# libraries ----

library(tidyverse)
library(readxl)
library(RSQLite)
library(glue)
library(jsonlite)
# example 1 ----
url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
# use that URL to scrape the S&P 500 table using rvest
library(rvest)
sp_500 <- url %>%
  # read the HTML from the webpage
  read_html() %>%
  # Get the nodes with the id
  html_nodes(css = "#constituents") %>%
  # html_nodes(xpath = "//*[@id='constituents']"") %>% 
  # Extract the table and turn the list into a tibble
  html_table() %>% 
  .[[1]] %>% 
  as_tibble()

sp_500
# example 2 ----
# html----
url  <- "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
html <- url %>% 
  read_html()

html
# rank ----
rank <-  html %>% 
  html_nodes(css = ".titleColumn") %>% 
  html_text() %>% 
  # Extrag all digits between " " and ".\n" The "\" have to be escaped
  # You can use Look ahead "<=" and Look behind "?=" for this
  stringr::str_extract("(?<= )[0-9]*(?=\\.\\n)")%>% 
  # Make all values numeric
  as.numeric()

rank
# title ----

title <- html %>% 
  html_nodes(".titleColumn > a") %>% 
  html_text()

title 
# year ----

year <- html %>% 
  html_nodes(".titleColumn .secondaryInfo") %>%
  html_text() %>% 
  # Extract numbers
  stringr::str_extract(pattern = "[0-9]+") %>% 
  as.numeric()

year

# people ----

people <- html %>% 
  html_nodes(".titleColumn > a") %>% 
  html_attr("title")

people

# rating ----

rating <- html %>% 
  html_nodes(css = ".imdbRating > strong") %>% 
  html_text() %>% 
  as.numeric()

rating

# num_ratings ----

num_ratings <- html %>% 
  html_nodes(css = ".imdbRating > strong") %>% 
  html_attr('title') %>% 
  # Extract the numbers and remove the comma to make it numeric values
  stringr::str_extract("(?<=based on ).*(?=\ user ratings)" )# %>% 
 # stringr::str_replace_all(pattern = ",", replacement = "") %>% 
#  as.numeric()

num_ratings

# full thing imb ----

imdb_tbl <- tibble(rank, title, year, people, rating, num_ratings)

imdb_tbl

# loops ----

for (variable in vector) {
  
}
# Example: For Loop
numbers <- c(1:5)
for (i in numbers) {
  print(i)
}

numbers_list <- map(numbers, print)




# json something ----

bike_data_lst <- fromJSON("bike_data.json")
# Open the data by clicking on it in the environment or by running View()
View(bike_data_lst)

#productDetail --> variationAttributes --> values --> [[1]] --> displayValue
