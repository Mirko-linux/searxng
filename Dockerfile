FROM python:3.11-slim-bookworm

# Variabili ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080

# Installa dipendenze base
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    make \
    python3-venv \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia il progetto
WORKDIR /app
COPY . /app

# Installa SearXNG con make install
RUN make install

# Espone la porta
EXPOSE 8080

# Avvia l’app
CMD ["python3", "-m", "searx.webapp", "--host", "0.0.0.0", "--port", "8080"]
