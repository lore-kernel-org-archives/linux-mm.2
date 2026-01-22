Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF5CD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F776B032E; Thu, 22 Jan 2026 14:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6D66B0330; Thu, 22 Jan 2026 14:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D51F6B0331; Thu, 22 Jan 2026 14:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 781E86B032E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B2AE1A08FD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:34 +0000 (UTC)
X-FDA: 84360594108.05.B13C376
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39B3A180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ColTfeos;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gc2Ga0FmrZbM/w9mX8iAH7QabuKS+HLM+fgeK8Kcqrw=;
	b=TMINxdAWDGhOUu+DhlgeH10x5FSKqMkm1PZWEOciMIwr/Vi0tzei6IgCLLPOQrkwDW0Ps6
	qiZmk6CL934+voKdfnqV5N72RXGO8nLbGGbsMQtFJVTGO2KYCUFphsJ1mi+DKNKcCCN3BW
	Trse3I/q8dAwgEnk/GA6KOo6Mq4ld0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110292; a=rsa-sha256;
	cv=none;
	b=ofwjBCTgsiQsF/EeFWYU8wcxVfKtvMacBuKj0kq4+BBe52p/XMMaPsIdKUP90lCspuFVb+
	G26rYGZm/cxmwGEI2M5KVtCnmUcivLMPBa6iGvvV/IIfJovSFX3CVE0Wr0iKov9SPw+BAC
	reu+bkU5iImlIHlsbnNr6Yzne/IPQgU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ColTfeos;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gc2Ga0FmrZbM/w9mX8iAH7QabuKS+HLM+fgeK8Kcqrw=;
	b=ColTfeosj6wnVafSeKjc2/fXqYikgs1yZSRWLhFCiYcB5pXD3bn5xAIgubcr5Ppk8FTrwK
	AjKDrxeuowR3WBxBlng3uHfRkXxWgPEXaLT4+wyVsB40FthEm5r6xsKn/2h55aM4rIkDuX
	oqFzsFOyUvY79LENBtxD+7ik6xbgB8A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-d87WCzgvOqKIKPXumczLrw-1; Thu,
 22 Jan 2026 14:31:28 -0500
X-MC-Unique: d87WCzgvOqKIKPXumczLrw-1
X-Mimecast-MFC-AGG-ID: d87WCzgvOqKIKPXumczLrw_1769110282
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5682119560AA;
	Thu, 22 Jan 2026 19:31:22 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4AEDB1958DC2;
	Thu, 22 Jan 2026 19:31:13 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 08/16] khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Thu, 22 Jan 2026 12:28:33 -0700
Message-ID: <20260122192841.128719-9-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mAfpG16Wd5bRhObHDkHuwCWUDsBwv2Vxus5VZgR6Bwk_1769110282
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 39B3A180002
X-Stat-Signature: eng6g5p85zk3ikwbe1jsqp1qngduu8js
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769110292-915840
X-HE-Meta: U2FsdGVkX1/hdE3SZLfanlcHsD9Fl50Xo1Ea9GnFVCRvL7DBU464g/Hu2bdBe2qDkNnF1hRkq21O27VlAk6qfPcqenbPqaCvyQY9oy9M74JEVYtUqO4qZ2rmVl2gkrCQ51u3KlW5qgv+Z5OlJhKNmOyz/iVi+ptOE4VJFVejcJN8JTVYng5ba4rqIyvbqeGkDwGRvmH53TDouIR35ZrKlYG8fslxz0rVPaJtGbOwjWvJr/4sVIISnZ5kCTsl2pBOGN5YDti3StuVtwvureGrCyNU6dv0GAkKGUX2H5Wp6aPGWLqlmDFLZU2ZbE/3u5P81yZjsoYpAUkvokRxMG5chWlNc1NB6Q6KqNUmuZbbjbGVolK1zM/fPIWpwsNN0IOoRPdNhLlBUyF5gDPPFfXExGPAdj/mISUEdrZHVXPaKtFK2t7z7FgVZsufHjZOX2W3Nm4wBmhoknT/ZqB5y8oVfoiePehZjtc9i9tfgQ14s1xvmBr0UZpWSrcrqzOhypcZ1sFkfdGnIhCG9U1fHPuaIsmsdFHm0vhBt9CUY76waSpeOYGESKWwYBu9pgfFvWF0QD+Q+El2EpDiACRZd+nJMJiUPDbSD4lMRGpyi00NQDtSIitRwl6YNQK8b2wYx1bk7KAG+LT41qR0qPnnyqghmXUTes128WmiXnFhlPaSnBcymnrEthnDk2gKBvK0CcnS4mHwVu39UYXh0p8i58732ndbcM/C7W/NNpvkuFeZn8FsvWlyz2VuJYah6G+HJIUnv7s0MQ3BwyAvEZgJZ74qfc1taW1FkdMQB1Tqa+a5I5LiACTNGyp1VeLnZVxbNUC3o6trtZ/iLFwIKQuqfSDk0+e4VyaklpYhs7J3pkZDFoRo139HVHQO1WtPKQPXLE2VnJH8ksKJNtRad5ptm8Ptegp2+OV8kcu9yESwNkxnusPcEk3yRkAvY6/oj7xTO8dKCKK1Q66tl/W2ss5yVmX
 oJoYUwir
 ZPx78HNOUlSOJUl9NivXDrgjtj+yJgFOxxcqyjjacLpcmwUowRw3+7aEcGF8DFQB3UisHkK330t3/bdKUAdWc8ZPHv1IvhXMU0laRFiX6DSZNzAUE5esfcofUkTmjP4K0DvWx07/ONBAGyU4m0ww5IVQPKK2ArgobRTwBJNjLjeYQqgmQCXcJZoaLZkvSTdNSSyU5Urnk+Y1od8aYo6nnGc0hpUP9hSXkikeg5ynKxtS3KwEn+c8zIF0CM0IDeUBJLfbNcmTPA5/D0WuaS0B8rTZrFMcVMZAcQMcaIMv+rUUxBGWa6zi/DihR2D2ud68uQQxNlCokQA5GIxKbCRZSBMZ3+ICDbhawVDl8Ue1Ywxt71jmecq8a2JWTprabU3qb/L/08ImoEQC7WcrrUheW6ZAcy6Hd98Lx3jEJ3NbcXkTTr4NqM4G1My4mAn96YkyMenLGKXfE6J4MP/ZnxOvto17DdtNJMLyaI+b6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass an order and offset to collapse_huge_page to support collapsing anon
