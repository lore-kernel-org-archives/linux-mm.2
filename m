Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54576CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079596B00A5; Sat,  3 Oct 2026 17:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051FF6B00A7; Sat,  3 Oct 2026 17:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA146B00A9; Sat,  3 Oct 2026 17:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8D126B00A5
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 488121609FD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:11 +0000 (UTC)
X-FDA: 85282590582.20.4CE65C8
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 92D1440006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q82dJdCP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3O3LBagYKCIIrxo55umuumrk.iusrot03-ssq1giq.uxm@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3O3LBagYKCIIrxo55umuumrk.iusrot03-ssq1giq.uxm@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruiMF87Q7JhX4xV02dgR8MOgre7MI5p5T6AzJckpwRA=;
	b=09/RfMFB6wxOFIUnk1G9/HvGFQtEPTUAF+mO+mYVpRPfiBBDjRoVPXfwqVeguaasY6qmIG
	nOCUUOl6Y9e57sqUVEMxE/KCW578n+yQiYq2O6XIQNC0ivtMcOQEyGZuyVLJVbLF/pU6Su
	3hzwnme4BkQCKTIqOOvlqj6F/6FDZ5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q82dJdCP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3O3LBagYKCIIrxo55umuumrk.iusrot03-ssq1giq.uxm@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3O3LBagYKCIIrxo55umuumrk.iusrot03-ssq1giq.uxm@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062589;
	b=19VmkksmYZvkP0xPw8WgX94ayDrxQTIUgDbg/bdQQr0PpC9/VTeO+1Os3Eg/H+Di+wmYjc
	RlkkgejKhGVuRCT53wRQkFnvtqcETfFH70njRnaf5exMAQo7mKnbYFyPtEeeufWzo5RVBt
	qHkOsQXjhDt1TPz5ir2PrrzllwRS8so=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e49c5ff09so84161866b.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062588; x=1791667388; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ruiMF87Q7JhX4xV02dgR8MOgre7MI5p5T6AzJckpwRA=;
        b=Q82dJdCPFk3Kh6BMdBSTXMbfpJ4qGKP6o8g09ezkultiwLDR9IQ7UiBYZCPvc1YVwu
         l+fsPmxU2IjDNdfulqIrlcdMUpkJpzf7w7v2ITeOsJwzfgVVavYpn2Y0v7qf6xpAcozy
         kzKSEZ2Ld7eobll2PI5kdDG2FO02U/XC+Yn/f9H+n4cmkY4hpGe9dmGl2iMB4f2VU6xP
         4dzWXytdXWi9rBBtDQGwgLZ+ZWk+HJ4XiZ7onQw2ejn5oVC6roDkJQPUaCeiOXmdUvds
         G3fXJXYa9SWbMwdZ0j5Z2FMsPVaV/7sxVYiYypJoA3FKuUZwLqNTLcJ0kOLP/EKSUVn+
         qFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062588; x=1791667388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ruiMF87Q7JhX4xV02dgR8MOgre7MI5p5T6AzJckpwRA=;
        b=Ygv1eK2LBNnvOIMhDbyx53NBbC1CwMuDPQCiyhrlfR6S/lgN5v9AADXFqn42D85hgg
         EmqO9pia6cvhDTtXR7xaqk+vrb5JN1/b2PocKk73bqexz8dmPjSwK3zKLU6GNIlLRLAQ
         +3ZoUH+jzKxe52q7N80bgGQPsf+gkftM7uYthbl0sxoQ8EQu1qDHPhZ6gz23r4mHP0xM
         4Ubre7xHWcRmzXSRbZdFB3VFr/ZJ9Hby1957bKI16KkgyFdTGKTgKX61tMSgMiNvF0Zx
         edG9/UKaKKZJhcAHKsDcdLAnQREFXWyKUzHgPoXgjcM01wlNY4T2hOKsKldMQSr77Vvw
         vhaA==
