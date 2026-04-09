Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EE4E98FA9
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 04:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440DB6B0005; Thu,  9 Apr 2026 00:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1BC6B0088; Thu,  9 Apr 2026 00:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0CC6B008A; Thu,  9 Apr 2026 00:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13E9B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:24:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91F6AB857E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:24:58 +0000 (UTC)
X-FDA: 84637727076.02.5F0C893
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8C48180009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:24:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fn4Qi9Kw;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775708697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOwKdUSQUx99IWiDOD3GSWLVM/ex8ua+MqLtreO1E0g=;
	b=M+bpYJmABbHOd/NwQOHVmd2lUxCeGoOFg0Wita5slS0pidMgrT9oH+78q/crhdgc7+DQ4K
	+RfX0GS7W6OI5hCMT9BXOYmiIvsH6U72QrDD7ILejTxksdqLdLvDlmS4bW47ZGfL5kO1bG
	zMwpsHC8UPYCVW3+uBVW4tZUNtZUtuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775708697; a=rsa-sha256;
	cv=none;
	b=Uby1v18HMDMJKn+f6nhdf5g3kyqqr5UhfzQlj/PuGWRSgFF3N+m79mM0vWliamT0OgGAwQ
	66/fVfw0SmN/aa/tBijSly/e+0z9gCcOowyJR0vnjNHo+Ir7IkTY7RMbJRzmNyaRlIP56w
	IheqtdVeQ9uMX3u6WRLWMQp4u+b/FkI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fn4Qi9Kw;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B516243A67;
	Thu,  9 Apr 2026 04:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377A7C4CEF7;
	Thu,  9 Apr 2026 04:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775708695;
	bh=Um/3s6L8Thw2xS2VcS2xhJ4lQqax6JnsUdU7TP2iZAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fn4Qi9KwkP/sIfnyrs7gsx9DW2jUM7JKxrCWoItOGcGt12L55BqrrTIPhii22gcu9
	 sdk76rgh95BubJ3E9y81R7LXZMQCx21nSzeFbZoZAGsDvJlOSZysknGmCmWiSYBgA2
	 o53robuzTewXPKcE4Pa7i33uNsapOdAPZAWWOHijyIjNJIz42umixA9EQ3ndb7KpnD
	 /A+FziUQ7KvnOg210izQ8+wbwQHZJj/HNqdzl+m/d0BefYDZccJSyvWx/FDJWdG95t
	 AQtywPS1TyIfa8CrVZsTJEfjqKXj7t5KkPUjHRwRS9Ee6enrAeqijYGTso52VC6lQZ
	 R4pZDnWXprt9w==
