Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0BD606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0D16B05B4; Wed, 28 Oct 2026 22:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5514B6B05B5; Wed, 28 Oct 2026 22:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4406C6B05B6; Wed, 28 Oct 2026 22:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 120F26B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:52:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 722331C31D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:52:40 +0000 (UTC)
X-FDA: 85374140880.30.E2A6D06
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BBE980003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:52:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf02.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FL2u3+LOjy1pD6ogUH1J9mKepJJkNbeZ56gnD4oM/Bk=;
	b=3QLwUCUW2E60PJrPkyxRFkBFF5li9J5Gg1ypspQFLxwzSbfPp4efWuFhEaVDaH+5Za0Zpy
	LTWcDn/P2NO7l53KtMYKcSiPACvS7fEA0waMqsls8StI24W8KyCx1IQGSMFa7UoyQYxSoD
	CUdfhTcx/gjTYzHMLHFEsdPRedn6C0E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf02.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242358;
	b=DIZZHISop11DYdecUT1lPVRPRLPPc9RrxaxFwmGu+D4VuDNFNSpE7Iv6aE2ggBcIgCcXoc
	NH1run1Tzadnk0EHWHvgdBI63nf4jj0gtkLFJpmwIBJsWZDEq2W0OcNjm2hLDXKBHOr2Md
	x4Venneg0e6r7/GsokDdzTSWZBf7jIs=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTKt0my6z171Yc;
	Thu, 29 Oct 2026 10:52:34 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTKr1nbxz171Yc;
	Thu, 29 Oct 2026 10:52:32 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id DD409314AC01;
	Thu, 29 Oct 2026 10:52:07 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:52:28 +0800
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
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 13/17] sched/cache: Allow active balance to spread load from a full LLC
Date: Thu, 29 Oct 2026 10:45:43 +0800
Message-ID: <20261029024543.4003980-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 3BBE980003
X-Stat-Signature: sh8xois31yowr5xfwn8iojm4p56bfk6u
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793242356-428995
X-HE-Meta: U2FsdGVkX1+m0tiF+6roR1wayMQGeJ3BxoRj02QxMaVLy49kbAsYnbmr3xXsYv0dM7r5ZfzRkSFAlBL8ledzLWJYpTTRbNx0bMD0U7QvImJxfdUyBQX5Mdv/l4ZuVnfPh6xSig79EMl3sIR2xMDMZANM/Mq0tkMaCOMfMkpZy/8iGy33OPtkRgv6wkkz2aNVzmBVUXLMcXfWZ5IM3DAA3hAwc5q3Gi6fHZPX0cbRnh5hQeGbYJa1p9z9MvkYORmIQF6mJL3zUcZxxmWQWK1pql2bgueugIUfxMxlOiIL5SiGCSdMT+hXQDML+guAeQBBN8Mq0+PkTxMlOhEpKUY5qbFmZ4dVDafFE3LhCbDJ2UpITe1bsoXo+uFV8rLcMRo6uP1f0EXYuZlakjkRsBey0D7rTIrrIQXWqfbvZ715Vr+f8bX/DWA9DypjTlSC61WiS15jdmm/iw2auRifO8d3Op4ljhBOFBVAk7QXMWzwtG3DULgcWO4wcRgRwLKs7UtAQmdRQUObwWS3ZwNP8MOp7tq5xfB6SQ4SYWijWXTPEV8nEAIpWPaLvCmmlVQPHgLOhxoOhdzbL4bupagOq2LznoYLqU6zfGTQYAJQUgE9BHKOdHDxk6GR8lLRLc1AjuzUPIKINz6IU9kf7msfKKT2rQOg8tO6yHdbh7GVwd8cMmAu4mYdW2avcMmtqyXQooqGQOTynEH1igIqCVCd8EHLuT2oEpZ8Roat0chiDdykuNqcwTWRB5hKsdfGFxSjB+WUndZhvySUHVU2GmNlM+5y+XN1azuv1vDkLWsXVsssMSdEFxMj8SH9edXnLGd19sNXOIBalzUnrfzPACHTWxogeBubJYgfz+2rd4lHdh/TsgHdx/34V83rG2qz2tUlA4SGsnjVWeBd0urr378KSmto9eTFNYpYy5X0w7cUx3gK4I8xe0gapLIQupgksvLO85bBOox1G2SPwQK3qw3/c2r
 Y+WRfoe8
 4W47XRcZGQZA/nhHndq38YOlniYrPJoGgdEsh3us1GinEhWuFnXvyfCkx9QGUn5EZMH89zsSLX3GEDDAl5LV8bh7oIvJCtv5u/IAp7iVARt4h1kWBFtirHPWQILgGd8TfJ98haagE07lS0nOjSagRk7QHXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cache-aware aggregation can trigger active balance for migrate_llc_task
