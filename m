Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D572AFEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF5E6B0088; Tue,  7 Apr 2026 08:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7D26B008A; Tue,  7 Apr 2026 08:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F52E6B009E; Tue,  7 Apr 2026 08:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9D26B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:16:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA82E1407A0
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:16:07 +0000 (UTC)
X-FDA: 84631656774.10.8DF6A2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A553940013
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:16:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APiuz0Wh;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775564165; a=rsa-sha256;
	cv=none;
	b=EpQAbuVVgBlmap9Zc1sr4rJkqpsCW1SBu7HzvYkVOGHgxLM41kx6mpMo9qUbBuBfmSSRFU
	ziNdvrs36XUYwuNhJ2lcE5aVT5XwUptGwVFNiQtYTZZ0gs0FItnnV56R35uCXhTzNFkTcr
	wjrLVmISYnA9IWkNJlnZw2FT9ejh4uk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775564165;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJDV+p+u1Gf8ukD1Wr62sgCjDA970X0eY1nRBodJDTI=;
	b=KEMjw8VYNt1/fw5LZwrcowqdhBYvItOIDSDCMB2YfI/3PMKz4JEH+3Z0e+IH9SClMdl3mO
	svmgHBuBbn8XxfWIWXP8v9tsxioJF2FNTr/8fkyPRXoINtVWRWQfvmS0RZiY4SyiSOOr9V
	1+UZNE0BcOk5rOrFFyKSNSHD1QTyzBI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APiuz0Wh;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8106644585;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60EB7C2BCB5;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=VeX2URpxMMmGWllvQVRgejcYCV7xVkIbhcuL9oWF31M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=APiuz0WhkwozV/Mf+a8ttzoZUscDS/xdAoU01q2HuHT6BUL2f00ZBWwxkuj39aRZs
	 DGLN4N9HVkE8mKSHcjPJ/PfVB74ZpVf272ZPjcXng89YGkkvrDXuOcmnJoiV4ZO4kQ
	 4LI0I0l1L8ik8SqinBwUIpTXayfVAvDoy5F50NHzradcqOS1Xc1mCYmToAf5t0VDw6
	 CHUf4RSlHZc5ZWr/kEZuxroGxNItXLa3/2uiYECcIxX+JmsUATUdmanJZBlZPXtQFe
	 A3EGCqJSE+8fEGwMO3DkbtvkZLvYuN5NmrfCOJBvqkWLkZPkaCI1/vg55CeBoym1TA
	 AqEiWpVprSWwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58080FEEF2F;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:34 +0800
Subject: [PATCH v4 05/14] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-5-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=7136;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UDYibubK9+mNaaKcoZWIyk0t6953xzxxj2pTQxfJro0=;
 b=YXO8JjkjkrfocrFlEvhEFxqIX20w/vp8dngiroR6Ax/4g69p7qgqjoMV66o64VM0HNeAbOfWP
 axontquOEfbA/RPuCELfYqFuqrb4vbyLFZMYtlf6kY8ndpbLOqUln5A
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A553940013
X-Stat-Signature: kgbkyyb8pfxo35q8pjuzk38i83ynqq49
X-HE-Tag: 1775564165-424837
X-HE-Meta: U2FsdGVkX18FdGzoqPCdL0SPCSxm0gYoUO7uDyyOJe5thKYNop5ZJliEGsNROlq0AuviTDuECEOgNp7tRpUqQXufLznJX9Q5iyqytiWmaUfSC4Du1aFRUGl3gcmXoMvrFp7zWRbs0BLg0/1BPXq2rFTJ9QdmDdVjeZqSj1uQOFl3nt//dbqzDFa38p85XfrscTdiuKLyfFpRmfZb3Pf2LG/haEUYOwydsLqZiL59/gZv7Ww/9itVInTXBpsPPDouBissPVAkQWjX7XlIj9CVqe8wZRpEMeFCD1ZJCDpRiaC5EAPBqaDJCQQqtspXXQKzx0WC2Lfa45Uv/WoaI6ENBZMnNaL8BV3M6t60ZWoFXcNqdy9RPmZQWVCWap9g0lbFJ1gijP9M1g7QnphNvrn7r/KmQCa6kuXO6Vq5EyLOyabMQONb69fzXGziKPar7KYM4pHwycd3ecY3jbwYBGZGPceEOStxftefQswU2PmVYiDGKsmzTMEv1pLEWkRNC2uGDC7jO5ELDiPcyzIG7xnft5HNcS69KuXwQCdJa9iJDZzIcLYc+2bNqTqHK3oPvKcNOWI9gdV5jie8Svb4c2Gt8znT2ed540kgfpyjwmyHfBugi4peT3vZjqglk4yTCFUzxGVP/kROc4GX17HRWT9XKhIQ25+71ZkofxknoWHMmcdcy9HUQfONbPRdYy/1HoT5zII3OAJlcedYLWYcoQXnQjkyDgDLb14aMc/QLNeoYNVND2o+H93M+Jj91QaLYes+llxwUYtC+L0qi/T3/bxpMEf0ypYCc1pTONWOBg8oN5JEqSjiExW9dalxw0gQvtlabYMaz3zM5LbW6IdSr4e16Pt+Q+GLK+3p85opKXITPXDXf7YKB660rbiXs75+qECPAj8OPLyXvtmNmRMof8E/KmO/pWNmBr9KvbxGsFd3ns4jBYmn1t3g0Vu4okll6rBimbEMFRPXFUr/ERVsKxR
 XeOkeY/a
 M2IEK0jDfm2BxI+0yDnnGqEjz7+ikbJk+UxgpWvoshYqnFeQuCBvfbjPDYacL/dSQvSjrSq75B6HUzZCgKOghNasw4kNValugts310WRswNfyIK0zJTfOO2qnolg2avgRpJC0pu9uPg2pZ9F68zP3ulKkbLRyafwrH+21yonP2lTZF5i0ic94mGQ3XWx6agMebDT38y3qwnwp+4ZEmbpAecHPDTU1eUAeXbeNt1B9Rzgu2+9w59CGA7ivDitdsqnmhHAtHAd84cnck78GmiJjRWLlf00KHGiD2DTadIQOx9rqr9s5dUY+FVbqOLr+kLBa7nDhNZu774t/dCPwenC+sBiWuyoUyDDDUtNm3y7oVb8aBb0GKJ/qzf4qm2QMYPMMHPxkjYxDJUSPwfsmpzRxGW7VcKkX52FWStKCKeNt5EKVyexNU+SAMmUO3IkcOf+m4UxUD8h01SbOExsi5YgxnRz/qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Make the scan helpers return the exact number of folios being scanned
