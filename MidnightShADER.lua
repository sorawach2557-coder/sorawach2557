 -- ============================================================
-- ✨ MIDNIGHT GLASS UI v17 ✨
-- Features: Keybind Toggle, Rotating Shadow, Glassmorphism,
-- Vertical Presets, Shader Settings, Fog, Custom Shader,
-- UI Sounds, Player Profile Card, Resizable, 7 Languages
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TOGGLE_KEY = Enum.KeyCode.RightShift

-- ============================================================
-- 🎨 THEME & ICONS
-- ============================================================
local Theme = {
    Background       = Color3.fromRGB(15, 12, 25),
    BackgroundTrans  = 0.15,
    Surface          = Color3.fromRGB(28, 22, 45),
    SurfaceTrans     = 0.4,
    Accent           = Color3.fromRGB(168, 85, 247),
    AccentLight      = Color3.fromRGB(216, 150, 255),
    Accent2          = Color3.fromRGB(100, 200, 255),
    TextPrimary      = Color3.fromRGB(240, 235, 255),
    TextSecondary    = Color3.fromRGB(160, 155, 185),
    StrokeColor      = Color3.fromRGB(168, 130, 240),
    StrokeTrans      = 0.4,
    Danger           = Color3.fromRGB(255, 100, 130),
    Success          = Color3.fromRGB(80, 220, 160),
}

local Icons = {
    Home     = "rbxassetid://10709790593",
    Shader   = "rbxassetid://10709791938",
    Settings = "rbxassetid://10709789594",
    Clock    = "rbxassetid://10709790826",
    Globe    = "rbxassetid://10709793004",
    Volume   = "rbxassetid://10709792294",
    Reset    = "rbxassetid://10709791655",
}

-- ============================================================
-- 🌐 LOCALIZATION (7 ภาษา)
-- ============================================================
local Locales = {
    ["EN"] = { name = "English", flag = "🇺🇸", title = "MIDNIGHT UI",
        tab_home = "Home", tab_shader = "Presets", tab_shader_setting = "Shader Set", tab_settings = "Settings",
        welcome = "Welcome", welcome_sub = "Adjust lighting, time, and language here!", btn_goto = "Go to Presets",
        presets = "PRESETS", lighting = "LIGHTING", clock = "TIME CLOCK", sync = "Sync Real Time",
        bloom = "BLOOM", brightness = "Brightness", contrast = "Contrast", saturation = "Saturation",
        bloom_int = "Intensity", bloom_size = "Size", lang = "LANGUAGE", audio = "AUDIO", audio_toggle = "UI Sounds",
        fog = "FOG", custom_shader = "CUSTOM SHADER",
        fog_start = "Fog Start", fog_end = "Fog End", atm_density = "Atmosphere Density", atm_haze = "Atmosphere Haze",
        exposure = "Exposure", env_diffuse = "Env Diffuse", env_specular = "Env Specular",
        tint_hue = "Tint Hue", tint_strength = "Tint Strength",
        profile = "PROFILE", account_age = "Account Age", days = "days", user_id = "User ID",
        reset_shader = "Reset Shader", reset_all = "Reset All Settings" },

    ["TH"] = { name = "ไทย", flag = "🇹🇭", title = "MIDNIGHT UI",
        tab_home = "หน้าแรก", tab_shader = "ธีมแสง", tab_shader_setting = "ตั้งค่าแสง", tab_settings = "ตั้งค่า",
        welcome = "ยินดีต้อนรับ", welcome_sub = "ปรับแต่งแสง เวลา และภาษาที่นี่!", btn_goto = "ไปที่ธีมแสง",
        presets = "ธีมสำเร็จรูป", lighting = "ตั้งค่าแสง", clock = "เวลาในเกม", sync = "ซิงค์เวลาจริง",
        bloom = "แสงฟุ้ง", brightness = "ความสว่าง", contrast = "คอนทราสต์", saturation = "ความอิ่มตัวสี",
        bloom_int = "ความเข้ม", bloom_size = "ขนาด", lang = "ภาษา", audio = "ระบบเสียง", audio_toggle = "เสียงประกอบ UI",
        fog = "หมอก", custom_shader = "เชดเดอร์กำหนดเอง",
        fog_start = "เริ่มหมอก", fog_end = "สิ้นสุดหมอก", atm_density = "ความหนาแน่นบรรยากาศ", atm_haze = "หมอกในอากาศ",
        exposure = "การรับแสง", env_diffuse = "แสงกระจาย", env_specular = "แสงสะท้อน",
        tint_hue = "เฉดสี", tint_strength = "ความเข้มสี",
        profile = "โปรไฟล์", account_age = "อายุบัญชี", days = "วัน", user_id = "ID ผู้ใช้",
        reset_shader = "รีเซ็ตการจัดแสง", reset_all = "รีเซ็ตทั้งหมด" },

    ["KO"] = { name = "한국어", flag = "🇰🇷", title = "미드나잇 UI",
        tab_home = "홈", tab_shader = "프리셋", tab_shader_setting = "셰이더 설정", tab_settings = "설정",
        welcome = "환영합니다", welcome_sub = "조명, 시간 및 언어를 조정하세요!", btn_goto = "프리셋으로 이동",
        presets = "프리셋", lighting = "조명", clock = "시간", sync = "실시간 동기화",
        bloom = "블룸", brightness = "밝기", contrast = "대비", saturation = "채도",
        bloom_int = "강도", bloom_size = "크기", lang = "언어", audio = "오디오", audio_toggle = "UI 소리",
        fog = "안개", custom_shader = "커스텀 셰이더",
        fog_start = "안개 시작", fog_end = "안개 끝", atm_density = "대기 밀도", atm_haze = "대기 안개",
        exposure = "노출", env_diffuse = "환경 확산", env_specular = "환경 반사",
        tint_hue = "색조", tint_strength = "색조 강도",
        profile = "프로필", account_age = "계정 나이", days = "일", user_id = "사용자 ID",
        reset_shader = "셰이더 초기화", reset_all = "모두 초기화" },

    ["ZH"] = { name = "中文", flag = "🇨🇳", title = "午夜 UI",
        tab_home = "主页", tab_shader = "预设", tab_shader_setting = "着色器设置", tab_settings = "设置",
        welcome = "欢迎", welcome_sub = "在这里调整光照、时间和语言！", btn_goto = "转到预设",
        presets = "预设", lighting = "光照", clock = "时间", sync = "同步现实时间",
        bloom = "泛光", brightness = "亮度", contrast = "对比度", saturation = "饱和度",
        bloom_int = "强度", bloom_size = "大小", lang = "语言", audio = "音频", audio_toggle = "UI 音效",
        fog = "雾", custom_shader = "自定义着色器",
        fog_start = "雾起点", fog_end = "雾终点", atm_density = "大气密度", atm_haze = "大气雾霾",
        exposure = "曝光", env_diffuse = "环境漫反射", env_specular = "环境镜面",
        tint_hue = "色调", tint_strength = "色调强度",
        profile = "资料", account_age = "账号年龄", days = "天", user_id = "用户 ID",
        reset_shader = "重置着色器", reset_all = "重置全部" },

    ["JA"] = { name = "日本語", flag = "🇯🇵", title = "ミッドナイト UI",
        tab_home = "ホーム", tab_shader = "プリセット", tab_shader_setting = "シェーダー設定", tab_settings = "設定",
        welcome = "ようこそ", welcome_sub = "ここでライティング、時間、言語を調整できます！", btn_goto = "プリセットへ移動",
        presets = "プリセット", lighting = "ライティング", clock = "時間", sync = "リアルタイム同期",
        bloom = "ブルーム", brightness = "明るさ", contrast = "コントラスト", saturation = "彩度",
        bloom_int = "強度", bloom_size = "サイズ", lang = "言語", audio = "オーディオ", audio_toggle = "UI サウンド",
        fog = "霧", custom_shader = "カスタムシェーダー",
        fog_start = "霧開始", fog_end = "霧終了", atm_density = "大気密度", atm_haze = "大気ヘイズ",
        exposure = "露出", env_diffuse = "環境拡散", env_specular = "環境スペキュラ",
        tint_hue = "色相", tint_strength = "色相強度",
        profile = "プロフィール", account_age = "アカウント年齢", days = "日", user_id = "ユーザーID",
        reset_shader = "シェーダーをリセット", reset_all = "すべてリセット" },

    ["VI"] = { name = "Tiếng Việt", flag = "🇻🇳", title = "MIDNIGHT UI",
        tab_home = "Trang chủ", tab_shader = "Cài đặt sẵn", tab_shader_setting = "Cài đặt Shader", tab_settings = "Cài đặt",
        welcome = "Chào mừng", welcome_sub = "Điều chỉnh ánh sáng, thời gian và ngôn ngữ!", btn_goto = "Đến cài đặt sẵn",
        presets = "Cài đặt sẵn", lighting = "Ánh sáng", clock = "Thời gian", sync = "Đồng bộ thời gian thực",
        bloom = "Phát sáng", brightness = "Độ sáng", contrast = "Tương phản", saturation = "Độ bão hòa",
        bloom_int = "Cường độ", bloom_size = "Kích thước", lang = "Ngôn ngữ", audio = "Âm thanh", audio_toggle = "Âm thanh UI",
        fog = "Sương mù", custom_shader = "Shader tùy chỉnh",
        fog_start = "Bắt đầu sương", fog_end = "Kết thúc sương", atm_density = "Mật độ khí quyển", atm_haze = "Sương mù khí quyển",
        exposure = "Độ phơi sáng", env_diffuse = "Khuếch tán môi trường", env_specular = "Phản xạ môi trường",
        tint_hue = "Tông màu", tint_strength = "Độ mạnh tông",
        profile = "Hồ sơ", account_age = "Tuổi tài khoản", days = "ngày", user_id = "ID người dùng",
        reset_shader = "Đặt lại Shader", reset_all = "Đặt lại tất cả" },

    ["RU"] = { name = "Русский", flag = "🇷🇺", title = "MIDNIGHT UI",
        tab_home = "Главная", tab_shader = "Пресеты", tab_shader_setting = "Настройки шейдера", tab_settings = "Настройки",
        welcome = "Добро пожаловать", welcome_sub = "Настройте освещение, время и язык!", btn_goto = "Перейти к пресетам",
        presets = "Пресеты", lighting = "Освещение", clock = "Время", sync = "Синхронизация",
        bloom = "Свечение", brightness = "Яркость", contrast = "Контрастность", saturation = "Насыщенность",
        bloom_int = "Интенсивность", bloom_size = "Размер", lang = "Язык", audio = "Аудио", audio_toggle = "Звуки UI",
        fog = "Туман", custom_shader = "Свой шейдер",
        fog_start = "Начало тумана", fog_end = "Конец тумана", atm_density = "Плотность атмосферы", atm_haze = "Дымка атмосферы",
        exposure = "Экспозиция", env_diffuse = "Диффузное окружение", env_specular = "Зеркальное окружение",
        tint_hue = "Оттенок", tint_strength = "Сила оттенка",
        profile = "Профиль", account_age = "Возраст аккаунта", days = "дней", user_id = "ID пользователя",
        reset_shader = "Сбросить шейдер", reset_all = "Сбросить всё" }
}

