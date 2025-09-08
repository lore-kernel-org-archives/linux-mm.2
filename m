Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1C5CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575EC8E000F; Mon,  8 Sep 2025 03:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D548E0001; Mon,  8 Sep 2025 03:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A998E000F; Mon,  8 Sep 2025 03:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3837D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:51:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D881A86F37
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:22 +0000 (UTC)
X-FDA: 83865312804.21.358F56D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 37B111A0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317881; a=rsa-sha256;
	cv=none;
	b=yUMi2fp2Ce3442/wzH4U9wOvdNiEbqBywEXX7rdcVyuHOml+tPm4XO3NpiY6oekn8+mM1p
	oOG6Wep4eaRuWsWn/4jzYf6q0RzzjVqRzTK0BE8c0TPSw717g/nqdkt94sJihE7c4zhgBD
	M2IIFpL3lh27h+7d8X12HCvceYGVkwA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWlLIQPSaqWHPooV4ErDwsPilGU41UKwerA8nMa6tRY=;
	b=bfJk3tn7KaeQgEt3HQ0xEKuHHOhOuqxTzsCRjhLh8yH5r5FvDQ8iP4PzBN70F5nujIuFjt
	3n9qOiyYPolMeRXl7nXWY54jtmLAWGv0Va7aDja818OAf2FDcUGzJttpsUFEP216ZAAk1p
	eisgW/Pv8mcuU8/sf4o0IUxPDV1xLvI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2880F169C;
	Mon,  8 Sep 2025 00:51:12 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 36CB43F63F;
	Mon,  8 Sep 2025 00:51:15 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	kas@kernel.org,
	willy@infradead.org,
	hughd@google.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
Date: Mon,  8 Sep 2025 13:20:28 +0530
Message-Id: <20250908075028.38431-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250908075028.38431-1-dev.jain@arm.com>
References: <20250908075028.38431-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37B111A0009
X-Stat-Signature: xh78ha6sppjxfuby6zis59fs7by8ad8d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757317880-552908
X-HE-Meta: U2FsdGVkX1+qMq8htgvj/rhHxyJRveunqWw8tnGEN8xNpGlUEfhCxxA1xknhQrJFg56DyuHE3kwhwfzIX4Ou6Edrw0FnNLrIUEcJFEb46jvRR2cH9TsCsUOnmGlVYgoU+Pj2RFGRRt3YiTLNp6rEsxt0r/bQgpcvxZ29Bwj+MPg/BRgRL7sV63Od/BBhynI+xVUTYCFB2OEc9aziFbznxVB1+bIYqQ7K5NhrSbD8SvJoE1qoCdU3ksT18d9TEFJtkaxV18FRDR4YtLwqm8Kd4+AvkWOV/ouriFGLAXl518LHs2tcgs9PtdAqNeOqGQyypGSUNkP3cMKeMpbpIt2/uXFsKM/MOpTxmHKUmx6XWIBCQctlICHQUqAeOVqgpqcXGittI6xcBO7X4LjqaBVxG/fggm8r2AerIm2nkC4zO9+2N7XvVDebd5FKF3MCZ4S3XNIIG+VBeFtMrqcSViSf0pLrpFgmHgV1rAOXE3ohPZr2BgQReH1jaQq7X+u3bNkz9mZb9oQ4Tc2SCk1KPux/nDA3tk6VQtSAhctsajt9wxIU2N5wLAoZ+Ijf6ZMUdz0BA48HJC5/bHceh1hY28RUXTIZTwe+9K8Bcg8nGGyDjzvXNtlvXdF1V6AsjjETB2S9KK+uGkTfyT8kSEyMJo9Vk7tcDM61aYwCBSwKvHmrJVMlk1axqSHxQUuffL3uRgc3nIXr0n4cllGRpOhotyLar6Dp0kh9+7KIIHa7lIBBISQmik341D48JIx3Jmx6bJD6KSu/TTkc6WtLRsao1Nx4h1BZXxCCG0apvOygDqMMhJDEdzyAicogNi36X0AGQ6+7Erd70rL8WjwTF7Jt/gXb2ORFjUJdj9F3FRmp8Wm4+c0Aec3/sH2B1rcn+fU6NkZxkCMMnviRLuYUsL8OuKz+CRnbx35P79TjrS5z8YZ49kxCM50vSxquZIfarYG/zNsYuqNTv5YxxITPa6tNJdY
 mz2AgfdS
 ReIm7umEcMgZ3Oq6r4vf2lcuiXDUi10QmzAFjKdvG1fceTq4EwSoXTewz9JRwigEPwo9jzL0y+YDioygHRvKh+I2zP5AN0X+zcX6YfQWMd7XBvg6+kQ1JMvb2Kr+miT19uBPYdj1xERFQ1sx8f7RTPZBkV9+vZHJWX4LKiQq7ibBLu+KqweVYk4J77A0zNfexa8DjD7x0qPFfjh4+T+F431dMjT1m6Gke6KENDdvy07PQ1Yr6d4BDc97JpBGyOwxRKrSdnhExYrjtAJVeaVxtBSY2U1GkmcUFN4bphMKO4pTd5tcJqtNMBUuYaPCD1tk0CBqDJGTQPGLa1Q9DCnlyvFT9BzNAkuvYXdVRtbG7dNyVK4QCskjAd9OzSsC5rLcyi+RFjl1+Mx07EtusjcVUCqzrV1qKxHOp6v39IT0zp0acm6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all actionable outcomes from checking pte_write() are gone,
