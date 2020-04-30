## Load Libraries ----
library(meetupr)
library(lubridate)
library(tidyverse)

# you must change YOURMEETUPKEY ----
# follow the instructions https://github.com/rladies/meetupr
# it will ask you for authetication to meet up.

urlname <- "rladies-la-paz"
events <- get_events(urlname, c("past", "upcoming"))

events

# munging ----


# display some cols
events %>% 
  select(name, created, status, local_date, yes_rsvp_count)


# mutate
myevents <-
events %>% 
  mutate(created_date = lubridate::date(created),    
            day_event = lubridate::wday(local_date, label = TRUE),
         days_creation = lubridate::time_length(
           lubridate::interval(created_date, local_date), unit = "day"),
         ym_event = forcats::as_factor(paste0(lubridate::year(local_date), "-", 
                     lubridate::month(local_date, label = TRUE)))) %>% 
  select(id, created_date, status, local_date, local_time, yes_rsvp_count,
           day_event, days_creation, ym_event)


myevents

write_csv(myevents, "data/events-rladies-la-paz.csv")

# load the theme for plots
source("https://raw.githubusercontent.com/rladies/starter-kit/master/rladiesggplot2theme.R")


eventosG <-
myevents %>% 
  ggplot((aes(x = ym_event, yes_rsvp_count))) +
  scale_y_continuous(limits = c(1, 40)) +
  geom_point(colour = "#88398A", size = 2.5) +
  geom_text(nudge_x = 0.3, 
            aes(label = paste(day_event, local_time)),
            size = 3 ) +
  geom_text(nudge_x = -0.2, aes(label = yes_rsvp_count), 
            size = 3) +
  labs(x = "Eventos por mes", y = "Meetup: RSVP",
          title = "Meetups RLadies La Paz") +
  r_ladies_theme() +
  theme(text = element_text(size = 12))

ggsave(eventosG, filename = "images/RSVP_RladiesLaPaz.png",
       height = 5, width = 8)

eventosG

## members ----        
lpmembers_ <- read_table("data/rladiesmembers.csv", col_names = "V1")

lpmembers <- 
lpmembers_ %>% 
  filter(V1 != "Co-organizer", V1 != " ") %>%
  filter(V1!= lag(V1, default="1")) %>%    # remove duplicated rows
  mutate(key = rep(c("name", "date_joined"), n() / 2), 
         id = cumsum(key == "name")) %>% 
  spread(key, V1) %>% 
  mutate(x = str_replace(date_joined, "Joined ",""),
         date_joined = lubridate::mdy(str_trim(x)))

rm(lpmembers_)  
write_csv(lpmembers, "data/members-rladies-la-paz.csv")


lpmembers %>%
  ggplot(aes(x = date_joined)) +
  geom_histogram(fill = "darkorchid4", binwidth = 5) +
  labs(x = "Fecha", y = "Nuev@s miembr@s",
       title = "Cuando se unieron mas miembr@s?",
       caption = "Comenzando en Octubre de 2018") +
  r_ladies_theme()

ggsave(filename = "images/members_RladiesLaPaz.png",
       height = 5, width = 8)
