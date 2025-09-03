Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4E9CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 05:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A7D6B000C; Wed,  3 Sep 2025 01:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23FD6B000D; Wed,  3 Sep 2025 01:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13196B000E; Wed,  3 Sep 2025 01:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDE9D6B000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:46:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79173B9B86
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:46:55 +0000 (UTC)
X-FDA: 83846855190.16.2E90122
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA76A14000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:46:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756878414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o9T6NK2ZKuIa8iNuKeCeSiSyX33OFTO1RvP9FwyJiFs=;
	b=RxT7JxO96UDi8xTi8ekLC3L7VB+RFwmEmd6keDC+YpB55BcPOnYn9pNUrRV+Im2VeIrWJu
	l9FZWcd2s6W9/kd5BHUUV+h/Aa98bWmi4CkNkZHOPRW391/6RaCMA+tbPjLAdLMM5/rd05
	xPcCzk1jaUf9RMAXynXBZ+Jq93gnZ1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756878414; a=rsa-sha256;
	cv=none;
	b=xnLQ0IbpGuiopZxrdCnbDt/OVuP+O6flH15MY3z6bmSXClfILj+6owU/2pZHAdfz4DgzR5
	9QEj7b6J8k0sP8bsUvHPFNCiF59Ct6RhPBz5te+ClCDafUsRKJmjnkp1admqDDG1w4RF8u
	GG6Qtl76seB3TB8omuXGwLF0x6lFEtc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64C451692;
	Tue,  2 Sep 2025 22:46:44 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 923DE3F694;
	Tue,  2 Sep 2025 22:46:48 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
Date: Wed,  3 Sep 2025 11:16:35 +0530
Message-Id: <20250903054635.19949-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
References: <20250903054635.19949-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA76A14000C
X-Stat-Signature: 36pebdt19qsim1zhbrg1azkycz1ekfda
X-HE-Tag: 1756878413-943181
X-HE-Meta: U2FsdGVkX19Ykf9N8JN/CSqKGA4+8XwcGTnoye11sZYf9VAlNHe+VRwiquLumIj42ZMLbTDGzYQqqGmBFqfknvafHdjCN37QMQmR5xtxue6W0gIOPJZl96UN9TX9CUlczW6m32KsDdkKdqhMmxcnVUdaGGjnm5OXqd7rQ9JO4Rze3WVT3Tn8mv3KOcSzi0RnFJKoC9yx4SiPkfg/8KqIm4vjFrFY52TYaTSTogGYFiYypW6ZOYIlQ/3I1gsiI2r1nDYEEc8Cl9qRB3nJb5QRBOUrimx6R+K0ZSUEqjYVHtsudghc8Pp0xPQI3mggaYIyfU1x87paTbHreHd447GW2zq4XEgakeVp+EcbFqw58KbEJq7aKj6bvxFTMHvJCrE1Eg0iGsLirX1aTzjo4wYlxXKs2wR8bxrfO8bAIoVTSr9HJCVTX5503HjOjilDDIxTVsEt+d/WFrqQk67aKa9EieXXauTcp/Jf9hLC/kzeaMykpBoQ0t3H2OG6mOY60l9B4yoa5ek8jCvQ+zojJc1LegxSw77RCLJx8xmZSB149vmQbDl1K9v5pbfTuJAr0dhqMyQV7lQhWcfEUEpysxJ5W6M8IJaAXs27FWoN9e3TnZIVNwPjLGBitodTdXFMkOqOqafMhadJ0BZWwhkUggDcm9x+OMHSHpYnuSvM10Ggq3IYhzNIvIuHZNTXc3WfVlxKASsd7ieb4xq26aZfEGTYeAgh0kZIJv36xCxYEJh5b9slZHMbeqcZiUgQGF4Lgz8CzQu72C3nql3/WqcAqppRo4X1fUXmT65bc8Qq5F0qJY/k0DwVqL1FKoc+KOjJr1uUmPOb94v0CiqEQcxlCBtl/80whDOmjaruAcT0+Hu9EVAzn/Lt9zr8Y2n+C6cif7wgy7vpgVeeGlySEaDtd+oewEdlKN1f+Tf/J3PgKUHytplJ50a3niCcTZDkls6yz+d+9ZLREQlcPcfYRo0d9WP
 j5KoB3AI
 ME9tl6eOilYUghvfBPaIagHEacxhIQneH6AKw2ccSWJNdSpF2AomGGtQF8W2t+jHceL94H1Hb5V5B1JdWKpgk5Kjhsho4qmULCUcIS2EWgR93dGFJkBsS1R38DojEJEM1iJqogDoFU2tk/+lSh5v2mnU8HxXVk/4LvfEnQsBzOi/Y84kTFeJ1tbDXE0073DLoDrYkCI8+Ulh6k4NP9bO5FQpOJpLzgwQGJkqHVnAH6Qr87Ns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all actionable outcomes from checking pte_write() are gone,
drop the related references.

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


