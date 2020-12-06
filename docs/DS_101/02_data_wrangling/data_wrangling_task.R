# Libraries ----

# Tidyverse
library(tidyverse)
library(vroom)

# Data Table
library(data.table)

# Counter
library(tictoc)




library(vroom)







# first task ----



col_types_assignee <- list(
  id = col_character(),
  type = col_integer(),
  name_first= col_skip(),
  name_last = col_skip(),
  organization = col_character()
)

assignee_tbl <- vroom(
  file       = "assignee.tsv", 
  delim      = "\t", 
  col_types  = col_types_assignee,
  na         = c("", "NA", "NULL")
)

assignee_tbl

setDT(assignee_tbl)

assignee_tbl %>% glimpse()




          col_types_patent_assignee <- list(
            patent_id = col_character(),
            assignee_id = col_character(),
            location_id = col_skip()
          )
          
          patent_assignee_tbl <- vroom(
            file       = "patent_assignee.tsv", 
            delim      = "\t", 
            col_types  = col_types_patent_assignee,
            na         = c("", "NA", "NULL")
          )



patent_assignee_tbl

setDT(patent_assignee_tbl)

patent_assignee_tbl %>% glimpse()



tic()
patent_assignee_assignee_tbl <- merge(x = patent_assignee_tbl, y = assignee_tbl, 
                      by.x = "assignee_id", by.y = "id",
                      all.x = TRUE, 
                      all.y = TRUE)
toc()

patent_assignee_assignee_tbl %>% glimpse()

patent_assignee_assignee_tbl



setkey(patent_assignee_assignee_tbl, "type")
key(patent_assignee_assignee_tbl)

?setorder()
setorderv(patent_assignee_assignee_tbl, c("type", "organization"))


patent_assignee_assignee_tbl_us <- patent_assignee_assignee_tbl[ (type == 2)]

patent_assignee_assignee_tbl_us


tic()
most_patents_us <- patent_assignee_assignee_tbl_us[!is.na(organization), .N, by = organization]
toc()


setkey(most_patents_us, "organization")
key(most_patents_us)

setorderv(most_patents_us, c("N", "organization"), order = -1)



as_tibble(most_patents_us, .rows = 10)

#Patent Dominance: What US company / 
#corporation has the most patents? 
#List the 10 US companies with the 
#most assigned/granted patents.

# use data.table  or dplyr
# tables needed: assignee, patent_assignee

# second task ----



col_types_patent <- list(
  id = col_character(),
  date = col_date("%Y-%m-%d"),
  num_claims = col_integer(),
  type = col_skip(),
  number = col_skip(),
  country = col_skip(),
  abstract = col_skip(),
  kind = col_skip(),
  filename = col_skip(),
  withdrawn = col_skip(),
  title = col_skip()
)

patent_tbl <- vroom(
  file       = "patent.tsv", 
  delim      = "\t", 
  col_types  = col_types_patent,
  na         = c("", "NA", "NULL")
)


setDT(patent_tbl)

patent_tbl %>% glimpse()

tic()
patent_assignee_assignee_patent_tbl <- merge(x = patent_assignee_assignee_tbl, y = patent_tbl,
                      by.x = "patent_id", by.y = "id",
                      all.x = TRUE,
                      all.y = TRUE)

toc()

patent_assignee_assignee_patent_tbl %>% glimpse()


setkey(patent_assignee_assignee_patent_tbl, "type")
key(patent_assignee_assignee_patent_tbl)

?setorder()
setorderv(patent_assignee_assignee_patent_tbl, c("type", "organization"))


patent_assignee_assignee_patent_us2 <- patent_assignee_assignee_patent_tbl[ (type == '2') ]

patent_assignee_assignee_patent_year <- patent_assignee_assignee_patent_us2 %>%
  select(organization, num_claims, date) %>%
  mutate(year = year(date))


patent_assignee_assignee_patent_year



patent_assignee_assignee_patent_2019 <- patent_assignee_assignee_patent_year[ (year == '2019') ]

