
# muestreo.R — Parte B: población vs. muestra (RetailAndina).
#
# La población es la base completa de fidelización: data/clientes_400.csv (N = 400).
# La pregunta de negocio: ¿cuál es el ingreso mensual promedio de los clientes?
# Se estima con tres diseños de muestreo y se compara cada estimación con el
# parámetro real de la población.

# ---------------------------------------------------------------------------
# 1. La población y su parámetro (N = 400)
# ---------------------------------------------------------------------------

poblacion <- read.csv("data/clientes_400.csv")

cat(sprintf("Población: %d clientes × %d columnas\n",
            nrow(poblacion), ncol(poblacion)))

parametro <- mean(poblacion$ingresos_mensuales)

cat(sprintf("Parámetro poblacional — ingreso medio: %.2f USD\n",
            parametro))

cat("Ciudades en la población:\n")
print(table(poblacion$ciudad))


# ---------------------------------------------------------------------------
# Función para reportar los resultados
# ---------------------------------------------------------------------------

reporte <- function(nombre, muestra, parametro) {
  # Imprime el tamaño, la media y la composición por ciudad.

  if (is.null(muestra)) {
    cat(sprintf("[%s] pendiente de completar (TODO)\n", nombre))
    return(invisible(NULL))
  }

  media <- mean(muestra$ingresos_mensuales)

  cat(sprintf(
    "[%s] n=%d  media=%.2f USD  (parámetro %.2f, diferencia %+.2f)\n",
    nombre, nrow(muestra), media, parametro, media - parametro
  ))

  cat("    composición por ciudad:\n")
  print(table(muestra$ciudad))
}


# ---------------------------------------------------------------------------
# 2. Muestra por conveniencia: "los primeros que llegaron"
# ---------------------------------------------------------------------------

# TODO 1: tomar las primeras 20 filas de la población.
muestra_conv <- head(poblacion, 20)


# ---------------------------------------------------------------------------
# 3. Muestra aleatoria simple: el sorteo de 20
# ---------------------------------------------------------------------------

# TODO 2: seleccionar 20 clientes aleatoriamente.
set.seed(1)
muestra_aas <- poblacion[sample(nrow(poblacion), 20), ]

# TODO 3: repetir el sorteo con las semillas del 1 al 5
# y mostrar las cinco medias para observar su variabilidad.

cat("\n MEDIAS DE MUESTRAS ALEATORIAS \n")

for (semilla in 1:5) {
  set.seed(semilla)

  muestra <- poblacion[sample(nrow(poblacion), 20), ]

  media <- mean(muestra$ingresos_mensuales)

  cat(sprintf("Semilla %d: %.2f USD\n", semilla, media))
}


# ---------------------------------------------------------------------------
# 4. Muestra estratificada: 5 % dentro de cada ciudad
# ---------------------------------------------------------------------------

# TODO 4: seleccionar el 5 % de los clientes dentro de cada ciudad.
library(dplyr)

set.seed(1)

muestra_est <- poblacion |>
  group_by(ciudad) |>
  slice_sample(prop = 0.05) |>
  ungroup()


# ---------------------------------------------------------------------------
# 5. Comparación final
# ---------------------------------------------------------------------------

cat("\n--- REPORTES DE LAS MUESTRAS ---\n")

reporte("Conveniencia", muestra_conv, parametro)
reporte("Aleatorio simple", muestra_aas, parametro)
reporte("Estratificado", muestra_est, parametro)

cat("\n--- TABLA COMPARATIVA ---\n")

if (!is.null(muestra_conv) &&
    !is.null(muestra_aas) &&
    !is.null(muestra_est)) {

  resumen <- data.frame(
    diseno = c(
      "Conveniencia (head)",
      "Aleatorio simple (sample)",
      "Estratificado (slice_sample)"
    ),

    n = c(
      nrow(muestra_conv),
      nrow(muestra_aas),
      nrow(muestra_est)
    ),

    media_estimada = round(c(
      mean(muestra_conv$ingresos_mensuales),
      mean(muestra_aas$ingresos_mensuales),
      mean(muestra_est$ingresos_mensuales)
    ), 2)
  )

  cat(sprintf("Parámetro poblacional: %.2f USD\n", parametro))
  print(resumen, row.names = FALSE)

  cat("\nCon estas salidas responde en informe.md las preguntas P2 a P5:\n")
  cat("  P2: ¿Cuál diseño quedó más cerca del parámetro?\n")
  cat("  P3: ¿Qué defecto tiene la muestra por conveniencia?\n")
  cat("  P4: ¿Qué implica la variabilidad entre semillas?\n")
  cat("  P5: ¿Cuándo usarías cada diseño de muestreo?\n")

} else {
  cat("Completa los TODO 1 a 4 para ver la tabla comparativa.\n")
}
