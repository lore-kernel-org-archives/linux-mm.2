Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0168BD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0376B0026; Mon,  1 Dec 2025 12:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5500A6B0096; Mon,  1 Dec 2025 12:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417F36B0098; Mon,  1 Dec 2025 12:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B73E6B0026
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E674214035B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:34 +0000 (UTC)
X-FDA: 84171636948.04.017CC67
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11FE1C0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SS2gmfAS;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0P734FAsuJ3a3pM621I9D2l0RVWlr/vu6rgvvHLdnAc=;
	b=t6aBEIM43nnd1cPeCw9rsba9UmiV/1a8Ofip0T0tcSFBX6AHnSN7J9vF8OUxpCLOpGfzdV
	wrXn0tnNEum3dRQ/0Qoj8RuuPxTingMJX9OSI51ubbyCu5K+BzHZR2PvN0AYyHNbc+HSga
	3ZFchdAvT7bQvB0L1dJrS8n4wQfo920=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611313; a=rsa-sha256;
	cv=none;
	b=mwnVgxRS7ipnPM4cJxEcbGkA/k5vzIWt70SynWVOEzYLlcjPyhNviG9hBNgLiQQC7JOEmf
	vkXir4KWTzla84W/oe2WGmCsw2umNzmADju10+qVK/mORQp4wUbJomYf+k25ZhjjHgKMqZ
	YciKYsXOE6aUv/MHbqpCItBEylht9Hk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SS2gmfAS;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0P734FAsuJ3a3pM621I9D2l0RVWlr/vu6rgvvHLdnAc=;
	b=SS2gmfASbTiX8zrxuSQcBYebmHnxKnpP+JelRE7WGVCjw6MDbq46RfDj3L5MZQItPZEKat
	yDUVR+LNDrRB1xz6VXY+UqpfTN+fZGpHQjN6dnD33xl/LhX2X3W+caeI1vKcEjBLSTljQN
	/zS/RdAerFCh9ODM9vz/K1jeJHjIK6w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-AdTX8QqbPKOp84G1lR4Sew-1; Mon,
 01 Dec 2025 12:48:30 -0500
X-MC-Unique: AdTX8QqbPKOp84G1lR4Sew-1
X-Mimecast-MFC-AGG-ID: AdTX8QqbPKOp84G1lR4Sew_1764611305
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F3B319560B1;
	Mon,  1 Dec 2025 17:48:25 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1835B1800451;
	Mon,  1 Dec 2025 17:48:14 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
Subject: [PATCH v13 mm-new 06/16] khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Mon,  1 Dec 2025 10:46:17 -0700
Message-ID: <20251201174627.23295-7-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 11FE1C0011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: bywp3djemtosog646xjhgtuh6pm1heyn
X-HE-Tag: 1764611312-834763
X-HE-Meta: U2FsdGVkX19AkPPc2O2xXc6mebAUr7o9I1dno0tMVfxyZdTNYMEybZv12iWY1jq+QYgCzboffHLcEzj5Yq+5llIyxj3zXr5hI9LmET8VavbKGx7xTIIvuIEfsEMjwnP/FHP5KHf/9Vy2S4Y52327chYLPFmDTflOP00uOZXSEp8EqdVisXvX/imvCbICN32aTItPAj8u+zXQmkuMrQuFetp9XgxlbuFywL5ib6gVMYZoaspsf3EX13HtvNy7tFytLizUNuVt1AP4c1X8u9TwC44OkvmUsVGwnbI2v5aAesj5T27wHF3THDmHqkdL9j2JPHeQQ1tQZb23PVpVSShVPQLuZKFQ16pay6sf+8QEjqwO+ibCRI1acDcJkqD+XrCWfaBsEmtc1u9hqiwNyV7LZ1pX9htzYhoeh0u1xVjHnTEyj+aBdZXAo4clJ0IBiGQXUzSrPB40HGgc2X14/PFyss6vHWDSzE5dpbtSa+WBj9zhG799bLukjK0d4ec3ya+jo2V/3Z1x0CN4/c4pu0eqU/N1duXoT/2pVm8j1OStVvlmMfu/CXueI8W1hjFhoU12sirDCTnIqVMqTOIXNHyeHNIdBdVGAyTYczmtPWdYL83ddqxR9cvPzjSnpfQGRD0PKFMf30wJBHr5kJiKG+UxIjt6YO9SEIDNZtnrxLwsPm2FvBvF87MbEE3vP/D4FMS5q7+xIFgbrDhHTn6nW7oqVMKMUg1joDmQrVqP5Nw6LVZjIE2/lE23ALzjSUHuQB0VchlxeDNPXfI5NvYy/ObfiFCQadrnTlCtz6qyByGdg1v/ncMMzWi3HcedKldvq9hrBXAsoO2aWIGdsjRY/EMmqV0GMIXp81ZGxjic+VnABQ49DS4Kuw1aJnl7rwmFZcSOqkSxGKH0VmYh06peO/zeAFI6ia2uoUYoFIBdxFy+G/RFgIn46rxV62wRaxd5SYgwyenARpP9BNwxJu04fsW
 ChN/rhCh
 OsgFhRMx7CCiqstyqewSKbTZMFoMWd1aYnl5tzvHl04Aj7pNGbaTnl2RHHu2FfJqzfpWD1ft/UmrUC+DMvUPWiC6Y+QE3SC3vVhGkS3fWzUP6T3OMsNWMgB/A+gJ3cOGy+bNQVjxuvmnASspfz38qaIq5/BTHAM/uGOKXuH965iX/9D5vqGRmdd6LZ/pawpLszwZhQXqd3S/QswTAFeGSli0Ubj8g5OAlN64A0+DEIFA/pGaalPjzwMGBG7QVDEui6UOsbYddpPkQxq6IMOt8mYz0D2Lf7DlolAapcWuF7Nx8GXplrXy3QFJZc/xlVMWhRA+QJnwgXwXsUNQZOnEQuEhdz2JCnnsiB3fp20uqB4E/MFiGt/rPRfH+yiovkGkNPnhG2V3jkgmYHYtRd/ruTeym6vLTvf2EMZ2sdRG6+scUm81cLQRyso9jPHvZDbvIoLn6vHe/B820DV2dHvRUI7yitggFABAwr85XmJqO/FiQROXK549EKQoSXI+pmzbtjtfQeTAwvxa2wxIBPLJ7jqXXvmPxdLSdiyWBjOasWpZVUeEFSpXSwL3bys3n9Ww03ITf5lAD2CHg56s=
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

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 78 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9c041141b2e3..8dab49c53128 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -541,25 +541,25 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long start_addr,
-					pte_t *pte,
-					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	const unsigned long nr_pages = 1UL << order;
+	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			     none_or_zero <= max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -587,8 +587,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
+			if (is_mthp_order(order) || (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared)) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -681,18 +687,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -745,13 +751,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
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
@@ -765,7 +769,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -785,16 +789,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
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
@@ -813,10 +817,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 
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
@@ -989,13 +993,12 @@ static int check_pmd_still_valid(struct mm_struct *mm,
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
-				       struct vm_area_struct *vma,
-				       unsigned long start_addr, pmd_t *pmd,
-				       int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1027,6 +1030,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		    pte_present(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (is_mthp_order(order)) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1147,7 +1163,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1195,6 +1211,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1225,6 +1242,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
-- 
2.51.1


