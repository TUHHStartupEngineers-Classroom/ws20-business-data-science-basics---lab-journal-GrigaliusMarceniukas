# Data Visualization
#{r, include=FALSE}
library(tidyverse)
library(vroom)
library(tictoc)
library(data.table)
library(ggplot2)
library(scales)
library(lubridate)
library(maps)

## Challenge : Cumulative Covid Plot
### Import Covid Data
#{r}
covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")

### Simplified covid_data_tbl 
#{r}
covid_data_simplified <- covid_data_tbl %>%
  select(dateRep, cases_weekly, countriesAndTerritories)

### Filter with countries & month
#{r}
covid_data_countries_month <- covid_data_simplified %>%
  filter(countriesAndTerritories %in% c("Germany", 
                                        "United_Kingdom",
                                        "France",
                                        "Spain",
                                        "United_States_of_America")) %>%
  mutate(date = lubridate::dmy(dateRep)) %>%
  group_by(countriesAndTerritories, date) %>%
  summarize(cumulative_cases = cumsum(cases_weekly)) %>%
  ungroup()

### Plot the Cumulative Cases in year 2020 
#{r}
covid_data_countries_month %>%
  ggplot()+
  geom_line(aes(x = date, y = cumulative_cases, color = countriesAndTerritories))+
  labs(title = " Covid-19 confirmed cases worldwide",
       x = "Year 2020",
       y = "Cumulative Cases"
  )

### Challenge : Visualize distribution of mortality rate
#{r}
world <- map_data("world")

covid_by_mortality_tbl <- covid_data_tbl %>%
  mutate(across(countriesAndTerritories, str_replace_all, "_", " ")) %>%
  mutate(countriesAndTerritories = case_when(
    
    countriesAndTerritories == "United Kingdom" ~ "UK",
    countriesAndTerritories == "United States of America" ~ "USA",
    countriesAndTerritories == "Czechia" ~ "Czech Republic",
    TRUE ~ countriesAndTerritories
    
  ))%>%
  group_by(countriesAndTerritories, popData2019, deaths) %>%
  summarise(total_pop = max(popData2019))%>%
  summarise(total_death = sum(deaths))%>%
  summarise(mortality =  (total_death)/(popData2019))

class(covid_by_mortality_tbl)
setDT(covid_by_mortality_tbl)
class(covid_by_mortality_tbl)
covid_by_mortality_tbl %>% glimpse()
setDT(world)
world %>% glimpse()

tic()
covid_by_map_tbl <- merge(x = world, y = covid_by_mortality_tbl, 
                          by.x = "region", by.y = "countriesAndTerritories",
                          all.x = TRUE, 
                          all.y = FALSE)

toc()
covid_by_map_tbl%>% glimpse()

setkey(covid_by_map_tbl, "region")
key(covid_by_map_tbl)

setorderv(covid_by_map_tbl, c("mortality", "region", "long", "lat"), order = -1)

covid_by_map_tbl%>%
  ggplot() +
  geom_map(aes(x = long, y = lat, map_id = region, fill = mortality),map = world) +
  scale_fill_continuous(labels = scales::percent)+
  labs(title = "Confirmed Covid19 deaths relative to size of the population ",
       subtitle = "More than 1.2 Million confirmed covid19 deaths worldwide")
