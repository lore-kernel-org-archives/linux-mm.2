Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48D1D37E3A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6866B0005; Wed, 14 Jan 2026 09:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D844D6B0088; Wed, 14 Jan 2026 09:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65B46B0089; Wed, 14 Jan 2026 09:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B27516B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:36:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F6CEC1DEA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:36:47 +0000 (UTC)
X-FDA: 84330820854.25.175BC79
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A0981C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:36:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wBO1cDgX;
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768401405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a4JTIpkP7Lienlrmm6a5VnUFXePFWSCp1ppP2dbbkgA=;
	b=Q9icuZ+Ax2HKsqJ0CGh8/D240xevxWo2rlLKtTrwbv+WDZ+yNXR1UQyzupGmnYoHa/UnsG
	sjO0e9MYr9wF8VbmKX5I7MRGcypjj/fX3YpX+i3OVu/JBiDDov4vx++NAYgDIosE9POu7C
	mYnGPneXwZFVVcbbeWb53MD+EUDIUDw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wBO1cDgX;
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768401405; a=rsa-sha256;
	cv=none;
	b=Ddh/hU2M20M5WB8XH7at5G0I91LCakBiyJbKfG4lzkdFY7YdUjR+6E5LgMm/OzzHZXHQnT
	LKj+9YNgsPs1gjWeYjEAmc8LHmWceAywjlT9H+tMovFGx4Vv2UjQvAiBhz0f3k2rjVF9+e
	8xCOeA+tUEW04mFMrAC2REhwOLVKIf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768401404;
	bh=a4JTIpkP7Lienlrmm6a5VnUFXePFWSCp1ppP2dbbkgA=;
	h=From:To:Cc:Subject:Date:From;
	b=wBO1cDgXgkiUkGrtHBWZaWXqXHfUTrJFFFuHCPcnjGC+LVjjcddGdSdoluNx6jvIp
	 suCLLqVmcEWWhO2O5evgtqhHhYZw6MK9OrLPVdlc9Nh7uiqTEScRXbdhBNUHeksaX5
	 QjtJC87XDkVoVjX1VBo2vDnDdL9rf9jvxYyrCUExqrkHyyN3Pjf0KN9raAn7N49DjW
	 JLSKv0NITJ8THXHwPED8AILq2OCZq7IWm+oh6oLoWXHiS0pZvSjXxEXFwVes0KJCfE
	 YFE8C8rUrH7zSFWZU9YcZUvGOoGpmQw3w72iCEKZOGSdeTPzz2+ZoKA5c36pcYhbGU
	 U7/DkJFq6fNfA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drpbJ3WKwzl8N;
	Wed, 14 Jan 2026 09:36:44 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v2 1/1] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Wed, 14 Jan 2026 09:36:42 -0500
