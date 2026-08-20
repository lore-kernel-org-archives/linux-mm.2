Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF020C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F296B0095; Wed, 19 Aug 2026 22:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F146B0098; Wed, 19 Aug 2026 22:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E686B009B; Wed, 19 Aug 2026 22:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34C6B6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:48:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0C5D1A069A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:51 +0000 (UTC)
X-FDA: 85120115262.18.8A46B97
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	by imf16.hostedemail.com (Postfix) with ESMTP id A51C5180002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yfd+Rxq9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787194129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTcro+wZrO9ONiOytWu7Pdxhrj0RvU2tboiHfG0z0yA=;
	b=mlxOc3HBKlXmPmrrOn8kzB6M0BJLnaaUJChz9Uo+pRuftdnBQ7k4IJUZ+g18tgCOrAiuXi
	hT685Zo70OSG9yBBez23suQZPNUn7LgWhvuOe0dJz/yEVyxY4Gd93llYwbtO8XnKRstw/G
	19OfsymAhr8SkgWK3jN6RecZU8V6f1I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yfd+Rxq9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787194129;
	b=QwL2XxKDJyb9IjFvFqhk7G3DNfEUuuUt0A8dKWWKhchq0EzhU487gcWyj2mrkAVjyqAGE6
	jxoDLWloV4buEZKVc/4rm0979Vy2RU2w3SVytbDphfRtVHetOGDNHdYq2wwwb7udj2OaOE
	yM5LsBVEQIK/JwG49MMLPAUbQdImoW8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Bhp2/74VmpHMzBwDgoyvkdbnUqDeX4YHMvi+u6elTeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787194128; v=1; x=1787798928;
 b=Yfd+Rxq9N4Z5ZmsjtbA9/QguI7AHiEYJjlJLIesWYU/Y4VUhMh8HDjD6pppABG2RtNBK1mti
 pkl/WW+dnkQq+cLsWAqxYDjTZrqxwnJ7VZ7cgHvV5ZwwjNx8QoY79g9qL1cNRJOHeVkF7o0Wve3
 eJ5x9hztzmEue9gIelpNMXdY=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id f7eac550d4626fba;
	Thu, 20 Aug 2026 02:48:48 +0000
X-Mizu-Trace-ID: f7eac550d4626fba
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v4 2/2] mm/vmscan: apply too_many_isolated() throttling to MGLRU eviction
Date: Thu, 20 Aug 2026 10:48:15 +0800
Message-ID: <dc4963a19e11d92eea4a0a89cb31a581fb9bc821.1787193916.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787193916.git.zhuhui@kylinos.cn>
References: <cover.1787193916.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A51C5180002
X-Stat-Signature: hxp48tfjaipesm7dks1179eo1xzt454j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787194129-481172
X-HE-Meta: U2FsdGVkX184Jdf/SPv7a0OVu3f1PQiGetUitAyTsrzQQRQOw4mo38xHGZJT/EIHjiacGJ8KHWd5S5xcqA9Y2dpRju4xvvP70P/dQLaTuUdko0nfd8NyDxruFTSmIhok/RjPrCxsGuBXEeDF8juFEo2UE7m9kzhE5l/u/i+39wjx8yCZYTO91s+wlJWUkT5OPOEWmB7A/jrhLxvPUCLVz+DXdZRk4byyqM2a3q4pOJY0H2bFzTwRrTR+EAbEuT6lgbCipiJ2ovKs3pAd1WYG0d2bEgyub1fNYmRT7EjFIcd5Uxoi4jaccd3sPGikjlap9396DuPe1CdDdU/wLgbqYf0m1QZL/Et+HYUyDl5WVipquSGw9UyHuTjKA3fhlDzzAdGisVQFPAMSPWf+eVuuXcIJpDA8PccWPOgVixbfPG4Xv/7N0ADmjq49DlhwtyM1y8Y2qpc9mL3vbNPUqlU/xYE0K3dgtURy681wYJ+Zv8C7Q87+N5Qs4Nu2CGlM6Ld8vDYUVDJw7y8oNfk8TQJNZypYaVZEsD14+it5ntAV95TbAh3aci5n7tJ0gS0jKRFu16/RMUlPPYUG8wM4UlYfJlYqUDuqBqzUMC7s1RAXqlcn59yjkWHzBXZJ8rE5Ldsu6yCBrkwvqLRtNMHOGiTO7Dz070hFfboWfJEpMmh1j9SuA7oQxnDJV/NbzrbaRd38ELlZT6nDvU49jFyuPuP8oxVm6ufJT6SXm+a+cW8qRwoB5LNd2QrN0cwE1jo0oSS7HJ7jCS5uAG1+sw5Y11mpBhb7wkyy0JTajTiEzCTD3AAFwFXY8L6plARY8gup/B5ssk6e7f8DkR7RVIKwiQZATy0so4fwkubHxX5+KxjHR29yPARJeblkdVRQlMzrdE+fEWlxmM0t/SrezfzmkwgKarkrc7fotUv+5E7eYbOoN+lhsL8ZkZnRazQPfIpxp0iRjen55AWj9I+yPd3LCi9
 aBtnmX7Y
 q2gNZhyBUVlqjGBinca0dbrlL4FhYSnHQSr96d7TdTFE3eWtIa216Ct5wPwry1CyPR6Nu9VHT8iOuwikRvS222g290v7aFCkqL2DCfuB/jSW4pQlwLi2V2+MRqiRzSlZCEtAeg5IjKVaCDVJgmyBVjsmkOyA4W53NNbq9RT9mQ8A2cCc5M/dFu76rgPu6dDa/SJtlqtOegAYJw8PXNF1rAUIdFz2IUa8BwWhiOIMvo1GpbuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The legacy path throttles direct reclaim in shrink_inactive_list() when