local CurrentLang = "EN"
local RegisteredTexts = {}

local function T(key) return Locales[CurrentLang][key] or key end
local function registerText(element, key) table.insert(RegisteredTexts, {element = element, key = key}); element.Text = T(key) end
local function updateAllTexts() for _, data in ipairs(RegisteredTexts) do if data.element and data.element.Parent then data.element.Text = T(data.key) end end end

-- ============================================================
-- 🔊 AUDIO SYSTEM
-- ============================================================
local AudioSettings = { enabled = true }
local Sounds = {
    Click  = "rbxassetid://9118823109",
    Toggle = "rbxassetid://9125402735",
    Tick   = "rbxassetid://9118823109",
    Hover  = "rbxassetid://9118823109",
    Open   = "rbxassetid://9125402735",
    Close  = "rbxassetid://9125402735",
    Tab    = "rbxassetid://9118823109",
}
local lastTick = 0

local function playSound(soundType)
    if not AudioSettings.enabled then return end
    local id = Sounds[soundType]
    if not id then return end
    if soundType == "Tick" and tick() - lastTick < 0.05 then return end
    if soundType == "Tick" then lastTick = tick() end

    local s = Instance.new("Sound")
    s.SoundId = id
    local vol, speed = 0.3, 1
    if soundType == "Tick" then vol = 0.1
    elseif soundType == "Hover" then vol = 0.15
    elseif soundType == "Open" then vol = 0.35; speed = 1.1
    elseif soundType == "Close" then vol = 0.35; speed = 0.9
    elseif soundType == "Tab" then vol = 0.25; speed = 1.15
    elseif soundType == "Toggle" then speed = 1.2
    end
    s.Volume = vol
    s.PlaybackSpeed = speed
    s.Parent = SoundService
    s:Play()
    Debris:AddItem(s, 2)
end

