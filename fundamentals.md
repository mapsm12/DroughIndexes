# Theoretical Fundamentals of the Self-Calibrating PDSI (scPDSI)

*Author (original code): Dimitris Herrera*  
*Adaptation & documentation: Miguel Andrade*

---

## 1 · Conceptual Background

The scPDSI is an enhanced version of the classical Palmer Drought Severity Index (PDSI).  
It self-calibrates to local hydro-climatic conditions, allowing direct comparison of drought and pluvial episodes across diverse climates.

Key goals:

1. Balance monthly **precipitation (P)** and **potential evapotranspiration (PE)** to track soil-water anomalies.  
2. Derive a **moisture anomaly index (Z)** that standardises local climate variability.  
3. Convert **Z** into an index **X** whose positive/negative excursions measure wetness/dryness severity and duration.

---

## 2 · Two-Layer Soil Water Balance

The model splits the root zone into:

| Symbol | Layer | Capacity |
|--------|-------|-----------|
| *SS*   | Surface layer | 1 inch (fixed) |
| *SU*   | Underlying layer | *AWC − 1* inch |

At each month *t*:

\[
\Delta W = P_t - PE_t
\]

### 2.1 Recharge, Loss and Run-off  
Decision rules determine recharge \((R)\), loss \((L)\), actual evapotranspiration \((ET)\) and runoff \((RO)\), respecting the capacity limits of SS and SU. The algorithmic flow is encoded in **`WaterBalance()`**.

---

## 3 · CAFEC Variables & Moisture Departure

For every month *m ∈ 1…12* we aggregate over the calibration period to obtain **CAFEC** (Climatically Appropriate For Existing Conditions) totals:

\[
\begin{aligned}
ET_m^{\ast} &= \sum ET_m \\
PR_m^{\ast} &= \sum R_m \\
PRO_m^{\ast}&= \sum RO_m \\
PL_m^{\ast} &= \sum L_m
\end{aligned}
\]

The **CAFEC precipitation** is

\[
\hat{P}_t = \alpha_m\,PE_t + \beta_m\,PR_t + \gamma_m\,PRO_t - \delta_m\,PL_t ,
\]

with coefficients

\[
\alpha_m=\frac{ET_m^{\ast}}{PE_m^{\ast}},\quad
\beta_m=\frac{R_m^{\ast}}{PR_m^{\ast}},\quad
\gamma_m=\frac{RO_m^{\ast}}{PRO_m^{\ast}},\quad
\delta_m=\frac{L_m^{\ast}}{PL_m^{\ast}} .
\]

The *moisture departure* is

\[
d_t = P_t - \hat{P}_t .
\]

---

## 4 · Initial Climatic Characteristic and Z-Index

1. **Absolute departures** are binned by month and summed:
   \[
   D_m=\sum |d_{t=m}|.
   \]

2. **Relative moisture demand**  
   \[
   T_m = \frac{PE_m^{\ast}+R_m^{\ast}+RO_m^{\ast}}{P_m^{\ast}+L_m^{\ast}}.
   \]

3. **First climatic characteristic**  
   \[
   k_m = 1.5\;\log_{10}\!\Bigl(\frac{T_m+2.8}{D_m/\bar{n}}\Bigr) + 0.5,
   \]
   where \(\bar{n}\) is years in the calibration set.

4. **First approximation of the moisture anomaly**
   \[
   z_t = k_m\,d_t .
   \]

Function **`Z_index()`** performs these steps.

---

## 5 · Duration Factors

Using sliding sums of \(z_t\) over window lengths \(L\):

- *Dry spells* → minimum cumulative \(z\) (negative)  
- *Wet spells* → maximum cumulative \(z\) (positive)

Linear regressions (function **`DurFact()`**) yield slopes \((m_d, m_w)\) and intercepts \((b_d, b_w)\):

\[
\text{Severity} = m\,L + b.
\]

These **duration factors** scale drought/pluvial persistence in later computations.

---

## 6 · Recursive Computation of X, X₁, X₂, X₃

Three state variables are updated each month (function **`CalcX()`**):

| Variable | Tracks | Update form |
|----------|--------|-------------|
| \(X_1\) | Wet spells | \(X_1\gets\max\bigl(w_c\,X_1 + \tfrac{z}{w_z},\,0\bigr)\) |
| \(X_2\) | Dry spells | \(X_2\gets\min\bigl(d_c\,X_2 + \tfrac{z}{d_z},\,0\bigr)\) |
| \(X_3\) | Active episode | Weighted combination of \(X_1,X_2,z\) |

where the constants  
\(w_c, d_c, w_z, d_z\) derive from \((m_d, b_d, m_w, b_w)\).

### 6.1 Probability Logic

Functions **`func_ud_wd()`** and **`ClearX3()`** implement the Palmer “probability of ending/beginning” logic, forcing episodes to terminate when \(-0.5 < X_3 < 0.5\) and adjusting \(X_3\) to avoid false transitions.

### 6.2 Final Index Selection

The final **scPDSI**:

\[
X_t = \text{SelectX}\!\bigl(X_3,\,X_1,\,X_2\bigr),
\]

guaranteeing a unique drought/wetness magnitude each month.

---

## 7 · Second Iteration (Scaling)

A second pass rescales \(k_m\) so that:

\[
k_m' = 
\begin{cases}
k_m\left(\dfrac{4}{\,\text{P2 \%ile}}\right) & d_t<0\\
k_m\left(\dfrac{-4}{\,\text{P98 \%ile}}\right) & d_t>0
\end{cases}
\]

This yields the “true” \(Z\) and a refined \(X\) (functions **`CalcPDSI()`** and **`sc_PDSI()`**).

---

## 8 · Wrapper Functions

* **`pdsi_wrapper()`** Converts units, applies leap-year correction, and computes monthly scPDSI.  
* **`pdsi_wrapper_annual()`** Aggregates inputs to yearly totals before calling `sc_PDSI`, enabling inter-annual analysis.

---

## 9 · Implementation Notes

* All depths are internally converted to **inches · month⁻¹** to preserve parity with Palmer’s original constants.  
* Arrays are NumPy-vectorised for performance; no loops over months are exposed to user code.  
* Optional dependence on **`xarray`** lets users apply the wrappers across large 3-D grids (lat–lon–time).

---

## 10 · References

1. **Palmer, W. C.** (1965). *Meteorological Drought*. Research Paper 45, U.S. Weather Bureau.  
2. **Wells, N.**, **Goddard, S.**, & **Hayes, M. J.** (2004). *A Self-Calibrating Palmer Drought Severity Index*. **J. Climate**, 17, 2335–2351.  
3. **Keyantash, J.** & **Dracup, J. A.** (2002). *An Aggregate Drought Index*. **Water Resour. Res.**, 38(7).

---

