Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA20C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDCE6B0160; Tue,  1 Sep 2026 08:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EC06B0162; Tue,  1 Sep 2026 08:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95256B0163; Tue,  1 Sep 2026 08:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5B2D6B0160
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:32:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39A5B803FF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:32:51 +0000 (UTC)
X-FDA: 85165132542.04.D1DB695
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id E7CFB8000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:32:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=m3LPIu+F;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788265969;
	b=G4bh/V9eiU99WEsoGw9/s8kQWPZw0QPOTa/VeNwre8H00gBImGQf0ERS+QLu6r4HtBarr6
	Mp+nHF8njImVvxX4w10S2RuBf2hdq/MJR68TXogQN4OBF6Vdt+3veGw6FyOYQ2LagEroaj
	OcNOBPLW/DLm/i5ERDAXS3HqhogA1/w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=m3LPIu+F;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788265969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11FIk8dcywNJhU7vX3fMrD3GTQv+b8U3zFVsgXjY8xM=;
	b=VDL7K8KzwcQdh0T0FR+2MSPTqxrhhlIJ/rGYb1q8n1S3P1KfzFprtI1PAffDD0Xc7FO3ia
	RtP80NCWatyKJlOXfki0JjGvT3wpOKvYsjUImw/vEj6RDsJrJvTp82e/B3RQ1X28fbCRH5
	dY/ttAoNzzVi+qEnTX7EEuoNtTDmjKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=11FIk8dcywNJhU7vX3fMrD3GTQv+b8U3zFVsgXjY8xM=; b=m3LPIu+FoN9GPmQNL+JAbX4umA
	RCUc+55B7wNBeD3QfRf+OKff006wPY1a+T19QUXMcQ8KZEi3a5TwgbOb6786lS+bW2TFXIYPIRHhE
	qRIvsbkExCXz+DP7wtsi0aHN56mVl5brXaG+jkal7C/7mYPaczD+Rl6dK7M5b3vqIeRtlPfX4Hfl/
	1LH04kzs9EHRGu7/dwrbDFrW48rrY6d1lX5LWfchOSIbd0HdayxTR9wg4Sf2mizckZ+LOabpUVMgo
	wtG/mnhCfGBbWaYhgPcFuc5AAYBFFlZ38IjafUCrsAko73fIWQLqur2GNEBKog4d2Smxl6v7uXoAA
	lF7siVdQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1NfK-0000000AwqP-2nSA;
	Tue, 01 Sep 2026 12:32:38 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7FE65300578; Tue, 01 Sep 2026 14:32:36 +0200 (CEST)
Date: Tue, 1 Sep 2026 14:32:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260901123236.GA687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <20260828151018.HnR9xV1N@linutronix.de>
 <20260828150836.2d5b378c@gandalf.local.home>
 <20260828151313.5c4a5e4b@gandalf.local.home>
 <20260828151747.20035d50@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828151747.20035d50@gandalf.local.home>
