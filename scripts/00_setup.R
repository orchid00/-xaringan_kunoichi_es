list_of_packages <- c("rmarkdown", "tidyverse", "devtools", 
                      "rvest", "lubridate", "here", "glue",
                      "janitor", "textclean", "rio", "tidyxl",
                      "showtext", "gganimate", "ggimage",
                      "Cairo", "gapminder", "digest", 
                      "RJSONIO", "extrafont", "DT")
new_packages <- 
  list_of_packages[!(list_of_packages %in% 
                       installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

rm(new_packages, list_of_packages)

## from github
devtools::install_github("yihui/xaringan")
devtools::install_github("rladies/meetupr")
devtools::install_github("emitanaka/anicon")

