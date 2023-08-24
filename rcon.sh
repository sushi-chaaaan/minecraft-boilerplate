#!/bin/sh
cd "$(dirname "$0")" || exit

mc_rcon() {
    docker compose exec mc rcon-cli "$1"
}

mc_rcon "$@"
