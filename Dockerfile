FROM ubuntu:20.04

ARG PASSWORD
ARG USERNAME
ARG UID
ARG GID

RUN apt update && \
    apt install -y openssh-server sudo -y

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# disable user password for sudo access
RUN echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/$USERNAME

RUN groupadd -g $GID $USERNAME && \
    useradd -rm -d /home/$USERNAME  -s /bin/bash -g $USERNAME -G sudo -u $UID $USERNAME 

RUN echo "$USERNAME:$PASSWORD" | chpasswd

RUN mkdir /home/$USERNAME/.ssh
COPY ./ssh_keys/id_rsa.pub /home/$USERNAME/.ssh/id_rsa.pub
RUN cat /home/$USERNAME/.ssh/id_rsa.pub >> /home/$USERNAME/.ssh/authorized_keys

RUN chmod -R go= /home/$USERNAME/.ssh  
RUN chown -R $USERNAME /home/$USERNAME/.ssh

RUN service ssh start
WORKDIR /home/$USERNAME

# USER $USERNAME  # throws error: no hostkeys available -- exiting

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
