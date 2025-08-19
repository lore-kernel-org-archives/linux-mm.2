Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DD6CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321AA8E0042; Tue, 19 Aug 2025 09:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2248E0007; Tue, 19 Aug 2025 09:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199EA8E0042; Tue, 19 Aug 2025 09:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 041478E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:45:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B2DF5A743
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:59 +0000 (UTC)
X-FDA: 83793627918.29.5BF3B08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 94927180003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GEgQXyqc;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611097; a=rsa-sha256;
	cv=none;
	b=CBN0ctkDONkKiA6iL8d0tJ84PgK/dV1SPBgA37K7CVb3rWzmctNPMg6enJYhqyF44ln7In
	gJ4g1BPnUq1OVg7L37JhVIBIwMJz2lWC4ERl7kakRdISZgj/teNEa5YOO6vq7LDcEwGeJU
	28mqiQA9jcdSubxjN5BQz4bu26aVW5Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GEgQXyqc;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+ADnhqPDJQAloHp02DAJ9LRNY/hQI9liEeFJZyVYtA=;
	b=VDFkdOwRHiB4bGK7rnM/t566j6g8d1bxg2PsR0VjsKrrUoiJYQNL1fvtpSEQLuA8nY0qP7
	7Ez+sot7SLZn0LOT45CO2R11DK5rGIH5Qupl68w4Rfr8b27qEFyl9EYlUWGxrymRfA30t/
	SnRGcTzXB2y4QhOqIr3kpHnQZcKU9WE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v+ADnhqPDJQAloHp02DAJ9LRNY/hQI9liEeFJZyVYtA=;
	b=GEgQXyqcuDe+KivxN6YJjff1cTFxCy7Ogbyb/IUEyXgRdi3dbx64U6FaHfEAiA+bIODqbL
	li5YheF3VuwWSuHWbFYnIns1Fhlj8ndBd25VGjD216IGQe6NnvkpgCGXbSbpeUid7fF05y
	dIz77LFfdSPoEHkQTBmszu3ZvTdPRBY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-W1cbFdp8PPygjDrY8ILXZg-1; Tue,
 19 Aug 2025 09:44:55 -0400
