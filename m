Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E1ACC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258D96B00BF; Tue,  7 Jul 2026 03:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3A46B00C1; Tue,  7 Jul 2026 03:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0357F6B00C2; Tue,  7 Jul 2026 03:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA83E6B00BF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:34:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 400C41C353E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:34:04 +0000 (UTC)
X-FDA: 84961166808.24.F20DA3F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D66320005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:34:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYsn8bob;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdQ03myuEqicxEeyevbla0PbJFj4q/ALEaDKwoFJ8EA=;
	b=xQrwAWR9aFkg76uPKXogijKH9iCoL2eVmhw5vsJNSmfASlW9f6JEUur1yGdbvKldq902R1
	Tr56hotIAN4MehI24miVAWaoct5BFAa8xMdG6jKE+83FB6gt2/uxpoWRQ10nWMrt5U8Z7+
	weeRWh5QZUapXa2tzrvhV953ImSRgFM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYsn8bob;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409642;
	b=rGhiTn63DpW8LIykvkZPwYSWKLQAzvPmjJS90VRJo8etcBgLbHG8XchyYWM1HnoJnhValo
	D5WOj+aD6g6msTaZLaCw+jRa/FEPyAswbW3xG8QlDQcl2th+1QCy25vNPJknQn7M6V9aqH
	kFHiC4VmLzkjxnpOzWESN4uwg1EY0tw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdQ03myuEqicxEeyevbla0PbJFj4q/ALEaDKwoFJ8EA=;
	b=tYsn8bobCXa6MnprP+l6CRK8psNXzJyJDdEFjTqdjZWgRPqqCeiCoEPsCoiNZ0z3exNvPS
	4aIiDq32rS0+HAGGQra6qsgSEnbzpHXu9M9NJRIjQajPRv3Wg1/AUN3cBgiJ44kckvETMC
	eqeMg8+ph4ZSFZ4qQSR5gXpDO/3QlIU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 7/7] mm/zswap, mm/swap_state: replace xarray indexing with swap table lookups
Date: Tue,  7 Jul 2026 15:32:04 +0800
Message-ID: <20260707073215.72183-8-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zwoir74i5u78nsas8wgnh8bunoy8ahb4
X-Rspamd-Queue-Id: 7D66320005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783409642-398554
X-HE-Meta: U2FsdGVkX18VE1Wyb+o73q6BViTTospbEQHNqFgtxgAPZWUy8IjUZdu4NBgkBTU82fU7IVpyOOBfeaLMuiMFxfL7Na6N9ElHQbWnHo8BOp3VsdHMCkS0Ztdtyc9jicIkGkC7O8QWa+6AMftQgbovPgdu6zWt410kvFKz9yIj80ch7ke8RZIrvgGX7adDCc37wYJCA2Z7aaT7ft1jLISVWh72j7OCgV6rUyIU7ejXJWLBN5SfArkrdmiHMI0dGcZQ/sCpcsJTs08//XXOkdELcELqkueZFupJ1jlLHVmqM0y6ALg2Hcs9R23XKxNfTwsonOvWCykCzVEIKFdLtUR61/cymiIDvAX1DjqaDhJ6xtSjr49dflHWEh6RVuaSvVutfbGFXflE2O8tBe0orf+UuhxRbwyttuzfQkL83iESaQwdJrSWzUwHUjwvQCbo6RejPtPBXAlH2pSWyPGTFu/19QxBoGOeywkcXOdgo6vU541xOlbx/GaTmuwe0IDZR2AR4xQKSbtdMNB3hb/2AbUFbHJqDZ9wVDaHmJd8N/JDg9EZUKu/1Cf23xk8iaaABoAI1CRxUg4yhsvqVXQDi5egrcQR0b+qhjBQnHe1pDNgFaV+JxZHkHSpgq8FSnYu2oJQZ6ODc1hJOVLm1Og2BuJ7mRgUpBp/V+fNSoME8NP5aMjuu0ucN0llDrsvBALdXJmnAC4u7dgIRF/Yn9qCYcRaPd4UWs6TlqMjjvvWHzkr3DNirk1uT3pQO7k+FNiaFB/D0vWy2d8RVpR3cjLFeDG9e3nvfh1IRrCcCdBc36mtGALGpYQgkddFfE5qiHtn3O7+fuinc9wgJZ+jmYfT180GQF44LsNFiB8mSPNuMF5BsAJ2EViSlOEYeI3WNG0dLHllOj4ln6WX5KnCJrPo5oPBQd23JXYsjufi5ZWXUSrG6CLi8poA/GfCFhijqNvCv3ZoYL+0eGvH/kT8pfhILDA
 6xXz7kH2
 hYXisqMrQBiGlXTUDHh4npMJQGXSA60bEqbe/4m0XAhdLlnkKlzk97/WzTn0WXoKyiahYVYOnV8RjuxCEbzgNJ/Of8gp5TeICzDsyOdX4ZMwwa+hM68xA6sQbE553O1QxiHU/WvRZk5sJtBGkfoyX7Hg+xWAgg9lWCFJo+TAdR9C4zsieTIioXUG5WO4YDTxK4wcKP+H8b1YOsW9k2NapBseBaiPjxFfEC61kIr91J73dovPTN8sxUp+u3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the xarray-based zswap entry lookup infrastructure entirely and