X-Forwarded-Encrypted: i=1; AKwUvBymLHrLdWXyU16H5t5bqPbIO93A/SAvu2XwsTeSvCNhOg/SPEWnUuyzG774CKmFWLHo/YtNHrhejA==@kvack.org
X-Gm-Message-State: AFuF++kzq78syAZsm0Fhn/Pjh7bSbCdRA9VzS3Mvnliakq5QHoCx1Yf/
	PaQS7rBaM48VDD3f2aarC+VjA8gDGAKkDtIH977OWybFqHMQ/+VGJIG5gckGheB/196pUOGYk57
	BRshGSA==
X-Received: from ejra7.prod.google.com ([2002:a17:906:4687:b0:c2e:7ffa:c615])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:cf86:b0:c26:19de:9ad3
 with SMTP id a640c23a62f3a-c2e4af70e4emr531232766b.43.1791062587675; Sat, 03
 Oct 2026 14:23:07 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:35 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-17-lrizzo@google.com>
Subject: [RFC: DMA_PMD 16/22] iommu/dma: Add per-NUMA-node PMD page reservoir
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
X-Stat-Signature: qijuxdfghapq13q5xenaiekod7eiwpct
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92D1440006
X-HE-Tag: 1791062589-16326
X-HE-Meta: U2FsdGVkX1+DahvNXqnA98MANZLGl/RECtG4bi4A2Yo+CjIrdGnCOWGIMDLynhErhj94x52E8m9LDTgIwVPU3Qst+cdztMJ/6VyNzVISPX/Zox6Mv+ipH7VOFdDLb4+ILYHv0xziDrRwkmjcP34ICjIwPL6CVGNtx2K/A0J92e5HfHeEQIEFTl2J+Sx55iEhgqIzqVzu9qvsah/Pn6TA3gYyjaJ6a2IvZkMeQdv3F0ezsc3rvYnDUDozTOGScCa9Jc3ZGMACCFpjJBKy0I9k9sW6tuZ22b9lu55nlh6LT2pH1828LUCoSWoCYsIc88gsyAVg0bru4AwSIGg3X/PC58NCjbVy4/nf2vXV5daD6Pp0FGVKsiM3TvZZlR0L/qvQ5Y2njnbWPAMF3nv4xybyJN0XU7252ZWNWJf2dCjQpqWNxqPxJq6PF9nFPlm7lg/Hoy2q2xiNH2fx+8ly5g2PcWieBx7TgaJ8OJclNnZ//kZzsuPewGlY3aMYzADSeUCXB15ZGnWJJdW0XZnP8SYWgNyZjmB9MetnIfpkOOksLnVUxvBSG0KAHpgl4AIUz/cyJgUXqHPyw6DaC1lDJspm3Plx6VTQstKbni1PiOZec/j8/uQgV/EplNHNW0zkq/R2t+L+i5U/4kOflngs3TIQ0sE85Jt1hZB+SBuQB11DWlvPuVvayLDq9vkuTNcLIg99I45RqITWDHs8TykdrL3J45WgkPkqglb0yn3l3CjUnFoMXwpNTxSRqMF+kH8SUc8M/A9SVwDUJ4cSAHmCqchqR9mwAagVvcj+Cuz7q94rnatttz731awO+njbtbHYeHf34NTdAWcn8+KmlvPZkiKeE5qmOa7KvndA1rg9xy4Yre1j6RkN3QQI9GjSZOLKikYYr+1mkHl4eC4fSKfQdGKM9B2vAmFtTcRU8aNejpejsJzs+6DaXHVRemPiAz9ctTJf8vHDpNN4n8EZwjeZLsN
 whpVG+2f
 LfKGPSCGmW+gfzjDf+iP573tIGiYW8lsp4UIOB17BEisFrNwP0VHFJMKr0wQR/pM8TEW67+jihTraZ8kpGFux3TYcQKRRO5zrom0jXmz6X6g4WXgTTadaedXYnGXKX9B7tBK9VT9Jd30UUTSQjCE47NurlQ4KbBAEIDSRtW8O/V0Zxi0Hda3Vrprd195LFUc0dnLwrf9Sk9Fh0y5OJwQ82tJYOXE2v+KGetTqh7DRSC7d9DxKoyXAiYwCwYAovJgoXpTUpzM72yWSZM/ktMhd+RsfytjHEcc6YRLiOblN58sy+lDBzGf79FM3/yRneoYTPbTr0NMkN/VgBrNXHu6fcCxUYNEWfyn1+xyuoct4bx1oRV9L7TfyvadYzMZ99A2k8xs127HDFJiNlCJsYfrowFjx/+NV9nudfaY7l7xX7r/5iLAjN138KmrXJIMJKXTdGyBclOOeqj9OER5+vM/788Ayk4l0OO/TBsfpHYtQ+MEhZJ0s1EfsraefAbiz7HfGIV7+meuPafUt29ulCPxA+z8omlzBieu2eL1bLw+eH41gddskGZHaMXVUVZ0+VZatREe8OlOVncj9GT6FmEwMgzosy9EsxAwExSESWLrpZx/h/kmX+rpuW8DyTyWhwIr6+O54wBbpjjIKAoQzmxkWV9WJYMtOcObNzZDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-NUMA-node reservoir of pre-allocated, pre-zeroed, and
