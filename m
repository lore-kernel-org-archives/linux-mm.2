Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C90D2502E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DAA6B0089; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914476B008A; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796876B008C; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBC96B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:48:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EAAAB7687
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:48:42 +0000 (UTC)
X-FDA: 84327978084.01.0431A4E
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BAACC0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:48:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FRxqryaH;
	spf=pass (imf10.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768333720; a=rsa-sha256;
	cv=none;
	b=eXuSW9glQ8EYbdFbJq3/HCRfA5RA5v/8Ous5XYwyLPlpQv3RnUxyfnNgpDoolX3Gj+vJMw
	R5Z7+UEGBnbMSm4LmRKQx0G5FiomU8wR79Ei2cl5+0hf2z78oEsFqeKcJ7FFknTP2IMVS3
	VlqgY0Ze1OAWfqFmW7q48iPbSWYMyug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FRxqryaH;
	spf=pass (imf10.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768333720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibI7m5hVA+BML8zWJ+X0AQLePZoxFXR6rc0fCgAMKyU=;
	b=8MP2Fl3wXgDH/9lQ07mfjsEkC/CgkhMzFjEg4TYYksSuniaHX1zxN2P1a7RoSKNkOI4p/W
	8azgKgl3fTLRIrjYUnVJFlcVvfXJvubPgtA8gPe/Gb2WCOVivjQVSk/7GRICqNFQSq6Fkd
	kgOn2lKgfmK357SCFn60j+TXYTbfFlM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768333719;
	bh=ibI7m5hVA+BML8zWJ+X0AQLePZoxFXR6rc0fCgAMKyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRxqryaHtE4q7Dc3L1yQfbYf3EA6gZnk9TO9G6Ily22Tpr2V37FMSXS8FfXv+gkX3
	 3T9wjufK4+hIH9SJbm1+yYOjX0GnaleffjYwEDPXRBLHclHhpjERmjuHTFp2NE3Mcy
	 WCDvL2+74yzG3f9+UV5Sjw4iy9h+GU/i4foTfkxXh0zfjCHbcKMPBRCtLZPfoHgkf5
	 /1TmH5sXzlOWMF/m22Of/AjMoSsowk50zh3sbijkKbkrwXVCMjW5t0st6enAWDdbC/
	 +SRd5xRRMXGQbTxQafem5fOnEC+Y9Se3/lXhSz+lin50gYGeIhVACSIHRNj/qBUFuf
	 Q3CNp1Fvq1Tgw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drKYg3hXRzlTQ;
	Tue, 13 Jan 2026 14:48:39 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	Michal Hocko <mhocko@suse.com>,
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
Subject: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on large many-core systems
Date: Tue, 13 Jan 2026 14:47:34 -0500
Message-Id: <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BAACC0005
X-Stat-Signature: jigtxifr8hih7cgs9pw6kmi541yfqbqh
X-Rspam-User: 
X-HE-Tag: 1768333720-545712
X-HE-Meta: U2FsdGVkX1+htFrCb/+JLi3gqQIG88iQNLA4b4QNketvQIxIZgUrPxDcw20jf1iuCbKvreKztKfe6fsD0lkhVCanUeNJfSkdsTspyg0JsCjSqHhXam5z8DCYQzOYOvuu+JAeOak5EhtcjoKJV2661qggFuPyE2zWCQRl58sKxgdcL1b5wOdVA5HwqQdQsBeHrqiASrOaOGMYoGZvYl1pUXFkALfDJhN5ppU2j7H8ASCdxK5FZdr3pBA0tmrB1SmeXDFkP8/GRmrwqJ5xryvihrnxoHdFMDiWVHKqvD5d/r6PMUYatgQSJ+8EqRGMKN4/WPVgIFnZcZdiSODDTlwQkZ/mmM4B9I+vQKltxrx5n4Bh5K0ZopAcqkJGPDlaVdn31VntmTY97lCDu8ejXOsZHmwoyjSSHcabwBuFlUEZrz796xvB4akaqTtQwGBgVyyMOYJS1KLXdnqVGPmA0CjkKFkr2FAUOYGPhQRohRD8q3E/px9WsV1AUCgpkDIw4VkcXZ9Yd7iiYdgWlETCU+ibql2qbSu55QGldDPhnGzHjfVAc9zMCy6JIM4gx4dCb/eSftkNpdHHofTvTgNyaJrU+UHP5t2UfjIlZhHoPeKbB4GyrUJXOS8/GOkrMSNOSKHyQU2YR0HIEfDNcgV4lUvVgrR/mN+jdG8vSviXOahUA4x6RQE1Kzu/OfIL/SifcRJFqU6i4UxWEYoh4m/cGXXLk9KdeSIcfA0DgyDkw29t7iz+Lf1A+ak6Y1CWAC61khr+jzrvcVEFCG7ZwP4xaAvjf6L0FFxj4n7S7UZ4ls84V418cHs4oEbRibfabjrioPhlSTzVgavo8bxOYeGnmRJJSM/zrbtDmcGbB+moHL37zGzAzB7WWiO3PPhaeHCQTJzZhEELUHS5v3ETA+oGDpuSFdWn2YkFlhxBLgsTaWPua6IitPpmzB6bz6dW6A7C5b57XuH5WOp3OWwz4Lihl+y
 +TQcCLb/
 GHOd4QLIAbMu4TF0gBO8+lMQ/+SOCL5pdF4XKQ621hTitWiat8SheVexmApj489G4ybkVHi6OR3oWme3FSQQUqaaGFx/IDpMMntmK8VkRE8NiGiTqA4f56fn+CRB6X38xKlKAftCYWGqzOzPDs1P5a9Llz8tGifCyNx5gKPg22o+//Z2JAJIvIiy7x0ji2d3gguCRM/637e1JNN4vhXkBziotRmFSvbzXfajUmPupt7dkuB2b2W3b5D32zpPeWeTYqzn0HSPZ+boa3VkPGjskQT1KmCgNRkLlr8axmBoF62OjwTh77SnoDqQr2/X59No0xGYe3sLfmjfX344+rNxGjrLj4q1DmZss5gPQaLDnQ8/wR7TQ5SHhRFj2x/SVBRkL3efrPO4AP6m6UhApB/QSua1JiAYvuZlqd6fRN06+cj2i5+eZbOTkyUFDBBmInA+WkGNAl+ZwqQhnZpwh6oUZbvydFfoefQ5+R/Ewdzbn8tuYZtJeSm4w90x0F+RJW1lHhW9e3kmMZtLKNVrHrObEU6BCuR3PX8/ClA5QpXIIcHsM4rvWBtQm6h5NcIG1H5eOxWlbKtIUYHa+jibQvwHHyjJbXV+3DSJmxdcCY8+f5HqVfz2X8Lw9opWxGnhTGiA0Mdu16Q3ExZAVWlO5TBOGNQQyoevQC8gQoEmeKgCYfrP46u7MnVPT0gj+2n6J/t+yV/kbHFnE6rV6+TGjRcVDhZB1iKQ7RiZNfNVzd+sscqyaQw3d0ulO3+tEUx/TNZHhGLA6B7kx6VYbEoIVUTKpZs6SeliaNU88NPGU+82c/2YHCa/XREsFfGkmO6cln2AK6FLZrwGDNw1F63gZCShMKI+ww5VE+hA0AVTesHOFfKMfRHioBi3WRSPCMgzG5fVfGGuogRzZR77WTP9FXjJtJw74I+E8Kw5OW0BQkqGNPJIM49uagehU2FA5SkdAwIe55brupm8+C63vC4IEpPy5ACbeUGMs
 3ypOrapv
 uRBhuEjPXngwZnWNFiVRGA0n0kI0nr+IIbQ652lfasX0GbZNthzYdJVbOvTaqIxdMKTNhyVN4eqdRF1VNKF6GQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the precise, albeit slower, precise RSS counter sums for the OOM
killer task selection and proc statistics. The approximated value is
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

The simple fix proposed here is to do the precise per-cpu counters sum
every time a counter value needs to be read. This applies to the OOM
killer task selection, to the /proc statistics, and to the oom mark_victim
trace event.

Note that commit 82241a83cd15 ("mm: fix the inaccurate memory statistics
issue for users") introduced get_mm_counter_sum() for precise proc
memory status queries for _some_ proc files. This change renames
get_mm_counter_sum() to get_mm_counter(), thus moving the rest of the
proc files to the precise sum.

This change effectively increases the latency introduced when the OOM
killer executes in favor of doing a more precise OOM target task
selection. Effectively, the OOM killer iterates on all tasks, for all
relevant page types, for which the precise sum iterates on all possible
CPUs.

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
 fs/proc/task_mmu.c | 14 +++++++-------
 include/linux/mm.h |  5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 81dfc26bfae8..8ca4fbf53fc5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -39,9 +39,9 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 	unsigned long text, lib, swap, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
-	anon = get_mm_counter_sum(mm, MM_ANONPAGES);
-	file = get_mm_counter_sum(mm, MM_FILEPAGES);
-	shmem = get_mm_counter_sum(mm, MM_SHMEMPAGES);
+	anon = get_mm_counter(mm, MM_ANONPAGES);
+	file = get_mm_counter(mm, MM_FILEPAGES);
+	shmem = get_mm_counter(mm, MM_SHMEMPAGES);
 
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -62,7 +62,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 	text = min(text, mm->exec_vm << PAGE_SHIFT);
 	lib = (mm->exec_vm << PAGE_SHIFT) - text;
 
-	swap = get_mm_counter_sum(mm, MM_SWAPENTS);
+	swap = get_mm_counter(mm, MM_SWAPENTS);
 	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
 	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
 	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
@@ -95,12 +95,12 @@ unsigned long task_statm(struct mm_struct *mm,
 			 unsigned long *shared, unsigned long *text,
 			 unsigned long *data, unsigned long *resident)
 {
-	*shared = get_mm_counter_sum(mm, MM_FILEPAGES) +
-			get_mm_counter_sum(mm, MM_SHMEMPAGES);
+	*shared = get_mm_counter(mm, MM_FILEPAGES) +
+			get_mm_counter(mm, MM_SHMEMPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->data_vm + mm->stack_vm;
-	*resident = *shared + get_mm_counter_sum(mm, MM_ANONPAGES);
+	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
 	return mm->total_vm;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..d096bb3593ba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2847,11 +2847,6 @@ static inline bool get_user_page_fast_only(unsigned long addr,
  * per-process(per-mm_struct) statistics.
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
-{
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
-}
-
-static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
 	return percpu_counter_sum_positive(&mm->rss_stat[member]);
 }
-- 
2.39.5


