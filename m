Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5348CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505598E0019; Wed, 22 Oct 2025 14:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCD98E0010; Wed, 22 Oct 2025 14:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3258E0019; Wed, 22 Oct 2025 14:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4608E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6B1B16091E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:41 +0000 (UTC)
X-FDA: 84026613762.07.63685FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id CAE7B100005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SSAR8H1c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0874xyrbFj9nCaUgYHmm7XQDE60Cu0eJaiJ16eISOI=;
	b=Wpx9f8BF9kOQ8zPgsz4mz9NuFJqlOiT8ADW03UsmBh3JCQh8wSgwWXT3A1K1n8cpmb/8df
	bTW9+NxDAhEfXnIxzlusuUWxhdH6cnlqDZab1zqvNyN13cktvnVhYrD1UPLN/zvp3J+htU
	5bkHJ6T96npOspM8SflFdopEepwY8lU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158380; a=rsa-sha256;
	cv=none;
	b=wBc8O9kF5m/EJ0F3MwCZmf6hOxC8Zfbo2XoDj2nUL9d/p3I55ymm2ImKaLB9jWxcyVxPjZ
	8pq+/syICHMAk3lUS+WvPrhEzEBQ29Z5OEFPTIJlLSzhy0wJVGv9ewBMnXCbyAh9OTtNeJ
	0O+3N0hbNSKGyo5S5pQ9WsHvStO36zs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SSAR8H1c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T0874xyrbFj9nCaUgYHmm7XQDE60Cu0eJaiJ16eISOI=;
	b=SSAR8H1cDrd0lQC41timc6fc6JaQhFRFinBMcEOxxmUtGFJewWNVKcewTTzt5VVtlGC9mL
	wDpIz4S5XjowPa6Vw0/naOgvmbuwgjgKN2GpiMQLvs5RUVBgr0R5VtP2wfGpySVFymGbxx
	embjXdLDX128IRm0wM8KRJJylY30eJM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-Ja-c1inUPIW03c1skwYKog-1; Wed,
 22 Oct 2025 14:39:34 -0400
X-MC-Unique: Ja-c1inUPIW03c1skwYKog-1
X-Mimecast-MFC-AGG-ID: Ja-c1inUPIW03c1skwYKog_1761158369
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF181956089;
	Wed, 22 Oct 2025 18:39:29 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1680D19560B5;
	Wed, 22 Oct 2025 18:39:19 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 07/15] khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Wed, 22 Oct 2025 12:37:09 -0600
Message-ID: <20251022183717.70829-8-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Stat-Signature: 59pfenmfgsitr55s58ai1a689gfggzqd
X-Rspam-User: 
X-Rspamd-Queue-Id: CAE7B100005
X-HE-Tag: 1761158379-62829
X-HE-Meta: U2FsdGVkX1/eg9tLU0OHD1LjFyJj7Fz9EgKw+/AWR7OtgBgGYQbWTZ1Iv0zmZdNDfbo1mcYOom2+Ap/0SJtXxCeJ1L8yEhxFZ1pQ/Yb9wnrtvqJrCogYcDnXp+w98qNG06BMArhh9Oc6+eYNrSbr92dFIxHFaM/2BLpmOikyEjgv1RbTdGNUI3Yo3LToQp+c4xmgfL6ChzJt6lCRMUOsEDyVf1vhizQ64sHoWqeXjv+qtvaVaznFKh5oq+Uc+K8FuDWAOZnMqgFS1TcJqOlFRgBYBWxjD8b101kqn+CcdEE9tZo8S5p1+KKOBx8QPYUJLsnt4N32YuFIzuldUIP1n+YSWkeu/iYCzRxV9qJIfmvpdRk9KxVRNPmNpLCsQf/c4rvl0uI3/jL4QVQdDydYYX1Pk2p2qVkz3Aepzk2OQnrxO4fZISZyBti/p8nmOnQjfulBccMdfB8SMyUNBUApS2q/fV5HfmtO6XYf/AXBtEYRFoaXJ4ACSiNJ8YBNuv8HVun4Sl2A4sqbpe9Zf2VHeuu48ZA6o1Q2yJ8jlW4upbwNibdjG+4917TLEI9m3gzOkvJuuluD2EA7TLKLgOvgm0cJzCpEIgzaXuxGSZt8MP/UttNjTWFAtKYmsf+Vk75bk7RR2GJIpJY4TDYPglRWcRmNemgVvs18o39PU0v4jf+arQQdJlap+J29DDGhyf/uilNW1kYq7UlImebgxvLSse9+AK6hSd/isburV6c28JK3E/0wmJCs6dl8fWctrUwqNl0yWoAHsXdx/h6PpnHSOeTWoltUDi5d5dRrzSjLSkqlY0CrQ/wswDG/CJV69HgDa/T7prORsbr0w/HF+bZJ0S8Ozd9b7q+Hq3NbVv3aeTPrjZJ93MG8Vr41VlwNctdeUzgHzyNLxVdHoP+CMsHgrZ+t9WqKe18qIWl5SIx1Yg2FQzNDUergyq2Y7gO/Ma1+R0Y9sCSNAC4z+07wBIF
 Ac4KRPkO
 yflc0UP40fqhXSY+wXT+ybKtIZXC4Uyy1CU+UmHMuOy9Q2PFSfx5DEKsMGMVtT1aD8EN2ruHZO6Bu1cA+EDZ3+ZSDG5DmX0YNZQJnZQJeWqkJwE+mF6nkRDSp4NqgxfjcVL9OJt1aXAoibElkcyRA1mlALD1nO7BFa1OxGT4g0dKthH/tzq0GEfcKcI1bDk5/mNtVWL+gyHXYL86Qv4sJGOvDrz8sUzaGGJOoH/fTTT4t9bX/uBW4aRmhndGiSK+qLbLY65eKKczpp9r7aB64t/lVWUk3TGvP6GtXjb12WDJ/4xMAVsF43d7ZOh+W3EWw3KF95fbb+bzzmIcTR8ORGkZAkb1IkiAt8Rvi8O5JbGFnLq0Z2qGeSLGDdhqP2KeO+iERLc011haGjx8b5jFfifkVRWONCGNh9zX9834so2ncM9MfFGSP/P3sp5bNRWJOWuhnRDBqd9bucRw=
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
 mm/khugepaged.c | 108 ++++++++++++++++++++++++++++++------------------
 1 file changed, 67 insertions(+), 41 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 286c3a7afdee..75e7ebdccc36 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1142,43 +1142,50 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
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
@@ -1190,13 +1197,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1206,20 +1214,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1231,24 +1239,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
@@ -1258,21 +1263,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
 
@@ -1282,20 +1287,42 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
+	if (order == HPAGE_PMD_ORDER) {
+		pgtable = pmd_pgtable(_pmd);
 
-	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
-	spin_unlock(pmd_ptl);
+		spin_lock(pmd_ptl);
+		WARN_ON_ONCE(!pmd_none(*pmd));
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
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
@@ -1463,9 +1490,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, start_addr, referenced,
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


