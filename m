Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB86606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uj2EVE2U
Received: by kanga.kvack.org (Postfix)
	id CAE276B00EF; Tue, 10 Nov 2026 20:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37CD6B05B0; Tue, 10 Nov 2026 20:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF496B05B1; Tue, 10 Nov 2026 20:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8286C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:03:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C4E61401BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:03:08 +0000 (UTC)
X-FDA: 85421039256.20.2A0F58A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A228EC0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:03:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uj2EVE2U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794358985;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2mlZdhoXM9fc5EMhNEd+NBol7Fpmgn82gd901AHkDs=;
	b=azqr8iwPfwsPfL1QD1q0Da0KF+2fua0qLTzen6PYFvBaDFfD476IuA7La+7ObKEzf9BUnt
	B9z97jw0VEPDOYjsiGoqPnCZk2QnwIF60QztkqmQFfJE3uIQz5OkRRJzT040NG3Ufb42Mn
	sE3qn9kfyt7ERjxgru2litgoICNkIjI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uj2EVE2U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794358985;
	b=lPK7qf6SDJwviQgWVpXFCw/EWaimvUMnSXMNi8li6j6w5X8vyCeuOV8fJbDazf5V5z/eI4
	DF8M2+6UL2IemfhniMOrVnVIxY5hkDk3Qcx3BF10DWm+VyF+oDykV2fUiwsuvAs3I/fZqp
	sTMUGDT0Tf0ri2WLxkYEASFBot31+oA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ECB9615AA;
	Wed, 11 Nov 2026 01:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5751F0089F;
	Wed, 11 Nov 2026 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794358984;
	bh=j2mlZdhoXM9fc5EMhNEd+NBol7Fpmgn82gd901AHkDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uj2EVE2UhsksQKIJ1gbJ3/LNJ4kTMqHkdd3KrXw67+rw0cRDuWGrh2u6CIXSBYmoQ
	 qLbeYpkXn62UGFmHRcpPnO7QFyFa9LsltDpbtKvpNKGhZ5nqvZCiqANNLet4K6XkGS
	 cusMnizFoNFz/KhLb9ifABoCrWXR1sQehpr1GQOdDfZTAwyGdUqzbky17o+Of80F4y
	 9ee4vvuVAYK1BsCGmV7KZSB3TuhS+WZHLRfoo0P3L7i6HsY479KHLE20iPhiF+lQ8J
	 2Ho4ZURWDjrOq6BbL6rwB6W5g38id7TgwknlJyRAQMmdXv6vXM1HRwQKFDVaKQwtA4
	 Q+ayoVWfkxBRA==
Message-ID: <sashiko-outbox-208044@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for
 PISA-backed slab caches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-17-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-17-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 01:03:02 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A228EC0008
