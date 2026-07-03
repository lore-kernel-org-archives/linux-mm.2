Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CF5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCE76B00B8; Fri,  3 Jul 2026 13:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4966B00B9; Fri,  3 Jul 2026 13:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793996B00BA; Fri,  3 Jul 2026 13:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6046B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 997971C1BAC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:33 +0000 (UTC)
X-FDA: 84948177426.05.AA47DA9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4A3C20005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a72Q5Mvd;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100372;
	b=NdyCPdXkd5ZEd09SLt2FnbnQxUlHINxfZmwF1gOkO6lI2Qdha729MHy40r7glgkTZlp1CU
	g903ByYGO1D9n7Uzsnb44M1dFV4/+SYShQrcmOZI9qhv8NaOsDp7mLo09otVf1VrR6IQhb
	ghNc01Zqr93sdHVbeigacWcNyM3AseA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxvjJSitPN21yh9gTgaZnSsZHaLSkNSPRj6VDjcaAN4=;
	b=IoRfqm8l25IVhFnNKh+GM36u/iaXvKKjABb4MVNuwTbcdidDfO2k8gzaoMk23Lzqe3ATIO
	IActTXSvGgmvY++yQrrRnbBoVdJ7zMQ7iH3k0Gwl0xGHsHA/S0TVJlyRdWgi8eYA3CTsBN
	Cnjzh5Z/Q/7iBfq47jBtG40i18cvaVM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a72Q5Mvd;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxvjJSitPN21yh9gTgaZnSsZHaLSkNSPRj6VDjcaAN4=;
	b=a72Q5MvdJYEbNV8W6IJk2tgFVWcHV+CSvN7UQs3RNRiE8mhMWVtUnpmp+wKcFyTkmXZkr9
	da88SxfXHvjRcG0u/LL4gxjmVa754ClQNMZBW+VjW5SmqciJSHiJPnPfzSkTI4gGauqhln
	ImIwa1FNJhkqAqFuK+wTycyqxZTR1rk=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 03/11] mm: handle PMD swap entries in fork path
Date: Fri,  3 Jul 2026 10:38:20 -0700
Message-ID: <20260703173903.3789516-4-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ftpa7accgmniyqydrkgmkn4c3gd43uyc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4A3C20005
X-HE-Tag: 1783100371-712097
X-HE-Meta: U2FsdGVkX1/bEddvTJ+ouHsIkLLQhBPFbE22QPZy5KOQQNFiv8X4D39vfrTmAlLa+zDfGwVIZ3ymXZWkXqe4MU0xHhheOwGeMDt3b+mPAyNLFwHTYq9wQGiLmbzI5PrXoRhCNOTYr9wTuJtZoYOFlUqJ5OcjbKci9YaHiMCMQrBJ9w6XapkcluU4WUaU5QBXbg7OaeBjUnNeyWXaC2M54wvL5kT11XWGZ9f1ruvmtgXSJbBl1IfQqlAXg29ghRoaLNOU2V9bxPPM3iHUJYmiXVJdNWleWd4UoOemFyTKknCELf0vTvQgyXmIsddEaYQaNzYBG5k/Hp48asbBqrKXu9guZJUpuMhd25i4WOVxGje83g9mAGtMPxd5NnMyMY1zKImZGADyE5ns3RAoIR6UYP0Zw0uga/blyNSwmAW0IVJFjz+NRTyNcwPwSGgSMTctChyIhElHCjCFwtwW50P3/EaaFK1NQexYgZVuKQGprFqWfRKbPKYCIq1GuA3S+0G+XqHTfx/PjIj8Q9ZgIrr6CTkfuvmpdmREXtEARMrNhQ2DGHedH6t3YkgABKBQuBiDUIoMgDn95XdPMVZw1JEmvKeo5GbiQ1MaCWLSL75rPdIOCen+Gq3821lyS8FnQliCY+bruf/hAH+5kZrAXJ8DhRZ0dzSjlgmv9f9WRGNogmJvwrrjsaCXDapCVnNtpFSTzrPezBYRmHEkXQtTIgV8qMtYWBmuAHRJ2bxFAJxomY0rqCvW9KSTE/yvD+QR6uPo+w3fZIxGxPOkk7jEPDX4Y3WbysIsxjXY2a7mr3q+K8sTDHps2Qa/M9MZ1URMcFGNXAsvKNR8C/cmfDoXtvpbZiUSrulYRZNRFCG5WNwVt88vEI80OV3uY+J1pXtAwjiwmT1zdQn4b6gW+4lL5gPWn4BpZyAl0q0tgoGI1E6FsO1811Dh7chCQpFAc20nfeYSoeMuwZnV4VKVWfosLT7
 0VhMqnoP
 X9fi1eINv5BR6EzlIlpeZX/8xuKwQt6Ba2ipnzi0FHt3OA3d2hH6Pv8r4ZIxQKt4i80qp6mSqemLFFzyIccuKCI7VI981aW4FQSL/i9GjnwMGkphRwV4hlNsuXNZiPDWq8OhDnqW8OTkzL2OQorP1YmowKoEGCK71ibzkzAu7zoMm+lyV1pBNuk3dj/+LSlrvwrMOKajezn4jze4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach copy_huge_pmd()/copy_huge_non_present_pmd() about swap entries,
