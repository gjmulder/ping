library(lubridate)
library(tidyverse)

system("ssh 192.168.0.18 './awk_ping.sh' > ping.csv")
ping <-
  read_csv("ping.csv", col_names = c("epoch", "resp")) %>%
  mutate(dt = as.POSIXct(epoch, origin = "1970-01-01")) %>%
  # mutate(day.of.week = wday(dt, label = TRUE)) %>%
  mutate(day.of.month = as.factor(mday(dt))) %>%
  mutate(time.of.day = as.factor(substr(as.character(100 + hour(
    dt
  )), 2, 3))) %>%
  # mutate(time.of.day = as.factor(paste0(substr(as.character(100 + hour(
  #   dt
  # )), 2, 3),
  # ':',
  # substr(as.character(100 + minute(
  #   dt
  # )), 2, 3)))) %>%
  group_by(day.of.month, time.of.day) %>%
  summarise(packets = n(), packet.loss = sum(as.integer(is.na(resp)))) %>%
  mutate(packet.loss.pct = 100 * packet.loss / packets)

gg <-
  ggplot(
    ping,
    aes(
      x = time.of.day,
      y = packet.loss.pct,
      fill = day.of.month
    )
  ) +
  geom_bar(stat = "identity",
           position=position_dodge(#width=0.25,
                                   preserve="single")) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
print(gg)
