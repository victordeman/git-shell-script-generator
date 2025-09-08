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
3. Run the script to generate setup_project.sh:
    ./generate_setup.sh

## Usage

1. Run setup_project.sh:bash

./setup_project.sh <git-repo-url>

## Example:bash

./setup_project.sh https://github.com/victordeman/Reco-AI-Agent

- The script performs the following:
  - Checks disk space, permissions, and required tools (git, gzip).
  - Clones the repository temporarily to git-shell-script-generator_project/temp_<repo_name>.
  - Detects the programming language.
  - Extracts the first 10 lines of README.md.
  - Generates a compressed offline script (offline_<repo_name>.sh.gz) and a wrapper script (offline_<repo_name>.sh).
  - Validates the recreated repository against the original using diff -r.
  - Deletes the temporary cloned repository.
  - Output files are placed in the git-shell-script-generator_project directory.

- **Run the Offline Script:
  - After running setup_project.sh, a compressed script (offline_<repo_name>.sh.gz) and a wrapper script (offline_<repo_name>.sh)     are created in git-shell-script-generator_project. To recreate the repository offline:bash

## How It Works

1. Input Validation:
   - setup_project.sh expects a single argument: a Git repository URL
   (e.g., https://github.com/victordeman/Reco-AI-Agent).
   The repository name is extracted from the URL (e.g., Reco-AI-Agent).

2. Error Checks:Verifies at least 1GB of free disk space using df -k.
Ensures write permissions in the current directory using -w.
Confirms git and gzip are installed using command -v.
Handles Git authentication errors for private repositories.

3. Temporary Cloning:Clones the repository to git-shell-script-generator_project/temp_<repo_name> to analyze its content.
If cloning fails (e.g., due to invalid URL or authentication issues), it provides guidance for private repositories.

4. Language Detection:Checks for:requirements.txt (Python)
package.json (JavaScript/Node.js)
pom.xml (Java)
*.sh (Bash)

Reports the detected language or indicates if none is detected.

5. README Extraction:Extracts the first 10 lines of README.md (if present) as a project description, removing Markdown headers for clarity.

6. Offline Script Generation:Creates offline_<repo_name>.sh.gz in git-shell-script-generator_project.
Embeds the full content of each file:Text files are embedded directly using cat << 'EOC'.
Binary files are encoded with base64 for accurate replication.

Generates a wrapper script (offline_<repo_name>.sh) that decompresses and executes the compressed script.

7. Content Validation:Runs the offline script to recreate the repository in git-shell-script-generator_project/<repo_name>.
Uses diff -r --exclude=".git" to compare the original and recreated repositories.
Reports success or displays differences if validation fails.

8. Cleanup:
   Deletes the temporary cloned repository (temp_<repo_name>) to save disk space.

