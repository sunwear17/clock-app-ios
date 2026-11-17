# ClockApp — 原生 SwiftUI 時鐘

一個 iOS 原生時鐘 App（SwiftUI + Canvas），含類比指針、數字時間、中文日期。

## 架構

```
ClockApp/
  ClockApp.swift      App 入口
  ContentView.swift   時鐘畫面（Canvas 繪製）
project.yml           XcodeGen 專案定義
.github/workflows/build-ios.yml   雲端編譯成 IPA
```

**冇 Mac 都編譯得**：GitHub Actions 用 macOS runner 幫你出 IPA。

---

## 步驟 1：上傳到 GitHub

```bash
cd clock-app-ios
git init
git add .
git commit -m "ClockApp: SwiftUI clock"
git branch -M main
git remote add origin https://github.com/<你的帳號>/clock-app-ios.git
git push -u origin main
```

> repo 要設為 **Public**（私有 repo 用 macOS runner 要收費；公開完全免費）。

## 步驟 2：等 GitHub 編譯

push 之後去 `Actions` tab → `Build unsigned IPA` → 等約 3–5 分鐘。

完成後喺 run 頁面底部 **Artifacts** 下載 `ClockApp-ipa.zip`，解壓得到 `ClockApp.ipa`。

亦可以手動觸發：Actions → 選 workflow → **Run workflow**。

## 步驟 3：Windows 簽名 + 安裝

1. 下載 **Sideloadly**（sideloadly.io）
2. iPhone 用 USB 連電腦，解鎖並「信任此電腦」
3. 開 Sideloadly：
   - **IPA**：揀啱啱下載嘅 `ClockApp.ipa`
   - **Apple ID**：輸入你嘅 Apple ID
   - 撳 Start，輸入 Apple ID 密碼（同兩步驗證碼）
4. 完成後 iPhone 會出現圖示

### 首次開啟要信任

iPhone → 設定 → 通用 → **VPN 與裝置管理** → 開發者 App → 揀你嘅 Apple ID → **信任**

### 有效期

免費 Apple ID 簽名 **7 日**後失效。過期後用 Sideloadly 重新簽一次即可（資料保留）。

想 1 年有效期 → Apple Developer Program（US$99/年）。

---

## 想改嘢

| 改咩 | 改邊度 |
|---|---|
| 顏色、尺寸 | `ContentView.swift` 的 `Color(red:green:blue:)` |
| 顯示名稱 | `project.yml` 的 `INFOPLIST_KEY_CFBundleDisplayName` |
| Bundle ID | `project.yml` 的 `PRODUCT_BUNDLE_IDENTIFIER` |
| 加功能（鬧鐘、世界時鐘）| `ContentView.swift` |

改完 `git commit && git push`，GitHub Actions 會自動重新編譯。
