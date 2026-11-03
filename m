Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B75606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 04:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KHDkkMsv
Received: by kanga.kvack.org (Postfix)
	id E436E6B05B1; Mon,  2 Nov 2026 23:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCEF6B05B3; Mon,  2 Nov 2026 23:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AD96B05B4; Mon,  2 Nov 2026 23:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969166B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:34:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1882C1402CD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:34:47 +0000 (UTC)
X-FDA: 85392542214.11.EDA74C6
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	by imf26.hostedemail.com (Postfix) with ESMTP id E65CB140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KHDkkMsv;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793680485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9Njty/s8OSTY2jW7LGO6SCpfmnpl1SS5BBMpxrgIQM=;
	b=dfot5q5g+MOFoELcfMWctBXTt58pEHjHb01yKbq9OzA4iHp9Y2RnXpM+lJKekKjoM+Doax
	cR1Oc4TFqce0rlQlMoxBvEkC5OeFb3nrIKQMS7OBdFwyr3h16TUcPIl5CBX/sr3QASs5Le
	sjj0Gp8U5+vnS3zyHtqN+mvmlKaPglA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793680485;
	b=zbs1Nts+j6bVp1xIVWP6pTnKgvpi709GewsQY4OX6XqrFlpp4DmVZ/G8Zd55HKqylwkMFI
	C8bSXrshFIrbi/Cw6kJZ7dHULb2gCPnyreDXQyUjbrq1x9u25xlTObaXi0N8DLr4lIdZZX
	qGjWIPovYXL2kZA7OWP0wsnLPznbv1E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KHDkkMsv;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Tkk/8VKuhrIf4fgRDjiA2Ro1wKiXOIisjNU8KXqStt4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793680482; v=1; x=1794285282;
 b=KHDkkMsvPiy7YmZ1IhyOB0Yed0gk+ac9uCTMIQA+xCfR/YBe14wxj/lhmy+VD41r6zHOc2tl
 rA0T1oKitTyLSkt9MfU+T0t7+b6MZguMyS2AVRW3hL4HNkXpPV5cZqT2MZ+Nn4fjbjNCQODHUvs
 7KXv/3hs1NW2LmEDpLDsmnmw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c175a73cfa824ebc;
	Tue, 03 Nov 2026 04:34:42 +0000
X-Mizu-Trace-ID: c175a73cfa824ebc
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 20:34:40 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <auli2Zlf1F0tyi4X@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
 <auhN7v127jwy-q-W@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auhN7v127jwy-q-W@tiehlicka>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1yn7hk8pu8hzo1jsr4swzyzue491fnoe
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E65CB140006
X-Rspam-User: 
X-HE-Tag: 1793680484-219289
X-HE-Meta: U2FsdGVkX196XlT2o1huazxu5j+RGtcKmt28YJ0ye5O2Lzu13ADlnCQPVEE0IrpNvJSx4WmpX7d4Q3z8SaHhkcNjCqa1GPCCERe4pGS1kYWYk2J2Ar+2hn3ojzR1ddY3p1J+HAlPH2sGBKaQKh272tJy3mCpyWzmSvcqmwZdJ+2TXBvEgZ9MbCykvnpkFE8vUMLiCa+dAo50u59xfa6bOF1UBBvu9+Kr1WkRnzPOxC+i39WtVYXoadKGVepWRFlhuJg5ZV4SHIYtUtus+HsKIVpXqf2o7chjpL2WUR1d07ZNP3nUoY1NmbTrR7TUF/2GY088COsxDoWp6WLZuZxI+whTeXJq1hBdjHMJgx76d1ABPnK0cgo0y3aWXbgWOJIGAekwGuWcwelPYi3uBs+D556P9z0cg2E3M2GhM0UtELwWiN4jE0/2/59i6kr9Ta9C3mQJlhQ1RPXOaobmYy6/x4PrFeMD9bJWjZJAn7cTyfzgEaEP3XLO6Y7vq6yNlXqzCHYSzYp3qB1aEWEvSvc1teR4f76R6W/BCmvtjH7u363CY/FALVvWVwon1kJ36BGrh0vZSyEfTLgL5HPLd5JS7WB2f3OEnTovNDdgfc2o1FXVQH9DOUUOwdbLkFZewvkJwCb9aYtYEYBi/HQVptOGlzuC9246+LiJ7+DlxyosXbOZLCBSMvZCYmsCHhxgqzjj2MD5gB6h1IVpviH6y8UATUlMqZZZkrrDdzmCawlJrl3xkionKHjTYPZToZ7IneeC7JNYQQHgiLmigNYIdJtbrlYQ/qil4dODBGZO4YztotcRSwlO8zR6kkb7aVi9o+YXXTGV5mO2wh04frGgS0Pd+GZJPLkDD9IA3YpSHdJ2l/sAjEVYZfV/0fpCUomBpdyi9chJy7cNY1SaaRjk5equJnX+hbnl1C3Nxe6R17jv/WlbwpJ3sA+YGdNEDnyBGGenjP2k6cuviVs3Ecc4uK7
 8jXz42+B
 BZzzewHCemUHZPLSBLJ30jWsaYHPYrCWSKNtflZEHGJsreGvfK2g5jkSN8k17EGRdVpbo1MmT6UGYUwx2fQ00mmtqn5fa4A43GpoNH6WUfTjGe0qHSJHEAZVuZjXddPTJ99k24DPxmffHalN/43em19lVDG767mvnGqKRYpk18u9zywyeEyt7xXG9exJG5p3EVsizZOdgEpoj266LOFefG7MuQ8lJX2EZ5I1myWXsM2DvQSJ77L2rB9of8Zdhn5y7ucR2fj49Y37esDlkIlixh3ked94zd6m0niDqfLJca2k+fAIA792P4wkB+f7K2986mtKrkgaEFqwhwis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 09:46:38AM +0100, Michal Hocko wrote:
