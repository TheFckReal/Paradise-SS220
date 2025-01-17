// =============
// ENGINEER
// =============

// надувные стены
/obj/item/inflatable/cyborg
	name = "надувная стена"
	desc = "Сложенная надувная стена, которая при активации быстро расширяется до большой кубической мембраны."
	var/power_use = 400
	var/structure_type = /obj/structure/inflatable

/obj/item/inflatable/cyborg/door
	name = "надувной шлюз"
	desc = "Сложенный надувной шлюз, который при активации быстро расширяется в простую дверь."
	icon_state = "folded_door"
	power_use = 600
	structure_type = /obj/structure/inflatable/door

/obj/item/inflatable/cyborg/examine(mob/user)
	. = ..()
	. += span_notice("Как синтетик, вы можете восстановить их в <b>cyborg recharger</b>")

/obj/item/inflatable/cyborg/attack_self(mob/user)
	if(locate(/obj/structure/inflatable) in get_turf(user))
		to_chat(user, span_warning("Здесь уже есть надувная стена!"))
		return FALSE

	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, span_notice("Вы надули [name]"))
	var/obj/structure/inflatable/R = new structure_type(user.loc)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	useResource(user)

/obj/item/inflatable/cyborg/proc/useResource(mob/user)
	if(!isrobot(user))
		return FALSE
	var/mob/living/silicon/robot/R = user
	if(R.cell.charge < power_use)
		to_chat(user, span_warning("Недостаточно заряда!"))
		return FALSE
	return R.cell.use(power_use)

// Небольшой багфикс "непрозрачного открытого шлюза"
/obj/structure/inflatable/door/operate()
	. = ..()
	opacity = FALSE


// =============
// MEDICAL
// =============

/obj/item/reagent_containers/borghypo/basic/Initialize(mapload)
	. = ..()
	reagent_ids |= list("sal_acid", "charcoal")

/obj/item/reagent_containers/borghypo/basic/upgraded
	name = "Upgraded Medical Hypospray"
	desc = "Upgraded medical hypospray, capable of providing standart medical treatment."
	reagent_ids = list("salglu_solution", "epinephrine", "spaceacillin", "sal_acid",
	"charcoal", "hydrocodone", "mannitol", "salbutamol", "styptic_powder")
	total_reagents = 60
	maximum_reagents = 60



// =============
// SERVICE
// =============
/obj/item/rsf/attack_self(mob/user)
	if(..() && power_mode >= 3000)
		power_mode /= 2

/obj/item/eftpos/cyborg
	name = "Silicon EFTPOS"
	desc = "Проведите ID картой для оплаты налогов."
	transaction_purpose = "Оплата счета от робота."

/obj/item/eftpos/cyborg/Initialize(mapload)
	. = ..()
	transaction_purpose = "Оплата счета от [usr.name]."

/obj/item/eftpos/ui_act(action, list/params, datum/tgui/ui)
	var/mob/living/user = ui.user

	switch(action)
		if("toggle_lock")
			if(transaction_locked)
				if(!check_user_position(user))
					return
				transaction_locked = FALSE
				transaction_paid = FALSE
			else if(linked_account)
				transaction_locked = TRUE
			else
				to_chat(user, "[bicon(src)]<span class='warning'>No account connected to send transactions to.</span>")
			return TRUE
		// if(isrobot(user))
		// 	card_account = attempt_account_access(id_card.associated_account_number, pin_needed = FALSE)
	. = ..()

// =============
// MINER
// =============
