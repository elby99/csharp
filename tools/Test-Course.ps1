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
        $targetPathPart = ($target -split '[?#]', 2)[0]
        $targetPath = Join-Path $file.DirectoryName $targetPathPart
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
