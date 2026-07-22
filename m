Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5580C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17BD6B00B8; Wed, 22 Jul 2026 11:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF706B00B9; Wed, 22 Jul 2026 11:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BAB6B00BA; Wed, 22 Jul 2026 11:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928166B00B8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:21:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1956F1401ED
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:17 +0000 (UTC)
X-FDA: 85016776194.26.F544DAC
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E80E4000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbOoEviI;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFb7iXegiOEvoQSm0YBXbtn9EVLn1rv63FDAlxcMKO8=;
	b=FHBm1reFslaO4UWWrf8arRkCdod1FUX4t+mea7iTadlxUpDJj6JOMO67xvMok8+GMHniqr
	NNnPpyFIOeUTz/+SFEqrvHkoubwOIKby+b5zgb9Ysvk9xDabUDb5yFJiRmX3vRMrbBRrxs
	5IXHeMDXF8EA1xy2LhHIHBozvKGX1Vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733675;
	b=O2CXSnXVSETSzJu5rzD4lWnQyD0lNRVqsab+iJLUOXFhUOI6YX818XEX8D+b33sc/xapI2
	I4ddkHLfyqDGOmFT5xWGAy+h6w24C4d2tSIGVOif0PAlsewOVkKcle1W845VOF5GlTP97h
	mOl8f2VOG/d8b1FIgCuRdHo3AAxSrKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbOoEviI;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wFb7iXegiOEvoQSm0YBXbtn9EVLn1rv63FDAlxcMKO8=;
	b=xbOoEviIZpBR7FjEBq1JTlzegpmV+KZp69GfUx1yeBEpDeKThVnG5VEv+p5674FCmgPnOH
	pDEilOxVCN5oB6NkdZXI1YGnGRH6d3I7D8Dc0Yl8KbjCj1iv5CW2z4GUriFUk5vew1mkxz
	3zo4E/LxHV0J//L0MyTY7om6UOEr9lA=
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
Subject: [PATCH v5 03/11] mm: handle PMD swap entries in fork path
Date: Wed, 22 Jul 2026 08:19:34 -0700
Message-ID: <20260722152043.2273289-4-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E80E4000D
X-Stat-Signature: 4cbjybjq4gpj3zwzx1t3wnasnuwqi3nb
X-Rspam-User: 
X-HE-Tag: 1784733675-49900
X-HE-Meta: U2FsdGVkX1/AUIQcCKK8/O/A0Ps6vad/LpCTf1fSCzCttL04szHMJFTUU+INff7QbP+8IjwPHV8kWngmCLX/Z1gkiVCcgMsL7nd22JwkEXqbxGkBzncoX0AhoyP8nEK6RmzNHFWg8pdb6Vi6in/At952lwRPz83qB/Kvm7iaSue6qqGYyLb39CNKN4z1mCOrLoDaCchYmBlS425o/cXVmOeEyDId8jO4gjV+/yYyGmTxC/cX1ISn6juUErvsR5P5KLZWHcayM8/xmNyi7dxMTKtgNCa/UGJC6pB5ZlpMazEckUYW29Rx3FCsolKPI8M31e5iBEUZRINmsqpXQHZyAwVNaRSHVgRl1O/MvmVeWUZDAszu5eJ+h4IJY4n9+a3GSr9GsKGW7r1XRoxVlIbMPMRS65f+gdefj8A9Ch8uAEWX0pu6+M9ZQHS1b+v6mIPL/qgzyZHhsHleRp01DI+fE2CIQesT2oBHFt01YcMA8SYt3XSeeCCgWytPO34Dihmlq37vYzAyxYo3FgNehql0sKEzaEYlgsFJc5jZa4MC7wgHPxl4PB4+/HZc2IcTyMZJi7ow+C7EZP/Qic1i745o2sgSMNyqKRXb9kCPn2JMHLySG7tv8UMYbS/YinktCvHcgMNLCS6viDl7gAJsqVSxjhVqjCCYcLvswpe7Oig74iLQJFuXHV56czHALzqoRi3gklySXhOO4lH65OmfpS6T2jrrEgmRvWfO+Sh/JLnGYkF475/F4BOoSkGdLxsG52H9x72ChXyUtn68BT4JhCvWrY7cebBBSkBnifG9kVqtZYfxlO/6jqQr6d+tF7bbgHT1Er2OXvUld/9mhvjnDRhdBZe26jpQ26SuI65BQPXwO5CUmKgBT7oiVoCEs5Nf/btYbx2Grh5f3fipqsay1sXQj6wx0HL7iG/vA58tfSdklCt2mz1kqAI5SWit2YP7kIHhBeSg4bj4r3iFRL45fIn
 8lT8z0rF
 39Ji6eUjH0L7RWYpyFDk+9YnEVPBHPAYuIhasFCInM18AmBgHxVnoNP6SA+DVaefAAHMPihABh0XBLFhyJzn4ypPpAk0AwmiCZPC5b4aCzYiHJchRQDaHerzBoUBhz5/veV4YsAPji1F2fqlm2ycBDDv3C0deJQsdijugDiXsxh7HfFVr+vnKeJBHXQNwab4f7BAWXJS7g6vzZFc=
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
alloc), copy_huge_pmd() retries after
swap_retry_table_alloc(entry, HPAGE_PMD_NR, GFP_KERNEL), matching
the PTE retry in copy_pte_range().  The PMD is stable across the
retry because dup_mmap() holds write mmap_lock on both mm_structs.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/swap.h |  4 ++--
 mm/huge_memory.c     | 54 ++++++++++++++++++++++++++++++++++++++------
 mm/memory.c          |  4 ++--
 mm/swap.h            |  5 ++--
 mm/swapfile.c        | 40 ++++++++++++++++++++------------
 5 files changed, 80 insertions(+), 27 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 32da5647171d..e8ad2741142c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -390,7 +390,7 @@ sector_t swap_folio_sector(struct folio *folio);
  * All entries must be allocated by folio_alloc_swap(). And they must have
  * a swap count > 1. See comments of folio_*_swap helpers for more info.
  */