or isolated. Since the reclaim loop now has a natural scan budget that
controls the scan progress, returning the scan number and consume the
budget should make the scan more accurate and easier to follow.

The number of scanned folios for each iteration is always positive and
larger than 0, unless the reclaim must stop for a forced aging, so
there is no more need for any special handling when there is no
progress made:

- `return isolated || !remaining ? scanned : 0` in scan_folios: both
  the function and the call now just return the exact scan count,
  combined with the scan budget introduced in the previous commit to
  avoid livelock or under scan.

- `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
  scan count was kind of confusing and no longer needed to, as scan
  number should never be zero as long as there are still evictable
  gens. We may encounter a empty old gen that return 0 scan count,
  to avoid that, do a try_to_inc_min_seq before isolation which
  have slight to none overhead in most cases.

- `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
  the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
  naturally returns 0 when only two gens remain and breaks the loop.

Also change try_to_inc_min_seq to return void, as its return value is
no longer used by any caller. Move the call before isolate_folios so
that any empty gens created by external folio freeing are flushed, and
add another call after isolate_folios to also flush empty gens that
isolation itself may create.

The scan still stops if there are only two gens left as the scan number
will be zero, this behavior is same as before. This force gen protection
may get removed or softened later to improve the reclaim a bit more.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 60 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 462ca0fa2ba3..d3fd5bb56cce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3878,10 +3878,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	return true;
 }
 
-static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
+static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	bool success = false;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
@@ -3907,11 +3906,10 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 	/*
 	 * If min_seq[type] of both anonymous and file is not increased,
-	 * we can directly return false to avoid unnecessary checking
-	 * overhead later.
+	 * return here to avoid unnecessary checking overhead later.
 	 */
 	if (!seq_inc_flag)
-		return success;
+		return;
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
@@ -3929,10 +3927,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 		reset_ctrl_pos(lruvec, type, true);
 		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
-		success = true;
 	}
-
-	return success;
 }
 
 static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
@@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
 		sc->nr.file_taken += isolated;
-	/*
-	 * There might not be eligible folios due to reclaim_idx. Check the
-	 * remaining to prevent livelock if it's not making progress.
-	 */
-	return isolated || !remaining ? scanned : 0;
+
+	*isolatedp = isolated;
+	return scanned;
 }
 
 static int get_tier_idx(struct lruvec *lruvec, int type)
@@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  int *type_scanned, struct list_head *list)
+			  struct list_head *list, int *isolated,
+			  int *isolate_type, int *isolate_scanned)
 {
 	int i;
+	int scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
-		int scanned;
+		int type_scan;
 		int tier = get_tier_idx(lruvec, type);
 
-		*type_scanned = type;
+		type_scan = scan_folios(nr_to_scan, lruvec, sc,
+					type, tier, list, isolated);
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
-		if (scanned)
-			return scanned;
+		scanned += type_scan;
+		if (*isolated) {
+			*isolate_type = type;
+			*isolate_scanned = type_scan;
+			break;
+		}
 
 		type = !type;
 	}
 
-	return 0;
+	return scanned;
 }
 
 static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			struct scan_control *sc, int swappiness)
 {
-	int type;
-	int scanned;
-	int reclaimed;
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
 	struct folio *folio;
@@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
+	int scanned, reclaimed;
+	int isolated = 0, type, type_scanned;
 	bool skip_retry = false;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	lruvec_lock_irq(lruvec);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
+	/* In case folio deletion left empty old gens, flush them */
+	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned += try_to_inc_min_seq(lruvec, swappiness);
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+				 &list, &isolated, &type, &type_scanned);
 
-	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
-		scanned = 0;
+	/* Isolation might create empty gen, flush them */
+	if (scanned)
+		try_to_inc_min_seq(lruvec, swappiness);
 
 	lruvec_unlock_irq(lruvec);
 
@@ -4861,7 +4861,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {

-- 
2.53.0