X-MC-Unique: W1cbFdp8PPygjDrY8ILXZg-1
X-Mimecast-MFC-AGG-ID: W1cbFdp8PPygjDrY8ILXZg_1755611090
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C528195608E;
	Tue, 19 Aug 2025 13:44:50 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4917519560AB;
	Tue, 19 Aug 2025 13:44:30 +0000 (UTC)
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 06/13] khugepaged: add mTHP support
Date: Tue, 19 Aug 2025 07:41:58 -0600
Message-ID: <20250819134205.622806-7-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94927180003
X-Stat-Signature: wi7m68nx5gza1yop8es58qody5wt43m9
X-Rspam-User: 
X-HE-Tag: 1755611097-63040
X-HE-Meta: U2FsdGVkX19pD2yFpJQ72LoQ1xbYGW9mHzTiopR2gElaMx/U4S5Ko9Mr8B5N/C0LZfBUXqxeSXpKk4f4eBU1RhhtjVjaX/Z+oprgP2Oey7uIHjUG02XZlGzdIzbRuPIlx8myxMzeWG6QC3KdATSyTda0i7dbs+8cmhSVlYwTyu0s45lSM+nIVzy2UdjPU9Ag2ndLCPspLMaysb/KzSNtVH7AdoGBOpuwj5vPsJ2VXokcdzieOZjtqe+USZsvxb5UNo7ppZUbSDULyLzYCvhIZyL8jP0lsmQDG2vMgwfuoZVpQBlgehwjQfkVFXy6p2L1qY7bqKM+kTDkW0mNrzW/dRve8ofQhUFIqfjPgtzL7uMCr9O04NM9hU/9rzWqMCr5qBoQRoqlX87On1eL1eQIw/MG/4muc8TKydtEHP4ez+gZVd5LWvQ0YlXdTumzeDfG/QLbbi4n9R4yYbnBfw7DhDX5SQfLViKug4HvhTVJSXDIBzkA+22BLpkV5xtXKpKecUIqGiG1obY01F0ivsKwvtRExTgo423IZnBytYV9DZnW+5vt1aRowd8qOiMFpZU+m7z53ZTZjFgkCdHXUnsFOSxzw5V46yQSYlUzQr8tXpT+jMdm9Xj3KJPo6Q7xzf1ksdR1j09HotedU6GB5or/dSjnj2okoL0wUaXbovjy7kQa8Kd67/98wGb7Sz941iB8y2aVz+C2/0gxy3LTnNoMzEuLJvpCPBMdPaxcBQzQLvXWgEm8JJqMnWV8CFNxbYdgH5yM+/gGL2MW5lTPOwYeysnGUte/BFbeHHTH+jMJukjaBalBFL3qv84BH8TpDwYYf4qvJaqx7r+pmmyBSIqKPidI2zlx1DsqlMUIKidqmIXRtAeAdSixpLCqfvlKf+E8Sr9tJu85ASlvdEyWXkeYA5CxjCzovS5aTfnsk2coCpYEwVcB1w/jFLqkEl02VExMpt20IJHRBb4xJbgVDPs
 fI7TKFQk
 nyj6xuZjzlaQ0IulBtpNg79DvpvENk1Duotp9L/HTdctO/EutYnmRbQyM5q0Pf2T8aU4Ga7U3W+jW9rsz6My6RxSkviK17S8FunNfSO0DWqK3msAFbAg+uOlTJSsvDwGL27TSJz3Qt98WMZQfVth9j78moYVHnKdelZLgWaXMmcxj408PtA2zvkfvlrIqM2jvlS2/5iOsB4MoKFYKkF3g116Xe56f9HdLgNLadVC47DHkZOAdC88KxKcYusGGq7nL3ZX8XbBIkPJzW+KMJznYpnXaUNIx+fGZDE1HCtFz5R7ACVIKhwfIl7/oKZpUeO8VDou53OI0iUmc4jgayxo8B5WkcNpbQNfDX0XrGSp3xDtV27mRNECQxV41sA9nHdbxubOz84klukeS/g3rfeIVd3UeuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the ability for khugepaged to collapse to different mTHP sizes.
While scanning PMD ranges for potential collapse candidates, keep track
of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER ptes. If
mTHPs are enabled we remove the restriction of max_ptes_none during the
scan phase so we don't bailout early and miss potential mTHP candidates.

A new function collapse_scan_bitmap is used to perform binary recursion on
the bitmap and determine the best eligible order for the collapse.
A stack struct is used instead of traditional recursion. max_ptes_none
will be scaled by the attempted collapse order to determine how "full" an
order must be before being considered for collapse.

Once we determine what mTHP sizes fits best in that PMD range a collapse
is attempted. A minimum collapse order of 2 is used as this is the lowest
order supported by anon memory.

For orders configured with "always", we perform greedy collapsing
to that order without considering bit density.

If a mTHP collapse is attempted, but contains swapped out, or shared
pages, we don't perform the collapse. This is because adding new entries
can lead to new none pages, and these may lead to constant promotion into
a higher order (m)THP. A similar issue can occur with "max_ptes_none >
HPAGE_PMD_NR/2" due to the fact that a collapse will introduce at least 2x
the number of pages, and on a future scan will satisfy the promotion
condition once again.

For non-PMD collapse we must leave the anon VMA write locked until after
we collapse the mTHP-- in the PMD case all the pages are isolated, but in
the non-PMD case this is not true, and we must keep the lock to prevent
changes to the VMA from occurring.

