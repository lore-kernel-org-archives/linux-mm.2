Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09B8606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYXvsP88
Received: by kanga.kvack.org (Postfix)
	id 0141B6B05B1; Tue, 10 Nov 2026 23:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05FF6B05B2; Tue, 10 Nov 2026 23:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8EA6B05B3; Tue, 10 Nov 2026 23:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B09276B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:16:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37B4F1401E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:16:27 +0000 (UTC)
X-FDA: 85421526414.04.FFB22CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 858F1180005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:16:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYXvsP88;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794370585;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrIpfAMNHJbZalOZs5RuSt0edkTTiRu1LjQMjOhXD2E=;
	b=UIb/Ubtbo02rQ05MzUY+FWiUg7vBhiCG3i6cDK9jnjbgsuAp3M2NlIO/fWvwFQsSU74GdW
	sWqQ3KJzYiwtq33u/uZxTnEnm+Zq6MqxjemuN4RQ+XlCfaKo2sBXDVAjYp5JNJZaYN0ECs
	5qaoPYwPIBZYI06Z/kKveazV+LC8WHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794370585;
	b=jtG3YQw6tHd8u69RQyyLzeEplBQw4+8JvzDjahLFR0NJ90JlNtKI0tkVL8FSbzpf+QSLlY
	i4Wwd/T1/UhemXGWB5UXesBjd1mpStEoPzpMlqGA8mH4k1oxnvUcuSS1QVbwoeMsUJeDrE
	8KrfZJO9Adtm5TS6ZPBFX8McWwHeb5k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYXvsP88;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9F0C407E6;
	Wed, 11 Nov 2026 04:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474A51F0089F;
	Wed, 11 Nov 2026 04:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794370584;
	bh=HrIpfAMNHJbZalOZs5RuSt0edkTTiRu1LjQMjOhXD2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AYXvsP88Ieo8GQgx81K4lEwcpnJQJafslV2jSTEwE8rWS/WWZET9PTpRf3ujgQHOD
	 B+pd8gJt9lZJbE+uwf7UIA/lqCeIptkR7XCCQA6Xb49P4et+hOKQssdZKbQ4fsadD/
	 wxegxa9/DuNoQwjsNCny3vqeGUuKMwlqx2YoiDIVHx2TxQN8FV9Ya2U4REgfTnKA+5
	 wkS3M55afKwS9cN6DFkJiMZkWAKiVeo5yQmVo4r46HlhTC3emZI9cygHWZ1uUGg1cr
	 lO0LiPnrklmeQS4aFtvEVxPcCH5nQWxFRAuxhgiClSquYYwBD7IZT4mAhnKZmkMhQj
	 0oIrbXkHIgC2g==