pre-prepared 2MB pages (dma_pmd_reservoirs[MAX_NUMNODES]) refilled in
process context by a background worker (dma_pmd_reservoir_work):

- Controlled by dma_pmd.reservoir_max (default 16 PMD pages = 32 MB per
  N_MEMORY node, subject to the global dma_pmd_max_pages ceiling).
- dma_pmd_add_page() first tries dma_pmd_reservoir_get(nid) (preferring
  the target NUMA node and falling back to other N_MEMORY nodes),
  avoiding blocking or failing order-9 buddy allocations on pool misses.
- When a node's reservoir drops to <= reservoir_max / 2 (or on pool
  creation), dma_pmd_reservoir_work is scheduled to refill in the
  background.
- Integrate the reservoir with dma_pmd_shrink_count() and
  dma_pmd_shrink_scan() so reservoir pages are reclaimed first under
  memory pressure.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-pool.c | 307 +++++++++++++++++++++++++++++++----
 1 file changed, 277 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index d774cd05347b8..d48c8e19741ab 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/nodemask.h>
 #include <linux/rcupdate.h>
 #include <linux/seq_file.h>
 #include <linux/set_memory.h>
@@ -62,6 +63,18 @@ static atomic_long_t dma_pmd_nr_pages __cacheline_aligned_in_smp;
 static unsigned long dma_pmd_max_pages __read_mostly;
 core_param(dma_pmd_max_pages, dma_pmd_max_pages, ulong, 0644);
 
+/* Target number of pre-allocated PMD pages per NUMA node in reservoir. */
+static unsigned int dma_pmd_reservoir_max __read_mostly = 16;
+module_param_named(reservoir_max, dma_pmd_reservoir_max, uint, 0644);
+
+struct dma_pmd_reservoir {
+	spinlock_t		lock;	/* protects @pages and @nr_pages */
+	struct list_head	pages;
+	unsigned int		nr_pages;
+};
+
+static struct dma_pmd_reservoir dma_pmd_reservoirs[MAX_NUMNODES];
+
 /* All live pools. */
 static LIST_HEAD(dma_pmd_pools);
 static DEFINE_MUTEX(dma_pmd_pools_lock);
@@ -69,6 +82,7 @@ static LLIST_HEAD(dma_pmd_dead_pools);
 
 static void dma_pmd_schedule_reclaim(void);
 static void dma_pmd_schedule_scrub(void);
