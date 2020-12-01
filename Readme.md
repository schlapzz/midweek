Tekton Trivy Security Pipeline
===

This is an example pipeline for a secure Docker image build with Buildah and Trivy. Compared to other container security scanner tools, Trivy is able to scan the container from a local filesystem. There is no need to push a potentially insecure image to an registry before scanning.

The tekton Task contains three steps
* Build docker image with buildah and push it to the filesystem
* Scan image with Trivy
* Push image to registry with buildah

## Installation

```
# Create git-clone task 
oc create -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml

#create buildah & trivy task
oc create -f build-scan-push-task.yaml

#create test pipeline
oc create -f pipeline.yaml


# For private registries
#create docker registry secret
oc create secret docker-registry \
    --docker-server=docker.io \
    --docker-username=schlapzz \
    --docker-password=<DOCKER_PASSWORD> \
    --docker-email=schlatter@puzzle.ch \
    regcred

# link docker secret to service account
oc secrets link pipeline regcred


# for private repositories
oc create secret generic git-secret \
    --from-file=ssh-privatekey=<path/to/ssh/private/key> \
    --type=kubernetes.io/ssh-auth

# link git ssh secret to service account
oc secrets link pipeline git-secret

```


## Task Params


### Build
The full list of the task parameter is specified in the `tekton/build-scan-and-push-task.yaml`

```
    - description: Reference of the image buildah will produce.
      name: IMAGE
      type: string    
    - default: ./Dockerfile
      description: Path to the Dockerfile to build.
      name: DOCKERFILE
      type: string
    - default: .
      description: Path to the directory to use as context.
      name: CONTEXT
      type: string
    - default: '1'
      description: 'Fail pipeline when security check is failing. (1 = fail, 0 = pass)'
      name: FAIL_ON_SCAN
      type: string
```


### Git Clone
```
url 'https://github.com/schlapzz/insecure-node-app.git'
    - name: revision
        value: master
    - name: submodules
        value: 'true'
    - name: depth
        value: '1'
    - name: sslVerify
        value: 'true'
    - name: deleteExisting
        value: 'true'
```

## Prequisites


