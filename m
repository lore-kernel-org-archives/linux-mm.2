Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE79C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 21:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F256B00C3; Fri, 17 Jul 2026 17:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8ED6B00C4; Fri, 17 Jul 2026 17:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1066B00C6; Fri, 17 Jul 2026 17:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1AF6B00C3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:08:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9F18C0266
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:08:17 +0000 (UTC)
X-FDA: 84999506634.26.7ACB47B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A0B8180007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:08:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q+IuVgME;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784322495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjYCCbO3PLXnys6k424gkT2HzpdBexgKHv5hZJae8ug=;
	b=GM8DuXGf0JaT6of7vYVd00lDrdDn1ecWraGapejZwMSE+fUYexpzwEjIjzI4xCS63Zl4Oh
	23atiTNe63jkrUtvSFdWhgTQIkdTClN+vX+WL1eCzYHQFwgnYeBec3OwffIf+goKZEpOXW
	AiUI6gRVnm/JtAbfiDem+Tdp1aDMVcM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q+IuVgME;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784322495;
	b=vjYi+ImM2Na7rAzKQbKTPvlJ/gy7LmoiA8zr+9skSL417iDueeRxYu2D46k4/qtmbx+Ex+
	tLidBdORYkeU9RSanyvVPCn2VGyT9goL7+HvuJMZ6IvM7yqMUNW/1eymF1jkttGf7bxTyq
	TcOWA5FKVlZgKK8iTw3E8xNSxa6enhI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49546c690ffso12627635e9.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784322494; x=1784927294; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AjYCCbO3PLXnys6k424gkT2HzpdBexgKHv5hZJae8ug=;
        b=q+IuVgMEXzxW1tw776h952o4r1qDsBGy9pEam6GuWVJtipjbrIcFUhcfT8AmXypU1I
         n1OmsUP14f1hh4KP+VfmN2VRm8MA8LD6mQLYDvYD9Tg8cG8QdLiocPAJXBuGpfMMCTrp
         So6Pxg5boQBM5PZuOIj6jaW69L/PAhJGa/1i3FEmu//2dcEZ5EwvKqNkmhzyX9nuy2Hy
         wSAwSxkQ0spZpETzV6FhfRccsLAhFOKnYjqMUAaslvQ3IcK8TZJmUvvcWHiCXZ1ds6I7
         M1R2rloy4MZbkDYG+lGWHjIMqCD/UDY982f++bk8WHgnz4WlKovFXrFzc5VSZLlF94mK
         OAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784322494; x=1784927294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AjYCCbO3PLXnys6k424gkT2HzpdBexgKHv5hZJae8ug=;
        b=pOFYrNgWjLGvq7llZG74BhTLrxPYxtbGeloBWXTDLQDtOh/YTyBuUD0gprV8Pp+fMz
         8fJXOwMEXHOCv29KC05UqxdcQLZ7EU94fUCQGIttSlczsK1OBi2di9Mp1yIBFH6+moH/
         vmxDDMZY89xV9byVKcSrilbZ/IM7rjPEwe5jNh5XQbAvlrG3Q2m8aSWgWJz0izA4F9ps
         JAu9rDMNlXbUOj1sxF5u0GmmQSEaZVe+nZBkTHj8H13a/afkP2+V8toO1T8kkrjBt6ge
         G5R0bIF/PrK9AbUcD6ErbCjSAZbqTuS1wORVlxKDeAu/TBGFzx7BRQ4VnOWFyRQ9UNmt
         HZZw==
X-Forwarded-Encrypted: i=1; AHgh+Rr1TxJemHl4lz6ebN+XC7kuODejzzbCSttKjFfPwLqyd0PWz7MXGpa7/xTay7IeTJsUXleQY9QuAg==@kvack.org
X-Gm-Message-State: AOJu0YysAcANgYCDDH1KxzlljDIAOtwAhOBrkyJYSGi1NX9613S4bvpO
	xojxWj0nuzXS/lDkKW3Y/7XGpW9jPCv4JOgA2RZWTcxdx4BJMEFEkhhfTr+uAztl5eY=
X-Gm-Gg: AfdE7cl1mil+mU+yGc0XhKaB0JVFN7cUS0xMt7Mj2ETZ1Ln3mOc8QOvLRHE9WpZkhbY
	m7fKzkxe8Yf3liqTlV8xtpI2vKD6bY7RmKB7VUuIHr9dFDJoi5fCIB5CjYB5PCbhnwacKf1sbwK
	8m9neBkfOkZFp5FISHY9DrDf0Li5G+TpmxkBN9EUkbB1SRBRMq6iWXFlK+k/O/oLeGmQDZ0LMNO
	6CpgnHf37FLcvibgX86jyNtetIfd0+ywLg5s9wH+91WkPtofkz1LwGMWxDuoowvX8wkUml3mV9l
	zZto8U/+DlYxTI0Ft36f1jbeSv6iM5+LgxxfrySpdJKoolU1o6JY7gY5TMAPymo5SJaBocnOLSy
	gCQZ/U3XTnc5V8rm5v/DIluEtjQ0ep4yd00GRO8Q345bFxtmiJHjfo55YsxGVAv+jkyC4esLlM4
	4=
