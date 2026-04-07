Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF05FB518B
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 04:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64436B0088; Tue,  7 Apr 2026 00:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15726B0089; Tue,  7 Apr 2026 00:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B556B008A; Tue,  7 Apr 2026 00:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 800FB6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:19:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EA6D8C0AB
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:19:29 +0000 (UTC)
X-FDA: 84630455658.12.5544725
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DEBAA0013
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:19:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hx0nTPT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775535567; a=rsa-sha256;
	cv=none;
	b=NlJwOXrSnsJEj4k+ZOAe0vK9t2HXhQgtHvz2/7p1ayujmU42B1JlHRyq/O4U0Nds+XD8ox
	45HqwGh1smj3Raw3ZgFQqNtdLxJOh5SoJXl5paevhmuT1YnkbxLB8nOSDB4+gfuHFOWpUq
	7QwuActp9ceZoc1iq5xM8JgEqshkDCM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hx0nTPT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775535567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNd9FQVfCzg6cwGID6WAm/C+ItKuv3gjj7gXikVVe5U=;
	b=WFUfFQTNYiQZveJ/bETatf8wcUZUI8Jl0lUUWr06Mqnni7Rxm0JmD4PcMVaj2Rp19h/He6
	stj277V0oEdqX/ZE9ojp1mV9+gvssKyv6CwmDeGnNN0VE6oI9ncxoFjhXUznPxjifGh4Rd
	7ecOzT6Ifax+YCVldAGBAlWA05hx7LU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8654760180;
	Tue,  7 Apr 2026 04:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5101C116C6;
	Tue,  7 Apr 2026 04:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775535566;
	bh=J1M5hWouK0/D/pUlFBWyWPpW3hMdaNu8Tub1jrXWO1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hx0nTPT5KVOPU6iEO3ufrgjR5q97n6KpUNPj+dgylY9a7rMBRvH6CbnOp/qOZxfTb
	 Ds93yPFaOQjosaZSB/Cmhcjr+BkD+phSU7Vb62YMxFEOITsXGvu6SAXjIEf8yVFKp/
	 VxgOcQqLKZr/wcaWTQtoT6kD1OGWD+pWik2eDuYDqIjJ8aT3zT218aSwwe6Xg5NERn
	 5/f6a6MCPjDmzrzUZ6718GOmNZqEZcwBHJlpnQGk1TdF6pIMLh2oO0rAsVoi8dur4J
	 nM0fxYydWoKgmrDnQS0gUcctaMgux9+9pqVuXbRXXQ6p0Ipohs9LlXEustYa5lj7hU
	 xVm/7kp+ObZYw==
