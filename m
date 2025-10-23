Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D291FCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1718E0002; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376AD8E0011; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1311A8E001A; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14858E001C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9470D5C741
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:58 +0000 (UTC)
X-FDA: 84029235276.09.1E9FE80
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BAB418000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PfYbc28/8Lcu1OUbzh7+BOt5R+6/4iLfpUI3iYHlWFY=;
	b=bxjl/lkOjXoohJQYZQQec0xMku1CiZtCFHAuoFnqUIkazGW7YFqVaNjHcb6K8Nku9mPiGj
	iCRt7SkLSP0TK9w1xxn5TqtLH5MZShRgcbIdojklu9ddKCB3+e195YvdwUbCvI04nrMHVC
	gnlsX3PBIB6xkY9bExiTDwfTycOco8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220796; a=rsa-sha256;
	cv=none;
	b=fZ5TdKhmVCrIIs74V72dArW5J/i0dA6axFfggG3l+Y+Mhg9hbPAjValYsXV3ZjDo0EOUE4
	ZLouIDIiRRCVUYC2aDsSc6sqVTTAkJQC6snitNTbRLNzTJqAYkhAj+WsK9TugrsGMLIUra
	q1Y035H2u9CizD2kctkDqisCyNKSSLM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cskx00h81zJsVq;
	Thu, 23 Oct 2025 19:55:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 24F07180B63;
	Thu, 23 Oct 2025 19:59:52 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:51 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 4/6] mm: page_alloc: add alloc_contig_frozen_{range,pages}()
Date: Thu, 23 Oct 2025 19:59:38 +0800
Message-ID: <20251023115940.3573158-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: s6i5e6xn1cpn9r99e35ujpr8hnuageo7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BAB418000A
X-HE-Tag: 1761220795-548298
X-HE-Meta: U2FsdGVkX188xSa52TIZK3X05cHhWL5kzeD9VqtUF6YustIF4GhcdNKI9uKmn3Ts6jG7X3dNiOp/ERBCoU7+ZIyw/s3idlchEvjBHUAFrlbMS277P3OEq0aeaApJYm7trNWe3zJnYraOsXpI4T8uCYfdRldHDzoNmif4K4J/MWOvFJNwZhx1odpm1LXL2afxRm0yFkm21zrAb1QKCJOR2OiHjhFyHvDlKnpHBNizURV1hWDSqGkjILidWWa82rLPe0Lp0A/iZ/MRHcHhrfcIaSPaL87/ckdMED2rhNHU+KT7U8p4+TiHSgZg2Hkg77rSEku0PBVGgnTusan5F8J2G4QvWnY56LkHYDdoN1t5NA2eXAxdaHjWmwxd4KMWwdE8zsSA8Midfgufn/kOK1aYn/wyjNSR3GvjPORXbJUOZMXb7gO2djzzXVQFGPVpc9zzaRqoEXwCKGZumt3qt97NA84zC1prsUe3BzhfHPKT0X+8SSka4M1mZHOhGVfxtSgtmky7+vyDPCnWnZnKC/0V8NkwbS7TLoAbDvVuvZFP8XZy74QTvJO2uJ0lZlmkPm86IyavDfQ+wP9Cift7ifjcmi7a8fzvbiCPyTI7PTqQ5E5iWtqfVC2S7ZpGXy2koVb9AK7VhNjE3GSMqzewqBLq8fPL1zYVYjZ1ZQ/67zcB4I+xHNUtwetXidH9xaA87/CQ1st0KwP5J3YqQ6TiTqqz88PRpKhimNWTbgcZA5wAXd3nsEYuaIg0ivDpAhcnDFF8dQKDPE0KB6oVSxBxW6FPwasgSjkew7gfIZfWJNt3KeV9tbSCCBigc9mnT4FfjXTy7ksPuqsvfRIn8AFLqHy0EVU7LPv65nLWw9RNB5oPDO1oKDrRcRr7lUxWoucl2YrYE9uxPcCd/L9gQKh//aTd5iDHjcXHftC5052yimIv6kPuDvemTc5/sBKqqZrOGSkCXJB3Dg7bve1aNw38AtM
 piPabM3/
 JlQCx6GybZEsY0Ncg9N8kcJsE1ipETrmK1KTbuxQShuk9kBVGh7CdfTYcncszbFTHeF/EhKKI8gimFKNW774FTIFO+eSYm44i+9gIZVfhNOqniLDX+QIvPm4W+P4cAoQzto8ZbN1bln5R9D6JqqgIZx/JKq1aE9YiPcZDb+1hCo4V1GMxzzECYFaOIKZWaN+qsnGwRWX86tzUDhA4KQS67DX7kvlWYae2GnZKC+pZs1J5JORF6uPNxZaPeVlusF5lcKHytqLFft7uw2ZacfzYLn+EUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to allocate given range of pages or allocate compound
