# Cold Email Template

**These are drafts only.** The agent writes them into
`applications/<Company>/outreach_queue.md`. [Your Name] sends them himself.

## Subject Line

`[Role] application - [Your Name]` — or, only if there is a genuine specific hook:
`[Role] application - 2 yrs fintech delivery, FinIQ`

Avoid "Referral Request" as a subject to someone who has never met you. It asks for
a favour before establishing why you are worth it.

## Body

Hi [First Name],

I've just applied for the [Role] role at [Company] and wanted to introduce myself briefly.

I spent two years at FinIQ Consulting delivering structured financial software for international banking clients — gathering requirements, coordinating engineering and QA through releases, and leading SQL-based regression automation to cut manual testing effort. I'm now finishing an MSc in Management and Technological Change at King's College London.

[One specific sentence about this company or role. Reference something concrete — a product, a recent launch, how the role is scoped. If there is nothing specific to say, delete this line rather than padding it.]

If it's useful I'm happy to share more detail on any of the above. Either way, thanks for your time.

Best regards,
[Your Name]
[Phone] | [Email]
[Portfolio URL]

---

## LinkedIn Note (300 character limit)

Hi [First Name] — I've applied for the [Role] role at [Company]. Two years delivering fintech software at FinIQ (requirements, QA, SQL automation), now finishing an MSc at King's. Would be glad to connect.

---

## Template Variables

| Variable | Source |
|----------|--------|
| `[First Name]` | Recruiter or hiring manager, from public sources |
| `[Role]` | Job title |
| `[Company]` | Company name |

Fixed details (name, phone, email, site, FinIQ background, KCL) come from
`profile.json` and `master_resume.md`. Do not re-derive them.

## Rules

1. **Under 150 words.** The version above is roughly 120.
2. **One concrete company-specific line, or none.** Generic flattery reads worse than brevity.
3. **Lead with the two years of delivery experience, not the degree.** Experience is the differentiator; the MSc is context.
4. **Never claim a referral relationship that doesn't exist.**
5. **Never state metrics that aren't in `master_resume.md`.** No invented percentages.
6. **Never mention visa or sponsorship status in a cold email.** If asked, answer with the wording in `profile.json.work_authorization.accurate_form_wording`.
7. **Max 3 contacts per company.** More than that is a mail merge, not outreach.
8. **Agent never sends.** Draft goes to the queue file; [Your Name] reviews and sends.
