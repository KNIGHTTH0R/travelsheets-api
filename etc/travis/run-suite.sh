#!/usr/bin/env bash
set -e

code=0

common_step_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suites/common/$1.sh"
if [ -f "${common_step_script}" ]; then
    /usr/bin/env bash "${common_step_script}" || code=$?
fi

IFS=' ' read -r -a suites <<< "$2"
for suite in "${suites[@]}"; do
    suite_step_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suites/${suite}/$1.sh"
    if [ -f "${suite_step_script}" ]; then
        suite_step_is_suitable_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suites/${suite}/is_suitable.sh"
        if [ -f "${suite_step_is_suitable_script}" ]; then
            /usr/bin/env bash "${suite_step_is_suitable_script}" || continue
        fi

        /usr/bin/env bash "${suite_step_script}" || code=$?
    fi
done

exit ${code}