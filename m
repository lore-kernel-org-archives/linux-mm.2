Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10BFECAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6AB8E0114; Thu, 18 Sep 2025 09:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6718E0112; Thu, 18 Sep 2025 09:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DDA8E0114; Thu, 18 Sep 2025 09:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D65C8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B72C1601C5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:46 +0000 (UTC)
X-FDA: 83902430892.07.2739E3D
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id B26C840006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vbugJTYwoEbubWCWRuHydPCrQUcC8Q5krRdZs67dAx4=;
	b=PR2prI0Sa2svHXTOjEZmJIkDV/yuktD4Wb71GIRuO3Vv0VpcOZKeIOgEH5ZadKVSgoLQLU
	avOTj0tWdiLzRFOlYfFytrtlmnxv3BOMGW5IOUGYY/J+Rwsb1KMPOBtxi9+8bqbmMnN/Sy
	5PCsIlyKRGMFoDel2gf/4zhufpImQsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201644; a=rsa-sha256;
	cv=none;
	b=W3DD+fG2rUUDEIOS9IGLfkIE7QpXKi+/V5RBkxGtTUHllbuUTAZRRco5oB8lCTD0FBsWr9
	shdu1dF520sJKr44sjCg/dSrH4sDcVsBdVQzLBzD3MFnsk7307ZqeyaxJV00Y0wFAxPY9h
	SACtiv/T2UGcVmkAV/+ikYc/qzdY5co=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cSGP54SdKz13Nls;
	Thu, 18 Sep 2025 21:16:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BC17B18007F;
	Thu, 18 Sep 2025 21:20:36 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:35 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 5/8] mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
Date: Thu, 18 Sep 2025 21:19:57 +0800
Message-ID: <20250918132000.1951232-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B26C840006
X-Stat-Signature: ypucfzkce5t6bpa81cmit1ms3h7jrpkc
X-Rspam-User: 
X-HE-Tag: 1758201643-44323
X-HE-Meta: U2FsdGVkX1/4TcQr2dhFXIP9/r1Dc7mmaED05PpaUZnAYOuqeq4kA0u13joNt6MkPsbNK3jI3Aoej+eJzjdHHhh46+y7y24E0QiCy/jt8iZI2jDbUJztdoniHgwU0FqMf/bkRInMHKA2UT3zqxPKN4SSEa4ykAz+xFKb+xBhBgzLn+BarOlOnj+OBjxdiTucfLFljRaDhUA5ImlRNBjtf0y8D2a/NTx4/G3/+AiQXzAyAamMaBmr77GJoJreOp88tDIU6aZ3HuA+EbpDwbDOA1RCBRrQPYWS2Dwnd4C/D/kB2VOrgZzNMg4xrcT3Ter5nm1GppPfAJz9jf5Ve1YfFC0JDqwLlpxTFOYLahjg0oUZ6e+OqZ61SjZkaGvFDU+I6c8NCAGqH4N813zmqF8gaxNtZvA4TACrSeubWsxMlzNoNAxPy5ekhrvrCi8RnEGzykIOoTNhYQUbmHR9Rn+otv69hVD7yN52iFnrnDeycmdj3MrSpKCimHhZ92QI/s6fFiJL5rLSvWvFetUankVbcYiWfcJID9M9knl8enpr60es5WQYlT9P/R7qb4tnxbrEnTd+2qcU9K5AAN5XNSc+/p9QALqTPG+0IIS+LLvIqymy6CY3ZSevcZrYhrIF9vjfJ7e9RY1mHnzmbRCtMfJquwYy4LM3ULbzD22eVhXAaVePgJV0GzBMJrlJmvITW5nSo79jx4iOnikxGO7h8LojYx+704eC/vvH1VfXEmCBu89mHG/2wsKyw96eFKB8+Ysp82sgEKv2+LVuB3U2HroHZN/kGAzlYE64Vj+776fL5SlgDZlIbfmAxczJjbK9ZkE8dViW2N5PCcPAhsKL4wEuuf0GAUFdJQlUB/hk7DqDAaHWKaUQESereV+rzlbFdMJdGWVeUg+aUbTbFcnEOcah3nx0sMgTwK7DuVrW4w1e+3FB2gVPDunr3bx0EZr3PgAl0Ps8Vaofn76uYUmQ67D
 UhC1lkRu
 yLO0A5SROKhC5YGcgNcYfytke1ChoHt1Idf1ad6A+E0sVqaHOVXXFNuON+ZN5Ckv9ivwegJrjq8wZLAYgMccN9RmpwZDPvDo/SsEJbMCzOw1chtg+xS47VHTgNYtROBSqfUbQBIIY0X2r8KNpPK5P2hD6pcHL0ZkuyothsW2BDhVe9h/ot8pUnIhkOJbtOevgKJbDjv0UeRNtIlvhzG2etsbZI7RwbxLPv897cMwoKvCz10S8/REqaRO+Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to allocate given range of pages or allocate compound
