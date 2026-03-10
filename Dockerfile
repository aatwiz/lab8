FROM python:3.11-slim

WORKDIR /app

# Copy requirements first for layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Initialise the database schema at build time
RUN python -c "import db; db.init_db()"

# Render overrides this at runtime
ENV PORT=5000

# Use shell-form so $PORT expands correctly
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 2 app:app"]
