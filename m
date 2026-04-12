Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E18E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D794F6B0093; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57916B0096; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67C26B0098; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0B4D6B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82F138CABA
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.28.FEBCEBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9E8AC40009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oaBjutJo;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oaBjutJo;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012501; a=rsa-sha256;
	cv=none;
	b=xhro5Ib3vAljQK12JcTalYI1bqmEg/9pAiA/EOkpj801zUQt+/g/RQglSDZYpf0GUiuSkL
	Z9q+MpXPT1TJRAYLstdxRHfe4veQnqcdEdfu7AD1gSNGXQWrwzgZzJiN/0+Clup8rbKpdG
	EufO+91C9NACI9OSMlLhii4kzerhtyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yC6ZAL4lsjijBdluEjGrRMY4TDPz9eTRVzBo8BBYf1A=;
	b=oFeKHRy+ELYvsOb1ba8IXvS4Q0vje6eRwOjdkyHBShKOX8eE/O8nu8hO5iBWKm8gVxa/4F
	m0W5tSM2BKSjB1toIToVwd7HrKtU8hDZLycTxYdFWEzrWU0jtUSC93VRudiuet0Mpvarz3
	XIPe+bSaSAmOUXAm0TogzXp5BuEoqCo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A76A761340;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D4CBC2BCB7;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=Howtx+WY1RxvIrbQAsQfOblRTAE1qNC3ZcMPzNf3NmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oaBjutJoyZiL7AdLlTPYqiY/xZhPmD/fzcB8RUOr//B6lKxBGhcJ+M8za2RF53xT9
	 sl+mUYYc0RHqFHx7uFAyWHmVe9yAJjR1Sgsd+gtFixPoYUMJq/+fNWGT2uhePDIYwn
	 TZMecjCk78b+TPLTpWvPDY1jSueIMr3zLp8XppivAlf3A9CKWtqjm0oAJ2nxt2FP5f
	 rzvBMVVDn9x8QLMjauTDzsfWoMUrthJdzFT11/kthix5CNlDFtrKy/Rv39dn1x2OtH
	 vQiB0rNfBRFphssA4//rULbnj8PaZmEaNKpbeXpStgV0lyhl45owCvie4P8xmzxlEx
	 LilgyPgwB2u4Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BBEE937F1;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:24 +0800
Subject: [PATCH v5 10/14] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-10-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=4353;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nHbRG5GNajgUzGsrEyC6HM5seFNrRS8JnEpLkfa1ehE=;
 b=cvPP0SjnNQGrT2ED1jlxu4Fj0AgDqKlQbDXgwEqU9n4LsCraiW0ODDWOP/u+znOJCRlBZg7gq
 pklzMCNeBG3Cz3RRuXKxKq9aT37d8dvH/jb056V3uSeX21VAUdO2gx3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E8AC40009
