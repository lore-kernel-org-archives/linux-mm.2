Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D95C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C6E6B009F; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5FD6B00A0; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395B16B00A1; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10FA96B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAB051A034A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:38 +0000 (UTC)
X-FDA: 85146990516.14.53B1481
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id B15ADC000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834017;
	b=fV1db2zxIsJakFd9vct4UsatVKNuVUlti2Xz4No+Oqn8igy5ieh76rNIqnbDFDHnnNq0td
	21KJkt17qyrEHSSBZID69+pnROAbB0MRVjeaPxA9VUC0t1e7CSMzK8jIFHN9UTmeOVyivb
	2cCWmD/8hkPFJH/aHb+YL6kWEq4OYow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPYUTUjtMxAEL+EC+oR79no9ykn+vPNRXCUp1B2JMGE=;
	b=8Wm2PG3dJbQEJ7cFgzlp6emDPDb/F7UHNR/L3+NYk7VEcNFkm9bX+qWYC4pM4upqrZBXLW
	ETCckYCNs0Bp+6tcwlEme6WmEVsKF9MiZ9ZPkOjqklyV7B5eqmVtareG8oAionZZO48cM/
	dBgCI0D4fobocuLjENiTYOYl6MigV74=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CL0WpZzBJb6r;
	Thu, 27 Aug 2026 20:33:34 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CH2D2CzBJb6r;
	Thu, 27 Aug 2026 20:33:31 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D53FA78AD;
	Thu, 27 Aug 2026 20:33:23 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:29 +0800
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
Subject: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task migration decisions
Date: Thu, 27 Aug 2026 20:28:04 +0800
Message-ID: <20260827122816.756234-12-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B15ADC000D
X-Stat-Signature: jo4appeawyccux35nskdgqzimd3nryko
X-HE-Tag: 1787834016-452732
X-HE-Meta: U2FsdGVkX19giF+urCZi9P+NKl14LXbbsQLxk6mvJmTO6BtG7H90dzKfvhf7Y8NbX+ANHXmNS0ubv9/+Pp3SN0fsMj+w06dGmjbgSiBH0EGIkNT+Ej7/aMiwa3wdzGg0zQKO7rHPZWcFZ4suTIBpdkG6cteaB2d3BWQHCvDLSiWQiFsok0PiJ3H0zhURSk0Gg9IBWWa4eV2XIelYD7Eh+eD4DiZHogtvnYVVmZNa8X2LHWFUst4csn8lRUZ2yGGSpybdWFd9RzzIzq1Wwf7FCy2cWyKnrxtvXLF3U6Pu8FmYlS2T+3Ao5LhhH3b2bhIIOqnzEsp3c3aBMOaYLkpdwFbp3/YTMRTn7640lborFIl5spV4R2Pdh8yVl6idEQ/TchzcfLEnMqhVKjudErggqDeVUpBtFHmLPGhWpYqflu2pRYDYnrX8C8ekTHYF6blIrr/NYi2hPK8q4hKPHsxZlJikAGDFGXjrb2v3SeCGRpCrWwI4q0Ul43xHtGD8hBDWyrbHR1qALHM5bMZfiXUKbjwLYtzj5SPxiUsB3jSFi2y94xiaUe6EjzTFE9uzHj+NNExiAZSiGKKvrLtxwORLjOHYQK7jcxcw9dTsLSTYqsNPrP1/q1eEy68wW2UQRDPTN2reaxhcUOxdmraA60tAxBAMBE6F5wmKRW0qrrjT6ixhm4SOXFu/LB6bXUHn+POMRkr/MuIGw+/0wIU0R6JsqBr96kjjofpuko4uV7Z8yZNIxHGWupHVPwAUjSwz+qTgoeB/k0E/Wm0wdLT0xKtFl8qXNwZg3wIi0SsuqWFERtdhpmZ00GuKA+IVliUNAZpr12ciyICN5fLCn1lqe/rqDY13vnIukCKzy8sTDXzn12JlLSkNi8FCjM6/ModxEhcVScnZOop6C/OVSekeRJsSJAY11VvEKu+oQ8rMLmU6fpTDCPb/YZZPzd7tDJvyBMa2RgsnovKhk9yke2DSl1o
 It/g8yET
 nQFeaUM9SEnyfK6t74+V4TH8yhYNhA23k0F7aqKgPf35MwcLL6/YqYG4ei+7YZK7M5q0i74sSltLW8t+M/Pmz9ei5nZ/wlQjRlEnM2OryZSE3citOB8CjCduSDSM9m1gxPnIH9IrGnf1y7iIc3uZ/EVa8vG7pS3XCnk4sGQcDbaa5RytC2sTWI99YOjsaCqqlallnMeJJ2DSf8DMrxWbZnhq6Y4PBLE6rHgaD0NC/wgBqOEHrQzJuUu2vqCiMQarirLGUwyOLtYeLSwBZyPkn4GHtLUyd5r3hFA6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cache-aware scheduling makes migration decisions purely based on LLC
