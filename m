Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC10CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD298E0016; Wed, 22 Oct 2025 14:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA49A8E0010; Wed, 22 Oct 2025 14:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAC88E0016; Wed, 22 Oct 2025 14:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB31A8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8129B88DB2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:21 +0000 (UTC)
X-FDA: 84026612922.09.D0C5EFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D08A4160008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CX8DrMhG;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/azAtutXSUdxAwM5H4dVL3IbyI5xMqyjUavoMIbw45w=;
	b=1qvj4RbPyCxTJxGXb3c5Nv9DzAyFy8sZrYGMoTbi3FhmuyYPXleEXLulA00wikDaiLp1I8
	c7d8UDf9OXFWdxORy9SxoLcIzvPyzICkCzhvtzncvrIG64vEGNq3jpwBj47VkzhFTiNOOV
	drAe2GDaEUOcM57qkSO9D9mnQXMf2Zk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CX8DrMhG;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158359; a=rsa-sha256;
	cv=none;
	b=Oh7C7+teaxcNFKeaNTKOJx1j8G0lErApYnbpIJdHs0mpLAyTyxAebWnUjs5IYacQTOaSpn
	AIYtj/CLJc2bala4BKOvens2yzpkDKSGRqHopo9p5sf20ulKKutnpn6hNhXC9eAYXmdBO7
	pa0n+ZfPFmzV4ZI0qMtkQL+wVbQ39R0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/azAtutXSUdxAwM5H4dVL3IbyI5xMqyjUavoMIbw45w=;
	b=CX8DrMhGJpwTTIUAGcvV5TaMiNGT4iWHuWShtiJTxNav+R2zv+L4SrFWEC4pK4qkdvm9rN
	hCpdrShn2M6cxrZyyxQW7PjDwjnbt0mxRhMbLHcOk8DY5svIOhOWZGlLI0EyURZQDVrijV
	dg//n3zZBLvtNhnrFlOYayN6MdS5Jsw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-kSNwNSCBOZSnmHsYnUtgCw-1; Wed,
 22 Oct 2025 14:39:14 -0400
X-MC-Unique: kSNwNSCBOZSnmHsYnUtgCw-1
X-Mimecast-MFC-AGG-ID: kSNwNSCBOZSnmHsYnUtgCw_1761158349
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A69DE19560AD;
	Wed, 22 Oct 2025 18:39:09 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C76F19560B7;
	Wed, 22 Oct 2025 18:38:59 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 05/15] khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Wed, 22 Oct 2025 12:37:07 -0600
Message-ID: <20251022183717.70829-6-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: j13pd9ffmm4wzb897z3yutph4gj77ibp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D08A4160008
X-HE-Tag: 1761158359-992445
X-HE-Meta: U2FsdGVkX19hxYZ0GPhcHeU9BNN1uy/8e2c6QpnaiX/BcOm9YYLNUba3F/1e1TZDmU8nQMIjopFXu7B0ZsEjgXfmK7Wdm3LxmlW09wzSOxVI7KS06QQtt24NoXkRyJ2We1ZClFfTuiq5oX8qG9EmY6FxuhWLfmEJA8TT0KBQuFG+ngpbtaWno1weDO59P4v53NQSeoito9EB9Xf4p0qGMckG4AI9fXt/S5qi6hxxB1Af5VqLqL5e8y54pyHiHbWvOoST6Of+n402PLdmLs5dxFCZqUG5LXeYAeQMt7SkAj0lLChPWDE2YuCVF96QOmZNUspMZEn0itMQz+ho/CdcN2D7bAT9QkwqMZOKl1qL+qbnBHuEe8YfIOaU8z/9EGu14A5ZZUjRcEXsPKae/XrgUmuY76lpMC87YCgL4Op+sDHIU7+TkFqMKjNypul5vhxCKJ/vHeD4atjm1v8/aerDwTSl4UYMfRxqINXdv9kpix97Diyx/oyNNAyU/DR/y8zvs0XOfUUun0i1GV1MDU7wNzWrSEH7VlqFUggXRiRTeJ8H1BDNwtiYstosPm0iZRTmXOmEr/D7yVmf3fczIlnopSnuEisVqRAEBWMey8PIBYiO28lvT+dypjNABP8C2Kp8ZDWs+2vhVzxhDg2ofGNjijgAHw/a206mw2v+1kKwmyHAA59fXQK6Kdbu+BzavwX7zeRur2d6dweG/2l4uZ3K1a5sQbSOj1s/322zuIdi9qQYisbwtUO+6lbLdneECzHVdoA6xVnK+o62Chq56YdCgKJtuePpgaSznjYRII07iFN4J1Ac9qm5bzYCKzcucTbNfr0VDQP0WtIA41DQ8G7+WY6G9SCb1u2Gc0ZtZIZM4xLg0G8SsO+1CljrXYOblhcibSbJLO/A6cvKVmFi9/QRhqUNIdF9GFBt2KrnPvd17lV9zkFmkZJ2hxaPzLMovvlMpFF+55/hzuir5LZtC4E
 GeonUIQW
 fIxIGbLTOlPwiUqzINAJDPCj8AUk8jfrKVJge7xQiCpMlzY9APOeIDqk3W00JSZbfcqs5LsRJocA6QMM4tOw5HmOaTcu2ug5BGACn7ah+wA0k8Qx5QpYnLhVIEuUZ9DavTMSkQ3CxAHiW2QWle3OduKxrPOR+PCpwPLM8wC8ZUAn6Bb7WrKMVjAdiUZ5wWltdB5LZcxb8hdD//j7JWVaL4iUBWeN26S+s6IMNWyr5pUiTMkPRKRIc7bCuk9WiLZKRAiVa/QsRryA274wV+r2zt84oUTqvR/shQtSiLR4wUe5zBVzWy9HyjWU/VxxiRARCYIffiChOBXq0B3NxRML1GLh2ywG5G2XNDQYVKZqxeoHqQsymjQ5lUB4sD9GdSfgN2HhdoFCJUb7OE3EOWhmjLYu5nWPSQX3D0HFJbUk5Jt8/54U0IA52Bpk3VKHGtalVnFxLqLAF/sY/bEaps4UImgUWXm4Mg0viNSMzn+1iWrk5jC5sGY9Yc5S0fp6eklO6qYyFI1VNX396hFGWTwGBJL3b6Q==
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
index 36ee659acfbb..4ccebf5dda97 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -537,25 +537,25 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
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
@@ -583,8 +583,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -677,18 +683,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -741,13 +747,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
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
@@ -761,7 +765,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -781,16 +785,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
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
@@ -809,10 +813,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 
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
@@ -985,13 +989,12 @@ static int check_pmd_still_valid(struct mm_struct *mm,
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
@@ -1022,6 +1025,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1142,7 +1158,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1190,6 +1206,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1220,6 +1237,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
-- 
2.51.0


