#
# SHINY UI
# ***********************************************
# Define user interface for application
ui <- navbarPage(
  
  # Title on NavBar Header
  title = "ShinyTreemaps",
  
  # Use one of different shiny themes
  theme = shinytheme("cerulean"),
  #shinythemes::themeSelector(),
  
  tabPanel("App",
    
    # Sidebar
    sidebarLayout(
      
      # HERE COME ALL CONTROLS FOR THE SIDEBAR PANEL
      sidebarPanel(width = 4,
        
        # SELECT DATA
        # -------------------
        # select data file
        h4("DATA OPTIONS"),
        
        fluidRow(
          column(width = 6,
            fileInput("UserDataInput",
              "Upload data", accept = c(".csv", ".tsv", ".txt"))
          ),
          column(width = 6,
            uiOutput("DataChoice")
          )
        ),
        
        fluidRow(
          column(width = 6, 
            uiOutput("DataVars")
          ),
          column(width = 6, 
            br(), uiOutput("treemap_status")
          )
        ),
        
        fluidRow(
          column(width = 3, 
            selectInput("UserFun",
              "Aggregate by", choices = c("sum", "mean", "min", "max"), 
              selected = "sum")
          ),
          column(width = 3, 
            uiOutput("CellSize")
          ),
          column(width = 3, 
            selectInput("UserShape",
              "Shape", choices = c("rectangle", "rounded_rect", "circle", "hexagon"), 
              selected = "rectangle")
          ),
          column(width = 3, 
            selectInput("UserIterations",
              "Iterations", choices = c(10, 50, 100, 200, 300), 
              selected = 100)
          )
        ),
        
        fluidRow(
          column(width = 3, 
            selectInput("UserErrorTol",
              "Error tolerance", choices = c(0.1, 0.05, 0.01, 0.005, 0.001), 
              selected = 0.01)
          ),
          column(width = 3, 
            textInput("UserSeed", "Seed", value = "none")
          ),
          column(width = 3, 
            selectInput("UserPositioning",
              "Positioning", choices = c("random", "regular", "clustered",
                "regular_by_area", "clustered_by_area"), 
              selected = "regular")
          )
        ),
        
        # SELECT PLOT OPTIONS
        # -------------------
        
        br(),
        h4("PLOT OPTIONS"),
        fluidRow(
          column(width = 3, 
            selectInput("UserPrintHeight",
              "Plot height", choices = c(1:10*100), selected = 600)
          ),
          column(width = 3, 
            selectInput("UserPrintWidth",
              "Plot width", choices = c("auto", 1:10*100), selected = 600)
          ),
          column(width = 3, 
            selectInput("UserLegend",
              "Legend", choices = c(TRUE, FALSE), selected = TRUE)
          ),
          column(width = 3, 
            selectInput("UserColorType",
              "Coloring", choices = c("categorical", "cell_size"), selected = "categorical")
          )
        ),
        
        fluidRow(
          column(width = 3, 
            selectInput("UserColorPalette",
              "Palette", choices = c("rainbow", "hawaii", "sunset", "batlow", 
              "terrain", "dark_mint", "viridis", "plasma", "purple_yellow", 
              "yellow_green", "yellow_red", "pink_yellow"), selected = "rainbow")
          ),
          column(width = 3, 
             uiOutput("ColorLevel")
          ),
          column(width = 3,
            uiOutput("LabelLevel")
          ),
          column(width = 3,
            uiOutput("BorderLevel")
          ),
        ),
        
        fluidRow(
          column(width = 3,
            colorSelectorInput("UserLabelColor",
              "Label color", grey(1:10/10), selected = grey(0.9)
            )
          ),
          column(width = 3,
            colorSelectorInput("UserBorderColor",
              "Border color", grey(1:10/10), selected = grey(0.9)
            )
          ),
          column(width = 3,
            numericInput("UserLabelSize", 
              "Label size", 1, 0, 10)
          ),
          column(width = 3,
            numericInput("UserBorderSize", 
              "Border size", 6, 0, 20)
          )
        ),
        
        fluidRow(
          column(width = 3,
            actionButton("UserCreate", "Make Treemap!", class = "btn-success")
          ),
          column(width = 3,
            actionButton("UserClean", "Clear gallery", class = "btn-success")
          )
        )
      ),
      
      
      # MAIN PANEL WITH OUTPUT PLOTS
      # Each tab has individual Download buttons
      mainPanel(width = 8,
        column(width = 8,
          wellPanel(
            tabsetPanel(
              tabPanel(
                "VORONOI TREEMAP",
                uiOutput("voronoi.ui"),
                help_voronoi(),
                downloadButton("UserDownloadSvg", "SVG"),
                downloadButton("UserDownloadPng", "PNG"),
              )
            )
          )
        ),
        
        # SIDE PANEL WITH PLOT GALLERY
        column(width = 4,
          wellPanel(
            h4("GALLERY"),
            slickROutput("gallery", height = "30%")
          )
        )
      )
    )
  ),
  
  # THE ABOUT PAGE
  tabPanel("About", 
    # THE SAME OR A BIT EXTENDED HELP BOX AS IN SIDEBAR
    column(width = 6,
      helpbox(width = 12)
    )
  )

)