affinity, allowing moves only toward a task's preferred LLC. This rigid
policy cannot handle workloads that do not fit within a single LLC.
A better approach is on-demand thread aggregation across LLCs: as the
thread count increases, additional LLCs are recruited to host threads,
enabling workload scaling at LLC granularity.

To realize this behaviour, we need to pick the next eligible LLC once
currently selected LLCs become saturated.

Earlier patches have built node-level and LLC-level distance matrices.
From these matrices we obtain a node-affinity sequence, and within each
node an intra-node LLC-affinity sequence. These sequences provide the
priority order used to pick subsequent LLC candidates.

This patch adds a helper routine to determine whether task migration
is permitted. It checks whether the destination CPU resides within the
first eligible LLC. Migration is permitted if this condition holds,
and vice versa.

The first eligible LLC is resolved via a two-stage policy. The first
stage operates at NUMA-node granularity: we iterate over the
node-affinity sequence to find the first node that can accommodate
the task. Once such a node is found, the second stage selects the
first capacity-available LLC within this node by walking the
intra-node LLC-affinity sequence.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 185 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dc7bbdb1ab98..cfbd596992ab 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10610,6 +10610,191 @@ static enum llc_mig can_migrate_llc(int src_cpu, int dst_cpu,
 	return mig_llc;
 }
 
