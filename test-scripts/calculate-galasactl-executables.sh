#!/bin/bash

#
# Copyright contributors to the Galasa project
#
# SPDX-License-Identifier: EPL-2.0
#


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



function calculate_galasactl_executable {
    h2 "Calculate the name of the galasactl executable for this machine/os"

    raw_os=$(uname -s) # eg: "Darwin"
    os=""
    case $raw_os in
        Darwin*) 
            os="darwin" 
            ;;
        Windows*)
            os="windows"
            ;;
        Linux*)
            os="linux"
            ;;
        *) 
            error "Failed to recognise which operating system is in use. $raw_os"
            exit 1
    esac

    architecture=$(uname -m)

    export binary="galasactl-${os}-${architecture}"
    info "galasactl binary is ${binary}"
    success "OK"
}