Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1753DF428F5
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 20:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB00F6B0005; Wed, 15 Apr 2026 16:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A046B0089; Wed, 15 Apr 2026 16:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A017E6B008A; Wed, 15 Apr 2026 16:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864D66B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:56:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCD70160605
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:55:59 +0000 (UTC)
X-FDA: 84661997238.03.8F16C1F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12E804000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:55:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X3DZ13Ow;
	spf=pass (imf11.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776286557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENNbs4gbyOAs95P0v1deKno0AQbBqBiXnzI8NKCHyzw=;
	b=X/hkI4tuuowSSirTG0PRE+4j+Rli8oEpe035C/+KGzYMvM4pX02K+lA30EuRzyUnRJripu
	NAweXViF3jBUeXCdz4UraPkCgrB1e8fZRNhm2E/TwN3QarhgkeTPhw/6hKWGoeB0kV5tXe
	apjD79mNxt7cdIxFq6myuJ4U58vR3k0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X3DZ13Ow;
	spf=pass (imf11.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776286557; a=rsa-sha256;
	cv=none;
	b=D9wxE5PVgrIuL3mXFDQRxMGjqBg5G/71Mu5L4ktM/wITWByevHpKqTDBD/tQtc/ky7tvP9
	DKwoe6ssiXbueRUrO+Kh7+NSCGuerJaCWUdvEwGghIZbckacw2zi1ioTt1nxp96NnBLVGy
	KlA+casFKAdZZo9YuKfZsKX65dvm42c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776286557; x=1807822557;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=G1TIPTrudC61FQEc6LlRZJ0Y6VI6iOIVzJ8PnSQ90e4=;
  b=X3DZ13OwZ4uxpoCSlL2/t4dy6veecnroD5QUPJKKICkB66Mv54M6ka/6
   3i4mKsxgKe7+4gQReXc1RiCdsMx20LZshm/DULIOaKYhRzxvPn+cIFuu/
   qGbqKLJZZ4ANFAIrKgnsGaKfVrK8CsZzXRxT2lGOiap+CEhnuVxna3EPU
   2RnbrchZGEMvmrEcMPCOi2wHcm8Pg/7HZ75/0VaK5Fauvz/APGVg56/G2
   enXUJ+EDPIpsKogul5KjsOHR2mzFKkyglQelRIftD6lmLx+e2x5wlFEJm
   bgHdhfNF+BWDzNZ+sXBd5IUStijH23chu7I+sgoeDgQeEHBSOg52IRU3n
   w==;
X-CSE-ConnectionGUID: /rDgJ3rXSzyDQb7tyDRRTw==
X-CSE-MsgGUID: EQDVMUv4TxGS6vxgZDT7VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11760"; a="77392675"
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="77392675"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 13:55:55 -0700
X-CSE-ConnectionGUID: uZtdK/G0TNiRuGshzxZDjQ==
X-CSE-MsgGUID: PJVmEMMATpKvAhB+wYBHYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="226211101"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.88.27.144])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 13:55:54 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, harry@kernel.org,
 akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.orgg, Hao Li
 <hao.li@linux.dev>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
