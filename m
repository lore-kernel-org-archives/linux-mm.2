Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6F810F3DF8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A736B00A1; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306DC6B00A6; Sat, 28 Mar 2026 15:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15CA6B00A1; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB2996B00A2
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A478F1B7135
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:37 +0000 (UTC)
X-FDA: 84596519154.18.F5F82FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A25061C000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CKmRWYUn;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7EkMFtkYXPuvyNlQQDORSBBkxZC0YkkKNjqcS+Mvzk=;
	b=3CbU5wFY+m2FQ3iafXDSvYgmL/owNrkdbsoMfaFTxlh6/Vxis/CFLeLVJQ/VUxxT+/7IOF
	ybdIa7fbbKfn0u1u0JK3GjXDDw/WwnsMbhY1XsxSHWpDWj2cyuLcYKe5wDiMdW44gT/UYV
	fyeDdCuCF3X9cPjnjWx/fmVcySqgbeM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CKmRWYUn;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727555; a=rsa-sha256;
	cv=none;
	b=DkK2cVcbLvS6r5kHWvB9Fmmaw/JJU2m5IEIOJvIqRN7YWEBrvPDjcvIpLzfdbMQ33ePxvl
	+un/X75I8YPedUjWufQ1Jl/hlSofzCq/wJOATotfu8VnE3Oi2ha0Vr2zjETBKshlGeILPs
	s3p6n7R/3uk6T3j/NQNzR4+UwqRfPnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DE844470A;
	Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2A63C2BCB7;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727552;
	bh=bcFibXg/uzRhIys8g8Z+diQcFu6B8PWOFe7oAURNKcA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CKmRWYUnWQiXOiASqokklj7nZzO1hIJTSPw5ODIr6cnldQybfWMBzerrrSeVvu+8d
	 bwoD496oVGkM1/joBuEOAam6AWR3yXDHnu++8RBOnOLNFmqUo0yf90smaziwAIAMwC
	 +LPgFTePr/0cEeuWnySRczdk4navAQ4I7XaKqY74X4JF4mt5kIyuuD1Vq1xG/aiG28
	 D/8XEsKbZ9ozAHM6C5cNYab6wJNrkOMImRiIq2MSzICPvtrAnfmp/SgyQeEZm3nTaj
	 ySftPcOjfEw8HL6+knEPP4VISs7tvksfPe7FsNRPyKLvHU4NW9ThAAzRAxNSLXceHi
	 gQ7aSKMofpqfQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA85610F3DFA;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:38 +0800
Subject: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic and
 throttling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=7093;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=I8jbbfuWeWbYqnTbBqSMSm96wu/ud2/1QtQ5+KraUWM=;
 b=ynKU2SRkk3ghH5g5uJ/eEFepcdH7qkgb2HFXraG5fQVTxkyED2JhzXot1mQKAYfsu8H16ivic
 amsBqsVGdciC3lrkrQ46d9YrqikfmIUkdh62Nphcpn9tUv2l72U/YmJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A25061C000A
X-Stat-Signature: ujtsaqbmt39mmgte4n6z471fwf1aecxt
X-Rspamd-Server: rspam06
X-HE-Tag: 1774727555-798489
X-HE-Meta: U2FsdGVkX1/YMr9uqPqDAmaZsoF5zuJCquN40GvG6U2F+8HUXDTLXEseXapYZaRDAYNgAusaeMN3crRyyeeJn3TREJRaViT7NYgquUxwZVEQU8TGPQP4O2aJ6Oa1Nnk5yhtjxVxBNm4Xtms+EnW1/YJq4t0QcVwkI6kzHOOHZ6mtCw3J5BcLpxRFx9GMTIRQwt050UTEUY1gC15x9KPJto9iPalee+QzeO9jHwufeSc0yXMjDbsVuNHGKO7WtToZOhcTEYdVRHZOqRbHnY6Sv5D9gS4DItUkryBAKQNixyV949q+aJ0UWkzXZojrUJE6ujCqb9QxLkWf3iTTyT1MoPuUXM4APaiN+1fWONhIYLQkV0hgN+8PQfwt8S6xKLoX7Tt4gpNYHSdqhwfNLP7JUurAC/lO7jx5tndOz+uUoWUI+No4e0QTGASEKkA7+PyF9YH1CMPm3Z4qnskW0VHQq6Ck0x/5Xhk2pAC8c+p0azx5S9+zGBXy3BCpr/bzmbfKPDKl2Imt/EQ3zCqe7+D/NeFd/ZHAlxg3uJFH7PTGqBrsbTtG8PACplngPfn5XLQ287p9wKA7iUtdNSqVoA7b8TBdUJ2oZHnOtR1n8uLBG0PnLQKwLxtlnjhgG+UifOWaHTW2pcVolTaUR44QSBggTYFWo0q/Mwvr9exiQSZCVg5pSpBqLijAHgYAtHcMI4aafpogFBGoYljTGI9rGAFFtH2iI5TsWHVzm2B/4YjJraG86qDb0yBCNpWy7wMKw2HnsOl8sd2uUaxd3x5U9nhpZlcPi3KzgiS8qVYSVvUki0OCdBq735UtqOuPm6cDAUziR3J30e93S+lISjlqFBJeeqcKmpwRioL2uzfA0kESctAQlWDV27eZTP5KA+Nj6/wxCKyJiFtOEoJbXkBmNiXJK2ae2LpM47TotxsbIx1w9a2mbpWnRa1UShg9ZVu+lk+yngGaoSGxVEKqlo8M0ZY
 yfFq5/9f
 cj7YFsVoxI9QzV3bFlexKmwEIdHoxyoMrCN+i5ES1fkxS1QnHvYJ6q881RIMww+CphqwzxHHy9KZ83Ab15IKRNV5QarlQChsExvO8SdRP1DIDLnC9AJ+1PBa7lQ==
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
so both setups will share the same behavior. Also remove the
folio_clear_reclaim in isolate_folio which was actively invalidating
the congestion control. PG_reclaim is now handled by shrink_folio_list,
keeping it in isolate_folio is not helpful.

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

After this commit, congestion control is now effective and no more
spin on LRU or premature OOM.

Stress test on other workloads also looking good.

Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
 1 file changed, 41 insertions(+), 52 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1783da54ada1..83c8fdf8fdc4 100644
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
@@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 
@@ -4833,26 +4836,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -4895,6 +4883,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}
 

-- 
2.53.0



