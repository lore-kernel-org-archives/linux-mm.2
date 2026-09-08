Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BE5C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20CF6B0092; Mon,  7 Sep 2026 23:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDDE6B0093; Mon,  7 Sep 2026 23:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EC06B0095; Mon,  7 Sep 2026 23:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9B26B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:41:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 078A816033C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:40 +0000 (UTC)
X-FDA: 85189195560.22.87817F2
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B7B080003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NLe3FZ7+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXxTmIeKQvV/g4Hrzs/mGZm0pm0bhMQphi8gJbgCQCg=;
	b=2G/9c4JR6GdlhaZnt3skA3AO+DCvOfuvGZLF+C9ZU7ppzMSaU4OpgkiAQJ5o2mXtTp5kfL
	Ltiu5Hf+rgEzbauYuAldQ9d1nbPAXilxZwQtzciKfHXX21UmYC/zSzS0IlZ9Smg4rednU1
	we6eqLKhp6ffJivwxmbpIpqdzhgmWKY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NLe3FZ7+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838898;
	b=eNjVhNhOWF2odmIgEDRbSVr80HL42NSKcCPYApuoZZFxAbnJKw/V2q3svY1wI0ik2hGu4O
	BBEc84v7ehtrIdRryBbizMl6KLWIcpPhQgXaYi+Waf7IlFLkOY8OQFCVJt5u5kxm4CGJwA
	Wg2PsrvRTqYEqWmGHRiGh6DwAoDsRNM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=48OIeErQYrhkpbuOIqiS9L91aRSY0G25gCPRWoMJaKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838895; v=1; x=1789443695;
 b=NLe3FZ7+kyHAfxxejboKegFHJddLVkrGkMVpODeH+9bijIBT0h7NKm3az5F08um5Zyg23BBV
 WkDlK+1iJVk9+fFrAoTNhUaZmrTgq/f0GFysMLVdZAKaTkBPzFb92JV8+OokKf91e9/EpTN9j4M
 8vK0VsoG+ESuw8C4vr4vlm2Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bc731f78d792f31d;
	Tue, 08 Sep 2026 03:41:34 +0000
X-Mizu-Trace-ID: bc731f78d792f31d
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
Subject: [PATCH v4 1/4] mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Tue,  8 Sep 2026 11:41:11 +0800
Message-ID: <c1ef4ef6a84cac479e573f4423b734dc8176f7d5.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ym5wa97d649zk79ggxpwexsrrjpppbdf
X-Rspamd-Queue-Id: 6B7B080003
X-HE-Tag: 1788838896-455116
X-HE-Meta: U2FsdGVkX19ZrFwLyTNRtJ2HcaObjI5hg/OCMgl+M65XafEUjW7H+ZAmy50oQPTxY7/AhOHjmSV47xpoweagqp+fUmJkRG0F9PxlD4xzd4YbZTCLNPk+NAE4eZdOkIkXmqfepKYmYOA+nutN1z05RHLeIsziUiDpnxvh9Ncy1SfKTdB25nk2YV9V7ohbCTbBEJuNO6DTtLhYBI6ZrwQAgwLp/4Qsz9y3L04G3ND2pu4mIXAjBspmuSuosXhB+F+IoHOfI7nzEShxrUvyxSYoR19uDH+sXpViF6BS14MoNdtRhPfXO+rHWay0AEsxHcYQ1CnGSEpb5K7q1UJRg7WFbHaaaUz7IbAkpuZ7HjFrOLpNABg/qkZh7149PZ4HxZ15wSW++U9FbipBgmMLkQVY/zm5hBdU8R6NIMysgs+9waJDsbT3h9bFJt/wUXYe0zLdy9E0PZ/oLfrYglvnbqW6VjcC903sjJa9WjlSbbcxBIQsnEsntmXjtY6LoVtqVOF/mj8h6/0nIWAcGljLc6h5fGQt9mmKQyLKDZgtOvnQGibLupEJ8jtusF8jJ1XO47gj83Rf6mulc2DMdZhSB2UsGNx2U92m8E0nvrDm2IfKJEkyeh6w3fAJsIvlRUIwG+L3JhgxGqvOyDLcNMEW8da7h9kq69Y0r3KzNSD9pkR1FfVsDaBhs92AVbNqXVVeygNwM0f0gm/t2zjBhdo2vz8uWDhu0TSz0sH7S/rqnPxhHp5VVEb5ghq2DjyYLYiQSSgb3w1dPDdqaY//JYfW98xd+WCdDb9pUWyuZmT6bryas0Hwj6qIYp82SEBQFMQZ60fF+VekespJ/j4BKo+gkMbaAD2YpsFvZUfzJdRqoSKITTkFvmLgW1PanTNQLzhxsTgP/wtqZeA9dBxCcw01PxadDHfJEG/iugOAHAkp/FFx4aeJlB2JsgMnfUyPtJ+rW2WsJCVX83u/ciFLOqLeZn3
 aTFP+7dC
 7grsfmkLksvFDz8Q7S/OxiuLbEq/lmFMh2QNMUeDitzYa4auLsT8WRvE1SO679TjPoNTMGzKHr2AcXsc1RBo4v545rU5zfEQTWRhhtYiwpZCGTStatFLSw6lVM3nzemJyYnlg7eKkEhTAAI/7GAlP3QzPurcYXK2jMNOmoDSNFRQ1WEs4oxilpIYzYx8WU7rLwpea+gvymWclsgqYwWGJDNgj2w==
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