pages without incrementing their refcount, adding two new helper
alloc_contig_{range_frozen,frozen_pages}() which may be beneficial
to some users (eg hugetlb), also free_contig_range_frozen() is
provided to match alloc_contig_range_frozen(), but it is better to
use free_frozen_pages() to free frozen compound pages.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h |  29 +++++--
 mm/page_alloc.c     | 183 +++++++++++++++++++++++++++++---------------
 2 files changed, 143 insertions(+), 69 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 1fefb63e0480..fbbdd8c88483 100644
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
+int alloc_contig_range_frozen_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask);
+#define alloc_contig_range_frozen(...)	\
+	alloc_hooks(alloc_contig_range_frozen_noprof(__VA_ARGS__))
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
+void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e1d229b75f27..05db9b5d584f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6782,7 +6782,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6794,11 +6794,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			split_non_compound_page(page, order);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6842,28 +6841,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 	return 0;
 }
 
-/**
- * alloc_contig_range() -- tries to allocate given range of pages
- * @start:	start PFN to allocate
- * @end:	one-past-the-last PFN to allocate
- * @alloc_flags:	allocation information
- * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
- *		action and reclaim modifiers are supported. Reclaim modifiers
- *		control allocation behavior during compaction/migration/reclaim.
- *
- * The PFN range does not have to be pageblock aligned. The PFN range must
- * belong to a single zone.
- *
- * The first thing this routine does is attempt to MIGRATE_ISOLATE all
- * pageblocks in the range.  Once isolated, the pageblocks should not
- * be modified by others.
- *
- * Return: zero on success or negative error code.  On success all
- * pages which PFN is in [start, end) are allocated for the caller and
- * need to be freed with free_contig_range().
- */
-int alloc_contig_range_noprof(unsigned long start, unsigned long end,
-			      acr_flags_t alloc_flags, gfp_t gfp_mask)
+int alloc_contig_range_frozen_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -6979,19 +6958,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages, gfp_mask);
+		split_free_frozen_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)
-			free_contig_range(outer_start, start - outer_start);
+			free_contig_range_frozen(outer_start, start - outer_start);
 		if (end != outer_end)
-			free_contig_range(end, outer_end - end);
+			free_contig_range_frozen(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7001,16 +6979,48 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	undo_isolate_page_range(start, end);
 	return ret;
 }
-EXPORT_SYMBOL(alloc_contig_range_noprof);
 
-static int __alloc_contig_pages(unsigned long start_pfn,
-				unsigned long nr_pages, gfp_t gfp_mask)
+/**
+ * alloc_contig_range() -- tries to allocate given range of pages
+ * @start:	start PFN to allocate
+ * @end:	one-past-the-last PFN to allocate
+ * @alloc_flags:	allocation information
+ * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
+ *		action and reclaim modifiers are supported. Reclaim modifiers
+ *		control allocation behavior during compaction/migration/reclaim.
+ *
+ * The PFN range does not have to be pageblock aligned. The PFN range must
+ * belong to a single zone.
+ *
+ * The first thing this routine does is attempt to MIGRATE_ISOLATE all
+ * pageblocks in the range.  Once isolated, the pageblocks should not
+ * be modified by others.
+ *
+ * Return: zero on success or negative error code.  On success all
+ * pages which PFN is in [start, end) are allocated for the caller and
+ * need to be freed with free_contig_range().
+ */
+int alloc_contig_range_noprof(unsigned long start, unsigned long end,
+			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
-	unsigned long end_pfn = start_pfn + nr_pages;
+	int ret;
+
+	ret = alloc_contig_range_frozen_noprof(start, end, alloc_flags, gfp_mask);
+	if (ret)
+		return ret;
+
+	if (gfp_mask & __GFP_COMP) {
+		set_page_refcounted(pfn_to_page(start));
+	} else {
+		unsigned long pfn;
+
+		for (pfn = start; pfn < end; pfn++)
+			set_page_refcounted(pfn_to_page(pfn));
+	}
 
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
+	return 0;
 }
