#!/bin/bash

PROFILE=$1

export PROFILE=$PROFILE

docker compose build
docker compose up --abort-on-container-exit --exit-code-from benchmark
EXIT_CODE=$?
docker compose down

echo "Benchmark exit code for profile ${PROFILE}: $EXIT_CODE"
exit $EXIT_CODE
