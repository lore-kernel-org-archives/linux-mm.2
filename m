Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D3010D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845FE6B0092; Mon, 30 Mar 2026 08:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7216B0095; Mon, 30 Mar 2026 08:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D476B0096; Mon, 30 Mar 2026 08:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9B06B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:22:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD03F8BFE3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:22:04 +0000 (UTC)
X-FDA: 84602641368.25.DB50AFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B9BB4000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:22:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DICsJz4m;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774873323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPNhAMsRULPG+NJvLLVqQoxLfRlWU+6G6s4gnTJjHCc=;
	b=SML3mR6hH1LXn0GAwhaePYzE5QuXuPMxIx4xnOPzeyxkiCcz1RqWE0NyekE3mbau2BrfJw
	hnsWyQKTZUW2E4gRIXLPXuLSd6zMItTbm5H0Isi/0WUQU9BXuhk845gSMl6r6ejAp5rYhL
	4GxlLbRWkMgBGzbGO7S1pUop2Z92OnE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DICsJz4m;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774873323; a=rsa-sha256;
	cv=none;
	b=t//cXVCbbE2Jw83xZEP3WV0VwNS97TxLI+IjMN0CqL8cXuMGNGozbACs2iS2vntAZaiAo9
	L7sAaQO3SDXmqh4WHVw75uR28qlGnz6QGd43jbT7yrRz6VaXQWKGEDnlkkh1zik4orMuP/
	JyB2Wa4mvb6WR1np38qo5aKjgJlIY9Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8622B60054;
	Mon, 30 Mar 2026 12:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72F9C4CEF7;
	Mon, 30 Mar 2026 12:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873322;
	bh=0+VcjiJsc8KVUCGTmtqDYPJdbypNWqliK6agHrrQbi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DICsJz4mBysoRI2OaiWFdNVskCzxK54KETg+TN+rekYnt46DfeJPoxkMLS/cDYniw
	 kj8NCkZQvIV9zWhBThzIe28IOVd5fCf1lZm/ibeZkWZgolyeo9HgA6GZhYzxz0Eb+V
	 feUR/YEB501hMOOHUoik0kw/vVC1MZjotKmeRZjxAWENZL60/CQMPuRbaNSob7sTk1
	 lpts8UK553d5qCrLFUhECUiw0QD2WhTLTt1M3Od1beP5wTiVDC34reI2yw3a+AZKmJ
	 O7ftX5kvpgu4gjGfkYFOEcLfYgzrDE0UvkSeGXs2DNHcL7+JuTw4C5jC1ZwJYRkjoV
	 vbp4YMEvLnGqA==
Message-ID: <02c6bf8f-303d-4451-83d6-4cc2b1dd4550@kernel.org>
Date: Mon, 30 Mar 2026 14:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: skip freelist construction for whole-slab bulk
 refill
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
 yang.yang29@zte.com.cn
