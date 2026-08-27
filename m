Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E93DC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C5D6B00A1; Thu, 27 Aug 2026 08:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3106B00A2; Thu, 27 Aug 2026 08:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB216B00A3; Thu, 27 Aug 2026 08:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9976B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 059EC1C1CA0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:42 +0000 (UTC)
X-FDA: 85146990684.20.F4946C6
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1920B160009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834020;
	b=kcF6820Zrsw5dYb6ox2LLUyNHcUsS4RYbHh30advORLYaasSNsWEFTr2K34qmFarINH4PL
	Az3eheZps4b9PH9PN+6HeW49CuM0D+Yi6qaT17V2tN/MTxpsCXTH8R0eESHfDIkCKvRjZJ
	g8dJsCHOuDJ5taviSJ4+8Aldx1z0g2M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+9Y0ftw5L8ycQU7gsaUNvrM4VJo0WmEeM1zqcwp3Tg=;
	b=mnKAACfxVpjDQ7EPgPjspqmXlGuJFj4uXMHrPUDFEjd7xi/n76Wl9c5Oq6O3M2CMdyh3h/
	tbJAiKaipPajUZZsmtu2A1csxJFr+2J9cpXDHwFUK3Yhz2Up5H3Tfjrk8UMsyaJQpPJrQ/
	ILLEC4jptYF2oj0zdzdIhL6ZkW5Eb3E=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CP0WlzzBJb6v;
	Thu, 27 Aug 2026 20:33:37 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CN13S7zBJb6n;
	Thu, 27 Aug 2026 20:33:36 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id B5BBF78AD;
	Thu, 27 Aug 2026 20:33:28 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:34 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 13/23] sched/cache: Pick optimal src rq/group using affinity promotion metric
