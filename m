Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E612CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFE86B000E; Thu, 11 Sep 2025 23:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97606B0022; Thu, 11 Sep 2025 23:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD4B6B0023; Thu, 11 Sep 2025 23:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C51016B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ACCA140659
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:19 +0000 (UTC)
X-FDA: 83879170158.22.4DF1D2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C88ED20003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGuFZ74W;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9D76zFALWSml5Ic9rb2rWLYMf0DSBysHFMFaXfSgyWc=;
	b=6iF5NEunwRF/MRgphqo3aPYOaRsHH+sGYt603Dp1rMthhta314YNjbvtij4Ys9duDLBFLW
	pxpTveTvF4gaLd3zklclQ0pZtdkKOwJT42JRxoIMpkHmLe9hnA/QK+75vPuvGVAN68uEby
	BTt3MjWXhZBKouhuL+ozIYzPHTybd2A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGuFZ74W;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647817; a=rsa-sha256;
	cv=none;
	b=jiMGMs0dHipDqsPAwL+NO0m2P/hCv1pIJjRu+KeLay8Ux5gpvM8mTYti9inCp8ObfSN5nR
	TCW0++cu+OT71dpTh29LDx1EjVV1J85t5hB9lCJfY8OLl68oN3c7Lvb7rlu7fBefvxTZ2u
	oUM0Nbs8rGPe/GqkussPEw5mPVsUEls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9D76zFALWSml5Ic9rb2rWLYMf0DSBysHFMFaXfSgyWc=;
	b=LGuFZ74W0XGO9dCzar1fx5vgQv+mFcg/h6QI+mRV2Rom8z2lHM5Oq7u84ZevFRJ8DtVr2k
	vilry4dtKTBKK7HBFyzELbGQzfaUaMlN6RZM2oBZXtbSh//m3j+hMz1zJrVHIfGX91hLAv
	KaOSI7z+gO0zKsXfWQXCY/Sq9Nnx/Ko=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-ktzECp4YPJ-kuDKK3ZLadw-1; Thu,
 11 Sep 2025 23:30:14 -0400
X-MC-Unique: ktzECp4YPJ-kuDKK3ZLadw-1
X-Mimecast-MFC-AGG-ID: ktzECp4YPJ-kuDKK3ZLadw_1757647809
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8244F1800366;
	Fri, 12 Sep 2025 03:30:09 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90F4F18004D8;
	Fri, 12 Sep 2025 03:29:59 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v11 05/15] khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Thu, 11 Sep 2025 21:28:00 -0600
Message-ID: <20250912032810.197475-6-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: 1jmmfiwszi6d949ax7koqcd8g7gj1yn4
X-Rspam-User: 
X-Rspamd-Queue-Id: C88ED20003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757647817-245185
X-HE-Meta: U2FsdGVkX1+raPEW7qZnvYKCKmn1rqUAJiKMgIVmT/DNB0tUEL7/77cXVM1Iinh8jUgxcGC1nOAl+Nxl74b8wh2RJJsfkFX7a2Fu270EqzpPh9n9t2wg9QGMB2dP3bXPOQjPVcyJCYVAkkpZAOISrSiJWEnSdQA1qGY+CYwjyoC65HvbJi8sGPMqiqqkCZHctNzOg0kz9ukhNukIz6vU5AoqYxZQ+H7Mcmm77I+KA0b4WiMj7sRSONPgKKduxoCTyS+Bb+CyEk7CWDFL/zlx46ae6agFJUEyFMWMk3mLG6503zauk8D2rUYs9RAhSymcpoJW3J5R6YELDvV8dBDYZg18NzEKcFtchIthlQE4//FsAiIRnu1sQ11takcXSn0qbGAq4pzE0w8kqtp3CUBEPqGRChAaovCx7cJts8G17PJb3HSHmhBPNxqhzYQG3p+Qj7miY1DEGnVfFPcfMbVPG5GfViNwkPiDG3rKkdQJLfm29UKpJYUHycJ+e/MRYeU4Lw3YSCkCYc2F3TrO9DbmDEogwEb85dMJrhB/q1UUrQX1nCPKFxvpe2+VB255L/EZIX4WXrn0z8BQuHBky+MjlsLG6/xCDlyhIQfQp2DD9FRYB28JuLIh2fTzKIqy9stvt2pe2RnYLlCwwg5ySybJxIqEfDxDkr+bsdI2wbyDa5/2HT6Ja8YpeWlGdhpW7WwZYKZzNwtyP/JNp5o7PHWCjAy9uwEPuY2SHvfmCX2+pj8EjRY1iYD6/HCZPDFoHxvrM/fZumFwulrSzmUmotQnAvIKgKiNmQNhzsIIrktXF5SBj3fZ6HdV+2jZx6l6SBrETYnVlbA4IlbJN36y44AokPw2tSsJdroB8LRgCFMi7oyF7rQVclV4cr/AokQkUxBrbFpUuIqmcAzZ2Jr8CQuSSyUQJAFThDz8PR+TpUVLLS90atkWkRS0KBZauRWP8thUBq8mBIFKQQfT8Xdetk+
 6rKb9tk6
 +wfcXwYHcNN8GqX4v3WvjIZSSGFeHgD3c+G4rmOC0Duwx0Vud9Q7B53M5FUsvSvPGg5bLcBtGZpjJAxMPH1yAPRBhrfnpDBZ4ygt8U0LFZwn7r+Vx/WieiYXXfxtCTAXMQkj+0ImMnjBZTPii6bnrdGNbDCN/hh0Ur6Yc9IhaSRH6573XOLm3h7F6wVuz+WR8dr9bf+f3pvMbtXVuLYG/GPsOFH1AYNI9Bu6AfpyWQzvkIwd1ISZ3m+F2wkoqNu2Dg8oybt+enxXCAmJkxG/K2eHQL7jM142Bk8mpCxVPTezNGN0sCJkHUcCMU70FFBnJ+e+dg3Fd6ISGEjJfp7yPibmMzaUgULs9PxCjUq0e67r4Js432tHIwPwU/r6PtIGfvh0+apnFtphnxGnoBXbfVz4wzOuEqXjiISeUdMAl6iQim5NXowSVTBCBxe183jy+6+9XItcafQ81efyxv4qcasXtA7traSJmLVbt7tRs8p0btQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generalize the order of the __collapse_huge_page_* functions
