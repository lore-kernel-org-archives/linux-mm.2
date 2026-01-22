Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D68C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 04:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D46C6B00D8; Wed, 21 Jan 2026 23:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082756B00D9; Wed, 21 Jan 2026 23:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6A36B00DA; Wed, 21 Jan 2026 23:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D9A956B00D8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:59:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B8871DDE99
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:59:09 +0000 (UTC)
X-FDA: 84358395618.19.7817849
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id 964F81C0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:59:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ibmzka49;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769057948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdpaA1zGTiovVE63EwimqyFpitVdOAF+4rwOeZdtVJc=;
	b=yyU2Th5MxyitCzuuwk40wZeBcS3yDIQNy2b12cKVLuOFEVMN1PcdbZW/PV9J2fFAVTq1DH
	MM1xth9in8TTe9x0CiSJZeev7DgbUgJNU+Yf2q8lj03k1GGK8yaRhV/9bQO8KysiwUp1Tn
	HKTJB3vqbcpruYukNDlS/ObO5P7IbLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769057948; a=rsa-sha256;
	cv=none;
	b=5zgx2xkQmQ9v3W4NnbW3BontTkifD3bx/T+uCsYSc9I+NkCZOIBsZyeOnCtk/vLpTDOlbz
	t/fJ3wiSBBxUhRfnxEEk3aKaZD0xzPwlPpWIlDe9da03dlI2IOWLJno8nsZ+GfarkEfHPG
	PDjtBA8Yj9e/hD6QU1n+Y2cJf11OjNE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ibmzka49;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 22 Jan 2026 12:58:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769057945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MdpaA1zGTiovVE63EwimqyFpitVdOAF+4rwOeZdtVJc=;
	b=ibmzka49BLCb+VtqiOWz+F80wMeecNCfysx49eFBGfx1o6zi1Aaj/kQXMCeHsVNXR8kP04
	Lz68Ro2RfH5pjpOPQOK/w/Z8l4grQzLZRCmCcohTVKtswqjQvVnM9PtITTaluXuR3h/tt3
	dRap4bu40onjY+ct2VdHYx6n9zQxT7M=
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
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
Message-ID: <gmpxnzifhxamwnngr6holbcfdd42fvuq2xtqrqvdz75zv6fb57@hxbmcgfxtuko>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 964F81C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kxy98qd3yxjnt4wojzy5xs9gksqb753f
X-HE-Tag: 1769057947-919550
X-HE-Meta: U2FsdGVkX1+iXmo5rGQ5OeGOJemSTPeX7kIADwQDu9Xj6XVDpgPBMHuqAu/LBNZ0YOd22/FoZhs2HAtsKcso3zMwpgp77EFELZQ0Ril1k9gNlyvaaMqHaq9K6mga4BCpC4Gw1/JMUdg7inyvEt+tuYpam3c+Oh82ixwCUW2lN3/2GWNfjfrZuRfA3Wi9t8gOf7CWrPFLwn53GY5FBqKWf3rdaEjS0JcN/KoWx9B4YbFVln6DhB4xMxBPss4q2ImiTWVtVbej61xw86SWQiHjiQZagXFFlrIrPDVE8BN9mZhKnLWvtlWGYfkdbGbMe4MBweKH/y3fgzHZV5eIYnnEtpw6Ae5lQ8GyiZ9vd3FH88rpyY8tgs1dW6kTKxQodRn1UtU7+0w8aiV67DASAuTlkcMrQhwm57f6pciM79mZiJlIJBP24GbpM3mtseKOBzNOj68/H9It7IuR5CBpc+rQ62pn3JG5gpyauEPdI29SbcNZ+Wf9ArbFf9uIwW6AfLmL8EY/I85g3H05Xa94pCmh3KNc5Wxlo7bSxPF4vLmwrbhaVZJP3aPHYhgmFi35s5KwUdIIgYUqSnwChkTVaMwhGnZx8CSB9VjPn8HgS3a9W7U0u5Mv+o9GyiNJTyNOR6AtCMRdrihaGQNsL22vK/y4Q1OE6UTNcC9eUDKH6/OvHVPTsOXZm0FB+sNKFdmBZ1gYxCfaIT/IZZQ9ovQURCpKt4qhT+7hm790ecdIKXH9vWXJcwVtS9jK7h4l82YVYtnMOP1ijkrOrY/gx1SlrByrxPMqPyjCYyj/JWfBUUrwJ8e8XCVjiEm0dSaiazO6aPoSltG5vG8nkYdGk8N+p1TzX3VHVonwb6/iCOGUm8ZiLDP2VM2K7goZyf/N8Rrro9xOR3Um//M70/tViYD2zuVaVXz4yHJXkw3wgA7xU9noxF54CB5XUH4gNHrRXzijwknb/2WGVwyX0XQumbeyjQF
 L3GaA1ff
 Foz22loJgaOMgeAw624hJBmn4Q/jeydjz8qcUje15THFRiU5Xa45NXdwUUp/6TPF8jxLBf3tul7KpAxps1fJuX3lJ4/r0Iwaf/jAW5sbjBvRtMvLtJyhti8U5SGtbUFA94FmpH3YQnPrf14TVHj4j+FU2E7oR/xrfo3TXftNqQgg5VBU9kPa89ofD77tlaECRw5Dj8QAJnPqMaBKRokVejabcpz4pcyQPb1wYugD+/HaqmKDLUgMEn8TzEQNvmpo9sUc5gjenB4/wAAo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:37PM +0100, Vlastimil Babka wrote:
