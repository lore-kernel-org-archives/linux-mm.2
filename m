Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC96C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137A96B00A6; Tue, 28 Jul 2026 16:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1120D6B00A7; Tue, 28 Jul 2026 16:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF27A6B00A9; Tue, 28 Jul 2026 16:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C79C16B00A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 562FCA039A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:25 +0000 (UTC)
X-FDA: 85039363290.27.72583BB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB5112000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FYufSIjg;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyn3zN9b+ph0eRqy5mEVvBJJVMf2FtXLQDf1QYBb7cI=;
	b=KF1uVjoGGcN2zUfdsV2pNXmPY28hEHw2u82LR0IOsQH921CL1RTpl++rNTSxY2vPop0F6b
	8dTI/WVzW9A/LJMOrEBocLn1XQlxOnTg8gzKxf90a1DFEcPwn+cJhH43L9Gm22EkBJ4WQi
	sS6SmiAk58WtVvq77j4Q4Zl8ZiNKGcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271463;
	b=mZfQkaZKzPlmWpi17Rmbhx+7Wd2bG85z/p8DtjYNZj7byaqb77SQ2Jg20t9fmOSCqZ1swl
	M5DCMifFm2Yl44QbA2OiZJ5Ma7VObNAybezwfOInrbfFnAXSYQdBW36V5yVQptAuQRqu/d
	AnxdJdzaC2IGYtrEDGBMX5wlFC56pUI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FYufSIjg;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=nyn3zN9b+ph0eRqy5mEVvBJJVMf2FtXLQDf1QYBb7cI=; b=FYufSIjgd6Htd+cOXXc178/OSC
	AQvbWFvh7dZFW/JlbzUzRCUETMyf4upPt1fqq8vcruj6/ChxvJxbXeExH1+JgUjWCl6kI8HIM2v3P
	Y6lYyuy1Uw6YII6kkTPGsR5G45vPKogFA30vSuXZVmYSH5TQaDlw0EZWQI2vhH35uYCxeqRsPkmjR
	6MnMF74qapN0sDuVmp2AzQAtpxYV32FvV2JsXeDtMAvBKztlJH6rNC+EeD2WDNg+qibsKKUEFX3PS
	8oIvGiOX8KNOc20vluJjD8zYbL3o86rVDVz1fDGj2+M4QLAi6sOBo7xgd+lyl6wyZYd06SmvA/iw9
	obbk2fYQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeo-0000000EFWR-3aIb;
	Tue, 28 Jul 2026 20:44:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v7 02/13] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Tue, 28 Jul 2026 21:43:54 +0100
Message-ID: <20260728204409.3396238-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB5112000D
X-Stat-Signature: nxu3bh4j7ttpezwx1zafgtmu7g7erjdr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785271463-307036
X-HE-Meta: U2FsdGVkX19H1vD9zIRjD0++300WQmiqVqQ+Ujym0eiOjrk3tA8pjeAbn/kQpnPEIOZigYWvTkumDbftqCKHRvmJcffykNhfl20EqDmvsGgpLMkx0HbAg08f6jdZoNTQ7l3zRfeeJ4ZIvdbqmSvpK91xqgBNFU4I4pKgSaoLP2W0ag3zZQgy/zSvn+NJLM0fb6QQ9eHGCiqsRSUoeS4t9/r7G9i9QhfSRdXgfQNCeYZA8RAPr3RBR9Chn9F5H2aWU5naTmA9wgJgOkK6Hqnlwi3FBo2exj0PAFGpC0hUsFWYIU10/PyQZpAZWoFEjovbq5jpGoR4Ief16Hv3d/fAmwy5v9b3b3BPcefoTPJ09icGbHkNMp4ALSlhbZRdivXLMTIcSAZc10Adj4w/Ml6PfaIf4GhgW3fZ5Wy5qjon3U+fJLY1ePWe+LBClpTp5Y6Y+osMeLcLncGAesOUYK2WVaD8LB4XdwvbEgktXn1IQJUTqR6sKieQUzLe5m/RTT1COSfBYv4+z37zs2amWITOzfzeN+F8lmA/JpOfSM5QHj01rEOYdMPKiIGyzuRagiJmksGyl44RGj2jTo7Pmm6FPHwkA//CJwL6LQyMGR+paSIJlyPh7AtYDfl3M/bzbshtqcjmnyokz1Vk+fll5N0K9aqeS45qtMI0ALO3CclQH6WHEw57hr1wDsWSDpaKDikXd3ER2yntOspJddo5TBzciad05Iuvnmg1WLxzwJzhLxV+47+eof8T8i1pYWxejHihm2UchvbCjB/5FOp861z3PXPyUlKDQKIb9BXmpWuiBCZ+DBsOOiuIt7mSG2c5Th5xGuAwL17UVLZyeAembSzRiyznIHgRAPJEg/ZOA5C/HxmhUB+hgF5HJsU1IztU6TcgRiVSAMcnkezfqLeDHLGGfnyLgzNB8thEzvx2Milb65zgXyCL4gH3ai5pnoeabAHtAoj9mqtho9MCpEvinnO
 Fyv7ygWB
 rAgmean/jh7FkAg+8pwm5z8Y+LX+QtWWz6FwhzH0isDYVBqVekC3DsuqkUzYI/90Jw8mgBkwZ/M+Ql4JPgMSo4v9ISs3HyloJYN7sOM7xJUlYc+Z017QMSntB79gSwrcFjfLpsq2W9ze2vPFqY1nreRi3M4szEiMVcZbAmo8WsDDrvTZGPROdP3guHGLbol/oCyLyvYyL49Qa31oo/fveuXsLMzZc9eQirVNLgw8xVDtU4EIOmciHFHZuw6UGj52uIz/g9OvcnhgRTCQhgW7tSNDRUXjcshT5our3dtCEjpdL4tnAsQj4AbkMONW3/uGbjjC+4mNKmRa9yKQI0QODDBXx83XEPzzWKxOPq6Hd1miX8CjPhmheWOn4Pb2lCcvuRNsvYw9yS5VGEw6L1Rq1FJw7/LfVtkmf/VE8wHPQ4N/ieBs3LpBXQHasOAjkxU2htpVyFuhfjwxtJux2jRHj4hj8eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.  No functional change.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 include/linux/page-flags.h | 4 ++--
 mm/huge_memory.c           | 2 +-
 mm/memory_hotplug.c        | 2 +-
 mm/shmem.c                 | 2 +-
 mm/vmscan.c                | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..4185a03a45cf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
 bool is_free_buddy_page(const struct page *page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..353340309107 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
-	if (folio_contain_hwpoisoned_page(folio))
+	if (folio_has_hwpoisoned_page(folio))
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..33007e8e546a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() cannot handle large folios
 			 * in all cases yet.
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..492c9bef3620 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	if (ret)
 		return ret;
 
-	if (folio_contain_hwpoisoned_page(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..70e54ace0e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() can't handle large
 			 * folio, just skip it. memory_failure() will
-- 
2.47.3


