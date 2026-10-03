Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1807FCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A326B009E; Sat,  3 Oct 2026 17:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421DE6B009F; Sat,  3 Oct 2026 17:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3117C6B00A0; Sat,  3 Oct 2026 17:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0436A6B009E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79B79A0A0E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:01 +0000 (UTC)
X-FDA: 85282590162.12.C5190A8
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id B5F081C0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vC2xI20a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MnLBagYKCHkiofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3MnLBagYKCHkiofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGGPC1bwrTZZ3ZKXOiwd7CFyhuWlN9AcME08KbRuwUo=;
	b=sdQE/FIcZ6+nmGcnvesJGWKqGYnbldYtSeDGp5W/2vvg/ma5HdWUOk7AwuQMVT1Z5I34UB
	vXu1jOIYKtO+0ZfPoQF9VKGD0BCWf6wkb61V9vMya87+gkKTxMuth4qAAY+RImrXPwKG7I
	ubtUEDH1495QqlHGp6s36YFo/LSR4bA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vC2xI20a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MnLBagYKCHkiofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3MnLBagYKCHkiofwwldlldib.Zljifkru-jjhsXZh.lod@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062579;
	b=ayjpIcome16HvG+VE1djSql4NozrPSQUmNIO0d/Pp+40zRlkOoOwPaJ0g7c6ElwjYcxwby
	aMS3yPXfrbjPO+Nhkd7xvaSqLYtaxSDxk8Qs6h84U4EuNXUjE7oSzjkdHZjDsjmchEVKEL
	5Atsa+Q/rvVaIiz3v5kmagvL6lH800Q=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so13995045e9.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062578; x=1791667378; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sGGPC1bwrTZZ3ZKXOiwd7CFyhuWlN9AcME08KbRuwUo=;
        b=vC2xI20a+AOjmYf/MrYltkfF5Qd48JJQUhoivtZ9NQe+/CfLBo+y3sqAfOyR3AIYRg
         vpuifrIqUrW5NFS/GhUeilft3Kne2MYHoJGT7vmeL3o4lRpPBYM4/LKD/ll6bXaxxpeW
         Kv3SvuSVoiUQKqmQH8dPwH7XR3eyJ3LJxFS+jilbSaL7FSI63OcjdUhOsibHMuPv1krI
         ZW9zB7BY48T7XKZqjwwAUnwTzxJKSoelj6g/Atmy6rqotKLqL2I8pn4HIYOrEXSKVesA
         eXLeqBVA1nZt/pHWvvDpESxEzyMCmeVayK/N2dvL4I8Dg4SBeDLt9Atd13x0R10rMSs2
         dyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062578; x=1791667378;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sGGPC1bwrTZZ3ZKXOiwd7CFyhuWlN9AcME08KbRuwUo=;
        b=Aw6vEP87iWzKKKnBG/sVA+stidlgq+MjZZpCe6K2cjJj3noZjMJX5iqBUQDHCIFB6K
         0/2RZ495gS/xlZATjRX5hjMtXxIteyMSg0dOkw0FvJp/sEiTPzqQP6KiutWZQzjce7Xg
         t0pF73z5f6KjVbxnel6Bj7QoAUk75suPqn5wADAR9xiGknLpdyCmuhOVO4FTPiyG1Xxb
         Rtu/xXaT9uhvTaR7sw8hj7MXK0sYPiM7CR2BHSXYwqSDaqiavB+k8gDzWbqDYj8OKZ9+
         rRHAPYi693iVw7zfzp/AysRH4MkeE2uaf5gEOj7olYaOscDtQ7r+MCf/vKjift4lR5Xn
         6+RA==
X-Forwarded-Encrypted: i=1; AKwUvBxdSuYMJtTNSlOc0LjqVcELHscKOPbCoHst9CjQ1216q0QXRJEWOSzf+xSvN3gUbRx5wlLjdbAFDQ==@kvack.org
X-Gm-Message-State: AFuF++n8o5TnZQfg7BlJFM+xY5Zk6A34luwrf/vZB2YxbFKzhfi0WpBe
	Brcz/ZgHYRc90TQ48IboGgfiKwqoJIpmL/BRk7JZLE13m7JkoUG9jCTv+y83m8kOEerNQf1+zBz
	a/s0mcg==
X-Received: from wmpd34.prod.google.com ([2002:a05:600c:4c22:b0:49e:6b11:9532])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b04:b0:49f:c331:39e4
 with SMTP id 5b1f17b1804b1-4a1680e76c5mr48512125e9.7.1791062578150; Sat, 03
 Oct 2026 14:22:58 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:28 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-10-lrizzo@google.com>
