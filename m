Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC810606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yb1gq23E
Received: by kanga.kvack.org (Postfix)
	id 4D7B76B05BC; Tue, 10 Nov 2026 18:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B00C6B05BD; Tue, 10 Nov 2026 18:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6826B05BE; Tue, 10 Nov 2026 18:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01F7B6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AA76A01AF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:21 +0000 (UTC)
X-FDA: 85420760082.05.813EBC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2B29C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yb1gq23E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352340;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rndOsQi425xgDTsXXY5I0ThFNzqgz5wZx+Izz6WvZP8=;
	b=PaXkz6dx3tHYJcyLC0yjIVGBZDk5GfQQZA6SS+JcQT3eqpw9TtcdDoG6/2R+yEx/iNbu5Y
	dH/0f9szMmwbGAUO2D6viZthIcb+FmPcow8MizorfLnL/SPKPZLc6L/YBwaVwiKQmfslQa
	PmA04LN9uR6u/M1mBIekrwbJ+CIoxPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352340;
	b=eLTWXQq99Xnj6W+Ac7XR4qqgBGpwUkqC6jad4PbEdkcuv7Gric1eG4Kap4PflzSEPZnnl/
	kI4axibvhIzDkkJoSlnsUForQ1cKjXF5ThmMy3yCoYn2DDGBhY4JQWBzLz1WNd/8tt33Rw
	itQ2Y6yFnGp65Ae75xaUKkbMPDJtjDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yb1gq23E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B7B94234C;
	Tue, 10 Nov 2026 23:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D8E1F0093C;
	Tue, 10 Nov 2026 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352339;
	bh=rndOsQi425xgDTsXXY5I0ThFNzqgz5wZx+Izz6WvZP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yb1gq23EVRXbdLpbvOzd7GAtNe1L00Gj9dbFywk9/sWh7PpxiXnLQ+T7KIGI1T3so
	 t9zd0pwsHfKy2jP+uUo5QIoBVWBZkvBo71yQAcx49bIXughw1f1maZHoGeUS9RqQue
	 MBz4egN6l4writFLSe/CMHAL6ZgRYsv48TgCwQvSpTYVesmJVpB6naX0YzmN90/C2P
	 ZuNeZ/6WwTIJQvmrj0wXj7JHhG1u5zX+/RgrfTVUx6v71Ymv+yCSpAay5RYAWkV826
	 1iVkFBLxsT4ehAOOvO3RUsCj/N4AFQK/iNdUhzmjIF/G/fxW42XWNoxWlQB9EyIoZj
	 yl8PSYpaRH9qw==
Message-ID: <sashiko-outbox-207866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 11/25] iommu/dma: Add per-CPU block caches to
 PISA allocators
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
In-Reply-To: <20261109182533.3594984-12-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-12-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:17 +0000
X-Stat-Signature: rbmqm91gy17tcdbbj1d9dh7spyjkihtf
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2B29C0006
X-HE-Tag: 1794352339-778977
X-HE-Meta: U2FsdGVkX1/KIatBgEMANOALw8Z9wMrxPrYo6YKPk1QxJ+azH83TjjhtiFT3HHFmkHew25UiPhwc70WOVB3nh7RWQEBTQZJJsBwlGPA0Nfvxf8YxlOLBhO3+8SlMlRJhkI+VkfSeRy7+SAMyE+7FPCT0Affc5xOdcKC4LAopksDRE4Wr6poDko8bNW8wR6Xq6UCmDodE8HrrZhz0O6Cc0BvP5TKD7HwijnhsveEvKHLrFHb8SkGDxmhEhSnIVk1zHMsJpsgGf1qGpdtBvolHqsX9qSAnJ0ooB1+AR+UQhZYvjD/Ya7Gx+RqgnWl2p4M/WzM4THfiMqc6dL8C/Aei1nGliZSceVKA0xTvcx/tyBILtZkTGi+1U/T4a51qG3MUaE8yG447Ri2uMDZL+FT05Br84z1kfVgnBlQBOzw1XospKOdHtZN3OlA/T4HZiSTd99pOA07kHNa35AMHpiK5gRgStHxyFnYwp+RkQQSkxzHoprW3ov9H5ISQYubPz6+myPOxhUBSC3aBLdmoM+oTF5GIa1MO17F10GsJYOotgfNniKu/CGLMRmHduBn972fWb1SRzIR4LqZgfc6JPQcCBKKG/oFgjyRHl0VAWi70Sbetd6fOTl8ThxIgeQixSJxiTIqTG9UQPnyvwmAdt2mQuEhSHH6UxlnKRBtRLMh1fmoK4QvlKt/u6AeRNx+NbmVW8yNuf3ekAvQLkKjzoKObGh0ftQW620jpYYKacZrk5RWHRENxvKWZgVNT3KdPa+ZDKzcR8v++IJlDbBYqeE3kc7ilxJF4Er8/Mke9gAlfY5VM1iM2z0LHYEyAh2S5hrTTgGaszmedYXbYCQPCvR5CvtZRVf01QMzBJ/n5SV4/BgQZAOGOPgP2gxbc2SG6dJonIaFWMO1n1BNI6hVqkecDlo5XOQuLWt+Jnq5SzftbJFo5seW6g0CjEhTd3IB9c+AULkTZxZT53HVuBxfQEma
 71wGedRK
 bKIaoo4iobTlYPgfmUDYYCF/tbAEf6dR5nSelcYSIjVDN7pFk/i++kTzZh4UxHSmgOyfBHYK3p81C6r3qGBFHTSj0ZcE2wgkL5aTW2TtHAMouFd4X0WMc018CCqpHDFadfA6dwktYSCvwCWibt1m+Sa4d4Gxk9b0ip5rAabsJFpdRO8lcUhTW6GN/p3TR96Xt5hrQGdajM3GGRoXW33e00mgjwzCtIXDZGf6EeJSai96uW/oEgFBlTcbg5beY5vEtz8IUu2eXwxATLBHeNOp+64XEMEPoHZsgQz4f8Em+j9BZLnBbZ/ueCQkNOIXeJ9pZxFZw63pyl79AH1XQQ4Uk6Z/BbFA9RJz5oSg2Wzk8D8RknR/igljUOaUWVkUrSB+bmX1GqoFO+g1gKD48Hd5uh/Voc3pCulJqx46M37/wofqP9/gPTK/lbaWowDqu8xvmDUmnGeKrPiikAshIIzpHRSPzH+JeHpytLwPkRRby4yGqQos0vaS7d6L38KgC7Il87RWs79q9FYpVhNkQYDWxLu0GesjKQR1WYFN6sM9nOpj/LE++yy+GoVmn1aiUuGLjjWHONDg+8yJuYXuL4OLnds4NXxyeJA9KAz4Z9CtcXfAFCxqF5RREhf/J9JgFVRSy61eI+vCR37fh6ebwUU3FBYEyNGb+By0hlorXOiHDep58tsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] iommu/dma: cross-node per-CPU cache refill in
  pisa_alloc_bulk()
