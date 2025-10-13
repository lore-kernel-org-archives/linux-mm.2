Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30013CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3278E0049; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A928E0024; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0AE8E0049; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 968BC8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47375C0406
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:43 +0000 (UTC)
X-FDA: 83993201166.22.D58CBBD
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2FA3A40014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r+slsQXs;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Glj189WG52L9dbVo45AVCYFbUmCvc5QnVMuNcbvpfrk=;
	b=Wn2ZZijybvLHfG6tSWaESn8tazYS7ggduMoV2bcOW0XgCUfmX9BqzdlyJXqqHloaPQdMZI
	ad14urzF1YBIN5IdHDPGrg/vRyPdSqvNC8EKIUel6ayBWpAhZDEW6S38qGL9PpSAhJAT+n
	N7mDQPunYG7eWK92wfMWO2wKZ2apDqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362840; a=rsa-sha256;
	cv=none;
	b=02z6lki9JDpVzOLsSciJkTJZe3u0PjgESxcxTJVLavHQw240sXSH7vg7h4vbLH0foCyUzs
	GnVlRu3V1K2shhas/pFczVT+BqP3wnQ76fmL0ON8ZUyddvapAEK/lvSuKmUdRjI0/gbvvn
	7h6S7C1sd+Gzm5vBzKqTcsXRWIUEDgA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=r+slsQXs;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Glj189WG52L9dbVo45AVCYFbUmCvc5QnVMuNcbvpfrk=;
	b=r+slsQXsMfW+j4k9rkys1CbHnA8aL6HCZwl4CrVhDg3IG0KSeca8WdMSV/Yy3WbRms6ioYJtA
	jqGqb6lLhxPwpS8vAQVYE3wQyucwDbLsBtTJXLVums84692kfDX5qB7A1/dpnmU5rCVTEG7KdZT
	YvSnvjC5KSwlX+vuQapUo30=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cldl46sXYzRhS7;
	Mon, 13 Oct 2025 21:40:16 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D444180064;
	Mon, 13 Oct 2025 21:40:36 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:35 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 3/6] mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
Date: Mon, 13 Oct 2025 21:38:51 +0800
Message-ID: <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FA3A40014
X-Rspamd-Server: rspam02
X-Stat-Signature: mckrtddzha1grjfkwmzgr3bgtfci46oe
X-HE-Tag: 1760362839-274461
X-HE-Meta: U2FsdGVkX18Z99nW19GZaWQWZ7K2uiTEf6Pv782oEPEgUUqyo/GWiezpEz3eOiVL/1KkWPp5LOd1wf0uHQqqj1YGZyukAi6hhTy3ChnTc0qdRHybDnfW087YuM6vIv+n0pWJANrG4vvNeRv3tWbPcRrEfMGQGgUMkWh/Wm6OK9nD03kGjNT22kSVDlH9+lWpF8Qu3V3gY/N5wuiculiRP/tWbXF8Hie5Mxd4DU6cT6VOi5gbV+JaxTURLCA2MENgp9FuHimBkys1y45cqCgHm1PeBWDXrRbLLkQ2pLwW/y4u0oZEf5YLPs9fMTcjl6U0INVb0a/frsohmhBJyUjX5HlHkLVMt1IbKAzKaBYIQhPr8TsAcG4SUPmwNq30WBGam2GCeM/iy2LzELPRUuwVA+NY9RIt66j+H+o42XqJhePX6mXoCMBXW+c+0bykEzcTT8voB6zWTclY11lYOcVRZgCv2Bx6yhSnDHT5R33kimA4jKD2sJhRqIJrJfy7bmnT6Ilgusls8n+XCDy12PEJwFLeaq7bao7BhVg3A+ImgaJ2GaxEAzHBC3M8SAwjPa4QQK+HzdDYv9o4SC8GZINA3A93YP22OmRQU2QChM7GueNWWwhPGtcFX5QNED5Gzh2YyWAVj1oQQpVj7ShgVxQdjhhp0CQjTGANQR3Is+Bk110VO1HV+XFRzKMQbcj9yE/ZQ/tjncLw6Y6Fq2geDluFq18RNtrfSbddlLtJ+aVNlhncimUvgyFc3xHR9XwyUxbZnSdBv+SjXAXJGA72KaEE1GmOLl8/JxCegZuUtQNtw/1n8jGdUeVkeuoTqCVUZYgQU/Yj9SAcfzOwbuMpzCjkRzvMVitbYcdmj0MPYGrL+TuZPXpDbvoOuLjzgyE7Pug9zKE7rSWhAy//h+DwFnPvlKN+kz/P0Qt/L8FqIPCFTuAERXkP4jUF3fyXB25gayXWR/aGBa20D/rDzN/rN4s
 Wz+G5u3M
 iznImTMOpCISdNzHdz9rCcRigv6IWg6jQya20SMO7NfkCDkw59McJQlCryvnugMtcwBq/YWNMmwdQHE8jzmx5l73XZ/Urm40MnXvBIVOyLFWg52K8QU0EzpauMuIiEj/T9WTUBliT9qJfNmj72faU1o5QcFjumS7Y/F3y2dC41v9jBe8w/H9LO/k/bnkM5c0b1yV+5ICahbrEnfI4AKSX8XBtCa3e+X9wu6amEL3qr+lOXZOdVsgO+EAIquzfaxpueda8hrJcu/hdtYpXd4RX5mDxNX533yxHtKhn09DuzUcDqYXMz5zlyvIJTCr9W+PSOg6DkgWtYvkggDGblAh6q+kz5g==
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
index 646a6c2293f9..3db3fe9881ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6806,7 +6806,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6818,11 +6818,10 @@ static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			__split_page(page, order);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6866,28 +6865,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
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
@@ -7003,19 +6982,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
@@ -7025,16 +7003,48 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
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
@@ -7067,31 +7077,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
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
@@ -7114,7 +7101,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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
@@ -7126,6 +7115,78 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
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


