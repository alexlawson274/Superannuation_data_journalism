library (readr)
library(tidyverse)
library(ggplot2)


#read in the source data file from the github folder
urlfile="https://raw.githubusercontent.com/alexlawson274/Superannuation_data_journalism/refs/heads/main/source-data/world%20bank%20national%20accounts/Savings%20%25GDP%20AU%20vs%20OECD%20-%20High%20savings%20vs%20global%20peer%20(full%20data).csv"
df<-read_csv(url(urlfile))

#merge/reshape data into 3 columns
df_long <- pivot_longer(
  data = df,
  cols = -Year,                
  names_to = "Country",        
  values_to = "Value"          
)

#create a plot to inspect the data
p <- ggplot(df_long, aes(x = Year, y = Value, group = Country)) +
  geom_line(color = "grey70", linewidth = 1) +
  gghighlight(Country == "Australia",
              use_direct_label = FALSE,
              label_params = list(color = "red")) +
  labs(title = "Savings % of GDP") +
  ylim(0, 45) +  # Sets y-axis from 0 to 45
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "#FFF8E7"),  # Cream background
    plot.background = element_rect(fill = "#FFF8E7"),   # Extends cream to plot edges
    panel.grid.major = element_line(color = "white"),    # Light grid lines
    panel.grid.minor = element_blank()                  # Remove minor grid
  )

#Save the plot to local comp.
ggsave(
  filename = "Savings % of GDP- World Bank.png",  # Name of the file
  plot = p,                      # Plot object to save
  device = "png",                # File format (options: "png", "pdf", "jpeg", "svg", etc.)
  width = 8,                     # Width (inches)
  height = 5,                    # Height (inches)
  dpi = 300                      # Resolution (dots per inch)
)

#save CSV output
write.csv(df_long, "Savings % of GDP- World Bank.csv", row.names = FALSE)
  
              