# DevonFW templates

This are the DevonFW templates to build devonfw apps using the s2i images. They are based on the work of Mickuehl in Oasp templates/mythaistar for deploy My Thai Star.

- Inside the `icons` we have a custom icons for openshift.

## How to use

#### Previous requirements

##### Deploy the Source-2-Image builder images

Remember that this templates need a build image from s2i-devonfw-angular and s2i-devonfw-java. More information:
- [Deploy the Source-2-Image builder images](https://github.com/oasp/s2i#deploy-the-source-2-image-builder-images).

##### Customize Openshift

Remeber that this templates also have a custom icons, and to use it, we must modify the master-config.yml inside openshift. More information:
- [DevonFW Openshift Origin Add Custom Icons](https://github.com/oasp/s2i/tree/master/templates/devonfw/customizeOpenshift/).

#### Deploy DevonFW templates

Now, it's time to create devonfw templates to use this s2i and add it to the browse catalog.

To let all user to use this templates in all openshift projects, we should create it in an openshift namespace. To do that, we must log in as an admin.
To let all user to use this templates in all openshift projects, we should create it in an openshift namespace. To do that, we must log in as an admin.

    $ oc create -f https://raw.githubusercontent.com/oasp/s2i/master/templates/devonfw/devonfw-java-template.json --namespace=openshift
    $ oc create -f https://raw.githubusercontent.com/oasp/s2i/master/templates/devonfw/devonfw-angular-template.json --namespace=openshift

When it finish, remember to logout as an admin and enter with our normal user.

	$ oc login

	
#### How to use DevonFW templates in openshift

To use this templates with openshift, we can override any parameter values defined in the file by adding the --param-file=paramfile option.

This file must be a list of <name>=<value> pairs. A parameter reference may appear in any text field inside the template items.

The parameters that we must override are the following

    $ cat paramfile
      APPLICATION_NAME=app-Name
	  APPLICATION_GROUP_NAME=group-Name
	  GIT_URI=Git uri
	  GIT_REF=master
	  CONTEXT_DIR=/context
		
The following parameters are optional

	$ cat paramfile
	  APPLICATION_HOSTNAME=Custom hostname for service routes. Leave blank for default hostname, e.g.: <application-name>.<project>.<default-domain-suffix>,
	  # Only for angular
	  REST_ENDPOINT_URL=The URL of the backend's REST API endpoint. This can be declared after,
	  REST_ENDPOINT_PATTERN=The pattern URL of the backend's REST API endpoint that must be modify by the REST_ENDPOINT_URL variable,

For example, to deploy My Thai Star Java

    $ cat paramfile
	  APPLICATION_NAME="mythaistar-java"
	  APPLICATION_GROUP_NAME="My-Thai-Star"
	  GIT_URI="https://github.com/oasp/my-thai-star.git"
	  GIT_REF="develop"
	  CONTEXT_DIR="/java/mtsj"
    $ oc new-app --template=devonfw-java --namespace=mythaistar --param-file=paramfile
