Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C58D778B1
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 00:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576F56B0005; Sun, 25 Jan 2026 19:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E116B0088; Sun, 25 Jan 2026 19:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45ABA6B0089; Sun, 25 Jan 2026 19:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324B76B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 19:51:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE687C229B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:51:27 +0000 (UTC)
X-FDA: 84372286614.05.9BB69B3
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id D434E1A0003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:51:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bFK+0C+5;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769388686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZMWMY+mIk/ZareEAhb040770CIAQtwMX6nJgk+aGIU=;
	b=Dr25ieA6gExArEFpaXvPf6iQ42haIjtmc5KzFQAxs6azrBCj7G9m6CUDDgb94Kwaqree0y
	m+rMZeUSoH2emj+MoW+9CKUMp0A9MoPXcRwvZKH9cCDyHm7QIJRgJphA5SYJOwHXjNzNeq
	rA4aftl5JdB5Q8TM/1uy+y2bycsarMo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bFK+0C+5;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769388686; a=rsa-sha256;
	cv=none;
	b=zRoLqtt1alBXZkzJCNGxk0dQHs9xfIqSRPqzcZXvJ0ztz051JuoFfieEWp4sqp/Z2CkXDW
	5wFIqvFlkFbTEu6hFGDPyVIlhxEbrFdXfFWh94Pn8Azd+Pz5QIKQVPF3T0YOhApyC9O40m
	ag0ZEaYePn+//vo8aBl1f9RCHAw6elU=
Date: Mon, 26 Jan 2026 08:51:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769388683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZMWMY+mIk/ZareEAhb040770CIAQtwMX6nJgk+aGIU=;
	b=bFK+0C+5whH7UFfoZq2PpP2omZlJpjnJVw3beo5c1GjYSQwSAmvXbbUO0Vqyjhnoh7R+gl
	oTG8DkvXS2jFMZdX1S1N04KpvYEr8TClJJU4t0RN//4AzCu9JigQ4LOx7N/uTsR87osS1B
	L6KVhQVKrWBg/Y+xonW68axjnb/FHug=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org, 
	cl@gentwo.org, rientjes@google.com, surenb@google.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own
 slab
Message-ID: <bbhrcvqbwuvf6l4xwv7ax6w5iwuixaivvuknvlgutnavxyllme@r5zkvsh7mwtw>
References: <20260124104614.9739-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124104614.9739-1-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: zc5goea95i4yrjdtx8rqr7kachbthjox
X-Rspam-User: 
X-Rspamd-Queue-Id: D434E1A0003
X-HE-Tag: 1769388685-27832
X-HE-Meta: U2FsdGVkX1/7ujArIseZhYtZS3jBrKnO9KAK8uxKAEr6vlHQ6PwXbHQSG4dUOs/sIn6osXYBH1FQV0Gt/l7rj/+nBZKLq4EbwyjLCGgQPagp0O4J88+LiGz+VehMw4ab7WWzTw9EERy0MWdlijGfrKWMelCPKLssgYcvRwX89PrZuRdTe9u/5TI5Op0jdNeUirnWhM1sPGG7Ln4hp27Gv2YzCHvRpsYA/X9PkX7oIlQSo3tlV9Wl8cXU1hIxgNsDcAuwZdRNPb3+53acqIpxXm75KZueLhm4XiWDNo0mufuvIvWMc+SpFDtnIrSlFoQrpRzPOyeBp0WkQdIyFzdXx0j8BBsSGjA8socNSyUbGECjRlaeqSQRmmqdKuzsfnKnoA2TVdUb4cJaqm+OIlray2Fk2DEkKJpnjRGOIkeQFglReaQ8lQ7RQJXQ8+vdBOis/dgjUNozJyQkNc7RPl31L1aO8s/sces46SbzePwFYlpSFQJKjd3cr15TVMcTtB3EHIc7W2HXGhueN4Qf40NMsw11YQUt6QS4gLmf39LhyAtVDVlsjRYExMXIYV6sGEG7fEfSs+JnWQybPONBWZlMn+XmfFmfmtSp2MiAvgdGxQiBGjtZdyYSzXg2NcEssr1Js9R9CKPaZhlUYL7L/ns3o4yilAvtayEf2KdpGckXqcgenhG6FDChrAcvOG8MhPmgRcW9xV7cvJULB6s5/TP02RdhZ0mt377K5NsPOfvLo4uhTuE0/ZQMxNVBxY3tOtJIXqDtsNvUSV6YtAiu+2zOssCevvO7GpRfJmC0VTY7RLn/NEBWtfZjukHD3jm1TlH9n+0ilGPVDWBYIIA4S1CkPisW4WrIBLEpp4pe6hcJ81grM8UEqLiN8fWO+WlhLxXSBC2qd70poemFkC9zLy2FISyXrH6QKcZHz1Jj/RzV7JOUaYvwd22sHPT+hPN7NCXF7bWBy/bJa3rfjSu4mNI
 Bywz550m
 HWD8Sqv0vvNi0mhNQcum0wa+62aK0MblKEuXcs4/xwLGjzLVPSZMbNeyZ7UTlSAt1PSRZierphv+SjsGakHPZxagugzjd0IjQ+59omO/e+B/97jUY/RBqzR8Etle730n8rR7Hs+V7evoIPqlY/hj9pvQdw8aGN4BjIhQZHmBRGqeuXc5zkOcWLUomshhIYlgwNtX4+SmMXs+tunQwe5CJS0zYUvO0MfJhskCDw8u9AezRGkZSWk6if0JUQSIoOsh52rerVyGhxxplGBOsblAgEYksCsHScarhlF4XtHv+1ZmiYvZh+ewXQ9RSy2T7m9L+aLZH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:46:14PM +0900, Harry Yoo wrote:
