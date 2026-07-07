Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB25C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E5A6B00B9; Tue,  7 Jul 2026 03:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE2E6B00BB; Tue,  7 Jul 2026 03:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF106B00BC; Tue,  7 Jul 2026 03:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 113D46B00B9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:33:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8996340351
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:29 +0000 (UTC)
X-FDA: 84961165338.20.7D6A8A8
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id C007F140007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBDnhGxT;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bW7lRkUk0nMqEjMRkw0Ai82Wzm8WWSf5+Obu2fJrU1U=;
	b=HVkMs45sxGMIioDP/3eKMbuJ/N3clR02/nBuOCBjcMfF5L4PYJaF3MdapXzkkv+GF9xpcl
	f933bVk0yMHYHYauX6Fx0uUjFeuZvQsorBWUS3uHYUENHsl227y+TOvMyVYvZiaSJPoobM
	ZtD7TNxWPA7RI7hSjWwQz4BLYl8NO18=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBDnhGxT;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409608;
	b=rhFFLNMhv0lueXm7imrgXeGjf+TuRtrgp3FE2jSHao2wEujI43IqVLRn3L29IE3sNmGRRO
	ID7oymKFFDkVhyvNRVA+ankgy4ecfXb4h/IQjuVoo1N3e1/V9ZwyAxe5H3IDOjwLdoX0S9
	gwhaOvbyCWjbZ6Q3CdZpctoQK3MxPP4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bW7lRkUk0nMqEjMRkw0Ai82Wzm8WWSf5+Obu2fJrU1U=;
	b=IBDnhGxTEbnSkh04UOO1ikeys6VJ00TDY9YbMivs6pfraZDsz0+oCt//I/1FtxcGPyv+u4
	7NusiKHBgWuP2hhOS4Lk6sq2jSXOshorWQefDNqXk7W+41yQDn7AUX2u1HY5rWacsZszYa
	IW+NQ06LFPbkmmIFE38iwe4USXK4dj8=
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
Subject: [RFC PATCH 4/7] mm/zswap, mm/swap_state: handle Pointer entries in add_folio path
Date: Tue,  7 Jul 2026 15:32:01 +0800
Message-ID: <20260707073215.72183-5-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C007F140007
X-Stat-Signature: 6pzur9om6e17pojnopu1sa741os9yjkf
X-HE-Tag: 1783409607-740552
X-HE-Meta: U2FsdGVkX18hjD1pWa3GHaD8cRdr7j6auxRH9lpyz0Ogiag/KHAJ9RrI1mb9uFrHx4qcJh342vtT8Jg6SHN2hTtnbNOvS6iesQ2yIlhBR/Q7YiTLVlsw/fZM+44ssSz5vFIy6z/1ajwi4fQCA3zgXruZdRuUVuXK67QBbTtR0TysfbvEBIHAWVwALn+2mthpRkKneYcBjuvgz6saTR6F6uf+nQM45hv45cLrOeE8/+FxwrMRAnChUqThOUZjy3pN0ljWGbfYS+rokgwc3jth3hdkS2PHLG2rNR8v1+2SyhChOhvZHfXC8tThKxW3FGLsuTudjgRczvyHQHn4yscEupZxkpj2uB05MlyCkQz3e+2pLH1oXer8aZoc4GTk0Rq2ZFnArRXlUi9xz4eClCx6jHcASuC0v2TnVt4VnyLbUYPWlObmVflgXq3GFldS2WzIf1jSC7ih2/7dE9Yv8XmWz0wpEVucGXVdROPOLkzsL3XoH56j62l03f8yZOBgjSRKXpYTTVaqTJaq6AFQ6UxKHITjaX6DXS/QqdM2mqmM6AInh+WpX9wbTdHn4x005XcxifFlmFiTkE1635s+vqM4vs47zymB7SQVnBoO9430UNMYJAcwqrJUz6VXgJnAHMle+cHylb7YX4KCobg8w3OrHyL/l7WCsef85aG3vDKZvby5ms5IXM54MODzW5LovWeNUAwh0sCM+KAOdgw7UL2SrNW7sWsh1zi+46UTMM3vCHOg0NHDFNTC/zFvc4T0gn85Coi1+sI8izzue9KSflzAltSYS6pTPtxrNQ6kvuiSI2wt/nNP6H2TccVNmmh72T1QC57CL53wL7D3JMDhJGa64tPBKHnOCaTT4JdPlrW3saZlcCTUknDRpDJt43q0A8JG4wqrIaBypkimmSPPm8JqvTmgQSrtusAI8ezBB/uzLhbgh84/eqeJ6vuEoNxJVQqGkeRPszy1MebrMEowB29
 hS2IDZrA
 HSl7gQZDVWd9HCjeh8NfHluAf4wtQRCFfSAF52iLGokjxmlLKNiTC9QxJl1EBWpdnaI7zvR3g/H2DuZZfwLHnLRVjaFCvH1WjHJbM2mQKd9df64HTaJNI/UtQF7ca+IVJi5K6cuuNz0Sya6DTtt0Ws8sOg4R/fgw/ovNeL5Trku0STviaVqNhSghMOoNOamA7OSE1yYe06GTGj7tfY6zbw01AtGwzET2SE4CrWrwcoUhOu+bYqffG5I6Fuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update __swap_cache_add_check and __swap_cache_do_add_folio to handle
