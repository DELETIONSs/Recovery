local OrionLib = {}
OrionLib.Folder = "OrionLibrary"
OrionLib.SaveCfg = false
OrionLib.UI = {}
OrionLib.NotificationHolder = Instance.new("Frame")
OrionLib.NotificationHolder.Parent = game.Players.LocalPlayer.PlayerGui
OrionLib.NotificationHolder.Position = UDim2.new(0, 0, 1, -55)
OrionLib.NotificationHolder.Size = UDim2.new(0, 300, 0, 0)

-- Function to initialize the library and auto-load configuration if enabled
function OrionLib:Init()
    if OrionLib.SaveCfg then
        pcall(function()
            if isfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt") then
                LoadCfg(readfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt"))
                OrionLib:MakeNotification({
                    Name = "Configuration",
                    Content = "Auto-loaded configuration for the game " .. game.GameId .. ".",
                    Time = 5
                })
            end
        end)
    end
end

-- Create window function to initialize UI and settings
function OrionLib:MakeWindow(WindowConfig)
    local FirstTab = true
    local Minimized = false
    local Loaded = false
    local UIHidden = false

    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Orion Library"
    WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
    WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
    WindowConfig.HidePremium = WindowConfig.HidePremium or false
    if WindowConfig.IntroEnabled == nil then
        WindowConfig.IntroEnabled = true
    end
    WindowConfig.IntroText = WindowConfig.IntroText or "Orion Library"
    WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
    WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
    WindowConfig.Icon = WindowConfig.Icon or "rbxassetid://8834748103"
    WindowConfig.IntroIcon = WindowConfig.IntroIcon or "rbxassetid://8834748103"
    OrionLib.Folder = WindowConfig.ConfigFolder
    OrionLib.SaveCfg = WindowConfig.SaveConfig

    if WindowConfig.SaveConfig then
        if not isfolder(WindowConfig.ConfigFolder) then
            makefolder(WindowConfig.ConfigFolder)
        end
    end

    -- Create tab holder
    local TabHolder = self:CreateScrollFrame({
        Size = UDim2.new(1, 0, 1, -50),
        Padding = 8
    })

    -- Add connections
    AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Create Close and Minimize buttons
    local CloseBtn = self:CreateButton({
        Size = UDim2.new(0.5, 0, 1, 0),
        Icon = "rbxassetid://7072725342",
        Position = UDim2.new(0.5, 0, 0, 0)
    })

    local MinimizeBtn = self:CreateButton({
        Size = UDim2.new(0.5, 0, 1, 0),
        Icon = "rbxassetid://7072719338",
        Position = UDim2.new(0, 0, 0, 0)
    })

    -- Create the draggable window frame
    local DragPoint = self:CreateTFrame({
        Size = UDim2.new(1, 0, 0, 50)
    })

    local WindowStuff = self:CreateWindowStuff({
        TabHolder = TabHolder,
        CloseBtn = CloseBtn,
        MinimizeBtn = MinimizeBtn
    })

    -- Window name label
    local WindowName = self:CreateLabel({
        Text = WindowConfig.Name,
        Position = UDim2.new(0, 25, 0, -24),
        Font = Enum.Font.GothamBlack,
        TextSize = 20
    })
end

-- Notification System to show messages
function OrionLib:MakeNotification(NotificationConfig)
    spawn(function()
        NotificationConfig.Name = NotificationConfig.Name or "Notification"
        NotificationConfig.Content = NotificationConfig.Content or "Test"
        NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
        NotificationConfig.Time = NotificationConfig.Time or 15

        local NotificationParent = Instance.new("Frame", OrionLib.NotificationHolder)
        NotificationParent.Size = UDim2.new(1, 0, 0, 0)
        NotificationParent.BackgroundTransparency = 1
        NotificationParent.AutomaticSize = Enum.AutomaticSize.Y
        NotificationParent.Name = "NotificationParent"

        local NotificationFrame = Instance.new("Frame", NotificationParent)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        NotificationFrame.Size = UDim2.new(1, 0, 0, 0)
        NotificationFrame.Position = UDim2.new(1, -55, 0, 0)
        NotificationFrame.BackgroundTransparency = 0
        NotificationFrame.AutomaticSize = Enum.AutomaticSize.Y

        local Stroke = Instance.new("UIStroke", NotificationFrame)
        Stroke.Color = Color3.fromRGB(93, 93, 93)
        Stroke.Thickness = 1.2

        local Padding = Instance.new("UIPadding", NotificationFrame)
        Padding.PaddingBottom = UDim.new(0, 12)
        Padding.PaddingLeft = UDim.new(0, 12)
        Padding.PaddingRight = UDim.new(0, 12)
        Padding.PaddingTop = UDim.new(0, 12)

        local Icon = Instance.new("ImageLabel", NotificationFrame)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Image = NotificationConfig.Image
        Icon.ImageColor3 = Color3.fromRGB(240, 240, 240)
        Icon.Position = UDim2.new(0, 0, 0, 0)
        Icon.Name = "Icon"

        local Title = Instance.new("TextLabel", NotificationFrame)
        Title.Text = NotificationConfig.Name
        Title.Size = UDim2.new(1, -30, 0, 20)
        Title.Position = UDim2.new(0, 30, 0, 0)
        Title.Font = Enum.Font.GothamBold
        Title.Name = "Title"

        local Content = Instance.new("TextLabel", NotificationFrame)
        Content.Text = NotificationConfig.Content
        Content.Size = UDim2.new(1, 0, 0, 0)
        Content.Position = UDim2.new(0, 0, 0, 25)
        Content.Font = Enum.Font.GothamSemibold
        Content.Name = "Content"
        Content.AutomaticSize = Enum.AutomaticSize.Y
        Content.TextColor3 = Color3.fromRGB(200, 200, 200)
        Content.TextWrapped = true

        local TweenService = game:GetService("TweenService")
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()

        wait(NotificationConfig.Time - 0.88)
        TweenService:Create(Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
        TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6}):Play()
        wait(0.3)
        TweenService:Create(Stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
        TweenService:Create(Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
        TweenService:Create(Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.5}):Play()
        wait(0.05)

        NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
        wait(1.35)
        NotificationFrame:Destroy()
    end)
end

-- Helper Functions
function OrionLib:CreateScrollFrame(Config)
    -- Add scroll frame functionality here
end

function OrionLib:CreateButton(Config)
    -- Create a button element here
end

function OrionLib:CreateTFrame(Config)
    -- Create a draggable frame here
end

function OrionLib:CreateWindowStuff(Config)
    -- Set window elements and arrange them
end

function OrionLib:CreateLabel(Config)
    -- Create and return a label element here
end

return OrionLib
