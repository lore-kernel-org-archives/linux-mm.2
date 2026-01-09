Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C56D167E9
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2B46B0092; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FE26B0093; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC60D6B0092; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCCA86B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DB4B160411
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:32:00 +0000 (UTC)
X-FDA: 84311908800.17.3E595B0
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ADA2100002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5RWvrhPb;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951118; a=rsa-sha256;
	cv=none;
	b=VVR41jJq8Ygx0uXnZnvhh8oVpN86uIbEKL/HmFzKIgrlrPb0sXLmIKfwxEf+E7uJxQ8rjJ
	0332ojicXMHVfKOwLFFEOCk0023QRI02lUktqgeITFz1RTjBilmkpXXtTqryxQGMnwds6K
	e+TOrTUL9ddpDMYCcmXJsvQBCF1Vsdw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5RWvrhPb;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7M9VqO1jtA6x1K/CC9VN77x2bUuBOb1nej1/udUdYv0=;
	b=weYb5g9ZG2t0CTnI/vQQ8qwm6/AgnZxHk9Xm0x6WpJ7OyDRFnFNhlr+zzoRzMpKhF3VtCf
	x/CH4BvhvRVeAX8WulU75QVddmY90/wMLRC4aKABL8OnyNdY9Yo5PQ83z2BTrbLgF3Vdwm
	PSyRCyTDDVE3+GhWMubTBGi/luCEeSQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7M9VqO1jtA6x1K/CC9VN77x2bUuBOb1nej1/udUdYv0=;
	b=5RWvrhPbndNhvJ3ZDAngssUnGZkqc7OBWQ3Fzl2ozC669zcjZLKOVxDdvngzCVxxLa23t/mmo
	u41bMSGVxTGieED+HN0w2bDD+XXVAnyXyViJ3c+LrsV3EhW5v7YqLhR1pyMBORgZ14cQxqNiOlt
	ub/1WZH39AptliDbIRQsXWQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dnbzV65L5z1T4Ht;
	Fri,  9 Jan 2026 17:28:06 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id ADC8B404AD;
	Fri,  9 Jan 2026 17:31:52 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 17:31:51 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea.uj@bp.renesas.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v6 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Fri, 9 Jan 2026 17:31:31 +0800
