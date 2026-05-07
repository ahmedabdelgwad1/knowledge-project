# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install SWI-Prolog and other dependencies required by pyswip
RUN apt-get update && \
    apt-get install -y swi-prolog && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable for Gunicorn
ENV PORT=5000

# Run app using Gunicorn for production
CMD ["gunicorn", "-b", "0.0.0.0:5000", "interface:app"]
