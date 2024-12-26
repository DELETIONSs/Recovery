-- DeletionLibrary ModuleScript
local DeletionLibrary = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Color themes
local ColorThemes = {
    DefaultDark = {
        Main = Color3.fromRGB(25, 25, 25),
        Second = Color3.fromRGB(32, 32, 32),
        Stroke = Color3.fromRGB(60, 60, 60),
        Divider = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150)
    },
    DeepOcean = {
        Main = Color3.fromRGB(0, 0, 50),
        Second = Color3.fromRGB(0, 0, 100),
        Stroke = Color3.fromRGB(0, 100, 200),
        Divider = Color3.fromRGB(0, 50, 100),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(180, 180, 180)
    },
    Vercel = {
        Main = Color3.fromRGB(255, 255, 255),
        Second = Color3.fromRGB(240, 240, 240),
        Stroke = Color3.fromRGB(200, 200, 200),
        Divider = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(100, 100, 100)
    },
    Apple = {
        Main = Color3.fromRGB(255, 255, 255),
        Second = Color3.fromRGB(240, 240, 240),
        Stroke = Color3.fromRGB(200, 200, 200),
        Divider = Color3.fromRGB(150, 150, 150),
        Text = Color3.fromRGB(0, 0, 0),
        TextDark = Color3.fromRGB(50, 50, 50)
    },
}

-- Create a new window
function DeletionLibrary:MakeWindow(options)
    local theme = ColorThemes[options.Theme] or ColorThemes.DefaultDark
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")

    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = theme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = theme.Second
    TitleLabel.Text = options.Name or "Untitled"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.Parent = MainFrame

    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if options.CloseCallback then
            options.CloseCallback()
        end
    end)

    return {
        MakeTab = function(tabOptions)
            return self:MakeTab(MainFrame, tabOptions, theme)
        end,
        -- Other methods can be added here
    }
end

-- Create a new tab
function DeletionLibrary:MakeTab(parent, options, theme)
    local TabFrame = Instance.new("Frame")
    local TabButton = Instance.new("TextButton")
    local TabContent = Instance.new("Frame")

    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundColor3 = theme.Main
    TabFrame.Visible = false
    TabFrame.Parent = parent

    TabButton.Size = UDim2.new(0, 100, 0, 40)
    TabButton.BackgroundColor3 = theme.Second
    TabButton.Text = options.Name or "Tab"
    TabButton.TextColor3 = theme.Text
    TabButton.Parent = parent

    TabButton.MouseButton1Click:Connect(function()
        TabFrame.Visible = not TabFrame.Visible
    end)

    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundColor3 = theme.Second
    TabContent.Parent = TabFrame

    return {
        -- Additional methods for the tab can be added here
    }
end

return DeletionLibrary