In-Reply-To: <20260410112202.142597-1-hao.li@linux.dev>
References: <20260410112202.142597-1-hao.li@linux.dev>
Date: Wed, 15 Apr 2026 13:55:54 -0700
Message-ID: <87a4v47xk5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ismh5caooj8pmp48mjkmkqiyyy3kokp9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12E804000B
X-HE-Tag: 1776286556-777042
X-HE-Meta: U2FsdGVkX1+h81kn9FVjypDz4RRMBDQMn4mR1ENA8O7Sx1RSAxTpz6vZiSiu3bayn5XHDK5F9xx5sXwFYeVC6kma5WNN0A1yZtPOXhx8QrMLvI+CgN61xE0RDFG5GpROlX4SzMJGKa3WiXdAoVHoA2U1QdC19vVDQX6PsviazVdpsWwHsZcZT8NzWTBP93QRMGoLCTySQfvkB1vgF28Ioyci/yE13aQ0HMxCvogeho74iAQ1Kj8bXhADSen2Rw+5M98pIUFNeR5en0k/xJNGBtuf1HEgO6oFkhBJ+GInW/k+8yOaMVBb8LiJ9FnTZTfItDjqump2MJJ99fn5mz5HWaoujOYstizaK+zJXwO7O3XeQjUG4zE1BFFSGdBRI4P23zYtmjpsWIO9QFlLJOeH86YiGIp8d2Wlx0fxlJf7Ia/PW4Mzzr8aDJnlCJ2n02wDXkgVIq8iPamVf9hGw1xEB6GgA4oWYLBwlK35LZiSziaKfaN1HYf7iVxxJWN+ghumjDhb9UkDBIXZa5BVOVAd7e0Ezz4UYggOf3cWS4lFxpaUv/r/8ApADytsr/apZ64Br7BVlvpGOORzG6Gxk1UxMJeut0ejK6fkOPcDayNJFnf7kQPDojBDMYubXi4GjAWi31cIYamUo1dKwSC5I+xFZSPPGfiSuVOH9560hUROGoeqCPlItl24FXBqmp9EstZ/2/bLnL3hojTKL919WK/SWCWvGrWwBYeeGkfv/3JsvQO2SEBX/3Ke5Pi3cErJvMWLXgeSaNRAdUKNP5bshFvh8BHMnDSTYJngDtwBoX9P6DW9OlqpWumy4qWMfo0n+oNEsypn3N7pJOUn1AqZpOpZCuoY0Lne4ye2QB9LtpR3WyRdc5A/mtkP62k4e5Ob9TjkvG2OaxaVmOE1j7tUyRZcXIcbP2A56t0z/8y2jYOi4fpY1NbWs+RKOinU699qsSy7keKQoOHPHnZ1VR3g40G
 6bPn1eZj
 r0sIaIZLusN5BVpxsixlmNtIJxef1N+wxROHS8mXtJ+WEkGP+MkT1mF7CCMwSdgbOXav0sbMj6soxm1z2wtxXlSHUV/sPSeG+5xNt1RohuarlaFMVkSxM6ZNiPKH+WiXKQH8IBZcCbSm8xiNMkA9nCnfvS5+9V0qPV189f7Tt/ku4Hz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao Li <hao.li@linux.dev> writes:

> When performing objects refill, we tend to optimistically assume that
> there will be more allocation requests coming next; this is the
> fundamental assumption behind this optimization.
>
> When __refill_objects_node() isolates a partial slab and satisfies a
> bulk allocation from its freelist, the slab can still have a small tail
> of free objects left over. Today those objects are freed back to the
> slab immediately.
>
> If the leftover tail is local and small enough to fit, keep it in the
> current CPU's sheaves instead. This avoids pushing those objects back
> through the __slab_free slowpath.
>
> Add a helper to obtain both the freelist and its free-object count, and
> then spill the remaining objects into a percpu sheaf when:
> - the tail fits in a sheaf
> - the slab is local to the current CPU
> - the slab is not pfmemalloc
> - the target sheaf has enough free space
>
> Otherwise keep the existing fallback and free the tail back to the slab.
>
> Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> stats.
>
> On the mmap2 case in the will-it-scale benchmark suite, this patch can
> improve performance by about 2~5%.
>
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>
> This patch is an exploratory attempt to address the leftover objects and
> partial slab issues in the refill path, and it is marked as RFC to warmly
> welcome any feedback, suggestions, and discussion!
>

I was also looking at these regressions, but I went from a different
direction, and ended up with 3 patches:

1. the regressions showed a lot of increase in the cache misses,
   which gave me the idea that a cache would help (and it seemed to help)

2. Allowing smaller refills (but potentially more frequent);

3. A cute (but with small impact) use of prefetch();

