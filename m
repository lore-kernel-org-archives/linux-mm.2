Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE97ED5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD6B6B0089; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552C46B008A; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434FC6B008C; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32F586B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBA0F13618E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:39 +0000 (UTC)
X-FDA: 84225164478.09.D8C3DEB
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A70C1A0017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=grtcZI9r;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885778; a=rsa-sha256;
	cv=none;
	b=FbvsbMoBkZShrmia1WPEE0EfNMJ9ZjojpX2u27g15FV5M4DW65qLiyxBThNpwkPDsWlX82
	u51ldWs/skEpYnyyuAmZ0JL+YN3l4SUMBcTQpiyIp8i4R19KuRewHqdzDo7vRztnh4ejUa
	88zXlLNR0iyjRLlidQtm8nAVIUvNTHo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=grtcZI9r;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSVkPtXCQLXocC+JKi07hcooqPzN0ZeYtdO5Gx4kiWs=;
	b=im2WNnj3lGnE71gobwlecl0CDHvU/Ohfm9MMteGKRhweS2h3Pbh+4g+Uy13jKq3w4W+zYZ
	IvvTTeoCEkZv0PifuKsAoApaTtJnfAurm6Ly/9K1GXI8neaHEGnEIiat7+386vGRrtwe/E
	F1LgTzNwn1ZN9AMDmd3IvkZthClLjPE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QSVkPtXCQLXocC+JKi07hcooqPzN0ZeYtdO5Gx4kiWs=;
	b=grtcZI9rzAD+MDdFdoEnrptCHoyiab555TXn0seZgZXBDDxCMCkpPPJliP5Vi8yq3t6aYLJky
	M4ldDQDYmaN2IK7MT7eKe5slafXkqWy6dtyHUfCXhvztGn2Y486G9IYNt1iCCEZteYQKvawv/ot
	rF9FmlwAKTIwIkIGgbnz5Qc=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dVwCF2cm2z1T4J5;
	Tue, 16 Dec 2025 19:47:21 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3FF26180488;
	Tue, 16 Dec 2025 19:49:32 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:31 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Tue, 16 Dec 2025 19:48:39 +0800
Message-ID: <20251216114844.2126250-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A70C1A0017
X-Rspamd-Server: rspam10
X-Stat-Signature: 4oze7x4uaxyu7dswf1wfbgcazms4s9hq
X-HE-Tag: 1765885777-370246
X-HE-Meta: U2FsdGVkX19phhOBaqauyM5xq5uls4druJiJEQgV6OSL45Ob/JjByPVoYYT8h7GntGjxVUMjd2B/stYpc0J6+egfxpEzWZyKaZoggmwQnQOqCN8d5FGcZ+83wjXUis9/UDYEDA/D97BxJRAX2zmQ8BYc1NZ9pRkSfCsybS5aZM+Qm+TWq6Lx8ye0sk/upiffOFT1nUeJLfxCMNOBVhdv1NPlbykadQCdnOgQQFyYPCeaPpPJbhWR6CG/3JVToN5rBCCVQcLBQuD40rGGUYPqCRrFx5aoFXGiVEvUrCredX4rIeba0PZT7FROp+/e2nGOu3ZdjKba4C+vci+RjZfs67XiencP2EQyY2lxEYXWimwPKm6ORJ6V/9eZ4oqyYFkKhu4CCPo2xPkuy9jpoA5orlCDw65W4veZd577+uQeRbp+/FsazBKxWdHIn3aVw85JCh1lTLV/ZOgvCqc03V41hXHDMctYOKKXufOqlUP/WKmptj9C8lFd3qiGd/u+xrGRQP8XlOnCYD+amhlHSynQ6DIk7Rf0cob3YLnVha5tTwQVufJemRAiX+DhTdpmZ2O4+wsiaJ24JGzHKyMf6y1UVKILsYDcYIjJrgPKBFUZ6qi+16mQAeiMOa/vyfRbgJRfGKobwhtXCy4EEuD3SM8cAoDfBziyTpjWCZjuUqkFWKBfBZCS+/jnRzDZvLQh7c4gRGmjAjENYyhqCfPJM2JRl1QYBpZ+Vx5pWlEfV6YhPVCkytoSzdRD+oN43tJaG6XZjPkRgSZDoaTd8IRGHGP6ksVKS9KKXlPmEh52mm91R5Qk/Q0vlovOsCNO6GB6lx3sgsXIPVu6+8i/KdyC46d1M9pMYB2MvS4rhdHZCEgZ73DqBRdQcyHNWayHO/z0ts/TMJhi0npaHcMC68CcAFZO4QX4MfbSVtKaxQb7C+F3LcHbEN33YpXY0fv0uqP2fdPiPwqUo1dGAvW+ivOWn7y
 hNT0bSX4
 MD1iCEL2iytoFZm1LOAJq3zDVk8uxlj7uM3ktoUB0n+qG2/zsxzF/u6VVkT8WFVqoEdzltujzoo2RBIoSEc9CsCA9eYHg2Xkqp48BJgl6e4hc48gQVU4S32NFFJKnyUn0ciN2j3uCM7a34dreqXoZc/ZHV8SBdXwuVnqJvCJsmy/Vtg4oVt0/EqrSREHO5DxSkI8nvTLe9AUHhhhZFUartRUdZG76eH16zkRw/z8jsWgG41ZS3qrq2dDc4+jwRDXxFbGTiGFgVKeuOnKFBTZWvH/YCd5AIzRh4OczxiQINSisI7l4IA95QB+nyV4UDoPJAncs
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
index b155929af5b1..ea053f1cfa16 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -438,8 +438,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
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
index 5bb3a7844abb..da32397b4313 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7180,7 +7180,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7207,6 +7206,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


