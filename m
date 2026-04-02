Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF765D6AAF8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC736B0098; Thu,  2 Apr 2026 14:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117F66B0093; Thu,  2 Apr 2026 14:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22736B008A; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7E36B009E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51DA15B708
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
X-FDA: 84614514810.04.533BBA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D60B40008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPchXNEV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hvh4rPpoerpuei0LbKrqbGVGW0I2ccIfNMxelzTRq+o=;
	b=QWmZ6vRyGNzq/2dV16XIf+nBCLWQCDN4xtHdzQxSlTJulsssyzM6RsAmz8Ted6fFd/dVvD
	tgmc9vhXfVF/CizZX6i9Mh5VRWgx5ER5VwK/lyG+41Lpy1cBhm4z3PNdKISHh20BKFww1B
	vV4x/h8rh1YMcP3JjlXVCfGTX8U0bgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156023; a=rsa-sha256;
	cv=none;
	b=mlFuRGMRHY+MsfYwWlIGk3leMN1Rkdu3PcbieR7kYBfoP9MUroIL2rBRLHJ2/Wee+2lT/k
	4liR92jvmc/VCjy+8HDYR8wUKrr8n0WC2fGkLkoO+vFShncmzbN16xU5yfSHPhBYx6vI6r
	73ue3pyKa2H6uLUFOaYQgCWK76uGeWk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPchXNEV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC1B944482;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C56FC2BCFB;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=EATGoxb144ySghfszsyByP5U86/ZHl8CVCI8i+wfQTE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sPchXNEVBkAynbKsWBA0BhCbH+FoYVVoxz3JSWFEi+VIlKhfjAyFjmsRAYzNFpOhY
	 8cPS6Ou/23phVRazFFz1ELEmlc5TsaELxyGghrtTafZ+3QZcEg9ly9NzExOQdoFOVV
	 KghmwhzkXAIs+Jk+Oruxxm8d6L7LTO6BjmU9gqIO/LzmbVvRBtXleWsr2QPrkZh6Gq
	 tbgSOl8qe06t9Zdhw+uh77i0oAz7uYE/lm+KZ3FHXlTjktVDaPzhl4TCqPmSnFO2dy
	 vg0aOIpzNiLYnP17gjFCtgYqsnspkmm46XMGR333krO9k5e6dJSx/VUeRbQBFY3vUh
	 ZEKnu0A+w5Vbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911EFD6AAFD;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:33 +0800
Subject: [PATCH v3 07/14] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-7-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=3449;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bSy2f/NXeY/jTEGjpMc5skrp7OityVUKdYtvXUwM9i8=;
 b=QnCc+Y5vPX1EtMTnDjPqM98CZyYXa7TzJ9o1gvPr99U5A7mK5FSBlop3VqXGnX99Bxl5JRVJd
 4OapmGaqoHAA3OGBA0cf2x/09kPXxW6LXW+v/C+H3lSS/MVsGNiepHl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 3D60B40008
X-Stat-Signature: 6uerir6kaashigxt5osko7613gic1azp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775156023-115648
X-HE-Meta: U2FsdGVkX19cQEIkjXNkf8AxSFCWQS2NkJaFtoBp0GeB9P5I775DUN4yKnBWN0VlHVDrXsCPn86XRkLdG9UZznCoqRWEtUBoe6ceD9p8ei3VhIW6npt9cI4kV8z2LWQV6x8QYoSBO8Wyo5oug2+qArvs7MKPFJosxEaz9nEXjJ26lq7Wt84r+sZyVNYp8KAquvRuxTuMXf0XdCL9dV9+LD4APwoKMDk7TkVpzB6+X8rOky3Qtny1p8X7E0krn2q5HUlb7Ya+t5I2FAeMPTMKTS0IRkmM6nZ+PnjMalunc/50UJ7YyvVl4dNrbzZjnoqeKuqgfG/tRjfqX5dYEy5+JWr97VZVOQiJie0xVMcQ3ThwjSMphpw1vGo1ez7JJTa9AdIZqK6slkvlJavJ2OlcgKo6KDf56RSt2F7hW6DSzZP5R0SHUIopDGpjUkJOdOn+Qez+OzJW3RWs6A9I+eaeHn3B+b6ee8loIc6z0oLje0YiOe8hBDe/s7tmshKgpusbbbLv8Zwf4x1exvWmJ0qM7j0lYvS2c4L8SC5P0utYJfKc80ZCL3WMgKoy+pnLPxZHR/N4yD3Q2PJXjHO0ZxSqnZk6C/PcNatW7ww7E3JCwQoHQ4grZo//I+ezdnz6X+l2dflJIA2QzCCQG+TwaVZ909GNhmC9Jq5Vh5tM42RxfijVttI0+GjqZYnOmmt1HL8vqe+kmh8BnuVJNQjaa80gv1f4TZddS7aCy+KJuDkOOdMCyJELtFC99eldeNZCV43jEINk5P4G9EV5pYe+t0b47ZyJvSZjZh0emM1k6HjvcmcD5qOkf1UMvbNz4VdKxk0fIIahH1C2WII999UvjbUGJ5Xx4WiOisLExL5tWe6m+GFagH5NYa4UQ92LRG2XIxu++pLQN4hDCBtKNdPesc/z6lM5lZZN/vvpbgBP6/HTnFTpjm2vjXzqkpzZPAfgloHNZ+Foi2joRpeA7xStS54
 NuEvTINY
 8cdjl+D2zhyEUWVWHML8FZkVFjm03LWM6s35LA+ogwZGkYhz6MW7T2KpqppxB5m0s5K8ZbKE3xOgo0oqFosvuieigCaGk9Q+mHaxuisNoZ4ZyIUe56fJLP4UUZWhKdBhG+tpr96WmU/2u8PBFTtj1yxq15ZgP+abSCGy4524Yp0Ev44Z2iXKL6DGvgT1B4kplUgGyWxAzeiM3GSgahzWKtpotLRe9Vq8uO7ILZg40h6HL7ezs/cqNU3p4MC+raQKxG4VOxz4SRb2KQDL2GbbPKnRWVKBSg61PJXCCLTv0UHG0UmpsZBX5bRWYtvoUNg5CsRPJJkp8Kayus1xjqOEvSsT23WXVOhVw6AOJGyBENDFHeY9hfa/sGZYKqxWIh23w0Me3HNu9tXr0/JmT0YmcnLNEw1uNY8/40lHb01nGBtoaaJv25ZFWQtPPQ0ekIRU3YCqR
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
index 9c28afb0219c..b3371877762a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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



