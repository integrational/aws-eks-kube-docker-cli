# CLIs for AWS EKS, Kubernetes, and Docker

Linux (Ubuntu) base image with

- `aws`, the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- `eksctl`, the [AWS EKS CLI](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
- `kubectl`, the [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- `aws-iam-authenticator`, to [authenticate to a Kubernetes cluster using AWS IAM](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- `docker`, the [Docker CE CLI](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

Example run launching bash in the container:
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

## Details

The container entrypoint configures the AWS CLI using environment variables and so the container must be run with:
```
docker run -e 'AWS_ACCESS_KEY_ID=...'     \
           -e 'AWS_SECRET_ACCESS_KEY=...' \
           -e 'AWS_DEFAULT_REGION=...'    \
           -e 'AWS_DEFAULT_OUTPUT=json'
```
where only `AWS_DEFAULT_OUTPUT` can be omitted and then defaults to `json`.

To list available Kubernetes clusters in the chosen default region, run this in the container:
```
eksctl get cluster
```

To use kubectl from within the container against one of these Kubernetes clusters, run this in the container:
```
aws eks update-kubeconfig --name <cluster-name>
```

To use the docker CLI from within the container, run the container like this:
```
docker run -v /var/run/docker.sock:/var/run/docker.sock ...
```
