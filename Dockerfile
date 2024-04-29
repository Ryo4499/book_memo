FROM gradle:7.0.2-jdk11 AS build
WORKDIR /home/gradle/app
COPY --chown=gradle:gradle gradle gradle
COPY --chown=gradle:gradle gradlew build.gradle settings.gradle ./
COPY --chown=gradle:gradle src src
RUN ./gradlew --no-daemon --max-workers=2 bootJar

FROM eclipse-temurin:11-jre
WORKDIR /app
COPY --from=build /home/gradle/app/build/libs/*.jar app.jar
USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
