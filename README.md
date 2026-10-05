# TradeDesk — Stock Portfolio Management System

A responsive, learning-focused stock portfolio dashboard built as a static frontend. It includes portfolio overview, holdings, transactions, watchlist, company research, dividend history, risk analysis, and account preferences.

## Run locally

No build step is required. Open `index.html` in a browser, or serve the directory with any static server:

```bash
python3 -m http.server 8000
```

Then visit `http://localhost:8000`.

## Included features

- Overview dashboard with portfolio value, daily change, total return, risk score, performance chart, sector allocation, watchlist, and recent activity.
- Portfolio holdings table with market value, average cost, and return calculations.
- Demo buy/sell transaction modal and transaction history.
- Watchlist cards with simulated price charts.
- Company research page with a stock snapshot and price performance chart.
- Dividend income summary and payment history.
- Risk analysis with concentration, volatility, and liquidity education.
- Responsive sidebar navigation and mobile menu.
- Accessible labels, semantic sections, responsive tables, and keyboard-friendly controls.

All market numbers are simulated demo data. This project does not place real trades.

## Suggested data model

The UI is designed around these entities:

- `Users`: account identity, email, base currency, preferences.
- `Stocks`: ticker, company name, exchange, sector, industry.
- `Transactions`: user, stock, transaction type, quantity, price, transaction date.
- `Portfolio`: user, stock, quantity, average cost, invested value.
- `Watchlist`: user, stock, created date.
- `MarketData`: stock, timestamp, open/high/low/close, volume, dividend.

## Connecting a real stock API later

Replace the arrays at the top of `app.js` (`holdings` and `watch`) with calls to a backend service. Keep API keys server-side, normalize provider responses into the fields currently used by the rendering functions, and refresh market data through a backend endpoint rather than exposing provider credentials in this static frontend.

A production implementation should add authentication, server-side order validation, a database, audit logging, rate-limit handling, and an explicit paper-trading mode before connecting brokerage APIs.

## SQL examples

See [`sql/queries.sql`](sql/queries.sql) for queries covering highest-profit stock, monthly returns, portfolio value, and sector-wise investments.
