local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Function to add smooth dragging functionality
local function AddDraggingFunctionality(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false
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
                TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
            end
        end)
    end)
end

-- CreateWindow function
function UILibrary:CreateWindow(title)
    -- Error handling: Check if title is provided
    if not title then
        error("Title is required for the window!")
    end

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainFrameCorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local Sidebar = Instance.new("Frame")
    local ContentFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local TabButtons = {} -- To store tab buttons

    -- ScreenGui
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BorderSizePixel = 0

    -- MainFrame Corner
    MainFrameCorner.Parent = MainFrame
    MainFrameCorner.CornerRadius = UDim.new(0, 10)

    -- TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BorderSizePixel = 0

    -- Close Button (White X Icon)
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0, 40, 1, 0)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Text = ""
    CloseButton.Image = "rbxassetid://6031090057" -- White X Icon

    -- Close Button Functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextSize = 16
    MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)

    -- Minimize Button Functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Visible = not minimized
    end)

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BorderSizePixel = 0

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ContentFrame.Size = UDim2.new(1, -150, 1, -40)
    ContentFrame.Position = UDim2.new(0, 150, 0, 40)
    ContentFrame.BorderSizePixel = 0

    -- Title Label
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title or "UI Library"
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Use AddDraggingFunctionality to make the window draggable
    AddDraggingFunctionality(TopBar, MainFrame)

    -- Add tabs to Sidebar
    local function addTab(tabName, content)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Sidebar
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.TextSize = 16

        -- When the tab is clicked, show its content
        TabButton.MouseButton1Click:Connect(function()
            for _, button in pairs(TabButtons) do
                button.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            ContentFrame:ClearAllChildren()
            content(ContentFrame)
        end)

        table.insert(TabButtons, TabButton)
    end

    -- Customization Tab (UI Customization)
    addTab("Customization", function(parent)
        -- Color Picker for Background
        local bgColorButton = Instance.new("TextButton")
        bgColorButton.Parent = parent
        bgColorButton.Size = UDim2.new(0, 200, 0, 30)
        bgColorButton.Text = "Change Background Color"
        bgColorButton.Position = UDim2.new(0, 10, 0, 10)
        bgColorButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        
        bgColorButton.MouseButton1Click:Connect(function()
            -- Change the background color of the MainFrame
            MainFrame.BackgroundColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        end)

        -- Font Selector
        local fontLabel = Instance.new("TextLabel")
        fontLabel.Parent = parent
        fontLabel.Size = UDim2.new(0, 200, 0, 30)
        fontLabel.Text = "Select Font"
        fontLabel.Position = UDim2.new(0, 10, 0, 50)
        fontLabel.BackgroundTransparency = 1

        local fontDropdown = Instance.new("TextButton")
        fontDropdown.Parent = parent
        fontDropdown.Size = UDim2.new(0, 200, 0, 30)
        fontDropdown.Text = "Choose Font"
        fontDropdown.Position = UDim2.new(0, 10, 0, 80)

        fontDropdown.MouseButton1Click:Connect(function()
            -- Change the font of the TitleLabel
            TitleLabel.Font = Enum.Font.Gotham -- You can change this to any font you want
        end)
    end)

    -- Player Info Tab (Automatically Added)
    addTab("Player Info", function(parent)
        local usernameLabel = Instance.new("TextLabel")
        usernameLabel.Parent = parent
        usernameLabel.Text = "Username: " .. game.Players.LocalPlayer.Name
        usernameLabel.Size = UDim2.new(0, 200, 0, 30)
        usernameLabel.Position = UDim2.new(0, 10, 0, 10)
        usernameLabel.BackgroundTransparency = 1
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Parent = parent
        levelLabel.Text = "Level: 1"  -- This would be dynamic based on player data
        levelLabel.Size = UDim2.new(0, 200, 0, 30)
        levelLabel.Position = UDim2.new(0, 10, 0, 50)
        levelLabel.BackgroundTransparency = 1

        local scoreLabel = Instance.new("TextLabel")
        scoreLabel.Parent = parent
        scoreLabel.Text = "Score: 1000"  -- This would be dynamic as well
        scoreLabel.Size = UDim2.new(0, 200, 0, 30)
        scoreLabel.Position = UDim2.new(0, 10, 0, 90)
        scoreLabel.BackgroundTransparency = 1
    end)

    -- Chat Logger Tab (Automatically Added)
    addTab("Chat Logger", function(parent)
        local chatBox = Instance.new("TextBox")
        chatBox.Parent = parent
        chatBox.Size = UDim2.new(0, 200, 0, 200)
        chatBox.Position = UDim2.new(0, 10, 0, 10)
        chatBox.Text = ""
        chatBox.TextColor3 = Color3.fromRGB(0, 0, 0)
        chatBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        chatBox.TextSize = 14
        chatBox.ClearTextOnFocus = false

        -- Log chat messages
        game:GetService("Chat").ChatBar.MessageSent:Connect(function(message)
            chatBox.Text = chatBox.Text .. message .. "\n"
        end)
    end)

    return UILibrary
end

return UILibrary