-- ============================================================
-- 🛠️ HELPER FUNCTIONS
-- ============================================================
local function corner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 12); c.Parent = parent; return c end
local function stroke(parent, color, thickness, transparency) local s = Instance.new("UIStroke"); s.Color = color or Theme.StrokeColor; s.Thickness = thickness or 1.5; s.Transparency = transparency or Theme.StrokeTrans; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s end
local function gradientFill(parent, color1, color2, rotation) local grad = Instance.new("UIGradient"); grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)}); grad.Rotation = rotation or 90; grad.Parent = parent; return grad end

-- ============================================================
-- 🎬 SHADER & TIME SYSTEM
-- ============================================================
local Shader = {
    cc = nil, bloom = nil, atmosphere = nil,
    isSyncing = false, syncThread = nil, onTimeSyncUpdate = nil,
    values = {
        brightness = 2, contrast = 0.1, saturation = 0.1, clockTime = 14,
        bloomIntensity = 0.8, bloomSize = 24, bloomThreshold = 0.9,
        fogStart = 0, fogEnd = 100000, fogHue = 0.55, fogSat = 0.3,
        atmDensity = 0.3, atmHaze = 0, atmOffset = 0, atmGlare = 0,
        exposure = 0, envDiffuse = 1, envSpecular = 1,
        tintHue = 0.6, tintStrength = 0
    }
}

local ShaderDefaults = {
    brightness = 2, contrast = 0.1, saturation = 0.1, clockTime = 14,
    bloomIntensity = 0.8, bloomSize = 24, bloomThreshold = 0.9,
    fogStart = 0, fogEnd = 100000, fogHue = 0.55, fogSat = 0.3,
    atmDensity = 0.3, atmHaze = 0, atmOffset = 0, atmGlare = 0,
    exposure = 0, envDiffuse = 1, envSpecular = 1,
    tintHue = 0.6, tintStrength = 0
}

function Shader:init()
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("Atmosphere") then e:Destroy() end
    end
    self.cc = Instance.new("ColorCorrectionEffect"); self.cc.Parent = Lighting
    self.bloom = Instance.new("BloomEffect"); self.bloom.Parent = Lighting
    self.atmosphere = Instance.new("Atmosphere"); self.atmosphere.Parent = Lighting
    self:apply()
end

function Shader:apply()
    Lighting.Brightness = self.values.brightness
    if not self.isSyncing then Lighting.ClockTime = self.values.clockTime end

    if self.cc then
        self.cc.Contrast = self.values.contrast
        self.cc.Saturation = self.values.saturation
        self.cc.TintColor = Color3.fromHSV(self.values.tintHue, self.values.tintStrength, 1)
    end

    if self.bloom then
        self.bloom.Intensity = self.values.bloomIntensity
        self.bloom.Size = self.values.bloomSize
        self.bloom.Threshold = self.values.bloomThreshold
    end

    Lighting.FogStart = self.values.fogStart
    Lighting.FogEnd = self.values.fogEnd
    Lighting.FogColor = Color3.fromHSV(self.values.fogHue, self.values.fogSat, 1)

    if self.atmosphere then
        self.atmosphere.Density = self.values.atmDensity
        self.atmosphere.Haze = self.values.atmHaze
        self.atmosphere.Offset = self.values.atmOffset or 0
        self.atmosphere.Glare = self.values.atmGlare or 0
    end

    Lighting.ExposureCompensation = self.values.exposure
    Lighting.EnvironmentDiffuseScale = self.values.envDiffuse
    Lighting.EnvironmentSpecularScale = self.values.envSpecular
end

function Shader:startSync()
    self.isSyncing = true
    if self.syncThread then task.cancel(self.syncThread) end
    self.syncThread = task.spawn(function()
        while self.isSyncing do
            local now = os.date("*t")
            local realTime = now.hour + (now.min / 60) + (now.sec / 3600)
            Lighting.ClockTime = realTime
            if self.onTimeSyncUpdate then self.onTimeSyncUpdate(realTime) end
            task.wait(1)
        end
    end)
end

function Shader:stopSync()
    self.isSyncing = false
    if self.syncThread then task.cancel(self.syncThread); self.syncThread = nil end
end

function Shader:setPreset(preset)
    local overrides = {
        Default = {},
        Cinematic = { brightness = 1.5, contrast = 0.3, saturation = -0.1, clockTime = 18, bloomIntensity = 1.2, bloomSize = 30, bloomThreshold = 0.8,
            fogStart = 100, fogEnd = 800, atmDensity = 0.35, atmHaze = 1, tintHue = 0.08, tintStrength = 0.1 },
        Vibrant = { brightness = 2.5, contrast = 0.1, saturation = 0.6, clockTime = 12, bloomIntensity = 0.5, bloomSize = 20, bloomThreshold = 1 },
        Horror = { brightness = 0.5, contrast = 0.6, saturation = -0.8, clockTime = 0, bloomIntensity = 0.3, bloomSize = 15, bloomThreshold = 1.2,
            fogStart = 30, fogEnd = 200, atmDensity = 0.6, atmHaze = 3, tintHue = 0.1, tintStrength = 0.2 },
        Cyberpunk = { brightness = 1.2, contrast = 0.4, saturation = 0.8, clockTime = 22, bloomIntensity = 1.5, bloomSize = 25, bloomThreshold = 0.6,
            atmHaze = 0.5, tintHue = 0.75, tintStrength = 0.15, exposure = 0.2 },
        Pastel = { brightness = 2.8, contrast = -0.2, saturation = 0.3, clockTime = 10, bloomIntensity = 0.9, bloomSize = 35, bloomThreshold = 1.1,
            tintHue = 0.9, tintStrength = 0.1 },
        Noir = { brightness = 1, contrast = 0.8, saturation = -1, clockTime = 20, bloomIntensity = 0.2, bloomSize = 10, bloomThreshold = 1.5,
            atmHaze = 1, fogSat = 0 },
        Sunset = { brightness = 2.2, contrast = 0.2, saturation = 0.4, clockTime = 17.5, bloomIntensity = 1, bloomSize = 28, bloomThreshold = 0.7,
            fogStart = 200, fogEnd = 1500, fogHue = 0.05, fogSat = 0.5, tintHue = 0.05, tintStrength = 0.15 },
    }
    local o = overrides[preset] or overrides.Default
    local newVals = {}
    for k, v in pairs(ShaderDefaults) do newVals[k] = v end
    for k, v in pairs(o) do newVals[k] = v end
    self.values = newVals
    self:apply()
end

Shader:init()

-- ============================================================
-- 🌟 MAIN UI
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "MidnightGlassUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = PlayerGui

