Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA60010F3DFA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6FA6B0098; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3516B0096; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661E76B009D; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42BB66B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD892140239
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:34 +0000 (UTC)
X-FDA: 84596519028.30.1A5883E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE02F180005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MfSYtNrV;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKcTX0xzgEav0zodriSzyVoL1l8sbllIo/H7BOodlaI=;
	b=4nxrTk4V3aM/wt472nTTwwVwfKQFXWChJr++2wrGiX7p/ynqzAsZNjJtx3jxg+VPTZ/Uia
	NNY9n530KEGGTuXk6loBUHLmNQZvDs8746YEQAwZGMrlYLAgjD9eZjr+XCIQCLVFaKROuz
	1eEPMfJwBUs1IVJKefzHSpTEbkSczJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727553; a=rsa-sha256;
	cv=none;
	b=nfMllZo6KwfYC9PXca6cY6uKoaqAUQXr6kNtd5CWf3tfJrg4/eQDH4YKzDrDuRrA0CclPi
	mVkPILsMSpOpwBokSSvUQ0ewxaqJPGzedxYAgYCzt0+2+QSNqFlHhI1RQo6PffuqAghycC
	yHw6HhDxA4x/JhipwjXtt4WFodqM5dc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MfSYtNrV;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 785DE4451F;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46CE6C2BCB0;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=qMplLn8Oud7+IXw7Jqz7Q0ci6PUtsFK5BHg8NJ7v5bw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MfSYtNrVdAb9CNV1YiWdPTrNQu7qn0K5wAF1PUFmhUD5bXa8W03nZLYDK2SlbxFDH
	 mgufnpN7O3tHPWcSe9ncrvmx8B2lgTpIQrQxWUSWVN0jDte4nFlhWtO4EPs3I6RZT8
	 3yFS31+bqXuHP5BtJfoddsQe73x5LwA2TtMg06XOXrFtKOIojMK/gMusP5wOqAnjRK
	 sC4x7XxgXxwGXGnGvJMdA8rzuVpnZS/+NR50pklxzCG97wPSPokxum9sLGROE5j+6M
	 4TrGGckf/+do38KgKWZcV6VJQDRuEMY+mhXQotdu8CG5IPxDQpwG7MIgnF4SpZnnGk
	 wvu0AMO57JbNA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A0810F3DF5;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:28 +0800
Subject: [PATCH v2 02/12] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=2780;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/S4DxXkZbkmPymDZ4txoaa0S870DUGxVp3pt8OKH86o=;
 b=pAXljMxVpl/JontxkdHTDUsp9N8qbT9jY4ejGTIS5od5hogsVJMNr2Ts2tYOn2yIXqguzcG76
 SJV0Ty4ZYC2AXCeVrwYGiT0H3sxlzJDkoGBIVKBtITYnqp2xFDzeTQY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: CE02F180005
X-Stat-Signature: ceba9wq6ppcmmxidmq6ysjyd6nczcubu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774727552-159451
X-HE-Meta: U2FsdGVkX18HeqnHFBDw3fyP5RHH4hQf70uC0jzcU39vz97QoJZfLRIbEb79uD3dYprJQ+0y6FD0qYquwP1aNvR0iL51PJ0u0w9puP+SS1I2I7jKx6n6T/dfgHUPY8nXN9XGeaOPif+GTnlAmUrAcB5Tqg4sZ9WDfppqHKWFA1k2Fb8J8mHTBNKh712zKB6nRMp9MTYzoSyO5tJO8/scbLa4CAAmgLLScM+84bondLFqiXxKAFVLKB9TEQEa2MZ1Q3ysaMZut1Rf8WWTxle0uPrbrlT7ijI5deBgrSdyukdfS25MpSfvqILOS9jmDwjCRnW7YDRqRi4UYGDo1ubcqjSQxNWifVF16tgqInL4/EiafLsTtqCLhmvnRfzTB5ryGp2rlFFoti0fAQ6YrZzeDHsb523v8pHc474+9eA2BiiMwIf1oC+n0Xj5Jy7fRxlLqFaAk9W9JqUOG3AwkrH9PNtHfy2+0Y1CkPerLYmRGwALuW/tbgbwi8DoFriDkF6N9F2MvHPesMhLz70/Plx3QAHHUiV95VB5h9HuHzXfwyZHTSoWLP6pr+MFootzHE7gh734+G/5WGs2wEMCTqT3AG9XZr8E9LKU4mjLWDtrnDSBWhtiGthkiREW3G/4yHct28MV6S5EmmRpK4fV2ZadWE4hyxEXNFWzaCgIN/viPTRv0Pndr+AapLUHihKKBGMckRgtedPE9rGrqhiPo9GZCthxziUlzhQ3s0CXSW6rNtrcXju4teISJPtnt4pw2UA1fXWAVbksUvfQ4QHHi9Z3vTmRQtVGLb2acwWUgvuB0fmOAeQlW/sz1XBLpp1TR/d9FCyCtez3N7nGjMEX1/UYY8C/aUgi8yyMZJgOJAOUgVeAeSx93DFuB+HUKQknRdgsqWyLl6XHj+qJ11Fj7N8bi2Vajjoyf6V+p2qJxCkoZ+mDC4bVxq4rAFeLrFheQFgN07W/wDj6KGvcGAX01wn
 rjcPii1U
 b7gMp2FaWYyosV4S/7dZNJ2ac6VsfJl42GgHalEkesV7ALuqbBYhLvuA8TvSLxtYoHrpPl7PFxZ7f7LwY9iWtkqGhEF5vtSeVn4q01Sjq+209sUu9JDqE2F+SrH8RNWrqR+chc//e7FUXn3jq1qStchE4nEVYawiuBFw6pXHoNIFtsvt9yj4k82tkEguLHlfcxjNkasX+e2VlXKE5kqQrTuTQNchXoiFmYhi6gr4UK0LF2RH4KOJKdvjQRMo+C1xo9JyzsoeuJhKni8+Rv/v2f9ssTyMbgxJJhIr+0Ga4a5zBLjokIhzZYiMxIjtbi/K7yymlWXrRtc5r1c3mkKejGcsfLSfxGtiyV8GW3i7BVt1NTnftD+bX1jpTNGakHPg2lErawtLsPKkJhfJipI2lCEUnSdtka+m+n6BlxtOrY9rVbr8gFhoncg3td19moBsiFz+woJlSjFUsD6v9ZSk/sY54hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current variable name isn't helpful. Make the variable names more
meaningful.

Only naming change, no behavior change.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index adc07501a137..f336f89a2de6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4934,7 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
-	bool success;
+	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4942,7 +4942,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (nr_to_scan && !mem_cgroup_online(memcg))
@@ -4951,7 +4951,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
 	/* try to get away with not aging at the default priority */
-	if (!success || sc->priority == DEF_PRIORITY)
+	if (!need_aging || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
 
 	/* stop scanning this lruvec as it's low on cold folios */
@@ -5040,7 +5040,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
+	bool need_rotate;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5058,7 +5058,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 		memcg_memory_event(memcg, MEMCG_LOW);
 	}
 
-	success = try_to_shrink_lruvec(lruvec, sc);
+	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -5068,10 +5068,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (success && mem_cgroup_online(memcg))
+	if (need_rotate && mem_cgroup_online(memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (!success && lruvec_is_sizable(lruvec, sc))
+	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
 		return 0;
 
 	/* one retry if offlined or too small */

-- 
2.53.0