mirroring copy_nonpresent_pte().

swap_dup_entry_direct() gains a nr parameter (and is renamed to
swap_dup_entries_direct()) so it can duplicate a contiguous range of
swap slots in one call, matching the existing
swap_put_entries_direct(entry, nr) API.  Existing callers pass 1.

copy_huge_non_present_pmd() "copies" PMD swap entries during fork
instead of splitting, preserving the THP.  This mirrors
copy_nonpresent_pte() which duplicates the swap slot refcount,
clears the exclusive bit on the source, and adds the destination
mm to mmlist.  If swap_dup_entries_direct() fails (GFP_ATOMIC table
alloc), copy_huge_pmd() retries after swap_retry_table_alloc() with
GFP_KERNEL, matching the PTE retry in copy_pte_range().  The PMD is
stable across the retry because dup_mmap() holds write mmap_lock on
both mm_structs.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/swap.h |  4 ++--
 mm/huge_memory.c     | 53 ++++++++++++++++++++++++++++++++++++++------
 mm/memory.c          |  2 +-
 mm/swapfile.c        |  7 +++---
 4 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8d19be675baf..0b1db19e6ae3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -451,7 +451,7 @@ sector_t swap_folio_sector(struct folio *folio);
  * All entries must be allocated by folio_alloc_swap(). And they must have
  * a swap count > 1. See comments of folio_*_swap helpers for more info.
  */
-int swap_dup_entry_direct(swp_entry_t entry);
+int swap_dup_entries_direct(swp_entry_t entry, int nr);
 void swap_put_entries_direct(swp_entry_t entry, int nr);
 
 /*
@@ -495,7 +495,7 @@ static inline void free_swap_cache(struct folio *folio)
 {
 }
 
-static inline int swap_dup_entry_direct(swp_entry_t ent)
+static inline int swap_dup_entries_direct(swp_entry_t ent, int nr)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 201193ce0373..69e4e09ac1f6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1805,7 +1805,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static void copy_huge_non_present_pmd(
+static int copy_huge_non_present_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1851,14 +1851,35 @@ static void copy_huge_non_present_pmd(
 		 */
 		folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
 					    dst_vma, src_vma);
+	} else if (softleaf_is_swap(entry)) {
+		int err;
+
+		/*
+		 * PMD swap entry: duplicate swap references and clear
+		 * exclusive on source, matching copy_nonpresent_pte().
+		 */
+		err = swap_dup_entries_direct(entry, HPAGE_PMD_NR);
+		if (err < 0)
+			return err;
+
+		mm_prepare_for_swap_entries(dst_mm);
+
+		if (pmd_swp_exclusive(pmd)) {
+			pmd = pmd_swp_clear_exclusive(pmd);
+			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		}
 	}
 
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	if (softleaf_is_swap(entry))
+		add_mm_counter(dst_mm, MM_SWAPENTS, HPAGE_PMD_NR);
+	else
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_swp_clear_uffd_wp(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
+	return 0;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -1899,6 +1920,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pgtable))
 		goto out;
 
+retry:
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1906,11 +1928,28 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
-	if (unlikely(thp_migration_supported() &&
-		     pmd_is_valid_softleaf(pmd))) {
-		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
-					  dst_vma, src_vma, pmd, pgtable);
-		ret = 0;
+	if (unlikely(pmd_is_valid_softleaf(pmd))) {
+		ret = copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
+						addr, dst_vma, src_vma, pmd,
+						pgtable);
+		if (ret) {
+			spin_unlock(src_ptl);
+			spin_unlock(dst_ptl);
+			/*
+			 * For PMD swap entries -ENOMEM means the per-cluster
+			 * swap-extend table couldn't be GFP_ATOMIC-allocated.
+			 * try the GFP_KERNEL fallback once before giving up.
+			 */
+			if (ret == -ENOMEM) {
+				softleaf_t entry = softleaf_from_pmd(pmd);
+
+				if (softleaf_is_swap(entry) &&
+				    !swap_retry_table_alloc(entry, GFP_KERNEL))
+					goto retry;
+			}
+			pte_free(dst_mm, pgtable);
+			goto out;
+		}
 		goto out_unlock;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 6637c5b13c9b..e0819a562187 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -950,7 +950,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	struct page *page;
 
 	if (likely(softleaf_is_swap(entry))) {
-		if (swap_dup_entry_direct(entry) < 0)
+		if (swap_dup_entries_direct(entry, 1) < 0)
 			return -EIO;
 
 		mm_prepare_for_swap_entries(dst_mm);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5a69716b2052..0695dbd1a8b1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3899,8 +3899,9 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
+ * swap_dup_entries_direct() - Increase reference count of swap entries by one.
  * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: number of contiguous swap entries to duplicate.
  *
  * Returns 0 for success, or -ENOMEM if the extend table is required
  * but could not be atomically allocated.  Returns -EINVAL if the swap
@@ -3912,7 +3913,7 @@ void si_swapinfo(struct sysinfo *val)
  * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
  * be used.
  */
-int swap_dup_entry_direct(swp_entry_t entry)
+int swap_dup_entries_direct(swp_entry_t entry, int nr)
 {
 	struct swap_info_struct *si;
 
@@ -3929,7 +3930,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	 */
 	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
 
-	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
+	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-- 
2.53.0-Meta


