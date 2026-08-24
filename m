Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09982C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289FB6B00A0; Mon, 24 Aug 2026 11:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214286B00A7; Mon, 24 Aug 2026 11:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101F86B00A9; Mon, 24 Aug 2026 11:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB48D6B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5435EA2A52
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:43 +0000 (UTC)
X-FDA: 85136547846.15.A0F0F44
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B0AB40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V2sq5UOW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3ZGOMagYKCLciofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3ZGOMagYKCLciofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MUtQgSiF1UT5gfL8VJuu1JZ6DoMTlmedVjUdmZy7TI=;
	b=YCVbCM1ytYdXdkcgeyAzHraKG5kRYN0ltvCzRTuxuxAccq/Tixf3uaBVpMoHv+29efNCQH
	g7AyfZimhJASxxm7Yn/KSX+Dl90MX/nhc7nGmdQmgSsx1v+FCKES/AGXqylxHtfgHSORa3
	DwhLN2Mfd1btyw2C7SBeQYhZxKs6s1Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V2sq5UOW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3ZGOMagYKCLciofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3ZGOMagYKCLciofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585381;
	b=8V5JUn3XkU4iwM/f8NcXRGoO58otqH6Do5FFxhvl++8MyIUDLmi7GTWtV4xJV3elKuU0Sv
	EnY3YeUszIvcPPnnZ7tkLYMqPbwNGFTsz58qkx3HI1pA/PhyUzBpemZ0zEwgPBQpoTNlry
	nAWVil/W0mQGwb1dR5sFpcjOWRAZ2c0=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c217f249fa1so389704266b.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585380; x=1788190180; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+MUtQgSiF1UT5gfL8VJuu1JZ6DoMTlmedVjUdmZy7TI=;
        b=V2sq5UOWJIpvuB2W2U3KarAPzMzWwJ7weyMklCzfUp5jCLrumi/BW7CRUHSjrhVTyu
         ZtF5mCYWdaUP+P8SUF7WUnS37eIwwj9i3LgGGc/CbLBm3pltTVSRj207dHW9DZ0Ipxte
         ocbvi2UQ7k7sWW5j5B3f5YP/lnivOxQkK13DictSD8RpKQn+4b5NSUhWzyEgScUNt/WN
         y8996DSEi5Er083kTiT4sBmIGNHq8EMUueMF04QW2Wmh5w1cqYj7Rcpfxz5vA3FPD2SE
         yX6JkMugWYOlypGpINR2xw+jeeYNafgcV+eO6RDblCVlyjPGf5zMkRlpE+f12Usk48ul
         JQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585380; x=1788190180;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+MUtQgSiF1UT5gfL8VJuu1JZ6DoMTlmedVjUdmZy7TI=;
        b=C5I2Ebrs4xMXPZ9z4sWO2/W/3RhvpJlxpcrpgzYOolOJX2WzKWlO2oLK3fo9yX1asm
         7SbVYeEnOpcMsii50NFLmF0n5y3GoCiiaSY0wNUK5zYoLN56dPrcb9uq8XbOfozWWms4
         nlI3D0sr/b79dJMe5k+dMCsgxXQ2LL0UU9wzv5eLg8ls+N2Z6St4odlTvUlcsVXt+584
         JvLV9oV2sOoc3qU7UKMUTer1301Dmy5x3HTNoklbTb0IDQjl+to56NG6gzoIhMkq1CHG
         4xjafWAdE7I3LFoc2Rfia79CK41FaLbpzS+mJVUruwTA0JrYDR1KiNyFC2XKB/zWXTAe
         5stg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/BvUd0EdQYhZ4YWFkrN73vGMXof1R7XNBCLFocxIH57Gz3ELG3ZU5NRUI6s+QTTadJF0Ucok4Gg==@kvack.org
X-Gm-Message-State: AFuF++nZbUedKYtgbo+KiAd0Vyz2sLMxLKb5W4doqrvhaGH5fJFKJD1B
	ajWhq9YsF8oFylYX/PywQq0tvaQwFEVIlxObMDnT81F4I3nnHgsX9a5ylQYuCWHp8uTUFR+oh/I
	y6vUuHQ==
