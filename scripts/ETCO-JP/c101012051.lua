--コードブレイカー・ウイルスバーサーカー

--Scripted by mallu11
function c101012051.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c101012051.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012051,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101012051)
	e1:SetCost(c101012051.spcon)
	e1:SetTarget(c101012051.sptg)
	e1:SetOperation(c101012051.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012051,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101012151)
	e2:SetTarget(c101012051.destg)
	e2:SetOperation(c101012051.desop)
	c:RegisterEffect(e2)
end
function c101012051.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x23c)
end
function c101012051.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c101012051.spfilter(c,e,tp)
	if not c:IsSetCard(0x23c) then return false end
	local ok=false
	for p=0,1 do
		local zone=Duel.GetLinkedZone(p)&0xff
		ok=ok or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone))
	end
	return ok
end
function c101012051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c101012051.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101012051.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone={}
	local flag={}
	for p=0,1 do
		zone[p]=Duel.GetLinkedZone(p)&0xff
		local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
		flag[p]=(~flag_tmp)&0x7f
	end
	local ft1=Duel.GetLocationCount(0,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[0])
	local ft2=Duel.GetLocationCount(0,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1])
	if ft1+ft2<=0 then return end
	local ct=math.min(ft1+ft2,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101012051.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local ava_zone=0
			for p=0,1 do
				if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone[p]) then
					ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
			local sump=0
			if sel_zone&0xff>0 then
				sump=tp
			else
				sump=1-tp
				sel_zone=sel_zone>>16
			end
			Duel.SpecialSummonStep(tc,0,tp,sump,false,false,POS_FACEUP,sel_zone)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c101012051.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101012051.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsLinkState,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,ct,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
