Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDDBCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95B46B00E0; Mon, 11 May 2026 15:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6DDB6B00E1; Mon, 11 May 2026 15:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CEB6B00E2; Mon, 11 May 2026 15:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96D2E6B00E0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:00:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 320BEC0ABD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:22 +0000 (UTC)
X-FDA: 84756054684.28.A98F937
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 33C7040010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yf6bRXPK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526020; a=rsa-sha256;
	cv=none;
	b=hweUGkxAA8o8Ic7oc95J4CZ16pv4YwTr0KyvgQkceKsFwbLn4LrBoYggK4BkRhwvV0plJl
	6hIIoe1av226Q20UCx8MQG8Xx/L+SpVXr6RTp7lXeGpCvfKbushHbUwlvw9WxociEF/saU
	NvPZOky0SOx6nOVwCgW7ewibAoRH5GI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yf6bRXPK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70AXSU6IOZyrgTR8aag/atBUTnXtitCUDtfgO5TZeUI=;
	b=0UOq4eQjNo515BWORxbRbXpWTfO6L7uwA5Osq6O9XM38JrjNj9SzpVZCNoQ6fGPEoLthN6
	rViHyGxD3/7TMzzHGydI2eZrms6/RJim7PHdwK0WUhAlPVntHxsZN+Nm1jix09T/W7PixM
	b1GeVVPn3QYRlHzLWOwYC5ZS4AAT6Jg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70AXSU6IOZyrgTR8aag/atBUTnXtitCUDtfgO5TZeUI=;
	b=Yf6bRXPKsJKDX8gLTAQzzOfw6TiQDA6e4++2O7adyy8CONVd6ZR3AXWOzC/5/ohlnXU5w1
	1MMbNl83dBgzFLoXG+QHJOo58VX1XjUOPePcApyYdRa0d3pidmM+IRrQVQHAxSpzFqkGsH
	wrl2rLwe3q4y/7x8qzPsu2mTeN46hXQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-tiWw8GTPPV-9gwAUtk2IGg-1; Mon,
 11 May 2026 15:00:13 -0400
