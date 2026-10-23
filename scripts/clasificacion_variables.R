
# clasificacion_variables.R — Parte A: clasificación de las variables de clientes.csv
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# Objetivo: clasificar las variables y verificar su clasificación en código.
#
# Regla: el tipo que infiere el lenguaje es una pista, no la clasificación.
# El criterio depende del significado de cada variable.

clientes <- read.csv("data/clientes.csv", stringsAsFactors = FALSE)


# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------

cat(sprintf(
  "Dimensiones: %d filas × %d columnas\n",
  nrow(clientes), ncol(clientes)
))

cat("\nPrimeras filas:\n")
print(clientes)


# ---------------------------------------------------------------------------
# 2. Tipos inferidos (str) — la pista que da el lenguaje
# ---------------------------------------------------------------------------

cat("\n TIPOS INFERIDOS \n")
str(clientes)

# TODO 1: identificar qué columnas llegan como números y cuáles como texto.

columnas_numericas <- names(clientes)[
  sapply(clientes, is.numeric)
]

columnas_texto <- names(clientes)[
  sapply(clientes, is.character)
]

cat("\nColumnas numéricas:\n")
print(columnas_numericas)

cat("\nColumnas de texto:\n")
print(columnas_texto)

cat(
  "\nNota: satisfaccion puede estar almacenada como número, ",
  "pero conceptualmente es una variable ordinal.\n",
  sep = ""
)


# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------

cat("\n VALORES ÚNICOS POR COLUMNA \n")

# TODO 2: imprimir la cantidad y los valores únicos de cada columna.

for (columna in names(clientes)) {
  valores <- unique(clientes[[columna]])

  cat(sprintf(
    "%s: %d valores únicos -> ",
    columna,
    length(valores)
  ))

  print(valores)
}


# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------

cat("\n VARIABLES ORDINALES \n")

# TODO 3: convertir nivel_educacion en un factor ordenado.

orden_educacion <- c(
  "Primaria",
  "Secundaria",
  "Universidad",
  "Posgrado"
)

clientes$nivel_educacion <- factor(
  clientes$nivel_educacion,
  levels = orden_educacion,
  ordered = TRUE
)

cat(
  "Nivel educativo mínimo: ",
  as.character(min(clientes$nivel_educacion, na.rm = TRUE)),
  "\n",
  sep = ""
)


# TODO 4: convertir satisfaccion en un factor ordenado.
# Se supone que la escala está codificada con las etiquetas 1, 2, 3, 4 y 5.

orden_satisfaccion <- c("1", "2", "3", "4", "5")

clientes$satisfaccion <- factor(
  as.character(clientes$satisfaccion),
  levels = orden_satisfaccion,
  ordered = TRUE
)

cat(
  "Satisfacción mínima: ",
  as.character(min(clientes$satisfaccion, na.rm = TRUE)),
  "\n",
  sep = ""
)


# Prueba extra: cambiar accidentalmente "Posgrado" por "Postgrado".
# Se utiliza una copia para conservar la variable correcta.

educacion_error <- factor(
  as.character(clientes$nivel_educacion),
  levels = c(
    "Primaria",
    "Secundaria",
    "Universidad",
    "Postgrado"
  ),
  ordered = TRUE
)

cat(
  "Valores faltantes al escribir 'Postgrado' en lugar de 'Posgrado': ",
  sum(is.na(educacion_error)),
  "\n",
  sep = ""
)


# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------

# TODO 5: clasificar cada variable según su significado.

clasificacion <- c(
  cliente_id         = "Identificador",
  edad               = "Numérica discreta",
  numero_hijos       = "Numérica discreta",
  genero             = "Categórica nominal",
  nivel_educacion    = "Categórica ordinal",
  ciudad             = "Categórica nominal",
  ingresos_mensuales = "Numérica continua",
  satisfaccion       = "Categórica ordinal"
)

cat("\nResumen de la clasificación (para el informe):\n")

for (variable in names(clasificacion)) {
  cat(sprintf(
    "  %-18s %s\n",
    variable,
    clasificacion[[variable]]
  ))
}
