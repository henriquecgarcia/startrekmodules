---------------------------------------
---------------------------------------
--         Star Trek Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--    LCARS Category List | Client   --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(windowData)
	self.Padding = self.Padding or 1
	self.FrameType = self.FrameType or "frame_triple"

	self.CategoryButtonHeight = windowData.CategoryButtonHeight

	self.CategoryCount = #windowData.Categories

	local smallCategories = false
	if self.CategoryCount <= 4 then
		smallCategories = true
	end

	local categories = {}
	for i, categoryData in pairs(windowData.Categories) do
		categoryData.Id = i
		categories[i] = categoryData
	end

	self.SubCategories = {}
	while true do
		if smallCategories and #categories > 2 then
			local subCategories = {
				table.remove(categories, 1), -- 1st Entry in List
				table.remove(categories, 1), -- 2nd Entry in List
			}

			table.insert(self.SubCategories, subCategories)
		elseif #categories > 4 then
			local subCategories = {
				table.remove(categories, 1), -- 1st Entry in List
				table.remove(categories, 1), -- 2nd Entry in List
				table.remove(categories, 1), -- 3rd Entry in List
				table.remove(categories, 1), -- 4th Entry in List
			}

			table.insert(self.SubCategories, subCategories)
		else
			table.insert(self.SubCategories, categories)

			break
		end
	end

	local nRows = #self.SubCategories
	self.SubMenuHeight = nRows * (self.CategoryButtonHeight + self.Padding) + self.Padding

	local success = SELF.Base.OnCreate(self, windowData)
	if not success then
		return false
	end

	self.Selected = windowData.Selected

	self.CategoryRows = {}
	for i, subCategories in pairs(self.SubCategories) do
		self.CategoryRows[i] = self:SetupCategoryRow(subCategories)
	end

	for rowId, rowData in pairs(self.CategoryRows) do
		rowData.Y = self.Area2Y + (rowId - 1) * (self.CategoryButtonHeight + self.Padding)
		rowData.YEnd = rowData.Y + self.CategoryButtonHeight

		for butId, categoryData in pairs(rowData.Categories) do
			local successButton, button = self:GenerateElement("button", self.Id .. "_" .. rowId .. "_" .. butId, rowData.Width, self.CategoryButtonHeight,
				categoryData.Name or "[ERROR]", nil,
				categoryData.Color, Star_Trek.LCARS.ColorOrange,
				butId > 1, butId < rowData.N,
				categoryData.Disabled, self.Selected == categoryData.Id, false)
			if not successButton then return false end

			categoryData.Button = button

			categoryData.X = self.Area1X + (butId - 1) * (rowData.Width + self.Padding)
			categoryData.XEnd = categoryData.X + rowData.Width
		end
	end

	return self
end

function SELF:SetupCategoryRow(categories)
	local rowData = {
		Categories = {}
	}

	if #categories == 1 then
		rowData.Width = self.Area1Width
		rowData.N = 1

		table.insert(rowData.Categories, categories[1])
	elseif #categories == 2 then
		rowData.Width = (self.Area1Width - self.Padding) / 2
		rowData.N = 2

		table.insert(rowData.Categories, categories[1])
		table.insert(rowData.Categories, categories[2])
	elseif #categories == 3 or #categories == 4 then
		rowData.Width = (self.Area1Width - 3 * self.Padding) / 4
		rowData.N = 4

		table.insert(rowData.Categories, categories[1])
		table.insert(rowData.Categories, categories[2])
		table.insert(rowData.Categories, categories[3])
		if #categories == 4 then
			table.insert(rowData.Categories, categories[4])
		else
			table.insert(rowData.Categories, {
				Disabled = true,
				Name = "",
				Color = Star_Trek.LCARS.ColorGrey,
			})
		end
	end

	return rowData
end

function SELF:OnPress(pos, animPos)
	for rowId, rowData in pairs(self.CategoryRows) do
		for butId, categoryData in pairs(rowData.Categories) do
			if categoryData.Disabled then continue end

			if self:IsButtonHovered(categoryData.X, rowData.Y, categoryData.XEnd, rowData.YEnd, pos) then
				return categoryData.Id
			end
		end
	end

	local buttonId = SELF.Base.OnPress(self, pos, animPos)
	if isnumber(buttonId) then
		return self.CategoryCount + buttonId
	end
end

function SELF:OnDraw(pos, animPos)
	surface.SetDrawColor(255, 255, 255, 255 * animPos)

	for rowId, rowData in pairs(self.CategoryRows) do
		for butId, categoryData in pairs(rowData.Categories) do
			categoryData.Button.Hovered = self:IsButtonHovered(categoryData.X, rowData.Y, categoryData.XEnd, rowData.YEnd, pos)
			categoryData.Button:Render(categoryData.X, rowData.Y)
		end
	end

	SELF.Base.OnDraw(self, pos, animPos)
end