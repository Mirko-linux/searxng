FROM python:3.11-slim-bookworm

# Variabili ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080 \
    INSTANCE_NAME="searxng"

# Installa dipendenze base
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python3-venv \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Crea directory app
WORKDIR /app

# Copia requirements prima per caching
COPY requirements.txt ./

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia il file settings.yml nella posizione CORRETTA dove SearxNG lo cerca
COPY settings.yml /app/searx/settings.yml

# Crea le directory necessarie per SearxNG
RUN mkdir -p /app/searx/data /app/searx/plugins

# Espone la porta
EXPOSE 8080

# Avvia l'app
CMD ["python", "-m", "searx.webapp", "--host", "0.0.0.0", "--port", "8080"]
