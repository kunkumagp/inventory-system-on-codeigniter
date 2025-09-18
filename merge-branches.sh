#!/bin/bash

# Script to soft reset the current branch, merge into dev, and then merge dev into main

# Define target branches
DEV_BRANCH="dev"
MAIN_BRANCH="main"

# Soft reset the current branch and apply changes to dev
echo "Soft resetting the current branch and applying changes to $DEV_BRANCH..."
git checkout $DEV_BRANCH || exit 1
git pull origin $DEV_BRANCH || exit 1
git merge --soft HEAD || exit 1

echo "Staging all changes..."
git add . || exit 1

echo "Enter a commit message for the changes applied to $DEV_BRANCH:"
read DEV_COMMIT_MESSAGE

echo "Committing changes to $DEV_BRANCH..."
git commit -m "$DEV_COMMIT_MESSAGE" || exit 1

echo "Pushing changes to remote $DEV_BRANCH..."
git push origin $DEV_BRANCH || exit 1

# Merge dev branch into main branch
echo "Switching to branch $MAIN_BRANCH..."
git checkout $MAIN_BRANCH || exit 1

echo "Pulling latest changes from $MAIN_BRANCH..."
git pull origin $MAIN_BRANCH || exit 1

echo "Merging $DEV_BRANCH into $MAIN_BRANCH..."
git merge $DEV_BRANCH || exit 1

echo "Pushing merged changes to remote $MAIN_BRANCH..."
git push origin $MAIN_BRANCH || exit 1

# Add a tag for the main branch
echo "Enter a tag name for the main branch (e.g., v1.0.0):"
read TAG_NAME

echo "Creating a tag $TAG_NAME for the main branch..."
git tag -a $TAG_NAME -m "Release version $TAG_NAME" || exit 1

echo "Pushing the tag $TAG_NAME to the remote repository..."
git push origin $TAG_NAME || exit 1

# Optional: Delete the specified branch locally and remotely
read -p "Do you want to delete the current branch? (y/n): " DELETE_BRANCH
if [[ $DELETE_BRANCH == "y" ]]; then
    echo "Deleting branch locally..."
    git branch -d $(git rev-parse --abbrev-ref HEAD) || exit 1

    echo "Deleting branch remotely..."
    git push origin --delete $(git rev-parse --abbrev-ref HEAD) || exit 1
fi

echo "Merge process completed successfully!"