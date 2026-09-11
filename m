Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94810C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C1C6B00A6; Fri, 11 Sep 2026 04:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E2D6B00A7; Fri, 11 Sep 2026 04:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A936B00A9; Fri, 11 Sep 2026 04:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF586B00A6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B83518012E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:28 +0000 (UTC)
X-FDA: 85200736656.26.858FB18
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABAE1C000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnGYwt8A;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXxTmIeKQvV/g4Hrzs/mGZm0pm0bhMQphi8gJbgCQCg=;
	b=V0VrBuUjnF2JAmUuQ2gn8tpQjAA42xGt151Xmet32hSkLAq3+unHq+CZVrU0U29HhTmTye
	P1W0kNN6BfCjDa4SCn59AY1A+BFBlDvyIY3Xgc/gsjkYexfDOlfeYdryLz8RpG99uQ0qA1
	bMlsvchFfa5BW72pyjkxxB/IL5Nctus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113687;
	b=nlKEcdjRYabEO4byT6JZhOVscTHLWsLAIZ/mPCfL2bLEmojhnWVhQQoEdq5ekgYVu38nHR
	Mg3rG1F2SjFAKjIDRDe7VHDvJmLh5RhD8hji68eIBEmDCsZh5Z+Feps8eJ5FrtWQiqjyOP
	2ypR4n5iRdmNbAG8m54Lnlac+NURs50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnGYwt8A;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=48OIeErQYrhkpbuOIqiS9L91aRSY0G25gCPRWoMJaKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113682; v=1; x=1789718482;
 b=cnGYwt8AhDyuiA7JuomDmDM6Cq+RcLuhVFsw1UbcAnaIy2pAYlDYGhEyCEyu9viIGlG+7hVT
 PBWof/O371hthPEPY71CjBbBpcY+QrxnCBXS7D4wOUjHcg0HfgX4DbHL+IwFc3QRqIjmdLg18vY
 ZBcwWFYHXO8CTimCuBMIudL0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 53d09cb5692f64cf;
	Fri, 11 Sep 2026 08:01:22 +0000
X-Mizu-Trace-ID: 53d09cb5692f64cf
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v5 1/4] mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Fri, 11 Sep 2026 16:00:48 +0800
Message-ID: <c1ef4ef6a84cac479e573f4423b734dc8176f7d5.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 54b3qum77tag4sssgte1dsa6fpirbme9
X-Rspamd-Queue-Id: ABAE1C000C
X-HE-Tag: 1789113686-951580
X-HE-Meta: U2FsdGVkX1+ykqF+ZrDxMfCSmuTiolPRcJMgBcQEbvY6FHCo039Tz2twDVFLFJMzhRlHCsTgjuZ0oMBHl10tVd4Our3oZg3Y06GX3RL7bb7E5VndEq2ztbuWtBJhgfICYFz2yZaXkrDy3U8LssPwiQWqF2cD54LozPqMbAfxy8oIxwNsZCwBagIlJBCJ05fcgzhLTBuI0gGnPVeGRoMDRggwR+noXk7nMu63u7sFqCkR5pbmScdVBWTjaBV31n7uezbjBeS2NblA+VZlXijUXSDu5fizs9D5Bs85VEKo7a5sM92DkJ3/++a3Ah5r0UBFvESvkYmkEvGx+asjNcUYL18I0mC545PTj+Se1SfiJw4orjLfuYkBAKPOieEV2H7hBBn8yCFgHenVqAIC5aGbx480KEDWjW4OwkGJZJ8ZSYN+rR5cL0EJYR98s9xisnfPBn4pMuFcGtTaLmmhgcEt4VtFFUnE52dbf79S+l/2IEisu09XV2M3g6AJDHlIjUFi6kdyAKT9d2RHkO2kTvQoSdkaB/qZGAbH3gIrVRHf6QdF97K9r0yuiVCgSueaT4fZk2jnqcEwrvQT4F4oMm7nzx/Sw7aAjVhq/4VInH3HFu9wb+YHm2iewaOFdMEAoc8pWckl3hxIYNvvo1DtiNcohmrnUYNmcXrL3U3y3OpFxLFHiTclFo74JMVevEFjjll7YnZjq+yad1eOkYcK3iDMwzmLjrHyDHM9GuYfSA18l/e46J/oa+bV6ItWxOaQNhUGh3P8x4ZeOFLe5tZsftE3TWt1j/PMYLo8XMl4kiQW9rTaVGdB28dF/dJ6E7sA1JKQI2q7G3arzMiVJLfPt78ibRXelkWqgaWYhfR4Y1bJA5QHg8lg7XfPuTryq2bCejuQDiQ9c/RTp8E1RboHQQ69g/VXb1YmTpc1LUze85MFoNhjjzfNU04arAW2hxPbNR9EhlPWhRfz3xnwcmeDdts
 Gjn1FFAU
 P2HwcHiSmDiwwxlqFi0korLIZV9TQV/S5Q1hjbEPinQpX30spVxiWrspgOOlWrzVIAp77twpBEWOwIkxKbmoYafOFZQNP8mzxI4+78qdqXjWxPqNMqET6PGTTqWNBG1JqXFqOrklIvo54GioyaMLOai5am6IvkIcK8ckEGMUG9FBPA9Q61n6xME0DiHjF3s3fJePIQANkOPsL/E/qqiPYJQnXbw==
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

A later patch in this series restores lruvec_page_state_local() in
count_shadow_nodes() to fix the broken workingset shadow node budget
under MGLRU.  count_shadow_nodes() is the only reader of those
non-hierarchical state_locals on cgroup v2: when a memcg is offlined,
its pages are reparented to the ancestor but their stat updates keep
being accounted to the dying memcg, so count_shadow_nodes() computes a
wrong shadow node budget and workingset thrashing protection is lost.
This is user visible as premature reclaim of hot page cache and
degraded performance under memory pressure.  Apply the redirection to
all hierarchies to fix this.

Offlining is rare, so the added cost on the stat update fast path is
limited to an rcu_read_lock() and a css_is_dying() check; the upward
walk happens only while a memcg is dying.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617e..ace9fe2b46084 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -845,20 +845,14 @@ static long memcg_state_val_in_pages(int idx, long val)
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
 
@@ -870,22 +864,8 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
 
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
2.43.0


