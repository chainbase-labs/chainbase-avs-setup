#!/bin/sh
# path: chainbase-avs.sh

. ./.env

register_chainbase_avs() {
  echo "Registering Chainbase AVS, ECDSA key path: $NODE_ECDSA_KEY_FILE_PATH ,BLS key path: $NODE_BLS_KEY_FILE_PATH"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "register-operator-with-avs"
}

deregister_chainbase_avs() {
  echo "Deregistering Chainbase AVS, ECDSA key path: $NODE_ECDSA_KEY_FILE_PATH ,BLS key path: $NODE_BLS_KEY_FILE_PATH"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "deregister-operator-with-avs"
}

change_run_permission() {
  chmod +x ./monitor-config/prometheus/run.sh
}

run_manuscript_node() {
  echo "Running Chainbase AVS"
  docker compose up -d
}

stop_manuscript_node() {
  echo "Stopped Chainbase AVS"
  docker compose down
}

test_manuscript_node() {
  echo "Testing manuscript node"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    --volume "/var/run/docker.sock:/var/run/docker.sock"\
    --network "holesky_avs_network" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "test-manuscript-node-task"
}

update_node_socket() {
  echo "Updating manuscript node socket"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "update-operator-socket"
}

stake_c_tokens() {
  if [ -z "$1" ]; then
      echo "Error: Amount is required. Please provide the amount to stake."
      return 1
  fi
  amount="$1"
  echo "Stake C tokens into staking contract. Operator address: $OPERATOR_ADDRESS ,C token amount: $amount"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "stake-into-staking" --amount "$amount"
}

unstake_c_tokens() {
  echo "Unstake C tokens from staking contract. Operator address: $OPERATOR_ADDRESS"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "unstake-from-staking"
}

withdraw_c_tokens() {
  echo "Withdraw C tokens from staking contract. Operator address: $OPERATOR_ADDRESS"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_PATH}":"/app/node.ecdsa.key.json" \
    --volume "${NODE_BLS_KEY_FILE_PATH}":"/app/node.bls.key.json" \
    --volume "./node.yaml":"/app/node.yaml" \
    "repository.chainbase.com/network/chainbase-cli:v0.2.9" \
    --config /app/node.yaml "withdraw-from-staking"
}

update_node_version() {
  echo "Updating manuscript node version"
  git  pull origin main
}

print_help() {
  echo "Usage: $0 {register|deregister|run|stop|test|socket|update|stake|unstake|withdraw|help}"
  echo "Commands:"
  echo "  register      Register the Chainbase AVS"
  echo "  deregister    Deregister the Chainbase AVS"
  echo "  run           Run Chainbase AVS manuscript node"
  echo "  stop          Stop Chainbase AVS manuscript node"
  echo "  test          Run test task on Chainbase AVS manuscript node"
  echo "  socket        Update manuscript node socket on chain"
  echo "  update        Update manuscript node version"
  echo "  stake         Stake C tokens into staking contract"
  echo "  unstake       Unstake C tokens from staking contract"
  echo "  withdraw      Withdraw C tokens from staking contract"
  echo "  help          Display this help message"
}

case "$1" in
  register)
    register_chainbase_avs
    ;;
  deregister)
    deregister_chainbase_avs
    ;;
  run)
    change_run_permission
    run_manuscript_node
    ;;
  stop)
    stop_manuscript_node
    ;;
  test)
    test_manuscript_node
    ;;
  socket)
    update_node_socket
    ;;
  update)
    update_node_version
    ;;
  stake)
    stake_c_tokens "$2"
    ;;
  unstake)
    unstake_c_tokens
    ;;
  withdraw)
    withdraw_c_tokens
    ;;
  help)
    print_help
    ;;
  *)
    echo "Invalid command"
    print_help
    ;;
esac
