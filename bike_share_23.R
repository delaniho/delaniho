library(tidyverse)
divvy_1 <- read_csv("divvy_01.csv")
divvy_2 <- read_csv("divvy_02.csv")
divvy_3 <- read_csv("divvy_03.csv")
divvy_4 <- read_csv("divvy_04.csv")
divvy_5 <- read_csv("divvy_05.csv")
divvy_6 <- read_csv("divvy_06.csv")
divvy_7 <- read_csv("divvy_07.csv")
divvy_8 <- read_csv("divvy_08.csv")
divvy_9 <- read_csv("divvy_09.csv")
divvy_10 <- read_csv("divvy_10.csv")
divvy_11 <- read_csv("divvy_11.csv")
divvy_12 <- read_csv("divvy_12.csv")
colnames(divvy_1)
colnames(divvy_2)
colnames(divvy_3)
colnames(divvy_4)
colnames(divvy_5)
colnames(divvy_6)
colnames(divvy_7)
colnames(divvy_8)
colnames(divvy_9)
colnames(divvy_10)
colnames(divvy_11)
colnames(divvy_12)

head(divvy_1)
head(divvy_2)
head(divvy_3)
head(divvy_4)
head(divvy_5)
head(divvy_6)
head(divvy_7)
head(divvy_8)
head(divvy_9)
head(divvy_10)
head(divvy_11)
head(divvy_12)

all_trips <- bind_rows(divvy_1, divvy_2, divvy_3, divvy_4, divvy_5,
                       divvy_6, divvy_7, divvy_8, divvy_9, divvy_10,
                       divvy_11, divvy_12)

all_trips <- all_trips %>% 
              select(-c(start_station_id, end_station_name,start_station_name, 
                        end_station_id, start_lat, start_lng, end_lat, end_lng ))

colnames(all_trips)
str(all_trips)
table(all_trips$rideable_type)
table(all_trips$member_casual)
View(all_trips)

#duplicated.data.frame(all_trips$ride_id) #check for duplicate in ride_id

all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

View(all_trips)

is.numeric(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))

all_trips_v2 <- all_trips[ !(all_trips$ride_length < 0 ),] # the comma is important

dim(all_trips)
dim(all_trips_v2)

colnames(all_trips_v2)
 
table(all_trips_v2$ride_length)

anyNA(all_trips_v2)

mean(all_trips_v2$ride_length)
median(all_trips_v2$ride_length)
max(all_trips_v2$ride_length) 
min(all_trips_v2$ride_length)
mode(all_trips_v2$ride_length)

summary(all_trips_v2$ride_length)

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,
          FUN = mean)
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels = c("Sunday",
                                                  "Monday" ,"Tuesday", "Wednesday", 
                                                  "Thursday", "Friday", "Saturday"))

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,
          FUN = mean)

#without label displays days in number
all_trips_v2$weekday <- wday(all_trips_v2$started_at, label = TRUE) 
View(all_trips_v2)

#another method
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE))

all_trips_v2 %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length),
            most_used_ride = max(rideable_type)) %>% 
  arrange(member_casual, weekday)

all_trips_v2 %>% 
  group_by(member_casual, weekday, rideable_type) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
arrange(member_casual, weekday, rideable_type) 

all_trips_v2 %>% 
  group_by(member_casual, weekday, rideable_type) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday, rideable_type) %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

all_trips_v2 %>% 
  group_by(member_casual, weekday, rideable_type) %>% 
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday, rideable_type) %>% 
  ggplot(aes(x = rideable_type, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


                                              


