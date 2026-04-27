Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDDCFF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528906B00A4; Mon, 27 Apr 2026 14:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B736B00A5; Mon, 27 Apr 2026 14:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDDC6B00A6; Mon, 27 Apr 2026 14:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7D36B00A4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB2BD1B74D0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:38 +0000 (UTC)
X-FDA: 84705118596.09.B78EED9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2FE0180004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxvlEBdN;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313257;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/4or4l9o+1UYpU3JMRed53jW58PBMCvNlJaCOIJLoE=;
	b=WNbpsD6uueYQxBQYkSdwm5L/8MQ10u06ZpDS/1oxGISeTd4/Z6pehOtzdUqRqdLOUCLx83
	scqS3Yb1Tw7AP9644gkTtuOqCXPU7l40WYBEvNTtEwguH2TrpFLTbVGnyXeKRIfc/xucOv
	JjMd9WFK5XxDoZcRVNcICdWhT7ef+/o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxvlEBdN;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313257; a=rsa-sha256;
	cv=none;
	b=O+Yfi3lGKTiU7re986LVf5/SfUhWBVZJIOHJC8arOOEiMEZ8fx57sNyWvtrXa1exgixg5y
	yfWqk6sm2SdxZQvqap2TKRZWSsUHbNw6TRFSjAPIBl9wxNOo+t7suSfsXncbtYT/mIAjSF
	j1VGe5BKQz/kvTspkeqlJ/k+a/7HwQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7DB644760;
	Mon, 27 Apr 2026 18:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1C54C4DDFF;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=TltjEqiK8mp2zGBFuhVqWMZLycNs4HGZe1tGT42589U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IxvlEBdNl5ezRo0sFBZOSuOwdFXqZ1J3+ehS9WAX/Xx1DS/g7KaXRbNAQWYmCY8LX
	 tbTDOudCf8+a6vDgnbuvAiLZubbbivtkAQ/2Wz+LyWGBMx9Z/nPBrZK6ofPoybPYo0
	 TH3q6sAadEPid/3Uu3HqQjpxJBBW0BNxlt2X6E/EX533cykCnl4pVLC6GCuCU/KSNO
	 V6eyXbdN1LEG4jwp5FJDm5u8QB4Ag3ATbQMz9j16TlOkD5b8336t91N9VvPkN7fkUs
	 yyEb3kjpuycxOialuAE+KPuDqWXKqlmnXSfSCGz2LTA8x+BWzmXsU2p+PNVDG9BnR6
	 T3F3ZS+OYoRDg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA33AFF8868;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:06 +0800
Subject: [PATCH v7 15/15] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-15-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=6821;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cQ7SJbHtgzouLQNheQ5U8x6eH/mNrNkWUSaVWupAfY4=;
 b=bdzV3avOotE9stSy0GuDAjEjDar1QjhkCFUp7c862T4KjZU7Njhl5t31hyzGzCOP3EKeKIVRA
 UrIdHvmVLqRD8A/Dful197cVNiCL/UaQUSUDE1zlD0jfM38jNuWAhHT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: t134k6zrp8ikhz6htbqs9rgu1s7e494j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2FE0180004
X-Rspam-User: 
X-HE-Tag: 1777313256-696129
X-HE-Meta: U2FsdGVkX1++wIw/ZxIWUtjzfqdRMfQwrorNE9XA9LZxBWUzNy9r9PXaT2jhOHibJVEg7ZuGh5xh6LU2b4DvbWWDvhCGx7ntjTYrnDu2SBBbjt5XwEc0TGBKw/625IYBB+OA71vXAl3YDFpRdMsL6kR3GiEfTRWqePdD7sOiusPEEAQSy7e8K4asym9UGt/wDt0f9fzYqetbwXRRcklLOL2gPTTECWfMBqKlqhhqL0vOmfGGkFmgvJ/95Gl+H57G7kWMuOTOWrzDR4E9ZnTDM24QovJD273RZfIIGlQ55/BwMj8TMzQNV2Yt/pz3hHhL6HkWvWWFqOQG3lJVktkI+h1igiw4lEu7GWTRK16mN+2I49lkhT5PvwwPeAQYAlYlv4DSihi54jJOx5wex6LFKizRQiiBrpCl7tBDPz+YlAJ9WK2OSm4oleeKxpIU4jpTy97daorDMHpIWLXq26JkFJ194fU03Jq0d5RXO2WvAqoDkw+3gcv6b/fpW6WOtDMGqY+d8+Zu+ciJ08hehP9N/zHt4Gn0PI2d/Gf+t17yWRFD6+sniMje4w1eagjtR59mNHvCn1Y0BoWU7Dq3nl/Mj/7EDXwJHb5AC5A5kCK+aS5VmvzVY/zfGX8QbVf/rhTzfAWU8h3gF81dKXtSo1VuNorYHKWoWchz4U+zqbpPOhQIvvNLqy7uOULcGJXGZnQTeuWOpfr/zFxihpVzue5i3KeJKqIM+jCHzayuHyN9Tp1AGeCt8yoPd8O+8IKWZdcperLaqXIFxmcUsnhxcAiKHjv+2yOIvF80jyfDT5maljIspdSxynpm2+FZ9atVTYgbZDRq8bJGmt5T1fMN8kCaX18Oz4dOR/6FnbAk0kp0qnpx7/Om7ny6qECjvDEgqPz/3UMmhhBVRdy7YGJzfgobSCGSl3zjBIEkATrBNSZGh4SkywPB1oTXCqiDoWUrLfkJUy/B3sGL+LcIJxT/Ste
 hvGlUc8x
 jFmULCfMFQ5KPYltGxR1yvXID/T0WHSt45IeBlL01ClGcRyn3DCEtQWjLT4eAHOFiEdG+UjtLboGQymQ59cn7nV36NOJ59Nw1tfnEoonxYvcEmPhrMagqJ+KH5p85yPpJHiNI6H/as1HvDTgSkXzLlbLRvA7kOBzhipOKYc4jxTUCNvztf4rVBKt2G3a5LmQIQ6te65NcWDiKIEXQBD0T3sZz8VePNEJpDCHZbbBJb92WohN0IpE9U3iVlHnIeRJYdrTFzvgjAYRIx1B1g5lVt5Ais/E4UK2sS7f+OdZ9nYfLadbBNWeHFHwYmiLO3dchRe5wJ1QRXn+0pPGhampZCn4b0oaMK0liUiov3RJmVOVSm7BfHsDeaNQfYsXKohTbn+PLToDZkLg+mt8/OsTWTodPOZkHRs30QQyqTiZzn/5vAPINhIwJmSO/n9jDL89kTrD6BtHQy04OtXnSKnYpFaOY2CkCJDk+RzNKSiB9LVbP8ky0qtpHla2z8q6iqkwXqktY9cn9DPPIu72kXz51FR/U6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU and non-MGLRU handle the reclaim statistic and writeback
