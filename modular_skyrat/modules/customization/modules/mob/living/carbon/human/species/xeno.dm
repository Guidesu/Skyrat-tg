/datum/species/xeno
	// A cloning mistake, crossing human and xenomorph DNA
	name = "Xenomorph Hybrid"
	id = "xeno"
	say_mod = "hisses"
	exotic_blood = /datum/reagent/toxin/acid/blood
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_ACIDBLOOD)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list()
	mutant_organs = list(/obj/item/organ/resonator/xeno,/obj/item/organ/vocal_cords/xeno)
	default_mutant_bodyparts = list("tail" = "Xenomorph Tail", "legs" = "Digitigrade Legs", "xenodorsal" = ACC_RANDOM, "xenohead" = ACC_RANDOM, "taur" = "None")
	attack_verb = "slash"
	var/attack_vis_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'modular_skyrat/modules/customization/icons/mob/species/xeno_parts_greyscale.dmi'
	damage_overlay_type = "xeno"
	deathsound = 'sound/voice/hiss6.ogg'
	var/faction = list(ROLE_ALIEN)
	punchdamagelow = 7
	punchdamagehigh = 19
	punchstunthreshold = 17
	armor = 5
	brutemod = 0.5
	coldmod = 0.5
	acidmod = 0.2
	heatmod = 3
	burnmod = 3
	siemens_coeff = 3
	mutantliver = /obj/item/organ/liver/alien
	mutantbrain = /obj/item/organ/brain/alien


#define ORGAN_SLOT_XENO_RESONATOR "xeno_resonator"
#define isxenomorph(A) (is_species(A, /datum/species/xeno))
/obj/item/organ/resonator/xeno
	name = "xenomorphic resonator"
	desc = "Fragments from the Xenomorph, stemming from their origins. These are used to \"hear\" messages from their other kin."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_XENO_RESONATOR
	icon_state = "hivenode"

/obj/item/organ/vocal_cords/xeno
	name = "xenomorphic physic transmisor"
	desc = "When its resonates, it causes all nearby pieces of xenomorphs to resonate as well."
	actions_types = list(/datum/action/item_action/organ_action/use/adamantine_vocal_cords)
	icon_state = "hivenode"

/datum/action/item_action/organ_action/use/xeno_vocal_cords/Trigger()
	if(!IsAvailable())
		return
	var/message = input(owner, "Resonate a message to all nearby xenomorphs.", "Resonate")
	if(QDELETED(src) || QDELETED(owner) || !message)
		return
	owner.say(".x[message]")

/obj/item/organ/vocal_cords/xeno/handle_speech(message)
	var/msg = "<span class='resonate'><span class='name'>[owner.real_name]</span> <span class='message'>resonates, \"[message]\"</span></span>"
	for(var/m in GLOB.player_list)
		if(iscarbon(m))
			var/mob/living/carbon/C = m
			if(C.getorganslot(ORGAN_SLOT_XENO_RESONATOR))
				to_chat(C, msg)
		if(isobserver(m))
			var/link = FOLLOW_LINK(m, owner)
			to_chat(m, "[link] [msg]")


/datum/reagent/toxin/acid/blood
	name = "Sulphuric Blood"
	description = "A weaker solution of acid with the molecular formula H2SO4."
	color = "#00FF32"
	toxpwr = 1
	acidpwr = 10 //the amount of protection removed from the armour
	taste_description = "Acid heresy"
	self_consuming = TRUE
	ph = 3.90
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/acid/proc/reaction_mob(mob/living/carbon/C, method, reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		if(!HAS_TRAIT(C, TRAIT_ACIDBLOOD))
			C.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(method == INJECT)
		if(!HAS_TRAIT(C, TRAIT_ACIDBLOOD))
			C.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	C.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ACIDBLOOD))
		M.adjustToxLoss(clamp((toxpwr-2)*REM, -toxpwr*REM, 0))  //Counteracts toxin damage from parent, stronger acids will still do toxin damage to those with acidic blood but weaker acids will not
	. = 1
	..()
