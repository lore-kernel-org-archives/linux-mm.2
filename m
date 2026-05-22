Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDABCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F6F6B00AB; Fri, 22 May 2026 11:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36366B00AD; Fri, 22 May 2026 11:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C3E6B00AE; Fri, 22 May 2026 11:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A47C36B00AB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:02:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3296592D27
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:04 +0000 (UTC)
X-FDA: 84795370968.14.52B2A9A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22C0A14002D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gy4HZ9mI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9GyHs3IVoMuSHvkJgCN44948IdxMS9mMjGSNGJEJTk=;
	b=FKE75lAjSCt7P9+D5d1b6lqVVEUvSvM/71ukag4FrLsFixLA/WatkW8L72RouxFHo/UcE3
	mUKK5nD3MELQrls/Ojr8cDRpJzX/XWtKJuvzcYiG7RLss6JtrfjvyumYwH376Lirap8rOT
	NFEbVkQUbw0F70I65RogstfmxI4tWwM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gy4HZ9mI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462122; a=rsa-sha256;
	cv=none;
	b=dt1t128r7b/3kmzpfUBRlFQeYsNlZsV/th6Vn5KDofdTxvES9Ep1zqYWWqqQ4C0eC4185w
	7ObxdrkRtnvl5fysyodXkoiHAlp5mJjguv+xPAfEOtSF2l2tTh8RFBqgqLF8RYB7vKnutP
	VosBpQqHtTjRN3vKadEPiOB3BQ/rrb0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9GyHs3IVoMuSHvkJgCN44948IdxMS9mMjGSNGJEJTk=;
	b=gy4HZ9mIWXEQ6Gg04Ksdz3TL1GmKM6WZYu23qdrElkTDDZw32f4ugWG3zMTKEcZ5ZClXQb
	eNN3vOin6n8IKcGVRGC40fdj3kSZFkD/zacq0mixilz2KEAzAn056AuAIeQKYFtGmvzr/b
	RVicRnPofzhPM6sGv4kOx0hxwTD52a8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-lPQXmzpsNo2xqE-0_gqpQA-1; Fri,
 22 May 2026 11:01:58 -0400
X-MC-Unique: lPQXmzpsNo2xqE-0_gqpQA-1
X-Mimecast-MFC-AGG-ID: lPQXmzpsNo2xqE-0_gqpQA_1779462109
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A84FC1956050;
	Fri, 22 May 2026 15:01:49 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5E2291800576;
	Fri, 22 May 2026 15:01:31 +0000 (UTC)
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
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Fri, 22 May 2026 09:00:01 -0600
Message-ID: <20260522150009.121603-7-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _QLqwPIvi-PpiaXEx6Xe3oAQ3ydFd9uocOrJG7pzM4E_1779462109
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22C0A14002D
X-Stat-Signature: 647m3con71tetaq79wef6bhcbczx1x6c
X-Rspam-User: 
X-HE-Tag: 1779462121-679760
X-HE-Meta: U2FsdGVkX192Ej+V7RceXxz6STAQgB3Sl/pCtBLfgOSztlEBlbdbVq1d54h8R+Bp/7BAhsbwu2pjDZWGrGp8PoUcdxxLvFOEehCOLzAd79hO+aQJZTqf5jC2ebLDkpUmUlwrOoZZv9vtV1FIoL3NBmI9uXsai+vQNFOBwI0xsYtgeFuDKIs/orw3o/Cg0Ozz81M4G6YeUut5KN1NzpQXemheZu03s6ADVGngaZop34dTkUD15ImW/n2nbiXGkd4XASARQT7DqBwTOYs1MnittEUJ2jtBgsXPwh1+XlfegZJjCMKhiHktMHuymPDRFork2RSOFwaX/L3JateAJkQFgTNmDltod+gTstNK1O5t/zK6t4UIA1MQ5qQQHOEmI/GOjTZJe1iNy2xpwsNehWvFHdRPz6Tbjew+LJu495KaRBqxEWswHDv/tU5nCDN5pVbQ1yIiL0M5lMWZNT0qzD5RzIrsvPYuItz2QaJVpW0qkBVUVl5VutJ/UNrN6QoPPhVNHESYf62f/s93ms53fswQCvGccgl0mXwzLq2RcNdJGXi+te8vZba2zTs2CWWbYwmDyy7bZQHFLsem0y23rzCvH+8ZqeDzqyKJ20uzWhur7OrE5lOzPy5nlLPFcmK+Xn6yGzQWYSrvsKgGPpEFb2ZkikECMpxe9Iao7GPbVvaf/Riv0yTsStVTL5h4cQLGmChEephlvJG7cWaYjDSQ4XFsA2jowpfPTVvLSFi4dblztixsY72erRfq7hx+0luiedlOj319Hy70FwpktxsaS2Og98C0H7OS6ww91y07YVrHyigMbTvoK0gsZaEeQQDCfuQ5XjA3duoNovb1WlimSDCNVmhGRA8RyWp+S599Jycuz0cJw99MTlq53QA83yoLSZw48Idh9sfdm9j+KObmZP2L1qmEIfl53Y6hT5d0urQfJ7eKx8J0UzNePOcYGwMAz+SqKC5HnKyzxdzJYN1Wtkq
 tQa+70mt
 OEp3HZJUYcejTBOayjwnMIe+n3Ag2BCHZDEaFzPsOncC8I+lL6L1PwlYqXxhO7uUKg7odDLQNK+tIxXVTCX7xh9xqzSg0dZyhbh9YzGfdOfp7f9+6xFW0/KX7mF1a3tSp0qHCgedbv/9NnQjrJOm5A2DnTmy4NJQOavX0Kvt8c+u2252yhTw2Jh4d8++dBQQlCEDScVAJow+mlOrQ8tvM2BDsm5r5V4GpwZbUPLv9jFRHviDCWFemV1RO+SVZq2P3lkIXpDf7e34mymgUjuesKATMNiRRiZCl104L7HIy54MXcHPGM44LdyuDtUc1LYy5TXr3tgZlq7uA8+7Pa/wnVo/k4ZjKQSuhmayZEPuG7sfmL+7P0bFmUFHHZEiZEQAkupwN61GyBw0BHPh8zUtHaY47/4nGDulBIilQsJJO4eY1Y9Tkx7Tv9xcxAKy2HwgXjgcnsI/yy9J/nLQ=
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

Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 38 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fab35d318641..d64f42f66236 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
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
@@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
 
@@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


