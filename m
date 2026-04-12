Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFD4E937F2
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BAE6B009F; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513366B00A4; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429166B00A3; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B55D6B009F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC881B91F5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
X-FDA: 84650486928.30.04FFA64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC60D14000F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJ1SD7T6;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiVP2bP79VgczXdbJZ1barnyPYw7E2m0JzwZehgqZJg=;
	b=CbuPUPW7zVdp4Mx3HbpOBqNo4lf5j8C5XxqZKDbt+p29ZO99w6skDYBQCCJ0CJPf6wIICN
	rzIw59aPHXcrqLZJCkefl1fBJqlh13Mi3Cn9wobT+plThf1zbc6o9IJcPU45WlPLwzri9E
	UvNDUzxg3vJj7bU9kOKC8RqyzNobLrU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJ1SD7T6;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012503; a=rsa-sha256;
	cv=none;
	b=SxXLS6UDHLnddQIC659ZlSE9Iux0r9Xxwu9jjGk6QeNKJ2A5HNJEwGHZeF81KpE0/yVa9p
	993LFcDK46DwaK+SkPX3HbELFRFQKKyGIQkGIDlEI/GBPzU/JUnPiqWplRxcdJhbG6MbcU
	1xXggMChZQigIoJMa3badmgzVEG/xVk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC92061344;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CC60C2BD00;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=dA6z1QpGlnN4t7Dr9dhJIinRiuAH8kuko+RPRulPJfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tJ1SD7T6OvB+ndRzlzLogjl2YR8a3FpkeP5dXARSV3QUtYRK2+pt74WYHCdONIQ6j
	 Pkq4v916u/Gi2hEigWAxbshDAZc3XdIgUIWGM2RPrO4LDfM3wmSbaJo/CbtfNCN/TZ
	 LR007nO/IRDDgt5YwqQI/C3rrYOJ7tFVXflf9p/u54KAereCACJqW/Jy2zRGypaNnd
	 eDGU9SvssVIAiAWyFVgGLKK3E+nu5d44TLUTccFoloJrnX3AAE3l6S0bFnI6fHZP3x
	 fvog4OkNcV2nnRNHZdVKwC5FJy2G8MriCVYpKDNyA9qdPcgU+r78Vq5JWucllqVCWc
	 sVXUFDH8n9Szg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1344AE937EE;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:21 +0800
Subject: [PATCH v5 07/14] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-7-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=3560;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=eyt/3rbFbCzIlzaC3Pqb1f8uETg5r3owZ/Vsdk0rmM4=;
 b=gL76/idDwn3TVYTnnU90LhS9xqDoJjdRmG8OzvLF9RvRZlwosZiWHI8FvIJjTp73sFfpebQOr
 SpneHHQ1n0WAM0qSM4L5x9xfhNHzWWdLXHoGbpsVbclp17uapXjDIDV
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: dngaimipzxsya9o33xga3uchbkgdw165
X-Rspamd-Queue-Id: EC60D14000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776012502-476326
X-HE-Meta: U2FsdGVkX18zmj6JREIh9kofLWgv1qQVr0d1RQ76xDwPl5V+1yyYei3Vyzoaugv2XA79fJJE6vxzzevQx3gF07/9zPBeWI7T5isM2AOGUsiW0X0SJLRDQuFUqTsZVSE2kY47ChNreYRQPFHDSQw5t9ZHUdKrGPK6EIBLrdkERgus+WRpWujYxqCoQwDcPNM00alDdsraec7+9oLfd6JAG+52+fsZY1BS/GpB6J+GmZLna5C22L0fV/9CeOeXRmhjHmTHxew37eu1ePcNvOUrtwlp2bSnjHAJhlCUb4n5jpoieIRocRYidnXCztdfh1VvBGixHBp5TXYRuNKGFUi4pvkr+r2tQwJs3zZv/MXEd+pwvcMY/rzS7ZuvlnzEqwy/25/Ar4uZYHXhQfor5LylYg/V9H7Oq82E0Voc/ZFOEGDdc8iD++rHSPEoR8yLkTvyRrPeDbInOPuWocUz/pCCByYwE2f2YH9cckEwKcIzUEglE1y/ZZatyGuV3NDtLdZ+WzIoIN1NEdjCSnrMuhHfDL37wRxihpn9WJ5epgdwn1ihvS0eSSEaTU4nyP+HYl0F9c44QyYbxhfdn30wPcfpbM6naGlOc7FoFHTGp5RB3dSEwtWAyR/iVkAHVekQFBZnUN6hSmkZk1YeB8lolc/oLlAGzVtwIie21YIlkQIySA6FuEdRAD/Iw5Q2fQqaGS8zQzPtCMTpf/uWl9DxpYxzxA6omh9TDxou7CtC+OdsHiuFgL1uMdSzoyILNDl6f3SCSpeXM814D3cSFS3ZQyjfKBZTr/xpve3SjpI5qwWad2VTQj1wGnPI7lHaAXAmNsGLOEgAVu2NTXCz+xGSsNC6rxcGV5RyEJxYjuz8z0xu0w94TSJvgYvhA0zAmQVK2perYuxtIeUgxRfD4yNKvf2aBMRQozl3Qhl2b/c40dXAkQ7nmgIpPoFErd1FQu5aLBOWicuczf7yFXOj+YtDWkU
 FC6Hpq8U
 tmIfGFUa/at1UcCJQfKg+U15IPCVDwGnjeX4iUY9fYBxu10Rf0Vr3WhTf9X/XXCLYQUdX/0NDGDAC4C5vx0/hYsXo1Qo5QkIKAVPoDdVYYeTj/Mr2cylpVKPAzMplgVLKXHSl+HIm1MbDWteAsQ9AIAxNxnPo07mD/ai8oOWhPewTUPzl/vrjAO2/+KNxTU1QwHqTXstRXxvIrtXb5K4nhICJKo3Cim2WtQdn4AU8eGxvOf4ctODhFkd5TwUajQHVfxQjwpHDO05sMGd4p01LSPxpVpel0YceCeRjPGDZRfO/52wULr3IXmKaQTNmu8yOOW/2maPC6+WyNfyL3OXCEq5tQYcpnRzmrB32BDrMg9McZV8QMoYHJwzx90AP1GejbrvfHFtk+s1H4xmiAcV9Rv3k/Lc058i7lBiiNghBeZBcRurpT52odJHyfcQGQdva//ktOBggGYeW5DpBeaP/wtOO236cMjcHRqQrVgrwUS4PrsE=
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
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cfb10052e350..5ae6bd967b17 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4984,7 +4984,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5005,7 +5005,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5016,6 +5016,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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



