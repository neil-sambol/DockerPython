# Readme for Docker-Python

## Problem to solve:

I hate the python virtual environment and am always suspicious that it is doing something under the covers that will break my system in production.

## Possible solution:

What if instead of running our applications in a virtual environment, we ran them in a Docker instance?

## Solution:

I have written an application to pull an empty Docker, Linux image with Python 3.1x and then install the requirements.txt on it automatically.  To make debugging easier, the user is presented with a shell that is 
the shell of the virtual machine.  Peering into the Docker image so as to run and debug scripts as if it was the local machine, however, it is entirely contained within a Docker instance.

The system is configurable by command-line and manual script changes.

# TODO

## Command-line switches:



## Examples of use:
