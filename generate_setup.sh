#!/bin/bash

# Script to generate setup_project.sh
OUTPUT_SCRIPT="setup_project.sh"

# Create or overwrite setup_project.sh
cat << 'EOF' > $OUTPUT_SCRIPT
#!/bin/bash

# Check if Git repository URL is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <git-repo-url>"
    exit 1
fi

REPO_URL="$1"
PROJECT_DIR="git-shell-script-generator_project"
REPO_NAME=$(basename "$REPO_URL" .git)
TEMP_DIR="temp_$REPO_NAME"

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1

# Clone the repository temporarily to analyze
git clone "$REPO_URL" "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone repository"
    exit 1
fi

cd "$TEMP_DIR" || exit 1

# Detect programming language
detect_language() {
    if [ -f "requirements.txt" ]; then
        echo "Detected Python project (requirements.txt found)"
        return 1
    elif [ -f "package.json" ]; then
        echo "Detected JavaScript/Node.js project (package.json found)"
        return 2
    elif [ -f "pom.xml" ]; then
        echo "Detected Java project (pom.xml found)"
        return 3
    elif [ -f "*.sh" ]; then
        echo "Detected Bash project (*.sh files found)"
        return 4
    else
        echo "No specific programming language detected"
        return 0
    fi
}

# Fetch README.md and extract description
fetch_readme() {
    if [ -f "README.md" ]; then
        echo "Project Description from README.md:"
        head -n 10 README.md | sed 's/^#* *//g'
    else
        echo "No README.md found in repository"
    fi
}

# Generate project structure and content
generate_offline_script() {
    OFFLINE_SCRIPT="../offline_$REPO_NAME.sh"
    echo "#!/bin/bash" > "$OFFLINE_SCRIPT"
    echo "mkdir -p $REPO_NAME" >> "$OFFLINE_SCRIPT"
    echo "cd $REPO_NAME || exit 1" >> "$OFFLINE_SCRIPT"
    echo "" >> "$OFFLINE_SCRIPT"

    # Find all files (excluding .git directory)
    find . -type f -not -path './.git/*' | while read -r file; do
        # Remove leading ./ from file path
        file_clean=${file#./}
        dir=$(dirname "$file_clean")
        echo "Creating $file_clean with content"
        # Create directory structure
        echo "mkdir -p \"$dir\"" >> "$OFFLINE_SCRIPT"
        # Embed file content using cat << 'EOC'
        echo "cat << 'EOC' > \"$file_clean\"" >> "$OFFLINE_SCRIPT"
        cat "$file" >> "$OFFLINE_SCRIPT"
        echo "EOC" >> "$OFFLINE_SCRIPT"
    done

    # Make offline script executable
    chmod +x "$OFFLINE_SCRIPT"
    echo "Generated offline script: $OFFLINE_SCRIPT"
}

# Validate equivalence between cloned and generated content
validate_content() {
    # Run the offline script to recreate the repository
    cd .. || exit 1
    bash "offline_$REPO_NAME.sh"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to run offline script"
        exit 1
    fi

    # Compare original and recreated repository
    cd "$TEMP_DIR" || exit 1
    diff -r --exclude=".git" . "../$REPO_NAME" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Validation successful: Generated repository matches original"
    else
        echo "Validation failed: Generated repository differs from original"
        diff -r --exclude=".git" . "../$REPO_NAME"
        exit 1
    fi
}

# Clean up temporary cloned repository
cleanup() {
    cd .. || exit 1
    rm -rf "$TEMP_DIR"
    echo "Cleaned up temporary directory: $TEMP_DIR"
}

echo "Setting up project from $REPO_URL"
echo "----------------------------------------"
detect_language
echo "----------------------------------------"
fetch_readme
echo "----------------------------------------"
echo "Generating offline script..."
generate_offline_script
echo "----------------------------------------"
echo "Validating generated content..."
validate_content
echo "----------------------------------------"
echo "Cleaning up..."
cleanup
echo "----------------------------------------"
echo "Project setup complete. Run ./offline_$REPO_NAME.sh to recreate the repository offline in $PROJECT_DIR/$REPO_NAME"

EOF

# Make the generated script executable
chmod +x $OUTPUT_SCRIPT
echo "Generated setup_project.sh successfully"
