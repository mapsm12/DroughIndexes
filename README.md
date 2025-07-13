# Índices de Sequía en Python (`DroughIndexes`)

Este repositorio contiene scripts, funciones y herramientas desarrolladas en Python para el cálculo, análisis y visualización de índices de sequía como el **scPDSI** (Self-Calibrated Palmer Drought Severity Index) y el **SPEI** (Standardized Precipitation-Evapotranspiration Index).

## ð Estructura del repositorio

- `scpdsi/` – Scripts y funciones para calcular el índice scPDSI
- `spei/` – Códigos para el cálculo y análisis del índice SPEI
- `datasets/` – Información sobre los datos de entrada utilizados
- `notebooks/` – Ejemplos interactivos y análisis exploratorios en Jupyter
- `SALIDAS/` – Resultados generados (mapas, series temporales, tablas)

## ð§ Requisitos

- Python 3.8 o superior
- Librerías:
  - `xarray`
  - `numpy`
  - `matplotlib`
  - `pandas`
  - `climate_indices`
  - `netCDF4`
  - `rasterio` (para análisis espaciales)

Instalación recomendada con `conda` o `pip`:

```bash
pip install -r requirements.txt

