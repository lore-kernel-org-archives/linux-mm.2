Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3002CCA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B19B6B009E; Fri,  2 Oct 2026 20:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361E26B009F; Fri,  2 Oct 2026 20:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229B36B00A0; Fri,  2 Oct 2026 20:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6B316B009E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67E1C160683
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:53 +0000 (UTC)
X-FDA: 85279507866.03.C5A0D2F
Received: from mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6CB1A140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYQyj5tGei/QrEJjqCA91Zyv2z/vswz+Ix9dUYPP/gQ=;
	b=hfCZQ/g2tAoafX1eZ+sYXriW9ZOnX5/P9TmpuJSWp+Yt0kApoaxoOyHhi7yxxK/HqoNB5c
	6bpJE/sfmRiHqbdbdIu2dk+RwBGE6uGft+d4YjjYFOSCS2oJI3pwTob6JeYYTiAhLaY4Ku
	DzmhjtpeSqHDj02QDAuvXH4gv6VTVM0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989191;
	b=u/wnJzdkJmtq5nqUSRVKXzllKWE6r1/Xk12N36vBa5cYcTJ9sAo8j/FdpjkIwJGzBx4Or+
	YLiMJDRnrpDP/uL51aTd8kGg4mj40zC7C/2u2Pikl4ZvCf1natl28XShBjqbYqvQNWtK34
	LoXBVv/WJzrP4WTcbF2ecLATX9nK2Iw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 74dbea7703783e5b;
	Sat, 03 Oct 2026 00:59:50 +0000
X-Mizu-Trace-ID: 74dbea7703783e5b
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 05/12] mm, swap: use the xswap physical backend
Date: Sat,  3 Oct 2026 08:58:53 +0800
Message-ID: <20261003005900.909710-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zj67dfejcoy91f83e3i43ot7koafs7r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6CB1A140004
X-HE-Tag: 1790989191-972739
X-HE-Meta: U2FsdGVkX18xTvgukiKGgs4ISYkWZerRGQlrzNmDRtFtBnfgcQ08HGA4WB62yMjZumYAJ6GLzSG90B3H64UWp0oEZWoH/0DZuLQT71F+wK33ofzNIjgw8HioieFYirRvr5DMws7hOiLU2BJYvWms6FOCoZdk2+9D4jMyPi6MlwiZqBJKpk6gqoPJZMw9WIsa1brAkgHcVPR+eDElOTsOpMGUKoadKFiH7roNMaeUsHaxfJHp57ayNAoZrtSojZ+gOBnw6PYvA9p2UAIFiZUG8jBouCIVE/i6EAtG1prOkjsz6IUhtXz/lQEkI8RumGfm/YkaS4aERW0nC+0BNGfPNMCugc7A8E3U8w6wTbUymyieuafCqyaffkYTbFF1jcSQu7U8qkT4oXaQit+e6Jg8wM5/TbZZu9c318kBGtbA+v3D8LB4JXg0v7wWmMANBtqOoVKtvqIgx1Hjg5KvEQoRj5AMeg0AA6nk33tBwvnxEVBUZVdSid2ia7h3ELLfPRarRPdGDaFDywyMUEAc918M4zh2yhrc2BXlZ0ZUj97b946tnLfosRlXcmw91MfWvaPmAzXG/biRBCe3XwyamYsUZbze+EFGfhdEvmp+mPglunlYDo4/WQySKluIl+80aqt7kFfjyMdsBMLJT9JTtMJfDIqYrR9B9+RRAJ7zMvFDTKHn+dMW8m21EQN4IcjRXdvvBXfB1coHNWeR5dQvDwduSsfUrQ3PwNqd7XRrOj/luYI0HQskivi9mACyWOrdL5MByl0+xcGvD74B+ydA7CP9XS+KerA+t1GLbq9I01A51mIPqGGNl/Qv9MHVdk4Rr70eEd4KD36u3kvvPtI9EseddxjB+vrE4J4BTWt8NIXYG8EDYsNcqZ3YzM6wGVIAjxKxqSh1+WTdNUwmhd1/30nfDADQ9LvdYxsHPCuVCblRWOte5yDpHJvixZE6yA1kOD/9d7szoKNkt31aeQSCjSw
 igtcSRa2
 QLS2s6A+UPhWWm91gWAmO/q23MpMDPuWVBt3VJElf+sB7zMV+uyolvc19opGs1HXx4atZ3b/coi0s1gga4VxMb2qDzQKBFhWFKtWio939+dv/IsIonIWAxP70JVWgMA3wHpV8j9yPAxLkqf2yVAyMW6ffXsJwmGti9bWcIohWEC/Ni1pzH7PFVmNQLcJOHL+6KbjWyyuNBf3GQg2y30yK6N+P2lI/aI+Bo4cxQtl6OOPYt4H6CQZvaWi5dXtxjvQCiJy9iGATypkSZP01qGK4oa8p22ZOnilh+gKa40LvFu90Ebo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap entry that zswap evicts had nowhere to go, so
