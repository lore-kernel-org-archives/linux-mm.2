Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5CBCAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425438E0005; Sun, 14 Sep 2025 06:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6008E0001; Sun, 14 Sep 2025 06:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4078E0005; Sun, 14 Sep 2025 06:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11A988E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:04:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB61B85958
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:04:03 +0000 (UTC)
X-FDA: 83887419966.28.59538A2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id D1B25160004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:04:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3HW3EUAHidUrSqa8mcYFKLLp8TrVNBHqWNN47SO9lxY=;
	b=yrXX22g6xCuHdnSqv4NiVYu3PSOspKD32HAC9pa7ErAkSTk3Gt5uveWtPD6K3BSO9sIkLz
	5X1O00h3svABopGg6EETqvH18bxHR5iKyne8t8HkxbtpZcNY5knAU3TLv2N35CEicHSXtH
	KE1YskAUApNRoklcXIFeoxpy7x1Dy3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844241; a=rsa-sha256;
	cv=none;
	b=lX4Oo1QTo+67sAu45xweyCudQ/aArPnh7QVKpQ3OIMoj+EshYlKpEzEVKXdflvuWPxO59Y
	cHNXG65JPuuVq79h1mErSz0UOBaPifqkwDCfIJpmVxMCe+LUIbgsNUrm8saXoZa2phcPqT
	fobWcj4amVUx5QIkSIcwPOgXRcJO4LI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPkJr6x1Bz5PM38;
	Sun, 14 Sep 2025 18:03:56 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 58EA3mCY092681;
	Sun, 14 Sep 2025 18:03:49 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:03:51 +0800 (CST)
Date: Sun, 14 Sep 2025 18:03:51 +0800 (CST)
X-Zmail-TransId: 2afa68c69307545-58a60
X-Mailer: Zmail v1.0
Message-ID: <20250914180351288rcLuZnPAMUej48nuTc7KV@zte.com.cn>
In-Reply-To: <20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn>
References: 20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <shakeel.butt@linux.dev>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
        <roman.gushchin@linux.dev>, <david@redhat.com>,
        <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvNV0gbWVtY2c6IGFkZCBwZXItbWVtY2cga3NtX3JtYXBfaXRlbXMgc3RhdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58EA3mCY092681
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 14 Sep 2025 18:03:56 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C6930C.000/4cPkJr6x1Bz5PM38
X-Rspamd-Queue-Id: D1B25160004
X-Stat-Signature: nwoknhdjw69uy65kgaaz8si6qokgpx8b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757844240-607434
X-HE-Meta: U2FsdGVkX1/tUBni8eTANO4RMLqNlaVHX7wpap28qeKCCM/Lk32gBZ+WnrdEvv0SAfFTenBJw6oW+BFfpbXZBY9Ax6tylm0qU+XgstLp9TRGzp1P3fd91vBtPIgMiBM000q9ihrJXSYpjm5HnEc/r3EdJRZ41mLBwllZx219Ck9WPW6Y/yP2O3+hryTJ+DSrV8Wud+UkftoAxLmZppM58g6PWPUlLAwFgPt9OTofUNPfkE2p2jI4tRFSbbSeAA+5mzP6G2/TYegsJavtH9vkyR84a0bJ9vDGDnK/9dvZcULqDJ373dL3sURFJxU+HdCuDIpqdS52YzuiB07Qs7kBHt4HM/AEWcTvkvy5p7BhZBLSBKgyhT2iBAzjHbbOzSwKYEaGsEwfFHsOA/oZdrntWKWpPb6ArQeu++atl4vKncpLQ9Qqg6gxOOBsgJ4Uqs3Sn0H7tzLHGV5q7ENGX6EKRSfXxtWFJ9jbhXi3NiWu7JkPump0eRkMu81H7jJxMwQUs4Sdh0gatkRkxBctfzf0Vyb3TQsFn+KvBShfO3NuQKXBGzr4MMwr/G4cD7t5Z+yWxznVQ35NCmwm6KBCCJGbU5AeiYe75o1fR59LaX6kNmPd7J5+ABSIHn5jlrdRJe13gUhD6tboSKNXgXy3/Yxu/qmBbxLPgI4LmtRyZA75Pg17VInNJYHXvzlShSOZv3fPqkojAPFSP2MzR7VdCU9Z+nDehTqVY2BALvriO3wRs+OedjYPzPAAVWKG1n4f9QT58tTraR0vp7ICg+4eynVxMUB9FY4pFRoTE5Wuyc8tppD+hz1z8lMZjmhMf20Ak52mUjtyibYfZM8MMXY0hS0ay2uJjKtD389YqvnI76+lBynzcQ1ZCwqAYcCzvwnV3pDVmHDtHTNnpreu9JVlMXEGly0De5gi+uPHINgWUnWc9NUdUP5pYhhQGXW4Qw0esEIaxoaDzqUmaKpVfy8B+f6
 Q5OLpt7c
 rV7VlQKVVF3zWj66QxgKhhY6gYHf6HcobE+xVq4Re8/op9Keo/apjFMtwAcGeWImL6xPL7THsP1cAd6EqFoHHjuTb5d35YCuSoEi9SpX8OZsUNcyC719dY0oTMdiMbtNX1RKXT87vXeExmOw6W6wtwm8G5byreL9Lc0m3kY05gUpp2LsVz5EKnr2ALXfxXRkoodl8YGeY+50ZH5Aoqz0Jhb6+ahHcf1RFJH0Wp0P6OPfZcRBwbsgA2b35hW1KERMmopGFAmHFbrLqtsfRx3u6JQrUgV/4tCFKrp0DJh2fQHp23Rc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

