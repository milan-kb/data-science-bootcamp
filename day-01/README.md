# Hotel Booking Demand — Dataset Exploration & Problem Framing

**Assignment 1 — Epochs: Data Science Bootcamp (Day 1)**
Tag: `#evn-ds-epochs26-day01`

## Dataset Overview

This project uses the [Hotel Booking Demand](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand) dataset from Kaggle. It contains **119,390 booking records** across a City Hotel and a Resort Hotel, covering arrivals between 2015 and 2017. Each row represents a single booking and includes details about the guest, the stay dates, the booking channel, pricing, and — critically — whether the booking was ultimately cancelled.

## Business Problem

Hotels lose real revenue and operational efficiency when bookings are cancelled, especially close to the arrival date: rooms can go unsold, staffing plans get disrupted, and last-minute pricing/overbooking decisions become harder to make well.

**The business problem:** *Can we predict, at the time a booking is made, whether it is likely to be cancelled?*

If so, a hotel could act early — offering flexible rebooking incentives to at-risk guests, adjusting overbooking strategy with more confidence, or tightening deposit policies for high-risk segments — rather than reacting only after a cancellation happens.

## ML Problem Framing

**Type: Classification** (binary: cancelled vs. not cancelled)

This is framed as classification rather than regression because the target (`is_canceled`) is categorical, not continuous. It's also not a clustering problem, because the business need is a specific, actionable prediction per booking (will *this* booking cancel?), not an open-ended grouping of bookings into segments.

## Target Variable & Key Features

**Target variable:** `is_canceled` (0 = not cancelled, 1 = cancelled)
- Class balance: 63% not cancelled / 37% cancelled — moderately imbalanced, worth accounting for in modeling (e.g. stratified sampling or class weighting) but not severe enough to require synthetic resampling.

**Key features** (all known at the time of booking, so all safe to use without leaking the outcome):
| Feature | Why it matters |
|---|---|
| `lead_time` | Days between booking and arrival — strongest, most intuitive driver of cancellation |
| `deposit_type` | No Deposit / Non Refund / Refundable — surprisingly strong (and counterintuitive) signal |
| `market_segment` | Online TA, Groups, Direct, Corporate, etc. |
| `customer_type` | Transient, Group, Contract, Transient-Party |
| `previous_cancellations` | Guest's prior cancellation history |
| `total_of_special_requests` | Rough proxy for guest engagement/commitment |
| `hotel` | City Hotel vs Resort Hotel |

`reservation_status` and `reservation_status_date` are deliberately **excluded** from modeling features, since they're recorded after the outcome is already known and would leak the target.

## Basic Exploration Summary

- **Shape:** 119,390 rows × 32 columns
- **Missing values:** `company` (94.3% missing — most bookings simply aren't company-booked), `agent` (13.7% missing), `country` (0.4%), `children` (4 rows, negligible)
- **Data quality issues found:** `adr` (Average Daily Rate) contains an invalid negative value and an extreme outlier (5400); ~31,994 exact duplicate rows exist (~27% of the dataset) and should be addressed before modeling
- Full statistics and breakdowns are in `analysis.ipynb`

## Three Key Observations

1. **Non-refundable deposits cancel almost every time — the opposite of what you'd expect.** Non Refund bookings cancel **99.4%** of the time, versus 28.4% for No Deposit bookings. Logically, a non-refundable deposit should discourage cancellation since the guest stands to lose money — instead it's the single strongest cancellation signal in the dataset. This likely reflects a subset of provisional or speculative bookings from specific channels rather than genuine paid commitments, and is worth investigating further rather than taken at face value.

2. **Cancellation rate rises steadily with lead time, from 9.6% to 67.7%.** Bookings made within a week of arrival cancel only 9.6% of the time; bookings made a year or more in advance cancel 67.7% of the time. Unlike deposit type, this relationship is intuitive and trustworthy — more time between booking and arrival means more opportunity for plans to change.

3. **Group bookings cancel more than any other market segment, despite seeming like the most committed.** Groups cancel at **61.1%**, far above Direct (15.3%) and Corporate (18.7%). This runs against the assumption that group bookings (weddings, tours, conferences) are firmer commitments — in practice it likely reflects that group bookings are booked far in advance (compounding the lead-time effect) or represent block reservations that get partially released as plans firm up.

## Repository Contents

- `analysis.ipynb` — full dataset exploration using Pandas
- `README.md` — this file
- `hotel_bookings.csv` — dataset (or see Kaggle link above)

## Tools Used

Python, Pandas, NumPy, Jupyter Notebook