Subject: [RFC: DMA_PMD 09/22] iommu/dma: Add DMA_PMD arena allocator
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
X-Rspam-User: 
X-Stat-Signature: aegyn3pcz9wybcrei8rxwb5st3nhuc6r
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5F081C0009
X-HE-Tag: 1791062579-729585
X-HE-Meta: U2FsdGVkX18tyokfiSoVVN0Qmb7HXphkqZDtQMAkxRTkZAYOtG3uqm9kuI816VA7TqSndWfaeDvg5784Yf68myDC0MxPg0dvudXy5sP0eEvSjpqObYce6T8jENSulyZeZXbQodNJ+MxaCW0wsFyqXzpIjJZIG9o2XvQzAVu7DfW+wgx2+TSDalRzMJPHLoarj3CVX7ChZ9jgoXAI+J9dkZ0gX6o/LhvJx8s/KsV3Zp6qXF0wUhXEeqB4uJl+1HAxqn4UFW04k7KxGvf5ls4rTkt52CSixJzsNkobKO35gz3MwTky+aXL4Lg6eEj1kBUk3sAeKDlIiW6ckI/rBPfHqtp3WnVMidlJorlW3kz4Hcx25OCmz9qmjeSxoEPb/4gMebgn8hM5ji/8U+MKhkgjkMZGzRO7XD8keo1CweBEnqhWzvbwlsdxb2fGGYazPwgE0VCI98m7vUs1eC6aoY2MW3JTa+Q8r+Xmr37qnUdTCb/IGWUVVlRA+cGDP6UV3c/9RMd1E3vpAdhvBiRfeijMXNa34p1z9RBsyGsIm43bWUO81ET38rAts83LlbDSHyDAOKGnTG6F1v1mFCnIm/DhqIWpgg0Iw2kArUJJ3VZeshc86hGJtFkOE5TIRueRMA8DWS8dQT2z04lXk7u3U3WhuVvaarP3sNgu8PZiDklcnUZiKhoESJpBoBjJxtoOO7RD0t4VAHYYb1B1gQjpm0iI3cIcGQCB4FJk5rdFF5v+t5gZfJhhoWpK9B59RzoDWVjaOR0CXBxGEsNVUITdifEbRDUmk/v9pLS0AN7LUeRiDPS645zHL5x7T+tBaxBqupuGrwOhnc42rHZ+GtfVI057C4L/9DoJ8PKPO+7MGpKzmFhNENW3/tvR1dkrxd0i32rMfsWytRi0ip3ybJQpboruyU0V5M4A0qkS6t2KbObenJEtgTh8kkAYHBSJ6NFaExCsl0/VQhM5tAq/TAGwwoR
 9/IngGu7
 +CLSSutLTZPKRreV0e7xnT6ogW5wB6xiY4ZueDOBKs0q9q5Kj3vil6ZkRVuZjYt5iw7xGOLWX1ZfVMgdUhkfpE71Z8jmV61jPxtfUvfJwWkZlPR7ugebBhTXpIKkQPRWw/TpzGyZ3bx0RPxxPqJ5Wp7xtz1beo7P/RSeicXEJlL9L83IlczIhz2FrP8W1Ss98sVRqyGJ3Tef7F8pQROEyMwwFmNU9uVxjg0RDlHVno5+Me3PCFnuTDQxcwwcHi/R9XZENd01yZYCfD2sUI/46ZQ+xRId4Qs4zZ9FIwGsTZyapzumNBNWOt1Im40dGeVwedCAJhyrLilNQ0+bFxk6dfoUXFQSnZ+ErMuU1N9UBPF2DJFBq0k17qZ9VcO2bQwD6aL0Rq6JBWUC/YMkt7qKRsb0gyZWwM0SMcCgz9x+b9F+uOGg9Cx1YfT1o/sFpt9MY8bV9sSUNtjbx8hlCdalFkO934CsY7R8sSymzoGjpRhE6L2XeKKKsk0hCADuqUyIbYSrDH6Vr1pI1pzrA6Kbf8oufavVG9aJzivqkFA/kUjIifidlQDwMh8Rxv4cOtVPyl5iq+u4JxdSBppQsBMGv/AnE5qLBct10YAhEYsIvyUmuTdzWdDQmkoAFkTCCY1Loj+wbwxymzqrzSZuHFrMPOhJOuc/y5imh6EXR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device driver use dma_alloc_attrs() for several long lived
device-accessible regions, such as queues and header buffers.

Add a compatible dma_pmd_arena allocator for DMA_PMD pages, which will be
later used by dma_alloc_attrs() for eligible allocations. Reserve a IOVA
region right after the one used to map physical ram, used specifically for
dma_pmd_arena allocations so they can be easily identifyed from their IOVA.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile        |   3 +-
 drivers/iommu/dma-pmd-arena.c | 385 ++++++++++++++++++++++++++++++++++
 drivers/iommu/dma-pmd-kunit.c |  35 ++++
 drivers/iommu/dma-pmd-map.c   |  19 +-
 drivers/iommu/dma-pmd-meta.c  |  61 ++++--
 drivers/iommu/dma-pmd-priv.h  |  41 +++-
 include/linux/dma-pmd.h       |   9 +
 7 files changed, 519 insertions(+), 34 deletions(-)
 create mode 100644 drivers/iommu/dma-pmd-arena.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index e701b36b9b605..e96fcf309a0b2 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,7 +11,8 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
-obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o dma-pmd-pool.o dma-pmd-map.o
+obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o dma-pmd-pool.o dma-pmd-map.o \
+			 dma-pmd-arena.o
 obj-$(CONFIG_DMA_PMD_META_KUNIT_TEST) += dma-pmd-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
