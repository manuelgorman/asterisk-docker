FROM ubuntu:22.04

COPY src repo
ADD https://github.com/asterisk/asterisk.git /appsrc/

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN DEBIAN_FRONTEND=noninteractive \
    apt update \
    && apt install -y gcc g++ make wget\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /appsrc
RUN pwd
RUN ./configure
#RUN chmod +x contrib/scripts/install_prereq 
#RUN contrib/scripts/install_prereq test
#RUN make