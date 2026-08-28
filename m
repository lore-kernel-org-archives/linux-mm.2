Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA63C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DC46B0088; Thu, 27 Aug 2026 22:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864FF6B008A; Thu, 27 Aug 2026 22:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6376B0092; Thu, 27 Aug 2026 22:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5212E6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:19:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C46E8C0275
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:19:58 +0000 (UTC)
X-FDA: 85149072876.08.E702E5A
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id 12EE440006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:19:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883596;
	b=S9aEN6Q2phHqq+w3/9j5IILiUM29uQ0+eosWwCh6d1bTDSTsX4peRKs7vN9PB42hyEt9me
	+fzwSvWaz47bV+A3+kWIRFdt5izlL93/fUg2Q0jawqggV/YVjHfYApffWK/akxEST0ww8Y
	OHuiO/1NsDEwvZ9XnpfHhChko9cCUOc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IfGZTfTLcgVln0a/8bpI+8X/3mYKgPlsVOSLZmLHSZw=;
	b=ULMoy52KgeOcLaXfuaHFGVRHNI+G5ezgvMykk72ibeuWnrZDirLvp4FER/1riXakkHmIrQ
	iYnRj7h7aV4PhVeE3JdRnLiGTPNAyaI9cc394dP3LktOkn+hX/sVQfcV+RM2pSFh/QYyck
	Hr6naYow36GV5w/PlAA2+TXFPd11Mdk=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMXn0rTwz34Dg;
	Fri, 28 Aug 2026 10:19:53 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMXl32BHz34Dg;
	Fri, 28 Aug 2026 10:19:51 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 36E303104800;
	Fri, 28 Aug 2026 10:16:08 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:19:50 +0800
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
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>, XIAO WU <xiaowu.417@qq.com>
Subject: [RFC PATCH v2 23/23] sched/debug: Print task preferred LLC for scheduler debugging
Date: Fri, 28 Aug 2026 10:15:54 +0800
Message-ID: <20260828021554.785781-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12EE440006
X-Stat-Signature: oi66o3at37watoi87xo9bunnkjdx4f8p
X-Rspam-User: 
X-HE-Tag: 1787883595-3418
X-HE-Meta: U2FsdGVkX1/q73BxBfzh9ZslGQhjtdazQMW1CTl30NkREiTGccTh2jMf+xdws99evXk2DpApbg8bT9vflziZ+F+KNpHsqskoSnLbijNBdnkcfGxAU5uDxgXUjYYdEenLQXDVfoxrs/nbxQSxBO31HvHGcmQWuBJZI3hE+7x/HTQR4TXEMaekJ6RUnqQL8oCe9t5aYuREN5DB26/pg7MKbX4ODLZeLlxO4VFqwxKHZXpfXLF0/YO+xw1wxGCjnMY5jkw4QBE4PQf+hIY1spgmnlsuEVpJYI6VQ49JkMUxKXyj6bjQMRmN7kPkC7eQPdHbJX/VpoqHTnJWNjkgFKHm3BVUiLNbZNV6DJN9xB3Ji0ZISImrtyFrNIXkOR4plUIA3jGMRa1QmoMxOQl8jDPsQmLkhO2/aQ5xsAspzCLIVCdrr7vPT/PaDqefPKgNLC9yyfBvGAv6F5ReQQTmV3Mc1CTwz4xklMxmAKt9fBNYRn06QsDOoDakVXVHNw8SjvpNiz4ljSnCqb5en1ALoTWMjPgSddbf/gwgd30FxnHjxh5jAnBzcVSzVaU2Js/+bq/AM/k3AzmwyM9OulXTdEqjkBF8qNyXMvMA5uIdBaS8lBPpr3cP90R3tjQFWM8iuf060mk1vOlMjcqyyMGw7RPZKNJU0cEu4EdvAH/3mhPum4pKFJoLDyBxyVTOpNME1q2Fc/N6pNtFAOj0TRqEbkuxYl080hFNrdRFi+0VQPtiRVSRBWCv3bju+dZW5KahVEp2v/aTqz8O0jGBIcZ6xpBwVZbTVGFFBkPJ45CSIlODe+XUXb4DSO8QDFQMgYK6Y9yqAMNdNa8u/JV4mEBHXJL4hEiJxj4pXs/zv5dc285b2rIapFDfL4gku7j1W6p9jaMDjm1iijUNvIZ+d5RHGtrmjTqlj0ccLgq1GpndPK4tfijvOt6/q37SMGQAmXfBzCZ0WTfOhC9TlZsm9vvKqTK
 QREbmhDz
 gCvLZIh1BVHfotjOz4qoxO0n3hGxs23Oeiat3ERUVhpHpfMnUZ4xC1lX4rCAqBZiFgQYBnJN+8AT9WftK8bZRzWQ+EaW1k9vgW1BamntHlOT0vSkb9s+j3qbTH/iA22xvspVlbSOGohVjRtBloPU+qFCEwQhcTuAaaRcqWAmp7S2SReD8UHYvMyiHp6jy+vK34DnZUslKT7kjou6m4AM4H4IVVZRFCFiUhlQLdJPAp9SXQEZDXxaUA68Y7VUbqhKNFiZHu7LJG/1oSuxkxOOTLJ0gw5E6BODQaF/u5IiNJ3TKSLzs/cNYKTeLL3lPGErTSpaMrKfH3eeSADTQI0Gztr5c6ZclAmnSbDUx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose each task's preferred LLC to aid diagnosis of cache-aware
