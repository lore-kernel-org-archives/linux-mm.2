Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0E8D6AAFA
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C336B0093; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FA66B00A3; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A03A6B0093; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68C216B00A1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 336228C701
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:48 +0000 (UTC)
X-FDA: 84614514936.19.7AE0856
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05EA5120008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVr75AyE;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156026;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNRtAckyhnAZjICWjM5R+TxiggFURVFf2J6b81CFOSs=;
	b=gKSM/mPxutFVlufNL/8xWe5QBz+9PnsElRjM8Bhn1u2qZtIlRBqrXXdLyegt+6htDCgL/5
	yRdNhjv2xjQ6UgWxhMRVySpaokXLgxOr43hoNNfU/NDnq4C+L7XDhJIMToAdwx5djiASqM
	RO11khF3NaKlPdnpW8Z4kCowjudwRP8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gVr75AyE;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156026; a=rsa-sha256;
	cv=none;
	b=foSFmqvPtwnyEVv2YXLhObDKA9kfeJs1qUr1r3E3HkDyviqkdObBreGqFcD9gVYKHhNl+l
	4QqPwmAuLXdhq08jDG2O0wUxEmcQMftlporzih3VzM4BpC+Q+9nNGAMWXiT4Y7Sz9lbBol
	h3kydJp7kTn873bAPoZVdApagW/2gu0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BC4F4456B;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 262D0C4AF0D;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156022;
	bh=JoTw5aUvhkz8VaY5u7uxlkTbs6iUI9G/SuKSxLly8S8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gVr75AyEWfcWQQbAhTlTTpzLKx2kdHlCTcHTM2xLbqqgR3ZaRP5htaPh68nXTf2w8
	 BV4r2W6gNxrQeNlMaur5pbAjfppLSLwRxiV1z+V8tjfjUIRuJnsnOO37Y+Wfovxi6/
	 2gvlf52QkMhDIKJKLLj+ggJFRn3G+A8a1M2RJOn7EXIAbo2x2SynEBSu/8C2OECFQE
	 +3Uoq4xUia1jkynUjqaglnqCuE6Uw+DpP4AMowftC216LNeaRUQ7uLp3bMkC+D+pE8
	 kctf95m4/HSFTNkUWMknFxfr5YrmbwJtkENP/NzwtRujfMGrbt8T8qHNp9/5V7AmL5
	 IIYTeicS1pmrA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D70BD6AAF8;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:40 +0800
Subject: [PATCH v3 14/14] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=6627;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HRyVJumaRGlmjmg7giWQoM7fAZ1aA3IIuyfVBBx3wZY=;
 b=xD+AQD0knA28MQKrusASwXm7UtsaKfBTKC9JBS15D+CeEKYFqH1uJ/6ScHUKnKVujGRyMe3N0
 WvZa1Tu3h3iD8Aw8A6T62YMuetjGpPZWi00ERRjqfPGa5cpR9bK+k7t
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 05EA5120008
X-Stat-Signature: ib3azsc3zye86dghha44o11wcmug3e17
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775156025-99783
X-HE-Meta: U2FsdGVkX196UmBP5kWORbXg2p07y5zM/xoihM1x7SKjamsrWb7immK7zvNmKrnoZju55WLzPcoZaU6OaizKwCB3zJoQuAx1UoWOBWa49iNk7kxfQmhFU1r9VEzS9CZn1qV6mxy9DUx10LWXeXafUTN803KUQCDbQ+tXGjbG9LJE1kUZQtFqg97vtX4WSCZ+BA9JFKx9qg1WxC1RnISbnlZQA45AWqgksv++utP+HwDNJwEetfyCDL1yLIFM8TDFfXYnUHHrWfoF0mN2ddILQKVtjjMTHW9WV88N+rhKUgPDJuyzhUDZwOEZdfm+vMNNpWp4+N1viX7tR6l2qyRChYjWVj+n2Zx4VTgjTz+2mQ83jdF+9OAHJmRHWWjybQiAe52nvsZt2Ob7mC6dgYsYVA/PNvuKHv99eKFU+s2Spma5gifdV6syt3/KleNuneN5rtYMTXNesCEwRfCRgUHFWFD8IBndC3bSWNfRrL+L3QdK+RHsIUAZCmw6A3nmDsh3tUvqfXvgSwPI8AswkuyJOJd7l8CalXYcQPq+di08AxJxwXp003Whi+fHb+EWhm62LT12TO4983deQia8LC35vVFBzY5FeO0AQHzetKFjDwKD4bbfMhSZxFfrRKJcHOTbY+41PkIKNoqihlR2rRFHQ8HQ13xA4lrE9iix4xIhB2SW1QqxdbejFG2qP9VNmGAd1IZrY59GyGsVmtW8DVjZFyPCi6FjTarLXZWTpBYlPlXFVqE8K3fa58oqGNARqPAp4cdkzsWMjOdwtljQ2Z7iVUsEgAB3kmYURexJvMVFtXD8rMhJeCDCVqrDGvlh3w4mMSX4YxHjwYmCo2nm893kvdWv9jnGsM7c7XOlRQZ7v31Ersp/rh24d0vZ3cRhnmK6zF0YqS+N/Bcbb3xDxTOAuKFN9MW13MBjPDaWg44zCFZlJ/Q30kCxZoNlIDkU5040SEg9OkcP9uBOqoXJR5K
 OiTQFXep
 K9TtPLVXQuemQTmrXl5Gp5ZW6bUR8ZQJvvUHDtmF0BbYD3t4KGkdyX0ENQPZJRCiGodHDj8TWMgIU3Le54H2VACe3bZJT3wkrjelV1ql7+uxtHHMhMOIZKIKOsqnZHfhVFDCNHBgFpRimGyWNvhTqXG39nxz/FSERkf6GhMky4nFBXlRccEEMkanNk0lfPCVe/h6lbIKUqvy2WAMVARD39aMl2y/xS2Vsht4B8Fvog3X7Bk2cjFeCgUMBSnTmRHTroTFB0NFnK1eZN11OGKLo0XqnXOcjoVtFZzECpNprVaAWOPdx8r050Qm/dAUotzAOGz8H8FCPPwquk7oh/yVffF4Uxam10g8nwPmMep6/wF+uYNtdiNOkyKNuxqkaRsCtkcNByYBcWKDVngCR7d2dxiDYZDhdSw40Wa0jEQmc/rdPPQO6TWKp8u2KUVdrnLA4gGGUutKe2s2HsMSKzLYUbcXmoECs/jkEf2B6QhrqYdIBNSQ=
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 90 ++++++++++++++++++++++++++++---------------------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9120d914445e..a7b3e5b6676b 100644
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



