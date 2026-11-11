Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389F6606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v7/51tjy
Received: by kanga.kvack.org (Postfix)
	id E6E796B05B5; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E457D6B05B6; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D986B05B7; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B326B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C2651A0431
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:49 +0000 (UTC)
X-FDA: 85423996938.17.903A041
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A09A1A0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="v7/51tjy";
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb0qHmH8xZVBF31GoHXvIcJB91cbFnuRAr+MrEKKva0=;
	b=PtTyKfeuPT4bjOPIQTAXhA0QmLh0UKZs74rukrHSmHWwHtco0D+paHSB5h/3XZqgDHYBVi
	Y32kJ2SIMEUtmaDAmiK+bkXGEeVMYjLiNWciRh00k4qR0TUokEg3VD9YAkpqDHWTlEimbH
	cenwRCVNld+ZQc3r6ctrJjgymeE0Kpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429407;
	b=6k70dZJuJTD8rC/qsRrtdg+ktnUKhfNd+cmV8N0pWINbZia8p8ZOq6VFuxIe0In7eSYCEQ
	2ooRfmZzMqQf8devhikyR70rhiNtfRB/UWK88JmODXV+ct+3oGIbVkwYu03w3OxDdNJwXR
	YRmouyZUtOGxYY+ZiyfXr+3bIgjeNdg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="v7/51tjy";
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429406;
	bh=mb0qHmH8xZVBF31GoHXvIcJB91cbFnuRAr+MrEKKva0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7/51tjyseOn9JsJPN+jIenbIG1dOD8e2q6QCg0dN5Gzktl0KLfFmLSjH1edqtfZ1
	 SPOL84xzvsAW52iECzCZVytxICPx80DNAf0TLJaO2DsosdPkSYprZzGsRpG1JD5LJD
	 QBEPHfPh3BgAx4aoBQn0dFjLwNEu40xMRcHgY9OHrN3cNlC/vJCfOmmiYIRC0XGe0J
	 A51eNeNO6cY47fbEyxPLBabTImKhdofhzRKnEPpvridO4taPry4t8OS5rg7UUIEvQ4
	 jgl/l9Hv10lf/0JsnaalmHXUH/Iz6phsRGK3lxMvloX0tyWQh266vo5VqkRg/5Kk10
	 3U0z44OV9+H6g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKn6WhmzNZW;
	Wed, 11 Nov 2026 15:36:45 -0500 (EST)
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
Subject: [RFC PATCH v25 07/14] mm: keep the RSS counters of single-threaded processes exact
Date: Wed, 11 Nov 2026 15:36:19 -0500
Message-Id: <20261111203626.95838-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A09A1A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mysq4umrwzmqd7j1q1st6cafajcicyak
X-Rspam-User: 
X-HE-Tag: 1794429407-924162
X-HE-Meta: U2FsdGVkX1/ur4FCPJH/iXmXRXtl2c91X8p+++wOJfd8by7Y7Uo/stVbDbY2J9yIW816SzGMSlbhnapYEVeG+/muJbFdkyUqjufIp6rEPNFCp1CKl7Kf/l0009TzK4TjaY9aHe9GERr+TiLE2VX5oUSxHMp3uEKCu7unDRhZ+y+pc+Dl5Uc91YV9YBJ/CS/y+A0If7ipfgdkPJVmhZo11omE3YXgZpcDx4fsCqSGa6TLYMVSmxxEAGXJ9v3KbzJjMS/Q2718oZZlxfLE9tUtrh+bKyrzwBeBmRGn2K2zEfmz8zRGJbiKyNmBwhakf8HfWmD3RRxyyJHkHfLFx/dY4vJ0AxELX+RzziQJi2mHlfFxa6CMtJK+1g1jvRvvo/Xze7v+vkQlA61XfB0Fw0amWPfuUxI/fOoZp8iwF4OsczbViCBI6Kzos3iqg5fHbPlAS0H0I1adziT1p2yGkw1cW6pJKlc0km78g0kkrVSiGZ/GRv17HgUH08955ObXknTbyqEwLYqf0yozSUNHYR9r4Qg0LHWJGAoePJwpurHIrRhuZjtezG6kehWcLJcADM7o2bfK6cdsBWI8XsLiLDQCPtW3UmD224zZ0KTg8OvPfQyctV+11kNQvN2Pc9kfVP7bMJkwhHXZ4aNnrzD3pGSzhl0obn9i9qieWGEV8e1yyv5C1VzLC78Bxq5wYDGVjNcGCfUtLyKva68W+17LVAX7b3IUu5g8GXlwAGZ9fMJh4sz2xHCbBE0PHgmPtfU/S24HKnUGHg5Hwae1K6MA2XklvJ3jYPBl7RVSxcRwXQL0D3tv5fDqQH0IKDJWPnEpDsIG1pQS/+Mx7J8gu3J+DkzkyEA9o5mnYwEM5wQSq0vEL0P7vtAkVGm9YCv0ymuNWC4gti+RM/k3aWRUmuApC/bDLAtgG49s1wwMcheItA5dZV4zCZA1ztftUYi5zijRic2talTWygDfbtpB8UzU47b
 m0dVbNpL
 Cs+zjTUbw9LpiEV4Mwlp1oNZNfw9o/5z5mXwtvTmOJZZbWdb3yNA8dDyfWQBCvkrKTJn856dz4+IeAbzLQUIgM8RdiXhCy8YG59L3G3oPlgcfwWpgF9zpqGgqL5+9P+qI+vF7kTtCpTsaP4vG+yaZd2Q3UILZibBTa6p9RKGm7PbqtbUsb314UGY9BJlH9/f1sEwy+5yb5DZohCsoQ76qF0ZpeayCugTHh6KkP5/cuY+ufywhAEHSUrv5BOIeQpzL15MpyM9RPh0lrGfCBKAxvg+8V/r4uiHQNZoywX/kFTv12uGZbUC7DMeDJfaFOrLmIFI+/FuG+CHJGOV6eGhDgQSrh/R5aKSJv28kDFZ5VXDc6VP+a59znfJcHyU0P/KLDHYV5tBcM4GwJtyG+NELjs87p9BphqzKSVpB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Until a second thread shares the mm, initialize the RSS counters lazily,
