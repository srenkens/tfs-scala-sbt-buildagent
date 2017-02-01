#!/bin/bash 
echo "$1"

cd /myagent

export USER_ID=user

case "$1" in
  install)
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