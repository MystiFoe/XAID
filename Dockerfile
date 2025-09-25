FROM python:3.11.9-slim

# Install only essential system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install only chromium for Playwright (lighter than full install)
RUN playwright install-deps chromium
RUN playwright install chromium

# Copy application
COPY . .

# Create necessary directories
RUN mkdir -p /tmp/x_automation/user_data

EXPOSE 8080

# Add memory limits and optimizations
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

CMD ["streamlit", "run", "streamlit_app.py", "--server.port=8080", "--server.address=0.0.0.0", "--server.runOnSave=false", "--server.fileWatcherType=none"]