without their counter tree: the task owning the mm adds to a plain
counter, and other tasks, such as reclaim, khugepaged, the OOM reaper or
remote GUP, add atomically.  The RSS counters of single-threaded
processes are therefore exact, their precise sums for /proc/PID/status,
/proc/PID/statm and the OOM killer take O(1), and they use no per-cpu
memory.  The readers of the approximation, such as /proc/PID/stat, the
RSS high watermark and the rss_stat tracepoint, get the exact value for
these processes.

The owner, mm->rss_owner, is the task running on the mm: the child in
dup_mm(), or the task in exec_mmap(), which also clears it from the mm
it leaves, as exit_mm() does.  It stays NULL, which matches no task, in
the mm of exec() until exec_mmap() and in those of the other users of
mm_alloc(): all their updates are atomic.  It is only compared with
current, never dereferenced, so a single task writes the plain counter,
including while a vfork() child shares the mm.  mm->owner (CONFIG_MEMCG)
is not used, because mm_update_next_owner() hands it over to another
task while a vfork() child may still update the counters.

copy_mm() activates the counter tree when a thread is created with
CLONE_VM, except for vfork(), whose parent waits while the child shares
the mm.  mm->rss_stat_mutex serializes the activations, as
mm->mm_cid.mutex serializes the mode changes of mm_cid at fork and exit,
without relying on which tasks can create threads.  Once the tree is
active, thread creation no longer takes the mutex.  This moves the
allocation of the per-cpu counters and tree items of the RSS counters
from fork() to the creation of the second thread of a process, which
returns -ENOMEM if it fails, as fork() could before.  The tasks the
kernel creates with CLONE_VM for a process, such as the io_uring workers
and the vhost tasks, also share its mm: a single-threaded process using
them gets the counter tree.  The updates made before the activation stay
in the single counters, which the sums keep reading, so updates racing
with the activation are not lost.  Once the tree is active,
__add_mm_counter() no longer reads rss_owner, so the updates of the
threads of a process do not pull in its cache line, which other
mm_struct fields share.

The tree stays active when the process returns to a single thread:
going back to the single counters would need a grace period for the
remote updaters, and a process alternating between one and two threads
would pay for each switch.

Before the activation, the updates of tasks other than the owner are
atomic additions to one word per counter: concurrent remote updates
of the same single-threaded process from many CPUs, such as direct
reclaim unmapping its pages, contend on it.

* Testing results:

Test hardware: 2 sockets AMD EPYC 9654 96-Core Processor (384 logical
CPUs).

With the test program and the instrumentation described in the patch
switching the RSS counters to hierarchical counters, in a KVM guest with
384 vCPUs, each pinned to its own CPU of the host, with the NUMA topology
of the host, the approximation of the RSS counters of the single-threaded
program is exact, compared to an 841MB delta for the upstream counters.
With an idle second thread, which activates the counter tree, the
hierarchical counters reach a 96MB delta, compared to 845MB for the
upstream counters.

