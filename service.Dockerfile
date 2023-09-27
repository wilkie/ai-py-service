# Describes a simple docker container to provide a Python-based web service
# for calls out to an external AI agent.

FROM ubuntu:20.04

RUN apt update

# Add a secondary repository that provides newer Python versions
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y

# Install Python 3.11 from the alternative repository
RUN apt update
RUN apt install python3.11 python3 python3-venv python3.11-venv python3.11-dev -y

# Create the virtual environment for Python 3.11
RUN python3.11 -mvenv pybin

# Install Python libraries
ADD requirements.txt .
RUN /bin/bash -c "source pybin/bin/activate; pip install -r requirements.txt"

# Add the Python code from this repository
ADD app app
ADD lib lib
ADD test test

# This command will run the server
CMD /bin/bash -c "source pybin/bin/activate; waitress-serve --host=0.0.0.0 --call app:create_app"