use the swap table Pointer entries as the sole index for locating
compressed zswap data.

Thread the zswap_entry through the swapin call chain via a new
void **zentry parameter.

Update all declarations in swap.h and include/linux/zswap.h to match
the new signatures.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/zswap.h |   4 +-
 mm/page_io.c          |   4 +-
 mm/swap.h             |  25 +++--
 mm/swap_state.c       |  68 ++++++++----
 mm/swapfile.c         |  16 ++-
 mm/zswap.c            | 252 +++++++++++++++---------------------------
 6 files changed, 165 insertions(+), 204 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..4f55c8d0c4c5 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -26,7 +26,7 @@ struct zswap_lruvec_state {
 
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
-int zswap_load(struct folio *folio);
+int zswap_load(struct folio *folio, void *zentry);
 void zswap_invalidate(swp_entry_t swp);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
@@ -44,7 +44,7 @@ static inline bool zswap_store(struct folio *folio)
 	return false;
 }
 
-static inline int zswap_load(struct folio *folio)
+static inline int zswap_load(struct folio *folio, void *zentry)
 {
 	return -ENOENT;
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index b23f494fcc83..1ce8201ed86e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -658,7 +658,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+void swap_read_folio(struct folio *folio, struct swap_iocb **plug, void *zentry)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
@@ -686,7 +686,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 		goto finish;
 	}
 
-	if (zswap_load(folio) != -ENOENT)
+	if (zswap_load(folio, zentry) != -ENOENT)
 		goto finish;
 
 	/* We have to read from slower devices. Increase zswap protection. */
diff --git a/mm/swap.h b/mm/swap.h
index c23f54dc32bd..84e13ba6e605 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -210,9 +210,8 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 
 extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 
+struct zswap_entry;
 #ifdef CONFIG_ZSWAP
-void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
-				  unsigned int ci_off, int type, pgoff_t offset);
 void *zswap_swp_tb_get_shadow(unsigned long swp_tb);
 unsigned char zswap_swp_tb_get_count(unsigned long swp_tb);
 unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb);
@@ -220,10 +219,8 @@ int zswap_swp_tb_dup_count(unsigned long swp_tb,
 			   struct swap_cluster_info *ci, unsigned int ci_off);
 void zswap_swp_tb_put_count(unsigned long swp_tb,
 			    struct swap_cluster_info *ci, unsigned int ci_off);
+void zswap_entry_free(struct zswap_entry *entry);
 #else
