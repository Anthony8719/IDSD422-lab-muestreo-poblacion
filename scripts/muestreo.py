# muestreo.py — Parte B: población vs. muestra (RetailAndina).
#
# La población es la base completa de fidelización: data/clientes_400.csv (N = 400).
# La pregunta de negocio: ¿cuál es el ingreso mensual promedio de los clientes?
# Se estima con tres diseños de muestreo y se compara cada estimación con el
# parámetro real, que aquí sí se conoce porque la población es pequeña y visible.
#
# Uso (desde la raíz del repositorio): python scripts/muestreo.py

import pandas as pd

pd.set_option("display.width", 100)


def reporte(nombre, muestra, parametro):
    """Imprime n, media estimada y composición por ciudad de una muestra.

    Composición por ciudad: es la pista que delata un sesgo de selección.
    """
    if muestra is None:
        print(f"[{nombre}] pendiente de completar (TODO)")
        return

    n = len(muestra)
    media = muestra["ingresos_mensuales"].mean()
    comp = muestra["ciudad"].value_counts().to_dict()

    print(
        f"[{nombre}] n={n}  media={media:.2f} USD  "
        f"(parámetro {parametro:.2f}, diferencia {media - parametro:+.2f})"
    )
    print(f"    composición por ciudad: {comp}")


# ---------------------------------------------------------------------------
# 1. La población y su parámetro (N = 400)
# ---------------------------------------------------------------------------

poblacion = pd.read_csv("data/clientes_400.csv")

parametro = poblacion["ingresos_mensuales"].mean()

print(
    f"Población: {poblacion.shape[0]} clientes × "
    f"{poblacion.shape[1]} columnas"
)
print(f"Parámetro poblacional — ingreso medio: {parametro:.2f} USD")
print("Ciudades en la población:", poblacion["ciudad"].value_counts().to_dict())
print()


# ---------------------------------------------------------------------------
# 2. Muestra por conveniencia: "los primeros que llegaron"
# ---------------------------------------------------------------------------

# TODO 1: tomar las primeras 20 filas de la población.
muestra_conv = poblacion.head(20)


# ---------------------------------------------------------------------------
# 3. Muestra aleatoria simple: el sorteo de 20
# ---------------------------------------------------------------------------

# TODO 2: sortear 20 clientes con la misma probabilidad para todos.
muestra_aas = poblacion.sample(20, random_state=1)

# TODO 3: repetir el sorteo con las semillas 2 a 5
# y mostrar las cinco medias obtenidas, incluyendo la semilla 1.
print(" MEDIAS DE MUESTRAS ALEATORIAS ")

for semilla in range(1, 6):
    muestra = poblacion.sample(20, random_state=semilla)
    media = muestra["ingresos_mensuales"].mean()

    print(f"Semilla {semilla}: {media:.2f} USD")

print()


# ---------------------------------------------------------------------------
# 4. Muestra estratificada: 5 % dentro de cada ciudad
# ---------------------------------------------------------------------------

# TODO 4: muestrear dentro de cada ciudad, conservando su proporción.
muestra_est = poblacion.groupby("ciudad").sample(
    frac=0.05,
    random_state=1
)


# ---------------------------------------------------------------------------
# 5. Comparación final
# ---------------------------------------------------------------------------

reporte("Conveniencia", muestra_conv, parametro)
reporte("Aleatorio simple", muestra_aas, parametro)
reporte("Estratificado", muestra_est, parametro)

print()

if (
    muestra_conv is not None
    and muestra_aas is not None
    and muestra_est is not None
):
    resumen = pd.DataFrame([
        {
            "diseño": "Conveniencia (head)",
            "n": len(muestra_conv),
            "media estimada": round(
                muestra_conv["ingresos_mensuales"].mean(), 2
            ),
        },
        {
            "diseño": "Aleatorio simple (sample)",
            "n": len(muestra_aas),
            "media estimada": round(
                muestra_aas["ingresos_mensuales"].mean(), 2
            ),
        },
        {
            "diseño": "Estratificado (groupby + frac)",
            "n": len(muestra_est),
            "media estimada": round(
                muestra_est["ingresos_mensuales"].mean(), 2
            ),
        },
    ])

    print(f"Parámetro poblacional: {parametro:.2f} USD")
    print(resumen.to_string(index=False))
    print()

    print("Con estas salidas responde en informe.md las preguntas P2 a P5:")
    print("  P2: ¿cuál diseño quedó más cerca del parámetro y por qué un solo")
    print("      número no basta para declarar un ganador?")
    print("  P3: ¿qué defecto tiene la muestra por conveniencia y cómo lo delata")
    print("      su composición por ciudad? ¿Se corrige con más filas?")
    print("  P4: ¿qué implica la variabilidad entre semillas para una decisión")
    print("      tomada con un solo estudio?")
    print("  P5: ¿cuándo usarías cada diseño? (piloto · subgrupos · conclusión)")

else:
    print("Completa los TODO 1 a 4 para ver la tabla comparativa.")