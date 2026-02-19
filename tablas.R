library(dplyr)
library(gt)
library(tidyr)
library(stringr)
library(glue)
library(purrr)


# resumen casos ----
datos |> 
  arrange(desc(año), desc(agregado)) |> 
  select(caso, nombre,
         sector,
         tipo_caso) |> 
  separate_wider_delim(tipo_caso, delim = ",",
                       names = c("tipo_caso_1", "tipo_caso_2", "tipo_caso_3"),
                       too_few = "align_start") |> 
  mutate(across(starts_with("tipo_caso"), str_squish)) |> 
  mutate(across(starts_with("tipo_caso"), ~pildora_alerta(.x))) |> 
  gt() |> 
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = caso)
  ) |>
  fmt_markdown(columns = starts_with("tipo_caso")) |> 
  sub_missing(columns = sector, missing_text = "sin información") |> 
  tab_style(
    style = cell_text(color = "grey70"),
    locations = cells_body(columns = sector,
                           rows = is.na(sector))
  ) |>
  sub_missing(columns = starts_with("tipo_caso"), missing_text = "") |> 
  cols_merge(
    columns = starts_with("tipo_caso"),
    pattern = "{1}{2}{3}"
  )

# conteo tipos de casos ----
datos |> 
  ###
  # filtrar por persona, sector?
  ###
  select(tipo_caso) |> 
  separate_longer_delim(tipo_caso, delim = ",") |> 
  mutate(tipo_caso = str_squish(tipo_caso)) |> 
  count(tipo_caso, sort = TRUE) |> 
  mutate(tipo_caso = pildora_alerta(tipo_caso)) |> 
  gt() |> 
  fmt_markdown(columns = tipo_caso) |> 
  cols_align(align = "right", columns = tipo_caso)
  

# conteo tipos de casos x sector ---- 
datos |> 
  select(sector, tipo_caso) |> 
  mutate(sector = replace_na(sector, "sin información")) |> 
  separate_longer_delim(tipo_caso, delim = ",") |> 
  mutate(tipo_caso = str_squish(tipo_caso)) |> 
  count(sector, tipo_caso, sort = TRUE) |> 
  pivot_wider(names_from = sector, values_from = n, values_fill = 0) |> 
  mutate(tipo_caso = pildora_alerta(tipo_caso)) |> 
  gt() |> 
  fmt_markdown(columns = tipo_caso) |> 
  cols_align(align = "right", columns = tipo_caso)
