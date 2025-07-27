#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}"  )" &> /dev/null && pwd  )
DAEMON_NAME=$(ls ${SCRIPT_DIR}/*.py)

rm /service/$DAEMON_NAME
pkill -f "python $SCRIPT_DIR/$DAEMON_NAME"
DAEMON_NAME=${SCRIPT_DIR##*/}
pkill -f "supervise $DAEMON_NAME"
chmod a-x $SCRIPT_DIR/service/run
$SCRIPT_DIR/restart.sh
