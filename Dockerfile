FROM alpine:3

ENV BASE_URL="https://get.helm.sh"

ENV HELM_2_FILE="helm-v2.17.0-linux-amd64.tar.gz"
ENV HELM_3_FILE="helm-v3.11.3-linux-amd64.tar.gz"

RUN apk add --no-cache ca-certificates \
    jq curl bash nodejs npm aws-cli && \
    # Install helm version 2:
    curl -L ${BASE_URL}/${HELM_2_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    # Install helm version 3:
    curl -L ${BASE_URL}/${HELM_3_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm3 && \
    chmod +x /usr/bin/helm3 && \
    rm -rf linux-amd64 && \
    # Init version 2 helm:
    helm init --client-only

ENV PYTHONPATH "/usr/lib/python3.8/site-packages/"

COPY . /usr/src/
WORKDIR /usr/src/

RUN npm ci

ENTRYPOINT ["node", "/usr/src/index.js"]