> __refill_objects() currently only attempts to get partial slabs from the
> local node and then allocates new slab(s). Expand it to trying also
> other nodes while observing the remote node defrag ratio, similarly to
> get_any_partial().
> 
> This will prevent allocating new slabs on a node while other nodes have
> many free slabs. It does mean sheaves will contain non-local objects in
> that case. Allocations that care about specific node will still be
> served appropriately, but might get a slowpath allocation.
> 
> Like get_any_partial() we do observe cpuset_zone_allowed(), although we
> might be refilling a sheaf that will be then used from a different
> allocation context.
> 
> We can also use the resulting refill_objects() in
> __kmem_cache_alloc_bulk() for non-debug caches. This means
> kmem_cache_alloc_bulk() will get better performance when sheaves are
> exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
> it's compatible with sheaves refill in preferring the local node.
> Its users also have gfp flags that allow spinning, so document that
> as a requirement.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 137 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 106 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d52de6e3c2d5..2c522d2bf547 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2518,8 +2518,8 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  }
>  
>  static unsigned int
> -__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> -		 unsigned int max);
> +refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +	       unsigned int max);
>  
>  static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  			 gfp_t gfp)
> @@ -2530,8 +2530,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  	if (!to_fill)
>  		return 0;
>  
> -	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
> -			to_fill, to_fill);
> +	filled = refill_objects(s, &sheaf->objects[sheaf->size], gfp, to_fill,
> +				to_fill);
>  
>  	sheaf->size += filled;
>  
> @@ -6522,29 +6522,22 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
>  static unsigned int
> -__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> -		 unsigned int max)
> +__refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		      unsigned int max, struct kmem_cache_node *n)
>  {
>  	struct slab *slab, *slab2;
>  	struct partial_context pc;
>  	unsigned int refilled = 0;
>  	unsigned long flags;
>  	void *object;
> -	int node;
>  
>  	pc.flags = gfp;
>  	pc.min_objects = min;
>  	pc.max_objects = max;
>  
> -	node = numa_mem_id();
> -
> -	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +	if (!get_partial_node_bulk(s, n, &pc))
>  		return 0;
>  
> -	/* TODO: consider also other nodes? */
> -	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> -		goto new_slab;
> -
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
>  		list_del(&slab->slab_list);
> @@ -6582,8 +6575,6 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  	}
>  
>  	if (unlikely(!list_empty(&pc.slabs))) {
> -		struct kmem_cache_node *n = get_node(s, node);
> -
>  		spin_lock_irqsave(&n->list_lock, flags);
>  
>  		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> @@ -6605,13 +6596,92 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  		}
>  	}
>  
> +	return refilled;
> +}
>  
> -	if (likely(refilled >= min))
> -		goto out;
> +#ifdef CONFIG_NUMA
> +static unsigned int
> +__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		     unsigned int max, int local_node)


