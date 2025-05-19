SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(CASE WHEN s.confirmed_amount > 0 THEN s.transaction_date ELSE NULL END) AS last_inflow_date,
    DATEDIFF(CURDATE(), MAX(CASE WHEN s.confirmed_amount > 0 THEN s.transaction_date ELSE NULL END)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
    ON p.id = s.plan_id
WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
GROUP BY p.id, p.owner_id, type
HAVING last_inflow_date IS NULL 
   OR last_inflow_date <= CURDATE() - INTERVAL 365 DAY
ORDER BY inactivity_days DESC;