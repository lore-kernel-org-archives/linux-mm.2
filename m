Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0708FC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5D46B0093; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0256B0099; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBE86B0095; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4884D6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB74C140788
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:25 +0000 (UTC)
X-FDA: 85060992450.26.6538E3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D26E4180003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsHo+j7j;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786443;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5+QSULbm2OFfNdQi313gUbasryj3a1Dc8hsAxeQzBs=;
	b=0MVJOMOmBnGnXT4Rxpxs2ORw5qRW7AXFj6uIFYSNpzm7TiIAq0pmAiDhfT/Va6FHH/GxIU
	nGoZ1HDzUqJKp7pRT0yJmx66dcP16NVO1I024JUfK8z2utOEhxkgDdAlvJM2DEc4a3rpnf
	P0x8yrBtwLfxrK9Q3RyRy1rzOXGeWbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786443;
	b=wCzb3tMc1Qff/ZzDF095hqdn5m2UXL/jABhbnRCC2W8hVqOTOviw5+VHv7/mokO/ABZ5Zn
	u5F/OQIb00I70xhe2ZJjogEOnIlNKu66hHntSrsTI1zZK8prWd1wCQnRGx/fyYfu7nr75d
	6yQ3HDvqtINoXla0OIm/6tSkNwOAc+I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsHo+j7j;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D4060AB2;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AC70C4AF11;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=SDJd3vW3qkKBS3CdNbHJyIAmbUP3QRPpQi1oINDrVZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nsHo+j7jd2vx98UxP4tyzOOtNN+FVFsQsoXSJloYLREMymCHSA4L03zFuvjoTcnDQ
	 33yc8gdxMpla5D1wIL9JJj1tGx4BE8+q0pkzWpZRerE7yBVMaIQg7NXXTleRtDb43a
	 nmTDNhEHccHHoHnGkTj87GK9aj3Ck1oy0rshvCCcY6lXgLYwVXgtq7624h7kni5KQC
	 YmLNgVlrQfdJG4M3Rjr9i+MCZ/C0KgR97AuK+6qNwkzY0oCYHYLEe5RXzUr5mXSQxi
	 sqhTSikM1KJDctKIRJDentqEpzDlGei0oKesll+47UrpMKKFqGs/PU2oL+uSOtt5ms
	 IJn0+ERzT+lYg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A88C55AB9;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:00 +0800
Subject: [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-4-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=5062;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=t4exwehi8Ei4/lRorOvsWBcZjkV0WY4vPQIntyWBAJ0=;
 b=XbPr3kZEY7eYz5dQbFhpzZo36GfAY5LKWawkIw/5lYUPRWbkiMxoYdg7f0L3E4rW2cRtlhkF2
 sNRk59Xa+OyCI1aHCtTsfGqGIryV/wtrtu+tPl7iFjY4mYLkqpEcW95
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D26E4180003
X-Stat-Signature: yke61i7abjcqydbsc9oxn5x83gwr8r3e
X-HE-Tag: 1785786443-736341
X-HE-Meta: U2FsdGVkX18H9kSVcWZaXmV7l5UdVzOn9Rzdk59FB1QHlxdGkUd6XlPSZ1I3bLDx8FyovAWajhOFsUXqTj6B1MaDOcBetg5YQPsnXq8vbpZOuy+w3FotXl15Z+RaT0Y50iodTACeUZpXCH47FcDzbNa95Zo9LRVkdFTWgn/zDjfr8+g6KRAK+9aW3dAc2Qbt7UNxtZLB/lM2W9O+suXHOyG0hbkJxIL/zRDTW2KSDUBtnxaa4ZcnoXLwpqq3pn05D49x8Wrw1z4t1BK21AdA7T50OX04YF1X715y5wijiISb0g1OL8rVR2gGXJt9O68phYz7zKBCyohQaGTgsRtPB5HoFRk/FDMgW1Hn6stiywUT5e76gGzcdDMXU5bugsiLgdyXs9lV6kyQchXyyd1CS9AviV3FUEFZSE4fbwtmn4s8dAVUEzidU0vqxWUTBGpble4SKY/4kUtpWLh3lAQ6Bqb1do0t1IKNGgnNKULXhO2XUZ+TFrY70aguSnMDnNz2kno+6GgRFjWw9sCBl0SB4342CuyD1tzmmJQbyF1B4/vb9C2usn7uV+bqnEfo6Pmys+OtRsh6cmIYM+ZVRhP2siijmrK4AhoZTxpl4vrp3RsPZMkY/BX8xCs8EMm6OZ79zidSCRgt4pIxkzIoHdw7QQYy64DIM+kyZJo/pNizorfw3h+x+MohBEjcDLyPR1Vymr5Ptkv+G9e7r6CX7f8nSYfgi9ewY8LsxyM60zMvy93iMshrez0DlSpCeWoNOdXtryN9jRrLNZtlQIC7GOkH+AdMn+Xgz2cFsyC5uc1Ys7Lu1BxC1YppDtbUyqnAV1LC/exodLo+9HBjbD2KG1/McgYKPZCGauqQMRbS/R6PIm8fEWvrRecirWzIrdV3T4h4w+Gz8umsCpWKB014/uH4Sf23tX4VPKtZuSiNZeXnPyQpJsWVk1w07YnsSq/1BApfjuo+7TGr1QrkQRXAMHc
 MgZXN0T3
 /tM/FKVaPylQPEjOzdIZCIDi0aSjf35AuY1eE32m0+ScsIDmeIGyy08oYjE85Oq6jErQxKLFiNviG+9QJoCQh/rpOkvp/rXbWXcIlvJ5wyEo7HutK1wQTXn5bKGuhNLX7mOAN8c31oIAuzLElS9aygDx1/Ebp28hbE73EcRj3hH52JIYnwaXVRppmKTF8X4JyET9Rh+pSnlqGcgBUl/ucQwNqPaKZ9/4t7DR3RA0ZiPd+OvBC66qO4YdxJmYXbRLdHZfXGswIhcPCJJTOMX729BPD7Ih7xHi0IhVrn3z1GUS8hb8bzneXsYHFUEjozkvGecg3UgKSTRGsZWXWp1gJwHEiUbYUV67lR5q1wuRhu/i5M0s+m1PI9rURgnATXh6Cd8KPal7J14DwiRfUVlAmqNO49Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, convert them to atomic so we can update them without
holding the LRU lock. There is no risk of overflow. The reader always
compares and uses zero instead if the counter values are negative. It
follows final consistency.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h |  6 ++----
 include/linux/mmzone.h    |  2 +-
 mm/vmscan.c               | 20 ++++++++++----------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 4076e3f7dcc8..018a2f54a5c9 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -245,11 +245,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
 
 	if (old_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
 	if (new_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
-			   lrugen->nr_pages[new_gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
 	/* addition */
 	if (old_gen < 0) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8048c6b0544d..4225dab760ba 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -572,7 +572,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f5b0a7c63a3a..b02d2ec8ff4b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3354,8 +3354,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -4044,8 +4043,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4163,7 +4162,8 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					     0L);
 		}
 	}
 
@@ -4598,7 +4598,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4606,9 +4606,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
@@ -5650,7 +5649,8 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					    0L);
 
 			seq_printf(m, " %10lu%c", size, mark);
 		}

-- 
2.55.0



