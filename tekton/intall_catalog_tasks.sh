#!/bin/bash

echo "create git-clone task"
oc create -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml

echo "create buildah & trivy task"
oc create -f build-scan-push-task.yaml

echo "create test pipeline"
oc create -f pipeline.yaml

echo "create docker registry secret"
oc create secret docker-registry \
    --docker-server=docker.io \
    --docker-username=schlapzz \
    --docker-password=${DOCKER_PASSWORD} \
    --docker-email=schlatter@puzzle.ch \
    regcred

echo "link regcred"
oc secrets link pipeline regcred