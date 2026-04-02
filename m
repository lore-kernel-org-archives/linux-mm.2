Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DC3D6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1890F6B008A; Thu,  2 Apr 2026 14:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002AF6B0099; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61F86B009D; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62FDF6B009D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FB2E5850B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
X-FDA: 84614514810.24.F784B18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2840C000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtWGs+0r;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCgn41vKVh7UTi3tzbMonHYV9Lpi7YIgy9WqLSO2mes=;
	b=I1RZJueicD8busqDdUR712BMPQ2fIpWO/nWAXJdroDuft091PKINejDSv38dg+u9Qgp/6q
	bl6PKUAchVkrUKa6KVQg1YEuCtFKQAl9CkG2x79FCsDRQ9bj1qs7aGkArsxkDYKMCacu9T
	HIPHhb3mS/HFK3Ka+8BJaFdyMJHwzkI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtWGs+0r;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156023; a=rsa-sha256;
	cv=none;
	b=2AcpSDr8S3sfM2B3U4q4/ucBj7mu1lR8m1zB5JOyHrNdbMuGAUUU3HAJ/9oC7g1ukwqH96
	jqkrmFdFEFTJkuHqdpwiTfAqyNS9p1jT5dVwDevVuF/Z5Ek1ofDv9Iw41sbs/ckAGdZtV0
	qVjRa5FiNKX2yT9q2Vtbg98UGITnGZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95547443FD;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 504DCC2BCC4;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=VkpgFkQP9kSm8dY+9afCyPiICs3NYwoC96e7crLfYA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OtWGs+0rTZdlWsMw64Jz7GYlD8+ZV+Zj+xo6RoMeqkwM310pC6mv256ZLZOnjfqmz
	 vdVKqIpkqw/34k7z5IouUTzkOV189OfKk54GS4n3yLY+DzQWs521r6FM3BwdNJNQCn
	 DpieNCr2CO0R45w2DDxg/fh7Ho1b3YD9DZ1v33ZrYNzFLUe4S1tpFD5G5vVtTGijXN
	 NGn+CLwVrBphmjRm1prRYbwLPbHUjo7GZsdUqQwcBEjNh0fO95f+HDIvP787GO6ziK
	 5OnX4P/FlkLbTPFRFkTHQKDPbjaziaXuxHEcnB0YYKuWiNk6ms9oKLbCL9fE+gQGwX
	 9UItINeihXF2A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FF5D6AAFC;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:29 +0800
Subject: [PATCH v3 03/14] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-3-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=3260;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=t1HUAx5d1QFG9Hfnk5BrzG1D63onxNMjgtf1TQ7zmGc=;
 b=GOjNFgd9u+a6HEbec8EHvZzLzVytLP1RAikjRqZr9s0k06yP5i/tq4xusoK34nfAQQAD+B6LE
 PMP181WbUVHCL1WzYp0UrS49WfvMRLmOi3pDESCUEKVzbA5lYoqSf0m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: 35ornb5emz5g66tfh3dm9xspqyn7imnw
X-Rspamd-Queue-Id: F2840C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775156022-157073
X-HE-Meta: U2FsdGVkX19yA+FjnGfcQW3CosaOB87HMO9fhSrqV660klPIO2a8Q4epknCliwftlbowxMvVjfTlzpJQVem9uhW2DhCtXE3eE3ltgiwmLcUw4K0iDytus1g7lxlEFBfVhgnc1Sbv6zFmcn9zt6iBeqdGveQMmM5fKgdBBdfG3/uSxEklIE52/exGndrr0H9/WYysMpz5qnbYhj3dLFncEGHZ3bDqlUZf3KkpaPz98ZpasycRexJm+MzA8vSiizPuBL8TG+O+IQG84KOk6De94DqZ8ZosOIKMtr6BgTpQNE8dg4Ync/iZZA3ZCLDtytLrbeNmsmq/N+iv5cOUbDsXXktOi3RTLG5BOYjW4mKVkAuR1fiKiYIRmNxlQU5begBMDwu4adbhoEPVi2mLwoqvnjv7s3uX3Smvu6rwoG/DaQNjwN22qPMvORQIdwclglS9BnwfyfyE4C4PyGlCcEVdBfkp626VeVibFWrfKSBbQqgPgIsniXX8q48o+Wnpymw5e1s2fPrpZD50guQgAAK6RYFOdalZLNlbtsoaTEuB0ZhBklhU/2eKWOjQQ3CqF+FkbVuFUOl08INe4hsIzZ4MAz4c+L/eM27q1Nzv+AHO7QVq+3wYnmJO8m6+wzDKcXLhadr24UQalvDr9AD7EVUkqznHmD0T77uK9GUkYQn/mrjdoK4yvDzNIgszryfXozvOR95yHcN0C1BU62S2dDs6oUtmb0IRrF9rI7De4vSTFpqB8g8uHFTlZ+AlOXelUhcLgrlhWQ4Waznyt0wheGSCRiAzrhPQfmy0PJAfn/7B0biixTbeMUJQniclcJFxkkIkZ/0FXHbmyMk413YDHUiYFKarU52rrDjdPPFEwdCx3UWjCGdz82q3NNoeA/H0mp8TNEmWGcJEQOAXLg5F3JW3nBTbiQaGR3ARqa1wak8x8Q3iF8QEC/JboEZLlbPonzYJzG1BJ2sSzvTw2iSHKYG
 4nyG+97w
 hWLVkMu4wESjDQRcJ62kyVQ2LXNr7deQRiniSO04vavazgMDjal42QIW02fSSLnee8XD27GR1BeK9vDBKs8F4rYCnGLxFAUujnEUbzBydA1pZoIQDvi70V3mMrh6Px14mUoiop5JoHdNUw46fmQ0IKfB3MaT6+0iBqTfCgaLKzMX4s0Z5CNJU+t7moQcl46O3jmFn+zvjYzNdxtKYlYX0YSuL0hTAaTy8sGmt36KiLEoJWFJXuWCGFzvPpZZGKPJfJ+M/FJgbdk7dNBuxVVjNp+eJot0HwSaiyUfDIxUz+s07o8k7PcPLCX4wPyZiWhVY9/D3Y66Al18N+Ke8GPP7YEMIX29qQ25MYMulmsvueHupyTUrmqkx6+7CeqGqsvTqMpsYkPyRLoeJO+GVWyIz8QdB7rkxdv1oumegcPV5qBAe9Gmq8LXxSAmQJLsUfcmuoCGKTWVAVT8K7fiZ2rO4Li2U/UAxixHON/LJsbvcCg2+wmgXjNTP78dc0662HAfWamjxSMXRwrxsQH4=
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



