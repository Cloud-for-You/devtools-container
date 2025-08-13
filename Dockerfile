FROM registry.access.redhat.com/ubi9/ubi:latest

ARG OC_VERSION=4.18.13
ARG YQ_VERSION=v4.47.1

# Instalace utilit: yq, jq, kubectl, helm, oc-cli pomocí microdnf
RUN dnf install -y microdnf jq tar

RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \ 
    && chmod +x /usr/local/bin/yq

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

RUN curl -fsSL -o openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz \
    && tar -xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && chmod +x /usr/local/bin/oc \
    && chmod +x /usr/local/bin/kubectl
 