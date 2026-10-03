Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D4DCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0534C6B00A6; Sat,  3 Oct 2026 17:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A826B00A9; Sat,  3 Oct 2026 17:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34516B00A7; Sat,  3 Oct 2026 17:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B204F6B00A4
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 396DC1C3C8D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:10 +0000 (UTC)
X-FDA: 85282590540.08.794DCE6
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf31.hostedemail.com (Postfix) with ESMTP id 51C5A20005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J18eRBmx;
	spf=pass (imf31.hostedemail.com: domain of 3OnLBagYKCIEqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3OnLBagYKCIEqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZzR6zx1azl50By4SkClXLMvxt4zEV1vyStY0HIRy7M=;
	b=RuLQAuS+rewzeCn8rK1BzqiB8i5ec7baIjLwgzysI/XERmIfwfB5ybVEfQkAmUH/24CvoN
	Urc8d2Z71pZY2tgPnALJHPkiypsM1BbgsY59C5v+4YmN3uaInLzRXdWvGHweOPDq+WWRcK
	jqNx/kOwkmWVzdmJLdXRpk7zNpQkkZ0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J18eRBmx;
	spf=pass (imf31.hostedemail.com: domain of 3OnLBagYKCIEqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3OnLBagYKCIEqwn44tlttlqj.htrqnsz2-rrp0fhp.twl@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062588;
	b=xwN8mAAOCpH6HqqnBZTQK9dM+fz7Xp7eRWTB/61gVsTC6hR5ovLTqYxwSGM4bR2E6CreWG
	mC+Jq/jjS2JNDsne1jO+jwN3+vwktd3HKWR88Uqx0MkECEJcJfcAY57emzG0ntkKpGPirE
	w6My6EXHpa6XpUTdWK9G/XdXC6HMHIo=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so897837a12.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062587; x=1791667387; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wZzR6zx1azl50By4SkClXLMvxt4zEV1vyStY0HIRy7M=;
        b=J18eRBmx38sd/x78pUJgzuvH9Pg4LvjJIS0TllPpMUIK7QLseyCJWDpHNVoFcRGfUN
         BoALrIsmhi3nNWH0DYK/488DcR3Ii9YTJqaQN4laRCJVmH80SpXuF+PllE0guv0/6EnY
         SWKOQ4h8dYHS6MkU2WoECYsLmNxb+cvEaIuCE9uO9nqXYruLa8jvo2LCRA1P9ix3cV4o
         pDf5jDmNkHUS/dZoHiPZTjUUIqGgoC/NIUXHat5E4WxiLe+oXykxKt9vdr+5wvTSqfPy
         cgW4A8ggSwZlEpcac+LEH/BqvlwVhlr8EhORuyAtItw0fl1UwKsUzPCyVv0QlZu9jYQ+
         R5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062587; x=1791667387;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZzR6zx1azl50By4SkClXLMvxt4zEV1vyStY0HIRy7M=;
        b=TRqLrpzAeeCWmEsImfmfwYXnHe5rU88cVMIF1kI1hDgy4QIxubAnHQDP2/n6YLrKS8
         9JRB33JoBDmfqkui6pqpKGDIt0pG/vipU25gz2xU5cnnEdahui2/oXoXKtIUj0KOjCCA
         pBeG4EnaAYuSm049rt6ZI7n3xC94IrbVNN9yAfCxmWyMEDFIQHByW/nRnkBio/Cq/ys5
         W/Pb+vF6BDcPOTiZM4+opcw8ey2+Eho26n2j2DYN9TPx5bM7eFcLjQ/hcJvjfovUPYlo
         Jq83rnz2BoF6GyFoLzqNryLpsn47Ifa4gulrTlqS1JWDSEC4twr8xig8B7XjhGRnKvbh
         n4jA==
X-Forwarded-Encrypted: i=1; AKwUvBwHfoWFClCEHI4GebDPrV6L48hD3KiC4XkKWtajGsCjD2ySHj16KfpWJ0gzLEGv8siv+DoyDL1fyA==@kvack.org
X-Gm-Message-State: AFq9FYJnNO3pP9tZsEBPNdRVj0RYbdekJZ7h9xPqmyjt1U7P3JDlxLl4
	54AOUKExdT/usaNll3aJxtPYrJXAT209XmMcew6yGl1VaqikjGIxDlA/D5nG0Fer+2WTVlDBqVz
	W30Xziw==
X-Received: from edpr6.prod.google.com ([2002:aa7:c146:0:b0:6a9:d114:1911])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2788:b0:6aa:490e:5506
 with SMTP id 4fb4d7f45d1cf-6af9e31cde4mr4814545a12.39.1791062586439; Sat, 03
 Oct 2026 14:23:06 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:34 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-16-lrizzo@google.com>
Subject: [RFC: DMA_PMD 15/22] iommu/dma: Add background page scrubber for
 DMA_PMD pools
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51C5A20005
X-Rspam-User: 
X-Stat-Signature: ddwnpodpzh5riak66hhr86rdcp5bfr65
X-HE-Tag: 1791062588-203785
X-HE-Meta: U2FsdGVkX19U/nYSUqWfTRQ0q8QbUnrPU4ABUfyJCoZjQvtCFRksumj/syXYD3kYHaYGer9d28rcrKph6azKZ3G/FJRW0m0EqLp9JOypKhzYiHGN+U1lan5f31l70d2ot5ZA4tiynDc9tFGD0kNlEgn63DazTAqpzbHRjmYjdc5jgcYyUmeIFA4Wsyh4VlX7cQ71r/8MkAddkw7QKjSbK2hRKVseYEdkafMWI33uWG14JAFGvrniuxXik6CRIgPJ05W+oU2q5WF8xCUHb4IHMX7rS1cQhAuDhbcK0YvJLhoCH5BcrE1M2zHOHaMwWLfgzz1NFwPEkEmHW9QIrc9q7POHGwYVlO6LkwkOa+m41U9O3fARevi82/5KlUfSvFjO1RA7n0/zHqMhdvj1JZpGAo2hffus2pSerTjxDMbPqdTO9rxZ4g1YqJfrQWGgY/hlMPldOvgwDBFiIRQlH+oSIW6stmf5dmuAMlGz3HaU172lQuTRYozxFvCr+dERlmsOlWo8Z0I8qsGKSt2wRE418ZVLeRt1B3apI9I+Nm4cNRq/UpEXVpo9Q6YHeeOPqha5O1Mom+SC0Os72q70bMBagb1qFNt9u1WUYLPynUVaRysqlyzGI9+EEzk8HHoRHv5Ha6vWMuhlIDLfdN17QftCEb537pqXJf7q28KenxbzjQMTniOf9JOyJOqPhvsh4OHXGZ2IHrn8fuOTuK+HjzINHKn9lKnHt8zuHabDqjQU7gpH/SIsC3JzwinP4N98xhaBYpRBdpeCNbYhscBHILwXLQExrX2Jtde2P4NC57uPJGGLabKQ64ROROmtlSG/Z6Zpb8ax6jo8mcd9O6ADXdRZ9naXz7rFAYHYzXRssny4ZNQktAdrU90+9sbLhV7wXRmb3tLqsW/ynVMyBxcQbamQljIVmC519YeLYNcm0AXIyYjWImHgVwAGxaayibMnrnYdrDlavM5ogIGtdl5PGKX
 jLbnayd0
 acWunA0haqiApRXrxHOo0yotM5AV021rhWtqg8bf3LzvKs9IYvLeb53/P5tYxPKYnqHYY5UIlmvqBNZFYSIbTJOFgoGrRggFOpRkAYlfL9Y9YirC665rg/Bs/nmeHBGVQaiZ+eO8jHrktjlhvAC/3CSa8DoKnkVXmT2f8kr1mcGs2DQjtvfQpFvmdU67RrfCbF7srftTEZHNwW7xvyqdNfRwIl7HL/JxXPqQTvXLJsM2CyOk8DL7JhLFYVZPrRErRjhz4zT9/MzrvcchdDNgHkqJXdfEYoBADx8FPKfyw2nZ4wAUC+eYsCmXHPSaZJAfkt790/6oaaEgKYPY8aD/AVhGYXF8rh4V+T0N9X7e9S6cLMFYkyJX28xh4bDxppJWb5GWEDkeUi5Bm0wHJJY3M8hUo3wvHVqtces1OMDJ5bgcbjgWuKz7n1oEbgkEDXxnGAzeEN2nkD4trE9sgk4TnXfml95dcbQ2/5HvohY4sNJ0oenOqElS0EjxwngVbh1f9xcZLZSSv2eZaQAYVycoc77rwQZPq2KygutzjE2Kt+iO28GhTuLZGH2dyBT4Gwo7bn8lMoHvVfc0CvW7SUGaCG10VXATFqUT0YI/q/56bKknaTmWLr2seffS7GxbM0MwikW8Gl0a+bFeCZwtSKU6J/0ZFIisE/qCe2mBk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a background scrubber worker (dma_pmd_scrub_work) that zeroes dirty
blocks in meta->dirty_bitmap[] and moves them to meta->free_bitmap[],
and change __GFP_ZERO (want_init_on_alloc) allocations to take blocks
exclusively from free_bitmap[]:

- Remove the per-block memset() and out_prep: loop from
  dma_pmd_pool_alloc_bulk_node(). When dma_pmd_add_page() allocates a
  new PMD page for a zeroed request, zero the 2MB page once and place
  all blocks in free_bitmap[].
- Maintain pool->partial (nr_free > 0, with clean-only pages at head and
  mixed pages at tail), pool->partial_dirty (nr_free == 0, nr_dirty > 0),
  and pool->idle (clean pages at head, dirty pages at tail) so both
  allocation and scrubbing find candidate PMD pages in O(1) time.
- Trigger dma_pmd_scrub_work only when meta->nr_dirty transitions from 0
  to 1 on block free (or when a non-zeroed PMD page is added).
- Detach up to DMA_PMD_SCRUB_BATCH (64) dirty blocks under pool->lock,
  zero them outside the lock, and re-insert them into free_bitmap[].

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-pool.c | 336 ++++++++++++++++++++++++++++++-----
 drivers/iommu/dma-pmd-priv.h |   9 +-
 2 files changed, 296 insertions(+), 49 deletions(-)

diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index deacb6f7d3610..d774cd05347b8 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -32,6 +32,8 @@
 
 #include "dma-pmd-priv.h"
 
+#define DMA_PMD_SCRUB_BATCH	64U
+
 /*
  * DMA_PMD pages whose last block has just been freed and which are over the
  * pool's idle watermark are pushed here locklessly for later release.
@@ -66,6 +68,7 @@ static DEFINE_MUTEX(dma_pmd_pools_lock);
 static LLIST_HEAD(dma_pmd_dead_pools);
 
 static void dma_pmd_schedule_reclaim(void);
+static void dma_pmd_schedule_scrub(void);
 
 static void dma_pmd_pool_free_kref(struct kref *kref)
 {
@@ -250,6 +253,216 @@ static void dma_pmd_schedule_reclaim(void)
 		schedule_work(&dma_pmd_reclaim_work);
 }
 
+/*
+ * Background page scrubber
+ * ------------------------
+ * Freed blocks are returned to @meta->dirty_bitmap so __dma_pmd_free_page()
+ * never pays a memset() on the free hot path. Callers that do not require
+ * zeroed memory take dirty blocks first, while callers with __GFP_ZERO (or
+ * init_on_alloc) take pre-zeroed blocks from @meta->free_bitmap.
+ *
+ * The scrubber runs on system_wq to asynchronously convert dirty blocks into
+ * zeroed blocks in @meta->free_bitmap. To avoid holding @pool->lock across
+ * memset(), it detaches up to DMA_PMD_SCRUB_BATCH (64) dirty bits under
+ * @pool->lock, zeroes the pages unlocked (while their bits are clear in both
+ * bitmaps so no allocator or double-free check can race on them), and
+ * republishes them in @meta->free_bitmap under @pool->lock.
+ *
+ * Triggered lazily (without touching any list on every __dma_pmd_free_page()):
+ * when a PMD page transitions from 0 to 1 dirty block, when a page with dirty
+ * blocks becomes completely idle, or when a __GFP_ZERO allocation misses on
+ * clean pages while dirty pages are present.
+ */
+
+/*
+ * Place @meta on the appropriate pool list according to its available clean
+ * (@nr_free) and dirty (@nr_dirty) block counts. Caller must hold @pool->lock
+ * and update @pool->num_idle_pages when moving into or out of @pool->idle.
+ *
+ * List invariants:
+ * - @pool->full:          avail == 0
+ * - @pool->partial:       0 < avail < nr, nr_free > 0
+ *                         (nr_dirty == 0 at head, nr_dirty > 0 at tail)
+ * - @pool->partial_dirty: 0 < avail < nr, nr_free == 0, nr_dirty > 0
+ * - @pool->idle:          avail == nr
+ *                         (nr_dirty == 0 at head, nr_dirty > 0 at tail)
+ */
+static void dma_pmd_place_meta(struct dma_pmd_pool *pool,
+			       struct dma_pmd_meta *meta)
+{
+	unsigned int avail = dma_pmd_meta_avail(meta);
+	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
+
+	if (!avail) {
+		list_move(&meta->list, &pool->full);
+	} else if (avail == nr) {
+		if (!meta->nr_dirty)
+			list_move(&meta->list, &pool->idle);
+		else
+			list_move_tail(&meta->list, &pool->idle);
+	} else if (!meta->nr_free) {
+		list_move_tail(&meta->list, &pool->partial_dirty);
+	} else if (!meta->nr_dirty) {
+		list_move(&meta->list, &pool->partial);
+	} else {
+		list_move_tail(&meta->list, &pool->partial);
+	}
+}
+
+static struct dma_pmd_meta *dma_pmd_pick_dirty_meta(struct dma_pmd_pool *pool)
+{
+	struct dma_pmd_meta *meta;
+
+	meta = list_first_entry_or_null(&pool->partial_dirty,
+					struct dma_pmd_meta, list);
+	if (meta)
+		return meta;
+
+	if (!list_empty(&pool->partial)) {
+		meta = list_last_entry(&pool->partial, struct dma_pmd_meta, list);
+		if (meta->nr_dirty)
+			return meta;
+	}
+
+	if (!list_empty(&pool->idle)) {
+		meta = list_last_entry(&pool->idle, struct dma_pmd_meta, list);
+		if (meta->nr_dirty) {
+			pool->num_idle_pages--;
+			return meta;
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * dma_pmd_scrub_pool - Scrub one batch of dirty blocks in @pool
+ * @pool: Pool to scrub
+ *
+ * Cost: Zeroes up to DMA_PMD_SCRUB_BATCH blocks (e.g. up to 256 KB for
+ *       order-0) outside @pool->lock; two brief O(batch) bitmap passes under
+ *       @pool->lock.
+ * Locking: Process context. Acquires @pool->lock (irqsave) to detach and
+ *          republish block bits; drops lock during memset().
+ * Frequency: Background worker only (on system_wq).
+ *
+ * Return: true if a batch was scrubbed (more dirty blocks may remain),
+ *         false if @pool has no dirty blocks left or is destroyed.
+ */
+static bool dma_pmd_scrub_pool(struct dma_pmd_pool *pool)
+{
+	unsigned int nr, order, idx, count = 0, used = 0;
+	u16 idxs[DMA_PMD_SCRUB_BATCH];
+	struct dma_pmd_meta *meta;
+	bool should_release = false;
+	unsigned long base_pfn;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	if (pool->destroyed) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		return false;
+	}
+
+	meta = dma_pmd_pick_dirty_meta(pool);
+	if (!meta) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		return false;
+	}
+
+	order = pool->order;
+	nr = DMA_PMD_BLOCKS(order);
+	base_pfn = dma_pmd_meta_to_pfn(meta);
+
+	for_each_set_bit(idx, meta->dirty_bitmap, nr) {
+		struct page *block = pfn_to_page(base_pfn + (idx << order));
+
+		__clear_bit(idx, meta->dirty_bitmap);
+		used++;
+		if (unlikely(folio_contain_hwpoisoned_page(page_folio(block)))) {
+			pr_err_once("dma_pmd: poisoned block at pfn %lu, leaking it to keep pool %p intact\n",
+				    page_to_pfn(block), pool);
+		} else {
+			idxs[count++] = idx;
+		}
+		if (used == meta->nr_dirty || count == DMA_PMD_SCRUB_BATCH)
+			break;
+	}
+	meta->nr_dirty -= used;
+	dma_pmd_place_meta(pool, meta);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	if (unlikely(!count))
+		return used > 0;
+
+	for (idx = 0; idx < count; idx++) {
+		struct page *block = pfn_to_page(base_pfn + (idxs[idx] << order));
+
+		memset(page_address(block), 0, PAGE_SIZE << order);
+	}
+
+	spin_lock_irqsave(&pool->lock, flags);
+	for (idx = 0; idx < count; idx++)
+		__set_bit(idxs[idx], meta->free_bitmap);
+	meta->nr_free += count;
+	pool->block_scrub_cnt += count;
+
+	if (dma_pmd_meta_avail(meta) == nr) {
+		if (pool->destroyed || pool->num_idle_pages >= pool->max_idle_pages) {
+			list_del_init(&meta->list);
+			llist_add(&meta->llnode, &dma_pmd_free_list);
+			should_release = true;
+		} else {
+			pool->num_idle_pages++;
+			dma_pmd_place_meta(pool, meta);
+		}
+	} else if (!pool->destroyed) {
+		dma_pmd_place_meta(pool, meta);
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	if (should_release)
+		dma_pmd_schedule_reclaim();
+
+	return true;
+}
+
+/*
+ * Walk all live pools and scrub dirty blocks until every pool is clean.
+ *
+ * Cost: Proportional to total dirty blocks across all pools; yields via
+ *       cond_resched() between batches of DMA_PMD_SCRUB_BATCH blocks.
+ * Locking: Process context (system_wq). Holds @dma_pmd_pools_lock across the
+ *          pool walk.
+ * Frequency: Scheduled on demand via dma_pmd_schedule_scrub(); coalesced by
+ *            work_pending().
+ */
+static void dma_pmd_scrub_work_fn(struct work_struct *work)
+{
+	struct dma_pmd_pool *pool;
+	bool progress;
+
+	do {
+		progress = false;
+		mutex_lock(&dma_pmd_pools_lock);
+		list_for_each_entry(pool, &dma_pmd_pools, node) {
+			while (dma_pmd_scrub_pool(pool)) {
+				progress = true;
+				cond_resched();
+			}
+		}
+		mutex_unlock(&dma_pmd_pools_lock);
+	} while (progress);
+}
+
+static DECLARE_WORK(dma_pmd_scrub_work, dma_pmd_scrub_work_fn);
+
+static void dma_pmd_schedule_scrub(void)
+{
+	if (!work_pending(&dma_pmd_scrub_work))
+		schedule_work(&dma_pmd_scrub_work);
+}
+
 unsigned int dma_pmd_pools_forget_domain(int idx)
 {
 	struct dma_pmd_pool *pool;
@@ -262,6 +475,8 @@ unsigned int dma_pmd_pools_forget_domain(int idx)
 		spin_lock_irqsave(&pool->lock, flags);
 		list_for_each_entry(meta, &pool->partial, list)
 			dropped += dma_pmd_forget_domain(meta, idx);
+		list_for_each_entry(meta, &pool->partial_dirty, list)
+			dropped += dma_pmd_forget_domain(meta, idx);
 		list_for_each_entry(meta, &pool->idle, list)
 			dropped += dma_pmd_forget_domain(meta, idx);
 		list_for_each_entry(meta, &pool->full, list)
@@ -311,6 +526,7 @@ struct dma_pmd_pool *dma_pmd_pool_create(unsigned int order, unsigned int max_id
 	pool->max_idle_pages = max_idle_pages ? : 16;
 	pool->next_alloc_attempt = jiffies;
 	INIT_LIST_HEAD(&pool->partial);
+	INIT_LIST_HEAD(&pool->partial_dirty);
 	INIT_LIST_HEAD(&pool->idle);
 	INIT_LIST_HEAD(&pool->full);
 
@@ -368,6 +584,7 @@ struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
 	}
 	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
 
+	flush_work(&dma_pmd_scrub_work);
 	kref_put(&pool->refcount, dma_pmd_pool_free_kref);
 	flush_work(&dma_pmd_reclaim_work);
 	return NULL;
@@ -379,6 +596,7 @@ EXPORT_SYMBOL(dma_pmd_pool_destroy);
  * @pool: Owning pool
  * @gfp: GFP allocation flags
  * @nid: Target NUMA node (or NUMA_NO_NODE for local node)
+ * @zero: True if caller requires zeroed blocks in @meta->free_bitmap
  *
  * Cost: Slow path (pool miss); allocates PMD page from buddy on @nid,
  *       splits into compound blocks, and sets the PMD page's membership bit.
@@ -390,7 +608,7 @@ EXPORT_SYMBOL(dma_pmd_pool_destroy);
  *         on failure.
  */
 static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
-					     gfp_t gfp, int nid)
+					     gfp_t gfp, int nid, bool zero)
 {
 	/*
 	 * Require full GFP_KERNEL (not just gfpflags_allow_blocking()):
@@ -431,7 +649,7 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 	 * is shaped into compound pieces by hand. What is left is also free
 	 * of everything slab treats as a bug in GFP_SLAB_BUG_MASK, so the
 	 * metadata allocation below can use it as it stands.
-	 * __GFP_ZERO is handled per-block in dma_pmd_pool_alloc_bulk_node().
+	 * __GFP_ZERO is handled explicitly below after dma_pmd_page_prepare().
 	 */
 	base_gfp = gfp & ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE | __GFP_ZERO);
 
@@ -487,7 +705,9 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 		return NULL;
 	}
 
-	if (meta->flags & DMA_PMD_DECRYPTED) {
+	if (zero || (meta->flags & DMA_PMD_DECRYPTED)) {
+		if (!(meta->flags & DMA_PMD_DECRYPTED))
+			memset(page_address(page), 0, PMD_SIZE);
 		bitmap_set(meta->free_bitmap, 0, nr);
 		meta->nr_free = nr;
 	} else {
@@ -514,8 +734,7 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 static unsigned int dma_pmd_scan_bitmap(struct dma_pmd_pool *pool,
 					unsigned long *bitmap, u16 *countp,
 					unsigned long base_pfn, unsigned int nr,
-					unsigned long want, struct page **out,
-					bool unfreeze)
+					unsigned long want, struct page **out)
 {
 	unsigned int idx, got = 0, used = 0;
 
@@ -531,8 +750,7 @@ static unsigned int dma_pmd_scan_bitmap(struct dma_pmd_pool *pool,
 			pr_err_once("dma_pmd: poisoned block at pfn %lu, leaking it to keep pool %p intact\n",
 				    page_to_pfn(block), pool);
 		} else {
-			if (unfreeze)
-				page_ref_unfreeze(block, 1);
+			page_ref_unfreeze(block, 1);
 			out[got++] = block;
 		}
 
@@ -544,6 +762,41 @@ static unsigned int dma_pmd_scan_bitmap(struct dma_pmd_pool *pool,
 	return got;
 }
 
+static struct dma_pmd_meta *dma_pmd_pick_meta(struct dma_pmd_pool *pool, bool zero)
+{
+	struct dma_pmd_meta *meta;
+
+	if (!zero) {
+		meta = list_first_entry_or_null(&pool->partial_dirty,
+						struct dma_pmd_meta, list);
+		if (meta)
+			return meta;
+		if (!list_empty(&pool->partial))
+			return list_last_entry(&pool->partial,
+					       struct dma_pmd_meta, list);
+		if (!list_empty(&pool->idle)) {
+			meta = list_last_entry(&pool->idle,
+					       struct dma_pmd_meta, list);
+			pool->num_idle_pages--;
+			return meta;
+		}
+		return NULL;
+	}
+
+	meta = list_first_entry_or_null(&pool->partial, struct dma_pmd_meta, list);
+	if (meta)
+		return meta;
+
+	list_for_each_entry(meta, &pool->idle, list) {
+		if (meta->nr_free) {
+			pool->num_idle_pages--;
+			return meta;
+		}
+	}
+
+	return NULL;
+}
+
 /* Extract up to @want available blocks from @meta under @pool->lock. */
 static unsigned long dma_pmd_take_blocks(struct dma_pmd_pool *pool,
 					 struct dma_pmd_meta *meta,
@@ -555,23 +808,18 @@ static unsigned long dma_pmd_take_blocks(struct dma_pmd_pool *pool,
 	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
 	unsigned int got = 0, used;
 
-	if (zero) {
-		got += dma_pmd_scan_bitmap(pool, meta->free_bitmap, &meta->nr_free,
-					   base_pfn, nr, want, out, true);
+	if (!zero)
 		got += dma_pmd_scan_bitmap(pool, meta->dirty_bitmap, &meta->nr_dirty,
-					   base_pfn, nr, want - got, out + got, false);
-	} else {
-		got += dma_pmd_scan_bitmap(pool, meta->dirty_bitmap, &meta->nr_dirty,
-					   base_pfn, nr, want, out, false);
-		got += dma_pmd_scan_bitmap(pool, meta->free_bitmap, &meta->nr_free,
-					   base_pfn, nr, want - got, out + got, true);
-	}
+					   base_pfn, nr, want, out);
+	got += dma_pmd_scan_bitmap(pool, meta->free_bitmap, &meta->nr_free,
+				   base_pfn, nr, want - got, out + got);
+
 	used = avail_before - dma_pmd_meta_avail(meta);
-	if (!dma_pmd_meta_avail(meta) || WARN_ON_ONCE(!used)) {
+	if (WARN_ON_ONCE(!used)) {
 		meta->nr_free = 0;
 		meta->nr_dirty = 0;
-		list_move(&meta->list, &pool->full);
 	}
+	dma_pmd_place_meta(pool, meta);
 
 	return got;
 }
@@ -588,7 +836,7 @@ static unsigned long dma_pmd_take_blocks(struct dma_pmd_pool *pool,
  *       under a single lock acquisition. Slow path (both empty) calls
  *       dma_pmd_add_page().
  * Locking: Acquires @pool->lock (irqsave) for the bitmap scan. Drops lock
- *          during slow-path PMD buddy allocation and per-block initialization.
+ *          during slow-path PMD buddy allocation.
  * Frequency: High (called per RX buffer refill or per SKB TX page frag refill).
  *
  * A pool hands out a block of a PMD page it already owns, on the node that
@@ -605,7 +853,8 @@ unsigned long dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp,
 					   int nid, unsigned long nr_pages,
 					   struct page **page_array)
 {
-	unsigned long allocated = 0, flags, i;
+	unsigned long allocated = 0, flags;
+	bool should_scrub = false;
 	bool zero;
 
 	if (unlikely(!pool || pool->destroyed || !nr_pages ||
@@ -619,22 +868,18 @@ unsigned long dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp,
 	while (allocated < nr_pages) {
 		struct dma_pmd_meta *meta;
 
-		/* Partially used pages first, idle ones next. */
-		meta = list_first_entry_or_null(&pool->partial, struct dma_pmd_meta, list);
-		if (!meta && !list_empty(&pool->idle)) {
-			meta = list_first_entry(&pool->idle, struct dma_pmd_meta, list);
-			list_move(&meta->list, &pool->partial);
-			pool->num_idle_pages--;
-		}
+		meta = dma_pmd_pick_meta(pool, zero);
 		if (!meta) {
 			/* Fallback to a new allocation */
 			spin_unlock_irqrestore(&pool->lock, flags);
-			meta = dma_pmd_add_page(pool, gfp, nid);
+			meta = dma_pmd_add_page(pool, gfp, nid, zero);
 			if (!meta)
-				goto out_prep;
+				goto out;
 			spin_lock_irqsave(&pool->lock, flags);
 			pool->pmd_alloc_cnt++;
 			list_add(&meta->list, &pool->partial);
+			if (meta->nr_dirty)
+				should_scrub = true;
 		}
 
 		allocated += dma_pmd_take_blocks(pool, meta,
@@ -643,14 +888,9 @@ unsigned long dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp,
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-out_prep:
-	for (i = 0; i < allocated; i++) {
-		if (!page_count(page_array[i])) {
-			page_ref_unfreeze(page_array[i], 1);
-			if (zero)
-				memset(page_address(page_array[i]), 0, PAGE_SIZE << pool->order);
-		}
-	}
+out:
+	if (should_scrub)
+		dma_pmd_schedule_scrub();
 	return allocated;
 }
 EXPORT_SYMBOL(dma_pmd_pool_alloc_bulk_node);
@@ -674,7 +914,9 @@ EXPORT_SYMBOL(dma_pmd_pool_alloc_bulk_node);
 bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool)
 {
 	return pool && !READ_ONCE(pool->destroyed) &&
-	       (!list_empty_careful(&pool->partial) || !list_empty_careful(&pool->idle));
+	       (!list_empty_careful(&pool->partial) ||
+		!list_empty_careful(&pool->partial_dirty) ||
+		!list_empty_careful(&pool->idle));
 }
 EXPORT_SYMBOL(dma_pmd_pool_has_free);
 
@@ -706,8 +948,8 @@ bool __dma_pmd_free_page(struct page *page)
 	struct dma_pmd_pool *pool = meta->pool;
 	unsigned long pfn = page_to_pfn(page);
 	bool should_release = false;
+	bool should_scrub = false;
 	bool zeroed_on_free = false;
-	unsigned int avail;
 	unsigned long flags;
 
 	idx = (pfn - dma_pmd_meta_to_pfn(meta)) >> pool->order;
@@ -755,28 +997,28 @@ bool __dma_pmd_free_page(struct page *page)
 		meta->nr_free++;
 	} else {
 		__set_bit(idx, meta->dirty_bitmap);
-		meta->nr_dirty++;
+		should_scrub = !meta->nr_dirty++;
 	}
-	avail = dma_pmd_meta_avail(meta);
 	pool->block_free_cnt++;
 
-	if (avail == 1 && !pool->destroyed)
-		list_move(&meta->list, &pool->partial);
-
-	if (avail == nr) {
+	if (dma_pmd_meta_avail(meta) == nr) {
 		if (pool->destroyed || pool->num_idle_pages >= pool->max_idle_pages) {
 			list_del_init(&meta->list);
 			llist_add(&meta->llnode, &dma_pmd_free_list);
 			should_release = true;
 		} else {
-			list_move(&meta->list, &pool->idle);
 			pool->num_idle_pages++;
+			dma_pmd_place_meta(pool, meta);
 		}
+	} else if (!pool->destroyed) {
+		dma_pmd_place_meta(pool, meta);
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	if (should_release)
 		dma_pmd_schedule_reclaim();
+	else if (should_scrub)
+		dma_pmd_schedule_scrub();
 
 	return true;
 }
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 8c7a50d5b7220..82a5c869aa216 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -181,8 +181,10 @@ static inline unsigned int dma_pmd_meta_avail(const struct dma_pmd_meta *m)
  *		block bitmaps and the statistics counters
  * @order:	Block order managed by this pool (<= PMD_ORDER)
  * @destroyed:	Set when dma_pmd_pool_destroy() has been called
- * @partial:	List of PMD pages with at least 1 free block, but not all
- *		of them (MRU ordered). Candidates for allocation.
+ * @partial:	List of partially used PMD pages with @nr_free > 0 (clean-only
+ *		at head, mixed clean/dirty at tail)
+ * @partial_dirty: List of partially used PMD pages with @nr_free == 0 and
+ *		@nr_dirty > 0
  * @idle:	List of PMD pages whose every usable block is free. Held
  *		separately because they can be released under pressure.
  * @full:	List of PMD pages with 0 free blocks
@@ -193,6 +195,7 @@ static inline unsigned int dma_pmd_meta_avail(const struct dma_pmd_meta *m)
  * @pmd_free_cnt: Statistics counter of PMD pages released back to buddy
  * @block_alloc_cnt: Statistics counter of block allocations satisfied
  * @block_free_cnt: Statistics counter of block frees recycled into pool
+ * @block_scrub_cnt: Statistics counter of dirty blocks zeroed by scrubber
  * @next_alloc_attempt: Do not attempt a new order-9 allocation before this time.
  *		Damps repeated high-order GFP_ATOMIC failures under
  *		fragmentation, which would otherwise be retried on every
@@ -207,6 +210,7 @@ struct dma_pmd_pool {
 	u8			order;
 	bool			destroyed;
 	struct list_head	partial;
+	struct list_head	partial_dirty;
 	struct list_head	idle;
 	struct list_head	full;
 	unsigned int		num_idle_pages;
@@ -217,6 +221,7 @@ struct dma_pmd_pool {
 	u64			pmd_free_cnt;
 	u64			block_alloc_cnt;
 	u64			block_free_cnt;
+	u64			block_scrub_cnt;
 
 	/* Cold. */
 	unsigned long		next_alloc_attempt;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


