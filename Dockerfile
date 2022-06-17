#DockerFile to run my weather wrapper app
FROM python:3.10.1

#Labels as key value pair
LABEL maintainer="ekane3.github.io"

# Any working directory can be chosen as per choice like '/' or '/home' etc
# i have chosen /app as working directory
WORKDIR /app

# Now the structure looks like this '/app/app.py'

#To add the remote file to the root dir in container
COPY app.py ./


#Installing the required packages
RUN pip install --no-cache-dir requests==2.27.1
RUN pip install --no-cache-dir flask==2.1.2
#From official image documentation
CMD ["python", "app.py"]