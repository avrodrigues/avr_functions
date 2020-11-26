library(tmap)
library(here)
library(magrittr)
library(raster)
library(rgdal)
library(rnaturalearth)
library(sf)
library(shiny)
library(leaflet)



dir.shp <- here("shapefile", "Morrone 2014")
neo.tropics <- readOGR(dir.shp, "Lowenberg_Neto_2014")
evoregion <- readOGR(here("shapefile","Evoregions"), "Evoregion")


coast <- ne_countries(scale = "10")


# Neotropics --------------------------------------------------------------


bbox <- extent(c(-130,-30, -60, 35))
tm_shape(coast, bbox = bbox) +
  tm_polygons(col = "white", border.col = NULL) +
tm_shape(neo.tropics) +
  tm_polygons("Dominions", border.col = NULL) +
  tm_layout(title = "Região Neotropical",
            title.position = c("right", "top"),
            aes.palette = "Accent",
            bg.color = "lightblue",
            sepia.intensity = 0.4, 
            legend.position = c("left", "bottom"), 
            frame = T)


# Myrcia Evoregions -------------------------------------------------------


bbox <- extent(c(-130,-30, -60, 35))
tm_shape(coast, bbox = bbox) +
  tm_polygons(col = "white", border.col = NULL) +
  tm_shape(evoregion) +
  tm_polygons("Evoregion", border.col = NULL) +
  tm_layout(title = "Região Neotropical",
            title.position = c("right", "top"),
            aes.palette = "Accent",
            bg.color = "lightblue",
            sepia.intensity = 0.4, 
            legend.position = c("left", "bottom"), 
            frame = T)
