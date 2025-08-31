FROM registry.access.redhat.com/ubi9/ubi:latest

ARG OC_VERSION=4.18.13
ARG YQ_VERSION=v4.47.1
ARG NODEJS_VERSION=22
ARG AWXKIT_VERSION=24.6.1
ARG RELEASE_PLEASE_VERSION=17.1.2

# Enable NodeJS module stream
RUN dnf module enable -y nodejs:${NODEJS_VERSION}

# Install packages via dnf
RUN dnf install -y jq tar git \
      nodejs npm \
      python3 python3-pip \
    && dnf clean all

# Install python packages
RUN pip3 install --upgrade pip \
    && pip3 install --upgrade awxkit==${AWXKIT_VERSION} --root-user-action=ignore

# Install nodejs packages
RUN npm install -g ajv-cli ajv-formats release-please@${RELEASE_PLEASE_VERSION}

# Install binary packages
RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \ 
    && chmod +x /usr/local/bin/yq
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh \
    && helm plugin install --version master https://github.com/sonatype-nexus-community/helm-nexus-push.git
RUN curl -fsSL -o openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz \
    && tar -xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && chmod +x /usr/local/bin/oc \
    && chmod +x /usr/local/bin/kubectl
    
    