Date: Tue, 7 Apr 2026 13:19:23 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v3] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <adSFyyFWlLy177rB@hyeyoo>
References: <202604062150182836ygUiyPoKcxtHjgF7rWXe@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604062150182836ygUiyPoKcxtHjgF7rWXe@zte.com.cn>
X-Rspamd-Queue-Id: 8DEBAA0013
X-Stat-Signature: b8dkhs9ade8mi3qjdy6t3y6ypom3wxji
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775535567-423122
X-HE-Meta: U2FsdGVkX19RXCL5DPfW4InI+htRJdbA4awkfXLDSkhUDTXkYcitxkwFi+oo9dbA9e122uUQLZAyj7PjWpp5X0xsJf0Xr363WG9hywUEnLF1zxz2RUw/UThsdeb55RQwvD5cL1e+M9Eyt/z5Ee6v5f5eskidFlned6UfyfM/SD0ZtTlEeoUyLLN/5I281izh/5VmmVGOSoAOydyJ48pXjYKcQMLF/lDlr4raDxL8rtCNdjj5D4qNaPxiGTnWdXf0A7HXHPEBfW1TflkYB5naqDVMnIAfK6UyH/CBf/WcwbM8cJ+mACzfbMG6Z0AUgFfWz7iOj7T4nGBsBb7k9rG/Faq0M+86BkzKvRL16Bihzo3PxVjxYIJ43TMLvqdU4JngIta8r/Ex5wVtVsETzBZls5+cpYcmgaJczn4mdoRfZ3F/UtxmpuSFfd/OBMz2M+5mkrByDNdLLJ9J8tyQd6STFO0X46/OJFfNrj2WukzI/mzJ1TuQ1sJ/lZoZVrkDv03D/MKUb6Qp2HYCyxyWNP7oMZj5s25teXLae+b/hgUCFyyJvAezdeE/5KPd9p0oS0rKOwVrKTY6hhBjioTuxs1GzFpbnFxIm9FlA7s9+2qtJxl/lO1KwvP0YKfBqrBjbC8ll+t+gnC8lH2geYoEARVRyUx9C/Cfd8ssIUMQKquGebCuWZw7/4oiW5f4UxubVJtSefY5a7ODAq+IxHcsMsEhfvQu071v3kL+Ct4ggt+/kdwlqKnAJN1HQGaCiWLsfaOrBSslIVcQDyaGX9Bozr0MrJI4Fn8U2d/bHQDCTnrp/n5UiBL7uSicoKwUUuQ562zSWmOoN/iGXrVY5S6YSKn03GfiNcDpilKdFrSg99Hmv6JHGraF7CL4cmgbNPliXRJlOJXBOWnIpo/2VEdC7qrNKn9R4WBQhWnrRCM58wAXLD0eRVwzciqSOfawNHa74QcTttSqgtwwSRU58KHIo/k
 n7QKbY1Z
 VavePBC0ad6Ycamrg5SVYgO6Sq3pDCEGhX6pZ7fGpYilspLK1IfsxHhGQlqhFcgz8C7rbu2YouHSm7sH8n5/QdOV7kLKLrtKVsobowfSTgnC3nO71DWrsXqZK6HcWIs1M1nBOV9Vm6Ec0tQ4lBXyHihBHPlZAQo7GQoPYuT7GyMb3Qxf3H7GiyutKnACxhrr8ZROMVJdrL88s6f6FHkuzARdTEE83eb4SDBK3XiSe2WWDXb0oGCSN+RNtskS1/zi20BTMh/RY9IImvy8UjXcZjP9tpAwVsPm26sOQiTW/lPt96geujNq6EzCmG5lled+tHtJ/5AkelxM1VfgFYezUMueIXemLg75xyl89PA8+DYAc9YxkoDv3Jgr1wo6aNETWQHDk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shengming, thanks for v3!

Good to see it's getting improved over the revisions.
Let me leave some comments inline.

