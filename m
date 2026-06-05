Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCABCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E64D6B009D; Fri,  5 Jun 2026 12:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497156B009E; Fri,  5 Jun 2026 12:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F596B009F; Fri,  5 Jun 2026 12:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20E2E6B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:15:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E32531A01D1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:48 +0000 (UTC)
X-FDA: 84846359976.13.C0452BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5FA7A001A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Okw2fZJq;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiyvVIBTfeyftNjdamEQ07U4KZCyjVtuDDP8zoffdS8=;
	b=UpOtBIPgwHFN5j0eqyTJH0sLO2nyy58xtqRUdTPOyBr6FO/KmC5VjK9eBkNatqCBCmK93I
	bHZ8099PEFUWj3Kio41yGc5s3ro/29nFq0IO+uRiXu/T+3/73NSY11p7Q4P0aSfsBwVBYR
	IYDntpY1AIRoXMBIriCz4tMbteHXs+8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Okw2fZJq;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676147;
	b=tAPcWvUz+LFhhwSXrw/+qzUwTEQTeJP3anTvCl/TtfV9wv+udVdHufT8G+1qh0NrNDOFzk
	KU3D1Uy21RyjS9QaoEqUTaYgvygv9TSHnLCsLPGioymGYSG0Zy71cmY4yfc5uT8MtokDUA
	hy7E/RoCIERdPX2QYeoZ/NpaTfBI3dg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiyvVIBTfeyftNjdamEQ07U4KZCyjVtuDDP8zoffdS8=;
	b=Okw2fZJq4lCamo1Wq3i1/mlhLWwcsJw1M2Q3jnuO7GiReh12ANQhZJyDP+DPo9AFM1hqXF
	foZetVHYD1fucw3mbYqQKmgb7yYlSjmQ+mFvVh3h1cqLZzVhgkl7EKkEgQuq7Obe/EFAsd
	DBYthESWEpLJkFVqLVmIxM4BBZ3zu+U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-FZZv-PuCOvaPlqgi1GX69Q-1; Fri,
 05 Jun 2026 12:15:44 -0400
X-MC-Unique: FZZv-PuCOvaPlqgi1GX69Q-1
X-Mimecast-MFC-AGG-ID: FZZv-PuCOvaPlqgi1GX69Q_1780676138
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81ADF180034C;
	Fri,  5 Jun 2026 16:15:38 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36015180049F;
	Fri,  5 Jun 2026 16:15:19 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Fri,  5 Jun 2026 10:14:13 -0600
