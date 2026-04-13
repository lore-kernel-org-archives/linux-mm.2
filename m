Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5BDE93812
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 03:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803406B0089; Sun, 12 Apr 2026 23:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D106B008A; Sun, 12 Apr 2026 23:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6551E6B0092; Sun, 12 Apr 2026 23:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0A76B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 23:45:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1465D1A046F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:46 +0000 (UTC)
X-FDA: 84652143492.24.34B07E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 84D741A000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YPID9g2P;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776051944; a=rsa-sha256;
	cv=none;
	b=zB7lBCjBGgYG64dUjdnHBEl/frfla899TG4B2tXFWdgOtgGoDwqq+XzoA77AR07aNQs5L5
	3cZWI5ziBCcYioXnAOn1v3dSUvkRub+fFPXPo/unL+9jgFn9naEIGivjae04PR3pAfgF4c
	s/L0A4bZTer9hYkur8JuPHZvzcKB7cE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776051944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKGHluccV6hdIndjeKQTc25URc1NPrvg1tOhEBzSqF4=;
	b=hOTYyDzDJ42m2+/xkwxfvFBKNQQ5ovvXnlLbDqNSkyJzX6T82Yv6wj76D+H1KW+2Y8mGPB
	ZjOMfmvs6V0SKS44LFmX3TfJAKfJSh4QoBDTlXYVVsUZzi4Us+nzp74AvceaSciIFyXrRq
	LsXSR2viRd8NaiC/EFN6B5U00whWIzs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YPID9g2P;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCF9960142;
	Mon, 13 Apr 2026 03:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C97C116C6;
	Mon, 13 Apr 2026 03:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776051943;
	bh=eQ+MIjMGR6SoMDn4ZvvIdIn6reDcSKKuhb8N0UFgxfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YPID9g2PN783aoD/kungoRq1iUm3FsxsLVelbD9yQtAZmdYgFdIFwLQqfLerX+qJy
	 Gn5xygdUfiHOGydx3XKwJ9A1N+JlI6YATHMgVVtwDp/1jMLs7lq4rVpfBCrqEaJuTe
	 5l+1g8RGXWD7Qgf/Ods96W+EpC/P4nzexFjldfWQMRswMXfYsbjEvo9UH8mXkb8y2E
	 083ydvdAIUukuO/Iiq+nPKPbHgJHUED5X4GNmsAwIgxp8fGkMcLD9TesxWrAHZfeUL
	 ErXFLS/gZRlqmSPZIzi484w7eh4tf8e7zsj0PAA/fYg3wfJI1b1AXJV8nArBACnIrE
	 VsrjIk+8cCnrg==
