FROM python:3.11-slim-bookworm

# Variabili ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080 \
    INSTANCE_NAME="searxng" \
    SEARXNG_SETTINGS_PATH="/app/settings.yml"

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

# Copia tutto il resto
COPY . .

# Crea le directory necessarie per SearxNG
RUN mkdir -p /app/searx/data /app/searx/plugins

# Crea un utente non-root per sicurezza
RUN useradd -m -u 1000 searxuser && \
    chown -R searxuser:searxuser /app

# Cambia utente
USER searxuser

# Espone la porta (IMPORTANTE per Render)
EXPOSE 8080

# Avvia l'app con la porta corretta (FONDAMENTALE)
CMD ["python", "-m", "searx.webapp", "--host", "0.0.0.0", "--port", "8080"]
