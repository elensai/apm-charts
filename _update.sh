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
  rm -rf ./$i/charts/*
  /usr/local/bin/helm dep update $i
  /usr/local/bin/helm package $i
  curl --data-binary "@${i}-0.1.0.tgz" http://192.168.1.244:22317/api/charts
  echo "\n"
done < list.md

rm -f apm*tgz

# git add . && git commit -m "$commit" && git push origin master
