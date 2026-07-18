Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C15EC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6846B6B009E; Sat, 18 Jul 2026 05:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A9B6B009F; Sat, 18 Jul 2026 05:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598446B00A0; Sat, 18 Jul 2026 05:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 258666B009E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:38:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84B1180384
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:38:36 +0000 (UTC)
X-FDA: 85001397432.24.A81BCF6
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EB35160003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:38:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784367514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ixvTnZ/iVK028kY6QhbPte/9Noobidws4Kchl4/zEKk=;
	b=lMCyp7sp2RmThSibPQfP8FdKf2/U9NWVXwif33SMS63/e9oAoeGUSdgMt0tPobjlrCaog0
	fTdyXxOXwYZNaPH8U5LU8QgW4vCVTp4oCY+amWlEqG4EYVZrpBCAHQAr7eJBMTEMeeZaGA
	VcoRtVwo+x0zgO44dV3/hVs8d0MUxys=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784367514;
	b=lsw3g9EOT+8hbTucouIUAjd/PxT9i/e86czuwoD65BzmTIhXR2g2kqyIKV7c6ISu1ap3Ab
	2wn5G+O+JTyAlAF8yIP3iczLiolSrn/ohkTLf4MwFDxVXUYIQlEk062RrZLHgmPEUZqTrq
	jaMxuSfTi9+/CzitiQO1ADAl+nbDdp0=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 943683E83F;
	Sat, 18 Jul 2026 09:38:30 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
Date: Sat, 18 Jul 2026 11:36:39 +0200
Message-ID: <20260718093723.153324-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718093723.153324-1-alex@ghiti.fr>
References: <20260718093723.153324-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGcSX6vKILToVNLKv1WVPr1SLvH8b57oTAO36Gk4UblSlEX77LNjuus2BGSuIvHmZSDj1TAAMWrqX7a9ejMqnV2sgjNpYBgRTOUDhHor/NZgx2haNGmPfXI+/8Of3s5OTjnrXd8cA5uRa0uZD5Zhvc9KKuHCjh/O1uiaj+MAvlwvi8geUDxVqCCbrlKBuWwENz68kowJ0XX4rv2LjHoK5nnw076u9td5NYgNN5IAmYT65mIXMNzcc9vBow3LjNztLEJOuaPxpZ41t1oee+ZYYtUtrHAmHR7xNQJ19JIsGn3ybuJbGsigcBoqzqvMe8U3+ndawTRVAzvm31EIyHRupvEbwxNbkeg3qeOvMA60SZF2VvCZif4C/08OnstATEDWYzSlsct8OzpJfCcqUbYU6e2PcXcymysMo+Q9083MG9iFOCvYolxfBHiUfYsvzwY6v382EHsRu+MASnfiw843kqxisCfYaHuV4Mek1pSreeG21svdQUH9o8oK9ti1zM+7oag99/uvcUEdMW6qUdGDSRTFEnxl0dr0TlJzQrckb2D6ecSgEP77wPA+ibYElCtqHQPB0o4xHdeV9Mm7+mdg9S64GLW3oYjcO1//vzcUC1d1Tg0hwiYAVrx2BKOSjGFEAwoOLA2Bu6CF5n0G1mLS/yA3EO0Ab0cs/4zLg3yZ+yFcg
X-GND-State: clean
X-Stat-Signature: om9be1ty4fnqfd85pj166dbneemznyyh
X-Rspamd-Queue-Id: 7EB35160003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784367514-681932
X-HE-Meta: U2FsdGVkX18Zc4fwBfsg148iO7P55xXHBTIWLnatJ0LuaoKDWRENFAFvAb/DjgcqFdeSR/wKuGNj7TN5EWrSxTvfKy9coLFH8f8RGwGDoM6I63hViSDasFPsrqREMVMeWsDX3wbrkjUHOBeM+X9gHus4HYOIwwq0YvAzChMWO7djmWjMtkUuFAOQi5273eKLkSrQLD2FRcnFfrrobUZkfZ9gR/KfPMjjyE5X+zpmdYpx+HVv4LocSn+qqd6rKEBme9bvnvZ8404zj0cm/TCesI2UHcRZXrqzXK34aGrrLGCr2RmnqihnjbPmogEmLvjU5wakKFP5ZEIAsEdyhe7bL+Iq9VedJZfWeOAF+RVJyNzRzO387xhRpI2LN5Ne98Je7W88NXQyKHZQWLOQRHkeKXRMJvkITAtY67OMxQ0moF+Sum7Pp9Gkuxk5amlQ3o46hul0OLHpCr4JCIqcL+hRUgT6wPWQoq7xISg/gDwzrnZhGEry1BtxEwqfWOyjW76j6CGZSzVwTFUlZzLOEYwYsrOarLlpkPx1q8W5Qd1EEbIcjWuzFaNdhCchjb3XB3yEfXmIkOussrsXvzVesev8HsVBvq0dJ89/i5//PJoBc4ep+8A56PfIV46hXKAa2BL6Y7H7dE/VpcBPjyKEibCFtE7xpA62ydxgRJkvu5zd1YEa24uQ6Ai75shXbXUb94lJhaasQg2cRh96y3pWFFvYKwF0ue/DGh5yqgd5EkFzKOZNvvp5G4O7a9RJP4C5g0qWBtDBQuHjJv2i1sLSD0bditFNlNRTqlbZBDmf20P02szadA1xcizbY5+QaOKxD+VGbtXNKI2M+ffMSKIVPXx2NxNeKygK878Sx7qAa7br9QBJC9KFRPEg6dngfbAW7X9yx1Kr42MFNNcNMpsP2bXxdCOqQdLEbeL7YQr3q56DyRUUHco3JZs6+Wxe6rNjFjrWNcgkCUsE2hYWb7XL6B/
 RuS9gnfB
 lxD7Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writes an entry back, it allocates a swap cache folio,
