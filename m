Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D3DC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9419E6B0152; Thu, 23 Jul 2026 05:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919EF6B0154; Thu, 23 Jul 2026 05:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831836B0156; Thu, 23 Jul 2026 05:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 520986B0152
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:26:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA7A5803E1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:26:19 +0000 (UTC)
X-FDA: 85019510478.17.889673F
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 342FA120005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:26:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jhf3zLsm;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhK7rXQUKHH1GT74xd7mygtaCtXNtm23NKLc3K1ezuI=;
	b=hS8HG8/kMAZ85vKhqAw52uNca+J5rAhQ2xYrwU2RG3iUx6vLfvKbjJ8fBA3j0LqDQqXybW
	/6FC/1iPxo7qs5fkhKa6CAUPqpX4XjCdMV6gxtEO7FEn6x7eDlw09AwofgbUQmBEE0coHx
	lRlpo4SfYicKffg8TA57a11AFwHgFpA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798778;
	b=HF65h8FznP6cq4fs8Tb/w1LnrdWZSeqlBee09OghhGRTKhsvG0uVoEnniQ/lVTkcJiC4l/
	aV0es3yMkZeFWoX76hAku511//JC1VUiGJgOyUQptLYgxlEVA/cfImWO7yVyCp8FOhE8kD
	ONAsQMkfdMkmAuEs8sVxsG1O+QzcC4Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jhf3zLsm;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 17:25:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784798772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qhK7rXQUKHH1GT74xd7mygtaCtXNtm23NKLc3K1ezuI=;
	b=jhf3zLsmNmHx5T/z3/e1F0Efeg3KhVVXTyV9pmCM6b9jY1iYdRTLQReW0dJClLYjyCkj14
	XH5rszyy97A2JoRQ6WHqB8oGHy0L9n0M5kNGb9MezpXfUPRb8QIHX5/Ju82ag6RMFO+qfV
	iNkAakMIkvIvJ82o8IURiIz1tmXfuHE=
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
Message-ID: <amHbnLLrpOmwmusv@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 342FA120005
X-Stat-Signature: h3ytsow59bj1gfrcxhkrof6u5johcpoq
X-Rspam-User: 
X-HE-Tag: 1784798776-946709
X-HE-Meta: U2FsdGVkX19/uCyiHZ/6YQvw6LpMaddataKalGpdWtMmU466hyyIoTecQ7ACjD01dw+WQu75WtaNA3YLsV7Txib+6/5m379sS9UdSviWMBF+ujnGjW28JjSVGsWgKeZpzQ5xtpu+Pldwf/vOOztBzkl4Up7ZnZNVE5V1tJaQRQMSeTe4qC3/dghxR56EQ2zkefu/1dv8VSlr8mOu6bj9P/U+NFSHDkgQ4TnrFpDGCjBFo4Xspv8By10r2Gv24a6INETOP5cDyxm30UkzBVM5hOYB4YMMmyixnpbybUzGrm+uC7Kg8jzFEZJNYePY/a2mLIkHXHKRUY0rnexyfGu6rMDjsUf0kwfLaZ9Pcgy/4jWppxUoUZLz7bo3Xp4hVdNhq4XOfJRWQ62DfVrgQlPbH4mSeFgaeC7QbeD8xgEAvrG3ttmIJhNdopDrKVlD3uk0mnamVjOQQD9cGgMggpXRNyBhAaqHzIM5vnfjrSyNfkBnUluQEAG2SYFjSVUA0ZeXtLZkJ262QO81IlDER260NK6wt2BbWLvvs6OiqWgHQfF0KLTsMyUMuIAFW2x8eqxUv55bHDUjDdtAKWzb5di+P8fNmkS77J5xjVS1Mypjb9uT/13qPuubacXJUyOLj2Qfg++Eq/U4+LwQgQEo2e9BhNXpx1WUZp/TcdDfIm3k6VfiYmdsDpjTCiR82GrZ3o+zhOhhnupCLF59DWce7LO0d+qg0F+c70UheCeMw1ZxNRhrZbcQswS2G11C53dl9vyS/NR4zdCfPHQp3gKQcVu2ewY45DvOBmT1h7N/AuK6kdbo/97GM35XxNk7jNieLmiXQx96g24mfh7qbXvfVd0ncjzA0dJvnhZosr5r12IyJql9bM44SsdTkf5CDMCM43FBFfID8mz/oU3bpaZHiLFX/72YnVTGXS1wDSFSmSu1XcP8JmhJzV3Ed/mPfP7Jd37kqZRL8lkTUouhdbauOPg
 ZkcbC6Rt
 EtuCSKI9z4gbvKy8PDGK/J7SGI4TKaMpeB3/f2jb8cR8sV0f1WlFFEOMbafzqhWoS26bBYlD62uN2jrsCDvgy1AP0PPj5ikOe9jArdbuZEewcP3Jmmz9eG8hRprKLvJt+jFHfjd75lImyOA70g5pUG99zh5Bo3jxmGWOm5NbAgaWKHHWPz7GG+ZmNhkMou0L2DAlfrFNEpSrogSVlSM7mEzb116lxSI5tgDMx4PYW/46QJhrXUOqIMwU4BMP1tpOwbi0hNV8A4/9zbKvStzzjkkTcPw==
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

if memcg itself is disabled via `cgroup_disable`, mem_cgroup_kmem_disabled()
still return false, so maybe we can use:

if (!mem_cgroup_disabled() && !mem_cgroup_kmem_disabled())
	flags |= SLAB_MAY_ACCOUNT;

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

the same as above

Others look good to me.

Reviewed-by: Hao Li <hao.li@linux.dev>

> +		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
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

