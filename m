Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F29FCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA546B0005; Fri, 12 Jun 2026 00:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AB56B0088; Fri, 12 Jun 2026 00:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0A56B009E; Fri, 12 Jun 2026 00:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9946B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:05:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32A7F165A47
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:05:12 +0000 (UTC)
X-FDA: 84869920464.06.C87B6CC
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A6FB8000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:05:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hZG8lZYr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781237110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPSZ+ZJ1Dy/4TtgnmDEs7BipTTu6JauwKDrcxScrmls=;
	b=AhSfmFfT16Zbu4tBHpfUD85jjhFVobJN/g/9U/hMEzxK/L8c4QMsgX0Aue4tr2bbGNCvVr
	4j/A/MptfhUlUR2HwrP50g+R9eNzrkLdUixI/nN9OAD84eXhHf2vLvy8E7zmKFwYKdOQfl
	nn2NkSyOEXD7kTNup4UA7W93etkI3Kc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hZG8lZYr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781237110;
	b=t7kKF+w6KHt1doLIjar1W8YbXgBlssdRp1TGvs2gzagtlWGnDEGIybis7AC8pYfsOUQsVr
	cXVlI4yLhqOAfxeshYWiVpTs9ctJSdQgC+o4OqHFKaCw84i792XeekQhbSwKWomuS6lQ3U
	muG6QrSxhplHyKW5HmC7cw0YtDJi5cc=
Date: Fri, 12 Jun 2026 12:04:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781237106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dPSZ+ZJ1Dy/4TtgnmDEs7BipTTu6JauwKDrcxScrmls=;
	b=hZG8lZYrtItniCX26jc4WxdGTIy7oIO0tf3kSfNkI6V/OyY9l4lLYbb7u3liYzOPJdTb7T
	1b7/KrwS59kuh6Xywzsm3IQH/bttyApqTy7didmkBS86gdayidPajmb2Tkr46iPDvIdAn3
	DN/kmD+cG9dMPF7fPR784SB5czEouhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
Message-ID: <aiuCiXBBB64AfPjI@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A6FB8000C
X-Rspam-User: 
X-Stat-Signature: cpdjkehmmj1jkocykoxwm6yqs6473qym
X-Rspamd-Server: rspam09
X-HE-Tag: 1781237107-836847
X-HE-Meta: U2FsdGVkX1/LQDDguvz5tGrGj3pYdQsEgQ/h93YVOwegdWd7MSE1E7fNVHZmVctuNtNTlYClBbiP7bxH1h8fHVCY9agv/bW3T9UEPGRiBbxigQOxm0KgS2UM1cBqGphxZVYaMnzdd1XL7XdbKnJmSpxwTWcH2uu4k2ADKk8Q/z/De4T9HyX2Ioyey7VgQGOMWAKD+/Pen5Oc9U6UWKf7L4MUccIySKpHNi5skQ2nIx9FxH0aMkeLp1aC+TzUnJQqoZQCOzI4gzobG0CJxBbmY3hLA1NCwdUpFExYZzeH+g+3eXaAzBLu3GcFV9OB/1srW/gYNpdMhNSA5GdV1VmiixIn1HRJ34/WYmAvPrDyBtWuMh0udFsOnCohlhFf3iSmZdZdf84s7rT2lRqv2PFvn7rvmp/RaH9h0eI9idOIiln7DStBuVpz6Fn2i3N+PHkfGla2708pSV16hl1oHwG8uw5xK1kQ8AFH3a+lnOMlumcZkJtFCEqo4wtDC9sT127aDih8xCct8+IyM+ekISg89KjQq4aHaSeMQEdBJZQeqaJhiky34b90qi9lLk1adbe8u6mLVBXtR+6LcJ/AVNPifVqqLlSmSNTiIwMyeFcrArBK2clEv7D6Oc0q5u7FV5g+paWKuH5WopIboVzSzYvkX4g6LqVzp+T4eUzoQ+3AqOCRSB4xiKrybLdTVE4o+lI2w7L55C+9J/WF95X+1qoxfFgjoV+rmA2Sar6TF0Eojixy7FS5QFAA1KLwQBf3gRtg9BuRUDjXfVxwn4HlE9Ud7bZHYuEAZzM49y3i3+3iTmTAciNO+DfsZHAwF+WBgunJ+XZH8vS8hpt4lF2asF+MOceWxhw5i0qUsIsV5nUwbpp/qe7ugf2Y9l53tNm/7953p6oonWDSlSxHh8wE6jZ10LVxDC7HH3lx8NzFrqLqv82E+wJCMGBVE1HNitwY84vjd6uDYbRavf/Fuu9ciA1
 gpd0QeGD
 poF4rp0itZRNQphwe0roh5sLiR1M/uc8kiID0xR2t07AQY6SvouPUw+4/8rQ/G4dXliNORE/fNTnLfEKzPgxtdXyrxHaa/Uo+DG4UDWqB9pTtWRk0dxkCkvNHgTTYyunvthBzRKDK56aeYf43ZsLzA5NQQrPhESNX4KZQS67HW7ffhOxGMLPyjOlcl3c07tnvXMJHBX+fYvv8aXUZIqJfovNOMtF9IXe7CqRqmNft3HtUw7jnD0EAbvuSnnREcUMgP8GVrm2KtJCv1j56CwXYVrmd4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:09PM +0200, Vlastimil Babka (SUSE) wrote:
