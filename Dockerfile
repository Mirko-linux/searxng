# Usa un'immagine Python leggera e sicura
FROM python:3.11-slim-bookworm

# Variabili ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080 \
    INSTANCE_NAME="searxng" \
    SEARXNG_SETTINGS_PATH="/etc/searxng/settings.yml"

# Installa dipendenze di sistema necessarie
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Crea directory necessarie
RUN mkdir -p /etc/searxng /app

# Imposta la directory di lavoro
WORKDIR /app

# Clona il codice sorgente di SearxNG
RUN git clone --depth=1 https://github.com/searxng/searxng.git .

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Installa SearxNG in modalità sviluppo (include i comandi CLI)
RUN pip install --no-cache-dir -e .

# Genera il file settings.yml
RUN python -m searxng.webapp --help > /dev/null 2>&1 && \
    mkdir -p /etc/searxng && \
    echo 'use_default_settings: true' > /etc/searxng/settings.yml && \
    echo 'instance_name: "SearXNG"' >> /etc/searxng/settings.yml && \
    echo 'bind_address: "0.0.0.0"' >> /etc/searxng/settings.yml && \
    echo 'port: 8080' >> /etc/searxng/settings.yml && \
    echo 'image_proxy: false' >> /etc/searxng/settings.yml && \
    echo 'search:' >> /etc/searxng/settings.yml && \
    echo '    safe_search: 1' >> /etc/searxng/settings.yml

# Crea directory per i dati
RUN mkdir -p /var/log/searxng /etc/searxng

# Espone la porta
EXPOSE 8080

# Avvia l'app con il comando corretto
CMD ["searxng", "run", "--host", "0.0.0.0", "--port", "8080", "--settings", "/etc/searxng/settings.yml"]
