-- Example schema assumptions:
-- users(id, name, email)
-- stocks(id, ticker, company_name, sector)
-- transactions(id, user_id, stock_id, type, quantity, price, transacted_at)
-- portfolio(user_id, stock_id, quantity, average_cost)
-- market_data(stock_id, close_price, recorded_at)

-- Highest profit stock for one user (realized + unrealized can be added separately)
SELECT s.ticker,
       s.company_name,
       SUM(p.quantity * (m.close_price - p.average_cost)) AS unrealized_profit
FROM portfolio p
JOIN stocks s ON s.id = p.stock_id
JOIN market_data m ON m.stock_id = p.stock_id
WHERE p.user_id = :user_id
  AND m.recorded_at = (SELECT MAX(m2.recorded_at) FROM market_data m2 WHERE m2.stock_id = p.stock_id)
GROUP BY s.id, s.ticker, s.company_name
ORDER BY unrealized_profit DESC
LIMIT 1;

-- Monthly returns based on month-end portfolio snapshots
WITH month_end AS (
  SELECT DATE_TRUNC('month', recorded_at) AS month,
         SUM(quantity * close_price) AS portfolio_value
  FROM portfolio_value_snapshots
  WHERE user_id = :user_id
  GROUP BY DATE_TRUNC('month', recorded_at)
)
SELECT month,
       portfolio_value,
       portfolio_value / NULLIF(LAG(portfolio_value) OVER (ORDER BY month), 0) - 1 AS monthly_return
FROM month_end
ORDER BY month;

-- Current portfolio value
SELECT p.user_id,
       SUM(p.quantity * latest.close_price) AS portfolio_value
FROM portfolio p
JOIN LATERAL (
  SELECT close_price
  FROM market_data m
  WHERE m.stock_id = p.stock_id
  ORDER BY recorded_at DESC
  LIMIT 1
) latest ON TRUE
WHERE p.user_id = :user_id
GROUP BY p.user_id;

-- Sector-wise investments
SELECT s.sector,
       SUM(p.quantity * latest.close_price) AS market_value,
       ROUND(100.0 * SUM(p.quantity * latest.close_price) /
         NULLIF(SUM(SUM(p.quantity * latest.close_price)) OVER (), 0), 2) AS allocation_percent
FROM portfolio p
JOIN stocks s ON s.id = p.stock_id
JOIN LATERAL (
  SELECT close_price
  FROM market_data m
  WHERE m.stock_id = p.stock_id
  ORDER BY recorded_at DESC
  LIMIT 1
) latest ON TRUE
WHERE p.user_id = :user_id
GROUP BY s.sector
ORDER BY market_value DESC;
