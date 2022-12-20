FROM python:3.9-slim

RUN pip3 install promnesia[all]

ENV PROMNESIA_CONFIG="/config/config.py"

VOLUME /config
VOLUME /data

EXPOSE 13131
CMD ["python", "-m", "promnesia", "serve", "--db", "/data/promnesia.sqlite", "--port", "13131"]
