library(shiny)
library(leaflet)
library(tidyverse)
library(vroom)
library(shinycssloaders)
library(highcharter)
library(stringr)
library(xts)

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)