Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98035FEDA11
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A27E6B00A3; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248596B00A9; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024156B00A6; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D15226B00A4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAC7958677
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.25.DAE70C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91BE1140003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oFI7UOOf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgdhlTMk42QVGVfWWnQc4OdVTyQQIZtPbwDIEY93FVo=;
	b=Ivu9KKf29VWowWNAmfgBAs/mUugdJGH6SUBRoylA17qI0cGyy/ISGzgpe1mo1XcQv0uMOc
	bJT49lTHFR24YxPe0hQ0j4FEl1iA4ud9AF+0jDGOxsRo16Az+ZFt8+CnBKjZBOV2hOEDWh
	AA9CCLJj4xAziEg4Q10zgyc0rZ8iRZY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oFI7UOOf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=GI9EmGDZ9nRto/k3qAACCMkKy/FM9U6YPFPzCdjh6ThjEbdSVC+uAKSmh9L7/8avmQn+wd
	uGBM4+D1d+QRS4klqZ70lTAgZjYW4/dOef8J9aYVDyhdX2JRFX6KEqcOnPEipuQ4yKUuDS
	2FsWSCo38/R9DfaTmwHmvp+a6lg3/rU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36B6D44403;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAC98C2BCF4;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=jYjMwGGYQDPMRn5bLK8uLhUtqGCSfPtAEbvkIWptfNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oFI7UOOfJHLv59Y+PX2snHUYjZO6nMcm43kc+lrJ4M5+5ihEDOAJCkSzy+gn6OfGA
	 EE5Orxsi8NJdmwJB64XMH+UANeaFCa4UWLOixdu3l7A54aCpeIKhTbLGVs5IET17Qw
	 GiMss7rMUBbCM9bnGxNUvjDxmUSl7lAjYx9ZWmqFUNm3LIWyadvk8aEmn+ElQ/mxA/
	 Td9AQ360YkZZxDl7+r/OWJlQmutCRUJKB6BkU1GJiZLyfrWWMW/jdNIZas3wZhntzF
	 TaTrt7lzQb3cHA8inOCP2DYnzEcUms/z0xLPFE9kko0hLyz5IQuqaF41itozTlJH8e
	 7TPIE7xq8aJ3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF47AFEDA10;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:09:02 +0800
Subject: [PATCH 6/8] mm/mglru: don't abort scan immediately right after
 aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-6-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=3429;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=T/HWO7r92IX2HXb54p5Jhi6DhOIRTUsj1BQ/NXwPbvg=;
 b=aMekzaRsdniBjd+IraV6atJrozmNn8h5TRpciswuPMrWkmFP08pADTxM66rxNk2N94Aij+nsX
 vy8cTKR6edsD3WTTNGjHufKdjL5aq/4OKmP2iolDmwPZTpYW9k0LI+N
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91BE1140003
X-Stat-Signature: mmn4djg9o9aphbfy4ytyokq8abqgh9ut
X-Rspam-User: 
X-HE-Tag: 1773774708-885172
X-HE-Meta: U2FsdGVkX180VIUPy2gm5sWqgS2pl/6V7b5s7WCaB8KwU+zTJQ41TUC5WLH37tLFPGOy+5UDEKkfpOGLbrNbruE0PgkrL1sq03f8E9jx5EHDD/MCrSxJj+gdOGa+XMrILsoaLAt8heEF9WHPaTwzyZYwWGKMp7c6bvpOG/mLYitbYwKJKxBjIHEfD/9Ra4rKYRM7SgohZEsG4AFZs0Vbbk4oIdyRR5vfGqhI201rwcR5SUWyghUxi4vX7FuxQJZx3w2QkUcvTxSqZvPNSdx6cD5iR6GEZ6jTXo0Qr2H9xlPXg5D1cxclpGKMp8ASGZbjjebndeWNwmgKqh13rODXi43XGuuK0h1DzkU03Em2TnxWHwi5EQzmL8RaSDdw+u8B84Nbx8fotxn82WPICBmPSr3jjhty/0g2/8oeXdJyhf/pqk4ldynUIDAY9L8FyVqChxvdK/Nn+7DuWrfMusM6RjraLbHiZJ3yu8wJQuBGMQMAXFTtehTr0N/4UFW9uOVA+ASxN19o3VYI8CMJEcQfRtnCiXIe+a6aYUmftHs7ZJP+vCz5XkzWtLuRw9XKu/D97zYE+OpcJgSNYYiZkvkK3f4AHeGsK2jzvtSbXKxhdGe//GF2Cdd9aJcAllzaogmqtumPlmBvDXJWSYFV0bkTUAQsnrCU6HJmyk8uq5k+JlOwA2QLRK5A2F3olJx60liJCpvYHU1Lp5lJw9gYAshJi9LUwFpu1cA1+czdvpqrcXOz+Mu4J6f7ckAuaXHnvx1OlSj9T9RL+iA8BWfZFpVOW6ek7SOt+eUjuamubDzT9f5fJtqOtmZ0g23v4wJFyGFCvwpjrs66wRNZVHupGwmIjmvPD8A93e55cVTpyPnBX9XH2uImK4CbwONpbamhXHrSTctK0dV60/I2FqSK8HliXLmFEuyI/G2aRdERn7Ai+D/ae96GUghCTnbBW5QqientFsM3KKPRGTPEqSQz0M3
 6xnD8tUc
 SmyZaxw1gey0Xa/lGDc7tCOOJ/s+iEcfXxzXH6+fH4AXNt2rAUXBmDEUA/owcdhQhKwVdSnnSXJd1kmTw36Hl6sGJ5V9hYk/WnBO3CGgOx5IOjc6H8My38XmhsozzNNQIz1O69W6DAYkf/TXPZujvnt/z5y3WQYn12hy80GQmEOCsidD46HnHMgBlYn9E/94ytN+XnZAQUl6GalkCDuqKTT4T4sYnhcoByyUc1mfCa+g6LK1gJaKJx96yzIEP5ezAwm6ExUObjbZN7ncJEWidlaQoXC86qTMab8qJ887udTnMwpFPhTRicbsNEwyVWmaC2VxwbQGWaLsiRQrPTkzDfyi4DY6WD7bo6PAHy3Zt1qw/tQD0ZNSVsb7QaA2klClVD9D6TewieAGjL7kpmi9EJpooDc4TCOpbMn8pIWbphRDUHhJzbsxU4Br1UD/+njCLlDZx
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
index 2ff1609ff4de..b26959d90850 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4986,7 +4986,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5004,7 +5004,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5015,6 +5015,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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



