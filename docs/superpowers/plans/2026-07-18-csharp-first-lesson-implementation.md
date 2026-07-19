# C# First Lesson Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish the persistent C# teaching workspace and publish the first sourced, interactive lesson for an experienced PHP developer taking ownership of a .NET Framework 4.8/MVC 5 application.

**Architecture:** Markdown files hold mission and source state; shared CSS and JavaScript provide a reusable presentation layer; standalone HTML lesson and reference pages consume those assets through relative paths. A PowerShell verifier checks required artifacts, links, citations, and reusable-asset usage without introducing package dependencies.

**Tech Stack:** Markdown, HTML5, CSS3, browser JavaScript, PowerShell 5.1+, Microsoft Learn primary references.

## Global Constraints

- Prioritize intimate understanding of the C# language; .NET Framework 4.8 and MVC 5 are supporting context only.
- Optimize for production code reading and modification, not beginner programming drills.
- Label language features as **Brownfield baseline**, **Tooling-dependent**, or **Modern recognition**.
- Do not equate .NET Framework version with C# language version.
- Use official Microsoft documentation or the published C# specification for language claims.
- Keep lessons short, self-contained, print-friendly, and linked through relative paths.
- Record learning only after demonstrated understanding; do not create a learning record merely for publishing a lesson.
- The workspace is not a Git repository. Do not initialize Git during this plan; omit commit steps unless the user separately authorizes repository initialization.

---

## File Map

- `MISSION.md`: concrete ownership goal, observable success, and scope boundaries.
- `RESOURCES.md`: annotated primary C# sources and a community option.
- `NOTES.md`: stable teaching preferences and learner background.
- `tools/Test-Course.ps1`: dependency-free artifact and link verifier.
- `assets/course.css`: shared responsive and print-friendly course styling.
- `assets/quiz.js`: reusable accessible answer-feedback behavior.
- `reference/php-to-csharp-types.html`: durable PHP-to-C# type-system comparison.
- `lessons/0001-types-are-contracts.html`: first interactive lesson.

### Task 1: Workspace State and Verification Harness

**Files:**
- Create: `MISSION.md`
- Create: `RESOURCES.md`
- Create: `NOTES.md`
- Create: `tools/Test-Course.ps1`

**Interfaces:**
- Consumes: Approved design at `docs/superpowers/specs/2026-07-18-csharp-language-course-design.md`.
- Produces: Course metadata and `tools/Test-Course.ps1`, which exits `0` after all required artifacts and links are valid and exits `1` with readable failures otherwise.

- [ ] **Step 1: Write the verifier before creating course artifacts**

Create `tools/Test-Course.ps1`:

```powershell
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

$required = @(
    'MISSION.md',
    'RESOURCES.md',
    'NOTES.md',
    'assets/course.css',
    'assets/quiz.js',
    'reference/php-to-csharp-types.html',
    'lessons/0001-types-are-contracts.html'
)

foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative))) {
        $failures.Add("Missing required file: $relative")
    }
}

$htmlFiles = Get-ChildItem -LiteralPath $root -Recurse -Filter '*.html' -File
foreach ($file in $htmlFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    $links = [regex]::Matches($content, '(?:href|src)="([^"]+)"')
    foreach ($link in $links) {
        $target = $link.Groups[1].Value
        if ($target -match '^(?:https?:|#|mailto:)') { continue }
        $targetPath = Join-Path $file.DirectoryName $target
        if (-not (Test-Path -LiteralPath $targetPath)) {
            $failures.Add("Broken relative link in $($file.Name): $target")
        }
    }
}

$lesson = Join-Path $root 'lessons/0001-types-are-contracts.html'
if (Test-Path -LiteralPath $lesson) {
    $lessonText = Get-Content -Raw -LiteralPath $lesson
    foreach ($needle in @('../assets/course.css', '../assets/quiz.js', 'learn.microsoft.com', 'data-answer')) {
        if (-not $lessonText.Contains($needle)) {
            $failures.Add("First lesson is missing: $needle")
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    exit 1
}

Write-Host "Course verification passed: $($required.Count) required files and $($htmlFiles.Count) HTML files checked."
```

- [ ] **Step 2: Run the verifier and confirm the expected red state**

Run:

```powershell
& .\tools\Test-Course.ps1
```

Expected: exit code `1`, including `Missing required file: MISSION.md` and missing lesson/assets messages.

