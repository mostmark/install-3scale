#!/bin/bash

export PROJECT_NAME=${PROJECT_NAME:=3scale}
export TOKEN_USERNAME=${TOKEN_USERNAME:=my-username}
export TOKEN_PASSWORD=${TOKEN_PASSWORD:=my-password}
export WILDCARD_DOMAIN=${WILDCARD_DOMAIN:=apps-crc.testing}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:=welcome1}



read -rp "Project name: ($PROJECT_NAME): " choice;
if [ "$choice" != "" ] ; then
  export PROJECT_NAME="$choice";
fi

read -rp "Wildcard domain to use: ($WILDCARD_DOMAIN): " choice;
if [ "$choice" != "" ] ; then
  export WILDCARD_DOMAIN="$choice";
fi

read -rp "3scale admin password: ($ADMIN_PASSWORD): " choice;
if [ "$choice" != "" ] ; then
  export ADMIN_PASSWORD="$choice";
fi

read -rp "Token username: ($TOKEN_USERNAME): " choice;
if [ "$choice" != "" ] ; then
  export TOKEN_USERNAME="$choice";
fi

read -rp "Token password: ($TOKEN_PASSWORD): " choice;
if [ "$choice" != "" ] ; then
  export TOKEN_PASSWORD="$choice";
fi

echo ""
echo "******"
echo "* Project name is $PROJECT_NAME "
echo "* Your wildcard domain is $WILDCARD_DOMAIN "
echo "* Your 3scale admin password $ADMIN_PASSWORD "
echo "* Your token username is $TOKEN_USERNAME "
echo "* Your token password is $TOKEN_PASSWORD "
echo "******"

read -n 1 -s -r -p "Press any key to continue..."
echo ""
echo ""

oc new-project $PROJECT_NAME

oc create secret docker-registry threescale-registry-auth \
  --docker-server=registry.redhat.io \
  --docker-username=$TOKEN_USERNAME \
  --docker-password=$TOKEN_PASSWORD

oc new-app --file https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/master/amp/amp-eval-tech-preview.yml \
  --param WILDCARD_DOMAIN=$WILDCARD_DOMAIN \
  --param ADMIN_PASSWORD=$ADMIN_PASSWORD
