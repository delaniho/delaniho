library(tidyverse)

daily_activity <- read_csv("dailyActivity_merged.csv")
sleep_day <- read_csv("sleepDay_merged.csv")

head(daily_activity)
colnames(daily_activity)
str(daily_activity)

head(sleep_day)
colnames(sleep_day)

n_distinct(daily_activity$Id, na.rm = TRUE)
n_distinct(sleep_day$Id, na.rm = TRUE)
nrow(daily_activity)
nrow(sleep_day)

daily_activity %>%
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()

sleep_day %>%
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()

ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + geom_point()

ggplot(data=sleep_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + geom_point()

combined_data <- merge(sleep_day, daily_activity, by="Id")

n_distinct((combined_data))
n_distinct(daily_activity)
n_distinct(sleep_day)

combined_data_v2 <- full_join(sleep_day, daily_activity, by="Id")

View(combined_data)

combined_data_v2 <- full_join(sleep_day, daily_activity, by="Id", 
                              relationship = "many-to-many")
View(combined_data_v2)

n_distinct(combined_data_v2)
