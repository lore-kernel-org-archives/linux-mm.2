Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B128C606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JeFYc1RQ
Received: by kanga.kvack.org (Postfix)
	id 6BC886B05CA; Thu,  5 Nov 2026 13:41:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DFC6B05CB; Thu,  5 Nov 2026 13:41:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DB16B05CC; Thu,  5 Nov 2026 13:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19D3B6B05CA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 971C1A0BE9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:14 +0000 (UTC)
X-FDA: 85401932868.14.E1913EA
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A927100010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JeFYc1RQ;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99OaPNUALtrEo1DyIHDA5LAxQ/Si4UJO2itR3fKmwI0=;
	b=Y2m2ZSJItZaW5NqOabZpcV20avZ2IgRYm01BrDV/pP9oiKMPszh6b+zgn5abTprm/G6HML
	t+Bb1g8plMoNl82LAZyQxz4UD4teWpsf0RTJJAuW7dZAchKhjPX2vxYF7cv/tigWcNjM9N
	nCgtUAOfM9tVzMSzSxFXtRIyWmceEVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904072;
	b=fs121A++VJcPsIq99GVG55B+7pKWai7YuJRv4Z3UF3FLnVxOTDJwV1IPuuyCBzEZjzLXNA
	vvOPMMUz7+S7I0I1scUUXMRTal3jH1OTWrD7rgF9pPrLF97XYZsBuKUoNoAspbl9sBTQdY
	HgluobZefgB0MICGMY6X/Z/nLLjxeBI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JeFYc1RQ;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A3/111gOQUX96DxN2YJbLmOUYLhJf9za3+Chp1HLx+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904071; v=1; x=1794508871;
 b=JeFYc1RQnXyaNCJi/kyAaBHUekbi6bmrdzsnqK7rYDG+rMLVn4DiMXZ8DtDVzr/+Hk9EMxg1
 iLWSonkmVL34zf6pBK5xgn6z5nRo2DEsIT8nvAmfu8oDG0IqVhNPQjVe5lnTxBeiXbDhUgfXFus
 VKqHQK/lkslH7VOm0K10IA4A=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 587db54ab7101a72;
	Thu, 05 Nov 2026 18:41:11 +0000
X-Mizu-Trace-ID: 587db54ab7101a72
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 13/32] mm/swap: allow duplicating a range of swap entries
Date: Thu,  5 Nov 2026 10:38:57 -0800
Message-ID: <20261105183940.2236717-14-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 53xng4bh6ci7ee8dphny556cfgaukifw
X-Rspamd-Queue-Id: 9A927100010
X-Rspam-User: 
X-HE-Tag: 1793904072-955735
X-HE-Meta: U2FsdGVkX1887jWylHlg/F1j3rzXPRupdaPkjtKkXZdMm325r6gBFJ7lRYoJbvOp+fB41J/rlzxeq1psQ0yY8cHnErNk7LfkuWd687TwfdS9ip1IWv8AtWrqh6b4VXDOWAuFEQ+bfXCdIb7nyAn+sEHwWQswuFOHnpBVvEADdpJLdXnte08mlH+D1PIxEaZiv4XwT16rEy8fTaEUpWTBfQskMMBG0joLkJ1nF43ZWoZMQ2T6C+KxbrU2jAvPJtF1cBPPvwwphu6DH2+xphEWpO84rgpIJeDiWKQ0SAKRg2Wv3BMoVPYyy2ljdFVFMxmQGECiH/d1dpIBvbLXXMR33NuUirL9RSRfxCid7KHa6avgOgYg50lCaTGDdAWjS8DPvXAqdYWXNsEwcoWyO8J/7zMmzyrbFyzohMJ5jjlh+/WZVCNvwQHxoWc0Ykj4xlTHS9JyAYtubNFuDIf+SWuSVrRGwWUpVPaJTlk9fx90mTFGXvVyLRNSfSeyzSzpyxZnyEYiUXu8Nqrxodupws3KaxL4d6lxDKY9UDdExNG6JBtsbVjnAFjVzTQBPQjGjoW0Lds+5QZ0QhPicxLkmCLz4vNH+fC9Q+DepVaTpVllCaNwafO6BeZ9cz0Cqji1raBR9ykD0UDGrFno3QewBUMj7nnfbuOHA7AS9H7LjbVLt6547xeQcSeZIsWOjO0CW+mj377PlKxU027eAl/KFuiDehTc22PjMaAc7b+SXJQm9f6+3WhFchRNTpjcWkWaV2dZ87AFApLmVOOq1sph5SO7X3Zk2K1olGkcaXXQ8YuQW7TlKA/nsCfbBSpZoPP9kKK3Su1ffhE02vFIOEA8WJVWC4OpvqwmvJJLwboK2OrbzKLwlV0gPcvKWgpH0ONumyXyCbrEdCHqUxio+n7dQTszJl3mld/84fkh6eomlL4ZZeHcQ9hhXNvfomFvrnbWSUXVRnaaZOyahh+hc1vvKZa
 vXtIIrAq
 JJOnMkxj4xZ5/CkToJh2HlpDNAH0yhY2zTSYLTonLocp31qc3TihhG0i20Yw0ZXcfDQW6YKsUEMGsw5wzUSnFIOAej5MA5MNggY+0cv+TE+5BvLMPN6Shrm81+v3JfY2sCx7t2oHrgmKsXqh7FWKjPJ3kmTzlJw4bymQsZ2mQ/l/G2t5zeFzNeelHDUMBz2rMV0DnRopmUqZX6lF9xqWWE77Bl4YZ++tQ7D1tdzJJFaH+v20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 4f686709d71f0..861193d5ea109 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -417,9 +417,14 @@ sector_t swap_folio_sector(struct folio *folio);
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
@@ -464,6 +469,11 @@ static inline void free_swap_cache(struct folio *folio)
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
index b8181bd056ee2..f028bd10c2cea 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -223,7 +223,12 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
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
@@ -453,6 +458,12 @@ static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
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
index 8dd2ba8254137..6b5149b88fa43 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1473,11 +1473,16 @@ static bool swap_sync_discard(void)
 
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
@@ -1491,15 +1496,21 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
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
@@ -1507,19 +1518,23 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
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
@@ -1695,6 +1710,9 @@ static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
  * @offset: start offset of slots.
  * @nr: number of slots.
  *
+ * The range [offset, offset + nr) must not cross a cluster boundary; the
+ * caller is responsible for splitting a range that can.
+ *
  * Context: The specified slots must be pinned by existing swap count or swap
  * cache reference, so they won't be released until this helper returns.
  * Return: 0 on success. -ENOMEM if the swap count maxed out (SWP_TB_COUNT_MAX)
@@ -1709,6 +1727,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 
 	ci_start = offset % SWAPFILE_CLUSTER;
 	ci_end = ci_start + nr;
+	VM_WARN_ON_ONCE(ci_end > SWAPFILE_CLUSTER);
 	ci_off = ci_start;
 	ci = swap_cluster_lock(si, offset);
 restart:
@@ -1717,7 +1736,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, 1,
+							      GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;
@@ -1728,6 +1748,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
+	/* The caller's page-table or swap-cache reference pins every slot. */
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
 	swap_cluster_unlock(ci);
@@ -3964,8 +3985,9 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
+ * swap_dup_entries_direct() - Increase reference count of swap entries by one.
  * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: number of contiguous swap entries to duplicate.
  *
  * Returns 0 for success, or -ENOMEM if the extend table is required
  * but could not be atomically allocated.  Returns -EINVAL if the swap
@@ -3976,8 +3998,11 @@ void si_swapinfo(struct sysinfo *val)
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
 
@@ -3987,6 +4012,9 @@ int swap_dup_entry_direct(swp_entry_t entry)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(swp_cluster_offset(entry) + nr > SWAPFILE_CLUSTER))
+		return -EINVAL;
+
 	/*
 	 * The caller must be increasing the swap count from a direct
 	 * reference of the swap slot (e.g. a swap entry in page table).
@@ -3994,7 +4022,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	 */
 	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
 
-	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
+	return swap_dup_entries_cluster(si, swp_offset(entry), nr);
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-- 
2.53.0-Meta