X-Stat-Signature: zbnbfybtn8frcjf5jzwb6ti9gmto7pru
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794358985-600702
X-HE-Meta: U2FsdGVkX1/SnL2wC1ByDhOlwfjJa+i9w6Lyl6hDndrSc/md2Hcxmogizeu61vtvvngkHBiaEoV1uLKP2Azkisc6PdYJtA5X9DpxCqbMvVpheSeHumuEFx/dILaDTm31TYV+TKqu2owiPZp0Qv8W3vzZ6wvYf9KYaQlFZzIbJO2l3fTtrQ9eczk2iUXJLZ6CAxyLB0dHHbEdRaTOf/h0pGJmqG9M09I+qqS7GaAlgJ/RobRrPC7xd0ytUVv2cggfqSYTxAlA2LX9EwSipWAj7lRLblalBYD1b8K6dFp9JMiqTU6NlFWFLNEm2w1t1S9WI29fZ0MnVukTacrqPgjGGA1Rbxvd85DXbXMLK50pFX39aTvFMCil+Fy9YQN+KZEUeBL+/qZ6zYGzeKsifTBem9EAUMBd8AN9ThVNArA9DFcI664GtlySFBx0AUUGBt5ZH8pQ8LoEjeno+d9p2IB3DOJtu5cOtFeXOOSTaGwQ2qz/ERur3TanmnntgZmw7gB7vVN7XvUNjcWP6QL/3AEdCjEvXAD6jCMGBj8XQRF9dPBIt+DTfgECB2xZj594i0XzVNZrxMPlQXpWLQ85sA9Pltb2LhCXVvp69w2bVnpoosz+FnxgS5O7SKlA2ENuHTg7vjpvz6TncjhYR/bU4/To/JLzw71N+WeKTs3kNfiw8NwSMFfhZ6MdsN63CkhgeigGoEXr+944Z9g6Yca7u9s3rYmHiBBmWh4eCjLzOPmP0n0XYjc3O4ASTMWK03b81iFs/zpXi9fzIMhm3ZduC114h/n78rZVscvr8awJXanuHMgwU7KwlLf2QDhsNzHFV6wh+qYBTRAXLCFPQy2tN88W4LqVpXomxEieZI+c7fygl8BW5szB3yOWQ7EOsKz7EYL5SmzFV7jO7oavOK7kyV5XUK3Qm1R22bRGh8syjseC7+kIfAbKY6XPUnwaijJXO1llFzvkukLpDoVWccUnRvf
 KO0XSwjC
 WxPXCGPgs9kMuNGlKwl0Q+m/9nDJdwusf9rYkFIjxYwDSrvAbJLjFV01qvcARRmfJPWEEC01PFnSgLwM5XDV3m0M/WQbJ1hwIKvP5wa25NNRgXBUbtCPun9vVUh/uREd8gk77wNi8owA6R0VYi39Ln6qRchA0ItNTw2o2em7CGTqUgR9ySGBB0X9F8jvL53rn0QldaGGVy9DtIYv8NR+OTYmSlCxFvP3rFXiAnrH/AME7GrPlpxB+9mEAcOwqdpQ0bVn/rUJXBFvrnriLA48/43preo5IT9b6KE/aHCoMIaQa//pgiFOnvEMTvFmeRqqyBCuVsI4TSfeK1ebQ1rv9ZA4gJrn0pqTQ3mBf3ZaM3qjSFRRRSVO3KcKjIg8pRzJtA6qLAv3Thd0H5K1bRSKWl3isOrPIUrjHqgXWIle9KCqJuBSYLI14lJ539GQq2kdHxD/0ULmOrE8Q0+1VDCaYfYv+oeMBF1gcpsZOto7GAjyS8IAcwO73TPwQxx909WoUsa39VWseS2cvcCfIz6bOjiXqBSnYTMQpV9oRZN0h15mfbSqstdzwtSRjXgBw8Bls7//z3ic+M7FI7FrAhPCpggrQnmF4jX7k5IvE/xd9oNcZbkIHytIthkukIysNCzNVwWt09gg7PdgK2+ZAgtZnsyIeDixqXgyM663zpGI8lX3RoEv82gxQkQo/V9Q6s1kTfgeiJ7uRh8uWqJ+cPbA7oaq7ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] mm/slub: order clamping in calculate_sizes() breaks non-4K
  pages and slab->objects
- [Medium] iommu/pisa: pisa_alloc_folio() pollutes per-node allocator on
  __GFP_THISNODE
- [Medium] mm/slub: __GFP_PISA_RO leaks into alloc_slab_obj_exts() via
  OBJCGS_CLEAR_MASK
- [Medium] mm/slub: alloc_slab_page() and pisa_alloc_folio() bypass
  current_gfp_context()
- [Low] iommu/pisa: kmem_cache leak in test_slub_page_alloc() on
  allocation failure
--

commit 48ed47e1e79e98a68d2521a0d03cf1f63453e5e9
Author: Luigi Rizzo <lrizzo@google.com>

mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches

This commit adds the SLAB_CACHE_PISA_RO flag so SLUB caches can allocate
zeroed, read-only PISA folios via pisa_alloc_folio().

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index 4b61ec84ed6d1..3b5c49d143a7e 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
> @@ -848,6 +848,33 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsig=
ned int order, int preferred
>  	return pisa_alloc_bulk(pa, gfp & ~__GFP_PISA_RW, nr_pages, page_array, =
frozen);
>  }
> =20
> +/**
> + * pisa_alloc_folio - Allocate a frozen folio for SLUB (SLAB_CACHE_PISA_=
RO)
> + * @gfp: GFP flags (must have __GFP_PISA_RW or __GFP_PISA_RO set)
> + * @order: Folio order
> + * @nid: Target NUMA node (or NUMA_NO_NODE)
> + *
> + * Drops __GFP_THISNODE before calling the per-node allocator and verifi=
es
> + * node placement afterwards.
> + *
> + * Return: Frozen folio of @order, or NULL.
> + */
> +struct folio *pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
> +{
> +	struct page *page;
> +
> +	page =3D pisa_alloc_pages(gfp & ~__GFP_THISNODE, order, nid, NULL);
> +	if (!page)
> +		return NULL;
> +	if (unlikely((gfp & __GFP_THISNODE) && nid !=3D NUMA_NO_NODE &&
> +		     page_to_nid(page) !=3D nid)) {
> +		page_ref_unfreeze(page, 1);
> +		__free_pages(page, order);
> +		return NULL;
> +	}
> +	return page_folio(page);
> +}