On Mon, Apr 06, 2026 at 09:50:18PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> refill_objects() can consume many objects from a fresh slab, and when it
> takes all objects from the slab the freelist built during slab allocation
> is discarded immediately.
> 
> Instead of special-casing the whole-slab bulk refill case, defer freelist
> construction until after objects are emitted from the new slab.
> allocate_slab() now allocates and initializes slab metadata only.
> new_slab() preserves the existing behaviour by building the full freelist
> on top, while refill_objects() allocates a raw slab and lets
> alloc_from_new_slab() emit objects directly and build a freelist only for
> the remaining objects, if any.
> 
> To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> small iterator abstraction for walking free objects in allocation order.
> The iterator is used both for filling the sheaf and for building the
> freelist of the remaining objects.
> 
> This removes the need for a separate whole-slab special case, avoids
> temporary freelist construction when the slab is consumed entirely.
> 
> Also mark setup_object() inline. After this optimization, the compiler no
> longer consistently inlines this helper in the hot path, which can hurt
> performance. Explicitly marking it inline restores the expected code
> generation.
> 
> This reduces per-object overhead in bulk allocation paths and improves
> allocation throughput significantly. In slub_bulk_bench, the time per
> object drops by about 41% to 70% with CONFIG_SLAB_FREELIST_RANDOM=n, and
> by about 59% to 71% with CONFIG_SLAB_FREELIST_RANDOM=y.
> 
> Benchmark results (slub_bulk_bench):
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
> before: 4.62 +- 0.01 ns/object
> after: 2.72 +- 0.01 ns/object
> delta: -41.1%
> 
> obj_size=32, batch=128:
> before: 6.58 +- 0.02 ns/object
> after: 3.30 +- 0.02 ns/object
> delta: -49.8%
> 
> obj_size=64, batch=64:
> before: 10.20 +- 0.03 ns/object
> after: 4.22 +- 0.03 ns/object
> delta: -58.7%
> 
> obj_size=128, batch=32:
> before: 17.91 +- 0.04 ns/object
> after: 5.73 +- 0.09 ns/object
> delta: -68.0%
> 
> obj_size=256, batch=32:
> before: 21.03 +- 0.12 ns/object
> after: 6.22 +- 0.08 ns/object
> delta: -70.4%
> 
> obj_size=512, batch=32:
> before: 19.00 +- 0.21 ns/object
> after: 6.45 +- 0.13 ns/object
> delta: -66.0%
> 
> - CONFIG_SLAB_FREELIST_RANDOM=y -
> 
> obj_size=16, batch=256:
> before: 8.37 +- 0.06 ns/object
> after: 3.38 +- 0.05 ns/object
> delta: -59.6%
> 
> obj_size=32, batch=128:
> before: 11.00 +- 0.13 ns/object
> after: 4.05 +- 0.01 ns/object
> delta: -63.2%
> 
> obj_size=64, batch=64:
> before: 15.30 +- 0.20 ns/object
> after: 5.21 +- 0.03 ns/object
> delta: -65.9%
> 
> obj_size=128, batch=32:
> before: 21.55 +- 0.14 ns/object
> after: 7.10 +- 0.02 ns/object
> delta: -67.1%
> 
> obj_size=256, batch=32:
> before: 26.27 +- 0.29 ns/object
> after: 7.54 +- 0.05 ns/object
> delta: -71.3%
> 
> obj_size=512, batch=32:
> before: 26.69 +- 0.28 ns/object
> after: 7.73 +- 0.09 ns/object
> delta: -71.0%
> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
> Changes in v2:
> - Handle CONFIG_SLAB_FREELIST_RANDOM=y and add benchmark results.
> - Update the QEMU benchmark setup to use -enable-kvm -cpu host so benchmark results better reflect native CPU performance.
> - Link to v1: https://lore.kernel.org/all/20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn/
> 
> Changes in v3:
> - refactor fresh-slab allocation to use a shared slab_obj_iter
> - defer freelist construction until after bulk allocation from a new slab
> - build a freelist only for leftover objects when the slab is left partial
> - add build_slab_freelist(), prepare_slab_alloc_flags() and next_slab_obj() helpers
> - remove obsolete freelist construction helpers now replaced by the iterator-based path, including next_freelist_entry() and shuffle_freelist()
> - Link to v2: https://lore.kernel.org/all/202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn/
> 
> ---
>  mm/slab.h |  11 +++
>  mm/slub.c | 256 +++++++++++++++++++++++++++++-------------------------
>  2 files changed, 149 insertions(+), 118 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fb2c5c57bc4e..88537e577989 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4344,14 +4245,130 @@ static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
>  			0, sizeof(void *));
>  }
>  
> +/* Return the next free object in allocation order. */
> +static inline void *next_slab_obj(struct kmem_cache *s,
> +				  struct slab_obj_iter *iter)
> +{
> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	if (iter->random) {
> +		unsigned long idx;
> +
> +		/*
> +		 * If the target page allocation failed, the number of objects on the
> +		 * page might be smaller than the usual size defined by the cache.
> +		 */
> +		do {
> +			idx = s->random_seq[iter->pos];
> +			iter->pos++;
> +			if (iter->pos >= iter->freelist_count)
> +				iter->pos = 0;
> +		} while (unlikely(idx >= iter->page_limit));
> +
> +		return setup_object(s, (char *)iter->start + idx);
> +	}
> +#endif
> +	void *obj = iter->cur;
> +
> +	iter->cur = (char *)iter->cur + s->size;
> +	return setup_object(s, obj);
> +}
> +
> +/* Initialize an iterator over free objects in allocation order. */
> +static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
> +				      struct slab_obj_iter *iter,
> +				      bool allow_spin)
> +{
> +	iter->pos = 0;
> +	iter->start = fixup_red_left(s, slab_address(slab));
> +	iter->cur = iter->start;

It's confusing that iter->pos field is used only when randomization is
enabled and iter->cur field is used only when randomization is disabled.

I think we could simply use iter->pos for both random and non-random cases
(as I have shown in the skeleton before)?

> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	iter->random = (slab->objects >= 2 && s->random_seq);
> +	if (!iter->random)
> +		return;
> +
> +	iter->freelist_count = oo_objects(s->oo);
> +	iter->page_limit = slab->objects * s->size;
> +
> +	if (allow_spin) {
> +		iter->pos = get_random_u32_below(iter->freelist_count);
> +	} else {
> +		struct rnd_state *state;
> +
> +		/*
> +		 * An interrupt or NMI handler might interrupt and change
> +		 * the state in the middle, but that's safe.
> +		 */
> +		state = &get_cpu_var(slab_rnd_state);
> +		iter->pos = prandom_u32_state(state) % iter->freelist_count;
> +		put_cpu_var(slab_rnd_state);
> +	}
> +#endif
> +}
>  static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  		void **p, unsigned int count, bool allow_spin)

