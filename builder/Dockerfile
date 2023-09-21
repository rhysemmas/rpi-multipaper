FROM eclipse-temurin:17-jdk

RUN apt-get update && \
    apt-get install -y git

WORKDIR /app

ENV MULTIPAPER_BRANCH=dev/1.20.1
RUN git clone "https://github.com/MultiPaper/MultiPaper.git"
WORKDIR ./MultiPaper
RUN git checkout ${MULTIPAPER_BRANCH}
RUN git config --global user.email "egg@ilikeeg.gs" && \
    git config --global user.name "I like eggs"

RUN \
    --mount=type=cache,target=/root/.gradle/ \
    ./gradlew --stacktrace applyPatches
RUN ./gradlew --stacktrace shadowjar createReobfPaperclipJar
