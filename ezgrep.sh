#!/bin/bash

# Function to display a welcome message
function welcome_message() {
    echo "    ___________                       "
    echo "   / ____/__  /  ____  ________  ____ "
    echo "  / __/    / /  / __ \/ ___/ _ \/ __ \ "
    echo " / /___   / /__/ /_/ / /  /  __/ /_/ /"
    echo "/_____/  /____/\__, /_/   \___/ .___/ "
    echo "              /____/         /_/"
    echo ""
    echo "by terribledactyl"
    echo "it's just grep with extra steps and not as good"
    echo ""
    echo "------------------------------------------------"
    echo ""
    echo "Welcome to the interactive grep search script!"
    echo "This script will help you search for specific keywords within files in a given directory."
    echo "You can choose to search recursively through subdirectories, specify whole word matching, case insensitivity, and search for multiple keywords."
    echo
}

# Function to prompt user for keywords
function get_keywords() {
    read -p "Enter the keywords to search for (separate with commas): " keywords
    if [[ -z "$keywords" ]]; then
        echo "Keywords cannot be empty. Please try again."
        get_keywords
    else
        # Convert comma-separated keywords into an array
        IFS=',' read -r -a keywords_array <<< "$keywords"
    fi
}

# Function to prompt user for a directory
function get_directory() {
    read -p "Enter the directory to search in: " directory
    if [[ -z "$directory" ]]; then
        echo "Directory cannot be empty. Please try again."
        get_directory
    elif [[ ! -d "$directory" ]]; then
        echo "The specified directory does not exist. Please try again."
        get_directory
    fi
}

# Function to prompt user for recursion option
function get_recursion_option() {
    read -p "Do you want to search recursively? (yes/no): " recursive
    case "$recursive" in
        [Yy]* )
            recursive_flag="-r"
            ;;
        [Nn]* )
            recursive_flag=""
            ;;
        * )
            echo "Please answer yes or no."
            get_recursion_option
            ;;
    esac
}

# Function to prompt user for whole word match option
function get_whole_word_option() {
    read -p "Do you want to match whole words only? (yes/no): " whole_word
    case "$whole_word" in
        [Yy]* )
            whole_word_flag="-w"
            ;;
        [Nn]* )
            whole_word_flag=""
            ;;
        * )
            echo "Please answer yes or no."
            get_whole_word_option
            ;;
    esac
}

# Function to prompt user for case insensitive option
function get_case_insensitive_option() {
    read -p "Do you want to perform a case-insensitive search? (yes/no): " case_insensitive
    case "$case_insensitive" in
        [Yy]* )
            case_flag="-i"
            ;;
        [Nn]* )
            case_flag=""
            ;;
        * )
            echo "Please answer yes or no."
            get_case_insensitive_option
            ;;
    esac
}

# Function to construct grep pattern from keywords
function construct_grep_pattern() {
    grep_pattern=""
    for keyword in "${keywords_array[@]}"; do
        # Trim leading and trailing whitespace from keywords
        trimmed_keyword=$(echo "$keyword" | xargs)
        if [[ -n "$grep_pattern" ]]; then
            grep_pattern="$grep_pattern|$trimmed_keyword"
        else
            grep_pattern="$trimmed_keyword"
        fi
    done
}

# Function to perform the search using grep
function perform_search() {
    echo "Searching for the following keywords in directory '$directory':"
    for keyword in "${keywords_array[@]}"; do
        echo "  - $keyword"
    done
    echo "With the following options:"
    echo "  Recursion: $recursive_flag"
    echo "  Whole word match: $whole_word_flag"
    echo "  Case insensitivity: $case_flag"
    echo

    grep $recursive_flag $whole_word_flag $case_flag -n -E "$grep_pattern" "$directory"
}

# Main script execution
welcome_message
get_keywords
get_directory
get_recursion_option
get_whole_word_option
get_case_insensitive_option
construct_grep_pattern
perform_search
