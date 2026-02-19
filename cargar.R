library(dplyr)
library(readxl)
library(janitor)

datos <- read_xlsx("datos/datos_funa_politicos.xlsx") |> 
  clean_names() |> 
  rename(año = ano)

datos
