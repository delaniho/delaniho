library(tidyverse)
q1_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")
colnames(q1_2019)
colnames(q1_2020)
colnames(q1_2019)

q1_2019 <- rename(q1_2019, ride_id = trip_id, rideable_type = bikeid, 
                           started_at = start_time, ended_at = end_time, 
          start_station_id = from_station_id, start_station_name = from_station_name,
          end_station_name = to_station_name, end_station_id = to_station_id,
          member_casual = usertype)
str(q1_2019)
str(q1_2020)

q1_2019 <- mutate(q1_2019, ride_id = as.character(ride_id),
                  rideable_type = as.character(rideable_type))
str(q1_2019)
View(q1_2019)
View(q1_2020)

all_trips <- bind_rows(q1_2019, q1_2020)#, q3_2019)#, q4_2019, q1_2020)
all_trips
View(all_trips)

## the following codes give the same result we executed
adex_join <- full_join(q1_2019, q1_2020)
adex1 <- bind_rows(q1_2019, q1_2020) 

## the following codes remove some of the columns
all_trips <- all_trips %>% 
  select( - c (tripduration, start_lat, start_lng, end_lat, end_lng, gender, birthyear))
View(all_trips)
adex1 <- adex1 %>%
  select(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender, tripduration))
View(adex1)

colnames(all_trips)
nrow(all_trips)
dim(all_trips) # gives dimension
head(all_trips)
as_tibble(all_trips)
str(all_trips)
summary(all_trips)
table(all_trips$member_casual) # this gives the common items in the member_casual table

all_trips <- all_trips %>% 
  mutate(member_casual = recode(member_casual,
    "Subscriber" = "member",
    "Customer" = "casual"
  )) # recode changes items as instructed

View(all_trips)
table(all_trips$member_casual)

#these create additional table to the all_trips table
all_trips$date <- as.Date(all_trips$started_at) # taking date frm started_at
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

#this subtracts one column from the other
View(all_trips)
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

#these confirming if its factor or numeric
is.factor(all_trips$ride_length)
is.numeric(all_trips$ride_length)

#after running str()ride_length was changed to numeric
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
str(all_trips)
View(all_trips)

# removing bad data from columns (with "equal to ==" and  "OR |")
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

# viewing mean, median... summary() can also do it (descriptive analysis)
View(all_trips_v2)
mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# checking descriptive anaysis
summary(all_trips_v2$ride_length)

# checking mean... ride_length for member_casual
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# checking mean ride_length for member_casaul per day
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,
          FUN = mean)

# re_arranging day_of_week in order
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday",
                                                                       "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
View(all_trips_v2)

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,
          FUN = mean)
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) #creates weekday field using 
              # short names
  

# codes to gather some infos, arranging in order
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration = mean(ride_length)) %>% 
arrange(member_casual, weekday) 

# Let's visualize the number of rides by rider type
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#Export summary file for further analysis(Create a csv file that we will 
#visualize in Excel, Tableau, or my presentation software)

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual +
                      all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = 'avg_ride_length.csv')

cnt <- all_trips_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday)
write.csv(cnt, file = 'my_trial_version.csv')

