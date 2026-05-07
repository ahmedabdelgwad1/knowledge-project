# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install SWI-Prolog and other dependencies required by pyswip
RUN apt-get update && \
    apt-get install -y swi-prolog && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up a new user named "user" with user ID 1000 for Hugging Face Spaces
RUN useradd -m -u 1000 user

# Switch to the "user" user
USER user

# Set home to the user's home directory
ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
WORKDIR $HOME/app

# Copy the current directory contents into the container at $HOME/app setting the owner to the user
COPY --chown=user . $HOME/app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Hugging Face Spaces requires exposing port 7860
EXPOSE 7860

# Define environment variable for Gunicorn
ENV PORT=7860

# Run app using Gunicorn for production
CMD ["gunicorn", "-b", "0.0.0.0:7860", "interface:app"]
