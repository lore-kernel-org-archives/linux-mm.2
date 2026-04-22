Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECF8F94CDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3836B0088; Wed, 22 Apr 2026 03:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6945E6B008A; Wed, 22 Apr 2026 03:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA686B008C; Wed, 22 Apr 2026 03:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4860B6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:10:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBD7B5EF3B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:10:14 +0000 (UTC)
X-FDA: 84685317948.21.FC50AF7
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id E099EC0002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:10:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZnmNDsB;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776841813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRhsyrYmf4lTf1R1VAKnMYDKnyEcNjsJEI8VqdLZF2Q=;
	b=tdPoz9cVaBtKuSpU2+jouztTrY0uyCzw8gIx7tgBS1WNX8fC165VrMyuxckVE7Si0g4APY
	8wY9NHyQU49Gn9OMz9m/abXpMhVDiKHDjBiTxQivqH8ngfHM8dr8YwCKR9qZzUV/G6LOXU
	thPvhyVkwYnonEqLv/J0oiVlOb8r5Wo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZnmNDsB;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776841813; a=rsa-sha256;
	cv=none;
	b=l+QEwr1Ag/lFI6LsNgSLeI4M48EWjaXMGs42RHj7Koc1oamSvG8cygRH+EBtOV7yn2Q8YR
	GzfPlNfrC4EM8hht4JYXO7I0BkcPVLrDAyZmJqrVt9WWGUXF9YbkdhhgSQGEVCtdkswEC+
	GQNMobhrwX7QAcV3EdkCZ3HIzrRfNLw=
Date: Wed, 22 Apr 2026 15:09:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776841810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uRhsyrYmf4lTf1R1VAKnMYDKnyEcNjsJEI8VqdLZF2Q=;
	b=DZnmNDsBn+rqq/iiPc9ITWwRxy2uZxfjO46kSc2JLsxZmpBxx12wk2qSzThfhbvWpT6I30
	J1eHBPDa/9FS82+HnPVRJDCiy6rjTk6xStzcsv9kRQJVf6Dd/qLYT2yMQ4bXqNN7PWES4P
	iQOGjM4rnuixeCfULl0zMeSzTrhnJHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	hu.shengming@zte.com.cn, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH RFC] mm, slab: add an optimistic
 __slab_try_return_freelist()
