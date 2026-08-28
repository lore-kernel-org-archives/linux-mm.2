Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F735C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6095D6B0096; Thu, 27 Aug 2026 22:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B96E6B0098; Thu, 27 Aug 2026 22:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483C16B0099; Thu, 27 Aug 2026 22:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF9E6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:09:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78CE7A38CC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:09:11 +0000 (UTC)
X-FDA: 85149045702.21.7D34E5D
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf08.hostedemail.com (Postfix) with ESMTP id C221C160003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:09:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf08.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5y79zmqI2DZWhhKQIRUd2sF4dzPSut9wlXPL+TKvKfE=;
	b=OyARP5CnZIsNcDWoStYaWZU16Cha8NC665BFmSZAInVfOQM6INTS4TRXWxlPptv2/JkfjR
	KCdL9Y6V6XZrVOUxm3xwhwDocrcdRJYGEVHhKAobdNkh0Xv7bRYnc0Fed74ac91nHSXG4g
	CJtcRDALUaKjNrj9aiL4DMaDT+oRlf4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf08.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882949;
	b=usXgcje2Y7Kj7jcpnrz61/hRB1RFBTcHL27cBZkYjCy5W3xrE3Lo9KplrBIXY4PQwVRSdM
	m689di0J7AvEYNmpBGf1ZHxha/qqLPF/NSE6axLkwVZsBGkZG5FPKZM6cYQs+KHU5JMKaz
	te7XPTzrj4TOUt9/C4yo3h+tQclrS18=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMJK0WNqz34Dg;
	Fri, 28 Aug 2026 10:09:05 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMJG3bKfz34Dg;
	Fri, 28 Aug 2026 10:09:02 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 4A2983104800;
	Fri, 28 Aug 2026 10:05:19 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:09:01 +0800
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
Subject: [RFC PATCH v2 16/23] sched/cache: Allow un-throttled active balance to spread out of a full LLC
Date: Fri, 28 Aug 2026 10:04:57 +0800
Message-ID: <20260828020457.785383-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: adrq4qmsmdry6z41rkmqdsuenn36f365
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C221C160003
X-Rspam-User: 
X-HE-Tag: 1787882948-336629
X-HE-Meta: U2FsdGVkX1+qg/VOXVOgmCRA02hc2ECYkI1Lbg+4mNM/OCbA7CghjXOGkbykLtiL08He3L5GnvcStWu8aLIdsSy05f+tiVPkk2rRM0ZLoRd0RmpkvEMV3g9prdBI6cwTLuRrSyyVVZ/9RvealFdoPkzGJ1FOoCTwM20bh36LRrftYYI4g/BBWpD67SMannQN6d6wZe9yPPiirSdA2cwpzX9Kicc8+Ko4iMQuo8pQk0Ah3Cc4MXAR0GLDzX00u1NG967iE73PnILZgZf8uw5Bih4HQbZ2WjVHdmC7VSHG3z1U6Rt208KeNm2j5F1s9ERxRiUJi0VrhRI8y92HzrdXOaY8etbUM9aq99o6HPHjMhwNK1sNXXvy1wtyw29B6B+rqGSfASeZrB5+cZwV3nJAxIfQplKUAZWA88AI/oO+SJtPxBog0utLgFTbUHj884vCkM/95DRa1UXCxr7NE+SMOh19rmkBuGYdYLxTgbEsn8lNjLWg06FUTStcYZ39EOfChQnsgECBjPE8zb8Z9lkODi10XOqgG/LbUBCpnmMGMa1qv/IbS/hd8YcYC0EF7Yorkjc0csqg/xrGhC1QTuq7xyBuiM1WzHVcmm9sfH0C2Rb+SLg4vcV+Yx3Kk4EMh8nq1gpiHgc3pRqLi8sGL89zP6I4NeGypYtXSUGe9Mh7ywDerZHrWv1Gq6GcoOQWCCS9IR4Y3Gc7vsVyVpsSyMOvtnUMWYT6VKbo0KTXUJLUzKJRT1MeghO5eEFsRzsa55Z0CMcpJAm2+0eIxfUa2gPfSHbpA4FXX4mLEUucKfgW+UMJiWo8zfDqNTMVp9NIDYb3lftEPz842IiXhFE8HMuHCZU5Id8TTijzJX4Yti6UKxpeRqk1qi0psTaelIFDmSeQF+LzHQ9QYG9aMo0JeXzmdSFehvHjj1zRsG54PqIYw/P/A5F+XRbYTtqmxDnMcbBAPG+JgIfiDF+mHJqDS3/
 Oc9EyDaN
 blHMr8xfHMWGNYUQq2peAsJEPCL83mn6vtc58NBUC2aoU4Z2ZEJWmb/Mi60mYjeqKtyDB2Hcl46QeaBfjQffLid06O56usTkCY1w3InlFDNxY7m29XvA+o0pWyYWCLCGvhDLWt/IgtVvLfwnqoTch03Kj2T3XzxXp/FPaaCRmbqbP1wsYcXNvgezKhAKNzc6mWQSIGYAW2UqRII/FjWJmCvbHqMaAM8xDt7nY4UDPMj6KT95OMVeuB3x3mZKsC5aydF8Gi6ND/9/pI6CDSAvDKoFCueE8HAazxnfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cache-aware aggregation reaches active balance through two asymmetric
paths. Pulling a task back to its preferred LLC uses migrate_llc_task,
which need_active_balance() lets through unconditionally. Pushing a task
the other way. Out of an LLC that is already over the aggregation cap
and into one that still has room. It only happens via migrate_task, which
first has to wait for nr_balance_failed to exceed cache_nice_tries + 2.

Let the spread direction reach active balance without the
nr_balance_failed wait as well. The source LLC must already be over the
aggregation cap and the destination must still fit under it with a full
CPU of load added, so this can only undo an overshoot and never fights
the aggregation itself.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0defdd4316b8..42ab6347e667 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13506,6 +13506,61 @@ imbalanced_active_balance(struct lb_env *env)
 	return 0;
 }
 
+#ifdef CONFIG_SCHED_CACHE
+/*
+ * Cache-aware aggregation pulls tasks back to the preferred LLC via
+ * migrate_llc_task, which reaches active balance without any
+ * nr_balance_failed gating. Spreading tasks the other way. It only
+ * happens through migrate_task, which must first wait for
+ * nr_balance_failed to exceed cache_nice_tries + 2. That asymmetry
+ * lets a few LLCs stay oversubscribed while other LLCs of the same
+ * preferred region stay idle.
+ *
+ * Allow the spread direction to active balance un-throttled as well. The
+ * source LLC must be over the aggregation cap and the destination must
+ * still fit under it, so this can only undo an overshoot and never fights
+ * the aggregation itself. Region containment is still enforced by
+ * alb_break_llc()/can_migrate_node(), which run before this.
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
+	if (fits_llc_capacity(src_util, src_cap))
+		return false;
+
+	/*
+	 * Only move when the destination still fits with a full CPU of the load
+	 * added, and when the source leads by at least two CPUs worth, so that
+	 * moving one task cannot invert the imbalance and bounce it straight
+	 * back.
+	 */
+	if (!fits_llc_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap))
+		return false;
+
+	/* Avoid threads ping-pong migration */
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
@@ -13519,6 +13574,9 @@ static int need_active_balance(struct lb_env *env)
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



