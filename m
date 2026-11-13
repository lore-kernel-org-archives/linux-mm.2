Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1586071040
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=are3EysM
Received: by kanga.kvack.org (Postfix)
	id 7EF656B05BE; Fri, 13 Nov 2026 13:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6576B05BF; Fri, 13 Nov 2026 13:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC856B05C3; Fri, 13 Nov 2026 13:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECDA6B05BE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8011D1601C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:11 +0000 (UTC)
X-FDA: 85431000942.15.97B0EA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DD5A040008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=are3EysM;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ab6jQE+uJD46Ll5FCTsmdW/Hp44XQBfAYxsnpCJz+D4=;
	b=AV5mX7ieeuB5I9XOtCrCEbXD1yUJxn6yMC43Opz7FqOXL6aiTiczPU9JhJYGbwwxQ6fQ0C
	9aL8OIaBO9F9ER+nim7zHFlFnil4sS05nCZUf257k0sAXTokBTRJiilFtUlI1Rv28INFMu
	nksyj+OPlqEhga0zF0sjMOoywVEM8lQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596170;
	b=RkEq6z7socYQw9F0DvKH0RUUEicqoF+HddPtk3272ygfLG21rZtHrQ0IR+OQM4FpAipBJb
	kL5zmqyWQH0/LWXlCV6FDUfzBLfwh4FG7IGBBsa7U/7R802tL9BDlplv8wqRgvbUXIoD7g
	TldIxUmRAXtZ70ffgMygJaysEO46y0E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=are3EysM;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EAAD41B61;
	Fri, 13 Nov 2026 18:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C47F1F000C6;
	Fri, 13 Nov 2026 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596169;
	bh=ab6jQE+uJD46Ll5FCTsmdW/Hp44XQBfAYxsnpCJz+D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=are3EysM1jA1csE0F2A4zqg4HWywNrj29LCGP/RVLXJtm8cr4O2xBP6WHjffQBzrT
	 LPZFO9rKE7/kJTAHQtCfvPSxT+ioFVXdt8U5SaBx1Jp76hZWHSZlka5llH7LcFpnSS
	 QIEeyqItCGRqteyEPa5MWsSakzBvkXTATk+yU9c7j75xwkZjNgQ+MSIOOPGNYNqgNl
	 sdHW+anINi+EiqoIzTKJnRuIBQbKZbS1xhF6KGS35IpTiv9K9L6NVGwbpfMXi4sH6r
	 3qATtXCewl3sNMf2ZI6ra+O3JlPziRH8Tbk/TI7Fe+7a+LHertNw7jEV0YLNv+ohQQ
	 qrh/MrXqdZubw==
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
Subject: [PATCH v8 04/16] mm/mglru: lift the forced protection of reclaimer
Date: Sat, 14 Nov 2026 02:55:29 +0800
Message-Id: <20261113185541.70203-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3jyfti8n37ybjpewh51dxttco73m6a7h
X-Rspamd-Queue-Id: DD5A040008
X-Rspam-User: 
X-HE-Tag: 1794596169-344185
X-HE-Meta: U2FsdGVkX190qAjPjILpWb6CzNe26XS/QOqHFIFDPZyTefv5FYnnQeL5M5a23j2DYQbWn8R7BrTVOBKyUkVI5zXH5VsyJYFX9HNfPYzlrb5qs3DllcDU1MUIfNIjSNFQLNQVKdLN1np/s24as571BXJVw7W2A7laA3KOIR+oB+acyM468qM3YUVWMYMHaV2mC7zMeAZfOBJDzMbKrTo4Ezdt82jMeuABV6hXaU+Rhk7dySrVBxNuxYnNlxjeDjv8em1WYDhIdMBBIgI26nSLaYXBaVFwj6ienjyJ1+98hrmeRnQKMnS/iI0OJJtGh7Rw8X0WsfMjmixHAb6sNe43B8cW6sycky2dEdGjcduzwpiVXPAKsa6mK5D3i12DrYAQX2rAeY1l2/sH1z3Np0P+2Wsamjt92B5zqa+yjUXcorQpPG1DH9FMefvLHwat7tehWm4I/zrtGC2x/PLKdFuFB+XyWZl9Xqex4NM/41dN/LKX8B2opcw7lh1vQCsc28cmVJWxLKMu2KIQ/J3Mbz/XnvSwahTAZzL5n9yysVjnosPAHj2C6n1qFoJ9qDBQPOluCt30cmzJBvAUIAXVS9+Q5BdR37KzNZKgEOyA+QpX0ihJSYr7ZAzKq9W+hhnFvgLCp0f+Ozg0rAyvSVQsf23d2PNoj4vPU8nEXsv4Vi0t8vrRL4ASM51OjVcN5R6Zh+p8TRPqMvynicbyyNDn6tKhGA+uiOYT4uOLQ1MauKqyKO+vne84UNuUw1vcFCOP5fNBKu+oOZDFrOdhrWJFCetumeNaLVc2T+ixSQzcQ62BxqZrO2JYrWqcnEHEOjDaimKCD0k1Hu2iVnNf+XUl+m4Khw6jR2vzMIGjJB9kTd1U8clC0lhMoeETljHAtI2SA+1zw78l/S/iBcKihBWclOktE92wAOsa6hn1rGUA8IQMBKJ/pgi2oMCMz+J76NMmJVv/oDbtErJJUeCkQ/QURmk
 oO7+GLsI
 e5Cby6CWID4IBVI57qGDhfEehKQxxtFNGTzlDxabxgS1wf/HF9HQ+3SOXQlGDBGJXkcEb7ysE7GES4su+v13jPAZ2VyDfZZEXG1230zFFqHyZw536F7+RPFiGNYtPAQk0UO28AlLqO2n00IQG/aIBHYSixaJ39exm+YzO2PwnOnmfeVN0cGdUgmH28XcqH3anrd1xNzE9nY6pPRzzubGPUoNPH7B73abJ94yESh9cumjCHWEpktPuQfMUK+boWxow0IEoKTgx9qgbTzZZzq7LpoYW4P2SNO3M3sZGFt0sGnbFtg4U9wtAYIvo8KpnQYddGIwkB+J7jmuNwS2kW+WVKgGcS0KEZWGLUwRwB9eelqn9lmfIAW0jOAu93QaQur4quSLt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

