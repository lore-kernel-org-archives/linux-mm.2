Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E819C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207DA6B0088; Mon, 20 Jul 2026 13:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7EE6B0095; Mon, 20 Jul 2026 13:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081B16B0098; Mon, 20 Jul 2026 13:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF7986B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:03:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3716E1C0218
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:03:04 +0000 (UTC)
X-FDA: 85009775088.25.44D203D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF512100006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:03:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vtHxYiUZ;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMuWMKqgnkPBUwOMQjhA6e2FQmdsWS/MkwAM17YGiE0=;
	b=1mrshxkFunqHgCLvPBDlg0Pop3DDWKk6MWYIZKoqepjRW6Fvzmxwkva0uvsl82/CBrSQ+p
	QYcDrd1Dgp+1vY0x301y8RCuX+g+G2alp86YW4vBNTtKcF7Sobg+I6X1ALxxMLa3d+2jbh
	uTNjqDHiVvPukQTvjSg95qGi+tlIbp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566981;
	b=6Q7+Tguu6h8IxWqilWj3IW/XDMIUJtDdbbM2q3gjbHV7aB8EMSYKcnjnIah3aPsICrWykg
	aqilbqye7aZmW9pYV5wHdDGqsdNJFleUUHMm4S127ZR2RZdLoL0Ntg3A7d7yVQPdohA4QB
	hW12QicMnQK+Sk6LtKB6Hl8gvvz3Iy4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vtHxYiUZ;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784566975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMuWMKqgnkPBUwOMQjhA6e2FQmdsWS/MkwAM17YGiE0=;
	b=vtHxYiUZTWBe/9tm3d3ozCfohoThor8P2b7AXRdvys5Cl6mM82JMRs56s9DMK0zdf2hsgs
	1c67AiCnb+3NQHpKBoWrNnq6WZ/99VwJopyLHTT30dCg6BRPsJfxfsLzxdQ1IaBmrgDUMn
	Ps/OUQTliWIsniL5NvYd80VXd/H8fvw=
From: Usama Arif <usama.arif@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon, 20 Jul 2026 10:02:44 -0700
Message-ID: <20260720170245.939058-1-usama.arif@linux.dev>
In-Reply-To: <20260717210808.GI6843@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF512100006
X-Stat-Signature: rhri57uywu9qeh56xnp1gwye8i31z7q1
X-Rspam-User: 
X-HE-Tag: 1784566980-296413
X-HE-Meta: U2FsdGVkX18d/e2kca5m8kdxrDlR3C6JE7dqJpymPSahgK52fyk3XsNxQ+/KAfklvS1rHWJn/bpC+0WCe6AfsayVMhXndoweSEws9qu/YGmcfBn5Z5lTKTtmJC86+ZZlD+qH9Nb0S9xIbSKxOWPfNfFjwqFmuDWFDb7mQMekRbr/tzVAeOiAOOSXIL4tvLQHjzpY0jjQ6zeVzERpYyCQ8NCWpBR+jAPx1h8kis7g0JYhLDn1bUzz4xYvOPFnNNrfumfoKsiRO4EM29YoSH1q+WWFAihPAtrdogrdQlYmr6FuFlmVTryXSgzXRjzxdthcJ0rCOX29Xj9BV5Itn0IceN/HpnXcOvlGMX4a4/ySyfIi0MfxUB29JdVmI0PE32KyYfOLsV0rOGcfCEpU75kfvPbzGOZr8CtwgdJhcy53zfRmW7MZZwofZmOEogPXFhbG8SL29+mpFlh/O9FWW3j4s8dLcK7fx7UonzbtClcdEI9YMoVIcw9AH2gYnerlk7oEmb8rhvPeP3Wll6mxqVRqwDm9XuMujN5x2D3zP5ZRltOLWTvL/O0s1/7szQn1VRPRYIW9xyGG6oSsbf+gUWNF79c8Z/esL+uD3QCEeQ8mZ2SrkPbowm14vFE2mQPlXtG/i0rN324vimoOygUc3JbpJIu6dw2o3iCQJb7uW7haYyve0hcSI10zExyOK51kRprW30iLl3Zd620ESiMNZbYQGWc3R1+8ZSVGZ+/AWnWPwthQotUuOu7FBo1NaeDBSCLfN5MAphmqBnKPK86oxjJNttxC+uzN2OMxdtfYBYDmHqKU+6kTMizEHnKXLt2sHq1zUKjeJ6XX0cjUx8Oh2hUFuhyc7g7+ypiZGsSzHgAl8LJkaqvmWLxzZYbDBMga2E3Bs5csA4pCQn52HCImcQaxp8wC3OB49KcY+5V2tdb7mUk27eroFKRPNmhZoVCaFYrHKrL4X5ZSGTFq4KkAGtQ
 HfHapaRZ
 aDYvtgEIEZH5qH107dwTnDg4FBWh4i8n+Xt42eQZZT2tuHMPrEu/PZJsG8f2wZtf56SDszvJgJitXESgNH/C+3fOz1J0djD/v7xspI8WlzxAkccIYD7BtZSlxjYwdCFdwpvr+zAPXqHvl+YbBXSRzoy0/4rC6+P9STzbbSyO2gDWM4h0PA33BcWtqoTiHtIHS6qmL/+7UuhwB4LDUYYnbS0n0yof//ehPocXI5uC9TjFGpf0dqfl/3UWmx7h1PWyhJaBNtqNkj0dHxnpEeiEh8je3olo/8TTdwizfhAYLuFhGfkzNeaQd2nq2+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 23:08:08 +0200 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jul 17, 2026 at 06:57:32AM -0700, Usama Arif wrote:
