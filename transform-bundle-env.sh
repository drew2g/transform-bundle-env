#!/bin/bash

if [[ -z "${BUNDLE_DIR}" ]]; then
  BUNDLE_DIR="build"
fi
if [[ -z "${ENV_SRC}" ]]; then
  ENV_SRC=".env.example"
fi
if [[ -z "${ENV_TGT}" ]]; then
  ENV_TGT=".env"
fi

BUNDLE_TMP="$(BUNDLE_DIR)/tmp.js"
BUNDLE_FILE=./$(ls ./$(BUNDLE_DIR) | grep .js)
ENV_TMP=.env.tmp

transformExample() {
    cat "$ENV_SRC" | grep -v "#" | sed '/^$d;s/[[:blank:]]//g' > $ENV_TMP
    replace_pattern="REPLACE_"

    cp $ENV_TGT "${ENV_TGT}.bak"
    > $ENV_TGT

    while IFS= read -r line; do
        # Extract key and value from the input line
        key=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2-)
        new_value="${replace_pattern}${key}"
        echo "${key}=\"${new_value}\"" >> $ENV_TGT
    done < $ENV_TMP

    rm $ENV_TMP
}

# Function to safely escape special characters for sed
escape_sed_delimiters() {
    local input="$1"
    # Escape forward slashes and ampersands, but not single or double quotes
    echo "$input" | sed 's/[\/&]/\\&/g'
}

transformBundle() {
    # Make a copy of the source file to work with
    cp "$BUNDLE_FILE" "$ENV_TMP"

    # Process each key-value pair in the input file
    while IFS= read -r line; do
        # Extract key and value from the input line
        key=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2-)

        # Construct the pattern to replace
        pattern="\"REPLACE_${key}\""

        # Escape the pattern and value for sed
        escaped_pattern=$(escape_sed_delimiters "$pattern")
        escaped_value=$(escape_sed_delimiters "$value")

        # Use sed to replace occurrences in the temp file
        sed -i "s|${escaped_pattern}|${escaped_value}|g" "$ENV_TMP"
    done < "$ENV_TGT"

    # Move the modified temp file back to the original source file
    mv "$ENV_TMP" "$BUNDLE_FILE"

    echo "Replacements have been made and saved to $BUNDLE_FILE."
}
