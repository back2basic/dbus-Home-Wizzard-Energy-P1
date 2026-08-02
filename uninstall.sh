#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}"  )" &> /dev/null && pwd  )
DAEMON_NAME=$(ls ${SCRIPT_DIR}/*.py)
RC_FILE_PATH=/data/rc.local
STARTUP=$SCRIPT_DIR/install.sh

pkill -f "python $SCRIPT_DIR/$DAEMON_NAME"
DAEMON_NAME=${SCRIPT_DIR##*/}
rm /service/$DAEMON_NAME
pkill -f "supervise $DAEMON_NAME"
chmod a-x $SCRIPT_DIR/service/run
$SCRIPT_DIR/restart.sh

sed -i "\~$STARTUP~d" $RC_FILE_PATH