> > @@ -2303,12 +2301,63 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
> >  	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
> >  
> >  	/*
> > -	 * Determine the scan balance between anon and file LRUs.
> > +	 * Determine the scan balance between anon and file LRUs from per-LRU
> > +	 * vmstat counters. The raw cost per side is:
> > +	 *
> > +	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
> > +	 *			     shrink_inactive_list and shrink_active_list
> > +	 *			     (CPU work).
> > +	 *	NR_VMSCAN_WRITE    - reclaim-driven anon pageout IO.
> > +	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
> > +	 *
> > +	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
> > +	 * higher cost of an IO over a rotation.
> > +	 *
> > +	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
> > +	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
> > +	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
> > +	 * `now - prev_cost[f]` yields the correct delta across a signed-long
> > +	 * wraparound of the underlying counter (a real hazard on 32-bit that
> > +	 * the clamp in lruvec_page_state() would otherwise turn into a huge
> > +	 * spurious delta).
> > +	 *
> > +	 * The delta against prev_cost is folded into cost_accum, which is
> > +	 * halved on both sides until their sum is within lrusize/4.
> > +	 * cost_lock serialises concurrent reclaimers in the same memcg+node.
> 
> IMO that's a lot of describing what the code does. Why not stick
> closer to the original comments?
> 
> >  	 */
> > -	spin_lock_irq(&target_lruvec->lru_lock);
> > -	sc->anon_cost = target_lruvec->anon_cost;
> > -	sc->file_cost = target_lruvec->file_cost;
> > -	spin_unlock_irq(&target_lruvec->lru_lock);
> > +	spin_lock(&target_lruvec->cost_lock);
> > +	for (int f = 0; f <= 1; f++) {
> > +		unsigned long now, delta;
> > +
> > +		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
> > +		      lruvec_page_state_monotonic(target_lruvec,
> > +						  WORKINGSET_RESTORE_BASE + f) *
> > +				SWAP_CLUSTER_MAX;
> > +		if (f == WORKINGSET_ANON)
> > +			now += lruvec_page_state_monotonic(target_lruvec,
> > +							   NR_VMSCAN_WRITE) *
> > +				SWAP_CLUSTER_MAX;
> 
> It's hard to prove overflow behavior is correct. I would keep the
> delta extraction dead simple, then do the weight math on the delta.
> 
> > +		delta = now - target_lruvec->prev_cost[f];
> > +		target_lruvec->prev_cost[f] = now;
> > +		target_lruvec->cost_accum[f] += delta;
> > +	}
> > +	unsigned long lrusize =
> > +		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
> > +		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
> > +		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
> > +		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
> > +	unsigned long cost_limit = lrusize / 4;
> > +
> > +	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
> > +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
> > +	       target_lruvec->cost_accum[WORKINGSET_ANON] +
> > +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
> > +		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
> > +		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;
> 
> Why do you need to check them individually? Between reclaim cycles,
> there are no scans->rotations. And I don't see how you could get
> refault events several times the size of the LRU, let alone in excess
> of ULONG_MAX.
> 
> > +	}
> > +	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
> > +	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
> > +	spin_unlock(&target_lruvec->cost_lock);
> 
> I realize these long descriptor names make it hard, but I think this
> can be cleaned up a bit and written in a more idiomatic way.
> 

Thanks for the prototype and the above reivew comments!

I integrated all of them and sent them as v4.

And best part of it is, sashiko is happy as well now with v4 lol

