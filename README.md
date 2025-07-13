# Metodología para el cálculo del índice de sequía scPDSI

Este repositorio implementa una adaptación en Python del algoritmo original del **Self-Calibrating Palmer Drought Severity Index (scPDSI)**, diseñado para evaluar déficits hídricos prolongados considerando las condiciones climáticas locales.

El código fue adaptado por Miguel Andrade a partir del trabajo desarrollado originalmente por Dimitris Herrera.

---

## 1. Descripción general

El índice **scPDSI** es una versión auto-calibrada del índice PDSI tradicional. Permite detectar eventos de sequía y pluviales en una escala estandarizada, con calibración automática a las condiciones climáticas locales. El cálculo considera:

- Precipitación mensual (mm)
- Evapotranspiración potencial (PET) mensual (mm)
- Capacidad de retención de agua disponible del suelo (AWC, en pulgadas)
- Periodo de calibración climática

---

## 2. Estructura de la metodología

### 2.1. Cálculo del Balance Hídrico Mensual

Se calcula la relación entre la precipitación y la evapotranspiración potencial para estimar:

- Evapotranspiración real (ET)
- Recarga del suelo (R)
- Pérdida de agua (L)
- Escorrentía (RO)
- Humedad en capas superficial y profunda del suelo (SS y SU)

> Función: `WaterBalance()`

---

### 2.2. Cálculo de variables potenciales

Se estiman los valores potenciales de:

- Recarga (`pr`)
- Pérdida (`pl`)
- Escorrentía (`pro`)

> Función: `potentials()`

---

### 2.3. Cálculo del índice de anomalía de humedad Z

A partir del balance hídrico y las variables CAFEC (Climatically Appropriate For Existing Conditions), se calcula:

- Precipitación esperada (`Phat`)
- Déficit de humedad (`d`)
- Coeficientes climáticos (`k`)
- Índice Z

> Función: `Z_index()`

---

### 2.4. Factores de duración (dry/wet spells)

Se determinan relaciones lineales entre la duración y severidad de eventos secos y húmedos, usando:

- Mínimos/máximos de sumatorias de `Z` por tramos
- Ajustes de regresión lineal

> Función: `DurFact()`

---

### 2.5. Cálculo del índice PDSI final

Se generan los índices:

- `X1`, `X2`, `X3`: componentes de seguimiento del estado de sequía/pluvial
- `X`: índice final `scPDSI` ajustado
- `Z`: segunda aproximación de la anomalía de humedad con nueva calibración

> Funciones: `CalcPDSI()`, `CalcX()`, `SelectX()`

---

## 3. Consideraciones de entrada

- **Unidad de datos**:
  - Si se usan datos de modelos climáticos (`kg/m²/s`), se convierten a mm
  - PET puede ingresarse como tasas diarias o mensuales
- **Unidad estándar de cálculo**:
  - Todos los datos se convierten a **pulgadas/mes**

> Conversión y ajuste en: `pdsi_wrapper()`

---

## 4. Aplicación espacial

El script incluye funciones adaptadas para aplicar el scPDSI a grillas de datos 3D (latitud, longitud, tiempo), permitiendo el análisis espacial del índice.

---

## 5. Aplicación temporal anual (opcional)

También se incluye una versión adaptada para trabajar con valores agregados **anualmente**, útil para comparar tendencias de sequía interanual.

> Función: `pdsi_wrapper_annual()`

---

## 6. Requisitos

- Python 3.8+
- Librerías: `numpy`, `scipy`, `xarray` (para uso espacial)

---

## 7. Créditos

- Código base: Dimitris Herrera, Cornell University
- Adaptación y documentación: Miguel Andrade

---

## Referencias

- Palmer, W.C. (1965). Meteorological Drought. Research Paper No. 45, U.S. Weather Bureau.
- Wells, N., Goddard, S., Hayes, M. J. (2004). A Self-Calibrating Palmer Drought Severity Index.


