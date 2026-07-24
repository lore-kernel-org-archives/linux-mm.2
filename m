Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DF2C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3455D6B007B; Fri, 24 Jul 2026 05:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F57B6B0088; Fri, 24 Jul 2026 05:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E926B008A; Fri, 24 Jul 2026 05:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D98CC6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:42:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50432C0326
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:42:04 +0000 (UTC)
X-FDA: 85023178968.16.77F4090
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7E97920003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:42:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XVMPfTgd;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784886122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1750c1eenHXo1TIdu8y/9O1bLDCeeNFo2oetdSlOqMc=;
	b=xWtJbxsAOG3vJdsEo/XwrX2etmw0YVOuiI42OCj9oDYO/ooz0XrzKPzdp/SlWvustGoHvT
	RfVeHKHt0fMYL9EaZO4//jOqHblesKQt6ZoPSzZHKhdl1B0j8dtRedNx0JUGITLjk/xCEJ
	yimLeru1OHsZ3DjnTrEko0R0gJdQIHE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XVMPfTgd;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784886122;
	b=R1QA7EAh8H+aPaYeavgDpOfaFDoudBSxnhREK1r3ZXQv6OEgFoxgMCPXtSmG+oaW2NO2o7
	LO19Lwwjj3rAz9z39oQlwmAmEQLcJu3vItnrRn7BoxmoFKt1ozHcE1qOz80n3HO3iKpSDB
	5BAAqx2vWACjQUpQZE/3ViRwHM/IzWs=
Date: Fri, 24 Jul 2026 17:41:32 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784886120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1750c1eenHXo1TIdu8y/9O1bLDCeeNFo2oetdSlOqMc=;
	b=XVMPfTgd4n6vEJPoJbULi1+7Zz7Ql9gOYYRxTaZpLm5MpL974cNHbvg8b8o7RnQY25b7/v
	GV2s580tPnfaHFx8FKnLKQ3pCJXVbCAd2yf5LhInwuSzVnXByJ2whLadQj+jTI5/5hYt4a
	m4NjtFDdDs+KM6vZMZYA8xziwAl55Os=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <amMt7baftCrU-OJq@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E97920003
X-Stat-Signature: qqnj3uh8mq6ykhy6z5ng8diac1cgh6qd
X-HE-Tag: 1784886122-623759
X-HE-Meta: U2FsdGVkX1/2cVRTUEdQkIF5VG1tiRhHFpXLMfhWAEl9yt0j4HdhF4MtG8sJPH60Grbbdo0x0T+jTj9U+5U1hmTcXnPoO577vIlF1dTAMfhq82z/LV2bYY3CIbKw5uWtimYBuS2+2bloyu8T7FfkTNnvtKxp045ateXUp9IQJcF41yrRInGld2Rkky8PbEBxsR8Nb2bnoV28iHpXO++++8FdImnmvd9Vev/yoRR3y61xoefroQdvj+usXU4HxI02bE2tlYMMqghzYe05O45YmFvsaGZ+TRnX5tA9iPeDXOAP8Cehynf8ELBjOj3hCY+niD0wc3/Z2+vwx62xbGlBYfM5ZNX5FgQLkg156nKFXAxpk4EurdlQfnkFiKf1BxnoPmmFTvyEq9ysuDQNdGD3MOri15OQbWDI5AYVxUoQp8t246QeUAQBTnXFHM8BSLFTLMUHYH43U7wOgBe7uj0MBkjjyxXvOqirqVZC+PsvYrsB/gW5uTMPoTt2i1diFBTexDUXWGKQTCTeMp2KeCLp6oUKOYJHCqfHPJkqVOXnCoRajixuWDTB7vbKNZkx+9lvEucQOlK7jpau42UTDC0TYknGXQRVSihCXRbwHbBTD3x5OAd0rJtLR85knTo9l5WMsewJs4h4bOqQs/vq8+C37YHEIXiMAI+RHxQzlToJpYVRILcZTDUPnL6iC8rlnIOoIys2paXfBW/G6HIJxJLvvSwj9n+6Wlu4RU80SUh5qvgtG6OR6E7bUkQUtLzqHIavq9S4oViAeO0cq1x+zDthr4nQCKCGX/xnoV/tltCEai43mw3UE9IhQEcTcND1zBD+ZxKvs5Dbc0SWbKetBBmp9pI+N8xvivwTroYJRG+3U9cGjaAW+DaGLX1SKY0hdqObnEA5Q/hB7zpZrDlpDAub4vXY1NJJ3TqB+eQAodUnScWGMrPrcFE7PZMXvFHrNzUuMx/vaJtgpKlzICqsnwJ
 NIH7GxcR
 cpXKbH48ecn0RjEEdGYbgaeT2zQjBw2p1YyV+5xN0USxxcdo9fY4mayGxxgHBzB6PysTmY2yJ3lgypxLcBVlyJrRKOLnN7EkHOIdcO0B26SXdUnz5M1tsdVM0Ykiesa6ssDft/CQoHV+MaIj0O/6gVojGGY4S01QqVYMbO/S/n/u2syQNUfPQXFdLCgrhCLKjp1GYmI/K8UyNB0YaPQ3fWHQO2a6fmdleNx4QMFj+jLA/3k2QqGhke2Ed+b2L78hfwH+jKXffebwXwKUDI6VwQM7lzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
