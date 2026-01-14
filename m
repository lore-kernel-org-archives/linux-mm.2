Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766A8D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE95D6B00C5; Wed, 14 Jan 2026 06:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD7E6B00C7; Wed, 14 Jan 2026 06:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA406B00C8; Wed, 14 Jan 2026 06:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB8CB6B00C5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:36:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E2F21BC01
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:27 +0000 (UTC)
X-FDA: 84330366414.30.E84163F
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id DFE0C1A0006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hP2Zk2ST;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPjfXOeLD3JqDz3IDoD+k8CQ2UhiNCnYJI1wQcwmWYE=;
	b=KrkCqWagU29alN4F60E9YG+6y62C7YFFsQC4cAO0VShWp0zhzZtSBzIoTKOhuFzGvLu418
	3vSNbqdnOqp55uaYFzF2W/MS2jFFeilB+LdeCzjTgwvA2j6q88MQy1wnOmeI3Xr1QGtK1R
	NSesMVGu/HtXE0z709LshV+fpzyg5ic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hP2Zk2ST;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390586; a=rsa-sha256;
	cv=none;
	b=eNNqtrHjtIU0u8qXhD72nrucP7aY+rS5eo3D3GBDguDtlak5CmZoTdmGZfrKvDJptebFI/
	okh6mDg9mtgavkxcfVzZyhrNZ4DOkdLultMO79ukETN4tVaFf4L2LXYFjkSxrh48Rne8hL
	rRaJuwjhlyFRo5SQzb8jfakbbjOhNy8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qPjfXOeLD3JqDz3IDoD+k8CQ2UhiNCnYJI1wQcwmWYE=;
	b=hP2Zk2ST5tXGQJs5jKumpXbTNEQa6cSN/QefSYfwvZwTZLcduImseVBv4ckkJPsodJ4g7m
	6lzvZCv7rw8zQHewhdAtzt+yN2TQdS1KXkKxaIdyajvzKgAvJA4AkBi8RnfsO+xbt9Jtnv
	CekD4YJFeHRZG9Mh3bbOdcqJngsDuaY=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting state_local
Date: Wed, 14 Jan 2026 19:32:55 +0800
Message-ID: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ezpffbqy6z7hsjo6fif97qejacqarkn5
X-Rspamd-Queue-Id: DFE0C1A0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768390585-262419
X-HE-Meta: U2FsdGVkX1/XyIOA+zPtOXPBdqCxrWn+rW2V2VEBPXWxnbQCfefynxag5tlHO9h/QZUDrogdcKLyzXfVo64zAkbVlgDf6SlcjeB7nW0mwVi3wTfkl193fSTNw7+wQ44eMZMTzdg4doPmI4HIKVw/REOytr82GD9LGAuZMklIWhkUuou16KiX9xXlWYa2L6z2h+kUgCDG3tnt5EcHP+eiUF7PaOEVcbffvZE53/XWwC/PS6SKfLZpXHT9L7ssNWzCiZVlpDEfY+IrmcDv8+9X68WHGJ3B+RM3OEFfIL50viWltwcpm5sDLuG3AIJnqNDkidEPdmy/wHTjCqXhwwNPa8bWVDSalZMdr+mdNLQNezKPZo/CTntTMXYB4AWdnu/Qv4YFuZEKgWEVz/1rZ+ruDlSvQBypvALjoCP26o6Yg0orYM6yVJKqglLL4y8VvuTjGCPT387F1cGjw4ZQlKBlwOWO7vIPEeCDpFEvhSEOoRvBB2r3Ot/o3EZ+bKFhqJXcN9fyRcOOqxA2ZAep7Iod4rjetWJYJDGexkFp81aHvEv/bf3ebEPeVNqL3gKNNO9bjeo3vL1ARRXVSk/4toUcswnw2Mcx/e4AqbjFkq+br28FibwqmWpOhSilRY8ZRmkoTgGUEZ6Uz2CmyrOB78QyKDlh2JMCdpfSwyQixaHxILBpRQPuUAxtcPeiNWeIsDJlopRAVJUF6P82JyIPzc1JxkpWy34rhVBnQ6SWkHQmD9ciPKuZNJ/eXcMKA8+2prEfrTS4JdawSymlBGL0LRGyPuS+QW2RofEWt28SjQYNexDaVjfuNqFV5aBQUHUAou3KFrusV2o3NDrEUUt40wX50WPGqpfpzJ7f0Oeki/AqAcTxxQhI0OXEIteWt9QybbYJutieanwXZM7UUSkj1i7jRXxuctMO+/g2vRsP3t3OuKZFmZx1DwNhfvCWkvp6kRCkFppCU0be33wyaykt82l
 REscSy/u
 N1+6IBM8Xw6OmDfmfoHsNQ7ZLM62p2QP6Ztl6k2khI4HRylx7EK7SZ6CCkr245jnW2yo3T503o9jxRmCH39TwwqarXIt9wom8/kKWCQMTF7ltQULMhTxihO7EjosBhvuYakmNR0IxJhrugaA2Q7YxNbpHA67trWSLeB09ZnNM6e5eKbvAcabI2P3Nl2qkMgTbsyP1ddlMCWd3nT8MRYNy2to4AB5GfnwcL+uUpyO+2MQlcug5OEdnWOV6SFWDBKHYl02x7UYCCLsN8eI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. The following counts are all non-hierarchical
