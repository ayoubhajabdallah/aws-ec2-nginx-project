# AWS EC2 Nginx CI/CD Deployment

A hands-on cloud and DevOps project demonstrating an automated deployment pipeline to an AWS EC2 instance using GitHub Actions, a self-hosted runner, Nginx, Bash, and Linux.

The goal of this project is not the frontend itself, but the infrastructure and deployment workflow behind it: a change pushed to the `main` branch is automatically deployed to a live Nginx web server running on AWS EC2.

---

## Project Highlights

- Deployed a web server on **AWS EC2**
- Configured **Nginx** on Amazon Linux 2023
- Implemented automated deployments with **GitHub Actions**
- Configured a **self-hosted GitHub Actions runner** on EC2
- Created a **Bash deployment script**
- Configured the runner as a persistent **systemd service**
- Connected EC2 to GitHub using **SSH key authentication**
- Restricted SSH access through an **AWS Security Group**
- Verified an end-to-end deployment from GitHub to the live server

---

## Architecture

```text
Developer
    |
    | push to main
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Self-Hosted GitHub Actions Runner
    |
    | AWS EC2 / Amazon Linux 2023
    v
Bash Deployment Script
    |
    v
Nginx Web Server
    |
    v
Live Website
```

### Deployment Flow

```text
Code Change
    ↓
Git Commit
    ↓
Push to main
    ↓
GitHub Actions Workflow
    ↓
Self-Hosted EC2 Runner
    ↓
deploy.sh
    ↓
Nginx Web Root Updated
    ↓
Nginx Reload
    ↓
Updated Website
```

---

## Tech Stack

| Technology | Purpose |
| --- | --- |
| AWS EC2 | Cloud compute instance hosting the server |
| Amazon Linux 2023 | Operating system running on EC2 |
| Nginx | Web server serving the application |
| Git | Source-code version control |
| GitHub | Remote repository hosting |
| GitHub Actions | CI/CD workflow automation |
| Self-Hosted Runner | Executes deployment jobs directly on EC2 |
| Bash | Deployment automation |
| SSH | Secure server administration and GitHub authentication |
| systemd | Keeps the GitHub Actions runner running as a service |

---

## How It Works

### 1. AWS EC2

An Amazon Linux 2023 EC2 instance provides the Linux environment used to host the project.

The instance is publicly reachable for web traffic while administrative SSH access is restricted through the EC2 Security Group.

### 2. Nginx

Nginx is installed on the EC2 instance and serves the website over HTTP.

The deployed application is served from the Nginx web root:

```text
/usr/share/nginx/html/
```

### 3. GitHub Repository

The project source code is stored in GitHub.

The EC2 instance authenticates with GitHub using SSH keys, allowing Git operations without using a GitHub account password.

### 4. GitHub Actions

A GitHub Actions workflow listens for pushes to:

```text
main
```

When a new commit reaches `main`, GitHub automatically creates a deployment job.

### 5. Self-Hosted Runner

Instead of manually connecting to the server for every deployment, a GitHub Actions self-hosted runner is installed directly on the EC2 instance.

The runner:

- connects the EC2 instance to GitHub Actions
- listens for deployment jobs
- executes the workflow on the server
- runs the deployment script automatically

### 6. systemd Service

The self-hosted runner is installed as a system service.

This allows the runner to continue operating independently of an interactive SSH terminal and to run in the background.

### 7. Automated Deployment

The deployment script:

1. Moves into the project repository
2. Pulls the latest version of `main`
3. Copies the updated website into the Nginx web root
4. Applies the required file permissions
5. Reloads Nginx

The result is an automated deployment pipeline:

```text
git push → GitHub Actions → EC2 → Nginx → Live Website
```

---

## Repository Structure

```text
aws-ec2-nginx-project/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── deploy.sh
├── index.html
└── README.md
```

### `index.html`

Simple webpage used to verify that deployments successfully reach the live EC2 server.

### `deploy.sh`

Bash script responsible for deploying the latest application version to Nginx.

### `.github/workflows/deploy.yml`

GitHub Actions workflow that triggers the deployment process when changes are pushed to `main`.

### `README.md`

Project documentation.

---

## CI/CD Workflow

The workflow is triggered automatically whenever code is pushed to the `main` branch.

```yaml
on:
  push:
    branches:
      - main
```

The deployment job uses the EC2 self-hosted runner:

```yaml
runs-on: self-hosted
```

The runner then executes the deployment script on the EC2 instance.

This removes the need to manually SSH into the server and deploy each update.

---

## Security

Several basic security measures are used in the project.

### Restricted SSH Access

SSH uses port `22`, with inbound access restricted through the AWS Security Group rather than exposing SSH broadly to the internet.

### HTTP Access

Port `80` is available for public HTTP traffic so users can access the Nginx-hosted website.

### SSH Key Authentication

SSH keys are used for authentication instead of passwords.

The EC2 server also uses SSH authentication when communicating with GitHub.

### Private Keys

Private SSH keys are never committed to the Git repository.

Only public keys are registered where authentication requires them.

---

## End-to-End Deployment Test

The complete pipeline was tested by changing the website source and committing the update to `main`.

The expected sequence occurred automatically:

```text
GitHub Commit
      ↓
GitHub Actions Triggered
      ↓
Self-Hosted Runner Received Job
      ↓
Deployment Script Executed
      ↓
Nginx Updated
      ↓
New Content Visible on Live Website
```

The GitHub Actions deployment completed successfully and the updated content appeared on the web server without a manual deployment.

---

## What I Learned

This project provided practical experience with several areas of cloud infrastructure and DevOps.

### AWS

- Launching and managing an EC2 instance
- Working with EC2 public networking
- Configuring Security Group inbound rules

### Linux

- Working with Amazon Linux
- Installing and managing packages
- Navigating the Linux filesystem
- Managing files and permissions
- Managing services with `systemd`

### Networking & SSH

- Connecting securely to a remote Linux server
- Working with public/private SSH keys
- Restricting administrative access
- Authenticating GitHub operations using SSH

### Web Infrastructure

- Installing Nginx
- Starting and enabling Nginx
- Deploying files to the Nginx web root
- Reloading the web server after deployment

### Git & GitHub

- Creating and cloning repositories
- Staging and committing changes
- Working with the `main` branch
- Pushing code using SSH authentication

### CI/CD

- Creating a GitHub Actions workflow
- Configuring workflow triggers
- Installing a self-hosted runner
- Running the runner as a persistent service
- Automating deployments with Bash
- Testing an end-to-end deployment pipeline

---

## Future Improvements

The current version establishes the core deployment infrastructure. Possible extensions include:

- [ ] Configure **HTTPS/TLS**
- [ ] Connect a **custom domain**
- [ ] Add application and server **monitoring**
- [ ] Improve centralized **logging**
- [ ] Add automated deployment validation
- [ ] Add rollback functionality
- [ ] Introduce **Infrastructure as Code**
- [ ] Improve the frontend application
- [ ] Add additional server security hardening

---

## Project Status

**Core deployment pipeline: Complete**

The current implementation successfully supports:

```text
Push to main
    ↓
Automatic GitHub Actions deployment
    ↓
AWS EC2
    ↓
Nginx
    ↓
Updated live website
```

Further work will focus on security, observability, infrastructure automation, and production-oriented improvements.
