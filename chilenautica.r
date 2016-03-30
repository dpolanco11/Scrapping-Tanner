library(dplyr)
library(rvest)
library(ggmap)
library(leaflet)
library(RColorBrewer)
library(httr)

Date <- c(NULL)


setwd("C:/Users/dpolanco/Desktop")
url <- read_html("http://www.chilenautica.cl/ads/")

Tabla <- html_nodes(url, "a")
Tabla <- as.character(Tabla)
Tabla <- Tabla[substr(Tabla,1,40) == '<a href=\"http://www.chilenautica.cl/ads/']

Link <- paste("http://www.chilenautica.cl/ads/" ,sub('.*?<a href=\"http://www.chilenautica.cl/ads/(.*?)/.*', "\\1", Tabla), sep="")
x <-seq(from=1, to=length(Link), by=2)
Link <- Link[x]

Modelo <- sub('.*?<a href=\"http://www.chilenautica.cl/ads/(.*?)/.*', "\\1", Tabla)
Modelo <- Modelo[x]

Tabla <- html_nodes(url, "p")
Tabla <- as.character(Tabla)
Tabla <- Tabla[substr(Tabla,1,21) == '<p class=\"post-meta\">']

Nombre <- sub('.*?<a href=\"http://www.chilenautica.cl/author/(.*?)/.*', "\\1", Tabla)

Date[1:length(Link)] <- date()

Base <- cbind(Link,Modelo,Nombre,Date)


#################################### Detalle ###################################

Telefono <- c(NULL)
Precio <- c(NULL)

for (i in 1:length(Link)){
  
  url_d <- read_html(Link[i])
  Tabla_d <- html_nodes(url_d,"p")
  Tabla_d <- as.character(Tabla_d)
  Tabla_d <- Tabla_d[substr(Tabla_d,1,20) == '<p class="post-price']
  
  Precio[i] <- sub(".*?<p class=\"post-price\">(.*?)</p>.*", "\\1", Tabla_d)
  
  Tabla_d <- html_nodes(url_d,"li")
  Tabla_d <- as.character(Tabla_d)
Tabla_d <- Tabla_d[substr(Tabla_d,1,19) == '<li id=\"cp_telefono']
  
 Telefono[i] <- sub(".*?</span>(.*?)</li>.*", "\\1", Tabla_d)

  if(nchar(Telefono[i]) > 20) Telefono[i] = "No Disponible"
  
  
  i=i+1
  
}

Base <- cbind(Precio, Base, Telefono)

write.table(Base, file="chilenautica.csv", append = TRUE, sep = ";", col.names = FALSE)



