CREATE DATABASE manuscript_node;

\c manuscript_node;

CREATE TABLE IF NOT EXISTS pow_results (
    chain VARCHAR(255),
    block_number BIGINT,
    block_hash VARCHAR(255),
    pow_result VARCHAR(255),
    insert_at TIMESTAMP(3),
    difficulty SMALLINT,
    task_index BIGINT,
    PRIMARY KEY (chain, block_number)
);
CREATE INDEX idx_pow_results_chain_block_number ON pow_results (chain, block_number);
CREATE INDEX idx_pow_results_task_index ON pow_results (task_index);