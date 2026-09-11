Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2FCC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670226B009B; Fri, 11 Sep 2026 05:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6219F6B009D; Fri, 11 Sep 2026 05:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512C66B009E; Fri, 11 Sep 2026 05:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294F46B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:22:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF85FA3C18
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:22:33 +0000 (UTC)
X-FDA: 85200940986.11.407B9CB
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3201180004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:22:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/UTofjDfGPNE7fv8/ntwJzVqMNYKtsdaUh7SXWvqsSc=;
	b=N2uvXrrCN4z20gT3ekIw798Uk2CXatYVPPebRWr9JlbPpgp7vCGF50rv6f4KaaVA9Sq1dk
	0hVwOF0intox4amW+3YriTzOZZYH7ENbENTg6z6Ob1SvH4cec5J3KNO+igUl7Ne889qAxL
	ipyth1w4h3taIw8wmWC5bjGHl3dsmWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118552;
	b=gJoQ+iv21z2OREIgPMQpy3Z+6A6RVGIpVW07HHouL9psjcaNeSpLejrzoqt0PoMtcxkz9m
	+yXTC88mx76ane9uaciUymSHW7PLAy4dvawCfga9Q9j9+kPrdsizak+M5bEAYVlqLvDaeR
	3juj05Is84PvKEeKo517KhjkoyMpM7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 801C53E97F;
	Fri, 11 Sep 2026 09:22:24 +0000 (UTC)
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
Subject: [PATCH v4 2/3] mm: swap: refault on swap-in, not in the swap cache allocator
Date: Fri, 11 Sep 2026 11:20:06 +0200
Message-ID: <20260911092012.92399-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911092012.92399-1-alex@ghiti.fr>
References: <20260911092012.92399-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEXUoAcTyxqs6DHuS9bexJcXxMxDWHXvKBIE5yJKvJ1l5Z5tjXpj2z0YH4g69HcaifX7LU9iZAtDhaYvP1e6KaK12VCqCrwmqG0NiWAe2+yovGW8qe4hB7tMi9RhbFgIMptkZyZ7V5on3kMbTXoq15zOJ+7iTP43ZJYgRBXQTZOPpguoIqpSHHa6HkjKM3Q0x0dGvABnyZRjNbmajTuj4am1MQqXUSyzSfzN7UanmP7HnKdCUySLAOiF0Yhc2e6aMBpt40WHxFOlZTqYIlLiFbVTSIGxPc3fgOKENtxC7Tenicq834qOzgDJXh3T2uEU9hPdjXCK8TIqSLZ6ur7kyo4dEUxqeq1g+09o/ki3xxHK6EOnUU+5YWUPXUfL+Tfn0jVbpl6XAAe4RCNC94YcogjvcPO8033kW0XCG8LziHlmwPNU1+Xv8v1OvftMmgsLn5FaCriQd7NcA/Dekyn3A+nZq2AVzY8wIHKmWObOnevHduJUKiBAI8A3GZhcscJ4qnXt0yJBGdEQKNCUr8p9TA5Us0t+aR3/qXXssnZ+EV+pLsIFeXxHF4YYLmZKlXVUauboGjgoansfJAXH8TibeuaHoSacortRDdhUEuYptE436XIuDVLSbZY5fjWLsEkdWnQdTEjn4tlBMENgaD0EYuEmmPzGtv3RxaHXbKhFHMh5A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E3201180004
X-Stat-Signature: pxzyk1nq7t8nyjq6zh3frbuijot5zo53
X-HE-Tag: 1789118551-102862
X-HE-Meta: U2FsdGVkX19iBj6Rb/YLFkkbGCiqWWE7mDn3HWJXFp3QKeUwVPKnogueLQSpMNzSkW0kVivrthYCucFh37lS1WV+2kDuhYdk3j5Z6cw8DzBvOhE8NvtJtwpXFVGyUkRBqjU3WxDdTtoTXxtvbkEOT29QDOGzbShEswS2IJBn2lY4yAj00Uk1HZKaxJQeGEnNffVO500u0joADqnXOXpGKa6efSGTXiWMArv9ztpdc6mJHICzasTVV1sWEimhg8UmkdgL/Pbyh/I3l8arMP4yBvgE4gqjWOP8KSv5IuQuUG74ZCQtkldWwcPXdZFIdV13Ctn/Ncm6KwjzkawXWQMTbYqKcoCdiEoWqtayia+M0vTTBSgudTcYYG/4QY+poETO3t9PFRj/atAeAvIvz8QeciKyHaKFWnxtNWAjq/050TWgUwXes2z4OGP78OnPsIaNkFo29RHq+UVf+fHL9w2khrB23arjwDzwk4/xhnJv6emUp5ztn8A6DcILxgIzMmmAg+42PC6PRZYuBxBfjP2aiITrqOj+MoOIsV/QPc4SYsvIY8tl6LZbz8pXpAzsE/OoiJ5RGuFI/x4c0MnPoP7cNCnLL/u2aZjwsKx9WRnMzR2yloQ9mqeBUnWZqQgBYEg/0ZsCuR0wNzOOqcwlN98tjsKu9rTtY6i74Sj+0Ms0SSgGTRkyqvkELRCBgDglZhu5EmWYjY5p8JT0/90vG+vWcD4mJ1J1nVHHJ31cr5fp6RISiGz0FY1CmYW+sX24wX2bPcOJqDlCFOZRjcC5v4C+srI/ASDC/f8G7omByqE7+QVYsX7o9qmaCQmNmTE1m3ViKo9KJpjndWZSN8VaY5eIf7QLRhi3ConsbbJGSQB5RMxr/F85GCGioJSkIQ+QWkoES3D9X7q7i8lwC+g3K3CqZ7aliSgNlzSquTEd0fNKXsS1pRv4R+l2fqoKzZRTmbPfzUTga/yvi+C5UcrR4Lr
 GTJExFtu
 +xNSVpa7dOV/w2sPnEVJz3P192IBtJG0eOXb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap cache allocator evaluates the refault of every folio it