Date: Thu, 27 Aug 2026 20:28:06 +0800
Message-ID: <20260827122816.756234-14-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1920B160009
X-Stat-Signature: rsbcjoim8hr7sf8y8dcs6we4habzawiy
X-Rspam-User: 
X-HE-Tag: 1787834019-297326
X-HE-Meta: U2FsdGVkX19xhoAeWG6GNfhUltnEKYAG9tFvE1vCBTnmx5WbLjK5ryrOYa8tVNUcM8IfEK6TGh7dJ8upFy261+GOmA57Jg5RM0p585qeW1xQjCdO42hAi4sURNY+NDj0+Tv9h4XTX5v0a2U6f06wa2wJRVws12hbrvPoE8oiM+wTFyRkpkDiesagR/31RT4mqkMi8SmHXYFJUT/DX3CrYhboAWJ1GrY3EBJcv4WMYJw+4dZbhPDXVuZBCnCKqXhnvsSuxI1eS9XJ9wJY4hfKNadtrZQmm0hc+LmDbe8CNeUEWaD5ugkQ0lSF4ITEG2rr5v97nySRVo+wax8LLWrbCHykdghkUo7ASdu5oEqYjR+9i2AH4fT2rQrBcwUIU9hSRaw3PYJhuiLgPLOvESdrR+9b265ljK2v8Nf7OU4CnxdpIMN+RGJXyINNE/41YlzUw0MfCVFSX0dvQyx53C/IB2ylj0bp8MCTyZa6/7TywNwKcBwMFUAStzJK0pj4LhWHKRkBReIs/JuGwe1s5Cy1pxkIPK6owR9oII/6jB60OIxowzuFKfH2TOfP9oKpwWkNScd9Sj4oxSN+BP+YS69AFjGLR8Oz86cGrbJDX1YvKx8VLzncH0wSg3t+/Ttc8eSZx0rmvUHsLVO5vQEH+YDUZ8YRky+04UsomGvqW9eDsQzegxr0O1PyT46oic2rDNUcplcxumfE4jy6iEFOXsV7hwsoYxGIwkcovYrwmSnFc7EzzlJkMTeLaDkShjkw6XpwYbBiO+zFQpVCIS7lKZZmMuMtNswEF2iuHbE3a9uofWGZ1P3d9yRZV2kb+0gc6Q3RiB/xfNEjmG+5g3/A8ktVEz88sYgT3O7HlZbvV5ffZTu3kDxXXS7TB7vJGFErkAgpAnd/uD5V2ZBted2aFyyoiR54toWc2yRCFpAJDuu9cDc08gW2FFQ+Uaqrnm0ypTsNS2OP9q28noP4zA/HD/n
 snPV7Ji0
 dm56r/j/GUITk5MpzAWAo7dHCf6XY7aQyL3+rv6OQ0ZjP4Nj+ERQE2gxv8XfLyyDRhpVWpgoTWh8LaAqmtcpmn/obEQo/odivIi3WSyGbqZDp+ZxDQBMk6r/BaHbjvTC9CqYSukTbGLp7sz0jk3djvqIg6PxfD3lq/aVGtDdFqvBN5JHpfsx2WV0UIsY3EEKBu3VnH5rn/2TgoyqMgkoS1f4UvSj/q9xkVXTgHcLyUuUqThsXewk79nDrkfaQlQ7BkbYdYCV5sJOR7vbGq56DCwVP+qSBxXjhxMao
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current source group/rq selection only considers LLC preference and
overlooks potential NUMA affinity improvements. Utilize the affinity
gain calculation from the prior commit to choose optimal source sched
group and runqueue in load balancing.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 505a1ea9537f..584297528a9e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10653,7 +10653,7 @@ static bool get_span_stats(const struct cpumask *span, unsigned long *util_out,
  * Decide if migration should happen on a specific node.
  * The node here is an LLC or a NUMA.
  */
-static enum llc_mig __maybe_unused can_migrate_node(int src_cpu, int dst_cpu,
+static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 			struct task_struct *p, bool to_pref)
 {
 	const struct cpumask *span;
@@ -11983,8 +11983,8 @@ static inline bool llc_balance(struct lb_env *env, struct sg_lb_stats *sgs,
 		return false;
 
 	if (sgs->nr_pref_dst_llc &&
-	    can_migrate_llc(cpumask_first(sched_group_span(group)),
-			    env->dst_cpu, 0, true) == mig_llc)
+	    can_migrate_node(cpumask_first(sched_group_span(group)),
+			    env->dst_cpu, NULL, true) == mig_llc)
 		return true;
 
 	return false;
@@ -12203,6 +12203,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 {
 	int i, nr_running, local_group, sd_flags = env->sd->flags;
 	bool balancing_at_rd = !env->sd->parent;
+#ifdef CONFIG_SCHED_CACHE
+	int last_node = -1, node_num = 0;
+	int *cache_data, *affi;
+
+	lb_affi_scratch(&cache_data, &affi);
+#endif
 
 	memset(sgs, 0, sizeof(*sgs));
 
@@ -12232,7 +12238,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			if (llc_id(i) != dst_llc) {
 				sd_tmp = rcu_dereference_all(rq->sd);
 				if (sd_tmp && (unsigned int)dst_llc < sd_tmp->llc_max)
-					sgs->nr_pref_dst_llc += sd_tmp->llc_counts[dst_llc];
+					sgs->nr_pref_dst_llc += cal_affinity_score(env->sd, rq, i,
+					    env->dst_cpu, cache_data, affi, &last_node, &node_num);
 			}
 		}
 #endif
@@ -13330,9 +13337,13 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 	unsigned long busiest_util = 0, busiest_load = 0, busiest_capacity = 1;
 	unsigned int __maybe_unused busiest_pref_llc = 0;
 	struct sched_domain __maybe_unused *sd_tmp;
+	int __maybe_unused dst_llc, __maybe_unused *cache_data, __maybe_unused *affi;
+	int __maybe_unused last_node = -1, __maybe_unused node_num = 0, i;
 	unsigned int busiest_nr = 0;
-	int __maybe_unused dst_llc;
-	int i;
+
+#ifdef CONFIG_SCHED_CACHE
+	lb_affi_scratch(&cache_data, &affi);
+#endif
 
 	for_each_cpu_and(i, sched_group_span(group), env->cpus) {
 		unsigned long capacity, load, util;
@@ -13466,8 +13477,8 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 
 			if (sd_tmp && (unsigned)dst_llc < sd_tmp->llc_max) {
 				unsigned int this_pref_llc =
-					sd_tmp->llc_counts[dst_llc];
-
+					cal_affinity_score(env->sd, rq, i, env->dst_cpu,
+					    cache_data, affi, &last_node, &node_num);
 				if (busiest_pref_llc < this_pref_llc) {
 					busiest_pref_llc = this_pref_llc;
 					busiest = rq;
-- 
2.34.1



