#!/usr/bin/bash

set -eoux pipefail

echo "::group::Executing install-kernel-akmods-sb"
trap 'echo "::endgroup::"' EXIT

/ctx/install-kmods \
    /tmp/rpms/{extra,kmods-extra}/*zenergy*.rpm \
    /tmp/rpms/{extra,kmods-extra}/*ryzen_smu*.rpm