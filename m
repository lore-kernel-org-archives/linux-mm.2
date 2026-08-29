Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B63C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4886B008C; Fri, 28 Aug 2026 21:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C136B0092; Fri, 28 Aug 2026 21:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9286B0095; Fri, 28 Aug 2026 21:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5586B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:04:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB2DE140574
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:04:42 +0000 (UTC)
X-FDA: 85152512004.05.8E2BFF1
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F0EB18000D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:04:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTcxGMFW;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787965481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujQsZj3ZcfVTm5paqkOFzeFRu6z6q0TzQhnrTrxNXXQ=;
	b=y1Ct3ksAJ1dGyB76gB+qFk61PeVdVOfImpJds6xfAQ395uX3aGmVqEnCT3jl1NsX+65Nan
	3CEnoWjCN4jZNnxfy9UNBIkEj+5UVZwYb2SBURAtMHFtCkiCyg67vbfBsyJcy6U6wFs1OY
	lyng23Bz4wXuvjJU7QBX7B4ZZ2OZFCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787965481;
	b=qDWe5RmoUnbXhTqV9+u2+EJ5F5nZZxTqIY6/1203WbbOwGkoLm5/ymoAHm49IiNmY+Qg4q
	AjPk0azZPohFVgSEYHjfqALwHZetzIp7SPiVt7Nus6oyAeM0G8cN/UqJwnW510Pt8nkKjz
	kbiyWVQWcGIghfqbZbJfO95lvuMUvpY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTcxGMFW;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kFVnj/RCyVGdhv/GrLJjxqmvHwAXJnYM9xkltOMPrqc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787965478; v=1; x=1788570278;
 b=TTcxGMFWoEsBiY1ov6+AULkzfP5/X/1wHWOBMu8dlEFvJ5REThzhY3wALQRrUmkBF1BaAZeH
 4cFaHcLmcV5NtG6hOqpxz4Om++qEdMBzHwwhtSvu/uCiFDCT6m5IDy5YqTU17QlK/H1rxYWSSyC
 1MCLwCoqV6lrgKNGEbY62zvs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 171c61ff73f22124;
	Sat, 29 Aug 2026 01:04:38 +0000
X-Mizu-Trace-ID: 171c61ff73f22124
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 18:04:37 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joe Damato <joe@dama.to>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: raise MEMCG_MAX for charges that fail
 without reclaiming
Message-ID: <apIvUej_7wvcDUjg@linux.dev>
References: <20260827233119.411152-1-joe@dama.to>
 <apDPJzlJ4gS9YUDX@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apDPJzlJ4gS9YUDX@linux.dev>
X-Stat-Signature: ntdqukq8o4h5ogbh57nczspn8oeer4ji
X-Rspamd-Queue-Id: 9F0EB18000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787965480-999339
X-HE-Meta: U2FsdGVkX1/E20Y3KKWuVWWOmNsjTmGvr6Sau1XY6KAtMXWF8t9YXa1R3uBzhdebg65eBXjvThVaDmsxHLaMxW6k4CjYYAIiy4/Z3+FwLu97GRNcHJfODf01fnrKAkc3lLVCqbEnXQuOTSiKclrn09m/VyKaa2yoS3t49rnLuQYkc9O9gNE6gLu5629yUVqzRkWKoMZJrnfn8dLwMtLlhI6QLtLgwAZSOBIkcoJf2P8oNl38ptXM//wMsOBAoli1mQQyQG2NgmWs+XZzwEKoIX0+U9JeyxKccY4VEAbTQPhdJhAilgUTzkTRA3evZRxTEGHuBR9JTEpHSvHuzT2CY4kabs+ch7R9JnybW37CElQNMWYumhLYG/v9PDIERI3DlXIaLqyBiNlCSyr99e1pS/x2NZ+fEFbAEG8/zSRcRUe7B6Sls5u+ov51RvzakUleZpHUT/nY0qF+JbKVkrrLiE9R1d+wmesCsFGcyTgJO8RJCXn8b0ZHMKjKH8GQkksifhWE845Xv9gDSpX1rfJF2hxA8UYvEtqmi45NGwaNcHLSizQV+XO+ghuZ3V08/8eCpfFmeMk65d2Y1PB1L+SbDwpPsK2OwXUPhUS5clNV7XE1fluJxloIOhq9Pozfz6gjMFx1nrQZzx5HryuQkNXyk7e9uBKl0ZSiWwqAYfy/VDio42G88JYLPPXPhxA4oGFH3bazSBbfLZZOeglXeF3LRHBCj+OEq97WSXHlUcaiKfaFb2z+UfMUg8uIamcih4aCxzmnLtp9qy03T93d39zWJt9B6uRHjSWHRt0HNniWiiNnH4ZolWOIBnDxtMgESdVv3r4rXEt4dr8rchLMNp/2JnWhc/LdxIQ1/PEof8y1YqW5gF8B3nDhk/A4YmP0+uqVW/YsoEC7ZFlC9XRO9EGHF4EMgtpZ5S4qJ4g29igY2Ht2CwDLP8NRWLwRzjj8tP7AhHXg2pe+qvXd6X+vZLU
 FcxBs8fL
 Dm+myzIKpcQvjDWEYoCNdH6jMKjQ0KQ0tXAJXCC3knO+71gSbWqyXrDTP5LDsq24XOmInIrSdq2Ff3eOSB+hEuAD8Z6Xj0jtO+Z949dHQGpgPN7b4/YHMBZGWqKosKJRyEgJRP4LZX+neWuaz/R3V8j9uc9YlFmSHAO4CQ8CG16+jbWYu1r/SiEPSCrtSYPfDpVFq5/YCmAG3Z5cvSJ97cuildwYkAfvQ5GoaJ9jnDyIeMKJwA19smN4dKrZ1OmMMe9l5ZK2tF89AyakzHiZdxjW0N5oojhePAR+crZprUcNjKhv86Jgg887JBHvRWYhKqVd7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:13:44PM -0700, Shakeel Butt wrote:
