/datum/borrow
	var/broker = ""
	var/borrower = ""
	var/datum/stock/stock = null
	var/lease_expires = 0
	var/lease_time = 0
	var/grace_time = 0
	var/grace_expires = 0
	var/share_amount = 0
	var/share_debt = 0
	var/deposit = 0
	var/offer_expires = 0

/datum/stock
	var/name = "Stock"
	var/short_name = "STK"
	var/desc = "A company that does not exist."
	var/list/values = list()
	var/current_value = 10
	var/value_cap = 450000
	var/last_value = 10
	var/list/products = list()

	var/performance = 0						// The current performance of the company. Tends itself to 0 when no events happen.

	// These variables determine standard fluctuational patterns for this stock.
	var/fluctuational_coefficient = 1		// How much the price fluctuates on an average daily basis
	var/average_optimism = 0				// The history of shareholder optimism of this stock
	var/current_trend = 0
	var/last_trend = 0
	var/speculation = 0
	var/bankrupt = 0

	var/disp_value_change = 0
	var/optimism = 0
	var/last_unification = 0
	var/average_shares = 100
	var/outside_shareholders = 10000		// The amount of offstation people holding shares in this company. The higher it is, the more fluctuation it causes.
	var/available_shares = 500000

	var/list/borrow_brokers = list()
	var/list/shareholders = list()
	var/list/borrows = list()
	var/list/events = list()
	var/list/articles = list()
	var/fluctuation_rate = 15
	var/fluctuation_counter = 0
	var/datum/industry/industry = null

/datum/stock/proc/addEvent(var/datum/stockEvent/stock_event)
	events |= stock_event

/datum/stock/proc/addArticle(var/datum/article/stock_article)
	if (!(stock_article in articles))
		articles.Insert(1, stock_article)
	stock_article.ticks = world.time

/datum/stock/proc/generateEvents()
	var/list/types = typesof(/datum/stockEvent) - /datum/stockEvent
	for (var/stock_type in types)
		generateEvent(stock_type)

/datum/stock/proc/generateEvent(var/event_type)
	var/datum/stockEvent/stock_event = new event_type(src)
	addEvent(stock_event)

/datum/stock/proc/affectPublicOpinion(var/boost)
	optimism += rand(0, 500) / 500 * boost
	average_optimism += rand(0, 150) / 5000 * boost
	speculation += rand(-1, 50) / 10 * boost
	performance += rand(0, 150) / 100 * boost

/datum/stock/proc/generateIndustry()
	if (findtext(name, "Farms"))
		industry = new /datum/industry/agriculture
	else if (findtext(name, "Software") || findtext(name, "Programming")  || findtext(name, "IT Group") || findtext(name, "Electronics") || findtext(name, "Electric") || findtext(name, "Nanotechnology"))
		industry = new /datum/industry/it
	else if (findtext(name, "Mobile") || findtext(name, "Communications"))
		industry = new /datum/industry/communications
	else if (findtext(name, "Pharmaceuticals") || findtext(name, "Health"))
		industry = new /datum/industry/health
	else if (findtext(name, "Wholesale") || findtext(name, "Stores"))
		industry = new /datum/industry/consumer
	else
		var/ts = typesof(/datum/industry) - /datum/industry
		var/in_t = pick(ts)
		industry = new in_t
	for (var/i = 0, i < rand(2, 5), i++)
		products += industry.generateProductName(name)

/datum/stock/proc/frc(amt)
	var/shares = available_shares + outside_shareholders * average_shares
	var/fr = amt / 100 / shares * fluctuational_coefficient * fluctuation_rate * max(-(current_trend / 100), 1)
	if ((fr < 0 && speculation < 0) || (fr > 0 && speculation > 0))
		fr *= max(abs(speculation) / 5, 1)
	else
		fr /= max(abs(speculation) / 5, 1)
	return fr

/datum/stock/proc/supplyGrowth(amt)
	var/fr = frc(amt)
	available_shares += amt
	if (abs(fr) < 0.0001)
		return
	current_value -= fr * current_value

/datum/stock/proc/supplyDrop(amt)
	supplyGrowth(-amt)

