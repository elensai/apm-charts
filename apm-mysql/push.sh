#! /bin/bash

git add .; git commit -m 'fix';

helm package .

curl -XDELETE http://192.168.1.244:22317/api/charts/mysql57/0.1.0

curl --data-binary "@mysql57-0.1.0.tgz" http://192.168.1.244:22317/api/charts

cd ../test-nginx-chart

rm -f charts/mysql57-0.1.0.tgz

helm dependency update 

version='version: '`date | awk '{print $4}'| sed -n 's/:/./pg'`

sed -i "17,/version:/c nnnnnnn$version" Chart.yaml

sed -i "s/nnnnnnn/\n/" Chart.yaml

sed -i '15,18s/\.0/\.7/g' Chart.yaml

sed -i '15,18s/: 0/: /g' Chart.yaml

git add .; git commit -m 'fix';

cd ../test-charts

git subtree pull --prefix=test-nginx-chart sub-nginx master --squash

git push origin master