-- Rotating Shadow
local rotatingShadow = Instance.new("ImageLabel")
rotatingShadow.AnchorPoint = Vector2.new(0.5, 0.5)
rotatingShadow.Position = UDim2.new(0.5, 0, 0.5, 10)
rotatingShadow.Size = UDim2.new(0, 480, 0, 600)
rotatingShadow.BackgroundTransparency = 1
rotatingShadow.Image = "rbxassetid://8992230677"
rotatingShadow.ImageColor3 = Color3.new(0, 0, 0)
rotatingShadow.ImageTransparency = 0.4
rotatingShadow.ScaleType = Enum.ScaleType.Slice
rotatingShadow.SliceCenter = Rect.new(20, 20, 20, 20)
rotatingShadow.ZIndex = 1
rotatingShadow.Parent = sg

-- Keybind Hint
local keybindHint = Instance.new("TextLabel")
keybindHint.Size = UDim2.new(0, 250, 0, 30)
keybindHint.Position = UDim2.new(0, 20, 0, 20)
keybindHint.BackgroundColor3 = Theme.Surface
keybindHint.BackgroundTransparency = 0.3
keybindHint.Text = "กด [" .. TOGGLE_KEY.Name .. "] เพื่อเปิด UI"
keybindHint.TextColor3 = Theme.TextPrimary
keybindHint.Font = Enum.Font.GothamBold
keybindHint.TextSize = 14
keybindHint.Visible = false
keybindHint.ZIndex = 10
keybindHint.Parent = sg
corner(keybindHint, 8)
stroke(keybindHint, Theme.Accent, 1, 0.5)

-- Main Frame
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 380, 0, 500)
main.BackgroundColor3 = Theme.Background
main.BackgroundTransparency = Theme.BackgroundTrans
main.BorderSizePixel = 0
main.Active = true
main.ZIndex = 2
main.Parent = sg
corner(main, 16)
gradientFill(main, Color3.fromRGB(25, 18, 42), Color3.fromRGB(18, 15, 30), 135)
stroke(main, Theme.Accent, 2, 0.2)

main:GetPropertyChangedSignal("Size"):Connect(function()
    rotatingShadow.Size = main.Size + UDim2.new(0, 100, 0, 100)
end)

RunService.RenderStepped:Connect(function(dt)
    if main.Visible then
        rotatingShadow.Rotation = rotatingShadow.Rotation + (15 * dt)
    end
end)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Theme.TextPrimary
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar
registerText(titleText, "title")

-- Window controls
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -42, 0.5, -15)
closeBtn.BackgroundColor3 = Theme.Danger; closeBtn.BackgroundTransparency = 0.8; closeBtn.Text = "✕"
closeBtn.TextColor3 = Theme.Danger; closeBtn.TextSize = 14; closeBtn.Font = Enum.Font.GothamBold; closeBtn.AutoButtonColor = false; closeBtn.Parent = titleBar
corner(closeBtn, 8); stroke(closeBtn, Theme.Danger, 1, 0.4)

local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0, 30, 0, 30); maxBtn.Position = UDim2.new(1, -78, 0.5, -15)
maxBtn.BackgroundColor3 = Theme.Success; maxBtn.BackgroundTransparency = 0.8; maxBtn.Text = "□"
maxBtn.TextColor3 = Theme.Success; maxBtn.TextSize = 14; maxBtn.Font = Enum.Font.GothamBold; maxBtn.AutoButtonColor = false; maxBtn.Parent = titleBar
corner(maxBtn, 8); stroke(maxBtn, Theme.Success, 1, 0.4)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -114, 0.5, -15)
minBtn.BackgroundColor3 = Theme.Accent2; minBtn.BackgroundTransparency = 0.8; minBtn.Text = "−"
minBtn.TextColor3 = Theme.Accent2; minBtn.TextSize = 18; minBtn.Font = Enum.Font.GothamBold; minBtn.AutoButtonColor = false; minBtn.Parent = titleBar
corner(minBtn, 8); stroke(minBtn, Theme.Accent2, 1, 0.4)

-- Tab Bar
local tabBarBg = Instance.new("Frame")
tabBarBg.Position = UDim2.new(0, 18, 0, 65); tabBarBg.Size = UDim2.new(1, -36, 0, 40)
tabBarBg.BackgroundColor3 = Color3.fromRGB(20, 16, 32); tabBarBg.BackgroundTransparency = 0.3; tabBarBg.BorderSizePixel = 0; tabBarBg.Parent = main
corner(tabBarBg, 10); stroke(tabBarBg, Theme.StrokeColor, 1, 0.6)

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0.25, -4, 1, -8); indicator.Position = UDim2.new(0, 4, 0, 4)
indicator.BackgroundColor3 = Theme.Accent; indicator.BorderSizePixel = 0; indicator.Parent = tabBarBg
corner(indicator, 8); gradientFill(indicator, Theme.Accent, Theme.AccentLight, 45)

local tabLayout = Instance.new("Frame")
tabLayout.Size = UDim2.new(1, 0, 1, 0); tabLayout.BackgroundTransparency = 1; tabLayout.Parent = tabBarBg
local listLayout = Instance.new("UIListLayout"); listLayout.FillDirection = Enum.FillDirection.Horizontal; listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Parent = tabLayout

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 18, 0, 115); content.Size = UDim2.new(1, -36, 1, -135)
content.BackgroundTransparency = 1; content.ClipsDescendants = true; content.Parent = main

local tabs, pages = {}, {}
local activeIndex = 1

local function switchTab(index)
    if index == activeIndex then return end
    playSound("Tab")
    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0.25 * (index - 1), 4, 0, 4)}):Play()
    for i, tab in ipairs(tabs) do TweenService:Create(tab.icon, TweenInfo.new(0.2), {ImageColor3 = i == index and Color3.new(1,1,1) or Theme.TextSecondary}):Play() end
    if pages[activeIndex] then pages[activeIndex].Visible = false end
    if pages[index] then
        pages[index].Visible = true; pages[index].Position = UDim2.new(0, 10, 0, 0)
        TweenService:Create(pages[index], TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end
    activeIndex = index
end

local function createTab(iconId, textKey, order)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0.25, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.LayoutOrder = order; btn.Parent = tabLayout
    btn.MouseButton1Click:Connect(function() switchTab(order) end)
    local icon = Instance.new("ImageLabel"); icon.Size = UDim2.new(0, 16, 0, 16); icon.Position = UDim2.new(0.5, -8, 0.5, -10); icon.BackgroundTransparency = 1; icon.Image = iconId; icon.ImageColor3 = order == 1 and Color3.new(1,1,1) or Theme.TextSecondary; icon.Parent = btn
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, 0, 0, 12); label.Position = UDim2.new(0, 0, 0.5, 4); label.BackgroundTransparency = 1; label.TextColor3 = Theme.TextPrimary; label.Font = Enum.Font.GothamMedium; label.TextSize = 10; label.Parent = btn
    registerText(label, textKey)
    table.insert(tabs, {btn = btn, icon = icon})
    local page = Instance.new("ScrollingFrame"); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Theme.Accent; page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = order == 1; page.Parent = content
    local p = Instance.new("UIPadding"); p.PaddingTop = UDim.new(0, 10); p.PaddingRight = UDim.new(0, 5); p.Parent = page
    local l = Instance.new("UIListLayout"); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0, 10); l.Parent = page
    pages[order] = page; return page
