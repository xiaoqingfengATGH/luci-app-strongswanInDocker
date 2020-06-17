#!/bin/sh

. ./dockerControl.sh

isImageExist
[ $? -ne 1 ] && return 1

isContainerExist
[ $? -ne 1 ] && return 2

isContainerRunning
if [ $? -eq 1 ]; then
	return 0
else
	return 3
fi