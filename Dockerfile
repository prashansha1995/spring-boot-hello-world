# Build a JAR File
FROM maven:3.6.3-jdk-8-slim AS stage1
RUN mkdir -p /home/app
WORKDIR /home/app

# 1. add pom.xml only here

ADD pom.xml /home/app

# 2. start downloading dependencies

RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

# 3. add all source code and start compiling

ADD . /home/app

RUN ["mvn", "package"]

# Create an Image
FROM openjdk:8-jdk-alpine
EXPOSE 5000
COPY --from=stage1 /home/app/target/hello-world-java.jar hello-world-java.jar
ENTRYPOINT ["sh", "-c", "java -jar /hello-world-java.jar"]