/datum/stock/proc/fluctuate()
	var/change = rand(-100, 100) / 10 + optimism * rand(200) / 10
	optimism -= (optimism - average_optimism) * (rand(10,80) / 1000)
	var/shift_score = change + current_trend
	var/as_score = abs(shift_score)
	var/sh_change_dev = rand(-10, 10) / 10
	var/sh_change = shift_score / (as_score + 100) + sh_change_dev
	var/shareholder_change = round(sh_change)
	outside_shareholders += shareholder_change
	var/share_change = shareholder_change * average_shares
	if (as_score > 20 && prob(as_score / 4))
		var/avg_change_dev = rand(-10, 10) / 10
		var/avg_change = shift_score / (as_score + 100) + avg_change_dev
		average_shares += avg_change
		share_change += outside_shareholders * avg_change

	var/cv = last_value
	supplyDrop(share_change)
	available_shares += share_change // temporary

	if (prob(25))
		average_optimism = max(min(average_optimism + (rand(-3, 3) - current_trend * 0.15) / 100, 1), -1)

	var/aspec = abs(speculation)
	if (prob((aspec - 75) * 2))
		speculation += rand(-4, 4)
	else
		if (prob(50))
			speculation += rand(-4, 4)
		else
			speculation += rand(-400, 0) / 1000 * speculation
			if (prob(1) && prob(5)) // pop that bubble
				speculation += rand(-4000, 0) / 1000 * speculation
	var/fucking_stock_spikes = current_value + 500
	var/piece_of_shit_fuck = current_value - 500
	var/i_hate_this_code = (speculation / rand(25000, 50000) + performance / rand(100, 800)) * current_value
	if(i_hate_this_code < fucking_stock_spikes || i_hate_this_code > piece_of_shit_fuck)
		current_value += i_hate_this_code
	if(current_value > value_cap)
		current_value = 450000
	if (current_value < 5)
		current_value = 5

	if (performance != 0)
		performance = rand(900,1050) / 1000 * performance
		if (abs(performance) < 0.2)
			performance = 0

	disp_value_change = (cv < current_value) ? 1 : ((cv > current_value) ? -1 : 0)
	last_value = current_value
	if (values.len >= 50)
		values.Cut(1,2)
	values += current_value

	if (current_value < 10)
		unifyShares()

	last_trend = current_trend
	current_trend += rand(-200, 200) / 100 + optimism * rand(200) / 10 + max(50 - abs(speculation), 0) / 50 * rand(0, 200) / 1000 * (-current_trend) + max(speculation - 50, 0) * rand(0, 200) / 1000 * speculation / 400

/datum/stock/proc/unifyShares()
	for (var/shareholder in shareholders)
		var/shr = shareholders[shareholder]
		if (shr % 2)
			sellShares(shareholder, 1)
		shr -= 1
		shareholders[shareholder] /= 2
		if (!shareholders[shareholder])
			shareholders -= shareholder
	for (var/datum/borrow/broker in borrow_brokers)
		broker.share_amount = round(broker.share_amount / 2)
		broker.share_debt = round(broker.share_debt / 2)
	for (var/datum/borrow/borrower in borrows)
		borrower.share_amount = round(borrower.share_amount / 2)
		borrower.share_debt = round(borrower.share_debt / 2)
	average_shares /= 2
	available_shares /= 2
	current_value *= 2
	last_unification = world.time

