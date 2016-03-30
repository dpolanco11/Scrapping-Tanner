
library(dplyr)
library(rvest)
library(ggmap)
library(leaflet)
library(RColorBrewer)
library(httr)

Date <- c(NULL)
setwd("C:/Users/dpolanco/Desktop")
url <- read_html("http://m.yapo.cl/region_metropolitana/barcos_lanchas_aviones?ps=&pe=&q=&st=s&f=a&w=1&cg=2080&ca=15_s#16447437")

Tabla <- html_nodes(url, "li")
Tabla <- as.character(Tabla)
Tabla <- Tabla[26:75]

Id <- sub(".*?id=(.*?) href.*", "\\1", Tabla)
Id<-substr(Id,2,9)

Link <- sub(".*?href=\"(.*?)ca=.*", "\\1", Tabla) 
Precio <- sub(".*\"price\">(.*?)</p>.*", "\\1", Tabla)
Modelo <- sub(".*?\" title=\"(.*?)\".*", "\\1", Tabla)
Date[1:length(Id)] <- date()

Base <- cbind(Id, Link, Precio, Modelo, Date)

x <- Base[,1]

#################################### Detalle ###################################

Telefono <- c(NULL)
Nombre <- c(NULL)

for (i in 1:length(Id)) {
  
  url_d <- read_html(Link[i])
  Tabla_d <- html_nodes(url_d,"a")
  Tabla_d <- Tabla_d[length(Tabla_d)]
  Telefono[i] <- sub('.*?tel:(.*?)".*', "\\1", Tabla_d)
  
  if (nchar(Telefono[i]) > 15) Telefono[i] = "No Disponible"
  
  Tabla_d <- html_nodes(url_d,"h3")
  Tabla_d <- Tabla_d[2]
  Nombre[i] <- sub('.*?user-name">(.*?)</h3>.*', "\\1", Tabla_d)
  
  
    i=i+1
    
}

Base <- cbind(Base,Nombre, Telefono)

write.table(Base, file="yapo.csv", append = TRUE, sep = ";", col.names = FALSE)



