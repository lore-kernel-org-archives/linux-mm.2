Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5DECA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD298E0009; Thu, 11 Sep 2025 02:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5338E0006; Thu, 11 Sep 2025 02:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C279A8E0009; Thu, 11 Sep 2025 02:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AABF28E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:57:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A6BA858A0
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:13 +0000 (UTC)
X-FDA: 83876062746.21.FB018A0
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 00CA340012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757573831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XBZE77Lsy020m7TEiqVi0s+UWkO3AfiBnXMYb2GNEYM=;
	b=GoHqg1yz8zq5k5hQksPf6JGRBgnOAJpjhNugVN0Ru5DZFa4VZqJVC+M+FAWRhvpd/gyadu
	Iw7oGD8VrR2WrIc4Cy8KR1EpB5sVQOlRBDSy69rrn8j8S/0pWr70sP+wYbUv2VCS4MUAfm
	7sTPK9cY/4V16FrEVw8zu0X/dV5TxSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757573831; a=rsa-sha256;
	cv=none;
	b=t+MzF1kzrQITK8C6eSjLhDs59H+V25cZNPOWkZF7lDtWToMUd1nYa8rxgKouERCxZ6gopd
	1oY8FSkG16NYSwxAbaUH8moOLD2D+a9gSBThqXeIaSHqg6Z7FXlk6Hc/96W2bf+UhUy1VC
	sF2b42EH/QVEx9GPTwQFjJyBByqjc78=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMpCH5V2lzRkP0;
	Thu, 11 Sep 2025 14:52:27 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CB4A4140278;
	Thu, 11 Sep 2025 14:57:04 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 14:57:03 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH 2/4] mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
Date: Thu, 11 Sep 2025 14:56:57 +0800
Message-ID: <20250911065659.617954-3-wangkefeng.wang@huawei.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00CA340012
X-Stat-Signature: 7k6tiaxgf6oyk6rto5b9khequtu9bqog
X-Rspam-User: 
X-HE-Tag: 1757573830-524978
X-HE-Meta: U2FsdGVkX19AJJV1NeYz1i1ENFVtJkIE3hrzc1SyJRFVxPWLGHekIukEAeibocvAetjb0QUm5b5/sHRsN1CeRzX2UmCtJ81Mg2ACITHyxxMC/dzruWGGNQTA+4j1Y/RowJR5rrIWGnkw515NVLI6tHiAfGvkL8R5E70dj9AVhbKSuiSO1LCsdThWH53pTO9dXxR/vemxL/rPVaHBtdKyhptqtsN4VFwY6PxyWOy3Nsh96MjZvxiKYlNWb+MQs9gsF0BfAbQ6OSl41V9cMp4GY8wB8EyD+tdHk3rrSJelUPN9V46h59PXDblbSc8igvgXJpFdlVKosMO3yCsZc4xwXo2bKKqu1FfHHj6tLdPsyh2tY2bcZPM74BQ/Gn1XTyBcxo40+VCCQPx66qpWdySVVxTimnQliAMyiMEcp0HtSGH/+n8mufeNQBiIg+kZGeaczTMcwf6xdxfk1mIhkhCEG1pDRaY7zOW/l4r6MNKQk/9y1R7ygVc3rnwu1UgR7n3w/odQV9f6OpgZYV8EqtW8jd3HfP+TP5GMD7TkXUgpn48BXYqvx6uIIkjgRlR7C1gxj7BtcBaZV3uzC8/+3DLcGjSxi/shFTGf83O9DqxWLWiwiTx3ZnFCRNG8ahKC3lE2o3BTmSlKn4N2Wj3cBBICPGbLikuweXuwElVFpPKse3XRoevzkphnpEeA4T74guSO8kuFbwxCW39HtrRlsfEJbZ93sCi3vyCgMlM9lkkWWl2yXMPp/ZbzmvHSeu85Z9yUMCkcjG0jcvCaM7S+quXnM7Oe4mh3H7NEEh+zCpTwkMl/LQMlWvFMZH09azEzikukBPt4F1lLJoJmEN+dcfFdTM/b6qX7X3hRB7dvA8u3F5q9EsPif3TivhHPB+uc6oc8q/CYtM21JSKBwhDhMTGHZEwCzefbaUkS5gz9m6gfM0jtFlBMD1bV5PTuJKlgBeB5niH6HHCh1HQmjrV5kYs
 Ed3zapBU
 xFBT+gRc2eLEdIzwZuhOHPY6cZSn6qZU4IfRNyxO63jnmEJoQ+B1xGoVLvahfF15Qz3TudI93TmSapuiz+gWKEGhWpcAn5fzAffT226GJx5tDHqSI3dzu6FPYhQQQGLkE+uGc7tkBoEKVzppFirMB+7zXUNxmi/igy6VlWLJP/OrVPJlv0TLXaPaXpxhOZLUQTMXpebSmnnW3FHH2p5FtiWs5qKzHav7vKqRKKFnPSyaT2vrT9j4jWXk91hIpX4PaXkAX6W4p+ERK2nXmAJu6l6BmfH/j7XAxoDY0SiCJeAR8RnJyyfIOZUvHUiumsCRlU2TtrWT5S0GiqkZFYFQRzjql0ytL3u6/VcbRzXW7w0/wukq2eMb9zxleWJUS+zrOyEZg/wJ+0xCvgOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to allocate given range of pages or allocate compound pages
without incrementing their refcount, adding two new helper
alloc_contig_range_frozen() and alloc_contig_frozen_pages() which may
be beneficial to some users (eg hugetlb), also free_contig_range_frozen()
is provided to match alloc_contig_range_frozen(), but it is better to
use free_frozen_pages() to free frozen compound pages.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h |  29 ++++--
 mm/page_alloc.c     | 211 +++++++++++++++++++++++++++++---------------
 2 files changed, 161 insertions(+), 79 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 651acd42256f..ed9445e6fe38 100644
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
index 587be3aa1366..1b412c0327e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3042,6 +3042,23 @@ void free_unref_folios(struct folio_batch *folios)
 	folio_batch_reinit(folios);
 }
 
+static void __split_page(struct page *page, unsigned int order, bool frozen)
+{
+	int i;
+
+	VM_BUG_ON_PAGE(PageCompound(page), page);
+
+	if (!frozen) {
+		VM_BUG_ON_PAGE(!page_count(page), page);
+		for (i = 1; i < (1 << order); i++)
+			set_page_refcounted(page + i);
+	}
+
+	split_page_owner(page, order, 0);
+	pgalloc_tag_split(page_folio(page), order, 0);
+	split_page_memcg(page, order);
+}
+
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -3052,16 +3069,7 @@ void free_unref_folios(struct folio_batch *folios)
  */
 void split_page(struct page *page, unsigned int order)
 {
-	int i;
-
-	VM_BUG_ON_PAGE(PageCompound(page), page);
-	VM_BUG_ON_PAGE(!page_count(page), page);
-
-	for (i = 1; i < (1 << order); i++)
-		set_page_refcounted(page + i);
-	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order);
+	__split_page(page, order, false);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -6770,7 +6778,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6782,11 +6790,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			__split_page(page, order, true);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6830,28 +6837,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
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
@@ -6967,19 +6954,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
@@ -6989,16 +6975,48 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
 
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
+		for (pfn = start; pfn < end; pfn++)
+			set_page_refcounted(pfn_to_page(pfn));
+	}
+
+	return 0;
 }
+EXPORT_SYMBOL(alloc_contig_range_noprof);
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages)
@@ -7031,31 +7049,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
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
@@ -7078,7 +7073,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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
@@ -7090,6 +7087,78 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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
2.43.0


