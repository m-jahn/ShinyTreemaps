helpbox <- function(width = 12) {
  column(width = width, 
    h4('INFO & HELP'),
    wellPanel(
      h4('HOW TO'),
      
      h5('Input data options'),
      
      tags$ul(
        tags$li('Upload data: Input data should be .csv tables with one column for each hierarchical level'),
        tags$li('Variables: Column names to be used for treemap generation. The order of names must 
          correspond to the hierarchical levels, going from broad to fine'),
        tags$li('Aggregate by: The function to be used to aggregate cell sizes of parental cells'),
        tags$li('cell_size: The name of the column used to control cell size. 
          Can be any column with numerical data. 
          NA or values equal or less than zero are not allowed as the cell area needs to be positive.
          The values in this column are aggregated by the function specified by "Aggregated by".
          For the default, cell_size = NULL, cell area is simply computed by the number of members 
          for the respective cell (corresponding to rows in input data table)'),
        tags$li('shape: Set the initial shape of the treemap. Currently supported are the 
          keywords "rectangle", "rounded_rect", "circle" or "hexagon". In the WeightedTreemaps R package,
          the user can also supply a named list with coordinates for a custom polygon.'),
        tags$li('maxIteration: Force algorithm to stop at this number of iterations 
          for each parent cell. The algorithm usually converges to an acceptable
          solution fairly quickly, so it seems reasonable to restrict this number
          in order to save computation time. However, more iterations give higher
          accuracy.'),
        tags$li('error_tol: The allowed maximum error tolerance of a cell.
          The algorithm will stop when all cells have lower error than this value.
          It is calculated as the absolute difference of cell area to its target
          area. The default is 0.01 (or 1 %) of the total parental area. Note: this
          is is different from a relative per-cell error, where 1 % would be more
          strict.'),
        tags$li('seed: The default seed is NULL, which will lead to a new
          random sampling of cell coordinates for each tesselation. If you want
          a reproducible arrangement of cells, set seed to an arbitrary number.'),
        tags$li('positioning: Algorithm for positioning of starting
          coordinates of child cells in the parental cell using spsample();
          "random" for completely random positions, "regular" for cells aligned
          to a grid sorted from bottom to top by name, "clustered" with regular
          positions of cells but sorted by name from inside out. Two variants
          "regular_by_area" and "clustered_by_area" will work as their counterparts
          but will sort by cell target area instead of cell name.')
      ),
      h5('Graphical customization'),
      
      tags$ul(
        tags$li('Added soon.')
      ),
      
      p(''),
      
      h4('DATA AND REFERENCES'),
      
      p('The Voronoi tesselation is based on functions from Prof. Paul Murrell',
        a(href = 'https://www.stat.auckland.ac.nz/~paul/Reports/VoronoiTreemap/voronoiTreeMap.html',
          target = '_blank', 'https://www.stat.auckland.ac.nz/~paul/Reports/VoronoiTreemap/voronoiTreeMap.html'),
        '. A recursive wrapper around the main tesselation function was created and
        dozens of additional changes and helper fucntions implemented to improve
        the stability for generation of larger treemaps.'),
        
      p('For a similar but javascript based implementation of Voronoi treemaps wrapped
        in R, see David Leslie’s scripts at',
        a(href = 'https://github.com/dlesl/voronoi_treemap_rJava', target = '_blank',
          'https://github.com/dlesl/voronoi_treemap_rJava')
      ),
      
      p('A Javascript based R package lets you draw simple treemaps in your
        browser, however, this is not suitable for treemaps with many (as,
        hundreds of) cells. The package is available from CRAN or github:',
        a(href = 'https://github.com/uRosConf/voronoiTreemap', target = '_blank',
          'https://github.com/uRosConf/voronoiTreemap')
      ),
      
      p('Another popular resource is the web-based treemap generation from
        University of Greifswald at', 
        a(href = 'https://bionic-vis.biologie.uni-greifswald.de/', target = '_blank',
          'https://bionic-vis.biologie.uni-greifswald.de/')
      ),
      
      p('The source code for this R shiny app is available on ', 
        a(href = 'https://github.com/m-jahn/ShinyTreemaps', target = '_blank', 'github/m-jahn/ShinyTreemaps')
      ),
      
      h4('CONTACT'),
      p('For questions or reporting issues, contact 
        Michael Jahn, Max Planck Unit for the Science of Pathogens (MPUSP), Berlin, Germany'), 
      p(
        a(href ='mailto:jahn@mpusp.mpg.de', target = '_blank', 'email: Michael Jahn')
      )
    )
  )
}

help_voronoi <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('Select variables using the menu on the left side'),
      tags$li('Hit "Make treemap" to generate your map'),
      tags$li('Small maps with 100 cells take a few seconds, more cells take longer')
    )
  )
}