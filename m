Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EE0CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D1E8E0006; Thu, 11 Sep 2025 02:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301DD8E000A; Thu, 11 Sep 2025 02:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DC78E0006; Thu, 11 Sep 2025 02:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08BA58E000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:57:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EC6C13A342
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:13 +0000 (UTC)
X-FDA: 83876062746.13.322C0D3
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 12CE9140004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757573831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=009TObxTuoAym2laDnbXWEko3t8mjJvcVzYCYghogOQ=;
	b=3gB/d0dCciats82fL2AME7vF7J1K2XOUCTT2GiTuZXKDf62EySh2tcA0f+XeozG5pKwLRa
	YqBRCT6bJZ3eIreMnht1VsT/tCbMr+Gz9IxDCpHdo1XzNoXgO8TBdh+nUVQLKDGtkmkaGw
	THuF6vZLEbL3bOAmQ2l/k/x6/wdEPXQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757573831; a=rsa-sha256;
	cv=none;
	b=Ww5yOYWjQlYi3nVFpzocLrorb83BLw5Um2d94l+N79Zdq/246h+5Ynn5K3uAImY3wVK26n
	20B+Yc7obPKe1nIBwTEbtIrBDDuGCHuJypJ0F7pKXbyZzWZ53WahXDb9mbkokAqJq+jV6c
	ZiMc48earBp55DpKwYlKwo9NWNHPOxs=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cMpD14CX7z13NZQ;
	Thu, 11 Sep 2025 14:53:05 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 26A65180464;
	Thu, 11 Sep 2025 14:57:07 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 14:57:05 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH 4/4] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Thu, 11 Sep 2025 14:56:59 +0800
Message-ID: <20250911065659.617954-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 12CE9140004
X-Rspamd-Server: rspam05
X-Stat-Signature: qxk8etcmneo679t9ca1jgsjx351snx7t
X-Rspam-User: 
X-HE-Tag: 1757573830-433728
X-HE-Meta: U2FsdGVkX1/DcI9UY8VK8KPIe8LUiKo5CiL/jLIvMZ3RaEu/pNriaHuxUhIa7xJs5wR+8sLwyktY7nh+PhR/enLupV4IAfasGc8nxe4fP2v42oy+DAPNXKNBnObRr+LCqJozswg6Z8TKkjqbHpcAbwysdYnvIumCO+x2uFvR/7UfZyLNMzTAQ4UF43aYl0ACwGumXb3/3ZuaF1y0vy4ixRj2ogI8vPY1ZkKtrCDnJ30ql/MxarVWj3ZGlRHRS6JEsS0DwU5wc5Wz/+rHA/A2KiGKaVlef0v+F/lVU+xXUDqshFnOGw4J2cDjZPSfGIoLBdA+H5GToaNwT8xOPyD5XhrjVPCnaoEce+9uNSdJrfqcm6e8pWyTf+834sDsMn0Zq01TJK1JvKPnAqiuQYWQRq5xu8/Sxv1h5vWBORMd8buoReTCWm/Oiug2aT1U82maXbH1xHh0wVlhk6/3yPTfRp8rTBL9/CvnU5JkhbgSG3smHy57ak0ac5ZzBXVP1MHUmL12i6JCJ235HI9lg+h5U2ynNJwxPtPJFJFB+x7h208lWrP7aAOwWaQRxaNg8Fm7oQgakdSQZpX/d71sGmlTm77IImo65/parzAokLdZMQPyLgCAjpqzIk9Utql5dQoDz7tu5l5hlRzjYgoEBohPWSaD7qaN0TaRkik/HD47SoWh+g+s2YgmqEdFrfsynch5PmJP2yhigh6ild2Z3TwhykUhtpmFOm+BZryOizfqK0zIP9sTJIqRcQgMxQ98ik7Sr4ROC7/1JBO468+b8ZZjHHpv8VjbuJKF7PZ+kMMbGiZcE00Kyss+bNgHkVqAeSNbL3pepVRkRYzcGGdq0AgfZyWZRqQmxd72/GCza5FZIGwmGE+r9xe1rXSlb6hid9VWnoonxt0uiOQOF1MYir16px5gNSAJhs3suLay4pE6Z2dGrw3BE8krpCrHzRU6zYJOREE8evY3FvTso5DGZwx
 RoPuqNuJ
 pryhi3hFgmOUxhiLaTBlLO61Q+TEJQhucjosw3wKNUuvhOLj6QRtwe4Gth01Xx4ArSR8gYSXAtAEdmnP6ASGokNYGY3w5fHO+8vgpnczSjBkUKhxEjSSg1DfGLpTlri4k6t/UZdRp07Bxaq+KU35ZNp0MVVPL5K1dTj5LhYT9ZYl/Dy1M/MSOuef4ntSeqiPsqyEoSuMxc1zWcxSNDpmF0wjPDExss/aoCb9qiRpOVA3w8Gi53ELAnU0ubsGJsUFEQ3p9oSXA+dsCfi8kVoOtN+F0IPvQ8AMTvyZM5AonHKk5rBOerFxhC3X+vh1/2HmGzeSVYc3huwKLmj1P6Hu9OWaoYaOUvx2IINJdSh47O3AsZi+H3ihNw/ultlbBSF4Jta6Dclhjh8JjbIauOR7+iF+LoWq3QPNbn67pHj0Is6XN3s8xedwvVT8FIh/bSWmVDmZ7sZ92M9cDo/8gSwKV+XeWIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
