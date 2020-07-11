#!/bin/bash

SITE=$1
SCRIPTDIR=$(cd `dirname $0` && pwd)
SITE_PATH="$(dirname "$SCRIPTDIR")/apps/sites/$SITE"

echo $SCRIPTDIR
echo $SITE_PATH

DOCKER_CFG="$SITE_PATH/dockerSetting.json"

echo $DOCKER_CFG

# if [ -f "$f" ]; then

function jsonValue() {
    KEY=$1
    #num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed "s/^[ \t]*//"
}


echo $(cat $DOCKER_CFG) | jsonValue port
echo $1
exit 1