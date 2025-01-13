# Copyright 2019-2024 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0
ARG IMG_BASE
ARG IMG_JAVA

FROM ${IMG_BASE} AS build
ARG WAMT_VERSION
ADD wamt-${WAMT_VERSION}.zip /
RUN apk add --no-cache --upgrade bash && \
    apk add unzip sed && \
    unzip -o /wamt-${WAMT_VERSION}.zip -d /

FROM ${IMG_JAVA}
COPY --from=build /wamt /wamt

# Fix for issue on M4 - https://github.com/rancher-sandbox/rancher-desktop/issues/8057#issuecomment-2586147638
ENTRYPOINT [ "java", "-XX:UseSVE=0", "-Duser.language=en", "-jar", "/wamt/binaryAppScanner.jar" ]