[Severity: Medium]
Can stripping __GFP_THISNODE here attach a remote 2MB PISA page to nid's
per-node PISA allocator?

When ___slab_alloc() tries the local node first, it passes
GFP_NOWAIT | __GFP_NOWARN | __GFP_THISNODE.  If nid's PISA allocator and
reservoir are empty, pisa_alloc_pages() reaches __pisa_page_alloc(), which
calls alloc_pages_node(nid, gfp, PISA_ORDER) without __GFP_THISNODE.  When
nid has no free order-9 buddy pages, alloc_pages_node() falls back to a
remote node, and __pisa_alloc_bulk() binds that remote 2MB page's
pisa_meta to nid's pisa_alloc and sets PISA_ACTIVE.

pisa_alloc_folio() then rejects the block because page_to_nid(page) !=3D nid
and calls __free_pages(page, order), which intercepts PISA_ACTIVE in
__free_pages_prepare() -> pisa_free_page() and recycles the remote block
back into nid's pisa_alloc instead of freeing the 2MB page.  Subsequent
__GFP_THISNODE allocations on nid will repeatedly pop and reject blocks
from that remote 2MB page.

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index 40bf7801183da..9cc1328893ace 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c
[ ... ]
> @@ -621,6 +622,23 @@ static void test_reservoir_and_scrubber(struct kunit=
 *test)
>  	WRITE_ONCE(pisa_scrub_max, old_scrub);
>  }
> =20
> +static void test_slub_page_alloc(struct kunit *test)
> +{
> +	struct kmem_cache *s;
> +	void *obj;
> +
> +	s =3D kmem_cache_create("pisa_kunit_slab", 1024, NULL,
> +			      SLAB_NO_MERGE | SLAB_CACHE_PISA_RO);
> +	KUNIT_ASSERT_NOT_NULL(test, s);
> +
> +	obj =3D kmem_cache_alloc(s, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, obj);
> +	KUNIT_EXPECT_TRUE(test, is_pisa_page(virt_to_page(obj)));
> +	kmem_cache_free(s, obj);
> +
> +	kmem_cache_destroy(s);
> +}

[Severity: Low]
Does KUNIT_ASSERT_NOT_NULL(test, obj) leak the kmem_cache s if
kmem_cache_alloc() fails?  KUNIT_ASSERT_NOT_NULL() aborts the test
immediately before reaching kmem_cache_destroy(s).

> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c2..63609768f4e3f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
[ ... ]
> @@ -3378,6 +3379,8 @@ static inline struct slab *alloc_slab_page(gfp_t fl=
ags, int node,
>  	if (unlikely(!allow_spin))
>  		page =3D alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
>  								  node, order);
> +	else if (unlikely(flags & __GFP_PISA_RO))
> +		page =3D (struct page *)pisa_alloc_folio(flags, order, node);
>  	else if (node =3D=3D NUMA_NO_NODE)
>  		page =3D alloc_frozen_pages(flags, order);
>  	else

[Severity: Medium]
Does calling pisa_alloc_folio() directly bypass current_gfp_context()?

alloc_frozen_pages() and __alloc_frozen_pages() apply
current_gfp_context(gfp) in __alloc_frozen_pages_noprof() to strip
__GFP_DIRECT_RECLAIM, __GFP_FS, or __GFP_IO under scoped
memalloc_noreclaim_save(), memalloc_nofs_save(), or memalloc_noio_save()
sections.  Neither alloc_slab_page() nor pisa_alloc_folio() applies
current_gfp_context(flags), so a GFP_KERNEL allocation from a
SLAB_CACHE_PISA_RO cache inside memalloc_noreclaim_save() still has
gfpflags_allow_blocking(gfp) true and can sleep in pisa_alloc_split_page(),
and inside memalloc_nofs_save() or memalloc_noio_save() can enter
pisa_meta_init() from __pisa_page_alloc() before pisa_memalloc_save() is
called.