Currently madv_collapse is not supported and will only attempt PMD
collapse.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/khugepaged.h |   4 +
 mm/khugepaged.c            | 236 +++++++++++++++++++++++++++++--------
 2 files changed, 188 insertions(+), 52 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..d12cdb9ef3ba 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+#define KHUGEPAGED_MIN_MTHP_NR	(1 << KHUGEPAGED_MIN_MTHP_ORDER)
+#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
+#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER))
 
 #include <linux/mm.h>
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 074101d03c9d..1ad7e00d3fd6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+struct scan_bit_state {
+	u8 order;
+	u16 offset;
+};
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -102,6 +107,18 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/*
+	 * bitmap used to collapse mTHP sizes.
+	 * 1bit = order KHUGEPAGED_MIN_MTHP_ORDER mTHP
+	 */
+	DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
+	DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
+	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
+};
+
+struct collapse_control khugepaged_collapse_control = {
+	.is_khugepaged = true,
 };
 
 /**
@@ -854,10 +871,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -1136,17 +1149,19 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 
 static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+			      struct collapse_control *cc, bool *mmap_locked,
+			      unsigned int order, unsigned long offset)
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
+	unsigned long _address = address + offset * PAGE_SIZE;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1155,16 +1170,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
-					 BIT(HPAGE_PMD_ORDER));
+	*mmap_locked = true;
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1182,13 +1201,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_swapin(mm, vma, _address, pmd,
+						     referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
 
 	mmap_read_unlock(mm);
+	*mmap_locked = false;
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the ptep_clear_flush and the VM
@@ -1198,8 +1218,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 BIT(HPAGE_PMD_ORDER));
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -1210,11 +1229,12 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	anon_vma_lock_write(vma->anon_vma);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-				address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _address,
+				_address + (PAGE_SIZE << order));
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
+
 	/*
 	 * This removes any huge TLB entry from the CPU so we won't allow
 	 * huge and small TLB entries for the same virtual address to
@@ -1228,19 +1248,16 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);
 	if (pte) {
-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-						      &compound_pagelist,
-						      HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_isolate(vma, _address, pte, cc,
+						      &compound_pagelist, order);
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
@@ -1255,17 +1272,17 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	}
 
 	/*
-	 * All pages are isolated and locked so anon_vma rmap
-	 * can't run anymore.
+	 * For PMD collapse all pages are isolated and locked so anon_vma
+	 * rmap can't run anymore
 	 */
-	anon_vma_unlock_write(vma->anon_vma);
+	if (order == HPAGE_PMD_ORDER)
+		anon_vma_unlock_write(vma->anon_vma);
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, address, pte_ptl,
-					   &compound_pagelist, HPAGE_PMD_ORDER);
-	pte_unmap(pte);
+					   vma, _address, pte_ptl,
+					   &compound_pagelist, order);
 	if (unlikely(result != SCAN_SUCCEED))
-		goto out_up_write;
+		goto out_unlock_anon_vma;
 
 	/*
 	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
@@ -1273,33 +1290,115 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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
+		BUG_ON(!pmd_none(*pmd));
+		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		set_pmd_at(mm, address, pmd, _pmd);
+		update_mmu_cache_pmd(vma, address, pmd);
+		deferred_split_folio(folio, false);
+		spin_unlock(pmd_ptl);
+	} else { /* mTHP collapse */
+		mthp_pte = mk_pte(&folio->page, vma->vm_page_prot);
+		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
+
+		spin_lock(pmd_ptl);
+		BUG_ON(!pmd_none(*pmd));
+		folio_ref_add(folio, (1 << order) - 1);
+		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << order));
+		update_mmu_cache_range(NULL, vma, _address, pte, (1 << order));
+
+		smp_wmb(); /* make pte visible before pmd */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		spin_unlock(pmd_ptl);
+	}
 
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
+out_unlock_anon_vma:
+	if (order != HPAGE_PMD_ORDER)
+		anon_vma_unlock_write(vma->anon_vma);
 out_up_write:
+	if (pte)
+		pte_unmap(pte);
 	mmap_write_unlock(mm);
 out_nolock:
