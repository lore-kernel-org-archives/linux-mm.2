Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47161606A897
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsllZv5n
Received: by kanga.kvack.org (Postfix)
	id 40A5B6B05DD; Wed, 11 Nov 2026 18:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2386B05DE; Wed, 11 Nov 2026 18:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F2C6B05DF; Wed, 11 Nov 2026 18:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2D186B05DD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 662DC1C3C1F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:40 +0000 (UTC)
X-FDA: 85424424960.30.E2D6B1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BAE7C20005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsllZv5n;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439598;
	b=Cv9HB+e8gAYKmS1dnfl2nsFtWNXVEqby/xkrmnHpfFPRlMLWixZHNVIwsJSPzHuD1Fb3GR
	t8nZDBli4UybjbqfO5aRXSe5IUTbdWZns1lXR+z3POrxTrDVWWtKh5GZYxlB9yknZh6x0q
	9OjQZyiIjdcq23APUgtVWgwTjQAq0ck=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsllZv5n;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7XUwUomnVCDK9aa962ZIpgMQ6QHHvHVmOdhzPQ+ujw=;
	b=vpL432eThvP1cxnmblj6jooJpnbXN7IJSBHjt97+cieeW/bnDHbmzWxpFtNI9c/pJZjY8Q
	6g8clW8yL3elWcl/5Q0/yrQVVI7pEXwMwR+g9fn6YMMlH9Dy3Am1eO392Y8z+AVGUB5ONZ
	nxRi/PnJxLA4z0AiVgjZjllV1K5nvLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12C7642B94;
	Wed, 11 Nov 2026 23:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0651F00A08;
	Wed, 11 Nov 2026 23:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439597;
	bh=s7XUwUomnVCDK9aa962ZIpgMQ6QHHvHVmOdhzPQ+ujw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsllZv5njedZwKJ59odVutAPlnA2JBfk1ja8Af6vB6OmwMExoSVmyla8TZHyRWMVb
	 RfRogZSnw2H4NEJOp1jN5OYqtVaCD3P0MRdJ79rCIhhxwATWYZHMy8648AWiLKunre
	 tRsuWlFSYNQYsRjxryXSsLGv5/aqho8DULqMpxk3P3SxWMZ3P//ZyoPSpXVIlObg8W
	 BDdVW1/7XEYDyIDv76XwWUj6bVOOQpHVgujK30c1KSCf5TovDzGAprba1bihMRBzeV
	 EdijAys2qvKgqImPwGAIAkFYZRSQ2eFQmIB/ORSGpv5a+TjYVapE6PweP7qqno3zi8
	 YSiyeV7CiOVqg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v7 05/16] mm/mglru: skip zones above reclaim_idx instead of rotating them
Date: Thu, 12 Nov 2026 07:25:52 +0800
Message-Id: <20261111232603.9934-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uxxpb3iob8c9pjg8ncmuiicf17395oab
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAE7C20005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439598-784014
X-HE-Meta: U2FsdGVkX1+XoCyVdghrSPsSo+bQP0gzBppdOY/kvJ0wktma7D9mTESkT616aMt9RgO5oO5CTLPb75Rj0D0vfIShhtxhkQ7SiGE0KM+0TXZBReNTc2Z1zOkbDUOegz8DwUpE1fRFVrbp4ibtpywOnS1O4aTd5NQNKScOngUgssJQ6niOaIKcdNmEl4SaWK3otItZlB/9lP8LGjFdQUTVxWqXDDzMIbz3fFE+g8gm4EaffBEq+Eis2T8Mtd3MrGshQZWz+nlrslJhpBEHv3BPGMObj4MireziSyNt96VDyamLLHT0WvKhBjxuQ229VGs9Bionf7SdGG0I/oM7WbJZpWhKNMh8KQJjGgBwWhSynY0HrgiGcgHrEcquZlKtVorQonNdazkZb32z7O7IMueujGW0Yew3G1yqqspz+b0mX1eZ+SMbpOWERf+VINAlC5mXS/uvJW6s3INwCA7M1sNJ9JQ4D8h+GeCT52OYTVTMeiUcTFlDp2O9U5DlXgkn8/MqfEvA1JGRCcuzmCiAsBirf7OxIrmuXY61M6fRRckv/1+NMD0LAJaY7CYjxeiS0pSRSCjkdXnTjuPXz3CmAjC4+V5jNt3KRi61Ke9YQOAZpcNyLV+zxFbp2pkLrWonidzmEpQoTk1XBcw/QqPletiAWRIhhT2UyTMrk7nyxQRkb0Y0GArLTMiAiJu65+pC/77pI6AOJkZ1TLTp33SvkonyjjCs5E7n5Y0OA8d73jAwDHuIeGcT7E3MsJRvAK9mvMqmJAlIfIqvy4CtxVZQwB+pjWFDaWuCmUtlU3IVR7ew4S0cY5Te+fmFzGNlaeCYZrSc3LeegNaEWboW3t+RgiA1F+R0vt5DZ84dFb4bZtzonhoYp/J537QiyWsD+v3yw5QA2x2bRoSL7/jerXzbTaf0UsTipXAWg/mkf41CGDBWjI2AI5xNhbovXpW18EJKImiVRRpsBFjWK2GhG/7pyON
 GnxACjbl
 xeaCh0hPIKzJdDYtLVCziFIZMmD2CTd+F2v0gsLL2dNoj5By7dja0LJW2B5gDL0OU3R+XdROLOep/3olK5OBQEO+gH/A7PBrR10BYpPDVZjqeKthSB8rtTiSUjUKevDXIkQU9kd12ejttUcYdw/f+K6xVETyREXxG+6Hf3wltqQTCHML+Wt5BGbL1HwotX7MpjKvjrY6tG/IL/OFDyNME5Ahb4PXbFmlfgvosgF0QMTE2eA1hzTeCjRUPXSaYKyGz+n90Q7nA3kLocFdS6akgWgUkFItIaWr1rOtUK1xFyL+r3zV/7GzyhEHMjYFQDO3AVNAR+4EBdyyG7ez5QxRUOv9CC/P0CpebhipWrAAfOiLQ9+5j7K24kd6+np/sm4NFGhsI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

