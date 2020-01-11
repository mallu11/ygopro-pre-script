--宵星の騎士ギルス

--Scripted by mallu11
function c101012024.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012024,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101012024)
	e1:SetTarget(c101012024.tgtg)
	e1:SetOperation(c101012024.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012024,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101012124)
	e3:SetCondition(c101012024.spcon)
	e3:SetTarget(c101012024.sptg)
	e3:SetOperation(c101012024.spop)
	c:RegisterEffect(e3)
end
function c101012024.tgfilter(c)
	return c:IsSetCard(0x11b,0xfe) and c:IsAbleToGrave()
end
function c101012024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012024.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101012024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101012024.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		if c:GetColumnGroup():GetCount()>=2 and c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c101012024.tgfilter(c)
	return c:IsSetCard(0x11b,0xfe) and c:IsAbleToGrave()
end
function c101012024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function c101012024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,101012124,0xfe,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c101012024.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101012124,0xfe,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,101012124)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token=Duel.CreateToken(tp,101012124)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end