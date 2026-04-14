Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB376F9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D936B0088; Tue, 14 Apr 2026 08:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E416B008A; Tue, 14 Apr 2026 08:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C7D6B0092; Tue, 14 Apr 2026 08:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3ED6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:50:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B975B58651
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:50:54 +0000 (UTC)
X-FDA: 84657146028.03.4C0B454
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1638B40012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:50:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dNRwNfgx;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776171053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lELMV2jyk63cpRVnXaJ4JWLlHAmoowBk4pR60tIOmdE=;
	b=MIy76FhHebpj7aUr2UsKO5YYMCB0Pog+9MVHB95nGcFMDfs5b35hk97wwhBYUdO/vARU7t
	LeO3k1YHACkDO4c9BzpWXIk5wj5maRtkah5+1PyN48kvp8aDlowNqoEFOooKRSQNAHLCmU
	BXhHsEtSrYErO0qD0+BYPDbE+Xaal8k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dNRwNfgx;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776171053; a=rsa-sha256;
	cv=none;
	b=0uC5s9FhK1wEoadc+Kb7c4zEhSdwz2XrV3oewMOkVTa4Ur5kYtrIkcXM8CWTPYMthhFlDy
	y3JUFk0kCunZtSbvmdwGPx7mewXto2QO7AysJp20OMZ1jGe28E59RmDypm2SZC7bhKwsqz
	8+56r6Y6yW8lviI6M3yJzwUYoH0u7wQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BCCD60018;
	Tue, 14 Apr 2026 12:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDC3C19425;
	Tue, 14 Apr 2026 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776171052;
	bh=a9iI19vCq4SRLsBnvUz/Jlni7gRkLa3PiZiap/Z+s4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dNRwNfgxfZ2w23BOvDjQE6ZWJ1j+fQaepPfULlXE6qBiYa/xylTCgqSJ20BMxv7z8
	 aSSBNULOSeJcxJS+uUtRO+Vv+RzUasUEk7gXFkpKpfXZBlRSCwR8ggVRvfoAQ3OaD0
	 HIWHZtNNazWVCA9wiE0U1M8zfAeNGLujPtsoy2PuUv8wJunABZ2pStNN5hQpq0HUds
	 W9recr76fXvpUnLGNTbSmYbDzHrHofu/RJ0IzXaava5TtpaKSvMa/NLlWepMKGZsOj
	 Uep91RkkxkVBLq+6VajXAyK2AN9+UUzEx/7/KrqBD1ItHALAHQzKeNJvNbt6rh+Ues
	 /PtEK+xu8mrZg==
Message-ID: <411f9b29-9b1c-4e2f-a212-f583280a6788@kernel.org>
Date: Tue, 14 Apr 2026 14:50:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
 yang.yang29@zte.com.cn
