#!/bin/bash 
set -euo pipefail

# X Config
if [ -f /tmp/.X99-lock ]; then
  rm -rf /tmp/.X99*
fi
export XVFB_WHD=${XVFB_WHD:-1280x720x16}
export DISPLAY=:99
echo Starting X
Xvfb :99 -ac -screen 0 $XVFB_WHD -nolisten tcp &




echo "$1"
cd /myagent
export USER_ID=user

case "$1" in
  install)
	rm -rf /var/run/dbus/*
    service dbus start
    gosu $USER_ID ./run-agent.sh;
    ;;
  remove)
    gosu $USER_ID ./config.sh --unattended --acceptteeeula --replace --url ${TFSURL} --auth PAT --token ${TFSTOKEN} --pool ${TFSPOOL} --agent ${TFSAGENT}
    gosu $USER_ID ./config.sh remove --auth PAT --token ${TFSTOKEN}
    ;;
  *)
    echo "none of the above"
    exec "$@"
esac