diff --git a/drivers/iommu/dma-pmd-arena.c b/drivers/iommu/dma-pmd-arena.c
new file mode 100644
index 0000000000000..578df5be86a86
--- /dev/null
+++ b/drivers/iommu/dma-pmd-arena.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * DMA_PMD coherent arena allocator (ARENA_REGION).
+ *
+ * See Documentation/core-api/dma-pmd.rst for the architecture overview.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-pmd.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/iommu.h>
+#include <linux/mm.h>
+#include <linux/sched/mm.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+
+#include "dma-iommu.h"
+#include "dma-pmd-priv.h"
+/*
+ * dma_pmd_arena (ARENA_REGION allocator for coherent buffers)
+ * -----------------------------------------------------------
+ * Packs long-lived coherent DMA allocations into PMD physical pages mapped
+ * via PMD IOMMU leaf PTEs in the 16GB ARENA_REGION at the bottom of each
+ * domain's DMA_PMD IOVA window.
+ *
+ * - Allocation & Mapping (dma_pmd_arena_alloc / dma_pmd_dma_alloc):
+ *   Allocates a PAGE_SIZE-aligned, zeroed region of @size bytes in
+ *   ARENA_REGION, returning the CPU virtual address and storing the IOVA in
+ *   *@dma. Each PMD arena page is mapped into a single IOMMU domain and is
+ *   never shared across domains. Allocations <= 1MB first try partially used
+ *   PMD arena pages already mapped in the caller's domain before allocating a
+ *   fresh PMD page. Allocations > 1MB allocate contiguous empty PMD slots in
+ *   ARENA_REGION and vmap() them when spanning multiple PMD pages; if the
+ *   trailing PMD page has leftover 4KB blocks, it becomes available for
+ *   subsequent <= 1MB allocations in the same domain.
+ *
+ * - Unmapping & Release (dma_free_coherent / dma_pmd_free):
+ *   dma_pmd_free() checks whether @dma_handle falls in @dev's ARENA_REGION and,
+ *   if so, unreserves the 4KB blocks via dma_pmd_arena_free(). Once all 512 4KB
+ *   blocks of a PMD slot are free, its PMD PTE is unmapped from its domain and
+ *   the backing PMD page is returned to the buddy allocator.
+ */
+
+struct dma_pmd_arena {
+	spinlock_t lock;	/* protects bitmaps and arena metadata */
+	DECLARE_BITMAP(fully_empty, DMA_PMD_ARENA_PAGES);
+	DECLARE_BITMAP(partial_empty, DMA_PMD_ARENA_PAGES);
+};
+
+/* Currently one instance for all allocations */
+static struct dma_pmd_arena dma_pmd_arena __cacheline_aligned_in_smp = {
+	.lock = __SPIN_LOCK_UNLOCKED(dma_pmd_arena.lock),
+	.fully_empty = { [0 ... BITS_TO_LONGS(DMA_PMD_ARENA_PAGES) - 1] = ~0UL },
+};
+
+/* Provide a contiguous VA range for multi-page allocations */
+static void *dma_pmd_arena_vmap(unsigned int slot, unsigned int npages)
+{
+	unsigned int nr_subpages = npages * DMA_PMD_BLOCKS(0);
+	unsigned int subpages_per_2m = DMA_PMD_BLOCKS(0);
+	struct page *page, **pages;
+	unsigned int i, j;
+	void *va;
+
+	pages = kvmalloc_array(nr_subpages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	for (i = 0; i < npages; i++) {
+		page = dma_pmd_arena_meta(slot + i)->arena_page;
+		for (j = 0; j < subpages_per_2m; j++)
+			pages[i * subpages_per_2m + j] = page + j;
+	}
+
+	va = dma_common_pages_remap(pages, nr_subpages << PAGE_SHIFT,
+				    PAGE_KERNEL, __builtin_return_address(0));
+	if (!va)
+		kvfree(pages);
+	return va;
+}
+
+/* Provide a contiguous IOVA range for allocations */
+static int dma_pmd_arena_map_domain(struct device *dev, struct iommu_domain *domain,
+				    struct dma_pmd_window *win, struct dma_pmd_meta *m)
+{
+	unsigned int domain_idx;
+	unsigned long flags;
+	dma_addr_t iova;
+	int prot, ret;
+	u64 limit;
+
+	if (!domain)
+		return 0;
+
+	iova = win->base + dma_pmd_meta_win_offset(m);
+	limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+	if (iova + PMD_SIZE - 1 > limit)
+		return -ENOSPC;
+
+	domain_idx = win->domain_idx - DMA_PMD_IDX_FIRST;
+	if (test_bit(domain_idx, &m->domains_mapped))
+		return 0;
+
+	prot = dma_info_to_prot(DMA_BIDIRECTIONAL, true, 0);
+	spin_lock_irqsave(&m->map_lock, flags);
+	if (test_bit(domain_idx, &m->domains_mapped)) {
+		ret = 0;
+	} else if (unlikely(!dma_pmd_domain_active(domain_idx, domain))) {
+		ret = -ENODEV;
+	} else {
+		ret = iommu_map(domain, iova, page_to_phys(m->arena_page),
+				PMD_SIZE, prot, GFP_ATOMIC);
+		if (!ret) {
+			/* Ensure the leaf PTE is visible before setting the bit. */
+			smp_mb__before_atomic();
+			set_bit(domain_idx, &m->domains_mapped);
+		}
+	}
+	spin_unlock_irqrestore(&m->map_lock, flags);
+	return ret;
+}
+
+/**
+ * dma_pmd_arena_free - Unreserve blocks in an ARENA_REGION allocation
+ * @dev: Device passed to dma_free_coherent()
+ * @size: Size of the allocation being freed
+ * @cpu_addr: CPU virtual address passed to dma_free_coherent()
+ * @dma: DMA address passed to dma_free_coherent()
+ *
+ * Return: true if @dma belonged to ARENA_REGION and was freed.
+ */
+bool dma_pmd_arena_free(struct device *dev, size_t size, void *cpu_addr, dma_addr_t dma)
+{
+	unsigned int slot, off, nblocks, bpp = DMA_PMD_BLOCKS(0);
+	struct iommu_domain *domain;
+	struct dma_pmd_window *win;
+	dma_addr_t arena_base;
+	unsigned long flags;
+
+	if (!dev || !cpu_addr)
+		return false;
+
+	if (!dma_pmd_meta_base())
+		return false;
+
+	if (dev->iommu_group) {
+		domain = iommu_get_dma_domain(dev);
+		win = domain ? dma_pmd_dma_window(domain) : NULL;
+		/* Pairs with smp_store_release() in dma_pmd_window_assign(). */
+		if (!win || !smp_load_acquire(&win->size))
+			return false;
+		arena_base = win->base;
+	} else if (IS_ENABLED(CONFIG_DMA_PMD_META_KUNIT_TEST)) {
+		/* Reachable only from KUnit tests with a dummy device. */
+		arena_base = 0;
+	} else {
+		return false;
+	}
+
+	if (dma < arena_base || dma - arena_base >= ARENA_REGION_SIZE)
+		return false;
+
+	if (is_vmalloc_addr(cpu_addr)) {
+		kvfree(dma_common_find_pages(cpu_addr));
+		dma_common_free_remap(cpu_addr, size);
+	}
+
+	slot = (dma - arena_base) >> PMD_SHIFT;
+	off = ((dma - arena_base) & (PMD_SIZE - 1)) >> PAGE_SHIFT;
+	nblocks = ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	while (nblocks > 0 && slot < DMA_PMD_ARENA_PAGES) {
+		struct dma_pmd_meta *m = dma_pmd_arena_meta(slot);
+		unsigned int n = min(nblocks, bpp - off);
+		struct page *free_page = NULL;
+
+		spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+		if (!WARN_ON_ONCE(!m->arena_page)) {
+			bitmap_clear(m->free_bitmap, off, n);
+			m->nr_free += n;
+			if (m->nr_free == bpp) {
+				free_page = m->arena_page;
+				m->arena_page = NULL;
+				m->nr_free = 0;
+				__clear_bit(slot, dma_pmd_arena.partial_empty);
+			} else {
+				__set_bit(slot, dma_pmd_arena.partial_empty);
+			}
+		}
+		spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+
+		if (free_page) {
+			dma_pmd_unmap_all(m);
+			__free_pages(free_page, PMD_ORDER);
+			spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+			__set_bit(slot, dma_pmd_arena.fully_empty);
+			spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+		}
+
+		nblocks -= n;
+		off = 0;
+		slot++;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(dma_pmd_arena_free);
+
+/**
+ * dma_pmd_arena_alloc - Carve a DMA-mapped buffer out of ARENA_REGION
+ * @dev: Device the buffer is allocated and mapped for
+ * @size: Requested size, rounded up to 4KB
+ * @dma: Out parameter, DMA address of the returned buffer in ARENA_REGION
+ * @node: Preferred NUMA node, or NUMA_NO_NODE for the device's own node
+ *
+ * Locking: Acquires @dma_pmd_arena.lock (irqsave) when searching or updating
+ *          slot bitmaps.
+ *
+ * Return: Kernel virtual address of the zeroed buffer, or NULL if the caller
+ *         should fall back to its own allocation (e.g. dma_alloc_coherent()).
+ */
+void *dma_pmd_arena_alloc(struct device *dev, size_t size, dma_addr_t *dma, int node)
+{
+	unsigned int npages, nblocks, slot, i, bpp = DMA_PMD_BLOCKS(0);
+	unsigned long *bitmap = dma_pmd_arena.fully_empty;
+	struct iommu_domain *domain;
+	struct dma_pmd_window *win;
+	dma_addr_t arena_base;
+	unsigned long flags;
+	void *va;
+
+	if (!dev || (!dev->iommu_group && !IS_ENABLED(CONFIG_DMA_PMD_META_KUNIT_TEST)))
+		return NULL;
+
+	if (node == NUMA_NO_NODE)
+		node = dev_to_node(dev);
+
+	size = ALIGN(size, PAGE_SIZE);
+	if (!size || size > ARENA_REGION_SIZE)
+		return NULL;
+
+	domain = dev->iommu_group ? iommu_get_dma_domain(dev) : NULL;
+	win = domain ? dma_pmd_dma_window(domain) : NULL;
+	if (dev->iommu_group && (!win || !(domain->pgsize_bitmap & PMD_SIZE)))
+		goto err_fallback;
+
+	if (unlikely(dma_pmd_meta_init()))
+		goto err_fallback;
+
+	/* Pairs with smp_store_release() in dma_pmd_window_assign(). */
+	if (win && !smp_load_acquire(&win->size) &&
+	    (READ_ONCE(win->domain_idx) != DMA_PMD_IDX_NONE ||
+	     dma_pmd_window_assign(dev, domain, win)))
+		goto err_fallback;
+
+	arena_base = win ? win->base : 0;
+	nblocks = size >> PAGE_SHIFT;
+
+	/*
+	 * Allocations <= 1MB first try partially empty pages already mapped in
+	 * @domain (arena PMD pages are single-domain and never shared across
+	 * IOMMU domains).
+	 */
+	if (size <= SZ_1M) {
+		unsigned long domain_mask = win ? BIT(win->domain_idx - DMA_PMD_IDX_FIRST) : 0;
+		u64 limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+
+		spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+		for_each_set_bit(slot, dma_pmd_arena.partial_empty, DMA_PMD_ARENA_PAGES) {
+			struct dma_pmd_meta *m = dma_pmd_arena_meta(slot);
+			unsigned long off;
+
+			if (READ_ONCE(m->domains_mapped) != domain_mask ||
+			    (domain &&
+			     arena_base + ((dma_addr_t)(slot + 1) << PMD_SHIFT) - 1 > limit))
+				continue;
+			if (m->nr_free < nblocks)
+				continue;
+
+			off = bitmap_find_next_zero_area(m->free_bitmap, bpp, 0, nblocks,
+							 (1UL << get_order(size)) - 1);
+			if (off >= bpp)
+				continue;
+
+			bitmap_set(m->free_bitmap, off, nblocks);
+			m->nr_free -= nblocks;
+			if (m->nr_free == 0)
+				__clear_bit(slot, dma_pmd_arena.partial_empty);
+			va = page_address(m->arena_page) + (off << PAGE_SHIFT);
+			*dma = arena_base + ((dma_addr_t)slot << PMD_SHIFT) +
+			       (off << PAGE_SHIFT);
+			spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+
+			memset(va, 0, size);
+			return va;
+		}
+		spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+	}
+
+	/*
+	 * Allocations > 1MB (or <= 1MB when no partial page fits) look for
+	 * @npages contiguous fully empty pages.
+	 */
+	npages = DIV_ROUND_UP(size, PMD_SIZE);
+	spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+	slot = 0;
+	while (slot + npages <= DMA_PMD_ARENA_PAGES) {
+		unsigned int next_zero;
+
+		slot = find_next_bit(bitmap, DMA_PMD_ARENA_PAGES, slot);
+		if (slot + npages > DMA_PMD_ARENA_PAGES)
+			break;
+		next_zero = find_next_zero_bit(bitmap, slot + npages, slot);
+		if (next_zero >= slot + npages) {
+			bitmap_clear(bitmap, slot, npages);
+			break;
+		}
+		slot = next_zero + 1;
+	}
+	spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+
+	if (slot + npages > DMA_PMD_ARENA_PAGES)
+		goto err_fallback;
+
+	for (i = 0; i < npages; i++) {
+		struct dma_pmd_meta *m = dma_pmd_arena_meta(slot + i);
+		gfp_t gfp = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
+		struct page *page;
+
+		page = (node == NUMA_NO_NODE) ? alloc_pages(gfp, PMD_ORDER) :
+			alloc_pages_node(node, gfp, PMD_ORDER);
+		if (!page)
+			goto err_free_pages;
+
+		m->arena_page = page;
+		if (dma_pmd_arena_map_domain(dev, domain, win, m)) {
+			m->arena_page = NULL;
+			__free_pages(page, PMD_ORDER);
+			goto err_free_pages;
+		}
+	}
+
+	va = (npages == 1) ? page_address(dma_pmd_arena_meta(slot)->arena_page) :
+			     dma_pmd_arena_vmap(slot, npages);
+	if (!va)
+		goto err_free_pages;
+
+	spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+	for (i = 0; i < npages; i++) {
+		struct dma_pmd_meta *m = dma_pmd_arena_meta(slot + i);
+		unsigned int n = min(nblocks - i * bpp, bpp);
+
+		bitmap_zero(m->free_bitmap, bpp);
+		bitmap_set(m->free_bitmap, 0, n);
+		m->nr_free = bpp - n;
+		if (m->nr_free > 0)
+			__set_bit(slot + i, dma_pmd_arena.partial_empty);
+	}
+	spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+
+	*dma = arena_base + ((dma_addr_t)slot << PMD_SHIFT);
+	return va;
+
+err_free_pages:
+	while (i--) {
+		struct dma_pmd_meta *m = dma_pmd_arena_meta(slot + i);
+		struct page *page = m->arena_page;
+
+		m->arena_page = NULL;
+		dma_pmd_unmap_all(m);
+		__free_pages(page, PMD_ORDER);
+	}
+	spin_lock_irqsave(&dma_pmd_arena.lock, flags);
+	bitmap_set(bitmap, slot, npages);
+	spin_unlock_irqrestore(&dma_pmd_arena.lock, flags);
+err_fallback:
+	return NULL;
+}
+EXPORT_SYMBOL(dma_pmd_arena_alloc);
diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index 7f4251845ba49..b91dbcb468879 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -166,12 +166,47 @@ static void test_window_helpers(struct kunit *test)
 	dma_pmd_pool_destroy(pool);
 }
 
+static void test_arena_alloc_and_free(struct kunit *test)
+{
+	struct device dev = { .numa_node = NUMA_NO_NODE };
+	void *v1, *v2, *v3, *vl1;
+	dma_addr_t d1, d2, d3, dl1;
+
+	KUNIT_EXPECT_NULL(test,
+			  dma_pmd_arena_alloc(NULL, SZ_4K, &d1, NUMA_NO_NODE));
+
+	v1 = dma_pmd_arena_alloc(&dev, SZ_64K, &d1, NUMA_NO_NODE);
+	KUNIT_ASSERT_NOT_NULL(test, v1);
+	v2 = dma_pmd_arena_alloc(&dev, SZ_64K, &d2, NUMA_NO_NODE);
+	KUNIT_ASSERT_NOT_NULL(test, v2);
+	KUNIT_EXPECT_PTR_EQ(test, v2, v1 + SZ_64K);
+	KUNIT_EXPECT_EQ(test, d2, d1 + SZ_64K);
+
+	/* Freeing v1 unreserves [0, 64K); next 64K alloc reuses it. */
+	KUNIT_EXPECT_TRUE(test, dma_pmd_arena_free(&dev, SZ_64K, v1, d1));
+	v3 = dma_pmd_arena_alloc(&dev, SZ_64K, &d3, NUMA_NO_NODE);
+	KUNIT_EXPECT_PTR_EQ(test, v3, v1);
+	KUNIT_EXPECT_EQ(test, d3, d1);
+
+	/*
+	 * Allocate 3MB (spans 2 contiguous fully_empty slots in ARENA_REGION);
+	 * the trailing 1MB in the second slot is marked partial_empty and can
+	 * satisfy a <= 1MB allocation before both are freed.
+	 */
+	vl1 = dma_pmd_arena_alloc(&dev, SZ_2M + SZ_1M, &dl1, NUMA_NO_NODE);
+	KUNIT_ASSERT_NOT_NULL(test, vl1);
+	KUNIT_EXPECT_TRUE(test, dma_pmd_arena_free(&dev, SZ_2M + SZ_1M, vl1, dl1));
+	KUNIT_EXPECT_TRUE(test, dma_pmd_arena_free(&dev, SZ_64K, v2, d2));
+	KUNIT_EXPECT_TRUE(test, dma_pmd_arena_free(&dev, SZ_64K, v3, d3));
+}
+
 static struct kunit_case dma_pmd_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_pooled_toggle),
 	KUNIT_CASE(test_pool_alloc_and_recycle),
 	KUNIT_CASE(test_window_helpers),
+	KUNIT_CASE(test_arena_alloc_and_free),
 	{}
 };
 