References: <20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9tkggzodrcrb7c6rwq75o36tyqihyni9
X-Rspamd-Queue-Id: 1638B40012
X-Rspamd-Server: rspam09
X-HE-Tag: 1776171052-885293
X-HE-Meta: U2FsdGVkX1/I0EJeVcQxc2ijivKeZFHVZWMC0gAOq0LON2AFiNpI2ud1o+3fMS2zRRbXC2c0qk8PutbpmdM2kTra2XVxbZ0yMTUbnRK8y9sEV1Eo/q1GhRPM74ggM7YdiLk8vtzLA9u1yyAmgwleo6VQhAg0YHdLg6c6YlY+0VkpC1bJHYsm1Uos71kgBgd0PLuYnpmWA508piMyQFFm8Rs5jps64JsNMk3XZk+P678wRiXFUMVWAbFoxn7Q+nLaHdNZBrJ4WI8GKh+aWHiBPG9ZKE0pkr7BXU5hp75wYAVPQsyRLU/xKqlchYVxu+rwVCezqcOOyzicjSzfA2IMWRqCn1Se6NPAswmzoBIyEwbNRmMapbDa3U4KNCFJtYPdpozsdqyXE3MJlFscAsJesEX9Iao7b5u2mo9FZgBwwFU4byVErSSFpwbmao+30rHp81JnzoeYbCYuMRCJGUBNheUSmhqQ5AXdC92mF7YvXb4DWQEhWRJ17dqIiVGdFAiMPecXX9tzn4Kc9l0pkDiI+bQHfYdke+PHhhSReCdDsyPSF7p40iQeoqmIYK7t8kk7zi0k6xFZvlxtJnIqP7dBzUBxqQ0j/7nu69rObQxciEFH9CAuxvyPAYAQDVNZo8GBT+DvK5Z0MEEl2W+n6wstZ+hHXof54FkJY1UAYAShAbsTkkYhE0pbvG69vifh0ehcidkRF7vDhfOz/9bWC7AE+dHCW8oE641nY8G/FZJhGvpCYQCtA/3hXdTr0hfrJKF5R3Q06+/PJRy3+LTQelp2gGT2VU0Z3bNRVBNmiBGQW/0ufso8roivpEbpFS6atJx9bUCOY0FR0rSCc0o+RxucjIqdkUlXMIrOdY1pqNG24slxytEJPvtHAeqKz3N/idQidsAg0JpyozJ1k+u5co/Vk+kfFY5GklUPU0khUCE2EaEOaYTAZjLHNRPfjQQnHudIuWsFWRfGOuqZ2e9/1Kd
 VqcS1snv
 vHWOcaIJr3bd2uRp22tYGvwrEAYTPOj1daBiT4zDE+RrRqH6JlW7GTE1szvqvUuANkMjykiIg6LXK+w614uvnBnNEJeYLBp/2oXYv78bBiN5NfQ7b1NwnvHp+m3jtFpkEdZWgznKfZO9iAzg/HhSZPxCsXl7IKJMOPPscTESMYNbayWqDas1MaQc1c3KY1i/g0RVf2lfax6pih3H6dT8BymV2B6cmMvHZRs39pDIKz3eMRwxU97JmLpPhGQBXfOi2RzsSWIWRH8DRyYUlrP6yZBgkub2RVDCd6/uwL0yupvuKuqiYq4CD+RxhW7dBQrcrXnFnwFs9y3apG+LDcJUQvmG0tXI8auA5CFVlXUBBype5dzl9ZVXLLSe8bFVqHTh66o0hwrXBgiXrEQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 17:04, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Allocations from a fresh slab can consume all of its objects, and the
