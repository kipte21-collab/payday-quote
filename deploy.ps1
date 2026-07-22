# 견적서 시스템 배포 스크립트
# 가장 최근에 수정된 견적서_시스템*.html 파일을 index.html로 복사한 뒤 GitHub에 push합니다.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$src = Get-ChildItem -Path $PSScriptRoot -Filter '견적서_시스템*.html' -File |
       Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $src) {
  Write-Host "오류: 견적서_시스템*.html 파일을 찾을 수 없습니다." -ForegroundColor Red
  exit 1
}

Write-Host "배포 대상: $($src.Name) (수정: $($src.LastWriteTime))" -ForegroundColor Cyan
Copy-Item $src.FullName -Destination (Join-Path $PSScriptRoot 'index.html') -Force

git add index.html
$pending = git status --porcelain index.html
if (-not $pending) {
  Write-Host "변경사항이 없습니다. (index.html이 이미 최신 상태)" -ForegroundColor Yellow
  exit 0
}

$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm'
git commit -m "update: $($src.Name) ($stamp)"
git push origin main

Write-Host ""
Write-Host "배포 완료! 약 30초~1분 후 반영됩니다:" -ForegroundColor Green
Write-Host "https://kipte21-collab.github.io/payday-quote/" -ForegroundColor Green