memory to arbitrary orders within a PMD. order indicates what mTHP size we
are attempting to collapse to, and offset indicates were in the PMD to
start the collapse attempt.

For non-PMD collapse we must leave the anon VMA write locked until after
we collapse the mTHP-- in the PMD case all the pages are isolated, but in
the mTHP case this is not true, and we must keep the lock to prevent
changes to the VMA from occurring.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 111 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 40 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9b7e05827749..76cb17243793 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1151,44 +1151,54 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
-		int referenced, int unmapped, struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
+		int referenced, int unmapped, struct collapse_control *cc,
+		bool *mmap_locked, unsigned int order)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	pte_t *pte = NULL;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
+	bool anon_vma_locked = false;
+	const unsigned long nr_pages = 1UL << order;
+	const unsigned long pmd_address = start_addr & HPAGE_PMD_MASK;
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_WARN_ON_ONCE(pmd_address & ~HPAGE_PMD_MASK);
 
 	/*
 	 * Before allocating the hugepage, release the mmap_lock read lock.
 	 * The allocation can take potentially a long time if it involves
 	 * sync compaction, and we do not need to hold the mmap_lock during
 	 * that. We will recheck the vma after taking it again in write mode.
+	 * If collapsing mTHPs we may have already released the read_lock.
 	 */
-	mmap_read_unlock(mm);
+	if (*mmap_locked) {
+		mmap_read_unlock(mm);
+		*mmap_locked = false;
+	}
 
-	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	*mmap_locked = true;
+	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
+		*mmap_locked = false;
 		goto out_nolock;
 	}
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
+		*mmap_locked = false;
 		goto out_nolock;
 	}
 
@@ -1198,13 +1208,16 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced, HPAGE_PMD_ORDER);
-		if (result != SCAN_SUCCEED)
+		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
+						     referenced, order);
+		if (result != SCAN_SUCCEED) {
+			*mmap_locked = false;
 			goto out_nolock;
+		}
 	}
 
 	mmap_read_unlock(mm);
+	*mmap_locked = false;
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the ptep_clear_flush and the VM
@@ -1214,20 +1227,20 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
 	vma_start_write(vma);
-	result = check_pmd_still_valid(mm, address, pmd);
+	result = check_pmd_still_valid(mm, pmd_address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
 	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_locked = true;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-				address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
+				start_addr + (PAGE_SIZE << order));
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
@@ -1239,24 +1252,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush(vma, pmd_address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
 	if (pte) {
-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-						      HPAGE_PMD_ORDER,
-						      &compound_pagelist);
+		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
+						      order, &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
 		result = SCAN_NO_PTE_TABLE;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
-		if (pte)
-			pte_unmap(pte);
 		spin_lock(pmd_ptl);
 		BUG_ON(!pmd_none(*pmd));
 		/*
@@ -1266,21 +1276,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(pmd_ptl);
-		anon_vma_unlock_write(vma->anon_vma);
 		goto out_up_write;
 	}
 
 	/*
-	 * All pages are isolated and locked so anon_vma rmap
-	 * can't run anymore.
+	 * For PMD collapse all pages are isolated and locked so anon_vma
+	 * rmap can't run anymore. For mTHP collapse we must hold the lock
 	 */
-	anon_vma_unlock_write(vma->anon_vma);
+	if (is_pmd_order(order)) {
+		anon_vma_unlock_write(vma->anon_vma);
+		anon_vma_locked = false;
+	}
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, address, pte_ptl,
-					   HPAGE_PMD_ORDER,
-					   &compound_pagelist);
-	pte_unmap(pte);
+					   vma, start_addr, pte_ptl,
+					   order, &compound_pagelist);
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
@@ -1290,20 +1300,42 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
+	if (is_pmd_order(order)) { /* PMD collapse */
+		pgtable = pmd_pgtable(_pmd);
 
-	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
+	} else { /* mTHP collapse */
+		pte_t mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
+
+		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		folio_ref_add(folio, nr_pages - 1);
+		folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		set_ptes(vma->vm_mm, start_addr, pte, mthp_pte, nr_pages);
+		update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
+
+		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+	}
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
 out_up_write:
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
+	if (pte)
+		pte_unmap(pte);
 	mmap_write_unlock(mm);
+	*mmap_locked = false;
 out_nolock:
+	WARN_ON_ONCE(*mmap_locked);
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
@@ -1471,9 +1503,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc);
-		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+					    unmapped, cc, mmap_locked,
+					    HPAGE_PMD_ORDER);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-- 
2.52.0


