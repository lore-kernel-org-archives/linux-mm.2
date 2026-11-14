Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D3E606A334
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bh/GgWO7
Received: by kanga.kvack.org (Postfix)
	id B6D8C6B05DC; Sat, 14 Nov 2026 15:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D016B05DD; Sat, 14 Nov 2026 15:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E48C6B05DE; Sat, 14 Nov 2026 15:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0046B05DC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74DC8A02F1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:41 +0000 (UTC)
X-FDA: 85434812442.12.4AF5A9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8572320006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bh/GgWO7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2o3SI4bwFrc7bAbrnsYUQ3EEpOSbHBMvTUqeawpBv4A=;
	b=r+/Pbh5ai3s5VrxnDrPLMWjdsoB4h5t1355KOmaZngV86excJmDPWNdVFaMFJera+gGJKe
	Guu6w3NGL2QiyC6uBSEE+FjGwoonGyvPRsqIV+WvmAU7GVEf3DOl4IwTvs1GyTBcy80JSH
	phn5MQBDU6Qc70kiqeAdf+Hmh3lpHGM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bh/GgWO7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686919;
	b=hCmBcBjw29UCcaAhXzR4uMdmM9/m31frtf+mJg2CopnIIUDMdYFsxYBXhcHvBRW9HWp1zM
	l2hIotKr68O4KVWPyIyfx3uW20K7ygI4CePLZ9vUgFw6qKUhzPPg74q9B8i82kExdy/9os
	wgNfyKzTVuYZvsbs1U/6yvAfWtAjSGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18EDA618BD;
	Sat, 14 Nov 2026 20:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133B51F000CA;
	Sat, 14 Nov 2026 20:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686918;
	bh=2o3SI4bwFrc7bAbrnsYUQ3EEpOSbHBMvTUqeawpBv4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bh/GgWO7fMNO0NDCxtGb7jqy2fJNZoLZLPmqXU2ZRlVUVm61JiCI0eMV8KuSLTgRc
	 24U4jckx8mZATuDBT+UVQLrpJs+e4V0OmVVi/MTVnWkDY6AJE6L4l5tVV8phsCCkpC
	 azQyDMnI33Tdd6Yx5xx7BSi60eHXSkdSho1TYU7bSgo+zMNMIe2pNvajP3cAcGie0q
	 YHEUDpwuXZe6tu7q8ol1zWFA9sGrG4nDCZFrHGFDFCGZ5MusiVfu6kzr1VENNeU07F
	 dT3fy9swpMZbJeel6XgHoPVB3fNT/snacV7ChLCNQNEZrl4cespRUpU/Fh1wV3whjv
	 1pJA8WKmXD8bA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
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
Subject: [PATCH v9 05/16] mm/mglru: skip zones above reclaim_idx instead of rotating them
Date: Sun, 15 Nov 2026 04:07:52 +0800
Message-Id: <20261114200803.23129-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8572320006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4jabwpyrcdfhxo7jwu1ppjbscgjppixo
X-HE-Tag: 1794686919-228
X-HE-Meta: U2FsdGVkX1/s5C3NkXSmD2ADpGI8c3c/J8ry5bWnNFJkHL04L4b9S5xGYIAiqsrzouiRpjKN2Ws3Fg1acji8ExkwtFEyv8OS27+sIviF4yOzR50vvXFEriH+oLtlm0oIodz6/x+FfhtPciDoX4SynJDjEerqRwF6I4vRlKQYKiiBWzkRxwCVjxZbnS/FLqtYeuT352f4BIs4WDMLVvxjpphaxNItC95nZqcaVonj8/peqDCbXmczICOXq512aQSe045HH8Zv0xrzYMH4vuZlOg8htKapss5lmZdHL9aVINsasEG4XWOUjijDSVg3oqnT2RjLdu6cF0qFeMSLhOpHGdFB+xNnUh727vHUvMn+UBjfrsMrBVQzmxBb5ITy+uDXisbews4/epvlIwCO/ccUc2R7IFnu833CUO7dAdHgj+xHBLvTxknTXT7aTf3rCYf3O84hlYe9uzCYXLVrCzWoOqsir8h6+WIBVjbfcm3esc0r/sM/MlarlmMC+WNB7NkBubFeYwDKvc9qG3xuQ6q/h8qNjEwkBJyFZT78uLfK/2HuP4ThsetT96bYgQ1YbrdeTW9dxelJZ3u1hfE74WDiKY5o1fWxcYr8RRi9ZmLUV9nCgpQ+blRRxKI5s0AwTejp5oGapS6ryBAdipYiiWQcvmjngX2qKEvw0fWrje8SkvyqAhWT+qOVm9Oj9v5HzGyeRhi34zCc6JdX/BtEnRrA1GVrBUEq2xtzehni2X0uJOrPyhWGWL0uX4+I5FQk6ZrncvY73cP2fkRZvvXqDMLHHglUfwhK7m9uyTo73FtyC/nGCrp1225qpK64Dg/IaSqkwGtdLcGvYV6T2oNse9Gq2XFZ39stGU56paTpE3Ti4Ku2tGweaZ1SFy7429ryWWVG/BqC2rPHFAGABI1KbYd3KoOLrcdIBxNcxJFjWeHqAHdpuhCErDRZK5RsATj+BiVF/6tN1zJ1MxGIBYuftsE
 5kLhEU9c
 k/ZoUKcYP8iVDU58aTrMQ2jujdY+wjvcbqHYZNFlVQBsC5p3ikNFbbph/PMdx74Zk8zXfcLID8Mp0zHVFG5jkyzuIfQz+PLCJLjAOOSeM+c5IL2f/olOyE1Me22I3ip7SJhJ3rDp4+fdXuXgczmpr4XjYnGH1krZEXTLSIwQCBDLDbOMhUddd2ln6Kr5l+IefAUyzCGXjarZYWYCgm4i/sggZ+txhobEmMD/kYW4sAFrLrUI+tMrg2XvdfsGNure5SPi+hp0awO/wcOh0E1+CGxzLgvPqNTHyc8BO4YP188DoF5TCrR4ADAKhWe4kz/IgTj1xSMhKSadAXtmUGobapikPuMxrJhRJYjpRe/GtWtbrvwiAITnIe3o+6glFVSgR38Yd
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
index 603fb7c73f94..b3ce4a550a62 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3992,7 +3992,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
 static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
-					      unsigned long max_seq)
+					      int zone_limit, unsigned long max_seq)
 {
 	int gen, zone;
 	unsigned long min_seq;
@@ -4003,7 +4003,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	while (min_seq < max_seq) {
 		gen = lru_gen_from_seq(min_seq);
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
 				return min_seq;
 		}
@@ -4026,7 +4026,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	/* Requires at least MIN_NR_GENS gens for basic functionality */
 	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
 		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
 	}
@@ -4689,6 +4689,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
+	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
 
 	/* unevictable: let it through and the generic path will cull it */
 	if (!folio_evictable(folio))
@@ -4705,10 +4706,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4725,13 +4724,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
 
@@ -4763,16 +4755,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4784,24 +4777,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4811,7 +4802,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
 
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
@@ -4830,7 +4821,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
 			skipped += skipped_zone;
 		}
 
-- 
2.39.3 (Apple Git-146)


