FROM alpine:edge
# non-interactive automated build  to avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive
#RUN echo 'http://mirrors.ustc.edu.cn/alpine/edge/main' > /etc/apk/repositories
#RUN echo '@community http://mirrors.ustc.edu.cn/alpine/edge/community' >> /etc/apk/repositories
#RUN echo '@testing http://mirrors.ustc.edu.cn/alpine/edge/testing' >> /etc/apk/repositories
#RUN apk update &&\ 
#    apk upgrade 

# OpenJDK8 ...  
RUN apk add --update \
        musl \
        build-base \
        #python3 \
        #python3-dev \
        bash \
        wget \
        git \
        curl \
        ttf-dejavu       
#RUN pip3 install --no-cache-dir --upgrade pip
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u161
ENV JAVA_ALPINE_VERSION 8.161.12-r0

# RUN apk add --no-cache 	openjdk8="$JAVA_ALPINE_VERSION" 
RUN apk add --no-cache 	openjdk8="$JAVA_ALPINE_VERSION" 


# get maven and checksum
RUN wget --no-verbose -O /tmp/apache-maven-3.2.2-bin.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
# RUN echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2-bin.tar.gz" | md5sum -c
    
 

#install maven
RUN tar -xzf /tmp/apache-maven-3.2.2-bin.tar.gz -C /usr/local/lib; \
    chmod 777 -R /usr/local/lib/apache-maven-3.2.2 ; \
    ln -s /usr/local/lib/apache-maven-3.2.2/bin/mvn /usr/local/bin
    #rm -f /tmp/apache-maven-3.2.2-bin.tar.gz
#ENV MAVEN_HOME /usr/local/lib/apache-maven-3.2.2

# copy jenkins war file to the container
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war /usr/local/lib/jenkins.war
RUN chmod 644 /usr/local/lib/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/usr/local/lib/jenkins.war"]
EXPOSE 8080

CMD [""]