Message-ID: <20260109093136.1491549-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
References: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2ADA2100002
X-Stat-Signature: 1scskbt87fnk11xsphmuunymmoa8rutn
X-Rspam-User: 
X-HE-Tag: 1767951116-499658
X-HE-Meta: U2FsdGVkX18Kad3OlIJehMtJ+EZAA4R2bywRFxlGLj3Yu28kIzJbb5PzbG6Mky8Tx4rlfSz7FEpokgtKtXzH8gZhm7evUNTzpmxwSMeRwL+VXz0YxpWbaqR9/YDQ2j7/itEXbeVB3W7nvoWX5jg7rrpdD2sPuqIhnRhN13MJzvvAz0GmEgyQn8/b0pFO1XykRkPzD62LkZzhb7FMQGK9L+0rGWawpuvdTI5mkepuJd76ABaJTtCdyI84Gf3GbY1LoR7IPwf31RLlxhCrNZqxc7jaiaEVHEZ3DJIaQDjNfmFvxgqvQAwvpGyXdN1wVAvG43UXYX1HCT/g3D22CH/vL1XyEpunNH4Hm9nVVF5TEVL/MIudhYfxDsfE22S0ysUiOyqHOL4+bWEDF2IInJqaIgU8f48EG7QX2R3IAn5hz/HT6zuqF8gMjNZ/2+ewFBjTjnXqzizTbQPz/yOrPdiN6QV6sgdgLqLCrXuzpQXU8T7JWI6afj6VbZbyHYa+4SXsTzTu4Qwq75i1bX8lY0IwhwdlbNs2zkHjL2wpQAjNceGuP0dpNpG8s4VgCaPIvGCjEWW2VJ8XKRjkk+gGknsQf0uTpsKP3+X9DCX5xLE86guSLoKDWRDQTkKeKSmHvcl9ZL/8NrC3u1DO+4mQ5gwaiNelJP4p73x6yFwZB+P6pKSDQUTupE2tkbrWiRbT5eahG/kORt7NtLJR7Z/zeKvnZWsVQlRUNahagSHvmIirxfEBBkLiNol36URg5WFNK3fUapeqcoO9QrExnr8SfwEK7aHIcn5dIs1Glki0C2QaQJ0amdfOSSIhNlS641H/SyfJCa2Wfepy/1KpSc4G2I4izLRi8tiQ/Sb0qW6Egc4+K4Fa813NSQOX52ZzjiuDyMV2U/MzrSZ4w00ezAO9sFKhmXUCLb4GD2+/UZc5rOFPuwLfDKkNhjFgpcU4+JF6VT1jVHRkkhJQNbxeAMBa9Fv
 AwQW/j+4
 mpJn7iWO4RKfUrF0pGedBT1hM3ZgVILQROAVI4bhFd/vX8arKpXFT+Gml3Cb86irqLS3ReB6TiwLb6/74yvfHqN0KM2DxKe8CkW63X2wvpXlc7I0SLNP8qyo1MAQ4gRGDgt4XyPG0LXZBo2EmXtArEVd/kDtp//WFXrbFRPo3/YXlKYsE8MuF/85OY79Q9bSUsVX4+6Z6k79pgVaT1Z3QxQ69+u/3sCPZGX/dAfwXRKS4xTA51BH2CyNMeyvNuC8qbgdv8nSRpZlFrfHUE1z1cqlBiYJp6mSxYhiihEPDsXelyQdQqP/vUXYUsGNQauHbV1p9ia5GVzfBRL4NmHWfW8BRd1YF/UWeUmugepHYs8SH9a9/j7tpOX1XqG/l0hE5INprj2upFKEnPGtQHljqCQyg405cTxy4bLkhXwSZGmqIJj3PyKTq1neG+Vku+hgCOVhSmO3rvhaijnsUH5Xp4lrbIPJYlc+wvWvRjH8Xqzc7CGOtpp2FPPDopJm+2p6PA0bvYZypAyeC+ISiYVmzQnF8GPWxMcNxKg/Np0laDHbnjUE262w8uUl9Q/h95ivnXUBW4Desb4ohc6QV/tixNeifQl/7l6jUbVWEbAQ2+byy6OA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER instead of
open-code.

Also move the free_contig_range() under CONFIG_ALLOC_CONTIG since all
caller are built with CONFIG_ALLOC_CONTIG.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/gfp.h   |  2 +-
 mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
 mm/page_alloc.c       |  2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f9fdc99ae594..627157972f6a 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -444,8 +444,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
-#endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index ae9b9310d96f..83cf07269f13 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -971,22 +971,26 @@ static unsigned long __init get_random_vaddr(void)
 	return random_vaddr;
 }
 
-static void __init destroy_args(struct pgtable_debug_args *args)
+static void __init
+debug_vm_pgtable_free_huge_page(struct pgtable_debug_args *args,
+		unsigned long pfn, int order)
 {
-	struct page *page = NULL;
+#ifdef CONFIG_CONTIG_ALLOC
+	if (args->is_contiguous_page) {
+		free_contig_range(pfn, 1 << order);
+		return;
+	}
+#endif
+	__free_pages(pfn_to_page(pfn), order);
+}
 
+static void __init destroy_args(struct pgtable_debug_args *args)
+{
 	/* Free (huge) page */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage() &&
 	    args->pud_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pud_pfn,
-					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
-		} else {
-			page = pfn_to_page(args->pud_pfn);
-			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PUD_ORDER);
 		args->pud_pfn = ULONG_MAX;
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
@@ -995,20 +999,13 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_hugepage() &&
 	    args->pmd_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
-		} else {
-			page = pfn_to_page(args->pmd_pfn);
-			__free_pages(page, HPAGE_PMD_ORDER);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
 	}
 
 	if (args->pte_pfn != ULONG_MAX) {
-		page = pfn_to_page(args->pte_pfn);
-		__free_page(page);
+		__free_page(pfn_to_page(args->pte_pfn));
 
 		args->pte_pfn = ULONG_MAX;
 	}
@@ -1242,8 +1239,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	 */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage()) {
-		page = debug_vm_pgtable_alloc_huge_page(args,
-				HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PUD_ORDER);
 		if (page) {
 			args->pud_pfn = page_to_pfn(page);
 			args->pmd_pfn = args->pud_pfn;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fff0d12efff5..b0eba56a40d3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7258,7 +7258,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7285,6 +7284,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