-int swap_dup_entry_direct(swp_entry_t entry);
+int swap_dup_entries_direct(swp_entry_t entry, int nr);
 void swap_put_entries_direct(swp_entry_t entry, int nr);
 
 /*
@@ -434,7 +434,7 @@ static inline void free_swap_cache(struct folio *folio)
 {
 }
 
-static inline int swap_dup_entry_direct(swp_entry_t ent)
+static inline int swap_dup_entries_direct(swp_entry_t ent, int nr)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9819c0ae228a..c7fc2f5d7238 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1806,7 +1806,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static void copy_huge_non_present_pmd(
+static int copy_huge_non_present_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1852,14 +1852,35 @@ static void copy_huge_non_present_pmd(
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
@@ -1900,6 +1921,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pgtable))
 		goto out;
 
+retry:
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1907,11 +1929,29 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
+				    !swap_retry_table_alloc(entry, HPAGE_PMD_NR,
+							    GFP_KERNEL))
+					goto retry;
+			}
+			pte_free(dst_mm, pgtable);
+			goto out;
+		}
 		goto out_unlock;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index a620d425ec95..c64e11fc7180 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1012,7 +1012,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	struct page *page;
 
 	if (likely(softleaf_is_swap(entry))) {
-		if (swap_dup_entry_direct(entry) < 0)
+		if (swap_dup_entries_direct(entry, 1) < 0)
 			return -EIO;
 
 		mm_prepare_for_swap_entries(dst_mm);
@@ -1427,7 +1427,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 
 	if (ret == -EIO) {
 		VM_WARN_ON_ONCE(!entry.val);
-		if (swap_retry_table_alloc(entry, GFP_KERNEL) < 0) {
+		if (swap_retry_table_alloc(entry, 1, GFP_KERNEL) < 0) {
 			ret = -ENOMEM;
 			goto out;
 		}
diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd2..326bbb7ef831 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -229,7 +229,7 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 	spin_unlock_irq(&ci->lock);
 }
 
-extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
+int swap_retry_table_alloc(swp_entry_t entry, unsigned int nr, gfp_t gfp);
 
 /*
  * Below are the core routines for doing swap for a folio.
@@ -435,7 +435,8 @@ static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return 0;
 }
 
-static inline int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
+static inline int swap_retry_table_alloc(swp_entry_t entry, unsigned int nr,
+					 gfp_t gfp)
 {
 	return -EINVAL;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d15913dcf86..1292c6bfe8c0 100644
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
@@ -3911,8 +3922,9 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
+ * swap_dup_entries_direct() - Increase reference count of swap entries by one.
  * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: number of contiguous swap entries to duplicate.
  *
  * Returns 0 for success, or -ENOMEM if the extend table is required
  * but could not be atomically allocated.  Returns -EINVAL if the swap
@@ -3924,7 +3936,7 @@ void si_swapinfo(struct sysinfo *val)
  * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
  * be used.
  */
-int swap_dup_entry_direct(swp_entry_t entry)
+int swap_dup_entries_direct(swp_entry_t entry, int nr)
 {
 	struct swap_info_struct *si;
 
@@ -3941,7 +3953,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	 */
 	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
 
-	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
+	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-- 
2.53.0-Meta