Date: Mon, 13 Apr 2026 12:45:41 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v5] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <adxm5az9EfHr2aYg@hyeyoo>
References: <20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84D741A000C
X-Stat-Signature: xa3bexxsawsx9b9sbsckgp5a6yahz1g5
X-HE-Tag: 1776051944-534575
X-HE-Meta: U2FsdGVkX1+wSFYMKyBMFrbGwur9Z3QbHYPF7rvPRTYqfNVPhoyYPwo+IOQAe2vmnT6jH55bPh3J379kFLbdZq4vHJtouiS7uahCcti/pL3VUz5P94LbZmsZer7+f4bLABLj2G4S5ZRrBR3zY3o23g/8mpNdi662MMTC9bzJkpnheDlTFwzCM/5BqeeowVjoO9tt1M1/swpiq52UMjLCZeg37ZIBTX++TgF3wSQv3MaWGv8q82vxnMeiDh/YDM9d4B49udNedkPTYMxaPEkpS/hQjXo+5eNwBufi6QQyrqdiQePi3W2c6bChr7/pLEgchAKxBojXjoBXmE6d/2qHT//ROoOfRvDcy9zumvCkO12NnUBmb6Zp4+AXWbVlypaOvSnrZDmNLC5m/z0Q2MEATEO/3jTRloZbdAj4NDAIy6e4uhdC1Ft4JT7FspYMnW2ZMzzxBzMQId0fLsQi2+ehm/aQSomYOYc7hmsYW/PUsD5OVvm0EoLeN2GceW4ZhZtIvqvs0mSge12G9ekh2JqEadRdjwQvIAo0giM8ZY/AVEDN3+Xq1oOad+pLey+nxYEbt24y58DkO7AFsf47goeilsS/ksUNHoMZ6oFWIFbmp9V8nowF6YnPd6hS9Y7MsGnMOyvvCMzDaWzbo9bhpdDz1ae4S8q9u9nsTZz7nn2nZG7EjwRhrHwyUDF9Gtl3+OoWTsIwOyWCgZ9ZizME9TF5mJYgsTqJ1lEvDGDo94m67bUW7Dj0piAua3f0ICSwT2mliuu+gHk03CoF9ourfnD7rIC9aMKCV7y7BcixWOQ9Z3+waZ5AI8fdJLmCn43MxYRGy/eYbPLgO66sMlVyey9Nl/TEKRAf5Hqv2Y+ZHdu9qi0A6juFr2NcZWbS2rJp39KdpVKzvyY1JazbR9wH+l4FXUUVSRJDU4ql8WKl6sxnLEwhMskIKXrE9IuZ2bChULhUCXevyge4rg5QshqM+7d
 4sQrUnHJ
 uSs4gc0OosLxvRXNWYeRvQRJ5zaHqC21zX7ZB2nvoKzOhCSOfLoNwj/fJSaSc6fXt3+x0WkspmWmye0FbvhP0xLeXCo66yLdLxlAF1npxGzs+mW1XjO2zSI7yaJ0vVyXCfjO59xaoR1XeT1rnbkJZ6JUZad/dh/viUp+x8Cl4kT276FSa+g7fYNIhN6GONgVaiRCrrR+49P6CxwCMJbvGLN5dQ15vAUHNHUTVq+ZlIjjXTleu6LpamqAuErpe9b9u2O9XmmF16zhAi0QBMOlxivRE7l/YNcdSRbgBqFmC0QTDebjJI1F14VGat/SXNv/Co603ZYSEHDlBwaclm2yxP0EVg+a3heocfEFpLJEMSYrfJuKdSSGhXQKt03MTNagw0NAQytCbZgPeL9JM9sPpEtzScSA2hXGiiN6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 08:43:52PM +0800, hu.shengming@zte.com.cn wrote:
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
> In slub_bulk_bench, the time per object drops by about 32% to 71% with
> CONFIG_SLAB_FREELIST_RANDOM=n, and by about 52% to 70% with
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

[...]

Hi Shengming, it's been great to see how this patch has been improved
since v1 to where it is now. Thanks for taking the feedback and steadily
improving things along the way.

I think this is getting pretty close to being ready for mainline,
with just one little thing to fix in the code.

Other reviewers/maintainers may also take a look and leave comments
when they get a chance.

> Link: https://github.com/HSM6236/slub_bulk_test.git
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

If you think it's appropriate, please feel free to add:
Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>

In case this was assisted by AI or other tools, please disclose that
according to the process document:

  https://docs.kernel.org/process/generated-content.html
  https://docs.kernel.org/process/coding-assistants.html

Not that I think this was assisted by AI, just mentioning because
sometimes people using tools to develop the kernel are not aware that
they need to disclose the fact. It wouldn't hurt to remind people :-)

> Changes in v5:
> - Call build_slab_freelist() unconditionally, and remove the redundant "slab->freelist = NULL" initialization in allocate_slab().
> - Check the return value of alloc_from_new_slab() to prevent a potential use-after-free bug.
> - Refine the commit message with more precise test coverage descriptions.
> - Link to v4: https://lore.kernel.org/all/2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn/
> 
> ---
>  mm/slab.h |  10 ++
>  mm/slub.c | 279 +++++++++++++++++++++++++++---------------------------
>  2 files changed, 147 insertions(+), 142 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4927407c9699..9ff8af8c2f73 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3696,22 +3686,30 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
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
>  	spin_unlock_irqrestore(&n->list_lock, flags);
>  
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);

Ouch, I didn't catch this when it was added in v4. When slab debugging
feature is enabled for the cache, inc_slabs_node() should be done within
the spinlock to avoid race conditions with slab validation.

Perhaps it's worth adding a comment mentioning this :)

See commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
caches and make it safe") for more details.

With this fixed, please feel free to add:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

