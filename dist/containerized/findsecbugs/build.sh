#!/usr/bin/env bash

function stream_edit() {
	sed -i -e "${1}" "${2}"
}

FSB_VERSION="1.13.0"
TEMP_DIR="/tmp/test"
REPO_URL="https://github.com/find-sec-bugs/find-sec-bugs/"
LATEST_TAG="version-${FSB_VERSION}"

rm -Rf "${TEMP_DIR}"
mkdir -p "${TEMP_DIR}/findsecbugs-cli"

pushd "${TEMP_DIR}" &>/dev/null

git clone --branch "${LATEST_TAG}" "${REPO_URL}"
cd find-sec-bugs

# Fix for the ant plugin to work with the latest version
stream_edit 's/<tasks>/<target>/g; s/<\/tasks>/<\/target>/g' findsecbugs-plugin/pom.xml

# Fix for issue on M4 - https://github.com/rancher-sandbox/rancher-desktop/issues/8057#issuecomment-2586147638
export JAVA_TOOL_OPTIONS="-XX:UseSVE=0"

mvn -T 4 clean install -Dmaven.test.skip=true -DskipTests

popd &>/dev/null

cp build.gradle gradle.properties "${TEMP_DIR}/find-sec-bugs/cli"

pushd "${TEMP_DIR}/find-sec-bugs/cli" &>/dev/null
gradle packageCli

unzip -o findsecbugs-cli-${FSB_VERSION}.zip -d "${TEMP_DIR}/findsecbugs-cli"

popd &>/dev/null
