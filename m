Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9689610F3DF8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8907D6B009D; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CC46B0098; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9376B009F; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 432206B0098
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBF0C89A5E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:34 +0000 (UTC)
X-FDA: 84596519028.01.70D4326
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA064A0005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ciw7jlWa;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WL6Oh9e+7huQ06a0hlSZgMSRfadsqyVe90W/nws9X0k=;
	b=X+hvSLR44h/NVtM2qcUVgHD7YXjPt6KgmdA0n3SpPsZGC2J3emyRl9x+Y+Jl6hfXUZtSCE
	wDjVOl4CLkJOu2VD81HpVOyQr1h0g6T1cRoaV7AIPzejGOZjEoP8baHEqe6r8zPByzKPsw
	Ki5zMrjNf4blFDh5kCzs5he6IS3nVcg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ciw7jlWa;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727552; a=rsa-sha256;
	cv=none;
	b=sILEZDFrWEwNr1Fdj5PHj4ZxCB0F/s5Bj+/CWj+i31ExYJiQJXnOXUD4MgJLGQtFX9CVg2
	LulHVumj8M3PQxX1Jcj1ZlwRl5+GCSlhw95ulzqtv77uKLzhrt4HpCYj3h5GfWU/9lr81m
	kIXsiHRgJSRKOQVA/xP8DdjlMdKF9k4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13F8A60128;
	Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB398C2BCFA;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=ZrNLUf7TIsnwMuqf3iVQ5egKhLO7tBdBlTFX9MiJW9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ciw7jlWamFG0Zkvwo8DlgG19vpldBiO2NgEw9S9FuR+GVzehh5aauskJ813ZANJ3n
	 SybWtfhjDYGttM54IG2LKZCv7X1L3UWUbBGDs0IQBOzy2IxsN268HLHlIWiy8rnUs0
	 CkgSeROdNY1B277COSY/wFoeJ34vAO4lGdjcNHdtMRjjfur09XoK6GOiGhnxt0ja9C
	 12zt6A8XLIMizDb2C3UyCDO9BBLEnmbMQd5bxVr6a5EE7G76PLoX24sAGc+nFrOaNJ
	 +1KKOSYOaIwkLjjCxAs/KHVWhDHt+BUZJT6UIbvSsNnBkfRxKWJZe4cCd6va6fEnjs
	 cawBN+hsrizGA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33AA10F3DF8;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:34 +0800
Subject: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
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
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=5969;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=T/G4ibrY7PQDUQFvtmIQoGY8xdh7KRch5mx7kYmgnHQ=;
 b=657LO41LLkGKMBTi3D7JTHfNytmDYDYIFylcEUbiGOlDeDMnPmHzWiDcdWfm/O6Hjb1mo/uKU
 +6EKFyu+SyvC+4eYfDrMoYLJ3KBJFuSN+8217Z64/Znx3R7YWF1gCpP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: tpff7k347h9jxqud49hikt51ccyoh1ea
