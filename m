Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B249BFD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F636B008C; Wed, 25 Feb 2026 22:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA0E6B0092; Wed, 25 Feb 2026 22:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF816B0093; Wed, 25 Feb 2026 22:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2D86B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:24:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E8E71CA81
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:11 +0000 (UTC)
X-FDA: 84485164302.01.C31D4BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B26E2C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeBCEjxP;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMaDPMdSo1wOJupzMtNfLzVgCQkuS95wkaCrSiv4DDs=;
	b=KheMAh4ALEtcMb3kUvl0Mp4MZm+vT/FYQP482rMI6ETNcy+y/aeom/a+zh63C/fXg6uXcS
	Opq4Gn6IaRkyLMtvK8TYK/xBEBFXCYWigQQQEYrrSeZAS87fnZl2Vl+rZG7O9ZG7qbvpMe
	yr9DmJ/tmyDZfmKOR4b7UazUVo3TQ98=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeBCEjxP;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076249; a=rsa-sha256;
	cv=none;
	b=XVQqMsf7T/hJx5JhGczgbJTPex3cwVn8Qd1WGXNf2wlYiYaDGwb4BPg75pUqm0WFyU5suU
	pNzeV8yA9SfnzruljfKOXrTCMqfJXGGr7ocLGThMbOKoVo0yLuskPGKYwZyTbCBOIDolW1
	TO6W9HZ8UvhgGnrM0cnKjvrplCnTPP0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HMaDPMdSo1wOJupzMtNfLzVgCQkuS95wkaCrSiv4DDs=;
	b=TeBCEjxPWmkA35KJEruR4eSZirWQ6KdOO50mc4JbBE3AX9kIT4CAD2rXib1WUftqYIEt30
	dKvw0uBMP7D/jkPNWIfygNx8aKZduqmw86TqPfDJq556zFlUWwRYgTOSixhf+UHPK3uhJA
	hWPwvQiw6ipi0uFnuckDK1JhNnxCOLw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-DcmLCHvzOm6sZTqh7hfWOA-1; Wed,
 25 Feb 2026 22:24:05 -0500
X-MC-Unique: DcmLCHvzOm6sZTqh7hfWOA-1
X-Mimecast-MFC-AGG-ID: DcmLCHvzOm6sZTqh7hfWOA_1772076240
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56D23195605F;
	Thu, 26 Feb 2026 03:23:59 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B8D83003D88;
	Thu, 26 Feb 2026 03:23:49 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
