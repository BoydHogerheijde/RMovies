library("shiny")
library("plotly")

# UI.
ui <- fluidPage(
  
  # App title.
  titlePanel("RMovies", windowTitle = "RMovies - Movie db comparator"),
  
  sidebarLayout(
    
    # Sidebar with slider inputs for filtering on different criteria.
    sidebarPanel(
      h4("Filter"),
      sliderInput("year", "Year released", 1960,  2017, c(1980, 2017), step = 1),
      sliderInput("rating", "Rating(min. numeric rating)", 1, 10, 5.5, step = 0.1),
      sliderInput(
        "duration",
        "Duration(min. duration in minutes)",
        0,
        180,
        100,
        step = 1
      ),
      
      h4("Choose a genre"),
      selectInput("genre",
                  "Genre",
                  c("All",
                    genres),
                  selected = "All")
    ),
    
    # Mainpanel containing plots and data table in tabs.
    mainPanel(tabsetPanel(
      tabPanel("Movies", plotlyOutput("plot")),
      tabPanel("Average/year", plotlyOutput("plot1")),
      tabPanel("Table", dataTableOutput("table"))
    ),
    
    # Small panel at the bottom of the screen maintaining a count of movies used to produce the output graphs/tables.
    wellPanel(span(
      "Number of movies: ",
      textOutput("number_of_movies")
    )))
  )
)
