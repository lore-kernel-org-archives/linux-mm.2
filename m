Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7569DF30952
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D196B00CB; Thu,  5 Mar 2026 06:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01776B00CD; Thu,  5 Mar 2026 06:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E136B00CE; Thu,  5 Mar 2026 06:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF5F6B00CB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:59:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 569485B7CC
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:33 +0000 (UTC)
X-FDA: 84511864626.25.5445F6A
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 905C618000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7n0Qy4E;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqFrQFPtVkdFa+x5udaTTR/4bek6Z3abiEm6Dfccfmw=;
	b=CNEJXPe2B1wnsazcLdZTct0QLUz93J9Szs9f3ySPGqRKK7dtO4Uw5VMdvZriyQ/N9+2NWP
	OKHx7DS3hbF85bPD8oDYbpPRG3Wqrz+pLDXL3jr7hoTvIj/Lv/xpYXuuB+6EKEaC0s/Vw+
	xtCBUd7xESnGFWkCLKSeb6oIunvl5Lo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711971; a=rsa-sha256;
	cv=none;
	b=S0t+ZkYmQlRMD/dMuc5YRMaeWZ/xpFeXMngZDMVD0OWRYFoO4wrqRXEdLqf1REDTtiQp1O
	MSEEBx/1/DNMQfUXKWFjeL/F/Hg1R7dqP6xJ4h5w436JmVak9DI0Om/WFZwHlCJ68Qr0Rc
	Vw1oIFHiwU4dfQCzIMwCM1YPn7Th8XM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7n0Qy4E;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqFrQFPtVkdFa+x5udaTTR/4bek6Z3abiEm6Dfccfmw=;
	b=a7n0Qy4ENXJeEguCWvjqw9nNjrrdnQOqZiHKBtpkL8SsI21/hCDrzAK2ROURwoVSSdMwDH
	XF0k4a5wB/cMBuVNR1A9uD5UuJdzQ2ZyymrWWsaXZJYoq403esAMzDgzyZziG+fE7mvHZW
	S2GFZdcxiy7m82Ucvc5wnHOANDKGvR4=
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting non-hierarchical stats
Date: Thu,  5 Mar 2026 19:52:48 +0800
Message-ID: <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 905C618000D
X-Stat-Signature: ebgommo3c9o67wrs554c5ki9wz8hueq1
X-HE-Tag: 1772711971-173646
X-HE-Meta: U2FsdGVkX1+/4AISY/6nqZT3GSpmYXP2OKify+YVN2kSyDfDJC5Z1ZX2mbXfvakbqrdf2XecsPt6yGeqNeKPgFR1DSU+O+Jtn8sJIdN4zYXXP2jN4I71KNd+nzTTOxxlaOTVnblEfJzeOsqKYRy4NjNtQKxVW27UHXtMzQiWFMzdM7hvsVr5xQlB17yNl1MnatRx/U/piX+dd+Rgde4XFMpVkGscuw5GL8jnciOPRnKeO+SAxOUSJEfp43+Oy6ED8lR8qBsnrNtqluZW1dR+Rn0QLDLyPe1jSqSkrcPouxhJAnEZXV4UWJhHX+Q5VQWFLU6lYfRs5sEcwxSXu/XbfFmR4aMfBmiObGRfJ0uoLqTVTfzWX/1aFMhl6rqUw0tkpNuTl8Z3IHN0tLizB24HwnV5dKCz6BSzGJMtsIn+wrsxPpaw7XLb/o3Tf6zBc8yGcfXi+imx6aEd5p5kt/1ONpg7qSUdgkgnS/Dp/G0OvnJunsAd5EOyktoIcP44mNCpE7mJkplJauoHL42X/DA0FAaXABb5kHYlSEyLaWWbpQzZvw6LQzyHYsImbIBq4k49z84Tz8Z89wfxoYC9JyMk+eBxkSveyj/8X1qNJgZWZaZkt1h1nX8c36g1MzV63XZDTKdsNR7qLIoZajJquH+Yx0CNjyrlA6ALflNgha9KWOkXP4RVeyHGHPZBIiUNghajA2wJXuhT4AF3+x1XT3Y/nUqe8xARDYz09qWQbBCMpmETI+CrzDaJDmyuwWvs4RtvwRxDeohPbBTSISgxb8QBZHU0I0X4lDNh5B+9kXJ9YzlVuLIlyswv/KjNEmW2YGGr2rtbSsAbHsQbtXRRgqbnegQEicuwXZZj+SzjHVNdB35z192EGL5Iwa2k6Vckk4lut7AH4zKvD2TtXiq6qYiknFB9KPSP/ha4DIOWv6sT2i0YgFPk9c0X6gvaD/cWhHlxVTYbr/337bqbjipaA+R
 7jXe4bCD
 a4UOjpA0x5O5+de5V8ySw50u7tIDOFnkMr7+UJEljZwiVO1+l3deXRZ+eT34No23W0ht97BeOzmqSfoSVN/n2BrS5a9TRBazTL58f/jf0IkNWbnwCSRrvPubUt5XllS8FdFkZJjFUZ+xToTjQQspXL1sW0H2go/J934txjbSuQZU0h6+MdnwANjhv6vX9GCSZPTQ+99DJH6thj8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. This could cause problems for non-hierarchical