drop the related references.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/trace/events/huge_memory.h | 19 ++++++-------------
 mm/khugepaged.c                    | 14 +++-----------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 2305df6cb485..dd94d14a2427 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -19,7 +19,6 @@
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
 	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
-	EM( SCAN_PAGE_RO,		"no_writable_page")		\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
 	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
@@ -55,15 +54,14 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable,
+	TP_PROTO(struct mm_struct *mm, struct folio *folio,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, pfn)
-		__field(bool, writable)
 		__field(int, referenced)
 		__field(int, none_or_zero)
 		__field(int, status)
@@ -73,17 +71,15 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->pfn = folio ? folio_pfn(folio) : -1;
-		__entry->writable = writable;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
 		__entry->unmapped = unmapped;
 	),
 
-	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
+	TP_printk("mm=%p, scan_pfn=0x%lx, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
 		__entry->mm,
 		__entry->pfn,
-		__entry->writable,
 		__entry->referenced,
 		__entry->none_or_zero,
 		__print_symbolic(__entry->status, SCAN_STATUS),
@@ -117,15 +113,14 @@ TRACE_EVENT(mm_collapse_huge_page,
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct folio *folio, int none_or_zero,
-		 int referenced, bool  writable, int status),
+		 int referenced, int status),
 
-	TP_ARGS(folio, none_or_zero, referenced, writable, status),
+	TP_ARGS(folio, none_or_zero, referenced, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(int, none_or_zero)
 		__field(int, referenced)
-		__field(bool, writable)
 		__field(int, status)
 	),
 
@@ -133,15 +128,13 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
 		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
-		__entry->writable = writable;
 		__entry->status = status;
 	),
 
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
 		__entry->pfn,
 		__entry->none_or_zero,
 		__entry->referenced,
-		__entry->writable,
 		__print_symbolic(__entry->status, SCAN_STATUS))
 );
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a0f1df2a7ae6..af5f5c80fe4e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -39,7 +39,6 @@ enum scan_result {
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PTE_UFFD_WP,
 	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_PAGE_RO,
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
 	SCAN_SCAN_ABORT,
@@ -557,7 +556,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
-	bool writable = false;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
@@ -671,9 +669,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
 								     address)))
 			referenced++;
-
-		if (pte_write(pteval))
-			writable = true;
 	}
 
 	if (unlikely(cc->is_khugepaged && !referenced)) {
@@ -681,13 +676,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	} else {
 		result = SCAN_SUCCEED;
 		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, writable, result);
+						    referenced, result);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, writable, result);
+					    referenced, result);
 	return result;
 }
 
@@ -1280,7 +1275,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
-	bool writable = false;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1344,8 +1338,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 			result = SCAN_PTE_UFFD_WP;
 			goto out_unmap;
 		}
-		if (pte_write(pteval))
-			writable = true;
 
 		page = vm_normal_page(vma, _address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
@@ -1435,7 +1427,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
-- 
2.30.2