and need to be reparented to prevent the counts of parent memcg overflow.

1. memcg->vmstats->state_local[i]
2. pn->lruvec_stats->state_local[i]

This commit implements the specific function, which will be used during
the reparenting process.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h |  4 +++
 mm/memcontrol-v1.c         | 16 +++++++++++
 mm/memcontrol-v1.h         |  3 ++
 mm/memcontrol.c            | 56 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 26c3c0e375f58..f84a23f13ffb4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -963,12 +963,16 @@ static inline void mod_memcg_page_state(struct page *page,
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index f0ef650d2317b..800606135e7ba 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1898,6 +1898,22 @@ static const unsigned int memcg1_events[] = {
 	PGMAJFAULT,
 };
 
+void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
+		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
+}
+
+void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
+}
+
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	unsigned long memory, memsw;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index eb3c3c1056574..45528195d3578 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -41,6 +41,7 @@ static inline bool do_memsw_account(void)
 
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
+void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
@@ -73,6 +74,8 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
+void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70583394f421f..7aa32b97c9f17 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -225,6 +225,28 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
+#ifdef CONFIG_MEMCG_V1
+static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
+
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	synchronize_rcu();
+
+	__mem_cgroup_flush_stats(memcg, true);
+
+	/* The following counts are all non-hierarchical and need to be reparented. */
+	reparent_memcg1_state_local(memcg, parent);
+	reparent_memcg1_lruvec_state_local(memcg, parent);
+}
+#else
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+}
+#endif
+
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	spin_lock_irq(&objcg_lock);
@@ -458,6 +480,28 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx)
+{
+	int i = memcg_stats_index(idx);
+	int nid;
+
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return;
+
+	for_each_node(nid) {
+		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+		struct mem_cgroup_per_node *parent_pn;
+		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
+
+		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
+
+		WRITE_ONCE(parent_pn->lruvec_stats->state_local[i],
+			   parent_pn->lruvec_stats->state_local[i] + value);
+	}
+}
+
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_MEMCG_V1
@@ -757,6 +801,18 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 #endif
 	return x;
 }
+
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx)
+{
+	int i = memcg_stats_index(idx);
+	unsigned long value = memcg_page_state_local(memcg, idx);
+
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return;
+
+	WRITE_ONCE(parent->vmstats->state_local[i], parent->vmstats->state_local[i] + value);
+}
 #endif
 
 static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-- 
2.20.1


