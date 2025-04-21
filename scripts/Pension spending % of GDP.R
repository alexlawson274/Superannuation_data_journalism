#import libraries 
library (readr)
library(tidyverse)

#read in the source data file from the github folder
urlfile="https://raw.githubusercontent.com/alexlawson274/Superannuation_data_journalism/refs/heads/main/source-data/Pensions%20at%20a%20Glance%202023/Pensions%20spend%20%25%20of%20GDP%20in%20OECD%202020-2060%20-%20Full%20data%20(1).csv"
df<-read_csv(url(urlfile))

#rename headers
colnames(df)[1] <- "country"
colnames(df)[2] <- "year_2020"
colnames(df)[10] <- "year_2060"

# Keep only needed columns
df <- df[, c("country", "year_2020", "year_2060")]

# Reshape to show as barplot
df_long <- df %>% 
  pivot_longer(
    cols = c(year_2020, year_2060),  
    names_to = "Year",
    values_to = "Value"
  )
df_long <- df_long %>%
mutate(country = fct_reorder(country, Value))  # Reorder country by Value

#set a background color
background <- "#FFF8E8"  

#create a bar plot to inspect the data
ggplot(df_long, aes(y = country, x = Value, fill = Year)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(
    title = "Spending on Pensions as % of GDP- OECD 2020 to 2060",
    x = "Pension Spending (% of GDP)",
    y = "",
    fill = "Year"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")+
theme(
  plot.background = element_rect(fill = background, color = NA),
  panel.background = element_rect(fill = background)
)

#save plots to github
ggsave(
  filename = "Pensions_GDP_OECD_2020_2060.png",  
  plot = last_plot(),               
  width = 8,                
  height = 6,               
  dpi = 300                 
)

#save CSV output
write.csv(df, "Pensions_GDP_OECD_2020_2060_FV.csv", row.names = FALSE)