-static inline void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
-						unsigned int ci_off, int type,
-						pgoff_t offset) {}
 static inline void *zswap_swp_tb_get_shadow(unsigned long swp_tb)
 {
 	return NULL;
@@ -245,6 +242,7 @@ static inline int zswap_swp_tb_dup_count(unsigned long swp_tb,
 static inline void zswap_swp_tb_put_count(unsigned long swp_tb,
 					  struct swap_cluster_info *ci,
 					  unsigned int ci_off) {}
+static inline void zswap_entry_free(struct zswap_entry *entry) {}
 #endif
 
 /*
@@ -278,7 +276,7 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
+void swap_read_folio(struct folio *folio, struct swap_iocb **plug, void *zentry);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
@@ -340,13 +338,16 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
+bool folio_maybe_swapped(struct folio *folio);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     void **zentry);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry);
+			    struct folio *folio, swp_entry_t entry,
+			    void **zentry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
@@ -418,7 +419,8 @@ static inline void folio_put_swap(struct folio *folio, struct page *page)
 {
 }
 
-static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug,
+				   void *zentry)
 {
 }
 
@@ -490,6 +492,11 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+static inline bool folio_maybe_swapped(struct folio *folio)
+{
+	return false;
+}
+
 static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b3d5bedfaf07..60d937c6b392 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -214,7 +214,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 }
 
 static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
-				      struct folio *folio, swp_entry_t entry)
+				      struct folio *folio, swp_entry_t entry,
+				      void **zentry)
 {
 	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -231,15 +232,32 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
 		VM_WARN_ON_ONCE(swp_tb_is_folio(old_tb));
 		/*
 		 * If the old entry is a Pointer (zswap compressed data),
-		 * extract the flags from the zswap_entry. The Pointer
-		 * entry has no inline flags.
+		 * extract the zswap_entry for the caller and preserve
+		 * its flags. The Pointer entry has no inline flags.
 		 */
-		if (swp_tb_is_pointer(old_tb))
+		if (swp_tb_is_pointer(old_tb)) {
+			unsigned char pflags = zswap_swp_tb_get_flags(old_tb);
+			/*
+			 * If swp_tb_val carries SWP_TB_COUNT_MAX, the
+			 * real overflow count lives in ci->extend_table.
+			 * Pull it so the new PFN carries the correct count
+			 * and won't later crash on a missing extend_table.
+			 */
+			if (zswap_swp_tb_get_count(old_tb) == SWP_TB_COUNT_MAX) {
+				unsigned char real = SWP_TB_COUNT_MAX - 1;
+				if (ci->extend_table && ci->extend_table[ci_off])
+					real = ci->extend_table[ci_off];
+				pflags = (real << (SWP_TB_FLAGS_BITS - SWP_TB_COUNT_BITS)) |
+					 (pflags & ((1 << (SWP_TB_FLAGS_BITS - SWP_TB_COUNT_BITS)) - 1));
+			}
+			if (zentry && !*zentry)
+				*zentry = swp_tb_to_pointer(old_tb);
 			__swap_table_set(ci, ci_off,
-				pfn_to_swp_tb(pfn, zswap_swp_tb_get_flags(old_tb)));
-		else
+				pfn_to_swp_tb(pfn, pflags));
+		} else {
 			__swap_table_set(ci, ci_off,
 				pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
+		}
 	} while (++ci_off < ci_end);
 
 	folio_ref_add(folio, nr_pages);
@@ -262,11 +280,12 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
  * that holds the entries.
  */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry)
+			    struct folio *folio, swp_entry_t entry,
+			    void **zentry)
 {
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	__swap_cache_do_add_folio(ci, folio, entry);
+	__swap_cache_do_add_folio(ci, folio, entry, zentry);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
@@ -313,14 +332,6 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 			/* If shadow is NULL, we set an empty shadow. */
 			__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
 					 __swp_tb_get_flags(old_tb)));
-			/*
-			 * If zswap has a compressed copy of this slot,
-			 * convert the just-written Shadow to a Pointer
-			 * entry referencing the zswap_entry.
-			 */
-			zswap_try_convert_to_pointer(ci, ci_off, si->type,
-						     swp_offset(entry) +
-						     ci_off - ci_start);
 		}
 	} while (++ci_off < ci_end);
 
@@ -454,7 +465,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx)
+					struct mempolicy *mpol, pgoff_t ilx,
+					void **zentry)
 {
 	int err;
 	swp_entry_t entry;
@@ -501,7 +513,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
-	__swap_cache_do_add_folio(ci, folio, entry);
+	__swap_cache_do_add_folio(ci, folio, entry, zentry);
 	spin_unlock(&ci->lock);
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
@@ -558,7 +570,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     void **zentry)
 {
 	int order, err;
 	struct folio *ret;
@@ -571,9 +584,12 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 	if (WARN_ON_ONCE(!orders || (1UL << order) > SWAPFILE_CLUSTER))
 		return ERR_PTR(-EINVAL);
 
+	if (zentry)
+		*zentry = NULL;
+
 	do {
 		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
-					 vmf, mpol, ilx);
+					 vmf, mpol, ilx, zentry);
 		if (!IS_ERR(ret))
 			break;
 		err = PTR_ERR(ret);
@@ -689,18 +705,20 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct swap_iocb **plug, bool readahead)
 {
 	struct folio *folio;
+	void *zentry;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx,
+					       &zentry);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
-	swap_read_folio(folio, plug);
+	swap_read_folio(folio, plug, zentry);
 	if (readahead) {
 		folio_set_readahead(folio);
 		count_vm_event(SWAP_RA);
@@ -729,18 +747,20 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
+	void *zentry;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx,
+					       &zentry);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
-	swap_read_folio(folio, NULL);
+	swap_read_folio(folio, NULL, zentry);
 	return folio;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 15572383cafa..18925e462571 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -935,7 +935,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		nr_pages = 1 << order;
 		swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type,
