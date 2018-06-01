FROM ubuntu:xenial
# non-interactive automated build  to avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive
# OpenJDK8 
RUN apt update; \
  apt upgrade -y; \
  apt install -y default-jre curl wget git ; \
  apt-get clean

ENV JAVA_HOME /usr
ENV PATH $JAVA_HOME/bin:$PATH

# get maven and checksum
RUN wget --no-verbose -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz; \
  echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2.tar.gz" | md5sum -c

# install maven
RUN tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/; \
  ln -s /opt/apache-maven-3.2.2 /opt/maven; \
  ln -s /opt/maven/bin/mvn /usr/local/bin; \
  rm -f /tmp/apache-maven-3.2.2.tar.gz
ENV MAVEN_HOME /opt/maven

# copy jenkins war file to the container
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

CMD [""]