end

-- ============================================================
-- 🧩 COMPONENTS
-- ============================================================
local function sectionHeader(parent, textKey, iconId, order)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, 0, 0, 20); frame.BackgroundTransparency = 1; frame.LayoutOrder = order; frame.Parent = parent
    if iconId then local icon = Instance.new("ImageLabel"); icon.Size = UDim2.new(0, 14, 0, 14); icon.Position = UDim2.new(0, 0, 0.5, -7); icon.BackgroundTransparency = 1; icon.Image = iconId; icon.ImageColor3 = Theme.AccentLight; icon.Parent = frame end
    local lbl = Instance.new("TextLabel"); lbl.Position = iconId and UDim2.new(0, 20, 0, 0) or UDim2.new(0, 0, 0, 0); lbl.Size = UDim2.new(1, -20, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Theme.AccentLight; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    registerText(lbl, textKey); return frame
end

local function card(parent, height, order)
    local c = Instance.new("Frame"); c.Size = UDim2.new(1, 0, 0, height or 60); c.BackgroundColor3 = Theme.Surface; c.BackgroundTransparency = Theme.SurfaceTrans; c.BorderSizePixel = 0; c.LayoutOrder = order; c.Parent = parent
    corner(c, 10); stroke(c, Theme.StrokeColor, 1, 0.7); return c
end

local function slider(parent, textKey, min, max, def, order, isClock, callback, isHue)
    local c = card(parent, 64, order)
    local label = Instance.new("TextLabel"); label.Position = UDim2.new(0, 12, 0, 8); label.Size = UDim2.new(0.7, 0, 0, 16); label.BackgroundTransparency = 1; label.TextColor3 = Theme.TextPrimary; label.Font = Enum.Font.GothamMedium; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = c
    registerText(label, textKey)
    local valueLbl = Instance.new("TextLabel"); valueLbl.Position = UDim2.new(0.3, 0, 0, 8); valueLbl.Size = UDim2.new(0.6, -12, 0, 16); valueLbl.BackgroundTransparency = 1; valueLbl.TextColor3 = Theme.Accent2; valueLbl.Font = Enum.Font.GothamBold; valueLbl.TextSize = 12; valueLbl.TextXAlignment = Enum.TextXAlignment.Right; valueLbl.Parent = c
    local bar = Instance.new("Frame"); bar.Position = UDim2.new(0, 12, 0, 36); bar.Size = UDim2.new(1, -24, 0, 6); bar.BackgroundColor3 = Color3.fromRGB(40, 35, 55); bar.BorderSizePixel = 0; bar.Parent = c; corner(bar, 3)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; fill.BorderSizePixel = 0; fill.Parent = bar; corner(fill, 3); gradientFill(fill, Theme.Accent, Theme.AccentLight, 0)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0, 12, 0, 12); knob.Position = UDim2.new((def - min) / (max - min), -6, 0.5, -6); knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0; knob.ZIndex = 2; knob.Parent = bar; corner(knob, 6); stroke(knob, Theme.Accent, 2, 0)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 20, 1, 30); btn.Position = UDim2.new(0, -10, 0, -15); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = bar

    local function updateText(v)
        if isClock then
            local h = math.floor(v); local m = math.floor((v - h) * 60); valueLbl.Text = string.format("%02d:%02d", h, m)
        elseif isHue then
            valueLbl.Text = math.floor(v * 360) .. "°"
        else
            valueLbl.Text = string.format("%.2f", v)
        end
    end
    updateText(def)

    local dragging = false
    local function update(x, isUserInput)
        local relX = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * relX
        if not isClock then val = math.floor(val * 100) / 100 end
        fill.Size = UDim2.new(relX, 0, 1, 0); knob.Position = UDim2.new(relX, -6, 0.5, -6)
        updateText(val); callback(val)
        if isUserInput then playSound("Tick") end
    end

    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input.Position.X, true) end end)
    btn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X, true) end end)

    local sliderObj = {frame = c}
    function sliderObj:SetValue(val)
        local relX = math.clamp((val - min) / (max - min), 0, 1)
        fill.Size = UDim2.new(relX, 0, 1, 0); knob.Position = UDim2.new(relX, -6, 0.5, -6)
        updateText(val); callback(val)
    end
    return sliderObj
end

local function toggle(parent, textKey, def, order, callback)
    local c = card(parent, 50, order)
    local label = Instance.new("TextLabel"); label.Position = UDim2.new(0, 16, 0, 0); label.Size = UDim2.new(1, -80, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Theme.TextPrimary; label.Font = Enum.Font.GothamMedium; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = c
    registerText(label, textKey)
    local bg = Instance.new("Frame"); bg.Size = UDim2.new(0, 40, 0, 20); bg.Position = UDim2.new(1, -56, 0.5, -10); bg.BackgroundColor3 = def and Theme.Accent or Color3.fromRGB(50, 45, 65); bg.BorderSizePixel = 0; bg.Parent = c; corner(bg, 10); stroke(bg, Theme.StrokeColor, 1, 0.3)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0, 14, 0, 14); knob.Position = def and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7); knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0; knob.Parent = bg; corner(knob, 7)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = bg

    local state = def
    local function setState(newState, playSnd)
        if state == newState then return end
        state = newState
        if playSnd then playSound("Toggle") end
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 45, 65)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)}):Play()
        callback(state)
    end

    btn.MouseButton1Click:Connect(function() setState(not state, true) end)
    local toggleObj = {frame = c}
    function toggleObj:SetState(newState) setState(newState, false) end
    return toggleObj
end

local function button(parent, textKey, color, order, callback)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = color or Theme.Accent; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.AutoButtonColor = false; btn.LayoutOrder = order; btn.Parent = parent; corner(btn, 8); gradientFill(btn, color or Theme.Accent, Theme.AccentLight, 45)
    registerText(btn, textKey)
    btn.MouseEnter:Connect(function() playSound("Hover"); TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentLight}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or Theme.Accent}):Play() end)
    btn.MouseButton1Click:Connect(function() playSound("Click"); callback() end)
    return btn
end

-- ============================================================
-- 📋 TAB 1: HOME (พร้อม Profile Card)
-- ============================================================
local homePage = createTab(Icons.Home, "tab_home", 1)

-- 👤 PROFILE CARD
local profileCard = card(homePage, 110, 1)

