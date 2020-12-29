# 
# LOADING LIBRARIES
# ***********************************************
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)
library(dplyr)
library(colorspace)
library(SysbioTreemaps)


# LOADING EXTERNAL FUNCTIONS AND DATA
# ***********************************************
for (Rfile in list.files("R", full.names = TRUE)) {
  source(Rfile)
}