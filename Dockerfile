# Usa Python slim come base (più leggero)
FROM python:3.11-slim-bookworm

# Imposta variabili d'ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080

# Installa dipendenze necessarie
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia il progetto dentro il container
WORKDIR /app
COPY . /app

# Installa SearXNG (assumendo che setup.py o requirements.txt siano nella repo)
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e .

# Espone la porta usata da Render
EXPOSE 8080

# Avvio SearXNG su 0.0.0.0:$PORT
CMD ["python", "-m", "searxng", "webapp", "--host", "0.0.0.0", "--port", "8080"]
