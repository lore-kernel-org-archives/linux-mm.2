Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C99C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56B56B019D; Tue, 18 Aug 2026 09:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07436B019E; Tue, 18 Aug 2026 09:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6FF6B019F; Tue, 18 Aug 2026 09:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3D46B019D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC6301A013B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:26 +0000 (UTC)
X-FDA: 85114429092.11.7EA458D
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 192091A0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O+S6qEO9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+VWZL6Caa1JbcGY4NmyVZSeKhHUi3YyDSSuEk7EYH8=;
	b=DvveahN3HmxKhstE/zKeI5XtlI8Wjt9fWKfB601vYRFKM9Jqo4RC5tkAp1LKyklkG6zEnp
	qWz+1Fahyo22kyf1w8/nnZ5kHmUoO5IDsNgjcmy/BYfs4AMKNQyJlYqUYHNitk1JIhKBod
	wt008HlGuigA6PkHKOQciyqGKzaiYio=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O+S6qEO9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058745;
	b=SDn6c3WgstSdQBOHKwiqxBLSosWx/w/wjbbW0+0piVdSZy4iWU9uaFJPLGDIQeTnKXVL30
	LOAnsmJsMRg6MfU/bjL5RDBmJDRd4X7Z9PlEs1jTdWrAirMhZXR3bab6O86wpC2IaO7M8D
	7xbOhGux6K1k2kfbjWy6qbhIc+1ekwI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U1HZxdR4YZz99uGbDOKosgWNZREILwS2Y40gIn/27F0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058743; v=1; x=1787663543;
 b=O+S6qEO9/mKiXyn8/U3czBJALoojR+1m5dLirY24t6qvJgVhoSLQOUA2TXwstSl1Rf+cB6Tc
 FXkYtNRyr5bPj9KJe3lt/wCyyBU55g3J4HserB3552UavkJJddANsiNoX0ICtt4XkHrII1SRX51
 PI8JYvFCTTXd7o5laAMVq9l8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:58::)
	by mta11.migadu.com with ESMTPS id d2282fcef2b2083d;
	Tue, 18 Aug 2026 13:12:23 +0000
X-Migadu-Flow: FLOW_OUT
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
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 04/12] mm: handle PMD swap entries in fork path
Date: Tue, 18 Aug 2026 06:09:45 -0700
Message-ID: <20260818131202.494754-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 192091A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: aw3m4emcdhsrmtxp5n1mz5dqmc7sre5p
X-HE-Tag: 1787058744-744611
X-HE-Meta: U2FsdGVkX1/FOF4bh1AVCXqnX8IesLXfRtoqI2sNCOIPQ1LuoDqmDh1CYhNboFQ6vcMNsxvF1FW4tx8zfAL3FQpWlJM17q1KG2EGii1GriEFEiuN7Ne4WqRsfFpRW/Abxx3TjPlzh8IzPLRa6JpG3qb2x3CMYfWzVgIn/+uMVLdNsgLG0mo5BiQzzULSoQ22JZhEQRzA+LjX7vX2G7tIYlOyzuYxQQ//EZOlMPtHENoo96YPnfpOHGWQ1iNI54UhhYL6IcZDFzknu+AKBrjmR/dYEuI5ae0Apz3IEOAaGyDIe08PIpWPVqN/edLI4IytKYKaxMH7NjOijhRNMCSOd48t922pfHZRZ4NXp2qxtDc3RZ+u3dHnSM0iA+mtX4sr7BQWRev26ZPEn00dqx6gppEvEta+RXdaAL8gpQOI/zWVyZy0Jx3Y1IHRX4mOikYZMeIPRCW+/d52wUqdP+4/cDfMzh5hhugpLBXzxG/ilt5qTk3jHC0AB0tJc/Npm4W+WH0iHXDpmJPxrSROXo17ovTIlUdoJm+Dw7uBvquPS8xcVfEnm4XOslBUVQVMI5hgx0HmiAKQjUyvRu53pGUd0gbodstwqOTcVaTobdG4Rz+Og7dH3rCNxnXxwBTs9gsthrZo0PDG2v30SRWHRlo8gXo6ne+yYPPRjpH65UQl6fyeo8tNp03DmMFpinouRpIkMaJ1M5HryAfbvuL3FLYeNMyGAp2+BNplY/yD0oAv3ZJAGYm56z4yAdxwMT20xLzrcl/JgD/qIZ5nEn//qcb4OGWuYuwhMzS84IVeDSN9XpCLMfrpah/k+9Vx1r5ZlnE1k6qR3T358M3Nd7D+QkIWCQmup4Jy+X5LzTRhJfGyt3Hpag0VmfoZUWYfq1Hr/Yc4becYR5mia20mkDoGE+GwARcPXKLm+CqrgzVG8UFXh1vWiCMai8pAG2APGbEgTjRyuOW27xA3Q+ykmIavuFX
 lDSdnoE4
 YYWu/Bmz1lHRmLgF3g1SkW7G4A/Xcr//uLJpzPbkuKXneDgHWEUHIsiAEw8vl9KuEGOtte1/sC/I2OHLcYIjRFq1tTjUzVEOLrI8TqAkQqGJTaNzhMNns9iDsjKXOiF9GfWEny36OFsVeIBehW+syUIlc1zwzEfAAvPXCH0UWGSNgCogmF3pbG6/BLqwOwn3W3erZUG5/rFJMwQ3n4zmY7QygC2Jv7thnpQHFl9q8td8VnH77icuX6md3j1E0fSqE0EMa8eMM1gZn2nEwa2FVg+AMiQ==
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

