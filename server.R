require("shiny")
library(leaflet)
library(tidyverse)
library(vroom)
library(shinycssloaders)
library(highcharter)
library(stringr)
library(xts)
library(RSQLite)
library(RPostgreSQL)
library(DBI)
library(yaml)

drv = dbDriver("PostgreSQL")

server_data <- yaml.load_file("./data/server.yaml")

con = dbConnect(
  RPostgres::Postgres(),
  dbname = server_data$database,
  host = server_data$host,
  port = server_data$port,
  user = server_data$user,
  password = server_data$password
)

options(digits = 2)

station_file <- './data/stations.geojson'
river_file <- './data/river.geojson'




query = "select * from discharge where station ='03-13'"
data = dbGetQuery(con, query)
data <- rapply(object = data, f = round, classes = "numeric", how = "replace", digits = 6) 
stations <-  rgdal::readOGR(station_file)
rivers <-  rgdal::readOGR(river_file)

shinyServer(function(input, output, session){
  
  
  reactive_objects=reactiveValues()
  reactive_objects$Station <- '03-18'
  # station <- reactive_objects$Station
  # df <- data[which(data$Station == station),]
  station <- reactive_objects$Station
  query = str_interp("SELECT * FROM discharge where station = '${station}';")
  df = dbGetQuery(con, query)
  
  df$Dischage <- as.numeric(df$dischage)
  reactive_objects$df <- rapply(object = df, f = round, classes = "numeric", how = "replace", digits = 6) 
  reactive_objects$df <- df
  reactive_objects$dfx = xts(df$Dischage, order.by=as.Date(df$Date))


  
  # df <- data[which(data$Station == "1201"),]
  # df <- rapply(object = df, f = round, classes = "numeric", how = "replace", digits = 6) 
  

  
  map = leaflet::createLeafletMap(session, 'map')
  
  session$onFlushed(once = T, function() {
    
    
    content <- paste(sep = "<br/>",
                     "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
                     "606 5th Ave. S",
                     "Seattle, WA 98138"
    )
    
    
    output$map <- leaflet::renderLeaflet({
      # buildMap(sites=prof_sites, plot_polys=TRUE, au_poly=lake_aus)
      leaflet() %>%
        addProviderTiles("Esri.WorldImagery") %>%
        setView(lng = 35, lat = 35, zoom = 6) %>%
        addMarkers(
          data = stations,
          # label = paste0(pond_point$Name),
          popup = paste0(
            "<b>Name: </b>"
            , stations$Name
            , "<br>"
            ,"<b>Station No: </b>"
            , stations$Station
            , "<br>"
            ,"<b>Elevation : </b>"
            , stations$Elevation ," m"
            , "<br>"
            ,"<b>Basin Area: </b>"
            , stations$Basin_Area , "m"
          ),
          # labelOptions = labelOptions(noHide = F),
          layerId = ~Station,
          clusterOptions = markerClusterOptions()) %>%
        setMaxBounds( lng1 = 25
                      , lat1 = 35
                      , lng2 = 45
                      , lat2 = 45
        ) %>%
        addPolylines(data=rivers,weight = 1,opacity = 0.5)
    })
    
    output$plot <- renderHighchart({
      
      
      
      highchart(type = "stock") %>% 
        hc_title(text = paste("Observed discharge at station : ",reactive_objects$station)) %>%
        hc_add_series(reactive_objects$dfx, yAxis = 0,name = "Observed") %>%
        hc_add_yAxis(nid = 1L, title = list(text = "Discharge m3/s"), relative = 4) %>%
        hc_xAxis(
          type = 'datetime') %>%
        hc_legend(enabled = TRUE) %>%
        hc_tooltip(
          crosshairs = TRUE,
          backgroundColor = "#F0F0F0",
          shared = TRUE, 
          borderWidth = 5
        )
    })
    
    
    output$table <- DT::renderDataTable({
      
      # station <- reactive_objects$Station
      # # df <- data[which(data$Station == station),]
      # query = str_interp("SELECT * FROM discharge where station = '${station}';")
      # df = dbGetQuery(con, query)
      # df$Dischage <- as.numeric(df$dischage)
      df <- reactive_objects$df 
      df <- select(df,"Date","Dischage")
      # row.names(df) <- NULL
      DT::datatable(df,  extensions = 'Buttons',options = list(dom = 'Blfrtip',
                                                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                               lengthMenu = list(c(10,25,50,-1),
                                                                                 c(10,25,50,"All"))))
    },
    options = 
      list(sPaginationType = "two_button")
    )
    
    output$pond_stat <- DT::renderDataTable({
    })
    
  })
  
  # observe({
  #   click <- input$map_marker_click
  #   if (is.null(click)){return()}
  #   p <- input$map_marker_click$id
  #   # siteid=site_click$id
  #   # reactive_objects$sel_mlid=siteid
  #   reactive_objects$Station=p
  #   print(reactive_objects$Station)
  # })
  
})

