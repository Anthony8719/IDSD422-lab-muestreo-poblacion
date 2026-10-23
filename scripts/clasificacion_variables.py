
# clasificacion_variables.py — Parte A: clasificación de las variables de clientes.csv
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# Objetivo: clasificar las variables y verificar su clasificación en código.
#
# Regla: el dtype es una pista, no la clasificación.
# El criterio depende del significado de cada variable.

import pandas as pd

clientes = pd.read_csv("data/clientes.csv")


# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------

print(" 1. ESTRUCTURA DEL ARCHIVO ")
print(f"Dimensiones: {clientes.shape[0]} filas x {clientes.shape[1]} columnas")
print()
print("Primeras filas:")
print(clientes.to_string(index=False))
print()


# ---------------------------------------------------------------------------
# 2. Tipos inferidos (dtype)
# ---------------------------------------------------------------------------

print(" 2. TIPOS INFERIDOS (DTYPE) ")
print(clientes.dtypes)
print()

# TODO 1: identificar qué columnas llegan como números y cuáles como texto.

columnas_numericas = clientes.select_dtypes(include="number").columns.tolist()
columnas_texto = clientes.select_dtypes(include=["object", "string"]).columns.tolist()

print("Columnas inferidas como numéricas:", columnas_numericas)
print("Columnas inferidas como texto:", columnas_texto)
print()
print("Nota: satisfaccion puede llegar como número, pero conceptualmente es ordinal.")


# ---------------------------------------------------------------------------
# 3. Valores únicos
# ---------------------------------------------------------------------------

print("\n 3. VALORES ÚNICOS POR COLUMNA ")

# TODO 2: mostrar cantidad y valores únicos de cada variable.

for columna in clientes.columns:
    valores = clientes[columna].unique()
    print(f"{columna}: {len(valores)} valores únicos -> {valores}")

print()


# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------

print(" 4. VARIABLES ORDINALES ")

# TODO 3: convertir nivel_educacion en categoría ordenada.
# El orden debe respetar el nivel educativo, no el orden alfabético.

orden_educacion = [
    "Primaria",
    "Secundaria",
    "Universidad",
    "Posgrado"
]

clientes["nivel_educacion"] = clientes["nivel_educacion"].astype(
    pd.CategoricalDtype(categories=orden_educacion, ordered=True)
)

print("Nivel educativo mínimo:", clientes["nivel_educacion"].min())

# TODO 4: convertir satisfaccion en categoría ordenada.
# Se consideran las etiquetas de la escala del 1 al 5.

orden_satisfaccion = [1, 2, 3, 4, 5]

clientes["satisfaccion"] = clientes["satisfaccion"].astype(
    pd.CategoricalDtype(categories=orden_satisfaccion, ordered=True)
)

print("Satisfacción mínima:", clientes["satisfaccion"].min())

# Prueba extra: demostrar el efecto de escribir mal una categoría.
# Se usa una copia para no alterar la variable correcta.

educacion_error = clientes["nivel_educacion"].astype("object").astype(
    pd.CategoricalDtype(
        categories=["Primaria", "Secundaria", "Universidad", "Postgrado"],
        ordered=True
    )
)

print(
    "Valores faltantes al escribir 'Postgrado' en lugar de 'Posgrado':",
    educacion_error.isna().sum()
)

print()


# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación
# ---------------------------------------------------------------------------

print(" 5. RESUMEN DE LA CLASIFICACIÓN ")

# TODO 5: clasificar cada variable según su significado.

clasificacion = {
    "cliente_id": "Identificador",
    "edad": "Numérica discreta",
    "numero_hijos": "Numérica discreta",
    "genero": "Categórica nominal",
    "nivel_educacion": "Categórica ordinal",
    "ciudad": "Categórica nominal",
    "ingresos_mensuales": "Numérica continua",
    "satisfaccion": "Categórica ordinal"
}

print("Resumen de la clasificación (para el informe):")

for variable, tipo in clasificacion.items():
    print(f"  {variable:20s} {tipo}")
