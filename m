Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E3A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE846B00EF; Wed, 28 Oct 2026 23:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196746B05B2; Wed, 28 Oct 2026 23:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D46F6B05B4; Wed, 28 Oct 2026 23:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E26586B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:04:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74DBC1602C2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:04:39 +0000 (UTC)
X-FDA: 85374171078.11.5B4C4D4
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73D2E180004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:04:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vv+IYR9dud8EsrFaA0dR51P4en2GrhP5pTZk8r56EFQ=;
	b=dC8/VKJU2h64P4HdwRYzSDKGWf0dl/vYjGZX40WEvN5jssFhqztWeP1s0AUl8w/MtvBlBH
	uUKg4rxK3p89RWoxDRWOwUMMhVj27ShE+XONPzsgrR7dsHVeqh2u5pEC+yAKCO7IOFODfC
	1zsPmnSs6QlbaUsVHMh0zIoVWVpc1hU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243077;
	b=QLYMWY8o+GhrPaCVqxdfFcec5gTP02TFuJWss7gu6aIgpw73mDl/YPs6D6+aidGiyhQnxc
	CjCO3bdJ2VtTHx4Ea1pmvzBg2IZiYjZwNoYvLIOD1VId4mHSj0rVD0QPcFjADa8qoaNvoM
	IJbMhR8hlCECPOaF5zZwWMMZXs4O/D0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTbj1Q1Cz171YY;
	Thu, 29 Oct 2026 11:04:33 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTbf6Gr6z171YY;
	Thu, 29 Oct 2026 11:04:30 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 027055943;
	Thu, 29 Oct 2026 11:04:24 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 11:04:24 +0800
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
	<yingzhiwei@hygon.cn>, XIAO WU <xiaowu.417@qq.com>
Subject: [RFC PATCH v3 17/17] sched/debug: Show cache placement and preferred LLC in /proc/<pid>/sched
Date: Thu, 29 Oct 2026 10:59:40 +0800
Message-ID: <20261029025940.4005235-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73D2E180004
X-Stat-Signature: hq3s34au6s5f5af36hx6d7ghsyz8cc4y
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793243076-570573
X-HE-Meta: U2FsdGVkX19o/EYK02tgxf06lu0G//BKdxbNkp1ZIOUOH4iLiPiT+ZRhftWCebEeOi0tDXk2IdKhdE6wyE0g1Vm+EYjgcnSAPQz2vegx6JWs5hWTAeuxdSmq6dWGpFz6xFvlMcQyFLPu+MyQw1Ddp58o9XUCf+riWnDqPxa95mvwg8A7zBUht3hZCOYdlyhUEzg/lhHaoD2yHMylA3b6EGjYskzdTnXTYIh6Hccxj4nwwPlz+9o8v6bSv7iq3Wv5AOoB1mOh/2UL09+dinLJ8z0ns7ijpNGGBS9hODjjXEMg0nBM60KY8CGuitjQYbh7uyS76Nyu8dXlU2eqFjucu+Tbk5I+AGMYTG2nHglibjuPuRe8uGonjd3Ga3+yACcm6SlLPZ3YuzqhJ4IW+Bn3M6eP/564H6SMZ8irzeawa5nsp/NepPn9bE3IQ0/UKPPW181g/Rg1b3bXuwFQh02Mh1sFqYKDhqoM6l8lVynzMn75GyPf/0hNRqCsA10tFlSn6BqCIONpDUeVzcTuxnPKlBfkFMh/bfOj1nCtC0P0Y809yiXIw3vU8fcd0Q29zYyEwLpCAPxH4IqZOl4bqKd6kVuzIC1b8hOG1OM9esED1Y/jLlcm6UFdsrMwTjVzGc53rCZY4S4DuGmBa/gQPJFiveI4337JNVM9avFYig21DWo9Z7eerwNEMl4Iol/KSbcBELR6PKnQAJdVgsmNumSStlyPCcBkxlPnXvSpyMeAYKtov0Ce8wwaCskBpMsQauZHLwcMSvEDjU1a4pOMDPGahO3Lf3/gCboH136R8/2bjl+MUbj5N2nDmcDhWQ8av42cQuECeXLO+1s6/2ls/wMSUtPCM77/DAueNCMrJDDJ10QKRO2IysIef3ncQ+wJjiDnpst3Hlc2COqELE6zw9JUHe8uEvfOOb5qzm2RMNunAmtFh1fewAhpymg+93UDtptKFTVXmGXFL+Sc+ym827g
 m6RNIF7j
 1wRHVooUcMAGvnIR7bOhgzzw9vXJTVG9UbxHDl3tPjJKTBchhCqp2FetO3BzLUF89y8y7cKTgF6N7l20K+18YrjVc6gmqHtmltUQf0edVe1HOwUkNhF9j5cp2g9Gnt+zPusev6LHAlsIGkmDYsTkJ7VYfbAnvSC41C+cHI0Tq9Qx9i3Z8eANp3DPyV1jk2M8fJzYLzx8l2J0+6AXT5YxSiWgCNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Print the mm's selected CPU and its LLC and NUMA node, alongside the
task's preferred LLC and its NUMA node. This helps diagnose cache-aware
scheduling and task placement decisions.

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