to support future mTHP collapse.

mTHP collapse will not honor the khugepaged_max_ptes_shared or
khugepaged_max_ptes_swap parameters, and will fail if it encounters a
shared or swapped entry.

No functional changes in this patch.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 78 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dea49522755..b0ae0b63fc9b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -547,17 +547,17 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long address,
-					pte_t *pte,
-					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+		unsigned long address, pte_t *pte, struct collapse_control *cc,
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+	const unsigned long nr_pages = 1UL << order;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none(pteval) || (pte_present(pteval) &&
@@ -565,7 +565,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			     none_or_zero <= scaled_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -593,8 +593,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
+			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared)) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -687,18 +693,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 }
 
 static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-						struct vm_area_struct *vma,
-						unsigned long address,
-						spinlock_t *ptl,
-						struct list_head *compound_pagelist)
+		struct vm_area_struct *vma, unsigned long address,
+		spinlock_t *ptl, unsigned int order,
+		struct list_head *compound_pagelist)
 {
-	unsigned long end = address + HPAGE_PMD_SIZE;
+	unsigned long end = address + (PAGE_SIZE << order);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
+	const unsigned long nr_pages = 1UL << order;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -751,13 +757,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 }
 
 static void __collapse_huge_page_copy_failed(pte_t *pte,
-					     pmd_t *pmd,
-					     pmd_t orig_pmd,
-					     struct vm_area_struct *vma,
-					     struct list_head *compound_pagelist)
+		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	spinlock_t *pmd_ptl;
-
+	const unsigned long nr_pages = 1UL << order;
 	/*
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
@@ -771,7 +775,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -791,16 +795,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  */
 static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl,
+		unsigned long address, spinlock_t *ptl, unsigned int order,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
 	int result = SCAN_SUCCEED;
-
+	const unsigned long nr_pages = 1UL << order;
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		pte_t pteval = ptep_get(pte + i);
 		struct page *page = folio_page(folio, i);
 		unsigned long src_addr = address + i * PAGE_SIZE;
@@ -819,10 +823,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 
 	if (likely(result == SCAN_SUCCEED))
 		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    compound_pagelist);
+						    order, compound_pagelist);
 	else
 		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 compound_pagelist);
+						 order, compound_pagelist);
 
 	return result;
 }
@@ -995,13 +999,12 @@ static int check_pmd_still_valid(struct mm_struct *mm,
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
-				       struct vm_area_struct *vma,
-				       unsigned long haddr, pmd_t *pmd,
-				       int referenced)
+		struct vm_area_struct *vma, unsigned long haddr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long address, end = haddr + (PAGE_SIZE << order);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1032,6 +1035,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		if (!is_swap_pte(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (order != HPAGE_PMD_ORDER) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1152,7 +1168,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1200,6 +1216,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1230,6 +1247,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
-- 
2.51.0


