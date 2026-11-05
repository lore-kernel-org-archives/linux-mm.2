Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34B9606D81D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=WL6PU8V6
Received: by kanga.kvack.org (Postfix)
	id AEC346B05BB; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26536B05BD; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF446B05BC; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8CE6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD871C0C25
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:52 +0000 (UTC)
X-FDA: 85402224264.27.F774E67
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4F5C11C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=WL6PU8V6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0WVyU8Un4WAL07LgGPKN8XU7yNyVH1mBvR0bHvznHQ=;
	b=cMaWElk/Z5eACzkf+weIwL+sobfjJHZSy+UVmRnGSZXrdLwkmZJOKs//NlGCFts8tOqE0R
	rtJVOCcRfLJttChB0Yi+AJqdfJ5llx37gBMc0ItZfCPWHA+8+7nOHVpYeHlVJ379/JqKX0
	wfaefFFwx0p9oDa9exwrEf5dxRLszbY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=WL6PU8V6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911011;
	b=mBIEQXh1kn3IYMiYGYG1gpaL/gjtwiQSq3EmpXBPkNBoq9Zw/+uT8FmwW9WKHpfsUM8Iu5
	/t6IZl+jitauEiJpMp5NHdTvU0s/g9zP8u+40XrwliIISXaf5YhSBXRZtSNJhfFAA2Qj2I
	srhXz1eAUTQRRs69/vTIP8/6YgLAhJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793911009;
	bh=G0WVyU8Un4WAL07LgGPKN8XU7yNyVH1mBvR0bHvznHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL6PU8V6xR42qUbWCNtbIbLtRPeNC3or5BwyPo+WXFBjfS8JUmHvPKnS027BtAnyx
	 5CYyBklEb1I9305/HOyfc/HSgj3lKQAQszFLsrSI3bzcl2p7FNT5KJ8yoTlLNgMkT7
	 0fZi6iYBK67K0al36VZ0OxtZLuLG1B5MhzQgYQ7qolNeDRTlIcJL60OoPEsEvQLrVe
	 xSWUUK8UhOksiqWpXnWljV5AT6HrUNEsW26w+BatZMX2itfpuC7CyoD3zJ6GFj8eun
	 2KnWpEUDZjLFYIizWciPaTlhqPAiHZmYQy/uJYooZws+Em+Uao9NmPDzQ2S8oPfOAp
	 2ttfBgeRztBPQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLDcd1DrJzLrQ;
	Thu, 05 Nov 2026 15:36:49 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v24 09/10] mm: add the rss_stat_batch boot parameter
Date: Thu,  5 Nov 2026 15:36:38 -0500
Message-Id: <20261105203639.1459524-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F5C11C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t8pha3qty3ajw9g9n75engu9gd63kbyi
X-HE-Tag: 1793911011-665872
X-HE-Meta: U2FsdGVkX18uZgKIH1UfTZpW66A1MH/rK5nYUaxPki5m6+czDSTBAib43sF/9dOL4ZRXcwAoUrHi54q9te3cspp+BK0NOy+0py2b4KCj4wI33g5Vv77hV151wxx1GdOPkZPYmAcOyZrh8Ka25t00weF8kLOIqWZOX4xANnh4zs0neFKeq0xeHGXxM4wsX9m+xULmC5qlU9B0ewAZ/irW/LsKmweIxTmEjNoQKThWhy/rQVDLjBn3rvMIedoMz/H76AJ1KMJLZSCZsDlJ5eB1Peu2gq3r66AGjg+KTLhYviA/DH3Pn+TEqioKn/q6SR4unIVeedHqS28jlq2dz0NPMQyUmD+kjjZiRAsoNhdLmr7qOf7thVCb9NtwJBaT32MxmyMK3zB0AvFVRxIKgHl5mYoWT//l8/KKIt1fR3dFCviZNoqwi3l/jZhacp6ZSRvvZrMan6ko7zecSTKZQkrA3k4alQBACVpOq1DhLjDKpDzSv/JJxtsZzNHe4HD7j22gn+2FVxo0f95f7simSsabMKCYXtPdynGFJBnRKtwkiWwn0hqOm2imQkTu6Gvsdo4yHILCSO0iwwMgpSohxTROjf3ZSuE3YjMQX7szJtIsfCuYw/V8t0fTfX46air7l5EU7zP0pAGo/6CreTz/iBjipD+g9CTVZ5SQPzk56ZZamySsbnlZTjEe4+YquPBLGTvAQqq1occkxIXBB1NoPEGfCCI8R7dawKzWaH2ivXVnVJ6DtteVWzsOTA7zD8YiKpbnQ9yx73STu2eSOSkUSrGIRgD+rAS3IJnXInfXGsrOVokSwSA+RTpVZixySLlZ2JZaLEZ5eP0h3sjzRreoUa5IRrUWRrP94/olRmefQJbvREftMTkRbvkIHmgpBBA9Fnj2XPLmeY80AOdC0c8b1JkUUJhu2djpLYq+r+muXC1z19FWD68vCtHixYJX2ycyUxIxiulnS+SpecWlsLsY7KW
 zEN8eitW
 1Jv9NqoMHAb0f9pspqbF/1xlOy86THC4ESfIPGUfK3/Hf34Oaxmoi4M4c3axow9MhE9IX7GUKcjbBSYQFA8Ow7i8ZiaJtp6CfNsQXKzUVIkwEnNvtffeMmAJxWdqFLI1MS0GfdiZ0kH9qI1OyJnVQkge7BlETiBYuTEHkvy5DM/vP/glJp6OyeBbmKC7Y9vPndC37q/ks5P8B3GLW0RxBIlActdDLhlZlZ1fxMbgKinGtj72IAz80ZFL6KDQQwySqvaL5HgZ+gReNO/IHAvUqaAgcs+bFUK4igHW/CRUzD3flsW4JRmUV0Y9xrHqsW2e8Y3oRxY4yLUUEIjEAQwkDp+jGNfp3yknfBos7PdcZTkw2vMOPZ8L/qnVSVCNW3ZKTAAqrB2ZFq3yzjqU3nVB5o8cieqFc17QA5wqSGVHMtRhGUgcDNuZr1aMEQSQcSvPPnJTJ9SxOIYDX3MwcfxbH+mcWUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The RSS counters use a batch size of 32: each CPU accumulates up to 31
