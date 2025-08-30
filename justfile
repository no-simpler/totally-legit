cl_new:
    #!/usr/bin/env bash
    set -euxo pipefail
    just _cl_new_root
    for package_suffix in \
        macros \
        util \
        core \
        alternative \
    ; do
        just _cl_new "$package_suffix"
    done

_cl_new_root:
    git cliff -c '../cliff.toml' -w 'totally_legit' --include-path 'totally_legit/**/*' --tag-pattern 'totally-legit-\d+\.\d+\.\d+' --tag 'totally-legit-0.0.1' --output 'totally_legit/CHANGELOG.md' --unreleased

_cl_new package_suffix:
    git cliff -c '../cliff.toml' -w 'totally_legit_{{package_suffix}}' --include-path 'totally_legit_{{package_suffix}}/**/*' --tag-pattern 'totally-legit-{{package_suffix}}-\d+\.\d+\.\d+' --tag 'totally-legit-{{package_suffix}}-0.0.1' --output 'totally_legit_{{package_suffix}}/CHANGELOG.md' --unreleased
