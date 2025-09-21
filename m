Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A595CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962228E0005; Sun, 21 Sep 2025 11:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A2D8E0001; Sun, 21 Sep 2025 11:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876D98E0005; Sun, 21 Sep 2025 11:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 722D58E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:09:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21E631DECD0
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:09:06 +0000 (UTC)
X-FDA: 83913590292.21.B137F1E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43A40140013
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:09:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGbS25jNIx7pjWwQtcB5db+pOJ2R5RznlLbvqfE83Qw=;
	b=5cwQqdbv/hD5hxJlV3oaG7SPNvzttfPDD+sib1lUr3Ra+KAUX3OHfJ6Y0gObDO1zWJ2veI
	bTvcbXNme88ugXdUx8Ql5Qttkj5HFatvhzcMf19NRHOWjhaABO3G7kBsrukNAHUB125fiM
	V2YTd54rkWPZPzce7RrINYrk9DITjfo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467343; a=rsa-sha256;
	cv=none;
	b=BW8MPlMtiLDstmWUJgAebqfhrktMNwFPYUGQSfhMn20IzUqzjAQx5gYW6keSupDrd/MLAe
	XkCL6cMP90Uvx/FEcOT1xztbwTQlJJiUCDnUl2mtiekaxSWcBtqzsGc25g1sCQW4QpZ5C9
	MvfQuxgnzNpJH1taBQQcbWDiBcX3Eh0=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cV8lc0d6Wz8Xs70;
	Sun, 21 Sep 2025 23:09:00 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 58LF8pmu055494;
	Sun, 21 Sep 2025 23:08:51 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:08:54 +0800 (CST)
Date: Sun, 21 Sep 2025 23:08:54 +0800 (CST)
X-Zmail-TransId: 2afa68d0150669b-1c21a
X-Mailer: Zmail v1.0
Message-ID: <20250921230854496C6rkj7YZAYi39dNV3t6Fp@zte.com.cn>
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
References: 20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>,
        <david@redhat.com>, <chengming.zhou@linux.dev>,
        <muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgMS82XSBtZW1jZzogYWRkIHBlci1tZW1jZyBrc21fcm1hcF9pdGVtcyBzdGF0?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58LF8pmu055494
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 21 Sep 2025 23:09:00 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D0150C.000/4cV8lc0d6Wz8Xs70
X-Rspamd-Queue-Id: 43A40140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: npujhibqxzoq1f9467xsddsy6iexub9b
X-HE-Tag: 1758467342-288968
X-HE-Meta: U2FsdGVkX18x6TlWVJnVdrEh0w94AJwLnKsKaQoTxieUFTg7JQkoB9Eiczk+6LR5hH12tii9JuS8DuSy4062+WP8Aoxsrlab7maKEZPx9sNLqL3y0bhSpDXOQ9cDD+6XsYzv+nCV1QEdR7nqq6qJ5qZbazcYKX31vXfDf/wEq9IscsriwV1EF+MUZF4qnppcls1S1O42p87a8jzfnwAVtBTS1XEI4ujsWIUY92+0z9Wk/J81I1R73CzfEej3Rsx/RTaLuZEbC9WzfajvyjwgZUhEbHMWy2k0y1dY154TIC+rnAq21QoVvTtKxifmAcTUEh8H0gCYdrkYv5UDfARr4VUfD/XWiGWOmoGC9h8oCOhthpC2jyx7PVwQ89hxp4VL9idj7nFRAGl9dgVMnofTxssPfVWbL+uP6uHNNXYOJOhev2qCxfgAiDlG0yJ0yTQ42D5JExQ9lrBW8Pw8zvzYpSVH2KUeZM4rBbe3BGRQLwI6itEPDqX1ClYhbgK+vqf33CJR8w8CkZEEWL1tJUvi91/CIJ5yYOnasesAGqLR69jEhGZ4l8QLq3KyA7fcWY/xKu0Q0jU+5FcuFPdxW6FY8/ZYAKu7daiYjIjC7bsIsAazyWYQvwQgtOyzzPDHqH4OQaCWJ+dHyShxdQ5Keov8nPbemUyJibSCghyosCbg6UKnDKg8p7yoJ95sURW23F1Owq0r12xoSJQP/K5yGWwO0Gf64mGPzjwjLzNg3T7I5MBHP5DvdYMulUP3tRJvgi9SR82bCJxuyVr8W/C+rmMmr65vbZzC6H9d7EfSwdRvp2aHglrxg/cD4ksrQKpjm6FRfnFakykZI9oJZPiAUa7dxGX45xzV9Hxq33wRT57RRmmnZvC/c5DNykVPkA5tC4rDmKoRvokCm5JTVK5TAbrBegmOIrsgZzC0f+OwRESh6xXwcbjmtciL3rx3Suo8RELYzwUfRHdlSjc2J1XCgLi
 gon6jYKj
 CR4mji+/egat8Ro4XybLHNukGoINxa/milxFnO7so46ByjdniPGY6ziVDE36AfVN9IE3dmOyc6T1tNRtAmE6UVzn6RtKgGxGt0ASMkAASfahdNpNzdHuRInk8PehPiEsR3PtuBFBsZwGbPkQ1oewMbsT8N26VcHEQ6yQBA9z5VsvbGtqZvzCggQboKg16XoB4C0+8lQ4suCizRPeGEWbhY7qj+dKjmR/xUjCdzq4txKBtif/UfNo5IWMDGa8rFThgRgYN2wkb0M0qfspky2BZKGWj0uCrTnUsC+gXB1A6RtwZXII=
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
 mm/ksm.c            | 39 +++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c     |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 067538fc4d58..ce2a32b73f95 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -100,6 +100,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct list_head *to_kill, int force_early);
 long ksm_process_profit(struct mm_struct *);
 bool ksm_process_mergeable(struct mm_struct *mm);
+void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s);

 #else  /* !CONFIG_KSM */

diff --git a/mm/ksm.c b/mm/ksm.c
index 2ef29802a49b..be0efa0f8f2b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -40,6 +40,7 @@
 #include <linux/oom.h>
 #include <linux/numa.h>
 #include <linux/pagewalk.h>
+#include <linux/seq_buf.h>

 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -3308,6 +3309,44 @@ long ksm_process_profit(struct mm_struct *mm)
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
index e090f29eb03b..705717f73b89 100644
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
@@ -1493,6 +1494,10 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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