References: <20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B9BB4000D
X-Stat-Signature: d38e4mcz5z51gg6158nqzbhnfxu51koh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774873323-644839
X-HE-Meta: U2FsdGVkX18F7gnLLARN+03FTXcW70ErY9WwZwMiPxMM1VjmPx29L24yS45fSwEXFsKcirNBnlcsenUZWcYRVNsV1oVVnZn4u4MuMDYvFeMS5nbcgOd+OaJx6PZ6QP8OzBAjE0e4Bs32pnLELuVLBq2V1RxbylxeNk18opHMA6DKa54M88/P+KHfqVkBY2upigFcwSoGtcFKkz8y6SjAEwGm1zgfLTZQY5C1AyFd2iMVkewm0iJq4/UtsBM2cMXlfuujIFaUObu2X0e9+v9NW7fqdcY2nBqQh2d0a86KzFqXaMkxCoC5bKCjg3RF6TD7SxZSHAL3nvvhIuIVERS5yBtqSK2qvzIVSH57+iz6LG0r9lRnMYnOxvu+bqRxz0BS8KCoozFXwRtNXsc/GEg/NvZ73c3zovzP2/wt+xD+9moxC6TlwNP8eFuF/jfPwi9eVrB0vJGLEYUU7rWQ9Sqlk5pmVMQx94+KS/ShwtnGWDkmCPG3g8h5QLNw2DQB7CBleezo0P9hJwAOHweVGN99OaZ9oNttH8lseQUdig+tPqAlrvcYfE3ukRtQg3jpspvEgs5LcJozV75Bb6COrrCyciIbvfawcb32F3vyAESKzgEW4Df4r2YiSXLxaudENIpCdtbJt0oQ0o9N4x63BQ1qQ1ZqvF3QsjSYrDlH8yS4erd1/OlbeitQu6dPBv3ktWQ0VnnAvERbY5IZQCaLoLpTkLMkeoGRDGs8ixPmgS2qrKfPCTuTOhA7z6mEp7WzuLvg+e+0kxa74rWmNx0RbFRdqyXlT8F2hadptNKEt6GGF6gt1aD0NhTE905hbd4dx1kfgjjLEBN5Rv/fPwPnyIM9bdmflQm855hog+D3pQieH23E3MX9XpM5piGzRfk2K1KtIl9UcniyyWoYvmk9zIARkgDq8OYJHiJyeLb7ZO+uL4VaV31i2ZkaAzRzd86eWaWCUMZX2PlS9gIq/Ha0nG1
 fk4eJp4T
 ap6HdmMZKWk2IWS0ssJhRcYacY4X0BmCNETHlCN8ZFKO2fefqPOJrjkSP9oM7QPIRf4wEvzVxOwH677cjDsMPXVqC6lBWZr2Au4lcAKnvoyy2OrPkUkwoofKyEyKTW+R2N+IO00O7RrwmrEL9OS5NO/NUr80SYQdy/pqHNKRb+XbOsRbqP5IWTAsgFUbpZ7yRAzpfUn8wwBXyNM8BY+5roPo1DZOnKQvTaYDS9IsVmAQV1p6nqVQNLLiJGfBvDAQZk1JuvNPFwLKEQvV/PUBJalrHAdZAoDxS/j37KZp7GEfI00HukXM7dKBTfLUD1sy4Y+qGcnjL4bqHt8BJb2KZg4nDABkxIPNSXY3JzDmgaQKmVUWAeDU6nRI2rcGs6X61xYovVS5HxIoufMJT+bHLYfwRzIL02nFP8PB0+X4il8HDwLCaVBBHC3ag1Lrl5oo8VUqUOqfp08QDzoB6KcxcTzfJ1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/28/26 05:55, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> refill_objects() still carries a long-standing note that a whole-slab
> bulk refill could avoid building a freelist that is immediately drained.

"still" and "long-standing", huh :) it was added in 7.0-rc1
but nevermind, good to address it anyway

> When the remaining bulk allocation is large enough to fully consume a
> new slab, constructing the freelist is unnecessary overhead. Instead,
> allocate the slab without building its freelist and hand out all objects
> directly to the caller. The slab is then initialized as fully in-use.
> 
> Keep the existing behavior when CONFIG_SLAB_FREELIST_RANDOM is enabled,
> as freelist construction is required to provide randomized object order.

That's a good point and we should not jeopardize the randomization.
However, virtually all distro kernels enable it [1] so the benefits of this
patch would not apply to them.

But I think with some refactoring, it should be possible to reuse the
relevant code (i.e. next_freelist_entry()) to store the object pointers into
the bulk alloc array (i.e. sheaf) in the randomized order, without building
it as a freelist? So I'd suggest trying that and measuring the result.

[1]
https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLAB_FREELIST_RANDOM

