library(tidyverse)
police_arrest <- read_csv('Police_Arrests_20240702.csv')
head(police_arrest)
colnames(police_arrest)
str(police_arrest)
duplicated(police_arrest$`ID Reference Number`)
dim(police_arrest)

police_arrest <- police_arrest %>% 
                  rename(suspect_id = 'suspect_id', race = `Subject's race`,
                  gender = "Subject's gender", age = `Subject's age`, ethnic = 'Ethnicity',
                  district_of = `District of occurrence`,
            adj_to_school = `Adjacent to School`, division = `Assigned Division`, 
            bureau = `Assigned Bureau`, date_time = `Event Date/Time`)

anyNA(police_arrest)

n_distinct(police_arrest)
dim(police_arrest)
n_distinct(police_arrest, na.rm = TRUE)

View(test)

View(police_arrest)

police_arrest_v2 <- na.omit(police_arrest)

n_distinct(police_arrest_v2)

View(police_arrest_v2)

police_arrest_v3 <- police_arrest %>% 
                        select(-c(district_of, division,bureau))
dim(police_arrest_v2)
dim(police_arrest_v3)

summary(police_arrest_v2)
summary(police_arrest_v3)

expn <- police_arrest_v2 %>% 
  group_by(gender, ethnic, adj_to_school) %>% 
  summarise(no_of_suspects = n(), Avg_age = mean(age)) %>% 
  arrange(gender, ethnic, adj_to_school) 

expn_1 <- police_arrest_v2 %>% 
  group_by(gender, race, adj_to_school) %>% 
  summarise(no_of_suspects = n(), Avg_age = mean(age)) %>% 
  arrange(gender, race, adj_to_school) 

expn_2 <- police_arrest_v2 %>% 
  group_by(adj_to_school) %>% 
  summarise(no_of_suspects = n(), Avg_age = mean(age)) %>% 
  arrange(adj_to_school) 

expn1 <- police_arrest_v2 %>% 
  group_by(gender, race, ethnic, adj_to_school) %>% 
  summarise(no_of_suspects = n(), Avg_age = mean(age)) %>% 
  arrange(gender, race, ethnic, adj_to_school)

View(expn_1)
View(police_arrest_v2)

table(police_arrest_v2$race)

write.csv(expn_1, file = 'police_report_v2.csv')
write.csv(expn, file = 'police_report_v1.csv')
write.csv(expn1, file = 'police_report.csv')
  