#!/bin/sh

PURPLE='\033[0;35m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;94m'
NONE='\033[0m'

###########
# Functions

# Remove temporary files and prepare to exit script.
cleanup() {
  if [ ! -s ./pd1.sh ];
  then
    rm ./pd1.sh
  fi

  if [ ! -s ./pd0.sh ];
  then
    rm ./pd0.sh
  fi
}

###########
# MAIN Program begins...

# Parse command line...
if [ "$#" -ne 2 ] || [ "$1" != "--dev" ] && [ "$1" != "-d" ] && [ "$1" != "--prod" ] && [ "$1" != "-p" ] && [ "$1" != "--exit" ] && [ "$1" != "-x" ];
then
  echo
  echo "${PURPLE}pd - Python with Docker${NONE}"
  echo
  echo "${PURPLE}USAGE: pd [OPTION] [PATH]${NONE}"
  echo
  echo "${PURPLE}Options:${NONE}"
  echo "${PURPLE}  -d, --dev   Setup a new or activate an existing environment & container${NONE}"
  echo "${PURPLE}  -h, --help  This menu${NONE}"
  echo "${PURPLE}  -p, --prod  Build a production container${NONE}"
  echo "${PURPLE}  -x, --exit  Exit / shutdown running development environment & container${NONE}"
  echo
  exit 1
fi

# Is second parameter a valid directory?
if [ ! -d "$2" ];
then
  echo
  echo "${RED}ERROR: Path <$2> is not a directory${NONE}"
  echo
  exit 2
fi

# Lets move into the working directory
echo
cd $2

#########################
# EXIT?  If so, cleanup.
# We do this first so we don't have to create all of those files if we are just exiting.
if [ "$1" == "--exit" ] || [ "$1" == "-x" ];
then
  echo "${YELLOW}--> Stopping and removing existing docker images...${NONE}"
  echo "${BLUE}--> docker stop ${PWD} && docker rm ${PWD}...${NONE}"
  docker stop $PWD
  docker rm $PWD

  cleanup

  echo "${GREEN}--> Cleanup complete...script exiting.${NONE}"

  # Exit script with no errors.
  exit 0
fi

# Does Dockerfile file exist?
if [ ! -s ./Dockerfile ];
then
  echo "--> ${YELLOW}Dockerfile does not exist, creating file...${NONE}"

  # Filename: Dockerfile
  echo "FROM python:3.7" > ./Dockerfile
  echo "WORKDIR /usr/src/app" >> ./Dockerfile
  echo "LABEL maintainer=\"nsambol@otgexp.com\"" >> ./Dockerfile
  echo >> ./Dockerfile
  echo "COPY . /usr/src/app" >> ./Dockerfile
  echo "RUN pip install --upgrade pip" >> ./Dockerfile
  echo "RUN pip install -r /usr/src/app/requirements.txt" >> ./Dockerfile
  echo >> ./Dockerfile
  echo "# For colored prompt." >> ./Dockerfile
  echo 'RUN echo ". /usr/src/app/pd1.sh" >> ~/.bashrc' >> ./Dockerfile
  echo >> ./Dockerfile
  echo "CMD [\"python3\", \"app.py\"]" >> ./Dockerfile
else
  echo "--> ${GREEN}Dockerfile exists proceeding with existing file...${NONE}"
fi