Message-ID: <20260605161422.213817-7-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -Q9iCi6qVQUWmxxjkrOWQypL2QFpampjplM3QzCYJ3I_1780676138
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D5FA7A001A
X-Stat-Signature: rspc9hitwbnwu38r14teo53eet889on4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780676146-248401
X-HE-Meta: U2FsdGVkX1+J3Fsh87B3Yq47Xz6j3NhLq8l376OxfWfl2ngozMxcPmMH14zxY+HNiUrR55ZW+tUR0DOnRpCe2O/8VJA5MJxKACy8/NPmUtXoSGeTYhmQEf1sF6+q+krr9481CShNLTbO9PZ1ik/ZEHY2RA2b00ruO9KrbRsqlUCc6DqLA9XX80D7Q+PGeQUNJAx3JbkK9zSCffMq655FfBA3wuVYtAR05e9y4AHWJ4v3ahNx4S38B3SgpZUQ7jLf7LJOBIksCwCWbF3jWekK84W5dahjWaRWE/d7zfQMYKgBYI5eYVIcWWKZpALZkUBKLtC4e7Ll132MqqW7qpqqq0ob0x3zOhECod/+dFLb9TDH1hBqiYUnNWITWHxJ2Kyc4lrqNwkWpmreBkBAb9BIA7R/83QJNfIcLrawucyxNJW4HxuTbvGSH5vjypwHvjaqyoeeUzWVZR+Vops/+QMOnpHSzDKko35MzQiRUExK+ybPD266wpL9M6iSZN6zFiFNJtUKNK0ZAmqenRYTMmkY8y2VsEbxzLvGb7NNURZfd/d1gmIwCt6ZHBUSnT/Qq/xmIJ0GoSCl+fEC4R54lQHQ1o15Xrub056BtpELvnqyHvb6a+btoyYJhUL4RCWM4DpdnwvEPU60QPxnWZXnQMWWztNdhkW2d+BI4F73lgaJO53XAy+wmgf0MrN8EaU/REJyM8sprHRHUJgqfSZMMbW+ijH7rDT6enrr64ZiiH71obwSAelqkI2lAFvTq24AjYRkKPIv9t5KX9BOPa4Gy2EKtq07SZ1OoUGMV99n8+zP16encLEAmYs8Y5vBX67jZ5EDAwYBZ58gDJ9O5SMbVB0yB78oiF4dlGczRUolr4M0V+si9nyTEdpNF6PIebUkrGQPew1sCgRK5sa9PZqpUbyLarhrIf5WQHB0sFdAUjIBqRTu/OBNMnn71U4rDjsXGdrwb5lwz6an9gsPHG8CDgz
 xBI7Vi+Q
 WVqOsr1yuxZmAauZav9Tg//zAD6AXJcb+2WSELwRYvOXpZgxKfK53AWC30JPqd1y3Vp1e7gySqn7e3oKqAKtjtXHXXCAko/MfrlXLhGLZWEWBKoNuVljMrZCjGRMGF0lrGJlEpMJ7w7peMMnGrE+CPbyUIH6vYHjKpRYKMxs+9nFzMSTKYKfPyxYXmwVCdS6uWrhCBdOEHy6ft7XQIqV66haB4EnTwXVArcQ9OxQbmVr/T+Ik9WEuLcjXhOx/NcrD/PYnv6sTcnU2rM5AlYpcEsHo1ljvS+Y1ijQcs9xLuR1btAK5pdsdaKkBeZKX/dvMqeloaJbPWgiFMPRej9uOwkBk8iorQOR3sd8qbwQLLaRzO7jRBosHKJAXtv7xrIRgyTZP5yjmSIcZCWNwANxTi8TD6JFam6DlKl5MXGaVJPt6bdCXuv4xdeE6g7czv6lH9rQhR0G5uE3DmQC938gVSzrYnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass an order to collapse_huge_page to support collapsing anon memory to
arbitrary orders within a PMD. order indicates what mTHP size we are
attempting to collapse to.

For non-PMD collapse we must leave the anon VMA write locked until after
we collapse the mTHP-- in the PMD case all the pages are isolated, but in
the mTHP case this is not true, and we must keep the lock to prevent
access/changes to the page tables. This can happen if the rmap walkers hit
a pmd_none while the PMD entry is currently unavailable due to being
temporarily removed during the collapse phase.

To properly establish the page table hierarchy without violating any
expectations from certain architectures (e.g. MIPS), we must make sure to
have the PMD reinstalled before the PTEs, and hold both PTE/PMD locks
before calling update_mmu_cache_range() (if they are distinct locks).

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 105 ++++++++++++++++++++++++++++++------------------
 1 file changed, 67 insertions(+), 38 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e4b2ca77ecf6..c2769d82a719 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1228,34 +1228,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
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
@@ -1267,8 +1269,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
@@ -1283,20 +1285,28 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
+	/*
+	 * Only notify about the PTE range we will actually modify. While we
+	 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
+	 * it later, leaving other PTEs effectively unmodified. The locks we
+	 * hold prevent anybody from stumbling over such temporarily unmapped
+	 * PTE tables.
+	 */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
+				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
@@ -1308,26 +1318,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
+		VM_WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
 		 * We can only use set_pmd_at when establishing
 		 * hugepmds and never for establishing regular pmds that
@@ -1335,21 +1342,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
 
@@ -1359,18 +1369,37 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
-
 	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
+	VM_WARN_ON_ONCE(!pmd_none(*pmd));
+	if (is_pmd_order(order)) {
+		pgtable = pmd_pgtable(_pmd);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
+	} else {
+		/*
+		 * Some architectures (e.g. MIPS) walk the live page table in
+		 * their implementation. update_mmu_cache_range() must be called
+		 * with a valid page table hierarchy and the PTE lock held.
+		 * Acquire it nested inside pmd_ptl when they are distinct locks.
+		 */
+		if (pte_ptl != pmd_ptl)
+			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
+					  /*uffd_wp=*/ false);
+		if (pte_ptl != pmd_ptl)
+			spin_unlock(pte_ptl);
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
@@ -1550,7 +1579,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