> Slabs of some caches never need the objcg part of struct slabobj_ext.
> Introduce helpers to query this for a cache or a slab.
> 
> Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and only
> is_kmalloc_normal() caches don't have the flag.

it seems this could be "only type == KMALLOC_NORMAL caches don't have this
flag".

> 
> For named caches we currently can't derive SLAB_MAY_ACCOUNT from
> SLAB_ACCOUNT because some caches might be created without SLAB_ACCOUNT
> and then used both with and without __GFP_ACCOUNT concurrently,
> allocating obj_ext arrays on demand. So just add the SLAB_MAY_ACCOUNT
> to all kmem caches, unless kmem accounting is disabled.
> 
> This can be improved later by finding out all caches used with
> __GFP_ACCOUNT, adding the SLAB_MAY_ACCOUNT flag to them explicitly and
> then ignoring __GFP_ACCOUNT for all other caches (with possible
> warning).
> 
> To make the evaluation of slab_needs_objcg() faster in the allocation
> and free fast paths, add a obj_exts_needs_objcg flag into slab itself.
> This optimization is only available on 64bit architectures where free
> bits are available for the flag.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/slab.h |  3 +++
>  mm/kfence/core.c     |  3 +++
>  mm/slab.h            | 31 +++++++++++++++++++++++++++++--
>  mm/slab_common.c     | 25 ++++++++++++++++++++-----
>  mm/slub.c            |  6 +++++-
>  5 files changed, 60 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 3a14df50766a..f9132902c5a6 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -45,6 +45,7 @@ enum _slab_flag_bits {
>  #endif
>  #ifdef CONFIG_MEMCG
>  	_SLAB_ACCOUNT,
> +	_SLAB_MAY_ACCOUNT,
>  #endif
>  #ifdef CONFIG_KASAN_GENERIC
>  	_SLAB_KASAN,
> @@ -204,8 +205,10 @@ enum _slab_flag_bits {
>   */
>  #ifdef CONFIG_MEMCG
>  # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
> +# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
>  #else
>  # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
> +# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
>  #endif
>  
>  #ifdef CONFIG_KASAN_GENERIC
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 05b5482c8150..897ecf2594fb 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -640,6 +640,9 @@ static unsigned long kfence_init_pool(void)
>  		struct slab *slab = page_slab(page);
>  		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
>  				 MEMCG_DATA_OBJEXTS;
> +#ifdef CONFIG_64BIT
> +		slab->obj_exts_needs_objcg = 1;
> +#endif
>  #endif
>  	}
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index c5f37a46434e..65b44902c06e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -81,10 +81,11 @@ struct freelist_counters {
>  #ifdef CONFIG_64BIT
>  					/*
>  					 * Some optimizations use free bits in 'counters' field
> -					 * to save memory. If these free bits are not available,
> -					 * such optimizations are disabled.
> +					 * to save memory or CPU. If these free bits are not
> +					 * available, such optimizations are disabled.
>  					 */
>  					unsigned obj_exts_in_object:1;
> +					unsigned obj_exts_needs_objcg:1;
>  #endif
>  				};
>  			};
> @@ -584,6 +585,32 @@ static inline bool slab_obj_ext_has_codetag(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_MEMCG
> +static inline bool cache_needs_objcg(struct kmem_cache *cache)
> +{
> +	return (cache->flags & SLAB_MAY_ACCOUNT);
> +}
> +
> +static inline bool slab_needs_objcg(struct slab *slab)
> +{
> +#ifdef CONFIG_64BIT
> +	return slab->obj_exts_needs_objcg;
> +#else
> +	return cache_needs_objcg(slab->slab_cache);
> +#endif
> +}
> +#else
> +static inline bool cache_needs_objcg(struct kmem_cache *cache)
> +{
> +	return false;
> +}
> +
> +static inline bool slab_needs_objcg(struct slab *slab)
> +{
> +	return false;
> +}
> +#endif
> +
>  static inline size_t cache_obj_ext_size(struct kmem_cache *s)
>  {
>  	size_t sz = 0;
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 03ecac12cd86..4e983e250338 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -52,7 +52,7 @@ struct kmem_cache *kmem_cache;
>  		SLAB_OBJ_EXT_IN_OBJ)
>  
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
> -			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
> +			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
>  
>  /*
>   * Merge control. If this is set then no merging of slab caches will occur.
> @@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
> +	 * may need to store objcg pointers for objects
> +	 */
> +	if (!mem_cgroup_kmem_disabled())
> +		flags |= SLAB_MAY_ACCOUNT;
> +
>  	/* Fail closed on bad usersize of useroffset values. */
>  	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
>  	    WARN_ON(!args->usersize && args->useroffset) ||
> @@ -984,11 +991,19 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  #endif
>  
>  	/*
> -	 * If CONFIG_MEMCG is enabled, disable cache merging for
> -	 * KMALLOC_NORMAL caches.
> +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and  not
> +	 * aliased with any other type, make sure it's never merged with any other
> +	 * cache.
> +	 *
> +	 * In other cases the kmalloc cache may end up being used for a
> +	 * __GFP_ACCOUNT allocation so mark it as such
>  	 */
> -	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
> -		flags |= SLAB_NO_MERGE;
> +	if (!mem_cgroup_kmem_disabled()) {
> +		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)

With only those checks, the dedicated KMALLOC_NO_OBJ_EXT cache will also have
the SLAB_MAY_ACCOUNT flag, which might be a bit misleading. is it worth
explicitly excluding SLAB_MAY_ACCOUNT for dedicated KMALLOC_NO_OBJ_EXT cache?

> +			flags |= SLAB_NO_MERGE;
> +		else
> +			flags |= SLAB_MAY_ACCOUNT;
> +	}
>  
>  	if (minalign > ARCH_KMALLOC_MINALIGN) {
>  		aligned_size = ALIGN(aligned_size, minalign);
> diff --git a/mm/slub.c b/mm/slub.c
> index d78d3e50c877..30435e2509ea 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2557,7 +2557,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>  	 * of slab_obj_exts being allocated from the same slab and thus the slab
>  	 * becoming effectively unfreeable.
>  	 */
> -	if (is_kmalloc_normal(s))
> +	if (!cache_needs_objcg(s))
>  		return true;
>  
>  	/* Ignore already charged objects. */
> @@ -3435,6 +3435,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
>  
>  	slab->objects = oo_objects(oo);
>  
> +#ifdef CONFIG_64BIT
> +	if (cache_needs_objcg(s))
> +		slab->obj_exts_needs_objcg = 1;
> +#endif
>  	slab->slab_cache = s;
>  
>  	kasan_poison_slab(slab);
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao

