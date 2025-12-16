Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F27FD5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2156B0095; Tue, 16 Dec 2025 06:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963886B0096; Tue, 16 Dec 2025 06:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6006B0098; Tue, 16 Dec 2025 06:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53BEB6B0095
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 112A259679
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:44 +0000 (UTC)
X-FDA: 84225164688.18.D486DD4
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id A50394000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wTVqecwb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885782; a=rsa-sha256;
	cv=none;
	b=dqd5wB545xD/cHKKMkIsFbBSxKlRtuhpfk+JKm835S2Zq5WhMWDxWaSV9s4BPzGYmw1luj
	SeoDfHGU7cxMB6ZUDH8kaFdBh4smE0n9aTlG2FhK7YhKCPBCXDsRZhqv5qThtALw9i5eCR
	yGhhrgOZPxC8xslWjR0XIG+IuJwKdtU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wTVqecwb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xN5jJAgSwm/eRXkZjoPwBrveo7vHXEVsgQJg7CrLY0=;
	b=4rL6xEBM5fOjx5rpTA2zb6TpdysriJ4hX1HIBuvgnIXvctGrYLzhPcV+8dW9yHQeoyEDCj
	43jOyGC10RD8g+p8VPZd3hOxwJbLL5qml43WRVtmHdtM60DnLWTIhh5x9FXLj7/YjTR9Cm
	Eq3yeEwSfGZjdhND7mnTAhRQNgtjTc4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6xN5jJAgSwm/eRXkZjoPwBrveo7vHXEVsgQJg7CrLY0=;
	b=wTVqecwbi6Vn70CnNtMWw5Z5CDkiFw+ql0SaJrJ6uCCeMwNy4AknqbpEqdAhd6djNhLudsFr3
	WIraoTn6KcoQVFQb1txu3LD0L+AYyOD0R+De5gthYTtLx1oG8y1VTxSyTrihqccKR9HGYe5gZlE
	svJambRYBKIIXjJNO7iQoiw=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dVwBg73sCzpSvn;
	Tue, 16 Dec 2025 19:46:51 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 860141402C8;
	Tue, 16 Dec 2025 19:49:34 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:33 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 4/6] mm: page_alloc: add alloc_contig_frozen_{range,pages}()
