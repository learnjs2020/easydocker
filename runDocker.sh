#!/bin/bash

function jsonValue() {
    KEY=$1
    #num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed "s/^[ \t]*//"
}


SITE=$1
SCRIPTDIR=$(cd `dirname $0` && pwd)
SITE_PATH="$SCRIPTDIR/apps/sites/$SITE"

echo $SCRIPTDIR
echo $SITE_PATH
 
cd $SITE_PATH &> /dev/null && git pull &> /dev/null && cd $SCRIPTDIR &> /dev/null

DOCKER_CFG="$SITE_PATH/dockerSetting.json"

echo $DOCKER_CFG

if [ -f "$DOCKER_CFG" ]; then
    echo $(cat $DOCKER_CFG) | jsonValue port
    echo $(cat $DOCKER_CFG) | jsonValue ip
    echo $1
fi