pages without incrementing their refcount, adding two new helper
alloc_contig_frozen_{range,pages}() which may be beneficial
to some users (eg hugetlb).

The free_contig_range() is refactored to only free non-compound
pages, the only caller to free compound pages in cma_free_folio() is
changed accordingly, and the free_contig_frozen_range() is provided
to match the alloc_contig_frozen_range(), which is used to free
frozen pages.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h |  29 +++++--
 mm/cma.c            |  15 ++--
 mm/internal.h       |  13 ++++
 mm/page_alloc.c     | 183 ++++++++++++++++++++++++++++++++------------
 4 files changed, 177 insertions(+), 63 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 92582a329d47..6aba25904f36 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -429,14 +429,27 @@ typedef unsigned int __bitwise acr_flags_t;
 #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
 
 /* The below functions must be run on a range from a single zone. */
-extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
-				     acr_flags_t alloc_flags, gfp_t gfp_mask);
-#define alloc_contig_range(...)			alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
-
-extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-					      int nid, nodemask_t *nodemask);
-#define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
-
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask);
+#define alloc_contig_frozen_range(...)	\
+	alloc_hooks(alloc_contig_frozen_range_noprof(__VA_ARGS__))
+
+int alloc_contig_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask);
+#define alloc_contig_range(...)	\
+	alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
+#define alloc_contig_frozen_pages(...) \
+	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
+
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask);
+#define alloc_contig_pages(...)	\
+	alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
+
+void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
diff --git a/mm/cma.c b/mm/cma.c
index 6df44541933a..7f050cf24383 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -836,7 +836,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -904,6 +904,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
 	if (page) {
+		set_pages_refcounted(page, count);
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
@@ -943,7 +944,7 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool compound)
 {
 	unsigned long pfn, end;
 	int r;
@@ -973,7 +974,11 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 		return false;
 	}
 
-	free_contig_range(pfn, count);
+	if (compound)
+		__free_pages((struct page *)pages, compound_order(pages));
+	else
+		free_contig_range(pfn, count);
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -994,7 +999,7 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
 bool cma_free_folio(struct cma *cma, const struct folio *folio)
@@ -1002,7 +1007,7 @@ bool cma_free_folio(struct cma *cma, const struct folio *folio)
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio), true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/internal.h b/mm/internal.h
index 26e7901e963f..ec1e47a9044f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -513,6 +513,19 @@ static inline void set_page_refcounted(struct page *page)
 	set_page_count(page, 1);
 }
 