with refcount increated and then freeze it, convert to allocate a frozen
folio directly to remove the atomic operation about folio refcount, also
saving atomic operation during __update_and_free_hugetlb_folio too.

Rename some functions to make them more self-explanatory,

  folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
  cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
  hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}_frozen_folio

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  8 ++++----
 include/linux/gfp.h | 15 +++++++-------
 mm/cma.c            | 34 +++++++++++++++++++-----------
 mm/hugetlb.c        | 50 +++++++++------------------------------------
 mm/hugetlb_cma.c    | 13 ++++++------
 mm/hugetlb_cma.h    | 10 ++++-----
 6 files changed, 55 insertions(+), 75 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..cceec7b25bae 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -57,16 +57,16 @@ extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long e
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
 #ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
 bool cma_validate_zones(struct cma *cma);
 #else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	return NULL;
 }
 
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
+static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	return false;
 }
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ed9445e6fe38..38a7be7792a2 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -454,26 +454,27 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
 #ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
+	page = alloc_contig_frozen_pages_noprof(1 << order, gfp, nid, node);
 
 	return page ? page_folio(page) : NULL;
 }
 #else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	return NULL;
 }
 #endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
+/* This should be paired with free_frozen_pages() rather than free_contig_range_frozen(). */
+#define folio_alloc_frozen_gigantic(...)	\
+	alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
 
 #endif /* __LINUX_GFP_H */
diff --git a/mm/cma.c b/mm/cma.c
index 2af8c5bc58dd..bca95b8a1015 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -778,7 +778,7 @@ static void cma_debug_show_areas(struct cma *cma)
 
 static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
-				struct page **pagep, gfp_t gfp)
+				struct page **pagep, gfp_t gfp, bool frozen)
 {
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	unsigned long start, pfn, mask, offset;
@@ -836,7 +836,12 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		if (frozen)
+			ret = alloc_contig_range_frozen(pfn, pfn + count,
+							ACR_FLAGS_CMA, gfp);
+		else
+			ret = alloc_contig_range(pfn, pfn + count,
+						 ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -857,7 +862,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 }
 
 static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+		       unsigned int align, gfp_t gfp, bool frozen)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -879,7 +884,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 		page = NULL;
 
 		ret = cma_range_alloc(cma, &cma->ranges[r], count, align,
-				       &page, gfp);
+				       &page, gfp, frozen);
 		if (ret != -EBUSY || page)
 			break;
 	}
@@ -927,23 +932,24 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
+	return __cma_alloc(cma, count, align,
+			   GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0), false);
 }
 
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = __cma_alloc(cma, 1 << order, order, gfp, true);
 
 	return page ? page_folio(page) : NULL;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool frozen)
 {
 	unsigned long pfn, end;
 	int r;
@@ -966,7 +972,11 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (frozen)
+		free_contig_range_frozen(pfn, count);
+	else
+		free_contig_range(pfn, count);
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -987,15 +997,15 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio), true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f0e701e455ed..100e840894f1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -125,16 +125,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
-static void hugetlb_free_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb_cma(folio)) {
-		hugetlb_cma_free_folio(folio);
-		return;
-	}
-
-	folio_put(folio);
-}
-
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1472,43 +1462,20 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 		nr_nodes--)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
-
-retry:
-	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
-	if (!folio) {
-		if (hugetlb_cma_exclusive_alloc())
-			return NULL;
-
-		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
-		if (!folio)
-			return NULL;
-	}
 
-	if (folio_ref_freeze(folio, 1))
+	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
+	if (folio)
 		return folio;
 
-	pr_warn("HugeTLB: unexpected refcount on PFN %lu\n", folio_pfn(folio));
-	hugetlb_free_folio(folio);
-	if (!retried) {
-		retried = true;
-		goto retry;
-	}
-	return NULL;
-}
+	if (hugetlb_cma_exclusive_alloc())
+		return NULL;
 
-#else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
-					  nodemask_t *nodemask)
-{
-	return NULL;
+	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
@@ -1641,9 +1608,12 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
-	folio_ref_unfreeze(folio, 1);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 
-	hugetlb_free_folio(folio);
+	if (folio_test_hugetlb_cma(folio))
+		hugetlb_cma_free_frozen_folio(folio);
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
 }
 
 /*
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..24738a1d6098 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -18,29 +18,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_free_frozen_folio(hugetlb_cma[nid], folio));
 }
 
-
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		folio = cma_alloc_frozen_folio(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
+			folio = cma_alloc_frozen_folio(hugetlb_cma[node], order, gfp_mask);
 			if (folio)
 				break;
 		}
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 2c2ec8a7e134..71db3544816e 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -3,8 +3,8 @@
 #define _LINUX_HUGETLB_CMA_H
 
 #ifdef CONFIG_CMA
-void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+void hugetlb_cma_free_frozen_folio(struct folio *folio);
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -14,12 +14,12 @@ unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
 bool hugetlb_early_cma(struct hstate *h);
 #else
-static inline void hugetlb_cma_free_folio(struct folio *folio)
+static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
-- 
2.43.0


