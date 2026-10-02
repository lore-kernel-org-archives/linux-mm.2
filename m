Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4E7CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC7D6B00AC; Fri,  2 Oct 2026 05:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2786D6B00AD; Fri,  2 Oct 2026 05:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006466B00AE; Fri,  2 Oct 2026 05:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB5A76B00AC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67D26A06A5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:39 +0000 (UTC)
X-FDA: 85277231718.03.8C370D6
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 73C27140009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=At9qEfVZ;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RchIpk7NZchSvStMhaH00qt0RuXhdBuAEieJPqFEqoM=;
	b=ZFhvEhPsw6cM/NsyzjQtTUJDEHOdm5xrN8su9hOvvkPxbAjAWm5SLRp/FH8zXJ3doX1p9k
	vZq+jF2QZjxsxOLwrhE9o9pbWna6XZS1u+HxOk3HWQovBln1nV1A3nl7OsBs0j7R4qer7G
	+x7vbLxVFLFJyK7hgwJruuP1NmxuWt0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=At9qEfVZ;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934997;
	b=NIiSa7+slGwbsXVllqLEcQhu7dD8t0en7gy2uhQ/Q9qUuBgLILpisWF4Coreb/yKlV7WJ5
	DPWIgUR5BN7ltmFTqLXeaaCIxhtEWu+ikZyL8YneqPIPiIjDe0kR21T8FClSFlo3Rwqdqc
	LWVpUpfgPjaiqRvAvHvrQwRttwqXE5M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MdeSI1G92Jzt8Mz+e0jlhMl6iA+r0yp7B8u8CMz7XQ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934996; v=1; x=1791539796;
 b=At9qEfVZK2JlqBodE4q8CggywNvxo00bz1ZnepUz3BhSWuBhOFW9Dcmr/GmNEgCzZre4dzTf
 ClGjJdMCCKURf01sq8CnZiheHGI7W8VcGGubqQ1L/ZGnILDHpwFRSKH7JlJD4X75vMmgOJj1N6E
 HtW/YgXmxRrIK+2GQGcVPyx4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3805c21303341b99;
	Fri, 02 Oct 2026 09:56:34 +0000
X-Mizu-Trace-ID: 3805c21303341b99
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
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 12/30] mm/swap: allow duplicating a range of swap entries
Date: Fri,  2 Oct 2026 02:52:26 -0700
Message-ID: <20261002095503.3585565-13-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73C27140009
X-Stat-Signature: skf1cmsxs55e4omi8heuycbmocmiitna
X-Rspam-User: 
X-HE-Tag: 1790934997-794048
X-HE-Meta: U2FsdGVkX18bjxqpnPzqO6G9Ltq8Jnfli7j75g4fsSExghuYFT4lkyu+azuyzEycF7rGjDxHrOY7Nkh8XndVuasWfrTAbBkObqNkMq0JHg5mHPM/bR5snIZsOLoOxwEm9rjzlaAdqDeXXcg2iR/YeBuxj03tZZxSzUmtYIstxTmyJVKqh7WJQDIxqbSf50xMJ3Rq396Qe2xePWXBmRxfvvhqvznvprX/utOH7ybhOksGWC2EDrWt4CYlSK1OKQ9oN0VTN5urkiNugEm8IE4vkCmgtidR9xo39DPuwClI/M6bpTk5eKVahuHaLRYTA+hrlLhssk4jFUKk+jkNY0hSL8bA0jDZB8Z3YSioAudzWlVp8f3g89D8Ddh7xCf2xYarCps86UTBEW31b/5Nhr8IPkkCCTC9+P1zDpyLOyvCJgrxayuPwMF9hr7IyU+rB30A+7MW5zH9hb9JGHJvbiLm220IYKSQgjYJcsKJEySfay7XZwjAfs3/n+LXuM9eeSoUchczuCxknax3a11zD31xFOLJJYPggGvR4vnGFYLZ+uarQGnFW4il+zNRSUBKn/Gtww5IOcYBTVS3lLCaWDda6m9kpq2/mNj/u1l9i7F4+B9MXYiks5dbmZHTNSgECV2ok/J3FbDEBw5jat3WRTwxRkF8HAjI9A/JtpYm1C2zQHfE9j0J6WKRGrXHohBN9yZjfmmXOLeWcXTdsLLVRIp7IsnhLT61dVMkOGyL0kNeEFm1cAv9SAI6k5bwth056DH/Ca03zpk5VecPLReI2YHKYFucC/BCeTTrXebB60GbmhXMfEZUVSFUWuP7g7ASpPW1LZJJ3Lusz4Ho+bfe5Mk8a/e5IjwYZ+e7bHVoL5T6VfVz1Y3q0hDJMALNnwIRSpO5JHDd/mUj5IvcsPVZQL2/Yzjg1lqYaANurKyzLe6pECODf7jDLXvTcFbaSyriA89cdvZ3JR/QMz1RNvIeXnW
 USqX4/Kc
 ps29Po8hGTlTXv5n91RQ20zBHsm9J0r6oUPYzT1P/xRYCzgjHGcEm1s4BnMp+aiLnNkBKRY7cK8SAJJjqEIdBTIZe0lUJs4XzMHZ4kGQ5fvaD/tjX78SmYTWS7QB8goUch4vrTStQkzmSMiwfJmbX1GUc671LzcizQBSgU+g9VTzhWEGH5+yqPkLlFaZuMCVNW3ZLyAk0Ev95VOXr14D9Nzx/kjoPe7pSF3oXaZrww6eSHj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_dup_entry_direct() duplicates one slot at a time. The PMD swap entry
fork path needs HPAGE_PMD_NR of them, and doing that one slot at a time
would take and drop the cluster lock HPAGE_PMD_NR times.

Give it an @nr argument and rename it swap_dup_entries_direct(), and do the
same for swap_retry_table_alloc(), whose GFP_KERNEL retry has to cover the
same range - the caller does not know which slot in it overflowed. Keep the
old single-slot names as inline wrappers so existing callers are untouched.

Unlike the put side, @nr is handed straight to the per-cluster helper, so
the range has to sit inside one cluster. That holds for the only caller
passing nr > 1: a PMD swap entry only exists under CONFIG_THP_SWAP, where
SWAPFILE_CLUSTER == HPAGE_PMD_NR, and a PMD-order folio's slots are only
ever allocated at a cluster head (see alloc_swap_scan_cluster()), so the
range is exactly one cluster. Reject a crossing range with -EINVAL so a
future caller cannot walk off the end of the swap table.

No functional change intended.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/swap.h | 12 +++++++++-
 mm/swap.h            | 13 +++++++++-
 mm/swapfile.c        | 56 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 43155e122b5c3..73930bb7ee5e0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,9 +414,14 @@ sector_t swap_folio_sector(struct folio *folio);
  * All entries must be allocated by folio_alloc_swap(). And they must have
  * a swap count > 1. See comments of folio_*_swap helpers for more info.
  */
-int swap_dup_entry_direct(swp_entry_t entry);
+int swap_dup_entries_direct(swp_entry_t entry, int nr);
 void swap_put_entries_direct(swp_entry_t entry, int nr);
 
