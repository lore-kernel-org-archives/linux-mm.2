Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F218A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRTeg4jX
Received: by kanga.kvack.org (Postfix)
	id 573816B05BB; Tue, 10 Nov 2026 18:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AF76B05BC; Tue, 10 Nov 2026 18:12:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461F66B05BD; Tue, 10 Nov 2026 18:12:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 107DD6B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8353DA01AF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:19 +0000 (UTC)
X-FDA: 85420759998.29.DBD6F86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED05E180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRTeg4jX;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352338;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs5I5HWBogETsHUVSedLWngXLC3YD8dqeNwb+5ZmA00=;
	b=RXJwTSD/a3Pe2nl0uu2eZtnH3mdSoRE//wnTC3TGp3A3/SjWPif1PcGuDMFqJttTD5yw7S
	ONsX0NV+j1yx54cgwPm368K3zids2ou+/FkikWLtzoqNjcws+HzRcJte528ZxfJ5KizHIG
	hYw+apvHWRQV6tp+vPRwaQtw3x7itCY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352338;
	b=MZ7mIeYpN0CBCKZ2HLFNbCHzd5sbm15sSoY9C5gBftWZSuV7R+cnDRNt4nVtkVb/ZAvoIs
	5+4TqpZNkw/YKZhgekXswfqFZ52lwc8A5jWaouS7K8/IbxjYA5DfCYOxw/7nD7EiARRAK/
	jESrfm6sIPF/tkjHLvYxuu6DNe9Uzzk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRTeg4jX;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83D4F6346A;
	Tue, 10 Nov 2026 23:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70291F0093C;
	Tue, 10 Nov 2026 23:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352337;
	bh=fs5I5HWBogETsHUVSedLWngXLC3YD8dqeNwb+5ZmA00=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRTeg4jXmCaEZMVl+iN+LiP7ow5PBrqOBdiuK39cLr2EYHzN9RjZSYYTJQXzWJVpe
	 09w/XQB5U//SiD70FKQ6EZ1ujgBB0XoaVMWXLcTkeYzLj9PVaynpDqHdQLzblQor3Y
	 ysDlPzjwLsdC8q3EG9dXL+3n9OoctaE4iL/fQ9iNitjUbx+/ZYDAeZPBgHH1UiqPs6
	 6INU2i8ZSgkeIU/A5964ziYoV6FXoDXZRx8ep2we25SDJkzzexn3a+aCb0w+1Rr6Ng
	 XbK1+vkBaEh+wJ3stss7MuRuYmaZ6InrGzqs3p4NYzDdehb6awP/PEz27YiY0PrTGU
	 NYyfVOuCD08Rw==
