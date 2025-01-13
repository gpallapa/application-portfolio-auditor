ARG IMG_BASE=alpine:latest
ARG IMG_GRADLE=gradle:8.12.0-jdk21-alpine
ARG IMG_JAVA=eclipse-temurin:11.0.22_7-jre

FROM ${IMG_GRADLE} AS build
ARG FSB_VERSION=1.13.0
RUN apk add --no-cache --upgrade bash && apk add unzip sed git maven
WORKDIR /fsb
ADD build.sh build.gradle gradle.properties .
RUN ./build.sh

FROM ${IMG_JAVA}
COPY --from=build /tmp/test/findsecbugs-cli /findsecbugs-cli
ENTRYPOINT [ "/findsecbugs-cli/findsecbugs.sh" ]
