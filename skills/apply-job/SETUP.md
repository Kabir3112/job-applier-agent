# Setup Guide

Complete installation and configuration guide for the Job Application Agent.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Quick Install](#quick-install)
- [Manual Setup](#manual-setup)
- [Configuration](#configuration)
- [Playwright MCP Setup](#playwright-mcp-setup)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

1. **Claude Code CLI** installed and authenticated
2. **Node.js** 18+ (for Playwright MCP)
3. A browser you are logged into for job sites (the skill never touches Gmail or LinkedIn)

---

## Quick Install

### Clone and Setup (Recommended)

```bash
# Clone the repository
git clone https://github.com/theaayushstha1/job-applier-agent.git ~/job-applier-agent

# Review the install script before running
cat ~/job-applier-agent/install.sh

# Run setup script - installs from the clone, so local edits are preserved
cd ~/job-applier-agent && bash install.sh
```

`install.sh` refuses to run if the repo's two `SKILL.md` copies have drifted apart.

### Installing via npx

```bash
npx skills add https://github.com/theaayushstha1/job-applier-agent --skill apply-job
```

This always fetches upstream and overwrites any local changes. If you are running a
patched copy, use the clone method above instead.

---

## Manual Setup

### Step 1: Create Directory Structure

```bash
mkdir -p ~/job-applier-agent/{data,resume,templates,applications,screenshots}
```

### Step 2: Install the Skill

The skill files live in `skills/apply-job/` in this repo.

**Option A: Copy to Claude skills directory**
```bash
# macOS/Linux
mkdir -p ~/.claude/skills/apply-job
cp -r ./skills/apply-job/* ~/.claude/skills/apply-job/

# Windows (PowerShell)
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\apply-job"
Copy-Item -Recurse .\skills\apply-job\* "$env:USERPROFILE\.claude\skills\apply-job\"
```

**Option B: Symlink (for development)**
```bash
ln -s "$PWD/skills/apply-job" ~/.claude/skills/apply-job
```

### Step 3: Create Configuration Files

```bash
# Copy profile template
cp ~/job-applier-agent/profile-template.json ~/job-applier-agent/data/profile.json

# Create empty applications tracker
echo '{"applications":[],"stats":{"total":0,"applied":0,"interviewed":0,"rejected":0,"offers":0,"outreachDraftsPrepared":0,"outreachMarkedSent":0},"lastUpdated":""}' > ~/job-applier-agent/data/applications.json
```

### Step 4: Configure Your Profile

Edit `~/job-applier-agent/data/profile.json` with your information:

```bash
# Open in your preferred editor
code ~/job-applier-agent/data/profile.json
# or
nano ~/job-applier-agent/data/profile.json
```

**Required fields to update:**
- `personal.name` - Your full name
- `personal.email` - Your email
- `personal.phone` - Your phone number
- `links.website` - Your portfolio/website
- `links.linkedin` - Your LinkedIn URL
- `education.*` - Your education details
- `top_skills` - Your main skills
- `flagship_project.*` - Your best project
- `resume_file` - Path to your resume PDF

### Step 5: Add Your Resume

```bash
# Copy your resume to the agent directory
cp /path/to/your/resume.pdf ~/job-applier-agent/resume/MyResume.pdf

# Create master resume markdown (for tailoring)
# This should contain ALL your experience, projects, skills
touch ~/job-applier-agent/resume/master_resume.md
```

### Step 6: Create Templates

**Cover Letter Template** (`~/job-applier-agent/templates/cover_letter.md`):
```markdown
[Your Name]
[Your Email] | [Your Phone] | [Your Location]
[Your LinkedIn] | [Your Website]

[Date]

Hiring Team
[Company Name]
[Location]

Dear Hiring Team,

I'm applying for the [Role] position at [Company]. [Opening hook - why you're interested].

[Paragraph about relevant experience and skills that match the JD]

[Paragraph about specific project that demonstrates your capabilities]

[Closing - enthusiasm + call to action]

Sincerely,
[Your Name]
```

**Cold Email Template** (`~/job-applier-agent/templates/cold_email.md`):
```markdown
Subject: Referral Request - [Role] Application | [School] [Major] Senior

Hi [First Name],

I just applied for the [Role] position at [Company] and wanted to reach out.

I'm a [Major] senior at [School] ([GPA] GPA) graduating [Graduation]. [Flagship project one-liner with metrics].

[1-2 sentences about why THIS company excites you]

Would appreciate if you could review my application or put in a referral.

Thanks!
[Name]
[Website]
[Phone]
```

---

## Configuration

### Environment Variables (Optional)

```bash
# Add to ~/.bashrc or ~/.zshrc
export APPLIER_HOME="$HOME/job-applier-agent"
```

There is no switch to disable the confirmation prompts. Submitting an application,
sending an email, and sending a LinkedIn request always require explicit approval.

### Profile.json Reference

See [profile-template.json](profile-template.json) for complete schema.

**Key sections:**
- `personal` - Contact information
- `links` - Website, LinkedIn, GitHub
- `education` - School, degree, GPA
- `top_skills` - Primary skills (shown in emails)
- `all_skills` - Complete skill inventory
- `flagship_project` - Your best project for outreach
- `work_authorization` - Visa/authorization status
- `preferences` - Location, job type preferences
- `application_defaults` - Default answers for forms

---

## Playwright MCP Setup

The agent uses Playwright MCP for browser automation.

### Install Playwright MCP

The package is `@playwright/mcp` (published by Microsoft, the Playwright team).

```bash
# Install globally
npm install -g @playwright/mcp

# Or use npx (no install needed)
npx @playwright/mcp@latest
```

### Configure Claude Code

Add to your Claude Code MCP settings (`~/.claude/settings.json`):

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

> **Note:** earlier versions of these docs listed `@anthropic/mcp-playwright`. That
> package does not exist on npm and the `@anthropic` scope is unpublished — pointing
> `npx` at an unclaimed name means anyone who later registers it gets code execution
> on every Claude Code launch. Use `@playwright/mcp`.

### Verify Installation

```bash
# Start Claude Code and check MCP tools are available
claude

# In Claude, type:
/mcp
# Should show playwright tools available
```

---

## Testing

### Test 1: Check Files Exist

```bash
ls -la ~/job-applier-agent/
# Should show: data/, resume/, templates/, applications/, screenshots/

ls -la ~/job-applier-agent/data/
# Should show: profile.json, applications.json
```

### Test 2: Verify Skill Installation

```bash
ls -la ~/.claude/skills/apply-job/
# Should show: SKILL.md, WORKFLOWS.md, SETUP.md, profile-template.json
```

### Test 3: Test with Score Only

```bash
claude
# Then type:
/apply-job score https://linkedin.com/jobs/view/123456
```

This tests extraction and scoring without applying.

### Test 4: Full Test (Recommended)

```bash
# Find a real job posting you're interested in
/apply-job https://linkedin.com/jobs/view/REAL_JOB_ID
```

Watch the automation and verify:
- Profile data is loaded correctly
- Resume/cover letter are generated
- Application form is filled correctly
- Emails are sent to correct addresses

---

## Troubleshooting

### Skill Not Found

```
Error: Skill 'apply-job' not found
```

**Fix**: Ensure SKILL.md is in the correct location:
```bash
ls ~/.claude/skills/apply-job/SKILL.md
```

### Profile Not Loading

```
Error: Cannot read profile.json
```

**Fix**: Check file exists and is valid JSON:
```bash
cat ~/job-applier-agent/data/profile.json | jq .
```

### Playwright Tools Missing

```
Error: Tool mcp__playwright__* not available
```

**Fix**:
1. Check MCP server is configured in settings.json
2. Restart Claude Code
3. Run `/mcp` to verify tools are loaded

### Path Issues (Windows)

If paths aren't resolving correctly on Windows:

```powershell
# Use $env:USERPROFILE instead of ~
$env:APPLIER_HOME = "$env:USERPROFILE\job-applier-agent"
```

---

## Directory Structure

```
~/job-applier-agent/
├── data/
│   ├── profile.json          # Your personal info
│   └── applications.json     # Application tracking
├── resume/
│   ├── MyResume.pdf          # Your resume file
│   └── master_resume.md      # Full resume content for tailoring
├── templates/
│   ├── cover_letter.md       # Cover letter template
│   └── cold_email.md         # Email template
├── applications/
│   └── <Company>/            # Per-company generated files
│       ├── resume_tailored.md
│       └── cover_letter.txt
└── screenshots/
    └── <company>_<date>.png  # Application confirmations

~/.claude/skills/apply-job/
├── SKILL.md                  # Main skill definition
├── WORKFLOWS.md              # Detailed workflows
├── SETUP.md                  # This file
└── profile-template.json     # Profile template
```

---

## Updating

To update the skill to the latest version:

```bash
cd ~/job-applier-agent
git pull origin main
cp -r ./skills/apply-job/* ~/.claude/skills/apply-job/
```

---

## Uninstalling

```bash
# Remove skill
rm -rf ~/.claude/skills/apply-job

# Remove data (optional - keeps your applications history)
rm -rf ~/job-applier-agent
```

---

**Need Help?** Open an issue on GitHub or check the troubleshooting section above.