setkey(patent_assignee_assignee_patent_2019, "organization")
key(patent_assignee_assignee_patent_2019)

setorderv(patent_assignee_assignee_patent_2019, c("num_claims", "organization"), order = -1)

task_2_ans <- patent_assignee_assignee_patent_2019 %>%
  select(organization, num_claims, date)

as_tibble(task_2_ans, .rows = 10)


#Recent patent activity: What US company
#had the most patents granted in 2019?
#List the top 10 companies with the 
#most new granted patents for 2019.

# use data.table  or dplyr
# tables needed: assignee, patent_assignee, patent

# third task ----



col_types_uspc <- list(
  patent_id = col_character(),
  mainclass_id = col_character(),
  sequence = col_integer(),
  uuid = col_skip(),
  subclass_id = col_skip()
  
)

uspc_tbl <- vroom(
  file       = "uspc.tsv", 
  delim      = "\t", 
  col_types  = col_types_uspc,
  na         = c("", "NA", "NULL")
)

setDT(uspc_tbl)

uspc_tbl %>% glimpse()


tic()
patent_assignee_assignee_uspc_tbl <- merge(x = patent_assignee_assignee_tbl, y = uspc_tbl,
                      by = "patent_id",
                      all.x = TRUE,  
                      all.y = TRUE)
toc()

patent_assignee_assignee_uspc_tbl %>% glimpse()

            setkey(patent_assignee_assignee_tbl, "type")
            key(patent_assignee_assignee_tbl)
            
            ?setorder()
            setorderv(patent_assignee_assignee_tbl, c("type", "organization"))
            
            
            patent_assignee_assignee_tbl_us <- patent_assignee_assignee_tbl[ (type == 2)|(type == 3)]
            
            patent_assignee_assignee_tbl_us
            
            
            tic()
            most_patents_world <- patent_assignee_assignee_tbl_us[!is.na(organization), .N, by = organization]
            toc()
            
            
            setkey(most_patents_world, "organization")
            key(most_patents_world)
            
            setorderv(most_patents_world, c("N", "organization"), order = -1)
            
            
            
            as_tibble(most_patents_world, .rows = 10)

            
            
setkey(patent_assignee_assignee_uspc_tbl, "mainclass_id")
key(patent_assignee_assignee_uspc_tbl)

?setorder()
setorderv(patent_assignee_assignee_uspc_tbl, c("mainclass_id"))
patent_assignee_assignee_uspc_tbl

patent_assignee_assignee_uspc_tbl_world <- patent_assignee_assignee_uspc_tbl[!(mainclass_id == 'na')]
patent_assignee_assignee_uspc_tbl_world <- patent_assignee_assignee_uspc_tbl_world[(organization == 'International Business Machines Corporation')|
                                                                                   (organization == 'Samsung Electronics Co., Ltd.')|
                                                                                   (organization == 'Canon Kabushiki Kaisha')|
                                                                                   (organization == 'Sony Corporation')|
                                                                                   (organization == 'Kabushiki Kaisha Toshiba')|
                                                                                   (organization == 'General Electric Company')|
                                                                                   (organization == 'Hitachi, Ltd.')|
                                                                                   (organization == 'Intel Corporation')|
                                                                                   (organization == 'Fujitsu Limited')|
                                                                                   (organization == 'Hewlett-Packard Development Company, L.P.')]          
          
tic()
top_patent_class <- patent_assignee_assignee_uspc_tbl_world[!is.na(mainclass_id), .N, by = mainclass_id]
toc()

top_patent_class

setkey(top_patent_class, "mainclass_id")
key(top_patent_class)

setorderv(top_patent_class, c("N", "mainclass_id"), order = -1)



as_tibble(top_patent_class, .rows = 5)


          
          
#Innovation in Tech: What is 
#the most innovative tech sector? 
#For the top 10 companies (worldwide) 
#with the most patents, what are the 
#top 5 USPTO tech main classes?

# use data.table  or dplyr
# tables needed: assignee, patent_assignee, uspc


