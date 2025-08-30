tag version package_suffix='':
    if [ '{{package_suffix}}' = '' ]; \
    then just _tag_root '{{version}}'; \
    else just _tag_sub '{{version}}' '{{package_suffix}}'; \
    fi

tag_all version:
    #!/usr/bin/env bash
    set -euxo pipefail
    just _tag_root '{{version}}'
    for package_suffix in \
        macros \
        util \
        core \
        alternative \
    ; do just _tag_sub '{{version}}' "$package_suffix"; done

_tag_root version:
    [ -d 'totally_legit' ] || { echo "Error: Directory 'totally_legit' not found or is not accessible" >&2; exit 1; }
    git tag -a 'totally-legit-{{version}}' -m 'chore: prepare totally-legit v{{version}}'

_tag_sub version package_suffix:
    [ -d 'totally_legit_{{package_suffix}}' ] || { echo "Error: Directory 'totally_legit_{{package_suffix}}' not found or is not accessible" >&2; exit 1; }
    git tag -a 'totally-legit-{{package_suffix}}-{{version}}' -m 'chore: prepare totally-legit-{{package_suffix}} v{{version}}'

cl_new package_suffix='':
    if [ '{{package_suffix}}' = '' ]; \
    then just _cl_new_root; \
    else just _cl_new_sub '{{package_suffix}}'; \
    fi

cl_new_all:
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
    [ -d 'totally_legit' ] || { echo "Error: Directory 'totally_legit' not found or is not accessible" >&2; exit 1; }
    git cliff -c '../cliff.toml' -w 'totally_legit' --include-path 'totally_legit/**/*' --tag-pattern 'totally-legit-\d+\.\d+\.\d+' --tag 'totally-legit-0.0.1' --output 'totally_legit/CHANGELOG.md' --unreleased

_cl_new_sub package_suffix:
    [ -d 'totally_legit_{{package_suffix}}' ] || { echo "Error: Directory 'totally_legit_{{package_suffix}}' not found or is not accessible" >&2; exit 1; }
    git cliff -c '../cliff.toml' -w 'totally_legit_{{package_suffix}}' --include-path 'totally_legit_{{package_suffix}}/**/*' --tag-pattern 'totally-legit-{{package_suffix}}-\d+\.\d+\.\d+' --tag 'totally-legit-{{package_suffix}}-0.0.1' --output 'totally_legit_{{package_suffix}}/CHANGELOG.md' --unreleased