zswap_writeback_entry() refused to handle it. Send it to the physical
backend instead.  Reserve the backend before decompressing the entry,
so a failed allocation wastes no work.

Now that an xswap entry can be written back, put it on the zswap
writeback LRU again.  The base series kept it off because there was
nothing to write it back to.

A slot that was written out no longer has a zswap copy, so
swap_read_folio() forwards its read to the physical entry rather than
dropping it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c | 32 ++++++++++++++++++++++++--------
 mm/zswap.c   | 28 +++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 16ae84e6b785..6dc90182f761 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -467,6 +467,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	swp_entry_t entry = folio->swap;
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
@@ -496,18 +497,33 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 		goto finish;
 
 	if (unlikely(sis->flags & SWP_XSWAP)) {
-		/*
-		 * An xswap entry only ever lives in zswap, so zswap_load()
-		 * must have found it.  Unlock and let the caller retry.
-		 */
-		WARN_ON_ONCE(1);
-		folio_unlock(folio);
-		goto finish;
+		struct swap_cluster_info *ci;
+		swp_entry_t phys = {};
+		unsigned long offset = swp_offset(folio->swap);
+
+		/* May have been written back; reuse the physical read path. */
+		ci = __swap_offset_to_cluster(sis, offset);
+		if (ci) {
+			spin_lock(&ci->lock);
+			phys = xswap_slot_backend(ci, offset % SWAPFILE_CLUSTER);
+			spin_unlock(&ci->lock);
+		}
+		if (!phys.val) {
+			/*
+			 * No folio_mark_uptodate(), so do_swap_page() sees
+			 * this as a failed read and SIGBUSes silently.
+			 */
+			WARN_ON_ONCE(1);
+			folio_unlock(folio);
+			goto finish;
+		}
+
+		entry = phys;
 	}
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, folio->swap, READ);
+	swap_add_folio(ctx, folio, entry, READ);
 
 finish:
 	if (workingset) {
diff --git a/mm/zswap.c b/mm/zswap.c
index cdba35e0fb5a..e614c04697f2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1011,6 +1011,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
+	bool is_xswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1018,10 +1020,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
-	if (si->flags & SWP_XSWAP) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
+	is_xswap = !!(si->flags & SWP_XSWAP);
 
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
@@ -1055,6 +1054,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto err;
 	}
 
+	/* Reserve the destination before dropping the zswap copy. */
+	if (is_xswap) {
+		phys = xswap_backend_alloc(swpentry);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
 		goto err;
@@ -1087,12 +1095,14 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio, folio->swap);
+	__swap_writeout(&ctx, folio, is_xswap ? phys : folio->swap);
 	swap_write_submit(&ctx);
 
 	return 0;
 
 err:
+	if (is_xswap && phys.val)
+		xswap_backend_free(swpentry, phys);
 	swap_cache_del_folio(folio);
 	folio_unlock(folio);
 	folio_put(folio);
@@ -1516,8 +1526,12 @@ static bool zswap_store_page(struct folio *folio, long index,
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		/* No backing store: nothing to write these back to. */
-		if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP))
+		/*
+		 * An xswap entry with no real swap device cannot be written
+		 * back, so keep it off the shrinker's LRU.
+		 */
+		if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP) ||
+		    atomic_read(&nr_real_swapfiles))
 			zswap_lru_add(entry);
 	}
 
-- 
2.54.0