X-Rspamd-Queue-Id: EA064A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774727552-763635
X-HE-Meta: U2FsdGVkX1+y1EXzuZmYsQy+kBfAcVm69s5WoOa0Rwy8wNetgS/rU8d4BHs9jtdZ3RFIi22yoJsuQ1qcZ3KCQEyLG40nO8sZRZvp0aQkNbiZfHst6Ov88JoU/6CG6CjROm6RyXCge6ecErPULjS2aHsiDBLCYrDZXyEWwOX1jqL+39e+T8+MTJ5Opuv77qazkNKb2stYfju7KUdsBt/3hqdQTC0im6hcWZfA9I/Q2s2LmxU7u17tAARZkf80GDkIZDYDRdIZdQdFcoYkG+CcfxcbKFeu3Y7fGp9OC+LJapSa6eM+OYpNvXjAgfHdHLD8H7O7ZaVIUIOr8Ekc2/YmbcYmtxyc1egL22vyoNB1kQLgaGHbbFPYwNcmMY6jmFtFSbdDFZq3G38R3pK9fa34jubpjqxWzGihl2UiW27epyLc1aR15gzXq8BYPNPEv8vpjkypgaf6SbwxFQH/1FmdffRBQNdsTrsTtmfCdJpe/HUC3Zr3KJoTm/W8HES6uqmVlHNOLfJrVboajK/uuGXglxbMbUZ90D7LZCmOuqqe/kqmmF45LAogpUQbUYOvPFxeQN9cMt5MLYM4X5FUTs8rd08eShxxJGSBAPPZz7TVijY/TnHD1aUqmqYN9ll70OetVwqZ9n6n4YxKYVqpQxO+OS7FC9a9a+81U2gQc66glgK+qxU13E1wWNFacIz6pWjlNynj63pfIAG4/rjv8yYxilT0wJUaWyajnk2BkbBhFzA7Pthdp8rMSEXkObJ11V70B+woYtv3MMXzVn/uEB6I4H01iZOuioUvYrDDBdOTquJYL3l6eMgDZsTcrYrKUtKigtgsRpS8tATF86oBrQ+N1g7DvmpAZ5DkI8Mp/SmMW0K5rSPvNpnoMqUsBvhadEI/Xw3apEFLnJsyOwGShOoXYlgdz565qgdBMMfpsm5WolAgVhA2AE6fMz3IO0mvXOB6ZMQhb3Xb8xw4jLsDcsa
 YVUAp+Tq
 qXSWJrTJiqz7SqkFPNJS8BQow8aEeyKawx4JCZ4wYKkJvPCJQ1h15T8n1KOzzmOXVRl0huHoI+Fy4LCqur6o+Nx9dfUPzGeg2wCfQlEMyO5HGnNgvaU92Dz+HU/VjB6bf9q6EFfotQoCD7L4d6D+a9uEVnyDlTP3aiqG+v9up9mzANzCOMuG9IA24txE4HJhfS66IDLQ8cZ7z0wY2bcTGnYKlJHy1IBhbcPNCVuJHxMd8rZUWTjVrY1u+Q0yC/oGMeHVz3Tq44WasGVgeV2GO5vWDVhK5Yw24aNn7AtjIdzpQeum6Z6yvg1mnt90LYwBZdb68Krc1ECCCjCg65gWmhjcxmuzGXYVbknARCA0BGihxWQwgnPbpFIWcZEAt8NblXvbxRbbk0jyCRXTgsAI+6JrcpZI6cAh1X7QQy1wSn4Lq0H1BDvbKaU8sxq9S7m5xEVrnXc/7bp8TuEhoSRJHtPckcBgpUTLH1RW05n2VYEZktg+63Mi5yCpsw1Dx+QJBR3QJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current handling of dirty writeback folios is not working well for
file page heavy workloads: Dirty folios are protected and move to next
gen upon isolation of getting throttled or reactivation upon pageout
(shrink_folio_list).

This might help to reduce the LRU lock contention slightly, but as a
result, the ping-pong effect of folios between head and tail of last two
gens is serious as the shrinker will run into protected dirty writeback
folios more frequently compared to activation. The dirty flush wakeup
condition is also much more passive compared to active/inactive LRU.
Active / inactve LRU wakes the flusher if one batch of folios passed to
shrink_folio_list is unevictable due to under writeback, but MGLRU
instead has to check this after the whole reclaim loop is done, and then
count the isolation protection number compared to the total reclaim
number.

And we previously saw OOM problems with it, too, which were fixed but
still not perfect [1].

So instead, just drop the special handling for dirty writeback, just
re-activate it like active / inactive LRU. And also move the dirty flush
wake up check right after shrink_folio_list. This should improve both
throttling and performance.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 61642.78008938203
AverageLatency(us):  507.11127774145166
pgpgin 158190589
pgpgout 5880616
workingset_refault 7262988

After this commit:
Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
pgpgin 101871227                        (-35.6%, lower is better)
pgpgout 5770028
workingset_refault 3418186              (-52.9%, lower is better)

The refault rate is ~50% lower, and throughput is ~30% higher, which
is a huge gain. We also observed significant performance gain for
other real-world workloads.

We were concerned that the dirty flush could cause more wear for SSD:
that should not be the problem here, since the wakeup condition is when
the dirty folios have been pushed to the tail of LRU, which indicates
that memory pressure is so high that writeback is blocking the workload
already.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
 1 file changed, 16 insertions(+), 41 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8de5c8d5849e..17b5318fad39 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4754,8 +4738,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4858,12 +4840,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If too many file cache in the coldest generation can't be evicted
+	 * due to being dirty, wake up the flusher.
+	 */
+	if (stat.nr_unqueued_dirty == isolated) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -5020,28 +5017,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		cond_resched();
 	}
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
-		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	return need_rotate;
 }
 

-- 
2.53.0