X-Rspam-User: 
X-Stat-Signature: 4t5pa41mqopimbxo6tikrpzbf5gir8j3
X-Rspamd-Queue-Id: E7CFB8000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1788265968-100589
X-HE-Meta: U2FsdGVkX18Jn3rtNK4gnjqcEeAJliQTszBEf7smr7fGLwRT2uZajZuCGH4FjWHgyOMoTmGDBiW5P9tTeT92D6U9akfFn/LpVafLs59kOw7La71rs/zKJgm5Kk6ZY8w55IqO9VVUAVZppVb5JWEuiJU2jy2AoFbxOH2yzArBrdzJYR4VHjsS6EmSrzQvh1Kw3ym5u0Voisnnh9VCn7mbvTmHZDBt7+1Upl+3MlgWOFA4M5Ysqg4DpVxlIgDymiZ+8PMXfgC2QLJE1lcZbCs9ruGaIpLdXhEQo3UqM/34f6G+sWMn7tUwg1HR9A7rx1hqzPO9b32Y0u0szdkUJngegJrnUrKDlsYhaupDxFzJ869QY8WVskB0i1LPtgrMUL2/LxeY0jel89Y9Ee9A8OjnqDrtKKuzjE4BQPczCHCHG5QsDW/sBj8q9U4EplN+nlPz9MBkgF86dUxVnmqQHpEbzo6gyJYRCwxzs24w7d5+6rkgO5xHOSrnVS5NiOf/5nuCIN8nX6aqvJrPvhdIU7Ka/DWhfF+iikgzmiPYn1yoS0AqBCTB4JPpFampajlBBrc43lX/XzxlS5nnUrpf8wVfslmPbDxD9OnPO2X+qmNEJVGNpqIb+hbhk35vp1g/PC+s8yQEdYj++z5t3SI9Qw3aE3/2u11EEQgMO6oQOWiYdkuGqxGkY07kKA6YNbDHe/bVulhT7Ms08PUw9r/oBi9RPFl+SsviePHIgSouchNLvzPtg0tBm3kpjxF4lWsPPtw/MS4QExSt80m6BYheojQwisg2G0yzYV2MxPxDSkgNKCj2xc9hgwWdxued6l6QdoOpQlANlSVH8eDXMr6nNvlmhSwOEbS+UdKUYHOi2Z4r02gztwJNQIqlk0Mjhf5Fc14TY8sN3b1ETj7z5gLpBtbp2ZxwvU5AS1xFZRBB4cAK3npfbJI9gZwzl+npRInuygoBu4CDovCsOx+X+yOp7+P
 sYbumGPz
 SSMwRUFCpTrNAoNcfOBU1v6FSWsvRyik1/vmT/ai4Mnveever6j6Hg5Qww30xV5ZL/LZI1UsOHIVYppZ/ShDJ5+5nfPhe2LY//FxrDsVxtJ3NRrhlVjub+gYBexLUdi3ZJLDQUS5zBQAVFUQzt9s8JzcM2tN9aROKyzOn6BksdIAZd5w81nnkdZITYrjHsTKw9m6IM27TS9AYzwT3ZJTbBzDB3SDC8zgzJMuj+FUNBPLow50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:17:47PM -0400, Steven Rostedt wrote:

>   1)     8072     104   update_group_capacity+0x94/0x960
>   2)     7968     528   update_sd_lb_stats.constprop.0+0x426/0x39b0
>   3)     7440     424   sched_balance_find_src_group+0x8f/0x1150
>   4)     7016     552   sched_balance_rq+0x934/0x4130

Bah, yeah, those on-stack statistics just keep growing.

This should probably help. Very lightly tested. Also we can probably
relax the assertion to bh-disabled and avoid the extra irq-disable
around sched_balance_rq().

Anybody got time to play around with this?

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..0c83b0856a95 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11418,6 +11418,39 @@ struct sd_lb_stats {
 	struct sg_lb_stats local_stat;		/* Statistics of the local group */
 };
 
