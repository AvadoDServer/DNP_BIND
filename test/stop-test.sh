#!/bin/sh
# Builds the bind image, starts it, checks it answers, then stops it and
# expects a clean exit within 3 s. A shell PID 1 ignores SIGTERM, which made
# every bind update wait the full docker stop timeout (180 s on AVADO).
# Usage: sh test/stop-test.sh   (needs Docker)
set -e
cd "$(dirname "$0")/.."
IMG=bind-stop-test:local
NAME=bind-stop-test
docker build -q -t $IMG build >/dev/null
docker rm -f $NAME >/dev/null 2>&1 || true
docker run -d --name $NAME -e EXTRA_OPTS= $IMG >/dev/null
sleep 5
ANSWER=$(docker exec $NAME dig +short +time=3 @127.0.0.1 my.ava.do || true)
echo "my.ava.do -> ${ANSWER:-<no answer>}"
START=$(date +%s)
docker stop -t 8 $NAME >/dev/null
TOOK=$(( $(date +%s) - START ))
EXIT=$(docker inspect -f '{{.State.ExitCode}}' $NAME)
docker rm -f $NAME >/dev/null 2>&1
echo "stop took ${TOOK}s, exit code ${EXIT}"
if [ -n "$ANSWER" ] && [ "$EXIT" = "0" ] && [ "$TOOK" -le 3 ]; then echo PASS; else echo "FAIL: expected an answer for my.ava.do and exit 0 within 3 s"; exit 1; fi
