WITH transactions_per_month AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') AS transaction_month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- Only consider funded transactions
    GROUP BY s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m-01')
),
avg_transactions_per_customer AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM transactions_per_month
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_transactions_per_customer
),
final_counts AS (
    SELECT
        cc.frequency_category,
        COUNT(u.id) AS customer_count,
        ROUND(AVG(cc.avg_transactions_per_month), 1) AS avg_transactions_per_month
    FROM categorized_customers cc
    JOIN users_customuser u ON u.id = cc.owner_id
    GROUP BY cc.frequency_category
)
SELECT *
FROM final_counts
ORDER BY
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;