With the enablement of container-level KSM (e.g., via prctl), there is
a growing demand for container-level observability of KSM behavior.

The value of "ksm_rmap_items" indicates the total allocated ksm
rmap_items of this memcg, which could be used to determine how
unbeneficial the ksm-policy (like madvise), they are using brings,
since the bigger the ratio of ksm_rmap_items over ksm_merging_pages,
the more unbeneficial the ksm bring.

Add the counter in the existing memory.stat without adding a new interface.
We traverse all processes of a memcg and summing the processes'
ksm_rmap_items counters instead of adding enum item in memcg_stat_item
or node_stat_item and updating the corresponding enum counter when
ksmd manipulate pages.

Finally, we can look up ksm_rmap_items of per-memcg simply by:

    cat /sys/fs/cgroup/memory.stat | grep ksm_rmap_items

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/linux/ksm.h |  1 +
 mm/ksm.c            | 38 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c     |  5 +++++
 3 files changed, 44 insertions(+)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 22e67ca7cba3..a41ed503f152 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -94,6 +94,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct list_head *to_kill, int force_early);
 long ksm_process_profit(struct mm_struct *);
 bool ksm_process_mergeable(struct mm_struct *mm);
+void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s);

 #else  /* !CONFIG_KSM */

diff --git a/mm/ksm.c b/mm/ksm.c
index 2ef29802a49b..b533f0edaf96 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3308,6 +3308,44 @@ long ksm_process_profit(struct mm_struct *mm)
 }
 #endif /* CONFIG_PROC_FS */

+#ifdef CONFIG_MEMCG
+struct memcg_ksm_stat {
+	unsigned long ksm_rmap_items;
+};
+
+static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
+{
+	struct mm_struct *mm;
+	struct memcg_ksm_stat *ksm_stat = arg;
+
+	mm = get_task_mm(task);
+	if (mm) {
+		ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
+		mmput(mm);
+	}
+
+	return 0;
+}
+
+/* Show the ksm statistic count at memory.stat under cgroup mountpoint */
+void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
+{
+	struct memcg_ksm_stat ksm_stat;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/* Just use the global counters when root memcg */
+		ksm_stat.ksm_rmap_items = ksm_rmap_items;
+	} else {
+		/* Initialization */
+		ksm_stat.ksm_rmap_items = 0;
+		/* Summing all processes'ksm statistic items */
+		mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
+	}
+	/* Print memcg ksm statistic items */
+	seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
+}
+#endif
+
 #ifdef CONFIG_SYSFS
 /*
  * This all compiles without CONFIG_SYSFS, but is a waste of space.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 257d2c76b730..9595b132c6c3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/ksm.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -1492,6 +1493,10 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		}
 	}

+#ifdef CONFIG_KSM
+	memcg_stat_ksm_show(memcg, s);
+#endif
+
 	/* Accumulated memory events */
 	seq_buf_printf(s, "pgscan %lu\n",
 		       memcg_events(memcg, PGSCAN_KSWAPD) +
-- 
2.25.1

