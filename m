Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD3CECD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986D16B008C; Wed, 20 May 2026 11:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938356B0099; Wed, 20 May 2026 11:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E0C6B009D; Wed, 20 May 2026 11:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 713186B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 371E61C0768
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:11 +0000 (UTC)
X-FDA: 84788111142.03.76F0960
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id 084AE20021
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XDjS0uf/";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQXjUbTM4iHYcDcs5d+InjFN6hA+vO3mGOWCUeiALP4=;
	b=ypd1M/r757VGnZZh4V2FtCWeImdwitenhZIMsdYpJvPpAnAAibBMwTReXzoxOJ7LQM1oGv
	zmDyWCXWSnlLplY5vfxhOdY8a9cc+H1KfMp9s9fbIDjRjY5BoQAmMCC3LEiY+yLvhN+1ca
	TXPEYJnj2+t2y/Tg3BGM3xdxKjoQgIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289269; a=rsa-sha256;
	cv=none;
	b=eNLP87S2jLK128L5/LxB8K0WyRUC2eI4z30B125cMI+8tNNym6iNNHHH0qaeC3e8AEy9VR
	VPfPvtE+BWnZNZuS74t5WrThSO+GbEuare/ciUH2f5KNlOZDVDJyx9Gyw5bOhTgAR5jbWw
	nTZ9nm4Cay5pQlNHAD6pCmDDoqRGwn4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XDjS0uf/";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gQXjUbTM4iHYcDcs5d+InjFN6hA+vO3mGOWCUeiALP4=; b=XDjS0uf/xvBIXecJpX3z5Qn4T/
	3UpZRI8V5GmDC1Ef4EgttMNcKxUNwk6+1FzzDy+6ll6srrwu4uq76bXWpjHJWpt2H5EKZwJX2Ljog
	/y2bNYBTWJUPkUXzdMTiH4ORK0v+ij64xY0JL+lXm9vSb5zWkxVv3euYlzrCt6CR6n4NvSOYREOZg
	k3RJFUxJeVXzb3Kn7yfhX4hE+ITtiKNx0DQNI2+fbs/xOkFpY1CtDwYq24mizxBGhnCCvQcoy16cU
	9G5k3Xkuqqcho51ZXq9LMnApRD/9ZCsoOBT1G2y35QYt1Zei5Qapq0H9O3QyG0Lvnn2/N+L2YRkJ+
	4mxVt48g==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2Is2;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 19/40] mm: page_alloc: aggressively pack non-movable allocs in tainted SPBs on large systems
