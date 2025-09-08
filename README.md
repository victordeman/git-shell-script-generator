# Git Repository Offline Generator

The **Git Repository Offline Generator** is a shell script (`generate_setup.sh`) that creates a `setup_project.sh` script. The generated script processes a Git repository by analyzing its structure and content, detecting its programming language, extracting a description from its README, generating a compressed offline script to recreate the repository without internet access, validating the recreated content, and cleaning up temporary files. It is designed to replicate a repository’s full structure and content (including text and binary files) offline, with robust error handling and compression for efficiency.

## Features

- **Repository Analysis**: Accepts a Git repository URL, clones it temporarily to analyze its structure and content.
- **Language Detection**: Identifies the programming language (Python, JavaScript, Java, Bash, or others) by checking for key files (`requirements.txt`, `package.json`, `pom.xml`, `*.sh`).
- **README Extraction**: Extracts the first 10 lines of the repository’s `README.md` (if present) as a project description.
- **Offline Script Generation**: Creates a compressed (`gzip`) offline script (`offline_<repo_name>.sh.gz`) that can recreate the repository’s full structure and content without internet access.
- **Content Validation**: Validates equivalence between the original and recreated repository using `diff -r`.
- **Cleanup**: Deletes the temporary cloned repository after generating the offline script.
- **Error Handling**:
  - Checks for at least 1GB of free disk space.
  - Verifies write permissions in the working directory.
  - Ensures `git` and `gzip` are installed.
  - Handles Git authentication errors for private repositories.
- **Binary File Support**: Uses `base64` encoding/decoding to accurately replicate binary files (e.g., images, PDFs).
- **Compression**: Compresses the offline script using `gzip` to reduce disk usage for large repositories.

## Prerequisites

- **Operating System**: Linux or Unix-like system (e.g., Ubuntu, Fedora, macOS).
- **Dependencies**:
  - `bash`: To run the scripts.
  - `git`: To clone the repository.
  - `gzip`: To compress and decompress the offline script.
  - `base64`: To handle binary files (typically pre-installed).
  - `file`: To distinguish text and binary files (typically pre-installed).
- **Disk Space**: At least 1GB of free disk space.
- **Permissions**: Write access to the current working directory.
- **Git Credentials**: For private repositories, configure SSH keys or Personal Access Tokens (PATs) in advance.

## Installation

1. Save the script as `generate_setup.sh`.
2. Make it executable:
   ```bash
   chmod +x generate_setup.sh
