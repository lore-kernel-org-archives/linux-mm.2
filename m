Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF6EFEE4F5
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 19:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593DB6B0005; Sat, 28 Feb 2026 14:08:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541EB6B0088; Sat, 28 Feb 2026 14:08:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423C66B0089; Sat, 28 Feb 2026 14:08:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3EB6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:08:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E84D13A007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:08:04 +0000 (UTC)
X-FDA: 84494800488.28.793E989
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16CE440008
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:08:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yfql9eeJ;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772305683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hsY7r14+2E1JvDh8BzbQiLtP0ZOJyonmza2QiE5ic0=;
	b=WAP8DNkKv52ug3cLsEMQ77dze2pcY3O9fr0w55+YILe+TbvlzQ9Ybexv//udYNkxlEXO3E
	vQi0sMXf1K/qSrvwtNxz0pRiAnUJrm3QG0ZhbdXiAmG0F9fU3GYhgywm23QMchBqx1Z9M3
	x2aXZD2VQAktbT2twQYILIGdfrjVot4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yfql9eeJ;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772305683; a=rsa-sha256;
	cv=none;
	b=oFr32BdKONokdOlGCu1c1xo+hL3zqLGhSYHmMJ2CJ+QA5Hhs15w+kxDCdcwRLfOy9KxKH/
	m3UqrDo/2FmXKajk8cIRRddKWQuA/4w5DgZPH2ElTwQm2CEzzNwT2zjfYLFZmB3lYitO7k
	WuxhluhQcO/keDN7O7oTzdYdeVk3wVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CDB7600AD;
	Sat, 28 Feb 2026 19:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2702FC116D0;
	Sat, 28 Feb 2026 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772305682;
	bh=ECFj6PIlpgHGhqNluMLaNy+SmRjHOXDaaWlrfELFWo0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yfql9eeJU+5rH9cNSzrzpm/RDZf7mTiaCCY25VcG+3U0s9O2PQ5HPfwAl8tKdillT
	 VDaJjVMqrk6F5sF7EKI/xo+I9pi6J89yETNqcyg64igqrmsRoBIpbxAhwj58eVG8Q3
	 Cs66D+FaBMq7EiWWU36EFJXdEU1+PNSH//muc41A=
Date: Sat, 28 Feb 2026 11:08:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-Id: <20260228110800.50bfca2a90912142c11e2922@linux-foundation.org>
In-Reply-To: <20260228072556.31793-1-qi.zheng@linux.dev>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
	<20260228072556.31793-1-qi.zheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 16CE440008
