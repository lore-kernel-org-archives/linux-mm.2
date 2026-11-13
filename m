Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33270606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E7Y2VOHk
Received: by kanga.kvack.org (Postfix)
	id 3F7286B05BA; Fri, 13 Nov 2026 13:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE1E6B05BB; Fri, 13 Nov 2026 13:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4896B05BF; Fri, 13 Nov 2026 13:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 039016B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85A2B4012A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:06 +0000 (UTC)
X-FDA: 85431000732.24.01B7CC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CADB61A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7Y2VOHk;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYPhMwxgLY5XGA7uuuhuGTI1Zo3kZ1fNeW+U1jYNwgU=;
	b=NCoJZ2sAHcX2S7OUr+Z5Pvi4XxfiKkOSpN2kcximwa3j+bbqe+vZBHeW5WZh+NqT0rXvh7
	tDHr7tG3QMVLHRBcgRH0GlIOBNmKZeq8NW+gyJBG9vHZib41Lpb8tkrstqk9MyX5q7xT/q
	4w/LSzWJo1zv7LJF/MX/w1nU4Adiu8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596165;
	b=Q410gnvnHpSQqkXWx4qSdVLhY8Ltid6p8W5cMdvX+n3FtRisZmi7nleE43+v6WQenEy0yZ
	rBOLI/L1hoHCskCTeLCGnkaVD9H0n/4vOSD77xPQBnQ+VA13G3QkTDGo+J+GOn6y9RSUJ8
	Zme4M4bkw0Rb4aziRnJBSWZJ4BJmeEo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7Y2VOHk;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 267B2400E1;
	Fri, 13 Nov 2026 18:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E6F1F000C4;
	Fri, 13 Nov 2026 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596164;
	bh=yYPhMwxgLY5XGA7uuuhuGTI1Zo3kZ1fNeW+U1jYNwgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7Y2VOHkMlrq9krw1z9fdp2I4M2VFVerb7PGTf1uunnpyaZXuXnQzy+jxkQYoxCb4
	 QQYq1Cjr0xJSucIwax7BZKtIQRIUN0zGVOSyXnpyTTXxpuBrLMyCIlgGlo3XV128VV
	 1yvoH7CFeXdGZxqRShF7tH/8ZuyKkM6kaeerBtL0GznyjKf3Po2oaasXsKTIjvVMXw
	 Ti6uRcEy2XI9XHgS3a27tKAnnZ40u7sAmLpE0deJMIIjt4QqpY24JqYtz2XWtYPBek
	 lpuRxgsGkPyeiNQO+QRJmgoXjeuOPCFLQKGNj4M2c9S6MwDlE9UoV4g/imObmCxRQW
	 o41lNDkn3n0dA==
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
Subject: [PATCH v8 03/16] mm/mglru: reclaim from the oldest populated gen
Date: Sat, 14 Nov 2026 02:55:28 +0800
Message-Id: <20261113185541.70203-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 451pig6be6ias54awowij65x1e7qbt6b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CADB61A000B
X-Rspam-User: 
X-HE-Tag: 1794596164-582159
X-HE-Meta: U2FsdGVkX1+YRPDlq1TnmZ+H7yBlvlJWZIrlpMPKQgnElqEBDN+FMYuOt7AS0uiDccDF/f7PVyoUdfPzDJijr//VnQXjTdrwGIVZIYIL0yl4+K5dZj3oMfVZPQYOFBbtoF++DAtA2PSDboMkckoFG0RGsuj5Q2SlmX87/2BU9n3t4c580Ga/YbCiBrjA6F12P9JAhxmz1pSFNzVzzwwp/ZEpawVLGnBqwiuo8aMHVmQoG9f4akzWFYrQ5sNI8q+CAy10i4SubL0/aKvO8pHk1R6yctcDhC9mCIZTceDnhNAOwkdFRzLKCeuKFG8RU8kINTCdu//i0eiIAoWYL60+50RcYo4KgBb11Gk7GBz/pVylmnA+Ghwx3jtuO7kEopKFkdrvXULJHn/C7MQCshGcWTsKLna5xCd4RnAhxn4n5XsSovF5WaGOgCfvFCFPmreSzrJCdQLpAImylxGMhXB8TUn5gMkFP9Mai2UUECthhiDrwEi1ArXmnH0pZycaP7rZiUWLEyd3RpyiQKxDbhsKTczanTS04eccG+c2uhJrod3AIAh5mC2XS1TqwHj5KZroANbX1dYyGInbV3FSZcrb22s65xEAGA9f8OfT6OvmXf0C5+yw1yuwL6yHbJz949sLqx3pT4sk+8a6AhR4GJMFGCkvTht1FONE0B5aWc3aTcDO4kXWtn6W6vod/hcpcz5fhzux0PRVesJLijg/f2QNuvolVVziQpI0w0oRk7HQmY8tM6zhcL3anU6yEopwwgQVcQ6ZxyIKeux3Dooef1S3OAvmsfV0WRvHID7I+3lM1W7FZLCMY2Vn/PVTlyZu/YeUFAmw+Ybo1Lv2pyGWlr/Z7ChXIcdYU6QVmVfJYbzZaFR7hcYZAaajHJcOPDTlcmMLRNKC/ry3yO+Zh2OGLUM+2NMMa28cNcNsfMjpiYCZq8teIV47/xISpIc8PwuUjZBH3OXcOuwWkoQLyBStwfH
 cvUhd+UM
 8iFtnGnJ7GJAZMmmOC49RBMq0iG5ZOJTFR6x4gqsPJ+jnGxlKtrlb5apJ0f1q+NZxHB++T2yCJkQzlfK52/V4fPleigpq2Sz9bBzN3d3KWD5j4G8TtE2ks44wzlbFejaMJI+PzxBZf1UJoYZoP0EWinQmqqEuyzo5tnHcPV+UAayTadvTJ6XJ2z6AB5ua1RKWbKFnA9sFit/Rn9BoEb+LMYAq2qX99Og1yfy8tqULvz4zwvMZxmcxHhP7X+Mn5S7wUufeNRgFRFA8EHeQaxUHDok9MxfnbmmjwA2ny1ZnnKuUPcrrrUCq1VMFIES0yYgdUgMmeNRzttxWvJjq726Nx/BcRR/U4+FnON2pLxPRX59Hi98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Currently MGLRU tries to keep the gen numbers of the two types in sync,
