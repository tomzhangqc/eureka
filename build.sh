#!/bin/bash
image_name=$1
if [ -z $image_name ]
then
echo "image_name is null"
exit 1
fi
date=`date +%Y%m%d%H%M%S`
docker build -t $image_name:$date .
if [ $? -eq 0 ]
then
echo "build success"
docker tag $image_name:$date registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
if [ $? -eq 0 ]
then
echo "tag success"
docker push registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
if [ $? -eq 0 ]
then
echo "push success"
docker rmi $image_name:$date
docker rmi registry.cn-hangzhou.aliyuncs.com/ceres-spring/$image_name:$date
else
echo "push error"
fi
else
echo "tag error"
fi
else
echo "build error"
fi
