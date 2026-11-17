CREATE TABLE accounts (
	id				BIGSERIAL PRIMARY KEY,
	name			TEXT NOT NULL,
	currency		CHAR(3) NOT NULL DEFAULT 'BRL',
	allow_negative	BOOLEAN NOT NULL DEFAULT FALSE,
	created_at		TIMESTAMPZ NOT NULL DEFAULT now()
);

CREATE TABLE transactions (
	id				BIGSERIAL PRIMARY KEY,
	idempotency_key	TEXT NOT NULL UNIQUE,
	request_hash	TEXT NOT NULL,
	description		TEXT,
	created_at		TIMESTAMPZ NOT NULL DEFAULT now()
);

CREATE TABLE entries (
	id				BIGSERIAL PRIMARY KEY,
	transaction_id	BIGINT NOT NULL REFERENCES transactions(id),
	account_id		BIGINT NOT NULL REFERENCES accounts(id),
	amount			BIGINT NOT NULL CHECK (amount <> 0),
	created_at		TIMESTAMPZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_entries_account ON entries(account_id, id);
CREATE INDEX idx_entries_tx		 ON entries(transaction_id);

CREATE TABLE account_balances (
	account_id	BIGINT PRIMARY KEY REFERENCES accounts(id),
	balance		BIGINT NOT NULL DEFAULT 0,
	version		BIGINT NOT NULL DEFAULT 0
);

