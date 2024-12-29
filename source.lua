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
    -- Additional themes...
}

-- Create a new window with glassmorphism
function DeletionLibrary:MakeWindow(options)
    local theme = ColorThemes[options.Theme] or ColorThemes.DefaultDark
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")

    -- Create the ScreenGui and position it
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = theme.Main
    MainFrame.BackgroundTransparency = 0.5 -- Make background slightly transparent
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Add blur effect to achieve glassmorphism
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 15
    blurEffect.Parent = MainFrame

    -- Add gradient to enhance the frosted effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))})
    gradient.Rotation = 45
    gradient.Parent = MainFrame

    -- Create Title Label
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = theme.Second
    TitleLabel.Text = options.Name or "Untitled"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.Parent = MainFrame

    -- Close Button
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
        end
    }
end

-- Create a new tab with glassmorphism effects
function DeletionLibrary:MakeTab(parent, options, theme)
    local TabFrame = Instance.new("Frame")
    local TabButton = Instance.new("TextButton")
    local TabContent = Instance.new("Frame")

    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundColor3 = theme.Main
    TabFrame.Visible = false
    TabFrame.Parent = parent

    -- Add blur effect and transparency for glassmorphism
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 15
    blurEffect.Parent = TabFrame

    -- Add gradient to the tab
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))})
    gradient.Rotation = 45
    gradient.Parent = TabFrame

    -- Tab Button
    TabButton.Size = UDim2.new(0, 100, 0, 40)
    TabButton.BackgroundColor3 = theme.Second
    TabButton.Text = options.Name or "Tab"
    TabButton.TextColor3 = theme.Text
    TabButton.Parent = parent

    TabButton.MouseButton1Click:Connect(function()
        TabFrame.Visible = not TabFrame.Visible
    end)

    -- Tab Content with a subtle blur
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundColor3 = theme.Second
    TabContent.Parent = TabFrame

    -- Separate AddButton method with glassmorphism
    function options:AddButton(buttonOptions)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 200, 0, 50)
        Button.Position = UDim2.new(0.5, -100, 0, 10)
        Button.Text = buttonOptions.Name or "Button"
        Button.BackgroundColor3 = theme.Second
        Button.TextColor3 = theme.Text
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 16
        Button.Parent = TabContent

        -- Add blur effect for glassmorphism on the button
        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Size = 5
        blurEffect.Parent = Button

        -- Hover effect
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = theme.Stroke
        end)

        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = theme.Second
        end)

        -- Button click event with callback
        Button.MouseButton1Click:Connect(function()
            if buttonOptions.Callback then
                buttonOptions.Callback()
            end
        end)
    end

    -- Separate AddToggle method with glassmorphism
    function options:AddToggle(toggleOptions)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(0, 250, 0, 50)
        ToggleFrame.Position = UDim2.new(0.5, -125, 0, 10)
        ToggleFrame.BackgroundColor3 = theme.Second
        ToggleFrame.Parent = TabContent

        -- Add blur effect to the toggle frame for glassmorphism
        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Size = 5
        blurEffect.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.Text = toggleOptions.Name or "Toggle"
        ToggleLabel.TextColor3 = theme.Text
        ToggleLabel.TextSize = 16
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Parent = ToggleFrame

        local ToggleSwitch = Instance.new("Frame")
        ToggleSwitch.Size = UDim2.new(0, 50, 0, 25)
        ToggleSwitch.Position = UDim2.new(0.8, 0, 0.5, -12)
        ToggleSwitch.BackgroundColor3 = theme.Stroke
        ToggleSwitch.Parent = ToggleFrame

        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
        ToggleCircle.Position = UDim2.new(0, 0, 0, 0)
        ToggleCircle.BackgroundColor3 = theme.Text
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleSwitch

        local isToggled = toggleOptions.Default or false

        -- Animate the toggle
        local function updateTogglePosition()
            local targetPosition = isToggled and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
            ToggleCircle:TweenPosition(targetPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end

        -- Set initial position based on default value
        updateTogglePosition()

        -- Toggle the switch on click
        ToggleSwitch.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isToggled = not isToggled
                updateTogglePosition()

                -- Call the callback with the new value
                if toggleOptions.Callback then
                    toggleOptions.Callback(isToggled)
                end
            end
        end)
    end

    return {
        AddButton = options.AddButton,
        AddToggle = options.AddToggle,
    }
end

return DeletionLibrary
