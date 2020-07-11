#!/bin/bash

SCRIPTDIR=$(cd `dirname $0` && pwd)
ROOT_PATH="$(dirname "$SCRIPTDIR")"

CRON_PATH=$SCRIPTDIR/_cron
TMP_PATH=$SCRIPTDIR/_tmp

mkdir -p $CRON_PATH
mkdir -p $TMP_PATH

markfile=$SCRIPTDIR/mark.data

# --- clean longer time task -----
for file in $(find $markfile -not -newermt '-120 seconds' 2>&1) ;do
  if [ -f "$markfile" ]; then
    vfn=$(<$markfile)
    cmda="rm -fr $vfn && pkill -f $vfn > /dev/null && rm -fr $markfile >/dev/null 2>&1"
    eval "$cmda"
  fi
done

for f in "$CRON_PATH"/*; do

  if [ -f "$markfile" ]; then
    break;
  fi

  if [ -f "$f" ]; then

    execfn=$TMP_PATH/SH_$(basename $f)_$(date +%s%N).sh
    echo $execfn > $markfile

    cmdd="mv $f $execfn && sh $execfn $DOCKERCMD && rm -fr $execfn && rm -fr $markfile"
    echo "-- Ran $f -- at $(date +"%m/%d/%Y %H:%M:%S")"
    eval "$cmdd"
    echo "-- done $f -- at $(date +"%m/%d/%Y %H:%M:%S")"
  else
    exit 1
  fi
done
