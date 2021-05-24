/datum/job
	var/alt_title_pref

/datum/job/proc/get_alt_title_pref(client/preference_source)
	if(preference_source && preference_source.prefs && preference_source.prefs.alt_titles_preferences[title])
		alt_title_pref = preference_source.prefs.alt_titles_preferences[title]
	else
		alt_title_pref = title

/datum/job/proc/get_id_titles(mob/living/carbon/human/H, obj/item/card/id/ID)
	ID.real_title = title
	if(H.client && H.client.prefs && H.client.prefs.alt_titles_preferences[title])
		ID.assignment = H.client.prefs.alt_titles_preferences[title]
	else if (alt_title_pref)
		ID.assignment = alt_title_pref
	else
		ID.assignment = title

/datum/job/proc/get_pda_titles(mob/living/carbon/human/H, obj/item/pda/PDA)
	if(H.client && H.client.prefs && H.client.prefs.alt_titles_preferences[title])
		PDA.ownjob = H.client.prefs.alt_titles_preferences[title]
	else if (alt_title_pref)
		PDA.ownjob = alt_title_pref
	else
		PDA.ownjob = title

/datum/job/proc/announce_head(mob/living/carbon/human/H, channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	if(H && GLOB.announcement_systems.len)
		if(alt_title_pref)
			//timer because these should come after the captain announcement
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/_addtimer, CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, alt_title_pref, channels), 1))
		else
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/_addtimer, CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, H.job, channels), 1))

//Command
/datum/job/captain
	alt_titles = list("Station Commander", "Commanding Officer", "Site Manager")

/datum/job/head_of_personnel
	alt_titles = list("Executive Officer", "Employment Officer", "Crew Supervisor")

/datum/job/head_of_security
	alt_titles = list("Security Commander", "Chief Constable", "Chief of Security", "Sherriff","Chief Military Police")

/datum/job/chief_engineer
	alt_titles = list("Engineering Foreman","Engineering Officer")

/datum/job/research_director
	alt_titles = list("Silicon Administrator", "Lead Researcher", "Biorobotics Director", "Research Supervisor", "Chief Science Officer")

/datum/job/quartermaster
	alt_titles = list("Deck Chief", "Cargo Foreman","Deck Officer")

/datum/job/chief_medical_officer
	alt_titles = list("Medical Director","Medical Officer")

//Engineering
/datum/job/station_engineer
	alt_titles = list("Emergency Damage Control Technician", "Electrician", "Engine Technician", "EVA Technician", "Engineer", "Military Engineer","Engineer Trainee")

/datum/job/atmospheric_technician
	alt_titles = list("Life Support Technician", "Emergency Fire Technician","Firefigther","Life Support Specialist","Trainee Atmospheric Technician")

//Medical
/datum/job/doctor
	alt_titles = list("Surgeon", "Nurse","Physician","Coroner","Medical Intern","Trainee Nurse")

/datum/job/paramedic
	alt_titles = list("Emergency Medical Technician", "Search and Rescue Technician","Corpsman","Traine Paramedic")
/datum/job/virologist
	alt_titles = list("Pathologist","Micro-Biologist","Bio-Engineering Specialist")

/datum/job/chemist
	alt_titles = list("Pharmacist", "Pharmacologist","Trainee Chemist")

//Science
/datum/job/scientist
	alt_titles = list("Circuitry Designer", "Xenobiologist", "Cytologist", "Nanomachine Programmer", "Plasma Researcher", "Anomalist", "Lab Technician","Military Researcher","Research Trainee")

/datum/job/roboticist
	alt_titles = list("Biomechanical Engineer", "Mechatronic Engineer","Military Biomechanical Specialist")

/datum/job/geneticist
	alt_titles = list("Mutation Researcher")

//Cargo
/datum/job/cargo_technician
	alt_titles = list("Deck Worker", "Mailman","Military Deck Technician")

/datum/job/shaft_miner
	alt_titles = list("Excavator","Explorer","Military Explorer")

//Service
/datum/job/bartender
	alt_titles = list("Mixologist", "Barkeeper")

/datum/job/cook
	alt_titles = list("Chef", "Butcher", "Culinary Artist", "Sous-Chef","Mess Sergeant")

/datum/job/janitor
	alt_titles = list("Custodian", "Custodial Technicial", "Sanitation Technician", "Maid")

/datum/job/curator
	alt_titles = list("Librarian", "Journalist", "Archivist")

/datum/job/psychologist
	alt_titles = list("Psychiatrist", "Therapist", "Counsellor")

/datum/job/lawyer
	alt_titles = list("Internal Affairs Agent", "Human Resources Agent", "Defence Attorney", "Public Defender", "Barrister", "Prosecutor","Solarian Internal Resources Agent")

/datum/job/chaplain
	alt_titles = list("Priest", "Preacher")

/datum/job/mime
	alt_titles = list("Pantomimist")

/datum/job/clown
	alt_titles = list("Jester")

/datum/job/prisoner
	alt_titles = list("Minimum Security Prisoner", "Maximum Security Prisoner", "SuperMax Security Prisoner", "Protective Custody Prisoner")

/datum/job/assistant
	alt_titles = list("Civilian", "Tourist", "Businessman", "Trader", "Entertainer", "Off-Duty Staff", "Freelancer","Off-Duty Officer","Off-Duty")

/datum/job/botanist
	alt_titles = list("Hydroponicist", "Gardener", "Botanical Researcher", "Herbalist")

//Security
/datum/job/warden
	alt_titles = list("Brig Sergeant", "Dispatch Officer", "Brig Governor", "Jailer","Military Warden","Brig Officer")

/datum/job/detective
	alt_titles = list("Forensic Technician", "Private Investigator", "Forensic Scientist","Military Forensic Specialist")

/datum/job/security_officer
	alt_titles = list("Security Operative", "Peacekeeper","Freelancer Operative","Military Police","Master At Arms","Freelancer Peacekeeper","Cadet")

/datum/job/security_sergeant
	alt_titles = list("Security Squad Leader", "Security Task Force Leader", "Security Fireteam Leader", "Security Enforcer")

/datum/job/security_medic
	alt_titles = list("Field Medic", "Security Corpsman", "Brig Physician")

/datum/job/junior_officer
	alt_titles = list("Station Police", "Civil Protection Officer", "Parole Officer","Civil Protection Cadet")

/datum/job/brigoff
    alt_titles = list("Brig Officer", "Prison Guard","Prison Cadet")

/datum/job/blueshield
	alt_titles = list("Command Bodyguard", "Executive Protection Agent", "Personal Protection Specialist")

//Silicon
/datum/job/ai
	alt_titles = list("Station Intelligence", "Automated Overseer")

/datum/job/cyborg
	alt_titles = list("Robot", "Android")