avoiding reducing the gen number of one type when the other type has
more gens, as described in the comment in try_to_inc_min_seq().

This makes scan_folios() stuck reclaiming the type with fewer gens: it
always scanned the oldest gen of the type, even when that gen was
empty, so reclaim made no progress on that type unless forced aging
created a new gen and eliminated the dead empty gen.

There are other approaches, like lifting the gen number
synchronization [1]. However, that would break the gen layout used by
lru_gen_folio_seq(): newly added folios would no longer have a
well-defined hotness according to their gen number, which reduces
accuracy. It is also not pressure-aware, since with gentle reclaim we
still want to respect the gen layout (hotness).

Instead, reclaim from whichever populated oldest gen is left, but only
when the default reclaim priority can't satisfy the reclaimer's
requirement. This is typical for swappiness limitations: e.g., low
swappiness asks the reclaimer to reclaim from file, but file gens are
drained, so the reclaim cycle fails and priority is raised.

At the default priority the scan quota is 1/4096 of the evictable
size, and the old behavior is kept there to respect the hotness
distribution. Once priority is raised, the quota is at least 1/2048,
so the hotness bias introduced by reclaiming from a younger gen is
bounded by that quota, which seems fair. Global reclaim for MGLRU may
start with DEF_PRIORITY / 2 (1/64); the ratio is still reasonable at
that point, and when global pressure is more critical, we should
reclaim harder.

Note that scan_folios() still refuses to reclaim a type left with only
MIN_NR_GENS gens, so a completely drained type still requires aging.
This change only avoids scanning empty gens when populated reclaimable
gens remain.

Link: https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.org/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27dfbd3ff02b..6006508250c5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3312,11 +3312,9 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int old_gen)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int new_gen;
 	bool gen_increased;
 
 	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
@@ -4679,7 +4677,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx)
+		       int min_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4697,14 +4695,14 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return false;
 
 	/* promoted */
-	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
+	if (gen != min_gen) {
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4719,7 +4717,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4762,17 +4760,27 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
+	unsigned long min_seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
+	/*
+	 * Respect the gen hotness distribution at low priority to avoid
+	 * aging and scan cost, but prefer to satisfy the reclaimers request
+	 * when under pressure to respect swappiness more and reduce IO cost.
+	 */
+	if (sc->priority == DEF_PRIORITY)
+		min_seq = lrugen->min_seq[type];
+	else
+		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
+
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
-	gen = lru_gen_from_seq(lrugen->min_seq[type]);
-
+	gen = lru_gen_from_seq(min_seq);
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
@@ -4790,7 +4798,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, sc, tier))
+			if (sort_folio(lruvec, folio, sc, gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.39.3 (Apple Git-146)


