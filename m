Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 609BBC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777FA6B0098; Mon, 27 Jul 2026 10:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728756B009E; Mon, 27 Jul 2026 10:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A986B00AF; Mon, 27 Jul 2026 10:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25BEF6B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:37:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFDC0A07B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:37:36 +0000 (UTC)
X-FDA: 85034810112.13.676233B
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE6A840009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:37:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9c3EQDrXE3vRM1RVbiW2GeEHFsdgfcqVsnF8TLnbg18=;
	b=Ih9pDjCsbdyll9Kkf3TQ1VcByqFkWTOZ0UX3e2Tm6WfEF3Reg4Zpk/8k7Qlhjes5XgpawO
	B1WTbISYYZeZYex8kkcU0lx2VqrkQ2066p10WSU5llvGGC8gXOMWMOIr2lTbOW/wNzpJr3
	PmBQyDjN2IKWzLO+DmtW38vQuCK0jok=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163055;
	b=ip+ibPiDmoBh2wN+pr3zyQFw8rHvCTxv0NFKtRGERuFYrc4JPxHh/R2q5rOcHeIxURbbNJ
	E0c3BCGgkyFzU3Qr7sSuO9V5DDSpfts7cHg4Cz+uYOEAOQpu0juNbHK646bIvtu/emLNzs
	5b5micC25ASdG/4x6hQq9BGwdN0/yKQ=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 83E443E9B9;
	Mon, 27 Jul 2026 14:37:27 +0000 (UTC)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Mon, 27 Jul 2026 16:36:08 +0200
Message-ID: <20260727143618.1582318-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260727143618.1582318-1-alex@ghiti.fr>
References: <20260727143618.1582318-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGOfRGj+Y4aE1VYke1+m8o+GKG1gCm5Y7xcpj4upAxgjCYkun8pANvrTiq+OY0pCfJ40eTlWHQlkQZespmOciWdf4WlCT5C2JVQoaWVrFfVAhx0n88NKH+5xp0JJPNnW+EwBwtjBPLtFrR0+WDMgpUF0JeAmL+LQuc2RlQAdCb3HedO6zlMyxwA86n6Sd9l/w67Y8/zZMIHf4omdFOtHtrRjs/QQXKs8hNc4I4Hmk6ozkTKRZGYF4gghB/LL5qykh+PrAmMDRfxCGengayYEGk6oSH12wABQcn8jmeBsoXSSAl+AW3hNZu3sWejmOZD2ieLlBf9CVtvEVKZB3eQ1WzJUFtYSHP8ewHF+X432VvCY93Gacb6rEBqwUsEFJ/QozqcxTBRy86PLrr4PAzeHjbQ/UVv5Elde8cT18ITWJAN357wVsdLSdm83k0TIAFP68TeaQ8niKa3sO3rr6CGBu2dQErd/+yVlvkM9s+HHFvudq0il5OsZIHTEfd9Mj0WZSllmh92KWhxv7r+auAAbL0XdTVyZZXm9aaar0Je57AX+TjxH9TXOzM+nJlf2+c1zNu4RwnrVgJHDDAg87RcZDcwquyL57bqoJa23wbzmrbi3bU956mGt9gEZeZI7/OCPomVvDBLbOBSBK+QC12RdnplVQ5jn+kRpNon6n50lD6wrQ
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE6A840009
X-Stat-Signature: 4u9zr6eskp165e77zz6xhiwz4b4k7fux
X-HE-Tag: 1785163054-252576
X-HE-Meta: U2FsdGVkX1/KFc18LmvC+zHtDW/hSzKqyGYG8Y7+dlcf8otAKSeyax9s1/S6Nu1jx6a8jD2XGEkkf8//dqIABPDFJlUZgd8bMmPk/SWnSgV2kqmLIxfo+N06a8gZUtR3VfUXUbmkR0wg+GuZwiTV79LCepfrY60U4DouFfmWxtd0Y69yAtUn+y9HqnO2ewAFLY21Alabcfz1lCzuf8TlyEPsA14byNrY5qBjTukiLke0XWXUsSTjMUVgkIGf7z3Yzt8LWvE8EgfKLaXB9Yw/zZ/u2UeXwlf5RTS1PEEkKlLp5NCmyuteFvPYzyLEtnik7S4nNrcV7JGnZhdw8S5+IBBru45mtluJBb/RDLUNr+Uyhw8RcHxXLZI55UoPLGr+zvKNBUsMlCOlVelRgwkjd87Fig9Cn6KRUOd8zj3jNN9oLgU1pK2UygRru+WWn2CLnXIygxIoRmvWKz+fCVtgtDEMzWBq5CQ8QCo7qr0Q20XKgk/grVDb3ZzoKauGduOiM9jzesc1jdv4Eo7VwMJSBiOrHyszASa9O/XG8Pb3Jez8MrUG4SB8vUoayAkJ1O9jJMNixe1zjcbUvZOSdXnTAeGTLJWjPUZgUb76ed4alkXjScNS1tMQ4XQidn9KzwF15e+GesCDZaoSO+Dl1ZxEng0plz+zU8wbzoIDOt9cFd3hrtEaLwsOTeCeNxGHat3aO+wadpCALexGhys4IaAO7D7t6It1TNH6A6jwV0r25s7cD3ckzQmEzbnI6mMh4WwWDzu0N+d/ppfaNGkEMY6if22jAFowBvRwo4kBZSzTgVLQ0wposx2WwWAPvrh4FQzwSyvughaRm7EGVklqSLMyR8auStw1vmiDjIrxJ/84g3pk3nxe+JHuhmUqCWsMnScJVAoehErE6mkzfXduTgQWkFukxF77CvAKybZQANTo/9Q+Dpx4Uga6b+nY5+B190GIx+y5X93O/U4bDUek8YO
 2zeplbvH
 w3G9BBZOVtvsS1mpUN5B81pE4V/LCsSEx8ztZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback wants a swap cache folio it can free directly once
writeback completes, i.e. one that is not on the LRU (dropping the last
reference on an LRU folio would trip the free-time page-flag checks).

So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
no functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/zswap.c      |  5 +++--
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..fc44daae1de1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -304,9 +304,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
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
index 9c3a5cf99778..90638a8d7232 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -483,13 +483,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
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
@@ -501,13 +499,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
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
@@ -643,12 +645,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -683,12 +686,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, NULL);
 	return folio;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..8163e6c5f76c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,8 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1013,6 +1013,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-- 
2.53.0-Meta


