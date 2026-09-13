FROM tomcat:11-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/devops-demo-app.war /usr/local/tomcat/webapps/devops-demo-app.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
