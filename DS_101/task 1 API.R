# 1.0 LIBRARIES ----

library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing
library(httr)
library(RSQLite)



# get some date, make a tibble, print some of it 

resp <- GET("http://openlibrary.org/people/george08/lists/OL97L/seeds.json")

resp
#rawToChar(resp$content)



resp %>% 
  .$content %>% 
  rawToChar() %>% 
  fromJSON()

data_lst <- fromJSON("http://openlibrary.org/people/george08/lists/OL97L/seeds.json")
# Open the data by clicking on it in the environment or by running View()
#View(data_lst)

# the tibble ----
title<-data_lst%>%
  purrr::pluck("entries", "title")
work_count<-data_lst%>%
  purrr::pluck("entries", "work_count")
edition_count<-data_lst%>%
  purrr::pluck("entries", "edition_count")
ebook_count<-data_lst%>%
  purrr::pluck("entries", "ebook_count")

tibble(title ,work_count ,edition_count ,ebook_count)