- [ ] **Step 3: Create the mission, resources, and notes**

Create `MISSION.md`:

```markdown
# Mission: C# Language Fluency for Brownfield Ownership

## Why
I am taking ownership of a large brownfield C# application built on .NET Framework 4.8 and ASP.NET MVC 5. I need to understand its C# intimately enough to reason about existing behavior and change it safely.

## Success looks like
- Read unfamiliar production C# and accurately predict its behavior.
- Explain important semantic differences between C# and PHP.
- Recognize both foundational and C#-specific constructs in a mature codebase.
- Make small changes without accidentally altering type, null, evaluation, or ownership behavior.

## Constraints
- I have more than ten years of PHP experience; avoid beginner programming instruction.
- Focus on the language, using MVC 5 and .NET Framework only as relevant context.
- Clearly distinguish brownfield-safe language features from tooling-dependent and modern features.

## Out of scope
- A general MVC 5, IIS, database, or Visual Studio course.
- Modernizing the production application before its behavior and constraints are understood.
```

Create `RESOURCES.md`:

```markdown
# C# Language Resources

## Knowledge

- [The C# type system — Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/)
  Primary overview of static typing, compile-time and run-time types, and value/reference distinctions. Use for the first lesson and type-system reference.
- [Language versioning — Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-versioning)
  Explains how target frameworks, compilers, and `LangVersion` interact. Use whenever labeling feature compatibility.
- [C# language specification — Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/)
  Normative source for exact syntax and semantics. Use when reference documentation is simplified or ambiguous.
- [C# specifications and feature proposals — Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/csharp/specification/)
  Index of the ECMA specification and newer feature specifications. Use to trace semantics introduced after the published standard.

## Wisdom (Communities)

- [C# Discord](https://discord.com/invite/csharp)
  Practitioner community useful for testing interpretations of surprising legacy code. Treat discussion as advice, then verify language claims against primary documentation.
```

Create `NOTES.md`:

```markdown
# Teaching Notes

- Learner has 10+ years of PHP experience.
- Prefer semantic comparisons and production code-reading exercises over introductory programming drills.
- Target application: .NET Framework 4.8, ASP.NET MVC 5.
- Keep the curriculum centered on C# language behavior.
```

- [ ] **Step 4: Run the verifier and confirm only later-task artifacts remain red**

Run:

```powershell
& .\tools\Test-Course.ps1
```

Expected: exit code `1`; metadata errors are gone, while missing assets, reference, and lesson remain.

### Task 2: Reusable Course Assets

**Files:**
- Create: `assets/course.css`
- Create: `assets/quiz.js`

**Interfaces:**
- Consumes: Semantic class names `eyebrow`, `lede`, `callout`, `comparison`, `quiz`, and `feedback` from lesson/reference HTML.
- Produces: print-friendly visual styling and click-driven quiz feedback for elements carrying `data-answer` and `data-correct`.

- [ ] **Step 1: Create the shared stylesheet**

Create `assets/course.css` with the complete implementation below:

```css
:root { color-scheme: light; --ink:#172033; --muted:#5f6878; --paper:#fbfaf7; --panel:#fff; --line:#d8dde7; --accent:#3157a4; --good:#176b45; --bad:#a23b3b; }
* { box-sizing: border-box; }
body { margin:0; background:var(--paper); color:var(--ink); font:17px/1.6 system-ui,-apple-system,"Segoe UI",sans-serif; }
main { width:min(760px,calc(100% - 32px)); margin:56px auto 96px; }
h1,h2 { line-height:1.18; letter-spacing:-.025em; }
h1 { font-size:clamp(2.2rem,7vw,4.4rem); margin:.15em 0 .3em; }
h2 { margin-top:2.2em; }
.eyebrow { color:var(--accent); font-weight:750; letter-spacing:.08em; text-transform:uppercase; }
.lede { color:var(--muted); font-size:1.2rem; }
.callout,.comparison,.quiz { background:var(--panel); border:1px solid var(--line); border-radius:14px; padding:20px; margin:24px 0; }
.comparison { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
pre { overflow:auto; padding:18px; border-radius:10px; background:#172033; color:#f2f5fb; font:14px/1.55 ui-monospace,SFMono-Regular,Consolas,monospace; }
code { font-family:ui-monospace,SFMono-Regular,Consolas,monospace; }
button { display:block; width:100%; margin:10px 0; padding:12px 14px; text-align:left; border:1px solid var(--line); border-radius:9px; background:#fff; color:var(--ink); font:inherit; cursor:pointer; }
button:hover,button:focus-visible { border-color:var(--accent); outline:2px solid transparent; }
button.correct { border-color:var(--good); background:#edf8f2; }
button.incorrect { border-color:var(--bad); background:#fff1f1; }
.feedback { min-height:1.6em; font-weight:650; }
a { color:var(--accent); }
footer { margin-top:56px; padding-top:20px; border-top:1px solid var(--line); color:var(--muted); }
@media (max-width:620px) { .comparison { grid-template-columns:1fr; } main { margin-top:32px; } }
@media print { body { background:#fff; font-size:11pt; } main { width:auto; margin:0; } button { display:none; } .callout,.comparison,.quiz { break-inside:avoid; } a { color:inherit; text-decoration:none; } }
```

