Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4122CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8D66B0092; Sat,  3 Oct 2026 17:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581A46B0093; Sat,  3 Oct 2026 17:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4497A6B0095; Sat,  3 Oct 2026 17:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0758D6B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 747D8C0A14
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:52 +0000 (UTC)
X-FDA: 85282589784.22.806E57F
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADCB01C0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDZjZnX6;
	spf=pass (imf20.hostedemail.com: domain of 3KHLBagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3KHLBagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl5oLGui9d01xKPfSkAYkXMsMEaO4XUa6GnMZGmlpEY=;
	b=rfvi/kUVfTAab86oyNOWTOWo7YNtmyimi1CdxF5cdd/aPuPd4j1f0UdkyQc4osZ66bGmKJ
	KFTWiXi9RNppWOPtxyEDxFP5N7lFx8xqxGVOz6sK3gr2wHMqHi9RQz2UQy/aWsv7CMWxGR
	hY8ye3RKjRTRyvXbK+zQRT8MQWGVqhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDZjZnX6;
	spf=pass (imf20.hostedemail.com: domain of 3KHLBagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3KHLBagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062570;
	b=DHsbk8YlDSU812vVDkZ9q8p3CV62HF57l+Ez6/OUugxnMGMuqlhHnfWSOSCTxYJvRcKcd3
	RU/w5v3zxzzBDn7zuCXK2fEFy38keqix7lT/ApqhFfvC1UrSSTg5yChko0oM0ySD8g+UCN
	XGYe84dQ2locJA5BOa3EzSoMizRTQfg=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2e48dc5363so98842866b.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062569; x=1791667369; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fl5oLGui9d01xKPfSkAYkXMsMEaO4XUa6GnMZGmlpEY=;
        b=eDZjZnX6A7cFvqJMS7RqLUX+vIjOfAo8HlmCnxJmx2trI0YnXCefwJLCF74Sr5mI2t
         4vCpB3OY0n6/vT03uxx/Ep9m5JcSkvqVUQApR9ynYj8cQ9XrUoWOWvNioE8qU3R9kX32
         WnaIPQADiM7mp7PRSdbDyqUhEwRlj5GVdGbELMZPqX7KNMDcj+qa4Bj9Egdx6D1HXcu/
         lkhmO7giciR3nwq+Ywp7EaeiL/SVaDODdYIkjwfzYgZTvt8TuTPH8sVh4ivVun8v4OzD
         8+CckJLGyJxl+5ppjFs/dROveGPQGRqBQ9nQpztacgEn/I+W239QBCypTYbrgmCU54m5
         F10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062569; x=1791667369;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fl5oLGui9d01xKPfSkAYkXMsMEaO4XUa6GnMZGmlpEY=;
        b=d6c2VjJOVadTFM7G6JuaThOO6ZgwbDnRQDK7zf3Fm+Vwi07aXz5tg/nYlmvlTXF54v
         o3Rk5DW9q5HHdjzLO9Gg/MXGCnH5sRGU3LCORJ6xtFqlSzA52kxfcIqhRuwuX07qSX/p
         dH595GfQPWK7rlmR0XcQcD/FLwfFdttuZdpTdTP4XdjVZ1H0Q1EwM7OwcbkiEDf6lBba
         +xX6bMjGYBIHmudImu9Td69RW0Is2suX8oQ++jbfjIl3up9h9G6hto+bsk7mbwJ8U+II
         bh80Z1KkB7kGNXH86WRU7yd1zaJq/GS7HXFztSPIYDCE2GZNOtoIjBI6YsCCgN27c8AT
         Q0Kw==
X-Forwarded-Encrypted: i=1; AKwUvBwTQiiTFZQVirZ0FRaQR30W+Ylz5VT+mop2Q9Vx+oTSdD+RS9Z0Ht2Uft21gBIKB0rAg4cCFjJEzg==@kvack.org
X-Gm-Message-State: AFuF++nHsEhs34XInPq+rXQVfbvWnhojCjna/HBx9Q721X7PEKjIEIvR
	99Y5QPUT32MbBhN2eJPUujK8h0tcJY+A6fp587hU4lpXXENYYaNRvBg4Y4W7r4qWaFfdwXlSQbc
	dCp4few==
X-Received: from ejbhk12.prod.google.com ([2002:a17:906:c9cc:b0:c2e:27b8:8572])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:e102:b0:c2e:7daa:2399
 with SMTP id a640c23a62f3a-c2e7daa4002mr69702066b.42.1791062568434; Sat, 03
 Oct 2026 14:22:48 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:21 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-3-lrizzo@google.com>
Subject: [RFC: DMA_PMD 02/22] iommu/dma: add DMA_PMD pool lifecycle and page
 recycle hook
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
X-Rspamd-Queue-Id: ADCB01C0004
X-Rspam-User: 
X-Stat-Signature: d7fybj3fu9py6q4ccoqmmw3sa6hh3r4z
X-HE-Tag: 1791062570-515780
X-HE-Meta: U2FsdGVkX182XFwTJiAoxo0baNw/5cEnrbs8abALrf4Ud3KSWXPp82RG0V/Xzb4ogklVaUexHyui/Sp3mQb2uabDU7f0XyRWVy1c0wbEjhS6fDcN1790pbY8Tcn52XfYaOe1p/zTIC6WSeEnQXF9909wjf9cdyrc3cI0VV+xeC1sljn0VnRv5BlaX4FR8re1ExfjaL4T6jRPaUir/R2nOdWCu8ThEZpQkBjuccYZFe7IgzffC5DPLNam2rpfuJnRgQlVTBgvFCsu/vZNO+gh+1q8/mWfXlzxVrwFbufh/D1nfCcA0Rqr0nIflc+FMpJWUkp6XtbbsFhrD3JtE4VDfQNPjkj7YQ303t7mfR4R5VB7zlS6XsLjUVcQGgv8lcuilI8/EN+uXtOdsUAytz2XOKHCslnyYake4JlYoyIjTpLsHT1eIwiJoiOPzUiri5Nu8DLwEBDEQn83JYKOfTH9o7l5cb7+B4e6SZVl5WmCm0tvfVVVIIGo529gSuBn09ObsakBVoNKKbw1M3xQ2iRUFvVwR4q84J2dvIAJkKwtzbwgH6S/t7Gy3nx6oyZE3hIjIJm5mTAyUKnnEuaHEX6M6QBJbA7E0M2nDW/hdoFNHvF3WeHQVBPKNrnpxU8hh9EXUuwbZoE39PfioXUXc3grV56MzH/9/gEaBkcYv7FqCIVaj/O7bdfRh+MccX1iAqd3Rcz//AN+SMNM+mVvnw/O/xXpjaZvMftFsCOyV2nY5vx8cdacAAm7DZx4DAc2OaF7w+NUYdpI82FvBgIdlWNY+PT9ZgPMDoINQdWEBQuPGVifS7ojCrZ5tRiHYihQqpjnEz7O2Vu8IzxjHzOqipYQQ6WrnLdMdhE6CT9lwXcdS1xPhWtMuQAvp0xpGdgys2oNK8jPqKiwqmTItkr4wcTFLI1gzquDCNTQ3MjMQCjmjwGccKuE3WslS+yjTdJ3UvNEluFLubPtRJn4LpPGjNQ
 9tQ4EelR
 7IQpBxGo20k8xj2n8Cdvm2bKmR/YiZrb2RRJi0tHD7T2pjP7FWQLpkoMA8VAo6Yzkqct611jd9tHhbC2NGLytwFs7WmyLPICCh8krhFKWa3vH4/MLUuTif0izZapBSazm2k5tZ0jW6eD9/FuqIyFWEo0Ehq/aB1hBWuHls8ENvOEaGLkSYH6BPgp8gKrc/cqzDqO7a85Ysm7JpFPev4FNe0vHrtu/ns9KVCuNJvr/OJVe1oRN7FGr0sjm9bPves7UaPdX50rHpoo7C8jrJ2d2zfTJ6LRP637trUkxlD9lULaBvZkYu6qOWKv/zlnjLDYCbvcSeDxaLcm1NJsPMAsLI6T456+3CltZLpZw813OF04jyGSlxBCewHwNMMxfN579HxL0RVoLTYxf7Ccy2CoPAwYNwtfR9zEQEaxvgdHi7dayRBcHNAVZ37OqkuVUQgcMAOuPTxL+XIdSLJrwtgNjFgMeyhwmtstmWaJibuxDg5vJit9ZpfNIZLR92HaWFjCjcSdqDsoN4qQmUONQ918I7yj1Ym8L8S8Pljibk/6ECkxI1IUkD0b7JXFvgoqF7B7MqrWVign5My7A8HVkOTFRmsZwIkHgCoieM/svlCaTNJxK7l0zNdg9ZwHe9IfIkj87S7mSg1jkyn0TH/x3/eSm2qktsC4GgG6fUCI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA_PMD manages pools of PMD_SIZE physically contiguous memory from which
IO buffers can be allocated. Recycling memory to the pool amortizes the
cost of mapping, unmapping and IOTLB flush, but must be handled so that
memory with active IOMMU mappings cannot be used for other data or code.

Add the pool lifecycle (struct dma_pmd_pool, dma_pmd_pool_create(),
dma_pmd_pool_destroy()) and the page release side. In particular,
__dma_pmd_free_page() is hooked into __free_pages_prepare() so that
DMA_PMD pages are returned to the pool.

Also implement asynchronous DMA_PMD page retirement and release to
the buddy allocator via a WQ_MEM_RECLAIM worker.  Retirement removes
DMA_PMD pages from pools and destroys the mappings flushing the IOTLB,
but defers the buddy release by an RCU grace period, so a reader that
already passed dma_is_pmd_page() can safely finish reading p2m.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile       |   2 +-
 drivers/iommu/dma-pmd-meta.c |   4 +-
 drivers/iommu/dma-pmd-pool.c | 379 +++++++++++++++++++++++++++++++++++
 drivers/iommu/dma-pmd-priv.h | 129 +++++++++++-
 include/linux/dma-pmd.h      |  73 ++++++-
 mm/page_alloc.c              |   4 +
 6 files changed, 579 insertions(+), 12 deletions(-)
 create mode 100644 drivers/iommu/dma-pmd-pool.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2ad9b2eefd741..de2c3bad9aa3e 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
-obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o
+obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o dma-pmd-pool.o
 obj-$(CONFIG_DMA_PMD_META_KUNIT_TEST) += dma-pmd-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
diff --git a/drivers/iommu/dma-pmd-meta.c b/drivers/iommu/dma-pmd-meta.c
index fcaf5b121e66a..27b8c2568c749 100644
--- a/drivers/iommu/dma-pmd-meta.c
+++ b/drivers/iommu/dma-pmd-meta.c
@@ -43,7 +43,9 @@ EXPORT_SYMBOL(dma_pmd_meta_array);
 unsigned long dma_pmd_meta_nframes __read_mostly;
 static unsigned long *dma_pmd_chunk_bitmap __read_mostly;
 
-static struct dma_pmd_meta dma_pmd_meta_nil;
+static struct dma_pmd_meta dma_pmd_meta_nil = {
+	.map_lock = __SPIN_LOCK_UNLOCKED(dma_pmd_meta_nil.map_lock),
+};
 
 static unsigned long dma_pmd_meta_pages;
 static DEFINE_MUTEX(dma_pmd_meta_mutex);
diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
new file mode 100644
index 0000000000000..5020265d52cd5
--- /dev/null
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -0,0 +1,379 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * DMA_PMD streaming page pool, async page reclaim, shrinker, and debugfs.
+ *
+ * See Documentation/core-api/dma-pmd.rst for the architecture overview.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/debugfs.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-pmd.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/llist.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/seq_file.h>
+#include <linux/shrinker.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/srcu.h>
+#include <linux/workqueue.h>
+
+#include "dma-pmd-priv.h"
+
+/*
+ * DMA_PMD pages whose last block has just been freed and which are over the
+ * pool's idle watermark are pushed here locklessly for later release.
+ */
+static LLIST_HEAD(dma_pmd_free_list);
+
+/* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
+static struct workqueue_struct *dma_pmd_wq __ro_after_init;
+
+/* All live pools. */
+static LIST_HEAD(dma_pmd_pools);
+static DEFINE_MUTEX(dma_pmd_pools_lock);
+static LLIST_HEAD(dma_pmd_dead_pools);
+
+static void dma_pmd_schedule_reclaim(void);
+
+static void dma_pmd_pool_free_kref(struct kref *kref)
+{
+	struct dma_pmd_pool *pool = container_of(kref, struct dma_pmd_pool, refcount);
+
+	llist_add(&pool->dead_node, &dma_pmd_dead_pools);
+	dma_pmd_schedule_reclaim();
+}
+
+/*
+ * Releasing an idle PMD page proceeds in three stages:
+ *
+ * 1. Detach from pool->idle (or when the last block of a destroyed/over-watermark
+ *    PMD page frees in __dma_pmd_free_page()). Because __free_pages_prepare()
+ *    may run in hardirq/softirq or with allocator locks held, the PMD page is
+ *    pushed locklessly onto dma_pmd_free_list and dma_pmd_reclaim_work is
+ *    scheduled on dma_pmd_wq.
+ * 2. In process context, dma_pmd_release_page() unmaps all IOMMU domains
+ *    (dma_pmd_unmap_all(), added in a later commit), clears meta->pooled so
+ *    new lockless readers stop entering @meta, and queues
+ *    dma_pmd_release_page_rcu() via call_rcu().
+ * 3. After an RCU grace period (once no concurrent dma_pmd_free_page() reader
+ *    can still be dereferencing @meta), dma_pmd_release_page_rcu() unfreezes
+ *    all order-pool->order blocks (already split by split_page_compound()),
+ *    returns them to the buddy allocator, and drops pool->refcount.
+ */
+
+/**
+ * dma_pmd_release_page_rcu - Return a retired PMD page to the buddy allocator
+ * @head: @rcu member of the PMD page being released
+ *
+ * Runs once no reader can still be resolving a PFN in this PMD page. All blocks
+ * are unfrozen and handed back to the buddy allocator, and the pool reference
+ * is dropped last.
+ */
+static void dma_pmd_release_page_rcu(struct rcu_head *head)
+{
+	/*
+	 * Read @meta->pool before returning the blocks to buddy: once the last
+	 * block is freed, the PMD frame can be reallocated and @meta overwritten.
+	 */
+	struct dma_pmd_meta *meta = container_of(head, struct dma_pmd_meta, rcu);
+	struct page *page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
+	struct dma_pmd_pool *pool = READ_ONCE(meta->pool);
+	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
+	unsigned int order = pool->order;
+	unsigned long flags;
+	unsigned int i;
+
+	for (i = 0; i < nr; i++) {
+		struct page *block = page + (i << order);
+
+		page_ref_unfreeze(block, 1);
+		__free_pages(block, order);
+	}
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->pmd_free_cnt++;
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	kref_put(&pool->refcount, dma_pmd_pool_free_kref);
+}
+
+/**
+ * dma_pmd_release_page - Retire a PMD page and schedule its buddy release
+ * @meta: PMD page metadata structure (must have all usable blocks idle)
+ *
+ * Cost: Slow path; clears the membership bit. The blocks themselves are
+ *       returned after an RCU grace period.
+ * Locking: Must not hold @pool->lock.
+ * Frequency: Rare (background reclaim workqueue, pool destruction).
+ */
+static void dma_pmd_release_page(struct dma_pmd_meta *meta)
+{
+	/* dma_pmd_unmap_all(meta) will be called here once IOMMU mappings are added. */
+
+	/*
+	 * Clear membership before the grace period. A reader that passed
+	 * dma_is_pmd_page() just before this may still be reading @meta, so
+	 * the PMD page and its metadata entry must outlive the grace period.
+	 */
+	WRITE_ONCE(meta->pooled, false);
+	call_rcu(&meta->rcu, dma_pmd_release_page_rcu);
+}
+
+static void dma_pmd_reclaim_work_fn(struct work_struct *work)
+{
+	struct llist_node *node = llist_del_all(&dma_pmd_free_list);
+	struct dma_pmd_pool *pool, *ptmp;
+	struct dma_pmd_meta *meta, *tmp;
+
+	llist_for_each_entry_safe(meta, tmp, node, llnode)
+		dma_pmd_release_page(meta);
+
+	node = llist_del_all(&dma_pmd_dead_pools);
+	if (node) {
+		mutex_lock(&dma_pmd_pools_lock);
+		llist_for_each_entry_safe(pool, ptmp, node, dead_node)
+			list_del(&pool->node);
+		mutex_unlock(&dma_pmd_pools_lock);
+
+		llist_for_each_entry_safe(pool, ptmp, node, dead_node)
+			kfree(pool);
+	}
+}
+
+static DECLARE_WORK(dma_pmd_reclaim_work, dma_pmd_reclaim_work_fn);
+
+static void dma_pmd_schedule_reclaim(void)
+{
+	struct workqueue_struct *wq = READ_ONCE(dma_pmd_wq);
+
+	if (likely(wq))
+		queue_work(wq, &dma_pmd_reclaim_work);
+	else
+		schedule_work(&dma_pmd_reclaim_work);
+}
+
+/**
+ * dma_pmd_pool_create - Create a DMA_PMD page pool
+ * @order: Block order to dispense, must be <= PMD_ORDER.
+ * @max_idle_pages: Maximum number of completely idle PMD pages to keep cached in
+ *               the pool before asynchronously releasing excess PMD pages to buddy
+ *               (0 uses default of 16 = 32 MB).
+ *
+ * New PMD physical pages are allocated on demand on the NUMA node of the
+ * calling CPU (the NAPI CPU for RX queue refill, or the application CPU for TX).
+ *
+ * Cost: Process-context control plane; allocates pool metadata structure, and
+ *       on first call the global membership bitmap.
+ * Locking: May sleep (GFP_KERNEL).
+ * Frequency: Rare (driver queue initialization or subsystem init).
+ *
+ * Return: Pointer to the created pool, or NULL on failure.
+ */
+struct dma_pmd_pool *dma_pmd_pool_create(unsigned int order, unsigned int max_idle_pages)
+{
+	struct dma_pmd_pool *pool;
+
+	if (order > PMD_ORDER)
+		return NULL;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	kref_init(&pool->refcount);
+	spin_lock_init(&pool->lock);
+	pool->order = order;
+	pool->max_idle_pages = max_idle_pages ? : 16;
+	pool->next_alloc_attempt = jiffies;
+	INIT_LIST_HEAD(&pool->partial);
+	INIT_LIST_HEAD(&pool->idle);
+	INIT_LIST_HEAD(&pool->full);
+
+	mutex_lock(&dma_pmd_pools_lock);
+	if (dma_pmd_meta_init()) {
+		mutex_unlock(&dma_pmd_pools_lock);
+		kfree(pool);
+		return NULL;
+	}
+	list_add(&pool->node, &dma_pmd_pools);
+	mutex_unlock(&dma_pmd_pools_lock);
+
+	return pool;
+}
+EXPORT_SYMBOL(dma_pmd_pool_create);
+
+/**
+ * dma_pmd_pool_destroy - Destroy a DMA_PMD page pool and unmap cached PMD pages
+ * @pool: Pool to destroy
+ *
+ * Frees completely idle 2M pages immediately. Device DMA must be quiesced by
+ * the caller first, but blocks already handed to the networking stack (e.g.,
+ * RX skbs waiting in socket queues or TX skbs in TCP retransmit queues) may
+ * still be in flight; those 2M pages stay on @pool->partial / @pool->full and
+ * keep @pool alive on @dma_pmd_pools via @pool->refcount until their last
+ * blocks free.
+ *
+ * Cost: Control plane teardown; flushes async reclaim workqueue.
+ * Locking: Process context (may sleep in flush_work). Acquires @pool->lock.
+ * Frequency: Rare (driver queue teardown or module unload).
+ *
+ * Return: Always NULL, so callers can write `pool = dma_pmd_pool_destroy(pool)`.
+ */
+struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
+{
+	struct dma_pmd_meta *meta, *tmp;
+	LIST_HEAD(release_list);
+	unsigned long flags;
+
+	if (!pool)
+		return NULL;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->destroyed = true;
+
+	/* Take out the idle PMD pages; the unmap happens outside the lock. */
+	list_splice_init(&pool->idle, &release_list);
+	pool->num_idle_pages = 0;
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	list_for_each_entry_safe(meta, tmp, &release_list, list) {
+		list_del(&meta->list);
+		dma_pmd_release_page(meta);
+	}
+
+	kref_put(&pool->refcount, dma_pmd_pool_free_kref);
+	flush_work(&dma_pmd_reclaim_work);
+	return NULL;
+}
+EXPORT_SYMBOL(dma_pmd_pool_destroy);
+
+/**
+ * __dma_pmd_free_page - Recycle a freed block back into its DMA_PMD pool
+ * @page: Block being freed
+ *
+ * Called from __free_pages_prepare() when a block's refcount reaches 0.
+ * Marks the block index available in @meta->dirty_bitmap[] (or @meta->free_bitmap[]
+ * when init_on_free zeroes it). If the PMD page becomes completely idle and the
+ * pool exceeds @max_idle_pages, queues the PMD page to dma_pmd_free_list for
+ * asynchronous unmapping and buddy release.
+ *
+ * Cost: O(1) bit set under spinlock (~15-20 cycles).
+ * Locking: Runs inside the rcu_read_lock() section opened by
+ *          dma_pmd_free_page(), and acquires @pool->lock (irqsave).
+ *          Safe from any context (IRQ, softirq, process). Never sleeps.
+ * Frequency: Very high (called on every kfree_skb / napi_consume_skb / put_page
+ *            for buffers allocated from an dma_pmd_pool).
+ *
+ * Return: true if the page belonged to a DMA_PMD pool and was recycled, false
+ *         if it is a normal system page that should be freed by the buddy
+ *         allocator.
+ */
+bool __dma_pmd_free_page(struct page *page)
+{
+	struct dma_pmd_meta *meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
+	unsigned int nr = DMA_PMD_BLOCKS(meta->pool->order), idx;
+	struct dma_pmd_pool *pool = meta->pool;
+	unsigned long pfn = page_to_pfn(page);
+	bool should_release = false;
+	bool zeroed_on_free = false;
+	unsigned int avail;
+	unsigned long flags;
+
+	idx = (pfn - dma_pmd_meta_to_pfn(meta)) >> pool->order;
+
+	/*
+	 * Never reuse or return a hwpoisoned block to buddy: leave its bit
+	 * clear in free_bitmap/dirty_bitmap so the PMD page stays pinned and isolated.
+	 */
+	if (unlikely(folio_contain_hwpoisoned_page(page_folio(page)))) {
+		pr_err_once("dma_pmd: poisoned block at pfn %lu, leaking it to keep pool %p intact\n",
+			    pfn, pool);
+		return true;
+	}
+
+	/*
+	 * Reject double frees (bit already set in free_bitmap or dirty_bitmap),
+	 * out-of-range indices, or mismatched orders: leak the block rather than
+	 * corrupt the pool or hand a live PMD page's block to the buddy allocator.
+	 */
+	if (WARN_ON_ONCE(idx >= nr || compound_order(page) != pool->order ||
+			 test_bit(idx, meta->free_bitmap) ||
+			 test_bit(idx, meta->dirty_bitmap)))
+		return true;
+
+	/*
+	 * Pooled blocks stay allocated from buddy until dma_pmd_release_page_rcu()
+	 * (which runs KASAN/KMSAN/pgalloc_tag_sub via __free_pages()), and never
+	 * come from HIGHMEM (CONFIG_DMA_PMD is 64-bit only).
+	 */
+	if (want_init_on_free()) {
+		memset(page_address(page), 0, PAGE_SIZE << pool->order);
+		zeroed_on_free = true;
+	}
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (WARN_ON_ONCE(test_bit(idx, meta->free_bitmap) ||
+			 test_bit(idx, meta->dirty_bitmap))) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		return true;
+	}
+
+	if (zeroed_on_free) {
+		__set_bit(idx, meta->free_bitmap);
+		meta->nr_free++;
+	} else {
+		__set_bit(idx, meta->dirty_bitmap);
+		meta->nr_dirty++;
+	}
+	avail = dma_pmd_meta_avail(meta);
+	pool->block_free_cnt++;
+
+	if (avail == 1 && !pool->destroyed)
+		list_move(&meta->list, &pool->partial);
+
+	if (avail == nr) {
+		if (pool->destroyed || pool->num_idle_pages >= pool->max_idle_pages) {
+			list_del_init(&meta->list);
+			llist_add(&meta->llnode, &dma_pmd_free_list);
+			should_release = true;
+		} else {
+			list_move(&meta->list, &pool->idle);
+			pool->num_idle_pages++;
+		}
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	if (should_release)
+		dma_pmd_schedule_reclaim();
+
+	return true;
+}
+EXPORT_SYMBOL(__dma_pmd_free_page);
+
+static int __init dma_pmd_init(void)
+{
+	/*
+	 * Reclaim frees memory, so it must not queue behind arbitrary work on
+	 * system_wq when the machine is already short of it. Failure is not
+	 * fatal: dma_pmd_schedule_reclaim() falls back to system_wq.
+	 */
+	dma_pmd_wq = alloc_workqueue("dma_pmd", WQ_MEM_RECLAIM, 0);
+	if (!dma_pmd_wq)
+		pr_warn("dma_pmd: no reclaim workqueue, falling back to system_wq\n");
+
+	return 0;
+}
+subsys_initcall(dma_pmd_init);
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index a5ebede11dac2..99bd7d77fd4ef 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -3,37 +3,150 @@
 #define _DRIVERS_IOMMU_DMA_PMD_PRIV_H
 
 #include <linux/dma-pmd.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
 #ifdef CONFIG_DMA_PMD
 
+#define DMA_PMD_BLOCKS(order)		(1U << (PMD_ORDER - (order)))
+
+/*
+ * Locking
+ * -------
+ * dma_pmd_meta_mutex	Serialises population of dma_pmd_meta_array. Taken
+ *			from init and on-demand from dma_pmd_meta_ensure_pfn()
+ *			when can_block is true. It is not nested with pool->lock
+ *			or meta->map_lock, and sits inside dma_pmd_pools_lock
+ *			when dma_pmd_pool_create() calls dma_pmd_meta_init().
+ *
+ * dma_pmd_pools_lock	Mutex over the list of live pools. Outermost of the
+ *			three, and it must not be taken from a context that
+ *			cannot sleep.
+ *
+ * pool->lock		IRQ-safe spinlock over one pool's partial/idle/full
+ *			lists and its counters. The alloc and free fast paths
+ *			take it on its own.
+ *
+ * meta->map_lock	IRQ-safe spinlock over one PMD frame's domains_mapped
+ *			bitmap. Innermost, and never held across anything that
+ *			sleeps.
+ */
+
 /*
- * Normally 128 B per entry (64 KB per GB of RAM), or 256 B when spinlock
- * debugging enlarges struct dma_pmd_meta. Verified by static_assert().
+ * 256 B per entry (128 KB per GB of RAM). Verified by static_assert().
  */
-#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 #define DMA_PMD_META_SHIFT		8
-#else
-#define DMA_PMD_META_SHIFT		7
-#endif
 #define DMA_PMD_META_SIZE		BIT(DMA_PMD_META_SHIFT)
 
 /**
  * struct dma_pmd_meta - Metadata for a single DMA_PMD page
- * @pooled: True while this page is owned by an dma_pmd_pool (at offset 0)
+ * @pooled:	True while this page is owned by an dma_pmd_pool (offset 0)
+ *		read locklessly by dma_is_pmd_page().
+ * @nr_free:	Number of zeroed available blocks in @free_bitmap
+ * @nr_dirty:	Number of dirty available blocks in @dirty_bitmap
+ * @map_lock:	Spinlock protecting slow-path updates to @domains_mapped
+ *
+ * Map fast path:
+ * @domains_mapped: One bit per domain index: set once this PMD page's leaf
+ *		PTE is installed in that domain.
+ *
+ * Alloc/free fast path, all under pool->lock:
+ * @pool:	Owning dma_pmd_pool (holds a kref on the pool while pooled)
+ * @list:	Node in pool->partial, pool->idle or pool->full
+ *
+ * Slow path only (disjoint lifetimes):
+ * @llnode:	Node in lockless dma_pmd_free_list for async buddy release
+ * @rcu:	RCU head used to defer buddy release past lockless readers
+ *
+ * @free_bitmap: Bitmap of zeroed available block indices (up to 1 << PMD_ORDER)
+ * @dirty_bitmap: Bitmap of dirty available block indices
  *
  * Lives in the sparse per-PMD-frame array @dma_pmd_meta_array indexed by
  * (pfn >> PMD_ORDER). Only chunks covering valid RAM are backed by physical
- * pages (64 KB per GB of RAM).
+ * pages (128 KB per GB of RAM).
  */
 struct dma_pmd_meta {
 	bool pooled;
+	u16 nr_free;
+	u16 nr_dirty;
+	spinlock_t map_lock;
+
+	unsigned long domains_mapped;
+
+	struct dma_pmd_pool *pool;
+	struct list_head list;
+
+	union {
+		struct llist_node llnode;
+		struct rcu_head rcu;
+	};
+
+	DECLARE_BITMAP(free_bitmap, 1U << PMD_ORDER) ____cacheline_aligned;
+	DECLARE_BITMAP(dirty_bitmap, 1U << PMD_ORDER) ____cacheline_aligned;
 } __aligned(DMA_PMD_META_SIZE);
 
 static_assert(offsetof(struct dma_pmd_meta, pooled) == 0);
 static_assert(sizeof(struct dma_pmd_meta) == DMA_PMD_META_SIZE);
 
+static inline unsigned int dma_pmd_meta_avail(const struct dma_pmd_meta *m)
+{
+	return m->nr_free + m->nr_dirty;
+}
+
+/**
+ * struct dma_pmd_pool - Pool managing PMD-backed blocks of a fixed order
+ *
+ * @lock:	Spinlock protecting @partial, @idle, @full, @num_idle_pages,
+ *		block bitmaps and the statistics counters
+ * @order:	Block order managed by this pool (<= PMD_ORDER)
+ * @destroyed:	Set when dma_pmd_pool_destroy() has been called
+ * @partial:	List of PMD pages with at least 1 free block, but not all
+ *		of them (MRU ordered). Candidates for allocation.
+ * @idle:	List of PMD pages whose every usable block is free. Held
+ *		separately because they can be released under pressure.
+ * @full:	List of PMD pages with 0 free blocks
+ * @num_idle_pages: Length of @idle
+ * @max_idle_pages: High watermark of completely idle PMD pages retained in
+ *		@idle before triggering asynchronous release to buddy
+ * @pmd_alloc_cnt: Statistics counter of PMD pages allocated from buddy
+ * @pmd_free_cnt: Statistics counter of PMD pages released back to buddy
+ * @block_alloc_cnt: Statistics counter of block allocations satisfied
+ * @block_free_cnt: Statistics counter of block frees recycled into pool
+ * @next_alloc_attempt: Do not attempt a new order-9 allocation before this time.
+ *		Damps repeated high-order GFP_ATOMIC failures under
+ *		fragmentation, which would otherwise be retried on every
+ *		pool miss from softirq context.
+ * @refcount:	Reference count; held by pool creator and each active PMD page
+ * @node:	Node in the global dma_pmd_pools list
+ * @dead_node:	Node in dma_pmd_dead_pools once @refcount reaches 0
+ */
+struct dma_pmd_pool {
+	/* First cacheline: hot fields touched on block alloc and free. */
+	spinlock_t		lock;
+	u8			order;
+	bool			destroyed;
+	struct list_head	partial;
+	struct list_head	idle;
+	struct list_head	full;
+	unsigned int		num_idle_pages;
+	unsigned int		max_idle_pages;
+
+	/* Statistics, all updated under @lock. */
+	u64			pmd_alloc_cnt;
+	u64			pmd_free_cnt;
+	u64			block_alloc_cnt;
+	u64			block_free_cnt;
+
+	/* Cold. */
+	unsigned long		next_alloc_attempt;
+	struct kref		refcount;
+	struct list_head	node;
+	struct llist_node	dead_node;
+} ____cacheline_aligned;
+
 extern unsigned long dma_pmd_meta_nframes;
 
 static inline struct dma_pmd_meta *dma_pmd_meta_base(void)
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
index 07df815945257..236be50b7349f 100644
--- a/include/linux/dma-pmd.h
+++ b/include/linux/dma-pmd.h
@@ -3,9 +3,12 @@
 #ifndef _LINUX_DMA_PMD_H
 #define _LINUX_DMA_PMD_H
 
-#include <linux/compiler.h>
-#include <linux/mm_types.h>
 #include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/rcupdate.h>
+
+struct device;
+struct dma_pmd_pool;
 
 #ifdef CONFIG_DMA_PMD
 
@@ -25,6 +28,56 @@ static inline bool dma_is_pmd_page(unsigned long pfn)
 	return __dma_is_pmd_page(pfn);
 }
 
+bool __dma_pmd_free_page(struct page *page);
+
+static inline bool dma_pmd_free_page(struct page *page)
+{
+	bool ret;
+
+	rcu_read_lock();
+	ret = dma_is_pmd_page(page_to_pfn(page)) && __dma_pmd_free_page(page);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/*
+ * External API: dma_pmd_pool (streaming DMA page pool)
+ * -----------------------------------------------------
+ * Opportunistic drop-in for alloc_pages_node() that carves fixed-order
+ * (order <= PMD_ORDER) pages out of 2MB physically contiguous buddy pages.
+ *
+ * - Creation (dma_pmd_pool_create):
+ *   Records @order and @max_idle_pages; no 2MB pages or IOMMU mappings
+ *   are allocated yet.
+ *
+ * - Allocation (dma_pmd_pool_alloc_node / dma_pmd_pool_alloc):
+ *   Dispenses an order-@order compound page with refcount 1 (or NULL on
+ *   unsupported GFP flags / OOM, so callers fall back to alloc_pages_node()).
+ *   On a pool miss, allocates a 2MB page on @nid and splits it into subpages.
+ *
+ * - Mapping (dma_map_page / dma_map_single / dma_map_phys / dma_map_sg):
+ *   Intercepts single-buffer and scatterlist maps. On first use of a 2MB page
+ *   in an IOMMU domain, lazily installs a 2MB bidirectional leaf PTE in the
+ *   domain's DMA_PMD IOVA window; subsequent maps are O(1) arithmetic.
+ *
+ * - Unmapping & Recycling (dma_unmap_* / put_page):
+ *   dma_unmap_page/single/phys/sg() is a no-op for IOVAs in the DMA_PMD window,
+ *   keeping the 2MB PTE resident across buffer reuse. When the page's last
+ *   reference drops (put_page() / __free_pages()), __free_pages_prepare()
+ *   intercepts it via dma_pmd_free_page() and recycles the subpage back into
+ *   @pool.
+ *
+ * - Unmap & Buddy Release (reclaim / shrinker / dma_pmd_pool_destroy):
+ *   A 2MB page is released back to the buddy allocator only when all of its
+ *   subpages are free in @pool and either the pool exceeds @max_idle_pages, the
+ *   system shrinker reclaims idle pages, or dma_pmd_pool_destroy() is called.
+ *   Before __free_pages(PMD_ORDER) is called, the 2MB leaf PTE is unmapped from
+ *   every domain that mapped it and the IOTLB is synchronously flushed.
+ */
+struct dma_pmd_pool *dma_pmd_pool_create(unsigned int order, unsigned int max_idle_pages);
+struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool);
+
 #else /* !CONFIG_DMA_PMD */
 
 static inline bool dma_is_pmd_page(unsigned long pfn)
@@ -32,5 +85,21 @@ static inline bool dma_is_pmd_page(unsigned long pfn)
 	return false;
 }
 
+static inline bool dma_pmd_free_page(struct page *page)
+{
+	return false;
+}
+
+static inline struct dma_pmd_pool *
+dma_pmd_pool_create(unsigned int order, unsigned int max_idle_pages)
+{
+	return NULL;
+}
+
+static inline struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _LINUX_DMA_PMD_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c483..e8e9905cdea5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -17,6 +17,7 @@
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/dma-pmd.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/compiler.h>
@@ -1327,6 +1328,9 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	if (unlikely(dma_pmd_free_page(page)))
+		return false;
+
 	trace_mm_page_free(page, order);
 	kmsan_free_page(page, order);
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


