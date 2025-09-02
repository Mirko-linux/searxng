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

# Crea le directory necessarie per SearxNG prima di copiare i file
RUN mkdir -p /app/searx/data /app/searx/plugins

# Copia i requisiti prima per sfruttare la cache
COPY requirements.txt ./

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia il file settings.yml nella posizione corretta
COPY settings.yml /app/searx/settings.yml

# Espone la porta
EXPOSE 8080

# Avvia l'app
CMD ["python", "-m", "searx.webapp", "--host", "0.0.0.0", "--port", "8080"]
