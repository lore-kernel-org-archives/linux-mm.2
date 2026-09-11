Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A0BC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94A86B0093; Fri, 11 Sep 2026 08:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C316B0095; Fri, 11 Sep 2026 08:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B026B0096; Fri, 11 Sep 2026 08:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A535F6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:15:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A3E1120177
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:15:00 +0000 (UTC)
X-FDA: 85201375560.21.77E4EBA
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1F05E16000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:14:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789128898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQWRUvMVAUph2RK7qQDxv52xZIsOGQavIyfLWg2qO2c=;
	b=SLVWVSTFHuwLcvqZdSXE4q4flMG9tg44fuLWvts2VbcfGwIQlVz9XDVU6VZ0KJvkxFMnhY
	T9T0DJvVWsE0WAQiJ6ZgX5Ari1XKnvF/Xfl91OvBPhebYfrgW23Hfvp2SoF+MdqCds24ip
	XC1Z04JXhpxfhnIshjwE66guycmHsHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789128898;
	b=GDPJNyugdSJxbGLNG3Hnpv9rWt5HHHWm/ZkeoNGp/TFsE9JaYGzVr1ut8wHrC8RC3P1Tit
	YyPfKF3YeRc4rtbS5q+2LFP4AI8j2H5HRF8OVKLnx8SwdcJbXRn6rg50/D2eAcxs8QX6bY
	eapfZMHQf6bzJoBhBxJCxUJFDMRW1as=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id DBC853EE31;
	Fri, 11 Sep 2026 12:14:51 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Tal Zussman <tz2294@columbia.edu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Fri, 11 Sep 2026 14:13:28 +0200
Message-ID: <20260911121341.178028-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911121341.178028-1-alex@ghiti.fr>
References: <20260911121341.178028-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEHRPri608QdqX6Uj/BbR+hiAEqvAJNom1pMUaPCDF92wYu3ptg6D8gDZW2m7AvuQwIR2KkJm7RAJk3qeVC81VqEBriyq2Xdjp0AkofstRRVIHILe7cZr6l7t4f+ZKKWwj7745VQLOUqBJD9XxbkV5akW9m/vZnNgm4vNpb9ydmOxvLDanCIkyPQkljOkGS/d6zP/hgl5t79Smmd9JlhTybu2Diwh+eRj0dOJKXMe8t0uExHKdrFvDVypESTLCitwfT3LQsgEesG/8CTTaCUNDOth3Vv6FT5jDyJo9k/tttrmUE3LC7BxoOrohdZXA7bWgJIy8/L4PoQV6JuGOeZNVrAydr/M/Unk1WMzvuPcjb4Hd4uk4M8iOuPTUmHhjU58cXIEjZeyJQlaRrUBY4zkTuVoehOKQUGCsV/ONEYVrKv39Wks4nHPDUS0ZmY3jXR5P9iw2byjlaTIr8qSHXgVNi5xOmkBeXJIaZiWXzFL2loFPw3GIhhYeAfYEAmy33dbUQ6iFfIo2XbUY2HE3oNuYwAZAODPAkv5Bhv/RITaIy5Y+VlE1InwPCj2LkbRYK3uzszINY0nDeIfQcwUcEpxtypI2L+HqLeS5xdm/9y3UY7NELZObB8MtI7hIjPwJZaDK6DL2EH80xTRXH1V0rF+eyEV92wcx2Y57t8IV5lQJk5g
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9zk51nxo6bh9j17datksqi553cn9b58f
X-Rspamd-Queue-Id: 1F05E16000D
X-HE-Tag: 1789128897-701682
X-HE-Meta: U2FsdGVkX18+vudjyUYm4jciaCb7Lki4/8prJmdPdQ5nSlQjEcRL1OpluTD+5nSb6VDRmna/aIOSTz/4C3nh7ScFjtbHwizqZUnXhzR+adrpyGtVfzv6nEw8Dl1W1JSj00o+GzUU+UuvWn7InrJpTJLKZ+nefxBkeVMH9vKiyrlfybyzSDFtOmNTEWHmFp5EQCy3Ur+Kp0FeUBl4fTiRtIhf6dkhkm6+br05Qg0fSYA+6QEjoaGEK8BKuUB5uEL4BnDkiQcpE/XQdDUXvF+YUFDfqp7CvLObalni54SIiDxFE9wmTOUd0GySvHtxEtWqodDxhCSGUqe0LtFazeF/9FZ5++/RDKEZ3QGQK3TagsFuKDHyZtTcdbsFMgScByZHHkqKlWBPaQXW1wQXVR8YV3jqw0bHyjHKDx+TuauVBPKklgbnwDMXsPZBCSZxdfQoYaR5/FSlRl5cFw2MhJl9DZWQ6+TQ9X0pLUAjZiEVMevl4/+5lzZX91oEp+Ag87z6alnPKzw+uXqsvJl9qkeITANO8wR8qnxjokfcHmJXtK0I6RXEK1ff+uvcdBBE4XZvyPloIh5wRId9Vpj9VzBhgPzwIjLxLNYD3HxfGHE5gVZPUsXJUIhIGm1D4KpF7JRZjLYoz+XVTovOb4SPxyZwUtFQRYgPu/QS0PqiMqACiOhnpV5ZrWTCjUsSet6QXvYnQoEMQ1kgASmw02Vx9JYI5y9RyIYmleBjdb/rn46BvH/ePH/kzD5Zo8L+b1doeT4MCS4vG1L1/Ct4R3/x59R0baNtmy8CaB0t6+fukH8pU39w40nopAdhjSZMG0xu+P553gZ+xKM0egKz+Ec01UaeS+O8yMlVSuS8A8QUO/r6n3jVMIVjKg9tm4VjTf6iuQnlOrSGOZ+g1qO5kxYqjEZ8vx/zcB6Y+/WybsYfuZAfDDpkRgLMHJsub2XgDmzxE1Y78sBtmDQQCxDFjOg2C+E
 shdA48ja
 ETQDHMZRrC1Wa4SNa+g+nXQMKp0Oj6dhMxrKBcqUr4sH04Kwn68LwoUhvd7DUiLYgLE5a8PcCHZULv+Isx0uCqQxWEUVlsCEYBcio+YnQSQBnAtK4LznOkceSzIN6lEzvGyJx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a preparatory patch.

