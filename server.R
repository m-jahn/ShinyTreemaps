# 
# SHINY SERVER
# ***********************************************
server <- function(input, output) {
  
  # MAIN DATA IS LOADED
  # reactive environments make sure that data is loaded when
  # input vars change
  
  # variable that holds the input data frames
  datalist <- reactiveValues(
    mtcars = mtcars,
    starwars = starwars,
    airquality = airquality
  )
  
  # function that adds new data from input button
  observeEvent(input$UserDataInput, {
    file <- input$UserDataInput
    ext <- tools::file_ext(file$datapath)
    req(file)
    datalist[[file$name]] <- read.csv(file$datapath)
  })
  
  # button for user selection of data
  output$DataChoice <- renderUI({
    selectInput("UserDataChoice",
      "Choose data:", names(datalist),
      selected = names(datalist)[1])
  })
  
  # assignment of the chosen data frame to main data slot
  data <- reactive({
    datalist[[input$UserDataChoice]]
  })
  
  output$DataVars <- renderUI({
    req(input$UserDataChoice)
    selectInput("UserDataVars",
      "Variables:", colnames(data()),
      selected = colnames(data())[1], 
      multiple = TRUE)
  })
  
  output$CellSize <- renderUI({
    req(input$UserDataChoice)
    selectInput("UserCellSize",
      "Cell size:", c("none", colnames(data())),
      selected = "none")
  })
  
  # SVG download handler
  output$UserDownloadSvg <- downloadHandler(
    filename = "treemap.svg",
    content = function(file) {
      svg(file, 
        width = {if (input$UserPrintWidth == "auto") 7
          else as.numeric(input$UserPrintWidth)/100}, 
        height = as.numeric(input$UserPrintHeight)/100)
      plot_treemap(tm = tm(), input = input)
      dev.off()
    },
    contentType = "image/svg"
  )
  
  # PNG download handler
  output$UserDownloadPng <- downloadHandler(
    filename = "treemap.png",
    content = function(file) {
      png(file, res = 140,
        width = {if (input$UserPrintWidth == "auto") 1400
          else 2*as.numeric(input$UserPrintWidth)}, 
        height = 2*as.numeric(input$UserPrintHeight))
      plot_treemap(tm = tm(), input = input)
      dev.off()
    },
    contentType = "image/png"
  )
  
  # DYNAMIC CONTROLS
  # ***********************************************
  #
  # display status for selected variables
  output$treemap_status <- renderText(
    if (is.null(input$UserDataVars)) {
      "<b>REQUIRED:</b> Select variables to generate treemap!"
    } else {
      paste0(length(input$UserDataVars), " variables selected with ",
        sum(apply(data()[input$UserDataVars], 2, function(x) length(unique(x)))),
        " unique values."
      )
    }
  )
  
  # reactive UIs for different graphical parameters
  output$ColorLevel <- renderUI({
    req(input$UserDataVars)
    selectInput("UserColorLevel",
      "Color level", seq_along(input$UserDataVars),
      selected = 1)
  })
  
  output$LabelLevel <- renderUI({
    req(input$UserDataVars)
    selectInput("UserLabelLevel",
      "Label level", seq_along(input$UserDataVars),
      selected = 1)
  })
    
  output$BorderLevel <- renderUI({
    req(input$UserDataVars)
    selectInput("UserBorderLevel",
      "Border level", c("all", seq_along(input$UserDataVars)),
      selected = "all")
  })
  
  palettes <- reactiveValues(
    rainbow = rainbow_hcl(n = 7, start = 60),
    hawaii = sequential_hcl(n = 7, h = c(-30, 200), c = c(70, 75, 35), l = c(30, 92), power = c(0.3, 1)),
    sunset = sequential_hcl(n = 7, h = c(-80, 78), c = c(60, 75, 55), l = c(40, 91), power = c(0.8, 1)),
    batlow = sequential_hcl(n = 7, h = c(270, -40), c = c(35, 75, 35), l = c(12, 88), power = c(0.6, 1.1)),
    terrain = sequential_hcl(n = 7, h = c(130, 30), c = c(65, NA, 0), l = c(45, 90), power = c(0.5, 1.5)),
    dark_mint = sequential_hcl(n = 7, h = c(240, 130), c = c(30, NA, 33), l = c(25, 95), power = c(1, NA)),
    viridis = sequential_hcl(n = 7, h = c(300, 75), c = c(40, NA, 95), l = c(15, 90), power = c(1, 1.1)),
    plasma = sequential_hcl(n = 7, h = c(-100, 100), c = c(60, NA, 100), l = c(15, 95), power = c(2, 0.9)),
    purple_yellow = sequential_hcl(n = 7, h = c(320, 80), c = c(60, 65, 20), l = c(30, 95), power = c(0.7, 1.3)),
    yellow_green = sequential_hcl(n = 7, h = c(270, 90), c = c(40, 90, 25), l = c(15, 99), power = c(2, 1.5)),
    yellow_red = sequential_hcl(n = 7, h = c(5, 85), c = c(75, 100, 40), l = c(25, 99), power = c(1.6, 1.3)),
    pink_yellow = sequential_hcl(n = 7, h = c(-4, 80), c = c(100, NA, 47), l = c(55, 96), power = c(1, NA))
  )
  
  # RENDERING TREEMAP
  # ***********************************************
  
  # To control size of the plots, we need to wrap plots
  # into additional renderUI function that can take height/width argument
  output$voronoi.ui <- renderUI({
    plotOutput("voronoi", height = input$UserPrintHeight, width = input$UserPrintWidth)
  })
  
  # reactive generation of treemap
  tm <- eventReactive(input$UserCreate, {
    
    # keep only selected columns from df (including cell_size col)
    if (input$UserCellSize == "none") {
      cell_size <- NULL
      df <- data()[input$UserDataVars]
    } else {
      cell_size <- input$UserCellSize
      df <- data()[c(input$UserDataVars, cell_size)]
    }
    
    # reshape seed parameter
    if (input$UserSeed == "none") {
      seed_input <- NULL
    } else {
      seed_input <- as.numeric(input$UserSeed)
    }
    
    # generate treemap
    tm <- withProgress(
      voronoiTreemap(
        data = na.omit(df),
        levels = input$UserDataVars,
        fun = get(input$UserFun),
        cell_size = cell_size,
        shape = input$UserShape,
        maxIteration = input$UserIterations,
        error_tol = input$UserErrorTol,
        seed = seed_input,
        positioning = input$UserPositioning
      ),
      message = "computing treemap"
    )
    
    # add file name for new treemap to reactive list
    plot_counter$count <- plot_counter$count + 1
    plotname <- paste0("plot_", plot_counter$count)
    filename <- paste0("www/treemap_",
      formatC(plot_counter$count, digits = 2, flag = "0"), ".png")
    plot_list[[plotname]] <- filename
    
    # return treemap
    tm
  })
  
  # plotting of treemap
  plot_treemap <- function(tm, input) {
    # coerce border level input to numeric
    if (input$UserBorderLevel == "all") {
      border_level <- seq_along(tm@call$levels)
    } else {
      border_level <- as.numeric(input$UserBorderLevel)
    }
    
    # draw treemap
    drawTreemap(tm,
      color_type = input$UserColorType,
      color_level = as.numeric(input$UserColorLevel),
      color_palette = palettes[[input$UserColorPalette]],
      border_level = border_level,
      border_size = input$UserBorderSize,
      border_color = input$UserBorderColor,
      label_level = as.numeric(input$UserLabelLevel),
      label_size = input$UserLabelSize,
      label_color = input$UserLabelColor,
      legend = input$UserLegend,
    )
  }
  
  # rendering of treemap
  output$voronoi <- renderPlot({
    
    # draw placeholder for initial start up
    if (is.null(input$UserBorderLevel) | input$UserCreate == 0) {
      drawTreemap(
        example,
        color_palette = rainbow_hcl(n = 7, start = 60),
        color_type = "both",
        border_color = grey(0.1),
        border_size = 7,
        label_color = grey(0.1),
        label_size = 4)
      grid::grid.text("EXAMPLE", gp = grid::gpar(cex = 7, col = "white"))
    
    } else {
      # plot treemap
      plot_treemap(tm(), input = input)
      
      # also save treemap to disk
      fn <- plot_list[[paste0("plot_", plot_counter$count)]]
      if (!is.null(fn)) {
      png(filename = fn, res = 140,
        width = {if (input$UserPrintWidth == "auto") 1400
          else 2*as.numeric(input$UserPrintWidth)}, 
        height = 2*as.numeric(input$UserPrintHeight))
      plot_treemap(tm(), input = input)
      dev.off()
      }
    }
  })
  
  
  # GALLERY WIDGET
  # ***********************************************
  # keep track of treemaps with a reactive list
  plot_counter <- reactiveValues(count = 0)
  plot_list <- reactiveValues()
  
  # rendering of gallery
  output$gallery <- renderSlickR({
    # reload widget whenever graphical options change but not otherwise
    req(reactiveValuesToList(plot_list), 
      input$UserPrintWidth, input$UserPrintHeight,
      input$UserLegend, input$UserColorType, input$UserColorPalette,
      input$UserLabelColor, input$UserBorderColor, input$UserLabelSize,
      input$UserBorderSize, input$UserColorLevel, input$UserLabelLevel,
      input$UserBorderLevel)
    # display saved images
    imgs <- list.files("www", pattern = "[0-9].png", full.names = TRUE)
    slickR(imgs, objLinks = NULL, slideType = "img", height = "300px") + 
      settings(slidesPerRow = 1, rows = 3, vertical = TRUE)
  })
  
  # function to clean plots from gallery and locally
  observeEvent(input$UserClean, {
    file.remove(list.files("www", pattern = "[0-9].png", full.names = TRUE))
    for (n in names(reactiveValuesToList(plot_list))) {
      plot_list[[n]] <- NULL
    }
    plot_counter$count <- 0
  })
  
}