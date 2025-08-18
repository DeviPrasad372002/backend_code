FROM python:3.11-slim

WORKDIR /app

# Install ODBC dependencies
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    gnupg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Install Microsoft ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app","--host", "0.0.0.0","--port","8000"]