Just a small note: I noticed that the local_node variable is unused. It seems
the intention was to skip local_node in __refill_objects_any(), since it had
already been attempted in __refill_objects_node().

Everything else looks good.

Reviewed-by: Hao Li <hao.li@linux.dev>

> +{
> +	struct zonelist *zonelist;
> +	struct zoneref *z;
> +	struct zone *zone;
> +	enum zone_type highest_zoneidx = gfp_zone(gfp);
> +	unsigned int cpuset_mems_cookie;
> +	unsigned int refilled = 0;
> +
> +	/* see get_any_partial() for the defrag ratio description */
> +	if (!s->remote_node_defrag_ratio ||
> +			get_cycles() % 1024 > s->remote_node_defrag_ratio)
> +		return 0;
> +
> +	do {
> +		cpuset_mems_cookie = read_mems_allowed_begin();
> +		zonelist = node_zonelist(mempolicy_slab_node(), gfp);
> +		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
> +			struct kmem_cache_node *n;
> +			unsigned int r;
> +
> +			n = get_node(s, zone_to_nid(zone));
> +
> +			if (!n || !cpuset_zone_allowed(zone, gfp) ||
> +					n->nr_partial <= s->min_partial)
> +				continue;
> +
> +			r = __refill_objects_node(s, p, gfp, min, max, n);
> +			refilled += r;
> +
> +			if (r >= min) {
> +				/*
> +				 * Don't check read_mems_allowed_retry() here -
> +				 * if mems_allowed was updated in parallel, that
> +				 * was a harmless race between allocation and
> +				 * the cpuset update
> +				 */
> +				return refilled;
> +			}
> +			p += r;
> +			min -= r;
> +			max -= r;
> +		}
> +	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> +	return refilled;
> +}
> +#else
> +static inline unsigned int
> +__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		     unsigned int max, int local_node)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static unsigned int
> +refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +	       unsigned int max)
> +{
> +	int local_node = numa_mem_id();
> +	unsigned int refilled;
> +	struct slab *slab;
> +
> +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +		return 0;
> +
> +	refilled = __refill_objects_node(s, p, gfp, min, max,
> +					 get_node(s, local_node));
> +	if (refilled >= min)
> +		return refilled;
> +
> +	refilled += __refill_objects_any(s, p + refilled, gfp, min - refilled,
> +					 max - refilled, local_node);
> +	if (refilled >= min)
> +		return refilled;
>  
>  new_slab:
>  
> -	slab = new_slab(s, pc.flags, node);
> +	slab = new_slab(s, gfp, local_node);
>  	if (!slab)
>  		goto out;
>  
> @@ -6626,8 +6696,8 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  
>  	if (refilled < min)
>  		goto new_slab;
> -out:
>  
> +out:
>  	return refilled;
>  }
>  
> @@ -6637,18 +6707,20 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  {
>  	int i;
>  
> -	/*
> -	 * TODO: this might be more efficient (if necessary) by reusing
> -	 * __refill_objects()
> -	 */
> -	for (i = 0; i < size; i++) {
> +	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> +		for (i = 0; i < size; i++) {
>  
> -		p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
> -				     s->object_size);
> -		if (unlikely(!p[i]))
> -			goto error;
> +			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
> +					     s->object_size);
> +			if (unlikely(!p[i]))
> +				goto error;
>  
> -		maybe_wipe_obj_freeptr(s, p[i]);
> +			maybe_wipe_obj_freeptr(s, p[i]);
> +		}
> +	} else {
> +		i = refill_objects(s, p, flags, size, size);
> +		if (i < size)
> +			goto error;
>  	}
>  
>  	return i;
> @@ -6659,7 +6731,10 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  
>  }
>  
> -/* Note that interrupts must be enabled when calling this function. */
> +/*
> + * Note that interrupts must be enabled when calling this function and gfp
> + * flags must allow spinning.
> + */
>  int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  				 void **p)
>  {
> 
> -- 
> 2.52.0
> 