-							    ci_off + cluster_offset(si, ci)));
+							    ci_off + cluster_offset(si, ci)),
+				       NULL);
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
@@ -1969,11 +1970,18 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		 * means zswap has a compressed copy; the xarray still
 		 * holds the entry and zswap_invalidate will free it.
 		 */
-		if (swp_tb_is_pointer(old_tb))
+		if (swp_tb_is_pointer(old_tb)) {
 			VM_WARN_ON(zswap_swp_tb_get_count(old_tb) > 1);
-		else
+			/*
+			 * Free the zswap entry now under ci->lock while
+			 * the Pointer is still in the swap table.  Once
+			 * we null the slot, the entry would be leaked.
+			 */
+			zswap_entry_free(swp_tb_to_pointer(old_tb));
+		} else {
 			VM_WARN_ON(!swp_tb_is_shadow(old_tb) ||
 				   __swp_tb_get_count(old_tb) > 1);
+		}
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
@@ -2073,7 +2081,7 @@ int swp_swapcount(swp_entry_t entry)
  *
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-static bool folio_maybe_swapped(struct folio *folio)
+bool folio_maybe_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
 	struct swap_cluster_info *ci;
diff --git a/mm/zswap.c b/mm/zswap.c
index f5f4756c9ce6..f9762d0a596a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -203,9 +203,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-static struct xarray *zswap_trees[MAX_SWAPFILES];
-static unsigned int nr_zswap_trees[MAX_SWAPFILES];
-
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
 /* protects zswap_pools list modification */
@@ -231,15 +228,6 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-/* One swap address space for each 64M swap space */
-#define ZSWAP_ADDRESS_SPACE_SHIFT 14
-#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
-static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
-{
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
-}
-
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -768,7 +756,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_entry_free(struct zswap_entry *entry)
+void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
 	zs_free(entry->pool->zs_pool, entry->handle);
@@ -993,11 +981,12 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long swp_tb;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1005,9 +994,25 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
+	/*
+	 * Verify the swap table Pointer entry still references this
+	 * zswap_entry. If the entry was invalidated or replaced by a
+	 * concurrent store, the Pointer will be gone or point elsewhere.
+	 */
+	ci = __swap_offset_to_cluster(si, offset);
+	spin_lock(&ci->lock);
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (!swp_tb_is_pointer(swp_tb) ||
+	    swp_tb_to_pointer(swp_tb) != entry) {
+		spin_unlock(&ci->lock);
+		put_swap_device(si);
+		return -ENOMEM;
+	}
+	spin_unlock(&ci->lock);
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+				       NO_INTERLEAVE_INDEX, NULL);
 	put_swap_device(si);
 
 	/*
@@ -1021,27 +1026,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return PTR_ERR(folio);
 
 	/*
-	 * folio is locked, and the swapcache is now secured against
-	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
-	 * Verify that the swap entry hasn't been invalidated and recycled
-	 * behind our backs, to avoid overwriting a new swap folio with
-	 * old compressed data. Only when this is successful can the entry
-	 * be dereferenced.
+	 * The folio is now locked and in swap cache, so concurrent
+	 * stores are blocked. __swap_cache_do_add_folio already
+	 * overwrote the Pointer entry with a PFN.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
 		goto out;
 	}
 
-	xa_erase(tree, offset);
-
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
@@ -1111,36 +1104,22 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	}
 
 	/*
-	 * As soon as we drop the LRU lock, the entry can be freed by
-	 * a concurrent invalidation. This means the following:
-	 *
-	 * 1. We extract the swp_entry_t to the stack, allowing
-	 *    zswap_writeback_entry() to pin the swap entry and
-	 *    then validate the zswap entry against that swap entry's
-	 *    tree using pointer value comparison. Only when that
-	 *    is successful can the entry be dereferenced.
+	 * After we drop the LRU lock, the entry may be freed by a
+	 * concurrent swap slot free.  This is safe because
+	 * zswap_writeback_entry() rechecks the swap table under
+	 * ci->lock before dereferencing entry; if the Pointer is
+	 * gone it bails out.
 	 *
-	 * 2. Usually, objects are taken off the LRU for reclaim. In
-	 *    this case this isn't possible, because if reclaim fails
-	 *    for whatever reason, we have no means of knowing if the
-	 *    entry is alive to put it back on the LRU.
-	 *
-	 *    So rotate it before dropping the lock. If the entry is
-	 *    written back or invalidated, the free path will unlink
-	 *    it. For failures, rotation is the right thing as well.
-	 *
-	 *    Temporary failures, where the same entry should be tried
-	 *    again immediately, almost never happen for this shrinker.
-	 *    We don't do any trylocking; -ENOMEM comes closest,
-	 *    but that's extremely rare and doesn't happen spuriously
-	 *    either. Don't bother distinguishing this case.
+	 * Rotate the entry before dropping the lock: if it gets
+	 * written back or invalidated the free path will unlink
+	 * it from the LRU.  For failures rotation is fine.
 	 */
 	list_move_tail(item, &l->list);
 
 	/*
-	 * Once the lru lock is dropped, the entry might get freed. The
-	 * swpentry is copied to the stack, and entry isn't deref'd again
-	 * until the entry is verified to still be alive in the tree.
+	 * The swpentry is copied to the stack so we can pin the swap
+	 * device and validate the entry's swap table Pointer under
+	 * ci->lock in zswap_writeback_entry().
 	 */
 	swpentry = entry->swpentry;
 
