library(kokudosuuchi)
library(magrittr)
library(maptools)
library(ggplot2)
library(rgdal)
library(rgeos)
library(sp)
library(plotly)

for(i in 15:47){
  mapdata <- getKSJData(paste0("http://nlftp.mlit.go.jp//ksj/gml/data/N03/N03-17/N03-170101_",i,"_GML.zip"))
  mapdata <- mapdata[[1]]
  shiku <- ifelse(!is.na(mapdata$N03_003)&!is.na(mapdata$N03_004),
                  paste0(mapdata$N03_003,mapdata$N03_004),
                  ifelse(!is.na(mapdata$N03_003),as.character(mapdata$N03_003),as.character(mapdata$N03_004)))
  shiku <- factor(shiku, unique(shiku))
  mapdata[[6]] <- shiku
  ken <- as.character(unique(mapdata$N03_001))
  
  ggmapdata1 <- fortify(mapdata, region="N03_007")
  ggmapdata2 <- fortify(mapdata, region="V6")$id
  ggmapdata2 <- factor(ggmapdata2, unique(shiku))
  ggmapdata2 <- ggmapdata2[order(ggmapdata2)]
  ggmapdata2 <- ggmapdata2[ggmapdata2!="所属未定地"]
  ggmapdata3 <- data.frame("pref"=rep(ken,nrow(ggmapdata1)))
  ggmapdata <- cbind(ggmapdata1,ggmapdata3,"name"=ggmapdata2)
  
  write.csv(ggmapdata, paste0("mapdata_",i,".csv"), row.names = FALSE)
}

ggmapdata <- read.csv("mapdata_14.csv", colClasses=c(rep("numeric",3),"logical","factor","character",rep("factor",3)))

ggmapplot <- ggplot(ggmapdata, aes(x=long, y=lat, group=group, fill=id, text=name))+geom_polygon()
ggmapplotly <- ggplotly(ggmapplot)
