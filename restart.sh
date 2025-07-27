#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DAEMON_NAME=$(ls ${SCRIPT_DIR}/*.py)

pkill -f "python $SCRIPT_DIR/$DAEMON_NAME"
