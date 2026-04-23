Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1A6FDEE35
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52E06B00A2; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03596B00A1; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56ED86B00A4; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7EC6B00A1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0695B1603E1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:38 +0000 (UTC)
X-FDA: 84690542916.28.5C51073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF46A1C0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIVFQjqz;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966216;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGbN7Z1uFCz8Va9HQNec9rkGO45XswpYLbqil9gphUg=;
	b=Wmh4H6mhJHuoY9HJH1OJMQkIq6GkXpYo3tYsiuQq813Wo7pu/jiu+BK36mwW/UfX2GnQxS
	J4XCxjJnJAjmLNyR30BGfIN0njlIx3+hKo/Ze1RHVSAIL397ZOhchzZBZkR6FWyYAi0axy
	HOpUfcyowPpFgel7UjNZZFgcNrsumfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966216; a=rsa-sha256;
	cv=none;
	b=LbPnFHxU8Qv5tU8okezACC3i8rnz4jlsYqJ/mZfLubZXpb45wgnVuWn7T3dqMxOfQ4FuIT
	ZCKCOjKhzgCn+/3b5Y3bsmmvY8K4rzrSubZxhL17fHHT6maqSwtx9r85vXV1nlw2Xk8zw6
	2hZiR5jdEEUXKw4zy3xq7qPo8C924ok=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIVFQjqz;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7318242AA3;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BBDFC2BCAF;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=0QjluZuPaKHtRS38Z9q2BcOQuLoRsXERS1LKXhZU1G8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VIVFQjqz12sDQupe856JzKcx/OfZP2z+gTZzPAoILc3ab8XlO70bTc2FSRyQ/Nu6Z
	 4BuJZOTFCeQOT4Sykh633EuUatu8xhHFrxDnzNxfJzZuvWRo6XCphas4XInQShGfo0
	 7Y269MX7gw3D9omwu6AAEXzL6VFnVje2V+u4eSmfOjal4ZmjCLk5D9N0+Ck29WvKAO
	 S2PElj8fulNqpIwu0Yewbw1kQXQamyUtPdzyErZTv69mGlraJukD9RXhnQe20sGoah
	 6Gc4nlUAMCa/7hgZyZ2l+09w8U2mIMSf1M4oSoaMZ3haj5lPt6uOXFA/NFj3XD7Fit
	 6AV8gk9jKlAPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC2EFDEE3E;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:25 +0800
Subject: [PATCH v6 14/14] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-14-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=6820;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HoC8teVsXycmvNADkf3jUmdl9UWSqYgq6rOVfjqvXqo=;
 b=1tZ/nkNCWY6gDeefkEcLl+P+nLotnO1k29KiZwLW8FYKf3yOOLNFxstX0Ly29vLp7jKwMMeBq
 /V/AtchiM6+AAOc7bG0my7HZmQ2cs09mkcDbCONMXxBPKvl+zvbr2PW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: p8agtce5fisciqbig1yhgctfruyacpy1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF46A1C0005
X-Rspam-User: 
X-HE-Tag: 1776966215-654373
X-HE-Meta: U2FsdGVkX1/i7Ll7PpGlMBkPySvaf3nFzF3G1EQtq4qOIVOVooUiTQp8zDNaD60SS+4uTSsu2gYRG5yZvKCarKwvnFTyeDeSOaz6TixsL3MxJsp/y61vz2yskIi88xx2C28Rv5SXkSVR8u1FuTlYa88WHSyaAmi5h10b9RiRBZobPEo4tgmi622RoWlky4uf2C5MIVlCKN6rKIK/Y6thRGD+Tswt4JmJ+yMxTjSccMWucbyP4GlztL1E3sVuyGzIO12jXPv6M79gfP+9VPv/bhQOPEcjVnfFtHVsSjnHlCpdzfhEMLiG3wWP1lrr9RlXgIBSWt24cynMN4uhUU7RXtT1swJRXDaTLVI69c6hw5f6VyDi1CXJjfflGfRB/ByJvzy1KfckNps0DXoaCz6MRp+PxOSAs/ZWvrhVSTWjozDyxA9ar7Mo1LLmaaaJfxsyKvAN8JxSnOPeaBmM65T1pLx4W/wNQvWoVBI/3ySBSnupXnOd4p4C86WDM/h96KOqHw6RKqy7/cvuSDXIv1hUGQI10GgTpL20NWGRqxe10C+/ZNBiOEUqsSsCMdQnJlYeerF1A7Ch+HRRAA8/iCMaAksnncf4UFPxg6L62kHZVbx0mYwIrKD5cnWKFZJ6YMTJngzuNWgkeNB70N9mmGP7ADygO7NdUXctPCEP2eZn4mIX2jFWlzUl9Aqdv2HQXGX/J5ca326pXFkG8+gqN4XdLODO2C6E0JgAO0b2b2I+WDorJwlCn7NZgIY535O7+qvzVEW2irlmWvYwOAoiZC4PHtxJTZolJyeBy42+lLAKSv3P3P9/eU1J2JxL24rVfe3NSBvKD/A9Uz6e5ncRtL12LvqZ6zCB5ymiTuTx6jX+Fdw6141Pfx999+9p4LUHXyRnZIc01JA8TtrPy2Dn5QkYaC5ngt0p5DqjYc4P6TNr0FnSgyKVunGlJiaXoVKWucolhLLGCfUfwlYVtlxSl8b
 6PLkZVxL
 N4UNjhWmS4Sz1OKcLhVwqSFSIrR2eFn9dHWW6suhByOrFuErUt4cnmm9093o7cqqWtUBLpy21QEuRqE8PJlXP1H6XTaAysiT48y8AvAplMCbsGJl4P60qRnS1ICS/0sAGhrl93sJZwDdX1UU8uEJ0eXfF4aueAAp+7s8DBL95UxlbxKSEiy+ZXi4nIB8cGfx31+IwaWtdluD3owR6PvTxJOcWZn+aP7LvrxQzTXFEdO68Ugz7TTKMlVlquC1amn2cLlBBjgW8RIV2Y04grPM6CtvNnQwnwZTi1az1EG1OBJneRMBVV9cpj0XRkBU6Eq0Ni4KIk8PAlpLcyi+lHcB0DF9eFJhyvYDRYHImDvOIK0skDcoOTc+T5YDSV2jXXLFwc4l56BNwpS8SBQw5Th0pKPES8Buq1WQkbb1XSelvmiyy1TfHpJNdSXeaJCp4XOB0r783hMEEKTYb+hvkirgHfgr0dZ9PiDYOQtMY+ynBboeVBirsdzZ/N0anKkkwq7pcddWgYy3UuYCnPVCepqp/JrjQQxF4clu/bNkA
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
 mm/vmscan.c | 92 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6df5ab625e6a..910420f7754d 100644
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
@@ -4824,26 +4830,13 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -4886,6 +4879,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}
 

-- 
2.54.0