Date: Wed, 25 Feb 2026 20:23:47 -0700
Message-ID: <20260226032347.232939-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S1xynxlV8wY3ZW7QpuAqOGLhy_ggDMuvbcnMyq00h0w_1772076240
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: p1jriehr9xu7acxudiq89qh6wiua7bdg
X-Rspam-User: 
X-Rspamd-Queue-Id: B26E2C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1772076249-279916
X-HE-Meta: U2FsdGVkX1980tm4tnOddzrJ+hophJZPQNPhCnMBMRjG4BqPNMjSvyWxs7qWXvdzXQfiqxXvZXk3jgAswuXObyreuqYZZvAJG2njoC5hfOzfy7tUjiT+izxgPiPWTOG2cKbmKV1G5faRdbFuRAX2OxAXGRUBGCq0WX8AwFVnSdYEXvewJYN28ntGrcuLuBObxNJ6KVI7Y/1IxVyh3zYbGwtl7yONUkPUM+P9l/UI6iNqh6dPGsRNfYmObexvPIAJay46D000O+4Ji8UlwemyIHxjZpmRNzCMH/jHiEC/E+FPYlW12KRWlMjUpjZoMjrFwThXVIDABWEX9Jpx9vsi7/z2mvelxgFL5AO4U1uGm+QMLYW4StxlTF8Agh6RgfUw2ALX46EP3OSyYE23wHfx9A4LGJUjpebT/BOY5hF5K4ioZuoq4bb1FchzhdD3y8jBocpHlnUFY5JTX/2ZHtevE++zJISagrupec/fZRHK0k7tZxqliW+8AKIbV4mdr9BcAap3FX2E1WUZUe3+I7kRJ2qLYJMrh9wFdBO/yw4zNAbV6QD05oaNoBRMp0r+FJPd4YJSbQXwYsM8bWnBtjTvsMXjokkFLy1PXGI7fsuHzOqx+fSX2GDT8H1A2lGKqD22IHLsAdvAuoNxVB6FlEL3+jCdSDGOQx6qKdDO/qjotVCBeN5AIdK6iwEdEqss+cZfJkv8aqKdQ8+gCsWc7J/WE3xs7lQ4gg2+PNg2xlA7yvH3yTRmVIelzOUJeKUxGSssWOkvnWVtF0WdvS6+NiEnaXH3pcl9ShqlIfNOB18dqo4FtvrTjnlgpBONW9lAjd9msplmK7udeK92d4uUpj57z5IkXCeoi7VtfMLz3ZyC+djP2Har1IRHuDPGKuNm/efeNoB/XDbOPjwdClsMm06AVwTYg6LKEntY3w0wvSXt4Q98QiNb8V2l/D8igZqjh5AsHT9nj3iKvGbiuEaoe2i
 zMONXhgy
 NWg7qQCiC1AWVNNTpYPh8A60+1gy0RWPiM8FLSG3HSUwg5Cy1PD8nwLtjtFuEs1RbyJL/HU6QNFzQ6PgvU5Qvr+2+jNTi7zqrlXF1Wc3PejhIPqLpEk+iYGq4kQ9Oc+zq54CTm5BMxJFormfY7Nmxvlg6ePSco7KFQ8QoywalSok5ozRkNDJZEIj9Oyctqgn69KOmddu/jPXVBFKRQ5cx4nJNa+F7tulqYXyb/HO85bxN4+dW7YkptjJtHAWLrEhoa98YuMneAh4uTYaGeq7qRjY+OWcKG5xgSVYgHAO+YTyeSniyykDBVm+T5V+dIJRch1EROaNgaleEo5VGFsXuvbbX+Nk+KtaYB58ctN5ZxXVCB4S7Sr/akp1TuMEjsQarjhgW78Xoaf8SvmRjFGy3Rq4LfoBMFKuOurWV8ifsTEnixW3CFG98677fZ0jDwDlpfOEA+/gM0dEEshAQKxnvLmGD+j14FzVe0DfRnM+dn849IY9dHZAamyX0gOd6f+cRO7GuAhr/2Z4XQ6GhJfhzP9yPAJ98p+v709aQMxiwqVZgHwAo5f31xab0uxb84rlsCi7yPTcM4xT3OgM=
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
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 73 +++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a9b645402b7f..ecdbbf6a01a6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -535,7 +535,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
-		struct list_head *compound_pagelist)
+		unsigned int order, struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
@@ -543,15 +543,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
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
@@ -585,8 +587,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
+			if (!is_pmd_order(order) || (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared)) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -679,18 +687,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -743,13 +751,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
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
@@ -763,7 +769,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Release both raw and compound pages isolated
 	 * in __collapse_huge_page_isolate.
 	 */
-	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
 }
 
 /*
@@ -783,16 +789,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  */
 static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl,
+		unsigned long address, spinlock_t *ptl, unsigned int order,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
 	enum scan_result result = SCAN_SUCCEED;
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
@@ -811,10 +817,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
 
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
@@ -985,12 +991,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
-		int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr,
+		pmd_t *pmd, int referenced, unsigned int order)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
@@ -1022,6 +1028,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		    pte_present(vmf.orig_pte))
 			continue;
 
+		/*
+		 * TODO: Support swapin without leading to further mTHP
+		 * collapses. Currently bringing in new pages via swapin may
+		 * cause a future higher order collapse on a rescan of the same
+		 * range.
+		 */
+		if (!is_pmd_order(order)) {
+			pte_unmap(pte);
+			mmap_read_unlock(mm);
+			result = SCAN_EXCEED_SWAP_PTE;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1141,7 +1160,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced);
+						     referenced, HPAGE_PMD_ORDER);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1189,6 +1208,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
 		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      HPAGE_PMD_ORDER,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
@@ -1219,6 +1239,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
+					   HPAGE_PMD_ORDER,
 					   &compound_pagelist);
 	pte_unmap(pte);
 	if (unlikely(result != SCAN_SUCCEED))
-- 
2.53.0