> On Thu, Aug 27, 2026 at 04:31:18PM -0700, Joe Damato wrote:
> > Charges that exceed memory.max and return through the nomem label can
> > raise no event and simply return -ENOMEM.
> > 
> > A non-blocking charge can hit the limit, get rejected, but is not
> > visible in memory.events.
> > 
> > This was noticed in a production setting where bpf_mem_alloc() attempted
> > to refill its per-cpu freelists, which triggered a non-blocking charge
> > while at the limit.
> > 
> > Move the event so that it is raised as soon as the charge is known not
> > to fit.
> > 
> > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Joe Damato <joe@dama.to>
> > ---
> >  mm/memcontrol.c | 15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1271d390b617..3904fe9a7b2e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2683,6 +2683,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  		goto retry;
> >  	}
> >  
> > +	if (!raised_max_event) {
> > +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> > +		raised_max_event = true;
> > +	}
> > +
> >  	/*
> >  	 * Prevent unbounded recursion when reclaim operations need to
> >  	 * allocate memory. This might exceed the limits temporarily,
> > @@ -2711,9 +2716,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> >  		goto nomem;
> >  
> > -	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> > -	raised_max_event = true;
> 
> I just noticed that this will change the current behavior where we keep
> increasing MAX counter while charge request loops through reclaim and retry.
> Though we have not documented that behavior, so not sure if it is worth
> preserving. It does help identify cases where a request keep looping in the
> charge/reclaim/retry path.
> 
> Let's see what others say. Keeping the behavior should not be that hard if we
> decide to keep it. Something like below (untested):
> 

Hi Joe, let's go with the following patch. No need to change the semantics. Also
I think we should Cc stable as getting ENOMEM/allocation-failures without the
corresponding counter i.e. MAX getting increased is clearly a bug and unexpected
to the users and will make debugging/monitoring harder.

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..6bfa4ad30b24 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2656,10 +2656,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool raised_max_event = false;
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +	int ret = 0;
>  
>  retry:
>  	if (consume_stock(memcg, nr_pages))
> -		return 0;
> +		return ret;
>  
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
> @@ -2770,16 +2771,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * put the burden of reclaim on regular allocation requests
>  	 * and let these go through as privileged allocations.
>  	 */
> -	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
> -		return -ENOMEM;
> +	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
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
> @@ -2789,7 +2785,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> -	return 0;
> +out:
> +	/*
> +	 * Don't forget to raise a MEMCG_MAX event for forced or rejected requests.
> +	 */
> +	if (!raised_max_event)
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> +
> +	return ret;
>  
>  done_restock:
>  	if (batch > nr_pages)
> @@ -2848,7 +2852,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	    !(current->flags & PF_MEMALLOC) &&
>  	    gfpflags_allow_blocking(gfp_mask))
>  		__mem_cgroup_handle_over_high(gfp_mask);
> -	return 0;
> +	return ret;
>  }
>  
>  static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
> 

