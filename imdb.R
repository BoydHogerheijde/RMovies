library("rvest")

# IMDB scraper

# List of links for each genre.
links <-
  c(
    "http://www.imdb.com/search/title?genres=sci_fi&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs",
    "http://www.imdb.com/search/title?genres=action&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs",
    "http://www.imdb.com/search/title?genres=animation&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs",
    "http://www.imdb.com/search/title?genres=comedy&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs",
    "http://www.imdb.com/search/title?genres=horror&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs",
    "http://www.imdb.com/search/title?genres=documentary&explore=genres&sort=boxoffice_gross_us,desc&ref_=adv_explore_rhs"
  )

genres <-
  c("Sci-Fi",
    "Action",
    "Animation",
    "Comedy",
    "Horror",
    "Documentary")

imdb <- data.frame()

# For each link, the page will be scraped. The data we're getting out of the page(for each movie) are: title, year, rating and duration.
for (i in 1:length(genres)) {
  page <- read_html(links[i])
  
  title <- page %>%
    html_nodes(".lister-list .lister-item-header a") %>%
    html_text()
  
  year <- page %>%
    html_nodes(".lister-list .lister-item-header .lister-item-year") %>%
    html_text() %>%
    substr(2, 5) %>%
    as.integer()
  
  rating <- page %>%
    html_nodes(".lister-list .ratings-bar strong") %>%
    html_text() %>%
    as.numeric()
  
  duration <- page %>%
    html_nodes(".lister-list .runtime") %>%
    html_text() %>%
    substr(1, 3) %>%
    trimws() %>%
    as.integer()
  
  genre <- genres[i]
  imdb <-rbind(imdb, data.frame(title, year, rating, duration, genre))
}

imdb