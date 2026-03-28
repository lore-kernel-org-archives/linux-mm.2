Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2390410F3DF9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E147C6B009B; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2176B00A0; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921196B009E; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6781A6B009E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A177136829
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
X-FDA: 84596519070.15.DC5642A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 299FE1C0004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHpOUNrF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727553; a=rsa-sha256;
	cv=none;
	b=HjQy9ClHrVb/yUeH3lp+T35GrY/h7LkAK1QEEi+tV7CMZs5E/MEM/6VYzYNF8CmLLja0yQ
	H3N/zAzTqsXg1QeNwxfcQXAoXlSTD7W0ldLrCY0ajm9Wh5y8Fpx7bPUDVhZrk++l7bdcVp
	gyoOB5uiOpEfCG71i+/x5gosTkvcU3k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHpOUNrF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vI1OS8gkIXnhJ/0/mTHp7AORY22O60lKsh60Htt9bjM=;
	b=hG4hv2r2Arial+Q8Kf8x6kl0hp/nEhOUPVeFAi9ACRCifOKTUOVMcaly32VkIOXW2fsx3d
	BO7s34xy+w9q5uTzDTgo6b37cU/6LyyZNFrDp5wyTi/WxsXbAHmEkd0UT5UHf+u4fW8XXT
	d2wF21+O5Ly/6kXocEtBQGFLAj1eED0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7E444459A;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FA35C2BCB3;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=V+u/1ghTYrgsgZAfHoL8/JWPdvg7AFyTZRkLhwRadE8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HHpOUNrFFJaqCL69NLU86O/jJ9w2xAaAjGbTCQ7OdmuyyvOBCb6yI+HtYo3lgh0rD
	 w2jFfUSnaapZr7GPScDbG41DXMpSSNbz9aen++HR4SbfqcVLzSX2X72fb45svUC70Y
	 aouKEhNmuU1px3JbsChmNZ1lUc26NSKAfY8R+jXUd+0oFdb9hG42873XpEeYD8vfQn
	 A/5n95vWQtWFMaTyGciGiTc33aUYLrQyFyEcsp/Q0W5AmtEash7RmQ453DsUPVmlzT
	 ke3wwlzLBrHF+z1NdQKDJPc4PkQk0+Tik0aPNAJbvYwaFkgocG0AFjUeTC03IxfIss
	 HTtn7HsjHIJbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC8D10F3DF8;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:29 +0800
Subject: [PATCH v2 03/12] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-3-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=3157;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4QFLBbTOMAuh+ZOeAXX+ybk8/f1xj2wdgM33A3nTdsE=;
 b=sb434GG68neBgavvN9RF+c/IZlt6aLeFt5v1BLAVw88W8kUhrfTWqgPklM9E2FF+SOStm/2tW
 g4HlPTF6IdBAKLmenUvKBiUiE5/2hi06XqPfY2dbZ+qyx02+g3i0r2m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 299FE1C0004
X-Stat-Signature: rwcyeqbqdik9sg76bcchfnbttpyeyigz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774727552-299866
X-HE-Meta: U2FsdGVkX1+3PDNCn4iX4PFY1bAi1soqO87V1+UUwKU638S3gFHrAof5HEkJc7dDKuYht7QaIWwGgGA1pgso3hQ5mw28vaFpTINQ/LB1/8Rpo+XH1cFYnXADqIs2yUWXckDDSOaZm4b3X8crsE34fmlhx5D0/vKnbxo+BhM+bjNwYpebc36GXT4ERTDtrPv/oBL7Gatzw3nVUJF5jQhf/5r5CCdBiiBh7xPFD0s5YgZTL03Cx+NpiO6mCr/e+0oocBL2v7TPVv0QsuGxJ3Vpc9qz8EfqvHt5+UdGMAaUd2JGrCJKOTg78mxjNWMvfbAEDc0/3UGQd+JHX/ygjruQCPtyuc321eg8tGmKaik8Aq91W5rwFm4/Blp/3Ue0V9iZDPugj34oi1+TMICVhKzgrFo1Kheiq5HqfggbWDYt6F5AMmP7SkLih0L8xvPttar0W9eK08Z4KuM3umfWhl1jo4VHZVxPChhEQW0/r/me3Dlfnx650AoBBQp6UI0S8V+UNUBqFwiaNsWvPYu1dsmeGwf7MhLcoMDgh0vLVWXmuRlVjttU1UpLchSvK38kHawPtOkJAhJj6mSccQwpattTyQyeQv4fS60df0SIxI50Y8LefKEN4KzmGT1ckR0LJMr31nNXumxiTG9DxPvtkZgH/CP6D2kDyJtGmLCDYE62ScWEypzrY+XMju68xPuRqgyRhYGgteCTbFRgoh3+D2rApEJk7MjYBeiSEpcUXMlbiN4/3HeTQYekF1WMhi2Mrx1hiPoi+iUWxKj0cChGIlR/XzrU3kBIN3O41rgLNaNAU03fwMJ2XiCEIZEjQIXOwvnh8lxtwx0jMAjcOa6kTkPvpAz1ZFA5s0RavOr1pS3Hx2OTjIF09dhLTalTdD0RJCnV2XGYonetvr9fQzCe9EuL9KV7M1muwBQVBvyCNnjIZa5MBNTlc9S0skJs6gEIKxrP44VzLk1VJ6HEiiCQh8l
 2MP1umgA
 MUw4r3w9SDAmwXGIgQt1lBOPKiLLs1JN6SD2pXywx4zLlF2ar8xuz/JyQxv2hZlTNZH7IBeuH6PmHTgq29oqTmQ8jgjAEIPWLnltpy3ZfeMZtE45sIZg/tBvYMbfAqCO4Tmas
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



