#' Richness map from occurrences records
#'
#' @param x data frame with species names, longitude and latitude
#' @param resolution grid cell size in decimal degrees
#' @param species a character string with the name for the species column
#' @param latitude a character string with the name for the latitude column
#' @param longitude a character string with the name for the longitude column
#' @param plot logical. Default = TRUE
#' @param raster logical. Should the function return a raster object?
#' 
#'
#' @export
map_rich_occ <- function(x,
                         resolution = 1,
                         species = "species",
                         latitude = "latitude",
                         longitude = "longitude",
                         color.palette = c("white","red"),
                         xlim = NULL,
                         ylim = NULL,
                         plot = TRUE,
                         raster = FALSE
                         ){



  # crie um raster
  r <- raster::raster(resolution = resolution, # 1 grau decimal
              ext = extent(c(-180,180,-90,90)))

  # cria uma lista de celulas do raster em que cada espécie ocorre
  species_data <- split(as.data.frame(x), x[,species])

  cells_occ <- list()
  for (i in seq_along(species_data)){
    cells_occ[[i]] <- unique(raster::cellFromXY(r, species_data[[i]][,c(longitude, latitude)]))
  }

  # Gera valores de riqueza para cada pixel do raster
  riq_cell <- table(unlist(cells_occ))

  values_cell <- rep(NA, ncell(r))
  names(values_cell) <- 1:ncell(r)
  valid_cells <- names(values_cell) %in% names(riq_cell)
  values_cell[valid_cells] <- riq_cell

  richness_raster <- raster::setValues(r, values = values_cell)


  lims <- c(xlim,ylim)
  if(is.null(lims)){
    lims <- extent(xyFromCell(r, as.numeric(names(riq_cell)), spatial=T))
  }


  # Mapa
  countries <- rnaturalearth::ne_countries() # paises
  pal <- grDevices::colorRampPalette(color.palette) # Paleta de cores do raster

  # gerando mapa
  if(plot == TRUE){
    plot(richness_raster,
         xlim = lims[1:2]+c(-1,1),
         ylim = lims[3:4]+c(-1,1), # limites longitude/latitude
         col = pal(50))
    plot(countries, add = T)
  }
  
  if(raster == TRUE){
    return(richness_raster)
  }

}