Message-ID: <sashiko-outbox-208265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 23/25] block, mm, iommu/dma: Support PISA for
 disk I/O and scrub migration
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
In-Reply-To: <20261109182533.3594984-24-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-24-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 04:16:22 +0000
X-Stat-Signature: d17zqzzm46x1fay1m31hrddsnmz1ihjk
X-Rspamd-Queue-Id: 858F1180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794370585-18352
X-HE-Meta: U2FsdGVkX19tHCDrcQ475A5bpEUfLHPZPazVUX1HXaJoVAY/epoURZp90EKv9Ce16HLatW2nzOK+NuLUCMyLdNvZuYFNd62ecn1kNisBr5MeqDQ8Mo4GcEZlCSBhlbQtqPiRDHDPRZ8s/tgAgiqu8jAYPSrarSPT2EuXlRlfWUZGUsa9HXDaMjm7Rn33AOCJOIpjCKycBfowwD59Umw1Udrr/wzhQJGv8zskseH+v1tDi8h2Eq1VrM7U26U88eg3RyQkhOfRoqCwOCk+6Ng8twSFUBB5qO7UadDk7sjUUpho3n+oBgHLC0dC07kpAujIv0yuTfAJ2/RMX6O6WqXrPEQSy9tKXuh6XhKe9/0EfZ9mHmZmnyy0aOq8Hd3WH+QQWz6yWw6mL3Kf6BkBRub9eD9V5MONIMgS/b94ExP0vLmlrJuHOfo6yZoIlzJq7IVj8833/iXAclfX7IBk7kB4Vf2If4oH0boyD/NvSmtdiq7SrQQxldr7D4ji9vzd7+qeiGrb9gjCdxG2qmeMTojTOjN9lYFfRtEAlTg30Blb/7HyM2IC9FS+cz9ZZBf+ZXSDQ0yhBHBXiwNa9CPC130dNnDo/3BWUuyHS036FxM03r7scH3wnSaYlJQ25GxsL6MTPKKAgmx1fm/Eay91vV3sIVIegTwFdm4C/vZHCZkFlRTdTLMD+KyuWw1h7tgOXnH1ilXVfvm6oV22oTNIJWgLwHBdXX29eR79UvcpS3folCiuhcmrYJc/fXu9LlcvnPLDZoTf0WqXYJzReuVmNnDGnYxa5m8+TiUXU3Y/UnYhBtkMNRBV16WAjMt5lU61lKAsDNPp3WikifrR5EYaQuxyrSgD15bFW1/YcIT+tKy4B6ah5aCwwz4mBYmycKtBguUrysZlLlvGH+mwnoJF3kLYBzps6q/4zItrrnQDNuZjFJsEfeaSq+psThWHHBHeVRHTEnlpaHjd9S1kY9aUNN9
 YjdQbo34
 ddf0hu9MYthWGwmPqR0URP0zX6sDgOM5XkfLsb6P1xi8z4Oh2dIgEahdenwio8HWACX2mEbxq3M6KfPfrmvPGLyiGri5QeVc1e9vpt+vvCwRbMHW+Lm1QPD4eMAfbN33O/Kgxj5SP9kNZ8KzcPF1FHoy1LAD/dHIBPsFRuu9A0QUE56NY2jgKhxKI6Hi/ODIUGqxeIRSszQbYicAQ/xqwygLXWWGM311uDjb7GLdwVczqY7aMyVoTaotxsfG/xPlV9w/jsyqzZZn8r/6F/PtwTnkXcQvVEI88bDzMbR1VFKxw55GGJ9h0T2g+cUnhKzRWdGmtQM2EyJwrU9hzwcMpm4d9/olW3VvWwCxhPO+3Xnyrmdv1Ppru03x111Ii7MQaPZIRHE0xjkP7wkgmQHZblJVwoofdOIGHvqRBi6io+acn79GdMnp1uDKUXvXb+6lOBltU984BfeZT3TvP0JvHFs4WBcg4i6TEAp6BGN8XxVLq0MkdjfFJPUNU3A23Sf4I16xvaXShhalz7cA4Q1Py60GlXRRsIw6Kw/yDSkcCPURMdiw2uPnUXD2rI8x/4ti1uX+0HNuSEULP2MIHtTGPoqdLy9RO+q1RxJSgjc2JOb4yrH56nWpvWympW7F4MzYF8S0d8c7GI1CIAOJ2B8Z37Zly/ZZyVSuZgF9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential
issues to consider:
- [High] iommu/pisa: double pisa_place_meta() and recycling in
  pisa_user_scrub_alloc()
- [High] iommu/dma: 2MB PISA pages mapped into untrusted devices in
  __pisa_map_phys()
- [Medium] block: broken PISA promotion and bio repin in
  bio_upgrade_pages_to_pisa()
- [Medium] iommu/pisa: scrub worker never scheduled for sparse user_pa
  pages
- [Medium] iommu/pisa: early scrub loop exit and age reset in
  pisa_user_scrub_node()
- [Medium] iommu/pisa: block pisa_tx_bufs depends on
  net_pisa_tx_bufs_set() and CONFIG_NET
- [Medium] iommu/pisa: __pisa_bdev_enabled() misses gendisk sysfs and
  NVMe multipath
- [Medium] iommu/pisa: direction permission mismatch in
  __pisa_filemap_alloc() and pisa_zc_iter()
--

commit 07d0de2d5b536e6ca58dfc325de503d0cd0feffd
Author: Luigi Rizzo <lrizzo@google.com>

block, mm, iommu/dma: Support PISA for disk I/O and scrub migration

This commit extends the PISA user and page-cache allocators to support
O_DIRECT and buffered disk I/O with per-direction per-node allocators,
bypasses IOVA allocation for PISA pages in dma_iova_try_alloc(), and adds
background scrub migration for sparse user PISA pages.