diff --git a/drivers/iommu/dma-pmd-map.c b/drivers/iommu/dma-pmd-map.c
index 565e10dd1a2e8..1147874ac8068 100644
--- a/drivers/iommu/dma-pmd-map.c
+++ b/drivers/iommu/dma-pmd-map.c
@@ -51,6 +51,11 @@ static DEFINE_SPINLOCK(dma_pmd_domains_lock);
  */
 DEFINE_SRCU(dma_pmd_srcu);
 
+bool dma_pmd_domain_active(unsigned int idx, const struct iommu_domain *domain)
+{
+	return READ_ONCE(dma_pmd_domains[idx].domain) == domain;
+}
+
 /**
  * dma_pmd_unmap_all - Remove a PMD page's PTE from every domain holding it
  * @meta: PMD page metadata structure
@@ -77,7 +82,7 @@ DEFINE_SRCU(dma_pmd_srcu);
  */
 void dma_pmd_unmap_all(struct dma_pmd_meta *meta)
 {
-	phys_addr_t phys = dma_pmd_meta_to_phys(meta);
+	dma_addr_t offset = dma_pmd_meta_win_offset(meta);
 	unsigned long mapped, flags;
 	int idx, srcu_idx;
 
@@ -104,7 +109,7 @@ void dma_pmd_unmap_all(struct dma_pmd_meta *meta)
 		if (!domain)
 			continue;
 
-		iommu_unmap(domain, base + phys, PMD_SIZE);
+		iommu_unmap(domain, base + offset, PMD_SIZE);
 	}
 	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
 }