> Refactor get_from_partial_node(), get_from_any_partial(),
> get_from_partial() and ___slab_alloc().
> 
> Remove struct partial_context, which used to be more substantial but
> shrank as part of the sheaves conversion. Instead pass gfp_flags and
> pointer to the new slab_alloc_context, which together is a superset of
> partial_context.
> 
> This means alloc_flags are now available and we can use them to
> determine if spinning is allowed, further reducing false positive "not
> allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 52 ++++++++++++++++++++++++----------------------------
>  1 file changed, 24 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index ef745b37d063..98b79e5e7679 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -220,12 +220,6 @@ struct slab_alloc_context {
>  	unsigned int alloc_flags;
>  };
>  
> -/* Structure holding parameters for get_from_partial() call chain */
> -struct partial_context {
> -	gfp_t flags;
> -	unsigned int orig_size;
> -};
> -
>  /* Structure holding parameters for get_partial_node_bulk() */
>  struct partial_bulk_context {
>  	gfp_t flags;
> @@ -3826,7 +3820,8 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
>   */
>  static void *get_from_partial_node(struct kmem_cache *s,
>  				   struct kmem_cache_node *n,
> -				   struct partial_context *pc)
> +				   gfp_t gfp_flags,
> +				   struct slab_alloc_context *ac)
>  {
>  	struct slab *slab, *slab2;
>  	unsigned long flags;
> @@ -3841,7 +3836,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
>  	if (!n || !n->nr_partial)
>  		return NULL;
>  
> -	if (gfpflags_allow_spinning(pc->flags))
> +	if (alloc_flags_allow_spinning(ac->alloc_flags))
>  		spin_lock_irqsave(&n->list_lock, flags);
>  	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>  		return NULL;
> @@ -3849,12 +3844,12 @@ static void *get_from_partial_node(struct kmem_cache *s,
>  
>  		struct freelist_counters old, new;
>  
> -		if (!pfmemalloc_match(slab, pc->flags))
> +		if (!pfmemalloc_match(slab, gfp_flags))
>  			continue;
>  
>  		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>  			object = alloc_single_from_partial(s, n, slab,
> -							pc->orig_size);
> +							ac->orig_size);
>  			if (object)
>  				break;
>  			continue;
> @@ -3888,15 +3883,16 @@ static void *get_from_partial_node(struct kmem_cache *s,
>  /*
>   * Get an object from somewhere. Search in increasing NUMA distances.
>   */
> -static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *pc)
> +static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
> +				  struct slab_alloc_context *ac)
>  {
>  #ifdef CONFIG_NUMA
>  	struct zonelist *zonelist;
>  	struct zoneref *z;
>  	struct zone *zone;
> -	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
> +	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
>  	unsigned int cpuset_mems_cookie;
> -	bool allow_spin = gfpflags_allow_spinning(pc->flags);
> +	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
>  
>  	/*
>  	 * The defrag ratio allows a configuration of the tradeoffs between
> @@ -3930,16 +3926,17 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  		if (allow_spin)
>  			cpuset_mems_cookie = read_mems_allowed_begin();
>  
> -		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
> +		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
>  		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
>  			struct kmem_cache_node *n;
>  
>  			n = get_node(s, zone_to_nid(zone));
>  
> -			if (n && cpuset_zone_allowed(zone, pc->flags) &&
> +			if (n && cpuset_zone_allowed(zone, gfp_flags) &&
>  					n->nr_partial > s->min_partial) {
>  
> -				void *object = get_from_partial_node(s, n, pc);
> +				void *object = get_from_partial_node(s, n,
> +								gfp_flags, ac);
>  
>  				if (object) {
>  					/*
> @@ -3961,8 +3958,8 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  /*
>   * Get an object from a partial slab
>   */
> -static void *get_from_partial(struct kmem_cache *s, int node,
> -			      struct partial_context *pc)
> +static void *get_from_partial(struct kmem_cache *s, int node, gfp_t flags,
> +			      struct slab_alloc_context *ac)
>  {
>  	int searchnode = node;
>  	void *object;
> @@ -3970,11 +3967,11 @@ static void *get_from_partial(struct kmem_cache *s, int node,
>  	if (node == NUMA_NO_NODE)
>  		searchnode = numa_mem_id();
>  
> -	object = get_from_partial_node(s, get_node(s, searchnode), pc);
> -	if (object || (node != NUMA_NO_NODE && (pc->flags & __GFP_THISNODE)))
> +	object = get_from_partial_node(s, get_node(s, searchnode), flags, ac);
> +	if (object || (node != NUMA_NO_NODE && (flags & __GFP_THISNODE)))
>  		return object;
>  
> -	return get_from_any_partial(s, pc);
> +	return get_from_any_partial(s, flags, ac);
>  }
>  
>  static bool has_pcs_used(int cpu, struct kmem_cache *s)
> @@ -4454,16 +4451,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  			   struct slab_alloc_context *ac)
>  {
>  	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> +	gfp_t trynode_flags;
>  	void *object;
>  	struct slab *slab;
> -	struct partial_context pc;
>  	bool try_thisnode = true;
>  
>  	stat(s, ALLOC_SLOWPATH);
>  
>  new_objects:
>  
> -	pc.flags = gfpflags;
> +	trynode_flags = gfpflags;
>  	/*
>  	 * When a preferred node is indicated but no __GFP_THISNODE
>  	 *
> @@ -4479,17 +4476,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  		     && try_thisnode)) {
>  		if (unlikely(!allow_spin))
>  			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
> -			pc.flags = gfpflags | __GFP_THISNODE;
> +			trynode_flags = gfpflags | __GFP_THISNODE;
>  		else
> -			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
> +			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;

nit: the comment "__GFP_THISNODE in pc.flags" also needs to be updated to "trynode_flags"

otherwise, looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