Message-ID: <sashiko-outbox-207865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 10/25] iommu/dma: Use PISA for coherent DMA
 allocations
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
In-Reply-To: <20261109182533.3594984-11-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-11-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:15 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 37tfqzb63a4d55p389orbcgugmtb66fx
X-Rspamd-Queue-Id: ED05E180005
X-Rspam-User: 
X-HE-Tag: 1794352337-40410
X-HE-Meta: U2FsdGVkX19FIMdSGwTJ/xxN8QV1xgAmOtGoh0dOhhkbLkSB+kScavWWriz2B+KCMSxbyhhhwuYNs1DsotEUQsr45oZ6O0yuqCp5VlyOz5aFAf1w/CYenBxUcm/HOKlsL0oIPt9oQqjSwJxafXXDWlzLNQgBIXJIEM511lhFsKkAmScZ+Dwb3nYefsfZDD1dHyDXILoGU/zGfK+psDoT63qDxgAUmNOe3APgHi1Fh6vglgN4ZZaJxmM+sbQvhY6d+FKtvItyzZ7CFhH+pImghWslbFFQxbxFGafTSZDPk/EDLvAnGOHZKwCQtAN4nv7MLZjCMht4Mh3kWs8HUS33OdHCEu1aeKt8KF4J28434lrBINDmnDJ8lQG23hv9g0LPLCj+A/n0Nvmo68w98AiAHN1aulXwCbET4pe9Ts3+4LH6k8XfxBs0pG5Q295u/qKke30/gQknfOxJj3IF3DYHDeanWMYoUnoSsDH+zjgAIQNkWNyEtFjJll6aNaCuIYuHHfTh/PRAW4xuBg61XOxmjKrq7d6oSKrs9kjQrsy0jMxmUITWLXMsQEdHQHlwYvn+cmA9GMJVjTBsRU7MohYRt5msrixRn9/qEM5t8755jGA0f/FpD3Xu1s1/iwSQCex5OX0vmimz6NMLsTGN0no5a7d5/xFqj6v59ORRJk53Hyjsed3TVtAKKulZHpr93/snoTI4TDBVKWpMW+ofSiEuMM7MWrD6BkB+fWHn5kCl05/TNCFYCyAoF84l7caFdcYRBZ0Xhlea36dKTis/5dpGL+bIi/vQyIELdgBibjLok710/zLGEVgIA+U+kuY4VySNSzSYoCU2qP6A4Tx859ZMF05pYx391blWidktR2NYKJv2JY0HWFtCiJm3hjEVJX7wIoTR9JcGSIcQNWRJgmjTSb/VTOB6p+XyAPOalMMjPfYuZ7PMY7nnAFRIC1pQG+UfGwKKHRKrAFoymJaVSrW
 tuAxj8D5
 0naDqwJuZ/p6OjbD232VfwxSWH79/cEoJ8y90UGaMK3S4T3XdquUkzNxRlExBqNA+X4vYkf0en5I/c4oQ6sfNAEUI8//LNNFi73/bjsh2MklRzzbEhNjOxoGi3UG3+fnQRsVHWDbG/W7JrNIMzkzlHWa9tKVDZm6lfyMMfL+8EPqQ5YJunrvaPJtLUtjmvj7sof8mCfS0+FvBQhoZS5B2StdhWjIELKM/RQDovirN/SSrRKwZ2Myt8GxHj8VNFRKWlBPLl+VabWZGrfQ9FAZ4clv01FfH0+ewl0jcy+sIRhtm7czhfLhMTZZ+pZRf9nf4PKerFLL+P317h0/94ctoQiaGx9VSBuqbwmTcSLwXiumJTa43TMMOBvLVTL5jd2AsMKUBN8wAo1VBo6uP4zdDyhd+boUNMRvtsqWgiC32DyXxlPb4oNZAoXilDGmkHnrZWhe94acY0Kc8oN2mNC3vvRfjdELrmfsLl8wzy4r3KWRWUKk2K6D/iIdQ4+m3ni5CuTtXBzm+1R2EbYh1YUpKE3/sFY8pEdDVPqHI4gVz/O7hps8m/2owXH46IP3AYsB9QfIec+oILI4Ji/y4o3kJSiWs/V0gGznRQT19mZwtIbZKim3p0oiYgAvJ34QA5GYNq+aT3F0rJ3UsyJW9UR7ObRQ0D9jqIOl9z7lM
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
- [Medium] iommu/pisa: unsafe list_for_each_entry() in
  pisa_alloc_coherent()
- [Medium] iommu/pisa: NULL deref in is_swiotlb_for_alloc() in KUnit
  test
- [Medium] iommu/dma: incomplete DMA range check in
  pisa_alloc_coherent()
- [Low] iommu/dma: uninitialized stack device in
  test_coherent_alloc_and_free()
--

commit 707db606f2421a5bae5c7fa193156ad4c820f976
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Use PISA for coherent DMA allocations

