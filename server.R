library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)

prefcode <- read.csv("prefcode.csv", stringsAsFactors = FALSE)$pref

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlotly({
    
    ggmapdata <- data.frame()
    for(i in 1:length(input$pref)){
      temp <- read.csv(paste0("mapdata_",which(prefcode==input$pref[i]),".csv"), 
                       colClasses=c(rep("numeric",3),"logical","factor","character",rep("factor",3)))
      ggmapdata <- rbind(ggmapdata, temp)
    }
    ggmapdata$name <- gsub("能","〓",ggmapdata$name)
    ggmapdata$name <- gsub("十","〓",ggmapdata$name)
    ggmapdata$name <- gsub("表","〓",ggmapdata$name)
    
    ggmapplot <- ggplot(ggmapdata, aes(x=long, y=lat, group=group, fill=id, text=name))+geom_polygon()
    ggmapplot
    
  })
  
})
