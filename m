Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85ED2C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914A16B0095; Fri,  4 Sep 2026 05:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5566B0096; Fri,  4 Sep 2026 05:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB566B0098; Fri,  4 Sep 2026 05:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614C66B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:46:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D58AE80191
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:23 +0000 (UTC)
X-FDA: 85175599446.18.E9E83F4
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1294C0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8CdhhJG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788515182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCCIodSXcO4tqq7yHH+6L/MNmlUz+53D0oFsPOsujfY=;
	b=gRgUEqRiBF8tjmpF6tna2MuVKSkM+CkmUjTEUvAA0zTi7Ndcauw8ByZ80bn1pJsCrO1kuf
	KjRflM8O4KOMF8TItz6W5tKzHGTf/6vB4O3gWJsK9msE0pad1e2xhYcZwIGzVP/71R6YLW
	OXY2bROehfzAHs4u9DezuIYIJo2EbBQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8CdhhJG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788515182;
	b=HfHWvaZNVKaUQZ7MNewfRgKWu7bWqMTvXSjetYCqKvLGiDxuKTO5e0qGAIB2oqTKNecjyq
	36CDWr5MH4Lsp2gKAezuhvR07idKMdqsbh2j40OIB8jIEDQ3J5h+3ln+wXIJ+F5T4dOnvW
	Vme/Vn5RHRBkIVqudM4njb4lNBsTJvw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l6I893eMOABjOB0M92Iaqwew/NDGht/r0iDtXoMxBjA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515180; v=1; x=1789119980;
 b=F8CdhhJGU+uXXlZUT/P0KokyYv9tS8ia0VRNcfI06OJvwdLPq+Z6cjqqJX0gJkQuFUXhEHnI
 cTZwdY0Lp5TA7roERAgKKIbOnqzUcbTuXCY6yMOzmoSNILyhyL/8pDgq3jbDFInh7uN/V2ovLbN
 ThTDbSL5aFfQWKnXVvR9PlfU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 66135b2da841d307;
	Fri, 04 Sep 2026 09:46:19 +0000
X-Mizu-Trace-ID: 66135b2da841d307
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
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/3] mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Fri,  4 Sep 2026 17:45:54 +0800
Message-ID: <8a3fe5e6a076cdd9ac997125cb6c6a0948e1a6b6.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1294C0008
X-Stat-Signature: odfdcq5qj8s3zqhjcj8di7ag1rguq8d8
X-Rspam-User: 
X-HE-Tag: 1788515181-519644
X-HE-Meta: U2FsdGVkX19AKgi17kqLfXwKJJg9pNMxkO2fFz3hb4FGWCbLsylmM/IFKCZm7PWVn4iLLCaELKuGtxnRDHAAHk2q1PBTZI/bYH982swauc5sugHKevw9yMPgqp64WvjiwhfPDjO7sVgYGxk+r0IUuy9edjtRUF3+AnsEtnMw2m3lGBeVnxjgOTqYvOP7Gc/ywbU2QSu6yLn/ROMQSJzUa5gnN8sGw0ZCOYAb9cX7b42HXfVaoAMQJzplQaRRXd4jWknJMkedy01mlTb7iCWCPdy4UQaC9YJDZyMBA08MLp+7xMYdz0BH6nMcPcui+Sv6wqwitTPcwgtCNe5VFUYfAREiEN3kVsL8q+S3Zexsd2O+7Ukwqvi4H39rmjFJOO1fPzUA26dfxotNfSBsUio6HTSEcq8dmcD9lTsaTK2uP/p86SkK13Krc46TO8w1kZkdiDjO5hZ68ayKltDpMd8x4GLDj8gQvPM60RlftsP7QyFelRnVS/IDcC/4R0AUQzHAiycH20MPxHTiubVYjs4+jp94rgMOrQPK2unxwi9fIm8lZ/gzd9+Ft8Cs8w/1bP2/D2WC0FyVVkvkhZB0r0G1r1Npb+NPuGaEGEFnVvLMQsivBmOXRriMICThjhwwSPynrSBXLoA7jQ2WaDioYYB1Rx+lNsvBL4BrzQq8k7VrhD0N/CZloalUaaWII02rUv0LUG+xYtqp+BgZb4mbZPCXEZ0s4csHbUfnPMdSGXjtG4VwDnNvl9RcyG5nLUvEyawz0N07gimE6xisKvpHEb3hiUWrWSwaUMekoY2AfGjKaSN7kmRAtDvWN9+nZ8jNRXgXeUQnVN1NTgDQYCW2EtMNL/Ch4o1pmVIFP64ajWdyl/SauscyesRlDyyRd9//oiydRaM4q8VrKK/xzHVRZvy84cTcA4aRDHB+gUbP1/jQbJ18jVbKTLvcupglenp+XIVpdvuiUbG/3LtcanBV+/d
 4Oy+mgk7
 mv3lqlqVnxEycJPbgDdLfD7anPXo75fWyY1/NIx/9ynaAiYHCXsBEr2y2CPDBppPDUqBHfL2EcOIoaFLElcjT82fC/Vq4v47000Gfv3nGp3iNxbk5bkmTerU9u6fjQ9zbDzKL+z0eRBpSqwCqV+NH1yn19zLiAIZ0JRb7iQdw+ZDdMATZ2zOqUl5Zf7Wky4fDeJjPoynpVjvr3vZ7RLxDQqjVsw==
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


