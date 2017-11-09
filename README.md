# kubernetes-nifi-cluster
Kubernetes to create a NiFi cluster.

## Prerequisite

You need kubectl, and a kubernetes cluster. For example, in my environment I have these versions.

```Shell
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"8", GitVersion:"v1.8.0", GitCommit:"6e937839ac04a38cac63e6a7a306c5d035fe7b0a", GitTreeState:"clean", BuildDate:"2017-09-28T22:57:57Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"8", GitVersion:"v1.8.0", GitCommit:"0b9efaeb34a2fc51ff8e4d34ad9bc6375459c4a4", GitTreeState:"dirty", BuildDate:"2017-10-17T15:09:55Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}

$ minikube version
minikube version: v0.22.1

$ docker -v
Docker version 17.09.0-ce, build afdb6d4
```

## How to use

```Shell
# Clone this repository
$ git@github.com:heshoots/kubernetes-nifi-cluster.git
$ cd kubernetes-nifi-cluster

# To start nifi cluster
$ kubectl create -f deployment.yaml

# Wait few minutes for NiFi to unpack nars and the nodes recognized eachother.
# Then access the load balancer url through minikube
$ minikube service --url worker
http://192.168.99.100:31004
http://192.168.99.100:31640

http://192.168.99.100:31004/nifi/

# View pods
$ kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
nifideploy-5f47b59997-ndmm6   1/1       Running   0          1m
nifideploy-5f47b59997-qbgrg   1/1       Running   0          1m
zookeeper                     1/1       Running   0          1m

# View services
$ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                         AGE
kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP                         23d
worker       NodePort    10.0.0.228   <none>        8080:31004/TCP,9001:31640/TCP   9m
zookeeper    NodePort    10.0.0.192   <none>        2181:30542/TCP                  9m

# View logs or container status
$ kubectl log -f nifideploy-5f47b59997-ndmm6
$ kubectl log -f zookeeper
$ docker exec nifideploy-5f47b59997-ndmm6 tail -f logs/nifi-app.log

# Scale number of nodes
$ kubectl scale deployment --replicas=n nifideploy

# Dispose the cluster
$ kubectl delete svc zookeeper
$ kubectl delete svc worker
$ kubectl delete pod zookeeper
$ kubectl delete deployment nifideploy

# To rebuild nifi-node docker image
$ cd nifi-node
$ docker build -t quorauk/nifiworker:v0.0.2
```

## Special thanks

I used [mkobit/nifi](https://github.com/mkobit/docker-nifi) as a base image. Thanks for sharing the image and maintaining it up to date!

I used [ijokarumawak/docker-compose-nifi-cluster](https://github.com/ijokarumawak/docker-compose-nifi-cluster) as a starter and repo template. Very helpful for getting started in understanding nifi clustering

I also found the [guide](https://community.hortonworks.com/articles/68375/nifi-cluster-and-load-balancer.html) useful as well.

## Screen shot

![connected-node](https://raw.githubusercontent.com/ijokarumawak/docker-compose-nifi-cluster/master/images/connected-nodes.png)
