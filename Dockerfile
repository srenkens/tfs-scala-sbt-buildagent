FROM ubuntu:16.04

# The basics (UPDATE, create unprivileged user, install git and other basic stuff)
RUN useradd --create-home --uid 9001 --shell /bin/bash user && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install curl software-properties-common && \
    apt-add-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y libunwind8 libcurl3 git gosu && \
    rm -rf /var/lib/apt/lists/* && \
    echo "export TERM=xterm" >> /etc/bash.bashrc
    

# JAVA
ENV JAVA_OPTS=-Xmx5g
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*


# Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

    
# SBT
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbt/bin
ENV SBT_VERSION=0.13.13
ENV SCALA_VERSION=2.11.8
ENV SBT_HOME=/usr/local/sbt
ENV SBT_OPTS="-Dno-colors"
RUN \
    curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
    dpkg -i sbt-$SBT_VERSION.deb && \
    rm sbt-$SBT_VERSION.deb && \
    apt-get update && \
    apt-get install sbt && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /home/user/.ivy2 && \
    mkdir /home/user/.sbt && \
    chown user /home/user/.ivy2 && \
    chown user /home/user/.sbt
VOLUME /home/user/.ivy2
VOLUME /home/user/.sbt


# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \ 
    apt-get update && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*
    
    
# Xvfb and Google Chrome
RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y xvfb google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*
    
    
# VNC to check on the X Window
RUN apt-get update && \
    apt-get install -y x11vnc && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 5900


# Docker client
ADD docker-1.13.0.tgz /opt
RUN ls /opt/docker && \
    mv /opt/docker/docker /usr/local/bin/docker

# TFS Agent
WORKDIR /myagent
RUN wget https://github.com/Microsoft/vsts-agent/releases/download/v2.112.0/vsts-agent-ubuntu.16.04-x64-2.112.0.tar.gz && \
    tar -zxvf vsts-agent-ubuntu.16.04-x64-2.112.0.tar.gz && \
	rm vsts-agent-ubuntu.16.04-x64-2.112.0.tar.gz
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY run-agent.sh /myagent/run-agent.sh
COPY github-status /usr/local/bin/github-status
RUN chmod +x docker-entrypoint.sh && \
    chmod +x /myagent/run-agent.sh && \
    chmod +x /usr/local/bin/github-status && \
    chown 9001 /myagent
    
    
# SSH config - prevents ssh commands from asking for host fingerprint verification - which is not handy when running an automated CI proces
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config


ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR /app
CMD ["/bin/bash"]