scan_folios() used to visit every zone. Folios in zones above
sc->reclaim_idx can never be isolated, so sort_folio() rotated them to
a younger generation, the "ineligible" branch, or, when only one gen
was left, skipped them. This wasted scan work on every pass, and the
rotation kept the protected folios from aging.

Restrict both the scan and the gen selection to the eligible zones,
like the legacy LRU, which only isolates folios in zones up to
reclaim_idx:

- lruvec_populated_min_seq() takes a zone_limit, so the oldest
  populated gen is searched only among the zones the scan can
  reclaim from. A gen populated only in protected zones no longer
  stalls the scan.
- scan_folios() iterates the eligible zones in the descending order
  of the legacy zonelist walk, draining the zone at reclaim_idx
  first.
- The ineligible branch of sort_folio() is now dead and removed,
  with a VM_WARN_ON_ONCE_FOLIO() guarding the new invariant.

try_to_inc_min_seq() still considers all zones, so min_seq[type] is
only bumped once the oldest gen is empty everywhere. At DEF_PRIORITY
the search bound stays min_seq[type], so the scan still starts from
the oldest gen regardless of whether it is populated.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 47 +++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index db0a8a3e8887..6b1670677974 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3991,7 +3991,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
 static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
-					      unsigned long max_seq)
+					      int zone_limit, unsigned long max_seq)
 {
 	int gen, zone;
 	unsigned long min_seq;
@@ -4002,7 +4002,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	while (min_seq <= max_seq) {
 		gen = lru_gen_from_seq(min_seq);
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
 				return min_seq;
 		}
@@ -4025,7 +4025,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	/* Requires at least MIN_NR_GENS gens for basic functionality */
 	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
 		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
 	}
@@ -4684,6 +4684,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
+	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
 
 	/* unevictable: let it through and the generic path will cull it */
 	if (!folio_evictable(folio))
@@ -4700,10 +4701,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	 * longer be promoted or protected, so just isolate them. The one
 	 * exception is lru_gen_reparent_memcg(), which is handled above.
 	 */
-	if (min_gen == max_gen) {
-		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
+	if (min_gen == max_gen)
 		return false;
-	}
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
@@ -4720,13 +4719,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	/* ineligible */
-	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, min_gen);
-		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4758,16 +4750,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
 		       struct list_head *list, int *isolatedp)
 {
-	int i;
 	enum node_stat_item item;
+	int zone_idx;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
 	int gen, max_gen;
-	unsigned long min_seq;
+	unsigned long seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
@@ -4779,24 +4772,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * when under pressure to respect swappiness more and reduce IO cost.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		min_seq = lrugen->min_seq[type];
+		seq = lrugen->min_seq[type];
 	else
-		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
+		seq = lrugen->max_seq;
 
-	gen = lru_gen_from_seq(min_seq);
+	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
-	for (i = MAX_NR_ZONES; i > 0; i--) {
+	/* Scan eligible zones in descending order. */
+	for (zone_idx = sc->reclaim_idx; zone_idx >= 0; zone_idx--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
-		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
-		struct list_head *head = &lrugen->folios[gen][type][zone];
+		struct zone *zone = &pgdat->node_zones[zone_idx];
+		struct list_head *head = &lrugen->folios[gen][type][zone_idx];
 
-		/*
-		 * If there is only one gen left, rotating the unreclaimable
-		 * zone become meaningless, just skip them.
-		 */
-		if (gen == max_gen && zone > sc->reclaim_idx)
+		if (!managed_zone(zone))
 			continue;
 
 		while (!list_empty(head)) {
@@ -4806,7 +4797,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
 
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
@@ -4825,7 +4816,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
 			skipped += skipped_zone;
 		}
 
-- 
2.34.1