-- Frame รูปโปรไฟล์ (วงกลม + ขอบเรืองแสง)
local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 74, 0, 74)
avatarFrame.Position = UDim2.new(0, 16, 0.5, -37)
avatarFrame.BackgroundColor3 = Theme.Background
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = profileCard
corner(avatarFrame, 37)
stroke(avatarFrame, Theme.Accent, 2, 0)

-- รูปโปรไฟล์
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(1, -6, 1, -6)
avatarImg.Position = UDim2.new(0, 3, 0, 3)
avatarImg.BackgroundTransparency = 1
avatarImg.Parent = avatarFrame
corner(avatarImg, 34)

-- โหลด Headshot (async)
task.spawn(function()
    local success, contentId = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    if success and contentId then
        avatarImg.Image = contentId
    end
end)

-- จุดสถานะออนไลน์ (กระพริบเบาๆ)
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 16, 0, 16)
statusDot.Position = UDim2.new(1, -18, 1, -18)
statusDot.BackgroundColor3 = Theme.Success
statusDot.BorderSizePixel = 0
statusDot.Parent = avatarFrame
corner(statusDot, 8)
stroke(statusDot, Theme.Background, 2, 0)

task.spawn(function()
    while statusDot.Parent do
        TweenService:Create(statusDot, TweenInfo.new(0.8), {BackgroundTransparency = 0.4}):Play()
        task.wait(0.8)
        if not statusDot.Parent then break end
        TweenService:Create(statusDot, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
        task.wait(0.8)
    end
end)

-- Display Name
local profileNameLbl = Instance.new("TextLabel")
profileNameLbl.Position = UDim2.new(0, 100, 0, 16)
profileNameLbl.Size = UDim2.new(1, -116, 0, 22)
profileNameLbl.BackgroundTransparency = 1
profileNameLbl.Text = LocalPlayer.DisplayName
profileNameLbl.TextColor3 = Theme.TextPrimary
profileNameLbl.Font = Enum.Font.GothamBold
profileNameLbl.TextSize = 16
profileNameLbl.TextXAlignment = Enum.TextXAlignment.Left
profileNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
profileNameLbl.Parent = profileCard

-- @Username
local profileUserLbl = Instance.new("TextLabel")
profileUserLbl.Position = UDim2.new(0, 100, 0, 40)
profileUserLbl.Size = UDim2.new(1, -116, 0, 16)
profileUserLbl.BackgroundTransparency = 1
profileUserLbl.Text = "@" .. LocalPlayer.Name
profileUserLbl.TextColor3 = Theme.Accent2
profileUserLbl.Font = Enum.Font.GothamMedium
profileUserLbl.TextSize = 11
profileUserLbl.TextXAlignment = Enum.TextXAlignment.Left
profileUserLbl.TextTruncate = Enum.TextTruncate.AtEnd
profileUserLbl.Parent = profileCard

-- Account Age
local profileAgeLbl = Instance.new("TextLabel")
profileAgeLbl.Position = UDim2.new(0, 100, 0, 62)
profileAgeLbl.Size = UDim2.new(1, -116, 0, 14)
profileAgeLbl.BackgroundTransparency = 1
profileAgeLbl.Text = T("account_age") .. ": " .. LocalPlayer.AccountAge .. " " .. T("days")
profileAgeLbl.TextColor3 = Theme.TextSecondary
profileAgeLbl.Font = Enum.Font.Gotham
profileAgeLbl.TextSize = 10
profileAgeLbl.TextXAlignment = Enum.TextXAlignment.Left
profileAgeLbl.Parent = profileCard
table.insert(RegisteredTexts, {element = profileAgeLbl, key = "__custom_age"})

-- User ID
local profileIdLbl = Instance.new("TextLabel")
profileIdLbl.Position = UDim2.new(0, 100, 0, 80)
profileIdLbl.Size = UDim2.new(1, -116, 0, 14)
profileIdLbl.BackgroundTransparency = 1
profileIdLbl.Text = T("user_id") .. ": " .. LocalPlayer.UserId
profileIdLbl.TextColor3 = Theme.TextSecondary
profileIdLbl.Font = Enum.Font.Gotham
profileIdLbl.TextSize = 10
profileIdLbl.TextXAlignment = Enum.TextXAlignment.Left
profileIdLbl.Parent = profileCard
table.insert(RegisteredTexts, {element = profileIdLbl, key = "__custom_id"})

-- patch updateAllTexts ให้รองรับ custom keys
local _oldUpdateAll = updateAllTexts
updateAllTexts = function()
    for _, data in ipairs(RegisteredTexts) do
        if data.element and data.element.Parent then
            if data.key == "__custom_age" then
                data.element.Text = T("account_age") .. ": " .. LocalPlayer.AccountAge .. " " .. T("days")
            elseif data.key == "__custom_id" then
                data.element.Text = T("user_id") .. ": " .. LocalPlayer.UserId
            else
                data.element.Text = T(data.key)
            end
        end
    end
end

-- Welcome Card
local welcomeCard = card(homePage, 80, 2)
local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Position = UDim2.new(0, 16, 0, 12)
welcomeTitle.Size = UDim2.new(1, -32, 0, 24)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.TextColor3 = Theme.TextPrimary
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = 16
welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
welcomeTitle.Parent = welcomeCard
welcomeTitle.Text = T("welcome")

local welcomeSub = Instance.new("TextLabel")
welcomeSub.Position = UDim2.new(0, 16, 0, 38)
welcomeSub.Size = UDim2.new(1, -32, 0, 16)
welcomeSub.BackgroundTransparency = 1
welcomeSub.TextColor3 = Theme.TextSecondary
welcomeSub.Font = Enum.Font.Gotham
welcomeSub.TextSize = 11
welcomeSub.TextXAlignment = Enum.TextXAlignment.Left
welcomeSub.Parent = welcomeCard
registerText(welcomeSub, "welcome_sub")

button(homePage, "btn_goto", Theme.Accent, 3, function() switchTab(2) end)

-- ============================================================
-- 📋 TAB 2: SHADER HDR (Presets)
-- ============================================================
local shaderPage = createTab(Icons.Shader, "tab_shader", 2)
sectionHeader(shaderPage, "presets", nil, 1)

local function createPresetButton(txt, preset, color1, color2, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.new(1,1,1); b.Text = ""; b.AutoButtonColor = false; b.LayoutOrder = order; b.Parent = shaderPage
    corner(b, 8); stroke(b, Color3.new(1,1,1), 1, 0.4); gradientFill(b, color1, color2, 45)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0); label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1; label.Text = txt; label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold; label.TextSize = 14; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = b

    b.MouseEnter:Connect(function()
        playSound("Hover")
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, 5, 0, 45), BackgroundTransparency = 0.1}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 0}):Play()
    end)
    b.MouseButton1Click:Connect(function()
        playSound("Click")
        Shader:setPreset(preset)
    end)