This commit serves coherent DMA allocations up to 2MB from the per-NUMA-node
order-0 read-write PISA allocator when dev->pisa_coherent is enabled.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index b0d968aa9181c..25e4645310678 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
> @@ -10,6 +10,8 @@
>  #include <linux/bitops.h>
>  #include <linux/cache.h>
>  #include <linux/device.h>
> +#include <linux/dma-direct.h>
> +#include <linux/dma-map-ops.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/pisa.h>
>  #include <linux/export.h>
> @@ -697,6 +699,150 @@ unsigned long pisa_alloc_bulk(struct pisa_alloc *pa=
, gfp_t gfp,
>  	return i;
>  }
> =20
> +/* Find and reserve @nblocks aligned contiguous blocks in @meta under @p=
a->lock. */
> +static struct page *pisa_take_contig(struct pisa_meta *meta, unsigned in=
t nblocks,
> +				     unsigned long align_mask)
> +{
> +	DECLARE_BITMAP(busy, PISA_MAX_BLOCKS);
> +	struct pisa_alloc *pa =3D meta->pa;
> +	unsigned int bpp =3D PISA_BLOCKS(0), i;
> +	bool poisoned =3D false;
> +	unsigned long off;
> +	struct page *page;
> +
> +	if (pisa_meta_avail(meta) < nblocks)
> +		return NULL;
> +
> +	bitmap_or(busy, meta->clean_bitmap, meta->dirty_bitmap, bpp);
> +	bitmap_complement(busy, busy, bpp);
> +
> +	off =3D 0;
> +	for (;;) {
> +		off =3D bitmap_find_next_zero_area(busy, bpp, off, nblocks, align_mask=
);
> +		if (off >=3D bpp) {
> +			if (poisoned) {
> +				if (meta->on_list =3D=3D PISA_LIST_IDLE_CLEAN ||
> +				    meta->on_list =3D=3D PISA_LIST_IDLE_DIRTY)
> +					pa->num_idle_pages--;
> +				pisa_place_meta(meta);
> +			}
> +			return NULL;
> +		}
> +
> +		page =3D pfn_to_page(pisa_meta_to_pfn(meta) + off);
> +		for (i =3D 0; i < nblocks; i++) {
> +			if (!pisa_block_poisoned(pa, page + i))
> +				continue;
> +			if (__test_and_clear_bit(off + i, meta->clean_bitmap))
> +				meta->nr_clean--;
> +			else if (__test_and_clear_bit(off + i, meta->dirty_bitmap))
> +				meta->nr_dirty--;
> +			__set_bit(off + i, busy);
> +			poisoned =3D true;
> +			off +=3D i + 1;
> +			break;
> +		}
> +		if (i =3D=3D nblocks)
> +			break;
> +	}

[ ... ]

> +void *pisa_alloc_coherent(struct page **pagep, struct device *dev,
> +			  struct iommu_domain *domain, size_t size,
> +			  gfp_t gfp, unsigned long attrs)
> +{
> +	bool should_release =3D false;
> +	struct list_head *lists[3];
> +	unsigned long align_mask, flags;
> +	unsigned int nblocks, i;
> +	struct pisa_meta *meta;
> +	struct pisa_alloc *pa;
> +	struct page *page =3D NULL;
> +
> +	size =3D PAGE_ALIGN(size);
> +	if (!pagep || !dev || !READ_ONCE(dev->pisa_coherent) ||
> +	    !dev_is_dma_coherent(dev) || !size || size > PISA_SIZE)
> +		return NULL;
> +	if (min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit) <=3D DMA_B=
IT_MASK(32))
> +		return NULL;
> +	if ((current_gfp_context(gfp) & ~(__GFP_ZERO | __GFP_NOWARN)) !=3D GFP_=
KERNEL ||
> +	    (attrs & ~DMA_ATTR_NO_WARN))
> +		return NULL;
> +
> +	if (domain) {
> +		struct pisa_window *win =3D pisa_dma_window(domain);
> +
> +		if (!win || pisa_window_declined(win) || !(domain->pgsize_bitmap & PIS=
A_SIZE))
> +			return NULL;
> +	} else if (is_swiotlb_for_alloc(dev) ||
> +		   force_dma_unencrypted(dev) ||
> +		   !dma_coherent_ok(dev, PFN_PHYS(max_pfn) - 1, 1)) {
> +		return NULL;
> +	}
> +
> +	pa =3D pisa_node_pa(dev_to_node(dev), 0, false);
> +	if (!pa)
> +		return NULL;
> +
> +	nblocks =3D size >> PAGE_SHIFT;
> +	align_mask =3D (1UL << get_order(size)) - 1;
> +	lists[0] =3D &pa->partial;
> +	lists[1] =3D &pa->partial_dirty;
> +	lists[2] =3D &pa->idle;
> +
> +	spin_lock_irqsave(&pa->lock, flags);
> +	for (i =3D 0; i < ARRAY_SIZE(lists) && !page; i++) {
> +		list_for_each_entry(meta, lists[i], list) {
> +			page =3D pisa_take_contig(meta, nblocks, align_mask);
> +			if (page)
> +				break;
> +		}
> +	}

[Severity: Medium]
Can list_for_each_entry() walk off lists[i] onto a different list when
pisa_take_contig() encounters a poisoned block?

If pisa_take_contig() clears a poisoned block in meta and then fails to
find nblocks contiguous blocks (off >=3D bpp), it calls pisa_place_meta(met=
a)
before returning NULL.  pisa_place_meta() can move meta->list to another
list (for example from pa->idle to pa->partial, or from pa->partial to
pa->partial_dirty or pa->full).  Because pisa_take_contig() returns NULL,
list_for_each_entry() does not break; it follows meta->list.next on the new
list while testing for termination against lists[i], and then treats the
new list's head embedded in struct pisa_alloc as a struct pisa_meta.  Using
list_for_each_entry_safe() avoids following relinked nodes.

[ ... ]

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index ab64657ad5c58..72ee8986b4802 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c
> @@ -352,6 +352,72 @@ static void test_map_and_domain_lifecycle(struct kun=
it *test)
>  }
>  #endif /* CONFIG_IOMMU_DMA */
> =20
> +static void test_coherent_alloc_and_free(struct kunit *test)
> +{
> +	struct device dev =3D { .init_name =3D "pisa_kunit", .numa_node =3D NUM=
A_NO_NODE,
> +			      .coherent_dma_mask =3D DMA_BIT_MASK(64),
> +			      .pisa_coherent =3D true };

[Severity: Medium]
Does passing this stack-allocated struct device with a NULL domain to
pisa_alloc_coherent() cause a NULL pointer dereference when
CONFIG_DMA_RESTRICTED_POOL is enabled?

Because dev is neither initialized via device_initialize() nor
swiotlb_dev_init(), dev.dma_io_tlb_mem is NULL.  When
test_coherent_alloc_and_free() later calls pisa_alloc_coherent() with
domain =3D=3D NULL, pisa_alloc_coherent() calls is_swiotlb_for_alloc(dev),
which dereferences dev->dma_io_tlb_mem->for_alloc under
CONFIG_DMA_RESTRICTED_POOL=3Dy.

[ ... ]

> +	/* Freeing p1 returns its 16 order-0 pages; next 64K alloc reuses them.=
 */
> +	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p1, SZ_64K));
> +	v3 =3D pisa_alloc_coherent(&p3, &dev, NULL, SZ_64K, GFP_KERNEL, 0);
> +	KUNIT_ASSERT_NOT_NULL(test, v3);
> +	KUNIT_EXPECT_PTR_EQ(test, p3, p1);
> +
> +	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p2, SZ_64K));
> +	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p3, SZ_64K));
> +}

