Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF97CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247796B0005; Thu, 11 Jun 2026 23:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8096B0088; Thu, 11 Jun 2026 23:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DB66B008C; Thu, 11 Jun 2026 23:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039FF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:10:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97A271C363B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:10:14 +0000 (UTC)
X-FDA: 84869781948.16.6E9AA2F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5C41100002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:10:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RIJ2yqw7;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781233813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMkiUvF10XGtojfJrLDBnh6aQ1RB3YPypzDrMb4ByLo=;
	b=XEJuYy2SDZaRBVM1KHs9e7EtZ8wP/k86dOqNXQNl3KHvCLjuXcxH4WSmlwWgNtK/T5VjDz
	8R0wkMQ3uOvH+ivcTjwvfKWEULzMrS9o6zzPLSTU6p0z2I7SJ0GI+VTWTu3WxgFsfkla8c
	zrxlhznBIGpFKr5hzllz9zHKset4p5Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RIJ2yqw7;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781233813;
	b=j0XDGq0RIGRhwGwt2RQSXM+PeSHWvbXxSSnMmLleU30ieuZP80BTLT1jcz0t1v/JBK1pt4
	Pka/2S/rz1guJ+kIyWbvC+eZvA0UQbpp3NfM4FDs1+9bC/aJfTrVUYwgMbsFLmXxU+P+4r
	QYSNaYLFoq8gbSQi03hTOakA3zgY5Is=
Date: Fri, 12 Jun 2026 11:10:01 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781233810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IMkiUvF10XGtojfJrLDBnh6aQ1RB3YPypzDrMb4ByLo=;
	b=RIJ2yqw7C7JmCfkoCrm+79dXdzarL0gHVRsSeKdkHVY50yMmJXibLzdraXpjNnt1T1MD/Q
	3DsdrWIOGKAHBLsFlhF86W3POJqa9ri2gSvT8aLm8k4Gl6IU05wpVLHaaKY6kSft1JvQ0A
	BRwDmFSFA41k3I49MPYpyvGMEz43n6Y=
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
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
Message-ID: <ait21B7kqfT9XhOs@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5C41100002
X-Stat-Signature: z8sg9wzy77opuw35ty48rxr85iddsthd
X-Rspam-User: 
X-HE-Tag: 1781233812-315587
X-HE-Meta: U2FsdGVkX1/tcCJmiLjO8+XW0lI8XdpquqlZUNYYz7/JqgyAJq4hilukg6N38q7Qu9sGOjAIAOQkKNAGrI9Ao27q83xkkkHmmHEPhb0CwvmqlUaru0ewrMCxiGFMbjT2qiaDik+TakjlRrGuykw4Bj1aLis/OoOXTzVectYsKE2nxEt9j2WnQ1QscELhUA0hA9iwDzxlR8M7Cv3ofB+jOzz3SmHp/jh1q+TUAexx1F6ZKc/HpRoBvoXA0X6BCO8mEhkTkb1Twx23T5Xcqx8/9M8teNlBq9Dsu4TC5vnmH8rRxuJqSofLgEz7nz9QE9wb4yTpKFBrYxQkVBP8xeagkzbel1yicc/4H1EvbX3IIbswPEcnpGXa0Gr9MEYAo9A+yy26PB4GGNsmuKAQsBd0TwLDD9TbUXhWZVtCgZklVZAUQLrTA1sx+P07BZSe7YByW3v8GunaOLG3ffSDIj2TlQQ9+KC4DPYCwpYarxrQDLpTntO1VU0nzRcIS885CJQcBepGRBCSHWE/VLAvrcGTlUu11vJl1DFvOr2ye3hCAJajUUp99fWInoC5R7PFCcOpq0lq6qmKWJRT4kPknr9rR4PbuwrKv8fQK8SG1uJg4CeKBsHeicObMNyT9G8AkYCNMwL2+lBnOZv6HKYJLK5k4aDoojnO0BuOrS9OMWFNCMYiK8Ov56ukS5ZEW96KFZxO7NbW07R7orXpxg67Sguma6Ay6twoKcQg70sl5hv1tmdADNo7MBQfjU2ay9AipOsaMlQuTYC9qwEhwgrI/p9ytpR2LsBdBS34SRpPoevluwRGvYXOPbxOAeKoFf5VhJND1UnZGKChC1hRCFzUzv1rUGSlcx90n6V3XldMVpt7oeYtze+wuk+lS0f/EkEykfBNiIIHTzhAuGjpBFl9tX2MJFLqfxrX7SrXDQcCuck2O4M9WiU1Kn+M8dYOQaAI72yWb36gFQE3X2dcUy3GZts
 qysBnZOK
 VMyIek0L6TUuiLkKIL93vr519XcNPj8yFgXm1bTELo177pt0AmhKB/MaFrhpAFNS1widjMVwEDlS1QsOHP5DOyzS/UrA+0qNs5Urf4LN1ie5vYSOKsZEtuonzc3r/GNnWNd6BXXLhmdf4c/wI1dU10/cYkUvuB1PBmyiM4KI7Jlbnq1vOyR1cnnCCzoCLi59VGXIKiYvtIOBBtVZnGSI5tB/iSCwpV8xNDV2fZNPZcfUHG3KMHBijlMlW8osX0Azy/o63+eENEW+Q2PubeOtWPrTN+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:06PM +0200, Vlastimil Babka (SUSE) wrote:
> Similarly to page allocator's struct alloc_context, introduce a helper
> struct to hold a part of the allocation arguments. This will allow
> reducing the number of parameters in many functions of the
> implementation, and extend them easily if needed.
> 
> For now, make it hold the caller address and the originally requested
> allocation size.
> 
> Convert alloc_single_from_new_slab(), __slab_alloc_node() and
> ___slab_alloc(). No functional change intended.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 46 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 7b48c0d38404..a3cac7281cc6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -213,6 +213,12 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
>  static DEFINE_STATIC_KEY_FALSE(strict_numa);
>  #endif
>  
> +/* Structure holding extra parameters for slab allocations */
> +struct slab_alloc_context {
> +	unsigned long caller_addr;
> +	unsigned long orig_size;
> +};
> +
>  /* Structure holding parameters for get_from_partial() call chain */
>  struct partial_context {
>  	gfp_t flags;
> @@ -3687,7 +3693,8 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
>   * and put the slab to the partial (or full) list.
>   */
>  static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> -					int orig_size, bool allow_spin)
> +					struct slab_alloc_context *ac,
> +					bool allow_spin)
>  {
>  	struct kmem_cache_node *n;
>  	struct slab_obj_iter iter;
> @@ -3705,7 +3712,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	/* alloc_debug_processing() always expects a valid freepointer */
>  	set_freepointer(s, object, slab->freelist);
>  
> -	if (!alloc_debug_processing(s, slab, object, orig_size)) {
> +	if (!alloc_debug_processing(s, slab, object, ac->orig_size)) {
>  		/*
>  		 * It's not really expected that this would fail on a
>  		 * freshly allocated slab, but a concurrent memory
> @@ -4443,7 +4450,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>   * slab.
>   */
>  static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
> -			   unsigned long addr, unsigned int orig_size)
> +			   struct slab_alloc_context *ac)
>  {
>  	bool allow_spin = gfpflags_allow_spinning(gfpflags);
>  	void *object;
> @@ -4476,7 +4483,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
>  	}
>  
> -	pc.orig_size = orig_size;
> +	pc.orig_size = ac->orig_size;
>  	object = get_from_partial(s, node, &pc);
>  	if (object)
>  		goto success;
> @@ -4496,7 +4503,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	stat(s, ALLOC_SLAB);
>  
>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> -		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
> +		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
>  
>  		if (likely(object))
>  			goto success;
> @@ -4514,13 +4521,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  success:
>  	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> -		set_track(s, object, TRACK_ALLOC, addr, gfpflags);
> +		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
>  
>  	return object;
>  }
>  
>  static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
> -			       unsigned long addr, size_t orig_size)
> +			       struct slab_alloc_context *ac)
>  {
>  	void *object;
>  
> @@ -4545,7 +4552,7 @@ static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	}
>  #endif
>  
> -	object = ___slab_alloc(s, gfpflags, node, addr, orig_size);
> +	object = ___slab_alloc(s, gfpflags, node, ac);
>  
>  	return object;
>  }
> @@ -4923,8 +4930,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>  
>  	object = alloc_from_pcs(s, gfpflags, node);
>  
> -	if (unlikely(!object))
> -		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
> +	if (unlikely(!object)) {
> +		struct slab_alloc_context ac = {
> +			.caller_addr = addr,
> +			.orig_size = orig_size,
> +		};
> +		object = __slab_alloc_node(s, gfpflags, node, &ac);
> +	}
>  
>  	maybe_wipe_obj_freeptr(s, object);
>  
> @@ -5389,13 +5401,18 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>  	if (ret)
>  		goto success;
>  
> +	struct slab_alloc_context ac = {
> +		.caller_addr = _RET_IP_,
> +		.orig_size = orig_size,
> +	};

It might be better to move this to the beginning of the function, to avoid
patch09 jump to `success` before ac is initialized.

> +
>  	/*
>  	 * Do not call slab_alloc_node(), since trylock mode isn't
>  	 * compatible with slab_pre_alloc_hook/should_failslab and
>  	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
>  	 * and slab_post_alloc_hook() directly.
>  	 */
> -	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
> +	ret = __slab_alloc_node(s, alloc_gfp, node, &ac);
>  
>  	/*
>  	 * It's possible we failed due to trylock as we preempted someone with
> @@ -7237,10 +7254,13 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
>  	int i;
>  
>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> +		struct slab_alloc_context ac = {
> +			.caller_addr = _RET_IP_,
> +			.orig_size = s->object_size,
> +		};
>  		for (i = 0; i < size; i++) {
>  
> -			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
> -					     s->object_size);
> +			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, &ac);
>  			if (unlikely(!p[i]))
>  				goto error;
>  
> 
> -- 
> 2.54.0
> 