X-Received: by 2002:a05:600c:4515:b0:495:3af9:4cfe with SMTP id 5b1f17b1804b1-4954a40e322mr48126015e9.20.1784322493273;
        Fri, 17 Jul 2026 14:08:13 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2aa698sm68755195e9.4.2026.07.17.14.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 14:08:12 -0700 (PDT)
Date: Fri, 17 Jul 2026 23:08:08 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <20260717210808.GI6843@cmpxchg.org>
References: <20260717135807.3476029-1-usama.arif@linux.dev>
 <20260717135807.3476029-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717135807.3476029-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A0B8180007
X-Stat-Signature: 1erku53wftgw4kxrbec7u85tgwghjrhm
X-HE-Tag: 1784322495-669644
X-HE-Meta: U2FsdGVkX1/4hCwa7yE7K54RIJmngfEq5j4WI3Eb9YVvJLQDakvhrKOh0VyfARbX6CIMTIa7wZVqsEzqJ+DkqWbQddDDy1AyPPvf3zWhRGyRrqeWK+kVxt8Efqvlo6M7J19FoH7ZUFe+wh6L/NmtjUhkYuclsnIbiqsNJJshECbx/9IE220KFNhpPIaimNT16LqIIkP5TQgFow5trJUZXywRauEd+YR7w4s3X+yFGYuHf2HfXufuns+zKp4V22BeX9BR5vEXzmXMnWYVCQ/uiwvZT9tX6PsJN4ZOQMqNG55MTD7Bq4LWNb6pOwChHeZmgpSk6BuC/i6m8qiPyxU6kdSy90cdbmWMu9enRcxhnV9Ra1+o5S5nbsqK6epXw80LyyssJRk8qHdTtVAOOm1lM2gdhIhgTEyi96smUm/Fwg/SpWrx67ej2NDDB5bKoCGvftbvcwqyYp9RxFsCL4euUyUeN98d1J7HLq8frx/nv57bbQaio8Ikcy+eJu7i9J3cnQXhFEfwIy5xZUgXvtFadL0K10IogCiYhSGT0+9q/Tbir9Sb9h+PxiR36l+4iKUmQFrnYtUm7ULpyBJrigJ+ZfKpGY9u/KoDOS/s17ITdgz72fq+r/W1rx7E+qFMTfX7KP+2ETJVvJpVmd+JCK4gRzeNZOzu0fQWl7U+1nyypAzqJpNwBb/Jn59VCYzbXxyZzwCGr0dVGEnA0qPIboOJje6IxCUpNcj5xRRLV1ab+cWT/CP5W8v28CClmO5LhY2eJU3Imy1qMVBC5fSWSis4JymXR4WkKDnZ4w1WCRLFWaS6QqXo6D5xpgQDZ0pLjrXTvp7vSeFluVisDxtb6TFT5kPyClDXSpz5bzAsDVt8ZVhSsOvaEb1XVb+V6ScI77+T2fELrXuR3O+LiOwnwNZtBzaXx5rZqoLCIicsgMEycEUsHN1jLWfo2jWyhITxwUTzkvTUnxfvyy9agWRzZyz
 d+1iHGlZ
 2HM8SxzgmDml5V1x1Lb0t/SL0xobKgV2AIN8yih37jfoaKSoEdg2oofDVJc7FVkLG8LYpYG+MzUy31zHNLlf/Sio+Q0D4rnAx82wdBqoCzX6QLzDV2J8erfYowTAIZ/GxU7Xw4SK8K0NI75aGHVD2Jf5e/qYOH6vU5gp351ndxD8iHReNh40J/hWJKjz+ytsK9jlbGQgalrvJA/r1XJcRKEDz+TbxGUw+ICGXcRvZ2Yydx1HWVC+Dc4RXl7EEt9fNkgT4XpeaqX9E2ro2rU1f6p4UiQUSbR5olS9QflfikiZEdD3vGQbQ9vdcx5OpO8zVGmXxPiSKVlaoMUsiJ5Y7KA5zMSzTdidRMok66oAv59LVUq8YpcueC3mz2ykzp75+IZc2D8IB/ETMXjaONY6Cic0Jpq8V8xiZxT3Fr6b7WHzg+b6dra85xjm9QiNAB2QXBfOiVRTGDudZ/j4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 06:57:32AM -0700, Usama Arif wrote:
> @@ -2303,12 +2301,63 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
>  	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
>  
>  	/*
> -	 * Determine the scan balance between anon and file LRUs.
> +	 * Determine the scan balance between anon and file LRUs from per-LRU
> +	 * vmstat counters. The raw cost per side is:
> +	 *
> +	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
> +	 *			     shrink_inactive_list and shrink_active_list
> +	 *			     (CPU work).
> +	 *	NR_VMSCAN_WRITE    - reclaim-driven anon pageout IO.
> +	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
> +	 *
> +	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
> +	 * higher cost of an IO over a rotation.
> +	 *
> +	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
> +	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
> +	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
> +	 * `now - prev_cost[f]` yields the correct delta across a signed-long
> +	 * wraparound of the underlying counter (a real hazard on 32-bit that
> +	 * the clamp in lruvec_page_state() would otherwise turn into a huge
> +	 * spurious delta).
> +	 *
> +	 * The delta against prev_cost is folded into cost_accum, which is
> +	 * halved on both sides until their sum is within lrusize/4.
> +	 * cost_lock serialises concurrent reclaimers in the same memcg+node.

IMO that's a lot of describing what the code does. Why not stick
closer to the original comments?

>  	 */
> -	spin_lock_irq(&target_lruvec->lru_lock);
> -	sc->anon_cost = target_lruvec->anon_cost;
> -	sc->file_cost = target_lruvec->file_cost;
> -	spin_unlock_irq(&target_lruvec->lru_lock);
> +	spin_lock(&target_lruvec->cost_lock);
> +	for (int f = 0; f <= 1; f++) {
> +		unsigned long now, delta;
> +
> +		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
> +		      lruvec_page_state_monotonic(target_lruvec,
> +						  WORKINGSET_RESTORE_BASE + f) *
> +				SWAP_CLUSTER_MAX;
> +		if (f == WORKINGSET_ANON)
> +			now += lruvec_page_state_monotonic(target_lruvec,
> +							   NR_VMSCAN_WRITE) *
> +				SWAP_CLUSTER_MAX;

It's hard to prove overflow behavior is correct. I would keep the
delta extraction dead simple, then do the weight math on the delta.

> +		delta = now - target_lruvec->prev_cost[f];
> +		target_lruvec->prev_cost[f] = now;
> +		target_lruvec->cost_accum[f] += delta;
> +	}
> +	unsigned long lrusize =
> +		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
> +		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
> +		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
> +		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
> +	unsigned long cost_limit = lrusize / 4;
> +
> +	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
> +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
> +	       target_lruvec->cost_accum[WORKINGSET_ANON] +
> +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
> +		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
> +		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;

Why do you need to check them individually? Between reclaim cycles,
there are no scans->rotations. And I don't see how you could get
refault events several times the size of the LRU, let alone in excess
of ULONG_MAX.

> +	}
> +	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
> +	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
> +	spin_unlock(&target_lruvec->cost_lock);

I realize these long descriptor names make it hard, but I think this
can be cleaned up a bit and written in a more idiomatic way.

How about this (totally untested):

struct lru_cost {
	unsigned long count;
	unsigned long last_rotated;
	unsigned long last_io;
};

struct lruvec {
	struct lru_cost cost[2];
};

	struct lru_cost *anon_cost, *file_cost;
	unsigned long lrusize;
	
	/*
	 * Determine the scan balance between anon and file LRUs.
	 *
	 * The cost model is based on rotations, refaults and
	 * reclaim-driven writes (anon only) on each side.
	 *
	 * These event counters are monotonic, so each reclaim cycle
	 * the delta since the last scan is extracted and incorporated
	 * into a decaying average. This ensures currency, as workloads
	 * change over time, and avoids overflow in the calculations.
	 */
	spin_lock_irq(&target_lruvec->cost_lock);

	for (file = 0; file <= 1; file++) {
		struct lru_cost *cost = &target_lruvec->cost[file];
		unsigned long rotated, io, nr_rotated, nr_io;

		rotated = lruvec_page_state_monotonic(target_lruvec,
						PGROTATE_ANON + file);
		io = lruvec_page_state_monotonic(target_lruvec,
						WORKINGSET_RESTORE_BASE + file);
		if (!file)
			io += lruvec_page_state_monotonic(target_lruvec,
						NR_VMSCAN_WRITE);

		nr_rotated = rotated - cost->last_rotated;
		nr_io = io - cost->last_io;

		/*
		 * Reflect the relative cost of incurring IO and spending CPU
		 * time on rotations. This doesn't attempt to make a precise
		 * comparison, it just says: if reloads are about comparable
		 * between the LRU lists, or rotations are overwhelmingly
		 * different between them, adjust scan balance for CPU work.
		 */
		cost->count += nr_io * SWAP_CLUSTER_MAX + nr_rotated;

		cost->last_rotated = rotated;
		cost->last_io = io;
	}

	anon_cost = &target_lruvec->cost[WORKINGSET_ANON];
	file_cost = &target_lruvec->cost[WORKINGSET_FILE];

	lrusize = lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
		  lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
		  lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
		  lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);

	while (anon_cost->count + file_cost->count > lrusize / 4) {
		anon_cost->count /= 2;
		file_cost->count /= 2;
	}

	sc->anon_cost = anon_cost->count;
	sc->file_cost = file_cost->count;

	spin_unlock(&target_lruvec->cost_lock);

