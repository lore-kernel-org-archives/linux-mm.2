Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37E7E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA7B6B00A2; Sun, 12 Apr 2026 12:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A91A6B00A3; Sun, 12 Apr 2026 12:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89676B00A5; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFF0A6B00A2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77B8B1B91F0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:26 +0000 (UTC)
X-FDA: 84650487012.23.50556F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 769FBC0006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb2A1ngQ;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012504;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqlwNlDvfmvi2BTVRbRez8gqx2zfxo+7olupFVxTH0o=;
	b=ERnXBzigUjDWMb53yPvdOdjHZ/3r7d/W96HGboOhiQLkQu9ydUU6nAhCqnZdiv03FEYcTw
	iqZlqeHDzQV0I90tpXUVjcdE/+EKu7lAYkIASRWxLPHDT5Wa5hNYXEq/eYYZvdFwbL6siX
	Znf48hHSXyGV+0UeAJ4wGVaVVaXZ1iQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb2A1ngQ;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012504; a=rsa-sha256;
	cv=none;
	b=yQdPeeMNCSQmpIeab872NGkGXQO5M+mc3Y0uHq4aC1HrbxbG9mijwlHt8oWAZ+OmVvkdvo
	aVHz7MdN0gJAAGDRjXfKEm1Dy7im6SETc/1XJHTA31S6qMxNz/7wkjrFxhBZs6vnjvJjcT
	vdBFm0R7EzeJIqNvfpV3SThKOgqcDnc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E5544713;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9137EC2BD04;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=Qj/B1/z69+cZMySbji0O/P0DX24+zEDw7gVmSm9wO8U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nb2A1ngQdUgDrqtyzYZ/EbCYuQPAyNLKQZsIQMLsE+NN8BM430W0XZpqXhxKnlSb1
	 PTTyL3EgXFGragQhxKYgXZjMJAZ39esqiKlOMGEz0Cvm1Lnq2pQ65HDVYxTXqzY31f
	 hInPXG5pFrXxy+HDOpGD3IDdqr2VfEFIpqiTfbPHYHV1GsCofdVkRM1NAeI9W/l5op
	 /K1Nzqh9UONGRxui2QPRBknAKD/zetjz6PT/nyjqt9Oas95JfJR6onB8tosrBazKWZ
	 ao6nyMzuPqt1zinXjzlIM6esRPP7ST5tR29O7fp2WnCji9Jr0463DYITWkGT94greN
	 0Quvf+Jk00NJw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87417E937F6;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:28 +0800
