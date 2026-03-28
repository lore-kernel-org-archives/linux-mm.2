Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D654910F3DFA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BB46B0095; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8216B0099; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B606B0096; Sat, 28 Mar 2026 15:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC2D6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 937A3B69FE
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:34 +0000 (UTC)
X-FDA: 84596519028.07.85730E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A1B6C2000D
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb8ZGWPx;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nb8ZGWPx;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727552; a=rsa-sha256;
	cv=none;
	b=s6lfG57zx+fXT8Bp0j7nsWjtLpQaIsAhUwz0EPPdyQRv09Av9s7AWeGuuIlgoxPi0kjcxF
	YH585E8TDQwfPb53Tj3ge/4zjxMp1UnEb4DGlsZozXw09JgENjcWUlRyNj9U7efgt4a9LY
	CWSOZyxHEMErDSZTPJHOx35fbHEx59c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3dG6UhIh5A5p+Fjco0/JcJ2u2EB1y/1wpjVlwd9nb0=;
	b=hhTkCoA2mM/QfqsEkKy9fKMca4u8CsWuGIkt1anIMu851NoUArQBhVFEPjCqtfFq2MhG8E
	j+hLknarUceFinLXnOF7mNQJ6B+WrBT+cAQV3AMFdVUcj81h6Jwp9zucL94BNKLuTymGh5
	GDt4MQHR1uBSa6Klr4aJyzjaZlb5wyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA78760121;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B06BC2BCC7;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=sECggSc4MF397YOh2/Lacxd/o6F18d1Kk6r+68wxb0c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nb8ZGWPxqEDG1L38yQLEuAsDALo+VfAOYJ51C++dgxiFRhcLKT0KqtAzF+XN32/U+
	 gdGDKRAi8FzcUMCKep823Do35smfmRUJIY5sHImNpIUcGr2gRZN5KVw2M3ZQj5EjaK
	 Xef56XKRGGJJokBhwXIuXc/x12SAUxHvIpBq5Z/3xDUJGIDkktL95xWI7hNsjyhkmu
	 Yvj1ihHKvuf2yRiYWIcimIK097E/QNCf5l6HIiitSzI1OlwK/guRXMD05Nw7LrJwKJ
	 BjvEIDFOlDpB8HNQelOs8xrST9cYbQu1ChbRLk0ijyA1ukfrXUk3SFw6IXzyfHmaY7
	 /jJ/YXWNilpLg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FB710F3DFB;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:33 +0800
Subject: [PATCH v2 07/12] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-7-b53a3678513c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=3429;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9oXAEtsd+KkctSkA6zzJc0gY6moW3RMhiz1U6qfN0UQ=;
 b=HN9WBP30sd3hrrKuJwKAHlFAFwvd6vODwGA7Eb826xhii9eEYNqDL5i6qLjQoXwZiXYh4GCih
 gJOM6K37lHQBG45xgdCcGR0ja9EsZn5g1O7FPgsTxAE+5vYFcjRnzgE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1B6C2000D
X-Stat-Signature: zfkdgroy71bnsgtow8gw7t43zwk8bosn
X-Rspam-User: 
X-HE-Tag: 1774727552-66354
X-HE-Meta: U2FsdGVkX19zhlg+eJmByPCTzTPtRZvaK311Zq6ddZHJxfdwaInGrBOykScSifbpR73a5yss1hpikitmwfW8e0dDAxj3zCeZrzxj16ULhLfrYQDeGRPapQ2bZKxxhN86iG8LPecxcLpkxrexFn0hFs1pN7xFHdo8q8SLZCES2HfyATc6BZksA1tTVjQ39W0XC0dnBHGBflBOaVhHL+lsy4G3QLhzpyU377pZgQZxnrPS88SfCEowjmVZgOXHz0wXscZwDNg+p+oA3jwd0riBF45+q9GlTGBp0szgRc6TqxVXQMbnwk7R0ggMWyZ4jK3iIA2OqHn0OCy9D/x1DvYxzwyCi7nCwKnyfW4MmidQKkadTgn9xS4gMCA1p5t24KcOURkXN7//AljhbLvWK292Fo0zGfG23PyOS1HZUSuJrClPO80GDztIccrF7X8XXaLFhe5tIdHYzh3BEaOwe7kZu7H+TIYNZcFqog73LqZQLYbJcTWNYIfI3Q9m8kjuyQ8ulJVOJL14qvnZju3nO50YMdu5nAVE47u+6PTvOQWLJ7+8SboieeBD7tw93x221hwhnxrwrp7Pyd5ydOaZDGtpbCTJgBV2o4HSNhHjk7yGO/9a01mQ2t6JvYJZXSW/DrtyXxBjMEFDoi63za6boaJGehL9Mjh/Z6wbEhK8d/ORdh4UAlv/JcAyoHdnVUJeFL5VHwUb98wXqk/8Sa9QDRWbfYZ9HcA9T8jkmYiQXSQZhID0zRvNb3h4MPVcgbT7OCOcKgAFqtqw76S7a/sk4pXtJHuLZPNxyfahQaOJtOSNbJXCqPnNqtAnEwmYSsOIuJs7FT9L8NmcHEIW/jAQah3bW7qYUeqlXhEWHpZrM79w+YExlR1bSPnDE5t+cI+WBOmpobDVycCwrSyXa+o7tV01HsZxua45cledVL23U5uoFsyuyGKp+sQY985k/PXB4ZbfCWjHdLNuc9/8bTOJnEl
 Qu03QrFW
 Wc1aIbLCsR/93qEUKe4PoCPLxm1KR0NeLn2Qgy4N8BAVbtjBnevHQSj47jIYPF79na3u8aEKTpkX83tDBQoGulaCS62EYuUiFuLuTf1Bqv7iIeN59bRCUglk971yC5TV9W9G5x8H15LexG5yPoUloNLGtCtAl9RVQp97YOJb0vR6Fkwg/QpmpdX7J7Z1Bt4s40H9Witbfr4xaU0Q9VvJJCtZsUygvEYZBVhfr45+99IX1+DEkNjijNXk6A60VnNVqmHJft7XcHAL3JlWe+a4K8TwPUPUICRB509vp/RM1vKrewWrOVmDr6AEVd/Lf7lAq7zK1vzmjVQ0i6pFoqwzyIPvDFpJ0jTHm5RxuZrG48QpggOaL6ya/EeXKZHGX0uRiK8KcR4iIBHL9B176BG3OD/Ifj24F62yTMhZi1GQP4jovfvVUaqnrej79mA==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e3ca38d0c4cd..8de5c8d5849e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4983,7 +4983,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5001,7 +5001,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5012,6 +5012,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		/* Cgroup reclaim fairness not guarded by rotate */
+		if (root_reclaim(sc) && should_age)
+			break;
+
 		nr_to_scan -= delta;
 		cond_resched();
 	}

-- 
2.53.0



