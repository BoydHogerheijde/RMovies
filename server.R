library("dplyr")
library("plotly")

source("imdb.R")

# Server logic.
server <- function(input, output) {
  
  # Reactive block containing filter logic.
  movies <- reactive({
    
    # Variables containing filter values.
    min_rating <- input$rating
    min_year <- input$year[1]
    max_year <- input$year[2]
    min_duration <- input$duration
    
    # Actual filtering of the imdb dataframe, assigned into a filtered dataframe.
    filtered <- imdb %>%
      filter(rating >= min_rating,
             year >= min_year,
             year <= max_year,
             duration >= min_duration) %>%
      arrange(desc(rating))
    
    # Filter based on selected genre. 'All' is used as a default value, it doesn't need filtering when 'All' is selected.
    if (input$genre != "All") {
      selected_genre <- input$genre
      filtered <- filtered %>% filter(genre == selected_genre)
    }
    
    filtered
  })
  
  average_rating_per_year <- reactive({
    aggregate(movies()[, "rating"], list(movies()$year), mean)
  })
  
  # Render plots with plot.ly lib
  output$plot <- renderPlotly(
    plot <- plot_ly(
      movies(), # Input dataframe.
      x = ~year, # X axis.
      y = ~rating, # Y axis.
      type = "scatter", # Type of plot, this is a 'scatter' plot.
      mode = "markers", # Selected mode, 'markers' is the selected mode.
      color = ~genre, # Colored legend based on the distinct valus of the 'genre' column.
      text = ~title # Hover text includes the movie title.
    )
  )
  
  output$plot1 <- renderPlotly(
    plot <- plot_ly(
      average_rating_per_year(), # Input dataframe.
      x = ~Group.1, # X axis.
      y = ~x, # Y axis.
      type = "bar" # Type of plot, this is a 'bar' plot.
    ) %>%
      layout(
        xaxis = list(title = "year"),
        yaxis = list(title = "average rating")
      )
  )
  
  output$table <- renderDataTable(movies())
  
  output$number_of_movies <- renderText({
    nrow(movies())
  })
}