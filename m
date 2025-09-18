Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728F5CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0558E010F; Thu, 18 Sep 2025 09:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13A48E010E; Thu, 18 Sep 2025 09:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D288D8E010F; Thu, 18 Sep 2025 09:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6B528E010E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7ABD5B6D8A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:40 +0000 (UTC)
X-FDA: 83902430640.11.E91E865
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf15.hostedemail.com (Postfix) with ESMTP id D774BA0011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lJMiez1Buz2Mm0M8dDIs9FAxlpDcikABGeJdfWza0GY=;
	b=6Ydr7LTDmXi0n96l1+6XfGtN4Jb4n1+wkIVkb7PF6/F+OxF4auEq2umTkTgVapgoKFFCpK
	9O+JIFdTvlttgYulSTOeuEHumtJKruvpkgkSVVMWn3Fy9XF3wriCGCYhWHH9xti04jP2yO
	yNyp1RryphQ1O8Upic7X8bXUXvz26Ok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201638; a=rsa-sha256;
	cv=none;
	b=uNw5sf6fYsHvYfABuM6nl7RQbkQ5LAJl1sVaNyEUuUozUC2vgLc3AXLaM1xy4vBXP4ZrkT
	ugnRLvWaxtZXl0PThwj+zmmxxcAviErBPSr+910PHWT/cI2tCv7qd97PdlU+KZDWQrGvOD
	E9RmAeLBjmeslHsRlXHY3BqJJpSmFYk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cSGQJ2X3zz1R9Z0;
	Thu, 18 Sep 2025 21:17:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 948D0140296;
	Thu, 18 Sep 2025 21:20:34 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:33 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 3/8] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Thu, 18 Sep 2025 21:19:55 +0800
Message-ID: <20250918132000.1951232-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: hdy58d3ug57d6enctr1jx575wdejfqxf
X-Rspam-User: 
X-Rspamd-Queue-Id: D774BA0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758201637-685566
X-HE-Meta: U2FsdGVkX1/FPO3eF3BYVeDR0Evyfa7D2A7KnJbdwLzuLz4gNk9Vtwz3WBtFw/GIMZUmpelaqZW5PNgnnuKaCnYxNMXXAB+HTX2VWVZkKmzaZORRnv9gqhLQf9QV9p97IYOnJ2kQEgwBmtQXRD1MatM1QGFk4WfGXjZ06knRIJpj5ndNyY4HCUSReeQ/ThTNDaMtSmyy2qa210diMUSqvIIjumOkxRVIFIzKSg9o4ZEDXNCVdbbmLpUrn6zxrqgP18JKw8G0ORiftoGzHPNTdI5TG17LAsR1D9ZosuFrxGAgiFla3kXfGavTu31/puyIizAPi3Zr4k4ZRmomM0ZrklAbFZ6R2U/1SLJ9hSB6XFtdfVCpQ2vCfBPgyr5paXqmsEHtaMIRJpWq0OYojDeJMsbDxMtZsr4S/sDtEvL4jBOnUMjy0l1Uqgv5kGwF147SExFbH5n9eBncc93mQwYm8QJRGromo9mri68Tc/Orn7GYP5q1LH0IBGQbttBstqIaOPiN/UE6lGvQDF8H7CmXfKGSB8MTIPvxbSybyiP4PugXftjZoVZKJ5zBFtpMjWMwmbkk3rigCq7yfGoQwUnmMVpbVGrb1IGgvj+GENirXo0008X01kdtCpEW1Jx+i6OH3v8ZogTCwJedRphZh6lWMPtnSpNstxGtlZF9djHoogr6B2cA7Z7QQSwbmY493yIF+FgR4W6uTHb7QCDbgkiC2N+kthigFqdIKbb6V3W34NO3/YLQka0c2Ro+qluxirfC00uFonfVX2dKoL8TjAAGwYDkv7sXx2qm74qkN38CWJ6PoSSh2zoSHy1t107wf5uY5RPWJRdqD7Q32UGvi3xwmnoXdcIpz3uWYimVU/AA4XY+LReGv48RJk0eD2SPAoMJsWqwyTu8JCWddVuRC3qs+IzrrDqsNLxavK7dVvoz1Y4tx6TJ5qK4VzBYaelCMYBSpa34wclJzYLtmI6rbYT
 x4WaIwkM
 kHr8Q7RIdR569/ffgDVINfHlNPhdEqABdhVLmjXzMRJfCbdKe5GJuOaWZwFRPftvN4HdTRKGZSoI7tggKBxdasNumYQcO8Q/tash96ujTIQKrqBM6gv/9aPdfILVtdx+WPZ9NU9loRU4Tb9UCUlXd95fFrIYEnwcXeWIunE5rbTTWGSNyMGI3fwUzql9QTAPy4XIwP+f2+u0v3Hr+g1/jJ5iwhPXKLkVBsv6+1qwrrTXJJuI1hqfE0Y6kTjzH2zc2RBFtCouO9kAYZVQCQGOaNEubVw==
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
index 5b7d705e9710..b6eeae39f4d0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7113,7 +7113,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7140,6 +7139,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


