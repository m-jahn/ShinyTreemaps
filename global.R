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
library(SysbioTreemaps)


# LOADING EXTERNAL FUNCTIONS AND DATA
# ***********************************************
# load help files
for (Rfile in list.files("R", full.names = TRUE)) {
  source(Rfile)
}

# load example map
load("data/example.Rdata")