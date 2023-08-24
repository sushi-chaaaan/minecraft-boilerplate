#!/bin/bash
cd "$(dirname "$0")" || exit

mc_rcon() {
    docker compose exec mc rcon-cli "$1"
}

server_announce() {
    mc_rcon "tellraw @a [\"[\",{\"text\":\"Server\",\"bold\":true,\"color\":\"red\"},\"] ${1}\"]"
}

abort() {
    status=$?
    echo 'stop aborted!'
    server_announce 'サーバーの停止をキャンセルしました。'
    server_announce 'Server stop has been canceled.'
    exit $status
}

shutdown_now() {
    # stop the server.
    mc_rcon 'lp export backup'
    mc_rcon 'stop'
    docker compose down
}

shutdown_15sec() {
    # 15 seconds ago
    server_announce 'まもなくサーバーを停止します。'
    server_announce 'The server will be down soon.'
    sleep 15s
    shutdown_now
}

shutdown_1min() {
    # 1 minute ago
    server_announce '1分後にサーバーを停止します。'
    server_announce 'The server will stop after 1 minute.'
    sleep 45s
    shutdown_15sec
}

shudown_5min() {
    # stop announcement
    # 5 minutes ago
    server_announce '5分後にサーバーを停止します。'
    server_announce 'The server will stop after 5 minutes.'
    sleep 4m
    shutdown_1min
}

# if --dev is passed, server will shutdown in 1 minute
OPT=0
while (($# > 0)); do
    case $1 in
    # ...
    --dev)
        OPT=1
        ;;
        # ...
    # ...
    --now)
        OPT=2
        ;;
        # ...
    -*)
        echo "Illegal option -- '${1//^-*/}'." 1>&2
        exit 1
        # ...
        ;;
    esac
    shift
done

trap 'abort' 1 2 3 15

if [ $OPT == 1 ]; then
    shutdown_1min
elif [ $OPT == 2 ]; then
    shutdown_15sec
else
    shudown_5min
fi
