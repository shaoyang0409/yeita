library(shiny)
library(rCharts)
load("data\\userInfo.rda")


shinyUI(navbarPage("Covestro", inverse = TRUE, 
                   tabPanel("User Info",
                            fluidPage(
                              titlePanel("User Information"),
                              fluidRow(
                                column(3,
                                       wellPanel(
                                           dateRangeInput("date1", "TimeRange:", start = "2016-01-29", end = "2016-02-29", min = "2016-01-29", max = "2016-06-30", format = "yyyy/mm/dd", separator = "-"),
                                           br(),
                                           sliderInput("obs1", "Observation:", min = 0, max = nrow(userInfo.df), value = 100),
                                           hr(),
                                           submitButton("Update!")
                                       )
                                ),
                                column(9,
                                       tabsetPanel(type = "pills",
                                                   tabPanel(title = "Subscribe", plotOutput("subscribe")),
                                                   tabPanel(title = "Gender", showOutput("gender", "nvd3"), showOutput("subscriber", "nvd3")),
                                                   tabPanel(title = "Tier", showOutput("tier", "nvd3")),
                                                   tabPanel(title = "FLow", showOutput("flow", "morris")),
                                                   tabPanel(title = "View", h4(textOutput("observationname")), dataTableOutput("view"))
                                                   )
                                )
                              )
                            )
                   ),
                   
                   tabPanel("Contents", 
                     fluidPage(
                       titlePanel("The Contents"),
                       fluidRow(
                           column(3,
                                  wellPanel(
                                    sliderInput("obs2", "Observation:", min = 0, max = 45, value = 45),
                                    hr(),
                                    submitButton("Update!")
                                  )
                           ),
                           column(9, tableOutput("gat"))
                       )
                     )
                   ),
                   
                   tabPanel("Read",
                     fluidPage(
                       titlePanel("Read"),
                       fluidRow(
                         column(3, 
                                wellPanel(
                                  dateRangeInput("date3", "TimeRange:", start = "2016-01-29", end = "2016-02-29", min = "2016-01-29", max = "2016-06-30", format = "yyyy/mm/dd", separator = "-"),
                                  br(),
                                  selectInput("mouth3", "Mouth Selected:", choice = c("Feb", "Mar", "Apr", "May", "Jun")),
                                  hr(),
                                  submitButton("Update!")
                                )
                         ),
                         column(9,
                                tabsetPanel(type = "pills",
                                            tabPanel("ReadingHabit"),
                                            tabPanel("ReadingSource"))
                         )
                       )
                     )
                   ),
                   
                   tabPanel("Share",
                            fluidPage(
                              titlePanel("Share"),
                              fluidRow(
                                column(3,
                                       wellPanel(
                                         selectInput("mouth4", "Mouth Selected", choice = c("Feb", "Mar", "Apr", "May", "Jun")),
                                         hr(),
                                         submitButton("Update!")
                                       )),
                                column(9)
                              )
                            )
                   )
))