The numbers are here (the commentary from the bot are very hit or miss,
so don't pay too much attention to them):

https://github.com/vcgomes/linux/commit/c898c39ee8def5252942281353eda6acdd83d4ea

I am re-running the tests against a more recent tree, but if you
want to take a look:

https://github.com/vcgomes/linux/tree/mm-sheaves-regression-timerfd

Also, if you feel it's useful, I can send a RFC.

> ---
>  mm/slub.c | 107 ++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 88 insertions(+), 19 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 2b2d33cc735c..fe6351ba0e60 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -353,6 +353,7 @@ enum stat_item {
>  	SHEAF_REFILL,		/* Objects refilled to a sheaf */
>  	SHEAF_ALLOC,		/* Allocation of an empty sheaf */
>  	SHEAF_FREE,		/* Freeing of an empty sheaf */
> +	SHEAF_SPILL,
>  	BARN_GET,		/* Got full sheaf from barn */
>  	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
>  	BARN_PUT,		/* Put full sheaf to barn */
> @@ -4279,7 +4280,9 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
>   * Assumes this is performed only for caches without debugging so we
>   * don't need to worry about adding the slab to the full list.
>   */
> -static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +static inline void *__get_freelist_nofreeze(struct kmem_cache *s,
> +					    struct slab *slab, int *freecount,
> +					    const char *n)
>  {
>  	struct freelist_counters old, new;
>  
> @@ -4293,11 +4296,26 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
>  
>  		new.inuse = old.objects;
>  
> -	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
> +	} while (!slab_update_freelist(s, slab, &old, &new, n));
> +
> +	if (freecount)
> +		*freecount = old.objects - old.inuse;
>  
>  	return old.freelist;
>  }
>  
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +{
> +	return __get_freelist_nofreeze(s, slab, NULL, "get_freelist_nofreeze");
> +}
> +
> +static inline void *get_freelist_and_freecount_nofreeze(struct kmem_cache *s,
> +							struct slab *slab,
> +							int *freecount)
> +{
> +	return __get_freelist_nofreeze(s, slab, freecount, "get_freelist_and_freecount_nofreeze");
> +}
> +
>  /*
>   * If the object has been wiped upon free, make sure it's fully initialized by
>   * zeroing out freelist pointer.
> @@ -7028,10 +7046,15 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  		return 0;
>  
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +		void *head;
> +		void *tail;
> +		struct slub_percpu_sheaves *pcs;
> +		int freecount, local_node, i, cnt = 0;
> +		struct slab_sheaf *spill;
>  
>  		list_del(&slab->slab_list);
>  
> -		object = get_freelist_nofreeze(s, slab);
> +		object = get_freelist_and_freecount_nofreeze(s, slab, &freecount);
>  
>  		while (object && refilled < max) {
>  			p[refilled] = object;
> @@ -7039,28 +7062,72 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  			maybe_wipe_obj_freeptr(s, p[refilled]);
>  
>  			refilled++;
> +			freecount--;
>  		}
>  
> +		if (!freecount) {
> +			if (refilled >= max)
> +				break;
> +			continue;
> +		}
>  		/*
> -		 * Freelist had more objects than we can accommodate, we need to
> -		 * free them back. We can treat it like a detached freelist, just
> -		 * need to find the tail object.
> +		 * Freelist had more objects than we can accommodate, we first
> +		 * try to spill them into percpu sheaf.
>  		 */
> -		if (unlikely(object)) {
> -			void *head = object;
> -			void *tail;
> -			int cnt = 0;
> -
> -			do {
> -				tail = object;
> -				cnt++;
> -				object = get_freepointer(s, object);
> -			} while (object);
> -			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		if (freecount > s->sheaf_capacity)
> +			goto skip_spill;
> +		if (slab_test_pfmemalloc(slab))
> +			goto skip_spill;
> +
> +		if (!local_trylock(&s->cpu_sheaves->lock))
> +			goto skip_spill;
> +
> +		local_node = numa_mem_id();
> +		if (slab_nid(slab) != local_node) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto skip_spill;
>  		}
>  
> -		if (refilled >= max)
> -			break;
> +		pcs = this_cpu_ptr(s->cpu_sheaves);
> +		if (pcs->spare &&
> +		    (freecount <= (s->sheaf_capacity - pcs->spare->size)))
> +			spill = pcs->spare;
> +		else if (freecount <= (s->sheaf_capacity - pcs->main->size))
> +			spill = pcs->main;
> +		else {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto skip_spill;
> +		}
> +
> +		if (freecount > (s->sheaf_capacity - spill->size)) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto skip_spill;
> +		}
> +
> +		for (i = 0; i < freecount; i++) {
> +			spill->objects[spill->size] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, spill->objects[spill->size]);
> +			spill->size++;
> +		}
> +
> +		local_unlock(&s->cpu_sheaves->lock);
> +		stat(s, SHEAF_SPILL);
> +		break;
> +skip_spill:
> +		/*
> +		 * Freelist had more objects than we can accommodate or spill,
> +		 * we need to free them back. We can treat it like a detached freelist,
> +		 * just need to find the tail object.
> +		 */
> +		head = object;
> +		do {
> +			tail = object;
> +			cnt++;
> +			object = get_freepointer(s, object);
> +		} while (object);
> +		__slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		break;
>  	}
>  
>  	if (unlikely(!list_empty(&pc.slabs))) {
> @@ -9247,6 +9314,7 @@ STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
>  STAT_ATTR(SHEAF_REFILL, sheaf_refill);
>  STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
>  STAT_ATTR(SHEAF_FREE, sheaf_free);
> +STAT_ATTR(SHEAF_SPILL, sheaf_spill);
>  STAT_ATTR(BARN_GET, barn_get);
>  STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
>  STAT_ATTR(BARN_PUT, barn_put);
> @@ -9335,6 +9403,7 @@ static struct attribute *slab_attrs[] = {
>  	&sheaf_refill_attr.attr,
>  	&sheaf_alloc_attr.attr,
>  	&sheaf_free_attr.attr,
> +	&sheaf_spill_attr.attr,
>  	&barn_get_attr.attr,
>  	&barn_get_fail_attr.attr,
>  	&barn_put_attr.attr,
> -- 
> 2.50.1
>
>

-- 
Vinicius