handling very differently, especially throttling.  Basically MGLRU just
ignored the throttling part.

Let's just unify this part, use a helper to deduplicate the code so both
setups will share the same behavior.

Test using following reproducer using bash:

  echo "Setup a slow device using dm delay"
  dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
  LOOP=$(losetup --show -f /var/tmp/backing)
  mkfs.ext4 -q $LOOP
  echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
      dmsetup create slow_dev
  mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow

  echo "Start writeback pressure"
  sync && echo 3 > /proc/sys/vm/drop_caches
  mkdir /sys/fs/cgroup/test_wb
  echo 128M > /sys/fs/cgroup/test_wb/memory.max
  (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
      dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)

  echo "Clean up"
  echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
  dmsetup resume slow_dev
  umount -l /mnt/slow && sync
  dmsetup remove slow_dev

Before this commit, `dd` will get OOM killed immediately if MGLRU is
enabled.  Classic LRU is fine.

After this commit, throttling is now effective and no more spin on LRU or
premature OOM.  Stress test on other workloads also looks good.

Global throttling is not here yet, we will fix that separately later.

Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
Tested-by: Leno Hou <lenohou@gmail.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 92 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 902ca52ca381..e452cb043d46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
 	return !(current->flags & PF_LOCAL_THROTTLE);
 }
 
+static void handle_reclaim_writeback(unsigned long nr_taken,
+				     struct pglist_data *pgdat,
+				     struct scan_control *sc,
+				     struct reclaim_stat *stat)
+{
+	/*
+	 * If dirty folios are scanned that are not queued for IO, it
+	 * implies that flushers are not doing their job. This can
+	 * happen when memory pressure pushes dirty folios to the end of
+	 * the LRU before the dirty limits are breached and the dirty
+	 * data has expired. It can also happen when the proportion of
+	 * dirty folios grows not through writes but through memory
+	 * pressure reclaiming all the clean cache. And in some cases,
+	 * the flushers simply cannot keep up with the allocation
+	 * rate. Nudge the flusher threads in case they are asleep.
+	 */
+	if (stat->nr_unqueued_dirty == nr_taken) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
+	sc->nr.dirty += stat->nr_dirty;
+	sc->nr.congested += stat->nr_congested;
+	sc->nr.writeback += stat->nr_writeback;
+	sc->nr.immediate += stat->nr_immediate;
+	sc->nr.taken += nr_taken;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
-
-	/*
-	 * If dirty folios are scanned that are not queued for IO, it
-	 * implies that flushers are not doing their job. This can
-	 * happen when memory pressure pushes dirty folios to the end of
-	 * the LRU before the dirty limits are breached and the dirty
-	 * data has expired. It can also happen when the proportion of
-	 * dirty folios grows not through writes but through memory
-	 * pressure reclaiming all the clean cache. And in some cases,
-	 * the flushers simply cannot keep up with the allocation
-	 * rate. Nudge the flusher threads in case they are asleep.
-	 */
-	if (stat.nr_unqueued_dirty == nr_taken) {
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
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
-	sc->nr.dirty += stat.nr_dirty;
-	sc->nr.congested += stat.nr_congested;
-	sc->nr.writeback += stat.nr_writeback;
-	sc->nr.immediate += stat.nr_immediate;
-	sc->nr.taken += nr_taken;
-
+	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
 	return nr_reclaimed;
@@ -4829,26 +4835,13 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	/* Retry pass is only meant for clean folios without new isolation */
+	if (isolated)
+		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (stat.nr_unqueued_dirty == isolated) {
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4891,6 +4884,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}
 

-- 
2.54.0



