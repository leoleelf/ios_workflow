#!/bin/bash

GCP_SOURCE_PATH="~/source/github"

function firebase_deploy {
  while getopts "g:r:n:t:f:s:uc" opt; do
    case ${opt} in
      g )
        local gcpProjectName="${OPTARG}"
        ;;
      r )
        local repositoryPath="${OPTARG}"
        repositoryPathArray=(${repositoryPath//\// })
        local repositoryUserName=${repositoryPathArray[0]}
        local repositoryProjectName=${repositoryPathArray[1]}
        ;;
      n )
        local nodeVersion="${OPTARG}"
        ;;
      t )
        local toolVersion="${OPTARG}"
        ;;
      f )
        local functions="${OPTARG}"
        ;;
      s )
        GCP_SOURCE_PATH="${OPTARG}"
        ;;
      u )
        local isUpdateSourceMode=true
        ;;
      c )
        local isSourceClean=true
        ;;
      \? ) # Handle invalid options
        echo "Invalid option: -$OPTARG" >&2
        ;;
      : ) # Handle missing arguments
        echo "Option -$OPTARG requires an argument" >&2
        ;;
    esac
  done
  shift $((OPTIND -1))
  echo ${gcpProjectName}
  echo ${repositoryPath}
  echo ${repositoryUserName}
  echo ${repositoryProjectName}
  echo ${nodeVersion}
  echo ${toolVersion}
  echo ${isUpdateSourceMode}
  if [ "$isSourceClean" == true ]; then
    rm -rf "$GCP_SOURCE_PATH/$repositoryPath"
  fi
  if [ "$isUpdateSourceMode" == true ]; then
    if [ ! -d "$GCP_SOURCE_PATH/$repositoryPath" ]; then
      mkdir -p "$GCP_SOURCE_PATH/$repositoryPath"
      git clone -b master --single-branch https://github.com/$repositoryPath.git "$GCP_SOURCE_PATH/$repositoryPath"
    else
      cd "$GCP_SOURCE_PATH/$repositoryPath"
      git fetch origin
      git reset --hard origin/master
      cd ~
    fi
    exit 0
  fi
  source ~/.bashrc
  node -v
  echo "End."
  exit 1
}

firebase_deploy "$@"
