#!/bin/sh

SCRIPT_BASE=/etc/strongswanInDocker

. /etc/strongswanInDocker/downloadCommon.sh

isDownloadRunning=$(/etc/strongswanInDocker/getDownloadState.sh)
if [ $isDownloadRunning -eq 1 ]; then
	echo 1
	exit 1
fi
nohup $SCRIPT_BASE/doDownload.sh > /dev/null 2>&1 & echo $! > $DOWNLOAD_PID &
echo 0
exit 0