swap_retry_table_alloc() likewise gains a nr parameter so the outer
retry knows how many slots the caller was trying to duplicate.  The
underlying swap_extend_table_alloc() now scans every slot in
[ci_off, ci_off + nr) to confirm that at least one still needs the
per-cluster extend table before committing an allocation.

copy_huge_non_present_pmd() "copies" PMD swap entries during fork
instead of splitting, preserving the THP.  This mirrors
copy_nonpresent_pte() which duplicates the swap slot refcount,
clears the exclusive bit on the source, and adds the destination
mm to mmlist.  If swap_dup_entries_direct() fails (GFP_ATOMIC table
alloc), copy_huge_pmd() retries once after
swap_retry_table_alloc(entry, HPAGE_PMD_NR, GFP_KERNEL).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/swap.h |  4 +--
 mm/huge_memory.c     | 60 ++++++++++++++++++++++++++++++++++++++------
 mm/memory.c          |  4 +--
 mm/swap.h            |  5 ++--
 mm/swapfile.c        | 40 ++++++++++++++++++-----------
 5 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0f953ed9c8630..e465069361733 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -395,7 +395,7 @@ sector_t swap_folio_sector(struct folio *folio);
  * All entries must be allocated by folio_alloc_swap(). And they must have
  * a swap count > 1. See comments of folio_*_swap helpers for more info.
  */