X-Received: from ejdcu6.prod.google.com ([2002:a17:906:ba86:b0:c1f:97d8:cdd8])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:f59b:b0:c20:7cb1:9046
 with SMTP id a640c23a62f3a-c24924b7508mr2143073766b.8.1787585380008; Mon, 24
 Aug 2026 08:29:40 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:31 +0000
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-5-lrizzo@google.com>
Subject: [PATCH v2 4/5] net: Divert socket allocations to SWIOTLB for nocopy TX
From: Luigi Rizzo <lrizzo@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <lrizzo@google.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9B0AB40008
X-Stat-Signature: ebaz636xkwstxipeafzr3yaiuwug7ihx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787585381-798756
X-HE-Meta: U2FsdGVkX19OCWozEVCY+fW1IilPF3d7O0u5z3muUM/M+gaKsP1hmqKzfFV/1hLLTMpJxfa+h6WXpIb3AQfRc4BIIW+ciYQkrMttfcFzcwfvk2/Us/CwJ5amwhjXOSMpDNs/tqqDmymTeaYOwpHEYoZnVPDC0XGkFRsYrYBjXD6ysIGph97H1a2gw0z0pN4Qa1xC+w4u0Q1cilHhuAm3uUedzQUMdXLL+JkBt6h6WOALmczUiNGxk27fBu++P30K1q/QPJ7KrlVAnHcRzjKC4Yxj6QhA1LielzbRsTdtbOzkC0A6XhbPiDuz9AxnYAe0FHWZvMoY0E1150dQ4IE55d/At3/V/YlTnYM7PMNyaHleO9b8gPmIwhT4kvZhOXHQj+B2qdCTzzrTL8ML3pNDK4n6N2Y8iEiBWXJFr9NXgvA5MlOGtBvGIu0x92NXos/tkctEftzqGq2jWJpC9vqJtjoi49k4eF9C//PS8LAbIjV86x2NaaUEd0s/UpTcLKNDqEDVYnwXOezpV8st3AWoC5qv3jLcmRPwdR+EYRjO55EbkZsiu3mPbpc0oAkmujHij/TTi4XfPKLNJ+xZKoLyVKPtgr0KmdJ/E+2WjNRjC7CWcM8cnD0jXegKnwieie0HXcuzaWiEVLlIIgpsvqSTFSv9ryqLOlgBit3k7qlhQEygnAVnaGhcI0QRZk6KjROCSz5L98ZVhvyZeO4NWJBPT7D7PJkp/gBafR8MCr7QlHX/kXnV6EWzCU4HIyz/+Fc4Tav3GWPp+oSRVKifYfjZKg6FzWHqWD8lLUaGfYNCF26miu5l1+mI3TVQ+lnpxEZ1CbVtIPGRfG3lngAabHnh3DH7Xdk7XYm8H889X4CykIWq7fmIJ/VBjgI4KdcjMnHEPy+TWfsikSb3yO4FdyU2u1RivoI7iTY5WSOhaKw6Ieh2WFqwy518Zx9FaetZHHitBdQ7BKTonR+6bFb6wFS
 mUCDtn6e
 USGInrQWRedKb0KeI8mHVPcPNIHd/uyOFIQk8xUsCu77dmCFfRagbssl/wgRMkK9Ul+RYiViE21FWxluPemBzZ6YwHD/Oo3X4tTsFLVEsmSTtBxlxw6KOYOpt2jC30f+cxmK9M9vaSwEVchhtsTwPF0kkzQ9dKcsE4CsT28nwuv6K+Luiy+nzCLIRY43Zr2qwlTeaVWsaDBfrWRjRhPuns8D3xNd4awT09/fWIIPxD+ParJSniWDaOKRl2/r1QqdoUhsmJ5QfD6y7hKMf16fl0DrVSoiE0i6jUF8crPDBzed7/MdR0vGzNk2lYA4QFWlZ77auDee9ZwFsrMYBhYUjr+XppQ+rCpOQAHLZwntJOwz/lgqpKSveZ29ek8aUjChal5X8/qFLOGLRX0+Lsd35YWb89Km9oc5az259bnGFnrC9LmYitvedKJ36H98LjG8+8iXJevmKS1YId/fJrENAnwNsNNLe+KQRTzCfc7BJJU2pOmV6v9/Y8fgOF5Nv52aL0cfnng9I8oV2DkD8ic0qmWTgW9ao7OEzv/V+1xoRjRd4zw8Ol8tvZtsb0pyQ3ZTNoWsHxvCy0yW1OKcteLuhivUblOq8Vl5B0ThaqeRKaqvz1zQ7DPMEmmbIrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Conditionally intercept socket buffer page allocations and direct them
