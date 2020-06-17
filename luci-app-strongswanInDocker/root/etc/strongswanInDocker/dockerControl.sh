#!/bin/sh

DOCKER_IMAGE_ID="481894b7280b"
DOCKER_IMAGE_MD5="5d75bbfa30829b5a40d87f86e79c02ba"
DOCKER_CONTAINER_NAME="xqf999_StrongsWan584"

function isImageExist()
{
	local xx=$(docker images | grep $DOCKER_IMAGE_ID | wc -l)
	return $xx
}
#isImageExist
#[ $? -eq 1 ] && echo "Image Exist"

function isContainerExist()
{
	local yy=$(docker ps -a | grep $DOCKER_CONTAINER_NAME | grep $DOCKER_IMAGE_ID | wc -l)
	return $yy
}
#isContainerExist
#[ $? -eq 1 ] && echo "Container Exist"

function isContainerRunning()
{
	local zz=$(docker ps -q --filter name=^/$DOCKER_CONTAINER_NAME$ --filter status=running --filter status=restarting | wc -l)
	return $zz
}
#isContainerRunning
#[ $? -eq 1 ] && echo "isContainerRunning"

CURRENT_CONTAINERID=""
function getContainerId()
{
	local ww=$(docker ps -q -a --filter name=^/$DOCKER_CONTAINER_NAME$)
	CURRENT_CONTAINERID=$ww;
}

###################### Public Functions ######################

function startContainer()
{
	isImageExist
	[ $? -ne 1 ] && return 1
	isContainerRunning
	[ $? -eq 1 ] && return 2
	isContainerExist
	if [ $? -eq 0 ]; then
		docker run -d --restart=always --name $DOCKER_CONTAINER_NAME --privileged -v /etc/strongswanInDocker/ipsec.d:/etc/ipsec.d -p 500:500/udp -p 4500:4500/udp $DOCKER_IMAGE_ID
		return $?
	else
		getContainerId
		docker start $CURRENT_CONTAINERID
		return $?
	fi
}

function stopContainer()
{
	isImageExist
	[ $? -ne 1 ] && return 1
	isContainerRunning
	[ $? -ne 1 ] && return 2
	getContainerId
	docker stop $CURRENT_CONTAINERID
	return $?
}

function clearContainer()
{
	isImageExist
	[ $? -ne 1 ] && return 0
	isContainerRunning
	if [ $? -eq 1 ]; then
		stopContainer
	fi
	docker rm $(docker ps -q --filter name=^/$DOCKER_CONTAINER_NAME$ --filter status=exited --filter status=dead 2>/dev/null)
}

function downloadAndLoadImage()
{
	isImageExist
	[ $? -eq 1 ] && return 0
	mkdir -p /tmp/strongswanInDocker
	curl -SL https://raw.githubusercontent.com/xiaoqingfengATGH/luci-app-ipsecVPNInDocker/master/dockerImage/xiaoqingfeng999-strongswan-5.8.4.7z > /tmp/strongswanInDocker/xiaoqingfeng999-strongswan-5.8.4.7z
	local downloadedMd5=$(md5sum /tmp/strongswanInDocker/xiaoqingfeng999-strongswan-5.8.4.7z | cut -d  ' ' -f 1)
	if [ "$downloadedMd5" != "$DOCKER_IMAGE_MD5" ]; then
		echo Downloaded file check error!
		rm -rf /tmp/strongswanInDocker
		return 1
	fi
	7z x -so /tmp/strongswanInDocker/xiaoqingfeng999-strongswan-5.8.4.7z|docker load
	docker tag $DOCKER_IMAGE_ID xiaoqingfeng999/strongswan:5.8.4
	rm -rf /tmp/strongswanInDocker
}