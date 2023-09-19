# 
# LOADING LIBRARIES
# ***********************************************
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)
library(dplyr)
library(colorspace)
library(slickR)
library(WeightedTreemaps)


# LOADING EXTERNAL FUNCTIONS AND DATA
# ***********************************************
# load help files
for (Rfile in list.files("R", full.names = TRUE)) {
  source(Rfile)
}

# generate one time example
# data(mtcars)
# mtcars$car_name = gsub(" ", "\n", row.names(mtcars))
# example <- voronoiTreemap(
#   data = mtcars,
#   levels = c("gear", "car_name"),
#   cell_size = "hp",
#   shape = "rectangle"
# )
# drawTreemap(example, label_size = 2)
# save(example, file = "data/example.Rdata")

# load example map
load("data/example.Rdata")
