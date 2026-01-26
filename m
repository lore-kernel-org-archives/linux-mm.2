Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4767BC88E57
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 07:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D576B00A2; Mon, 26 Jan 2026 02:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75286B00A3; Mon, 26 Jan 2026 02:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABE06B00A4; Mon, 26 Jan 2026 02:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864E86B00A2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:12:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 494755A2B6
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:12:18 +0000 (UTC)
X-FDA: 84373246356.19.5DAED28
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F252C0006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:12:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gwzs01lv;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769411536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tQJFz7jcAPVzYMIAq76r5MfF6/thKPhJ3/J6Pp98fQ=;
	b=dkOiYHFo85D90yEy6JF3sCZQp1QaXgK7EzOEQ1MOXp1o2nKyezGomG0+mmCHjANyS2EntW
	LGyn9SQqR4HLhXdkheNTR5gWG9gcnLNhH9tpXNjDB9fm7MqecgL7KcftQfH4HeN/til2iP
	s4KZZqfuoDyGFZzXH17P1Wgf5d/atRU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gwzs01lv;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769411536; a=rsa-sha256;
	cv=none;
	b=YQ7rQTk/csx3SsLAgVp53RVkL4g4ehMyS9PEzR+C6vjb9rh5/2nsMDLVrzERcpCwmMw8v5
	SO11W5bLhjd6J4/r62/L9hPCQ3noFWHNuA9k6fY3tzzYiGO6jtVy8T9Ff45aIcNJhhOV/S
	qezljwNpnb3oCCAOW6rpwaNQ9+a+R38=
Date: Mon, 26 Jan 2026 15:12:03 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769411534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tQJFz7jcAPVzYMIAq76r5MfF6/thKPhJ3/J6Pp98fQ=;
	b=Gwzs01lv6uB1cCSRNn/WK4T2jgpEf4bzOZiOck9qkaD9FDws9D+Wug3+57oFR75Z7W3SU6
	hD+YMWEqGV/Kh39DlBN+uKWgTOgbEeoqqsGevXvYJrLeO6fUIm2ZI2Bepavu9WasBhKCAY
	uS0gqQCPZkSOr0cSlOzGzbgUupl2I6o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 10/22] slab: add optimized sheaf refill from partial
 list
