Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B22D606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOagy4FC
Received: by kanga.kvack.org (Postfix)
	id 350516B05B8; Tue, 10 Nov 2026 15:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327816B05B9; Tue, 10 Nov 2026 15:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217166B05BA; Tue, 10 Nov 2026 15:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F02B46B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:20:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 904DCA8168
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:58 +0000 (UTC)
X-FDA: 85420328196.21.5BA01FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEE8C40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOagy4FC;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuTthrTZtfu6mc4h+uORvcmjei37v2/cFoPsDNmHnVU=;
	b=yX+qN3NulTteLYeIoYB2HlqXg9N8+SQWIV32WxiWxTAZzye7QF9SZs9Glk57M3VtsAMmOJ
	FEONnMGBQxC8eDTAlsgAe/krUPzaG9rVc44Bh7IjI/uZ6lgqOZBbz0qIIQ4eEWrxKn09CX
	uhDW63bAqeN9HOoL61Ets00opNV0NUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342057;
	b=Uo6tFW9TbXC48a4SMavw614ssd1z/jbeiArcfuFapxQ2zZJWwVxe6UE60Fq+/IOjDo0pV4
	2g12Wy4gX/ffsjHKfZrPeMwykquzYnGxtkJ+VFXmwGBhSBrFnwfAMV7Iv0oUqSaPEbxBGO
	5sQC5aqxjoCP7omwDrOUrZPD3vKfN8w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOagy4FC;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C19B447FB;
	Tue, 10 Nov 2026 20:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670C71F008A1;
	Tue, 10 Nov 2026 20:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342056;
	bh=DuTthrTZtfu6mc4h+uORvcmjei37v2/cFoPsDNmHnVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOagy4FC8ahWxXOGTkQf/7Gp+OrrGe1HhaN/s9q2VxATymnNgTUzRXeEBNtzcfRkY
	 h4knSA36o8dqCZTpSfU2F2qBxLzApdWl1+wKKw5bDq8hovuONUAAFLEgT65g16T5Um
	 vr7Fr9NNmLYR46s2Ivt4mEgQJC+ND7u4FGXtzSyHNXP95HD1OWrxV74qCtVapMCyPa
	 VaYKegSztFSfdw170sQ3UYU0QDBEbcWkSevVnj9RLA+EnYKhKVqLkWmC+mO0N3NxH+
	 OAVsNWDQjpZ7k5HMKWFdksUKR6wATzsdzrohstLzcqGG9C0df9MsAS3YyvMnPY780p
	 gKrZ3iURCIGrg==
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
Subject: [PATCH v6 04/15] mm/mglru: lift the forced protection of reclaimer
Date: Wed, 11 Nov 2026 04:20:14 +0800
Message-Id: <20261110202025.25736-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9jxfe5cpcd54xxnuuuynfmpsux55aubk
X-Rspamd-Queue-Id: EEE8C40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342056-253515
X-HE-Meta: U2FsdGVkX18XlScQNKjGL2IQHfDQ9zBUJsav5b58n8zwGgUElYqSl2ag2zAzozdKBnmOFfj2STgWoqjxKC41hEY3MGWQ7hdNAsOolpV85WGhlRtgNWhmCrJWeBE9hdF8p+GF58jblEfe1HTINAjOBYriZQOXjY2DiYPqhk8rMMo8Yhv+C0zYXg/kiFDvsKw86V4ujMn/a3mwMRidVVyy3EiURXBpSpgj4/aiU66q0c8oIr0ofoTs/1UvsrbgKoJpJk+UihXed0oDV96JLO022gowa339gqkTrEZmURmV/CqaOH3neETfsBUIAzYXKUl3i1Sf+HwndefeaFBRh7Jg2Xldgbkr+b7ym0Vm+UCN5kDIdKODAoifQk/eKHID2a2zFJuy2O/Rtce+dBktdaI3AWgWFAySE4WSwwTrpaQEmgs1GJzvvJ46NHPWWgKFDBSlERBe7wY7g2UIjrVcvpSGzFS4bWwM9WNFEGGM/q8fdsxjvrKHNqjRcyQ+nWcAr6QMNPzceZJHz0jwrV5eOYiC7piugwfskyeiRbdz02GL9RwtPguRJkKKW+vKgcgNPrMVwiH1h3D9wJNCl7IzD3JYXJB63O74rkjIXrqHNWIqcYLxP5RODoqY3crOwDR7Et8zO4cBn+NaBtt53ALY2UyUexbH5PLwpYhmZegX52OWLSrSfJXHxGDX1nMgc6Bx9JEEETJWI7WRoTIvyPxXejrwrhiW8kWH+ac/tZoq1qPw39PsSMDRPYi+R7L8o5UseQTeey1WqjtBZzSgkJbjZdvSSdLRQqf4174sZPwZ7UrzWQR4OOCNJ5oN4mQbkUDPd6aIo0zuOfglVH7UxgUnbSABvpc83XQ1LOul2dinxouAQyDs2pCnUCQ2yfW3b4jCoDieOJ/UZECnpOeYyVWRQxNRh4QR86dJKSsmbJX45yT0flJKbhAnOedcxExiDz47KKSB8NvyjzSA+Pc3EjMkaFa
 1bbBeymj
 L6calFzct4qosHxKpPUiua7Q4SmYLdMYTRBzKateVJKkEsQOa693xmWr+bju0Oo51OEIqiam8t3M7x4wGXEmaD3w5HJqxKnobIVXGypP8fdsySKyXJJLWcNiYbcxze58vMHAlpI0E1haGd0vZDNAb95vFYYq/2uvP+nmGpDVfg1oHstHXCzo80OQ7OrST2VVz4J93u1PEJmb+Q1ahoNmjaoka/j2KQHwlCPNBv7Azd2VxRgImZ6cei71voJgkvD9TAgYt+tW3B7JKG1xvf19yDTX8DsVO6ny9jTE4ORpfOBNEdYa5quyLZ2Pc15DJZ+YV2xc2UtWjww+Z608TL6Stj3X2PU7kjZgj+8rDpmFaLDRQtHnViMo3bHBJAAJnku7FGKgB
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
index 593f407c0668..db0a8a3e8887 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4672,7 +4672,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int min_gen, int tier_idx)
+		       int min_gen, int max_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4689,12 +4689,22 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4749,15 +4759,16 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4770,18 +4781,24 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4792,8 +4809,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			scanned += delta;
-
-			if (sort_folio(lruvec, folio, sc, gen, tier))
+			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.34.1