Date: Thu, 9 Apr 2026 13:24:53 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v4] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <adcqFQR4XGSJqtAP@hyeyoo>
References: <2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn>
X-Rspamd-Queue-Id: C8C48180009
X-Stat-Signature: rqgirg19e1zoc5dhn5wrnt4wz57oceoi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775708696-743956
X-HE-Meta: U2FsdGVkX18BrRr6HndiI+/A31q5aeIDlvVcs6tpGggWCJ0Na/a32ErbVswokJutKBBh3bF/Xx+iKs+EtvBZwi6XBkvd717eKBhzZCcKL0sGf9rtVitl6302U3HP2Y9oMUndvM0djqM7cEkRZA+O5btHamAjDGr/61F0iwZU4q2Zp3sI964kxlWopWnPeJrlLqStqkHS/zlG+LKHe9CHh4qMmSNVhrehVtO26d+Olw2wj/QO6qhGlTTHuww7/YCv8d3z3hbx0+UxzhVoUmLhwapL61M/bbK5O8BAhewZWe7JoMn7uLJEYK9yVsYNq6zFXSH/Q7ic0fEFmZsj5w9zX8NvsJtiXIOj7rJAKzRuZhKDzHtY2Va7popdHYkMirlQfMO5JZRGskEUMoUv5NXyao8CWWkreIXLnsWrC7uiLtjeASe7xHcNP4PWi45MwGWPrJ+MVZuY1FnVeG16CBYJ5jKbTN8rI49xLjZoUDFrYBsO55afDeNIOGIO5wB6D8OjFFi7LSh8n7N5pcQsWeiwzWrZC6GgiqezV3aS0IjNrOuxUeyCcsf8vngh+XAquuYcxC9M4e00+SKqlmIC5cideYP9Ac2xFxQFnKyM8349E5EDshkpYZc7q2YKujMHRb6C/zyork7jl3SQZpgK0i5qXcBF6BiH3qLjSryvJKJkzAUL7CoqByWdlKcZNe5weJXZlr3yP+KzdtYrkhji9X/D05RVKmG/s+BNqv5OfzXxjfeAMBb50YsBhk00pgcV56Le7/FASISYrF40/3559ygiLoAOoImxx5yMfeGuflEpKVE6cXZNwQ3BeGPFIv3IZv8k0MGhbC8eh3ea8cnYZIQKQqoeB9bZ9WqqI6LzTs9OMVXGUUBGlI/5ZOYQQOznthmyWHr/E06obV6QUR+Hz+G9BTLPVEgvOmdbyMmfN8kfN3AcCJdSc9HkoMTcXBT3oXVyT9SRy5EumvIlFwpWucO
 BmAKRQeb
 KbcxJBmz60aNOu0Qmm62bh+F08PDWCHzv6e43Tfsk7gki0fIqwDFx7fi4RQmakJpvbVeyPdvOju69OGdssXJvjL5pftvKPDPZwQK0nvdVfu8fSddHEalC787Ts+2ptsaDEofISoRIZV/wdCynaG+bs7e0DMEjXQGmTgXy2r2MskqtDyg6MqJt5nK/4xSGLcdHexo/E2Ci1d8BVq57TZBWxcsz9M5weE8PV9dR9PQBk/RnqRwU1kJubEYhRs64238CpPjBw2AlVaOEWd2zoJ3djO2bxpIFdz8mC7HVm4Vqf4QAxQAZCF8Zl3uuWaltie/HY4KcaLWjjIOEOVoeqSMUBu2jKcHjlDW2Xb7p+hboSMFFa9yP/VDsCG5OGtfhTSYH+DbvSlvuGXn/z2pB6VVIxqY88fmg/vtbIP/UDve1Zrpz77s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 11:28:18PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Allocations from a fresh slab can consume all of its objects, and the
> freelist built during slab allocation is discarded immediately as a result.
> 
> Instead of special-casing the whole-slab bulk refill case, defer freelist
> construction until after objects are emitted from a fresh slab.
> new_slab() now only allocates the slab and initializes its metadata.

Oh, in v3 new_slab() built the freelist and allocate_slab() didn't,
but in v4 new_slab() doesn't build the freelist.

That was a subtle change but ok.

> refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> emit objects directly, building a freelist only for the objects left
> unallocated; the same change is applied to alloc_single_from_new_slab().
> 
> To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> small iterator abstraction for walking free objects in allocation order.
> The iterator is used both for filling the sheaf and for building the
> freelist of the remaining objects.
> 
> Also mark setup_object() inline. After this optimization, the compiler no
> longer consistently inlines this helper in the hot path, which can hurt
> performance. Explicitly marking it inline restores the expected code
> generation.
> 
> This reduces per-object overhead in bulk allocation paths and improves
> allocation throughput significantly. In slub_bulk_bench, the time per
> object drops by about 35% to 72% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> by about 60% to 71% with CONFIG_SLAB_FREELIST_RANDOM=y.
> 
> Benchmark results (slub_bulk_bench):

There are only a few bulk alloc/free API users.
Non-bulk alloc/free may also benefit from this when refilling
sheaves.

> Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> Kernel: Linux 7.0.0-rc7-next-20260407
> Config: x86_64_defconfig
> Cpu: 0
> Rounds: 20
> Total: 256MB
> 
> - CONFIG_SLAB_FREELIST_RANDOM=n -
> 
> obj_size=16, batch=256:
> before: 4.72 +- 0.03 ns/object
> after: 3.06 +- 0.03 ns/object
> delta: -35.1%

Hmm, the number is too good for slowpath optimization.

Probably it's because the bulk size in the microbenchmark
is too large (256MB? oh...) to be served from sheaves in the barn.

