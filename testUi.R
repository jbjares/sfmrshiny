#ui.R
library(rCharts)
library(shiny)

options(rcharts.cdn = TRUE)
shinyUI(navbarPage("Test Dashboard",
                   tabPanel("Main", sidebarLayout(
                     sidebarPanel(
                       helpText("Text")
                     ),
                     mainPanel(      
                       #nothing here
                     )
                   )
                   ),               
                   navbarMenu("Menu",
                              tabPanel("Test Menu 1", sidebarLayout(
                                sidebarPanel(
                                  helpText("Test")
                                ),
                                mainPanel(
                                  showOutput("chart1", "highcharts")
                                  ,
                                  br(), br(), br(), 
                                  showOutput("chart2", "highcharts")
                                ))) ,
                              tabPanel("Test Menu 2",sidebarLayout(
                                sidebarPanel(
                                  helpText("Test")
                                ),
                                mainPanel(
                                  showOutput("chart2", "highcharts")
                                  ,
                                  br(), br(),
                                  showOutput("chart1", "highcharts")
                                )))
                   )))