__swap_cache_alloc_folio() adds the new folio to the LRU itself, which
leaves its callers no way to act on the folio before it becomes visible
to reclaim.  Two users need exactly that:

 - moving the refault evaluation out of the swap cache folio allocation
   requires it to happen before folio_add_lru(): that consumes PG_active
   to file the folio on the inactive or the active list, and under MGLRU
   it also reads PG_workingset to pick the generation.  Setting either
   flag afterwards does not move the folio;

 - zswap writeback dropbehind needs the buffer folio to stay off the LRU
   entirely, as the per-CPU LRU batch would hold a reference on it and
   keep remove_mapping() from freeing it once writeback completes.

Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
each of them adds the folio right after the allocation, so there is no
functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/swapfile.c   |  2 +-
 mm/zswap.c      |  5 +++--
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 90a551a88df6..8679cb61268e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -312,9 +312,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f3961fdd857d..e5b7fa468ade 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -489,13 +489,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
 	return folio;
 }
 
 /**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @targ_entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders, must be non zero
@@ -507,13 +505,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
  * @targ_entry must have a non-zero swap count (swapped out).
  *
+ * The returned folio is locked and is NOT on the LRU. The caller must either
+ * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
+ * it directly once done; a folio left off the LRU is unreclaimable and leaks.
+ *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -649,12 +651,13 @@ static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(ctx, folio);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -690,12 +693,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(&ctx, folio);
 	swap_read_submit(&ctx);
 	return folio;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53bf01d5f7f1..d678a40fcaac 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1870,7 +1870,7 @@ void folio_put_swap(struct folio *folio, struct page *page)
  *   CPU1				CPU2
  *   do_swap_page()
  *     ...				swapoff+swapon
- *     swap_cache_alloc_folio()
+ *     __swap_cache_alloc_folio()
  *       // check swap_map
  *     // verify PTE not changed
  *
diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..0d2efe21f18a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1001,8 +1001,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1014,6 +1014,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-- 
2.53.0-Meta


