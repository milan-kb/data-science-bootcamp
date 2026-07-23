# Used Car Price Prediction — EDA, Cleaning & Feature Engineering

**Assignment 3 — Epochs: Data Science Bootcamp**
Tag: `#evn-ds-epochs26-day03`

## Dataset Overview

This project uses the [Used Car Price Prediction Dataset](https://www.kaggle.com/datasets/taeefnajib/used-car-price-prediction-dataset) (Kaggle), containing **4,009 used car listings** across **57 brands**, with 12 raw columns describing the vehicle (brand, model, model year), condition (mileage, accident history, title status), specs (engine, transmission, colors), and price.

| | |
|---|---|
| Rows | 4,009 |
| Raw columns | 12 |
| Model years | 1974–2024 |
| Brands | 57 |
| Duplicate rows | 0 |

## Data Quality Issues Identified

1. **`milage` and `price` stored as text, not numbers.** Values like `"51,000 mi."` and `"$10,300"` include units, currency symbols, and thousands separators, making them unusable for statistics or modeling without parsing.
2. **Missing values in three columns:** `clean_title` (14.87% missing), `fuel_type` (4.24% missing), `accident` (2.82% missing).
3. **Junk categories hidden inside `fuel_type`.** The values `"–"` and `"not supported"` are not real fuel types and function as disguised missing data.
4. **`clean_title` has no explicit "No" value** — it's either `"Yes"` or missing, meaning missingness here likely encodes information (no clean title) rather than being random.
5. **Severe category fragmentation in `transmission`.** 62 unique values, many describing the same underlying transmission type in different text formats (e.g. `'A/T'`, `'6-Speed A/T'`, `'Automatic'`).
6. **At least one clear data-entry error in `price`.** A 2005 Maserati Quattroporte Base listed at $2,954,083 is implausible for that model, unlike nearby genuine exotic-car outliers (Bugatti Veyron, Porsche Carrera GT).
7. **Unstructured text in `engine`** bundles horsepower, displacement, and cylinder count into free text (e.g. `"300.0HP 3.7L V6 Cylinder Engine Flex Fuel Capability"`), rather than separate usable fields.

## Cleaning Techniques Applied

| Issue | Technique | Reasoning |
|---|---|---|
| `milage` / `price` as text | Stripped units/symbols (`mi.`, `$`, `,`) and cast to float | Required for any numeric analysis or modeling |
| `fuel_type` missing + junk values | Replaced `"–"` and `"not supported"` with NaN, then filled all missing with `"Unknown"` | Preserves rows instead of dropping ~4% of data; avoids treating junk strings as real categories |
| `clean_title` missing | Filled with `"No"` (not "Unknown") | Column never contains an explicit "No" — missingness plausibly encodes a non-clean title, which is a real, useful signal |
| `accident` missing | Filled with `"Unknown"` | No strong basis to default to either "accident" or "no accident" |
| Duplicate rows | Checked with `.duplicated()` | None found (0 rows removed) — but the check is kept in the pipeline as a safeguard |
| Price outliers | Capped (winsorized) at the 99th percentile into a new `price_capped` column | Preserves legitimate exotic-car prices (Bugatti, Porsche, Lamborghini) while preventing the one implausible Maserati entry from distorting statistics; original `price` kept unchanged for transparency |

## Feature Engineering Performed

| Feature | Description | Why it helps |
|---|---|---|
| `car_age` | `2026 − model_year` | Age generalizes across time better than a raw year value |
| `mileage_per_year` | `milage / car_age` | Captures usage intensity — distinguishes a heavily-driven newer car from a lightly-driven older one with similar total mileage |
| `horsepower` | Extracted numerically from `engine` text via regex | Converts free text into a strong likely price predictor (successfully parsed for ~80% of rows) |
| `engine_displacement_l` | Extracted numerically from `engine` text via regex | Same rationale as horsepower — engine size is a known price driver |
| `num_cylinders` | Extracted from `engine` text (handles both `"X Cylinder"` and `"V6"`/`"I4"` style notations) | Adds another structured engine-spec signal from unstructured text |
| *(bonus)* `transmission_type` | Normalized `transmission`'s 62 raw values into `Automatic` / `Manual` / `CVT` / `Other` / `Unknown` | Fixes the category fragmentation issue identified in EDA, making the column usable in a model |

Where engine specs couldn't be parsed from text (~20% of rows, e.g. purely descriptive strings with no numbers), values are left as `NaN` rather than guessed, to avoid introducing false precision.

## Five Key Insights

1. **Price is extremely right-skewed, with at least one likely data-entry error.** Median price is ~$31,000 but the mean is ~$44,553, heavily pulled up by outliers — including one implausible $2.95M listing for a base Maserati Quattroporte that doesn't belong in the same category as genuine exotic-car outliers nearby it.

2. **`clean_title` missingness likely encodes real information, not randomness.** Since the column only ever contains `"Yes"` or is blank — never an explicit `"No"` — the ~15% missing values probably represent cars without a clean title, making this a meaningful predictive signal rather than noise to impute away.

3. **`fuel_type` contains junk categories that are actually missing data in disguise.** Values like `"–"` and `"not supported"` aren't real fuel types; treating them as missing (rather than as legitimate categories) prevents a future model from learning nonsense from these labels.

4. **`transmission` suffers from severe category fragmentation.** With 62 unique values describing what are really only a handful of true transmission types, this column needed normalization before it could be usefully modeled.

5. **The `engine` column bundles multiple numeric features into unstructured text.** Horsepower, displacement, and cylinder count were all extractable from free-text engine descriptions, turning previously unusable text into three separate, structured numeric features with 80%+ extraction success.

## Repository Contents

- `task-3.ipynb` — complete EDA, data cleaning, and feature engineering workflow
- `cleaned_used_cars.csv` — final cleaned dataset (4,009 rows × 19 columns)
- `README.md` — this file
- `used_cars.csv` — original raw dataset (or see the Kaggle link above)

## Tools Used

Python, Pandas, NumPy, Matplotlib, Jupyter Notebook, regex (`re`)