-int swap_dup_entry_direct(swp_entry_t entry);
+int swap_dup_entries_direct(swp_entry_t entry, int nr);
 void swap_put_entries_direct(swp_entry_t entry, int nr);
 
 /*
@@ -439,7 +439,7 @@ static inline void free_swap_cache(struct folio *folio)
 {
 }
 
-static inline int swap_dup_entry_direct(swp_entry_t ent)
+static inline int swap_dup_entries_direct(swp_entry_t ent, int nr)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a473e85d30f51..2735c3de7029c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1849,7 +1849,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static void copy_huge_non_present_pmd(
+static int copy_huge_non_present_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1895,14 +1895,35 @@ static void copy_huge_non_present_pmd(
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
 	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
+	return 0;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -1912,6 +1933,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
 	struct folio *src_folio;
+	bool retried = false;
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
@@ -1943,6 +1965,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pgtable))
 		goto out;
 
+retry:
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1950,11 +1973,34 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
+			 * Try the GFP_KERNEL fallback once before giving up.
+			 * swap_retry_table_alloc() also returns 0 when it
+			 * decides the table is not needed after all, so bound
+			 * this to a single retry rather than looping on it.
+			 */
+			if (ret == -ENOMEM && !retried) {
+				softleaf_t entry = softleaf_from_pmd(pmd);
+
+				retried = true;
+				if (softleaf_is_swap(entry) &&
+				    !swap_retry_table_alloc(entry, HPAGE_PMD_NR,
+							    GFP_KERNEL))
+					goto retry;
+			}
+			pte_free(dst_mm, pgtable);
+			ret = -ENOMEM;
+			goto out;
+		}
 		goto out_unlock;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0f..36ddca806be2f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1016,7 +1016,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	struct page *page;
 
 	if (likely(softleaf_is_swap(entry))) {
-		if (swap_dup_entry_direct(entry) < 0)
+		if (swap_dup_entries_direct(entry, 1) < 0)
 			return -EIO;
 
 		mm_prepare_for_swap_entries(dst_mm);
@@ -1431,7 +1431,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 
 	if (ret == -EIO) {
 		VM_WARN_ON_ONCE(!entry.val);
-		if (swap_retry_table_alloc(entry, GFP_KERNEL) < 0) {
+		if (swap_retry_table_alloc(entry, 1, GFP_KERNEL) < 0) {
 			ret = -ENOMEM;
 			goto out;
 		}
diff --git a/mm/swap.h b/mm/swap.h
index 90a551a88df63..e225527b2eb7a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -222,7 +222,7 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 	spin_unlock_irq(&ci->lock);
 }
 
-extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
+int swap_retry_table_alloc(swp_entry_t entry, unsigned int nr, gfp_t gfp);
 
 /*
  * Below are the core routines for doing swap for a folio.
@@ -428,7 +428,8 @@ static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return 0;
 }
 
-static inline int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
+static inline int swap_retry_table_alloc(swp_entry_t entry, unsigned int nr,
+					 gfp_t gfp)
 {
 	return -EINVAL;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f5dfc7e59191e..44b9ebbe7229f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1462,9 +1462,11 @@ static bool swap_sync_discard(void)
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
 				   struct swap_cluster_info *ci,
-				   unsigned int ci_off, gfp_t gfp)
+				   unsigned int ci_off, unsigned int nr,
+				   gfp_t gfp)
 {
 	int count;
+	unsigned int i;
 	void *table;
 
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
@@ -1480,15 +1482,21 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
 	 */
 	if (!cluster_table_is_alloced(ci))
 		goto out_free;
-	count = swp_tb_get_count(__swap_table_get(ci, ci_off));
-	if (count < (SWP_TB_COUNT_MAX - 1))
-		goto out_free;
 	if (ci->extend_table)
 		goto out_free;
-
-	ci->extend_table = table;
-	spin_unlock(&ci->lock);
-	return 0;
+	/*
+	 * The caller may not know which slot in [ci_off, ci_off + nr) hit
+	 * SWP_TB_COUNT_MAX - 1. Confirm at least one slot in the range still
+	 * needs the extend table before committing the allocation.
+	 */
+	for (i = 0; i < nr; i++) {
+		count = swp_tb_get_count(__swap_table_get(ci, ci_off + i));
+		if (count >= (SWP_TB_COUNT_MAX - 1)) {
+			ci->extend_table = table;
+			spin_unlock(&ci->lock);
+			return 0;
+		}
+	}
 
 out_free:
 	spin_unlock(&ci->lock);
@@ -1496,7 +1504,7 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
 	return 0;
 }
 
-int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
+int swap_retry_table_alloc(swp_entry_t entry, unsigned int nr, gfp_t gfp)
 {
 	int ret;
 	struct swap_info_struct *si;
@@ -1508,7 +1516,8 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), nr,
+				      gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1709,7 +1718,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, 1,
+							      GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;
@@ -1720,6 +1730,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
+	/* The caller's page-table or swap-cache reference pins every slot. */
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
 	swap_extend_table_try_free(ci);
@@ -3925,8 +3936,9 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
+ * swap_dup_entries_direct() - Increase reference count of swap entries by one.
  * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: number of contiguous swap entries to duplicate.
  *
  * Returns 0 for success, or -ENOMEM if the extend table is required
  * but could not be atomically allocated.  Returns -EINVAL if the swap
@@ -3938,7 +3950,7 @@ void si_swapinfo(struct sysinfo *val)
  * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
  * be used.
  */
-int swap_dup_entry_direct(swp_entry_t entry)
+int swap_dup_entries_direct(swp_entry_t entry, int nr)
 {
 	struct swap_info_struct *si;
 
@@ -3955,7 +3967,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	 */
 	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
 
-	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
+	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-- 
2.53.0-Meta


