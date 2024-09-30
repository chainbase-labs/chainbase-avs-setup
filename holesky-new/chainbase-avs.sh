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
    "${CLI_IMAGE}" \
    --config /app/node.yaml "register-operator-with-avs"
}

run_chainbase_avs() {
  echo "Running Chainbase AVS"
  docker-compose up -d
}

stop_chainbase_avs() {
  echo "Stopped Chainbase AVS"
  docker compose down
}

print_help() {
  echo "Usage: $0 {register|run|stop|help}"
  echo "Commands:"
  echo "  register    Register the Chainbase AVS"
  echo "  run         Run the Chainbase AVS"
  echo "  stop        Stop the Chainbase AVS"
  echo "  help        Display this help message"
}

case "$1" in
  register)
    register_chainbase_avs
    ;;
  run)
    run_chainbase_avs
    ;;
  stop)
    stop_chainbase_avs
    ;;
  help)
    print_help
    ;;
  *)
    echo "Invalid command"
    print_help
    ;;
esac