- [Medium] iommu/dma: hardcoded order 3 in test_gfp_pisa() fails on
  16K/64K pages
- [Low] iommu/dma: changelog omits pisa_page_can_recycle() and
  pisa.compact
- [Low] iommu/dma: short allocation in pisa_pcp_alloc() on poisoned
  block
--

commit 6d45ca2b93f2e0d3d72f8ae4375bcf8901944ad1
Author: Luigi Rizzo <lrizzo@google.com>

> iommu/dma: Add per-CPU block caches to PISA allocators
>
> Every block allocation and free takes the allocator's lock. Highly
> concurrent users e.g. socket tx fragments, can cause significant lock
> contention.
>
> Add pisa_enable_pcp(), an opt-in per-CPU front cache, similar
> to the page allocator's per-CPU lists:
>
> - Each per-CPU cache keeps up to 64 free blocks, and refills it from
>   the main allocator in batches of 32.
> - returned blocks belonging to the local NUMA node are kept in the local
>   cache.
> - returned blocks belonging to a remote NUMA node are returned to the
>   proper per-node allocator.
> The cache is fully integrated with the shrinker and CPU offlining to
> drain the cache.
>
> Enable per-CPU caches for the per-node order-0 RW and SKB_FRAG_PAGE_ORDER
> RO allocators.
>
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>

[Severity: Low]
This isn't a bug, but this patch also adds and exports
pisa_page_can_recycle(), the pisa.compact module parameter, and the
per-allocator block and page accounting used for soft compaction, none of
which are mentioned in the commit message.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index 25e4645310678..913706a503341 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c

[ ... ]

> +/* Allocate @nr_pages blocks through this CPU's cache, refilling in batc=
hes on miss. */
> +static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, un=
signed long nr_pages,
> +				    struct page **page_array, bool frozen)
> +{
> +	unsigned int pcp_batch =3D READ_ONCE(pisa_pcp_batch);
> +	unsigned long got, n, i, j;
> +
> +	got =3D pisa_pcp_pop(pa, nr_pages, page_array);
> +	if (got < nr_pages) {
> +		if (nr_pages - got >=3D pcp_batch) {
> +			got +=3D __pisa_alloc_bulk(pa, gfp, nr_pages - got,
> +						 page_array + got, false, true);
> +		} else {
> +			struct page *batch[PISA_PCP_BATCH];
> +
> +			n =3D __pisa_alloc_bulk(pa, gfp, pcp_batch, batch, false, true);
> +			for (i =3D 0; i < n && got < nr_pages; i++)
> +				page_array[got++] =3D batch[i];
> +			if (i < n)
> +				pisa_pcp_push(pa, batch + i, n - i);
> +		}
> +	}
> +
> +	for (i =3D j =3D 0; i < got; i++) {
> +		struct page *block =3D page_array[i];
> +
> +		page_array[i] =3D NULL;
> +		/* Poisoned while cached: leak it, as pisa_scan_bitmap() does. */
> +		if (pisa_block_poisoned(pa, block))
> +			continue;
> +		pisa_block_prep(block);
> +		if (want_init_on_alloc(gfp)) {
> +			memset(page_address(block), 0, PAGE_SIZE << pa->order);
> +			if (frozen) /* Order zeroing before caller publishes the page. */
> +				smp_wmb();
> +		}
> +		if (!frozen)
> +			page_ref_unfreeze(block, 1);
> +		page_array[j++] =3D block;
> +	}
> +	return j;
> +}
> +
>  /**
>   * pisa_alloc_bulk - Allocate up to @nr_pages blocks from @pa
>   * @pa: Allocator to allocate from
> @@ -681,11 +952,16 @@ unsigned long pisa_alloc_bulk(struct pisa_alloc *pa=
, gfp_t gfp,
>  			i++;
>  			continue;
>  		}
> +
>  		/* Fill the run of @n NULL entries at @i. */
>  		for (n =3D 1; i + n < nr_pages && !page_array[i + n]; n++)
>  			;
> -		got =3D __pisa_alloc_bulk(pa, gfp, n, page_array + i,
> -					want_init_on_alloc(gfp), frozen);
> +		/* Pairs with smp_store_release() in pisa_enable_pcp(). */
> +		if (smp_load_acquire(&pa->pcp))
> +			got =3D pisa_pcp_alloc(pa, gfp, n, page_array + i, frozen);
> +		else
> +			got =3D __pisa_alloc_bulk(pa, gfp, n, page_array + i,
> +						want_init_on_alloc(gfp), frozen);
>  		i +=3D got;
>  		if (got < n)
>  			break;

