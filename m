Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03EBCFEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE8C6B009B; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508746B009F; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299D46B009E; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04A016B00A1
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A58161606D3
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.03.BA3457E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7910C40018
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFgYac8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=BeCGnw6juzBOPBXiubgnaZc595+XzaZpQ2AaTfPuJCWoRP0zsvLJLF0P9BLmCNj+mTQ/xk
	Kfi9FwFiIi7YyM99Nmyv0wvxHr7lJ/vOwZYTEABsMLG+r+0acDqmnCXmtsxjhcim8+D6UJ
	m6OWF+c63CahxUBFloMt9YeKPgFQRoM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFgYac8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAR5Aw3cjh1uNeu6XVbs8nH0KAGcoSP4GipedfgBFMU=;
	b=gaX6HofGCZIlfBgxDEDXjuO2j7SApS/e5sqf3uSix0rPdhMLkqFZF/i+rcR5sz5YllrPgk
	1I//ignB7cn2Z8CiHGzhqQeck3/3yYKtwr3BOofKg70C0dxwB1k/P2lrmbMYqoIbLVWTe0
	SI+3Mrrl+05X2U+08yloTCotK3y3igw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04610446FF;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9FB9C2BCB2;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=6WJ9Z2fsnLq1GjpGSfSI7xNSBoZJyBY9EzWl0am9S4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mFgYac8WDbT3YK3ybKxEdFULRJJljQATksHlISvgxQMqi8x8XZrRLhON+GNoXYJyZ
	 3+BG3Isnr8tzCCy8j4FPbc2VKEkQXhsRubue0Jykj6lW6lul9me+pii+A+WdnizbXM
	 XpTsx4FBitIONumr3EF+Lt+c70OaXyfpjw50kiJFFadBbAmqyogLvxSgWZ9MC5mII4
	 9FG/6wqhPGssEGBypCVpvCJaS9dpfphH34mDqm1NWZ8ZzqBvZ7AnIGAFOxcBGj25Qu
	 xvRJm0n/NaLHWg5CDeCQdElkuhKBQkoxgolW376Nf4zjHTHPHPDnV+qsOGbKSWqAVK
	 zHHrEhP8BMq/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C70FEEF2D;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:39 +0800
Subject: [PATCH v4 10/14] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-10-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=4353;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=juNZ9Ne09rpe7JhI6g449eQEPulp7krd3JvDjYpqUDU=;
 b=L/XappBjZIy54+yjygXQ67LinB3SJCAvvPc29zafvIYJNA1Tk0die78KC81DRXsYP529ZfCc8
 jXhca+EjNZwBVwzg4otuXxeJb4cDhQBfs0puB/5JAoc+Ii0hClajPbb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 7910C40018
X-Stat-Signature: mbib36urbn7ozkc6s54x6ou1bqz3m5oz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775563495-477176
X-HE-Meta: U2FsdGVkX18Z/WJgg6w8prM/mPFYVBWa3XAciCmyQfecwFcVOdEGmFADqEkG4nT9vf/YOLDDGxKi+OLYHJh9SpqB160qjSkLMV1pm8J4OGuzxXjJXd8fw+rsi/s0n04OQbMPBbz2wZT4a9RwgCxMv0IPUn8nVu6IwmhKidsWqIIH6Zg9YUhmu3334OQdIuUyewX0zXw+sxs5/1ixWuMkjlaB1pZT2HgZRXutZ1K4G8oIkTEEmT+Kp6JM8clrEUF6eFYt5Zm0ilzD9lR6S3djb4mg9YUttiCzjuJ7HDSrtv/JjNaS8XlHrvBrRjlyo7SZgzmSFNuoqVpwvEHENuVxwtHL7IWOYP4pGP1/nzy+dt+d2rp8Eo8AnkDqDY6wL1MjYGMqtfUeJ/MszaALrG8xehuvwdxg5lqxMb4DAFt8CIzrw+CTqcos8//6hPsnRTy5t9IroxooIG4TthmO5+Q/umys6ZJEcMKUAnx6qa7lzDTaHIrxP+1xgmujWQrHCUXLFSpPBSZ/eUtD04oFtgjczooAxTOscn25H9rfz7mcfL7s5TbUfZt8VzDCGaO9KW8T/bVGEeJ2MhmptAwkU2Rk/tY5+0nO476k3ed7G0dkEuHIHuBbEHYvGdb8uaVI94tmvlLR2feFcd8FFwTNwRDizwvnqVzptU/T72PcsO5lUSaTxMG026HSSKN/yAuoaBtAcffMf8MJqtidFILbQt7lJxJrz5Sq8lHXQg/HtUDFqvWW1tQBdT0DPSWZPSOJri2wYLj93DZK/Z85RSsB3R4RnniTVbHw05FZFETVlYcXxoJD9aifcYLsMJboLQzAaMfvu51WekIS4iqSGKzICZLCufwk4CkKcec882h6DzH+sLmRXlWmTdyU2CIdrzZ5l0tTnW577NCU6IOnGedA47mIQuMKbdSrKN9DoyRDe+ba2DVwIZjY1QKng/ryxnMsXutGBkD7MTp9tuEChCTRt9Y
 vr4dEoXq
 g8zI58oV1l43MQGWLl7swdkQaoacLoaymY22CW7G/5n0922iHZur7fiQwQYxqm+gn/PzVFLmeLYOYlHzc7vOkIcdZRnnnRULo6mLWZYxx3x5jhL1ntAp/6OiOrzxR2SXCqhOrqkzTU+MkiHGd9qWsp+A0MBjeSGFp6AroYgrhpgRdhXivAs5+CckIQBhDzZlE3fyhxL2Dv7uHJJN0VJUowkWeJzZooOXx/ScD9c9ekGU7aLc4MyzF4eSTXLVO1MQfiG2f3FwnsTudQZYjajse4nvwS/H8vE/kDcFg7U0Q/FtEU5odapVYHByWteMCxwlwUT4N02LumSbKaJyY5DqFR2B1w8QO6R7QbgjwYUklt4dy5f1H7kJebvyzTzUmgzwAtsSVeOAwpThrw6LrGG8eQlQyZua/TIwdLMrJmjoGI+mbr/3kPVEVCe4Ch17TcNkTWEbgNTmBR4Xw5bmFblJjkOfKwPspWI2Z9xkesIOWAxLURPThHSVMdTURyHy8tABpHUbY
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
index 2a722ebec4d8..23ec74d3bf6a 100644
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
 
@@ -4994,28 +5007,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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



