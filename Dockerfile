FROM ubuntu:18.04
MAINTAINER gerald@integrational.eu

#
# This Dockerfile prioritizes clarity over efficiency by not merging all RUN commands.
#
# The container entrypoint configures the AWS CLI using environment variables and so the container must be run with:
#   docker run -e 'AWS_ACCESS_KEY_ID=...'     \
#              -e 'AWS_SECRET_ACCESS_KEY=...' \
#              -e 'AWS_DEFAULT_REGION=...'    \
#              -e 'AWS_DEFAULT_OUTPUT=json'
# where only AWS_DEFAULT_OUTPUT can be omitted and then defaults to json.
#
# To list available Kubernetes clusters in the chosen default region, run this in the container:
#   eksctl get cluster
#
# To use kubectl from within the container against one of these Kubernetes clusters, run this in the container:
#   aws eks update-kubeconfig --name <cluster-name>
#
# To use the docker CLI from within the container, run the container like this:
#   docker run -v /var/run/docker.sock:/var/run/docker.sock ...
#

WORKDIR /tmp

# Install basic set of packages needed in the following
RUN apt-get update                             \
 && apt-get install -y --no-install-recommends \
            curl unzip groff ca-certificates apt-transport-https gnupg-agent software-properties-common less

# Either: Install latest version of AWS CLI version 1
RUN apt-get install -y python3 python3-pip \
 && pip3 install awscli --upgrade --system

# Or: Install latest version of AWS CLI version 2
#RUN curl --silent "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
# && unzip -q awscliv2.zip                                                                             \
# && ./aws/install

# Install latest version of eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C . \
 && mv ./eksctl /usr/local/bin/

# Either: Install latest version of kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -                                 \
 && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
 && apt-get update && apt-get install -y kubectl

# Or: Install a specific version of kubectl
#RUN curl --silent https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl -o kubectl \
# && chmod +x ./kubectl                                                                                               \
# && mv ./kubectl /usr/local/bin/

# Install a specific version of aws-iam-authenticator
RUN curl --silent https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator -o aws-iam-authenticator \
 && chmod +x ./aws-iam-authenticator                                                                                                             \
 && mv ./aws-iam-authenticator /usr/local/bin/

# Install latest stable version of Docker CE CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -                                  \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
 && apt-get update && apt-get install -y docker-ce-cli

WORKDIR    /
ADD        entrypoint.sh ./
ENTRYPOINT ["./entrypoint.sh"]
CMD        ["/bin/bash"]
