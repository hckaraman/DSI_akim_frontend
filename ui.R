library(shiny)
library(leaflet)
library(tidyverse)
library(vroom)
library(shinycssloaders)
library(highcharter)
library(stringr)
library(xts)

shinyUI(fluidPage(
  tags$head(
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.contentWindow.min.js",
                type="text/javascript")
  ),
  
  # <a href="https://ibb.co/VwyDzNL"><img src="https://i.ibb.co/wcHCPLd/logo.png" alt="logo" border="0"></a>
  
  # Header
  headerPanel(
    title=tags$a(href='http://faceteknoloji.com.tr',tags$img(src='https://i.ibb.co/wcHCPLd/logo.png', height = 125, width = 100*2.85*1.75), target="_blank"),
    tags$head(tags$link(rel = "icon", type = "image/png", href = "dwq_logo_small.png"), windowTitle="Lake profile dashboard")
  ),
  
  #,
  
  # Input widgets
  fluidRow(
    column(7,
           tabsetPanel(id="ui_tab",
                       tabPanel("Map",
                                column(12,shinycssloaders::withSpinner(leaflet::leafletOutput("map", height="600px"),size=2, color="#0080b7"))
                       )
           ),
    ),
    column(5,tabsetPanel(id="plot_tabs",
                         
                         tabPanel("Plot",
                                  fluidRow(column(12,
                                                  shinycssloaders::withSpinner(
                                                    highchartOutput(outputId = "plot", height = "600px")
                                                  ),))),
                         tabPanel("Table",
                                  fluidRow(column(12,
                                                  shinycssloaders::withSpinner(
                                                    DT::dataTableOutput(outputId = "table", height = "600px")
                                                  ),)))
                         
                         
    )))))