+static void dma_pmd_schedule_reservoir(void);
 
 static void dma_pmd_pool_free_kref(struct kref *kref)
 {
@@ -81,8 +95,10 @@ static void dma_pmd_pool_free_kref(struct kref *kref)
 static int dma_pmd_page_prepare(struct page *page, struct dma_pmd_meta *meta,
 				bool can_block)
 {
-	bool want_decrypt = READ_ONCE(dma_pmd_decrypt);
-	bool want_pin = READ_ONCE(dma_pmd_pin);
+	bool want_decrypt = READ_ONCE(dma_pmd_decrypt) &&
+			    !(meta->flags & DMA_PMD_DECRYPTED);
+	bool want_pin = READ_ONCE(dma_pmd_pin) &&
+			!(meta->flags & DMA_PMD_PINNED);
 	void *vaddr = page_address(page);
 	int ret;
 
@@ -142,6 +158,16 @@ static int dma_pmd_page_unprepare(struct dma_pmd_meta *meta)
 	return 0;
 }
 
+static void dma_pmd_free_reservoir_page(struct dma_pmd_meta *meta)
+{
+	struct page *page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
+
+	if (!dma_pmd_page_unprepare(meta)) {
+		__free_pages(page, PMD_ORDER);
+		atomic_long_dec(&dma_pmd_nr_pages);
+	}
+}
+
 /*
  * Releasing an idle PMD page proceeds in three stages:
  *
@@ -226,8 +252,12 @@ static void dma_pmd_reclaim_work_fn(struct work_struct *work)
 	struct dma_pmd_pool *pool, *ptmp;
 	struct dma_pmd_meta *meta, *tmp;
 
-	llist_for_each_entry_safe(meta, tmp, node, llnode)
-		dma_pmd_release_page(meta);
+	llist_for_each_entry_safe(meta, tmp, node, llnode) {
+		if (meta->pool)
+			dma_pmd_release_page(meta);
+		else
+			dma_pmd_free_reservoir_page(meta);
+	}
 
 	node = llist_del_all(&dma_pmd_dead_pools);
 	if (node) {
@@ -463,6 +493,186 @@ static void dma_pmd_schedule_scrub(void)
 		schedule_work(&dma_pmd_scrub_work);
 }
 
+/*
+ * Per-NUMA-node PMD page reservoir
+ * --------------------------------
+ * Order-9 (2MB) buddy allocations can compact/reclaim and fail or stall in
+ * atomic context (such as NAPI RX refill or softirq TX), and CoCo decryption /
+ * hypervisor pinning cannot run in atomic context at all.
+ *
+ * Each NUMA node maintains a small reservoir of up to @dma_pmd_reservoir_max
+ * (default 8 = 16 MB/node) pre-allocated, pre-zeroed, and pre-decrypted/pinned
+ * PMD pages. On a pool miss, dma_pmd_add_page() pops a ready PMD page from the
+ * target node's reservoir in O(1) under a spinlock (falling back to other
+ * nodes before calling alloc_pages_node() directly).
+ *
+ * A background worker on system_wq refills nodes whenever a node's count drops
+ * to or below half of @dma_pmd_reservoir_max, on a reservoir miss, or when a
+ * new pool is created. Pages held in the reservoir count toward the global
+ * @dma_pmd_nr_pages budget and are reclaimable by the shrinker under memory
+ * pressure.
+ */
+
+/**
+ * dma_pmd_reservoir_refill_node - Refill node @nid's reservoir up to @max
+ * @nid: NUMA node ID
+ * @max: Target number of PMD pages to hold in @nid's reservoir
+ *
+ * Cost: Slow path; allocates order-9 pages with GFP_KERNEL | __GFP_RETRY_MAYFAIL,
+ *       populates metadata, decrypts/pins if configured, and zeroes 2MB per page.
+ * Locking: Process context (system_wq); sleeps during buddy allocation, CPA
+ *          decryption, and cond_resched(). Takes @res->lock briefly to enqueue.
+ * Frequency: Rare (when reservoir drops to <= @max / 2 or on pool creation).
+ */
+static void dma_pmd_reservoir_refill_node(int nid, unsigned int max)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_THISNODE | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
+	struct dma_pmd_reservoir *res = &dma_pmd_reservoirs[nid];
+
+	while (READ_ONCE(res->nr_pages) < max) {
+		struct dma_pmd_meta *meta;
+		unsigned long flags;
+		struct page *page;
+
+		if (atomic_long_inc_return(&dma_pmd_nr_pages) >
+		    READ_ONCE(dma_pmd_max_pages)) {
+			atomic_long_dec(&dma_pmd_nr_pages);
+			break;
+		}
+
+		page = alloc_pages_node(nid, gfp, PMD_ORDER);
+		if (!page) {
+			atomic_long_dec(&dma_pmd_nr_pages);
+			break;
+		}
+
+		if (unlikely(!dma_pmd_meta_ensure_pfn(page_to_pfn(page), true))) {
+			__free_pages(page, PMD_ORDER);
+			atomic_long_dec(&dma_pmd_nr_pages);
+			break;
+		}
+
+		meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
+		memset(meta, 0, sizeof(*meta));
+		spin_lock_init(&meta->map_lock);
+
+		if (dma_pmd_page_prepare(page, meta, true)) {
+			__free_pages(page, PMD_ORDER);
+			atomic_long_dec(&dma_pmd_nr_pages);
+			break;
+		}
+
+		if (!(meta->flags & DMA_PMD_DECRYPTED))
+			memset(page_address(page), 0, PMD_SIZE);
+
+		spin_lock_irqsave(&res->lock, flags);
+		list_add(&meta->list, &res->pages);
+		res->nr_pages++;
+		spin_unlock_irqrestore(&res->lock, flags);
+
+		cond_resched();
+	}
+}
+
+static void dma_pmd_reservoir_work_fn(struct work_struct *work)
+{
+	unsigned int max = READ_ONCE(dma_pmd_reservoir_max);
+	int nid;
+
+	if (!max || !dma_pmd_meta_base())
+		return;
+
+	for_each_node_state(nid, N_MEMORY)
+		dma_pmd_reservoir_refill_node(nid, max);
+}
+
+static DECLARE_WORK(dma_pmd_reservoir_work, dma_pmd_reservoir_work_fn);
+
+static void dma_pmd_schedule_reservoir(void)
+{
+	if (READ_ONCE(dma_pmd_reservoir_max) &&
+	    !work_pending(&dma_pmd_reservoir_work))
+		schedule_work(&dma_pmd_reservoir_work);
+}
+
+/*
+ * Pop one pre-prepared PMD page from node @nid's reservoir.
+ *
+ * Cost: O(1) list pop under @res->lock.
+ * Locking: Acquires @res->lock (irqsave). Safe from any context (IRQ, softirq,
+ *          process). Never sleeps.
+ * Frequency: Only on pool miss (dma_pmd_add_page()).
+ */
+static struct dma_pmd_meta *dma_pmd_reservoir_pop_node(int nid, unsigned int max)
+{
+	struct dma_pmd_reservoir *res = &dma_pmd_reservoirs[nid];
+	struct dma_pmd_meta *meta;
+	unsigned long flags;
+	bool refill = false;
+
+	if (!READ_ONCE(res->nr_pages))
+		return NULL;
+
+	spin_lock_irqsave(&res->lock, flags);
+	meta = list_first_entry_or_null(&res->pages, struct dma_pmd_meta, list);
+	if (meta) {
+		list_del_init(&meta->list);
+		res->nr_pages--;
+		refill = res->nr_pages <= max / 2;
+	}
+	spin_unlock_irqrestore(&res->lock, flags);
+
+	if (refill)
+		dma_pmd_schedule_reservoir();
+
+	return meta;
+}
+
+/**
+ * dma_pmd_reservoir_get - Obtain a pre-prepared PMD page, preferring @nid
+ * @nid: Preferred NUMA node (or NUMA_NO_NODE for local node)
+ *
+ * Tries @nid's reservoir first, then falls back to other memory nodes and
+ * schedules an async refill if a fallback or empty reservoir is encountered.
+ *
+ * Cost: O(1) on local node hit; O(MAX_NUMNODES) lockless checks on miss.
+ * Locking: Acquires @res->lock (irqsave) on non-empty node. Safe from any
+ *          context. Never sleeps.
+ * Frequency: Only on pool miss (dma_pmd_add_page()).
+ *
+ * Return: Metadata pointer of a ready PMD page (not yet compound-split or
+ *         bound to a pool), or NULL if all reservoirs are empty.
+ */
+static struct dma_pmd_meta *dma_pmd_reservoir_get(int nid)
+{
+	unsigned int max = READ_ONCE(dma_pmd_reservoir_max);
+	struct dma_pmd_meta *meta;
+	int target_nid, n;
+
+	if (!max)
+		return NULL;
+
+	target_nid = (nid == NUMA_NO_NODE) ? numa_mem_id() : nid;
+	if (target_nid >= 0 && target_nid < MAX_NUMNODES) {
+		meta = dma_pmd_reservoir_pop_node(target_nid, max);
+		if (meta)
+			return meta;
+	}
+
+	for_each_node_state(n, N_MEMORY) {
+		if (n == target_nid)
+			continue;
+		meta = dma_pmd_reservoir_pop_node(n, max);
+		if (meta) {
+			dma_pmd_schedule_reservoir();
+			return meta;
+		}
+	}
+
+	dma_pmd_schedule_reservoir();
+	return NULL;
+}
+
 unsigned int dma_pmd_pools_forget_domain(int idx)
 {
 	struct dma_pmd_pool *pool;
@@ -538,6 +748,7 @@ struct dma_pmd_pool *dma_pmd_pool_create(unsigned int order, unsigned int max_id
 	}
 	list_add(&pool->node, &dma_pmd_pools);
 	mutex_unlock(&dma_pmd_pools_lock);
+	dma_pmd_schedule_reservoir();
 
 	return pool;
 }