/datum/stock/process()
	for (var/borrower in borrows)
		var/datum/borrow/borrow = borrower
		if (world.time > borrow.grace_expires)
			modifyAccount(borrow.borrower, -max(current_value * borrow.share_debt, 0), 1)
			borrows -= borrow
			if (borrow.borrower in GLOB.FrozenAccounts)
				GLOB.FrozenAccounts[borrow.borrower] -= borrow
				if (length(GLOB.FrozenAccounts[borrow.borrower]) == 0)
					GLOB.FrozenAccounts -= borrow.borrower
			qdel(borrow)
		else if (world.time > borrow.lease_expires)
			if (borrow.borrower in shareholders)
				var/amt = shareholders[borrow.borrower]
				if (amt > borrow.share_debt)
					shareholders[borrow.borrower] -= borrow.share_debt
					borrows -= borrow
					if (borrow.borrower in GLOB.FrozenAccounts)
						GLOB.FrozenAccounts[borrow.borrower] -= borrow
					if (length(GLOB.FrozenAccounts[borrow.borrower]) == 0)
						GLOB.FrozenAccounts -= borrow.borrower
					qdel(borrow)
				else
					shareholders -= borrow.borrower
					borrow.share_debt -= amt
	if (bankrupt)
		return
	for (var/broker in borrow_brokers)
		var/datum/borrow/borrow = broker
		if (borrow.offer_expires < world.time)
			borrow_brokers -= borrow
			qdel(borrow)
	if (prob(5))
		generateBrokers()
	fluctuation_counter++
	if (fluctuation_counter >= fluctuation_rate)
		for (var/stock_event in events)
			var/datum/stockEvent/current_stock_event = stock_event
			current_stock_event.process()
		fluctuation_counter = 0
		fluctuate()

/datum/stock/proc/generateBrokers()
	if (borrow_brokers.len > 2)
		return
	if (!GLOB.stockExchange.stockBrokers.len)
		GLOB.stockExchange.generateBrokers()
	var/broker = pick(GLOB.stockExchange.stockBrokers)
	var/datum/borrow/new_borrow = new
	new_borrow.broker = broker
	new_borrow.stock = src
	new_borrow.lease_time = rand(4, 7) * 600
	new_borrow.grace_time = rand(1, 3) * 600
	new_borrow.share_amount = rand(1, 10) * 100
	new_borrow.deposit = rand(20, 70) / 100
	new_borrow.share_debt = new_borrow.share_amount
	new_borrow.offer_expires = rand(5, 10) * 600 + world.time
	borrow_brokers += new_borrow

/datum/stock/proc/modifyAccount(whose, by, force=0)
	var/datum/bank_account/dept_account = SSeconomy.get_dep_account(ACCOUNT_CAR)
	if (dept_account.account_balance)
		if (by < 0 && dept_account.account_balance + by < 0 && !force)
			return 0
		dept_account.account_balance += by
		GLOB.stockExchange.balanceLog(whose, by)
		return 1
	return 0

/datum/stock/proc/borrow(var/datum/borrow/borrow_event, var/who)
	if (borrow_event.lease_expires)
		return 0
	borrow_event.lease_expires = world.time + borrow_event.lease_time
	var/old_d = borrow_event.deposit
	var/d_amt = borrow_event.deposit * current_value * borrow_event.share_amount
	if (!modifyAccount(who, -d_amt))
		borrow_event.lease_expires = 0
		borrow_event.deposit = old_d
		return 0
	borrow_event.deposit = d_amt
	if (!(who in shareholders))
		shareholders[who] = borrow_event.share_amount
	else
		shareholders[who] += borrow_event.share_amount
	borrow_brokers -= borrow_event
	borrows += borrow_event
	borrow_event.borrower = who
	borrow_event.grace_expires = borrow_event.lease_expires + borrow_event.grace_time
	if (!(who in GLOB.FrozenAccounts))
		GLOB.FrozenAccounts[who] = list(borrow_event)
	else
		GLOB.FrozenAccounts[who] += borrow_event
	return 1

/datum/stock/proc/buyShares(var/who, var/howmany)
	if (howmany <= 0)
		return
	howmany = round(howmany)
	var/loss = howmany * current_value
	if (available_shares < howmany)
		return 0
	if (modifyAccount(who, -loss))
		supplyDrop(howmany)
		if (!(who in shareholders))
			shareholders[who] = howmany
		else
			shareholders[who] += howmany
		return 1
	return 0

/datum/stock/proc/sellShares(var/whose, var/howmany)
	if (howmany < 0)
		return
	howmany = round(howmany)
	var/gain = howmany * current_value
	if (shareholders[whose] < howmany)
		return 0
	if (modifyAccount(whose, gain))
		supplyGrowth(howmany)
		shareholders[whose] -= howmany
		if (shareholders[whose] <= 0)
			shareholders -= whose
		return 1
	return 0

/datum/stock/proc/displayValues(var/mob/user)
	user << browse(plotBarGraph(values, "[name] share value per share"), "window=stock_[name];size=450x450")