decompresses the entry into it and writes it out. That folio is cold by
construction, but it is currently left on the LRU for page reclaim to find
and free later. This wastes a reclaim scan and keeps cold memory resident
longer than necessary.

For synchronous-IO swap devices writeback completes in the calling context,
so the folio can be freed right after the write rather than left behind; do
that. Because it is freed directly rather than through reclaim, it is
allocated off the LRU: dropping the last reference on a folio still on the
LRU would trip the free-time page-flag checks. A folio that a concurrent
swapin has meanwhile claimed is left in place and reclaimed as usual.

Asynchronous and filesystem-backed swap complete writeback in interrupt
context, where the folio cannot be freed; they are handled in a later
change.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  3 ++-
 mm/swap_state.c | 17 +++++++++++------
 mm/zswap.c      | 36 ++++++++++++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..c617e5a0257f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -306,7 +306,8 @@ void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool skip_lru);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..048efc7ca612 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -403,7 +403,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx)
+					struct mempolicy *mpol, pgoff_t ilx,
+					bool skip_lru)
 {
 	int err;
 	swp_entry_t entry;
@@ -484,7 +485,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
 	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
+	if (!skip_lru)
+		folio_add_lru(folio);
 	return folio;
 }
 
@@ -507,7 +509,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool skip_lru)
 {
 	int order, err;
 	struct folio *ret;
@@ -522,7 +525,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 
 	do {
 		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
-					 vmf, mpol, ilx);
+					 vmf, mpol, ilx, skip_lru);
 		if (!IS_ERR(ret))
 			break;
 		err = PTR_ERR(ret);
@@ -643,7 +646,8 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx,
+					       false);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
@@ -683,7 +687,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx,
+					       false);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..3c494c5a671c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 /*********************************
 * writeback code
 **********************************/
+static void zswap_writeback_free_folio(struct folio *folio)
+{
+	folio_lock(folio);
+
+	/* The folio was allocated off the LRU and nothing re-adds it here. */
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	/*
+	 * Gate remove_mapping() on folio_test_swapcache(): a racing swapin may
+	 * have freed the swap slot (folio_free_swap()) and dropped the folio from
+	 * the cache, and remove_mapping() must not run on a non-swapcache folio
+	 * (it would trip __remove_mapping()'s mapping == folio_mapping() check).
+	 */
+	if (folio_test_swapcache(folio) &&
+	    remove_mapping(swap_address_space(folio->swap), folio))
+		goto out;
+
+	/* Raced: the folio is now owned by the swapin; put it back on the LRU. */
+	folio_add_lru(folio);
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 /*
  * Attempts to free an entry by adding a folio to the swap cache,
  * decompressing the entry data into the folio, and issuing a
@@ -992,16 +1016,18 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	bool sync;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
 		return -EEXIST;
+	sync = data_race(si->flags & SWP_SYNCHRONOUS_IO);
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+				       NO_INTERLEAVE_INDEX, sync);
 	put_swap_device(si);
 
 	/*
@@ -1046,11 +1072,17 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_mark_uptodate(folio);
 
 	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	if (!sync)
+		folio_set_reclaim(folio);
 
 	/* start writeback */
 	__swap_writepage(folio, NULL);
 
+	if (sync) {
+		zswap_writeback_free_folio(folio);
+		return 0;
+	}
+
 out:
 	if (ret) {
 		swap_cache_del_folio(folio);
-- 
2.53.0-Meta


