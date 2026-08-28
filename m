Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B536C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214C66B0098; Thu, 27 Aug 2026 22:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3F06B0099; Thu, 27 Aug 2026 22:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E1E6B009B; Thu, 27 Aug 2026 22:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFE336B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:11:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ADE012024D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:11:42 +0000 (UTC)
X-FDA: 85149052044.03.A205622
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf19.hostedemail.com (Postfix) with ESMTP id 258331A0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:11:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf19.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLhJLmNi7i/z0sZpnQw8wGhRevh6SoMY1V1fKXv/d1g=;
	b=qktazjcLSPxzWf5qKm+rsWTgGvDBnlQYUSP29ogUgZA/i48YqOjFlPwu19CqZ/gfDoPKaI
	FeJqGXV5klQOeJOURN9KNaY9VM8eLlizxnV/bpi2yCl3uHRjMr/brSbCddzgx/hkzy9HgX
	lV0xn+m/hvBYwhPCYQTMALw5qy/wNXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883100;
	b=N7xZ15/p2quLZh02FwLMldl5xECCBB1k9PM8S77VHAvt4Mm1soLf3/zjD4errnE6cgGrJY
	kxFQ/IdsjFxCqk3v0sOWEVJ4xCFZyaZhcobsrtZYaoCoBhCUdtFJR/o3NvyKhGzikIrjvU
	hsVTSb1EZhAAseU/seGlsF3kEoWmEWM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf19.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMMC0bBFz34Dg;
	Fri, 28 Aug 2026 10:11:35 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMM90gBVz34Dg;
	Fri, 28 Aug 2026 10:11:33 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D257178AD;
	Fri, 28 Aug 2026 10:11:24 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:11:31 +0800
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
Subject: [RFC PATCH v2 17/23] sched/fair: Fine-granularity NUMA balancing
Date: Fri, 28 Aug 2026 10:07:31 +0800
Message-ID: <20260828020731.785556-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 258331A0003
X-Stat-Signature: 1non6zbyz6ekoax76g666ebeefponc1e
X-HE-Tag: 1787883098-229945
X-HE-Meta: U2FsdGVkX1+ko+yxjz8xLl6F0UYVjoMA/DUdLpLFkg6jr+fqXoOew4chDFSlfsPPn47UYM9mInP0GySSzb74aG0C2yZgx4/k1tSJcOUn6w2ECSAMum6ohBDQGgJfTcf0wYnXQ6ziy0BkW9qXP741DnMHBGSjPEPUhqdbJryGd928kRsZZf6LBjfIJ2eFmT/4BZ7hQrufvJLrcMptltjQQgff7sBhLXeJQj9gGYmc7N3+bR5NlMG+Y54mD498pRkzoCfrQ3FBDaDhFsnUOlznpjOTnLEw7Q6LQcKf2KyF+INq+Up5Q3el6tBHemN7XQoOpXm8w4cnrLd61PePPbM4iC+N+f+UK3CxKgWLXHutUJUZiX23clquo4VdO4yjNzPQRiP8lFKCX/nhnzlQ1Som/p46w4Ph7blwFvFvg22kXxk08GKVeUoTkFOyyvA59vNrWwOLH66fGLc7PlhSc9w6ZRzMLvxImFKE1VvEDM2a3KgPOLR2eFGlz4GI56NZqAngVZpbF8u3eCFqWz+ejvWwKagnH4mKXVHgtlrqEyqzIbh/gCE9hYlzk5sTiWATIfq+x9v0u/fKbfef+G46747Nhq0o5spwQVXRdU65ynVdkQ8bTL8Ezv/EK4l2fMQBnyZXPsyB8hzEPlP1vIt5kBi9/AEyepBxmX/EFc/3g3OZyJqI4ejWzoN4eLJV4WxRngceYDLchh+74a4B4//fOm/RpojUeW051xApz1390AAuWVvssCGB00OfzUxcMzpQAPANziSvb/vYej75eD3+2iQyLhVyTcqMp/czOkiR64V+cipv0Puy5I9pqCZ40U7Z4dyY3qkCDU60bjyrmKuZUxKL+oiTCBaeylhoHQ8uG8uqqT2wo96PMnHBOGgvhXdVZDxRujCVc7yQrHbyNfNht5IScyGVpu2ves/9DJzj7CmWLYg2w84HTtDM5ps1ltkuIIx7FyD9phvjcC4fFHoAp4A
 MPuTeNpD
 5XyWf7JLc26wPDprM7sjRMzr1CIgHjM7P97Qzfv+50czw3YcMGAcdhGn9Vj+nSaQoCjexBpZl4bpTNjbxkTDi20DqtPPtEOoVOyFbJtQhe3bHSZmV495OeiVksFaH7jdDLWGkpGU6ufyNvR9shTNKugjcUAt/BuTJyKiR3L7Bx1jTV0od5Avnpf5gpgj+ClaBkO46Aq5SSPA7ewQYQ/xtwnsLUUr0JNvjqNMzOeHfOhope3H0a9gt+srKVwUO6RRz75L92CAU6bbaznq6To7tsuhJo7UuuI2C9iDewuiCfFYIxK4T4cy+pahAv9UDpAnnPBe5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA balancing currently consists of two coupled components:
task migration and page migration. These two mechanisms work in tandem.
However, task migration may conflict with other subsystems such as CAS,
which aggregates tasks solely via task migration. Conflicts arise when
both CAS and NUMA balancing are enabled simultaneously.

