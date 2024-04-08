FROM ubuntu:20.04

ARG CONTAINER_TIMEZONE=Etc/UTC

ARG DEBIAN_FRONTEND=noninteractive

COPY src repo


RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Set TZ
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Update package lists
RUN apt-get update && \
    apt-get install -y git
#gcc g++ make wget libjansson4 libjansson-dev 

COPY src /src/

WORKDIR /src/asterisk/
RUN chmod +x contrib/scripts/install_prereq && \
    contrib/scripts/install_prereq install && \
    ./configure --with-pjproject-bundled
RUN make

# Clean up package lists
#RUN rm -rf /var/lib/apt/lists/*