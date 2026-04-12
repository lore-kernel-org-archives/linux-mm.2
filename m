Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DB7E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E086B0095; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF696B008A; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981756B0096; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6146B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FED28CBDF
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.17.89A682A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 507EB1C0006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mq3bfUdU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raqrbrBMroGzbAKAB9vflmvgduGdSn52C/0mwXJ6P64=;
	b=flcG5mvfs7ULuAJ0zGwl0LWHQUzHKl9ajWl9eJS273cab91vnImTfTY8ri/S5HfNXfz7v7
	ilZopgVgKOJ/5kTJxyJDKSTIeZvb06rHR9pq78HTNVRjGJMLAZ/P1Nku4Py0giYReOEyGw
	MQjEYmIN/unFHV6cbS9Y3R0qNhOJr6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012501; a=rsa-sha256;
	cv=none;
	b=j3oipxu+2vwAOMku2bpWt72qvmihJv/eA34HGH8XKI/PEX/WkLgQAZ1UDiwvg0pibZphXK
	dnOII/PpXwx5OJO5+QDQnbpNL2EzFMNaXQtSzXdE1Hf7u6KCsNKxS07i/VbhfivFwZr1Si
	P2usMSWsVKpUIVVQsNTRzFdm+RsHi9c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mq3bfUdU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9181D6133A;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F01E4C2BCF6;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=NjTAqTMMdZ1d10EgLz4zAuMCvDORj15wAon0rP9Z3vQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Mq3bfUdUiEw9ytI3zBjE1N8QQMKIGKZmBgA59X3EGG7dTU+LgHfDTZso/EqvZPwov
	 jJdiRlPolWI/IoIs6azvPLsE3Zy+P0U4v8I/BS1tifWkk2XTIr/hOtddxP0ZRcNRXN
	 EV8tQE5wYp/8z8RxQXBumzgLagYlIN/YK6/gzB6Rpd1CV3/TwLCBki+XQ1bWbl1q/g
	 fSqMUNJvGmVodfTj1qWrHR8IzzhsFAsfWKlFrTQ3yuquQtv9klWqtXY+9A5UlWHAUa
	 bOVkVBYnDUhQbcX5j5HSblAbCtfH8p5NLyfBiQfZKP+uHvLQlmT4hb6ToBtsdp5xBB
	 w+lxNM94WwLzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F87E937EB;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:19 +0800
Subject: [PATCH v5 05/14] mm/mglru: scan and count the exact number of
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=7191;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+lNvcxMchl8+IGJt1lhbYz1RQNKHl1cEaDndT2wk7QA=;
 b=FH2asZ4t2q0DEJKYPRRpyHAPsCtYa07ehnRjHXa8XSN4VQyzPjeihP/52cXVth9KX6Fg90x8g
 pnvKm0wqYo+CFFQrvFASzZa3lhOte3ut1BlAN9BHJDdqcVTjfFRbkKN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 507EB1C0006
X-Stat-Signature: hxcmoypfcfj8xupp341s6gh4k839ffss
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776012501-946790
X-HE-Meta: U2FsdGVkX1+LimsJjEAm2HOD0rCtO2+qlprIRgTZvZCmCeBhZPNmNhvGuOZPPdVZIpMJW0X9jwagESiOBUPykpwsr7wqY18WvkrCzs45mAznv0tmPhJA0KHB8MuHKPPk+/5UNxd/VpYHNkX0KAiNmbPrrhrVs3vUaCMKvrQ1lntCSJGtzcUs661LRRedd/SdAZp6ZJqp3fIj9joOopP45WzhZeFQA/FKe6D1L8LEPS+IDwCkQdDWrlqEmnEPSEEyq1PrA+OQ9FcZdCvZwTuYsoKDytCK7wYwWT/yjDqigQA2jh5dHOoEhyI+f2KpEjKYHCBXfouZe7drtTHkHz/UNnEoA7RezdAZhBMTUBGCh6ePYAmL7SOVL8+n5cGXTB1DVKt1S74yToZaP1N85lr2cTzWoyjbEc+4YTB1lvipn6VenIm+A062YBDGHvm+xb9GUGAhsarAX5taJ/Ysdu5OaSdnFptD2ymJhDpH8TMMwfQxXxo5YkkSzRH71jF+ZrfwaNtC9NOJ36VcKiaBUGW7uHC+XX9v+fSD/yiQ8/U+/CPrUYmPRWZcCAWucW6yCCsPFaREyKnETCpx5bcpNmT8mXZ0ncuquMvVlvXkTYg7QMQ+0ryWsyEIXhzhQd0Yzr5xoC8kIc6sb5rMyfxWZKUP0Kc4shjW5+wNMBDkOWfn+0uMgQ59hbs3E9afSfUlulFa7t++7oGZa0/xb2xebsSvD1syjy58eScd1Z0nKrRuO6XcBAjFu6WxEWEGXmriCX0NucaQ6nzBiW16e119XEzlA7LkWxQj2+D+C5UKoWe1dKCkxJGjlpphmz6GRuYj2bz+cmYKzhXxn47aeFabxZVFq4cmbsU1fbh4XYkKxkY/xflJr9DHM3mIfxwjElPTlXj9HZAyTKSw6D5PYMAFbrCgRzjD04QSrZc3EliqIwjBSZ2gHwTDAVpNBVRbzxbVmeVVO7CrsvqUXHOO6ONOgCL
 SUUiqi0c
 EcPBX9fPMebMJooiTRrChbZY3Vh3LiXba9M+bbF528R9QbhxRsdSjh50xIS/ZbbX82284eXf5Il0zemAEYRFfS3Kh9xoebNfcHBgBBC7WmEIOWZeTEy5J5y/gy+sy+WoxiPtP0fwv4Y/Rx+Wg9xw90bAy+hM9EdoCQ2InpXVluwquIpHDgk6p1vCj6xCWJ3FuuQ33j4cp72rKp5CebQIKDhI1Rm7QAx3U/uMTyinoaz31pYl642nFt2ZGXcqPIHhZi28HfHW8ONsoQUToGotHdMsFJyN23Xndz2mXuJ8ZQJcLYAvQaf9Q0xYUcv2Lf1IeUAaAJoYR19vsOp2KUxf/ztzxbGjwDF9lpNohz+VzzcG2nSMOlcMUhhnuSv15SoZy4MMu6QtiPC6RizpUxbotam2aj4L3jCKhe3ThBYEt7h88ECZgOMCzXRDw5qCpcsRTAPUkPEWfWZvJ2+2GvXzKOjtzHVObOndWqLXPqgiGZvQNwlg=
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
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 60 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d4aaaa62056d..e3b68b008376 100644
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



