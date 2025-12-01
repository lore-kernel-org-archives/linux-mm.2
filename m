Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FD3D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D446B00A2; Mon,  1 Dec 2025 12:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E586B00A3; Mon,  1 Dec 2025 12:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF5C6B00A4; Mon,  1 Dec 2025 12:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE926B00A2
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB09414035A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:55 +0000 (UTC)
X-FDA: 84171637830.11.24F9588
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0DF8C20002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMIb6jjw;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKlawH5rN92L07OSGIPWj4zpB4VY7n7aNLOsEB4+QqM=;
	b=2lTRtNWpduVUCiizmTc1nlz3fHIsR3s0fO0zds5FaeU27JxWLkTBuPHJKTwMrB+KqxfEGj
	xbMGn5PvwsWCDlmUPzENxrsqBOBedY7NFP/m4NZ28VYN2vJUBrvwGIhXhn3No6HWIcWYvr
	vRdaViiJY8scRaTB7v2HpfTDQkExi84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611334; a=rsa-sha256;
	cv=none;
	b=b4I5IfnUEA5GjsbdvqKUTYarR8BAu9N3imZUI80mgcXZXi2dmvQNNWnRpsKx2BhQs1DbMQ
	/wDy2LNgjCHR2Rr9wCFWRIgw7T9xKFMNKUbhpBgLuVLWXk4AoYsBvDCexNfU3lPquf6YS9
	8JBeQ+Ijeekka4g3/ayoZgZWZ6oAfdI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMIb6jjw;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iKlawH5rN92L07OSGIPWj4zpB4VY7n7aNLOsEB4+QqM=;
	b=fMIb6jjwFMqsDT/6AgfBnHYeJFvtfIZj5OliXw1muqDOClu3qs9cgdGNCz+rUF91RyPsfk
	XwrrRh4to/bu3pBl/asbKouCsxC4u9LLblY3C2GnKIkVBja4bYvmLENPceeuWnV39lmblt
	Qc1pMsT3Sa2JMD2DxSkeOBoyJKuAN2M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-jbz-sue5NJmjthYxZl8Ocw-1; Mon,
 01 Dec 2025 12:48:51 -0500
X-MC-Unique: jbz-sue5NJmjthYxZl8Ocw-1
X-Mimecast-MFC-AGG-ID: jbz-sue5NJmjthYxZl8Ocw_1764611325
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EF0F19560AF;
	Mon,  1 Dec 2025 17:48:45 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2AA01800451;
	Mon,  1 Dec 2025 17:48:35 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 08/16] khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Mon,  1 Dec 2025 10:46:19 -0700
Message-ID: <20251201174627.23295-9-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 0DF8C20002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: o3swipkfcfcg63ayagihtuduk5xesxxo
X-HE-Tag: 1764611333-253630
X-HE-Meta: U2FsdGVkX1+ws8epHf46jVttz/nE/GG85enB3rvxmPO7+9VRGyyF0D1FcjN5JV3CxaD2FSUbjdp/ftc9TcLdBMZHfeXKu/scFKJtS+J2KK5ytrHT+yvl7sLFCNoN1ootIhmvz6bEUVPbqJss9TvGvmdG2yohgrpnlVAWv95w4swZPAlQ+Am4Z9kOWyatR4IrX9MSsL+/VmIo+gRa/Mxg2nu49se5TSJ8mNIqYvuIAm1QB7DqwClDoZ0NRw4VyQYRAkWN5xzRcA7pmtprG+Xpie5ouHPqyuVLMyej/0LDJGMHEwNf4Z/ld9RZmC9JBYTKAvN4zsn1V82rm8nlqqnmI1ylmO21/q800IWkNGNOqR5DRz6T82wGpoTPFeI8Qt9WZddk+2ny86fl9DHss9ZNPo5OQrV+j7WOmbTFXujMB/pqdLoCThl/V/d7dgQNPyMLVno/yxMagTlfu4zy7F7qqOGjcu3Prg4+E1RhPRraiY6wwRz/qFWU2MvXRjrSFwFJ6e3hJXiUTOJ9TI/i9Fel570Lu6Vt7ZfYk+Q5OaPR6iQRiZ8lVbhvaZerUUN7VD+YNlsGegS5wYyXc+07fghddzskNCnrBYqByqU3QdGfCkzqqToNPEvY0mY9rez3r52mXRsD5EcJuz8BzjhmtfpOJb3euKSUBwC4VDyGlRKPqD4wRjMD9hwYP8rT8MJSiWb7ZKZdsmisramJCvhJ81Qi9cfhh5YlI7zqRNiG0BbggAmuyE3si0rWhCRlSy6AebeZaGraSP6KyYDglh7TQhybBiuJoml72IbAa4LssSwmHDY63DGIIv72GLb6PMpzvbzM0z6G63ocduSHYmULo44Mwvc5YiZSzGA9fxNKuQDAO6XTa4/GuyQmRCtrSRWcNl/Vte3Sk6sLvPgOJOEtkcc47fPgjjmHZOStmDCFSiyZr1HwwyRqo853+B5MK/Wm9QzwXPoZPROm6cm5Zk4uZv1
 EyF2wLZu
 jn5B/HwQFse+GXEB2TNtkeJNZL97ylUVoOlKxPTGY0TOuN2Dwnvo20DPzViBceHBb42uV+pEw+2du69guO5vKt+dLsIB2Ft8p3ZB2cNwx/jMAVOZddTlsG+wVnO0jt2J4j1NHohRe538yID/0SU1hJjGGwD5jzXoktSEqcpmS1gOUJJHKDPLlBLq8+Yj8L/hXtHrGryIJN6NLrWZN1sMRznQsnDQKB8ppXFP6xKIskcmvVgXMZjaNRK3psfJVWblCDQcpC5LMJ4VZLxN5Qr82W8e1F6lqljDD3hBMU5maFSjsJKa5gte4XnTYl6OqMSk6np/M3eBNSdnzPKplraOtBWe3oZ72KfxfAq0KKK/e3hS8U18gd5/fgDtMneavwK/orock1nT6vVxxSO/c5651dgguuYuxQsDrys02ANh0uAb/CAoTSKPk0Cwe/NUQO3w+NS+8+ExFojxFm/vTomXaqAYFS51x4jOswrFW
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
 mm/khugepaged.c | 112 ++++++++++++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 41 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f425238d5d4f..b41f68bbac80 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1155,45 +1155,54 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 	return SCAN_SUCCEED;
 }
 
-static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
-			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+static int collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
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
 	int result = SCAN_FAIL;
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
 
@@ -1203,13 +1212,16 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1219,20 +1231,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1244,24 +1256,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1271,21 +1280,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
+	if (!is_mthp_order(order)) {
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
 
@@ -1295,20 +1304,42 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
+	if (is_mthp_order(order)) { /* mTHP collapse */
+		pte_t mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
 
-	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
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
+	} else { /* PMD collapse */
+		pgtable = pmd_pgtable(_pmd);
+
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
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
@@ -1476,9 +1507,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
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
2.51.1


