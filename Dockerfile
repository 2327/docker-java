FROM alpine
# https://www.oracle.com/webfolder/s/digest/8u251checksum.html

ENV LANG=en_US.UTF-8
ENV JAVA_HOME=/usr/java/jdk-8
ENV JAVA_SHA256=777a8d689e863275a647ae52cb30fd90022a3af268f34fc5b9867ce32f1b374e
ENV MAVEN_VERSION=3.6.3
ENV MAVEN_HOME=/usr/share/maven
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.31-r0

RUN apk add --no-cache --virtual .build-deps \
      curl \
      libstdc++ \
      curl \
      ca-certificates \
      java-cacerts \
      && \
      for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done \
      && \
        apk add --allow-untrusted /tmp/*.apk \
      && \
      rm -v /tmp/*.apk \
      && \
      /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
      && \
      curl https://oraclemirror.np.gy/jdk8/jdk-8u251-linux-x64.tar.gz \
        -o /tmp/jdk-8u251-linux-x64.tar.gz \
      && \
      echo "${JAVA_SHA256} */tmp/jdk-8u251-linux-x64.tar.gz" | sha256sum -c - \
      && \
      mkdir -p "$JAVA_HOME" \
      && \
      tar -zxf /tmp/jdk-8u251-linux-x64.tar.gz -C "$JAVA_HOME" --strip-components 1 \
      && \
      rm /tmp/jdk-8u251-linux-x64.tar.gz \
      && \
      curl -fsSL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar xzf - -C /usr/share \
      && \
      mv /usr/share/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} \
      && \
      ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

