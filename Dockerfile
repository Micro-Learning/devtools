FROM ubuntu:19.10

#Adding linux softwares
RUN apt-get update && \
	apt-get install -y sudo && \
	apt-get install -y wget && \
	apt-get install -y vim && \
	apt-get install -y unzip && \
	apt-get install -y jq && \
	apt-get install -y software-properties-common && \
	apt-get install -y net-tools && \
	apt-get install -y build-essential && \
	apt-get install -y zlib1g-dev && \
	apt-get install -y git && \
	apt-get install -y docker.io && \
	apt-get install -y firefox && \
	apt-get install -y apt-transport-https && \
    apt-get install -y ca-certificates && \
    apt-get install -y curl && \
    apt-get install -y lxc && \
    apt-get install -y iptables

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.0.0/graalvm-ce-java11-linux-amd64-20.0.0.tar.gz -O /tmp/graalvm.tar.gz && \
	tar -xzvf /tmp/graalvm.tar.gz -C /opt  && \
	mv /opt/graalvm* /opt/graalvm && \
	/opt/graalvm/bin/gu install native-image
ENV JAVA_HOME=/opt/graalvm
ENV PATH="${PATH}:${JAVA_HOME}/bin"

RUN wget http://ftp.unicamp.br/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O /tmp/maven.tar.gz && \
	tar -xzvf /tmp/maven.tar.gz -C /opt && \
	mv /opt/apache-maven* /opt/maven
ENV M2_HOME=/opt/maven
ENV PATH="${PATH}:${M2_HOME}/bin"

RUN wget https://download.jetbrains.com/idea/ideaIU-2019.3.4-no-jbr.tar.gz -O /tmp/idea.tar.gz && \
	tar -xzvf /tmp/idea.tar.gz -C /opt && \
    mv /opt/idea* /opt/idea && \
    sed -i '/.*UseConcMarkSweepGC/d' /opt/idea/bin/idea.vmoptions && \
    sed -i '/.*UseConcMarkSweepGC/d' /opt/idea/bin/idea64.vmoptions
ENV IDEA_HOME=/opt/idea
ENV PATH="${PATH}:${IDEA_HOME}/bin"

RUN wget https://services.gradle.org/distributions/gradle-6.3-bin.zip -O /tmp/gradle.zip && \
	unzip /tmp/gradle.zip -d /opt && \
	mv /opt/gradle* /opt/gradle
ENV GRADLE_HOME=/opt/gradle
ENV PATH="${PATH}:${GRADLE_HOME}/bin"

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
RUN rm -rf /tmp/* && \
	apt-get autoclean && \
	apt-get clean

USER developer
ENV HOME /home/developer
WORKDIR ${HOME}

ENTRYPOINT ["devtools-entrypoint.sh"]
CMD /bin/bash