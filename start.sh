#!/bin/sh
cd "$(dirname "$0")" || exit

# start server
docker compose -f compose.yml up -d --build