end

createPresetButton("Default Theme", "Default", Theme.Accent, Theme.AccentLight, 2)
createPresetButton("Cinematic", "Cinematic", Color3.fromRGB(200, 100, 50), Color3.fromRGB(255, 180, 50), 3)
createPresetButton("Vibrant", "Vibrant", Color3.fromRGB(80, 200, 100), Color3.fromRGB(150, 255, 150), 4)
createPresetButton("Horror", "Horror", Color3.fromRGB(150, 30, 30), Color3.fromRGB(80, 0, 0), 5)
createPresetButton("Cyberpunk", "Cyberpunk", Color3.fromRGB(255, 0, 150), Color3.fromRGB(0, 200, 255), 6)
createPresetButton("Pastel", "Pastel", Color3.fromRGB(255, 180, 200), Color3.fromRGB(180, 200, 255), 7)
createPresetButton("Noir", "Noir", Color3.fromRGB(50, 50, 50), Color3.fromRGB(20, 20, 20), 8)
createPresetButton("Sunset", "Sunset", Color3.fromRGB(255, 140, 0), Color3.fromRGB(200, 50, 150), 9)

-- ============================================================
-- 📋 TAB 3: SHADER SETTING (Sliders + Fog + Custom Shader)
-- ============================================================
local shaderSettingPage = createTab(Icons.Settings, "tab_shader_setting", 3)

sectionHeader(shaderSettingPage, "clock", Icons.Clock, 1)
local clockSlider = slider(shaderSettingPage, "time_clock", 0, 24, Shader.values.clockTime, 2, true, function(v) Shader.values.clockTime = v; if not Shader.isSyncing then Shader:apply() end end)
local syncToggle = toggle(shaderSettingPage, "sync", Shader.isSyncing, 3, function(on)
    if on then
        Shader:startSync()
        Shader.onTimeSyncUpdate = function(realTime) clockSlider:SetValue(realTime) end
    else
        Shader:stopSync(); Shader.onTimeSyncUpdate = nil
    end
end)

sectionHeader(shaderSettingPage, "lighting", Icons.Settings, 4)
local brightSlider = slider(shaderSettingPage, "brightness", 0, 5, Shader.values.brightness, 5, false, function(v) Shader.values.brightness = v; Shader:apply() end)
local contrastSlider = slider(shaderSettingPage, "contrast", -1, 1, Shader.values.contrast, 6, false, function(v) Shader.values.contrast = v; Shader:apply() end)
local saturSlider = slider(shaderSettingPage, "saturation", -1, 1, Shader.values.saturation, 7, false, function(v) Shader.values.saturation = v; Shader:apply() end)

sectionHeader(shaderSettingPage, "bloom", Icons.Settings, 8)
local bloomIntSlider = slider(shaderSettingPage, "bloom_int", 0, 3, Shader.values.bloomIntensity, 9, false, function(v) Shader.values.bloomIntensity = v; Shader:apply() end)
local bloomSizeSlider = slider(shaderSettingPage, "bloom_size", 0, 50, Shader.values.bloomSize, 10, false, function(v) Shader.values.bloomSize = v; Shader:apply() end)

-- 🌫️ FOG SECTION
sectionHeader(shaderSettingPage, "fog", Icons.Settings, 11)
local fogStartSlider = slider(shaderSettingPage, "fog_start", 0, 2000, Shader.values.fogStart, 12, false, function(v) Shader.values.fogStart = v; Shader:apply() end)
local fogEndSlider = slider(shaderSettingPage, "fog_end", 0, 100000, Shader.values.fogEnd, 13, false, function(v) Shader.values.fogEnd = v; Shader:apply() end)
local atmDensitySlider = slider(shaderSettingPage, "atm_density", 0, 1, Shader.values.atmDensity, 14, false, function(v) Shader.values.atmDensity = v; Shader:apply() end)
local atmHazeSlider = slider(shaderSettingPage, "atm_haze", 0, 5, Shader.values.atmHaze, 15, false, function(v) Shader.values.atmHaze = v; Shader:apply() end)

-- 🎨 CUSTOM SHADER SECTION
sectionHeader(shaderSettingPage, "custom_shader", Icons.Shader, 16)
local exposureSlider = slider(shaderSettingPage, "exposure", -3, 3, Shader.values.exposure, 17, false, function(v) Shader.values.exposure = v; Shader:apply() end)
local envDiffuseSlider = slider(shaderSettingPage, "env_diffuse", 0, 1, Shader.values.envDiffuse, 18, false, function(v) Shader.values.envDiffuse = v; Shader:apply() end)
local envSpecularSlider = slider(shaderSettingPage, "env_specular", 0, 1, Shader.values.envSpecular, 19, false, function(v) Shader.values.envSpecular = v; Shader:apply() end)
local tintHueSlider = slider(shaderSettingPage, "tint_hue", 0, 1, Shader.values.tintHue, 20, false, function(v) Shader.values.tintHue = v; Shader:apply() end, true)
local tintStrengthSlider = slider(shaderSettingPage, "tint_strength", 0, 1, Shader.values.tintStrength, 21, false, function(v) Shader.values.tintStrength = v; Shader:apply() end)

local resetShaderBtn = button(shaderSettingPage, "reset_shader", Theme.Danger, 22, function()
    Shader:setPreset("Default")
    syncToggle:SetState(false)
    clockSlider:SetValue(14)
    brightSlider:SetValue(2)
    contrastSlider:SetValue(0.1)
    saturSlider:SetValue(0.1)
    bloomIntSlider:SetValue(0.8)
    bloomSizeSlider:SetValue(24)
    fogStartSlider:SetValue(0)
    fogEndSlider:SetValue(100000)
    atmDensitySlider:SetValue(0.3)
    atmHazeSlider:SetValue(0)
    exposureSlider:SetValue(0)
    envDiffuseSlider:SetValue(1)
    envSpecularSlider:SetValue(1)
    tintHueSlider:SetValue(0.6)
    tintStrengthSlider:SetValue(0)
end)

-- ============================================================
-- 📋 TAB 4: SETTINGS
-- ============================================================
local settingsPage = createTab(Icons.Globe, "tab_settings", 4)

