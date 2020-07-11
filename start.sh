#!/bin/bash
SCRIPTDIR=$(cd `dirname $0` && pwd)
ROOT_PATH="$(dirname "$SCRIPTDIR")"

markfile=$SCRIPTDIR/mark.data
TMP_PATH=$SCRIPTDIR/_tmp
rm -fr $TMP_PATH
rm -fr $markfile

pkill -f "sh $TMP_PATH" > /dev/null
pkill -f "sh cron.sh" > /dev/null
sts=1
cntSts=0

DOCKERCMD=$(command -v docker)

if [[ $DOCKERCMD == "" ]]; then
    echo "\nDocker should be installed!"
    exit 1
fi

echo "Loading ...\c"
until [[ $sts == 0  ||  $cntSts -gt 60 ]]
do 
    docker_state=$($DOCKERCMD ps -q &> /dev/null)
    status=$?
    sts=$status
    cntSts=$(($cntSts+1))

    if [ $sts != 0 ] ; then
          echo "..\c"
          sleep 0.5
    fi
done
if [[ $cntSts -gt 50  ]]; then
    echo "\nDocker running is required!"
    exit 1
fi

echo "\nloading cron job"
# sh cron.sh > /dev/null &
stsCron=1
until [[ $stsCron == 0 ]]
do 
    if [ $stsCron != 0 ] ; then
        sh cron.sh &
    fi
    sleep 1
done



