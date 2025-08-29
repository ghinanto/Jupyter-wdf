#!/bin/bash
docker run -it -p 8888:8888 -v .:/home/jovyan/work localhost/jupyter-wdf:noroot