pages in either direction before propagating a carry into the counter
tree.  A smaller batch improves the accuracy of the approximate RSS, and
a larger batch reduces the cost of updates.

Add the rss_stat_batch= boot parameter to compare batch sizes on a
given machine, along with the percpu_counter_tree.arity= boot parameter
for the tree shape.  It accepts a power of 2 between 2 and 128, and is
ignored with a warning otherwise.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../admin-guide/kernel-parameters.txt         | 10 ++++++++
 kernel/fork.c                                 | 23 ++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c368affa2115..ba2bdeb1480b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6792,6 +6792,16 @@ Kernel parameters
 			debug mode. Defaults to CONFIG_RSEQ_DEBUG_DEFAULT_ENABLE.
 			Format: <bool>
 
+	rss_stat_batch=	[KNL,SMP]
+			Format: <integer>
+			Batch size of the per-mm RSS counters: the number of
+			pages a CPU accumulates before propagating them into
+			the counter tree. A power of 2 between 2 and 128.
+			A smaller batch improves the accuracy of the
+			approximate RSS, a larger batch reduces the update
+			cost. Default: 32.
+			This parameter is meant for performance comparison.
+
 	rt_group_sched=	[KNL] Enable or disable SCHED_RR/FIFO group scheduling
 			when CONFIG_RT_GROUP_SCHED=y. Defaults to
 			!CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED.
diff --git a/kernel/fork.c b/kernel/fork.c
index ac4eb1370e62..d0641700cd9c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -138,9 +138,26 @@
 #define MAX_THREADS FUTEX_TID_MASK
 
 /*
- * Batch size of rss stat approximation
+ * Batch size of rss stat approximation, tunable with the rss_stat_batch=
+ * boot parameter to compare batch sizes on a given machine.
  */
-#define RSS_STAT_BATCH_SIZE	32
+static unsigned int rss_stat_batch_size __ro_after_init = 32;
+
+static int __init setup_rss_stat_batch(char *str)
+{
+	unsigned int batch;
+
+	if (kstrtouint(str, 0, &batch) || batch < 2 || !is_power_of_2(batch) ||
+	    batch > PERCPU_COUNTER_TREE_MAX_BATCH) {
+		pr_warn("rss_stat_batch: expecting a power of 2 between 2 and %u\n",
+			PERCPU_COUNTER_TREE_MAX_BATCH);
+		return 1;
+	}
+	rss_stat_batch_size = batch;
+	pr_info("rss_stat_batch: %u\n", batch);
+	return 1;
+}
+__setup("rss_stat_batch=", setup_rss_stat_batch);
 
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
@@ -1149,7 +1166,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	if (mm_alloc_sched(mm))
 		goto fail_sched;
 
-	if (percpu_counter_tree_init_many_lazy(mm->rss_stat, NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE))
+	if (percpu_counter_tree_init_many_lazy(mm->rss_stat, NR_MM_COUNTERS, rss_stat_batch_size))
 		goto fail_pcpu;
 
 	lru_gen_init_mm(mm);
-- 
2.47.3


