#!/bin/bash

set -e

function choco {
	mono /opt/chocolatey/choco.exe "$@" --allow-unofficial --nocolor
}

rm -f coder.*.nupkg

mkdir -p tools
cp LICENSE tools/LICENSE.txt
cp VERIFICATION tools/VERIFICATION.txt
# chocolatey doesn't support ARM
cp ./build/coder_*_windows_amd64.exe tools/

choco pack coder.nuspec --version "${INPUT_VERSION}"

if [[ "$INPUT_PUBLISH" == "true" ]]; then
	choco push coder."${INPUT_VERSION}".nupkg --api-key "${INPUT_CHOCOLATEYKEY}" -s https://push.chocolatey.org/ --timeout 180
fi