On bare metal, with 1000 to 16000 single-threaded processes alive, a
read of /proc/PID/statm, which computes 3 precise sums, takes 5.3 to
6.5us, compared to 16.5 to 19.0us with the upstream counters, and a read
of /proc/PID/status, which computes 4 precise sums, takes 11.4 to
13.1us, compared to 26.6 to 28.6us.  A fork + exit of a child touching
no pages takes 116us, compared to 139us (219us compared to 247us when it
touches 64 pages): its counters are destroyed without 4 precise sums
over 384 logical CPUs in check_mm(), and neither per-cpu memory nor tree
items are allocated or freed.

On bare metal with SMT disabled at runtime, where the upstream batch
size is 384, will-it-scale page_fault2 with one process is 5.1% faster
than with the upstream counters, and page_fault3 1.3% faster (one boot
each, the upstream one on the previous day; the boot-to-boot spread
reaches 3%, so neither is claimed as a gain).

* Memory Use

Per mm, on a 64-bit arch with 64-byte cache lines, including the
rss_owner pointer and the 24-byte activation mutex, for a
single-threaded and a multi-threaded process, compared to the upstream
percpu counters:

                    Bytes per mm
  nr_cpus fan-out  1 thread  threads  upstream
        2 2             192      264       192
       16 16            192      320       416
       64 16,4          192      768      1184
      384 8,8,8         192     6400      6304
     1024 8,8,16        192    13568     16544

A single-threaded process uses 192 bytes for its RSS counters whatever
the number of CPUs: the 4 counter structures, rss_owner and the mutex in
mm_struct, compared to the 4 upstream counter structures (160 bytes) and
their per-cpu memory.  On x86_64 with 16, 384 and 1024 possible CPUs,
the mm_struct slab object keeps its upstream size (1752, 1872 and 2112
bytes in /proc/slabinfo).  A multi-threaded process adds nr_cpus bytes
of per-cpu memory per counter (1536 per mm at 384 logical CPUs),
compared to 4 * nr_cpus bytes per counter (6144 per mm) for the upstream
counters, and the tree items, without the rounding of their slab cache.
fork() no longer allocates memory for the RSS counters.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../core-api/percpu-counter-tree.rst          |  7 ++++
 fs/exec.c                                     |  5 +++
 include/linux/mm.h                            | 24 +++++++++++--
 include/linux/mm_types.h                      | 16 +++++++++
 kernel/exit.c                                 |  3 ++
 kernel/fork.c                                 | 35 +++++++++++++++++--
 6 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
index 138e9b74b0c8..87babe2276c4 100644
--- a/Documentation/core-api/percpu-counter-tree.rst
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -102,6 +102,13 @@ The activations of the same counters must be serialized by the caller:
 a concurrent activation would publish a second tree and lose the
 updates made to the first.
 
+The RSS counters of an mm use this: the task owning the mm updates the
+plain counter, and other tasks, such as reclaim, update the atomic
+counter. The tree is activated when a second thread shares the mm,
+under mm->rss_stat_mutex, which serializes the activations.
+A single-threaded process therefore has exact RSS counters, cheap
+precise sums, and neither per-cpu memory nor tree items for them.
+
 Use Cases
 =========
 
diff --git a/fs/exec.c b/fs/exec.c
index 8d2b14e1d455..7a6f07a6d482 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -875,6 +875,8 @@ static int exec_mmap(struct linux_binprm *bprm)
 		}
 	}
 
+	/* This task owns the RSS counters of the new mm, see __add_mm_counter(). */
+	WRITE_ONCE(mm->rss_owner, tsk);
 	task_lock(tsk);
 	membarrier_exec_mmap(mm);
 
