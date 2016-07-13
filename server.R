library(shiny)
library(ggplot2)
library(scales)
library(rCharts)
library(plyr)
load("data\\userInfo.rda")
load("data\\GAT.rda")
load("data\\GUS.rda")


userInfo.df$subscribe_time <- as.character(userInfo.df$subscribe_time)


shinyServer(function(input, output){
  
  datefun1 <- reactive({
    mindate1 <- as.POSIXct.Date(input$date1[1])
    maxdate1 <- as.POSIXct.Date(input$date1[2])
    subset(userInfo.df, subscribe_time > mindate1 & subscribe_time < maxdate1)
  })
  
  ##userInfo
  output$subscribe <- renderPlot({
    g1 <- ggplot(datefun1(), aes(x=subscribe_time, fill=..count..)) + 
      geom_bar() +
      labs(x="Subscribe Time", y="Count") +
      theme(axis.text.x = element_text(size = 7, angle = 45), axis.text.y = element_text(size = 13)) + 
      scale_fill_distiller(palette = "Spectral") +
      theme(legend.title=element_blank()) +
      theme(panel.background = element_rect(fill = "transparent",colour = NA), plot.background = element_rect(fill = "transparent",colour = NA), legend.background = element_rect(fill = "transparent", colour = NA))
    print(g1)
  })
  
  output$gender <- renderChart2({
    rchart2 <- nPlot(~ sex, data = datefun1(), type = "pieChart")
    rchart2
  })
  
  output$subscriber <- renderChart2({
    rchart3 <- nPlot(~ attention, data = datefun1(), type = "pieChart")
    rchart3$chart(donut = TRUE, color = c("orangered", "dodgerblue", "lawngreen", "gold", "purple", "cyan"))
    rchart3
  })
  
  
  tier.df <- ddply(userInfo.df, .(attention, tier), summarize, count=length(attention))
  names(tier.df) <- c("Attention", "Tier", "Count")
  output$tier <- renderChart({
    rchart1 <- nPlot(Count ~ Attention, group = "Tier", data = tier.df, type = "multiBarChart", dom = 'tier', width = 800)
    rchart1$chart(color = c("orangered", "dodgerblue", "lawngreen"))
    return(rchart1)
  })
  
  datefun2 <- reactive({
    mindate1 <- as.POSIXct.Date(input$date1[1])
    maxdate1 <- as.POSIXct.Date(input$date1[2])
    subset(GUS1, ref_date > mindate1 & ref_date < maxdate1)
  })
  
  
  GUS1 <- ddply(GUS, .(ref_date), summarize, new = sum(new_user), cancel = sum(cancel_user), increase = sum(increase_user))
  GUS1$acc_sum <- cumsum(GUS1$increase)
  GUS1 <- ddply(GUS1, .(ref_date), mutate, outflow = round(cancel/acc_sum*100, 2))
  GUS1 <- GUS1[, c("ref_date", "outflow")]
  GUS1$ref_date <- as.character(GUS1$ref_date)
  
  output$flow <- renderChart2({
    m1 <- mPlot(x = "ref_date", y = "outflow", data = datefun2(), type = "Line")
    m1$set(labels = "graph") 
    return(m1)
  })
  
  
  output$observationname <- renderText({
    paste("First", input$obs1, "Observation of the User Infomation")
  })
  
  output$view <- renderDataTable({
    head(userInfo.df, n = input$obs1)
  })
    
  
  ##Contents
  GAT1 <- ddply(GAT, .(ref_date, title), summarize, target = sum(details.target_user.5), read_user = sum(details.int_page_read_user.5), share_count = sum(details.share_count.5), fav_user = sum(details.add_to_fav_user.5))

  output$gat <- renderTable({
    head(GAT1, n = input$obs2)
  })
  
  
  
  
  
})