@@ -170,6 +175,7 @@ void dma_pmd_domain_release(struct iommu_domain *domain)
 {
 	unsigned int dropped = 0;
 	unsigned long flags;
+	unsigned int i;
 	int idx;
 
 	/* Nothing has ever been pooled, so nothing can reference @domain. */
@@ -199,6 +205,9 @@ void dma_pmd_domain_release(struct iommu_domain *domain)
 
 	dropped += dma_pmd_pools_forget_domain(idx);
 
+	for (i = 0; i < DMA_PMD_ARENA_PAGES; i++)
+		dropped += dma_pmd_forget_domain(dma_pmd_arena_meta(i), idx);
+
 	/*
 	 * Any PMD page removed from a pool list before the walk above is either
 	 * already on @dma_pmd_free_list (placed there under @pool->lock in
@@ -225,7 +234,7 @@ void dma_pmd_domain_release(struct iommu_domain *domain)
  * dma_pmd_dma_window_alloc - Allocate an IOVA window for DMA_PMD mappings
  * @dev: Device whose addressing limits the window must respect
  * @domain: Domain to take the window from
- * @size: Window size in bytes
+ * @sizep: In/out window size in bytes
  *
  * Allocates a contiguous IOVA range out of @domain's iova_domain on first use,
  * aligned to PMD_SIZE matching the mapping. Callers on the map path still
@@ -237,9 +246,9 @@ void dma_pmd_domain_release(struct iommu_domain *domain)
 static dma_addr_t dma_pmd_dma_window_alloc(struct device *dev,
 					   struct iommu_domain *domain, u64 *sizep)
 {
+	u64 min_size = ARENA_REGION_SIZE + ALIGN(PFN_PHYS(max_pfn), PMD_SIZE);
 	u64 limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
 	struct iova_domain *iovad = dma_pmd_dma_iovad(domain);
-	u64 min_size = ALIGN(PFN_PHYS(max_pfn), PMD_SIZE);
 	unsigned long shift, iova_len;
 	struct iova *new_iova;
 
@@ -295,7 +304,7 @@ static dma_addr_t dma_pmd_dma_window_alloc(struct device *dev,
 int dma_pmd_window_assign(struct device *dev, struct iommu_domain *domain,
 			  struct dma_pmd_window *win)
 {
-	u64 size = ALIGN(PFN_PHYS(dma_pmd_top_pfn()), PMD_SIZE);
+	u64 size = ALIGN(PFN_PHYS(dma_pmd_top_pfn()), PMD_SIZE) + ARENA_REGION_SIZE;
 	unsigned long flags;
 	int idx, ret = 0;
 	dma_addr_t base;
diff --git a/drivers/iommu/dma-pmd-meta.c b/drivers/iommu/dma-pmd-meta.c
index 27b8c2568c749..8f2bc7d77e5bd 100644
--- a/drivers/iommu/dma-pmd-meta.c
+++ b/drivers/iommu/dma-pmd-meta.c
@@ -186,8 +186,9 @@ static inline bool dma_pmd_pfn_online(unsigned long pfn)
  *
  * Return: 0, or -ENOMEM with the range partially backed.
  */
-static int dma_pmd_meta_populate(struct dma_pmd_meta *array, unsigned long nframes,
-				 unsigned long start_pfn, unsigned long end_pfn, bool force)
+static int dma_pmd_meta_populate(struct dma_pmd_meta *array, unsigned long *bitmap,
+				 unsigned long nframes, unsigned long start_pfn,
+				 unsigned long end_pfn, bool force)
 {
 	unsigned long chunk, last, pfn;
 
@@ -208,7 +209,8 @@ static int dma_pmd_meta_populate(struct dma_pmd_meta *array, unsigned long nfram
 
 		addr = (unsigned long)array + (chunk << PAGE_SHIFT);
 		if (vmalloc_to_page((void *)addr)) {
-			set_bit(chunk, dma_pmd_chunk_bitmap);
+			if (bitmap)
+				set_bit(chunk, bitmap);
 			continue;		/* already backed */
 		}
 
@@ -247,14 +249,17 @@ static int dma_pmd_meta_populate(struct dma_pmd_meta *array, unsigned long nfram
 			 * never leak the page it declined to consume.
 			 */
 			__free_page(page);
-			set_bit(chunk, dma_pmd_chunk_bitmap);
+			if (bitmap)
+				set_bit(chunk, bitmap);
 			continue;
 		}
 
 		flush_cache_vmap(addr, addr + PAGE_SIZE);
-		/* Pair with test_bit_acquire() in readers. */
-		smp_mb__before_atomic();
-		set_bit(chunk, dma_pmd_chunk_bitmap);
+		if (bitmap) {
+			/* Pair with test_bit_acquire() in readers. */
+			smp_mb__before_atomic();
+			set_bit(chunk, bitmap);
+		}
 		dma_pmd_meta_pages++;
 	}
 
@@ -273,8 +278,9 @@ bool dma_pmd_meta_ensure_pfn(unsigned long pfn, bool can_block)
 		return false;
 
 	mutex_lock(&dma_pmd_meta_mutex);
-	ret = dma_pmd_meta_populate(dma_pmd_meta_base(), dma_pmd_meta_nframes,
-				    pfn, pfn + (1UL << PMD_ORDER), true);
+	ret = dma_pmd_meta_populate(dma_pmd_meta_base(), dma_pmd_chunk_bitmap,
+				    dma_pmd_meta_nframes, pfn,
+				    pfn + (1UL << PMD_ORDER), true);
 	mutex_unlock(&dma_pmd_meta_mutex);
 
 	return !ret;
@@ -284,18 +290,20 @@ EXPORT_SYMBOL(dma_pmd_meta_ensure_pfn);
 /**
  * dma_pmd_meta_init - Reserve and populate the sparse per-PMD metadata array
  *
- * Populates all present RAM pages before publishing @dma_pmd_meta_array so
- * no concurrent reader ever sees an unmapped entry.
+ * Populates all present RAM pages and ARENA_REGION entries before publishing
+ * @dma_pmd_meta_array so no concurrent reader ever sees an unmapped entry.
  *
  * Return: 0 on success, or negative errno on failure.
  */
 int dma_pmd_meta_init(void)
 {
-	unsigned long nframes, nchunks, size;
-	struct dma_pmd_meta *array;
+	unsigned long nframes, total_frames, nchunks, size, i;
+	struct dma_pmd_meta *raw, *array;
 	struct vm_struct *vm;
 	int ret = 0;
 
+	static_assert(IS_ALIGNED(DMA_PMD_ARENA_PAGES << DMA_PMD_META_SHIFT, PAGE_SIZE));
+
 	if (likely(dma_pmd_meta_base()))
 		return 0;
 
@@ -308,8 +316,9 @@ int dma_pmd_meta_init(void)
 				    (unsigned long)min_t(u64, iomem_resource.end >> PAGE_SHIFT,
 							 1ULL << (MAX_PHYSMEM_BITS - PAGE_SHIFT))),
 			       1UL << PMD_ORDER);
-	size = PAGE_ALIGN(nframes << DMA_PMD_META_SHIFT);
-	nchunks = size >> PAGE_SHIFT;
+	total_frames = DMA_PMD_ARENA_PAGES + nframes;
+	size = PAGE_ALIGN(total_frames << DMA_PMD_META_SHIFT);
+	nchunks = PAGE_ALIGN(nframes << DMA_PMD_META_SHIFT) >> PAGE_SHIFT;
 
 	dma_pmd_chunk_bitmap = bitmap_zalloc(nchunks, GFP_KERNEL);
 	if (!dma_pmd_chunk_bitmap) {
@@ -324,14 +333,25 @@ int dma_pmd_meta_init(void)
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	array = vm->addr;
-
-	ret = dma_pmd_meta_populate(array, nframes, 0, max_pfn, false);
+	raw = vm->addr;
+	array = raw + DMA_PMD_ARENA_PAGES;
+
+	ret = dma_pmd_meta_populate(raw, NULL, DMA_PMD_ARENA_PAGES,
+				    0, DMA_PMD_ARENA_PAGES << PMD_ORDER, true);
+	if (!ret)
+		ret = dma_pmd_meta_populate(array, dma_pmd_chunk_bitmap,
+					    nframes, 0, max_pfn, false);
 	if (ret) {
+		unsigned long off, chunk;
 		struct page *p, *next;
-		unsigned long chunk;
 		LIST_HEAD(pages);
 
+		for (off = 0; off < (DMA_PMD_ARENA_PAGES << DMA_PMD_META_SHIFT);
+		     off += PAGE_SIZE) {
+			p = vmalloc_to_page((void *)raw + off);
+			if (p)
+				list_add(&p->lru, &pages);
+		}
 		for_each_set_bit(chunk, dma_pmd_chunk_bitmap, nchunks) {
 			p = vmalloc_to_page((void *)array + (chunk << PAGE_SHIFT));
 			if (p)
@@ -348,6 +368,9 @@ int dma_pmd_meta_init(void)
 		goto out_unlock;
 	}
 
+	for (i = 0; i < DMA_PMD_ARENA_PAGES; i++)
+		spin_lock_init(&raw[i].map_lock);
+
 	/*
 	 * Publish @nframes and the populated pages before the array pointer:
 	 * readers pair with smp_load_acquire(&dma_pmd_meta_array).
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 355f865f44057..b411ecb1fdafc 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -16,8 +16,9 @@ struct iommu_domain;
 
 /**
  * struct dma_pmd_window - A domain's IOVA window reserved for DMA_PMD pages
- * @base: First IOVA of the window. A page at @phys is mapped, in every domain
- *        that has a window, at @base + @phys.
+ * @base: First IOVA of the window. The leading ARENA_REGION_SIZE bytes
+ *        [base, base + ARENA_REGION_SIZE) form ARENA_REGION; a pooled RAM
+ *        page at @phys is mapped at @base + ARENA_REGION_SIZE + @phys.
  * @size: Window size in bytes, or 0 if this domain has no window, either
  *        because nothing has pooled through it yet, or because it could not
  *        find a free range that large. 0 must make both the map and the unmap
@@ -40,6 +41,8 @@ struct dma_pmd_window {
 #ifdef CONFIG_DMA_PMD
 
 #define DMA_PMD_BLOCKS(order)		(1U << (PMD_ORDER - (order)))
+#define DMA_PMD_ARENA_PAGES		8192U
+#define ARENA_REGION_SIZE		((u64)DMA_PMD_ARENA_PAGES * PMD_SIZE)
 
 /*
  * Number of IOMMU domains that may use DMA_PMD at once.
@@ -116,8 +119,9 @@ enum {
  * @domains_mapped: One bit per domain index: set once this PMD page's leaf
  *		PTE is installed in that domain.
  *
- * Alloc/free fast path, all under pool->lock:
+ * Alloc/free fast path, all under pool->lock (or dma_pmd_arena.lock):
  * @pool:	Owning dma_pmd_pool (holds a kref on the pool while pooled)
+ * @arena_page:	Allocated 2MB struct page for an ARENA_REGION entry
  * @list:	Node in pool->partial, pool->idle or pool->full
  *
  * Slow path only (disjoint lifetimes):
@@ -125,11 +129,13 @@ enum {
  * @rcu:	RCU head used to defer buddy release past lockless readers
  *
  * @free_bitmap: Bitmap of zeroed available block indices (up to 1 << PMD_ORDER)
- * @dirty_bitmap: Bitmap of dirty available block indices
+ *		 for pools, or allocated 4KB blocks for ARENA_REGION entries
+ * @dirty_bitmap: Bitmap of dirty available block indices for pools
  *
  * Lives in the sparse per-PMD-frame array @dma_pmd_meta_array indexed by
- * (pfn >> PMD_ORDER). Only chunks covering valid RAM are backed by physical
- * pages (128 KB per GB of RAM).
+ * (pfn >> PMD_ORDER), preceded by DMA_PMD_ARENA_PAGES entries for
+ * ARENA_REGION. Only chunks covering valid RAM and ARENA_REGION are backed by
+ * physical pages (128 KB per GB of RAM).
  */
 struct dma_pmd_meta {
 	bool pooled;
@@ -139,7 +145,10 @@ struct dma_pmd_meta {
 
 	unsigned long domains_mapped;
 
-	struct dma_pmd_pool *pool;
+	union {
+		struct dma_pmd_pool *pool;
+		struct page *arena_page;
+	};
 	struct list_head list;
 
 	union {
@@ -224,18 +233,29 @@ static inline struct dma_pmd_meta *dma_pmd_meta_base(void)
 
 /*
  * Highest PFN covered by the allocated @dma_pmd_meta_array reservation.
- * Every domain's IOVA window is sized to match this bound.
+ * Every domain's IOVA window is sized up to this bound.
  */
 static inline unsigned long dma_pmd_top_pfn(void)
 {
 	return dma_pmd_meta_nframes << PMD_ORDER;
 }
 
+static inline struct dma_pmd_meta *dma_pmd_arena_meta(unsigned int slot)
+{
+	return (dma_pmd_meta_base() - DMA_PMD_ARENA_PAGES) + slot;
+}
+
 /* IOVA of @phys in @win. Only valid once the PMD page's PTE is installed. */
 static inline dma_addr_t dma_pmd_window_iova(const struct dma_pmd_window *win,
 					     phys_addr_t phys)
 {
-	return win->base + phys;
+	return win->base + ARENA_REGION_SIZE + phys;
+}
+
+/* Offset of @m (either arena or RAM) from the start of a domain's window. */
+static inline dma_addr_t dma_pmd_meta_win_offset(const struct dma_pmd_meta *m)
+{
+	return (dma_addr_t)(m - dma_pmd_arena_meta(0)) << PMD_SHIFT;
 }
 
 int dma_pmd_meta_init(void);
@@ -250,6 +270,7 @@ void dma_pmd_unmap_all(struct dma_pmd_meta *meta);
 unsigned int dma_pmd_forget_domain(struct dma_pmd_meta *meta, int idx);
 int dma_pmd_window_assign(struct device *dev, struct iommu_domain *domain,
 			  struct dma_pmd_window *win);
+bool dma_pmd_domain_active(unsigned int idx, const struct iommu_domain *domain);
 
 static inline bool dma_is_pmd_phys(phys_addr_t phys)
 {
@@ -281,6 +302,8 @@ dma_addr_t dma_pmd_dma_map_phys(struct device *dev, struct iommu_domain *domain,
 
 void dma_pmd_domain_release(struct iommu_domain *domain);
 
+void *dma_pmd_arena_alloc(struct device *dev, size_t size, dma_addr_t *dma, int node);
+
 #else /* !CONFIG_DMA_PMD */
 
 static inline bool dma_is_pmd_phys(phys_addr_t phys)
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
index 085d9a730c278..55c770fe232b0 100644
--- a/include/linux/dma-pmd.h
+++ b/include/linux/dma-pmd.h
@@ -95,6 +95,9 @@ static inline struct page *dma_pmd_pool_alloc(struct dma_pmd_pool *pool, gfp_t g
 }
 bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool);
 
+/* Hooks for kernel/dma/mapping.c */
+bool dma_pmd_arena_free(struct device *dev, size_t size, void *cpu_addr, dma_addr_t dma);
+
 #else /* !CONFIG_DMA_PMD */
 
 static inline bool dma_is_pmd_page(unsigned long pfn)
@@ -141,5 +144,11 @@ static inline bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool)
 	return false;
 }
 
+static inline bool dma_pmd_arena_free(struct device *dev, size_t size,
+				      void *cpu_addr, dma_addr_t dma)
+{
+	return false;
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _LINUX_DMA_PMD_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


