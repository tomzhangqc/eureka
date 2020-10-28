#!/bin/bash
image_name=$1
if [ -z $image_name ]
then
echo "image_name is null"
exit 1
fi
date=`date +%Y%m%d%H%M%S`
docker build -t registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date .
if [ $? -eq 0 ]
then
echo "build success"
docker push registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
if [ $? -eq 0 ]
then
echo "push success"
docker rmi registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
kubectl set image deployment/$image_name $image_name=registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date -n spring-cloud
else
echo "push error"
fi
else
echo "build error"
fi