X-MC-Unique: tiWw8GTPPV-9gwAUtk2IGg-1
X-Mimecast-MFC-AGG-ID: tiWw8GTPPV-9gwAUtk2IGg_1778526008
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD356180060D;
	Mon, 11 May 2026 19:00:07 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 17C493002D30;
	Mon, 11 May 2026 18:59:48 +0000 (UTC)
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
	liam@infradead.org,
	ljs@kernel.org,
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
Subject: [PATCH mm-unstable v17 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Mon, 11 May 2026 12:58:06 -0600
Message-ID: <20260511185817.686831-7-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L-2HSY-4o4JV_VZZuHeJ0z7i61hHxoSdZDJGl8UIQvo_1778526008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: inyfegxowsrug83yk3tai3f8uwgwy7q8
X-Rspam-User: 
X-Rspamd-Queue-Id: 33C7040010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778526019-656295
X-HE-Meta: U2FsdGVkX1+eiz5tmWUwhH1U/7hJOZapHyFzARnoa0lcccydBb7opAFii+8fnhya/rrSY9hdryfp5iKZ9e4JlI5ByvBxmmhWUc3YCVu+4BgYE+CIZAwGsSugSiixMY9U2jUx5zhyc6cZ0PegWILEo8EmrPw83gkGpFxV86psaqh//ZmFWOUPbfDAeeylAzrGX/OL+gJFBVe9odeHCInc+fhl7T/jIiZU+BJXzzBFnKgScg1noX/FIBtBIRJ6KNGDZSmGC5iizLOunA9A9ogQt9EJWufUkV8+RbbBRe2x7ngSjEPZImZASBlVgP9mxb0RkStUBu1AL77UxC4vcgRM5aVA7bQFnxH/UsiepSMFpu0dI+1PEsIAWy/Cs9vjGigNCIlrZy7kUsxiF6ouw2QOwhAgbEF5wVgbQ7ROuh3FEvU0SQSzSC/ra9pG9Hcp0RXk+tPKisLLg0eNwh3EVWlQ89oFbHfko5ZY6iR0GV6OIfo5EwamdblGE7Me5KdgMJgBNvxqWQA9a8jTWMJRvk7y0SSr5Y1ze1GDYiLpQ1IDj5ayOIKO9ODBfuqfCymDBlDZjnEckob/rRQR2wxRV4uARP+V091KypWGeVMIzEws2sqlfJeeWdqdAk83VW3pZD8w6FZRK50vgX+kXEDqgfGFEpnFUhIbVmeiPV/zyjjPCGPM3iVxPw0NxP59v75euMzRNl4XP19uAnIumJ2hLKSqsiUEPaZyuCbT0Dyc8X2kyf9xybP1G6LeBnqywqJzy1tG7yQzbSTDQZ/OQrW4ixLzrET9as7VHNKGsB4JeF3Me/0/PdHkkCGbgK6jbEzbQVKWiym0Lsy2UWqx85pRtiXHUb/ge/LFLAyBFJrPXj0nsYeW8Kf+WkDopartDtCWNYLWHBxlWppiMWVY/d1kBeY4pH5JNrdzkCm1GP8MDxTPtpY3uer9b8KMetVxFk9XB1vdY5sJl93dNCe430uWOjL
 3AH0c7Er
 BnVPjw05rPh7psjlyz4DDl/oIbpO7SUPP65fiU9FrXxqnhzoBoxj203VgZdu4cV+ex++a9mjntcOaZgWeZi52YbqUCbnvMeOy0VLkKMV8Y0ZNp5FIsFwo2FQhsy4EQaCBgXs2sc+eQk3kWYo1dZ0GFyMykHJ/Nwrd2k0dt7rEkBXRVnbCH0fRpxhoRm1uk8VwDeN5plSKjmRv+zkTgGidDJ90AcIrHqtrQ8la1gjmib0SurHQJDndGMN6V0MGVkxy0B1K/otZRV513ajZNSXag/ZSFLngonSvtdo0JclFyvoW22zecJ/nWLExRYt1nbI/3ZTyu/BvGtexXvOTMAiAg5jJSELUcBO70i2mBWNY4QQemTUtjO4N6uij692fcglP/l3P19AfCCClrJwz4LDWFMuzQWT+eH2vzrrc54E/EnE6UgMicMuu61kcgge9ZATU2xyGIZWPZjWvlTA=
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
access/changes to the page tables. This can happen if the rmap walkers hit
a pmd_none while the PMD entry is currently unavailable due to being
temporarily removed during the collapse phase.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 38 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 37a5f6791816..f49bef78cf51 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1207,34 +1207,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
  * the mmap_lock during that. We must recheck the vma after taking it again in
  * write mode.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
-		int referenced, int unmapped, struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
+		int referenced, int unmapped, struct collapse_control *cc,
+		unsigned int order)
 {
+	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
+	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
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
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-
-	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1246,8 +1248,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
+						     referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1262,20 +1264,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
 	vma_start_write(vma);
-	result = check_pmd_still_valid(mm, address, pmd);
+	result = check_pmd_still_valid(mm, pmd_addr, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
 	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_locked = true;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-				address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
+				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
@@ -1287,26 +1290,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
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
-		BUG_ON(!pmd_none(*pmd));
+		WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
 		 * We can only use set_pmd_at when establishing
 		 * hugepmds and never for establishing regular pmds that
@@ -1314,21 +1314,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
+	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
+	 * removed and not all pages are isolated and locked, so we must hold
+	 * the lock to prevent neighboring folios from attempting to access
+	 * this PMD until its reinstalled.
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
 
@@ -1338,18 +1341,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
-
 	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
+	WARN_ON_ONCE(!pmd_none(*pmd));
+	if (is_pmd_order(order)) {
+		pgtable = pmd_pgtable(_pmd);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
+	} else {
+		/*
+		 * set_ptes is called in map_anon_folio_pte_nopf with the
+		 * pmd_ptl lock still held; this is safe as the PMD is expected
+		 * to be none. The pmd entry is then repopulated below.
+		 */
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
 out_nolock:
 	if (folio)
@@ -1529,7 +1546,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc);
+					    unmapped, cc, HPAGE_PMD_ORDER);
 		/* collapse_huge_page will return with the mmap_lock released */
 		*lock_dropped = true;
 	}
-- 
2.54.0


