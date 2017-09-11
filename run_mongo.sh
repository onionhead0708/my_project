#!/bin/sh

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`
CURRENT_PROJECT_HOME=`cd "$PRGDIR/." >/dev/null; pwd`

if [ -r "$CURRENT_PROJECT_HOME/setenv.sh" ]; then
  . "$CURRENT_PROJECT_HOME/setenv.sh"
fi

# ref: https://hub.docker.com/_/mongo/
DOCKER_IMG_NAME=mongo
DOCKER_IMG_VER=3.4.8

# Set MONGO_DATA if not set
[ -z "$DOCKER_CONTAINER_NAME" ] && DOCKER_CONTAINER_NAME=mongo
[ -z "$MONGO_DATA" ] && MONGO_DATA=$CURRENT_PROJECT_HOME/mongo_data
[ -z "$MONGO_PORT" ] && MONGO_PORT=27017

DOCKER_CONTAINER_ID=$(docker ps | grep "$DOCKER_CONTAINER_NAME *$" | awk '{print $1}')
if [ "$DOCKER_CONTAINER_ID" != "" ]; then
    echo "ERROR: There has been already an existing container running with name $DOCKER_CONTAINER_NAME"
    echo "Following command can stop the current running container:"
    echo "    docker stop $DOCKER_CONTAINER_NAME"
    exit 1
fi

DOCKER_CONTAINER_ID=$(docker ps -a | grep "$DOCKER_CONTAINER_NAME *$" | grep "Exit" | awk '{print $1}')
if [ "$DOCKER_CONTAINER_ID" != "" ]; then
    echo "Remove the stopped container:"
    docker rm $DOCKER_CONTAINER_NAME
fi

echo "Run the container: $DOCKER_CONTAINER_NAME"

docker run \
-d --name=$DOCKER_CONTAINER_NAME \
-p $MONGO_PORT:27017 \
-v $MONGO_DATA:/data/db \
$DOCKER_IMG_NAME:$DOCKER_IMG_VER