Message-ID: <jgmmllqopl4rpihfe4jdnuifzexlffef5gehsocdcdu2xdj62j@xuz56etxseza>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-10-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-10-041323d506f7@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 5z3sdjon3o8mo7g1oangi8npbdnidp9y
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F252C0006
X-HE-Tag: 1769411536-484560
X-HE-Meta: U2FsdGVkX188OmdWA652LoKwEcuV1jC2fOKtiukkRzGryKXA0YBGOujStYZiIBrgUwPNfA8reH0gMdv3VQnTE0vU9q9vgCqLhwqSZVCQG5Im7t4QpSpPFzGseGagvj6DFAQ1LWWR7tpgggUUdP1Poq/SiWaeSSOl8qqdgMn5T5/n/MtbvXXJ9Rrf16ytI/uiXxEkiPOlsKHm5J6gdIL2Yrugf1+573IbvcgoG7ZEsMcqnODEhrSezP2AzEeZQCH3eVJdODRmVbyg/fDvXB34frk5n7hkft8zh83tb2mkMC3uodLCorXRrmvJUpd1bSPB3zFSP4pQBLkoIszz/0AdoNGjjYwW0p2rX0Kei3mioiIIBm0iI1PugIXXbrKlVgVLODUy5yS46KkBUgWuSsRlMFMAkDkwmpRgpI1AnF9/K0RgutfiFSvxPwbvOpp47kDW3DkQg/SLrwyNWF2ZJzFVkUouJ/xBUR2BEVdazQyHweUET0cwapGVBPDgnUOjX5w1d6Xq9lgu2tN0m0HgZH6hfX2ZCApR1Aj72T6yknOt3HqOCvRrbFV07UXLhedKrJp/vnWWgkfYLTKYxD8aBrwjU4lZl4vk4W6/R2gYSSbTHs3D9rmY0NqzpW6tPqgSMpEtVY/FH80nwV2RdHkJVE1ITNbPtHZu6gUMTa4+WisvW2exTRF2771QFBMWTtJp2q8gQ6OnKbS0qm8SXGK479LVTcnGtpo+NmgsJfQ8zhTD3WsqqbHZXZxyl+36TPxElmH0qrF6kh+TKhEBDsLT3ewPj4muAM6mFvpZfeHt9hU3Gyo/bpbjs0j0DjVUksm2roMKskkP0BDO0BGK3HaXMIQVQS+TcBDxozWqbH6vMx+nVw66R9w4ceTFHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:48AM +0100, Vlastimil Babka wrote:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Introduce struct partial_bulk_context, a variant of struct
> partial_context that can return a list of slabs from the partial list
> with the sum of free objects in them within the requested min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list. There is a racy read of slab->counters
> so make sure the non-atomic write in __update_freelist_slow() is not
> tearing.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions. It supports
> the allow_spin parameter, which we always set true here, but the
> followup change will reuse the function in a context where it may be
> false.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> 
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 293 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 272 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 22acc249f9c0..142a1099bbc1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -248,6 +248,14 @@ struct partial_context {
>  	void *object;
>  };
>  
> +/* Structure holding parameters for get_partial_node_bulk() */
> +struct partial_bulk_context {
> +	gfp_t flags;
> +	unsigned int min_objects;
> +	unsigned int max_objects;
> +	struct list_head slabs;
> +};
> +
>  static inline bool kmem_cache_debug(struct kmem_cache *s)
>  {
>  	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
> @@ -778,7 +786,8 @@ __update_freelist_slow(struct slab *slab, struct freelist_counters *old,
>  	slab_lock(slab);
>  	if (slab->freelist == old->freelist &&
>  	    slab->counters == old->counters) {
> -		slab->freelist = new->freelist;
> +		/* prevent tearing for the read in get_partial_node_bulk() */
> +		WRITE_ONCE(slab->freelist, new->freelist);

Should this perhaps be WRITE_ONCE(slab->counters, new->counters) here?

Everything else looks good to me.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

>  		slab->counters = new->counters;
>  		ret = true;
>  	}
> @@ -2638,9 +2647,9 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  	stat(s, SHEAF_FREE);
>  }
>  
> -static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> -				   size_t size, void **p);
> -
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max);
>  
>  static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  			 gfp_t gfp)
> @@ -2651,8 +2660,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  	if (!to_fill)
>  		return 0;
>  
> -	filled = __kmem_cache_alloc_bulk(s, gfp, to_fill,
> -					 &sheaf->objects[sheaf->size]);
> +	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
> +			to_fill, to_fill);
>  
>  	sheaf->size += filled;
>  
> @@ -3518,6 +3527,57 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
>  #endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>  
> +static bool get_partial_node_bulk(struct kmem_cache *s,
> +				  struct kmem_cache_node *n,
> +				  struct partial_bulk_context *pc)
> +{
> +	struct slab *slab, *slab2;
> +	unsigned int total_free = 0;
> +	unsigned long flags;
> +
> +	/* Racy check to avoid taking the lock unnecessarily. */
> +	if (!n || data_race(!n->nr_partial))
> +		return false;
> +
> +	INIT_LIST_HEAD(&pc->slabs);
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +
> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +		struct freelist_counters flc;
> +		unsigned int slab_free;
> +
> +		if (!pfmemalloc_match(slab, pc->flags))
> +			continue;
> +
> +		/*
> +		 * determine the number of free objects in the slab racily
> +		 *
> +		 * slab_free is a lower bound due to possible subsequent
> +		 * concurrent freeing, so the caller may get more objects than
> +		 * requested and must handle that
> +		 */
> +		flc.counters = data_race(READ_ONCE(slab->counters));
> +		slab_free = flc.objects - flc.inuse;
> +
> +		/* we have already min and this would get us over the max */
> +		if (total_free >= pc->min_objects
> +		    && total_free + slab_free > pc->max_objects)
> +			break;
> +
> +		remove_partial(n, slab);
> +
> +		list_add(&slab->slab_list, &pc->slabs);
> +
> +		total_free += slab_free;
> +		if (total_free >= pc->max_objects)
> +			break;
> +	}
> +
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return total_free > 0;
> +}
> +
>  /*
>   * Try to allocate a partial slab from a specific node.
>   */
> @@ -4444,6 +4504,33 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
>  	return old.freelist;
>  }
>  
> +/*
> + * Get the slab's freelist and do not freeze it.
> + *
> + * Assumes the slab is isolated from node partial list and not frozen.
> + *
> + * Assumes this is performed only for caches without debugging so we
> + * don't need to worry about adding the slab to the full list.
> + */
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +{
> +	struct freelist_counters old, new;
> +
> +	do {
> +		old.freelist = slab->freelist;
> +		old.counters = slab->counters;
> +
> +		new.freelist = NULL;
> +		new.counters = old.counters;
> +		VM_WARN_ON_ONCE(new.frozen);
> +
> +		new.inuse = old.objects;
> +
> +	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
> +
> +	return old.freelist;
> +}
> +
>  /*
>   * Freeze the partial slab and return the pointer to the freelist.
>   */
> @@ -4467,6 +4554,72 @@ static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
>  	return old.freelist;
>  }
>  
> +/*
> + * If the object has been wiped upon free, make sure it's fully initialized by
> + * zeroing out freelist pointer.
> + *
> + * Note that we also wipe custom freelist pointers.
> + */
> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> +						   void *obj)
> +{
> +	if (unlikely(slab_want_init_on_free(s)) && obj &&
> +	    !freeptr_outside_object(s))
> +		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
> +			0, sizeof(void *));
> +}
> +
> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> +		void **p, unsigned int count, bool allow_spin)
> +{
> +	unsigned int allocated = 0;
> +	struct kmem_cache_node *n;
> +	bool needs_add_partial;
> +	unsigned long flags;
> +	void *object;
> +
> +	/*
> +	 * Are we going to put the slab on the partial list?
> +	 * Note slab->inuse is 0 on a new slab.
> +	 */
> +	needs_add_partial = (slab->objects > count);
> +
> +	if (!allow_spin && needs_add_partial) {
> +
> +		n = get_node(s, slab_nid(slab));
> +
> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/* Unlucky, discard newly allocated slab */
> +			defer_deactivate_slab(slab, NULL);
> +			return 0;
> +		}
> +	}
> +
> +	object = slab->freelist;
> +	while (object && allocated < count) {
> +		p[allocated] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +		slab->inuse++;
> +		allocated++;
> +	}
> +	slab->freelist = object;
> +
> +	if (needs_add_partial) {
> +
> +		if (allow_spin) {
> +			n = get_node(s, slab_nid(slab));
> +			spin_lock_irqsave(&n->list_lock, flags);
> +		}
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +	}
> +
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> +	return allocated;
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -4909,21 +5062,6 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
>  	return object;
>  }
>  
> -/*
> - * If the object has been wiped upon free, make sure it's fully initialized by
> - * zeroing out freelist pointer.
> - *
> - * Note that we also wipe custom freelist pointers.
> - */
> -static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> -						   void *obj)
> -{
> -	if (unlikely(slab_want_init_on_free(s)) && obj &&
> -	    !freeptr_outside_object(s))
> -		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
> -			0, sizeof(void *));
> -}
> -
>  static __fastpath_inline
>  struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>  {
> @@ -5384,6 +5522,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>  	return ret;
>  }
>  
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +				   size_t size, void **p);
> +
>  /*
>   * returns a sheaf that has at least the requested size
>   * when prefilling is needed, do so with given gfp flags
> @@ -7484,6 +7625,116 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  }
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max)
> +{
> +	struct partial_bulk_context pc;
> +	struct slab *slab, *slab2;
> +	unsigned int refilled = 0;
> +	unsigned long flags;
> +	void *object;
> +	int node;
> +
> +	pc.flags = gfp;
> +	pc.min_objects = min;
> +	pc.max_objects = max;
> +
> +	node = numa_mem_id();
> +
> +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +		return 0;
> +
> +	/* TODO: consider also other nodes? */
> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +		goto new_slab;
> +
> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +		list_del(&slab->slab_list);
> +
> +		object = get_freelist_nofreeze(s, slab);
> +
> +		while (object && refilled < max) {
> +			p[refilled] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +			refilled++;
> +		}
> +
> +		/*
> +		 * Freelist had more objects than we can accommodate, we need to
> +		 * free them back. We can treat it like a detached freelist, just
> +		 * need to find the tail object.
> +		 */
> +		if (unlikely(object)) {
> +			void *head = object;
> +			void *tail;
> +			int cnt = 0;
> +
> +			do {
> +				tail = object;
> +				cnt++;
> +				object = get_freepointer(s, object);
> +			} while (object);
> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		}
> +
> +		if (refilled >= max)
> +			break;
> +	}
> +
> +	if (unlikely(!list_empty(&pc.slabs))) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +
> +		spin_lock_irqsave(&n->list_lock, flags);
> +
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> +				continue;
> +
> +			list_del(&slab->slab_list);
> +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		}
> +
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +		/* any slabs left are completely free and for discard */
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			list_del(&slab->slab_list);
> +			discard_slab(s, slab);
> +		}
> +	}
> +
> +
> +	if (likely(refilled >= min))
> +		goto out;
> +
> +new_slab:
> +
> +	slab = new_slab(s, pc.flags, node);
> +	if (!slab)
> +		goto out;
> +
> +	stat(s, ALLOC_SLAB);
> +
> +	/*
> +	 * TODO: possible optimization - if we know we will consume the whole
> +	 * slab we might skip creating the freelist?
> +	 */
> +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> +					/* allow_spin = */ true);
> +
> +	if (refilled < min)
> +		goto new_slab;
> +out:
> +
> +	return refilled;
> +}
> +
>  static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  			    void **p)
> 
> -- 
> 2.52.0
> 

