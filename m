Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84106CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EACC8E000F; Tue,  2 Sep 2025 08:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174FE8E001C; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFAF8E000F; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDD348E0017
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95B6B117BAA
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:23 +0000 (UTC)
X-FDA: 83844291006.15.501EC40
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C002100007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817361; a=rsa-sha256;
	cv=none;
	b=o0m/60WPumwUrqWpwJVgI5XPwXbWSqk7gr3ICxK6c1Sdzj+nImjS2qCfsoG9jHghpw9X5C
	DRIxMC0ohxLqXwCWd+7Rb1q3y+e5/Pr/bI4B1LObbDFm++JWWSXOh6ZfuzpiEHswHESyuM
	VT4fXwkGuarwz+z+CJnQvhJIIeoN8bk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R+qu8QHQulvBVzJyUgvepPPe6980yHKz2AHvJ8G327I=;
	b=CgGFqZPFkCwT/sxgz+V1rQlLG0G9q0wM4YAlrocJ7ltzq/DvGaIHy6agy1Vrl9rj5yz9/A
	CAhctwbh/6EE17WcU+de1wbJawnPV1sY4VQRTQK/Oz8xDgByxJPNC5yCtuLTHI8i5n0WdM
	UujCI4Sm2Tzv+BOD8l5vNhZop7L9TaI=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cGQRz4Y1rz1T4Yt;
	Tue,  2 Sep 2025 20:44:47 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 885BE140258;
	Tue,  2 Sep 2025 20:49:16 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:15 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
Date: Tue, 2 Sep 2025 20:48:17 +0800
Message-ID: <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 1C002100007
X-Stat-Signature: b7kch8uyq1ee18xy9chciwfxc6n871y1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756817359-819138
X-HE-Meta: U2FsdGVkX19giPLrgt4t+qf0A5rI06ntEGwuf+NDDnpzZAN1W3szVj2VrGACJ202T7pyKFtBIy/9NmmMfBBHkEDR9OndTf4ezEtHXAjEOfb+rQI0Wou9oLS3RyJKZ3nHlk1YyByzvtJ7hzSvAiS2lgH7MZ922dcNM4NaGO26ty5x9ZhfpnaACZOQ7jTXFQ3K92gZeZ1inZ2fNZOucO/X2Anw31gPvrG3b8ySe/a4X2zb3e/4g4glUsif5lMXCjhxjRHxY9Z+D9fGzvZS+EMFlw3OIX4PgJCtqGotGXaHNfCpz5koQjyMSEb8NYe0whQzApZhN9NtDpFcszA0HX517nwzqdnlAufhOhOkJsjf8DEHTI5kQyhT8ojAHUIvYzG/sT/pruWfmwGE/cYA8JUSBNlr6JM8I41EVxdNHmB0yD3Ire1/66yIQK5CqMUv6UavCa1HoWMW90idTjWhh8sGdFAWiEYe/1t4aS30PNd17I94ZOsv3QFStGDydFISeg1f6si8v2YltOPolKvRCRmELQdIhfILMAUU7Aq83e71fQxCqf7rjW84z0QuVJsxPP4MZeWwKS/KMxTQcby0FGaQnF0KfomwcVwQx+6wPyFhzwrgO3nq+xayHtmWUK6kKaYGZtYIDvGt+r+VFRgm3/ZyNDFyKZLVaY8gs0H82woZddSz4OeBNhTa+NOtwwJK/6dp0RW/uvZv4IeL7R7YNWWR6OKBTW0FWkt9p8u5eV4DXU0Gvu+q/XHzuFT9FL9Y/xwAurLiqHaNasYWDS6F+oQl06klOnFgrS1wfK9rS9Gt65CNw56tdniq4giD1epy+09jmDx34oCnscinGmptS8Avet4qb6YUGWTpbmvbWlAjkGYs9OK5a6nkX1z7GRUaoPamg3V9tDU/eArGI5ZVeYla/69HDxQFA1Jsa2KGcuSVq7O3kL2jqzHlC12wLc6a9W1DzHFWKma/2XE8+ta/rDI
 N1ycn6Fi
 9g3DRvuKwA0Y5+c6ePUUKsLAAW283ywoVoIvqo2ow1MqUkQzuDfcv+hHUu/dVM7eGFFaq4GD/lmcaG+oOJRVmLZHNaXARJ+788a/oFWGcoKeW8rdT+cdTD0uqGCQxsgE2DiP97tfdDtHxSKwgMsj90jV3RoT4EWKuO0lyXzbOvj4UWHKRRDRsK3zszE2h5LDH4hgIJoqY1lH/3pQ8l0TNw7xQvGE4cCPIs7+lGb556sVukD4UPkhHdkllLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
allocate a frozen compound pages by alloc_contig_range(), also
provide alloc_contig_frozen_pages() to allocate pages without
incrementing their refcount, which may be beneficial to some
users (eg hugetlb).

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h |  6 ++++
 mm/page_alloc.c     | 85 +++++++++++++++++++++++++--------------------
 2 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..d0047b85fe34 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -427,6 +427,7 @@ extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
 typedef unsigned int __bitwise acr_flags_t;
 #define ACR_FLAGS_NONE ((__force acr_flags_t)0) // ordinary allocation request
 #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
+#define ACR_FLAGS_FROZEN ((__force acr_flags_t)BIT(1)) // allocate for frozen compound pages
 
 /* The below functions must be run on a range from a single zone. */
 extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
@@ -437,6 +438,11 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
+#define alloc_contig_frozen_pages(...) \
+	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
+
 #endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..0677c49fdff1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6854,6 +6854,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
 
+	if ((alloc_flags & ACR_FLAGS_FROZEN) && !(gfp_mask & __GFP_COMP))
+		return -EINVAL;
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
@@ -6951,7 +6954,8 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
+		if (!(alloc_flags & ACR_FLAGS_FROZEN))
+			set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -6963,15 +6967,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 }
 EXPORT_SYMBOL(alloc_contig_range_noprof);
 
-static int __alloc_contig_pages(unsigned long start_pfn,
-				unsigned long nr_pages, gfp_t gfp_mask)
-{
-	unsigned long end_pfn = start_pfn + nr_pages;
-
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
-}
-
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages)
 {
@@ -7003,31 +6998,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
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
+static struct page *__alloc_contig_pages(unsigned long nr_pages, gfp_t gfp_mask,
+		acr_flags_t alloc_flags, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7050,8 +7022,8 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 				 * and cause alloc_contig_range() to fail...
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = __alloc_contig_pages(pfn, nr_pages,
-							gfp_mask);
+				ret = alloc_contig_range_noprof(pfn, pfn + nr_pages,
+							alloc_flags, gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
 				spin_lock_irqsave(&zone->lock, flags);
@@ -7062,6 +7034,45 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
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
+	return __alloc_contig_pages(nr_pages, gfp_mask, ACR_FLAGS_NONE,
+				    nid, nodemask);
+}
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	/* always allocate compound pages without refcount increased */
+	return __alloc_contig_pages(nr_pages, gfp_mask | __GFP_COMP,
+				    ACR_FLAGS_FROZEN, nid, nodemask);
+}
+
 #endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
-- 
2.27.0


