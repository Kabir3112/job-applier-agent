#!/bin/bash
# Job Application Agent - Installer
# Works on macOS, Linux, and Windows (Git Bash/WSL)
#
# Installs from THIS clone, not from GitHub, so local patches survive.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/apply-job"
APPLIER_HOME="$HOME/job-applier-agent"

echo "Installing Job Application Agent from $SRC"

# Refuse to install a repo whose two SKILL.md copies disagree - upstream shipped
# one with confirmation prompts and one without.
if ! cmp -s "$SRC/SKILL.md" "$SRC/skills/apply-job/SKILL.md"; then
  echo "ERROR: SKILL.md and skills/apply-job/SKILL.md differ."
  echo "       These must be identical. Reconcile them before installing."
  exit 1
fi

# Create directories
mkdir -p "$APPLIER_HOME"/{data,resume,templates,applications,screenshots}
mkdir -p "$SKILL_DIR"

copy() {
  if [ ! -f "$1" ]; then
    echo "ERROR: missing $1"
    exit 1
  fi
  cp "$1" "$2"
}

echo "Installing skill files..."
for file in SKILL.md WORKFLOWS.md SETUP.md profile-template.json; do
  copy "$SRC/skills/apply-job/$file" "$SKILL_DIR/$file"
done

echo "Installing templates..."
for file in cover_letter.md cold_email.md; do
  copy "$SRC/templates/$file" "$APPLIER_HOME/templates/$file"
done

# Create profile from template (don't overwrite existing)
if [ ! -f "$APPLIER_HOME/data/profile.json" ]; then
    cp "$SRC/skills/apply-job/profile-template.json" "$APPLIER_HOME/data/profile.json"
fi

# Create empty applications tracker (don't overwrite existing)
if [ ! -f "$APPLIER_HOME/data/applications.json" ]; then
    echo '{"applications":[],"stats":{"total":0,"applied":0,"interviewed":0,"rejected":0,"offers":0,"emailsSent":0,"connectionsSent":0}}' > "$APPLIER_HOME/data/applications.json"
fi

# Create placeholder resume (don't overwrite existing)
if [ ! -f "$APPLIER_HOME/resume/master_resume.md" ]; then
    printf "# Your Resume\n\nAdd your full resume content here for tailoring.\n" > "$APPLIER_HOME/resume/master_resume.md"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "   1. Edit your profile: $APPLIER_HOME/data/profile.json"
echo "   2. Add your resume:   cp ~/Downloads/resume.pdf $APPLIER_HOME/resume/"
echo "   3. Configure Playwright MCP (@playwright/mcp) - see skills/apply-job/SETUP.md"
echo "   4. Start Claude:      claude"
echo "   5. Apply to jobs:     /apply-job <job-url>"
echo ""