@@ -1420,17 +1399,13 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
-
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
-	}
-
+	/*
+	 * Store the zswap_entry pointer in the swap table as a
+	 * Pointer-type entry, replacing the PFN or Shadow entry.
+	 * The full swap table entry value (including working set
+	 * shadow) is preserved in entry->swp_tb_val.
+	 * Folio lock serializes concurrent stores.
+	 */
 	si = __swap_entry_to_info(page_swpentry);
 	ci = __swap_offset_to_cluster(si, offset);
 	spin_lock(&ci->lock);
@@ -1465,7 +1440,7 @@ static bool zswap_store_page(struct page *page,
 	 * The entry is successfully compressed and stored in the swap table,
 	 * there is no further possibility of failure. Grab refs to the pool
 	 * and objcg, charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_put()
+	 * The opposite actions will be performed by zswap_entry_free()
 	 * when the entry is removed from the swap table.
 	 */
 	zswap_pool_get(pool);
@@ -1498,8 +1473,6 @@ static bool zswap_store_page(struct page *page,
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
@@ -1578,26 +1551,33 @@ bool zswap_store(struct folio *folio)
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
-		struct xarray *tree;
 		struct swap_cluster_info *ci;
 		struct swap_info_struct *sis;
 		unsigned long swp_tb;
 
 		sis = __swap_type_to_info(type);
 		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (!entry)
-				continue;
 			ci = __swap_offset_to_cluster(sis, offset + index);
 			spin_lock(&ci->lock);
 			swp_tb = __swap_table_get(ci, (offset + index) % SWAPFILE_CLUSTER);
-			if (swp_tb_is_pointer(swp_tb) &&
-			    swp_tb_to_pointer(swp_tb) == entry)
+			if (swp_tb_is_pointer(swp_tb)) {
+				entry = swp_tb_to_pointer(swp_tb);
+				/*
+				 * Restore the original swap table entry
+				 * (Shadow or PFN) that was saved when the
+				 * Pointer entry was created, rather than
+				 * zeroing the slot.  This preserves the swap
+				 * count and flags so the swap cache folio
+				 * can be correctly cleaned up later.
+				 */
 				__swap_table_set(ci, (offset + index) % SWAPFILE_CLUSTER,
 						 entry->swp_tb_val);
+			} else {
+				entry = NULL;
+			}
 			spin_unlock(&ci->lock);
-			zswap_entry_free(entry);
+			if (entry)
+				zswap_entry_free(entry);
 		}
 	}
 
@@ -1607,6 +1587,11 @@ bool zswap_store(struct folio *folio)
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
+ * @zentry: zswap_entry pointer extracted from swap table, or NULL
+ *
+ * The zswap_entry was extracted from the swap table Pointer entry by
+ * __swap_cache_do_add_folio before it overwrote the entry with a PFN.
+ * If @zentry is NULL, the slot was not backed by zswap.
  *
  * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
  * of the following error codes:
@@ -1624,12 +1609,9 @@ bool zswap_store(struct folio *folio)
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
  */