+struct pcpu_lb_stats {
+	struct sd_lb_stats sds;
+	struct sg_lb_stats sgs;
+	struct sg_lb_stats local_sgs;
+	struct sg_lb_stats idlest_sgs;
+};
+
+static DEFINE_PER_CPU(struct pcpu_lb_stats, pcpu_lb_stats);
+
+static inline struct sd_lb_stats *this_sds(void)
+{
+	lockdep_assert_irqs_disabled();
+	return this_cpu_ptr(&pcpu_lb_stats.sds);
+}
+
+static inline struct sg_lb_stats *this_sgs(void)
+{
+	lockdep_assert_irqs_disabled();
+	return this_cpu_ptr(&pcpu_lb_stats.sgs);
+}
+
+static inline struct sg_lb_stats *this_local_sgs(void)
+{
+	lockdep_assert_irqs_disabled();
+	return this_cpu_ptr(&pcpu_lb_stats.local_sgs);
+}
+
+static inline struct sg_lb_stats *this_idlest_sgs(void)
+{
+	lockdep_assert_irqs_disabled();
+	return this_cpu_ptr(&pcpu_lb_stats.idlest_sgs);
+}
+
 static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 {
 	/*
@@ -12406,12 +12439,13 @@ static struct sched_group *
 sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
 	struct sched_group *idlest = NULL, *local = NULL, *group = sd->groups;
-	struct sg_lb_stats local_sgs, tmp_sgs;
+	struct sg_lb_stats *local_sgs = this_local_sgs();
 	struct sg_lb_stats *sgs;
 	unsigned long imbalance;
-	struct sg_lb_stats idlest_sgs = {
-			.avg_load = UINT_MAX,
-			.group_type = group_overloaded,
+	struct sg_lb_stats *idlest_sgs = this_idlest_sgs();
+	*idlest_sgs = (struct sg_lb_stats){
+		.avg_load = UINT_MAX,
+		.group_type = group_overloaded,
 	};
 
 	do {
@@ -12430,17 +12464,17 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 					       sched_group_span(group));
 
 		if (local_group) {
-			sgs = &local_sgs;
+			sgs = local_sgs;
 			local = group;
 		} else {
-			sgs = &tmp_sgs;
+			sgs = this_sgs();
 		}
 
 		update_sg_wakeup_stats(sd, group, sgs, p);
 
-		if (!local_group && update_pick_idlest(idlest, &idlest_sgs, group, sgs)) {
+		if (!local_group && update_pick_idlest(idlest, idlest_sgs, group, sgs)) {
 			idlest = group;
-			idlest_sgs = *sgs;
+			*idlest_sgs = *sgs;
 		}
 
 	} while (group = group->next, group != sd->groups);
@@ -12458,17 +12492,17 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 	 * If the local group is idler than the selected idlest group
 	 * don't try and push the task.
 	 */
-	if (local_sgs.group_type < idlest_sgs.group_type)
+	if (local_sgs->group_type < idlest_sgs->group_type)
 		return NULL;
 
 	/*
 	 * If the local group is busier than the selected idlest group
 	 * try and push the task.
 	 */
-	if (local_sgs.group_type > idlest_sgs.group_type)
+	if (local_sgs->group_type > idlest_sgs->group_type)
 		return idlest;
 
-	switch (local_sgs.group_type) {
+	switch (local_sgs->group_type) {
 	case group_overloaded:
 	case group_fully_busy:
 
@@ -12486,17 +12520,17 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 		 */
 
 		if ((sd->flags & SD_NUMA) &&
-		    ((idlest_sgs.avg_load + imbalance) >= local_sgs.avg_load))
+		    ((idlest_sgs->avg_load + imbalance) >= local_sgs->avg_load))
 			return NULL;
 
 		/*
 		 * If the local group is less loaded than the selected
 		 * idlest group don't try and push any tasks.
 		 */
-		if (idlest_sgs.avg_load >= (local_sgs.avg_load + imbalance))
+		if (idlest_sgs->avg_load >= (local_sgs->avg_load + imbalance))
 			return NULL;
 
-		if (100 * local_sgs.avg_load <= sd->imbalance_pct * idlest_sgs.avg_load)
+		if (100 * local_sgs->avg_load <= sd->imbalance_pct * idlest_sgs->avg_load)
 			return NULL;
 		break;
 
@@ -12545,9 +12579,9 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 				imb_numa_nr = min(w, sd->imb_numa_nr);
 			}
 
-			imbalance = abs(local_sgs.idle_cpus - idlest_sgs.idle_cpus);
+			imbalance = abs(local_sgs->idle_cpus - idlest_sgs->idle_cpus);
 			if (!adjust_numa_imbalance(imbalance,
-						   local_sgs.sum_nr_running + 1,
+						   local_sgs->sum_nr_running + 1,
 						   imb_numa_nr)) {
 				return NULL;
 			}
@@ -12560,7 +12594,7 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 		 * up that the group has less spare capacity but finally more
 		 * idle CPUs which means more opportunity to run task.
 		 */
-		if (local_sgs.idle_cpus >= idlest_sgs.idle_cpus)
+		if (local_sgs->idle_cpus >= idlest_sgs->idle_cpus)
 			return NULL;
 		break;
 	}
