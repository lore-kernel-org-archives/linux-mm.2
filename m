Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8975CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DE68E004C; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D488E8E004E; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E448E004C; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7478E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62F968693B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:44 +0000 (UTC)
X-FDA: 83993201208.06.55AC792
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf01.hostedemail.com (Postfix) with ESMTP id BCFCD40005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5h6bJJ34;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362842; a=rsa-sha256;
	cv=none;
	b=zdImWGgo/9KnmrPuw9g3vhxVsugWzvNUF19ayJkVe7P4C7UQ11u4eDp2zvYB97fNJEVa/y
	1o6eHkSyx9xBDQ5LRPkDaxwrpXmZ+3mlK+OU2WFhaMHaw85PwFpdeCXpWVuxs69SNRGADw
	DmZu3BttuFIp+JJtzy4LEjPApy71eFs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5h6bJJ34;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WQOJdBjwtT8U6l4Wx9IPg0W/dU+vtG6fDat4Rz0MDM=;
	b=GgWnuwym1MMpXVTrU2Hri0qn21G5ZyzsEkZwVEdBFGRComGHyx023qNXJLFut8JJQLbvsc
	uiJvmXrmOxHJQZs/S0IfSJzkzJjrwn0sIsB7cybQPLku4sk/dODkD8+ppqnrMI6zl/nHyy
	irocQylDZ6voI0r9wToZUe7gi31dt+k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/WQOJdBjwtT8U6l4Wx9IPg0W/dU+vtG6fDat4Rz0MDM=;
	b=5h6bJJ34MHEkZE6lzWmbx6BN1puRpJunnu7CWtFwuCK/BXIla/r0D4lZYQF2RmHBVvfwRBvvD
	Uo3+32MHdzlZ6Miutw+iy7hPGz6jZPwMOTzfug6kcjdPkOPP143vzIZzzp2dSWDenAcMsHkbWnQ
	aosddvOqAswKdCWj83nr4d4=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cldl34Fp2zLlVL;
	Mon, 13 Oct 2025 21:40:15 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C16C5140142;
	Mon, 13 Oct 2025 21:40:34 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:34 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Mon, 13 Oct 2025 21:38:49 +0800
Message-ID: <20251013133854.2466530-2-wangkefeng.wang@huawei.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCFCD40005
X-Stat-Signature: 86uocym4udtj7um1uur5q98g6ntza8fy
X-HE-Tag: 1760362840-833259
X-HE-Meta: U2FsdGVkX18ENDBdV/hL1maufQ0MrRpeC0qwGPWlj9bPZgz1OO2M5/lQ8bXb9S7+1+jGxKe8e25c5kOakChdZoObvWorfKZa5mLyDI8csxN7VJPcGJkKZ3mhzQ6OQl+U5Q4ILtEGZ5H/WvgdQcxfX+SbEuNz5UGjP2WrgADxHfIzEeO7VYpYRY8DaLZxpujsa4vgQUc8SOD9bOUSQxszlc+jpT41dNhAAU0bOGHlXTT2h9uDnAaRpgOzdqz2WJqbjItczuevOs3wgm4SdODfeOXqnmsdmouYfMhQZD1oZ69KOZ3O5uCmVmdnqQWr6J5l6rBcvYHXdNWbAU+4Vps2Dc2d+yMAl7PIZn5zkz3wHQvlOq6k528jY+lK564DpFPZ2Nv5UmJooMFJtuHS3eyJrXWR+mI6NLJpPu6/l3xMlDHWfRwihtmdodEDA5tkIMg1qzyjV1m70s+wBr+kBwcWnq7QyEWg0n+TpVKOJbLytX7SMagmDpH+zgVIOo1Bi7h/7GJHIM8gWgCuoMssxur3FZY0K9udjLgzRGgMQJp1e2xSLVG4i7H+/IrE01jvBLrXHJWSLGEuWm/QdLCcYIesJZVOUHpSABz/sNdsPr6oFYqpbG5mJBDjoBWIbGRHEmJKLTHmKbexUWGo1E4EXqgC/FV9Pf3bGJZ8m+i9eX8yt/1nVvDwsW4UpQjtXlb4tuuef2XCMLj9YeellPOOACUT3V4Bw5B/1ntoJtSgij2N0MisnlVreCiGLv+QtzBwc5FochwdQp3JyRiBJAXstIms8o2fOI93cSaOfOHlnXqlHPJZlmY1bwffqI3lG2JEi2IhEeuEJ58gxuVkatC2j1qiytyCrRbPoAXFP+mT/1qyli6uk4QExc2JewrTxM3lGlTdu+N4XW+FAg1ZEqts19ogXOt63OqwD8rE4ELCG1JgS8uvrkhZPfM5UxmRFRUX2QkpOggl68L7L39ElQe+FkB
 +/uOj5Ma
 qVAbHEXPFhqGUaXssFO2dy76pnxy+9umoBbpWfodI9ESHdB7YPwlIAsPEOQX7ma9f7v3f+WHXK4oNFNGHS+3KtnutcmULZK7WvtbX4rGz+qc7TCsfN0YQblAUt20jflyoFp69kH6hjX2YYgwdCz/QmKrc4kq6gg838kfHyncr83fVlpUJHz6/nfr1QFoLfoVaQCgC8zFvhBIYEE3hqrR/Yjztq0jwnJisj7+5Rk0lCQPzgIUFkaZZbm1ilmiTKnmBzi3XD2h5m52VWi7t+1CxnNH7+4t6+ZIaQWNUTskKd446IlBYjwu0SO3TCWQEDqwc/HeopjuHdlOAAvAKpccFGBRnATOZLxvfQwxsCVHOk8oTc4UA5FzV80eedSDj0QmFI6HFu6LvKiy43Vw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
instead of open-code.

Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
since all caller are built with CONFIG_ALLOC_CONTIG.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h   |  2 +-
 mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
 mm/page_alloc.c       |  2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..1fefb63e0480 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -437,8 +437,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
-#endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..d7f82aa58711 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -946,22 +946,26 @@ static unsigned long __init get_random_vaddr(void)
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
@@ -970,20 +974,13 @@ static void __init destroy_args(struct pgtable_debug_args *args)
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
@@ -1215,8 +1212,7 @@ static int __init init_args(struct pgtable_debug_args *args)
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
index 600d9e981c23..949b01f293d4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7121,7 +7121,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7148,6 +7147,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


