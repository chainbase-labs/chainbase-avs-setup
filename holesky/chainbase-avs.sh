#!/bin/sh
# path: chainbase-avs.sh

. ./.env

register_chainbase_avs() {
  echo "Registering Chainbase AVS, ECDSA key path: $NODE_ECDSA_KEY_FILE_HOST"
  docker run --env-file .env \
    --rm \
    --volume "${NODE_ECDSA_KEY_FILE_HOST}":"${NODE_ECDSA_KEY_FILE}" \
    --volume "${NODE_LOG_PATH_HOST}":"${NODE_LOG_DIR}":rw \
    "${MAIN_SERVICE_IMAGE}" \
    $1
}

run_chainbase_avs() {
  echo "Running Chainbase AVS"
  docker compose up -d
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
    register_chainbase_avs $1
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
