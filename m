Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D677AFEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDC66B0095; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973386B0096; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815356B0098; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FFEF6B0095
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D930C26ED
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.02.92C1F89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3DC7114000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vC/66VV/";
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=HnMcE7XMPl+/ew7KGMhDB1kf2wK0Ft1QyHZjRnDMbn2o+vVi8L5lfEsf3n7ga22L/2l0cI
	FU4nTetwTdWJ72g5dm8tYG2pYKTLg31RDUfBj5Ioz3hluhKvkbw19DH9XBD2iCwxnqMyPf
	hhjK1xOzkIr0NHNBrzHvJZWepHC9MjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CImNy0ncnID4/0RnP+pxSpOQzjGowzFIZQL8QdHpwYg=;
	b=zz1XlM60r/AAAHwiNbZzj4JSP4x3At67C+E+8tusLErGkaBv+ZsJ1Ih4O3VYvYIr9VcAYs
	HGYzVHB7+vrGtUZbzZ4yQrrcI+xHT0HLxrECMGSd68RkXJuqreaUC51+WEi1SgToamwTjJ
	jNcfnZaS57CRhUBmcnuRgXHoD1oOFJ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vC/66VV/";
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1D5B445A7;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FB86C2BCB1;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=PYh84A53nyHTsFjf7EcHQyNYWt2bHhfXejabhh/MBkc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vC/66VV/jCGyBD8FrM4gXUOCBw4lksD3axClRDq1jvBvJtxSABhe2BcBkfvo4Ng+A
	 xcY/nZwHzrEA++/DBxz2fy0XL3CQi4GnHFj4NWAizsaMMhVkOsrDuFXWgkIA730uHi
	 Qk9FCBRjIZdOnKtUWH5ctQiX2X2Lph8dJoRyzDw8p34FanGP89AaCm3/6m5/EjwFeF
	 ZpjAJ7DVo2UpaCMjN1iyjxwbqEAQIVNNNTUezy8urK+T0Q0Q79p5LPKCPQT4YWLs4E
	 5fB1ZaCBqphB4ePPr08A2CbAzwXLCUAiI7T8hJHwXLPo1T/PKiZ/RNRjpZcGq8bg4l
	 w7M/X2gGAkbhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872C2FEEF29;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:36 +0800
