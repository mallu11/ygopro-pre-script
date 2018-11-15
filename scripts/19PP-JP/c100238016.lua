--シンクロ・トランセンド
--Synchro Transcend
--Scripted by AlphaKretin
function c100238016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100238016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100238016.target)
	e1:SetOperation(c100238016.activate)
	c:RegisterEffect(e1)
end
function c100238016.opfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c100238016.tpfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp)
end
function c100238016.tpfilter(c,lv,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100238016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c100238016.opfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingTarget(c100238016.opfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100238016.opfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100238016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp)<=0 or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100238016.tpfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel(),e,tp):GetFirst()
	if sg and Duel.SpecialSummonStep(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(100238016,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sg:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
