# Linux with CLIs for AWS, Amazon EKS, Kubernetes, and Docker

Linux (Ubuntu) base image with

- `aws`, the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- `eksctl`, the [Amazon EKS CLI](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
- `kubectl`, the [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- `aws-iam-authenticator`, to [authenticate to a Kubernetes cluster using AWS IAM](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- `docker`, the [Docker CE CLI](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Example: run bash in the container:
```
docker run --rm --name aws-eks-kube-docker-cli -it      \
           -e 'AWS_ACCESS_KEY_ID=...'                   \
           -e 'AWS_SECRET_ACCESS_KEY=...'               \
           -e 'AWS_DEFAULT_REGION=...'                  \
           -v /var/run/docker.sock:/var/run/docker.sock \
           integrational/aws-eks-kube-docker-cli:latest
```

and then, in bash, either create a cluster with `eksctl` or find and attach to an existing cluster in the default domain:
```
eksctl get cluster
aws eks update-kubeconfig --name <cluster-name>
kubectl get all
```

Example: execute `./script.sh` in the container:
```
docker run --rm --name aws-eks-kube-docker-cli -t       \
           -e 'AWS_ACCESS_KEY_ID=...'                   \
           -e 'AWS_SECRET_ACCESS_KEY=...'               \
           -e 'AWS_DEFAULT_REGION=...'                  \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(pwd)/script.sh:/script.sh               \
           integrational/aws-eks-kube-docker-cli:latest /script.sh
```

## Details

The **workdir** is `/` and this is also where the container entrypoint script is located.

The container **entrypoint script** configures the AWS CLI with `aws configure` using the values of **environment variables** and so the container must be run with:
```
docker run -e 'AWS_ACCESS_KEY_ID=...'     \
           -e 'AWS_SECRET_ACCESS_KEY=...' \
           -e 'AWS_DEFAULT_REGION=...'    \
           -e 'AWS_DEFAULT_OUTPUT=json'
```
where only `AWS_DEFAULT_OUTPUT` can be omitted and then defaults to `json`.

The entrypoint then **executes** the command or `/bin/bash`.

To list **available Kubernetes clusters** in the chosen default region, run this in the container:
```
eksctl get cluster
```

Before using **kubectl** from within the container against one of these Kubernetes clusters, run this in the container:
```
aws eks update-kubeconfig --name <cluster-name>
```

To use the **docker** CLI from within the container, run the container like this:
```
docker run -v /var/run/docker.sock:/var/run/docker.sock ...
```