This patch addresses the problem by introducing a fine-grained NUMA
balancing mechanism, allowing task migration and page migration to
be enabled or disabled independently.

Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched/sysctl.h | 12 +++++
 kernel/sched/core.c          | 87 ++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |  3 ++
 mm/memory.c                  |  3 ++
 4 files changed, 105 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 5a64582b086b..3434f044087e 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -23,10 +23,22 @@ enum sched_tunable_scaling {
 #define NUMA_BALANCING_NORMAL		0x1
 #define NUMA_BALANCING_MEMORY_TIERING	0x2
 
+/*
+ * Fine-grained control of the NUMA balancing sub-features. These are
+ * independent of the master NUMA_BALANCING_NORMAL switch and let the page
+ * migration and task migration paths be disabled separately.
+ */
+#define NUMA_BALANCING_PAGE_MIGRATION	0x1
+#define NUMA_BALANCING_TASK_MIGRATION	0x2
+#define NUMA_BALANCING_MIGRATE_DEFAULT	(NUMA_BALANCING_PAGE_MIGRATION | \
+					 NUMA_BALANCING_TASK_MIGRATION)
+
 #ifdef CONFIG_NUMA_BALANCING
 extern int sysctl_numa_balancing_mode;
+extern unsigned int numa_balancing_migrate_mode;
 #else
 #define sysctl_numa_balancing_mode	0
+#define numa_balancing_migrate_mode	NUMA_BALANCING_MIGRATE_DEFAULT
 #endif
 
 #endif /* _LINUX_SCHED_SYSCTL_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..8b6f2c4373ea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4621,6 +4621,9 @@ DEFINE_STATIC_KEY_FALSE(sched_numa_balancing);
 
 int sysctl_numa_balancing_mode;
 
+unsigned int numa_balancing_migrate_mode __read_mostly =
+	NUMA_BALANCING_MIGRATE_DEFAULT;
+
 static void __set_numabalancing_state(bool enabled)
 {
 	if (enabled)
@@ -4674,6 +4677,83 @@ static int sysctl_numa_balancing(const struct ctl_table *table, int write,
 	}
 	return err;
 }
+
+static void numa_balancing_mode_show(char *buf, size_t size)
+{
+	unsigned int mode = numa_balancing_migrate_mode;
+
+	switch (mode & NUMA_BALANCING_MIGRATE_DEFAULT) {
+	case NUMA_BALANCING_MIGRATE_DEFAULT:
+		strscpy(buf, "page_mig task_mig", size);
+		break;
+	case NUMA_BALANCING_PAGE_MIGRATION:
+		strscpy(buf, "page_mig", size);
+		break;
+	case NUMA_BALANCING_TASK_MIGRATION:
+		strscpy(buf, "task_mig", size);
+		break;
+	default:
+		strscpy(buf, "none", size);
+	}
+}
+
+static int numa_balancing_mode_parse(char *buf)
+{
+	unsigned int mode = numa_balancing_migrate_mode;
+	char *tok;
+
+	while ((tok = strsep(&buf, " \t\n,")) != NULL) {
+		if (!*tok)
+			continue;
+
+		if (!strcmp(tok, "default") || !strcmp(tok, "enable") ||
+		    !strcmp(tok, "all")) {
+			mode = NUMA_BALANCING_MIGRATE_DEFAULT;
+		} else if (!strcmp(tok, "disable") || !strcmp(tok, "none") ||
+			   !strcmp(tok, "off")) {
+			mode = 0;
+		} else if (!strcmp(tok, "no_page_mig")) {
+			mode &= ~NUMA_BALANCING_PAGE_MIGRATION;
+		} else if (!strcmp(tok, "no_task_mig")) {
+			mode &= ~NUMA_BALANCING_TASK_MIGRATION;
+		} else if (!strcmp(tok, "page_mig")) {
+			mode |= NUMA_BALANCING_PAGE_MIGRATION;
+		} else if (!strcmp(tok, "task_mig")) {
+			mode |= NUMA_BALANCING_TASK_MIGRATION;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	numa_balancing_migrate_mode = mode;
+	return 0;
+}
+
+static int proc_numa_balancing_mode(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	char buf[32];
+	int err;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	t = *table;
+	t.data = buf;
+	t.maxlen = sizeof(buf);
+
+	if (write) {
+		buf[0] = '\0';
+		err = proc_dostring(&t, write, buffer, lenp, ppos);
+		if (err)
+			return err;
+		return numa_balancing_mode_parse(buf);
+	}
+
+	numa_balancing_mode_show(buf, sizeof(buf));
+	return proc_dostring(&t, write, buffer, lenp, ppos);
+}
 #endif /* CONFIG_PROC_SYSCTL */
 #endif /* CONFIG_NUMA_BALANCING */
 
@@ -4787,6 +4867,13 @@ static const struct ctl_table sched_core_sysctls[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_FOUR,
 	},
+	{
+		.procname	= "numa_balancing_mode",
+		.data		= NULL, /* filled in by handler */
+		.maxlen		= 32,
+		.mode		= 0644,
+		.proc_handler	= proc_numa_balancing_mode,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 };
 static int __init sched_core_sysctl_init(void)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42ab6347e667..00f49e767583 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3312,6 +3312,9 @@ static int task_numa_migrate(struct task_struct *p)
 	struct rq *best_rq;
 	int nid, ret, dist;
 
+	if (!(numa_balancing_migrate_mode & NUMA_BALANCING_TASK_MIGRATION))
+		return -EAGAIN;
+
 	/*
 	 * Pick the lowest SD_NUMA domain, as that would have the smallest
 	 * imbalance and would be the first to start moving tasks about.
diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..47c9614dd54c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6049,6 +6049,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		*flags |= TNF_FAULT_LOCAL;
 	}
 
+	if (!(numa_balancing_migrate_mode & NUMA_BALANCING_PAGE_MIGRATION))
+		return NUMA_NO_NODE;
+
 	return mpol_misplaced(folio, vmf, addr);
 }
 
-- 
2.34.1



