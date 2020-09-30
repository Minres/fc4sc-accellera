#!/bin/bash
#******************************************************************************#
#   Copyright 2018 AMIQ Consulting s.r.l.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#******************************************************************************#
#   Original Authors: Dragos Dospinescu,
#                     AMIQ Consulting s.r.l. (contributors@amiq.com)
#
#               Date: 2020-Sep-29
#******************************************************************************#

# This script can be used to download and extract the tools directory from the
# AMIQ repository github. The directory contains tools that can be used to
# visualize, report and merge coverage databases generated by the FC4SC library.

# tools directory name
TOOLS_DIR="tools"
# temporary working directory (automtically cleanne, unless the script fails with some problem)
TEMP_DIR="temp_workdir_fetchtools"
# the repo where the tools directory will be pulled from
REPO_URL=https://github.com/amiq-consulting/fc4sc.git
# the commit/branch from which the tools directory will be pulled
BRANCH_NAME=master

if [ -d $TOOLS_DIR ]; then
	echo "\"$TOOLS_DIR\" directory already exists! Nothing to do!"
	echo "If you need a clean download, remove the \"$TOOLS_DIR\" directory and run the script again!"
	exit 0
fi

mkdir $TEMP_DIR &&
cd $TEMP_DIR &&

# initialize a git repository (needed to fetch the tools directory)
git init &&
# fetch the last commit on the master branch (used to pull the tools directory)
git fetch $REPO_URL $BRANCH_NAME --depth=1 &&
# configure sparse checkout (so that only a specific folder can be pulled)
git config core.sparseCheckout true &&

# configure the folder name to be pulled
echo "$TOOLS_DIR/" >> .git/info/sparse-checkout &&
# pull the latest commit
git pull --depth=1 $REPO_URL $BRANCH_NAME &&
# go back to the original directory (where this script was invoked from)
cd - && 
# move the tools directory to the location where the script was invoked from
mv $TEMP_DIR/$TOOLS_DIR . &&
# cleanup the temporarty working directory
rm -rf $TEMP_DIR

