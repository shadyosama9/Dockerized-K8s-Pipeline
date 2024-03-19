FROM openjdk:11 AS BUILDING_IMAGE

# Installing Services
RUN apt update && apt install maven git -y && apt clean && rm -rf /var/lib/apt/lists/*
# Cloning The Repo
RUN git clone "https://github.com/shadyosama9/Dockarizing-Java_App.git"
# Building The Artifact
WORKDIR /Dockarizing-Java_App
RUN mvn install

FROM tomcat:9-jre11

LABEL "Author"="Shady Osama"
LABEL "Project"="Vprofile"

# Deploying The Artifact
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILDING_IMAGE Dockarizing-Java_App/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

