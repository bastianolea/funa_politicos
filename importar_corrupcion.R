# cargar datos de corrupción y transformarlos para coincidir con la base de este proyecto
library(dplyr)

corrupcion <- readr::read_csv2("https://raw.githubusercontent.com/bastianolea/corrupcion_chile/refs/heads/main/datos/casos_corrupcion_chile.csv") |> 
  janitor::clean_names()

corrupcion |> 
  glimpse()

corrupcion |> 
  count(delitos) |> 
  print(n=Inf)

datos_corrupcion <- corrupcion |> 
  rename(año = 3) |> 
  select(caso, nombre = responsable, año, partido, sector, posicion,
         starts_with("fuente")) |>
  mutate(sector = tolower(sector)) |> 
  mutate(tipo_persona = case_when(posicion |> tolower() %in% c("alcalde", "concejal", "diputado",
                                                  "gobierno", "intendente", "ministro",
                                                  "presidente", "senador", "subsecretario") ~ "político",
                                  posicion |> tolower() %in% c("municipio", "fiscal", "funcionario público", "funcionario municipal") ~ "funcionario público",
                                  .default = "otros")) |> 
  rename(cargo = posicion) |> 
  mutate(tipo_caso = "corrupción")

datos_corrupcion |> 
  filter(!is.na(fuente2))