allocates.  zswap writeback also allocates through it: the shrinker puts
a buffer folio in the swap cache to write the compressed data out, and
that allocation is then counted as an anon refault (and, if the eviction
looks recent, as an activation) even though nothing faulted the page
back in.  On a workload that writes back continuously this inflates
workingset_refault_anon and workingset_activate_anon substantially.

Move the refault evaluation out of the allocator and into the two
swap-in callers.  zswap writeback keeps allocating the buffer, but no
longer reports a refault for it.

The callers cannot read the shadow themselves before allocating: the
allocation can sleep, so another swap-in may install a folio, have it
reclaimed and leave a newer shadow behind, and this caller would then
win the insertion but refault against the stale snapshot.  Hand the
shadow back from __swap_cache_alloc_folio() instead, which already
captures it under ci->lock in __swap_cache_add_check(), at the point the
insertion that displaces it succeeds.

The refault is evaluated before folio_add_lru(), as it was before this
patch, so workingset_refault() still sets PG_workingset/PG_active while
the folio is off the LRU: folio_add_lru() consumes both when it picks
the LRU list, and under MGLRU when it picks the generation.

Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  3 ++-
 mm/swap_state.c | 28 +++++++++++++++++++++-------
 mm/zswap.c      |  2 +-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 8679cb61268e..5e959bedf5a3 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -314,7 +314,8 @@ void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				       unsigned long orders, struct vm_fault *vmf,
-				       struct mempolicy *mpol, pgoff_t ilx);
+				       struct mempolicy *mpol, pgoff_t ilx,
+				       void **shadowp);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index bf8ff2d2dbf1..c95d1ddf3193 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -409,7 +409,8 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 					swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
-					struct mempolicy *mpol, pgoff_t ilx)
+					struct mempolicy *mpol, pgoff_t ilx,
+					void **shadowp)
 {
 	int err;
 	swp_entry_t entry;
@@ -483,12 +484,13 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* memsw uncharges swap when folio is added to swap cache */
 	memcg1_swapin(folio);
-	if (shadow)
-		workingset_refault(folio, shadow);
 
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
+	if (shadowp)
+		*shadowp = shadow;
+
 	return folio;
 }
 
@@ -500,6 +502,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * @vmf: fault information
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ * @shadowp: Returns the shadow the allocation displaced, NULL to ignore
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -515,7 +518,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  */
 struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 				       unsigned long orders, struct vm_fault *vmf,
-				       struct mempolicy *mpol, pgoff_t ilx)
+				       struct mempolicy *mpol, pgoff_t ilx,
+				       void **shadowp)
 {
 	int order, err;
 	struct folio *ret;
@@ -530,7 +534,7 @@ struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 
 	do {
 		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
-					 vmf, mpol, ilx);
+					 vmf, mpol, ilx, shadowp);
 		if (!IS_ERR(ret))
 			break;
 		err = PTR_ERR(ret);
@@ -646,17 +650,22 @@ static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
 		pgoff_t ilx, bool readahead)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol,
+						 ilx, &shadow);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(ctx, folio);
 	if (readahead) {
@@ -688,17 +697,22 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 {
 	struct swap_io_ctx ctx = {};
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol,
+						 ilx, &shadow);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(&ctx, folio);
 	swap_read_submit(&ctx);
diff --git a/mm/zswap.c b/mm/zswap.c
index 0d2efe21f18a..16b78d44fdd0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1002,7 +1002,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-					 NO_INTERLEAVE_INDEX);
+					 NO_INTERLEAVE_INDEX, NULL);
 	put_swap_device(si);
 
 	/*
-- 
2.53.0-Meta