> Additionally, mark setup_object() as inline. After introducing this
> optimization, the compiler no longer consistently inlines this helper,
> which can regress performance in this hot path. Explicitly marking it
> inline restores the expected code generation.
> 
> This reduces per-object overhead in bulk allocation paths and improves
> allocation throughput significantly.
> 
> Benchmark results (slub_bulk_bench):
> 
>   Machine: qemu-system-x86_64 -m 1024M -smp 8
>   Kernel:  Linux 7.0.0-rc5-next-20260326
>   Config:  x86_64_defconfig
>   Rounds:  20
>   Total:   256MB
> 
>   obj_size=16, batch=256:
>     before: 28.80 ± 1.20 ns/object
>     after:  17.95 ± 0.94 ns/object
>     delta:  -37.7%
> 
>   obj_size=32, batch=128:
>     before: 33.00 ± 0.00 ns/object
>     after:  21.75 ± 0.44 ns/object
>     delta:  -34.1%
> 
>   obj_size=64, batch=64:
>     before: 44.30 ± 0.73 ns/object
>     after:  30.60 ± 0.50 ns/object
>     delta:  -30.9%
> 
>   obj_size=128, batch=32:
>     before: 81.40 ± 1.85 ns/object
>     after:  47.00 ± 0.00 ns/object
>     delta:  -42.3%
> 
>   obj_size=256, batch=32:
>     before: 101.20 ± 1.28 ns/object
>     after:  52.55 ± 0.60 ns/object
>     delta:  -48.1%
> 
>   obj_size=512, batch=32:
>     before: 109.40 ± 2.30 ns/object
>     after:  53.80 ± 0.62 ns/object
>     delta:  -50.8%

That's encouraging!
Thanks,
Vlastimil

> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>  mm/slub.c | 90 +++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 71 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fb2c5c57bc4e..c0ecfb42b035 100644
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
> @@ -3438,7 +3438,8 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
>  			    -(PAGE_SIZE << order));
>  }
> 
> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node,
> +				  bool build_freelist)
>  {
>  	bool allow_spin = gfpflags_allow_spinning(flags);
>  	struct slab *slab;
> @@ -3446,7 +3447,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	gfp_t alloc_gfp;
>  	void *start, *p, *next;
>  	int idx;
> -	bool shuffle;
> +	bool shuffle = false;
> 
>  	flags &= gfp_allowed_mask;
> 
> @@ -3483,6 +3484,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	slab->frozen = 0;
> 
>  	slab->slab_cache = s;
> +	slab->freelist = NULL;
> 
>  	kasan_poison_slab(slab);
> 
> @@ -3497,9 +3499,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
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
> @@ -3515,7 +3518,8 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	return slab;
>  }
> 
> -static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node,
> +			     bool build_freelist)
>  {
>  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
>  		flags = kmalloc_fix_flags(flags);
> @@ -3523,7 +3527,7 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
> 
>  	return allocate_slab(s,
> -		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
> +		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node, build_freelist);
>  }
> 
>  static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
> @@ -4395,6 +4399,45 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	return allocated;
>  }
> 
> +static unsigned int alloc_whole_from_new_slab(struct kmem_cache *s,
> +		struct slab *slab, void **p)
> +{
> +	unsigned int allocated = 0;
> +	void *object;
> +
> +	object = fixup_red_left(s, slab_address(slab));
> +	object = setup_object(s, object);
> +
> +	while (allocated < slab->objects - 1) {
> +		p[allocated] = object;
> +		maybe_wipe_obj_freeptr(s, object);
> +
> +		allocated++;
> +		object += s->size;
> +		object = setup_object(s, object);
> +	}
> +
> +	p[allocated] = object;
> +	maybe_wipe_obj_freeptr(s, object);
> +	allocated++;
> +
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
> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	return false;
> +#else
> +	return count >= oo_objects(s->oo);
> +#endif
> +}
> +
>  /*
>   * Slow path. We failed to allocate via percpu sheaves or they are not available
>   * due to bootstrap or debugging enabled or SLUB_TINY.
> @@ -4441,7 +4484,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  	if (object)
>  		goto success;
> 
> -	slab = new_slab(s, pc.flags, node);
> +	slab = new_slab(s, pc.flags, node, true);
> 
>  	if (unlikely(!slab)) {
>  		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
> @@ -7244,18 +7287,27 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
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
> +		slab = new_slab(s, gfp, local_node, false);
> +		if (!slab)
> +			goto out;
> +		stat(s, ALLOC_SLAB);
> +		refilled += alloc_whole_from_new_slab(s, slab, p + refilled);
> +	} else {
> +		slab = new_slab(s, gfp, local_node, true);
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
> @@ -7587,7 +7639,7 @@ static void early_kmem_cache_node_alloc(int node)
> 
>  	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
> 
> -	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
> +	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node, true);
> 
>  	BUG_ON(!slab);
>  	if (slab_nid(slab) != node) {


