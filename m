Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E691D35144
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 06:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EAD6B0088; Wed,  1 Apr 2026 02:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8716B0089; Wed,  1 Apr 2026 02:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C04A6B008A; Wed,  1 Apr 2026 02:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAD76B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:56:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13A5E8C1A6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:56:17 +0000 (UTC)
X-FDA: 84609077994.25.F86F8D4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 13B471C0010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:56:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4vSOTod;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775026575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paMbxHyax8/ms1LKlFcByWVRiRiLY2REyz8Mqd1wUUE=;
	b=uxGKLOnUeizNLn87oZtg4pQIgJB4WwxEP2uThvpCRlt0+BFQPtSRAx/EKBkvJ6r3qD7u5g
	ykrcpVn83hzDP/bjdvoi31mQygXwMRVCOZQ0cIPsalCZyLpLBP7WM5xOrqKKo2UeQyXmtB
	JsuojU1mWMJ/2AaPZlA1OSXzo7mhHf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775026575; a=rsa-sha256;
	cv=none;
	b=S1pcyLPDWRCK9h9Jq9P4XR8dKeAEKH385csVdo25SGn+oSK43ywYjSNiWmetGEbqzLMBZy
	8j6f3bij1EZJsMKQrEMjFanpGsX63mGJhW4sV4J6hJcF9x3xdN3rlmb2yc0mfm7W8a1Nn1
	TAAo4tK2pkyb+v/xFlTfLOBtctRCMvU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b4vSOTod;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 1 Apr 2026 14:55:23 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775026572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=paMbxHyax8/ms1LKlFcByWVRiRiLY2REyz8Mqd1wUUE=;
	b=b4vSOTodZmtYq0dm5da/dDSy99bmNfBlE3VShGfPw1lbR/Z/aM8BFiQy4wXYWL6dcDnTrE
	q0qTQpphHDYvuD6vIKY/MTA6ZUJyNdIz5+c0IwTDX7w9nfQBmUgLycCEeDadmrNEBBIrzY
	cCxbwXTXlSVjQGkuBIQieZDAVEIckX8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	xu.xin16@zte.com.cn, yang.tao172@zte.com.cn, yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] mm/slub: skip freelist construction for whole-slab
 bulk refill
Message-ID: <fz2shejnypqsu74zpoy66senjbpyl2bbvcnoxu6hvfs77c7jtr@o2acnd2hzd4x>
References: <202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: ian11iqqtj85hnz1yc13czi5w6eyccx1
X-Rspamd-Queue-Id: 13B471C0010
X-Rspam-User: 
X-HE-Tag: 1775026574-693848
X-HE-Meta: U2FsdGVkX1/I45TuRHR4yejoBp7AATjNijfqvDTcKMIjgpZm29w0DF89mR2DQ3snW/8xzRLZD4HkRtQACCFBVqpfGeshqMJSCzCQbeNTedPNPlyy3n1b3o0tt7mbK1jaKf6eNTFNfOjDe0nSLTK3C5uQZQgtIlDC5wu8sW1HyPvRljwZ1UXrefzKkbklQhzYBTiQtjNinwvyoqqwWNZmslshZd3jQHdLBNc9NnPBqYJaRbDQpi95kmg5gWqdzZ0JBeiFsBEQ8W8f5sfWpDWgSTqNsHWipJgd1qx8BvFQiBhTancrK7nXD3UK9F0vI9JEsdpBx19PyGnjhZeh9qA5w8Xl7DBUPMXwiN0s2AD/Zkvb7u+lekgbwoBBhhE210pKzP1jF4K9GKi4fOaYxRdjsozOy2XOiTClBXyaiVg1kEmm/zhcPKXvswOKAlqo60OBXDF05AGFDGPx/njqgNPmUuYB1YFQWTZCaV6ZAK7p/utI+pAFkvvk3DM5T7Dpg1A3wrU+Sr6/WPl+AIFpYKcM2PZQFVU6nXiFgjYjaGyDGINN1aqzzYf7PrcTw46qSmmj8poIak8xsAuCpoNQ30aGEQ0QFPSUoF8xeXPpCxe5aV1EYgB6AJNLo3T/gt/nHRzSnAyLzq2O1x2T5XhYi+pBK+1a6PecNozdLn7wxTrv9J1l9sYmKT5qKangDc0MWorUNMwT2Apd4eJclfHvz39pevBJDo/3RsUxCqF1NAJl9d9ht3RWeFnQAPp4AZI9YKExtRVE8BIqa8VOLsd2Ojb4pzIiV5Bza16klFonNE4fVvJt5J0nPACSTEtp+dONPyobIqertLgBkvcSQ5Idrxy/plqp6B72AJOZq1F0nyJZPyF1szKXfHfEEHXXK+X5PaNBIiJE244LmM21+VFa0nRYIqWZjfiIufFGL4jczp5yuBXzDnlVcD/IeOTWTTBmtL68lz705n49qIIwO1xPiIN
 bT1O4V/I
 IIA4xfrzrteAHssacw9jRtq/+zzsL2duWqcfD/trBRsauxmUq2FCMeT1MLKSZZYVlxxhPetY1Sr/Op39wPUmUiNmOAAG6Ct5mTXgiGCi2oi5sti0SZrCLAKHSi4lEUv81fop9WM/KnVMWEQyqZQJ0myKohJ/MQlYWLkud9QQgiGYRLCn5JRZvckOPxTYDkBNAsPZtFGDWEQgDN21/jNix+iQFbQPkUvXqC00B333YBCGMULF9qF/jUL4+Z8hL1WJfYvWVYCxvPna+BgWYe02/QOaFkmsLwSCECSrurlgv0e6Cnzsh1/+P5SuPYy80KeC85PvZjuPbAYU1DPE3iIr7mV9eRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 12:57:25PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> refill_objects() already notes that a whole-slab bulk refill could avoid