X-Rspamd-Server: rspam07
X-Stat-Signature: u8wr648mjqfgm8whdj4p9bro4ba5d76u
X-Rspam-User: 
X-HE-Tag: 1772305682-812406
X-HE-Meta: U2FsdGVkX18aDMnQBQNaiDFc5NC545vYF4B4jieiqEYW3YVVyN3xZqQqis/DR5rUVm4tfQyvi1HWHgl/qgKggCjVGHfNf9v/H/P+IJCrDb1Cpf8NPn9jIH4JBei4pKxAiJzpGV2mmUwaf5k/Ctld3YY9ODj9BcDptPTR3cBqkvhCBoAT/3KaL3XaZYgTSfzHo01CLef4ZPC1vrmvDlc/ZBcJblceiMYVnan9MGfAt4znxZFge6CgEGb3nvoJtRI9dl33IL0NvmNXCrlKAphQKAuVMUru6y8YPGB9m3sgNl4c9BERyB0b8LPUnQGanddgX1xovY+NBOdKZJikerYq8UFutWm9rMzvyObrICwm1pRHYAOovibe2zoseQbqinfb8yMs7d1ZYUZjQ/pON6Wc2W+wRbkY7aLC3eWsOXhUhfWBrjktU5CHDEJ+H3KgvYkwQ4HZWkmzkBupgtOJuKcYl1+vVFqbvW1AirPVZhS3UsMHWVsa9hyKixxFtk1wD/s9K4yCZ/DJx8oGDu7E2G1VYb3cMYvtlTV0RvPBb5IeXluGaHdEXfz0Rivo8AxkX5BPLV6OV3rLWiy9fEmOgAlywOlFHT320C/91mnuIukmlXIyK6KR1DQrfb+nbSIm4w1iItohltaIK1gGZNwa/7YB1yGy6FNJOrZcaTrgThkWswyl1tmMw6Mu9zsMI52rav6u1WYsT1CpuenTVB8CsyJpLY7g6mku3lr0Fd5dOzj9B367OLbqE9Rd8L5hd6J0MlkJ9irpd00i2U22dywLnlD4v1oATmPRWFLnC3oJcQqRTTNNQTvvOAAHNItaiPZe8084oY/i/p7dFa+b7DRCOyL2RmFe0iRSejHaYBUCPak9DspbaMUQL474Yxjfi1JvVvdP/LfLkUveR/iJAmoNRMGg4OqH1IWqcUV1iC7oFup8+2rY+sjekCMaQ+h0hGqK9/0rNSCkCUCCZWitDwD4jIf
 6cdPExFf
 YJjlTWv6AzPXsBL664dGtsVKG31UUooaV13W6tUmk3/lOS/B7RdLQO2KBe5U0eWNqeKu5tnEjYQri8Y+kVhTdQUiK3Nreb7asI82LZEBx6TSW5R95pu+TiZe88ucRYWpCQEP9WtgALzJEisfFWGbQCnzJ6z2AYnkT+9IofVsfBRTz7gQ/GjX4tsuGesnoYX6L2bp95zhgbvyir3rkRcCysOOcQhHb+AapBbelpvbN4kLI+U9LlGj+0kZJFyNZ5GuYPrP489oNc32RmlGo0/4lU80lxFTjOlPm/nNDxOw+uDwdYeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Feb 2026 15:25:56 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. This could cause problems for non-hierarchical
> stats.
> 
> As Yosry Ahmed pointed out:
> 
> ```
> In short, if memory is charged to a dying cgroup at the time of
> reparenting, when the memory gets uncharged the stats updates will occur
> at the parent. This will update both hierarchical and non-hierarchical
> stats of the parent, which would corrupt the parent's non-hierarchical
> stats (because those counters were never incremented when the memory was
> charged).
> ```
> 
> Now we have the following two types of non-hierarchical stats, and they
> are only used in CONFIG_MEMCG_V1:
> 
> a. memcg->vmstats->state_local[i]
> b. pn->lruvec_stats->state_local[i]
> 
> To ensure that these non-hierarchical stats work properly, we need to
> reparent these non-hierarchical stats after reparenting LRU folios. To
> this end, this commit makes the following preparations:
> 
> 1. implement reparent_state_local() to reparent non-hierarchical stats
> 2. make css_killed_work_fn() to be called in rcu work, and implement
>    get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>    between mod_memcg_state()/mod_memcg_lruvec_state()
>    and reparent_state_local()

That's a big update (delta patch is below).

What did it all do?

I've bookmarked these reviewer comments:

https://lkml.kernel.org/r/CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com
https://lkml.kernel.org/r/aZ-R87JfacQ2gGq1@linux.dev
https://lkml.kernel.org/r/aZ-kefGBeT-RzGcG@linux.dev

Were they all addressed in some fashion?


 include/linux/memcontrol.h |    1 
 mm/memcontrol-v1.h         |    1 
 mm/memcontrol.c            |   89 ++++++++++++++++++++++++++---------
 3 files changed, 68 insertions(+), 23 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/include/linux/memcontrol.h
