Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADA5606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Mh2zpbk5
Received: by kanga.kvack.org (Postfix)
	id 3D9286B05BC; Mon,  2 Nov 2026 14:07:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3327B6B05BF; Mon,  2 Nov 2026 14:07:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DD76B05BD; Mon,  2 Nov 2026 14:07:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B46506B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9615F4022E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:37 +0000 (UTC)
X-FDA: 85391112954.28.873EFF7
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A0AF1C000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Mh2zpbk5;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0WVyU8Un4WAL07LgGPKN8XU7yNyVH1mBvR0bHvznHQ=;
	b=UbZ/xpz4pf1seu+ZHy2aSjLOhVApdkIFDnqRXcnWpsGxfRcLEuOLdDZyXEcGKqorPnbGLH
	A2to63NpAC4MliK43mlDKGkfh+fxO5wZbhrDXdvpzoTfsm768zaI/hBAmUw1cqACRZezGr
	JDMkbPUQa88Fi0xnsG5TXMB/IFvBsRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646456;
	b=CSSrgH9MNxLFXsVDVlusUnpQlqkbYKJafH+Viv/Sh7ofygMK/sgjjXGzJDk34gYtqSbgwZ
	k8giR1tZZsze5X0/FQFglfwuBcIAHiI1qCSvofrQQf3QROniLCSES8mI8/ZGIM+dPfyF1e
	uCatCRuzkSagds1O0E5O4XR2ss++CI4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Mh2zpbk5;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793646453;
	bh=G0WVyU8Un4WAL07LgGPKN8XU7yNyVH1mBvR0bHvznHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mh2zpbk5HcY3k+8abis5Ek0622v4bMoyR0nJAnUTkrNm9Vl/n181MfWGGWqmH3wxL
	 t+U2ejc9MHdEzrBL+/nqLIFC22JBlC9y8WP7bbY7A3OrhSxGQOeJwUSiYIGkC4QOf1
	 tMLTStTfbf7OSC70cP324INqFKHyS/aZtflwSiPjEBR8nzBWQSUOyWjcS00tHF9ZhD
	 tP4NO7HxgGl5h4RNPmOCm+fwMyKcFoJnkrkZl571MrHm4gDto9wIc+T3e6L7h7xQPI
	 XwGPMbitkgAnK8HIKTEl9jEjHofEYv2hliT0sCrdh8FKW9ZGyYLWqgDlaPOxRPkyZY
	 4uvr7UJhOqXAw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jJLn14ZZTzKlR;
	Mon, 02 Nov 2026 14:07:33 -0500 (EST)
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
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v23 09/10] mm: add the rss_stat_batch boot parameter
Date: Mon,  2 Nov 2026 14:07:07 -0500
Message-Id: <20261102190708.1287100-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oojdcuiqph3dnd1s9h6z6n378q9jyqtm
X-Rspamd-Queue-Id: 1A0AF1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793646455-250131
X-HE-Meta: U2FsdGVkX18X9nlYx0Katq9S0my3yfDuuv8Vfrz0bOM1soA5Py8kQPUpZdKzFBBkP5ZBBu9sRr0ciCOU8XPGt9isPcl5ZfHOYg1T5l8pUwk47ICXnQfvbS9JSyDrJ4whwiMnLRZ3yAuHo+ZFHBPpLNGjIbO//P51r5xbe8dqkrd8wcygOTlrNijchwO7TpAUcJp3IwLy/CROfk4F8X2NHWalTfD1S9w4USZ853rhg8rwkWojTvr5u1+v96U2RSBzTNe/njEvzCOD/39w6yUmnbY6uloudHlZfAA7XeOIoBm9KjInJjV0MWViELfczfKHj7b2oGj32LXX6a3/Qs5F97uJNKPbgugI/vT0uaswsXgQBCIk75W6IDS51bQ+/lgEd32UKzuzF7jyoFGktL/kGBG3PfhvQ+xzDxXR4TJ5jzJ9MgVHtc/HTIUJp3qTGCFXU5oYh/djR5y5ply/CRxi9WWvn/gwkPToq0hHYATHc36z4E6vKc7otB7tXmGwRzyKipQEuOidKhq1aQ9AO78lojFPQen0y8+iBLzCisJj+DBJ+YZzfYSg8Kd8YlL02acPqPHL+Y+RKDeCgVFqwflTI4TQEwwVvHmZ3I2Gs0VH4IwW5/Wc+/IZWvvYYKdFjw+0VSnmOGHqlhbYhRs9WtRBhBrJCc3g00NHgZyI/8kN33cYqT5Lrg5HJeZuV2x4xD0EPprwnFyakAv5ApaGW3xOKUxzAbShn7TLhO9ZzwliBDtcmC007j8KVPDQqVHJErmxwG7zkECT5sk1aWeREzjIoGiA8olPXiAY2VZI+bcKiweB3iLiH0L3GX0TcBaWes+NYKhF8R0iknJlYVXtmIahnPgedtZzQpvp1iU0Y58wMsCy763h3cG7ofItYxELrmRUfJDP7/yZdBnXVlC8ctaI5JqIQ5GzVH8PeKIx/pFJGsGRbMvAg7iLPXhklOrj41SZeA+NXjbFXoBMR8RHB+2
 obPgy1LS
 ha+6VEEuuoL4+odUafnljEX/LihPX8WEncim8aM7UrjKob7YNKFWwQPxd6iwNNQ8CWMLssQIv8GN57+TdXlFv7ZfoO0jxyylfvLPyp+XFpjJrZN/2hnkN4aPcsqSJm7S13mN+rNGBhc6vq6gqrBpE07yKTTRckfVlatRg4oHmQ35wRTtTjMfycWxkgLcHq8a9G4Qab54oxgP0s0YfuLAGCXKc6/GbV9eKqE+ymtjHTbjYz35GqSGGno9TkIH3WymoAzeANBsxbMmx3BWtey61FBC2+nWQSD8j1Y0PtNVJeipffP4Xjw/S1fqT0R5g1Qu+Vt37wFWtQ3Ns7VWyjTU+Oe9QObG9MH/SmUvkY6+zkBpT+ifTC9jH229/wWqwKLLZyFc7aMRAek/wxGom543wpIN2yMdPk3YdJdNvfrX9F7aZZlFJ90dnkmv17VbUXOt1fs4QVgklwMt6iX/Mb1kHTBNiAw==
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


