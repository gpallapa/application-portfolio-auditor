# Copyright 2019-2024 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0
ARG IMG_MAVEN
ARG IMG_SLIM

FROM ${IMG_MAVEN} as build
ARG CSA_BAGGER_VERSION
RUN mkdir /app
COPY . /app
WORKDIR /app
# Fix for issue on M4 - https://github.com/rancher-sandbox/rancher-desktop/issues/8057#issuecomment-2586147638
ENV JAVA_TOOL_OPTIONS="-XX:UseSVE=0"
RUN mvn clean package assembly:single -DskipTests -DcsvBaggerVersion=${CSA_BAGGER_VERSION}
RUN jar xf target/bagger-${CSA_BAGGER_VERSION}.jar
RUN jdeps --ignore-missing-deps -q  \
    --recursive  \
    --multi-release 21  \
    --print-module-deps  \
    --class-path 'BOOT-INF/lib/*'  \
    target/bagger-${CSA_BAGGER_VERSION}.jar > deps.info
RUN jlink \
    --add-modules $(cat deps.info) \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /myjre

FROM ${IMG_SLIM}
ARG CSA_BAGGER_VERSION

ENV JAVA_HOME=/user/java/jdk
ENV PATH=$JAVA_HOME/bin:$PATH
ENV BAGGER_DB_TMP=/app/bagger_tmp

RUN addgroup --gid 1234 javauser 
RUN useradd --uid 1234 -g javauser javauser
RUN mkdir -p /app $JAVA_HOME $BAGGER_DB_TMP
COPY --from=build /myjre $JAVA_HOME
COPY --from=build /app/target/bagger-${CSA_BAGGER_VERSION}-jar-with-dependencies.jar /app/bagger.jar
WORKDIR /app
RUN chown -R javauser:javauser /app "${BAGGER_DB_TMP}"
USER javauser
# Fix for issue on M4 - https://github.com/rancher-sandbox/rancher-desktop/issues/8057#issuecomment-2586147638
ENTRYPOINT [ "java", "-XX:UseSVE=0", "-Djava.io.tmpdir=/app/bagger_tmp", "-jar", "/app/bagger.jar" ]

