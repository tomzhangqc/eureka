FROM openjdk:8-jdk-alpine
COPY ./target/eureka.jar eureka.jar
EXPOSE 8761
ENV APP_OPTS=""
ENTRYPOINT ["sh", "-c", "java -jar /eureka.jar $APP_OPTS"]
