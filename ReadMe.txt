# Data Analytics-Assessment

This repository contains solutions to the Data Analytics SQL assessment. Each query answers a specific business question using well-structured SQL and best practices.

---

## Per-Question Explanations

### `Assessment_Q1.sql`
**Goal:** Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Approach:**
- Joined `users_customuser` with `plans_plan` and `savings_savingsaccount`.
- Used conditional aggregation with `CASE WHEN` to count savings and investment accounts separately.
- Aggregated the total confirmed deposit amount, converting from kobo to naira (`/ 100`).
- Filtered for customers who have **both** account types using the `HAVING` clause.

---

### `Assessment_Q2.sql`
**Goal:** Calculate the average number of transactions per customer per month and categorize them:
	"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)


**Approach:**
- Joined `users_customuser` with `savings_savingsaccount` to gather customer activity.
- Calculated customer tenure using `TIMESTAMPDIFF` in months.

---

### `Assessment_Q3.sql`
**Goal:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
Tables:

**Approach:**
- Used a `CASE` statement to categorize plans into "Savings", "Investment", or "Other".
- Pulled the most recent inflow transaction date using `MAX()` and filtered only positive `confirmed_amount` inflows.
- Calculated the number of days since the last transaction using `DATEDIFF`.
- Filtered for plans that are either inactive (no inflow ever) or have been inactive for over 365 days.

---

### `Assessment_Q4.sql`
**Goal:** Estimate Customer Lifetime Value (CLV) based on transaction activity and customer tenure

Calculated the number of months since each customer joined using TIMESTAMPDIFF.

Counted the total number of savings transactions per customer.

Calculated an estimated CLV using the formula stated in the question.


---

## Challenges Faced

1. **Understanding Table Relationships:**
   - Required reverse engineering the data model (e.g., how `users_customuser`, `plans_plan`, and `savings_savingsaccount` relate).
   - Used exploratory queries and column names to understand foreign key links.

2. **Data Quality & Null Handling:**
   - Used `LEFT JOIN` and `NULLIF` to handle missing transactions or zero-tenure scenarios safely.
   - Managed `NULL` inflow dates and filtered inactive accounts properly using conditional logic.

3. **CLV Formula Adaptation:**
   - Assumed the formula to use for CLV based on available data. Without exact business rules, used a logical estimation using average amount, frequency, and tenure.

4. **Currency Conversion:**
   - Some amounts were stored in kobo instead of naira, requiring manual conversion with `/ 100`.

5. **Avoiding Division by Zero:**
   - Introduced `NULLIF()` in the denominator of tenure calculation to avoid runtime errors in MySQL.

