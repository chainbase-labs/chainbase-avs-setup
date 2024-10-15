#!/bin/sh

if [ -z "$OPERATOR_NAME" ]
then
  echo "\$OPERATOR_NAME variable is empty"
fi

# eval is used instead of envsubst, as prometheus user doesn't have permissions to install envsubst
eval "echo \"$(cat /etc/prometheus/prometheus.yml.example)\"" > /etc/prometheus/prometheus.yml

/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --enable-feature=expand-external-labels