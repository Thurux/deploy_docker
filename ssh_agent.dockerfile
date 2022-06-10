# Dockerfile #
# ssh agent  #
##############

FROM archlinux:latest
MAINTAINER arthur

# create a good environment for jenkins
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

# update
RUN pacman -Sy

# add java and ssh packages
RUN pacman -S --noconfirm jdk8-openjdk openssh

# generate ssh keys and authorizations
RUN mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
COPY jenkins_agent_key.pub ${JENKINS_AGENT_HOME}/.ssh/authorized_keys
RUN chown -Rf "${ID_GROUP}" "${JENKINS_AGENT_HOME}/.ssh" && chmod 0700 -R "${JENKINS_AGENT_HOME}/.ssh"
RUN /usr/bin/ssh-keygen -A

# Add password to root user
RUN	 echo 'root:toor' | chpasswd

# config sshd
RUN  sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

# Expose tcp port
EXPOSE	 22

# Run openssh daemon
CMD	 ["/usr/sbin/sshd", "-D"]

##############