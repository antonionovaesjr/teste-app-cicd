FROM maven:3.5-jdk-8 as maven_builder

WORKDIR /app

ADD . /app

RUN mvn dependency:go-offline -B

ENV TIER DEV
ENV CONTEXT_USE true

# Sobre o valor TIER, veja https://docs.cronapp.io - Parâmetros para gerar .war
RUN mvn package -Dcronapp.profile=${TIER} -Dcronapp.useContext=${CONTEXT_USE}

FROM tomcat:9.0.17-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

#COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
COPY --from=maven_builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
# ola
# new edir
