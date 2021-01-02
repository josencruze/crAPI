#!/bin/sh

# Copyright 2020 Traceable, Inc.
#
# Licensed under the Apache License, Version 2.0 (the “License”);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -x
set -e
cd "$(dirname $0)"
scripts=$(find ../../services/ -name 'build-image*')
for script in ${scripts}
do
    echo "Executing $script"
    bash -x "$script"
done

# Deploy to local repository
docker images | grep crapi | grep -v localhost | awk '{print $1}' | xargs -L1 -I{} docker tag {} localhost:5000/{}:v1
docker images | grep crapi |  grep localhost | grep v1 | awk '{print $1}' | xargs -L1 -I{}  docker push {}:v1