Message-ID: <qfxtirtpoxcuzhnohm7cbo62z3ob3tiknlss6xenjlrjossmpu@pp4wwry3jad4>
References: <20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dtrk5jz5rdq3urxtq93escsoouffc66k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E099EC0002
X-HE-Tag: 1776841812-817503
X-HE-Meta: U2FsdGVkX18qws3xt+Hhe3EarkUpFxqLp8xISE6QOpmsvzGfV8E5IPtoodTEs+ax5P99UlinFkejufR3pc5zhlbD0/dsHNDdQhzkrkMyforFzblobZ6Hd5I4rRq8pGAGjdb//UwxLP4pijK7ykYg6HYSfK19qIKaq8NvZV4YhSWOweXggllg9jWO7O9LBfi8ppH1dUAuLZsFsiBcYcjv4n6Vx7/Gutw8SnsvpdcpAHhmY4oFKyVR+hdH4ExUhsistNFVJpqxhKc+2WvHoot7kMsLcmUmMZXEAMP1UlLKWjp7Lly6X4QMFqLJFOTFVlOf4U/Z/6UYqtpjHufd+7DscZCQUTv5wgFSq7baITh69lqonWm40/z/HKa+/8PkwcjWiqOOTsZdGRRX22OGYbpoU4i4SrEp0QuoVf+NCYl4TKC+O+WCd7UEgbIJOriT0L3jVsP62NosyGnjCjGps5e2ohNAwMFzUsTpZlVi1Yr4cFNRXy3lxd7c38P2qzucrNXxY7VvVLN5kBEDsHUZS86/L2o4JD3a4G0e4iG5PeGhiAPks5O1B+XF1m6jom2kXUpNY80eiUibHYReFCvj7NhjZdPdgO52Kk2k98QGLSj8uaZNm2oQF/qmTHRjqo+OZ6WHehW9vWIvMuawlkUijyEy5S8kbCztMTiRXUIqdlCov7fdMMVsQbKsPivkla3ndob0EOk0WbDRPnvJUykoxPRsRtszQ0nZm9D7b+kMx90zDWsGc6Bm1YLXhK8Fft5BNNr9mY5M0F0gRJwQrGNyDs0zNR0fUSx0VjhUeySHywJghA/pCUVrPVijCfo4v2WpF4/wETsZ2bwknhCrHwE3dfTw785uKcDmm1i6JtTr+Iuqq14cN+vWheshipMo1p84OOEBW3epjToItAkZ9gqrf9SkrFN0BVqoYMloKs+WrJ7KkbzDF3azk5E3+akzH9kCLJXKLAdVwrGiFmjGsI2iPF+
 jtp08myG
 CouY36CQW7Nt92xlHJzPGo+Wt4gosvUudd72CsJpwurOIrcIEvQhPmDPGi7dTvLIaJf4xmbSqihbt0cuv/O6tQO3abFZ5ckYc5Ka9YIUAYB5zWiuUb4xxZdGLRpddjjxmxKcqhRocXTVxLgJqnWUiYfPxDAJiM9UmoDJk1PWdsal3UP4+HhxdWsyH2FEhRykfG15qbNbzngTIRvI5NPQg4hHmIiEx04hxTYnRf7a6Zh6+o1zx8Mmw/p6FkXojbsSqyWUMhKSlYzzBHWSFjDxa+f7wBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 04:49:52PM +0200, Vlastimil Babka (SUSE) wrote:
> When we end up returning extraneous objects during refill to a slab
> where we just did a get_freelist_nofreeze(), it is likely no other CPU
> has freed objects to it meanwhile. We can then reattach the remainder of
> the freelist without having to walk the (potentially cache cold)
> freelist to to find its tail to connect slab->freelist to it.

this approach is clever!

> 
> Add a __slab_try_return_freelist() function that does that. It's a bit
> like __slab_free() but many situations from there cannot occur in this
> specific scenario so it's simpler.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> I've got this idea during the discussions on refill spilling, but not
> sure if I've mentioned it on-list. Anyway it seems like there should be
> no downsides (in theory...) so please test if it indeed improves things
> anywhere and then it could be a better baseline before trying anything
> that comes with tradeoffs?
> 
> I've included SLUB_STAT items that show to me the optimistic path is
> indeed successful, but maybe they don't need to make it in final version
> due to being rather low-level.
> 
> Git version here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/refill-optimistic-return
> 
> It's Linus' upstream few days ago with "mm/slub: defer freelist
> construction until after bulk allocation from a new slab" which is
> heading to 7.2 so also should be considered part of baseline.
> ---
>  mm/slub.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 35b6cd0efc3b..176bc4936d03 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -373,6 +373,8 @@ enum stat_item {
>  	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
>  	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
>  	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
> +	REFILL_RETURN_FAST,
> +	REFILL_RETURN_SLOW,
>  	NR_SLUB_STAT_ITEMS
>  };
>  
> @@ -4323,7 +4325,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
>   * Assumes this is performed only for caches without debugging so we
>   * don't need to worry about adding the slab to the full list.
>   */
> -static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
> +					  unsigned int *count)
>  {
>  	struct freelist_counters old, new;
>  
> @@ -4339,6 +4342,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
>  
>  	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
>  
> +	*count = old.objects - old.inuse;
>  	return old.freelist;
>  }
>  
> @@ -5502,6 +5506,50 @@ static noinline void free_to_partial_list(
>  	}
>  }
>  
> +/*
> + * Try returning a (part of) freelist that we just detached from the slab.
> + * Optimistically assume the slab is still full so we don't need to know
> + * the tail of the freelist. Return to the partial list unconditionally even
> + * if it became empty.
> + *
> + * Fail if the slab isn't full anymore due to a cocurrent free.
> + *
> + * Can be only used for non-debug caches
> + */
> +static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
> +				       void *head, int cnt)
> +{
> +	struct freelist_counters old, new;
> +	struct kmem_cache_node *n = NULL;
> +	unsigned long flags;
> +
> +	old.freelist = slab->freelist;
> +	old.counters = slab->counters;
> +
> +	if (old.freelist)
> +		return false;
> +
> +	new.freelist = head;
> +	new.counters = old.counters;
> +	new.inuse -= cnt;
> +
> +	n = get_node(s, slab_nid(slab));
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +
> +	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist")) {
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +		return false;
> +	}
> +
> +	add_partial(n, slab, ADD_TO_HEAD);
> +	stat(s, FREE_ADD_PARTIAL);
> +
> +	spin_unlock_irqrestore(&n->list_lock, flags);

