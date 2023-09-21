#FROM arm32v7/ubuntu:jammy as builder

FROM eclipse-temurin:17-jdk as builder

RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y git curl unzip

#ENV JDK_VERSION=zulu17.44.53-ca-jdk17.0.8.1-linux_aarch32hf
#RUN curl "https://cdn.azul.com/zulu-embedded/bin/${JDK_VERSION}.tar.gz" \
#         --output "${JDK_VERSION}.tar.gz"

#RUN tar -xzvf ${JDK_VERSION}.tar.gz

#ENV PATH=/${JDK_VERSION}/bin:${PATH}
#ENV JAVA_HOME=/${JDK_VERSION}

#RUN chmod -R 0777 ${JAVA_HOME}
RUN echo ${JAVA_HOME}

WORKDIR /app

ENV PAPER_VERSION=1.20.1
ENV PAPER_BUILD=100
RUN curl "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar" \
    --output "paper.jar"

ENV MULTIPAPER_BRANCH=dev/1.20.1
RUN git clone "https://github.com/MultiPaper/MultiPaper.git"
WORKDIR ./MultiPaper
RUN git checkout ${MULTIPAPER_BRANCH}

#ENV GRADLE_VERSION=8.0.2
#RUN curl "https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
#    --output "gradle-${GRADLE_VERSION}-bin.zip"

#RUN mv gradle-${GRADLE_VERSION}-bin.zip ./gradle/wrapper/

#RUN sed -i 's/distributionBase=GRADLE_USER_HOME/distributionBase=PROJECT/g' ./gradle/wrapper/gradle-wrapper.properties
#RUN sed -i 's/https\\:\/\/services\.gradle\.org\/distributions\///g' ./gradle/wrapper/gradle-wrapper.properties

#RUN ./gradlew wrapper --gradle-version=${GRADLE_VERSION} --distribution-type=bin
#RUN chmod -R 0777 /root/.gradle/
#RUN ps -aux

RUN \
    #--mount=type=cache,target=/root/.gradle/ \
    ./gradlew --stacktrace applyPatches
RUN ./gradlew --stacktrace --debug shadowjar createReobfPaperclipJar


FROM eclipse-temurin:19-jre

# https://cdn.azul.com/zulu-embedded/bin/zulu17.44.53-ca-jre17.0.8.1-linux_aarch32hf.tar.gz

COPY --from=builder /app/ /app/

WORKDIR /app

RUN useradd -ms /bin/bash paper && \
    chown -R paper:paper /app

COPY ./config/* .

USER paper

CMD java -Xms2G -Xmx2G \
         -XX:+UseG1GC \
         -XX:+ParallelRefProcEnabled \
         -XX:MaxGCPauseMillis=200 \
         -XX:+UnlockExperimentalVMOptions \
         -XX:+DisableExplicitGC \
         -XX:+AlwaysPreTouch \
         -XX:G1NewSizePercent=30 \
         -XX:G1MaxNewSizePercent=40 \
         -XX:G1HeapRegionSize=8M \
         -XX:G1ReservePercent=20 \
         -XX:G1HeapWastePercent=5 \
         -XX:G1MixedGCCountTarget=4 \
         -XX:InitiatingHeapOccupancyPercent=15 \
         -XX:G1MixedGCLiveThresholdPercent=90 \
         -XX:G1RSetUpdatingPauseTimePercent=5 \
         -XX:SurvivorRatio=32 \
         -XX:+PerfDisableSharedMem \
         -XX:MaxTenuringThreshold=1 \
         -Dusing.aikars.flags=https://mcflags.emc.gs \
         -Daikars.new.flags=true \
         -jar paper.jar --nogui

EXPOSE 25565 25575
