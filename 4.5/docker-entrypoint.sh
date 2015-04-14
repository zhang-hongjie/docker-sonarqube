#!/bin/bash -e

# Disbale update center
sed -i 's|#sonar.updatecenter.activate=true|sonar.updatecenter.activate=false|g' ${SONARQUBE_HOME}/conf/sonar.properties

if [ -d /docker-entrypoint-init.d ]; then
  for f in /docker-entrypoint-init.d/*.sh; do
    [ -f "$f" ] && . "$f"
  done
fi

function start() {
  set +e
  ${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh start
  tail -f ${SONARQUBE_HOME}/logs/sonar.log
}

function help() {
  echo "Available options:"
  echo " start          - Starts the server (default)"
  echo " help           - Displays the help"
  echo " [command]      - Execute the specified linux command eg. bash."
}

case "$1" in
  start)
    start
    ;;
  help)
    help
    ;;
  *)
    if [ -x $1 ]; then
      $1
    else
      prog=$(which $1)
      if [ -n "${prog}" ] ; then
        shift 1
        $prog $@
      else
        help
      fi
    fi
    ;;
esac

exit 0