Message-Id: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A0981C0002
X-Stat-Signature: c6bmdrqk8q7o1ajeamzsdrp8zccwwtrk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768401405-389941
X-HE-Meta: U2FsdGVkX19mrYqk3Rkk7Be0l5zDH0tyH12L0BiZvT4l5bJyboPc8tXm4cpnyAlbAzTXtULBdmTPLi5ji17B+5s1FM+GKXTKlr9V07QIJDBPnsLOoShNWFM44vKOYgotnrlZvPRxLMIGykagDIxNof1nimz4+GaFgJ8Lfo2v5Q83AStJIK51lZBvF1/87lAnaGs/nqYzw50mwZ3FjSDNb3kGAHXq3M0q/MgG3spZCTjKLs+5K9GsAiy9IpIRUtr1QayYpwssq+OplA5hetSzq3I9ohiyXsMTKereoQfoZ+fU4hwer1hbZ06zwOVHbJ0zpvj0GQ+3T/Xamx+9jhqFk3zjMYzAOc6bt2cXyEcpZb3foddgN+8W/DM4fdSf3f9zK5C/AyrRxJ5IjDwIjqFDtrY3AcW9mgcFnOO2YpqXN2Je2tpkog+2hEZTXVCo8VHizY7UzsLJEf1olaHjHiMzs+SmBJruFPrMBD1SzTqmAnrgPq5GMbT/iel7MIPbqNlJJwGdORwLJ9+qvcst4nwB1txe2VOL5EOuD+CYstQ/HU/QHc90wWFrM6EitQacIPuCI7QYL5aOEDD2eOMv7Va4RR33uD+wYawMsDwvoOReZew9GdgEIKj/UM99nQ4VIVPpY155WjIsHskmu3s0FHoW9mDeheKT0Aha6M0dbpIumndT7MvW3nfTJiA0zWnKNxzT32wslZRKLmGhGzH9hEXiPiknB5SUAP3eWfAaxTM3loZQrvcISnHFw55X1TCbP+K1P5Vte3bvIGPR3bWk0IzeU9XtNYlE1eouGne+UGoEIZ/CYQYGWb21Bga/2hEAejDxGeM/KwU2iZ53WX1+OTvRXA4kJRe/3/yI1+ed0b3mnKJEykBN067JFxbEee/rcJDLg3EZeqI//FFdO1pTgUYcDdc8esxpGxI/NjmpSN51Lhkj+4rol5hT5pZ2ya+cAq1jxqF1RwjOLHv0LZPea7y
 jQSnx28D
 aCK0s9HSSt5oFSd3UK6LxMQr+nDEp77Z3Mi5p6F4sLL7ZPdGSHhJ1PDiefgsGsEkuNt3jvUlycMmQeuqnsXAIEZME0FcdReOSMfAn1E3DFowCPk7Z+as0HSBa+y2joF7ENWmvOjffIX0RZcemmqsHUPwHTKrpO84YUFMr/jsk1u0a9odoosYClMyPdwLW/hMD+woD6hcULkIUCbFXW8LHUrJvZyi0aqeXB6uejgMHzeV336xiZZiOzyXgRhEgJjfROSAmXYiTWSb4HRZDx3XB2MugHWyNRAKydnkK+02kEjZt8wcqOFvNYAZFzu4MJRdp9EjH9T1+fDgiBm9PiIkER8gXi8IuiKPUb4MrjEJ9DZg2t8IkmxL5qer7Rw+1dOyXdDannCHvpWWE2YkBJQ+7XAu9QPup8xEKbAnrcQHFfHTOTVTAl4tS5Gt6ouVjz1XlpHwTVYr5uj4AeQ/EVQXcfQ+9rQBRiN1QpE7gcia3T28ACU5KkXQktMNhQGl81IIuIhb3p0Bhq61lSaCtGRRwXZIqiZK67/ZfBDB09K8SLd7IIjn1z61R+incE4proPl+iAcyQ1VdLEbkrMw+w7WhK39i/q32JfZevS6/D6F4NqOHIMYjTxWChTWUeLSCDd+BzPS1Sce3Lq5zQRY5Co/ZOQN0cndU+e35mjHrOLfv47RQD4obTQd08HSPsU5W+72vyLV8gBtN3AIfLATonhDBQn/drTNBIhuNtQv0IaOKSYWxtpVwcrrjP1EAm4BGq/vTvknMsUq8F6Pt0Uqzvxxil+QVeB0ym7HTvQ/+BU8ipPJQ6ZuDVhUWF2s2z5hqYo4buAS5skONZ5AJOOi4+YFkx0kEJXD2xghfHByJweBHuOxV2MHS/TeU3qC2G8wpF3LHpVOnTRlzFH1Xx0a6sNpEhfpgLGmcFOcwM6QcrMAqJujQDdCwbOwqvfUqwRS9/U7/yTncJG1aXYG8Jy9gwWOywglCoeLo
 W+eaUlGz
 Ch27LTH3pCzP4hY6277a+G63Yk+k5g1XQy2uTt6Vv9jmox1AcysTvjXPJvwlrP4clO8DhUY/yBtCMqlwCfypnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the precise, albeit slower, precise RSS counter sums for the OOM
