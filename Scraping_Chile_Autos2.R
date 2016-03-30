
library(dplyr)
library(rvest)
library(ggmap)
library(leaflet)
library(RColorBrewer)
library(httr)

url <- read_html("http://www2.chileautos.cl/cemagic.asp?region=0&ciudad=0&tipo=Todos&carroceria=&maresp=0&modelo=&combustible=0&kilom=&c_otros=&cili=0&cilf=0&vendedor=0&ai=1920&af=2016&pi=0&pf=1000000000&fecha_ini=&fecha_fin=&disp=1&dea=100&pag=1&boton=4")

Tabla <- html_nodes(url,"table")

Tabla <- Tabla[1]

Tabla <- as.character(Tabla)
Tabla1 <- unlist(strsplit(Tabla,"location",fixed=FALSE))
Tabla1 <- Tabla1[-1]

Id_Auto <- sub(".*?codauto=(.*?)'\">\n.*", "\\1", Tabla1)
Modelo <- sub(".*?ck=\"return false;\">(.*?)</a>\n.*", "\\1", Tabla1)
Año <- sub(".*?</td>\n    <td>(.*?)</td>\n.*", "\\1", Tabla1)
Precio <- sub(".*?\"center\">(.*?)</td>\n.*", "\\1", Tabla1)
Ciudad <- sub(".*?<td>(.*?)<div class=\".*", "\\1", Tabla1)
Ind_Fecha <- sub(".*?publicado  hace(.*?)</div></td>\n.*", "\\1", Tabla1)

Date <- date()

Base <- cbind(Id_Auto,Modelo,Año,Precio,Ciudad,Ind_Fecha,Date)

x <- Base[,1]

#######################################################################DETALLE#########################################################################################

y <- c(NULL,NULL, NULL)

for (i in 1:length(Id_Auto))
{
  url_d <- read_html(paste("http://www2.chileautos.cl/auto.asp?codauto=",Id_Auto[i],sep = ""))

  Tabla_d <- html_nodes(url_d,css = "body > div:nth-child(4) > div:nth-child(2) > div:nth-child(2) > table")

  Datos_Contacto <- html_text(Tabla_d)
  Nombre_Contacto <- html_text(Tabla_d)
  
  Nombre_Contacto <- sub(".*Vende:(.*?)Telefono.*","\\1", Datos_Contacto)

  Datos_Contacto <- sub(".*Telefono:(.*?)Ciudad.*","\\1", Datos_Contacto)
  Datos_Contacto <- sub("Correo:E-MailChileautos.clÂ® es una marca registrada", "",Datos_Contacto)
  Datos_Contacto <- sub("Ciudad", "",Datos_Contacto)
  Datos_Contacto <- sub("Vende:", "",Datos_Contacto)
  Datos_Contacto <- sub("Telefono", "",Datos_Contacto)
  Datos_Contacto <- sub("cel.:", "",Datos_Contacto)
  Datos_Contacto <- sub("fijo:", "",Datos_Contacto)
  Datos_Contacto <- sub("fijo", "",Datos_Contacto)
  Datos_Contacto <- sub("cel", "",Datos_Contacto)

  #if(nchar(Nombre_Contacto) > 100) Nombre_Contacto = NULL
    

  y1 <- c(x[i],Nombre_Contacto, Datos_Contacto)
  y <- rbind(y,y1)
  i = i+1
  
}

setwd("/Users/dpolanco/Desktop/")

definitivo <- cbind(Id_Auto, Modelo, Precio, Ind_Fecha, Año, Ciudad, Date, y)

write.table(definitivo, file="chileauto2.csv", append = TRUE, sep = ";", col.names = FALSE)

#dt <-read.table(file="chileautos.csv", header = TRUE, sep = ",")
#setkey(dt, "Id_Auto")
#unique(dt)

#write.table(definitivo, file="chileautosv2.csv", append = TRUE, sep = ";", col.names = FALSE)


### w <- read.table(file ="chileautos.csv" )

 