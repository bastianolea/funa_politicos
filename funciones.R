pildora_alerta <- function(valor) {
  
  color_alerta <- recode_values(valor,
                                "mentira" ~ "#925866",
                                "abuso" ~ "#AC524F",
                                "corrupción" ~ "#58925B",
                                "delito" ~ "#586C92",
                                "fraude" ~ "#927D58",
                                "irresponsabilidad" ~ "#92587F",
                                default = "#92587F")
  
  salida <- glue("<span style='padding: 2px 12px; 
                    border-radius: 12px; 
                    display: inline-block; vertical-align: top; 
                    margin: 2px;
                    background: {color_alerta}; color: white;'>
                {valor}
              </span>")
  
  salida <- if_else(is.na(valor), "", salida)
  
  return(salida)
}
