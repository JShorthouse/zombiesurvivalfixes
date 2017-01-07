include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

function ENT:DrawBar(x, y, w, h, factor, text)
	factor = math.Clamp(factor, 0, 1)
	
	local barwidth = w * factor
	local startx = x - w / 2
	local red, green = (1 - factor) * 255, (factor) * 255
	
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawRect(startx, y, w, h)
	surface.SetDrawColor(red, green, 0, 220)
	surface.DrawRect(startx + 4, y + 4, barwidth - 8, h - 8)
	surface.DrawOutlinedRect(startx, y, w, h)
	draw.SimpleText(text, "DermaLarge", x, y + h/2, Color(red, red, red, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local colFlash = Color(30, 255, 30)
function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()

	local w, h = 600, 420

	cam.Start3D2D(self:LocalToWorld(Vector(1, 0, self:OBBMaxs().z)), self:GetAngles(), 0.05)

		draw.RoundedBox(64, w * -0.5, h * -0.5, w, h, color_black_alpha120)

		draw.SimpleText(translate.Get("arsenal_crate"), "ZS3D2DFont2", 0, 0, COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if MySelf:Team() == TEAM_HUMAN and GAMEMODE:PlayerCanPurchase(MySelf) then
			colFlash.a = math.abs(math.sin(CurTime() * 5)) * 255
			draw.SimpleText(translate.Get("purchase_now"), "ZS3D2DFont2Small", 0, -100, colFlash, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local healthfactor = self:GetObjectHealth() / self:GetMaxObjectHealth()
		--local healthfactor = math.sin(CurTime() * 0.5)
		if healthfactor < 1 then
			self:DrawBar(0, 150, 550, 40, healthfactor, string.format("%i", healthfactor*100).."%")
		end
		
		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, 100, owner == MySelf and COLOR_BLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	cam.End3D2D()
end