+static inline int swap_dup_entry_direct(swp_entry_t entry)
+{
+	return swap_dup_entries_direct(entry, 1);
+}
+
 /*
  * folio_free_swap tries to free the swap entries pinned by a swap cache
  * folio, it has to be here to be called by other components.
@@ -458,6 +463,11 @@ static inline void free_swap_cache(struct folio *folio)
 {
 }
 
+static inline int swap_dup_entries_direct(swp_entry_t ent, int nr)
+{
+	return 0;
+}
+
 static inline int swap_dup_entry_direct(swp_entry_t ent)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a1..26ff22d63edca 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -222,7 +222,12 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 	spin_unlock_irq(&ci->lock);
 }
 
-extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
+int swap_retry_table_alloc_nr(swp_entry_t entry, unsigned int nr, gfp_t gfp);
+
+static inline int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
+{
+	return swap_retry_table_alloc_nr(entry, 1, gfp);
+}
 
 /*
  * Below are the core routines for doing swap for a folio.
@@ -428,6 +433,12 @@ static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return 0;
 }
 
+static inline int swap_retry_table_alloc_nr(swp_entry_t entry, unsigned int nr,
+					    gfp_t gfp)
+{
+	return -EINVAL;
+}
+
 static inline int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 {
 	return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 280dd906eb187..f9cfdd4600647 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1468,11 +1468,16 @@ static bool swap_sync_discard(void)
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
 				   struct swap_cluster_info *ci,
-				   unsigned int ci_off, gfp_t gfp)
+				   unsigned int ci_off, unsigned int nr,
+				   gfp_t gfp)
 {
 	int count;
+	unsigned int i;
 	void *table;
 
+	/* The range must not run past the end of @ci's swap table. */
+	VM_WARN_ON_ONCE(ci_off + nr > SWAPFILE_CLUSTER);
+
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
 	if (!table)
 		return -ENOMEM;
@@ -1486,15 +1491,21 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
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
@@ -1502,19 +1513,23 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
 	return 0;
 }
 
-int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
+int swap_retry_table_alloc_nr(swp_entry_t entry, unsigned int nr, gfp_t gfp)
 {
 	int ret;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
 
+	if (WARN_ON_ONCE(swp_cluster_offset(entry) + nr > SWAPFILE_CLUSTER))
+		return -EINVAL;
+
 	si = get_swap_device(entry);
 	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), nr,
+				      gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1690,6 +1705,9 @@ static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
  * @offset: start offset of slots.
  * @nr: number of slots.
  *
+ * The range [offset, offset + nr) must not cross a cluster boundary; the
+ * caller is responsible for splitting a range that can.
+ *
  * Context: The specified slots must be pinned by existing swap count or swap
  * cache reference, so they won't be released until this helper returns.
  * Return: 0 on success. -ENOMEM if the swap count maxed out (SWP_TB_COUNT_MAX)
@@ -1704,6 +1722,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 
 	ci_start = offset % SWAPFILE_CLUSTER;
 	ci_end = ci_start + nr;
+	VM_WARN_ON_ONCE(ci_end > SWAPFILE_CLUSTER);
 	ci_off = ci_start;
 	ci = swap_cluster_lock(si, offset);
 restart:
@@ -1712,7 +1731,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, 1,
+							      GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;
@@ -1723,6 +1743,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
+	/* The caller's page-table or swap-cache reference pins every slot. */
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
 	swap_cluster_unlock(ci);
@@ -3966,8 +3987,9 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
+ * swap_dup_entries_direct() - Increase reference count of swap entries by one.
  * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: number of contiguous swap entries to duplicate.
  *
  * Returns 0 for success, or -ENOMEM if the extend table is required
  * but could not be atomically allocated.  Returns -EINVAL if the swap
@@ -3978,8 +4000,11 @@ void si_swapinfo(struct sysinfo *val)
  * owner. e.g., locking the PTL of a PTE containing the entry being increased.
  * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
  * be used.
+ *
+ * Unlike swap_put_entries_direct(), the whole range [entry, entry + nr) must
+ * lie within one swap cluster; a crossing range is rejected with -EINVAL.
  */
-int swap_dup_entry_direct(swp_entry_t entry)
+int swap_dup_entries_direct(swp_entry_t entry, int nr)
 {
 	struct swap_info_struct *si;
 
@@ -3989,6 +4014,9 @@ int swap_dup_entry_direct(swp_entry_t entry)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(swp_cluster_offset(entry) + nr > SWAPFILE_CLUSTER))
+		return -EINVAL;
+
 	/*
 	 * The caller must be increasing the swap count from a direct
 	 * reference of the swap slot (e.g. a swap entry in page table).
@@ -3996,7 +4024,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	 */
 	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
 
-	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
+	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-- 
2.53.0-Meta


