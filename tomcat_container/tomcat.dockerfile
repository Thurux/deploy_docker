# Dockerfile #
# tomcat9    #
##############

FROM tomcat:9-jre8
MAINTAINER arthur

# debian-like image => apt
RUN apt-get update && apt install vim

WORKDIR /usr/local/tomcat

# pour se connecter et manage les appli
RUN cp -R webapps.dist/* webapps/
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

# TODO => enlever la valve dans les webapps/META-INF/hostmanager/context.xml 
# et webapps/META-INF//manager/context.xml

# port
EXPOSE 8080

# lance le server, pour le bon fonctionnement de notre container/daemon
CMD ["catalina.sh", "run"]