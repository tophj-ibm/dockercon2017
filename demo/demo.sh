#!/bin/bash

# look around the dockerfile, which just creates a simple go server and displays an image, the image it 
# displays will be different on each architecture
vim ../Dockerfile.x86_64

# then build the image
docker build -t tophj/x86_64-demo -f Dockerfile.x86_64

# push it like we do any other image (we won't here because, demo gods)
docker push tophj/x86_64-demo

# now, we can create a manifest list with this image
docker manifest create tophj/dockercon-demo tophj/x86_64-demo tophj/armhf-demo tophj/aarch64-demo tophj/ppc64e-demo tophj/s390x-demo

# now we will annotate the arm nodes, just because
docker manifest annotate tophj/dockercon-demo tophj/armhf-demo --os linux --arch arm
docker manifest annotate tophj/dockercon-demo tophj/aarch64-demo --os linux --arch arm

# now push!
docker manifest push tophj/dockercon-demo

# SWARM STUFF

# let's start a visualizer and point it to 8081
docker run -it -d -p 8081:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer

# just to show what we have already in the swarm
docker node ls

# show that there are no jobs running
docker service ls

# create a service, forward the ports (8082 because load balancing magic), make it global, and give it our manifest image tophj/dockercon-demo
docker service create --name dockercon-demo --mode global --publish 8082:8080 tophj/dockercon-demo

# make sure everything is running, can also view the visualizer here
docker service ps dockercon-demo

# then check out some gophers! Please don't go here all at once :) Load balancer may have been written poorly
reborn.tophj.us
reborn.tophj.us:8081
