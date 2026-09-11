Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0FDC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891926B0098; Fri, 11 Sep 2026 05:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841A86B0099; Fri, 11 Sep 2026 05:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731186B009B; Fri, 11 Sep 2026 05:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D95E6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:21:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23B671C0403
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:21:27 +0000 (UTC)
X-FDA: 85200938214.03.5782D9A
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 329E2140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:21:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118485;
	b=D1dpGVMBf8A5ruBNnTLF6zZPYiLQPMrGnNkpMTkaj0vJ+XfIyWIsI29+KBozMG7+gG4GYd
	3Xn5f60e52V+UzfD7wUxS7pz00Xai9YooVBd/LSacFUVsoAakWonWrkeEYxKZRfke3wCsu
	H3NxMZWjU92laqpvbJWkbqH3eQzWjm4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUJaOh2KD6xRBWpt8F1wTgtn33PqQSG0Nzak/7jX/RQ=;
	b=B7P6gLP24v2PswzPQCTrJuF+Fq4y6oSZXlr/p7J4y3E583OAkh0hP+xjfGe1cqbe6R4Qi7
	w10PGB3iUDPUU2gZOOIclVw6PpxB7C9NFFXef526cnzSiLSQ/3QkW/fC1VkfRSciONe/ED
	tPwloD3YSFEW0otqrJIX2esUHX//RqE=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A74F03E972;
	Fri, 11 Sep 2026 09:21:20 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Fri, 11 Sep 2026 11:20:05 +0200
Message-ID: <20260911092012.92399-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911092012.92399-1-alex@ghiti.fr>
References: <20260911092012.92399-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTEtas3CrwcasTY741hFvgzjpFnMkpMW1lbw3r0llWGiLFx/Y//z6Sz+CMZcDh8lwgArDwMrlPA3TSGMVfVpHEv2C6ty0hoyShpKtj2D4Q/451T6PEIEOXKgRyf1pNZV0vQxCWoAbt40ORR1ArLGrBuSZHK4P2ukcqghwIEMJPGzodJ4eD4rm1fS8IYOoRUwFfVzSPqjFMGFmT88rlEUzIlnFZwJBlSPjL+PJMMbkjpKNnW/2mo16VEyUBDtZcMItfChdkCMa/2WcMi/p2H6h2nPpFy0zdThAqC4XGY7cJV2+ojzT/cIFeQKbpJsrq4Wp/8TBNFTE2dzdnX9+OK1NOsCsS7LOrFqOvAZon2BAz/vuuOVDUdYbSYIs7G0HSuKPD4OPqgA0DDepZGF+17BpNOvIuopes97lc8SjQOVyWMhh5gpTCk/qnhgU0bpf9voG5CXLwqh5+ihZxqAUTnNTRHJ+MjBspHmvfT/4kPXDP4TD/QlhV5ul480ODBg5TTibi4yKpOBeP5ryPDLet9gnH8KgSKgFoiyIKjLv+WbC45K7P5OTKKB6NIG8472SOVnsgthYgPWTIdDXxSczNtFEUIGdrCR8GwHLircQ95Na7+X/E7ZyYDhepgm+HWCmxxmEI97YRdlAvTemkXT8Q9Z0m2CBTU8yUG9lZgMK+rMN9hQaA
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 329E2140007
X-Stat-Signature: iimfqecmor9kxg79q7ihsrgeyhpo5ujt
X-HE-Tag: 1789118484-226967
X-HE-Meta: U2FsdGVkX1/b8fnbJIxpes6zs78rYzvxMEeAzz80j7kTrf++/IWt71xdoAAEwisAvG8b5TFdzAwGvBdNDvL5goLqr5EbgDorveEw9Ye2G1/BB+fDP7DP5RDc30k8Zh4/3VXscs0S010Lk9+suOZ6H9p92QIgTnqn40SaI1EZxHSp/ZxryW6V00EtYv3SUI0OgzoRk8nmXFfK81iam5MVAKyLFuj5QbrZC2L/NxndI0K0e96OkmCOYI24Vfzy1cQxqFXlKETXUzhu/YzGSixjxTm16Y5Ucyjxwbwil7piO1r02ymQOahEzehFKwwMDq9EMyMIfllFUJ0xAfBVBYDE0ToCREA8P6rb3k7sIVEZmVnMacdO+OwIcl7sh8Qm1lv1bG+qE7DKexYSiyweBxWPgf+z3soQuL4TBLzd2h3uH82tSKAXjvBsp4+1hWLvBUzL2Pfw+eny7AepJshZemJ0qlW/4ot3A3axeFM/hjz92Gy7JfEETTtvxBvxwNirh+sslp2XxIGRKTWpPXMuIcw1geiOMDjcRBSe4E0LaKK7sx1U+OKpOvwZn6Clav3JHK+Xla5g9i2tOd/CNl63PQoR2u1KtOYgbHkPTFLPyEdcG+MzPzc5hH2eR8b/l45ZuiUEWP1u7bKyGQ/ylk0GUvfFBP2WJOOFFtOUy7BhJBC6zSyLoktzGgS15f4fgtF9Iuywgo0VOdWDcK0jXfsuAS6I6tHDAQZxODfug1SfDx8o3cSwQM4NLXYyu78Q1ZPBLHiun8pLT/IWQjQplKTwVX9rPOJ138v7XwVyQBQ7Nu3J4zhslbe2DRTdC66lxCC+mCTjp5rrdTXRh2X8oOD7tTEmgk4sLEyrdoeEbZQwA3/hwdESEDS85Lx91wUTLENmepIsXiAoaoOZLWvSlkCLS0P3UfMG4JDzN2JEGZGxbD1Nw0Y2c3Eo+51i6/Jo/M4tHwnTV0/tbzaa3mG9KwDew8d
 gr4RqusF
 +XH5BhgJau0dYFHpA+E6Q3efIyQdiHRbQIjoby0vHSMBALILKBtU4iTHaFTd+nicDk1fGdQaIq91yOz7lJex3J+8wIrQmlnAxHwsWMeGu6PhU4HJ0s/YNZg4di0zFYJ9DyVyW
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
index b76eb3d876fd..bf8ff2d2dbf1 100644
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
index 51f5a525bb61..bfd0fb46b0ad 100644
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


