#! /bin/bash

echo $1
commit=$1
if [ -z "$1" ];then
  commit='fix: no commit'
  echo "default commit"
fi


list=`find . -name 'apm-*' -type d ! -empty | awk -F/ '{print $2}'`
# echo "$list" > list.md

while read i 
do
  echo "$i";
  curl -XDELETE http://192.168.1.244:22317/api/charts/$i/0.1.0
  echo "\n"
done < list.md

while read i 
do
  echo "$i";
  helm dep update $i
  helm package $i
  curl --data-binary "@${i}-0.1.0.tgz" http://192.168.1.244:22317/api/charts
  echo "\n"
done < list.md

# for i in $list
# do
#   echo "$i";
#   curl -XDELETE http://192.168.1.244:22317/api/charts/$i/0.1.0
#   echo "\n"
# done;

# for i in $list
# do
#   helm dep update $i
#   helm package $i
#   curl --data-binary "@${i}-0.1.0.tgz" http://192.168.1.244:22317/api/charts
# done;

helm dep update app-zhi

git add . ; git commit -m "$commit"; git push origin master

# ------

# git add .; git commit -m 'fix'; 

# helm package .

# curl -XDELETE http://192.168.1.244:22317/api/charts/mysql57/0.1.0

# curl --data-binary "@mysql57-0.1.0.tgz" http://192.168.1.244:22317/api/charts

# cd ../test-nginx-chart

# rm -f charts/mysql57-0.1.0.tgz

# helm dependency update 

# version='version: '`date | awk '{print $4}'| sed -n 's/:/./pg'`

# git add .; git commit -m 'fix';

# cd ../test-charts

# git subtree pull --prefix=test-nginx-chart sub-nginx master --squash

# git push origin master