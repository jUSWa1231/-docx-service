FROM python:3.11-slim

# LibreOffice for DOCX->PDF, plus fonts for decent rendering
RUN apt-get update && apt-get install -y --no-install-recommends \
        libreoffice-writer \
        fonts-dejavu \
        fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Railway provides $PORT at runtime
ENV PORT=8000
EXPOSE 8000

CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
