Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58999C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2466B0096; Wed,  2 Sep 2026 21:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2B66B0099; Wed,  2 Sep 2026 21:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF306B009B; Wed,  2 Sep 2026 21:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31AD86B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:29:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C60D6A01D9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:29:30 +0000 (UTC)
X-FDA: 85170718500.26.BFACDDE
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25224100003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:29:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DP4/cesi";
	spf=pass (imf05.hostedemail.com: domain of qingfang.deng@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=qingfang.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788398969;
	b=L5EeEpm2FrkPSjLEA6GqnixZOU1QFaaMAOpXcTHtEFfxR6XsEChMHTfu4TPfcPo4nxzw4/
	F85+5VKTIgh5EV7Pj1JGMJIfDxJr5cEqVK6oPsHcGlsyZ4GxoFmDp9QHgpwvdyfZnqpMEq
	ijAQYCGQnRG8NQ37OaGXg5QwHT1pNB8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DP4/cesi";
	spf=pass (imf05.hostedemail.com: domain of qingfang.deng@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=qingfang.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788398969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+KXXExEepJS+DTiN3TQ/ALdJf9DzLqdlzaz5jXd8lpQ=;
	b=4+EFjjfqbZkZcQXkX5ZCaQY/YbxOsTHdEgAJntW3FYYPDKKcohD2rbh8Hq5XkSvi17kYZK
	37pNGcR7dNXB3M5GM4wgVdTVarC/9pPHL6w5e7qyTBc1laBXWGIhwroAPm4ZglBw9C1tkT
	UFOBokrwD+NpvK6W5e0JPIBUgcltsF8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=biYsCQdlpI1jiJazmEVMkrZxW/wkfpV5LjcpXes0HIc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788398965; v=1; x=1789003765;
 b=DP4/cesi19OdPFl7IZNTLN1DuWAY0mTraf3Y0vn5LG8eMRHQKWPyoHGYtYO3C1HN78H3vfB6
 drxouMi4S1sZzUlcppo9BbYEGceH8caIdZsde2TOE6Z0dwjsEAFedVCRTtMTUuqmqdD+LGbaJFq
 if1SbpDGPJ6AJLD2K6l6ypR0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0070fac8265920a4;
	Thu, 03 Sep 2026 01:29:25 +0000
X-Mizu-Trace-ID: 0070fac8265920a4
X-Migadu-Flow: FLOW_OUT
From: Qingfang Deng <qingfang.deng@linux.dev>
To: Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Qingfang Deng <qingfang.deng@linux.dev>
Subject: [PATCH v2] dma-mapping: use exact allocation for DMA pages
Date: Thu,  3 Sep 2026 09:29:13 +0800
Message-ID: <20260903012914.312305-1-qingfang.deng@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25224100003
X-Stat-Signature: gpsei9fppzwicyacoxzoqx8tgrwfmt77
X-HE-Tag: 1788398966-988965
X-HE-Meta: U2FsdGVkX1/jhDJHDuxZzVMmjR9zmydMTBzQni07gzSL3GRGj308gbQOBVXOIJBsuu14QEQcTPRnsM25m5X1dUb7uBO0Thq20hdTqLp0llarym0uGiKFWQ5nK8FP4SCI9LzlkX7WR7GupzRwoLrYNvxBtfLiNPInyIhkZ/VveI4U9VRVtikDWEF/PG4EAe3TfQ/KMPA6jUggAqva5wbr7t3lHCSyDJvzJMEBeb4wD05SZkt0+mR3sm7yHPjI/yo3FOwOiaungik6sNAyLKaWMqSYRP3VV4ue/1UJm+wdAcb26EoL5wlbguUQbzlbDN5IZiMMlPgnHpl9Zx2sKcZ6NIvSmfT7g8A/XK2jEbplNXoK2g7RtnLWNvq7okATfBUOTHKAbKkN+rib4hqMQ4jwegwtJJDfo8xWcdcYdC9qOstAKYpFC9SVF+V3qaf3FsHd5KDCrQO0p2r1QUM5bbnU78dQSsRkU+LVlwuYGjEyGy9cJW7lCoXWf2TCBpSezqWugXGooXwEO7RfByQuboxM2kmOKeTT+M7T4o50pqk9W7XqKqcWNhW54aBrrcFKAjPsXt2wJ0ZWtsJTFSUIdrAn6Cc8dPIUKki0sy96BRMhLinbUFk1fhuMKTs5a663XJU69Hxg5cGHNlWKvTfVnhpOhgUc45uhlSYK8rRz+k14nBxrFwbY45buZj8yES8OBMt0OwWYqty/bvWBaiwj3LwJya1tuJX/M4OyyFcGF7vC1zbXj2TK6pzIwgPmiaWDBmcB0v3GOBHjhgnYdW4+WChXEVUfLk23ZEE7mVhAzJs+MH4Omx4sltu1VoJ/s2Ch+4jY70/ufx5FLl8GxUybJ9q11jRl1NFlgwUMOS4ulIMOdXt3HkPo4Yk79mVRqOp6pnU/ofiHLa7qIHIRJwQhRKF6iRW1NLK0RsOiCCyopRZvLNEfHtUWrs69/CvSFIh+WrEzW5pJtQ33LYWXeP/k7pe
 3kixCMXp
 DAH/6ee7a5Y/q59khw2J8NX1GJLpeF4JDVZzF++uX3Y3Exe3cPKKJt9OraR/IeR2qirIhYPs15E0VlIbBC++avil5qyrxTkQmw/nvua1/n9GM65oKNcwMQkS8ArW2bW7dlHdX9h+iJByeQcwpEb0+KXDC+ZQKFe4u7DHQ94Px93uAYOfNYuLEGId5BRI0AWg5eYFdZh/nLmW22rSxRQt4oGOdbO/CtAEvmFlIK/7XTm3IiS9Q5KkLVrE0l5rdPvs7EAAN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA page allocation fallbacks use alloc_pages_node() with get_order(size),
wasting the unused tail for non-power-of-two requests.

Use alloc_pages_exact_nid() and free_pages_exact() so that a buddy
fallback retains only requested pages.

Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
---
v2: drop __meminit to fix section mismatch

v1:
https://lore.kernel.org/linux-iommu/20260901085348.53140-1-qingfang.deng@linux.dev/
---
 drivers/iommu/dma-iommu.c   | 10 ++++++----
 include/linux/dma-map-ops.h |  2 +-
 include/linux/gfp.h         |  2 +-
 kernel/dma/contiguous.c     |  6 +++---
 kernel/dma/direct.c         |  8 +++++---
 kernel/dma/ops_helpers.c    | 11 +++++++----
 mm/page_alloc.c             |  2 +-
 7 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 58c624513cd4..8f262c83802c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1628,10 +1628,12 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
 	void *cpu_addr;
 
 	page = dma_alloc_contiguous(dev, alloc_size, gfp);
-	if (!page)
-		page = alloc_pages_node(node, gfp, get_order(alloc_size));
-	if (!page)
-		return NULL;
+	if (!page) {
+		cpu_addr = alloc_pages_exact_nid(node, alloc_size, gfp);
+		if (!cpu_addr)
+			return NULL;
+		page = virt_to_page(cpu_addr);
+	}
 
 	if (!coherent || PageHighMem(page)) {
 		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 8fae2b7deb20..3ef3003713a6 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -143,7 +143,7 @@ static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
 static inline void dma_free_contiguous(struct device *dev, struct page *page,
 		size_t size)
 {
-	__free_pages(page, get_order(size));
+	free_pages_exact(page_address(page), size);
 }
 #endif /* CONFIG_DMA_CMA*/
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec..aa4601805f21 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -329,7 +329,7 @@ void *alloc_pages_exact_noprof(size_t size, gfp_t gfp_mask) __alloc_size(1);
 
 void free_pages_exact(void *virt, size_t size);
 
-__meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
+void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
 #define alloc_pages_exact_nid(...)					\
 	alloc_hooks(alloc_pages_exact_nid_noprof(__VA_ARGS__))
 
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 66093460584e..90937dc7c627 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -451,8 +451,8 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
  *
  * This function releases memory allocated by dma_alloc_contiguous(). As the
  * cma_release returns false when provided pages do not belong to contiguous
- * area and true otherwise, this function then does a fallback __free_pages()
- * upon a false-return.
+ * area and true otherwise, this function then does a fallback
+ * free_pages_exact() upon a false-return.
  */
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size)
 {
@@ -476,7 +476,7 @@ void dma_free_contiguous(struct device *dev, struct page *page, size_t size)
 	}
 
 	/* not in any cma, free from buddy */
-	__free_pages(page, get_order(size));
+	free_pages_exact(page_address(page), size);
 }
 
 /*
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c..ea64453d7370 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -120,6 +120,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	int node = dev_to_node(dev);
 	struct page *page;
 	u64 phys_limit;
+	void *va;
 
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
@@ -133,9 +134,9 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_free_contiguous(dev, page, size);
 	}
 
-	while ((page = alloc_pages_node(node, gfp, get_order(size)))
-	       && !dma_coherent_ok(dev, page_to_phys(page), size)) {
-		__free_pages(page, get_order(size));
+	while ((va = alloc_pages_exact_nid(node, size, gfp)) &&
+	       !dma_coherent_ok(dev, virt_to_phys(va), size)) {
+		free_pages_exact(va, size);
 
 		if (IS_ENABLED(CONFIG_ZONE_DMA32) &&
 		    phys_limit < DMA_BIT_MASK(64) &&
@@ -146,6 +147,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		else
 			return NULL;
 	}
+	page = va ? virt_to_page(va) : NULL;
 
 	return page;
 }
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 6b5f9208d31c..5cdf3f60cf47 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -67,10 +67,13 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 	phys_addr_t phys;
 
 	page = dma_alloc_contiguous(dev, size, gfp);
-	if (!page)
-		page = alloc_pages_node(dev_to_node(dev), gfp, get_order(size));
-	if (!page)
-		return NULL;
+	if (!page) {
+		void *va = alloc_pages_exact_nid(dev_to_node(dev), size, gfp);
+
+		if (!va)
+			return NULL;
+		page = virt_to_page(va);
+	}
 
 	phys = page_to_phys(page);
 	if (use_dma_iommu(dev))
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c4dc61ec663e..d3a135dfcdd3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5637,7 +5637,7 @@ EXPORT_SYMBOL(alloc_pages_exact_noprof);
  *
  * Return: pointer to the allocated area or %NULL in case of error.
  */
-void * __meminit alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask)
+void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask)
 {
 	unsigned int order = get_order(size);
 	struct page *p;
-- 
2.43.0


