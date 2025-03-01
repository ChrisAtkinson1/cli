#!/bin/bash

#
# Copyright contributors to the Galasa project
#
# SPDX-License-Identifier: EPL-2.0
#
echo "Running script test-galasactl-ecosystem.sh"

# This script can be ran locally or executed in a pipeline to test the various built binaries of galasactl
# This script tests the 'galasactl' commands against the ecosystem
# Pre-requesite: the CLI must have been built first so the binaries are present in the /bin directory


# Where is this script executing from ?
BASEDIR=$(dirname "$0");pushd $BASEDIR 2>&1 >> /dev/null ;BASEDIR=$(pwd);popd 2>&1 >> /dev/null
export ORIGINAL_DIR=$(pwd)
cd "${BASEDIR}"


#--------------------------------------------------------------------------
#
# Set Colors
#
#--------------------------------------------------------------------------
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 76)
white=$(tput setaf 7)
tan=$(tput setaf 202)
blue=$(tput setaf 25)

#--------------------------------------------------------------------------
#
# Headers and Logging
#
#--------------------------------------------------------------------------
underline() { printf "${underline}${bold}%s${reset}\n" "$@" ;}
h1() { printf "\n${underline}${bold}${blue}%s${reset}\n" "$@" ;}
h2() { printf "\n${underline}${bold}${white}%s${reset}\n" "$@" ;}
debug() { printf "${white}%s${reset}\n" "$@" ;}
info() { printf "${white}➜ %s${reset}\n" "$@" ;}
success() { printf "${green}✔ %s${reset}\n" "$@" ;}
error() { printf "${red}✖ %s${reset}\n" "$@" ;}
warn() { printf "${tan}➜ %s${reset}\n" "$@" ;}
bold() { printf "${bold}%s${reset}\n" "$@" ;}
note() { printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@" ;}


#-----------------------------------------------------------------------------------------                   
# Functions
#-----------------------------------------------------------------------------------------                   
function usage {
    info "Syntax: test-galasactl-ecosystem.sh --bootstrap [BOOTSTRAP]"
    cat << EOF

Bootstrap must refer to a remote ecosystem.
EOF
}

#-----------------------------------------------------------------------------------------                   
# Process parameters
#-----------------------------------------------------------------------------------------                   
bootstrap=""

while [ "$1" != "" ]; do
    case $1 in
        --bootstrap )                     shift
                                          bootstrap="$1"
                                          ;;
        -h | --help )                     usage
                                          exit
                                          ;;
        * )                               error "Unexpected argument $1"
                                          usage
                                          exit 1
    esac
    shift
done

# Can't really verify that the bootstrap provided is a valid one, but galasactl will pick this up later if not
if [[ "${bootstrap}" == "" ]]; then
    export bootstrap="http://galasa-cicsk8s.hursley.ibm.com/bootstrap"
    info "No bootstrap supplied. Defaulting the --bootstrap to be ${bootstrap}"
fi

info "Running tests against ecosystem bootstrap ${bootstrap}"

#-----------------------------------------------------------------------------------------                   
# Constants
#-----------------------------------------------------------------------------------------   
export GALASA_TEST_NAME_SHORT="local.CoreLocalJava11Ubuntu"   
export GALASA_TEST_NAME_LONG="dev.galasa.inttests.core.${GALASA_TEST_NAME_SHORT}" 
export GALASA_TEST_RUN_GET_EXPECTED_SUMMARY_LINE_COUNT="4"
export GALASA_TEST_RUN_GET_EXPECTED_DETAILS_LINE_COUNT="13"
export GALASA_TEST_RUN_GET_EXPECTED_RAW_PIPE_COUNT="10"
export GALASA_TEST_RUN_GET_EXPECTED_NUMBER_ARTIFACT_RUNNING_COUNT="10"


CALLED_BY_MAIN="true"
source ${BASEDIR}/test-scripts/calculate-galasactl-executables.sh
calculate_galasactl_executable

source ${BASEDIR}/test-scripts/runs-tests.sh
test_runs_commands

source ${BASEDIR}/test-scripts/properties-tests.sh
properties_tests