Pointer-type swap table entries.

Add zswap_swp_tb_get_shadow() helper that extracts the xa_value shadow
from the saved swap table entry value in zswap_entry->swp_tb_val.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap.h       |   5 +++
 mm/swap_state.c | 112 ++++++++++++++++++++++++++++++++++++------------
 mm/zswap.c      |  22 ++++++++++
 3 files changed, 111 insertions(+), 28 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 1b07a08e5277..c23f54dc32bd 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -213,6 +213,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 #ifdef CONFIG_ZSWAP
 void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
 				  unsigned int ci_off, int type, pgoff_t offset);
+void *zswap_swp_tb_get_shadow(unsigned long swp_tb);
 unsigned char zswap_swp_tb_get_count(unsigned long swp_tb);
 unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb);
 int zswap_swp_tb_dup_count(unsigned long swp_tb,
@@ -223,6 +224,10 @@ void zswap_swp_tb_put_count(unsigned long swp_tb,
 static inline void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
 						unsigned int ci_off, int type,
 						pgoff_t offset) {}
+static inline void *zswap_swp_tb_get_shadow(unsigned long swp_tb)
+{
+	return NULL;
+}
 static inline unsigned char zswap_swp_tb_get_count(unsigned long swp_tb)
 {
 	return 0;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 20fb57adbb7f..620dc763eb3b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -175,16 +175,29 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	old_tb = __swap_table_get(ci, ci_off);
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
-	if (!__swp_tb_get_count(old_tb))
+	if (swp_tb_is_pointer(old_tb)) {
+		if (!zswap_swp_tb_get_count(old_tb))
+			return -ENOENT;
+	} else if (!__swp_tb_get_count(old_tb)) {
 		return -ENOENT;
+	}
 	if (shadowp && swp_tb_is_shadow(old_tb))
 		*shadowp = swp_tb_to_shadow(old_tb);
+	else if (shadowp && swp_tb_is_pointer(old_tb))
+		*shadowp = zswap_swp_tb_get_shadow(old_tb);
 	if (memcg_id)
 		*memcg_id = __swap_cgroup_get(ci, ci_off);
 
 	if (nr == 1)
 		return 0;
 
+	/*
+	 * For multi-slot ranges, Pointer entries are not expected since
+	 * zswap does not support large folios. Return -EBUSY for safety.
+	 */
+	if (swp_tb_is_pointer(old_tb))
+		return -EBUSY;
+
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
@@ -201,7 +214,8 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 }
 
 static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
-				      struct folio *folio, swp_entry_t entry)
+				      struct folio *folio, swp_entry_t entry,
+				      void **zentry)
 {
 	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -216,7 +230,26 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		VM_WARN_ON_ONCE(swp_tb_is_folio(old_tb));
-		__swap_table_set(ci, ci_off, pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
+		/*
+		 * If the old entry is a Pointer (zswap compressed data),
+		 * extract the zswap_entry for the caller and preserve
+		 * its flags. The Pointer entry has no inline flags.
+		 */
+		if (swp_tb_is_pointer(old_tb)) {
+			unsigned char cur_count, cur_flags;
+			unsigned long new_tb;
+
+			cur_count = zswap_swp_tb_get_count(old_tb);
+			cur_flags = zswap_swp_tb_get_flags(old_tb);
+			if (zentry && !*zentry)
+				*zentry = swp_tb_to_pointer(old_tb);
+			new_tb = pfn_to_swp_tb(pfn, cur_flags);
+			new_tb = __swp_tb_mk_count(new_tb, cur_count);
+			__swap_table_set(ci, ci_off, new_tb);
+		} else {
+			__swap_table_set(ci, ci_off,
+				pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
+		}
 	} while (++ci_off < ci_end);
 
 	folio_ref_add(folio, nr_pages);
@@ -239,11 +272,12 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
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
@@ -269,22 +303,28 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 	ci_off = ci_start;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
-			     swp_tb_to_folio(old_tb) != folio);
-		if (__swp_tb_get_count(old_tb))
-			folio_swapped = true;
-		else
-			need_free = true;
-		/* If shadow is NULL, we set an empty shadow. */
-		__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
-				 __swp_tb_get_flags(old_tb)));
 		/*
-		 * If zswap has a compressed copy of this slot, convert the
-		 * just-written Shadow to a Pointer entry referencing the
-		 * zswap_entry, so the data can be found via the swap table.
+		 * If zswap already stored data for this slot
+		 * (zswap_store wrote a Pointer entry), leave it
+		 * in place. The count and flags are stored in the
+		 * zswap_entry struct.
 		 */
