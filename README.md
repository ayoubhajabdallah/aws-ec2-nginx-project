# AWS EC2 Nginx CI/CD Deployment

A small cloud infrastructure and DevOps project that demonstrates automated deployment of a web application to an AWS EC2 instance using GitHub Actions, a self-hosted runner, Nginx, and Bash.

## Overview

This project implements an end-to-end deployment pipeline from GitHub to an AWS-hosted web server.

Whenever a change is pushed to the `main` branch, GitHub Actions automatically triggers a deployment job. A self-hosted GitHub Actions runner running on the EC2 instance executes the deployment script and updates the website served by Nginx.

## Architecture

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Self-Hosted Runner
AWS EC2 / Amazon Linux
    |
    v
Bash Deployment Script
    |
    v
Nginx
    |
    v
Live Website
