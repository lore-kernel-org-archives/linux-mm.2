Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76617606C1FD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=skiL+GSZ
Received: by kanga.kvack.org (Postfix)
	id DAA666B05BC; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82FA6B05BD; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71856B05BE; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6306B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA3FC1C3BA4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:51 +0000 (UTC)
X-FDA: 85423997022.30.4608EAD
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64D50100008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=skiL+GSZ;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429410;
	b=nYQhZgqjznj98UoHX3uW7GbELO6s4MAOET4exyZAI82fUCI28hyXjKQeHtn5xQHBMxIApa
	GQSidDuSH1wTm7xJKxqk+/QWC+rMxUfCIFVF2sn/K45WI+JWUuHFdImPL6jSOe6zsv146e
	vsitvkPO9iuA0FNVlhSxsBUpRg2V+yA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=skiL+GSZ;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=101mrooLZWOPsx7/vp2ktPFHBHOgSH902fjsFmKKJSA=;
	b=W8R7sFp4qew7TPmhlqOxOz494vHkRlULun+Sw+MBcV8dePGxV+Y3RPAvkBANLcjbG2rpQo
	HqZvq7Qw/Q8/UkLi8KlMFX3g2bBhq0vsNiGXNGCCk4fsvRhI1ndU7AOyjH7QvrcTY6db8D
	sRmjGBIp3EjLTKTk4j33kxWQhalwDAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429407;
	bh=101mrooLZWOPsx7/vp2ktPFHBHOgSH902fjsFmKKJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skiL+GSZod4k/p/6ZwtYyDiXQ4Ju6wFgaVzD1PJEuPmuIxvByK7d9pU3TilgV34p9
	 eWDXDMGKBL7uN9txJqB/n7n99RxxM/Dn1KLjnapFsoPyZkxlBDbWUyLB8X4rJyrK61
	 7c8IigN83ypBo23h9EFz+oB23pjdeLX3aahOXwWDWqgApNMSI3lRkUKVfN80qj8pFO
	 ijYktGFBW0vfmT252gDfU+PiTWrnQ97HrgvUy/Tzjf9JL+lBPxuR4nV1OgFIjm39wk
	 uynHUtXVuyxcEX5YTtvRXRaEf+ficELQFDhxN6wYzcR690u+lqmfZtIlpzbZRLV0fV
	 g+rLoc5bDihag==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKq3VtjzNll;
	Wed, 11 Nov 2026 15:36:47 -0500 (EST)
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
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
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
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH v25 13/14] mm: add the rss_stat_batch boot parameter
Date: Wed, 11 Nov 2026 15:36:25 -0500
Message-Id: <20261111203626.95838-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jaqpbpn94uye3kodt1yai56kpg5w43ch
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64D50100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794429410-135674
X-HE-Meta: U2FsdGVkX19j4ZsSF0GWPpc8WcYlVr0pm0gotEt+6QAF/CyWIOPJRWqcolyYYvNzjY9KxUeiwTvrkm3D/C5A1tMjxuGx98cCd+8naG9nOL+s5Xfs5XAREkwOHB4hDBN5wnAa27IGhKGAY7PxCgaiv5ONG/VEA7OoHv0Li+r42foBDm/pHsvqHiIUn/4NzmaYLdMm5jtsMBK7AD1MJEPOsLofBpRKEKE02M1t64xrGwVi6h+RVH5HlIXghS1ZPfn5qKTKCr4CdGc33o1k1K3bgWwUP/K8iQ6lavz/4oRUVXat8O/aujIGaWEUIr/1l4W9L4Hhft7nbTvPUi68TlL8IpHlLZoo/vIiGmd2O4Qonar590gx4fGDrOJakBru8YeTA1QtWQ2WWFEnqu7vSM2SivYrydtGyi8emvMxeza+LHUQQU4lUhZdwoK1LeG/N0NZKapCKIz+XzFdre1sdGK4QaaeAhHdvKft3HsD4l6PtWvwLQPtao653KDwSM7LrXdWCejvLQc8aj/hbwli/m/0fL1hAlEV90tGGoLAOyF1JA8JUI1qfB5sYcyxFOPbyKN5aenqJzY6ed4bThmYSKXvrJrjfQ0mAS05AseB3OwwI/Ucc4hDX8eOlmId1WpvKc2WSh+0C58lN3V2BqkSrz0RxPi5PVSVsXsOoHkPrkCFylWiVLY/e4FmHQV692v95AxKendP5k6td+/fyGJ+b65Uc/8zfF4OdIA6A6q6413ODm/+iTEqU8WJVegkXXbcmYF8TpEMaW992LAzNEF1qLDn5Ox6wSKnAheYv4r0PSRgz4YB7XiE+/aPYB0ObRY3PP9OLPPRNh7Zj6UXTopqO2pa2oQVbnPrJ01Yg3zffwX2nzB9Rs0qle+w0bCQD8xCv9TmFFqPISoy5SKQ4CBDJuPZq7tH4/bUd/8HahfqF2KkVdynNKWS0cn7pVlbjHfk6M1VU4RtkgvD351WSsyQk/B
 hU1JBe3B
 tEHbALqDHnE/s1iATVgC1q4EzffAYOz6obv2eBBe59hclwA7kwHpmOXy+dJJz1sR1Q6fDddkU0Ry1I75a+APVacJKVuX7zc5EXGZQD8HbZVejiQHZXP9S5SgJufM33uQvH0c1TAe8RSrRnqz8HmyjVuSsIsTp0RkNDnASuHl4oSzd6IjBIEAkylaOEkAjgTXtR9ujkqEjQ90T8nsKhV/93FK5czV6POloa1KRTPuSBrqqM3mlSSpeGSJmAGMSh+/hPOwN+ORS/T9UaMPP3Sj8tpfCOfH6VkopqQ8ev3V0YY14QLyVdoWqDm7EY4oFKTMGKCOYQPG9cU6AVBG1zWCiIpWIpEDxs86KRLsciNnpKyeihYs9GqoJOgHy1cNutCWyyP0ij8wgNEMLZiGIq5BJfZbenlw+kC92trqLV0Af70+fWZ3xnj8qPgE3ZsUU57O3VDSxeBq0LRZTmC5E+yLNiCVYfg==
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
index dc1db6cb5da0..f582c1b073fe 100644
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