Subject: [PATCH v5 14/14] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-14-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=6741;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=onAAOpr3vpU2bMTuSUOIQofpAkgauLbJ3WIXe1tb0hQ=;
 b=FGbRkx/ZwSYXPdD+OeEnzMtVz6XKIkpf+5rfGCSl0b2y9g6+AgDXBdPdqLWrIsmtWIi3rNhwf
 Hq50xl97Ww5BsPWwtOGW6pmOwpX+5hRXjcT/bMktBkPJ45glAXWWUog
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: esxi4kmy7r76px1s1qdppo9tynrxbthk
X-Rspamd-Queue-Id: 769FBC0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1776012504-324762
X-HE-Meta: U2FsdGVkX19ucP57J4cCnzktMKF6l6rNx4ualO4GvHJjPekEX9923QPb4ZDeL477LC3T4KYongf9F/8eMeIHzEN2L0I4yh2gYKUnKWj/uWQpI65lCU1NIMOM1gtqhg9BCyPlSoiQ04jxoqPAbxRwggYdQOm/+XsmInfhmRSxnIOBP/qd2dhiWAzkIFu7WbNxJaZ/zSS8BqSDS1jwOy4Ek59Qnui8NYx+cuiRGTEHl5Iy/EvD+oGFqHUskze/6+P/YH5JgaILBz5FHUAzLqKKXGZyM+lUSNOsFR2haIYkDoGHu7GzMU30PJNbCnMjh9O6AHSuvSEZWI7PHP/sd/U3a6aXygoMWjTNsEi5rICnwg/hQMtWEG7BRIPg5DU0Mp/vzswAFc2MWQv7cRinIAhFVTbOxI0xhB1OVAtSxpHxyAuu1nSOrJiA0iRs1TRHKtwU34N49jhfFswiyOynH571wBLJ83G93yLcFqCyyU5GBFpkifEaq22UYqqDN6Ci7ZuFG0LjOFoumPbyUFgMxySh0KZ8DXmh6p/wj0qp2fdiQSHZ+ZqnRVIH71T6cfDWTYiowh3YyhdHffvYg5uGScKFp97BFiV47xoDfZZjxRafUMunDWJ1+byVhF9+acTDEumxDBJP98aiAei3k+SCfhXyN4nsJv5sIYSpCs+CPnVPCmOCoI/F4X6rM/D3RSCNkgwOrm72vMr+cRVBtenjTqUe9Hk9s3ECGHGbMREX82zsro8feXLLy6TB17R1uGFF1rMWK8S3zoTNFHJM/tGnXtRf9Fg8JOJjRL6EOAD8DMI99shcPE7YUslFZMialkdii8VxOx6wN4ZqRuBa+Tzy6zjNu4pj6kLwkgomlt8zu0pQjUahz1/uu88uDNzzwb5RVQ02vz8mSDKJxsdQB1ErQJYNUPdwLmWhDBOlN8c268Tt8SPVYaHTWW+3RjIQJLJLgRMnGW/YwIwCPKWVtvTfx5g
 3GF0kdMc
 riEMDcdQ3dq6N7yQ/576YvLZrNZyng6nxOz4lj78mFFubEMxjZ7u7oVX/iM00WRm9LbrDZMySKwxqt7/4n5d6vLfR295t0IAYPvssxYQ50O+12khDBRts5mo40CnkSvY2gNoVavytem5IF6jKy/Dy8NICrYygWNvEHemfNUWPFbkBeorywyzsnp8uUqss0b37yri71WPUqtN9LdDIduipqf8bN6hKAQPu17xwrAXM3ZbBFQ8gCaKF/1YrSEN6OcOQblGhrqwWd6lvdZnBCf1jImNrK+J4qz9L+uRQHTzzI6YDO6uh//5DFHyffNjm/94lvtpafdxduViYCIUPKQqV2ReyWJB6MzWKfUeOsxSSb8ILwVFyqGsZIsliZ4YqaXvI2ykO8NwopvGgylPVR+6LCiCpuZOL2D9tIv/12a9pP71wPbHuF+Y/18P34fxlgmWhqs2DACSchAtQ4pCYPqZ3vVC8eyT1QEwuKE11R1zYZgL+2Wr0NVlEYM/HVRfIHlLQOJPcOiT8VuLvvPperx/HHkTrYyZ/8br5EVrN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU and non-MGLRU handle the reclaim statistic and
writeback handling very differently, especially throttling.
Basically MGLRU just ignored the throttling part.

Let's just unify this part, use a helper to deduplicate the code
so both setups will share the same behavior.

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

Before this commit, `dd` will get OOM killed immediately if
MGLRU is enabled. Classic LRU is fine.

After this commit, throttling is now effective and no more spin on
LRU or premature OOM. Stress test on other workloads also looking good.

Global throttling is not here yet, we will fix that separately later.

Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
Tested-by: Leno Hou <lenohou@gmail.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 90 ++++++++++++++++++++++++++++---------------------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a431f94ff3a3..43a3cadbb586 100644
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
+	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
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
@@ -4824,26 +4830,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	handle_reclaim_writeback(isolated, pgdat, sc, &stat);
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
 
@@ -4886,6 +4877,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}
 

-- 
2.53.0