to the SWIOTLB page allocator when nocopy tx is active.

This only happens when the swiotlb usage is below module parameter
swiotlb.nocopy_tx_percent (default 0, range 0..90)
A value of 0 disables the feature.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-iommu.c |  9 +++++-
 include/linux/skbuff.h    |  7 ++++-
 include/linux/swiotlb.h   |  2 ++
 kernel/dma/direct.h       | 11 +++++++
 kernel/dma/swiotlb.c      | 12 ++++++++
 mm/page_alloc.c           | 10 ++++++-
 net/core/sock.c           | 62 ++++++++++++++++++++++++++++++++++-----
 7 files changed, 102 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9a07eb39336eb..956d5e11b2896 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1228,7 +1228,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 * If both the physical buffer start address and size are page aligned,
 	 * we don't need to use a bounce page.
 	 */
-	if (dev_use_swiotlb(dev, size, dir) &&
+	bool is_nocopy = false;
+
+	if (swiotlb_is_nocopy_addr(dev, phys)) {
+		swiotlb_nocopy_inc_ref(&dev->dma_io_tlb_mem->defpool, phys);
+		is_nocopy = true;
+	}
+
+	if (!is_nocopy && dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
 		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index add0d282dea6e..d8f7041edc400 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3786,7 +3786,12 @@ static inline void skb_frag_page_copy(skb_frag_t *fragto,
 	fragto->netmem = fragfrom->netmem;
 }
 
-bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
+/* nocopy swiotlb uses an additional non-null struct sock pointer. */
+bool __skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio, struct sock *sk);
+static inline bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio)
+{
+	return __skb_page_frag_refill(sz, pfrag, prio, NULL);
+}
 
 /**
  * __skb_frag_dma_map - maps a paged fragment via the DMA API
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index b1140db3cc397..3baf52e6572d0 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -204,6 +204,8 @@ void swiotlb_prep_compound_page(struct page *page, unsigned int order);
 void swiotlb_destroy_compound_page(struct page *page, unsigned int order);
 void swiotlb_safe_put_device(struct device *dev);
 
+extern unsigned int nocopy_tx_percent;
+
 /* Track epoch (number of delete operations) for leaf device info. */
 extern atomic_t global_device_epoch;
 
diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index 7140c208c1238..21c65acb13823 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -88,6 +88,17 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 {
 	dma_addr_t dma_addr;
 
+	if (swiotlb_is_nocopy_addr(dev, phys)) {
+		dma_addr_t unenc_addr = phys_to_dma_unencrypted(dev, phys);
+
+		if (likely(dma_capable(dev, unenc_addr, size, true))) {
+			swiotlb_nocopy_inc_ref(&dev->dma_io_tlb_mem->defpool, phys);
+			if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+				arch_sync_dma_for_device(phys, size, dir);
+			return unenc_addr;
+		}
+	}
+
 	if (is_swiotlb_force_bounce(dev)) {
 		if (!(attrs & DMA_ATTR_CC_SHARED)) {
 			if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index d4a07a7c570e1..7b818a796ff96 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -63,6 +63,11 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
+/* enable nocopy tx swiotlb and set the percentage of buffers allowed for it. */
+unsigned int nocopy_tx_percent;
+module_param(nocopy_tx_percent, uint, 0644);
+MODULE_PARM_DESC(nocopy_tx_percent, "percentage of swiotlb buffer allowed for nocopy tx");
+
 /**
  * struct io_tlb_slot - IO TLB slot descriptor
  * @orig_addr:	The original address corresponding to a mapped entry.
@@ -1640,6 +1645,13 @@ void __swiotlb_tbl_unmap_single(struct device *dev, phys_addr_t tlb_addr,
 		size_t mapping_size, enum dma_data_direction dir,
 		unsigned long attrs, struct io_tlb_pool *pool)
 {
+	int index = (tlb_addr - pool->start) >> IO_TLB_SHIFT;
+
+	if (pool->slots[index].flags & SWIOTLB_SLOT_NOCOPY) {
+		swiotlb_nocopy_dec_ref(pool, tlb_addr);
+		return;
+	}
+
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ea148562a76d0..32d5d630f9840 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3002,9 +3002,14 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 {
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
-	unsigned long pfn = page_to_pfn(page);
+	unsigned long pfn;
 	int migratetype;
 
+	if (unlikely(swiotlb_free_pages(page, order)))
+		return;
+
+	pfn = page_to_pfn(page);
+
 	if (!pcp_allowed_order(order)) {
 		__free_pages_ok(page, order, fpi_flags);
 		return;
@@ -3070,6 +3075,9 @@ void free_unref_folios(struct folio_batch *folios)
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = folio_order(folio);
 
+		if (unlikely(swiotlb_free_pages(&folio->page, order)))
+			continue;
+
 		if (!__free_pages_prepare(&folio->page, order, FPI_NONE))
 			continue;
 		/*
diff --git a/net/core/sock.c b/net/core/sock.c
index ca3e08d3de141..ef40d1ff1de9f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -188,6 +188,52 @@ void sk_record_bounce_device(struct sock *sk, struct device *dev)
 	}
 }
 EXPORT_SYMBOL(sk_record_bounce_device);
+
+/*
+ * Wrap alloc_pages in __skb_page_frag_refill(). If the socket's dma_device requires
+ * SWIOTLB bounce buffering, divert allocation to the SWIOTLB slot allocator.
+ * This ensures the packet payload is written directly to a bounce buffer from the start,
+ * enabling nocopy during driver DMA mapping.
+ */
+static inline struct page *alloc_any_pg(gfp_t gfp, unsigned int order, struct sock *sk)
+{
+	unsigned int pct = READ_ONCE(nocopy_tx_percent);
+
+	if (sk && pct && !sock_flag(sk, SOCK_ZEROCOPY)) {
+		struct page *page = NULL;
+		bool release_dev = false;
+		struct device *dev;
+
+		rcu_read_lock();
+		dev = rcu_dereference(sk->sk_swiotlb.dev);
+		if (dev) {
+			/*
+			 * The epoch check is just for cache invalidation, UAF is
+			 * protected by the reference held in the sk.
+			 */
+			if (swiotlb_dev_epoch() != READ_ONCE(sk->sk_swiotlb.epoch)) {
+				struct device __force **pdev =
+					(struct device __force **)&sk->sk_swiotlb.dev;
+
+				release_dev = (cmpxchg(pdev, (struct device __force *)dev,
+						       NULL) == dev);
+			} else {
+				page = swiotlb_alloc_pages(dev, order, gfp, pct);
+			}
+		}
+		rcu_read_unlock();
+		if (release_dev)
+			swiotlb_safe_put_device(dev);
+		if (page)
+			return page;
+	}
+	return alloc_pages(gfp, order);
+}
+#else
+static inline struct page *alloc_any_pg(gfp_t gfp, unsigned int order, struct sock *sk)
+{
+	return alloc_pages(gfp, order);
+}
 #endif
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
@@ -3213,7 +3259,7 @@ DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
  * no guarantee that allocations succeed. Therefore, @sz MUST be
  * less or equal than PAGE_SIZE.
  */
-bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
+bool __skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp, struct sock *sk)
 {
 	if (pfrag->page) {
 		if (page_ref_count(pfrag->page) == 1) {
@@ -3229,27 +3275,27 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 	if (SKB_FRAG_PAGE_ORDER &&
 	    !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
 		/* Avoid direct reclaim but allow kswapd to wake */
-		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
-					  __GFP_COMP | __GFP_NOWARN |
-					  __GFP_NORETRY,
-					  SKB_FRAG_PAGE_ORDER);
+		pfrag->page = alloc_any_pg((gfp & ~__GFP_DIRECT_RECLAIM) |
+					   __GFP_COMP | __GFP_NOWARN |
+					   __GFP_NORETRY,
+					   SKB_FRAG_PAGE_ORDER, sk);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
 			return true;
 		}
 	}
-	pfrag->page = alloc_page(gfp);
+	pfrag->page = alloc_any_pg(gfp, 0, sk);
 	if (likely(pfrag->page)) {
 		pfrag->size = PAGE_SIZE;
 		return true;
 	}
 	return false;
 }
-EXPORT_SYMBOL(skb_page_frag_refill);
+EXPORT_SYMBOL(__skb_page_frag_refill);
 
 bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 {
-	if (likely(skb_page_frag_refill(32U, pfrag, sk->sk_allocation)))
+	if (likely(__skb_page_frag_refill(32U, pfrag, sk->sk_allocation, sk)))
 		return true;
 
 	if (!sk->sk_bypass_prot_mem)
-- 
2.55.0.766.g2966f0265a-goog


