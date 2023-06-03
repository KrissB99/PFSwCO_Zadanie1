# Autor pliku Dockerfile
MAINTAINER Krystyna Banaszewska

# Etap 1: Budowanie aplikacji w języku Python
FROM python:3.9-slim AS builder

WORKDIR /app

# Instalacja zależności
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopiowanie kodu aplikacji
COPY server.py .

# Etap 2: Konfiguracja obrazu kontenera
FROM python:3.9-slim AS final

WORKDIR /app

# Kopiowanie zależności i skompilowanej aplikacji z etapu 1
COPY --from=builder /root/.cache /root/.cache
COPY --from=builder /app .

# Ustawienie zmiennej środowiskowej dla Flask
ENV FLASK_APP=server.py

# Otwarcie portu
EXPOSE 8000

# Uruchomienie serwera
CMD ["flask", "run", "--host=0.0.0.0", "--port=8000"]