- [ ] **Step 2: Create accessible reusable quiz behavior**

Create `assets/quiz.js`:

```javascript
document.querySelectorAll('[data-answer]').forEach((quiz) => {
  const expected = quiz.dataset.answer;
  const feedback = quiz.querySelector('.feedback');
  quiz.querySelectorAll('button[data-choice]').forEach((button) => {
    button.addEventListener('click', () => {
      const correct = button.dataset.choice === expected;
      quiz.querySelectorAll('button[data-choice]').forEach((candidate) => {
        candidate.classList.remove('correct', 'incorrect');
      });
      button.classList.add(correct ? 'correct' : 'incorrect');
      feedback.textContent = correct ? quiz.dataset.correct : quiz.dataset.incorrect;
      feedback.style.color = correct ? 'var(--good)' : 'var(--bad)';
    });
  });
});
```

- [ ] **Step 3: Run verification**

Run:

```powershell
& .\tools\Test-Course.ps1
```

Expected: exit code `1`; asset errors are gone and only the reference and lesson remain missing.

### Task 3: Durable PHP-to-C# Type Reference

**Files:**
- Create: `reference/php-to-csharp-types.html`

**Interfaces:**
- Consumes: `../assets/course.css`.
- Produces: stable anchor target `#compile-time-type` used by the first lesson.

- [ ] **Step 1: Create the type-system comparison page**

Create `reference/php-to-csharp-types.html` as a complete HTML5 document containing:

```html
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>PHP → C#: Type-system field guide</title><link rel="stylesheet" href="../assets/course.css"></head>
<body><main><p class="eyebrow">Quick reference · Brownfield baseline</p><h1>PHP → C#: types change what code means</h1>
<p class="lede">C# types participate in compilation, overload selection, permitted operations, representation, and dispatch. They are not merely annotations on PHP-like values.</p>
<h2 id="compile-time-type">Compile-time type versus run-time type</h2>
<pre><code>object value = "invoice"; // compile-time: object; run-time: string
Console.WriteLine(value.ToString());</code></pre>
<p>The declared type controls which members and implicit conversions are available and participates in overload resolution. The object’s run-time type controls virtual dispatch and run-time type tests.</p>
<h2>Fast comparison</h2><div class="comparison"><section><h3>PHP instinct</h3><p>A variable can hold values of unrelated types over its lifetime. Type declarations mainly constrain boundaries and assignments at run time.</p></section><section><h3>C# model</h3><p>Every expression has a compile-time type. A variable’s declared or inferred type does not change after declaration.</p></section></div>
<h2>Three distinctions to inspect</h2><ul><li><strong>Value/reference:</strong> assignment may copy a value or copy a reference.</li><li><strong>Static/run-time:</strong> the same object can be viewed through different compile-time types.</li><li><strong>Implicit/explicit conversion:</strong> a cast requests a defined conversion; it does not generally coerce arbitrary data.</li></ul>
<div class="callout"><strong>Version note:</strong> These fundamentals are brownfield baseline. Newer syntax can express types differently without removing these semantics.</div>
<footer>Primary sources: <a href="https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/">The C# type system</a> and <a href="https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/">C# language specification</a>.</footer>
</main></body></html>
```

- [ ] **Step 2: Run verification**

Run:

```powershell
& .\tools\Test-Course.ps1
```

Expected: exit code `1`; only `lessons/0001-types-are-contracts.html` remains missing.

### Task 4: First Interactive Lesson

**Files:**
- Create: `lessons/0001-types-are-contracts.html`