@@ -12647,14 +12681,13 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 {
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats *local = &sds->local_stat;
-	struct sg_lb_stats tmp_sgs;
 	unsigned long sum_util = 0;
 	bool sg_overloaded = 0, sg_overutilized = 0;
 
 	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
 
 	do {
-		struct sg_lb_stats *sgs = &tmp_sgs;
+		struct sg_lb_stats *sgs = this_sgs();
 		int local_group;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_span(sg));
@@ -12929,21 +12962,21 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 {
 	struct sg_lb_stats *local, *busiest;
-	struct sd_lb_stats sds;
+	struct sd_lb_stats *sds = this_sds();
 
-	init_sd_lb_stats(&sds);
+	init_sd_lb_stats(sds);
 
 	/*
 	 * Compute the various statistics relevant for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(env, &sds);
+	update_sd_lb_stats(env, sds);
 
 	/* There is no busy sibling group to pull tasks from */
-	if (!sds.busiest)
+	if (!sds->busiest)
 		goto out_balanced;
 
-	busiest = &sds.busiest_stat;
+	busiest = &sds->busiest_stat;
 
 	/* Misfit tasks should be dealt with regardless of the avg load */
 	if (busiest->group_type == group_misfit_task)
@@ -12965,7 +12998,7 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 	if (busiest->group_type == group_imbalanced)
 		goto force_balance;
 
-	local = &sds.local_stat;
+	local = &sds->local_stat;
 	/*
 	 * If the local group is busier than the selected busiest group
 	 * don't try and pull any tasks.
@@ -12986,14 +13019,14 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 			goto out_balanced;
 
 		/* XXX broken for overlapping NUMA groups */
-		sds.avg_load = (sds.total_load * SCHED_CAPACITY_SCALE) /
-				sds.total_capacity;
+		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
+				sds->total_capacity;
 
 		/*
 		 * Don't pull any tasks if this group is already above the
 		 * domain average load.
 		 */
-		if (local->avg_load >= sds.avg_load)
+		if (local->avg_load >= sds->avg_load)
 			goto out_balanced;
 
 		/*
@@ -13009,9 +13042,9 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 	 * Try to move all excess tasks to a sibling domain of the busiest
 	 * group's child domain.
 	 */
-	if (sds.prefer_sibling && local->group_type == group_has_spare &&
+	if (sds->prefer_sibling && local->group_type == group_has_spare &&
 	    (busiest->group_type == group_llc_balance ||
-	    sibling_imbalance(env, &sds, busiest, local) > 1))
+	    sibling_imbalance(env, sds, busiest, local) > 1))
 		goto force_balance;
 
 	if (busiest->group_type != group_overloaded) {
@@ -13025,7 +13058,7 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 		}
 
 		if (busiest->group_type == group_smt_balance &&
-		    smt_vs_nonsmt_groups(sds.local, sds.busiest)) {
+		    smt_vs_nonsmt_groups(sds->local, sds->busiest)) {
 			/* Let non SMT CPU pull from SMT CPU sharing with sibling */
 			goto force_balance;
 		}
@@ -13054,8 +13087,8 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 
 force_balance:
 	/* Looks like there is an imbalance. Compute it */
-	calculate_imbalance(env, &sds);
-	return env->imbalance ? sds.busiest : NULL;
+	calculate_imbalance(env, sds);
+	return env->imbalance ? sds->busiest : NULL;
 
 out_balanced:
 	env->imbalance = 0;
@@ -13958,6 +13991,7 @@ static void sched_balance_domains(struct rq *rq, enum cpu_idle_type idle)
 
 		interval = get_sd_balance_interval(sd, busy);
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
+			guard(irqsave)();
 			if (sched_balance_rq(cpu, rq, sd, idle, &continue_balancing)) {
 				/*
 				 * The LBF_DST_PINNED logic could have changed

