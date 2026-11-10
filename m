Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E5E606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK5iaMJw
Received: by kanga.kvack.org (Postfix)
	id 01C566B05B5; Tue, 10 Nov 2026 18:12:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE82D6B05B6; Tue, 10 Nov 2026 18:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24F86B05B7; Tue, 10 Nov 2026 18:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB28D6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D7384018E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:12 +0000 (UTC)
X-FDA: 85420759704.09.45D8F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77F03140006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CK5iaMJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352330;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yd1y30xfWxyUxzfaX1AjVyu+enrOCVVNhLXX5wRV5Wk=;
	b=Ld2lhUyqYHmEe/dV41Xho4fk5ClGtv3vSPSJnbLSAqzx6jDpeqxKoMZ867lSqSvXFo+4o5
	zJFxcX4LTDhEIoS6XsGbe2aSzz+fWS4U/1fO500Z3SwDgMc+cidADvqY2f7qUvk75oprtQ
	cQN3gPGcFOEvGPgVcPrW98UbbBJ7LuA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CK5iaMJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352330;
	b=BNGRf1ZXxzf9AzD1K54CZ/o0/QZD5CwShXXrEtUcPX71X1Brt2A5yMRVWYbZeyX0SENjaQ
	vRgmPd5xbAlNhyUcWWlCV+QEkhqHicCRjpI37U5t1EXhpTM0gxH1spk6RB1f9/BQ/CZlnZ
	Olyt9YEIKDM1dMV7XJrbyf/BLAuJyAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCE1D4234C;
	Tue, 10 Nov 2026 23:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC0D1F0093C;
	Tue, 10 Nov 2026 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352329;
	bh=Yd1y30xfWxyUxzfaX1AjVyu+enrOCVVNhLXX5wRV5Wk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CK5iaMJwQw5JkDqkxG9sNvSX07O+dXHVW7E2kV9R7Yw0EslayAZurMgL9/69QteyB
	 K+3dQrdnq4kcgOEAGT9yOmcj95qcA/OAeQwcgJkJ0XB1sMVL5+CzciipqLruVCJ2Kc
	 /TGuaNiZekbp33+3rvi627gc0wIDKb9L0PPw90OiKlq+nzIPHXQoGLmV+1MpnL3c9h
	 LUp71tBlaVF9pGU4VcBsv14an+UpgCv+dIIdelT62RqUt050RVfZ/eIkrNTcQWrXdG
	 8kcwsCPPlbjZKmgKpzVoSkzBvWnLplB+SdADlRlPzaKthBfNmSr78KZtl4d25Z3zts
	 TwtYk/EP7+NTw==
