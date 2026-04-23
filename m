Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5402EFDEE3E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B30F6B0098; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632DE6B009D; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4363D6B0099; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210966B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7F1E8B672
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:34 +0000 (UTC)
X-FDA: 84690542748.18.84C37FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE5344000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOgsLgTy;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966212;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW4zSaHBV3hxr0Mn0obFMmJt/l8Gn0VKxMYCHUqwMlM=;
	b=W1d2QOOERZyStQQicBYVIVR72uR13hD1MO6GpsEZWAGdTMbeKTyLKSLQLwaqLt5bfUSGOQ
	JfpY114Hhofl7FYnFxFtXfEtHfGI8kI3hYTIG1mW6lkMtRT8Tb4VrZkqsdlsMn2LIanuYA
	lwywpLsIdwKgq9jU+pp3UudDOhUksHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966212; a=rsa-sha256;
	cv=none;
	b=u9hav2VaLp3dlZ3fjSUYGvAZC4UETW0ByefT0reJ6SQZtPs2y2zlkCxvuUnjJqSJFqoQmv
	hZ0mHH1FMRMYkjNlEgd0U7iXJwR9FIGq0q7DTaLcxsClf1Dfo08teOD03xeTZNxChg07CW
	nT/bQ4kN7tVmtbO0rn1KXkk7g5thywQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOgsLgTy;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B25204455F;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 729FFC2BCB4;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=BLJ7pj/RWnId9OK7LjkDaHvpjcc6H/hZLs4LeAzVOvU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vOgsLgTyfdlgRsui9NlCwCB8G6HlWTA/Ce5tXFUEBB9qHsWfl/sGjgV3zhsN/HcNT
	 2SlJo+8BbM1TyZmKzlm65VXJDJuxTs5wK9nSYBpQCrOYTgopj2SFcEkGi+/ywNzNWX
	 y5m+5tzJtsJbJpLixWqAzid2m8GYpXwJQ0EvLLlZU826PZDYZpe3XkQqQpnN/w7g1r
	 KXRxucGrHJvrLmrBfdQ+Q91FPNXaftnpUvup8LukFjVwBxt4NnBOdR6SS9FUfTK57l
	 VS1wnX8dx3TnwK5DfAoGO9FnLxY2nOZo7g59ZIaPDWINWCRovh955ManZpt46LAYQL
	 DrhEwfgU+CtKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630ECFDEE32;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:13 +0800
Subject: [PATCH v6 02/14] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-2-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=2994;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pkefrOisXQDVNekKYKJpaD9Nmjz051ENbT27IFjveYI=;
 b=gkk5Z3HYypIGbeGnGIXmkrnMrUp0l1JBZ8/g2tU8tOJaF/JLsKy3wLWaipgA6AXs70CsThGgi
 rp+zKSP77WrDynmVZyyxiI5qWsAWJ2qFdU41PXZUP8Fw5Lg87cySahn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ndm8nmg3qpgutsu3rjp8daex1i5iw67w
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE5344000B
X-Rspam-User: 
X-HE-Tag: 1776966212-22957
X-HE-Meta: U2FsdGVkX1+oyJxWM/6R3JSu831WL0aRweVWnMbSG31dM6ZTylbOGi5u5PM+82Pgi0hhxy4Ffn39e93ixecjTGwSx7XT90kP38w1KTCtwycPLo4sF+JFNs+99QArQ8nZsGNsFiX/SZhz9gneRb0zu7OQaOCsE48iEL8Rqyggptist+7nT+e2A3n+sdWXRdmarfVMWQB0JUANAK+LxR1NKDu/THs6W2z+c4Wzqmop6zkEk9HKXff+q/mss62SoIaZKQirF5lxUxFKeKb5kjgU7CLqN6qbN68U6kIGCH17LUTH1rGoTtv9xfQ3oCbdhti8O/NQCHBKhSesugdVz3qk+BZ2v/GNPsKmjR2SA5Y/7LHYGqxFlGAfHGXaReQx5hCan21utt5zURH0mWtuVQub290J16JcJ+Tx9kpAuf2K/Xzy5B6pDQQTU+meJXtJ3wDUnZPGjmeTB2aB4pmMnYxBnMFzkx8sfqsQSOYqXlDxMphim5rKYQy75ew60bUSxD68yDs1ZyFNaEdyryD48FQ4aQ58ycS7knCxFtoRSnnA5uw+oQ+cP8sL1hpD1igBaRwp9thdjFqmutI84DeqtfrLvhQB8JX9sD7YFRNfdlaT2Bx2MQYzr4GUETgMY+y/v94ANoj2eDwk4C3tv+aeEWJ1O1jKaGESyFHeG5gVHelbknTC4dZ9Hb0RFo93LakCagz8ym3Hzs9UEMg/xjgcSL+HbDcad3rFJg3dUzJ0tAl4eJLmbHGyRsM075itDjhguqIo0HpNDWRlnvetMfCbVXDcc71CwlRPADwrtwUV9r0usN2w8nAvVFrkCy/fEr9prAUaWKOuxyL3cwcL6hBNjODanikaUr8kIKuo02B9YhKcSsdK9zwZtMHhRdXkUOlKX0F5jgSdZPSWrxEpVPbjMZCuO1Dm+TH0SwJhgnlzMA3hMY3l70rrq9fEu7x2i5T+9cxbljDYXuBNwjH0HzBmFws
 ooLl5hTe
 9ftDXOHFw7nILex/HPS/62vpQNZhbOygOAp2NJGSWY4WqtqKOdkvpG2mHxuyyBudFmAYkKQIS+KcsEa6+3UStKWoXXnd57ZtMz9peudcyvDWHzc4a8fNDOOMb5HQdYG/UYjg7sBo5KPpQT8oAyHdPZuXeoRq4M7UXaleT/QQC53CZ32l7J0lT+TUQike9d/BuxTRpSIBQY/jzO8dAUJXLDdXo8RwWnLaZ2XmHoLNFTxZh3iStCULwjVaVTIX+qVj39ui6BCXgxMS4yI4WgSFoyLJPR4pLKL+vllSxufZd6zdtKuXedG587n2QriCaIkLV8x9+yafmNHRDS+CbZG0Ej6B6iA9Muw6glQsNBUV+6NIS3v1bSSzAw36rhpGcu2D2rgecKMfdSv5U8BJfrBxTInZuUdqF526D5WakwVvQHddi4V6OCGH5xjEn5Z/UMyNVd6EPamG/LbuR5GO7Ad8OUpJUdk0BW77IdP/WWhvWH9cix3UN3XlM+ca8W5joqweUqne5p31Hv741ynTu1I1ueiFopg==
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6fa828c7c19d..4623a5ac6bc7 100644
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
2.54.0



