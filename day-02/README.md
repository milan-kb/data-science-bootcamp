# Northwind SQL Analysis — Epochs Day 2

**Assignment 2 — Epochs: Data Science Bootcamp**
Tag: `#evn-ds-epochs26-day02`

## Database Overview

This project uses the [Northwind Database](https://github.com/jpwhite3/northwind-SQLite3) (SQLite fork), which models a wholesale food distributor: customers place orders, each order contains one or more line items (`Order Details`), and each product belongs to a category and is sourced from a supplier.

This particular fork is considerably larger than the classic textbook Northwind dataset:

| Table | Rows |
|---|---|
| Customers | 93 |
| Employees | 9 |
| Orders | 16,282 |
| Order Details | 609,283 |
| Products | 77 |
| Categories | 8 |
| Suppliers | 29 |
| Shippers | 3 |

Order dates span **July 2012 to October 2023** (~11 years). Data quality is clean — no null order dates, no null customer IDs, no orphaned product references, and no duplicate order-line keys.

## Business Questions & SQL Analysis

All queries are in [`queries.sql`](./queries.sql); full execution and Pandas analysis is in [`analysis.ipynb`](./analysis.ipynb).

1. **Which products generate the most revenue?** → Top 10 products by revenue
2. **Which customers are most valuable?** → Top 10 customers by revenue
3. **How does revenue trend over time?** → Monthly sales aggregation
4. **Which product categories perform best?** → Revenue and units sold by category
5. **How often do customers purchase?** → Order count per customer, bucketed into frequency tiers

---

## Query Results & Output Screenshots

### 1. Top 10 Products by Revenue

| ProductName | Total Units Sold | Total Revenue |
|---|---|---|
| Côte de Blaye | 202,234 | $53,265,895.23 |
| Thüringer Rostbratwurst | 199,010 | $24,623,469.23 |
| Mishi Kobe Niku | 200,258 | $19,423,037.50 |
| Sir Rodney's Marmalade | 205,637 | $16,653,807.36 |
| Carnarvon Tigers | 201,747 | $12,604,671.88 |
| Raclette Courdavault | 204,137 | $11,216,410.70 |
| Manjimup Dried Apples | 201,319 | $10,664,768.65 |
| Tarte au sucre | 202,010 | $9,952,936.07 |
| Ipoh Coffee | 202,968 | $9,333,374.70 |
| Rössle Sauerkraut | 202,988 | $9,252,765.44 |

**Output Screenshot:**
![Top 10 Products by Revenue](https://github.com/milan-kb/data-science-bootcamp/raw/main/day-02/output_top_products.png)

---

### 2. Top 10 Customers by Revenue

| CustomerID | CompanyName | # Orders | Total Revenue |
|---|---|---|---|
| BSBEV | B's Beverages | 210 | $6,154,115.34 |
| HUNGC | Hungry Coyote Import Store | 198 | $5,698,023.67 |
| RANCH | Rancho grande | 194 | $5,559,110.08 |
| GOURL | Gourmet Lanchonetes | 202 | $5,552,309.80 |
| ANATR | Ana Trujillo Emparedados y helados | 195 | $5,534,356.65 |
| RICAR | Ricardo Adocicados | 203 | $5,524,517.31 |
| FOLIG | Folies gourmandes | 195 | $5,505,502.85 |
| LETSS | Let's Stop N Shop | 191 | $5,462,198.02 |
| LILAS | LILA-Supermercado | 203 | $5,437,438.34 |
| PRINI | Princesa Isabel Vinhos | 200 | $5,436,770.55 |

**Key Statistic:** Top 10 customers are clustered tightly: mean $5.59M, std dev $213k, range $5.44M–$6.15M.

---

### 3. Monthly Revenue Trend (2012–2023)

136 months spanning July 2012 to October 2023. Monthly revenue fluctuates between ~$2.6M–$3.9M with **no sustained growth or decline**—remarkably flat over 11 years.

**Output Screenshot:**
![Monthly Revenue Trend (2012-2023)](https://github.com/milan-kb/data-science-bootcamp/raw/main/day-02/output_monthly_revenue.png)

**Sample Months:**
| Year-Month | # Orders | Total Revenue |
|---|---|---|
| 2012-07 | 69 | $2,066,219.40 |
| 2012-08 | 122 | $3,556,875.79 |
| 2012-09 | 119 | $3,440,144.98 |
| 2012-10 | 111 | $3,201,529.96 |
| 2012-11 | 105 | $2,980,494.74 |

---

### 4. Product Category Performance

| Category | # Orders | Total Units | Total Revenue |
|---|---|---|---|
| Beverages | 14,828 | 2,427,361 | $92,163,184.18 |
| Confections | 14,895 | 2,628,466 | $66,337,803.06 |
| Meat/Poultry | 13,639 | 1,207,892 | $64,881,147.97 |
| Dairy Products | 14,581 | 2,020,160 | $58,018,116.78 |
| Condiments | 14,682 | 2,420,864 | $55,795,126.78 |
| Seafood | 14,780 | 2,410,782 | $49,921,604.17 |
| Produce | 13,247 | 1,010,224 | $32,701,119.88 |
| Grains/Cereals | 13,910 | 1,412,853 | $28,568,530.34 |

**Category Gap:** Top (Beverages) to bottom (Grains/Cereals) is only ~3.2x. No single category dominates; all are healthy contributors.

---

### 5. Customer Purchase Frequency Distribution

All 93 customers fall into a **single tight bucket: 151–300 orders**.

| Frequency Bucket | Customer Count |
|---|---|
| 0 orders | 0 |
| 1–50 orders | 0 |
| 51–150 orders | 0 |
| **151–300 orders** | **93** |
| 300+ orders | 0 |

**Statistics:**
- Mean: 175 orders per customer
- Std Dev: ~12.7 (very tight clustering)
- Min: 154 orders
- Max: 210 orders

**Insight:** This uniformity is unusual for real-world data and suggests the synthetic or heavily smoothed nature of this dataset.

---

## Key Insights

1. **Revenue leadership is broad, not concentrated in one product.** Côte de Blaye leads at ~$53.3M — roughly double the next product — but from position 2 onward, revenue drops off gently rather than falling off a cliff. Top 10 products range from $9.3M–$53.3M.

2. **Customer revenue is remarkably evenly distributed, with no "whale" accounts.** The top 10 customers by revenue all sit in a tight $5.4M–$6.2M band. For a B2B distributor, this is unusual—typically a Pareto distribution (80/20 rule) applies, with a few large customers dominating. Here, the **coefficient of variation is only ~3.8%**, suggesting either synthetic data, aggressive customer management, or a naturally flat market structure.

3. **Category performance is healthy across the board.** Beverages and Confections lead, Grains/Cereals trails, but the gap between the top and bottom category is only ~3.2x. No single category dominates, and no category is struggling.

4. **Every customer orders with almost identical frequency.** All 93 customers fall into the same 151–300 order bucket (mean 175, std dev ~12.7). Real-world purchase frequency is almost always right-skewed (many light buyers, few heavy buyers). This uniformity is a red flag for synthetic or heavily curated data.

5. **Monthly revenue is flat across the full 11-year span.** Revenue fluctuates month to month (~$2.6M–$3.9M) but shows no sustained multi-year growth or decline. For a real distributor, over an 11-year horizon, some structural trend is typical (either growth, decline, or clear seasonal patterns). This flatness again suggests synthetic or highly controlled data.

---

## Repository Contents

- `queries.sql` — all 5 SQL analysis queries (plus a supporting frequency-distribution query)
- `analysis.ipynb` — SQL execution, Pandas analysis, and charts
- `README.md` — this file
- `northwind.db` — SQLite database (or see the GitHub link above)

## Tools Used

Python, SQLite3, Pandas, Matplotlib, Jupyter Notebook