Subject: [PATCH v4 07/14] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-7-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=3505;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GxRE/zl5OeQby4fP7APi2mfKz/sRAK5Lkyko20nnWwE=;
 b=scutrbRvNg/iILtiYi5oBBbflWKr+fDUWNcVgfnv1UJ//9cI9hiauvRp8iroTbvuVvlmZf1Eu
 mAG/X+e7sSDBeZnpj7+TEghS63W0Gy3pNGXTdqvCloIAafgo7Gddrsg
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DC7114000B
X-Stat-Signature: 8ftcj8k1r6gizmy5xo4uwmdps8yikfes
X-HE-Tag: 1775563495-77022
X-HE-Meta: U2FsdGVkX18Rz0/JdWSii4fAv/6/dqO4Mk7z5uHaZLipjQKseDxnSqqATyAhiU38LPnLUZ2zVLX9TUs2BDo+AzWa7huiAxRaWdJGHq8eQAl4y0cWSR4LOXV1fBxz1PYh/TNq65edRY2I61NH3o1D5vtgi5RdxppE/hKoc6jBzj/shJzWIReq2v7SNR5o9YTGn/7FCOgta9clGPJeiLlQMEZxs8GUTiy3fKtSJJG+hFPdkjCv9VhfM5c3gRl5fj5WVJ1myJOiMI9CBGrMAEh9HtATKK1Emzf64tahTsivPwDsVRel8P0InZZYYYJ5+6HsCKw6njg474Pl/YcXPNhVczSZQ/Axs/hxtj0Vj9jeBvMw9l2jX9dAWUHdThQCaspumq6rvSY+fagKEkodwD092UdLqu+85hm1Qkgt8pusd0EnYKSXAAT7M3e31piY3Do8gDhrfAG2Kh5TrZtzGlw0eY7aCPr9RLs3GrGjTH1XI6EakFVpW2eV45hfkEdeGDUU1mPz5vagTxB9IaSjTSHJWlP4vB+RmDGRrwiktmdkFte61+We4fDSinrA2FdjOZnR5Q5wgzpgUx12yZAsKF4vZWuCg4h4EAloSTm/ejCRY+U6hnUnKNNCUVlruWJAUkSuquS3SNvt6/gDfYoKpCmnMCSNEcImpOjj6f/H97vJfvDBJukk/B3YXkNhfrO3nOuizwfUtZ6XaU71zgAgbdhPI/LBypphd6AaEmSeU8eQPiJFIKvtHQrMBl1CDt4GUc+6PL3CfL+m+SdjMJ2NZLJeA7mek2BpxdhzIyg21FLJwnjIHvNrNk9sC73pFU/nTNZh+WVIDRP6G8kqKzvcgI6PO4uq4pwSEsqhX9Dsldj4rMOXojhwS6969ldEJpjnlzyUObl34MR6SbofvM9WMEjFc3Ly3CSFUMWMXmTEIan+x3QNEdbe5OES47jq9rLp1MD0U7IVnLwoMk2bCvrVsiv
 69lD98Qc
 L4ehmE8OnSFBjkeDcUNQh/temsoDOZuMpk28gOPA2Oa4NA6Sw/lSSIZ/KEnLOura8XGjqKaqgBRC/8T9FY6uY+Xm+SoAFZ4Mr/p3fMW5iBzZhkQzYlusxTyxBbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now, if eviction triggers aging, the reclaimer will abort. This is
not the optimal strategy for several reasons.

Aborting the reclaim early wastes a reclaim cycle when under pressure,
and for concurrent reclaim, if the LRU is under aging, all concurrent
reclaimers might fail. And if the age has just finished, new cold folios
exposed by the aging are not reclaimed until the next reclaim iteration.

What's more, the current aging trigger is quite lenient, having 3 gens
with a reclaim priority lower than default will trigger aging, and
blocks reclaiming from one memcg. This wastes reclaim retry cycles
easily. And in the worst case, if the reclaim is making slower progress
and all following attempts fail due to being blocked by aging, it
triggers unexpected early OOM.

And if a lruvec requires aging, it doesn't mean it's hot. Instead, the
lruvec could be idle for quite a while, and hence it might contain lots
of cold folios to be reclaimed.

While it's helpful to rotate memcg LRU after aging for global reclaim,
as global reclaim fairness is coupled with the rotation in shrink_many,
memcg fairness is instead handled by cgroup iteration in
shrink_node_memcgs. So, for memcg level pressure, this abort is not the
key part for keeping the fairness. And in most cases, there is no need
to age, and fairness must be achieved by upper-level reclaim control.

So instead, just keep the scanning going unless one whole batch of
folios failed to be isolated or enough folios have been scanned, which
is triggered by evict_folios returning 0. And only abort for global
reclaim after one batch, so when there are fewer memcgs, progress is
still made, and the fairness mechanism described above still works fine.

And in most cases, the one more batch attempt for global reclaim might
just be enough to satisfy what the reclaimer needs, hence improving
global reclaim performance by reducing reclaim retry cycles.

Rotation is still there after the reclaim is done, which still follows
the comment in mmzone.h. And fairness still looking good.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c673830f4ba8..354c6fef3c42 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4979,7 +4979,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5000,7 +5000,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5011,6 +5011,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		/* For cgroup reclaim, fairness is handled by iterator, not rotation */
+		if (root_reclaim(sc) && should_age)
+			break;
+
 		nr_to_scan -= delta;
 		cond_resched();
 	}

-- 
2.53.0



