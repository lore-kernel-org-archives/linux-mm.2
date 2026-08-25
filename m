Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD337C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4736B009B; Tue, 25 Aug 2026 13:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBCA6B009D; Tue, 25 Aug 2026 13:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09166B009E; Tue, 25 Aug 2026 13:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFAC6B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:28:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2936BA0160
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:28:29 +0000 (UTC)
X-FDA: 85140475938.17.D32C16E
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id 257E3A0009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:28:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vl7bEynMWSjiFy6vjljw4mFlgSqX1Y/ZwpvF5U5zE6U=;
	b=wlOK5/fCL1YP+NRXkyEcwQchs/UDrbg/yFcxaLpTLZzLmJN9Z6rJ47YP0rFFMWwpjF+Xk5
	byEoDhkF5nc+ElGl2RTjCambqkO+tc1PJKI2GXGwgDIjXBpgPiOv6vrCR7E6LUmK3RAW7v
	qYR16J3kURArrPt+NHcEXOu8egrCgwI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678907;
	b=fgXLFmMrn/TDVLOoTzmqMBtFcAF9TJEB8P9KKQFofaYKsql9V1c8VcaBhOP5nWbvQvw6qi
	2t9+Zn/tR+SP5JZMFo2r4JworwHcGg9q3se6b2A1kzfU1j+0b5ZgdsvGmR1o/Q1M86oZiT
	NYjWirZOpNcaQEzA1BHEhPIBTLVc+h0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6B0D73EDE5;
	Tue, 25 Aug 2026 17:28:18 +0000 (UTC)
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
Subject: [PATCH v3 2/3] mm/swap: refault on swap-in, not in the swap cache allocator
Date: Tue, 25 Aug 2026 19:24:52 +0200
Message-ID: <20260825172604.3243589-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825172604.3243589-1-alex@ghiti.fr>
References: <20260825172604.3243589-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGuXf3ghZ7rYDYxzXV8RauQC1RsZOMtVX8R8/jyCcT7w60jVLhrnsd8+zDWNvFcxyHkL3rqxQWZ/B6Qg3LZw/qysGCHGLT1lKqQPV83iJfiu83bvgTwi0m6gx4aEdryF4z1f6cA35quoGQ69laGawak6Skf1iD/ffYdhAotj+da3E9GoEkDikUJaZwhz/Ga6LMJNZYWKp8dmj8LmnB5994N+ylycx5Jt6ZrBPcaEhmzgEBfyjIyiCyB46wCnB30WcuGmfYKS54s8AYguEB1tCRhEFmMGw6BPKvzg+Oec2psMPXjuSNYRvkkipS4hyXqIDIpK96Y1zEG9iaJI1e11SWzlDGSxLDeo8RaK8MCCJ7aF2m9ApJuHbIHm7vtDoFf8exHTf7oq009EeOLltMDW/IceYvx9GlqR9W13j3z9mOfavnMbvA/AnJf0IjRf3vGcw0a/ElnR1YoaffLdLufDIf0qylbDnuKaq+RtH6Z2N9zI3mM202Y3e6AspVuzsMthcXMPDGWX6M3D+ex2uuA0GgKwrQTPlE43nDK+yQWtPyb2vN39ILFuFzYeevz9JaJrOfNojmrkrD1kAmi/h34Sx++O/8glW9MxkYSqCgJb5EB8l/TYP4gkaSBpiEn0aDP+YFWCflgRtFaqEs99mI0GkGfvpMKbGfkCudcsU5Bsw1Dxw
X-GND-State: clean
X-GND-Score: -100
X-Stat-Signature: 8igrhfzs3xrdk6fam4isfyfdbwkurpi1
X-Rspamd-Queue-Id: 257E3A0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787678906-903257
X-HE-Meta: U2FsdGVkX18ybk/8HTEcNpyeNH7iWsVA+nMzPYZHe+7I7sWdnfpkvswi1Lguiy40H8Tnm2cuYwkz9Z4rM9ZALj+gldLuPpOU2rHSWvJTrw1ouZu2aqI3iP6AJ2KOrZwoRv8EG7HvscDoIK67fpLxSaSMILKLzAPgHXG809zVatiTXpAoEJf9oGXzRWMOLNubgZomZbEDrrTrml1EKEbTtjDXFqUBYTQsgOAV91Rwkfua2+YLbEtq054i3MnFUxppxbDUMO5vnrIKX3lrl+oEHy0G3tkWzaw14JsoEBivmErOLyQ0IiJjdMywIra4x/4SlaUBvJtFSDlQBwGS/Z3z90s2TvGDQeZ3+yjekCxd26bflY8WGLSmKCXFpA0Y+NDIV50P3P2YSZvsxmjYUiXpy4cUIrd0i+Ka43+J5/bOCmq0IIAdL4zcnGa63D1x1BkXDJd1gONPK2TyQjDp+ekuy+NblzaxBiMNH4KI6lpt+B02bLWkyFE88zIH6lGmxOj62ekvOtwNIk/cmlsLvOxGt0wc+EUum0XQ085nuQngbH+emV7j9qCEUJ1yh9sLRibZs5WDPKRJVPUaIQDNzu45P0faj2P2JKiFVUsc/Inpwp+IzMlTYrd7K/dz/w2JxBQ1Nd4JT9n3ZdfVJSfZYjHrJmYna3FZLmykL7rvyTUIxfZNGbiXEHf9i4pQjKrNvwTc75Ow86nr02SruFkTMYV3STA8adLeg5MeHlxVNMxcGC9YylVlB4g3W0gVIAnol/oL47EmijM2f83xMpv7VrpAPlZWQu19Lh29GPvwW0xp3l4I0RG9bqGySWgeBdapTtURPJKbXGHW7+bPwBI3Fcv5SOzTe80LQP63ETgnYrXtRwwY81JstdO5I3bQZAdwo3rVLxshhExEqPZpFByFyz5P/cmcTinpOr68O/TVBEeXdGVNW0lxzOBZzjsywFYgjCVR2eMg/7tOBKMCR58Ewnb
 v1EoAF4A
 Kky7egMx2D/MwwQCcn24STXbrr0vuOZEZhpy9
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
swap-in callers, which read the slot's shadow before the allocation
overwrites it.  zswap writeback keeps allocating the buffer, but no
longer reports a refault for it.

The refault is evaluated before folio_add_lru(), as it was before this
patch, so workingset_refault() still sets PG_workingset/PG_active while
the folio is off the LRU: folio_add_lru() consumes both when it picks
the LRU list, and under MGLRU when it picks the generation.

Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index bf8ff2d2dbf1..8046fea015c9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -483,8 +483,6 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* memsw uncharges swap when folio is added to swap cache */
 	memcg1_swapin(folio);
-	if (shadow)
-		workingset_refault(folio, shadow);
 
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
@@ -646,17 +644,26 @@ static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
 		pgoff_t ilx, bool readahead)
 {
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(ctx, folio);
 	if (readahead) {
@@ -688,17 +695,26 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 {
 	struct swap_io_ctx ctx = {};
 	struct folio *folio;
+	void *shadow = NULL;
 
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
+		/*
+		 * Capture the slot's shadow before the allocation overwrites it,
+		 * so a fresh swap-in can be evaluated as a refault below.
+		 */
+		shadow = swap_cache_get_shadow(entry);
 		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	folio_add_lru(folio);
 	swap_read_folio(&ctx, folio);
 	swap_read_submit(&ctx);
-- 
2.53.0-Meta


