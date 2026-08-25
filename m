Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B02C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D72F6B0098; Tue, 25 Aug 2026 13:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF846B0099; Tue, 25 Aug 2026 13:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C57D6B009B; Tue, 25 Aug 2026 13:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 302746B0098
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:27:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89F5840162
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:27:20 +0000 (UTC)
X-FDA: 85140473040.10.5AAF08A
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9020BC0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:27:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678838;
	b=3Kt+0iWQ6gWxsQdnNhu91EE5wmm315bEfdrz4TwrKiPJ85n/73KI/gNLi0L0ySSzcuEUU4
	BRU6Yks3H2/MIsbLswJHFvqf1HfL/uc7CbBrO9V5UTsx4+BVWojHxgJRM4eNn6K5H7RySr
	henPETO2Mq0Zy6tGxsq/BMHfPSS4MwE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2k6KQgaKztM77n9fCNfzg7RLmOyvunNsDZ6oIb2dIqc=;
	b=ykt7eJyi/s68FmluqojepknFEJkFQx2Pc/SxgRZ0RH0S4uikcvkBQjtGDZbV7TZ45KoGAC
	0IHWt0IsAaStNMXnENseSWcE64ks32qM8g7kshQUc9cB/mjxFtlkL9pWir/ayRB1ANI1Pj
	ALIlBfvuyYob1QOZl+0RiianBjVmtsU=
Received: by mail.gandi.net (Postfix) with ESMTPSA id EDEAF3EE41;
	Tue, 25 Aug 2026 17:27:13 +0000 (UTC)
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
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 1/3] mm/swap: move LRU insertion out of the swap cache allocator
Date: Tue, 25 Aug 2026 19:24:51 +0200
Message-ID: <20260825172604.3243589-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825172604.3243589-1-alex@ghiti.fr>
References: <20260825172604.3243589-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGHWaeQor2XdghODYIizE0whc46SNMKvGLs5Ra4yOK+xpbqr4c3E/nFsazkd1XSSmwRHUwmmf/KPoOvyH5LiUDkGDLlWpaawqlR71TWKaTBuWmm9QefDgCYeZjOaHijyVfpjVjVK3lMlkqW5DbNiHpv9SXk8x0vCc5F7n6cybwIwvm55phmNpro5xdoAZx9zHyXtWN3FohIlrlG38PzZqwXMRXg/+FZUA4sNrgS2eQ6wgxdtKygivvS7GtkYwI4pogEPtjlQYDsX2EIZEahoTVLrM05Uo9YF1Oc2TCDCJXhvy4cga0VexTek6+4p0SodNxXDEsBCQY1VwNT3556twJLITgVUBGINoxNbMdNKJLxWvQltxzBw8zdTI6ljNVEhD3XLRpCxeTqRSkqAoX/2U8/Z56IYEJpor7cPskqxqzfHXEMzvPX8h/cFlV+CxaNPd9+cb6V789kz6mHliTTasP8mnpduYEtH4emdQ0eZxkbNu+hWxGkP7p2lHfWnsDxfSSL2mu3HeMRZlROIki1hL7C4uZti3trdLhGrY8eyQJP+oEQxFxgMwio/83j0VyCQfyqc/XKBw0cDWfCYuulsiPCXlW14udrFxcIUJiFYu4KAa5YaKYmSPUlk9o3poVGyoC47XnFxz7RfWnBrNPWwrjGScsRDpmqpKfbh96zt6sYlQ
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9020BC0004
X-Stat-Signature: n33aaqoa9xc88pnyoqjo9mcznao7ukq8
X-Rspam-User: 
X-HE-Tag: 1787678838-681713
X-HE-Meta: U2FsdGVkX19kXpGrgPiijMt0Z3+8UWdLcSAcv6vJJrgwrU3sXUz9+wHpKbHICINC+TZFi85ZbNofqtG7/yYK1UNYUyd8oxBnyH9tmsVMyaOhcehPBCZ3ft/F9UqB/O+els6MVI1zOBdjB6fU8FcOT+V6RbCXj2UNI+WVBzR4ADlEJ5nJlOkddU2QnFr9nd4A1yH5xCnkWvsj4KEFoTdow0XhnYOY+sndPx6l9Ejq/40VyVI5ByTqWckfk7fip3aQGJjawrqu1BOio77Lf28sN0bpf/U/hPpJ28CSKp9mGbXTK4cO4Xdlj85LUWRMLMdZtVBcmIRB/xgo+nvQrXiUJQVKh3mh1/tndx7LDjkIZn5Tosbw7iI+oCphlVhBs48+EW2KZEh6tYphu0JoyNG0i4Z0cb8wXfDra35an8DpQ5Fm/1jlnZw3qXB12frhhVN1R5QwdExaq4z69hyyyudkIVdGXaN1t1XDifmRKp31AjzKmIUkE7zEpr+TqS6+oCjCGagCncol8AUwwL7lej7BtZuafOAUhoXeVGvEKJKqOS7LnE/l6cuc6AfJ7TaAxnC61Mufl9wKQv8wra2YPyqhhWtL+sOntkvHWTWhPbFnBaY7BNnwhf/hmCPBlbLrapHQiRbYf0vYcFxUDXd5/8B7+nNp/jHhRv2o0kgDRvJCQmdeK23KAh4GgNbx+ivMuqGoagXoR+7cYxittxksv79wNYeDzQeyAJ50uls3ho6F5X0N4uewiyFEYlOfTLPJXUqDpGwTkfNcjKEzkyd9NGFnEkWoB13cT9ImpWXSnxVoF7UOtczHcfTDRYgAJLQnZAMvA6BIVI7sh1z6kBjCT18jCGBEHeB0cInEiTFwSrlaKHypy0KCryIwSTQsAJLo7R8BXcRD581uNk7/0aRLR7ymc8LuZZnwrEARspxgrFBeTsRtFcaS1mTEnvwIKTXHDGrxYjAUIGzxvjAxz6IewmD
 RrJcoJ1i
 P4muNRt3sC7pwIUQnOyVKhKYmQovn7qYdEI3E
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

 - the next patch moves the refault evaluation out of the swap cache
   folio allocation, and it has to happen before folio_add_lru(): that
   consumes PG_active to file the folio on the inactive or the active
   list, and under MGLRU it also reads PG_workingset to pick the
   generation.  Setting either flag afterwards does not move the folio;

 - the upcoming zswap writeback dropbehind implementation needs the
   buffer folio to stay off the LRU entirely, as the per-CPU LRU batch
   would hold a reference on it and keep remove_mapping() from freeing
   it once writeback completes.

Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
each of them adds the folio right after the allocation, so there is no
functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/zswap.c      |  5 +++--
 3 files changed, 18 insertions(+), 13 deletions(-)

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


