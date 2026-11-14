Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09C3606A334
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCtqX8y5
Received: by kanga.kvack.org (Postfix)
	id E78FC6B05DB; Sat, 14 Nov 2026 15:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03EF6B05DC; Sat, 14 Nov 2026 15:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCABF6B05DD; Sat, 14 Nov 2026 15:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 921676B05DB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0712C12045C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:36 +0000 (UTC)
X-FDA: 85434812232.12.E395657
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E4EDC0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCtqX8y5;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpMLEsj5uFCoVB+BC2qF5SnzrdWcHRIuEONv7+JryW0=;
	b=R/L+u7D3ejPza4jNeom7vIMl2+CQW2sQ9ySFeC5WC2bwKZ65LGyyc146krE4zBPYV8cb97
	i3WhQsahCjKDUP0zYcb52i1F3vtlPI4m4NxuOVj/cXTREZ4WtZ9bKdc6q5mHcdLIFPNIhS
	Trqn8y0DmFh6iLhW4TGQ5rVUUEy978I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686914;
	b=oWwPvrDj0Itcc5EL4FT1fo+FTS506jTCDMcxlcqUlhQxQF8S/Wbs2OnpmVU3ycMT6jJNrg
	cA+Lvte9Hr7yVnO0R+tjWPS2mSXpwHgL7UjWsHNw4cGMug1HXIcgZ+5LmsfrE3iOGmLUjs
	wou9SWyGIL0BCN5vcI9GHrV8gJhXwuQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCtqX8y5;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F17BE60DDF;
	Sat, 14 Nov 2026 20:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85161F000C4;
	Sat, 14 Nov 2026 20:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686913;
	bh=wpMLEsj5uFCoVB+BC2qF5SnzrdWcHRIuEONv7+JryW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCtqX8y5B44sZ6C9lsM9Zu6SFjAstNGCMH9e0WX4luzWLYo5UWAZZAqhdI8WQNgxD
	 5Ka5txDe8FlB+zIG9KfZD6nOXg9m0Tb/Fx1jvkH2QqzBLrhnO1dK4gKUMXB9VhzHDt
	 BXPReux9t+KhpVkikOKpOpfZVdEr8Y7Bo2H3S6IevpeNo1hucetdc5xeY8ZDsVqMfv
	 J02am1X1WIxO50pPPinD67VNmVj5niabK2dvL3RWeCg0jMH33CafQpjjSdZPtMJqFz
	 f85v+30UEVcClGEhSQf8v5COyzUkYB/RLcTPFLkNm+WwpRR8eMLyRNPR/boojAk1nK
	 cp6vwID0Pwzug==
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
Subject: [PATCH v9 04/16] mm/mglru: lift the forced protection of reclaimer
Date: Sun, 15 Nov 2026 04:07:51 +0800
Message-Id: <20261114200803.23129-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ewwjpq914a1463no9iqrtj85yitffgh
X-Rspamd-Queue-Id: 5E4EDC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686914-161802
X-HE-Meta: U2FsdGVkX19XzAWY6tl1lOLhqIDIfPn+Qbjon39j9za5JdHVUPtaiSP5vGtUIVsWvIJ2YeeNQYoDKdmdQ0nQgK8fmboc1gm5/yoERYxOAlEEFOlzX30EVZJtY5omc2ukBi5rXb90cEw3GPhdodRPR1ozjcu+JeI3I8SH4S0hG8fTjsiwfhJhW/046zaKbfppbbkfvOymLsI+8FYXIRL78Z4wrPLwtFTVRWuuefs9uO/Er4grTFKMgCiI2h5jexmvuGVTjfcAibfcnnHkaChaAEzEnN9ZNrQKTvuAq5YGiVFFjaxEBug+Ozu8tKsf6ztEAX/4pQKceCaJNw2CDf79a+1i7fGRYljji0KeuaaqO0D81BMtATcoqZ8EAknuN0ZVuK7xKqnIn4L8DFDdI3yfekA/hJSBdHXvosD4R7wvld0bp8P/bYeby9ZBtJEcpPGW+nSMRgWxp4rrjE+PqKHD3/P/3MnMgwF0fUoF8p4HcPkSS53v33j5mbKd2UhXj1EHSpXllx9HszR8ydJqcRnHDMuWxLzgiKr0z9UV0jm7p/gRYoICS0H6uaHWxUlpeFpLHlSEJXqXUzCq70DbK4GPePbxs5Q8GU+CyAe9NU/M4n3Kr2ac4TGQUMip82la67IwfantA9VXazUaelmrua5iA8LQe3+qK2z5SQytE6kLPjjiMIIt4EPgUp/U0L1UrMWGZ1t79EoUzsXoXcnpjtRfyoXHwpqX7WRXz6YBTKGylWfCq8XUNLbc3o2VU0nsOWWMaWP1MfjFOTRTlMCZ82fZHo9Gk/kSK56bzooZLlsMi1DYQ7pk1P3DwCWRdDyuFqsvjOL5XGLkac7TcshdMcXQQqwp15psj6eCeMDtdG0KWZMi1e5uoIXPIUC6WdXzpUE0Q0SSuS/SvkwYvlz5ol2g+7TS5TW87k/TbvjdirA7Qz3oOSlnz/VLIdG/ndmSyihmBCA8lkmLds35iViK4vc
 B+UnU1Xo
 x//x72TrYgFLuYzhWbP4SypYJXeYJ/8haaXsiKxLwPeEMKiWDJheDPCoAyuXdDfkKa+QSHnr8dJIghyd7oXT+Ozlu87q82Kt+S1L0BV3CIzs1gMBmwSeyfBnGYGxWbyD3TsDKVo0y8qqw1+pzaXybElFuSXR5+/nW8rCORlO1k0wNtr+Eh+fKmFzOaKegqbNldDR3g7lgxjWpMCB11uGatWzAvZq0013UP5XoKmw9Fb/GSi9YBq46Mz94jazRUVWeZUBb4Mq+aCmShxhzZ+q7wAAN2nO3/cu6o5x9NRp/49ahfZENEv8NIBhgDqSnOdrlPzJxabXa1eE2LVouloiGzvCMhtuJq84eIJlDVk6OKX8ajwSKLCopjAyvugGfRAqFNEKD
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
Unmapped cache folios may thrash more under heavy memory pressure.
This should instead be addressed through refault-distance and
frequency-aware promotion [3].

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
index 1197e15065fe..603fb7c73f94 100644
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


