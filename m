Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95E1CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878F78E0040; Tue, 19 Aug 2025 09:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828CF8E0007; Tue, 19 Aug 2025 09:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717F48E0040; Tue, 19 Aug 2025 09:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7408E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:44:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC72E1DDD6C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:40 +0000 (UTC)
X-FDA: 83793627120.20.97F0C51
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 62C20140005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VaVQBV0p;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIzPuxQHyBdvNqV8dRvpyqjrUljFAc5kAhdT3Gs+PS0=;
	b=JbHD+uM+15mNjPmopGqLYvYWXlzC9EZ6zIbC4fda5lvgg7wgx5wGvkaqwztVWIlBJGPbx4
	uJyAQ2JE7lEP/q9UGVfSQPhwJaclj1RF/Ha5XQCCvO0aNroTFZJT+ApieRWWhRpahIZIZ2
	QDyV7jwwsG+xJLqvVaOCcqLAvvTTOQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611079; a=rsa-sha256;
	cv=none;
	b=Dz0gPFcbqx9xTSwhy8Xhd/BE0yyDWOYKCPdTn8JDlq94ecQ3s0HBbub5G+yAGs2wgnIDXw
	6kxGgw0LGS36CxzTe8vHHBbc5Ew6H+o5zpPyF0ehdh76fM/iitHx1JJv+ghBiX54t0RUSv
	M0UER91pRrqPRUR+45rBCeLZoYQi3q8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VaVQBV0p;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FIzPuxQHyBdvNqV8dRvpyqjrUljFAc5kAhdT3Gs+PS0=;
	b=VaVQBV0pEmuChlZK7FCJrEPg+VA7xUhm7ZWJ1/TwDP0vATl42KMPuSpTAu6OYxxk8qqoTa
	tUYalq8Iyvdm2H9acg4pmCHOsA1l5fU6E0OQ7eF1EMOgkcKBsEDsgNXwjbOta3stNPNZKc
	iphKlp8f+R88RU45Uy3uR25E+BHVVVM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-Kvf5g2AzN0Gk-RAu_vyxdA-1; Tue,
 19 Aug 2025 09:44:35 -0400
X-MC-Unique: Kvf5g2AzN0Gk-RAu_vyxdA-1
X-Mimecast-MFC-AGG-ID: Kvf5g2AzN0Gk-RAu_vyxdA_1755611070
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86FB6180034B;
	Tue, 19 Aug 2025 13:44:30 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5698C19560AB;
	Tue, 19 Aug 2025 13:44:11 +0000 (UTC)
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 05/13] khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Tue, 19 Aug 2025 07:41:57 -0600
Message-ID: <20250819134205.622806-6-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62C20140005
X-Stat-Signature: 4y7seph7y1dd4gn9ija8wxi6oipfgxn1
X-Rspam-User: 
X-HE-Tag: 1755611079-524015
X-HE-Meta: U2FsdGVkX1+r9jKjE/rB/0ac/Vltt9j7Jm+pQKjl3986BEXSTfM/Rk1iBYMlhh++77yC2uGWiJZ79sYZSWm8qg1iSIskNDqPUlS2PkNHfesyBUxnafjXhLi+AooLpUU2uTmzmsKi2yj6MsDhnyz+jB6vGqoP4iWvioCugk+ZYv31J6OsQwwZn5qBBcSmYOvd0KKfFu00biLF7adX5fI86Hv0fdA6IWOCqvdbqRNiiUD2FfVcQQiZmGrhV+udui3g/SefLF7hyE9xI3TEdLlJNzEUe0ISz3sab7oO/fep/pudjOz35Cbg2Hhlt+MitVJYauu+rgs3MChZ7eG2iXfEkEuQkntfeFSXu2DMCi31T1lXfOxn8M2RUoF7ils7J0Cu0FDSlmUoE14WiBDBeDc11alB5wYe0tO77hogorxu1aCst1+RyO1m71z7IcT8fg5X0Eh45OTgadtLaz3XSZVJtSuCX3KpAmfuLt3S06tFGdbLzcZvOuKlDp/iS2lao5FcSj5FNcI2NCsprJrRZ4kW1oNRhX6aWIFWzxXhh+qT9N9CPhb5Mz9Fm5R48jNOAw8ob2V0akejW5PpbcLWhsms2d3vK0+n+ox25Bk6/WAvM4d+eEAHqZD0aY3sOY5JnJgDa3dWvnaR5855ADhytGefcqufHzQUsqeMU961ifZlftLy3wYFuA0IihCJjBOdNStBamGuSJW6N1Y+sKNolNyhEsfYq1Jvfm79PhW3iryAJXGk45Ww25F2f0TIxNZEP/Nh8mEbj88aN6YUoF0xTpWxejDledS/fviPQXdXmtJ73gbpAMgrYr2b5/pwyIOAjaopoMO2OowlXERSFVUvGHHTerGY2A4QnX6HKMCK4eJa02UQFTkK+zbEu79hOY2XAHnoitgQI89z0pxsVS2v5VO4CsdTqFtj8GEus61jtd6KMN45Qxtv4SYfgD0g1duCPMQHHQL/FGdS7RPWtw0tg3p
 OIgULH/j
 aFNJ6SPkG7pyQ2PFItxcVrtiiwGyLrNcHYcEFIqESQ7Pzxb+MyTBxq1Z1KQ7ww3IiybDIFmlOPFa1hoUKF9Rs+ElKUkAWp7QQVWmmualv0oO4MMo7VkR52Pzkuz4z/1rz1VrTUA4DwvlKFi4FPXyUuSgS8ZA+u6JLfDETGRCLCFnD2I3Kc70uJZlIBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generalize the order of the __collapse_huge_page_* functions
