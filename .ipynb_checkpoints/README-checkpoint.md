# Methodology for Calculating the scPDSI Drought Index

This repository contains a Python implementation of the **Self-Calibrating Palmer Drought Severity Index (scPDSI)** algorithm, adapted from the original work developed by Dimitris Herrera. The implementation was modified by Miguel Andrade for flexible use in research and climate analysis.

---

## 1. Overview

The **scPDSI** is a self-calibrated version of the traditional Palmer Drought Severity Index. It standardizes the detection of dry and wet periods across different climates by dynamically adjusting calibration parameters based on local conditions. Inputs include:

- Monthly precipitation (mm)
- Monthly potential evapotranspiration (PET, mm)
- Soil available water capacity (AWC, inches)
- A defined calibration period

---

## 2. Methodology Structure

### 2.1. Monthly Water Balance Calculation

The water balance is computed to estimate:

- Actual evapotranspiration (ET)
- Soil moisture recharge (R)
- Water loss (L)
- Runoff (RO)
- Soil moisture in surface and lower layers (SS and SU)

> Function: `WaterBalance()`

---

### 2.2. Potential Values Calculation

Based on the water balance, the model estimates:

- Potential recharge (`pr`)
- Potential runoff (`pro`)
- Potential water loss (`pl`)

> Function: `potentials()`

---

### 2.3. Z Moisture Anomaly Index Calculation

Using CAFEC (Climatically Appropriate For Existing Conditions) values, the function computes:

- Expected precipitation (`Phat`)
- Moisture departure (`d`)
- Climatic coefficients (`k`)
- Z index

> Function: `Z_index()`

---

### 2.4. Duration Factors for Dry/Wet Events

Linear relationships between event **duration** and **severity** are derived by:

- Summing `Z` over various lengths
- Fitting regression lines separately for dry and wet periods

> Function: `DurFact()`

---

### 2.5. Final PDSI Computation

The index computation involves:

- Generating time series of `X1`, `X2`, and `X3` (state variables)
- Deriving the final scPDSI index `X`
- Recalculating `Z` using calibrated scaling

> Functions: `CalcPDSI()`, `CalcX()`, `SelectX()`

---

## 3. Input Considerations

- **Data Units**:
  - If using climate model outputs in `kg/m²/s`, they are converted to `mm`
  - PET can be provided as daily or monthly values
- **Standard Unit**:
  - All calculations are internally converted to **inches per month**

> Conversion handled inside: `pdsi_wrapper()`

---

## 4. Spatial Application

The script can be applied over 3D gridded data (lat, lon, time), enabling regional or global drought analysis.

---

## 5. Annual Aggregation (Optional)

An additional wrapper is included to compute **annual scPDSI values**, useful for interannual trend analysis and summary reporting.

> Function: `pdsi_wrapper_annual()`

---

## 6. Requirements

- Python 3.8+
- Dependencies: `numpy`, `scipy`, and optionally `xarray` for spatial operations

---

## 7. Credits

- Original code: Dimitris Herrera, Cornell University
- Adaptation and documentation: Miguel Andrade

---

## References

- Palmer, W.C. (1965). *Meteorological Drought*. Research Paper No. 45, U.S. Weather Bureau.
- Wells, N., Goddard, S., Hayes, M. J. (2004). *A Self-Calibrating Palmer Drought Severity Index*.

