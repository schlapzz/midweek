#!/bin/bash

echo "create git-clone task"
oc create -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml

echo "create buildah build task"
oc create -f tasks/buildah-build.yaml

echo "create buildah push task"
oc create -f tasks/buildah-push.yaml