to support future mTHP collapse.

mTHP collapse can suffer from incosistant behavior, and memory waste
"creep". disable swapin and shared support for mTHP collapse.

No functional changes in this patch.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 62 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 77e0d8ee59a0..074101d03c9d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -551,15 +551,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte,
 					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+					struct list_head *compound_pagelist,
+					unsigned int order)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 	bool writable = false;
+	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + (1 << order);
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none(pteval) || (pte_present(pteval) &&
@@ -567,7 +569,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			     none_or_zero <= scaled_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -595,8 +597,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -697,15 +705,16 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 						struct vm_area_struct *vma,
 						unsigned long address,
 						spinlock_t *ptl,
-						struct list_head *compound_pagelist)
+						struct list_head *compound_pagelist,
+						unsigned int order)
 {
-	unsigned long end = address + HPAGE_PMD_SIZE;
+	unsigned long end = address + (PAGE_SIZE << order);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
 	unsigned int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	for (_pte = pte; _pte < pte + (1 << order); _pte += nr_ptes,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
@@ -761,7 +770,8 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 					     pmd_t *pmd,
 					     pmd_t orig_pmd,
 					     struct vm_area_struct *vma,
-					     struct list_head *compound_pagelist)
+					     struct list_head *compound_pagelist,
+					     unsigned int order)
 {
 	spinlock_t *pmd_ptl;
 
@@ -778,7 +788,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + (1 << order), compound_pagelist);
 }
 
 /*
@@ -799,7 +809,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
 		unsigned long address, spinlock_t *ptl,
-		struct list_head *compound_pagelist)
+		struct list_head *compound_pagelist, unsigned int order)
 {
 	unsigned int i;
 	int result = SCAN_SUCCEED;
@@ -807,7 +817,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < (1 << order); i++) {
 		pte_t pteval = ptep_get(pte + i);
 		struct page *page = folio_page(folio, i);
 		unsigned long src_addr = address + i * PAGE_SIZE;
@@ -826,10 +836,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 
 	if (likely(result == SCAN_SUCCEED))
 		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    compound_pagelist);
+						    compound_pagelist, order);
 	else
 		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 compound_pagelist);
+						 compound_pagelist, order);
 
 	return result;
 }
@@ -1005,11 +1015,11 @@ static int check_pmd_still_valid(struct mm_struct *mm,
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
 				       struct vm_area_struct *vma,
 				       unsigned long haddr, pmd_t *pmd,
-				       int referenced)
+				       int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long address, end = haddr + (PAGE_SIZE << order);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1040,6 +1050,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1160,7 +1183,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1208,7 +1231,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-						      &compound_pagelist);
+						      &compound_pagelist,
+						      HPAGE_PMD_ORDER);
 		spin_unlock(pte_ptl);
 	} else {
 		result = SCAN_PMD_NULL;
@@ -1238,7 +1262,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
-					   &compound_pagelist);
+					   &compound_pagelist, HPAGE_PMD_ORDER);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
-- 
2.50.1


