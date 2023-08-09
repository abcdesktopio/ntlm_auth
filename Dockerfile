ARG TARGETPLATFORM
ARG BUILDPLATFORM
# Default release is 22.04
ARG TAG=20.04
# Default base image 
ARG BASE_IMAGE=ubuntu
# BASE_IMAGE_RELEASE deprecated
ARG BASE_IMAGE_RELEASE
ARG LINK_LOCALACCOUNT=true
#
# create package for openbox
# deb files will be located in /root/packages/$(uname -m) directory 
# patched with openbox.title.patch for abcdesktop
FROM ${BASE_IMAGE}:${TAG}
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN sed -i '/deb-src/s/^# //' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends devscripts wget ca-certificates git
RUN apt-get build-dep -y samba
RUN mkdir -p /samba
WORKDIR /samba
RUN apt-get source samba
COPY ntlm_auth.abcdesktop.patch /samba/samba-4.15.13+dfsg/source3/utils
RUN cd /samba/samba-4.15.13+dfsg/source3/utils && patch ntlm_auth.c ntlm_auth.abcdesktop.patch
WORKDIR /samba/samba-4.15.13+dfsg
RUN ./configure
RUN make
# RUN cd openbox-3.6.1 && dch -n abcdesktop_sig_usr
# RUN cd openbox-3.6.1 && EDITOR=/bin/true dpkg-source -q --commit . abcdesktop_sig_usr
#RUN cd openbox-3.6.1 && debuild -us -uc
#RUN ls *.deb