When a type is drained down to MIN_NR_GENS gens, the reclaimer will
fail to make any progress on that type without aging.

However aging comes with a cost, and it will take time to finish. Even
if we do aging more proactively, when under great pressure, gens will
still be drained very fast so the new gens produced by aging can't catch
up with the consumption. With MIN_NR_GENS setting blocking the reclaim,
we will run into OOM. This OOM can be reproduced by the previous test
program [1] used for fixing another aging problem [2]. When running in
great pressure, certain workloads will keep seeing premature OOM with
MGLRU, and never see any OOM with classical LRU.

This might get worse if we implement async aging, or avoid hotness
inversion in aging, as they will slow down the aging process even more.

To fix this, let's first drop the get_nr_gens() == MIN_NR_GENS early
return and let the raised-priority scan bound cover max_seq itself.

Mapped folios will still survive as the rmap PTE check will keep them.
Unmapped cache folios may thrashing more when under great pressure,
which is really a problem that should be fixed with refault distance
and frequecy aware promotoin instead [3].

Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [1]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/ [3]
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6006508250c5..0e8b3161f8f5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4677,7 +4677,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int min_gen, int tier_idx)
+		       int min_gen, int max_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4694,12 +4694,22 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	if (!folio_evictable(folio))
 		return false;
 
-	/* promoted */
+	/* promoted, or moved due to reparenting. */
 	if (gen != min_gen) {
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
 
+	/*
+	 * We are reclaiming the last gen left. Folios in this gen can no
+	 * longer be promoted or protected, so just isolate them. The one
+	 * exception is lru_gen_reparent_memcg(), which is handled above.
+	 */
+	if (min_gen == max_gen) {
+		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
+		return false;
+	}
+
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
 		gen = folio_inc_gen(lruvec, folio, min_gen);
@@ -4754,15 +4764,16 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct list_head *list, int *isolatedp)
 {
 	int i;
-	int gen;
 	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
+	int gen, max_gen;
 	unsigned long min_seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
@@ -4775,18 +4786,24 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (sc->priority == DEF_PRIORITY)
 		min_seq = lrugen->min_seq[type];
 	else
-		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
-
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
-		return 0;
+		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
 
 	gen = lru_gen_from_seq(min_seq);
+	max_gen = lru_gen_from_seq(max_seq);
+
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
 		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
+		/*
+		 * If there is only one gen left, rotating the unreclaimable
+		 * zone become meaningless, just skip them.
+		 */
+		if (gen == max_gen && zone > sc->reclaim_idx)
+			continue;
+
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
 			int delta = folio_nr_pages(folio);
@@ -4797,8 +4814,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			scanned += delta;
-
-			if (sort_folio(lruvec, folio, sc, gen, tier))
+			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.39.3 (Apple Git-146)