There is one problem with this change; ___slab_alloc() builds the
freelist before calling alloc_from_new_slab(), while refill_objects()
does not. For consistency, let's allocate a new slab without building
freelist in ___slab_alloc() and build the freelist in
alloc_single_from_new_slab() and alloc_from_new_slab()?

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
> @@ -4359,6 +4376,9 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	 */
>  	needs_add_partial = (slab->objects > count);
>  
> +	/* Target inuse count after allocating from this new slab. */
> +	target_inuse = needs_add_partial ? count : slab->objects;
> +
>  	if (!allow_spin && needs_add_partial) {
>  
>  		n = get_node(s, slab_nid(slab));

Now new slabs without freelist can be freed in this path.
which is confusing but should be _technically_ fine, I think...

> @@ -4370,19 +4390,18 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  		}
>  	}
>  
> -	object = slab->freelist;
> -	while (object && allocated < count) {
> -		p[allocated] = object;
> -		object = get_freepointer(s, object);
> +	init_slab_obj_iter(s, slab, &iter, allow_spin);
> +
> +	while (allocated < target_inuse) {
> +		p[allocated] = next_slab_obj(s, &iter);
>  		maybe_wipe_obj_freeptr(s, p[allocated]);

We don't have to wipe the free pointer as we didn't build the freelist?

> -		slab->inuse++;
>  		allocated++;
>  	}
> -	slab->freelist = object;
> +	slab->inuse = target_inuse;
>  
>  	if (needs_add_partial) {
> -
> +		build_slab_freelist(s, slab, &iter);

When allow_spin is true, it's building the freelist while holding the
spinlock, and that's not great.

Hmm, can we do better?

Perhaps just allocate object(s) from the slab and build the freelist
with the objects left (if exists), but free the slab if allow_spin
is false AND trylock fails, and accept the fact that the slab may not be
fully free when it's freed due to trylock failure?

something like:

alloc_from_new_slab() {
	needs_add_partial = (slab->objects > count);
	target_inuse = needs_add_partial ? count : slab->objects;

	init_slab_obj_iter(s, slab, &iter, allow_spin);
	while (allocated < target_inuse) {
		p[allocated] = next_slab_obj(s, &iter);
		allocated++;
	}
	slab->inuse = target_inuse;

	if (needs_add_partial) {
		build_slab_freelist(s, slab, &iter);
		n = get_node(s, slab_nid(slab))
		if (allow_spin) {
			spin_lock_irqsave(&n->list_lock, flags);
		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
			/* 
			 * Unlucky, discard newly allocated slab.
			 * The slab is not fully free, but it's fine as
			 * objects are not allocated to users.
			 */
			free_new_slab_nolock(s, slab);
			return 0;
		}
		add_partial(n, slab, ADD_TO_HEAD);
		spin_unlock_irqrestore(&n->list_lock, flags);
	}
	[...]
}

And do something similar in alloc_single_from_new_slab() as well.

>  		if (allow_spin) {
>  			n = get_node(s, slab_nid(slab));
>  			spin_lock_irqsave(&n->list_lock, flags);
> @@ -7244,16 +7265,15 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  
>  new_slab:
>  
> -	slab = new_slab(s, gfp, local_node);
> +	slab_gfp = prepare_slab_alloc_flags(s, gfp);

Could we do `flags = prepare_slab_alloc_flags(s, flags);`
within allocate_slab()? Having gfp and slab_gfp flags is distractive.
The value of allow_spin should not change after
prepare_slab_alloc_flags() anyway.

> +	allow_spin = gfpflags_allow_spinning(slab_gfp);
> +
> +	slab = allocate_slab(s, slab_gfp, local_node, allow_spin);
>  	if (!slab)
>  		goto out;
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
> -- 
> 2.25.1

-- 
Cheers,
Harry / Hyeonggon

