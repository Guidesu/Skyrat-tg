/obj/item/gun/ballistic/automatic/vintorez
	name = "\improper SolGov M41A-MKIV Pulse rilfe'"
	desc = "The M41A Pulse Rifle is a 10 mm pulse-action air-cooled assault rifle used as the primary infantry weapon by the SolGov Marine Corps and SolGov Fleet in during the late 22nd century."
	icon = 'modular_skyrat/modules/solarian_revolution/weapons.dmi'
	righthand_file = 'modular_skyrat/modules/solarian_revolution/right_hand.dmi'
	lefthand_file = 'modular_skyrat/modules/solarian_revolution/left_hand.dmi'
	icon_state = "vintorez"
	worn_icon = 'modular_skyrat/modules/sec_haul/icons/guns/norwind.dmi'
	worn_icon_state = "norwind_worn"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT | ITEM_SLOT_OCLOTHING
	inhand_icon_state = "vintorez"
	mag_type = /obj/item/ammo_box/magazine/multi_sprite/vintorez
	can_suppress = FALSE
	can_bayonet = TRUE
	mag_display = TRUE
	mag_display_ammo = TRUE
	realistic = TRUE
	burst_size = 4
	fire_delay = 2
	spread = 4
	zoomable = FALSE
	fire_sound = 'sound/weapons/gun/smg/shot_suppressed.ogg'
	emp_damageable = FALSE
	armadyne = FALSE
modular_skyrat\modules\solarian_revolution\weapons.dmi
/obj/item/ammo_box/magazine/multi_sprite/vintorez
	name = "vintorez rifle magazine (9mm)"
	icon = 'modular_skyrat/modules/sec_haul/icons/guns/mags.dmi'
	icon_state = "norwind"
	ammo_type = /obj/item/ammo_casing/b9mm
	caliber = CALIBER_9MM
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY_BASIC

/obj/item/ammo_box/magazine/multi_sprite/vintorez/hp
	ammo_type = /obj/item/ammo_casing/b9mm/hp
	round_type = AMMO_TYPE_HOLLOWPOINT

/obj/item/ammo_box/magazine/multi_sprite/vintorez/rubber
	ammo_type = /obj/item/ammo_casing/b9mm/rubber
	round_type = AMMO_TYPE_RUBBER

/obj/item/ammo_box/magazine/multi_sprite/vintorez/ihdf
	ammo_type = /obj/item/ammo_casing/b9mm/ihdf
	round_type = AMMO_TYPE_IHDF

//Non-ERT M41A shit




//This are ERT weaponary so its makes sense to be OP
/obj/projectile/bullet/m41a
	name = "10x24mm Caseless bullet"
	damage = 40

/obj/projectile/bullet/m41a
	name = "10x24mm AP Caseless bullet"
	damage = 30
	armour_penetration = 60

/obj/projectile/bullet/m41a
	name = "10x24mm hollow-point Caseless bullet"
	damage = 80
	weak_against_armour = TRUE

/obj/projectile/bullet/incendiary/m41a
	name = "10x24mm incendiary bullet"
	damage = 40
	fire_stacks = 5