@@ -956,7 +956,6 @@ static inline void mod_memcg_page_state(
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
--- a/mm/memcontrol.c~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/mm/memcontrol.c
@@ -234,11 +234,19 @@ static inline void reparent_state_local(
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	/*
+	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
+	 * to read its stats accurately , and conservatively flush @parent's
+	 * stats after reparenting to avoid hiding a potentially large stat
+	 * update (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
+	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
 	/* The following counts are all non-hierarchical and need to be reparented. */
 	reparent_memcg1_state_local(memcg, parent);
 	reparent_memcg1_lruvec_state_local(memcg, parent);
+
+	__mem_cgroup_flush_stats(parent, true);
 }
 #else
 static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
@@ -442,7 +450,7 @@ struct lruvec_stats {
 	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Non-hierarchical (CPU aggregated) state */
-	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
+	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Pending child counts during tree propagation */
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
@@ -485,7 +493,7 @@ unsigned long lruvec_page_state_local(st
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
+	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -494,6 +502,9 @@ unsigned long lruvec_page_state_local(st
 }
 
 #ifdef CONFIG_MEMCG_V1
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val);
+
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
 {
@@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(s
 	for_each_node(nid) {
 		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		struct mem_cgroup_per_node *parent_pn;
 		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
 
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
+		__mod_memcg_lruvec_state(child_lruvec, idx, -value);
+		__mod_memcg_lruvec_state(parent_lruvec, idx, value);
 	}
 }
 #endif
@@ -598,7 +607,7 @@ struct memcg_vmstats {
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Non-hierarchical (CPU aggregated) page state & events */
-	atomic_long_t		state_local[MEMCG_VMSTAT_SIZE];
+	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
@@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(str
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	x = atomic_long_read(&(memcg->vmstats->state_local[i]));
+	x = READ_ONCE(memcg->vmstats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -843,6 +852,51 @@ unsigned long memcg_page_state_local(str
 	return x;
 }
 
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
+{
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	cpu = get_cpu();
+
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_state(memcg, idx, val);
+
+	put_cpu();
+}
+
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+	struct mem_cgroup *memcg;
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg = pn->memcg;
+
+	cpu = get_cpu();
+
+	/* Update memcg */
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+
+	/* Update lruvec */
+	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_lruvec_state(memcg, idx, val);
+
+	put_cpu();
+}
+
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx)
 {
@@ -852,7 +906,8 @@ void reparent_memcg_state_local(struct m
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	atomic_long_add(value, &(parent->vmstats->state_local[i]));
+	__mod_memcg_state(memcg, idx, -value);
+	__mod_memcg_state(parent, idx, value);
 }
 #endif
 
@@ -4174,8 +4229,6 @@ struct aggregate_control {
 	long *aggregate;
 	/* pointer to the non-hierarchichal (CPU aggregated) counters */
 	long *local;
-	/* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
-	atomic_long_t *alocal;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
 	/* pointer to the parent's pending counters, could be NULL */
@@ -4213,12 +4266,8 @@ static void mem_cgroup_stat_aggregate(st
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu) {
-			if (ac->local)
-				ac->local[i] += delta_cpu;
-			else if (ac->alocal)
-				atomic_long_add(delta_cpu, &(ac->alocal[i]));
-		}
+		if (delta_cpu)
+			ac->local[i] += delta_cpu;
 
 		if (delta) {
 			ac->aggregate[i] += delta;
@@ -4289,8 +4338,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = NULL,
-		.alocal = memcg->vmstats->state_local,
+		.local = memcg->vmstats->state_local,
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4323,8 +4371,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 		ac = (struct aggregate_control) {
 			.aggregate = lstats->state,
-			.local = NULL,
-			.alocal = lstats->state_local,
+			.local = lstats->state_local,
 			.pending = lstats->state_pending,
 			.ppending = plstats ? plstats->state_pending : NULL,
 			.cstat = lstatc->state,
--- a/mm/memcontrol-v1.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/mm/memcontrol-v1.h
@@ -45,7 +45,6 @@ static inline bool do_memsw_account(void
 
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
-void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
_


