#/bin/bash

RED="\033[31m"
BLUE="\033[34m"
NC="\033[0m"

echo -e "${BLUE}
      ____                         __            ____  _
     |  _ \  _____   _____  _ __  / _|_      __ / ___|| |__   ___  _ __
     | | | |/ _ \ \ / / _ \| '_ \| |_\ \ /\ / / \___ \| '_ \ / _ \| '_ \\
     | |_| |  __/\ V / (_) | | | |  _|\ V  V /   ___) | | | | (_) | |_) |
     |____/ \___| \_/ \___/|_| |_|_|   \_/\_/   |____/|_| |_|\___/| .__/
                                                                  |_|
                   _____ _                     __
                  |  ___| | ___   ___  _ __   / _| ___  _ __
                  | |_  | |/ _ \ / _ \| '__| | |_ / _ \| '__|
                  |  _| | | (_) | (_) | |    |  _| (_) | |
                  |_|   |_|\___/ \___/|_|    |_|  \___/|_|

                   ___                   ____  _     _  __ _
                  / _ \ _ __   ___ _ __ / ___|| |__ (_)/ _| |_
                 | | | | '_ \ / _ \ '_ \\___ \| '_ \| | |_| __|
                 | |_| | |_) |  __/ | | |___) | | | | |  _| |_
                  \___/| .__/ \___|_| |_|____/|_| |_|_|_|  \__|
                       |_|
                                    _ _ _
${NC}"

echo "Login as admin"
oc login

oc adm policy add-cluster-role-to-user cluster-admin system

# STEP 2: create the devonFW project and add the s2i base-images.

## Create project to store build base-images
oc new-project devonfw --display-name='DevonFW' --description='DevonFW'

## Create base-images and add them to DevonFW project
### this files are private, to share it, you must enter in Git with a valid user, open the file and press RAW Button to generate a valid token
oc create -f https://raw.githubusercontent.com/oasp/s2i/master/s2i/angular/s2i-devonfw-java-imagestream.json --namespace=devonfw
oc create -f https://raw.githubusercontent.com/oasp/s2i/master/s2i/angular/s2i-devonfw-angular-imagestream.json --namespace=devonfw

## Build base-images in DevonFW project
oc start-build s2i-devonfw-java --namespace=devonfw
oc start-build s2i-devonfw-angular --namespace=devonfw

sleep 30
ret=`oc status -v -n devonfw | grep 'running for'`
while [[ !  -z  $ret  ]]; do
    echo "Waiting for build to complete..."
    ret=`oc status -v -n devonfw | grep 'running for'`
    sleep 30
done

# STEP 3: Setup the DevonFW project as "image-puller" to be used in other projects in the same cluster
oc policy add-role-to-group system:image-puller system:authenticated --namespace=devonfw

# STEP 4: Create DevonFW templates into openshift
### this files are private, to share it, you must enter in Git with a valid user, open the file and press RAW Button to generate a valid token
oc create -f https://raw.githubusercontent.com/oasp/s2i/master/templates/devonfw/devonfw-java-template.json --namespace=openshift
oc create -f https://raw.githubusercontent.com/oasp/s2i/master/templates/devonfw/devonfw-angular-template.json --namespace=openshift

echo -e "\nCluster Initial Setup finish.\n"
read -n1 -r -p "Press any key to close..." key