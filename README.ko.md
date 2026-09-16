# Tinycast 한글 포크

공식 `README.md`는 건드리지 않는다. 이 파일이 한글본 운영 메모다.

- 디렉토리: `/Users/admin/Developer/tinycast-ko`
- 포크: https://github.com/qaws81877/tinycast
- 공식: https://github.com/abue-ammar/tinycast
- 작업 브랜치: **`ko-i18n`만**. `main`에 한글을 쌓지 말 것.

## 원격

```
origin    = qaws81877/tinycast          # 개인 포크, push 대상
upstream  = abue-ammar/tinycast         # 공식, fetch만
```

## 왜 영어를 코드에 남기는가

업스트림이 문자열 위치를 옮길 때마다 충돌 나지 않게, **번역은 카탈로그 파일에만** 둔다.

| 역할 | 파일 |
| --- | --- |
| 영어 → 한국어 | `Tinycast/Localizable.xcstrings` |
| 권한 설명 등 Info.plist | `Tinycast/InfoPlist.xcstrings` |
| 런타임 조회 | `Tinycast/Platform/LocalizedString.swift` (`String.localized`) |

코드의 영어 리터럴은 키다. 카탈로그에 없으면 영어가 그대로 나온다. 앱 이름·사용자 스니펫·확장 문자열은 키에 없으니 번역되지 않는다.

표시는 런처 행, 설정, 다이얼로그, HUD, 온보딩, 메뉴 등 **표시 경계**에서만 `.localized` 한다. 검색은 영어 이름을 유지하고, 한글명은 alias로 붙는다.

SwiftUI `Button("Settings")` 같은 리터럴은 카탈로그만 있으면 자동 번역된다.

## 공식 앱과 한글본을 섞지 말 것

`brew upgrade tinycast`는 한글을 가져오지 않는다. 한글본은 항상 이 저장소에서 Debug로 직접 빌드한다.

| | bundle id | 앱 |
| --- | --- | --- |
| brew 공식 | `com.tinycast.app` | `/Applications/Tinycast.app` |
| 이 포크 Debug | `com.tinycast.app.dev` | `/Applications/Tinycast Dev.app` |

설정·클립보드·TCC·로그인 항목이 bundle id로 갈라지므로 둘을 같이 써도 데이터가 덮이지 않는다. **같은 글로벌 핫키는 양쪽에서 잡지 말 것.**

서명 신원은 `Tinycast Self-Signed` (`docs/signing.md`). 한 번 만들면 Accessibility 허용이 빌드마다 풀리지 않는다.

## 공식 업데이트가 나오면

```sh
cd /Users/admin/Developer/tinycast-ko
git fetch upstream
git checkout ko-i18n
git rebase upstream/main
# 충돌 해결 후
git push --force-with-lease origin ko-i18n
```

- rebase 대상은 **`ko-i18n`**. `main`에 한글을 올리지 말 것.
- `git push --force-with-lease`는 **번역 브랜치에만**. `main`에는 쓰지 말 것.
- 꼬이면 `git rebase --abort`. 이미 진행 중이면 `git reflog`에서 rebase 전 커밋으로 되돌린다.

충돌이 잘 나는 곳:

1. 표시 경계 Swift (업스트림이 그 줄을 고친 경우) — 영어 쪽을 살린 뒤 `.localized`만 다시 붙인다.
2. `Tinycast/Localizable.xcstrings` — 번역 쪽을 살린다.
3. `Scripts/run-tests.sh`의 `settings-history-test` 소스 목록 — `Tinycast/Platform/LocalizedString.swift`가 빠져 있으면 컴파일이 깨진다.

새 영어 UI가 화면에 그대로 보이면 키가 카탈로그에 없는 것이다. `Localizable.xcstrings`에 `en` 키와 `ko` 값을 추가한다. 포맷 문자열은 `"Open %@"`처럼 `%@`를 키로 쓴다.

Info.plist 권한 문구가 바뀌면 `InfoPlist.xcstrings`도 같이 고친다.

`project.yml`을 건드렸으면:

```sh
xcodegen generate
```

## 빌드 · 설치

```sh
cd /Users/admin/Developer/tinycast-ko
xcodebuild -project Tinycast.xcodeproj -scheme Tinycast -configuration Debug \
  -derivedDataPath build/DerivedData build

ditto "build/DerivedData/Build/Products/Debug/Tinycast Dev.app" \
      "/Applications/Tinycast Dev.app"
open "/Applications/Tinycast Dev.app"
```

`/Applications/Tinycast.app`에는 복사하지 말 것. macOS 언어가 한국어일 때 한글 UI가 나온다.

## 확인

```sh
./Scripts/run-tests.sh
```

`settings-history-test`는 `LocalizedString.swift`를 같이 컴파일해야 한다. `icon-cache-test` / `ext-test`는 이 포크와 무관한 기존 실패일 수 있다.

## 배포 (AGPL)

Tinycast는 AGPL-3.0이다. **지인에게 한글본을 나눠 주는 것 자체는 된다.** 공식인 척하거나, 소스 없이 `.app`만 뿌리면 안 된다.

해야 하는 것:

- 같은 AGPL로 주고, 수정본(한글 포크)이라는 걸 밝힐 것
- 소스를 같이 줄 것 — 이 포크의 `ko-i18n`이면 충분 (https://github.com/qaws81877/tinycast)
- `LICENSE`와 `NOTICE.md`를 바이너리와 같이 둘 것

하지 말 것:

- 공식 Tinycast / brew `Tinycast.app`인 척하기
- 지인 머신에서 `/Applications/Tinycast.app`을 한글본으로 덮어쓰게 안내하기
- 소스 없이 `Tinycast Dev.app`만 보내기

줄 때는 `Tinycast Dev.app`(`com.tinycast.app.dev`)과 이 저장소 링크를 같이 주고, 공식 앱과 bundle id가 다르다고 말하면 된다. self-signed라 Gatekeeper 경고가 날 수 있다.
