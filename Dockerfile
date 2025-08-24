FROM jupyter/base-notebook:x86_64-python-3.11
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

#notebook image gives us joyvan user, but we need root to install things
USER root
# create and activate virtual environment
RUN python3.11 -m venv /opt/venv
RUN chown -R jovyan:users /opt/venv #needed when we switch back to non root user
ENV ENV_ROOT="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/venv/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="/opt/venv/lib/python3.11:/opt/venv/lib/python3.11/site-packages:$PYTHONPATH"


# install requirements
COPY requirements.txt .  
RUN pip3 install -r requirements.txt

# runtime dependencies to install wdf
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    build-essential \
	  cmake git \
    libboost-all-dev \
    pybind11-dev python3-pybind11 \
    libfftw3-3 libfftw3-dev libfftw3-bin \
    libgsl-dev; \
	rm -rf /var/lib/apt/lists/*
  
#install FrameLib
RUN set -ex \
    && git clone https://git.ligo.org/virgo/virgoapp/Fr.git \
    && cd  Fr && cmake CMakeLists.txt \
    && make -j "$(nproc)" \
    && make install \
    && cd .. \
    && rm -rf Fr  

#install P4TSA
RUN git clone https://github.com/elenacuoco/p4TSA && cd p4TSA && cmake CMakeLists.txt \
    && make -j "$(nproc)" \
    && make install \
    && cd python-wrapper \
    && python setup.py  install \
    && cd .. \
    && cd .. \
    && rm -fr p4TSA

RUN /sbin/ldconfig 


#install wdpipe
#RUN mkdir tmp1/
RUN git clone https://gitlab.com/wdfpipe/wdf.git
#ADD . tmp1/
RUN cd wdf && python setup.py  install &&\
    cd .. && rm -fr wdf/ 

#switch back to non root user
USER jovyan

