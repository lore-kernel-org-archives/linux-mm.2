Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F370DCD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF5126B0092; Thu, 18 Jun 2026 11:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCC96B0093; Thu, 18 Jun 2026 11:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3906B0095; Thu, 18 Jun 2026 11:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977C26B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:22:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23AEC1C051B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:22:22 +0000 (UTC)
X-FDA: 84893399724.01.0A34E4C
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4D39D40017
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:22:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdh7NdOu;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781796140;
	b=5D5DK3VdrhpR+ruy52UhEMcVbcqvyCMQAYj4YrnuWhKsChv60hxRCEZe5b74KgLN+PMbIF
	MJI3tn1pGkr7H3IqwMY0sfV58mT3jK7puAdjAVMer3ADQ0P20+siQTkKUphmpZfhWKIY2Z
	fY9ictHebI21NTwsIzM8m2hpktGyJv8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdh7NdOu;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781796140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPnF9ie3GWjL02NStVwtdTUxsTUElaL+pC+C/sA2hk8=;
	b=OA4I/gHgy4mYuN13xq2XMG8s8+5okvU2jd9g40J0hn/3lviflOYUw82q2Xyv3vx9+BUPea
	O3KmiWrhjRd5INQCiHcf32vIhj9a3MgGvUQfvk3HiqGxhA0ZV+eOj7BbXBf5O+B5NxyzwL
	A5KG9MjkOSHq0acOp5SZNeXpKGkJsww=
Date: Thu, 18 Jun 2026 23:21:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781796138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPnF9ie3GWjL02NStVwtdTUxsTUElaL+pC+C/sA2hk8=;
	b=xdh7NdOu/tRjnJz9YQ8g2oGsRsA3yrNpsKLJz5LZDvOwlLTsbkuh37pzim51iPz2sfz+uH
	I8qoUs1l+2Migi7fW4rZ7TzuWhhnVp5dSqLasjbuvFCa5LRuJWwQQwdmohk46yppJRzh2j
	A31lwqxFrVQHdf3pk0SKGPZi7u+d2kk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org, harry@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
Message-ID: <ajQMZ4SCdnWY0Hp3@fedora>
References: <20260618100913.346636-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618100913.346636-1-hao.li@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x9zssj8ynhqnzg13wwyycjrua8diarrx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D39D40017
X-HE-Tag: 1781796140-54997
X-HE-Meta: U2FsdGVkX1/lAbUjq81IGZ59wVFs2AfKBzb2ahi1f8UAeWVSN1FKZqnK0ixmywtt3UhtDzloIrPSLJvyTAtVuP1GogBqml1ZlVtK9fQyju15LKO/bOQ81NCyfORLKdYghILPyZRwnW6FhCJRRiPdQOzH2ITeUBd/y4ftm2eiYFMLyTHiShf3Zc+l0HgZXrDNsaPh0bTegjCVm02VkpbWLc/Oytn3WwYu/3nJp/CS+TOQa5B2avI/6G7kK24NPJ3h4uC2qbip9XwkiEyIvUrSzbQnpHd/PU5rpyjZGS+sAHvN6vOoxVGGPiTgAVApyoSHBUcTXSDA9lGo8/lzSRZU+lqD+AE26yIT0vubCdyCmZZqyZn/yENc+wLtWBv0GdPTRUwxTttsAkilfUx+8xhSg6SPady7C5aP5+smo0TM2Kgr14BPRUJh9mlRqNP8v0YnG28/XaHjYqmZkE8HP7oY8Uh0NjoQD6l7dSaHYq+hJcfos8zOfK4SnfMstglhf4W4EkutvW1Mc1/KznM0ZKq/d4b7U/I5qhQjQ82ilv1eT++DMHXplqOHZkvl1QwHQStJ82rMMkgEsiLrQpTTnCYyH1Hv+1RkmIlwat+PDviD1OAtO7dw4UaTiTCWtDqBizKEyoNxnzWZkimSj9OK0r4F6ac9jlyOgXsVmxzziQTT+koT1erhCEg1rarH8pc7MnPhIYavu7QcSoR1LV8jbNJc4BFqHL4ifiMPc6zA3XAfN/5cGL5Q+Bx6Vqs7NiywWka3EtCEMmd0hNdZ+DSiV5Qo8aSwZhReZ0JqNm9daQbnDGqegzv59d6cPpoXQHb23SqFlP0LnRRJMxDdFUUCTLwYnz0mP7YVT16TphrnpxXv+Qn+tCBUjNvyGN7RCGSzfk/poxO5UTggtTcVCpa4gJmn1uwZZqAA9lDIe4QPSTeJgk496VgNhl4xza1/78GZ4gcQ8kw3p+1KYp+KRbx4Y6+
 QARqmRZf
 GmlphsTG8VwpL8A86nMKvQ5bNJRIyAz3AcdW8KF09k+coMtrdNaHuvbPQoRqFeNLRf12LdKjEqnC5oqPSnScc95TkbcIl0ngR0rDjWsaTBdHbKZ3PVOOpZHnv3u7BKgRPQGU65iC0fh8BAGx1b18JObwH+MaRFmf9mhd4smBbyjUjZVEbtXs7SaJpyO6BnUU1kpqDQSyYaeC/s1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 06:08:52PM +0800, Hao Li wrote:
> Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> NUMA policy independently. Since they are called consecutively in paths
> like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> redundant computations.
> 
> Introduce a helper function to resolve the NUMA policy once, eliminating
> the duplicated code and reducing execution overhead.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>  mm/slub.c | 72 ++++++++++++++++++++++---------------------------------
>  1 file changed, 29 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 62e9cd46916f..45e9f379b7da 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4523,32 +4523,36 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	return object;
>  }
>  
> +static __always_inline int apply_numa_policy(int node)
> +{
> +#ifdef CONFIG_NUMA
> +	if (static_branch_unlikely(&strict_numa) &&
> +			node == NUMA_NO_NODE) {
> +
> +		struct mempolicy *mpol = current->mempolicy;
> +
> +		if (mpol) {
> +			/*
> +			 * Special BIND rule support. If the local node
> +			 * is in permitted set then do not redirect
> +			 * to a particular node.
> +			 * Otherwise we apply the memory policy to get
> +			 * the node we need to allocate on.
> +			 */
> +			if (mpol->mode != MPOL_BIND ||
> +					!node_isset(numa_mem_id(), mpol->nodes))
> +				node = mempolicy_slab_node();
> +		}
> +	}
> +#endif
> +	return node;
> +}
> +
>  static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
>  			       const struct slab_alloc_context *ac)
>  {
>  	void *object;
>  
> -#ifdef CONFIG_NUMA
> -	if (static_branch_unlikely(&strict_numa) &&
> -			node == NUMA_NO_NODE) {
> -
> -		struct mempolicy *mpol = current->mempolicy;
> -
> -		if (mpol) {
> -			/*
> -			 * Special BIND rule support. If the local node
> -			 * is in permitted set then do not redirect
> -			 * to a particular node.
> -			 * Otherwise we apply the memory policy to get
> -			 * the node we need to allocate on.
> -			 */
> -			if (mpol->mode != MPOL_BIND ||
> -					!node_isset(numa_mem_id(), mpol->nodes))
> -				node = mempolicy_slab_node();
> -		}
> -	}
> -#endif
> -
>  	object = ___slab_alloc(s, gfpflags, node, ac);
>  
>  	return object;

oh!, __slab_alloc_node is almost an empty wrapper
Maybe I need to eliminate it completely...

> @@ -4756,28 +4760,6 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags,
>  	bool node_requested;
>  	void *object;
>  
> -#ifdef CONFIG_NUMA
> -	if (static_branch_unlikely(&strict_numa) &&
> -			 node == NUMA_NO_NODE) {
> -
> -		struct mempolicy *mpol = current->mempolicy;
> -
> -		if (mpol) {
> -			/*
> -			 * Special BIND rule support. If the local node
> -			 * is in permitted set then do not redirect
> -			 * to a particular node.
> -			 * Otherwise we apply the memory policy to get
> -			 * the node we need to allocate on.
> -			 */
> -			if (mpol->mode != MPOL_BIND ||
> -					!node_isset(numa_mem_id(), mpol->nodes))
> -
> -				node = mempolicy_slab_node();
> -		}
> -	}
> -#endif
> -
>  	node_requested = IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE;
>  
>  	/*
> @@ -4927,6 +4909,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
>  	if (unlikely(object))
>  		goto out;
>  
> +	node = apply_numa_policy(node);
> +
>  	object = alloc_from_pcs(s, gfpflags, ac->alloc_flags, node);
>  
>  	if (unlikely(!object))
> @@ -5430,6 +5414,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  		 */
>  		return NULL;
>  
> +	node = apply_numa_policy(node);
> +
>  	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
>  	if (ret)
>  		goto success;
> -- 
> 2.54.0
> 