X-Stat-Signature: 3crbwuub5hnbrb8iyo6camqw1b3r3s6r
X-Rspam-User: 
X-HE-Tag: 1776012501-309531
X-HE-Meta: U2FsdGVkX19ZzykOEAnSMj29as/ZKP+oPHiy4CftUkrzqgL63tkIIi4Km6KXJBtsUxObQ8fb3rPiRuu0rYz7COqjyfVoE68/bucqoyOIcOwIVFCAgSzWl+XUWjvqQZyBG0gi19CP+du9Z4j4q5Qbs9j6qPjz0d0z7gW3JHhYjSiTPPkwmDQy5FIMlEmdVY+5R31blsDIRUITAkPqChWWS0gTIyySSILHdufdE6X3yy25cq/LW4Q1qf/AWJcxXgUhVzPD6tRKuvuvPaJwl0ya6paLurmik1QjWnZwtToh3BX/YlOEG0zvHD5PnQGwNLqxKSlmlyzhfIZLv7z1ooNmAmWL6Gcus2aGzSFSh7h8BM0SSEplx/Rw3ENYlGczY/3M+Jc9Hr4mrheVJDcTp0A4bJWVlUMx+7bigU7WPMfYLYxZSnCg60vYjgks/y7sVI9+dhGmNw4cREUms9Yx4t949Z7cefmOhQENdB6ZlqZajluQtBsu9bx7D5/fLZSF9Ta+BD93nrGEGQnnPRUTCYa1S4Cv/FYdpjhabG6+sv5N80ZpQnsAf9eUYDq7Z0+FkCAfVKaHN2HUsjh4r62GDUZbWEjrPii8YAx1hK6Uutqep9QV9xaUbf68m7rQYAuTuE1q8lYK3+FG/RzdEJsFbzoKJU+q8Rlpy+0ZVvluEJ4d9SSCnqvgrMo7YtaJn1RIXmvnLaqt5LN5tl0e0POC6z6chL6CqNObLBqFFL2ejqzMoDc9ut/vlKotf81IYUmBrX25Drkh8OqhrNbFKLNlQZ69L/Fu3Zt6tqqtV/YvSj/Nf/Zbc11SNYfI24+cOMYKWp7NHXPKGpWdc4lbRyCAfWBNyd+/YacRuMXIbZd0Q9/DX+W487o+t2RpHk/fYJ+tDgKlA97TG0vxgxJnzAEA2gD15myMeRf6YZA3CddcIl1OLKAO1RP7a85iNGldxGqoY2t+MXEIYXqrQ5LuT9UfRRY
 QJitrsgw
 1o8PPo7pd1cteGhB7xKC9kOqFi+nMBaEiaOIg5/jBIeI5T4nIyFbyF6UXYfqm/qS5WoR4ldg5DM4aDJ6iQed6/0f9lh1RuSiRI9mehuk0QbE4ilRYagV57kLVdN5EfkZ3bkb3Cw0AdNeWgCVrqvQit+IYfjtHERFm2aTpDXTfApWUr9Que8GBfXlCxpN3GN3mVISrdPLeL4o9nmDRU5IomaIEHzWnr+IPs/6vH5zTGtHTqW9VNcADrGz/+LHikKZEvlXvSMMoVfBr10rWCuNDoJ5SLlmBgZqhuO9ak/jk2/naaPgwJ9W/OQPCuv5F5HDAWp2cv55FPqzEdbbcf8zfkZ4lipgbXTv/QlrqUDeF8zdpz9P0eDyLDojiBBeze84hzPEf8btLhLNMLZD74E/cCIZi9GvGbl5sAITlnvkkqGv6L17nbuLEn7RNgNjcg3/kzo7+o4VU4q6OQulS3ykr42GSjWQ7k+1Pi7iEID0Roxh/BLtOUAY6F+oOGDv7PEHlHg5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now the flusher wakeup mechanism for MGLRU is less responsive
and unlikely to trigger compared to classical LRU. The classical
LRU wakes the flusher if one batch of folios passed to shrink_folio_list
is unevictable due to under writeback. MGLRU instead check and handle
this after the whole reclaim loop is done.

We previously even saw OOM problems due to passive flusher, which were
fixed but still not perfect [1].

We have just unified the dirty folio counting and activation routine,
now just move the dirty flush into the loop right after shrink_folio_list.
This improves the performance a lot for workloads involving heavy
writeback and prepares for throttling too.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 62485.02962831822
AverageLatency(us): 500.9746963330107
pgpgin 159347462
workingset_refault_file 34522071

After this commit:
Throughput(ops/sec): 80857.08510208207
AverageLatency(us): 386.653262968934
pgpgin 112233121
workingset_refault_file 19516246

The performance is a lot better with significantly lower refault. We also
observed similar or higher performance gain for other real-world workloads.

We were concerned that the dirty flush could cause more wear for SSD:
that should not be the problem here, since the wakeup condition is when
the dirty folios have been pushed to the tail of LRU, which indicates
that memory pressure is so high that writeback is blocking the workload
already.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d63ac03a7266..8072255e3d3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4724,8 +4724,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4833,12 +4831,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -4999,28 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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