+	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
 
+/* Recursive function to consume the bitmap */
+static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
+			int referenced, int unmapped, struct collapse_control *cc,
+			bool *mmap_locked, unsigned long enabled_orders)
+{
+	u8 order, next_order;
+	u16 offset, mid_offset;
+	int num_chunks;
+	int bits_set, threshold_bits;
+	int top = -1;
+	int collapsed = 0;
+	int ret;
+	struct scan_bit_state state;
+	bool is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+
+	cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+		{ HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };
+
+	while (top >= 0) {
+		state = cc->mthp_bitmap_stack[top--];
+		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
+		offset = state.offset;
+		num_chunks = 1 << (state.order);
+		/* Skip mTHP orders that are not enabled */
+		if (!test_bit(order, &enabled_orders))
+			goto next_order;
+
+		/* copy the relavant section to a new bitmap */
+		bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap, offset,
+				  MTHP_BITMAP_SIZE);
+
+		bits_set = bitmap_weight(cc->mthp_bitmap_temp, num_chunks);
+		threshold_bits = (HPAGE_PMD_NR - khugepaged_max_ptes_none - 1)
+				>> (HPAGE_PMD_ORDER - state.order);
+
+		/* Check if the region is "almost full" based on the threshold */
+		if (bits_set > threshold_bits || is_pmd_only
+			|| test_bit(order, &huge_anon_orders_always)) {
+			ret = collapse_huge_page(mm, address, referenced, unmapped,
+						 cc, mmap_locked, order,
+						 offset * KHUGEPAGED_MIN_MTHP_NR);
+			if (ret == SCAN_SUCCEED) {
+				collapsed += (1 << order);
+				continue;
+			}
+		}
+
+next_order:
+		if (state.order > 0) {
+			next_order = state.order - 1;
+			mid_offset = offset + (num_chunks / 2);
+			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+				{ next_order, mid_offset };
+			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+				{ next_order, offset };
+		}
+	}
+	return collapsed;
+}
+
 static int collapse_scan_pmd(struct mm_struct *mm,
 			     struct vm_area_struct *vma,
 			     unsigned long address, bool *mmap_locked,
@@ -1307,31 +1406,60 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
+	int i;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long _address;
+	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	bool is_pmd_only;
 	bool writable = false;
-
+	int chunk_none_count = 0;
+	int scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
+	unsigned long tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, address, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
+	bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	if (cc->is_khugepaged)
+		enabled_orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+			tva_flags, THP_ORDERS_ALL_ANON);
+	else
+		enabled_orders = BIT(HPAGE_PMD_ORDER);
+
+	is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		/*
+		 * we are reading in KHUGEPAGED_MIN_MTHP_NR page chunks. if
+		 * there are pages in this chunk keep track of it in the bitmap
+		 * for mTHP collapsing.
+		 */
+		if (i % KHUGEPAGED_MIN_MTHP_NR == 0) {
+			if (i > 0 && chunk_none_count <= scaled_none)
+				bitmap_set(cc->mthp_bitmap,
+					   (i - 1) / KHUGEPAGED_MIN_MTHP_NR, 1);
+			chunk_none_count = 0;
+		}
+
+		_pte = pte + i;
+		_address = address + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1354,10 +1482,11 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++chunk_none_count;
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    (!cc->is_khugepaged || !is_pmd_only ||
+				none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1453,6 +1582,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 								     address)))
 			referenced++;
 	}
+
 	if (!writable) {
 		result = SCAN_PAGE_RO;
 	} else if (cc->is_khugepaged &&
@@ -1465,10 +1595,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
-					    unmapped, cc);
-		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+		result = collapse_scan_bitmap(mm, address, referenced, unmapped, cc,
+					      mmap_locked, enabled_orders);
+		if (result > 0)
+			result = SCAN_SUCCEED;
+		else
+			result = SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
-- 
2.50.1