Date: Wed, 20 May 2026 10:59:25 -0400
Message-ID: <20260520150018.2491267-20-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 084AE20021
X-Rspamd-Server: rspam04
X-Stat-Signature: yebppeknqbst5c6nknd75f8wy1hd7cs9
X-HE-Tag: 1779289268-883015
X-HE-Meta: U2FsdGVkX18Y0BBQshD00L4wuK6FnsZD8lR53pZkfqJA3vaLZ4UQtKDgipSVrGsRhxDiZHMN+ftFN8V31qQCdEpdqkIxzwMSvslg8j5nB2t87LIhRArsxCvWazErbZbsCnrgXhGUvMSQhjr47mWLsXt5exkdDSnVRUEb/6UMFlkqeUTjmEklbnPwz8coCeddfWTqCLNXv0OCGuX4DcCgL8MKeIC8fUwg4zsyy8yH8KNEWbTHakTGjsMNXGOT6okVAikChuerFcFSECQJ+UG5pNiR1tYJAjXyR4L9AGU4BObQgb8E5+MBDi4qqcdgN473rpJX2xOPDvIeeRzSxBnC3GE/BQVxhBSDcplpiMp5iNhQd7I5m/NsWqDZ7hIdm9XdCK/H9uoFnyMH/XOpwcumJ4YrqoXdT/f/VGmcpwBVRz/BYVSr43K2ri1sdKJui4rHwR/5pUpd/YfxTrkQO4puoZ0fQnaRCVaahr6Zk0eataxoEMZfnkLkkVMu7/Iqy+MEZ1MT35Pdt8YMoH4jzmGYEkH4pkcGIk+O63oVO8b0E6aZ3GD6UBHzpogs/BzhicXf+A8/1e8LFqE8WYQo4KBsCi1L2PIG9TaWUGDHRYVWn7IqrAzwPQG91Ye6i0aT3DZD8N0LHW94J1RYPEXwc456GIN/IW5n7kmXtqNEwdybywU9Jb/NHZfxam5jL0EgFsehEfPX79VHVwhwJBuqeRbr2N2v9o6QI405g2+YfZuMqaE7jiVovS2pPlDrh0deGqladmIuVwrxzXzDvw8sbOJhuXI9SWSqlFRh5ZPqAdIciSjNFgvDlx5MhBl7SvfGskkum4itbx2PmSjbPzdN5c/hF1aybf8TNdzzHZ2KU4qXLPrsYZp4LKguJ7ar7chRI7myZzBc+FmLCWP+w3trp8EvpXhBjnc3NMDzkVSjLdvG35k+2clZyDKvVFe9yR8Ymk/lVOqn5j4D+XW3fy4eWeR
 iB1zrwJT
 uTXYF4Vrqq+RJP2JrlBtTLDh6mLtXXKO2rCUm5eMNNRKFlv1tTDjyoEJ9ZdlUaSbDK7eZ3C9YX4ZUkZxvmF3qSUYI40USk44OdbUDz6WuaBoifbCud1YP8PIy780635NtLz6v+VKikehWqbBZ4uzH9PpUVm7GaWPz9YQVR0Bw77lSy6wPSWSp0NEooTRdWfpesAyhuQFzey6ulnH2REqBDO4X2VWe++C79j+s+BYgWVdDvQHDqRNa3p+r6sDh3GdbpY7S5Fuv58ctHSV7xpatIbLq2yZtGbnC0hKkilqqgA+30pwZFr+qdeWPjjaKXDVxeTZq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with many superpageblocks, sub-pageblock MOVABLE fragments
within already-tainted SPBs were being skipped by __rmqueue_claim()
due to the ALLOC_NOFRAGMENT pageblock_order floor. This caused the
allocator to fall through to clean SPBs, tainting them unnecessarily.

Introduce SPB_AGGRESSIVE_THRESHOLD: on systems with more than 8
superpageblocks, relax the min_order floor for the preferred category
(tainted SPBs) so non-movable allocations consume free space there at
any granularity. On small systems, preserve the pageblock_order floor
to protect MOVABLE capacity within tainted SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6884f638a97c..63151e99bd53 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2659,6 +2659,24 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  */
 #define SPB_TAINTED_RESERVE	4
 
+/*
+ * On systems with many superpageblocks, we can afford to "write off"
+ * tainted superpageblocks by aggressively packing unmovable/reclaimable
+ * allocations into them -- even sub-pageblock fragments -- to keep clean
+ * superpageblocks clean for future 1GB hugepage and contiguous allocations.
+ *
+ * On small systems (few superpageblocks), each SPB represents a large
+ * fraction of total memory. Aggressively claiming sub-pageblock movable
+ * fragments from tainted SPBs would destroy MOVABLE capacity that the
+ * system can't afford to lose, with little benefit since there are too
+ * few SPBs to meaningfully separate movable from unmovable anyway.
+ *
+ * This threshold controls the crossover: above it, prefer concentrating
+ * non-movable allocations in tainted SPBs at any granularity; below it,
+ * only claim whole free pageblocks from tainted SPBs.
+ */
+#define SPB_AGGRESSIVE_THRESHOLD	8
+
 /**
  * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
  * @zone: zone to search
@@ -3585,6 +3603,7 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 {
 	int current_order;
 	int min_order = order;
+	int nofrag_min_order = order;
 	struct page *page;
 	int fallback_mt;
 	static const unsigned int cat_search[] = {
@@ -3598,9 +3617,18 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 * Do not steal pages from freelists belonging to other pageblocks
 	 * i.e. orders < pageblock_order. If there are no local zones free,
 	 * the zonelists will be reiterated without ALLOC_NOFRAGMENT.
+	 *
+	 * Only apply this restriction to empty and clean superpageblocks.
+	 * Claiming within already-tainted superpageblocks does not cause
+	 * new fragmentation, and skipping them wastes free space that
+	 * could prevent tainting clean superpageblocks.
+	 *
+	 * When ALLOC_NOFRAGMENT is set, skip empty and clean superpageblocks
+	 * entirely to avoid tainting them. The slowpath will try reclaim and
+	 * compaction first, and only drop ALLOC_NOFRAGMENT as a last resort.
 	 */
 	if (order < pageblock_order && alloc_flags & ALLOC_NOFRAGMENT)
