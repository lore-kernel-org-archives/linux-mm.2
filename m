Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEB6FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1384D6B009F; Tue,  7 Apr 2026 08:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB006B00A2; Tue,  7 Apr 2026 08:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7AA16B009F; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA6C16B009F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86AD68C408
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:59 +0000 (UTC)
X-FDA: 84631628718.14.9DFDAB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89DCC1C0010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/JX1guG";
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563497;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUCeSExraGyeTdf3jLMLYjlAAE21qHKKc4c9K/FYtUE=;
	b=6rHed9xwcKepP0O/v+2k1HuWE+04AI+HcmMw4wr8BSCcxrc4RGNpIIGQ5TuRh2H92JARFb
	3gn9VBbx7gK5g9E/id+H+i7vdYj8ThUmdNsXejmRlYsB89AwMRnstVbwQLvsDGyGm7Saz5
	yIgxUl2bgzd/xhmhbs1Bpr33lUMj4hk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563497; a=rsa-sha256;
	cv=none;
	b=ryTs+qjOLSLREqhQtvxvTxj7s0mkg5tua0GNd8916TnOl7wfBi2XJ5ejFM3tfmHHlRVkau
	6shflNGd/HcCKxCrGiuEza49zle1IgIVY9MtmXMhd+PKAWs05BmzYFaHJwmmsof70ZPnAk
	rVVGOsLb2fIZcDfo8ghOqpIX+AVKssI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/JX1guG";
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6314B44719;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CD46C19421;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563492;
	bh=ovatNqtznssd/gITN5eCBeKBUZKWvCBBAHjSAQIuwj8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s/JX1guGiz4MIPnkH9WWs9QcLNa/45srPIXAOVZgjNb48Fw66ozW6kbdnNOmIYpOn
	 SwTveTLrWBxgDbzfwm3RspZPM+5n6ZsoJCMFdFm/LGQZvB0Qu2q5fi5LNtE4xt7DLA
	 OjCzv3eJjKy10cjmVKXsFXN5i1Wx4UenYGrx5I26OtQF8VQboor5ZaLD0KPDqruVBo
	 n+QszR9xQeAp25i8k/EqMmFD6Qdq3DosVjkApNZ5kp3XEMaIftK1Nk84tUZ3n22AFE
	 CdVbXAOTGhPKsHA9UkVz4RKYUSkBoZ6Gehn69z8gsQi+MOp871PlZbsG7NMrMEySz/
	 TZV+YH8HCY/4A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D3BFEEF2D;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:43 +0800
Subject: [PATCH v4 14/14] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-14-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563489; l=6741;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7QHyjr50/quaZhHvOcbUKxflnau3ozYmg6LdN0uZIvA=;
 b=5Z8fDGv9OJlrUKzC10NZUWtSzDzWTPu7NVnBtOD+zo9hXGm0HDSYsBVq4BpUHAVZjMRyRn3u0
 zP+B6GJnYCBCeEevZhnrIEGrodlWr7M6dJawAaylkpM7qj72/PV5f4s
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 89DCC1C0010
X-Stat-Signature: tziae31389uoyhjobtnpyc95xedkiz5z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775563497-783948
X-HE-Meta: U2FsdGVkX1+2MeBkhI1nsH/i+JgTppQ6ZAJdmk3iX4k/3vrGx1SMoPhmqfisF/NVtofuz964ZqoiAzxEsRc7rOyhB9WAA+jOcsN8TxwYRqM4wteKXqEoQ/WwbwLcqhza6iMuILfZfRKROQbjLtjhZ5ebI7D+qJo7zGvOm4nXjWaXhjgMNtpPy/3hvBt9T/vRIfa/WzXy502JKZ6K3GGYWlxl8+HZBklGRibm9XriYpRET6ie9A77A8oBGoQ1ppSFYigHKEG0jrmtMohHMGU2+SkrEC4MTcukxyHhVGdtYNR9aFNdz7OS/qwrAZX3xrMXycZuzonsZMmpZNq3ZGaz6veUpfxqvxTeC00nMwwobcHZWeYwArnyiOvO/ow6ovJSt8EgHvuAh7lk0IWtbehOCnlxdJJ4VnPXpnWvkxDcPbiIVPcuNz1GN5SCrvS+MGwSw0G5z9dRKcWf3DSBdPFWT5aKinTOx8T4oUNb4I8SpKltTTDi1A+X1FoWhL9woREmB/5Ba4UB/AKv7PjI49Q+TGkVb1FA2SgiUIpb8masjfgdmcQjpif09Xr8hcjiwKHXgMWPNHNP50GdJM4YyVuTBRqF5EydVrAEWoXwdUPUoZ4ZfCFs3WeHH0MCMnrYeB3TV5LZWBckaL3L53LvFly6EUEaOCQ9Q0kJU7jB3o93L/fpAj3TGbInvzxKVde6hnPsEVheQ6QAzhMurCv/quv8xlsKS9D2Y/pn3trZ2DYARTfpmpimS+8dvoYgI8Svh6dq8m1uW5W5KmMpAmQQhGoND0Tx93dEmvI/a10YA2CKqtUfNTfupN8+5t8SPwQp+3vkxDHdmj5s4uUKHM1pOudgXixIbsTlsQrNJwVr/20TfsPnpvq6eFky8tRy8SD1BaM/qyasn9Jiti+T2NGeT23KK1I2rjiZxpXPqD2pezsVm4bbb4qolCClvLFO1WOxEm1uuJZU6hWPV4XD1d6g2vl
 tYa7tZQA
 Aj6ooccY5q6TcNAlPMuc5Lolj8pIZyS+w7H+kDou/Dud6mrkmk49rgEV+gtaX0LFEsv7ukr6RQnxfzDw27zfxTRb/TaystluLfgdqF2ypr/l2yppwNXym6oKaiiXawnWrY2DNEJraR2PkIMCW4jRsymN3UpbkHI1HnP/+1CqsRdhU3Ytk+K32100XEi9PtRMOlduAOdsIX2T6k40IOiDum+aqU6rXxoW9Mx/HC0LwY+xA7Cd3X9IjQlxRo/WXoLFqWyHVYwKnkx5EMpydAxsVTeoYreezguO5PSh1M59Hw4iblEkC+q/9hVNH5PdQVBWroo3WlSeMveqUrIFNc351nNwwTI1YDbGngW6oppF+82hVFBfYBgga/qVaB+h9KqdYiMc/h08UkFkoRg/EDyfcGpWa9WJCDXMjWjomIC8yMUvowazm343LmPkUBVuKc6Okz2eZgyzDvYMjY+U2PhDcefNEl2I48ZtGm+EuoIoWnO1Xz9n+GGIme+YJtpOGspJiIjPTiZffAXciC5DQj0s7exQlwU3GgDHB2Y+c
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
index cea6df51dcff..609cbaf2cd4e 100644
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



