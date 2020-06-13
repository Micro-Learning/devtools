FROM ubuntu:19.10

#Adding linux softwares
RUN apt-get update && \
	apt-get install -y \
		sudo \
		wget \
		vim \
		unzip \
		jq \
		software-properties-common \
		net-tools \
		build-essential \
		zlib1g-dev \
		git \
		docker.io \
		firefox \
		apt-transport-https \
		ca-certificates \
		curl \
		lxc \
		iptables && \
		apt-get autoclean && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists

COPY --from=oracle/graalvm-ce:20.1.0-java11 /opt/graalvm* /opt/graalvm

# Build tools
RUN wget http://ftp.unicamp.br/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O /tmp/maven.tar.gz && \
	tar -xzvf /tmp/maven.tar.gz -C /opt && \
	mv /opt/apache-maven* /opt/maven && \
	wget https://services.gradle.org/distributions/gradle-6.3-bin.zip -O /tmp/gradle.zip && \
	unzip /tmp/gradle.zip -d /opt && \
	mv /opt/gradle* /opt/gradle

ENV M2_HOME=/opt/maven
ENV PATH="${PATH}:${M2_HOME}/bin"
ENV GRADLE_HOME=/opt/gradle
ENV PATH="${PATH}:${GRADLE_HOME}/bin"

# IntelliJ
RUN wget https://download.jetbrains.com/idea/ideaIU-2019.3.4-no-jbr.tar.gz -O /tmp/idea.tar.gz && \
	tar -xzvf /tmp/idea.tar.gz -C /opt && \
    mv /opt/idea* /opt/idea && \
    sed -i '/.*UseConcMarkSweepGC/d' /opt/idea/bin/idea.vmoptions && \
    sed -i '/.*UseConcMarkSweepGC/d' /opt/idea/bin/idea64.vmoptions
ENV IDEA_HOME=/opt/idea
ENV PATH="${PATH}:${IDEA_HOME}/bin"

VOLUME /var/lib/docker
ADD ./files/devtools-entrypoint.sh \
 	./files/wrapdocker.sh \
	/usr/local/bin/
RUN chmod +x /usr/local/bin/devtools-entrypoint.sh && \
	chmod +x /usr/local/bin/wrapdocker.sh

# Minikube
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl -O /tmp/kubectl && \
	chmod +x /tmp/kubectl && \
	mv /tmp/kubectl /usr/local/bin/kubectl && \
	wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -O /opt/minikube && \
    chmod +x /opt/minikube && \
    install /opt/minikube /usr/local/bin/

RUN useradd -ms /bin/bash developer && \
	echo developer:developer | chpasswd && \
	usermod -a -G sudo,docker developer

#Cleanning temporary files
RUN rm -rf /tmp/*

USER developer
ENV HOME /home/developer
WORKDIR ${HOME}

ENTRYPOINT ["devtools-entrypoint.sh"]
CMD /bin/bash