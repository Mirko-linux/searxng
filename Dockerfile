# Usa un'immagine Python leggera e sicura
FROM python:3.11-slim-bookworm

# Variabili ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080 \
    INSTANCE_NAME="searxng"

# Installa dipendenze di sistema necessarie
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

# Imposta la directory di lavoro all'interno del container
WORKDIR /app

# Copia i requisiti prima per sfruttare la cache
COPY requirements.txt ./

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Crea la directory principale per SearxNG
RUN mkdir -p /app/searx

# Genera il file settings.yml direttamente nel Dockerfile
RUN echo 'instance_name: SearXNG' > /app/searx/settings.yml && \
    echo 'bind_address: 0.0.0.0' >> /app/searx/settings.yml && \
    echo 'port: 8080' >> /app/searx/settings.yml && \
    echo 'image_proxy: False' >> /app/searx/settings.yml && \
    echo 'search:' >> /app/searx/settings.yml && \
    echo '    safe: True' >> /app/searx/settings.yml

# Crea le directory necessarie per SearxNG
RUN mkdir -p /app/searx/data /app/searx/plugins

# Espone la porta
EXPOSE 8080

# Avvia l'app
CMD ["python", "-m", "searx.webapp", "--host", "0.0.0.0", "--port", "8080"]