> On Fri 30-10-26 13:54:13, Shakeel Butt wrote:
> > Reclaim can charge memory, for example when zswap stores a page.
> > try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> > they fail at a limit. A charge that fits still has memory.high
> > enforced. That can make a task in direct reclaim do more reclaim and
> > sleep longer later, and kswapd records overage that it never handles.
> > 
> > It is also a problem for the next patches, which make kernel threads
> > queue high_work. The worker charges memory from its own reclaim, so it
> > can queue itself again. With those patches but not this one, the worker
> > queued itself in 118 of 284 runs in a VM test with incompressible zswap
> > data.
> > 
> > Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> > memory.high, as they can already go over memory.max. Drop the
> > PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> > 
> > Other effects:
> > - As before, the check reads current, so it also catches interrupts on
> >   a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
> >   themselves for swap over network, so the check can't be limited to
> >   task context.
> > - These charges no longer charge a batch or refill the per-cpu stock.
> > - MEMCG_MAX still goes to the first cgroup that the charge puts over
> >   its limit. On cgroup v1, memory.failcnt no longer counts them.
> > - high_work can still run again and again when there is nothing left
> >   to reclaim. This only stops reclaim from queuing more reclaim.
> > 
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0e484f7f823a..af95a4574a0f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
> >  	 * when it rechecks the overage and simply bail out.
> >  	 */
> >  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> > -	    !(current->flags & PF_MEMALLOC) &&
> >  	    gfpflags_allow_blocking(gfp_mask))
> >  		__mem_cgroup_handle_over_high(gfp_mask);
> >  }
> > @@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (consume_stock(memcg, nr_pages))
> >  		return ret;
> >  
> > +	/*
> > +	 * Reclaim may need memory to free memory. Let it go over the
> > +	 * limits for a while rather than fail or OOM kill. Doing this
> > +	 * before trying the limits also skips memory.high, so the
> > +	 * high_work worker can't queue itself from its own reclaim.
> > +	 */
> > +	if (unlikely(current->flags & PF_MEMALLOC)) {
> > +		/* Find the cgroup this charge puts over its limit, if any. */
> > +		for (mem_over_limit = memcg; mem_over_limit;
> > +		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> > +			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
> > +				break;
> > +		goto force;
> > +	}
> 
> This is racy. Not a huge deal as we would get a false event in the worst
> case but I think it would make more sense to check the margine after the
> charge is forced. So this would become

I actually tested your version as well i.e. after the charge. It is just
as racy and it has some additional issues which are inlined.

> --- 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..bd202ec05acf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,13 +2653,20 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool passed_oom = false;
>  	unsigned int reclaim_options;
>  	bool drained = false;
> -	bool raised_max_event = false;

First, raised_max_event can't go. Since 374f65b14819 rejected charges use it
too, and without it forced charges that already raised MEMCG_MAX before reclaim
raise it again.

>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
> +	/*
> +	 * Reclaim may need memory to free memory. Let it go over the
> +	 * limits for a while rather than fail or OOM kill. Doing this
> +	 * before trying the limits also skips memory.high, so the
> +	 * high_work worker can't queue itself from its own reclaim.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC))
> +		goto force;
>  
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
> @@ -2683,15 +2690,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> -
>  	if (unlikely(task_in_memcg_oom(current)))
>  		goto nomem;
>  
> @@ -2712,7 +2710,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto nomem;
>  
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2773,13 +2770,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
> -	/*
> -	 * If the allocation has to be enforced, don't forget to raise
> -	 * a MEMCG_MAX event.
> -	 */
> -	if (!raised_max_event)
> -		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> @@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> +	/*
> +	 * If the allocation has to be enforced, don't forget to raise
> +	 * a MEMCG_MAX event.
> +	 */
> +	for (mem_over_limit = memcg; mem_over_limit;
> +	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> +		if (!mem_cgroup_margin(mem_over_limit))

Second, !mem_cgroup_margin() is true at usage == max, so a charge that fits
exactly raises an event (unlike today).

> +			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);

Third, we definitely need a break here otherwise every ancestor at its limit gets
an event which does not happen today.

I want to keep my current version.