+static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (PageHead(page)) {
+		set_page_refcounted(page);
+		return;
+	}
+
+	for (; nr_pages--; pfn++)
+		set_page_refcounted(pfn_to_page(pfn));
+}
+
 /*
  * Return true if a folio needs ->release_folio() calling upon it.
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d619c70c6892..9aebab17974b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6836,7 +6836,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6848,11 +6848,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			__split_page(page, order);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6896,8 +6895,14 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 	return 0;
 }
 
+static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
+{
+	for (; nr_pages--; pfn++)
+		free_frozen_pages(pfn_to_page(pfn), 0);
+}
+
 /**
- * alloc_contig_range() -- tries to allocate given range of pages
+ * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
  * @alloc_flags:	allocation information
@@ -6912,12 +6917,15 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
  * pageblocks in the range.  Once isolated, the pageblocks should not
  * be modified by others.
  *
- * Return: zero on success or negative error code.  On success all
- * pages which PFN is in [start, end) are allocated for the caller and
- * need to be freed with free_contig_range().
+ * All frozen pages which PFN is in [start, end) are allocated for the
+ * caller, and they could be freed with free_contig_frozen_range(),
+ * free_frozen_pages() also could be used to free compound frozen pages
+ * directly.
+ *
+ * Return: zero on success or negative error code.
  */
-int alloc_contig_range_noprof(unsigned long start, unsigned long end,
-			      acr_flags_t alloc_flags, gfp_t gfp_mask)
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -7033,19 +7041,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages, gfp_mask);
+		split_free_frozen_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)
-			free_contig_range(outer_start, start - outer_start);
+			__free_contig_frozen_range(outer_start, start - outer_start);
 		if (end != outer_end)
-			free_contig_range(end, outer_end - end);
+			__free_contig_frozen_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7055,16 +7062,40 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	undo_isolate_page_range(start, end);
 	return ret;
 }
-EXPORT_SYMBOL(alloc_contig_range_noprof);
+EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
 
-static int __alloc_contig_pages(unsigned long start_pfn,
-				unsigned long nr_pages, gfp_t gfp_mask)
+/**
+ * alloc_contig_range() -- tries to allocate given range of pages
+ * @start:	start PFN to allocate
+ * @end:	one-past-the-last PFN to allocate
+ * @alloc_flags:	allocation information
+ * @gfp_mask:	GFP mask.
+ *
+ * This routine is a wrapper around alloc_contig_frozen_range(), it can't
+ * be used to allocate compound pages, the refcount of each allocated page
+ * will be set to one.
+ *
+ * All pages which PFN is in [start, end) are allocated for the caller,
+ * and should be freed with free_contig_range() or by manually calling
+ * __free_page() on each allocated page.
+ *
+ * Return: zero on success or negative error code.
+ */
+int alloc_contig_range_noprof(unsigned long start, unsigned long end,
+			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
-	unsigned long end_pfn = start_pfn + nr_pages;
+	int ret;
+
+	if (WARN_ON(gfp_mask & __GFP_COMP))
+		return -EINVAL;
+
+	ret = alloc_contig_frozen_range_noprof(start, end, alloc_flags, gfp_mask);
+	if (!ret)
+		set_pages_refcounted(pfn_to_page(start), end - start);
 
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
+	return ret;
 }
+EXPORT_SYMBOL(alloc_contig_range_noprof);
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages)
@@ -7098,7 +7129,7 @@ static bool zone_spans_last_pfn(const struct zone *zone,
 }
 
 /**
- * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
  * @nr_pages:	Number of contiguous pages to allocate
  * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
@@ -7106,22 +7137,25 @@ static bool zone_spans_last_pfn(const struct zone *zone,
  * @nid:	Target node
  * @nodemask:	Mask for other possible nodes
  *
- * This routine is a wrapper around alloc_contig_range(). It scans over zones
- * on an applicable zonelist to find a contiguous pfn range which can then be
- * tried for allocation with alloc_contig_range(). This routine is intended
- * for allocation requests which can not be fulfilled with the buddy allocator.
+ * This routine is a wrapper around alloc_contig_frozen_range(). It scans over
+ * zones on an applicable zonelist to find a contiguous pfn range which can then
+ * be tried for allocation with alloc_contig_frozen_range(). This routine is
+ * intended for allocation requests which can not be fulfilled with the buddy
+ * allocator.
  *
  * The allocated memory is always aligned to a page boundary. If nr_pages is a
  * power of two, then allocated range is also guaranteed to be aligned to same
  * nr_pages (e.g. 1GB request would be aligned to 1GB).
  *
- * Allocated pages can be freed with free_contig_range() or by manually calling
- * __free_page() on each allocated page.
+ * Allocated frozen pages need be freed with free_contig_frozen_range(),
+ * or by manually calling free_frozen_pages() on each allocated frozen
+ * non-compound page, for compound frozen pages could be freed with
+ * free_frozen_pages() directly.
  *
- * Return: pointer to contiguous pages on success, or NULL if not successful.
+ * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
  */
-struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-				 int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7138,13 +7172,15 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
 				/*
 				 * We release the zone lock here because
-				 * alloc_contig_range() will also lock the zone
-				 * at some point. If there's an allocation
-				 * spinning on this lock, it may win the race
-				 * and cause alloc_contig_range() to fail...
+				 * alloc_contig_frozen_range() will also lock
+				 * the zone at some point. If there's an
+				 * allocation spinning on this lock, it may
+				 * win the race and cause allocation to fail.
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = __alloc_contig_pages(pfn, nr_pages,
+				ret = alloc_contig_frozen_range_noprof(pfn,
+							pfn + nr_pages,
+							ACR_FLAGS_NONE,
 							gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
@@ -7156,30 +7192,77 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
 
-void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+/**
+ * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * @nr_pages:	Number of contiguous pages to allocate
+ * @gfp_mask:	GFP mask.
+ * @nid:	Target node
+ * @nodemask:	Mask for other possible nodes
+ *
+ * This routine is a wrapper around alloc_contig_frozen_pages(), it can't
+ * be used to allocate compound pages, the refcount of each allocated page
+ * will be set to one.
+ *
+ * Allocated pages can be freed with free_contig_range() or by manually
+ * calling __free_page() on each allocated page.
+ *
+ * Return: pointer to contiguous pages on success, or NULL if not successful.
+ */
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
-	unsigned long count = 0;
-	struct folio *folio = pfn_folio(pfn);
+	struct page *page;
+
+	if (WARN_ON(gfp_mask & __GFP_COMP))
+		return NULL;
 
-	if (folio_test_large(folio)) {
-		int expected = folio_nr_pages(folio);
+	page = alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
+						nodemask);
+	if (page)
+		set_pages_refcounted(page, nr_pages);
 
-		if (nr_pages == expected)
-			folio_put(folio);
-		else
-			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
-			     pfn, nr_pages, expected);
+	return page;
+}
+EXPORT_SYMBOL(alloc_contig_pages_noprof);
+
+/**
+ * free_contig_frozen_range() -- free the contiguous range of frozen pages
+ * @pfn:	start PFN to free
+ * @nr_pages:	Number of contiguous frozen pages to free
+ *
+ * This can be used to free the allocated compound/non-compound frozen pages.
+ */
+void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
+{
+	struct page *first_page = pfn_to_page(pfn);
+	const unsigned int order = ilog2(nr_pages);
+
+	if (PageHead(first_page)) {
+		WARN_ON_ONCE(order != compound_order(first_page));
+		free_frozen_pages(first_page, order);
 		return;
 	}
 
-	for (; nr_pages--; pfn++) {
-		struct page *page = pfn_to_page(pfn);
+	__free_contig_frozen_range(pfn, nr_pages);
+}
+EXPORT_SYMBOL(free_contig_frozen_range);
+
+/**
+ * free_contig_range() -- free the contiguous range of pages
+ * @pfn:	start PFN to free
+ * @nr_pages:	Number of contiguous pages to free
+ *
+ * This can be only used to free the allocated non-compound pages.
+ */
+void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
+		return;
 
-		count += page_count(page) != 1;
-		__free_page(page);
-	}
-	WARN(count != 0, "%lu pages are still in use!\n", count);
+	for (; nr_pages--; pfn++)
+		__free_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL(free_contig_range);
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.27.0