without waiting for nr_balance_failed. Spreading load from an LLC via
migrate_task normally requires nr_balance_failed to exceed
cache_nice_tries + 2. This delay can leave an LLC above the aggregation
threshold while another LLC has room.

Allow migrate_task to trigger active balance without that wait when the
source LLC exceeds the aggregation threshold and the destination can
accommodate one full CPU of additional load. Require the source to lead
the destination by at least two CPUs worth of load, so moving up to one
CPU of load does not reverse their utilization ordering and immediately
invite a migration back. The existing task migration checks still decide
whether the selected task may move.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c3f9ef8798d6..1e286296cd65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13558,6 +13558,57 @@ imbalanced_active_balance(struct lb_env *env)
 	return 0;
 }
 
+#ifdef CONFIG_SCHED_CACHE
+/*
+ * Cache-aware aggregation can trigger active balance via migrate_llc_task
+ * without waiting for nr_balance_failed. Spreading load via migrate_task
+ * normally waits for nr_balance_failed to exceed cache_nice_tries + 2.
+ * This can leave one LLC above the aggregation threshold while another
+ * LLC has room.
+ *
+ * Allow that spread when the source is above the aggregation threshold,
+ * the destination has room for one CPU's load, and the source leads by
+ * at least two CPUs' load. The gap prevents one migration from reversing
+ * their utilization ordering and immediately inviting a migration back.
+ * The task migration checks still decide whether the task may move.
+ */
+static inline bool llc_spread_active_balance(struct lb_env *env)
+{
+	unsigned long src_util, src_cap, dst_util, dst_cap;
+
+	if (!sched_cache_enabled())
+		return false;
+
+	if (env->migration_type != migrate_task)
+		return false;
+
+	if (cpus_share_cache(env->src_cpu, env->dst_cpu))
+		return false;
+
+	if (!get_llc_stats(env->src_cpu, &src_util, &src_cap) ||
+	    !get_llc_stats(env->dst_cpu, &dst_util, &dst_cap))
+		return false;
+
+	if (fits_llc_capacity(src_util, src_cap, true))
+		return false;
+
+	/*
+	 * Reserve room for one CPU's load at the destination. A two-CPU gap
+	 * keeps one migration from reversing the utilization ordering and
+	 * causing the task to ping-pong between LLCs.
+	 */
+	if (!fits_llc_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap, true))
+		return false;
+
+	return util_greater(src_util, dst_util);
+}
+#else
+static inline bool llc_spread_active_balance(struct lb_env *env)
+{
+	return false;
+}
+#endif
+
 static int need_active_balance(struct lb_env *env)
 {
 	struct sched_domain *sd = env->sd;
@@ -13571,6 +13622,9 @@ static int need_active_balance(struct lb_env *env)
 	if (imbalanced_active_balance(env))
 		return 1;
 
+	if (llc_spread_active_balance(env))
+		return 1;
+
 	/*
 	 * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
 	 * It's worth migrating the task if the src_cpu's capacity is reduced
-- 
2.34.1