> diff --git a/block/bio.c b/block/bio.c
> index b0fcc69de6535..5b43430b5280c 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -6,6 +6,7 @@
>  #include <linux/swap.h>
>  #include <linux/bio-integrity.h>
>  #include <linux/blkdev.h>
> +#include <linux/pisa.h>
>  #include <linux/uio.h>
>  #include <linux/iocontext.h>
>  #include <linux/slab.h>
> @@ -1316,6 +1317,43 @@ static inline bool bio_iov_bvec_aligned(const stru=
ct bio *bio,
>  }
>  #endif
> =20
> +/*
> + * Migrate pinned order-0 user pages in @bio into PISA memory when enabl=
ed on
> + * @bio->bi_bdev; returns true if pages were released and the caller mus=
t retry.
> + */
> +static bool bio_upgrade_pages_to_pisa(struct bio *bio)
> +{
> +	enum dma_data_direction dir;
> +	struct page *pages[64];
> +	unsigned int i, nr =3D 0;
> +
> +	if (!IS_ENABLED(CONFIG_PISA) || !bio_flagged(bio, BIO_PAGE_PINNED))
> +		return false;
> +	dir =3D op_is_write(bio_op(bio)) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	if (!is_bdev_pisa_enabled(bio->bi_bdev, dir))
> +		return false;
> +
> +	for (i =3D 0; i < bio->bi_vcnt && nr < ARRAY_SIZE(pages); i++) {
> +		struct page *page =3D bio->bi_io_vec[i].bv_page;
> +
> +		if (bvec_nr_pages(&bio->bi_io_vec[i]) =3D=3D 1 && !is_pisa_page(page))=
 {
> +			get_page(page);
> +			pages[nr++] =3D page;
> +		}
> +	}
> +	if (!nr)
> +		return false;
> +
> +	bio_release_pages(bio, false);
> +	bio->bi_vcnt =3D 0;
> +	bio->bi_iter.bi_size =3D 0;
> +	if (!pisa_upgrade_user_pages(pages, nr, dir, false)) {
> +		while (nr)
> +			put_page(pages[--nr]);
> +	}
> +	return true;
> +}

[Severity: Medium]
Does filtering out !is_pisa_page(page) prevent O_DIRECT buffers that are
already in a unidirectional PISA allocator from being promoted to
DMA_BIDIRECTIONAL when accessed in the opposite direction?  When an
O_DIRECT buffer allocated for writes (or via MADV_PISA) is later used for
an O_DIRECT read, dma_iova_try_alloc() sees is_pisa_phys(phys) and skips
blk-mq IOVA coalescing, and __pisa_map_phys() then rejects the window
mapping with -EACCES, falling back to individual 4KB IOVA allocations per
segment.

Also, bio_release_pages() and returning true happen before
pisa_upgrade_user_pages() checks whether any page is eligible or within
pisa.user_max_4K_pages budget, forcing bio_iov_iter_get_pages() to unpin
and re-pin the entire bio on every O_DIRECT request whenever migration does
not occur.

> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index a0c5ddab7a8b6..acedfe04bde26 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1868,7 +1868,7 @@ bool dma_iova_try_alloc(struct device *dev, struct =
dma_iova_state *state,
>  	dma_addr_t addr;
> =20
>  	memset(state, 0, sizeof(*state));
> -	if (!use_dma_iommu(dev) || is_pisa_phys(phys))
> +	if (!use_dma_iommu(dev) || is_pisa_phys(phys))
>  		return false;

[Severity: High]
Can a 4KB PISA user or page-cache page be mapped into an untrusted external
device's IOMMU domain without bounce buffering?

When a 4KB buffer backed by a 2MB PISA frame is used for DMA on an
untrusted PCI/Thunderbolt device (dev_is_untrusted(dev) =3D=3D true),
dma_iova_try_alloc() returns false because is_pisa_phys(phys) is true, and
iommu_dma_map_phys() skips swiotlb bounce buffering (since the 4KB buffer
is iova_aligned) and calls __pisa_map_phys().  Because neither
dma_iova_try_alloc() nor __pisa_map_phys() rejects untrusted devices,
__pisa_map_phys() installs a persistent 2MB IOMMU leaf PTE in the untrusted
device's domain, exposing the other 511 sibling 4KB user and page-cache
pages in that 2MB frame to DMA by the untrusted device.

> diff --git a/drivers/iommu/pisa-node.c b/drivers/iommu/pisa-node.c
> index cd29c146c281e..7469674133620 100644
> --- a/drivers/iommu/pisa-node.c
> +++ b/drivers/iommu/pisa-node.c
> @@ -184,7 +184,8 @@ void pisa_schedule_scrub(int nid)
>  {
>  	struct pisa_node *node;
> =20
> -	if (!READ_ONCE(pisa_scrub_max) || nid =3D=3D NUMA_NO_NODE)
> +	if ((!READ_ONCE(pisa_scrub_max) && !READ_ONCE(pisa_scrub_migrate)) ||
> +	    nid =3D=3D NUMA_NO_NODE)
>  		return;

[Severity: Medium]
What schedules pisa_schedule_scrub() when user_pa pages age past
pisa.old_ms and exceed pisa.wasted_pct?

Outside of writing to scrub_max or scrub_migrate in sysfs,
pisa_schedule_scrub() is only called from __pisa_alloc_bulk() and
pisa_alloc_coherent() when pa->scrub_demand >=3D PISA_SCRUB_TRIGGER.  Becau=
se
all user_pa[] allocators enable PCP in pisa_user_init() and
pisa_pcp_alloc() calls __pisa_alloc_bulk() with zero =3D false,
pa->scrub_demand is never incremented on user_pa[], and neither
__pisa_free_page() nor pisa_reclaim_work_fn() calls pisa_schedule_scrub(),
so background scrub migration never runs automatically.

> diff --git a/drivers/iommu/pisa-user.c b/drivers/iommu/pisa-user.c
> index a16909d429aca..7dca3bf066f0d 100644
> --- a/drivers/iommu/pisa-user.c
> +++ b/drivers/iommu/pisa-user.c
[ ... ]
> +struct folio *__pisa_filemap_alloc(const struct address_space *mapping,
> +				   gfp_t gfp, bool is_write)
> +{
> +	enum dma_data_direction dir =3D is_write ? DMA_TO_DEVICE : DMA_FROM_DEV=
ICE;
> +	struct page *page;
> +	int nid;
> +
> +	if (!__pisa_mapping_enabled(mapping, dir))
> +		return NULL;
> +	if (is_write && __pisa_mapping_enabled(mapping, DMA_FROM_DEVICE))
> +		dir =3D DMA_BIDIRECTIONAL;
> +	/* Pairs with smp_store_release() in pisa_user_init(). */
> +	if (!smp_load_acquire(&pisa_user_ready) &&
> +	    ((gfp & GFP_KERNEL) !=3D GFP_KERNEL || !pisa_user_init()))
> +		return NULL;
> +	if (pisa_user_budget() <=3D 0)
> +		return NULL;
> +	nid =3D pisa_sanitize_nid(numa_node_id());
> +	page =3D pisa_alloc(pisa_nodes[nid].user_pa[dir], gfp);
> +	if (!page)
> +		return NULL;
> +	if (pisa_meta_of_pfn(page_to_pfn(page))->flags & PISA_DECRYPTED) {
> +		put_page(page);
> +		return NULL;
> +	}
> +	return page_folio(page);
> +}

[Severity: Medium]
Can allocating page-cache folios from single-direction user_pa[dir]
allocators cause direction permission mismatches on later I/O?

When only pisa_rx_bufs is enabled on a block device, __pisa_filemap_alloc()
allocates read and readahead folios from user_pa[DMA_FROM_DEVICE]
(IOMMU_WRITE only).  If those folios are later dirtied and written back,
pisa_filemap_upgrade() and pisa_writeback_upgrade() both check
pisa_mapping_enabled(mapping, DMA_TO_DEVICE) and do not promote them;
conversely, when only pisa_tx_bufs is enabled, a partial-page buffered
write allocates a locked folio from user_pa[DMA_TO_DEVICE] (IOMMU_READ
only) and write_begin immediately issues a disk READ into it.  Similarly,
in net/core/datagram.c:pisa_zc_iter(), checking is_pisa_page(pages[i])
without verifying IOMMU_READ allows a DMA_FROM_DEVICE page (such as a
mmap'd page-cache folio, which pisa_upgrade_user_pages() skips because
allow_file is false) to be attached zero-copy instead of copied.  In all of
these cases, dma_iova_try_alloc() sees is_pisa_phys(phys) and disables
blk-mq or TSO IOVA coalescing, only for __pisa_map_phys() to fail with
-EACCES and fall back to per-page 4KB IOVA mappings.

[ ... ]

> +bool __pisa_bdev_enabled(struct block_device *bdev, enum dma_data_direct=
ion dir)
> +{
> +	struct device *dev;
> +
> +	if (!bdev || !bdev->bd_disk)
> +		return false;
> +	for (dev =3D disk_to_dev(bdev->bd_disk); dev; dev =3D dev->parent) {
> +		if (dir =3D=3D DMA_FROM_DEVICE ?
> +		    READ_ONCE(dev->pisa_rx_bufs) :
> +		    READ_ONCE(dev->pisa_tx_bufs))
> +			return true;
> +	}
> +	return false;
> +}

[Severity: Medium]
Does gating block device writes on dev->pisa_tx_bufs tie disk write support
to CONFIG_NET and the networking static key?

In drivers/base/core.c, pisa_tx_bufs is wired to net_pisa_tx_bufs_set():

drivers/base/core.c:
    PISA_SET_ATTR(pisa_tx_bufs, net_pisa_tx_bufs_set);

With CONFIG_NET=3Dn, net_pisa_tx_bufs_set() is a stub returning -EOPNOTSUPP,
so pisa_tx_bufs cannot be enabled on any block or storage controller
device.  With CONFIG_NET=3Dy, enabling pisa_tx_bufs on a storage controller
enables net_pisa_tx_bufs_key globally across the networking stack even when
no network device uses PISA.

[Severity: Medium]
Also in __pisa_bdev_enabled(), does walking dev->parent from
disk_to_dev(bdev->bd_disk) work for per-disk configuration or NVMe
multipath devices?

In drivers/base/core.c:device_add_attrs(), dev_attr_pisa_group is only
added when dev->dma_mask is non-NULL, so gendisk devices never expose
pisa_rx_bufs or pisa_tx_bufs in sysfs.  Furthermore, with
CONFIG_NVME_MULTIPATH=3Dy, nvme_mpath_set_live() sets the namespace gendisk=
's
parent to &head->subsys->dev (nvme-subsysX), which has parent =3D=3D NULL a=
nd
dma_mask =3D=3D NULL, so walking dev->parent from disk_to_dev(bdev->bd_disk)
never reaches the underlying PCI controller device.

> +
> +bool __pisa_mapping_enabled(const struct address_space *mapping, enum dm=
a_data_direction dir)
> +{
> +	struct super_block *sb;
> +
> +	if (!mapping || !mapping->host || !mapping->host->i_sb)
> +		return false;
> +	sb =3D mapping->host->i_sb;
> +	return __pisa_bdev_enabled(sb_is_blkdev_sb(sb) ?
> +				   I_BDEV(mapping->host) : sb->s_bdev, dir);
> +}
> +
>  #define PISA_USER_BATCH	512
> =20
> +static unsigned long pisa_user_scrub_alloc(struct pisa_alloc *pa,
> +					  enum dma_data_direction dir,
> +					  unsigned int mode,
> +					  unsigned long budget)
> +{
[ ... ]
> +	if (target) {
> +		base_pfn =3D pisa_meta_to_pfn(target);
> +		bitmap_or(inuse_map, target->clean_bitmap, target->dirty_bitmap, bpp);
> +		bitmap_complement(inuse_map, inuse_map, bpp);
> +		WRITE_ONCE(target->on_list, PISA_LIST_FULL);
> +		list_move(&target->list, &pa->full);
> +	}
> +	spin_unlock_irqrestore(&pa->lock, flags);
> +
> +	if (!target)
> +		return 0;
[ ... ]
> +	if (!list_empty(&list)) {
> +		migrated =3D pisa_user_migrate_dir(&list, mode =3D=3D 1, dir, true,
> +						 GFP_KERNEL | __GFP_NOWARN);
> +		pisa_pcp_drain(pa);
> +	}
> +
> +	spin_lock_irqsave(&pa->lock, flags);
> +	if (READ_ONCE(target->pa) =3D=3D pa) {
> +		WRITE_ONCE(target->alloc_jiffies, jiffies);
> +		should_release =3D pisa_place_meta(target);
> +	}
> +	spin_unlock_irqrestore(&pa->lock, flags);
> +	if (should_release)
> +		pisa_schedule_reclaim();
> +
> +	return migrated;
> +}

[Severity: High]
Does calling pisa_place_meta(target) after pisa_user_migrate_dir() and
pisa_pcp_drain() corrupt pa->num_idle_pages or double-add target->llnode to
pisa_free_list when all remaining blocks of target are migrated?

When the last in-use block of target is freed during migration or
pisa_pcp_drain(pa), pisa_return_block_locked() already calls
pisa_place_meta(target) with avail =3D=3D bpp.  In pisa_place_meta(), that
first call either increments pa->num_idle_pages and moves target to
pa->idle, or unlinks target and adds target->llnode to pisa_free_list.
Because target->pa is only cleared in pisa_release_page_rcu() after an RCU
grace period, READ_ONCE(target->pa) =3D=3D pa is still true here, so
pisa_user_scrub_alloc() calls pisa_place_meta(target) a second time with
avail =3D=3D bpp:

drivers/iommu/pisa-alloc.c:pisa_place_meta() {
	if (avail =3D=3D bpp) {
		if ((meta->flags & PISA_QUARANTINED) ||
		    (pa->num_idle_pages >=3D pa->max_idle_pages && !READ_ONCE(pisa_idle_m=
s))) {
			list_del_init(&meta->list);
			WRITE_ONCE(meta->on_list, PISA_LIST_NONE);
			llist_add(&meta->llnode, &pisa_free_list);
			return true;
		}
		if (pa->num_idle_pages >=3D pa->max_idle_pages)
			WRITE_ONCE(pa->idle_jiffies, jiffies);
		pa->num_idle_pages++;
		on_list =3D meta->nr_dirty ? PISA_LIST_IDLE_DIRTY : PISA_LIST_IDLE_CLEAN;
	}
    ...
	if (on_list =3D=3D meta->on_list)
		return avail =3D=3D bpp && pa->num_idle_pages > pa->max_idle_pages;
}

That second call either increments pa->num_idle_pages a second time for the
same page (before the on_list =3D=3D meta->on_list check), or calls
llist_add(&target->llnode, &pisa_free_list) a second time on the same node
(or moves a page already being released by pisa_reclaim_work_fn() back onto
pa->idle).

In addition, setting target->on_list =3D PISA_LIST_FULL before migration
makes pisa_page_can_recycle() return true for freed blocks of target, so
__pisa_free_page() caches them in pa->pcp where mode =3D=3D 1 compaction can
reallocate destination folios right back onto target.

> +
> +bool pisa_user_scrub_node(int nid, unsigned long budget, u64 deadline)
> +{
> +	unsigned int mode =3D READ_ONCE(pisa_scrub_migrate);
> +	unsigned long done =3D 0;
> +	unsigned int dir;
> +
> +	/* Pairs with smp_store_release() in pisa_user_init(). */
> +	if (!mode || mode > 2 || !smp_load_acquire(&pisa_user_ready))
> +		return false;
> +
> +	for (dir =3D 0; dir < ARRAY_SIZE(pisa_nodes[nid].user_pa); dir++) {
> +		struct pisa_alloc *pa =3D pisa_nodes[nid].user_pa[dir];
> +		unsigned long n;
> +
> +		if (!pa)
> +			continue;
> +		while ((n =3D pisa_user_scrub_alloc(pa, dir, mode, budget - done))) {
> +			done +=3D n;
> +			if (done >=3D budget || local_clock() >=3D deadline)
> +				return true;
> +			cond_resched();
> +		}
> +	}
> +	return false;
> +}

[Severity: Medium]
If the oldest sparse page in pa has only unmigratable folios (for example,
locked, under writeback, pinned, or mapped shared), pisa_user_scrub_alloc()
updates target->alloc_jiffies and returns 0.  Should pisa_user_scrub_node()
continue scanning the remaining old sparse pages in pa instead of exiting
the while loop on the first target page that migrates 0 folios?

Also, if pisa_user_scrub_alloc() stops isolating folios early because count
reaches min(budget - done, PISA_USER_BATCH), resetting
target->alloc_jiffies =3D jiffies hides the still-sparse page from the
scrubber for pisa.old_ms.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D23

