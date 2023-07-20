#!/bin/bash

set -e

ProductName=cloudflare-r2-upload
REPO_PFEX=george012/$ProductName
VersionFile=./package.json

CurrentVersionString=$(jq -r '.version' $VersionFile)

versionStr=""

function to_run() {
    if [ -z "$1" ]; then
        echo "============================ ${ProductName} ============================"
        echo "  1、发布 [-${ProductName}-]"
        echo "  当前版本[-${CurrentVersionString}-]"
        echo "======================================================================"
        read -p "$(echo -e "请输入版本号[例如；v0.0.1]")" inputString
        if [[ "$inputString" =~ ^v.* ]]; then
            versionStr=${inputString}
        else
            versionStr=v${inputString}
        fi
        return 0
    elif [ "$1" == "auto" ]; then
        baseStr=$(echo $CurrentVersionString | cut -d'.' -f1)     # Get the base version (v0)
        base=${baseStr//v/}                                       # Get the base version (0)
        major=$(echo $CurrentVersionString | cut -d'.' -f2)       # Get the major version (0)
        minor=$(echo $CurrentVersionString | cut -d'.' -f3)       # Get the minor version (1)

        minor=$((minor+1))                          # Increment the minor version
        if ((minor==100)); then                     # Check if minor version is 100
            minor=0                                 # Reset minor version to 0
            major=$((major+1))                      # Increment major version
        fi

        if ((major==100)); then                     # Check if major version is 100
            major=0                                 # Reset major version to 0
            base=$((base+1))                        # Increment base version
        fi

        versionStr="v${base}.${major}.${minor}"
        return 0
    elif [ "$1" == "get_pre_del_tag_name" ]; then
        pre_tag=$(get_pre_version_no "$CurrentVersionString")
        get_pre_version_no "$pre_tag"
    else
      return 1
    fi
}

function get_pre_version_no {
    local v_str=$1
    baseStr=$(echo $v_str | cut -d'.' -f1)     # Get the base version (v0)
    base=${baseStr//v/}                                       # Get the base version (0)
    major=$(echo $v_str | cut -d'.' -f2)       # Get the major version (0)
    minor=$(echo $v_str | cut -d'.' -f3)       # Get the minor version (1)

    if ((minor>0)); then                      # Check if minor version is more than 0
        minor=$((minor-1))                     # Decrement the minor version
    else
        minor=99                               # Reset minor version to 99
        if ((major>0)); then                   # Check if major version is more than 0
            major=$((major-1))                 # Decrement major version
        else
            major=99                           # Reset major version to 99
            if ((base>0)); then                # Check if base version is more than 0
                base=$((base-1))               # Decrement base version
            else
                echo "Error: Version cannot be decremented."
                exit 1
            fi
        fi
    fi

    pre_v_no="${base}.${major}.${minor}"
    echo $pre_v_no
}

function git_handle() {
    current_version_no=${CurrentVersionString//v/}
    netx_version_no=${versionStr//v/}

    jq ".version = \"${netx_version_no}\"" $VersionFile > temp.json && mv temp.json $VersionFile

    pre_del_version_no=$(get_pre_version_no "$current_version_no")

    git add . \
    && git commit -m "Update v${netx_version_no}"  \
    && git tag v$netx_version_no \
    && git push \
    && git push --tags \
    && git tag -f latest v$netx_version_no \
    && git push -f origin latest \
    && git tag -d v$pre_del_version_no
}

function alone_func {
    npm install
}

if to_run "$1"; then
    alone_func \
    && wait \
    && git_handle \
    && echo "Complated"
else
    echo "Invalid argument"
fi


