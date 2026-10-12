# Tinycast 한글 포크

공식 본문은 `README.md`에 그대로 둔다. 최상단 배너만 “개인 포크 · 한글화 작업본”이라고 밝힌다. 이 파일이 한글본 운영 메모다.

- 디렉토리: `/Users/admin/Developer/tinycast-ko`
- 포크: https://github.com/qaws81877/tinycast
- 공식: https://github.com/abue-ammar/tinycast
- 작업 브랜치: **`ko-i18n`만**. `main`에 포크 변경을 쌓지 말 것.

## 현재 상태: 공식 한국어를 그대로 쓴다

공식 v0.12.3-beta.127부터 Tinycast가 한국어를 포함한 8개 언어를 기본 내장한다(`Tinycast/Resources/Localizable.xcstrings`, `InfoPlist.xcstrings`). 이 포크는 더 이상 자체 번역 계층(`.localized`, `Tinycast/Localizable.xcstrings`)을 두지 않는다.

그래서 `ko-i18n`은 `upstream/main` 위에 **포크 표시만** 얹은 브랜치다.

| 포크 변경 | 파일 |
| --- | --- |
| “개인 포크” 배너 | `README.md` |
| 로컬 세션 폴더 무시 | `.gitignore` (`.gjc/`) |
| 운영 메모 | `README.ko.md` |

번역이 어색하면 포크에서 고치지 말고 공식 카탈로그를 고쳐 PR로 올린다. 포크에서 덮어쓰면 업스트림 문자열이 바뀔 때마다 충돌한다.

## 원격

```
origin    = qaws81877/tinycast          # 개인 포크, push 대상
upstream  = abue-ammar/tinycast         # 공식, fetch만
```

## 언어

- 새로 설치하면 Mac의 첫 번째 언어가 지원 언어일 때 그 언어로, 아니면 영어로 시작하고, 그 선택을 저장한다. 이후 Mac 언어를 따라가지 않는다.
- 바꾸려면 설정 ▸ General ▸ Language. 앱을 다시 실행해야 적용된다.
- 저장된 값은 앱별 `AppleLanguages`(`defaults read com.tinycast.app.dev AppleLanguages`)다.
- 설정을 건드리지 않고 한 번만 보려면 `-AppleLanguages '(ko)'`로 Debug 빌드를 실행한다.
- 검색은 macOS 언어 목록을 따로 읽으므로 앱 언어와 별개로 동작한다.

## 공식 앱과 한글본을 섞지 말 것

`brew upgrade tinycast`는 공식 빌드를 가져온다. 한글본은 항상 이 저장소에서 Debug로 직접 빌드한다.

| | bundle id | 앱 |
| --- | --- | --- |
| brew 공식 | `com.tinycast.app` | `/Applications/Tinycast.app` |
| 이 포크 Debug | `com.tinycast.app.dev` | `/Applications/Tinycast Dev.app` |

설정·클립보드·TCC·로그인 항목이 bundle id로 갈라지므로 둘을 같이 써도 데이터가 덮이지 않는다. **같은 글로벌 핫키는 양쪽에서 잡지 말 것.**

서명 신원은 `Tinycast Self-Signed` (`docs/signing.md`). 한 번 만들면 Accessibility 허용이 빌드마다 풀리지 않는다.

## 공식 업데이트가 나오면

포크에 남은 변경이 README 몇 줄뿐이라 충돌은 거의 `README.md` 배너에서만 난다.

```sh
cd /Users/admin/Developer/tinycast-ko
git fetch upstream --no-tags
git checkout ko-i18n
git branch ko-i18n-backup-$(date +%Y%m%d) ko-i18n
git rebase upstream/main
# 충돌 해결 후 빌드·검증
git push --force-with-lease origin ko-i18n
```

- `--no-tags`: 업스트림 태그가 이 포크의 태그와 겹쳐 `git fetch upstream`만 하면 `would clobber existing tag`로 실패한다.
- rebase 대상은 **`ko-i18n`**. `git push --force-with-lease`는 이 브랜치에만. `main`에는 쓰지 말 것.
- 꼬이면 `git rebase --abort`. 이미 끝났다면 백업 브랜치나 `git reflog`로 되돌린다.
- 업데이트 후에는 `node Scripts/check-localizations.js`로 업스트림 카탈로그에 `ko`가 빠진 키가 없는지 본다. 번역 대상이 아닌 `URL`·`esc` 같은 키는 비어 있어도 된다.

## 빌드 · 설치

```sh
cd /Users/admin/Developer/tinycast-ko
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild -project Tinycast.xcodeproj -scheme Tinycast -configuration Debug \
  -derivedDataPath build/DerivedData build

ditto "build/DerivedData/Build/Products/Debug/Tinycast Dev.app" \
      "/Applications/Tinycast Dev.app"
open "/Applications/Tinycast Dev.app"
```

`/Applications/Tinycast.app`에는 복사하지 말 것.

## 확인

```sh
./Scripts/run-tests.sh
./Scripts/lint.sh        # swiftlint 필요: brew install swiftlint
```

## 이전 방식 (v0.11.19 이하)

`ko-i18n-pre-0.12.3` 브랜치에 옛 계층이 남아 있다. 영어 리터럴을 키로 두고 표시 경계에서 `.localized`를 붙이던 방식이며, 공식 네이티브 번역과 중복되고 충돌해서 v0.12.3에서 버렸다. 그 카탈로그의 번역(‘하세요’체, ‘퀵링크’)이 필요하면 거기서 꺼내 쓴다.

## 배포 (AGPL)

Tinycast는 AGPL-3.0이다. **지인에게 한글본을 나눠 주는 것 자체는 된다.** 공식인 척하거나, 소스 없이 `.app`만 뿌리면 안 된다.

해야 하는 것:

- 같은 AGPL로 주고, 수정본(포크)이라는 걸 밝힐 것
- 소스를 같이 줄 것 — 이 포크의 `ko-i18n`이면 충분 (https://github.com/qaws81877/tinycast)
- `LICENSE`와 `NOTICE.md`를 바이너리와 같이 둘 것

하지 말 것:

- 공식 Tinycast / brew `Tinycast.app`인 척하기
- 지인 머신에서 `/Applications/Tinycast.app`을 한글본으로 덮어쓰게 안내하기
- 소스 없이 `Tinycast Dev.app`만 보내기

줄 때는 `Tinycast Dev.app`(`com.tinycast.app.dev`)과 이 저장소 링크를 같이 주고, 공식 앱과 bundle id가 다르다고 말하면 된다. self-signed라 Gatekeeper 경고가 날 수 있다.