> @@ -3484,7 +3487,7 @@ static struct slab *allocate_slab(struct kmem_cache=
 *s, gfp_t flags,
>  	gfp_t alloc_gfp;
>  	void *start;
> =20
> -	flags &=3D gfp_allowed_mask;
> +	flags &=3D gfp_allowed_mask & ~__GFP_PISA_RW;
> =20
>  	flags |=3D s->allocflags;

[Severity: Medium]
Does __GFP_PISA_RO in s->allocflags leak into internal slabobj_ext
allocations?

flags |=3D s->allocflags sets __GFP_PISA_RO in flags after ~__GFP_PISA_RW is
masked out, and allocate_slab() then passes flags to account_slab() ->
alloc_slab_obj_exts().  Because OBJCGS_CLEAR_MASK does not include
__GFP_PISA_RW:

mm/slub.c:
#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
				__GFP_ACCOUNT | __GFP_NOFAIL | \
				__GFP_THISNODE | __GFP_COMP)

alloc_slab_obj_exts() (and alloc_empty_sheaf() when a caller passes
__GFP_PISA_RO) leaves __GFP_PISA_RO set on the internal kmalloc call.  If
the slabobj_ext array exceeds KMALLOC_MAX_CACHE_SIZE,
___kmalloc_large_node() allocates the SLUB metadata array from a PISA RO
page.  Adding __GFP_PISA_RW to OBJCGS_CLEAR_MASK would prevent this.

[ ... ]

> @@ -8182,6 +8189,11 @@ static int calculate_sizes(struct kmem_cache_args =
*args, struct kmem_cache *s)
>  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
>  		s->allocflags |=3D __GFP_RECLAIMABLE;
> =20
> +	if (s->flags & SLAB_CACHE_PISA_RO) {
> +		s->allocflags |=3D __GFP_PISA_RO | __GFP_ZERO;
> +		order =3D clamp_t(unsigned int, order, 2, PAGE_ALLOC_COSTLY_ORDER);
> +	}
> +
>  	/*
>  	 * For kmalloc caches we enable sheaves later by
>  	 * bootstrap_kmalloc_sheaves() to avoid recursion.

[Severity: High]
Does clamping order to [2, PAGE_ALLOC_COSTLY_ORDER] after
calculate_order(size) break on 16KB and 64KB page kernels?

In pisa_init(), read-only PISA allocators are only created for order 2 and
SKB_FRAG_PAGE_ORDER:

drivers/iommu/pisa-alloc.c:pisa_init() {
	const struct {
		u8 order;
		bool ro;
		bool pcp;
	} cfg[] =3D {
		{ 0, false, true },
		{ 2, true, false },
		{ SKB_FRAG_PAGE_ORDER, true, true },
	};

On ARM64 with 16KB or 64KB pages, SKB_FRAG_PAGE_ORDER is 1 or 0, so no
order-3 (PAGE_ALLOC_COSTLY_ORDER) read-only PISA allocator exists.  When
calculate_order(size) returns 3, pisa_alloc_folio() looks up
pisa_node_pa(nid, 3, true), which returns NULL, and allocate_slab() skips
the s->min fallback for SLAB_CACHE_PISA_RO, causing every allocation from
the cache to fail.

In addition, clamping order up to 2 runs after calculate_order(size) has
enforced MAX_OBJS_PER_PAGE (32767).  On 64KB pages with s->size =3D=3D 8,
forcing order 2 produces 32768 objects, which fits in the 16-bit OO_MASK of
s->oo but truncates the 15-bit unsigned slab->objects bitfield to 0 in
allocate_slab(), corrupting freelist setup in build_slab_freelist() or
looping in ___slab_alloc().  Finally, if s->size exceeds
PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER when SLUB_DEBUG inflates metadata,
clamping order down makes oo_objects(s->oo) =3D=3D 0 before
do_kmem_cache_create() can reach disable_higher_order_debug.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D16

