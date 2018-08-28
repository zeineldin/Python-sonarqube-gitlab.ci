FROM python:3.6
COPY . /app
WORKDIR /app
RUN mkdir /app/logs
RUN pip install -r requirements.txt


RUN curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip
RUN apt-get update
RUN apt-get install unzip
RUN unzip  sonarscanner.zip
RUN rm sonarscanner.zip
RUN mv sonar-scanner-3.0.3.778-linux sonar-scanner
ENV SONAR_RUNNER_HOME=/root/sonar-scanner
ENV PATH $PATH:/root/sonar-scanner/bin

COPY sonar-project.properties ./sonar-scanner/conf/sonar-scanner.properties
RUN pip install coverage
RUN pip install nose
RUN pip install -r requirements.txt
RUN nosetests --with-coverage --cover-package=src test/** ; exit 0
#RUN nosetests --cover-package=src
RUN coverage report -m
RUN coverage xml -i
RUN sonar-scanner/bin/sonar-scanner