stats.

As Yosry Ahmed pointed out:

```
In short, if memory is charged to a dying cgroup at the time of
reparenting, when the memory gets uncharged the stats updates will occur
at the parent. This will update both hierarchical and non-hierarchical
stats of the parent, which would corrupt the parent's non-hierarchical
stats (because those counters were never incremented when the memory was
charged).
```

Now we have the following two types of non-hierarchical stats, and they
are only used in CONFIG_MEMCG_V1:

a. memcg->vmstats->state_local[i]
b. pn->lruvec_stats->state_local[i]

To ensure that these non-hierarchical stats work properly, we need to
reparent these non-hierarchical stats after reparenting LRU folios. To
this end, this commit makes the following preparations:

1. implement reparent_state_local() to reparent non-hierarchical stats
2. make css_killed_work_fn() to be called in rcu work, and implement
   get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
   between mod_memcg_state()/mod_memcg_lruvec_state()
   and reparent_state_local()

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/cgroup/cgroup.c |  9 ++--
 mm/memcontrol-v1.c     | 16 +++++++
 mm/memcontrol-v1.h     |  7 +++
 mm/memcontrol.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index be1d71dda3179..a9007f8aa029e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6044,8 +6044,9 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
-	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup_subsys_state *css;
+
+	css = container_of(to_rcu_work(work), struct cgroup_subsys_state, destroy_rwork);
 
 	cgroup_lock();
 
@@ -6066,8 +6067,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	if (atomic_dec_and_test(&css->online_cnt)) {
-		INIT_WORK(&css->destroy_work, css_killed_work_fn);
-		queue_work(cgroup_offline_wq, &css->destroy_work);
+		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
+		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
 	}
 }
 
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index fe42ef664f1e1..51fb4406f45cf 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1897,6 +1897,22 @@ static const unsigned int memcg1_events[] = {
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
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, i);
+}
+
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	unsigned long memory, memsw;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 4041b5027a94b..05e6ff40f7556 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -77,6 +77,13 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
+void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx);
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 23b70bd80ddc9..b0519a16f5684 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -226,6 +226,34 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
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
+	/*
+	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
+	 * to read its stats accurately , and conservatively flush @parent's
+	 * stats after reparenting to avoid hiding a potentially large stat
+	 * update (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
+	 */
+	__mem_cgroup_flush_stats(memcg, true);
+
+	/* The following counts are all non-hierarchical and need to be reparented. */
+	reparent_memcg1_state_local(memcg, parent);
+	reparent_memcg1_lruvec_state_local(memcg, parent);
+
+	__mem_cgroup_flush_stats(parent, true);
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
@@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
+#ifdef CONFIG_MEMCG_V1
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+				     enum node_stat_item idx, int val);
+
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
+		struct mem_cgroup_per_node *child_pn, *parent_pn;
+
+		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
+		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
+
+		__mod_memcg_lruvec_state(child_pn, idx, -value);
+		__mod_memcg_lruvec_state(parent_pn, idx, value);
+	}
+}
+#endif
+
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_MEMCG_V1
@@ -718,6 +770,42 @@ static int memcg_state_val_in_pages(int idx, int val)
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
+#ifdef CONFIG_MEMCG_V1
+/*
+ * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
+ * reparenting of non-hierarchical state_locals.
+ */
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return memcg;
+
+	rcu_read_lock();
+
+	while (memcg_is_dying(memcg))
+		memcg = parent_mem_cgroup(memcg);
+
+	return memcg;
+}
+
+static inline void get_non_dying_memcg_end(void)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	rcu_read_unlock();
+}
+#else
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+{
+	return memcg;
+}
+
+static inline void get_non_dying_memcg_end(void)
+{
+}
+#endif
+
 static void __mod_memcg_state(struct mem_cgroup *memcg,
 			      enum memcg_stat_item idx, int val)
 {
@@ -769,6 +857,15 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 #endif
 	return x;
 }
+
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx)
+{
+	unsigned long value = memcg_page_state_local(memcg, idx);
+
+	__mod_memcg_state(memcg, idx, -value);
+	__mod_memcg_state(parent, idx, value);
+}
 #endif
 
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-- 
2.20.1