> freelist built during slab allocation is discarded immediately as a result.
> 
> Instead of special-casing the whole-slab bulk refill case, defer freelist
> construction until after objects are emitted from a fresh slab.
> new_slab() now only allocates the slab and initializes its metadata.
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
> This reduces per-object overhead when allocating from a fresh slab.
> The most direct benefit is in the paths that allocate objects first and
> only build a freelist for the remainder afterward: bulk allocation from
> a new slab in refill_objects(), single-object allocation from a new slab
> in ___slab_alloc(), and the corresponding early-boot paths that now use
> the same deferred-freelist scheme. Since refill_objects() is also used to
> refill sheaves, the optimization is not limited to the small set of
> kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> workloads may benefit as well when they refill from a fresh slab.
> 
> In slub_bulk_bench, the time per object drops by about 32% to 70% with
> CONFIG_SLAB_FREELIST_RANDOM=n, and by about 50% to 67% with
> CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> cost removed by this change: each iteration allocates exactly
> slab->objects from a fresh slab. That makes it a near best-case scenario
> for deferred freelist construction, because the old path still built a
> full freelist even when no objects remained, while the new path avoids
> that work. Realistic workloads may see smaller end-to-end gains depending
> on how often allocations reach this fresh-slab refill path.
> 
> Benchmark results (slub_bulk_bench):
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
> before: 4.91 +- 0.07 ns/object
> after: 3.29 +- 0.03 ns/object
> delta: -32.8%
> 
> obj_size=32, batch=128:
> before: 6.96 +- 0.07 ns/object
> after: 3.73 +- 0.05 ns/object
> delta: -46.4%
> 
> obj_size=64, batch=64:
> before: 10.77 +- 0.12 ns/object
> after: 4.65 +- 0.06 ns/object
> delta: -56.8%
> 
> obj_size=128, batch=32:
> before: 19.04 +- 0.22 ns/object
> after: 6.30 +- 0.07 ns/object
> delta: -66.9%
> 
> obj_size=256, batch=32:
> before: 22.20 +- 0.26 ns/object
> after: 6.68 +- 0.06 ns/object
> delta: -69.9%
> 
> obj_size=512, batch=32:
> before: 20.03 +- 0.62 ns/object
> after: 6.83 +- 0.09 ns/object
> delta: -65.9%
> 
> - CONFIG_SLAB_FREELIST_RANDOM=y -
> 
> obj_size=16, batch=256:
> before: 8.72 +- 0.06 ns/object
> after: 4.31 +- 0.05 ns/object
> delta: -50.5%
> 
> obj_size=32, batch=128:
> before: 11.29 +- 0.13 ns/object
> after: 4.93 +- 0.05 ns/object
> delta: -56.3%
> 
> obj_size=64, batch=64:
> before: 15.36 +- 0.24 ns/object
> after: 5.95 +- 0.10 ns/object
> delta: -61.3%
> 
> obj_size=128, batch=32:
> before: 21.75 +- 0.26 ns/object
> after: 8.10 +- 0.14 ns/object
> delta: -62.8%
> 
> obj_size=256, batch=32:
> before: 26.62 +- 0.26 ns/object
> after: 8.58 +- 0.22 ns/object
> delta: -67.8%
> 
> obj_size=512, batch=32:
> before: 26.88 +- 0.36 ns/object
> after: 8.81 +- 0.11 ns/object
> delta: -67.2%
> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Nice!

>  mm/slab.h |  10 ++
>  mm/slub.c | 283 +++++++++++++++++++++++++++---------------------------
>  2 files changed, 151 insertions(+), 142 deletions(-)

And the delta is just 19 new lines of code, good!

Just some nits.


> diff --git a/mm/slab.h b/mm/slab.h
> index bf2f87acf5e3..ada3f9c3909f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -91,6 +91,16 @@ struct slab {
>  #endif
>  };
> 
> +struct slab_obj_iter {
> +	unsigned long pos;
> +	void *start;
> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	unsigned long freelist_count;
> +	unsigned long page_limit;
> +	bool random;
> +#endif
> +};

I think this struct could live in slub.c as mothing else needs it?

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
> +	build_slab_freelist(s, slab, &iter);
> +
>  	if (!alloc_debug_processing(s, slab, object, orig_size)) {
>  		/*
>  		 * It's not really expected that this would fail on a
> @@ -3696,20 +3686,32 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  		 * corruption in theory could cause that.
>  		 * Leak memory of allocated slab.
>  		 */
> -		if (!allow_spin)
> -			spin_unlock_irqrestore(&n->list_lock, flags);
>  		return NULL;
>  	}
> 
> -	if (allow_spin)
> +	n = get_node(s, slab_nid(slab));
> +	if (allow_spin) {
>  		spin_lock_irqsave(&n->list_lock, flags);
> +	} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +		/*
> +		 * Unlucky, discard newly allocated slab.
> +		 * The slab is not fully free, but it's fine as
> +		 * objects are not allocated to users.
> +		 */
> +		free_new_slab_nolock(s, slab);

I was going to complain that we can leave alloc_debug_processing() without a
corresponding free_debug_processing(). But it seems it can't have any bad
effect. Only with SLAB_TRACE we would print alloc without corresponding
free. But I doubt anyone uses it anyway.