Message-ID: <sashiko-outbox-207859@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 04/25] iommu/dma: Add PISA block allocation
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
In-Reply-To: <20261109182533.3594984-5-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-5-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:07 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77F03140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dafnngmccest3ujtwuomkobo391c1frm
X-HE-Tag: 1794352330-718909
X-HE-Meta: U2FsdGVkX19T5HfJy/ZSJ06FeYIvMkH4CPLBQiX/EhFmHt6Y7wSluzBtykqyyG4Q6EKDuxHTZ8kflhEJKjv3/rTYVOAB5YtKY0uAkjNeK5Gql94QvhXaz4SaqavPeXSdYeFDU291DMx0pCBsfUHJL5Paw02TiKto4gj8NfRwdOFGLI0tpFXcjvrPkJAlWU3n2juBqwI5Af75Gbq6EFsetX2xEy4Kc+XK+ygpI3uWg9DYdNywNVWunTjo0+OxCeuSDeAlsdG5t/59zw50ocXlNoLByoCS8lIQyr0icI8QEj6A+Tz0Of82O7cxNZUsnCrHZ+k/dkdf11JIQPloey06HRcG4k63+P7uT+zD6YzPPnQmZZH6aqklRHTaGHXDL2YDipwAcc1Tpt6UL+sqD85gZ3XKoGEF09g0DbcDLMoV0GW6VzfwgvjutdQsUPi8oDuZSm8hUCDFBgB+jQqhWFAlk82nobc5Qr8LVWC3lfUXQ5NVHnurJixCI4w3dXHvUUbNFehZZuEZd2T8itl6sepEaPyhRgopIK3A46+CBblq9qWH6wzXdEbKl/nXcj/hlquaaD5MAA+ZTPteQJJQ10FPnk2Im5IbJBzfAHLZ4WHlXkLIrpuidce8sytWri94WUdIL8cIbbxGX3e5aMCwWlLxzcuOUmd1/ZAk33yEnnQvTkv0UmInsgL6Y7jqUyp+zW7hep92KNtu3NrOCyB/X5SrKavpbtzIzuQBwsdVhJLmrJDIUmkZj8E/7J6Eu/8HNuasHojkjH6+y4YU/Nd+KlFZoEp+l7oyDyw0WtK+ohZIcytrLD7VRj6ekLgN1J0XIU2KXNUD8bW3f3+nwmMPUcxZLAJX5GhfHDdFgS4md0G4GOhpLm5MkTozgyzZbbc4lgVwMvYVhQxGe5bTSf904fLoio1Bpb+NqBF/U71hLCEWEVyGTfA9lPfsuCSgCmQ955i5dNmRnKx1ZJHoJaK+oGS
 gpw8RLOs
 VWazEFk8CJ6AiH/gnhr4iwzqzlHzhoPxpbSTkhPmBoqPJHKepwrH1aSRUO6x5S7hHaOklqYXULYvdshZF/YTjcXknV7Y+GEApRAG3cB9tvtR0RPIA+XInchXCx3s0v6wIFUex6A7eyb1qC+dT3MzaqsfqF0kpXHAdFeN7iCjQiRiGh+YNSC0QYluLdXdIJZi0IPpqlXyLCXEaFpR5wu62qHb2OrwlISV6dXX7MKKhvyXT9JseCym83sDhhXtgA92JfUNT8GwtGC8ACY0sQIo4A5HaiLgivkbaq2nIGvyZ4f+7oxnYfGGTXzfC6A4hdGoqHuZhfYttu+Ep9xhZPTCCUz0in5vverJ5PdrjBz16Dtph3pI9jobFsOdmlIRHFcfo7AYKB6dN7iDhTjZxJAycmFB4qvGtARvDVZr2cfx3imghMeWTHD4k156YlJxasTfDp4Nh3VNiVsmlGSBcfzcahTg4mVPBQlfo2866MIIxaKsOcmLieDh3D9hRD1QjUEV0ygzrQi9jGTiuADun+lK3um8tPTR3VxXZ3DQ9UdoZwWOVG/2hRSokeBHNJzC44YmqokMy7ucr/bqcIwTBE9Im0EG5PQPbt3Y284im2Iav6SlaylI5NY0JKuSrWo7Yu7zPMWMv6sHoja13qvxcK/u3qLH4DFdr8jGaJnd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: page_alloc: PISA hooks bypass gfp_allowed_mask and
  current_gfp_context()
- [Medium] iommu/dma: reclaim lock inversion on pisa_meta_mutex in PISA
  page allocation
- [Low] iommu/pisa: KUnit test_alloc_and_recycle() fails when
  SKB_FRAG_PAGE_ORDER is 0
--

commit c88623dbd052fba1d3099d39b6d0533caf0d54a7
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Add PISA block allocation

This commit adds PISA block allocation and compound page splitting, along
with __GFP_PISA_RO and __GFP_PISA_RW flags hooked into the page allocator.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index cf559ee86d6f9..1f1b99023094c 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
[ ... ]
> +/* Obtain and split a new PISA page on @nid into blocks of @order. */
> +static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t=
 gfp, int nid)
> +{
> +	bool can_block =3D gfpflags_allow_blocking(gfp), clean;
> +	unsigned int bpp =3D PISA_BLOCKS(order);
> +	struct pisa_meta *meta;
> +	struct page *page;
> +
> +	/* __GFP_DMA/__GFP_DMA32 were already declined by pisa_alloc_bulk(). */
> +	meta =3D pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, &clean);

[Severity: Medium]
Can a GFP_NOFS or GFP_NOIO allocation invert lock ordering on
pisa_meta_mutex when the reservoir misses?

pisa_meta_init() and pisa_meta_memory_cb() hold pisa_meta_mutex across
GFP_KERNEL allocations, establishing pisa_meta_mutex -> fs_reclaim.  Here,
GFP_NOFS and GFP_NOIO still have __GFP_DIRECT_RECLAIM set, so
pisa_reservoir_pop() -> __pisa_page_alloc() calls pisa_meta_ensure_pfn()
with can_block =3D=3D true while the caller holds filesystem or I/O locks:

drivers/iommu/pisa-meta.c:pisa_meta_ensure_pfn() {
    ...
	if (can_block && !pisa_meta_pte((unsigned long)pisa_meta_array + (idx << P=
AGE_SHIFT))) {
		int err;

		mutex_lock(&pisa_meta_mutex);
		err =3D pisa_meta_prealloc(pisa_meta_array, pisa_meta_nframes, pfn, pfn +=
 1);
		mutex_unlock(&pisa_meta_mutex);
    ...
}

CPU0                              CPU1
----                              ----
lock(fs_lock)
                                  mutex_lock(&pisa_meta_mutex)
                                  apply_to_page_range()
                                    /* fs_reclaim */
                                    lock(fs_lock)
pisa_alloc_split_page(GFP_NOFS)
  ...
    pisa_meta_ensure_pfn(..., true)
      mutex_lock(&pisa_meta_mutex)

 *** DEADLOCK ***

[ ... ]

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index 079f6220e742a..bdc52e6497b05 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c
> @@ -87,9 +90,78 @@ static void test_meta_active_toggle(struct kunit *test)
> =20
>  static void test_alloc_and_recycle(struct kunit *test)
>  {
> -	KUNIT_EXPECT_NULL(test, pisa_create(NUMA_NO_NODE, 0, DMA_NONE));
> -	KUNIT_EXPECT_NULL(test, pisa_create(NUMA_NO_NODE, PISA_ORDER + 1, DMA_B=
IDIRECTIONAL));
> +	const struct {
> +		unsigned int order;
> +		bool ro;
> +	} cases[] =3D {
> +		{ 0, false },
> +		{ 2, true },
> +		{ SKB_FRAG_PAGE_ORDER, true },
> +	};
> +	struct page *p1, *p2, *bulk[3];
> +	struct pisa_alloc *pa;
> +	unsigned int i;
> +
> +	KUNIT_EXPECT_NULL(test, pisa_create(first_memory_node, 0, DMA_NONE));
> +	KUNIT_EXPECT_NULL(test, pisa_create(first_memory_node, PISA_ORDER + 1,
> +					    DMA_BIDIRECTIONAL));
> +	KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, 1, false));
> +	KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, 0, true));

[Severity: Low]
Doesn't this KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, 0,
true)) check fail on arm64 with CONFIG_ARM64_64K_PAGES=3Dy?

With 64KB pages, SKB_FRAG_PAGE_ORDER is get_order(32768) =3D=3D 0, so
pisa_init() populates pisa_nodes[nid].pa[true][0] for the
{ SKB_FRAG_PAGE_ORDER, true } entry that this test also asserts is
non-NULL in the loop below.

[ ... ]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 48df87a19d312..b8e1f0fcb3f41 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
[ ... ]
> @@ -5223,6 +5246,14 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, i=
nt preferred_nid,
>  	while (nr_populated < nr_pages && page_array[nr_populated])
>  		nr_populated++;
> =20
> +	if (unlikely(gfp & __GFP_PISA_RO)) {
> +		nr_populated =3D pisa_alloc_pages_bulk(gfp, 0, preferred_nid, nodemask,
> +						     nr_pages, page_array, false);
> +		gfp &=3D ~__GFP_PISA_RW;
> +		if (nr_populated =3D=3D nr_pages)
> +			goto out;
> +	}
> +
>  	/* No pages requested? */
>  	if (unlikely(nr_pages <=3D 0))
>  		goto out;
> @@ -5457,6 +5488,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp=
, unsigned int order,
>  		fastpath_alloc_flags |=3D ALLOC_WMARK_LOW;
>  	}
> =20
> +	if (unlikely(gfp & __GFP_PISA_RO)) {
> +		page =3D pisa_alloc_pages(gfp, order, preferred_nid, nodemask);
> +		if (page)
> +			return page;
> +		gfp &=3D ~__GFP_PISA_RW;
> +	}
> +
>  	gfp &=3D gfp_allowed_mask;
>  	/*
>  	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS

[Severity: Medium]
Should both PISA hooks run only after gfp &=3D gfp_allowed_mask and
gfp =3D current_gfp_context(gfp)?

Callers inside a memalloc_nofs_save() or memalloc_noio_save() scope (or
during system suspend when pm_restrict_gfp_mask() clears __GFP_IO |
__GFP_FS in gfp_allowed_mask) pass GFP_KERNEL | __GFP_PISA_* and rely on
the page allocator to strip __GFP_FS and __GFP_IO.  Passing the raw gfp
into pisa_alloc_pages_bulk() and pisa_alloc_pages() lets
__pisa_page_alloc() see (__GFP_FS | __GFP_IO) still set:

drivers/iommu/pisa-node.c:__pisa_page_alloc() {
	if (unlikely(!static_branch_unlikely(&pisa_key))) {
		if (!can_block || (gfp & (__GFP_FS | __GFP_IO)) !=3D (__GFP_FS | __GFP_IO=
) ||
		    pisa_meta_init())
			return ERR_PTR(-EAGAIN);
	}
    ...
	if (can_block)
		memflags =3D pisa_memalloc_save(gfp);
}

As a result, __pisa_page_alloc() can invoke pisa_meta_init() inside a
NOFS, NOIO, or suspend context, and pisa_memalloc_save(gfp) fails to set
PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS when gfp_allowed_mask has restricted
I/O or filesystem reclaim.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D4