sectionHeader(settingsPage, "lang", Icons.Globe, 1)
local langCard = card(settingsPage, 130, 2)
local langGrid = Instance.new("Frame"); langGrid.Size = UDim2.new(1, -20, 1, -20); langGrid.Position = UDim2.new(0, 10, 0, 10); langGrid.BackgroundTransparency = 1; langGrid.Parent = langCard
local gridLayout = Instance.new("UIGridLayout"); gridLayout.CellSize = UDim2.new(0.5, -5, 0, 30); gridLayout.CellPadding = UDim2.new(0, 10, 0, 10); gridLayout.SortOrder = Enum.SortOrder.LayoutOrder; gridLayout.Parent = langGrid

local langBtns = {}
for code, data in pairs(Locales) do
    local b = Instance.new("TextButton"); b.BackgroundColor3 = code == CurrentLang and Theme.Accent or Theme.Background; b.Text = data.flag .. " " .. data.name; b.TextColor3 = code == CurrentLang and Color3.new(1,1,1) or Theme.TextSecondary; b.Font = Enum.Font.GothamMedium; b.TextSize = 11; b.AutoButtonColor = false; b.Parent = langGrid
    corner(b, 6); stroke(b, Theme.StrokeColor, 1, 0.5)
    b.MouseButton1Click:Connect(function()
        playSound("Click"); CurrentLang = code; updateAllTexts()
        for c, btn in pairs(langBtns) do btn.BackgroundColor3 = c == code and Theme.Accent or Theme.Background; btn.TextColor3 = c == code and Color3.new(1,1,1) or Theme.TextSecondary end
    end)
    table.insert(langBtns, b); langBtns[code] = b
end

sectionHeader(settingsPage, "audio", Icons.Volume, 3)
local audioToggle = toggle(settingsPage, "audio_toggle", AudioSettings.enabled, 4, function(on) AudioSettings.enabled = on end)

-- KEYBIND
local waitingForKey = false
local keybindCard = card(settingsPage, 60, 5)
local keybindLabel = Instance.new("TextLabel")
keybindLabel.Position = UDim2.new(0, 16, 0, 0)
keybindLabel.Size = UDim2.new(0.48, 0, 1, 0)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "Toggle UI Keybind"
keybindLabel.TextColor3 = Theme.TextPrimary
keybindLabel.Font = Enum.Font.GothamMedium
keybindLabel.TextSize = 12
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.Parent = keybindCard

local keybindButton = Instance.new("TextButton")
keybindButton.Size = UDim2.new(0, 125, 0, 32)
keybindButton.Position = UDim2.new(1, -137, 0.5, -16)
keybindButton.BackgroundColor3 = Theme.Accent
keybindButton.TextColor3 = Color3.new(1, 1, 1)
keybindButton.Font = Enum.Font.GothamBold
keybindButton.TextSize = 12
keybindButton.Text = TOGGLE_KEY.Name
keybindButton.AutoButtonColor = false
keybindButton.Parent = keybindCard
corner(keybindButton, 8)
stroke(keybindButton, Theme.StrokeColor, 1, 0.4)

keybindButton.MouseButton1Click:Connect(function()
    playSound("Click")
    waitingForKey = true
    keybindButton.Text = "Press a key..."
end)

local resetAllBtn = button(settingsPage, "reset_all", Theme.Danger, 6, function()
    resetShaderBtn.MouseButton1Click:Fire()
    CurrentLang = "EN"; updateAllTexts()
    for c, btn in pairs(langBtns) do btn.BackgroundColor3 = c == "EN" and Theme.Accent or Theme.Background; btn.TextColor3 = c == "EN" and Color3.new(1,1,1) or Theme.TextSecondary end
    audioToggle:SetState(true); AudioSettings.enabled = true
end)

-- ============================================================
-- 🎬 INTRO & DRAG
-- ============================================================
main.Size = UDim2.new(0, 340, 0, 450)
main.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 500), BackgroundTransparency = Theme.BackgroundTrans
}):Play()

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ============================================================
-- 🪟 WINDOW CONTROLS & KEYBIND
-- ============================================================
local isMaximized = false
local isMinimized = false
local isUIVisible = true
local originalSize = UDim2.new(0, 380, 0, 500)
local originalPos = UDim2.new(0.5, 0, 0.5, 0)

local function toggleUI()
    isUIVisible = not isUIVisible
    if isUIVisible then
        playSound("Open")
        main.Visible = true
        rotatingShadow.Visible = true
        keybindHint.Visible = false
        main.Size = UDim2.new(0, 340, 0, 450)
        main.BackgroundTransparency = 1
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = isMaximized and UDim2.new(0.9, 0, 0.9, 0) or originalSize,
            BackgroundTransparency = Theme.BackgroundTrans
        }):Play()
    else
        playSound("Close")
        local t = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 350, 0, 400), BackgroundTransparency = 1})
        t:Play()
        t.Completed:Connect(function()
            main.Visible = false
            rotatingShadow.Visible = false
            keybindHint.Visible = true
            main.Size = originalSize
            main.BackgroundTransparency = Theme.BackgroundTrans
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if waitingForKey then
        if input.KeyCode == Enum.KeyCode.Escape then
            waitingForKey = false
            keybindButton.Text = TOGGLE_KEY.Name
            return
        end
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            TOGGLE_KEY = input.KeyCode
            waitingForKey = false
            keybindButton.Text = TOGGLE_KEY.Name
            keybindHint.Text = "กด [" .. TOGGLE_KEY.Name .. "] เพื่อเปิด UI"
        end
        return
    end
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        toggleUI()
    end
end)

minBtn.MouseButton1Click:Connect(function()
    playSound("Click")
    isMinimized = not isMinimized
    if isMinimized then
        if isMaximized then maxBtn.MouseButton1Click:Fire() end
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 55)}):Play()
        tabBarBg.Visible = false
        content.Visible = false
    else
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
        tabBarBg.Visible = true
        content.Visible = true
    end
end)

maxBtn.MouseButton1Click:Connect(function()
    playSound("Click")
    isMaximized = not isMaximized
    if isMaximized then
        if isMinimized then minBtn.MouseButton1Click:Fire() end
        originalSize = main.Size
        originalPos = main.Position
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0.9, 0, 0.9, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = originalSize, Position = originalPos
        }):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    playSound("Click")
    toggleUI()
end)

-- ============================================================
-- 🔄 RESIZE HANDLE
-- ============================================================
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Theme.TextSecondary
resizeHandle.TextSize = 18
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.Parent = main

local isResizing = false
local resizeStart = nil
local startSize = nil

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true; resizeStart = input.Position; startSize = main.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local deltaX = input.Position.X - resizeStart.X
        local deltaY = input.Position.Y - resizeStart.Y
        local newWidth = math.max(320, startSize.X.Offset + deltaX)
        local newHeight = math.max(300, startSize.Y.Offset + deltaY)
        main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

print("[Midnight Glass UI v17] ✨ โหลดเสร็จ! (Profile + Fog + Custom Shader + Enhanced Sounds)")