# Does .gitignore file exist?
if [ ! -s ./.gitignore ];
then
  echo "--> ${YELLOW}.gitignore does not exist, creating file...${NONE}"

  echo "# Byte-compiled / optimized / DLL files" > ./.gitignore
  echo "__pycache__/" >> ./.gitignore
  echo "*.py[cod]" >> ./.gitignore
  echo ".DS_Store" >> ./.gitignore

  echo >> ./.gitignore
  echo "# C Extensions" >> ./.gitignore
  echo "*.so" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Distribution / packaging" >> ./.gitignore
  echo "bin/" >> ./.gitignore
  echo "build/" >> ./.gitignore
  echo "develop-eggs/" >> ./.gitignore
  echo "dist/" >> ./.gitignore
  echo "eggs/" >> ./.gitignore
  echo "lib/" >> ./.gitignore
  echo "lib64/" >> ./.gitignore
  echo "parts/" >> ./.gitignore
  echo "sdist/" >> ./.gitignore
  echo "var/" >> ./.gitignore
  echo "*.egg-info/" >> ./.gitignore
  echo ".installed.cfg" >> ./.gitignore
  echo "*.egg" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Installer logs" >> ./.gitignore
  echo "pip-log.txt" >> ./.gitignore
  echo "pip-delete-this-directory.txt" >> ./.gitignore

  echo >> ./.gitignore
  echo "# venv files" >> ./.gitignore
  echo "venv*" >> ./.gitignore
  echo "venv/*" >> ./.gitignore

  echo "# Unit test / coverage reports" >> ./.gitignore
  echo ".tox/" >> ./.gitignore
  echo ".coverage" >> ./.gitignore
  echo ".cache" >> ./.gitignore
  echo "nosetests.xml" >> ./.gitignore
  echo "coverage.xml" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Translations" >> ./.gitignore
  echo "*.mo" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Mr Developer" >> ./.gitignore
  echo ".mr.developer.cfg" >> ./.gitignore
  echo ".project" >> ./.gitignore
  echo ".pydevproject" >> ./.gitignore

  echo >> ./.gitignore
  echo "# PyCharm" >> ./.gitignore
  echo ".idea/*" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Rope" >> ./.gitignore
  echo ".ropeproject" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Django stuff:" >> ./.gitignore
  echo "*.log" >> ./.gitignore
  echo "*.pot" >> ./.gitignore

  echo >> ./.gitignore
  echo "# Sphinx documentation" echo >> ./.gitignore
  echo "docs/_build/" >> ./.gitignore
  echo "# Environment Variables" >> ./.gitignore
  echo ".env*" >> ./.gitignore
else
  echo "--> ${GREEN}.gitignore file exists proceeding with existing file...${NONE}"
fi

# Does .dockerignore file exist?
if [ ! -s ./.dockerignore ];
  then
    echo "--> ${YELLOW}.dockerignore does not exist, creating file...${NONE}"
    echo ".git" > ./.dockerignore
    echo ".gitignore" >> ./.dockerignore
    echo "Dockerfile*" >> ./.dockerignore
    echo ".gitignore" >> ./.dockerignore
    echo "docker-compose" >> ./.dockerignore
    echo "README.md" >> ./.dockerignore
    echo "LICENSE" >> ./.dockerignore
    echo ".vscode" >> ./.dockerignore
    echo ".env" >> ./.dockerignore
    echo ".sh" >> ./.dockerignore
    echo ".idea" >> ./.dockerignore
    echo "__pycache__" >> ./.dockerignore
    echo "*.pyc" >> ./.dockerignore
    echo "*.pyo" >> ./.dockerignore
    echo "*.pyd" >> ./.dockerignore
    echo ".Python" >> ./.dockerignore
    echo "env" >> ./.dockerignore
  else
    echo "--> ${GREEN}.dockerignore exists proceeding with existing file...${NONE}"
  fi