I was just brainstorming a bit here: what if we only try calling
slab_update_freelist without grabbing the lock or touching the partial list at
all?
Instead, we could just toss the slab right back into pc.slabs. That way,
we can let the downstream logic for handling "leftover slabs" take care of this
slab together. It could save us a whole lock/unlock pair.

> +	stat(s, REFILL_RETURN_FAST);
> +	return true;
> +}
> +
>  /*
>   * Slow path handling. This may still be called frequently since objects
>   * have a longer lifetime than the cpu slabs in most processing loads.
> @@ -7113,34 +7161,40 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
> +		unsigned int count;
> +
>  		list_del(&slab->slab_list);
>  
> -		object = get_freelist_nofreeze(s, slab);
> +		object = get_freelist_nofreeze(s, slab, &count);
>  
> -		while (object && refilled < max) {
> +		while (count && refilled < max) {
>  			p[refilled] = object;
>  			object = get_freepointer(s, object);
>  			maybe_wipe_obj_freeptr(s, p[refilled]);
>  
>  			refilled++;
> +			count--;
>  		}
>  
>  		/*
>  		 * Freelist had more objects than we can accommodate, we need to
> -		 * free them back. We can treat it like a detached freelist, just
> -		 * need to find the tail object.
> +		 * free them back. First we try to be optimistic and assume the
> +		 * slab is stil full since we just detached its freelist.
> +		 * Otherwise we must need to find the tail object.
>  		 */
> -		if (unlikely(object)) {
> +		if (unlikely(count)) {
>  			void *head = object;
>  			void *tail;
> -			int cnt = 0;
> +
> +			if (__slab_try_return_freelist(s, slab, head, count))
> +				break;
>  
>  			do {
>  				tail = object;
> -				cnt++;
>  				object = get_freepointer(s, object);
>  			} while (object);
> -			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +			__slab_free(s, slab, head, tail, count, _RET_IP_);
> +			stat(s, REFILL_RETURN_SLOW);
>  		}
>  
>  		if (refilled >= max)
> @@ -9366,6 +9420,8 @@ STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
>  STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
>  STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
>  STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
> +STAT_ATTR(REFILL_RETURN_FAST, refill_return_fast);
> +STAT_ATTR(REFILL_RETURN_SLOW, refill_return_slow);
>  #endif	/* CONFIG_SLUB_STATS */
>  
>  #ifdef CONFIG_KFENCE
> @@ -9454,6 +9510,8 @@ static const struct attribute *const slab_attrs[] = {
>  	&sheaf_prefill_oversize_attr.attr,
>  	&sheaf_return_fast_attr.attr,
>  	&sheaf_return_slow_attr.attr,
> +	&refill_return_fast_attr.attr,
> +	&refill_return_slow_attr.attr,
>  #endif
>  #ifdef CONFIG_FAILSLAB
>  	&failslab_attr.attr,
> 
> ---
> base-commit: da993c58f9bde299a5e1a4e7900125b32dccd2a6
> change-id: 20260421-b4-refill-optimistic-return-f44d3b74cc49
> 
> Best regards,
> --  
> Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 

-- 
Thanks,
Hao