Date: Tue, 16 Dec 2025 19:48:42 +0800
Message-ID: <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A50394000A
X-Stat-Signature: yph15iy4s7dirbq1y93uz4y7y4c4eupu
X-Rspam-User: 
X-HE-Tag: 1765885781-6851
X-HE-Meta: U2FsdGVkX18PqydVeEYkc9G0WRVfnKWNPXtn+bfA9XzcBjbihRAiVbXBC11ssSMM0TOc2IQYRrB9xu8Jh7DmOzzn3WUAgEmmR3Vt7/c0At8Bb33MHap60BauDpxAosfs4rMBpDKFjHwsFeJItDFG0Ic8lULFIq7uJQODTg/t1Z+W0DZMwLUf1r57VQD8fUg289rvp8fdAMXQTlkGf1TfCqCDSgeyFaJwzEi4KWMOix+X1AyJ8Sd29xAptasVS/K/agEZjwXt026eEaPeYaFVijRF6lS4f2Ez220Ve81UI5S3lpUD3HOmfBVjaZ3vj6ISq0glyIwd2sM2W9KoF+d8/fEpfMB/AkjH2HPYBCq1s1aYXnU0TiAnYYbrlzFnncxbNIGFBLknuM3nQoEa52yFFO7so0F4MRhr2OvDUaJJbPTvdRZA4cs/wioPEBmqjyO5aoMrGinhZOYfJ8fISkwjJZUCip++NMTRB6ZWGJC3xqtUyxrRgH7EL2MkYg2NK44PzcAWcKk58THcRc+oipSETqjOB0+16LLsMMqzZI7ULXKcclhf8gy1jidabgjx59QigDcRnQ9v51tL7kKAvu+ECmywvYsNHlq797z2ozpqUfoy8cUQVC0ROx2ElJS1E0Qjv4sGvPkphnUY7Fo0UQ5t9h4+XRwL4i8wl4jdMJUadJthiLeM8yuCTlZ76KpU6imvxvBjB2oZXpOdVVaVmr0fgnDbYSR/g0dB2YNFGPNvlPWpIp0Q+cumjJae9GeTowJbK08Y0zN2AfYse8fZFoH579tWzFMT2ocu+buA59ezHBLG2qDph2T2kCn4CFNsZfvbUMkK1YpuXDshqPbzbkxfL+LuRCpAQJBvfdc8FLNvWhoXMNqeUQxdN62U979hbxrLG0i3G6kTfHYtgd7Iiqi6Ix/9jfDYprUclUYPxC6cJnAGKJSON2zZvsmZJYq2BGOfn3muKdKuXKPa125FEVQ
 LhCzfJrm
 tBpS9qL6ViycwPwWKEX6IScLiCkaksgxPoY/JM7QODF79zexlBkTvPrziC1BpV/hyuU5DCQgdVaNuYSA5ssJ8ipN9pqpVG70FDPUxVv/qq53mahwITivOxz+nD9NmNyHeG+tgs/iro2q/zeg+mRW9t5hfW94zUP+9oCmgBBfKqzQFeDGCJgwvfoMZTaM8jGfb4OT2w1C6c2t7OnAetKKgKiqOJHNL8fuH1an34pwh0R0rDaGVhn/O7MNeVOY32a90gLBjfmWz11FvVLFzP6nfT+tEwddLJi2ksMBlrVa1dSG+TbyIEJ3y2zq1rWCsCCGiK9V+Cdtm0nygbZkUzwlEzzKdSw==
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

The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
and the free_contig_range() is refactored to only free non-compound
pages, the only caller to free compound pages in cma_free_folio() is
changed accordingly, and the free_contig_frozen_range() is provided
to match the alloc_contig_frozen_range(), which is used to free
frozen pages.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h |  52 +++++--------
 mm/cma.c            |  15 ++--
 mm/hugetlb.c        |   9 ++-
 mm/internal.h       |  13 ++++
 mm/page_alloc.c     | 183 ++++++++++++++++++++++++++++++++------------
 5 files changed, 184 insertions(+), 88 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ea053f1cfa16..aa45989f410d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -430,40 +430,30 @@ typedef unsigned int __bitwise acr_flags_t;
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
 
-#ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	struct page *page;
-
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
-
-	return page ? page_folio(page) : NULL;
-}
-#else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	return NULL;
-}
-#endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
-
 DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
 
 #endif /* __LINUX_GFP_H */
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3db94693a06f..ed185bbca419 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1428,12 +1428,17 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
+		struct page *page;
+
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
 
-		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
-		if (!folio)
+		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
+		if (!page)
 			return NULL;
+
+		set_page_refcounted(page);
+		folio = page_folio(page);
 	}
 
 	if (folio_ref_freeze(folio, 1))
diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..75f624236ff8 100644
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
index aa30d4436296..a7fc83bf806f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6865,7 +6865,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6877,11 +6877,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			__split_page(page, order);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6925,8 +6924,14 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
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
@@ -6941,12 +6946,15 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
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
@@ -7062,19 +7070,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
@@ -7084,16 +7091,40 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
@@ -7127,7 +7158,7 @@ static bool zone_spans_last_pfn(const struct zone *zone,
 }
 
 /**
- * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
  * @nr_pages:	Number of contiguous pages to allocate
  * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
@@ -7135,22 +7166,25 @@ static bool zone_spans_last_pfn(const struct zone *zone,
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
@@ -7167,13 +7201,15 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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
@@ -7185,30 +7221,77 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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