[Severity: Low]
In addition to the uninitialized dev.dma_io_tlb_mem above, does this call
with domain =3D=3D NULL fail the test and leak p2 on Confidential Computing
guests?

When domain is NULL, pisa_alloc_coherent() rejects the allocation if
force_dma_unencrypted(&dev) is true, so v3 is NULL and
KUNIT_ASSERT_NOT_NULL(test, v3) aborts before pisa_free_coherent(p2, SZ_64K)
runs (until commit "iommu/dma: Support decrypted PISA pages" later in the
series).

[ ... ]

> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 25e9a86835fd3..11052b65e573b 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -244,6 +245,12 @@ void *dma_direct_alloc(struct device *dev, size_t si=
ze,
>  	if (attrs & DMA_ATTR_NO_WARN)
>  		gfp |=3D __GFP_NOWARN;
> =20
> +	cpu_addr =3D pisa_alloc_coherent(&page, dev, NULL, size, gfp, attrs);
> +	if (cpu_addr) {
> +		*dma_handle =3D phys_to_dma_direct(dev, page_to_phys(page), false);
> +		return cpu_addr;
> +	}

[Severity: Medium]
Can dma_direct_alloc() return a valid cpu_addr with *dma_handle set to
DMA_MAPPING_ERROR (or an out-of-mask DMA address) when dev->dma_range_map
does not cover all of system RAM?

pisa_alloc_coherent() only checks dma_coherent_ok(dev, PFN_PHYS(max_pfn) - =
1, 1)
before allocating, and dma_direct_alloc() does not check
dma_coherent_ok(dev, page_to_phys(page), size) on the allocated page.  If
dev->dma_range_map covers the top of RAM at max_pfn - 1 but has holes in
lower RAM (where !dma_direct_all_ram_mapped(dev) is true, as in
a409d9600959 ("dma-mapping: fix dma_addressing_limited() if dma_range_map
can't cover all system RAM")) or translates regions with different offsets,
pisa_alloc_coherent() can return a page outside dev->dma_range_map and
phys_to_dma_direct() will set *dma_handle to DMA_MAPPING_ERROR.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D10