> +		return NULL;
> +	}
> 
> -	if (slab->inuse == slab->objects)
> -		add_full(s, n, slab);
> -	else
> +	if (needs_add_partial)
>  		add_partial(n, slab, ADD_TO_HEAD);
> +	else
> +		add_full(s, n, slab);
> 
> -	inc_slabs_node(s, nid, slab->objects);
> +	/*
> +	 * Debug caches require nr_slabs updates under n->list_lock so validation
> +	 * cannot race with slab (de)allocations and observe inconsistent state.
> +	 */
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
>  	spin_unlock_irqrestore(&n->list_lock, flags);
> 
>  	return object;
> @@ -4349,9 +4351,10 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  {
>  	unsigned int allocated = 0;
>  	struct kmem_cache_node *n;
> +	struct slab_obj_iter iter;
>  	bool needs_add_partial;
>  	unsigned long flags;
> -	void *object;
> +	unsigned int target_inuse;
> 
>  	/*
>  	 * Are we going to put the slab on the partial list?
> @@ -4359,33 +4362,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	 */
>  	needs_add_partial = (slab->objects > count);

How about

	bool needs_add_partial = true;

	...

	if (count >= slab->objects) {
		needs_add_partial = false;
		count = slab->objects;
	}

Then we don't need target_inuse and can use count.

> -	if (!allow_spin && needs_add_partial) {
> +	/* Target inuse count after allocating from this new slab. */
> +	target_inuse = needs_add_partial ? count : slab->objects;
> 
> -		n = get_node(s, slab_nid(slab));
> +	init_slab_obj_iter(s, slab, &iter, allow_spin);
> 
> -		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> -			/* Unlucky, discard newly allocated slab */
> -			free_new_slab_nolock(s, slab);
> -			return 0;
> -		}
> -	}
> -
> -	object = slab->freelist;
> -	while (object && allocated < count) {
> -		p[allocated] = object;
> -		object = get_freepointer(s, object);
> -		maybe_wipe_obj_freeptr(s, p[allocated]);
> -
> -		slab->inuse++;
> +	while (allocated < target_inuse) {
> +		p[allocated] = next_slab_obj(s, &iter);
>  		allocated++;
>  	}
> -	slab->freelist = object;
> +	slab->inuse = target_inuse;
> +	build_slab_freelist(s, slab, &iter);
> 
>  	if (needs_add_partial) {
> -
> +		n = get_node(s, slab_nid(slab));

The declaration of 'n' could move here.

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

Yeah I think this is ok.

> +			return 0;
>  		}
>  		add_partial(n, slab, ADD_TO_HEAD);
>  		spin_unlock_irqrestore(&n->list_lock, flags);
> @@ -4456,15 +4456,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	stat(s, ALLOC_SLAB);
> 
>  	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> -		object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
> +		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);
> 
>  		if (likely(object))
>  			goto success;
>  	} else {
> -		alloc_from_new_slab(s, slab, &object, 1, allow_spin);
> -
>  		/* we don't need to check SLAB_STORE_USER here */
> -		if (likely(object))
> +		if (alloc_from_new_slab(s, slab, &object, 1, allow_spin))
>  			return object;
>  	}
> 
> @@ -7251,10 +7249,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> 
>  	stat(s, ALLOC_SLAB);
> 
> -	/*
> -	 * TODO: possible optimization - if we know we will consume the whole
> -	 * slab we might skip creating the freelist?
> -	 */
>  	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
>  					/* allow_spin = */ true);
> 
> @@ -7585,6 +7579,7 @@ static void early_kmem_cache_node_alloc(int node)
>  {
>  	struct slab *slab;
>  	struct kmem_cache_node *n;
> +	struct slab_obj_iter iter;
> 
>  	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
> 
> @@ -7596,14 +7591,18 @@ static void early_kmem_cache_node_alloc(int node)
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
> +	build_slab_freelist(kmem_cache_node, slab, &iter);
> +
>  #ifdef CONFIG_SLUB_DEBUG
>  	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
>  #endif
>  	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
> -	slab->freelist = get_freepointer(kmem_cache_node, n);
> -	slab->inuse = 1;
>  	kmem_cache_node->per_node[node].node = n;
>  	init_kmem_cache_node(n);
>  	inc_slabs_node(kmem_cache_node, node, slab->objects);