killer task selection and console dumps. The approximated value is
too imprecise on large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
users") introduced get_mm_counter_sum() for precise proc memory status
queries for some proc files.

The simple fix proposed here is to do the precise per-cpu counters sum
every time a counter value needs to be read. This applies to the OOM
killer task selection, oom task console dumps (printk).

This change increases the latency introduced when the OOM killer
executes in favor of doing a more precise OOM target task selection.
Effectively, the OOM killer iterates on all tasks, for all relevant page
types, for which the precise sum iterates on all possible CPUs.

As a reference, here is the execution time of the OOM killer
before/after the change:

AMD EPYC 9654 96-Core (2 sockets)
Within a KVM, configured with 256 logical cpus.

                                  |  before  |  after   |
----------------------------------|----------|----------|
nr_processes=40                   |  0.3 ms  |   0.5 ms |
nr_processes=10000                |  3.0 ms  |  80.0 ms |

Suggested-by: Michal Hocko <mhocko@suse.com>
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
This patch replaces v1. It's aimed at mm-new.

Changes since v1:
- Only change the oom killer RSS values from approximated to precise
  sums. Do not change other RSS values users.
---
 include/linux/mm.h |  7 +++++++
 mm/oom_kill.c      | 22 +++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..bfa1307264df 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2901,6 +2901,13 @@ static inline unsigned long get_mm_rss(struct mm_struct *mm)
 		get_mm_counter(mm, MM_SHMEMPAGES);
 }
 
+static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
+{
+	return get_mm_counter_sum(mm, MM_FILEPAGES) +
+		get_mm_counter_sum(mm, MM_ANONPAGES) +
+		get_mm_counter_sum(mm, MM_SHMEMPAGES);
+}
+
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
 {
 	return max(mm->hiwater_rss, get_mm_rss(mm));
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..214cb8cb939b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -228,7 +228,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+	points = get_mm_rss_sum(p->mm) + get_mm_counter_sum(p->mm, MM_SWAPENTS) +
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
@@ -402,10 +402,10 @@ static int dump_task(struct task_struct *p, void *arg)
 
 	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
-		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		get_mm_counter(task->mm, MM_ANONPAGES), get_mm_counter(task->mm, MM_FILEPAGES),
-		get_mm_counter(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
-		get_mm_counter(task->mm, MM_SWAPENTS),
+		task->tgid, task->mm->total_vm, get_mm_rss_sum(task->mm),
+		get_mm_counter_sum(task->mm, MM_ANONPAGES), get_mm_counter_sum(task->mm, MM_FILEPAGES),
+		get_mm_counter_sum(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
+		get_mm_counter_sum(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
 	task_unlock(task);
 
@@ -604,9 +604,9 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
 
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 			task_pid_nr(tsk), tsk->comm,
-			K(get_mm_counter(mm, MM_ANONPAGES)),
-			K(get_mm_counter(mm, MM_FILEPAGES)),
-			K(get_mm_counter(mm, MM_SHMEMPAGES)));
+			K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+			K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+			K(get_mm_counter_sum(mm, MM_SHMEMPAGES)));
 out_finish:
 	trace_finish_task_reaping(tsk->pid);
 out_unlock:
@@ -960,9 +960,9 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	mark_oom_victim(victim);
 	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
-		K(get_mm_counter(mm, MM_ANONPAGES)),
-		K(get_mm_counter(mm, MM_FILEPAGES)),
-		K(get_mm_counter(mm, MM_SHMEMPAGES)),
+		K(get_mm_counter_sum(mm, MM_ANONPAGES)),
+		K(get_mm_counter_sum(mm, MM_FILEPAGES)),
+		K(get_mm_counter_sum(mm, MM_SHMEMPAGES)),
 		from_kuid(&init_user_ns, task_uid(victim)),
 		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
-- 
2.39.5


