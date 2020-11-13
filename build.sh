#!/bin/bash
image_name=$1
port=$2
APP_OPTS='$APP_OPTS'
if [ -z $image_name ]
then
echo "image_name is null"
exit 1
fi
if [ -z $port ]
then
echo "port is null"
exit 1
fi
cat > Dockerfile <<EOF
FROM openjdk:8-jdk-alpine
COPY ./target/$image_name.jar $image_name.jar
EXPOSE $port
ENV APP_OPTS=""
ENTRYPOINT ["sh", "-c", "java -jar /$image_name.jar $APP_OPTS"]
EOF
date=`date +%Y%m%d%H%M%S`
/usr/local/bin/docker build -t registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date .
if [ $? -eq 0 ]
then
rm -f Dockerfile
echo "build success"
/usr/local/bin/docker push registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
if [ $? -eq 0 ]
then
echo "push success"
/usr/local/bin/docker rmi registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
/usr/local/bin/kubectl set image deployment/$image_name $image_name=registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date -n spring-cloud
else
echo "push error"
fi
else
echo "build error"
fi