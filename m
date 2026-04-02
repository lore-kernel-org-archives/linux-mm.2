Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398C0D6AAFA
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E826B008C; Thu,  2 Apr 2026 14:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C4E6B0098; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8ACC6B0093; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 616D66B009B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 386C7E0965
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
X-FDA: 84614514810.17.2C66CF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F1044000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sg7iA4bO;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPSs+wenavfx8ab+XPENKDnL0o5ehpHZ27T6LrmoDbs=;
	b=WzITaQlUyn5p4YSx0VDp3y5CDBs1C9sRERVB6eEr31P/p6l3ZEYCl54FrYnyzZEsRMvCvf
	niYxplmpfLxagFnqt0DDvEmL7DNjKSfYlkGK0CIX41wEh1JMUpQbmsh84pua9bs0U6A9cE
	5iwKzt4EnjOzewgQ91NUOdATog7xi34=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sg7iA4bO;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156023; a=rsa-sha256;
	cv=none;
	b=aMgqNkVZ1zBAaqKJJ8/ubsa6+mYxEYYW4H4ngi7CDBlqwZNrLvkzMbQlyME6eD6EWudIVy
	qORUWilOvzBKYgjUCFKwY4JbQLDThQc12w2ABrbDJTLlbPUufENplNQqgZWfOeaW3KzDIM
	N1vaoTNYPkurgpefNVgRFeb1/9OYAxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B042544441;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 780D3C2BCF6;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=nLUcryvh8JhOr7k78Kv6A3d7lpY5EZnKbtRKNSfM9YY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sg7iA4bOK0uttvuXryrD47L5kZOWQYqf9VXU6lCx8sxSh7WHkotGnTZ7PGw8axokQ
	 NsrLlM8l5IOJoQDWFRj80xw2tYLoPpR/2Wjfgz1G80o6XiTOtf7r9/hxO3yZRpCcyG
	 qzzLVKA9SxV1D6peiv+qqUFAJiA+QnnJl8qkJ3qs59mSlrz+26sgu5B5LvKCcobeq9
	 GFoWIDfdWJSLCi76D8RdinGNLrvOY9NI7U5t0o6pQBYtZnfVYBO789jXIVPJro9gVo
	 RhmLTl/iWNuxnezZO34iCsv9o9GNtsHKbLniTwtQIgMtojio/+zZAN1JeSp3wlyWyE
	 DJJPka+KOg0LA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF4CD6AAF8;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:31 +0800
Subject: [PATCH v3 05/14] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-5-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=7080;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CYDE9ec7Cz1H+HSpLojRtRdyUXE6Vvbwr0W8YOLFv64=;
 b=pwjY+MndiwmgMz/YebgPM9NYr5g9YjMfJpvIkVtia9stPEJLx9oEpYdW0Mm1K4Ah+Em0zIgIJ
 yW78D6uQYKjAVFpm24ZXMaKiwHTW3XJjpkVpf7yqffaoz4XkVVRCs8b
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 2F1044000B
X-Stat-Signature: qg5zbht5uo1yfhswx4mrtqhof59ixawu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775156022-525315
X-HE-Meta: U2FsdGVkX1+1CV0jsJJUVgQJ40EtRRgnJXAE33f9fbbeFiQeNa0DPtvVfOaTvtIRS+hMuT0WZ/2Mfunq3yZQPTGozHWnpSm7K9lFh1xmUAMY1JE5z+NL6nHSaaAuzCcvV0Aqws7NVwZzdhEWQQWOg8f5VoG/KwODcQhAsEbioTCvcXtnnX7wQwePZGL9qPyLpzeJoyAL4bvClUNg7nZT2xclDvZgbYbBPKyjm37U7BqlHl/GgJvlnPIgaljedY3cXOjFjgK4jkDt8z8vgS/Lq9MlCBdHoy4jyh635ek3DtSwgQc+WN+k3zie0NWlJIB/nIEgVzX06gGIOTDz1NO2NdTzVbmRCcYmk7bNu49pZlXPp6HzfmNV2JcLKdjHn+hy6pgahVQ3QpeE+BQ0nbQPgKtkX3ybhNSZ2atNElFbtkReLcWhMCEW95BOdPbDQlAc833uazZ7FU9KDzIeMxYwWAhcEeueKjiFXES6UA4LodaZk7c+3t0vc0n+X02ShN5KyNFoY5OXxhUM4ImULn6oDtOWvyqnqYG0Rb7En6ds4wlp1kUuf0NONoiwYXb4kd4dh1Hoip+UugvVpBzuZLjgC+qWxdSUmAAmitSthgGQz484nTAtf5MQqTOX/+MFwObfu/d/F6oJrLdIRDXRi/CDm+I9odZPJUBws8+bBgoMbdS628Wr3iHYPYrF4rIUH/IjqP9EQPJ/rc5gI4movSRMzhxHEtH+UyHeFPdSdKrjtIqTGYx3Ur0Dx0tSKNInxmtdFy7vTVLO/O6DQpuQjGU2RROVY2H0iuMlLa0nW5P2sqrJiCyfp/VHtV2a2/b1V8sHAUYQAvI17X1R4upa6TpNdlSFLxlZsODRxgt/RycPOlCFfIcQ7ify+OoNXaoWA782eZXtopydOnEd7hEU51z+VUapvH9dgNCTwheRs9hozmNxmqRIVFbTUaj4BWfHB7Hfkqu8lBk31lzvTjJvHWf
 O0u8AoYN
 kWKgQLKc1bz7p7Gev758lbZVvHe6AMbR5Oc6TDYKV/8jnaswDM+EqNK0NaTwNjsJc4opa6owCgzSqki7221mylOaaICS0P6EFNRFZ11NqqCuj9Mqxgej/bdEUKBOJJtstHyzNI/tsNdYuaGOA+TRPiNkJOFTFNNjLgurLiR73yNXZBHgMsihxN4iUi/AV6/aUQZwIcYa4D6rUV8xUKjwXxEHGjiK47LoV3kwHRct/TH7jUgEYN/EYtTZE54XsNtqUtDzm9WViA/HiMiKsAPJ9BvdU15b7MwTeXJeFtak9v5T/lYFQylP8Jpc9WPKyZ/zTTpP0Viwjx1jRxH0uE2ABSXnyhwISTKICuhoSv3dn7cS77nm0uR5qKpMeKnF/oJ7aQaNNl9Ck/DOftRxpJXbKBKBFy/qcE5ffjyMzJQQHGNIyPn0/O5SjZfZU9yWCiP6IopMu
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 60 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 93ffb3d98fed..643f9fc10214 100644
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