too many isolated folios pile up, but MGLRU's evict_folios() isolates
folios without this check, which can lead to unnecessary swapping,
thrashing and OOM.

With the NR_ISOLATED counters now updated in evict_folios(), add
throttle_evictable_types() and call it from evict_folios(), before the
lruvec lock is taken since throttling sleeps. The legacy path is left
untouched.

Unlike the legacy path, where the LRU list to isolate from is known
before isolation, isolate_folios() picks the type to scan from the
refault feedback and may fall back to the other one. Therefore, instead
of throttling on a single type, throttle_evictable_types() collects the
evictable types that do not have too many isolated folios, and only
sleeps when all of them do: like the legacy path, it waits once for
concurrent reclaimers to put their isolated folios back, and gives up
if that makes no progress.

The resulting mask of the types that are not over-isolated is passed to
isolate_folios(), which restricts both its initial choice and its
fallback to it. This way a type that is merely over-isolated never
blocks the reclaim of the other type, and isolation never lands on a
throttled type.

If a fatal signal is pending, fake reclaim progress the same way the
legacy path does, so the dying task exits reclaim quickly instead of
being held in the throttle.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 98226bb021f3..693dc91a1695 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4833,15 +4833,73 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	return positive_ctrl_err(&sp, &pv);
 }
 
+/*
+ * Unlike the legacy path, where the LRU list to isolate from is known
+ * before isolation, isolate_folios() picks the type from the refault
+ * feedback and may fall back to the other one. Therefore, instead of
+ * throttling on a single type, collect the evictable types that do not
+ * have too many isolated folios, and only sleep when all of them do.
+ *
+ * Returns the mask of the types isolate_folios() may isolate from, or
+ * 0 if reclaim should stop. Also sets @fatal to tell the caller that
+ * the task received a fatal signal while waiting.
+ */
+static unsigned int throttle_evictable_types(struct pglist_data *pgdat,
+					     int swappiness,
+					     struct scan_control *sc,
+					     bool *fatal)
+{
+	unsigned int allowed;
+	bool stalled = false;
+	int i;
+
+	*fatal = false;
+
+	for (;;) {
+		allowed = 0;
+		for_each_evictable_type(i, swappiness) {
+			if (!too_many_isolated(pgdat, i, sc))
+				allowed |= BIT(i);
+		}
+
+		if (allowed)
+			return allowed;
+
+		/*
+		 * All evictable types are over-isolated. Like the legacy
+		 * path, wait once for concurrent reclaimers to put their
+		 * isolated folios back; give up if that makes no progress.
+		 */
+		if (stalled)
+			return 0;
+
+		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current)) {
+			*fatal = true;
+			return 0;
+		}
+	}
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
-			  struct list_head *list, int *isolated,
-			  int *isolate_type, int *isolate_scanned)
+			  unsigned int allowed, struct list_head *list,
+			  int *isolated, int *isolate_type, int *isolate_scanned)
 {
 	int i;
 	int total_scanned = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
+	/*
+	 * The preferred type may have been excluded by
+	 * throttle_evictable_types(); start from the other one.
+	 */
+	if (!(allowed & BIT(type)))
+		type = !type;
+
 	for_each_evictable_type(i, swappiness) {
 		int scanned;
 		int tier = get_tier_idx(lruvec, type);
@@ -4858,9 +4916,10 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		/*
 		 * If scanned > 0 and isolated == 0, avoid falling back to the
 		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
+		 * too readily can disrupt the positive_ctrl_err() bias. Only
+		 * fall back to a type that is not throttled.
 		 */
-		if (!scanned)
+		if (!scanned && (allowed & BIT(!type)))
 			type = !type;
 	}
 
@@ -4883,13 +4942,29 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	unsigned int allowed;
+	bool fatal;
+
+	allowed = throttle_evictable_types(pgdat, swappiness, sc, &fatal);
+	if (!allowed) {
+		/*
+		 * We are about to die and free our memory. Like the legacy
+		 * path, pretend some pages were reclaimed so reclaim
+		 * unwinds quickly instead of looping back into the
+		 * throttle.
+		 */
+		if (fatal)
+			sc->nr_reclaimed += SWAP_CLUSTER_MAX;
+
+		return 0;
+	}
 
 	lruvec_lock_irq(lruvec);
 
 	/* In case folio deletion left empty old gens, flush them */
 	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
+	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, allowed,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
 	if (nr_isolated)
-- 
2.53.0


