#!/bin/bash

talhelper genconfig

if [[ "$1" == "init" ]]; then
   INSECURE="--insecure"
fi

for i in {1..3}
do
   NAME="elite$i"
   ENDPOINT="192.168.1.5$i"
   echo -n "$NAME - $ENDPOINT: "
   talosctl -n $ENDPOINT apply-config $INSECURE -f clusterconfig/k8s-$NAME*.yaml
done

if [[ "$1" == "init" ]]; then
   sleep 2
   talosctl -n $ENDPOINT bootstrap
fi

for i in {4..6}
do
   NAME="elite$i"
   ENDPOINT="192.168.1.5$i"
   echo -n "$NAME - $ENDPOINT: "
   talosctl -n $ENDPOINT apply-config $INSECURE -f clusterconfig/k8s-$NAME*.yaml
done

talosctl -n 192.168.1.41 apply-config $INSECURE -f clusterconfig/k8s-elitepi1*.yaml