scheduling decisions.

Suggested-by: XIAO WU <xiaowu.417@qq.com>
Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/debug.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 40584b27ea0c..d18dbc1da67c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -9,7 +9,9 @@
 #include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/log2.h>
+#include <linux/sched/clock.h>
 #include "sched.h"
+#include <linux/sched/debug.h>
 
 /*
  * This allows printing both to /sys/kernel/debug/sched/debug and
@@ -1304,7 +1306,6 @@ void print_numa_stats(struct seq_file *m, int node, unsigned long tsf,
 }
 #endif
 
-
 static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 {
 #ifdef CONFIG_NUMA_BALANCING
@@ -1320,6 +1321,30 @@ static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
+static void sched_show_cache(struct task_struct *p, struct seq_file *m)
+{
+#ifdef CONFIG_SCHED_CACHE
+	struct mm_struct *mm = NULL;
+	int sc_cpu, sc_llc, sc_node, pref_llc, pref_node;
+
+	mm = get_task_mm(p);
+
+	if (mm) {
+		sc_cpu = READ_ONCE(mm->sc_stat.cpu);
+		sc_llc  = (sc_cpu >= 0) ? per_cpu(sd_llc_id, sc_cpu) : -1;
+		sc_node = (sc_cpu >= 0) ? cpu_to_node(sc_cpu) : -1;
+		pref_llc  = READ_ONCE(p->preferred_llc);
+		pref_node = (pref_llc >= 0) ? llc_to_node(pref_llc) : -1;
+
+		SEQ_printf(m, "sc_stat_cpu=%d, sc_llc=%d, sc_node=%d\n",
+			   sc_cpu, sc_llc, sc_node);
+		SEQ_printf(m, "preferred_llc=%d, preferred_llc_node=%d\n",
+			   pref_llc, pref_node);
+		mmput(mm);
+	}
+#endif /* CONFIG_SCHED_CACHE */
+}
+
 void proc_sched_show_task(struct task_struct *p, struct pid_namespace *ns,
 						  struct seq_file *m)
 {
@@ -1439,6 +1464,7 @@ void proc_sched_show_task(struct task_struct *p, struct pid_namespace *ns,
 	}
 
 	sched_show_numa(p, m);
+	sched_show_cache(p, m);
 }
 
 void proc_sched_set_task(struct task_struct *p)
-- 
2.34.1