+EXPORT_SYMBOL(alloc_contig_range_noprof);
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages)
@@ -7059,31 +7069,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
 	return zone_spans_pfn(zone, last_pfn);
 }
 
-/**
- * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
- * @nr_pages:	Number of contiguous pages to allocate
- * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
- *		action and reclaim modifiers are supported. Reclaim modifiers
- *		control allocation behavior during compaction/migration/reclaim.
- * @nid:	Target node
- * @nodemask:	Mask for other possible nodes
- *
- * This routine is a wrapper around alloc_contig_range(). It scans over zones
- * on an applicable zonelist to find a contiguous pfn range which can then be
- * tried for allocation with alloc_contig_range(). This routine is intended
- * for allocation requests which can not be fulfilled with the buddy allocator.
- *
- * The allocated memory is always aligned to a page boundary. If nr_pages is a
- * power of two, then allocated range is also guaranteed to be aligned to same
- * nr_pages (e.g. 1GB request would be aligned to 1GB).
- *
- * Allocated pages can be freed with free_contig_range() or by manually calling
- * __free_page() on each allocated page.
- *
- * Return: pointer to contiguous pages on success, or NULL if not successful.
- */
-struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-				 int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7106,7 +7093,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 				 * and cause alloc_contig_range() to fail...
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = __alloc_contig_pages(pfn, nr_pages,
+				ret = alloc_contig_range_frozen_noprof(pfn,
+							pfn + nr_pages,
+							ACR_FLAGS_NONE,
 							gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
@@ -7118,6 +7107,78 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_range_frozen_noprof);
+
+void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages)
+{
+	struct folio *folio = pfn_folio(pfn);
+
+	if (folio_test_large(folio)) {
+		int expected = folio_nr_pages(folio);
+
+		WARN_ON(folio_ref_count(folio));
+
+		if (nr_pages == expected)
+			free_frozen_pages(&folio->page, folio_order(folio));
+		else
+			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
+			     pfn, nr_pages, expected);
+		return;
+	}
+
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON(page_ref_count(page));
+		free_frozen_pages(page, 0);
+	}
+}
+EXPORT_SYMBOL(free_contig_range_frozen);
+
+/**
+ * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * @nr_pages:	Number of contiguous pages to allocate
+ * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
+ *		action and reclaim modifiers are supported. Reclaim modifiers
+ *		control allocation behavior during compaction/migration/reclaim.
+ * @nid:	Target node
+ * @nodemask:	Mask for other possible nodes
+ *
+ * This routine is a wrapper around alloc_contig_range(). It scans over zones
+ * on an applicable zonelist to find a contiguous pfn range which can then be
+ * tried for allocation with alloc_contig_range(). This routine is intended
+ * for allocation requests which can not be fulfilled with the buddy allocator.
+ *
+ * The allocated memory is always aligned to a page boundary. If nr_pages is a
+ * power of two, then allocated range is also guaranteed to be aligned to same
+ * nr_pages (e.g. 1GB request would be aligned to 1GB).
+ *
+ * Allocated pages can be freed with free_contig_range() or by manually calling
+ * __free_page() on each allocated page.
+ *
+ * Return: pointer to contiguous pages on success, or NULL if not successful.
+ */
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
+{
+	struct page *page;
+
+	page =  alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
+						 nodemask);
+	if (!page)
+		return NULL;
+
+	if (gfp_mask & __GFP_COMP) {
+		set_page_refcounted(page);
+	} else {
+		unsigned long pfn = page_to_pfn(page);
+
+		for (; nr_pages--; pfn++)
+			set_page_refcounted(pfn_to_page(pfn));
+	}
+
+	return page;
+}
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
-- 
2.27.0


