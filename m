Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CB3FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916016B0095; Wed, 25 Feb 2026 22:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BFA96B0096; Wed, 25 Feb 2026 22:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8586B0098; Wed, 25 Feb 2026 22:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63C026B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:24:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 188841407E2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:52 +0000 (UTC)
X-FDA: 84485166024.22.FAACB5A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E551140006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MpygpSJK;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076290; a=rsa-sha256;
	cv=none;
	b=IYaoeNJXGgi9PBVqb+9PPShvmupe7sUPWTHkrZ3gKwEe4AeixhKsLntKvDHCoLstY0LqAn
	v9M+DXZ9DpWdc58ujp3MJk54uaI+l5xmnr/4OXNdkUrtMVhCG38xnXCUdv4KdxB5KR5c2t
	M8Wf/WciUK6xYNiPmRQxMQTKrMFkVkI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MpygpSJK;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3cIFUaUaDmDcN+584RAP1pS1iOL72Sdza1OyuwIkM4=;
	b=FAxTpLV9kFeSSGplx0vGFvchB510hQ7kFJJ6ASmUNaF/qLAtLxUDhPZC8G6rNzWxyQepTv
	01tNqSbGYHs8wK0t7oZodLFrGqKe7qxNM/N5z6/Kb63vUJW8tKbEGggUOa8FUcwayfsXp0
	xznJhVsECTD5AurnJi2yYoy0eRBJimM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3cIFUaUaDmDcN+584RAP1pS1iOL72Sdza1OyuwIkM4=;
	b=MpygpSJKRlfS3nbZYK1yfYqP9OKpC3PFURxSLd3xPLqfyVQfLW8CKz/Hc7h5Ob8Xp7SX7P
	BB59KmpsgScG/KcxqdxIOQ2I9x4WXOH3EPT+hv5Wn0TR1MvbGbBVNbJRF9VVa4/hd66Z8y
	79+As31lfDa8Ux1+DfhPHQYsw+HsG8A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-EwvZMUHHP2OY4R9pCSvWRQ-1; Wed,
 25 Feb 2026 22:24:45 -0500
X-MC-Unique: EwvZMUHHP2OY4R9pCSvWRQ-1
X-Mimecast-MFC-AGG-ID: EwvZMUHHP2OY4R9pCSvWRQ_1772076280
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E79FC195608D;
	Thu, 26 Feb 2026 03:24:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F3F51955F26;
	Thu, 26 Feb 2026 03:24:29 +0000 (UTC)
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
Subject: [PATCH mm-unstable v15 05/13] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Wed, 25 Feb 2026 20:24:27 -0700
Message-ID: <20260226032427.233282-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qjj0pCrGaaqHvDQUD6m1LcLoTP7-KbE3O9wD4v7mKwo_1772076280
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E551140006
X-Stat-Signature: 5dcr5w333pu5eg4k7fsy93pfchbjsw89
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772076289-453416
X-HE-Meta: U2FsdGVkX18f24Ko1BJ3HwfuTqPJhi7MCJPNYeuS+cxmoQrTJlu6IQVKvA0TI04Uqxv4JwB3LHyfwcHvZNCZQWW5CPPPu9gWXYtq27KZfI9lLkPGrxzAMi+S1a57rzv3TdENje2oGjZFqyGhgHaP4JVArPFEQtXUUOJkFMlLv0O3/QurKfVRuSiU5w9NxOMCMMRvjKJl0UILLp8GKqTBfTnBCV+7akSKN6BEAcUCzUC3DTv3HmRKWqK3jmrJp9e0CHV/LtytIYizk5UkncPgRdudbaB3P/D5ewfZfY3NKtv4gCw/EUmWtIOBj5daxGbL5rU+Llz9B2NRpmILDPLuMjAt8lBH6QsObrSbKUh8ty3eHapMw7C6hzHk7fTx2zwF8V8jCmkN9EYOc7BnT2sMqJPzBA8K5fzGtLaEzJpuPc6JiDGdLKwQSGr3Cl1iBOII9/xrdYHr4A9ed8mkm/OwPwyM0aGGaV0xOPtmDE/Cue1lyyqRLdX5lJF7VSgqi4KcHnKFt2JznquarBjVlYwqUrMmbPHGgCNw+aErdxzCoS5fWkVckz7OUAZUpzwaW4qeAHhYQeQFA3p3VipC0huoOak83DOu87d/8eUtFjM7/brV6UTbsK7/K3IgrjpUd4NWJlparMwhl+sLw8oNBp7iUlS0cqxifbbG7l0oa+eT0K4NIeYQxv+bZ4aqsNcR1kmSATTjHU7KlOAWfWltIga7m3XxTeFbkfDm/+Od3IT6WLb+fZf1M4AEsfWIc/rTJVknvWOUD+JJKoJqbawBNXXTtrBgQvqYGGV+kH5e65c0T/ZLHTUqrRtfIwMPMjFrCSzZszDFBAUy6NkJ2zaOB3ForTCskmt1fexX0et25pwgZXWpwCdrMVOZNzfeFbq7NVrc2axK1uaT3F1MIgkaus8577rwdGRs3q8DC2ep7Wxmqh2ekFrQJ0YFlqgTcX+scrO/5H/pPK2UFQbORfTe78w
 j43F+21x
 9rS0ia01YUDz883awqRnYqfPnhCfZ1p/ENCwXbE0EkMCCToFg3Gh1Iy2++2Irvf+lFe5jLQsDjFZJ+v2K6v2VZlr810SEUJfZsupRIkrq6UEDRhSd1vpUpVo380u2vtBi0x49g/5VLHWVfXtovqdMs2AcHCM5cBSSHsOC05fK+Uv23ZpKbySAdJdPI6MyJn0IH2EEIYpjJhu5ENqMODw/hpdI51QgleW37kmPbW4uNdTQBAFr/dECvQ3vfWKVDpqWvCUOtF+fP/BPzbRq5qqLjBMqfKVlqYVhsk0F49aH+RjlzwUFsA7A3R7F/uYHgfiIYYGb4t8IcnlwVeMMRPbAXLWNTK7O7keOim52GHbH/BnijnOraHGxiQKXpdQXwd+DQtRlv1IVOoaTcgU71yOZY4NUdkws+JbLdFRSjpEdInZrWbXYnxHFhC1y7uHwYuRNTN/xBAGDWSo7ztrjRAmqziCJj2Iv1vmmSX4R
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

Also convert these BUG_ON's to WARN_ON_ONCE's as these conditions, while
unexpected, should not bring down the system.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 102 +++++++++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 40 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 99f78f0e44c6..fb3ba8fe5a6c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1150,44 +1150,53 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
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
 
@@ -1197,13 +1206,16 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1213,20 +1225,20 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1238,24 +1250,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1265,21 +1274,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
 
@@ -1289,20 +1298,34 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
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
@@ -1483,9 +1506,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
2.53.0