@@ -616,10 +827,18 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 	 */
 	bool can_block = (gfp & GFP_KERNEL) == GFP_KERNEL;
 	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
+	bool from_reservoir = false;
 	struct dma_pmd_meta *meta;
 	gfp_t alloc_gfp, base_gfp;
 	struct page *page;
 
+	meta = dma_pmd_reservoir_get(nid);
+	if (meta) {
+		page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
+		from_reservoir = true;
+		goto prepare;
+	}
+
 	/*
 	 * A high-order allocation is expensive when it fails, and under fragmentation
 	 * it fails on every pool miss. For GFP_ATOMIC, back off briefly.
@@ -687,9 +906,10 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 
 	meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
 	memset(meta, 0, sizeof(*meta));
-	meta->pool = pool;
 	spin_lock_init(&meta->map_lock);
 
+prepare:
+	meta->pool = pool;
 	if (dma_pmd_page_prepare(page, meta, can_block)) {
 		__free_pages(page, PMD_ORDER);
 		atomic_long_dec(&dma_pmd_nr_pages);
@@ -705,8 +925,8 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 		return NULL;
 	}
 
-	if (zero || (meta->flags & DMA_PMD_DECRYPTED)) {
-		if (!(meta->flags & DMA_PMD_DECRYPTED))
+	if (from_reservoir || zero || (meta->flags & DMA_PMD_DECRYPTED)) {
+		if (!from_reservoir && !(meta->flags & DMA_PMD_DECRYPTED))
 			memset(page_address(page), 0, PMD_SIZE);
 		bitmap_set(meta->free_bitmap, 0, nr);
 		meta->nr_free = nr;
@@ -1042,14 +1262,17 @@ static unsigned long dma_pmd_shrink_count(struct shrinker *shrink,
 {
 	struct dma_pmd_pool *pool;
 	unsigned long nr = 0;
+	int nid;
 
-	if (!mutex_trylock(&dma_pmd_pools_lock))
-		return 0;
+	for_each_node_state(nid, N_MEMORY)
+		nr += READ_ONCE(dma_pmd_reservoirs[nid].nr_pages);
 
-	list_for_each_entry(pool, &dma_pmd_pools, node)
-		nr += READ_ONCE(pool->num_idle_pages);
+	if (mutex_trylock(&dma_pmd_pools_lock)) {
+		list_for_each_entry(pool, &dma_pmd_pools, node)
+			nr += READ_ONCE(pool->num_idle_pages);
 
-	mutex_unlock(&dma_pmd_pools_lock);
+		mutex_unlock(&dma_pmd_pools_lock);
+	}
 
 	return nr << PMD_ORDER;
 }
@@ -1062,34 +1285,50 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 	unsigned long freed = 0;
 	LIST_HEAD(release_list);
 	unsigned long flags;
-	int srcu_idx;
+	int srcu_idx, nid;
 
-	if (!mutex_trylock(&dma_pmd_pools_lock))
-		return SHRINK_STOP;
+	for_each_node_state(nid, N_MEMORY) {
+		struct dma_pmd_reservoir *res = &dma_pmd_reservoirs[nid];
 
-	srcu_idx = srcu_read_lock(&dma_pmd_srcu);
-	list_for_each_entry(pool, &dma_pmd_pools, node) {
-		/*
-		 * Every PMD page on @idle is a candidate, so this detaches one
-		 * per iteration and stops as soon as the reclaim path has
-		 * what it asked for: the IRQs-off section is bounded by the
-		 * work done, not by how many PMD pages the pool holds.
-		 */
-		spin_lock_irqsave(&pool->lock, flags);
-		list_for_each_entry_safe(meta, tmp, &pool->idle, list) {
+		if (!READ_ONCE(res->nr_pages))
+			continue;
+		spin_lock_irqsave(&res->lock, flags);
+		list_for_each_entry_safe(meta, tmp, &res->pages, list) {
 			if (freed >= sc->nr_to_scan)
 				break;
 			list_move(&meta->list, &release_list);
-			pool->num_idle_pages--;
+			res->nr_pages--;
 			freed += 1UL << PMD_ORDER;
 		}
-		spin_unlock_irqrestore(&pool->lock, flags);
-
+		spin_unlock_irqrestore(&res->lock, flags);
 		if (freed >= sc->nr_to_scan)
 			break;
 	}
 
