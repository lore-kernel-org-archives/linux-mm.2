Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC38606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k8inY7Kc
Received: by kanga.kvack.org (Postfix)
	id E6A816B09DA; Thu, 22 Oct 2026 18:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AF66B09DB; Thu, 22 Oct 2026 18:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D320C6B09DC; Thu, 22 Oct 2026 18:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A89DF6B09DA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C80E11202F6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:30 +0000 (UTC)
X-FDA: 85351636860.28.DF5D6E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3142D40005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8inY7Kc;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjaHi74G05A3micuDJmoCwFLOLh7P45YvU+FurY2Pj0=;
	b=LVm6otoZygh+X6QI0Frx9QmJKzdUPG7x/+xt6/nlG4DePtyJpKkCMVUjtfEKnMH0S3V49q
	54U/5UyKydxeYPHEDBiUFBY+WKop2MNuMInwVNyCSvt7uhtxpkkM050GGbjvJAPjzP++Qp
	blvZ/pKNaeN+qNwqXgJipwg6VLkZRRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706549;
	b=WK3N9i9B/4LdFgtYi6epBGOkAxVO0xRPxyk9ROnNA+QG0nS2uiux5MJYzLu3M1g3x0yMmg
	iaH23iZCmL2lW/ULwhM6OTIvQD62zO7QH6TLPcnSiZBO2Q38q2h8GntQTTBLqtbfUCYbUQ
	tjIUF/4PCY3sLmXfnfSmAPUyCaujDa8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8inY7Kc;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF11C60A7A;
	Thu, 22 Oct 2026 22:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956C51F031E1;
	Thu, 22 Oct 2026 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706548;
	bh=JjaHi74G05A3micuDJmoCwFLOLh7P45YvU+FurY2Pj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8inY7KcNfDHOkqo0imhkQE+tEBqL+diazAO17P2RG2P27Hmt+VuhS+fcaFY5e5Aa
	 ynsTXJBiaiHXUlL6fPauUlOtjC5RvwDBeYPrQdUiioyXKohxu4MU058CoouTpmffFQ
	 WfyAyjHX064J5cETuXCP6mkewx8tdsb4MoKwsQt5naCnba4RSF/pNd3tRyGbMv9MQu
	 C8LZuU8KQJw7u7l5uP0POqVHgz7XGC8Cw7Me1TYY+pYW7cEBSmCjOCrM7asMy1b8ha
	 Vs+/1/zWRjUFpZe+1MJsAhPNUHhwwnyLdx4boCX36SJAcJ3NseWV1EcoJ/y8bfehqB
	 bP8B4jm1JbC7A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 03/14] mm/mglru: reclaim from the oldest populated gen
Date: Fri, 23 Oct 2026 06:01:52 +0800
Message-Id: <20261022220203.91911-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3142D40005
X-Stat-Signature: a6xp5x8he7q1rowesrbub15z9zyxybmp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792706549-849198
X-HE-Meta: U2FsdGVkX1+MyfTlqPn2ymfLDvctMBbVsagLrS2Eu0ZmQMravBzr0BwuoGq45S0ERsd32/jBIoV9RS6kRjSBImY/tNNpmgQalwSftaG6YZrTGg8KSFAsHtG296GN45cakcJTrXDdKkWOBHCHyBLVFB3fH7KRF85lAYCQiJ6hOzLkBi0lBW2mT0lp/qKkxNw9SML8mvky+WEwAp6rRoQ3Wgp0n0Z28lCXAU+cxh31gWh0Fm6bnQB3a64Vlamh8dHjBPq6GqiVctEjuHE/xicOrKB8W7uuy93bd6L5Vu/k2prAcwLmXJYFqQBoljWSEL7EgRXkdFLmnj7uZDXrqtlsyQmDWFO7KydmYmONf5bARUurzNLPG3Oc0qcNvcvYD0WvoAmyrisettr+WGEGs8MYr5G7Iei1YZNaPjDXKQyZzH876GEJIeT/qeoq7YQtja1LamDAKgFVSoYXobrDsDhyXz3lmIxiZhyxJ6E7FXKjgG+EeVnHHCx6Uxqqa+twdUqWmrsI7KqNMtsNBJunGcSi4aeoiwR873LpIsiSRINsR5gxqIuBzAdjQ0rC3IkeJV/Gq4nK7v8edJ3OA+gEfaIA9tHt1rWiHYaU3+HsR455PMyHpNBaxuPaIVQRhSwXfrobxJked+F+2JkrJUbdiu4R38X+5b0GsGfArcDlXhNH5ovF99wAC3kW00U/ss9TjQ7mo/G+TP0XCirvOX3p61mEboPOOnnaxlF/dd2vzm2fQHk99YdIhXb4nN0uL3daUyGXLIT8rkzIEYvIZEwrNWd6OHnXicbUF/2m2FhPqO3pZUBe2vQiLNWBm0e5eevzzRuK+9biQzFRrUouVgXE+2G5FPs2mu+gQP95OLzOGmrx1NIbku974XnZTlZKhfksrJX2YTzy9ybMp516xbfC9yUbRNDi7SNj4Er5lyWhd3+vMIrBdEns7wAxeXQI+yIPFmVGiFCa2yd2pLHGH2qCTVl
 Ru3e5lgX
 kz0FeJMjLDnpF7jpr1hcchv57AuAzWmGLJ4JmfM/e+YzuvH2j83b4bXUFW/Hy7rE2bx0tVF8+WZ35+DQUaDv/8KfhlYudEH+u21Ib/MNXWwbPTBOCk6if+QoxIqrW12XpXS4LceuqU+EGkiluvqsARvwbAK2NbySekopbUFf36+I9FWjsroI348GtLUVNYMW7ynXuRwaiukZ90vKDxlsDzVFKhoUazcdhoJvRtSqb8MxqUftUqiBMrHGK2CVkiB3vBACOsl6UAdvdx89TgXaNYj1uMR8KPBQ4YnCCiQP7TiIbFSkHvq6T/ZAgTlbYDumgSd7zJnrrl42OC1k=
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
Signed-off-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 500ef23949fd..d7eb15533de1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3451,11 +3451,9 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
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
@@ -4836,7 +4834,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx)
+		       int min_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4854,14 +4852,14 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4876,7 +4874,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4919,17 +4917,27 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4947,7 +4955,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, sc, tier))
+			if (sort_folio(lruvec, folio, sc, gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.34.1