[Severity: Low]
If a block popped from pa->pcp was poisoned while cached, does
pisa_pcp_alloc() return fewer than n blocks without refilling a
replacement?  Unlike pisa_scan_bitmap(), skipping the poisoned block after
the refill stage causes pisa_alloc_bulk() to see got < n and abort the
allocation early even when healthy blocks are available.

[ ... ]

> @@ -876,6 +1158,17 @@ bool __pisa_free_page(struct page *page)
>  	if (want_init_on_free())
>  		memset(page_address(page), 0, PAGE_SIZE << pa->order);
> =20
> +	/* Pairs with cmpxchg_release() in pisa_enable_pcp(). */
> +	if (smp_load_acquire(&pa->pcp) && pa->nid =3D=3D numa_mem_id() &&
> +	    page_to_nid(page) =3D=3D numa_mem_id()) {
> +		if (pisa_page_can_recycle(page)) {
> +			pisa_pcp_push(pa, &page, 1);
> +			return true;
> +		}
> +		if (this_cpu_read(pa->pcp->count))
> +			pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
> +	}

[Severity: Medium]
Can pisa_alloc_bulk() -> pisa_pcp_alloc() populate pa->pcp on a CPU where
numa_mem_id() !=3D pa->nid?

__pisa_free_page() only pushes freed blocks to or compact-drains pa->pcp
when pa->nid =3D=3D numa_mem_id(), but pisa_alloc_bulk() calls
pisa_pcp_alloc() without checking whether the current CPU belongs to
pa->nid (and __pisa_alloc_bulk() can also sleep and migrate the task
before pisa_pcp_push() runs).

On a multi-node NUMA system, a cross-node allocation refills 32 blocks and
leaves up to 31 blocks cached in that remote CPU's pa->pcp, where normal
frees never compact-drain them and CPUs on pa->nid never pop them, pinning
their backing 2MB PISA pages in pa->blocks_in_use.  This also causes
test_pcp_cache() and test_alloc_and_recycle() in drivers/iommu/pisa-kunit.c
to fail KUNIT_EXPECT_PTR_EQ(test, p2, p1) whenever the KUnit kthread runs
on a CPU with numa_mem_id() !=3D first_memory_node: p1 =3D pisa_alloc(pa, .=
..)
refills 32 blocks into the remote CPU's pa->pcp and returns batch[0],
__free_page(p1) bypasses pa->pcp and returns p1 to the bitmap, and
p2 =3D pisa_alloc(pa, ...) pops batch[31] from pa->pcp instead of p1.

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index 72ee8986b4802..5bbb540eb505e 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c

[ ... ]

> +static void test_gfp_pisa(struct kunit *test)
> +{

[ ... ]

> +	p_ro =3D alloc_pages(GFP_KERNEL | __GFP_COMP | __GFP_PISA_RO, 3);
> +	KUNIT_ASSERT_NOT_NULL(test, p_ro);
> +	if (p_ro) {
> +		KUNIT_EXPECT_TRUE(test, is_pisa_page(p_ro));
> +		KUNIT_EXPECT_EQ(test, pisa_meta_of_pfn(page_to_pfn(p_ro))->prot,
> +				IOMMU_READ);
> +		__free_pages(p_ro, 3);
> +	}

[Severity: Medium]
Should test_gfp_pisa() pass SKB_FRAG_PAGE_ORDER (or 2) instead of
hardcoding order 3?  pisa_init() only creates read-only per-node
allocators for orders 2 and SKB_FRAG_PAGE_ORDER, and on arm64 with 16KB or
64KB base pages SKB_FRAG_PAGE_ORDER is 1 or 0, so order 3 has no read-only
PISA allocator and falls back to the buddy allocator, failing
is_pisa_page(p_ro).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D11

