# Copyright 2019-2024 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0
ARG IMG_GRADLE
ARG IMG_JAVA

FROM ${IMG_GRADLE} as build

ARG FERNFLOWER_VERSION

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    apt remove apt --autoremove -y --allow-remove-essential && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /intellij /build
WORKDIR /intellij
COPY build.sh .
RUN ./build.sh "${FERNFLOWER_VERSION}"

FROM ${IMG_JAVA}

# Fix for issue on M4 - https://github.com/rancher-sandbox/rancher-desktop/issues/8057#issuecomment-2586147638
ENV JAVA_TOOL_OPTIONS="-XX:UseSVE=0"
# Update and cleanup
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    apt remove apt --autoremove -y --allow-remove-essential && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build /build /app
ENTRYPOINT [ "java", "-jar", "/app/fernflower.jar" ]
