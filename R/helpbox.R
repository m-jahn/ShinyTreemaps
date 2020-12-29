helpbox <- function(width = 6) {
  column(width = width, 
    h4('INFO & HELP'),
    wellPanel(
      h4('HOW TO'),
      p('Added soon'),
      h4('DATA AND REFERENCES'),
      p('Added soon.'),
      p('The source code for this R shiny app is available on ', 
        a(href = 'https://github.com/m-jahn/ShinyTreemaps', target = '_blank', 'github/m-jahn/ShinyTreemaps')
      ),
      h4('CONTACT'),
      p('For questions or reporting issues, contact 
        Michael Jahn, Science For Life Lab - Royal Technical University (KTH), Stockholm'), 
      p(
        a(href ='mailto:michael.jahn@scilifelab.se', target = '_blank', 'email: Michael Jahn')
      )
    )
  )
}

help_voronoi <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('Added soon')
    )
  )
}