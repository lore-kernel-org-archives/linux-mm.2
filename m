Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CFDCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2653B8E0002; Thu, 11 Sep 2025 23:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2148E8E0001; Thu, 11 Sep 2025 23:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCD08E0002; Thu, 11 Sep 2025 23:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED9888E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB26D86D9F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:41 +0000 (UTC)
X-FDA: 83879171082.28.2D2D9AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04C95180004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SsTEyDlV;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUbZXuD/tIL/iLobUEFL18qus/bMdCN0O7dskgZnAgQ=;
	b=oza4AbGX68U3mEiSLE6NrsR0QT3R+Q7uJG3BBONY1ngH5t45yELFk469Dsf8mtx1fBkMTD
	bxKn8zcfCV35dTwL0M06CTOLymxKoalgCPniq0umr2er8DakH/CQmlGzZjgVvAPe/VI86u
	qj2fmlmJMi0jCFHcOAsuVE9C5jCP06U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SsTEyDlV;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647840; a=rsa-sha256;
	cv=none;
	b=Vo4mV6b62kWEgRQ8S0FmUdCpm+JH1rtR/R4+/yU9BP8ly9PmgXe7KXbfSMTUAAeSbTO5cp
	YZxh9l5QYJpeEXvT4vdXyCpkzB3fHm62pb3mHP4IEfkAsmDnnop03754A+Q5qO0wmMtjBy
	9Stdrzm9KlHPk3RdrziZZjxNk8+38N0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUbZXuD/tIL/iLobUEFL18qus/bMdCN0O7dskgZnAgQ=;
	b=SsTEyDlVqjIH26uIV+L7/Dj7VFUKlrNlFiHtWLRfnL47rHOGiz0T6dLcP/HSkVmk9pWZLb
	dbEnpElJ0zUqVEcrWXK/XMWDjbHr9Wx4eV5naobPyk2X1YiBcM7Nmd0jODfm0HU3EKPd4d
	HA42BxGYp5X3+E+veYwaBQ08LtOsVFA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-EsB3IwknOo2sXoPAEPBHNQ-1; Thu,
 11 Sep 2025 23:30:34 -0400
X-MC-Unique: EsB3IwknOo2sXoPAEPBHNQ-1
X-Mimecast-MFC-AGG-ID: EsB3IwknOo2sXoPAEPBHNQ_1757647829
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4EED180048E;
	Fri, 12 Sep 2025 03:30:29 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DEE5C18004D8;
	Fri, 12 Sep 2025 03:30:19 +0000 (UTC)
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
Subject: [PATCH v11 07/15] khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Thu, 11 Sep 2025 21:28:02 -0600
Message-ID: <20250912032810.197475-8-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04C95180004
X-Stat-Signature: kqoipg5cwz9o7zqwnuifh8fjr5x7z1ye
X-HE-Tag: 1757647839-272712
X-HE-Meta: U2FsdGVkX1/DrHfZoqF4V2n0yVxMap9rwSOKPvfu5dweY3r9Pv6d8pqp35ZETzzHbXAV1uTSDT06F7/uUAzJM+tjnFfiVmzMxXCCThRuvdvcthNAyxE3LQIMhqOUh32CDIouSPIAttii4zowQu5/U9pdT1GQZFRg5MGCM8ybrkStOrTJ8C9GBycI2oGxhL/YzgvJ2CGGntDLYjwUWYy1WfWiH6+8KL/eduvKY/Yn3erV8OIjWxJ8XVRL69zRpNv9WsyMGuwhpf61pzrJ8dkzMvb5DykfAlvODBkakTMRPSZ2/DfGuAPCZ8srJwpt7y746KSyKCouBBG8FQLM9SR82dieyv3hVS+enWr+jFmKpLEnxkbI0vQ20l4lbpBX3/qkEPWROhufceYEfWjOyb+dUo4xrNJN8FqgvQ6MiT3OnEP6uT4CtCTRwp36uvooOCG41miPBdZMCjH9mp58I12khIc8s8o9SmYXZvywnBKiC7qnmPq5FlnlGY4+ac9KA/ZcTllTQaEu3xVAFbbax1C2kRVAGstgibYsQfsr8RbChPXoQHuMLodyaf/HST/4tEb2by3xILgXHp9li3UORyPUK3dHrPRnUSKwx4MU4voSgYLtkZ/zBkf0uWvTbS2eZLA9ssLkREHoK0gPSAEGlA6hF8GZKbBUY6P+Q2DWGeYzcw8kHeL5H+PMezGQThFW9pBA0SvhAY70b3ywmLEaV2Yiey1G/ScD6Z8BRcCAqk/6/l0gqP0zlhAPHFwkcQwzRBmNohV0FwU0eWxH0ybfK/YRDyXDJRfJAvD8VRnum/67bM1atDD4FhxhUi4zzdzaNlf5Osf3ygqirZfQroVFzFYGzoUReTWe2KXhSIprbUgcrjmlXifkHhulb9cuGcYBfMi7UHY+84HeRCMLZXASXv6/8h1oJHKmAAYNndmzMxGbxOXLkTCrWzRmrlf2lssxUcv4ohCdTCz9E6Loh5hOjKH
 Q/b0Lxdw
 nLZv/0CaH4LpW9FHOdUbja6HxIg6JrkdWuimQSIpltzpZ4HCg5SwKbn1ZB52VdtlM8hFWtMAo87iQAimdu0FIRkpBV6O67rxmebQY0DMeyJCREtHtBDq+hR3HDphO5xL+BaSzNC04bB7KyDQVOa0wUPiQIc2D8TORTWnTQmUpP2ZNdCois6reew59QssK20krw4PcECngCTCspLtva62ywZC+vx0K8MsUS5zyisB8o3HsRCwVDgttwKlUL0uAs5oES5MV/rclDYVHAXfyb+iLPQedJkmX74M16ZUYr7u8bbJDmcrqFbsN3SUMltAUz0bkLQZKtCBSZA8BQYtzkvq3S+fFeIpCxylZS+hJd9lp1ip14sOVprhxu0A+xCzDWD1CdQ3lApllnC3b7St7mnWK3XnSid5jdXYVjIuV0PypjOW1p/j2YVrRW3pXakeApHJNOO8nuFD/qqXQjC8=
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

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 123 +++++++++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 49 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4587f2def5c1..248947e78a30 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1139,43 +1139,50 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 	return SCAN_SUCCEED;
 }
 