+/*
+ * Like get_llc_stats but for sched domain that above LLC level.
+ * Based on get_llc_stats, we can accumulate utilization and cap for
+ * sched domain in the granularity of LLC.
+ */
+static bool get_span_stats(const struct cpumask *span, unsigned long *util_out,
+					unsigned long *cap_out)
+{
+	cpumask_var_t mask;
+	int cpu;
+	unsigned long util_tmp, cap_tmp, util = 0, cap = 0;
+	struct sched_domain *sd_tmp;
+
+	if (!span || !util_out || !cap_out)
+		return false;
+
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
+		return false;
+
+	cpumask_copy(mask, span);
+	for_each_cpu(cpu, mask) {
+		if (!get_llc_stats(cpu, &util_tmp, &cap_tmp)) {
+			free_cpumask_var(mask);
+			return false;
+		}
+
+		sd_tmp = rcu_dereference(per_cpu(sd_llc, cpu));
+		cpumask_andnot(mask, mask, sched_domain_span(sd_tmp));
+		util += util_tmp;
+		cap += cap_tmp;
+	}
+
+	*util_out = util;
+	*cap_out = cap;
+
+	free_cpumask_var(mask);
+	return true;
+}
+
+/*
+ * Decide if migration should happen on a specific node.
+ * The node here is an LLC or a NUMA.
+ */
+static enum llc_mig __maybe_unused can_migrate_node(int src_cpu, int dst_cpu,
+			struct task_struct *p, bool to_pref)
+{
+	const struct cpumask *span;
+	struct mm_struct *mm;
+	unsigned long dst_util, dst_cap, tsk_util = 0;
+	unsigned long src_util = 0, src_cap = 0;
+	unsigned long acc_util = 0, acc_cap = 0;
+	int node, target_cpu = src_cpu;
+	int get_src = 0;
+
+	if (!get_llc_stats(dst_cpu, &dst_util, &dst_cap))
+		return mig_unrestricted;
+
+	if (!get_llc_stats(src_cpu, &src_util, &src_cap))
+		src_cap = 0;
+
+	if (p) {
+		mm = p->mm;
+		if (mm) {
+			if (mm->sc_stat.cpu >= 0)
+				target_cpu = mm->sc_stat.cpu;
+		}
+		tsk_util = task_util(p);
+	}
+
+	dst_util = dst_util + tsk_util;
+
+	if (to_pref) {
+		unsigned long dst_pre = dst_util - tsk_util;
+
+		if (fits_llc_capacity(dst_util, dst_cap))
+			return mig_llc;
+
+		/*
+		 * The destination is over the margin. That is a reason to
+		 * refuse a task while the margin can still be met, but not
+		 * while every LLC of the node is over it: no placement
+		 * satisfies the margin then, and refusing every migration
+		 * leaves the imbalance in place.
+		 *
+		 * Let the task through when the move still lowers the peak,
+		 * that is when the source is noticeably heavier than the
+		 * destination and carries at least two more tasks worth of
+		 * utilization. The second condition keeps the destination
+		 * from becoming the heavier side, which would bounce the
+		 * task straight back.
+		 */
+		if (src_cap && util_greater(src_util, dst_pre) &&
+		    src_util >= dst_pre + 2 * tsk_util)
+			return mig_llc;
+
+		return mig_forbid;
+	}
+
+	for_each_sched_node(target_cpu, node) {
+		unsigned long u = 0, c = 0, nu, nc;
+
+		/*
+		 * The walk starts at the anchor, so the nodes it crosses before
+		 * reaching the source say nothing about this migration: the task
+		 * does not live there and is not going there. Judging them only
+		 * lets an unrelated node with room refuse the move. Start at the
+		 * node the task actually sits on.
+		 */
+		if (!get_src) {
+			if (!cpumask_test_cpu(src_cpu, cpumask_of_node(node)))
+				continue;
+			else
+				get_src = 1;
+		}
+
+		if (cpumask_test_cpu(dst_cpu, cpumask_of_node(node))) {
+			nu = 0;
+			nc = 0;
+			for_each_llc_node_span(node, span) {
+				get_span_stats(span, &u, &c);
+				nu += u;
+				nc += c;
+				if (cpumask_test_cpu(dst_cpu, span)) {
+					if (fits_llc_capacity(u + tsk_util, c))
+						return mig_llc;
+
+					/*
+					 * The destination is over the margin,
+					 * but so may be the source. Refusing
+					 * then leaves the peak where it is:
+					 * a LLC at seven tasks stays at seven
+					 * while a neighbour in the same node
+					 * sits at four, because taking one
+					 * more would put that neighbour over
+					 * the margin as well.
+					 *
+					 * Let the task through when the move
+					 * still lowers the peak, guarded the
+					 * same way as the aggregation path:
+					 * the source must be noticeably
+					 * heavier and carry at least two more
+					 * tasks worth of utilization, so the
+					 * destination cannot end up the
+					 * heavier side and bounce it back.
+					 */
+					if (src_cap &&
+					    util_greater(src_util, u + tsk_util) &&
+					    src_util >= u + 2 * tsk_util)
+						return mig_llc;
+
+					return mig_forbid;
+				/*
+				 * A nearer LLC only justifies vetoing this
+				 * migration if the task would actually fit
+				 * there, so account for its utilization the
+				 * same way the destination branch above does.
+				 * Without it a LLC already holding one task
+				 * per core still reads as having room and
+				 * vetoes every migration towards a farther,
+				 * genuinely idle LLC.
+				 */
+				} else if (fits_llc_capacity(acc_util + nu + tsk_util,
+						acc_cap + nc)
+						&& fits_llc_capacity(u + tsk_util, c)
+						&& !util_greater(u, dst_pre))
+					return mig_forbid;
+			}
+		}
+
+		/* Don't migrate if this is a good place to live. */
+		for_each_llc_node_span(node, span) {
+			get_span_stats(span, &u, &c);
+			if (cpumask_test_cpu(src_cpu, span)) {
+				if (fits_llc_capacity(u, c))
+					return mig_forbid;
+			} else {
+				if (fits_llc_capacity(u + tsk_util, c))
+					return mig_forbid;
+			}
+		}
+	}
+
+	return mig_unrestricted;
+}
+
 /*
  * Check if task p can migrate from source LLC to
  * destination LLC in terms of cache aware load balance.
-- 
2.34.1



