SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 THEN p.id END
    ) AS savings_account,
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 THEN p.id END
    ) AS investment_account,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits_naira
FROM users_customuser u
JOIN plans_plan p ON p.owner_id = u.id
LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id
GROUP BY u.id, u.first_name, u.last_name
HAVING 
    savings_account >= 1
    AND investment_account >= 1
ORDER BY total_deposits_naira DESC;