**Interfaces:**
- Consumes: `../assets/course.css`, `../assets/quiz.js`, and `../reference/php-to-csharp-types.html#compile-time-type`.
- Produces: the first course lesson and one learner-response prompt whose answer can later justify a learning record.

- [ ] **Step 1: Create the lesson**

Create `lessons/0001-types-are-contracts.html` as a complete HTML5 document containing:

```html
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Lesson 1: Types are contracts</title><link rel="stylesheet" href="../assets/course.css"><script src="../assets/quiz.js" defer></script></head>
<body><main><p class="eyebrow">Lesson 0001 · Brownfield baseline · 8 minutes</p><h1>Types are contracts, not labels</h1>
<p class="lede">Your win: predict which method an ordinary-looking call reaches before you trace into a large MVC 5 service layer.</p>
<div class="callout"><strong>Mission link:</strong> In brownfield C#, the type visible at the call site can matter as much as the object created at run time. Reading that distinction correctly prevents false control-flow assumptions.</div>
<h2>The model</h2><p>Every C# expression has a compile-time type. That type controls which members are available, which conversions are permitted, and which overload is selected. An object can also have a more specific run-time type, which matters for virtual dispatch and type tests.</p>
<div class="comparison"><section><h3>PHP instinct</h3><pre><code>function describe($value) { /* inspect at runtime */ }
describe("paid");</code></pre><p>The value arriving at run time dominates your mental model.</p></section><section><h3>C# adjustment</h3><pre><code>void Describe(object value) { }
void Describe(string value) { }
object status = "paid";
Describe(status);</code></pre><p>The call selects <code>Describe(object)</code> because <code>status</code> has compile-time type <code>object</code>.</p></section></div>
<h2>Why this surprises people</h2><p>Overload resolution occurs at compile time. It differs from overriding: an overridden virtual method is selected using the run-time object. Mature C# code often contains both mechanisms, so the first reading move is to identify the compile-time type at each call site.</p>
<section class="quiz" data-answer="object" data-correct="Correct. The variable’s compile-time type selects the object overload." data-incorrect="Not quite. Ignore the run-time string briefly and inspect the variable declaration."><h2>Predict before clicking</h2><pre><code>static string Render(object value) =&gt; "object";
static string Render(string value) =&gt; "string";

object invoiceId = "INV-42";
Console.WriteLine(Render(invoiceId));</code></pre><p>What is printed?</p><button type="button" data-choice="string">string</button><button type="button" data-choice="object">object</button><p class="feedback" aria-live="polite"></p></section>
<h2>Brownfield reading move</h2><ol><li>Find the variable, parameter, or property declaration.</li><li>Record its compile-time type.</li><li>List candidate overloads from that type context.</li><li>Only then consider virtual dispatch on the run-time object.</li></ol>
<div class="callout"><strong>Retrieve it:</strong> Without looking back, explain in one sentence why changing <code>object invoiceId</code> to <code>var invoiceId</code> changes this call. Send your sentence to your teacher for feedback; a learning record is created only after your explanation demonstrates the distinction.</div>
<p>Keep nearby: <a href="../reference/php-to-csharp-types.html#compile-time-type">PHP → C# type-system field guide</a>.</p>
<footer>Primary reading: <a href="https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/">The C# type system — Microsoft Learn</a>. Ask your teacher about anything that remains unclear or about a similar pattern from the production codebase.</footer>
</main></body></html>
```

- [ ] **Step 2: Run the complete verifier**

Run:

```powershell
& .\tools\Test-Course.ps1
```

Expected: exit code `0` and `Course verification passed: 7 required files and 2 HTML files checked.`

- [ ] **Step 3: Open and visually inspect the lesson**

Run:

```powershell
Start-Process (Resolve-Path '.\lessons\0001-types-are-contracts.html')
```

Expected: the lesson opens in the default browser. At a desktop width, the PHP and C# examples appear in two columns; at narrow width they stack; clicking each quiz answer updates the feedback and visual state; print preview hides buttons and preserves readable content.

- [ ] **Step 4: Confirm the course is ready for learner interaction**

Run:

```powershell
Get-ChildItem -Recurse -File | Sort-Object FullName | Select-Object FullName
```

Expected: the approved design and implementation plan plus all eight files in the File Map. Do not create `learning-records/0001-*.md` yet; wait for the learner’s retrieval response.