And the microbenchmark doesn't really touch objects and
thus not building freelist removes the need to fetch
cache lines and hence leading to much less cache footprint?

So the number doesn't seem to show benefits of realistic workloads
(per Amdahl's Law, the actual speedup is bounded by the fraction of time
spent in the slowpath, which should be low), but that's fine
as long as it doesn't complicate things.

> obj_size=32, batch=128:
> before: 6.69 +- 0.04 ns/object
> after: 3.51 +- 0.06 ns/object
> delta: -47.6%
> 
> obj_size=64, batch=64:
> before: 10.48 +- 0.06 ns/object
> after: 4.23 +- 0.07 ns/object
> delta: -59.7%
> 
> obj_size=128, batch=32:
> before: 18.31 +- 0.12 ns/object
> after: 5.67 +- 0.13 ns/object
> delta: -69.0%
> 
> obj_size=256, batch=32:
> before: 21.59 +- 0.13 ns/object
> after: 6.05 +- 0.14 ns/object
> delta: -72.0%
> 
> obj_size=512, batch=32:
> before: 19.44 +- 0.14 ns/object
> after: 6.23 +- 0.13 ns/object
> delta: -67.9%
> 
> - CONFIG_SLAB_FREELIST_RANDOM=y -
> 
> obj_size=16, batch=256:
> before: 8.71 +- 0.31 ns/object
> after: 3.44 +- 0.03 ns/object
> delta: -60.5%
> 
> obj_size=32, batch=128:
> before: 11.11 +- 0.12 ns/object
> after: 4.00 +- 0.04 ns/object
> delta: -64.0%
> 
> obj_size=64, batch=64:
> before: 15.27 +- 0.32 ns/object
> after: 5.10 +- 0.13 ns/object
> delta: -66.6%
> 
> obj_size=128, batch=32:
> before: 21.49 +- 0.23 ns/object
> after: 6.93 +- 0.20 ns/object
> delta: -67.8%
> 
> obj_size=256, batch=32:
> before: 26.23 +- 0.42 ns/object
> after: 7.42 +- 0.20 ns/object
> delta: -71.7%
> 
> obj_size=512, batch=32:
> before: 26.44 +- 0.35 ns/object
> after: 7.62 +- 0.27 ns/object
> delta: -71.2%
> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>  mm/slab.h |  10 ++
>  mm/slub.c | 278 +++++++++++++++++++++++++++---------------------------
>  2 files changed, 149 insertions(+), 139 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index bf2f87acf5e3..ada3f9c3909f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> diff --git a/mm/slub.c b/mm/slub.c
> index 4927407c9699..67ec8b29f862 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3483,6 +3409,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	slab->frozen = 0;
> 
>  	slab->slab_cache = s;
> +	slab->freelist = NULL;
> 
>  	kasan_poison_slab(slab);
>

nit: We could drop this hunk and call build_slab_freelist()
unconditionally instead. If slab->inuse == slab->objects, ->freelist
is set to NULL.

I think

"build_slab_freelist() is called unconditionally. It builds the freelist
 if there is any object left, otherwise set ->freelist to NULL"

is easier  to follow than

"Oh we didn't call build_slab_freelist(). where is ->freelist set to
 NULL?, oh, it's set in allocate_slab()"

>  /*
>   * Called only for kmem_cache_debug() caches to allocate from a freshly
>   * allocated slab. Allocate a single object instead of whole freelist
>   * and put the slab to the partial (or full) list.
>   */
>  static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> -					int orig_size, gfp_t gfpflags)
> +					int orig_size, bool allow_spin)
>  {
> -	bool allow_spin = gfpflags_allow_spinning(gfpflags);
> -	int nid = slab_nid(slab);
> -	struct kmem_cache_node *n = get_node(s, nid);
> +	struct kmem_cache_node *n;
> +	struct slab_obj_iter iter;
> +	bool needs_add_partial;
>  	unsigned long flags;
>  	void *object;
> 
> -	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
> -		/* Unlucky, discard newly allocated slab. */
> -		free_new_slab_nolock(s, slab);
> -		return NULL;
> -	}
> -
> -	object = slab->freelist;
> -	slab->freelist = get_freepointer(s, object);
> +	init_slab_obj_iter(s, slab, &iter, allow_spin);
> +	object = next_slab_obj(s, &iter);
>  	slab->inuse = 1;
> 
> +	needs_add_partial = (slab->objects > 1);
> +	if (needs_add_partial)

