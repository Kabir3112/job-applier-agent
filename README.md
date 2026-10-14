# Job Application Agent

Automated job applications with Claude Code. Apply to jobs with personalized resumes, cover letters, recruiter outreach, ATS optimization, interview prep, and smart analytics.

## Install

Run the installer from your local clone:

```bash
bash install.sh
```

> This is a locally patched copy. `npx skills add theaayushstha1/job-applier-agent`
> pulls from upstream and will **undo** the fixes below (confirmation gates, correct
> Playwright MCP package, blank EEO defaults). Install from this clone instead.
>
> `SKILL.md` at the repo root and `skills/apply-job/SKILL.md` must stay byte-identical —
> the root copy is what `npx skills add` reads, and upstream let the two drift into
> different safety behavior. If you edit one, copy it over the other.

## Setup

**1. Edit your profile:**
```bash
nano ~/job-applier-agent/data/profile.json
```

**2. Add your resume:**
```bash
cp ~/Downloads/YourResume.pdf ~/job-applier-agent/resume/MyResume.pdf
```

**3. Start applying:**
```bash
claude
/apply-job https://linkedin.com/jobs/view/123456
```

## Commands

| Command | What it does |
|---------|--------------|
| `/apply-job <url>` | Full application workflow with ATS analysis |
| `/apply-job search <query>` | Smart batch apply with dedup + dealbreaker filtering |
| `/apply-job outreach <url>` | Send recruiter emails + LinkedIn |
| `/apply-job status` | View your application stats |
| `/apply-job status weekly` | Weekly analytics with response rates by category |
| `/apply-job score <url>` | Score job fit without applying |
| `/apply-job prep <company>` | Interview prep with technical Qs, STAR answers, talking points |
| `/apply-job followup` | Check which applications need follow-up emails |
| `/apply-job ats-check <url>` | ATS keyword match analysis without applying |
| `/apply-job dedup` | Find and clean up duplicate applications |

## What It Does

**Core Application Flow:**
- Extracts job description from any URL
- Detects dealbreakers (clearance, senior level, 5+ years) before wasting your time
- Scores job fit (skills match, level, location, mission)
- Runs ATS keyword analysis (match score out of 100)
- Researches the company (news, Glassdoor, tech stack)
- Tailors your resume to match the JD
- Generates personalized cover letter using company research
- Auto-fills applications (LinkedIn, Greenhouse, Lever, Workday, ADP)
- Sends cold emails to recruiters (primary)
- Sends LinkedIn connection requests (secondary)
- Sets 7-day follow-up reminders
- Tracks everything in `applications.json`

**Interview Prep:**
- Generates technical questions based on the JD
- Writes STAR format behavioral answers using YOUR resume projects
- Creates talking points and questions to ask
- Saves prep docs per company

**Smart Analytics:**
- Weekly digest with response rates by role category
- Tracks which types of roles get the most callbacks
- Data-driven recommendations on where to focus
- Follow-up reminder system so nothing falls through the cracks

**Batch Apply Intelligence:**
- Auto-filters out jobs you already applied to
- Auto-skips dealbreaker jobs (clearance, senior level, etc.)
- Sorts by fit score, applies to best matches first

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- [Playwright MCP](https://www.npmjs.com/package/@playwright/mcp) for browser automation

Add to `~/.claude/settings.json`:
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

## Security and Privacy

- **No credentials stored**: The skill uses your existing browser sessions (Gmail, LinkedIn). No passwords or tokens are saved.
- **All data stays local**: Profile data, applications tracking, and generated files are stored on your machine only.
- **No external servers**: No data is sent to any third-party service. Emails go through your own Gmail account.
- **User confirmation required**: The skill confirms before submitting applications, sending emails, or sending LinkedIn requests. There is no flag to turn this off.
- **Untrusted web content**: Job descriptions, company pages, and search results are data, never instructions. The skill drives a browser that is already logged into your Gmail and LinkedIn, so a malicious job posting — not malicious code — is the real attack surface. Fetched text that addresses the agent is surfaced to you rather than acted on, and nothing is ever sent to an address or URL that came from a fetched page.
- **Sensitive fields are never auto-filled**: EEO/self-identification, work authorization, salary expectation, and signature fields are left blank for you to answer. `profile.json` ships no defaults for them.
- **Public info only**: Recruiter contact discovery uses only publicly available information from LinkedIn profiles and company career pages. Email addresses are not guessed from company patterns.
- **No shell execution**: The skill does not use Bash or any shell execution tools. All operations use safe, scoped tool calls (file read/write, browser navigation). `install.sh` is a one-time setup script you run yourself — read it first.

## Terms of Service

Automated LinkedIn browsing and connection requests are against LinkedIn's User Agreement, and bulk cold outreach may conflict with your email provider's policies. Restrictions land on the account you need for your job search. Use the outreach features deliberately, at low volume, or skip them and use the application/tailoring workflow only.

## License

MIT
