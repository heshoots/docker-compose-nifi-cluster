#!/bin/sh

fqhn=$(hostname -i | sed -e "s/\./-/g").default.pod.cluster.local

sed -i -e \
  "s|^nifi.web.http.host=.*$|nifi.web.http.host=$fqhn|" \
  conf/nifi.properties
sed -i -e \
  "s|^nifi.cluster.node.address=.*$|nifi.cluster.node.address=$fqhn|" \
  conf/nifi.properties
sed -i -e \
  "s|^nifi.remote.input.host=.*$|nifi.remote.input.host=$fqhn|" \
  conf/nifi.properties

bin/nifi.sh run
