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
    [ -d 'totally_legit' ]
    git tag -a 'totally-legit-{{version}}' -m 'chore: prepare totally-legit v{{version}}'

_tag_sub version package_suffix:
    [ -d 'totally_legit_{{package_suffix}}' ]
    git tag -a 'totally-legit-{{package_suffix}}-{{version}}' -m 'chore: prepare totally-legit-{{package_suffix}} v{{version}}'

cl_new version package_suffix='':
    if [ '{{package_suffix}}' = '' ]; \
    then just _cl_new_root '{{version}}'; \
    else just _cl_new_sub '{{version}}' '{{package_suffix}}'; \
    fi

cl_new_all version:
    #!/usr/bin/env bash
    set -euxo pipefail
    just _cl_new_root '{{version}}'
    for package_suffix in \
        macros \
        util \
        core \
        alternative \
    ; do
        just _cl_new_sub '{{version}}' "$package_suffix"
    done

_cl_new_root version:
    [ -d 'totally_legit' ]
    git cliff -c '../cliff.toml' -w 'totally_legit' --include-path 'totally_legit/**/*' --tag-pattern 'totally-legit-\d+\.\d+\.\d+' --tag 'totally-legit-{{version}}' --output 'totally_legit/CHANGELOG.md' --unreleased

_cl_new_sub version package_suffix:
    [ -d 'totally_legit_{{package_suffix}}' ]
    git cliff -c '../cliff.toml' -w 'totally_legit_{{package_suffix}}' --include-path 'totally_legit_{{package_suffix}}/**/*' --tag-pattern 'totally-legit-{{package_suffix}}-\d+\.\d+\.\d+' --tag 'totally-legit-{{package_suffix}}-{{version}}' --output 'totally_legit_{{package_suffix}}/CHANGELOG.md' --unreleased

cl_prepend version package_suffix='':
    if [ '{{package_suffix}}' = '' ]; \
    then just _cl_prepend_root '{{version}}'; \
    else just _cl_prepend_sub '{{version}}' '{{package_suffix}}'; \
    fi

cl_prepend_all version:
    #!/usr/bin/env bash
    set -euxo pipefail
    just _cl_prepend_root '{{version}}'
    for package_suffix in \
        macros \
        util \
        core \
        alternative \
    ; do
        just _cl_prepend_sub '{{version}}' "$package_suffix"
    done

_cl_prepend_root version:
    [ -d 'totally_legit' ]
    git cliff -c '../cliff.toml' -w 'totally_legit' --include-path 'totally_legit/**/*' --tag-pattern 'totally-legit-\d+\.\d+\.\d+' --tag 'totally-legit-{{version}}' --prepend 'CHANGELOG.md' --unreleased

_cl_prepend_sub version package_suffix:
    [ -d 'totally_legit_{{package_suffix}}' ]
    git cliff -c '../cliff.toml' -w 'totally_legit_{{package_suffix}}' --include-path 'totally_legit_{{package_suffix}}/**/*' --tag-pattern 'totally-legit-{{package_suffix}}-\d+\.\d+\.\d+' --tag 'totally-legit-{{package_suffix}}-{{version}}' --prepend 'CHANGELOG.md' --unreleased
