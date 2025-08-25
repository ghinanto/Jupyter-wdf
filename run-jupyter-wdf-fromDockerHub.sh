#!/bin/bash
# if using podman:
# podman run -it -p 8888:8888 -v .:/home/jovyan/work docker://docker.io/ghinanto/jupyter-wdf:noroot
# if using docker:
docker run -it -p 8888:8888 -v .:/home/jovyan/work ghinanto/jupyter-wdf:noroot
