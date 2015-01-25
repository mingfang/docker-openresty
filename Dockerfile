FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Requirements
#RUN apt-get install -y build-essential libpcre3 libpcre3-dev libcurl4-openssl-dev
RUN apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make

#OpenResty
RUN curl http://openresty.org/download/ngx_openresty-1.7.7.1.tar.gz | tar zx

#Build
RUN cd ngx_openresty-* && \
    ./configure --prefix=/usr/share/nginx \
                --sbin-path=/usr/sbin \
                --conf-path=/etc/nginx/nginx.conf \
                --with-pcre-jit \
                --with-ipv6 && \
    make -j4 && \
    make install && \
    rm -rf /ngx_openresty-*

#Add runit services
ADD sv /etc/service 