##########################
# Development Environment?
if [ "$1" == "--dev" ] || [ "$1" == "-d" ];
then
  # Does .env_dev file exist?
  if [ ! -s ./.env_dev ];
  then
    echo "--> ${YELLOW}.env_dev file does not exist, creating file...${NONE}"
    echo "MYSQL_PASSWORD=" > ./.env_dev
    echo "MYSQL_USER=" >> ./.env_dev
    echo "TESTING_MODE=" >> ./.env_dev
    echo "TESTING_MODE_DB=FALSE" >> ./.env_dev
    echo "TESTING_MODE_EMAIL=TRUE" >> ./.env_dev
  else
    echo "--> ${GREEN}.env_dev file exists proceeding with existing file...${NONE}"
  fi

  # OK, now we are finally setup for creating the container...
  # Lets pull project name ($pn) out of path.
  pn=${PWD##*/}
  # Remove any old images...TODO SAVE IMAGES / RECYCLE IMAGES?
  echo "${GREEN}--> Removing any previous containers for $pn...${NONE}"
  echo "${BLUE}docker rm $pn${NONE}"
  docker rm $pn

  # Create new container...
  echo "${GREEN}--> Creating container for $pn...${NONE}"
  echo "${BLUE}docker build . --tag $pn:latest --rm --no-cache${NONE}"
  docker build . --tag "$pn":latest --rm --no-cache

  # Open new terminal for local machine...
  echo "${GREEN}--> Opening new terminal for ${BLUE}local machine${GREEN}...${NONE}"
  echo "${BLUE}open -a Terminal .${NONE}"

  ### FOR LOCAL SHELL
  # We have to do some funky stuff here to make that happen...
  echo "#/bin/bash -i" > ./pd0.sh
  echo 'export PS1="\033[1;32mLOCAL SHELL: \033[0m"' >> ./pd0.sh
  echo "/bin/bash -i" >> ./pd0.sh
  chmod +x ./pd0.sh
  open -a Terminal ./pd0.sh

  sleep 1

  ### FOR DOCKER SHELL
  #!/bin/bash
  echo 'DOCKER_USER=$(whoami)' > ./pd1.sh
  echo 'if [ "$DOCKER_USER" == "root" ];' >> ./pd1.sh
  echo "then" >> ./pd1.sh
  echo 'export PS1="\033[1;31mDOCKER SHELL ($DOCKER_USER)# \033[0m"' >> ./pd1.sh
  echo "else" >> ./pd1.sh
  echo 'export PS1="\033[1;94mDOCKER SHELL ($DOCKER_USER)$ \033[0m"' >> ./pd1.sh
  echo "fi" >> ./pd1.sh

  # Run new container and transfer current xterm over to it...
  echo "${GREEN}--> Running container for $pn...${NONE}"
  echo "${BLUE}docker run -it -v $PWD:/usr/src/app --env-file ./.env_dev --name $pn $pn /bin/bash${NONE}"

  # We have to do some funky stuff here to make that happen...
  docker run -it -v $PWD:/usr/src/app --env-file ./.env_dev --name $pn $pn /bin/bash

  sleep 1
  cleanup

  # Exit script with no errors.
  exit 0
fi

#########################
# Production Environment?
if [ "$1" == "--prod" ] || [ "$1" == "-p" ];
then
  # Does .env_prod file exist?
  if [ ! -s ./.env_prod ];
  then
    echo "--> ${YELLOW}.env_prod file does not exist, creating file...${NONE}"
    echo "MYSQL_PASSWORD=" > ./.env_prod
    echo "MYSQL_USER=" >> ./.env_prod
    echo "TESTING_MODE=FALSE" >> ./.env_prod
  else
    echo "--> ${GREEN}.env_prod file exists proceeding with existing file...${NONE}"
  fi

  # OK, now we are finally setup for creating the container...
  # Lets pull project name ($pn) out of path.
  pn=${PWD##*/}
  # Remove any old images...TODO SAVE IMAGES / RECYCLE IMAGES?
  echo "${GREEN}--> Removing any previous containers for $pn...${NONE}"
  echo "${BLUE}docker rm $pn${NONE}"
  docker rm $pn

  # Create new container...
  echo "${RED}--> Creating production container for $pn...${NONE}"
  echo "${RED}docker build . --tag $pn:latest --rm --no-cache${NONE}"
  docker build . --tag "$pn":latest --rm --no-cache

  # Run new container and transfer current xterm over to it...
  echo "${RED}--> Running production container for $pn...${NONE}"
  echo "${RED}docker run -v $PWD:/usr/src/app --env-file ./.env_prod --name $pn $pn${NONE}"

  # We have to do some funky stuff here to make that happen...
  docker run -it -v $PWD:/usr/src/app --env-file ./.env_prod --name $pn $pn
  echo "${RED}--> There is no interactive shell for a production container $pn...${NONE}"
  echo "${RED}--> Script exiting...container running default command in Dockerfile...${NONE}"

  sleep 1
  cleanup

  # Exit script with no errors.
  exit 0
fi