-	mutex_unlock(&dma_pmd_pools_lock);
+	srcu_idx = srcu_read_lock(&dma_pmd_srcu);
+	if (freed < sc->nr_to_scan && mutex_trylock(&dma_pmd_pools_lock)) {
+		list_for_each_entry(pool, &dma_pmd_pools, node) {
+			/*
+			 * Every PMD page on @idle is a candidate, so this detaches one
+			 * per iteration and stops as soon as the reclaim path has
+			 * what it asked for: the IRQs-off section is bounded by the
+			 * work done, not by how many PMD pages the pool holds.
+			 */
+			spin_lock_irqsave(&pool->lock, flags);
+			list_for_each_entry_safe(meta, tmp, &pool->idle, list) {
+				if (freed >= sc->nr_to_scan)
+					break;
+				list_move(&meta->list, &release_list);
+				pool->num_idle_pages--;
+				freed += 1UL << PMD_ORDER;
+			}
+			spin_unlock_irqrestore(&pool->lock, flags);
+
+			if (freed >= sc->nr_to_scan)
+				break;
+		}
+		mutex_unlock(&dma_pmd_pools_lock);
+	}
 
 	/*
 	 * Retiring is done outside both locks: dma_pmd_release_page() unmaps
@@ -1103,8 +1342,10 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 		if (meta->flags & (DMA_PMD_DECRYPTED | DMA_PMD_PINNED)) {
 			llist_add(&meta->llnode, &dma_pmd_free_list);
 			dma_pmd_schedule_reclaim();
-		} else {
+		} else if (meta->pool) {
 			dma_pmd_release_page(meta);
+		} else {
+			dma_pmd_free_reservoir_page(meta);
 		}
 	}
 	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
@@ -1128,6 +1369,12 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 static int __init dma_pmd_init(void)
 {
 	struct shrinker *shrink;
+	int nid;
+
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		spin_lock_init(&dma_pmd_reservoirs[nid].lock);
+		INIT_LIST_HEAD(&dma_pmd_reservoirs[nid].pages);
+	}
 
 	/*
 	 * Hard ceiling on memory diverted from the buddy allocator into 2MB
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