-		min_order = pageblock_order;
+		nofrag_min_order = pageblock_order;
 
 	/*
 	 * Find the largest available free page in a fallback migratetype.
@@ -3610,6 +3638,31 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 * ones.
 	 */
 	for (c = 0; c < ARRAY_SIZE(cat_search); c++) {
+		/*
+		 * When avoiding fragmentation, do not search clean/empty
+		 * superpageblocks for fallback pages. Tainting a clean SPB
+		 * is the worst outcome -- better to fail and let the slowpath
+		 * try reclaim and compaction in already-tainted SPBs first.
+		 */
+		if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+		    cat_search[c] != SB_SEARCH_PREFERRED)
+			continue;
+
+		/*
+		 * For the preferred category (tainted SPBs for non-movable),
+		 * search all orders down to the allocation order on systems
+		 * with enough superpageblocks that we can afford to write off
+		 * tainted ones. These SPBs are already tainted, so sub-pageblock
+		 * stealing doesn't cause additional fragmentation.
+		 *
+		 * On small systems, keep the pageblock_order floor to preserve
+		 * MOVABLE capacity within tainted SPBs -- see comment at
+		 * SPB_AGGRESSIVE_THRESHOLD.
+		 */
+		min_order = (cat_search[c] == SB_SEARCH_PREFERRED &&
+			     zone->nr_superpageblocks > SPB_AGGRESSIVE_THRESHOLD) ?
+			    order : nofrag_min_order;
+
 		for (current_order = MAX_PAGE_ORDER;
 		     current_order >= min_order; --current_order) {
 			if (!should_try_claim_block(current_order,
@@ -3881,8 +3934,18 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 	 * For movable allocations, prefer pageblocks from the
 	 * fullest clean superpageblock to pack allocations and
 	 * preserve empty superpageblocks for 1GB hugepages.
+	 *
+	 * For non-movable allocations, force ALLOC_NOFRAGMENT so
+	 * __rmqueue cannot steal a whole pageblock out of a clean
+	 * SPB. Stealing is the worst possible outcome for a bulk
+	 * refill: a single network or slab burst can taint dozens
+	 * of clean pageblocks. Phase 2 will adopt sub-pageblock
+	 * fragments from tainted SPBs before Phase 3 falls back to
+	 * the original alloc_flags (which may eventually steal at
+	 * the requested order, a much smaller fragmentation event).
 	 */
 	while (refilled + pageblock_nr_pages <= pages_needed) {
+		unsigned int p1_alloc_flags = alloc_flags;
 		struct page *page = NULL;
 
 		if (migratetype == MIGRATE_MOVABLE) {
@@ -3892,11 +3955,14 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 			if (sb)
 				page = __rmqueue_from_sb(zone, pageblock_order,
 							 migratetype, sb);
+		} else if (!is_migrate_cma(migratetype)) {
+			p1_alloc_flags = (p1_alloc_flags | ALLOC_NOFRAGMENT) &
+					 ~ALLOC_NOFRAG_TAINTED_OK;
 		}
 		if (!page)
 			page = __rmqueue(zone, pageblock_order,
 					 migratetype,
-					 alloc_flags, &rmqm);
+					 p1_alloc_flags, &rmqm);
 		if (!page)
 			break;
 
-- 
2.54.0