> building a freelist that would be drained immediately.
> 
> When the remaining bulk allocation is large enough to consume an entire
> new slab, building the freelist is unnecessary overhead. Instead,
> allocate the slab without initializing its freelist and hand all objects
> directly to the caller.
> 
> Handle CONFIG_SLAB_FREELIST_RANDOM=y as well by walking objects in the
> randomized allocation order and placing them directly into the caller's
> array, without constructing a temporary freelist.
> 
> Also mark setup_object() inline. After this optimization, the compiler no
> longer consistently inlines this helper in the hot path, which can hurt
> performance. Explicitly marking it inline restores the expected code
> generation.
> 
> This reduces per-object overhead in bulk allocation paths and improves
> allocation throughput significantly. In slub_bulk_bench, the time per
> object drops by about 54% to 74% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> by about 62% to 74% with CONFIG_SLAB_FREELIST_RANDOM=y.

Thanks for the patch.
Here are some quick review..

> 
> Benchmark results (slub_bulk_bench):
> 
> Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> Kernel: Linux 7.0.0-rc6-next-20260330
> Config: x86_64_defconfig
> Cpu: 0
> Rounds: 20
> Total: 256MB
> 
> - CONFIG_SLAB_FREELIST_RANDOM=n -
> 
> obj_size=16, batch=256:
> before: 5.29 +- 0.73 ns/object
> after: 2.42 +- 0.05 ns/object
> delta: -54.4%
> 
> obj_size=32, batch=128:
> before: 7.65 +- 1.89 ns/object
> after: 3.04 +- 0.03 ns/object
> delta: -60.2%
> 
> obj_size=64, batch=64:
> before: 11.07 +- 0.08 ns/object
> after: 4.11 +- 0.04 ns/object
> delta: -62.9%
> 
> obj_size=128, batch=32:
> before: 19.95 +- 0.30 ns/object
> after: 5.72 +- 0.05 ns/object
> delta: -71.3%
> 
> obj_size=256, batch=32:
> before: 24.31 +- 0.25 ns/object
> after: 6.33 +- 0.14 ns/object
> delta: -74.0%
> 
> obj_size=512, batch=32:
> before: 22.48 +- 0.14 ns/object
> after: 6.43 +- 0.10 ns/object
> delta: -71.4%
> 
> - CONFIG_SLAB_FREELIST_RANDOM=y -
> 
> obj_size=16, batch=256:
> before: 9.32 +- 1.26 ns/object
> after: 3.51 +- 0.02 ns/object
> delta: -62.4%
> 
> obj_size=32, batch=128:
> before: 11.68 +- 0.15 ns/object
> after: 4.18 +- 0.22 ns/object
> delta: -64.2%
> 
> obj_size=64, batch=64:
> before: 16.69 +- 1.36 ns/object
> after: 5.22 +- 0.06 ns/object
> delta: -68.7%
> 
> obj_size=128, batch=32:
> before: 23.41 +- 0.23 ns/object
> after: 7.40 +- 0.07 ns/object
> delta: -68.4%
> 
> obj_size=256, batch=32:
> before: 29.80 +- 0.44 ns/object
> after: 7.98 +- 0.09 ns/object
> delta: -73.2%
> 
> obj_size=512, batch=32:
> before: 30.38 +- 0.36 ns/object
> after: 8.01 +- 0.06 ns/object
> delta: -73.6%
> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
> Changes in v2:
> - Handle CONFIG_SLAB_FREELIST_RANDOM=y and add benchmark results.
> - Update the QEMU benchmark setup to use -enable-kvm -cpu host so benchmark results better reflect native CPU performance.
> - Link to v1: https://lore.kernel.org/all/20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn/
> 
> ---
>  mm/slub.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 136 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fb2c5c57bc4e..52da4a716b1b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2733,7 +2733,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
>  	return *head != NULL;
>  }
>  
> -static void *setup_object(struct kmem_cache *s, void *object)
> +static inline void *setup_object(struct kmem_cache *s, void *object)
>  {
>  	setup_object_debug(s, object);
>  	object = kasan_init_slab_obj(s, object);
> @@ -3399,6 +3399,53 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
>  
>  	return true;
>  }
> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
> +						   void *obj);
> +
> +static inline bool alloc_whole_from_new_slab_random(struct kmem_cache *s,
> +					struct slab *slab, void **p,
> +					bool allow_spin,
> +					unsigned int *allocatedp)
> +{
> +	unsigned long pos, page_limit, freelist_count;
> +	unsigned int allocated = 0;
> +	void *next, *start;
> +
> +	if (slab->objects < 2 || !s->random_seq)
> +		return false;
> +
> +	freelist_count = oo_objects(s->oo);
> +
> +	if (allow_spin) {
> +		pos = get_random_u32_below(freelist_count);
> +	} else {
> +		struct rnd_state *state;
> +
> +		/*
> +		 * An interrupt or NMI handler might interrupt and change
> +		 * the state in the middle, but that's safe.
> +		 */
> +		state = &get_cpu_var(slab_rnd_state);
> +		pos = prandom_u32_state(state) % freelist_count;
> +		put_cpu_var(slab_rnd_state);
> +	}
> +
> +	page_limit = slab->objects * s->size;
> +	start = fixup_red_left(s, slab_address(slab));
> +
> +	while (allocated < slab->objects) {
> +		next = next_freelist_entry(s, &pos, start, page_limit,
> +					     freelist_count);
> +		next = setup_object(s, next);
> +		p[allocated] = next;
> +		maybe_wipe_obj_freeptr(s, next);
> +		allocated++;
> +	}
> +
> +	*allocatedp = allocated;

It seems we does not need to return the allocated count through allocatedp,
since the count should always be slab->objects.

> +	return true;
> +}
> +
>  #else
>  static inline int init_cache_random_seq(struct kmem_cache *s)
>  {
> @@ -3410,6 +3457,14 @@ static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
>  {
>  	return false;
>  }
> +
> +static inline bool alloc_whole_from_new_slab_random(struct kmem_cache *s,
> +					struct slab *slab, void **p,
> +					bool allow_spin,
> +					unsigned int *allocatedp)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_SLAB_FREELIST_RANDOM */
>  
>  static __always_inline void account_slab(struct slab *slab, int order,
> @@ -3438,7 +3493,8 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
>  			    -(PAGE_SIZE << order));
>  }
>  
> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node,
> +				  bool build_freelist, bool *allow_spinp)
>  {
>  	bool allow_spin = gfpflags_allow_spinning(flags);
>  	struct slab *slab;
> @@ -3446,7 +3502,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	gfp_t alloc_gfp;
>  	void *start, *p, *next;
>  	int idx;
> -	bool shuffle;
> +	bool shuffle = false;
> +
> +	if (allow_spinp)
> +		*allow_spinp = allow_spin;

It seems unnecessary for allocate_slab() to compute allow_spin and return it
via allow_spinp.
We could instead calculate it directly in refill_objects() based on gfp.

>  
>  	flags &= gfp_allowed_mask;
>  
> @@ -3483,6 +3542,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	slab->frozen = 0;
>  
>  	slab->slab_cache = s;
> +	slab->freelist = NULL;
>  
>  	kasan_poison_slab(slab);
>  
> @@ -3497,9 +3557,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	alloc_slab_obj_exts_early(s, slab);
>  	account_slab(slab, oo_order(oo), s, flags);
>  
> -	shuffle = shuffle_freelist(s, slab, allow_spin);
> +	if (build_freelist)
> +		shuffle = shuffle_freelist(s, slab, allow_spin);
>  
> -	if (!shuffle) {
> +	if (build_freelist && !shuffle) {
>  		start = fixup_red_left(s, start);
>  		start = setup_object(s, start);
>  		slab->freelist = start;
> @@ -3515,7 +3576,8 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	return slab;
>  }
>  
> -static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node,
> +			     bool build_freelist, bool *allow_spinp)
>  {
>  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
>  		flags = kmalloc_fix_flags(flags);
> @@ -3523,7 +3585,8 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
>  
>  	return allocate_slab(s,
> -		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
> +			     flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK),
> +			     node, build_freelist, allow_spinp);
>  }
>  
>  static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
> @@ -4395,6 +4458,48 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	return allocated;
>  }
>  
> +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> +		struct slab *slab, void **p, bool allow_spin)
> +{
> +
> +	unsigned int allocated = 0;
> +	void *object, *start;
> +
> +	if (alloc_whole_from_new_slab_random(s, slab, p, allow_spin,
> +					     &allocated)) {
> +		goto done;
> +	}
> +
> +	start = fixup_red_left(s, slab_address(slab));
> +	object = setup_object(s, start);
> +
> +	while (allocated < slab->objects - 1) {
> +		p[allocated] = object;
> +		maybe_wipe_obj_freeptr(s, object);
> +
> +		allocated++;
> +		object += s->size;
> +		object = setup_object(s, object);
> +	}

Also, I feel the current patch contains some duplicated code like this loop.

Would it make sense to split allocate_slab() into two functions?

For example,
the first part could be called allocate_slab_meta_setup() (just an example name)
And, the second part could be allocate_slab_objects_setup(), with the core logic
being the loop over objects. Then allocate_slab_objects_setup() could support
two modes: one called BUILD_FREELIST, which builds the freelist, and another
called EMIT_OBJECTS, which skips building the freelist and directly places the
objects into the target array.

> +
> +	p[allocated] = object;
> +	maybe_wipe_obj_freeptr(s, object);
> +	allocated++;
> +
> +done:
> +	slab->freelist = NULL;
> +	slab->inuse = slab->objects;
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> +
> +	return allocated;
> +}
> +
> +static inline bool bulk_refill_consumes_whole_slab(struct kmem_cache *s,
> +		unsigned int count)
> +{
> +	return count >= oo_objects(s->oo);

It seems using s->oo here may be a bit too strict. In allocate_slab(), the
object count can fall back to s->min, so using s->objects might be more
reasonable (If I understand correctly...).

> +}
> +
>  /*
>   * Slow path. We failed to allocate via percpu sheaves or they are not available
>   * due to bootstrap or debugging enabled or SLUB_TINY.
> @@ -4441,7 +4546,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	if (object)
>  		goto success;
>  
> -	slab = new_slab(s, pc.flags, node);
> +	slab = new_slab(s, pc.flags, node, true, NULL);
>  
>  	if (unlikely(!slab)) {
>  		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
> @@ -7244,18 +7349,30 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  
>  new_slab:
>  
> -	slab = new_slab(s, gfp, local_node);
> -	if (!slab)
> -		goto out;
> -
> -	stat(s, ALLOC_SLAB);
> -
>  	/*
> -	 * TODO: possible optimization - if we know we will consume the whole
> -	 * slab we might skip creating the freelist?
> +	 * If the remaining bulk allocation is large enough to consume
> +	 * an entire slab, avoid building the freelist only to drain it
> +	 * immediately. Instead, allocate a slab without a freelist and
> +	 * hand out all objects directly.
>  	 */
> -	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> -					/* allow_spin = */ true);
> +	if (bulk_refill_consumes_whole_slab(s, max - refilled)) {
> +		bool allow_spin;
> +
> +		slab = new_slab(s, gfp, local_node, false, &allow_spin);
> +		if (!slab)
> +			goto out;
> +		stat(s, ALLOC_SLAB);
> +		refilled += alloc_whole_from_new_slab(s, slab, p + refilled,
> +						      allow_spin);
> +	} else {
> +		slab = new_slab(s, gfp, local_node, true, NULL);
> +		if (!slab)
> +			goto out;
> +		stat(s, ALLOC_SLAB);
> +		refilled += alloc_from_new_slab(s, slab, p + refilled,
> +						max - refilled,
> +						/* allow_spin = */ true);
> +	}
>  
>  	if (refilled < min)
>  		goto new_slab;
> @@ -7587,7 +7704,7 @@ static void early_kmem_cache_node_alloc(int node)
>  
>  	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
>  
> -	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
> +	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node, true, NULL);
>  
>  	BUG_ON(!slab);
>  	if (slab_nid(slab) != node) {
> -- 
> 2.25.1



