Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6E9C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957CD6B0099; Mon, 31 Aug 2026 05:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FC26B009B; Mon, 31 Aug 2026 05:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C536B009D; Mon, 31 Aug 2026 05:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6764C6B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:46:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB689160425
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:45 +0000 (UTC)
X-FDA: 85161085170.06.D5CE38E
Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 029BB100003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hei3gk4X;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169604;
	b=D4xjwUgCA4WS0xO0ot73k/KKI2KGsEUIsu2nYBIexu5aZjgg3YicGLzJQHj1Xwy54tSE2K
	uxrOs2GI/blRHdE3Kl93rMAEfPtWNIS/hPPSxdZMd0zSebHJP3P3kfI+RKCc7lcCbT3oXq
	zpfybefILxbnUi4MhvvFkeXZBx1q9lA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRIBeH4guPHxC6hYietu1YQjrFtx+rdi6kxbcaJ0LbA=;
	b=Rk3tZWFaRENFCGjY6OIEkMVAMFiHK7Lyx8wO4QyBgZ/0m4nx8MWfUMPQ59PG12ZcChxCnc
	+m04+WFLoOdTI6KnqrkyDymUzUBFR9I5bxUtmCOu0i5iip/oZk2z/Q6iJnscJEm7xpdqaG
	q/wEDU+K+YzjOgeF5aU1K1VL6rKOktI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hei3gk4X;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3A3/xJ8l9zjo+u20t95UB+aIofHnDSAgrY2cv9uuTZo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169602; v=1; x=1788774402;
 b=hei3gk4XP3S3A5xIwixknjToXXhEqrRLO/tjzC7hWzHByD9c60pl+aLxrjD+a4t6YUrlNIaG
 Lx9laineMOcSIgipSNkrXapT+L3IAn47z/Nzo/RpDeqCtV3cEpHr80CT6sGSO63lYWeYr+RSbuX
 TxVOy+whAiStNqnGwwWDyL+g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7fd054419e97544c;
	Mon, 31 Aug 2026 09:46:42 +0000
X-Mizu-Trace-ID: 7fd054419e97544c
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 2/3] mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Mon, 31 Aug 2026 17:46:10 +0800
Message-ID: <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 029BB100003
X-Stat-Signature: esjdzi19xxo66ey8y89grnesbejp5iwx
X-HE-Tag: 1788169603-29534
X-HE-Meta: U2FsdGVkX19qTETEfqTpjqq7xCmwqTc9HRYfVssysFb0wUoEfIbeL3DrzvIDOktYBth3bjZ7iKcHBLjeoRKMpvkS2VK1Uhz1kQ3f/YU6V8JcIZ3vSDcgwfp3V+4AkLbwtyLjIDhT1rME6o9rnpgvSnov9cxBGkABtkqYNSilOQX+NeQ9FuCwqEj3s4F+xE//KXDX600gBeFzwTh138uDle59+Ln/QHnU7FDcaJi3Ag74Vf/yuWW4n8haNWLR+9Eu9DUX4Tw0fJhqcSMSFwyTM3kYLQak+Mlt6TAe0LpgwyH0XLg1InQe/vmmD2q9lTtja151hLBlQGMRHCnFcZSBZgTVeAJKF1ev/xP/CgbXfzOj/jxIcNAOAx/Y/G6nbi/U0eVu5qF7CND2fCUKUGA7/zxMFXPeUDwQjAttK4beuVg6n83oCmt8UnZM6ALHE7JllYlkpPIu5AiDzgLzHueqZjZO6LN5Sh2X0soabdN3bJsNMN1X1GB+OpVQ+YVtan6HnVqQPMNOAHgIuA8KCXY7uiju0acdez3HtpAQeCE+CY5gRoWCAR19V9dgkGU8o4tAqqhUc16Cs/u2O8XI7brqe5vaI3+YCpClz4VsVn/x97+KWAJLK8iadirxGWj2bJligYrGDQy/v8z1EbPj+Zok/SMuohr3At4tLEeCVp3w48ZSgftez96jsfqBjBwbiocTDo0apUVW75sUamvOGm4cDpRWQJOl3Jeb7RWF5m2i2uvDGjZcS+vBYa51x6jh2A8qhUCAOD4kzcoyp5GZSsXubAHp5PC2EGQRF58aTPDX++QurS+ekwQdESTDytOPsFtqk3HvbCZEVEmqJWQS218JBtA5OckFa3zF3aEqAVi34KsylL2I69Ie8+DVmTU45sVn0/c7XyCbVFXuljWIqKueln4FzV6O2Z+dsjW2CJAA1tnt6wCMdk9jj0l4L3nYxcZIP/u64QbFSpFg2B44wka
 76pjL35X
 enmMjb3f/A97UtyV0tVFcGObKjlt91U9loGKtgQH5vDrGVKHiwOMgqwnDzJkJC/JoPRmfkLEABlVzWiVsCJ/X3HTVdqQ5zUFG3Byg4rd3bOdCSzjnOaLQNSTOnF2rGbuBucgFicKmW8uhXfaRl7/f/LPRWnYAWlFwnVLi4hodfpDrh4gE9psk6IKtIMQdqUrxu9nW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
stats keep being accounted to the dying memcg itself.

The previous patch restored lruvec_page_state_local() in
count_shadow_nodes(), which reads those state_locals on cgroup v2 too, so
apply the redirection to all hierarchies.  Offlining is rare, so the added
cost on the stat update fast path is limited to an rcu_read_lock() and a
css_is_dying() check; the upward walk happens only while a memcg is dying.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..b3d1ac3fe0aa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -805,20 +805,14 @@ static long memcg_state_val_in_pages(int idx, long val)
 	return val < 0 ? -res : res;
 }
 
-#ifdef CONFIG_MEMCG_V1
 /*
- * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
- * reparenting of non-hierarchical state_locals.
+ * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race
+ * with reparenting of non-hierarchical state_locals.  Offlining a
+ * memcg is rare, so do the redirection for all cgroup hierarchies.
  */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
+static inline struct mem_cgroup *
+get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
-	/* Rebinding can cause this value to be changed at runtime */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		*rcu_locked = false;
-		return memcg;
-	}
-
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -830,22 +824,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
-	if (!rcu_locked)
-		return;
-
 	rcu_read_unlock();
 }
-#else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
-{
-	return memcg;
-}
-
-static inline void get_non_dying_memcg_end(bool rcu_locked)
-{
-}
-#endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
 			      enum memcg_stat_item idx, long val)
-- 
2.53.0


