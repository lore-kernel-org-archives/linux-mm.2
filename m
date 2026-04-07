Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5253EFEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68ED16B008C; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618706B0093; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AFA6B0095; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 245606B008C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1D945A78C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:54 +0000 (UTC)
X-FDA: 84631628508.27.DEE1C8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A14A71C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6wMaEo3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563492; a=rsa-sha256;
	cv=none;
	b=bevzFTFBLf36BQ8QleGmn50UWUijEQFnevjBPN8nkLUCg1IMke0tW6G8zDtmPYAlQfsoeW
	GNIXxgMhyPycYsA6f1f665kj/s6SJ9eFOV+xd1hVKmTnAJcvHiMYdgdlkXVnmSLhkowJwS
	/kpeh5FSyiiYamfZDU2bJLIfpTRbO/o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6wMaEo3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCgn41vKVh7UTi3tzbMonHYV9Lpi7YIgy9WqLSO2mes=;
	b=FxGz/2R3id/jKrvblRNf0wubaiz5QwLj62vsuuIP9k0PpANegIqg9ib14lhnKynG9PFfNi
	Q6/LGK1vyoPP3+/zaR4CS8nDbZSimg6C9TTaFOoC1uPnyPQY0zvomyJFcdLWyKfCmfdece
	pAh7PDj8hjh/8vuKesSpDWftiEHj/3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65FF944571;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3886BC2BCB1;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=VkpgFkQP9kSm8dY+9afCyPiICs3NYwoC96e7crLfYA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=l6wMaEo32KUG6A0ABd7g5ETkXEUy3+Yo/M9sZPKNMUKtPPjLx3q1AkLCPmUudMxKo
	 11qOKqetdlRMkDjPYW0MCud731+IF0J19HYqkepi+H3v+YocOaI1HJsn6O7+ChYcDw
	 ef88Fo0dj5vLFwxmlmq5IwlMvxbsRwT+r5TIfnMRMV0/NTrT4aSMwVWlkHAJkY/NnR
	 PjVa2bVhbG9fS1TAdqENDm0EMTZR92a/6os9hQfVV7Gcv11slm/B4LtHcythWOamzE
	 FbjgY4c0XKh38PycAkSCGMGa/t2uKYfDWfCGpmjEq8Za3dR8FdLDmCzlzbF96uageO
	 VZ7A9xImjAX7g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C765FEEF2D;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:32 +0800
Subject: [PATCH v4 03/14] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-3-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=3260;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=t1HUAx5d1QFG9Hfnk5BrzG1D63onxNMjgtf1TQ7zmGc=;
 b=G/LAzVsgXa9uyC3AuUSyPm/Favo6TWapBfVT01cdZ+N2E2hSeUNPHof52gt/swak2Zegh5DwO
 TfpBpNKQD14CjIXlof4cclpmFDr6LD44KvOENP/dUYvCCYezKnFfds/
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 143x7poih88wqqc1gd4n8ic5rj7xyn8b
X-Rspamd-Queue-Id: A14A71C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775563492-602583
X-HE-Meta: U2FsdGVkX1+vyFxUdRHqQxgZ9CKZnfM/p47ryxTKEfBsJTs63LBUCEFDrsqBPRFhVaBfG7W6fUva8adrKjgOae+E9WhU6HY3OY1QwbnxkhqGEPlIzdSTvZB0mxE+DcKPbRpEH7Cr1KcJ4HbIZJT8kMhCyJ2gwvi7SfqAUxahuOuQ1OExRuBt2WV3lLqMcxIBvC/Kn67bYbkSm+zqqLIC8HXBJFyfH2sMVXzbe3QtFqLxhJNxzkN3vzvs8NmTMGYXD/qpi3oMvIpJNAjd75hsfiRmb4wJihuTtqN2nV6qSD5GQI2+dXAu/swK73hM7nFPnYR9oGlb9JxnCIYAlKtpdNdyllFy80HK63A7cj+0uLPs2FMkfMQfH8P0wgZe3K6lUl8/FjkSjk8EqmEKvSkO2Hdmu8MkxkoG+S4t9dTP5Lg+FryvE8zhjbPpY8xGSTWT9Y7VrlVX4CRx+ZAID38vf1y6HzyPdIunLqPR8cOTI7rxHtQ+YKAe4JSWwXsG+Prmpwo6ENO+29GQ+GDR/6gApEDKid+5CUjziZDsgTsw4sAQ4KYNCiZWhTVFOj7QLVB7SpAbK6vTHoKMFZPpQw82bg2grP+7VpplC+jMzLearwWNe1Ndjvhv/yKETMVVWjZPVL+ZokfSZa2lNOp4xUVe/bKLepnUoK31mhrNaRAXZZ5xJJghfEkEpb8MWhH5IaHv04NAO7JG3PFy/L3nt7XLSK38QweaRaw8DAhJwxcsokrJCoEStoCJ1hHNMg6062b0xH2/0oc2vmFLHvHvmWZlRdO3PBG2MnN1bGbgqwYVcobSG+dkWdqxWEJxqe9V0BJtzA1/IeUlxqIbQYzwRanLhsEG1iGfxwldfzPXmC+9lryU8c7CHW/57PFCh6meYzERA+QUzaOaXAN0CnVPSLRbYg1oaxPqWu4odHPklcZaw3sMD0Y/7jJ2LpWgb4M5iq1s9shlO1QAsS/cJfF0QyJ
 P9+r0xU2
 8ON7X0fUmpWGax8Wak64tfFnea6QxqXa9HAXXkM7cQZZaWsTnwBpbxMBWfC6sJ0r4ZJ6y7xDmhO/ImEeuMQzf5EhkYT9bl1LWw5afVksvmMjFrmIdTykL4I9c4MMZV2wwNm5cXxZnzQ/GqsEBeybjJ1jm8pzzeJPLISPDmXbQbnmnMR4eEih35OAjc208EnHKsPMLM3MpzGnzuNDWLO+N7taFfBV31tRdJkiA2isAW/1KBpmKTNsDPpw/LTst4BIrYOc036OYTJ2EZB54OE+nFfTjCOB16RMIWEFIkOwOPMO/ViPyLbNBMyLpctKxv9iKsk4LBAaBWZf0p4tZhF2tJCykTjyaIrbtnDtu3EAVNLbne4v3sWB67xiqxEemVczcxOrN14PWWH1n3XQ2EIjSu4084c5nsRR7NK5EG3vjpwEuBab+JgwUWkpIsxCeOvy0OQBhjG+wbCPFrY5nnBLcr/HfJUSLSlmbifyiaejHJ1XcSspJ5YuNJ5sQOIh8bm7pjvEh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Same as active / inactive LRU, MGLRU isolates and scans folios in
batches.  The batch split is done hidden deep in the helper, which
makes the code harder to follow.  The helper's arguments are also
confusing since callers usually request more folios than the batch
size, so the helper almost never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f336f89a2de6..963362523782 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();

-- 
2.53.0



