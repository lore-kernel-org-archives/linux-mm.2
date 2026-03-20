Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC013109318E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB0F6B0368; Fri, 20 Mar 2026 04:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154976B0369; Fri, 20 Mar 2026 04:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BF86B036B; Fri, 20 Mar 2026 04:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E18966B0368
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:41:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C0B3BB8C4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:41:48 +0000 (UTC)
X-FDA: 84565798296.12.B1C0D7D
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC19E140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:41:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=LeVWHFjD;
	spf=pass (imf26.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773996106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3FdDd4Jim0m2IcD1xKAeykn7Nj6vOcTm39v8GFas/5k=;
	b=em1vAz59DFWF+4/PBwCkNybNooyxd4GbNCFHl/AIzJxu6N2fifsmlh2a63OmMAeLgAZ/gF
	w6FTFq8kGJ41wjQQUMHLIgLQaa/E9kFiRkAsVNdtvihVIHEDxC8g3B4UWJol36c8tM2Kex
	SQMAvxLUoPIKxBMcOpIj/Ca7Iv94EYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773996106; a=rsa-sha256;
	cv=none;
	b=yTy33wB/8EXhi9XbAw0p+55WftLSGy6P+pdrB6zZxZ8knZUKwnH0otqgPSVmvvMpCnjmN3
	j5WW82mSuSeluGzx5vJ7DTvob35bSNKoROs5FKxDVIGwaXkjVGDbqGCK6v6X3G0bhX+xhM
	SydJ2YlKSz7nB8L4uliq8BcSX81QwhI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=LeVWHFjD;
	spf=pass (imf26.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 62K8XoeD067731;
	Fri, 20 Mar 2026 16:33:50 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fcbQm2GsZz2PgdgW;
	Fri, 20 Mar 2026 16:32:16 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 20 Mar 2026 16:33:47 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen
	<axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand
	<david@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Matthew Wilcox <willy@infradead.org>,
        Shakeel
 Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: skip dirty file folios during isolation of legacy LRU
Date: Fri, 20 Mar 2026 16:33:39 +0800
Message-ID: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 62K8XoeD067731
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1773995639;
	bh=3FdDd4Jim0m2IcD1xKAeykn7Nj6vOcTm39v8GFas/5k=;
	h=From:To:Subject:Date;
	b=LeVWHFjDZjL2S6E4U/kbymvzVWPy1E95nW/Z6htCs/bzoJ87fNBe1RmB37pu/2MQf
	 AMke/73cRl0ZARIUNcHvMO1rhJeCwM4Djq/uTjJe+6Cw4hK0Y36mZHq4T0VI12sIGN
	 A+pFBDusO5VxHfh0B1gxPXqCyYx7yMW5hz8tqNOGLgoCbAiKAqCtIsAblBGHGzHCGw
	 sFlW7eY9jIZJiolHhFldo63b5/T6voaQSWXGVk0RnJ6OQP1ueK0G7cW+EX1bZGStnv
	 Uo6+Y5AAXW5dxFiMKX+cVYnSAjpcLLX4xgsABalGWa8Iz0xt58efMYrG97z3FClDzH
	 5bbK7F9G2pVeQ==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC19E140002
X-Stat-Signature: u8bjs47qwf5ha5ew449ejfkssiprxhe7
X-Rspam-User: 
X-HE-Tag: 1773996103-315756
X-HE-Meta: U2FsdGVkX1/6xRUSn9SIrgCwHIBygZuJehv9CwmQPg2WM67UzXZy8uGqg5FgwKMdlLPSuoxVleo+nbK7fkfJceq2rMpmNQSpcf24YqaBuJj2aP5DJuM3e6c2nSmJENygeNlSQY5uH/mNiGy1aKdwM2O7165hs2RrHBj24FnYIxRV/Psqham4xpLym2QvaESeL7c4Q8jjTar3R0J88/99hNBuyvQKVpD0hqk9iwWTnbqq7MlVTYqHKdz6I7BWF/mAeog6cxZwEOzvRkyYkf2vNOEw0IG2v/ZsKn96JqX0ws4jIX99wMMJlP9B8RmoqncEImFEQLmd0LxKyqzdTmjILVX/s/YdB1DJF+I2gW4Uz0DpKS04FLFe/86LdZIByz12vp4GUM5Ucpm3HPYD9JfzX1zDKWNxw83F4vsZlFIYUneKN7BhZ6H3MnC/HDoqs+jlOXTI5N/rYv3+DVqJKDtP/qgJkdZY3VXH8Lu9dH6jYTByEcXvgHUlq9yaYgi7GmYEL6kMXo3ZhiuSSXXrqHWzNpaErWTDcLZnKYHTIhxLWBFYRrI5f+3lxtwhAqLRn+yJHq1KR5/LVnvPOIzaXAQrg5O19vReMTsBOsGDV6/G3TTWehcGhIKrMPAAC+qXYdRY4DCQ5JX//RHa32Mv166HeeHnnGDXw3EA+UIRNbNSVXsVhGlcDOpoQfooFJ0244K97wz0e8ZLB/q1Sr5Q7prF8bSQPlCjU3SxyvXKxDRd8Z2KuRUp7hjgMJV37z95J49PrLshF5edeKVeokhm19dvnewmqlQ3Sfe3wtT0SAjvA1fm2fLna0kycteGMfY8cjnaNaVnJFy/69bWN/IjBIIGhMXt6XLwffkC49vL0hpM0byN8GzhgcKdPdMsvZ6+iDdONVRjcvtyiNbwLxZj95CkPmf1b2g/anWuVo2tpzzSaSz5meL/4RGcAfMTBGA3rw3AIGKFdKd5Z5HpXaUrV1+
 mROu8PEm
 YnlT/Z761LRpDaBm2f1ImCcAounI/JhTGG5ffB/CYsDYa2bUjOJguVcaa94hYiRgSmcAeEW5FQGdixZ9Pvj1HkTT/SP4lmQxw/+JzW/p1gonh6WD4lfYGIsEMzdNePbUdOW4cideHg1cWtRBIZ5ib+c4nrXsa3QHTw0Vge2Sfa586z99khTHFDtGfvfMsHgLvBtLUF5awdu0QTKS6uUni5BkOngA4C3mCvsAWZB8ceq44NnSC4svPyt5ZApW5ty2bXPQU0YzOimv34UttaXk+Af63mNPARyC7r5NahG3Yin1BVllNz5QdMRThOBmcczzjgDEOF20VuDnPt6iQQzwUZaCLOQrrEu0z3SlZ+gjDJxw+SAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Since dirty file folios are no longer writeout in reclaiming after
'commit 84798514db50 ("mm: Remove swap_writepage() and
shmem_writepage()")', there is no need to isolate them which could help
to improve the scan efficiency and decrease the unnecessary TLB flush.
This commit would like to bring the dirty file folios detection forward
to isolation phase as well as the statistics which could affect wakeup
the flusher thread under legacy LRU. In terms of MGLRU, the dirty file
folios have been brought to younger gen when sort_folios.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 103 ++++++++++++++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 10f1e7d716ca..79e5910ac62e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1103,7 +1103,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct address_space *mapping;
 		struct folio *folio;
 		enum folio_references references = FOLIOREF_RECLAIM;
-		bool dirty, writeback;
 		unsigned int nr_pages;
 
 		cond_resched();
@@ -1142,26 +1141,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!sc->may_unmap && folio_mapped(folio))
 			goto keep_locked;
 
-		/*
-		 * The number of dirty pages determines if a node is marked
-		 * reclaim_congested. kswapd will stall and start writing
-		 * folios if the tail of the LRU is all dirty unqueued folios.
-		 */
-		folio_check_dirty_writeback(folio, &dirty, &writeback);
-		if (dirty || writeback)
-			stat->nr_dirty += nr_pages;
 
-		if (dirty && !writeback)
-			stat->nr_unqueued_dirty += nr_pages;
-
-		/*
-		 * Treat this folio as congested if folios are cycling
-		 * through the LRU so quickly that the folios marked
-		 * for immediate reclaim are making it to the end of
-		 * the LRU a second time.
-		 */
-		if (writeback && folio_test_reclaim(folio))
-			stat->nr_congested += nr_pages;
 
 		/*
 		 * If a folio at the tail of the LRU is under writeback, there
@@ -1717,12 +1697,14 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
 	unsigned long skipped = 0, total_scan = 0, scan = 0;
+	unsigned long nr_dirty = 0, nr_unqueued_dirty = 0, nr_congested = 0;
 	unsigned long nr_pages;
 	unsigned long max_nr_skipped = 0;
 	LIST_HEAD(folios_skipped);
 
 	while (scan < nr_to_scan && !list_empty(src)) {
 		struct list_head *move_to = src;
+		bool dirty, writeback;
 		struct folio *folio;
 
 		folio = lru_to_folio(src);
@@ -1749,6 +1731,30 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		 */
 		scan += nr_pages;
 
+		if (!folio_trylock(folio))
+			goto move;
+		/*
+		 * The number of dirty pages determines if a node is marked
+		 * reclaim_congested. kswapd will stall and start writing
+		 * folios if the tail of the LRU is all dirty unqueued folios.
+		 */
+		folio_check_dirty_writeback(folio, &dirty, &writeback);
+		folio_unlock(folio);
+
+		if (dirty || writeback)
+			nr_dirty += nr_pages;
+
+		if (dirty && !writeback)
+			nr_unqueued_dirty += nr_pages;
+		/*
+		 * Treat this folio as congested if folios are cycling
+		 * through the LRU so quickly that the folios marked
+		 * for immediate reclaim are making it to the end of
+		 * the LRU a second time.
+		 */
+		if (writeback && folio_test_reclaim(folio))
+			nr_congested += nr_pages;
+
 		if (!folio_test_lru(folio))
 			goto move;
 		if (!sc->may_unmap && folio_mapped(folio))
@@ -1798,6 +1804,35 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
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
+	if (nr_unqueued_dirty == scan) {
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
+			reclaim_throttle(lruvec_pgdat(lruvec), VMSCAN_THROTTLE_WRITEBACK);
+	}
+	sc->nr.dirty += nr_dirty;
+	sc->nr.congested += nr_congested;
+	sc->nr.unqueued_dirty += nr_unqueued_dirty;
+
 	return nr_taken;
 }
 
@@ -2038,35 +2073,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
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
 
-	sc->nr.dirty += stat.nr_dirty;
-	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-- 
2.25.1


