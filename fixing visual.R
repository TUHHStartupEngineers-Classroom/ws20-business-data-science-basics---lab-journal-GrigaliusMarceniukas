# Data visualisation 


#```{r}

#Goal: Map the time course of the cumulative Covid-19 cases! 
#Adding the cases for Europe is optional. You can choose your 
#own color theme, but don’t use the default one. Don’t forget 
#to scale the axis properly. The labels can be added with 
#geom_label() or with geom_label_repel() 
#(from the package ggrepel).



# Challenge 4----

#Covid data analysis


library(tidyverse)
library(vroom)
library(lubridate)
library(data.table)
library(tictoc)
library(ggplot2)
library(scales)


covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")




#{r include=FALSE}
covid_data_by_month_tbl <- covid_data_tbl %>% map_df(rev)%>%
  select(cases_weekly, countriesAndTerritories, dateRep) %>%
  filter(countriesAndTerritories %in% c("Germany",
                                        "United_Kingdom",
                                        "France",
                                        "Spain",
                                        "Lithuania",
                                        "United_States_of_America")) %>%
  mutate(date = dmy(dateRep)) %>% group_by(countriesAndTerritories ) %>%
  mutate(total_cases = cumsum(cases_weekly))# %>%
#ungroup() 

covid_data_by_month_tbl 

tbl <- covid_data_tbl %>% map_df(rev)%>%
  select(dateRep, countriesAndTerritories, cases_weekly) %>%
  filter(countriesAndTerritories %in% c("Germany",
                                        "United_Kingdom",
                                        "France",
                                        "Spain",
                                        "Lithuania",
                                        "United_States_of_America")) %>% 
  group_by( countriesAndTerritories ) %>% 
  mutate(total_cases = cumsum(cases_weekly))# %>% map_df(rev) 
tbl
tbl2 <- tbl[4]

tbl2  

#total <- merge(covid_data_by_month_tbl, tbl)

#total %>% group_by(countriesAndTerritories, date) %>% ungroup() 

#total


#Covid cases ----
#```
#Covid graph for few countries
#```{r}
#{r plot5, fig.width=15, fig.height=7, echo=FALSE}
covid_data_by_month_tbl%>%
  ggplot(aes(x = date, y = total_cases, color = countriesAndTerritories)) +
  #geom_line()+
  #facet_wrap(~ countriesAndTerritories, ncol = 3) +
  geom_smooth(method = "gam", se = FALSE) +
  #geom_point()+
  scale_color_manual(values=c("#000000", "#ff0016", "#3ea6d7", "#feff00", "#106a00", "#ff8e02"))+
  labs(title = "Confirmed covid cases worldwide",
       x = "Year 2020",
       y = "Cases")




#{r include=FALSE}


#Goal: Visualize the distribution of the mortality rate
#(deaths / population) with geom_map().

# World Map ----

world <- map_data("world")

covid_mortality_tbl <- covid_data_tbl %>% # map_df(rev)%>%
  mutate(across(countriesAndTerritories, str_replace_all, "_", " ")) %>%
  mutate(countriesAndTerritories = case_when(
    
    countriesAndTerritories == "United Kingdom" ~ "UK",
    countriesAndTerritories == "United States of America" ~ "USA",
    countriesAndTerritories == "Czechia" ~ "Czech Republic",
    TRUE ~ countriesAndTerritories
    
  ))%>%
  group_by(countriesAndTerritories, popData2019, deaths_weekly) %>%
  summarise(total_pop = max(popData2019))%>%
  mutate(total_death = sum(deaths_weekly))%>%
  mutate(mortality =  (total_death)/(popData2019))



#{r include=FALSE}

#class(covid_mortality_tbl)

setDT(covid_mortality_tbl)

#class(covid_mortality_tbl)
covid_mortality_tbl
covid_mortality_tbl %>% glimpse()

setDT(world)

world %>% glimpse()


#{r include=FALSE}
tic()
covid_map_tbl <- merge(x = world, y = covid_mortality_tbl, 
                       by.x = "region", by.y = "countriesAndTerritories",
                       all.x = TRUE, 
                       all.y = FALSE,
                       allow.cartesian=TRUE)

toc()

covid_map_tbl%>% glimpse()





#{r include=FALSE}
setkey(covid_map_tbl, "region")
key(covid_map_tbl)

setorderv(covid_map_tbl, c("mortality", "region", "long", "lat"), order = -1)


#```
#Covid map
#```{r}
#{r plot6, fig.width=15, fig.height=7, echo=FALSE}
covid_map_tbl%>%
  ggplot() +
  geom_map(aes(x = long, y = lat, map_id = region, fill = mortality),map = world) +
  scale_fill_continuous(labels = scales::percent, low   = "green", high  = "red")+
  
  labs(title = "Comfirmed covid deaths in relation to population size")
#```