-int zswap_load(struct folio *folio)
+int zswap_load(struct folio *folio, void *zentry)
 {
-	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
-	struct zswap_entry *entry;
+	struct zswap_entry *entry = zentry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1647,7 +1629,6 @@ int zswap_load(struct folio *folio)
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
 	if (!entry)
 		return -ENOENT;
 
@@ -1670,7 +1651,6 @@ int zswap_load(struct folio *folio)
 	 * compression work.
 	 */
 	folio_mark_dirty(folio);
-	xa_erase(tree, offset);
 	zswap_entry_free(entry);
 
 	folio_unlock(folio);
@@ -1680,68 +1660,42 @@ int zswap_load(struct folio *folio)
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned long swp_tb;
 	struct zswap_entry *entry;
 
-	if (xa_empty(tree))
-		return;
-
-	entry = xa_erase(tree, offset);
-	if (!entry)
-		return;
-
-	/*
-	 * Also clear the swap table Pointer entry if present.
-	 * This is needed because zswap_store now writes Pointer
-	 * entries to both the xarray and the swap table.
-	 */
 	si = __swap_type_to_info(swp_type(swp));
 	ci = __swap_offset_to_cluster(si, offset);
-	spin_lock(&ci->lock);
+	/*
+	 * Do a lockless peek first.  If ci->lock is already held by
+	 * the caller (e.g. __swap_cluster_free_entries), and the
+	 * Pointer has already been cleared, we can bail out without
+	 * self-deadlocking.
+	 */
 	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-	if (swp_tb_is_pointer(swp_tb) && swp_tb_to_pointer(swp_tb) == entry)
-		__swap_table_set(ci, offset % SWAPFILE_CLUSTER, entry->swp_tb_val);
-	spin_unlock(&ci->lock);
-
-	zswap_entry_free(entry);
-}
-
-/*
- * This is called after the Shadow entry has been written. We replace the
- * just-written Shadow with a Pointer entry pointing to the zswap_entry.
- *
- * Context: cluster lock must be held. Cannot sleep.
- */
-void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
-				  unsigned int ci_off, int type, pgoff_t offset)
-{
-	struct xarray *tree;
-	struct zswap_entry *entry;
-	unsigned long swp_tb;
-
-	tree = &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
-	if (xa_empty(tree))
-		return;
-
-	entry = xa_load(tree, offset);
-	if (!entry)
-		return;
-
-	swp_tb = __swap_table_get(ci, ci_off);
-	/* Entry must be a Shadow (just written by __swap_cache_do_del_folio) */
-	if (!swp_tb_is_countable(swp_tb))
+	if (!swp_tb_is_pointer(swp_tb))
 		return;
 
-	/*
-	 * Save the complete original swap table entry value, which includes
-	 * the swap count, zero flag, and working set shadow information.
-	 */
-	entry->swp_tb_val = swp_tb;
+	spin_lock(&ci->lock);
+	swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	if (swp_tb_is_pointer(swp_tb)) {
+		entry = swp_tb_to_pointer(swp_tb);
+		/*
+		 * Restore the original swap table entry (Shadow or PFN)
+		 * that was saved in swp_tb_val when the Pointer entry
+		 * was created.  This preserves swap count and flags
+		 * for the subsequent slot-free path.
+		 */
+		__swap_table_set(ci, offset % SWAPFILE_CLUSTER,
+				 entry->swp_tb_val);
+	} else {
+		entry = NULL;
+	}
+	spin_unlock(&ci->lock);
 
-	__swap_table_set(ci, ci_off, pointer_to_swp_tb(entry));
+	if (entry)
+		zswap_entry_free(entry);
 }
 
 /*
@@ -1854,39 +1808,11 @@ void zswap_swp_tb_put_count(unsigned long swp_tb,
 
 int zswap_swapon(int type, unsigned long nr_pages)
 {
-	struct xarray *trees, *tree;
-	unsigned int nr, i;
-
-	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
-	trees = kvzalloc_objs(*tree, nr);
-	if (!trees) {
-		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nr; i++)
-		xa_init(trees + i);
-
-	nr_zswap_trees[type] = nr;
-	zswap_trees[type] = trees;
 	return 0;
 }
 
 void zswap_swapoff(int type)
 {
-	struct xarray *trees = zswap_trees[type];
-	unsigned int i;
-
-	if (!trees)
-		return;
-
-	/* try_to_unuse() invalidated all the entries already */
-	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!xa_empty(trees + i));
-
-	kvfree(trees);
-	nr_zswap_trees[type] = 0;
-	zswap_trees[type] = NULL;
 }
 
 /*********************************
-- 
2.54.0


