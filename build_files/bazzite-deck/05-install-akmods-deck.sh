#!/usr/bin/bash

set -eoux pipefail

echo "::group::Installing mods required for TDP control on Steam Deck and related hardware."
trap 'echo "::endgroup::"' EXIT

/ctx/tools/install-kmods \
    /tmp/rpms/{extra,kmods-extra}/*zenergy*.rpm \
    /tmp/rpms/{extra,kmods-extra}/*ryzen_smu*.rpm
