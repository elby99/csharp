# C# Language Course Design

## Purpose

Prepare an experienced PHP developer to take confident ownership of a large brownfield C# application. The course prioritizes intimate understanding of the C# language: both its fundamentals and the features or semantics that differ materially from PHP.

The production context is .NET Framework 4.8 with ASP.NET MVC 5. Framework material is supporting context, not the curriculum's center.

## Success Criteria

The learner can:

- Read unfamiliar C# and accurately predict its behavior.
- Recognize language constructs common in mature .NET Framework codebases.
- Explain where superficially similar PHP and C# constructs have different semantics.
- Trace control flow through delegates, events, LINQ, exceptions, and asynchronous code.
- Make small, safe changes without accidentally changing ownership, null, disposal, or evaluation behavior.
- Distinguish features compatible with the project's likely language/tooling generation from newer C# features encountered elsewhere.

## Teaching Approach

Use a hybrid brownfield spiral. Introduce foundational syntax through realistic legacy-code examples, then revisit those foundations as more advanced features become relevant. Optimize for production code reading and modification rather than beginner programming exercises.

Every lesson is short, self-contained, and tied to the ownership mission. It provides one concrete win, a PHP comparison where useful, a code-reading or prediction exercise with immediate feedback, and a link to a high-trust primary source.

## Curriculum Sequence

1. Static types, compilation, variables, conversions, and control flow.
2. Classes, structs, interfaces, inheritance, and object construction.
3. Properties, fields, methods, access modifiers, and overload resolution.
4. Value semantics, reference semantics, equality, and null behavior.
5. Generics, arrays, and collection interfaces.
6. Delegates, events, lambdas, closures, and extension methods.
7. LINQ, iterator blocks, materialization, and deferred execution.
8. Exceptions, `using`, `IDisposable`, and resource ownership.
9. Tasks, `async`/`await`, synchronization, and legacy asynchronous patterns.
10. Attributes, reflection, expression trees, and compiler-generated behavior.

Topics may be reordered when learning records or real project examples reveal a more useful next step.

## Version Strategy

Each relevant construct receives one of three labels:

- **Brownfield baseline:** routinely expected in .NET Framework 4.8-era MVC 5 code.
- **Tooling-dependent:** usable only if the project's compiler and configured C# language version support it.
- **Modern recognition:** useful for broader fluency but not assumed safe to introduce into the target project.

The course will not equate .NET Framework version with C# language version. Project configuration and compiler tooling determine which language features are available.

## Lesson Artifacts

- `MISSION.md` records the ownership goal and constraints.
- `RESOURCES.md` contains annotated primary references and carefully selected communities.
- `assets/` contains the shared print-friendly stylesheet and reusable interactive components.
- `lessons/NNNN-*.html` contains concise interactive lessons.
- `reference/*.html` contains durable cheat sheets and comparisons.
- `learning-records/NNNN-*.md` records demonstrated understanding, prior knowledge, and corrected misconceptions.
- `NOTES.md` records stable teaching preferences.

## Lesson Shape

Each lesson contains:

1. A mission-linked outcome.
2. The minimum explanatory model needed for that outcome.
3. One or more PHP comparisons focused on semantic differences.
4. A realistic C# snippet representative of production code.
5. An effortful retrieval or behavior-prediction task.
6. Immediate feedback with an explanation, not merely the answer.
7. A compact reference takeaway.
8. A primary-source recommendation and an invitation to ask follow-up questions.

Quiz choices will be balanced in length where their presentation could otherwise reveal the answer.

## Knowledge and Evidence

Language claims will be grounded in official Microsoft documentation, the C# language reference, or the published language specification. Secondary sources are used only when they add practical interpretation and are clearly distinguished from normative sources.

Learning records are created only after the learner demonstrates understanding, states relevant prior knowledge, corrects a misconception, or changes the mission. Completing a lesson alone is not evidence of learning.

## Presentation and Reuse

Lessons use clean, readable, print-friendly HTML with restrained visual design. Shared styling and interaction logic live in reusable assets rather than being duplicated. Lessons and reference pages link to related course artifacts using relative paths.

## Scope Boundaries

The initial course does not attempt to teach MVC 5 architecture, IIS administration, Visual Studio operation, database design, or general programming fundamentals. These subjects enter only when necessary to explain how C# behaves in the target application.

The course also avoids prescribing modernization until the existing code's behavior and constraints are understood.

## Verification

Before publishing each lesson:

- Validate internal links and relative asset paths.
- Exercise interactive questions and feedback states.
- Check print layout and common desktop viewport rendering.
- Compile or otherwise validate C# examples against an explicitly stated language/tooling target when executable tooling is available.
- Confirm factual claims against the cited primary references.
