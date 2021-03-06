
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	undershirt = random_undershirt(gender)
	socks = random_socks(gender)
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	if(!pref_species)
		pref_species = new /datum/species/human()
	backbag = 1
	features = random_features()
	age = rand(AGE_MIN,AGE_MAX)

/datum/preferences/proc/update_preview_icon()
	if(is_updating_icon)
		return
	is_updating_icon = 1
	// Silicons only need a very basic preview since there is no customization for them.
	if(job_vault_high)
		switch(job_vault_high)
			if(AI)
				preview_icon = icon('icons/mob/AI.dmi', "AI", SOUTH)
				preview_icon.Scale(64, 64)
				return
			if(CYBORG)
				preview_icon = icon('icons/mob/robots.dmi', "robot", SOUTH)
				preview_icon.Scale(64, 64)
				return

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = new()
	copy_to(mannequin)

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	var/highRankFlag = job_ncr_high | job_legion_high | job_bos_high | job_wasteland_high | job_vault_high | job_enclave_high

	if(job_wasteland_low & WASTELAND)
		previewJob = SSjob.GetJob("Wastelander")
	else if(highRankFlag)
		var/highDeptFlag
		if(job_ncr_high)
			highDeptFlag = NCR
		else if(job_legion_high)
			highDeptFlag = LEGION
		else if(job_den_high)
			highDeptFlag = DEN
		else if(job_bos_high)
			highDeptFlag = BOS
		else if(job_wasteland_high)
			highDeptFlag = WASTELAND
		else if(job_vault_high)
			highDeptFlag = VAULT
		else if(job_enclave_high)
			highDeptFlag = ENCLAVE
		for(var/datum/job/job in SSjob.occupations)
			if(job.flag == highRankFlag && job.department_flag == highDeptFlag)
				previewJob = job
				break

	if(previewJob)
		mannequin.job = previewJob.title
		previewJob.equip(mannequin, TRUE)

	preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	qdel(mannequin)
	sleep(5)
	is_updating_icon = 0