> When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
> can be allocated from the same slab we're allocating the array for.
> This led to obj_exts_in_slab() incorrectly returning true [1],
> although the array is not allocated from wasted space of the slab.

This is indeed a tricky issue to uncover.

> 
> Vlastimil Babka observed that this problem should be fixed even when
> ignoring its incompatibility with obj_exts_in_slab(), because it creates
> slabs that are never freed as there is always at least one allocated
> object.
> 
> To avoid this, use the next kmalloc size or large kmalloc when
> kmalloc_slab() returns the same cache we're allocating the array for.

Nice approach.

> 
> In case of random kmalloc caches, there are multiple kmalloc caches for
> the same size and the cache is selected based on the caller address.
> Because it is fragile to ensure the same caller address is passed to
> kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), fall back
> to (s->object_size + 1) when the sizes are equal.

Good catch on this corner case!

> 
> Note that this doesn't happen when memory allocation profiling is
> disabled, as when the allocation of the array is triggered by memory
> cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
> Cc: stable@vger.kernel.org
> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Looks good to me!
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

> ---
>  mm/slub.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 3ff1c475b0f1..43ddb96c4081 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2104,6 +2104,52 @@ static inline void init_slab_obj_exts(struct slab *slab)
>  	slab->obj_exts = 0;
>  }
>  
> +/*
> + * Calculate the allocation size for slabobj_ext array.
> + *
> + * When memory allocation profiling is enabled, the obj_exts array
> + * could be allocated from the same slab cache it's being allocated for.
> + * This would prevent the slab from ever being freed because it would
> + * always contain at least one allocated object (its own obj_exts array).
> + *
> + * To avoid this, increase the allocation size when we detect the array
> + * would come from the same cache, forcing it to use a different cache.
> + */
> +static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
> +					 struct slab *slab, gfp_t gfp)
> +{
> +	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
> +	struct kmem_cache *obj_exts_cache;
> +
> +	/*
> +	 * slabobj_ext array for KMALLOC_CGROUP allocations
> +	 * are served from KMALLOC_NORMAL caches.
> +	 */
> +	if (!mem_alloc_profiling_enabled())
> +		return sz;
> +
> +	if (sz > KMALLOC_MAX_CACHE_SIZE)
> +		return sz;
> +
> +	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
> +	if (s == obj_exts_cache)
> +		return obj_exts_cache->object_size + 1;
> +
> +	/*
> +	 * Random kmalloc caches have multiple caches per size, and the cache
> +	 * is selected by the caller address. Since caller address may differ
> +	 * between kmalloc_slab() and actual allocation, bump size when both
> +	 * are normal kmalloc caches of same size.
> +	 */
> +	if (IS_ENABLED(CONFIG_RANDOM_KMALLOC_CACHES) &&
> +			is_kmalloc_normal(s) &&
> +			is_kmalloc_normal(obj_exts_cache) &&
> +			(s->object_size == obj_exts_cache->object_size))
> +		return obj_exts_cache->object_size + 1;
> +
> +	return sz;
> +}
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		        gfp_t gfp, bool new_slab)
>  {
> @@ -2112,26 +2158,26 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	unsigned long new_exts;
>  	unsigned long old_exts;
>  	struct slabobj_ext *vec;
> +	size_t sz;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  	/* Prevent recursive extension vector allocation */
>  	gfp |= __GFP_NO_OBJ_EXT;
>  
> +	sz = obj_exts_alloc_size(s, slab, gfp);
> +
>  	/*
>  	 * Note that allow_spin may be false during early boot and its
>  	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
>  	 * architectures with cmpxchg16b, early obj_exts will be missing for
>  	 * very early allocations on those.
>  	 */
> -	if (unlikely(!allow_spin)) {
> -		size_t sz = objects * sizeof(struct slabobj_ext);
> -
> +	if (unlikely(!allow_spin))
>  		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
>  				     slab_nid(slab));
> -	} else {
> -		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
> -				   slab_nid(slab));
> -	}
> +	else
> +		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
> +
>  	if (!vec) {
>  		/*
>  		 * Try to mark vectors which failed to allocate.
> @@ -2145,6 +2191,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		return -ENOMEM;
>  	}
>  
> +	VM_WARN_ON_ONCE(virt_to_slab(vec)->slab_cache == s);
> +
>  	new_exts = (unsigned long)vec;
>  	if (unlikely(!allow_spin))
>  		new_exts |= OBJEXTS_NOSPIN_ALLOC;
> -- 
> 2.43.0
> 

