# Informe — Clasificación de variables y población vs. muestra

**Para:** Gerencia de RetailAndina S.A. · **De:** Equipo de Business Intelligence
**Fecha:** 23/10/2026 · **Asunto:** Base de fidelización: tipos de variables y estimación por muestreo

---

## Resumen ejecutivo

*Las diferentes variables de la base de datos de fidelización de RetailAndina S.A. se han clasificado por su naturaleza estadística en tipos de variables cuantitativa y categórica. Se estimó también el ingreso mensual promedio usando muestreo por conveniencia, aleatorio simple y estratificado cuando la población de individuos entrevistados fue una muestra de 400 clientes. Las conclusiones de esta investigación nos muestran que el muestreo puede dar una aproximación al valor real sin que esté bien reflejado en todos los grupos. Por lo tanto, antes de que la dirección ejecute decisiones comerciales, ella debe contemplar en primer lugar el método de selección como la variabilidad de las estimaciones que ha hecho.*

## Parte A — Clasificación de las variables

*Esta clasificación fue efectuada de acuerdo al significado de cada variable que no recurrió sólo al tipo de dato que Python o R son capaces de reconocer. Para ello se acudió a una interpretación de los tipos inferidos, a los valores únicos y a las comprobaciones del orden de las variable ordinales.*

| Variable | Tipo | Justificación (criterio) | Verificación en código |
|---|---|---|---|
| `cliente_id` | Identificador | Identifica de manera única a cada cliente. Aunque contiene números y letras, no representa una cantidad sobre la que tenga sentido calcular una media. |Se infirió como texto (object en pandas y character en R). Se encontraron 12 valores únicos, correspondientes a los identificadores C001–C012.|
| `edad` |Cuantitativa discreta|En esta base se registra en años enteros. No se consideran fracciones de año en el registro, por lo que se clasifica como discreta según la precisión utilizada.|Se infirió como entero (int64 en pandas e integer en R). Se encontraron 12 valores únicos, entre 22 y 48 años.|
| `numero_hijos` |Cuantitativa discreta|Representa un conteo de personas. Solo admite valores enteros no negativos; no tendría sentido registrar 2,5 hijos como cantidad de hijos.|Se infirió como entero. Se encontraron 5 valores únicos: 0, 1, 2, 3 y 4.|
| `genero` |Categórica nominal|Representa categorías sin una jerarquía estadística natural. Ninguna categoría es mayor o menor que otra.|Se infirió como texto. Se encontraron 3 categorías: Femenino, Masculino y Otro.|
| `nivel_educacion` |Categórica ordinal|Sus categorías tienen un orden educativo: Primaria, Secundaria, Universidad y Posgrado. La distancia entre los niveles no puede interpretarse como una cantidad numérica constante.|Se infirió como texto y se encontraron 4 categorías. Al declarar un factor o una categoría ordenada, el nivel mínimo debe ser Primaria.|
| `ciudad` |Categórica nominal|Identifica la ciudad de residencia del cliente. Las categorías no poseen un orden natural.|Se infirió como texto. Se encontraron 3 categorías: Quito, Guayaquil y Cuenca.|
| `ingresos_mensuales` |Cuantitativa continua|Representa una cantidad monetaria. Aunque en el CSV se almacena como número entero, conceptualmente puede expresarse con decimales, por lo que se considera continua.|Se infirió como entero. Se encontraron 12 valores únicos, desde 760 hasta 2450 USD.|
| `satisfaccion` |Categórica ordinal|Los valores de 1 a 5 representan niveles ordenados de satisfacción. Sin embargo, una puntuación de 4 no significa necesariamente el doble de satisfacción que una de 2.|Se infirió como entero. Se encontraron 4 valores observados: 2, 3, 4 y 5. El código declara el orden de las categorías de 1 a 5.|

**P1.** ¿Qué te dijo el dtype de `satisfaccion` y por qué no basta para clasificarla? ¿Qué pasa si una ordinal queda como texto sin declarar el orden?

*El tipo de dato (dtype) indicó que satisfaccion está almacenada como número entero. Sin embargo, esto no significa que sea una variable cuantitativa: sus valores representan niveles ordenados de satisfacción, por lo que corresponde a una variable categórica ordinal.*

*Por ejemplo, aunque 4 es numéricamente el doble de 2, no podemos afirmar que un cliente con satisfacción 4 esté dos veces más satisfecho que uno con satisfacción 2. Los números funcionan como etiquetas ordenadas y no necesariamente como cantidades con distancias equivalentes.*

*Si una variable ordinal se almacena como texto sin declarar su orden, el programa no conoce automáticamente la jerarquía de sus categorías. Por ejemplo, ordenar alfabéticamente los niveles educativos no reproduce su progresión académica. Declarar explícitamente el orden permite realizar comparaciones y operaciones coherentes con el significado de la variable.*

*En la prueba adicional, escribir Postgrado en lugar de Posgrado produjo 2 valores faltantes (NaN en Python o NA en R), porque ambos registros dejaron de coincidir con la categoría permitida. Esto demuestra que un error tipográfico puede alterar los datos silenciosamente.*

## Parte B — Población vs. muestra

### La población y su parámetro

| Concepto | Valor |
|---|---|
| Población (N) |400 clientes |
| Variable de interés | Ingresos mensuales de los clientes, en USD |
| Parámetro poblacional (media) | 1.330,73 USD |

*La población está compuesta por 200 clientes de Quito (50 %), 120 de Guayaquil (30 %) y 80 de Cuenca (20 %). La media de los ingresos mensuales de los 400 clientes es de 1.330,725 USD, que se presenta redondeada como 1.330,73 USD.*

*¿Por qué se muestrea si aquí el parámetro existe y se calculó?*

*En este ejercicio se conoce el parámetro porque disponemos de los 400 registros completos. Esto permite comparar las estimaciones muestrales con el valor real y evaluar su precisión.*

*En una empresa real, consultar a todos los clientes puede requerir más tiempo y recursos que estudiar una muestra. Por eso, el muestreo permite obtener estimaciones con un costo menor. Sin embargo, una muestra debe seleccionarse cuidadosamente, ya que un diseño inadecuado puede generar resultados poco representativos incluso si contiene muchos registros.*

### Los tres diseños

*Los resultados de la siguiente tabla corresponden a la ejecución del programa de Python con pandas, utilizando random_state=1 para las muestras aleatorias y estratificadas.*

| Diseño | n | Media estimada | Composición por ciudad | Diferencia vs. parámetro |
|---|---|---|---|---|
| Conveniencia (`head`) |20|1.348,50 USD|Quito: 20; Guayaquil: 0; Cuenca: 0|+17,78 USD|
| Aleatorio simple (`sample`) |20|1.336,00 USD|Quito: 8; Guayaquil: 4; Cuenca: 8|+5,28 USD|
| Estratificado (`groupby` + 5 %) |20|1.287,50 USD|Quito: 10; Guayaquil: 6; Cuenca: 4|−43,23 USD|

*Nota acerca de la metodología: las diferencias se determinaron a partir de la resta entre el parámetro poblacional y cada una de las medias estimadas. Por otro lado, la composición y las medias de las muestras aleatorias pueden variar si se utiliza R, dado que su generador aleatorio tampoco produce necesariamente el mismo resultado que en pandas.*

*Anota también las medias de 5 sorteos distintos del aleatorio simple (semillas 1 a 5):*

| Semilla | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| Media |1.336,00 USD|1.405,00 USD|1.235,00 USD|1.491,50 USD|1.288,00 USD|

*Estas medias corresponden a cinco muestras diferentes de 20 clientes seleccionados aleatoriamente de la misma población.*

**P2.** ¿Cuánto vale el parámetro poblacional y cuánto estimó cada diseño? ¿Cuál quedó más cerca y por qué eso **no** alcanza para declarar un ganador?

*El parámetro poblacional es de 1.330,73 USD; la muestra por conveniencia se estimó 1.348,50 USD; la muestra aleatoria simple, 1.336,00 USD y la muestra estratificada, 1.287,50 USD.*

*En esta ejecución, el muestreo aleatorio simple se halló más cerca del parámetro, con una diferencia de algunos pocos dólares, exactamente de 5,28 USD; la muestra por conveniencia mostró una diferencia de 17,78 USD y la estratificada una diferencia de -43,23 USD.*

*Sin embargo, no se puede declarar que el muestreo aleatorio simple es mejor que los anteriores solo por este resultado; es una muestra particular y otra serie puede darle la media que se produce. Para comparar los sistemas de muestreo o de muestreo debe tenerse en cuenta la representatividad, la variabilidad de sus estimaciones y su objetivo, además de la distancia observada en una única ejecución.*

**P3.** La muestra por conveniencia también tiene 20 filas. ¿Qué defecto tiene y cómo lo delatas en la composición por ciudad? ¿Se corrige tomando más filas?