@@ -903,6 +905,9 @@ static int exec_mmap(struct linux_binprm *bprm)
 	if (old_mm) {
 		mmap_read_unlock(old_mm);
 		BUG_ON(active_mm != old_mm);
+		/* Updates of the old mm by this task are now atomic. */
+		if (READ_ONCE(old_mm->rss_owner) == tsk)
+			WRITE_ONCE(old_mm->rss_owner, NULL);
 		/* Defer teardown to setup_new_exec(), outside the exec locks. */
 		bprm->old_mm = old_mm;
 	} else {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2b40f382da35..99a21a7c69b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3621,23 +3621,41 @@ static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
+/*
+ * Until a second thread shares the mm, the RSS counters are exact single
+ * counters: the task which owns the mm updates a plain counter, and other
+ * tasks (reclaim, khugepaged, the OOM reaper, remote GUP, ...) an atomic
+ * one. See copy_mm(). Once the tree is active, all updates go to it:
+ * rss_owner is not read, so the updates of the threads of a process do not
+ * touch its cache line.
+ */
+static inline void __add_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	struct percpu_counter_tree *counter = &mm->rss_stat[member];
+
+	if (!percpu_counter_tree_active(counter) && current == READ_ONCE(mm->rss_owner))
+		percpu_counter_tree_add_owner(counter, value);
+	else
+		percpu_counter_tree_add(counter, value);
+}
+
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	percpu_counter_tree_add(&mm->rss_stat[member], value);
+	__add_mm_counter(mm, member, value);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void inc_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_tree_add(&mm->rss_stat[member], 1);
+	__add_mm_counter(mm, member, 1);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_tree_add(&mm->rss_stat[member], -1);
+	__add_mm_counter(mm, member, -1);
 
 	mm_trace_rss_stat(mm, member);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 20b4517b7329..f0d315d72adb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1352,6 +1352,22 @@ struct mm_struct {
 #endif
 
 		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
+		/*
+		 * Task updating rss_stat with percpu_counter_tree_add_owner()
+		 * until the counter tree is activated by a second thread: the
+		 * task running on this mm, set by dup_mm() and exec_mmap(),
+		 * cleared when that task exits or execs, NULL for the other
+		 * users of mm_alloc(). Only compared with current, never
+		 * dereferenced. Not mm->owner, which depends on CONFIG_MEMCG
+		 * and which mm_update_next_owner() hands over to another task
+		 * while a vfork() child may still update the counters.
+		 */
+		struct task_struct *rss_owner;
+		/*
+		 * Serializes the activations of the rss_stat counter tree,
+		 * until the tree is active. See mm_activate_rss_stat().
+		 */
+		struct mutex rss_stat_mutex;
 
 		struct linux_binfmt *binfmt;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..c153cd064987 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -582,6 +582,9 @@ static void exit_mm(void)
 	local_irq_enable();
 	task_unlock(current);
 	mmap_read_unlock(mm);
+	/* From now on, this task updates the RSS counters of @mm atomically. */
+	if (READ_ONCE(mm->rss_owner) == current)
+		WRITE_ONCE(mm->rss_owner, NULL);
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
diff --git a/kernel/fork.c b/kernel/fork.c
index d9bdaf2bd998..dc1db6cb5da0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1108,6 +1108,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	spin_lock_init(&mm->arg_lock);
+	mutex_init(&mm->rss_stat_mutex);
 	mm_init_cpumask(mm);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
@@ -1148,8 +1149,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	if (mm_alloc_sched(mm))
 		goto fail_sched;
 
-	if (percpu_counter_tree_init_many(mm->rss_stat, NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
-					  GFP_KERNEL_ACCOUNT))
+	if (percpu_counter_tree_init_many_lazy(mm->rss_stat, NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE))
 		goto fail_pcpu;
 
 	lru_gen_init_mm(mm);
@@ -1550,6 +1550,8 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 		mmap_write_unlock(oldmm);
 		goto fail_uprobe;
 	}
+	/* The child owns its RSS counters, see __add_mm_counter(). */
+	mm->rss_owner = tsk;
 
 	err = dup_mmap(mm, oldmm);
 	if (err)
@@ -1577,6 +1579,23 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	return NULL;
 }
 
+/*
+ * Serialize the activations of the RSS counter tree, whichever tasks create
+ * threads. Once the last counter is active, the activation is complete and
+ * thread creation skips the mutex. That check needs no acquire: the updates
+ * and the sums of the counters order their own accesses to the tree. Not
+ * observing the other counters active yet only delays their updates going
+ * to the tree.
+ */
+static int mm_activate_rss_stat(struct mm_struct *mm)
+{
+	if (percpu_counter_tree_active(&mm->rss_stat[NR_MM_COUNTERS - 1]))
+		return 0;
+	guard(mutex)(&mm->rss_stat_mutex);
+	return percpu_counter_tree_activate_many(mm->rss_stat, NR_MM_COUNTERS,
+						 GFP_KERNEL_ACCOUNT);
+}
+
 static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm;
@@ -1601,6 +1620,18 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 		return 0;
 
 	if (clone_flags & CLONE_VM) {
+		int err = 0;
+
+		/*
+		 * A second thread shares the mm: activate the RSS counter
+		 * tree. A vfork child shares the mm while the parent waits,
+		 * so the single counters still fit. The tree stays active if
+		 * the clone fails later, which is harmless.
+		 */
+		if (!(clone_flags & CLONE_VFORK))
+			err = mm_activate_rss_stat(oldmm);
+		if (err)
+			return err;
 		mmget(oldmm);
 		mm = oldmm;
 	} else {
-- 
2.47.3


