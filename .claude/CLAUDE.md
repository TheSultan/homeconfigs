# Global Claude Code Defaults

These instructions apply to every project unless overridden by a project-level CLAUDE.md.

## Agent Usage

- Use sub-agents proactively for tasks that can be parallelized or require broad codebase exploration.
- Spawn an Explore sub-agent for any search that would take more than 3 queries.
- Run independent research tasks in parallel via background agents rather than sequentially.
- Delegate open-ended analysis (e.g. "what files are affected by X?") to a sub-agent to protect the main context window.

## Engineering Principles (Karpathy-style)

- **Read before writing.** Understand the full context — relevant files, existing patterns, prior decisions — before proposing or making changes.
- **Prefer simple and boring.** Choose the well-understood approach over the clever one. New abstractions, frameworks, and patterns carry a cost; pay it only when the benefit is clear.
- **Don't over-engineer.** Solve the problem in front of you. Don't design for hypothetical future requirements or add indirection "just in case."
- **Three similar lines before abstracting.** Duplication is cheaper than the wrong abstraction. Wait until the pattern is proven before factoring it out.
- **Write code that is easy to delete.** Prefer loose coupling. The easier something is to remove, the safer it is to add.
- **No half-finished implementations.** Either implement a thing properly or don't add it. Placeholder logic, TODO stubs left in production paths, and feature-flagged dead code all rot.
- **Trust the stack.** Don't add error handling, fallbacks, or validation for scenarios the framework or internal code already guarantees. Validate only at system boundaries (user input, external APIs).

## Code Style

- Write no comments by default. Add a comment only when the WHY is non-obvious: a hidden constraint, a workaround for a specific bug, a subtle invariant. If removing the comment wouldn't confuse a future reader, don't write it.
- Never write multi-line comment blocks or docstrings narrating what the code does.
- Do not create documentation files (README, CHANGELOG, etc.) unless explicitly asked.
- Do not add features, refactor, or introduce abstractions beyond what the task requires.

## Prose Style

These rules apply to all written output — responses, emails, documents, comments.

- No em dashes (—). Use a comma or restructure the sentence.
- No semicolons in conversational prose. Split into two sentences.
- Never open with: "Certainly", "Of course", "Absolutely", "Great", "Sure", "Happy to", or "I'd be happy to".
- Avoid these words/phrases entirely: *delve*, *dive into*, *comprehensive*, *straightforward*, *leverage* (when "use" works), *utilize*, *in the realm of*, *it's worth noting*, *please note that*, *feel free to*, *don't hesitate to*.
- Don't use *furthermore* or *moreover* as default transitions — vary or cut them.
- No "As an AI..." disclaimers.
- No throat-clearing: drop "Let me...", "I'll go ahead and...", and similar filler.
- No closing offers ("Let me know if you need anything else!") unless asked.
- Use headers only in document-like output, not conversational replies.
- Use numbered lists only when order matters; use bullets sparingly; prefer prose.

## Security

- Default to secure code. Never introduce command injection, XSS, SQL injection, or other OWASP Top 10 vulnerabilities.
- Validate input only at system boundaries (user-facing endpoints, external API responses). Trust internal code.
- If you notice insecure code while working on a task, fix it immediately and note it explicitly.
- Never commit secrets, credentials, or tokens. Warn loudly if asked to.