-		zswap_try_convert_to_pointer(ci, ci_off, si->type,
-					     swp_offset(entry) + ci_off - ci_start);
+		if (swp_tb_is_pointer(old_tb)) {
+			if (zswap_swp_tb_get_count(old_tb))
+				folio_swapped = true;
+			else
+				need_free = true;
+		} else {
+			WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
+				     swp_tb_to_folio(old_tb) != folio);
+			if (__swp_tb_get_count(old_tb))
+				folio_swapped = true;
+			else
+				need_free = true;
+			/* If shadow is NULL, we set an empty shadow. */
+			__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
+					 __swp_tb_get_flags(old_tb)));
+		}
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
@@ -295,7 +335,14 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 	} else if (need_free) {
 		ci_off = ci_start;
 		do {
-			if (!__swp_tb_get_count(__swap_table_get(ci, ci_off)))
+			unsigned long tb = __swap_table_get(ci, ci_off);
+			unsigned char cnt;
+
+			if (swp_tb_is_pointer(tb))
+				cnt = zswap_swp_tb_get_count(tb);
+			else
+				cnt = __swp_tb_get_count(tb);
+			if (!cnt)
 				__swap_cluster_free_entries(si, ci, ci_off, 1);
 		} while (++ci_off < ci_end);
 	}
@@ -410,7 +457,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx)
+					struct mempolicy *mpol, pgoff_t ilx,
+					void **zentry)
 {
 	int err;
 	swp_entry_t entry;
@@ -457,7 +505,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
-	__swap_cache_do_add_folio(ci, folio, entry);
+	__swap_cache_do_add_folio(ci, folio, entry, zentry);
 	spin_unlock(&ci->lock);
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
@@ -514,7 +562,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     void **zentry)
 {
 	int order, err;
 	struct folio *ret;
@@ -527,9 +576,12 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
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
@@ -645,18 +697,20 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
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
@@ -685,18 +739,20 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
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
 
diff --git a/mm/zswap.c b/mm/zswap.c
index f6e8259ab56a..1bb484d1ac87 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1687,6 +1687,28 @@ void zswap_try_convert_to_pointer(struct swap_cluster_info *ci,
 	__swap_table_set(ci, ci_off, pointer_to_swp_tb(entry));
 }
 
+/*
+ * Extract the working set shadow from a Pointer-type swap table entry.
+ * The shadow is recovered from zswap_entry->swp_tb_val which preserves
+ * the original Shadow entry value. The shadow can then be used by
+ * workingset_refault() for refault distance calculation.
+ */
+void *zswap_swp_tb_get_shadow(unsigned long swp_tb)
+{
+	struct zswap_entry *entry = swp_tb_to_pointer(swp_tb);
+	unsigned long saved = entry->swp_tb_val;
+
+	/*
+	 * swp_tb_val preserves the original swap table entry.  Only
+	 * Shadow entries carry workingset information; PFN and NULL
+	 * entries have no shadow to extract.
+	 */
+	if (!swp_tb_is_shadow(saved))
+		return NULL;
+
+	return (void *)(saved & ~SWP_TB_FLAGS_MASK);
+}
+
 /*
  * Read the swap count from a Pointer-type swap table entry. The count
  * and flags are stored in zswap_entry->swp_tb_val which preserves the
-- 
2.54.0


