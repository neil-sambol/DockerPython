FROM python:3.7
WORKDIR /usr/src/app
LABEL maintainer="nsambol@otgexp.com"

COPY . /usr/src/app
RUN pip install --upgrade pip
RUN pip install -r /usr/src/app/requirements.txt

# For colored prompt.
RUN echo ". /usr/src/app/pd1.sh" >> ~/.bashrc

CMD ["python3", "app.py"]
