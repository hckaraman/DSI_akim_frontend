library(shiny)
library(leaflet)
library(tidyverse)
library(vroom)
library(shinycssloaders)
library(highcharter)
library(stringr)
library(xts)


fluidPage(
navbarPage(
  
  "Face Tech", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js"),
                          tags$head(includeHTML(("analytics.html"))),
                        ),
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        # absolutePanel(
                        #   id = "controls",
                        #   class = "panel panel-default",
                        #   fixed = TRUE,
                        #   draggable = TRUE,
                        #   top = 80,
                        #   left = "auto",
                        #   right = 20,
                        #   bottom = "auto",
                        #   width = "25vw",
                        #   height = "50vh",
                        #   style = "background-color: white;
                        #  opacity: 0.85;
                        #  padding: 20px 20px 20px 20px;
                        #  margin: auto;
                        #  border-radius: 5pt;
                        #  box-shadow: 0pt 0pt 6pt 0px rgba(61,59,61,0.48);
                        #  padding-bottom: 2mm;
                        #  padding-top: 1mm;",
                        #   
                        #   fluidRow(style='height:100%',
                        # 
                        #   h2("DSI Flow Data"),
                        #   
                        #   # selectInput("roi", "Region of Interest", vars),
                        #   tabsetPanel(id = "plot_tabs",style='height:100%',
                        #               
                        #               tabPanel("plot",
                        #                        fluidRow(
                        #                          column(12, h4(""),
                        #                                 withSpinner(
                        #                                   highchartOutput(outputId = "plot")
                        #                                 ), )
                        #                        )),
                        #               tabPanel("Table",
                        #                        fluidRow(
                        #                          column(12,
                        #                                 withSpinner(
                        #                                   DT::dataTableOutput(outputId = "table")
                        #                                 ), )
                        #                        ))))
                        # ), 
                        
                        tags$div(id="cite",
                                 'Face Tech'
                        )
                    )
           ),
           
           # tabPanel("Data explorer",
           #          shinycssloaders::withSpinner(DT::dataTableOutput("pond_stat", height="600px"),size=2, color="#0080b7")
           # ),
           # 
           conditionalPanel("false", icon("crosshair"))
))