*La muestra por conveniencia consiste en escoger los primeros 20 registros que aparecen en el archivo, como si se hiciera a la manera de una suerte de billete elegido al azar. En este caso, la muestra incluye 20 clientes, pero todos son de Quito. Por lo tanto, como ciudades, Guayaquil y Cuenca quedan completamente fuera de la muestra.*
*El problema, por tanto, radica en que la muestra elegida no refleja en absoluto la composición geográfica de la población; en la que Quito representa el 50 %, Guayaquil el 30 % y Cuenca el 20 %. La composición que podemos observar permite identificar inmediatamente esta limitación.*

*Aumentar el número de filas no corrige el problema. Dado que se siguen recogiendo registros de forma consecutiva y están ordenados por ciudad, una muestra de mayor tamaño podría seguir dejando fuera de la muestra a otras ciudades o bien mostrar las ciudades de manera muy desproporcionada. Como remedio, sería mejor elegir un mecanismo de selección aleatoria o bien un diseño estratificado.*

**P4.** El sorteo aleatorio dio un número distinto en cada semilla. ¿Qué implica esa variabilidad para una empresa que va a decidir con un solo estudio?

*Los cinco tipos de semillas que dieron lugar a cinco médias diferentes [1.235,00, 1.345,00, 1.394,00, 1.402,00 y 1.491,50 USD]. Esto muestra que la estimación es, en parte, dependiente de los clientes elegidos en la muestra.*
*Para una empresa, significará que la decisión concreta que se desee tomar basándose en un solo estudio puede verse alterada por la variabilidad muestral. La utilización del resultado para establecer un presupuesto, diseñar una promoción o segmentar a sus clientes nos lleva a afirmar que hay que ser consciente de que la media estimada no es el parámetro determinado.*

*Por lo tanto, no basta con presentar una única cifra como si fuera la exacta.*
*El problema radica en que hay que ser consciente de la "incertidumbre" de la estimación, utilizar métodos estadísticos adecuados para calcular intervalos de confianza donde corresponda y comprobar si el tamaño y el diseño de la muestra se adecuan a la decisión que se quiere tomar.*

**P5.** ¿Cuándo usarías cada diseño en la práctica? Relaciona cada uno con un uso real (piloto, subgrupos que deben aparecer, conclusión sobre toda la población).

*Muestreo por conveniencia — estudio preliminar: me serviría para experimentar con rapidez una encuesta, asegurarme de que las preguntas formuladas sean entendibles o identificar las complicaciones iniciales de un proceso. Es rápido y económico, no obstante, no es la opción adecuada si se pretende obtener conclusiones muy representativas de toda la población, pues ofrece la debilidad de no ser del todo representativo de la población.*

*Muestreo aleatorio simple — estimación global: lo utilizaría para estimar el ingreso mensual promedio en clientes de una entidad cuando se cuenta con lista completa y se puede elegir a cada cliente con probabilidad igual. Disminuye el peligro de selección intencionada, pero no asegura que en una muestra reducida aparezcan todos los subgrupos.*

*Muestreo estratificado — análisis de subgrupos: lo utilizaría cuando resulta decisivo que existan representaciones de todas las ciudades. Ya que se elige a los clientes dentro de cada ciudad, entonces la composición geográfica esperada es conservable y así las comparaciones entre grupos son posibles. Por ejemplo, un 5 % de cada ciudad produce una muestra de 20 clientes: 10 de Quito, 6 de Guayaquil y 4 de Cuenca.*

## Conclusiones

*La clasificación de las variables debe sustentarse en el significado de las mismas y no solamente en el tipo de dato que reconoce el lenguaje de programación de turno. Por ejemplo, satisfaccion está definida como un número entero, pero es ordinal, y cliente_id identifica registros, pero no representa una cantidad estadística.*


*Los resultados muestran que una muestra de 20 clientes puede dar como resultado una media que se aproxima al parámetro poblacional, pero esa proximidad no garantiza que sea representativa. La muestra por conveniencia sólo muestra clientes de Quito, mientras que los diseños aleatorio o estratificado han permitido lograr mecanismos de selección más adecuados para el estudio de la población.*


*La gerencia debe revisar el método de selección, la composición de la muestra y la incertidumbre de las estimaciones antes de tomar decisiones sobre el negocio. Cuando debe garantizarse la participación de todas las ciudades, el muestreo estratificado proporcional es una alternativa adecuada, y para la elaboración de conclusiones generales, deben revisarse también la precisión y las limitaciones del diseño de muestreo implementado.*

