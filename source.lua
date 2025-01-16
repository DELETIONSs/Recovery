local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Default Themes: Light Acrylic Glass and Dark Theme
local themes = {
    LightAcrylicGlass = {
        BackgroundColor = Color3.fromRGB(240, 240, 240),
        TopBarColor = Color3.fromRGB(200, 200, 200),
        SidebarColor = Color3.fromRGB(230, 230, 230),
        ContentFrameColor = Color3.fromRGB(255, 255, 255),
        CloseButtonColor = Color3.fromRGB(255, 0, 0),
        MinimizeButtonColor = Color3.fromRGB(255, 255, 0),
        TextColor = Color3.fromRGB(0, 0, 0),
        Transparency = 0.3,
    },
    DarkTheme = {
        BackgroundColor = Color3.fromRGB(50, 50, 50),
        TopBarColor = Color3.fromRGB(70, 70, 70),
        SidebarColor = Color3.fromRGB(60, 60, 60),
        ContentFrameColor = Color3.fromRGB(40, 40, 40),
        CloseButtonColor = Color3.fromRGB(255, 0, 0),
        MinimizeButtonColor = Color3.fromRGB(255, 255, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        Transparency = 0.5,
    }
}

local currentTheme = themes.LightAcrylicGlass

-- Function to apply a theme to all UI elements
local function applyTheme(MainFrame, TopBar, Sidebar, ContentFrame, CloseButton, MinimizeButton, TitleLabel, theme)
    MainFrame.BackgroundColor3 = theme.BackgroundColor
    MainFrame.BackgroundTransparency = theme.Transparency
    TopBar.BackgroundColor3 = theme.TopBarColor
    Sidebar.BackgroundColor3 = theme.SidebarColor
    ContentFrame.BackgroundColor3 = theme.ContentFrameColor
    CloseButton.BackgroundColor3 = theme.CloseButtonColor
    MinimizeButton.BackgroundColor3 = theme.MinimizeButtonColor
    TitleLabel.TextColor3 = theme.TextColor
end

-- Add Dragging Functionality to the Window
local function AddDraggingFunctionality(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false, nil, nil, nil
        DragPoint.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MousePos = Input.Position
                FramePos = Main.Position
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        DragPoint.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = Input
            end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
                }):Play()
            end
        end)
    end)
end

-- Create the Main Window
function UILibrary:MakeWindow(settings)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local Sidebar = Instance.new("Frame")
    local ContentFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CustomizationTabButton = Instance.new("TextButton")
    
    -- ScreenGui
    ScreenGui.Name = settings.Name or "CustomUILibrary"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = currentTheme.BackgroundColor
    MainFrame.BackgroundTransparency = currentTheme.Transparency
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BorderSizePixel = 0

    -- TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = currentTheme.TopBarColor
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = currentTheme.CloseButtonColor
    CloseButton.Size = UDim2.new(0, 40, 1, 0)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 16
    CloseButton.TextColor3 = currentTheme.TextColor

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = currentTheme.MinimizeButtonColor
    MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextSize = 16
    MinimizeButton.TextColor3 = currentTheme.TextColor

    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = currentTheme.SidebarColor
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = currentTheme.ContentFrameColor
    ContentFrame.Size = UDim2.new(1, -150, 1, -40)
    ContentFrame.Position = UDim2.new(0, 150, 0, 40)

    -- Title Label
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = settings.Name or "UI Library"
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = currentTheme.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Apply theme to UI elements
    applyTheme(MainFrame, TopBar, Sidebar, ContentFrame, CloseButton, MinimizeButton, TitleLabel, currentTheme)

    -- Make the window draggable
    AddDraggingFunctionality(TopBar, MainFrame)

    -- Make the Tabs
    function UILibrary:MakeTab(tabSettings)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabSettings.Name
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Text = tabSettings.Name
        TabButton.Font = Enum.Font.SourceSans
        TabButton.TextColor3 = currentTheme.TextColor
        TabButton.TextSize = 18

        -- When tab is clicked, show its content
        TabButton.MouseButton1Click:Connect(function()
            ContentFrame.Visible = true
        end)

        function Tab:AddSection(sectionSettings)
            local Section = Instance.new("Frame")
            Section.Parent = ContentFrame
            Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Section.Size = UDim2.new(1, 0, 0, 100)
            Section.Position = UDim2.new(0, 0, 0, 0)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Parent = Section
            SectionTitle.Text = sectionSettings.Name
            SectionTitle.Size = UDim2.new(1, 0, 0, 30)
            SectionTitle.TextColor3 = currentTheme.TextColor
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Font = Enum.Font.SourceSans
            SectionTitle.TextSize = 16

            -- Adding button, toggle, slider to the section later
        end

        return Tab
    end

    -- MakeNotification Function
    function UILibrary:MakeNotification(notificationSettings)
        local NotificationFrame = Instance.new("Frame")
        local TitleLabel = Instance.new("TextLabel")
        local ContentLabel = Instance.new("TextLabel")
        local ImageLabel = Instance.new("ImageLabel")
        local CloseButton = Instance.new("TextButton")
        
        -- Setup Frame
        NotificationFrame.Parent = ScreenGui
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationFrame.BackgroundTransparency = 0.5
        NotificationFrame.Size = UDim2.new(0, 300, 0, 150)
        NotificationFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
        NotificationFrame.BorderSizePixel = 0

        -- Title
        TitleLabel.Parent = NotificationFrame
        TitleLabel.Text = notificationSettings.Name or "Notification"
        TitleLabel.Size = UDim2.new(1, 0, 0, 30)
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextSize = 18

        -- Content
        ContentLabel.Parent = NotificationFrame
        ContentLabel.Text = notificationSettings.Content or "No Content"
        ContentLabel.Size = UDim2.new(1, 0, 0, 60)
        ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Font = Enum.Font.SourceSans
        ContentLabel.TextSize = 14

        -- Image
        ImageLabel.Parent = NotificationFrame
        ImageLabel.Image = notificationSettings.Image or "rbxassetid://4483345998"
        ImageLabel.Size = UDim2.new(0, 50, 0, 50)
        ImageLabel.Position = UDim2.new(0, 10, 0, 50)

        -- Close button
        CloseButton.Parent = NotificationFrame
        CloseButton.Text = "X"
        CloseButton.Size = UDim2.new(0, 40, 0, 40)
        CloseButton.Position = UDim2.new(1, -40, 0, 0)
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        CloseButton.Font = Enum.Font.SourceSansBold
        CloseButton.TextSize = 18

        -- Close Button Logic
        CloseButton.MouseButton1Click:Connect(function()
            NotificationFrame:Destroy()
        end)

        -- Auto-close after a certain time
        delay(notificationSettings.Time or 5, function()
            NotificationFrame:Destroy()
        end)
    end

    return UILibrary
end

return UILibrary
