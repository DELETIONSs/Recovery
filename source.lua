local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- SimpleUILibrary ModuleScript
local SimpleUILibrary = {}
local UserInputService = game:GetService("UserInputService")

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

-- Function to create a new UI window
function SimpleUILibrary:CreateWindow(title, theme)
    theme = theme or ColorThemes.DefaultDark  -- Default to DefaultDark if no theme is provided
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")

    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = theme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = theme.Second
    TitleLabel.Text = title
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.Parent = MainFrame

    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return MainFrame
end

-- Function to create a button
function SimpleUILibrary:CreateButton(parent, text, callback, theme)
    theme = theme or ColorThemes.DefaultDark  -- Default to DefaultDark if no theme is provided
    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = theme.Stroke
    Button.Text = text
    Button.TextColor3 = theme.Text
    Button.Parent = parent

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

-- Function to create a slider
function SimpleUILibrary:CreateSlider(parent, min, max, default, callback, theme)
    theme = theme or ColorThemes.DefaultDark  -- Default to DefaultDark if no theme is provided
    local SliderFrame = Instance.new("Frame")
    local SliderBar = Instance.new("Frame")
    local SliderButton = Instance.new("TextButton")
    local ValueLabel = Instance.new("TextLabel")

    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = theme.Main
    SliderFrame.Parent = parent

    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0.5, -5)
    SliderBar.BackgroundColor3 = theme.Stroke
    SliderBar.Parent = SliderFrame

    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0, -5)
    SliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    ValueLabel.Size = UDim2.new(1, 0, 0, 20)
    ValueLabel.Position = UDim2.new(0, 0, 1, 0)
    ValueLabel.Text = "Value: " .. default
    ValueLabel.TextColor3 = theme.Text
    ValueLabel.Parent = SliderFrame

    -- Set initial value
    SliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0, -5)

    SliderButton.MouseDrag:Connect(function()
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderX = SliderBar.AbsolutePosition.X
        local sliderWidth = SliderBar.AbsoluteSize.X

        local newValue = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1) * (max - min) + min
        SliderButton.Position = UDim2.new((newValue - min) / (max - min), 0, 0, -5)
        ValueLabel.Text = "Value: " .. math.floor(newValue)

        if callback then
            callback(newValue)
        end
    end)

    return SliderFrame
end

return SimpleUILibrary
