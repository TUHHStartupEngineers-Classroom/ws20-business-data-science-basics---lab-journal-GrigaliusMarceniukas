# 1.0 LIBRARIES ----

library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing
library(httr)
library(RSQLite)
library(ggplot2)
library(dplyr)
library(purrr)


# create small database: model names and price of 
#                        at least one category


#xopen(url_home) # Open links directly from RStudio to inspect them

url  <- "https://www.radon-bikes.de/en/trekking-cross/cross/bikegrid/"
html <- url %>% 
  read_html()

names <-  html %>% 
  html_nodes(css = ".a-heading.a-heading--small") %>% 
  html_text() %>% 
  stringr::str_extract("(?<= ).*(?=)")%>%
 # discard(.p = ~stringr::str_detect(.x,"to our Radon-Bikes Instagram!|#bisbaldimwald"))
  purrr::discard(names,.p = ~stringr::str_detect(.x,"to our Radon-Bikes Instagram!|#bisbaldimwald"))
names


price <-  html %>% 
  #html_nodes(css = ".m-bikegrid__price.currency_eur >span") %>% 
  html_nodes(css = ".m-bikegrid__price--active") %>% 
  html_text() %>% 
  #html_attr("class")%>%
  stringr::str_extract("(?<=).*(?=)") %>%
  #discard(.p = ~stringr::str_detect(.x," ₤"))%>%
  purrr::discard(names,.p = ~stringr::str_detect(.x," ₤"))%>%
  as_tibble()%>%
  filter(row_number() %% 2 == 1)

price


tibble(Model=names, "Cost  "=price)