-static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
-			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		bool *mmap_locked, unsigned int order, unsigned long offset)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	pte_t *pte = NULL, mthp_pte;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
+	bool anon_vma_locked = false;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long mthp_address = pmd_address + offset * PAGE_SIZE;
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_address & ~HPAGE_PMD_MASK);
 
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
 		goto out_nolock;
 	}
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1187,13 +1194,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_swapin(mm, vma, mthp_address, pmd,
+						     referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
 
 	mmap_read_unlock(mm);
+	*mmap_locked = false;
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the ptep_clear_flush and the VM
@@ -1203,20 +1211,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, mthp_address,
+				mthp_address + (PAGE_SIZE << order));
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
@@ -1228,24 +1236,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush(vma, pmd_address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, mthp_address, &pte_ptl);
 	if (pte) {
-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-						      HPAGE_PMD_ORDER,
-						      &compound_pagelist);
+		result = __collapse_huge_page_isolate(vma, mthp_address, pte, cc,
+						      order, &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
 		result = SCAN_PMD_NULL;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
-		if (pte)
-			pte_unmap(pte);
 		spin_lock(pmd_ptl);
 		BUG_ON(!pmd_none(*pmd));
 		/*
@@ -1255,21 +1260,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
+	if (order == HPAGE_PMD_ORDER) {
+		anon_vma_unlock_write(vma->anon_vma);
+		anon_vma_locked = false;
+	}
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, address, pte_ptl,
-					   HPAGE_PMD_ORDER,
-					   &compound_pagelist);
-	pte_unmap(pte);
+					   vma, mthp_address, pte_ptl,
+					   order, &compound_pagelist);
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
@@ -1279,27 +1284,48 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
-
-	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-
-	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache_pmd(vma, address, pmd);
-	deferred_split_folio(folio, false);
-	spin_unlock(pmd_ptl);
+	if (order == HPAGE_PMD_ORDER) {
+		pgtable = pmd_pgtable(_pmd);
+		_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
+		_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
+
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		folio_add_new_anon_rmap(folio, vma, pmd_address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		set_pmd_at(mm, pmd_address, pmd, _pmd);
+		update_mmu_cache_pmd(vma, pmd_address, pmd);
+		deferred_split_folio(folio, false);
+		spin_unlock(pmd_ptl);
+	} else { /* mTHP collapse */
+		mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
+		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
+
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		folio_ref_add(folio, nr_pages - 1);
+		folio_add_new_anon_rmap(folio, vma, mthp_address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		set_ptes(vma->vm_mm, mthp_address, pte, mthp_pte, nr_pages);
+		update_mmu_cache_range(NULL, vma, mthp_address, pte, nr_pages);
+
+		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		spin_unlock(pmd_ptl);
+	}
 
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
 out_up_write:
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
+	if (pte)
+		pte_unmap(pte);
 	mmap_write_unlock(mm);
 out_nolock:
+	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
@@ -1467,9 +1493,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, address, referenced,
-					    unmapped, cc);
-		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+					    unmapped, cc, mmap_locked,
+					    HPAGE_PMD_ORDER, 0);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-- 
2.51.0