nit: Again this condition is already checked within build_slab_freelist().
Let's call it unconditionally.

> +		build_slab_freelist(s, slab, &iter);
> +
>  	if (!alloc_debug_processing(s, slab, object, orig_size)) {
>  		/*
>  		 * It's not really expected that this would fail on a
> @@ -4359,33 +4360,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	 */
>  	needs_add_partial = (slab->objects > count);
> 
> -	if (!allow_spin && needs_add_partial) {
> -
> -		n = get_node(s, slab_nid(slab));
> -
> -		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> -			/* Unlucky, discard newly allocated slab */
> -			free_new_slab_nolock(s, slab);
> -			return 0;
> -		}
> -	}
> +	/* Target inuse count after allocating from this new slab. */
> +	target_inuse = needs_add_partial ? count : slab->objects;
> 
> -	object = slab->freelist;
> -	while (object && allocated < count) {
> -		p[allocated] = object;
> -		object = get_freepointer(s, object);
> -		maybe_wipe_obj_freeptr(s, p[allocated]);
> +	init_slab_obj_iter(s, slab, &iter, allow_spin);
> 
> -		slab->inuse++;
> +	while (allocated < target_inuse) {
> +		p[allocated] = next_slab_obj(s, &iter);
>  		allocated++;
>  	}
> -	slab->freelist = object;
> +	slab->inuse = target_inuse;
> 
>  	if (needs_add_partial) {
> -
> +		build_slab_freelist(s, slab, &iter);

nit: per the suggestion above build_slab_freelist() should be called
regardless of needs_add_partial...

> +		n = get_node(s, slab_nid(slab));
>  		if (allow_spin) {
> -			n = get_node(s, slab_nid(slab));
>  			spin_lock_irqsave(&n->list_lock, flags);
> +		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/*
> +			 * Unlucky, discard newly allocated slab.
> +			 * The slab is not fully free, but it's fine as
> +			 * objects are not allocated to users.
> +			 */
> +			free_new_slab_nolock(s, slab);
> +			return 0;

Sashiko raised a very good point [1] here.
https://sashiko.dev/#/patchset/2026040823281824773ybHpC3kgUhR9OE1rGTl%40zte.com.cn

Now that we unconditionally fill the @p array, it becomes problematic that
___slab_alloc() doesn't check the return value of
alloc_from_new_slab() but the value of `object` variable:
|        if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {              
|                object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
|
|                if (likely(object))
|                        goto success;                                           
|        } else {                                                                
|                alloc_from_new_slab(s, slab, &object, 1, allow_spin);           
|
|                /* we don't need to check SLAB_STORE_USER here */
|                if (likely(object))

That's a use-after-free bug.
It should really check the return value and not `object`.

if (alloc_from_new_slab(...))
	return object;

|                        return object;
|        }      

>  		}
>  		add_partial(n, slab, ADD_TO_HEAD);
>  		spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -7596,14 +7591,19 @@ static void early_kmem_cache_node_alloc(int node)
>  		pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
>  	}
> 
> -	n = slab->freelist;
> +	init_slab_obj_iter(kmem_cache_node, slab, &iter, true);
> +
> +	n = next_slab_obj(kmem_cache_node, &iter);
>  	BUG_ON(!n);
> +
> +	slab->inuse = 1;
> +	if (slab->objects > 1)
> +		build_slab_freelist(kmem_cache_node, slab, &iter);

nit: ditto. let's call build_slab_freelist() unconditionally.

>  #ifdef CONFIG_SLUB_DEBUG
>  	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
>  #endif
>  	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
> -	slab->freelist = get_freepointer(kmem_cache_node, n);
> -	slab->inuse = 1;
>  	kmem_cache_node->per_node[node].node = n;
>  	init_kmem_cache_node(n);
>  	inc_slabs_node(kmem_cache_node, node, slab->objects);

Otherwise LGTM!

-- 
Cheers,
Harry / Hyeonggon

