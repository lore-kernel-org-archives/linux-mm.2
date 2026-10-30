Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE665606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1X+wgWf
Received: by kanga.kvack.org (Postfix)
	id B50736B00EF; Thu, 29 Oct 2026 20:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01EB6B05B2; Thu, 29 Oct 2026 20:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17BC6B05B3; Thu, 29 Oct 2026 20:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63D1A6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:10:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCBD2405EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:10:49 +0000 (UTC)
X-FDA: 85377361818.18.78A4B7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DFA31C0009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:10:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1X+wgWf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of "SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793319046;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K6ILzFZiVFUFAPqZeUEPRY19QV0bVhJQXSiFCkK0uz4=;
	b=pkGiCllfwtQ8Flpf9dOIEJmNfdfqmdA6ObY67NvBBUUusIa/okKGcyn54Snn/h0j6pqGnR
	KgvFFKNdiW0CxR0UDXV+TrxBdtd4NnzVHtHk458XhWb6QoeAaMedaFW3Ec6j+YPXlz2RMd
	hcVNd5+v1cVtuXx4+gHLxldMoMgFr0Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1X+wgWf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of "SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=W2Id=IU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793319046;
	b=8Pkow/x8ZjQ23fycC90I8FS2xKeLRRz+PCmAMFWr6ohgXgpWXK3Fo12Equjpkzu3GOtson
	U0S1I5w3geFpLHIfWwKY12XADzuCxPXjc1+eWElT9Ca4KawMhc2nmYZ+86Q0isZceSW/0k
	CW+GqUI+lCytJCcEJAQtTTLtUR5BD64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E89A7600C8;
	Fri, 30 Oct 2026 00:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E05C1F00919;
	Fri, 30 Oct 2026 00:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793319045;
	bh=K6ILzFZiVFUFAPqZeUEPRY19QV0bVhJQXSiFCkK0uz4=;
	h=Date:From:To:Cc:Subject:Reply-To;
	b=K1X+wgWfUC+G4W2B/LKzYsIibfuWfn7nUNoZYGp5pxie1zFcBKRjj76xPd6jqwIa7
	 V0qKcOGImDBaPDDNbduDKQ5Y+TWqZ5wgUSNt5WOA2aE73aKbIdIhgiVQnJMRqU2FAM
	 efXnbqorJlOJze32HToPc7RCp3jUhCH2szktRJx+8Y2m8Yybz9XiCLXMJfxT+Bz1k9
	 YJHzhKh4TKSxq0o5G4DPGp8HNhqIwBbfFxUWF18FDYAaT40VWgw27VJ1rigDG3aluT
	 uBKd+buLCZmcmxAz5u+yuwIEJ2vzyTL8s/Q7ikeKT7/sIbRFpYNrpYwMMoNofVD53T
	 MjARjYxtMv/SA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 52B95CE090D; Thu, 29 Oct 2026 17:10:45 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:10:45 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [BUG] KCSAN cannot find frame in stack trace
Message-ID: <97f6213a-1dec-494e-96d1-abe546bce993@paulmck-laptop>
Reply-To: paulmck@kernel.org
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 9DFA31C0009
X-Rspam-User: 
X-Stat-Signature: osphqz4ma1w1qsyzan4mbbjhmxx4n1pb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793319046-759980
X-HE-Meta: U2FsdGVkX1+hySCa16DIR5RV+2q3xw707NDd3E3Zv3azxlsAlHPlyxvlw4X41JCs5xjYzJE/nOIIlfv5oXILmXeJaSP0iuaPBL3959Y4ONziPiI4nlqUaL2U6tCdYLNpz+jnXhW/y9BsDG5HZVtKyaGs1CDNwEQrCompcZwuD5fGQJGg47g9R7iyvglPbaYEfhaUITJGLn+a0ZZcMMjbSsAUt025OqwlREAsEQtDMc66mlId3lUpPNbc9jvtSEm8jSkhicLhq/tTZsTjeaDkeuC9q6EstCvJCdjKG6/ylYt8FuMafpNMR2nL5j27QAJk/zLxag3Bka110C6hfYSBoLFGqJdtNIJL8V1djqFYsljrGCYvBarU83itd7qoIGQRKGLQDFHf8t/9Tm7K7wr7yLF3dbDYnlMA/dt09e2LWa6B/GSIbolog7SkAkWTtodV4Di1R2RssROAE5d5MZQMxdzxIXWiOEl4biKKynudj7WhmNCoyM9ObyVk0iPctvjp5QpN91y54VS14iRZDOjc1oW6eSrkX2xe7gZQwF7GdIxCy3eeYbMfiEV0JsGLtqDKrE/6RHhBrkHEAH/qd5gyWZ/RRe7mi3dng4D9dZVVGlTojjjOP5aRe1hTRLGo/VhyJntuWEsvYnfB/FdPnuVgsicce9Fnz+SmaP7wCDMAY4QvwDjPhD2KTem054mPPalOApSi47eYBi48OytZ4Z875TqRZqq1lDF1Y6+ZWfARpfSL3ao/fNbicHRbkzPlBej5ftu77PV1oN+P88Bt74MPcBtu5+eA2q6SGC0urpuQLmquYFNXe5DIQx+KrWdpquZOqeyOaS0QQNmD2FU2Bb/ORAgSW/IeRVzPGNYdSomh7/Iahj28wu7tsKzRZzhkAN9g96bzKeauyzZ20XzUh3rDx4jHBR6NNOFnGAgpMDMsyPKBkjbdJZH5h6OISf8GNPaZdCO+2eKPZuSu0fx3Np+
 naKxdFq7
 72yN3bLKbsChVTfeWs12JGuCwOCrxzehALo5iP+BjphgDCp5WYcZIv5GT/emCH0Ty4R81qT3psV9/zAC8CrwmLQ9b4/a2o7deuV6Uw/m6seDBu2wXYn7sMWRTi3Ci+PfwrqfyXxtk1Nzsx0VHZS2iG2iZIKk89zKUULANkq7FcXpevf0QSQYTrMKj82ZORnMNr4HITFwrpFFzxFA7P/96h8gUlhKSdswZFQE0sSNU2ej2SDd0ipQtb/E2OvMqzH0q+IT7IHGCWmiVzU9m+TW7kX1vgb6Q7qm3xKxEerFUhaHhrrd3WYVNzI3C2cm3qmyQiX+sWZJCB8Ja0C53HwuJ130kcJIVT96ZpEoN00IjhxQWJCckrqoQExGwbEy0hB8zUY7e+ZyPXgLkuzzU1AqL4iq99gsAGRjxwKZU+BEYJR+zJwGKVD+ENiMzIM/kM8I7iNn347T920N5dkjBhU8ay+WMUTTmREF1jfNYSMIxgMbgrf+1ao+gPxExKXP/d7GH8WZmxkSWIKoyDeBFaHoXT4jhhJfEuDCnzaPJB1uqYX3x7ARLB9VLEii+CphdWHRWGBe4NEBh7jnhxkfectd+e3OteAW4JztMKpRY9CYkMmFaur0oH6cLZps2wQmaqr08HeyptgRZB82UgB3/pTCPy5RrC6wj7vYGFgbLH6wQfa4G+18ku7Oomoz2/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello!

I am seeing the following (very) intermittent spat when running
the rcutorture script torture.sh on recent -next (starting about
next-20261014) with KCSAN enabled:

[    0.312250] ------------[ cut here ]------------
[    0.312256] Cannot find frame for arch_dup_task_struct+0x40/0x154 in stack trace
[    0.312324] WARNING: kernel/kcsan/report.c:344 at sanitize_stack_entries+0x120/0x12c, CPU#16: swapper/16/0
[    0.312349] Modules linked in:
[    0.312358] CPU: 16 UID: 0 PID: 0 Comm: swapper/16 Not tainted 7.3.0-rc7-next-20261014-00001-gc88f750a9fe1 #17994 PREEMPT(full) 
[    0.312367] Hardware name: linux,dummy-virt (DT)
[    0.312370] pstate: 600003c5 (nZCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.312378] pc : sanitize_stack_entries+0x120/0x12c
[    0.312385] lr : sanitize_stack_entries+0x120/0x12c
[    0.312392] sp : ffff800080283900
[    0.312394] x29: ffff800080283920 x28: ffff000005f79550 x27: ffff000005f78000
[    0.312404] x26: 0000000000000008 x25: ffffc75ad7c6d414 x24: ffff800080283998
[    0.312413] x23: ffffc75ad7c96900 x22: 0000000000000008 x21: ffffc75ad7c6d454
[    0.312423] x20: 0000000000000008 x19: ffff8000802839a0 x18: 0000000000000000
[    0.312431] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000001
[    0.312440] x14: ffff000005f794f0 x13: ffffc75adac1ea88 x12: ffffffffffffffff
[    0.312449] x11: ffffc75adac1eae8 x10: 0000000000000001 x9 : e761494156778100
[    0.312459] x8 : e761494156778100 x7 : 6563617274206b63 x6 : 63617473206e6920
[    0.312468] x5 : 0000000000000000 x4 : ffffc75adc9fc468 x3 : 00000000000005e3
[    0.312477] x2 : 0000000000000004 x1 : 0000000000000008 x0 : ffff000005f78008
[    0.312486] Call trace:
[    0.312489]  sanitize_stack_entries+0x120/0x12c (P)
[    0.312499]  print_report+0x84/0x488
[    0.312507]  kcsan_report_known_origin+0x14c/0x1ec
[    0.312516]  kcsan_setup_watchpoint+0x578/0x864
[    0.312525]  __kcsan_check_access+0x1ec/0x1f8
[    0.312535]  do_raw_spin_lock+0xa4/0x1c4
[    0.312547]  _raw_spin_lock+0x70/0x88
[    0.312559]  rcutree_report_cpu_starting+0x1ac/0x4b8
[    0.312568]  secondary_start_kernel+0xe8/0x28c
[    0.312577]  __secondary_switched+0xc0/0xc4
[    0.312586] irq event stamp: 0
[    0.312588] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.312594] hardirqs last disabled at (0): [<ffffc75ad7d6a34c>] copy_process+0x9a8/0x18a8
[    0.312604] softirqs last  enabled at (0): [<ffffc75ad7d6a35c>] copy_process+0x9b8/0x18a8
[    0.312612] softirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.312617] ---[ end trace 0000000000000000 ]---
[    0.312641] ==================================================================

This is the code at line 344 of kernel/kcsan/report.c:

	/* Should not happen; the resulting stack trace is likely misleading. */
	WARN_ONCE(1, "Cannot find frame for %pS in stack trace", (void *)ip);

This does not happen often enough for reasonable bisection.  However, the
alleged fix below does seem to prevent this from happening.  This alleged
fix should of course be considered to be part of the bug report: I am
*not* claiming that it is a proper fix.

The diagnosis sounds plausible to me, but perhaps not to those who
understand the affected code better than I do.  And I don't know why
this wouldn't have been showing up earlier.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------
LLM alleged fix:
------------------------------------------------------------------------

kcsan: reset per-task KCSAN state in dup_task_struct

KCSAN's per-task state (struct kcsan_ctx) is copied verbatim from parent
to child by arch_dup_task_struct(), and is never reinitialized on fork.
With CONFIG_KCSAN_WEAK_MEMORY, this leaks the parent's in-flight
reorder_access (and kcsan_stack_depth) into the child.

In particular, __tsan_memcpy() runs check_access() before the real copy,
so when fork_idle() copies a task_struct, the parent first records the
task_struct-sized write with ip in arch_dup_task_struct as its reorder
access, and the subsequent memcpy then copies that very reorder entry
into the child.  The parent's entry is cleared on function exit, but the
child boots with the stale entry still valid (its inherited stack depth
never returns through the parent's call chain).

On arm64 secondary boot this produces a false-positive report: the stale
write "replays" against the idle task's own read of
current_thread_info()->cpu in raw_smp_processor_id() (via
arch_timer_evtstrm_available() during a watchpoint delay).  At report
time replace_stack_entry() then warns with "Cannot find frame for
arch_dup_task_struct+0x40 in stack trace", because the reorder ip has no
frame on the child's secondary_start_kernel stack.

Fix by resetting the child's KCSAN state in generic dup_task_struct(),
alongside the existing kcov/kmsan initializers: zero kcsan_ctx, restore
the lazy-empty scoped_accesses list encoding used by init_task, and zero
kcsan_stack_depth and kcsan_save_irqtrace.

Fixes: 69562e4983d93 ("kcsan: Add core support for a subset of weak memory modeling")
---
 include/linux/kcsan.h | 10 ++++++++++
 kernel/fork.c         |  2 ++
 kernel/kcsan/core.c   | 19 +++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/kcsan.h b/include/linux/kcsan.h
--- a/include/linux/kcsan.h
+++ b/include/linux/kcsan.h
@@ -10,7 +10,9 @@
 #ifndef _LINUX_KCSAN_H
 #define _LINUX_KCSAN_H
 
 #include <linux/kcsan-checks.h>
 #include <linux/types.h>
 
+struct task_struct;
+
 #ifdef CONFIG_KCSAN
@@ -62,14 +62,22 @@
 };
 
 /**
  * kcsan_init - initialize KCSAN runtime
  */
 void kcsan_init(void);
 
+/**
+ * kcsan_task_init - initialize KCSAN state for a new task
+ *
+ * @task: task to initialize.
+ */
+void kcsan_task_init(struct task_struct *task);
+
 #else /* CONFIG_KCSAN */
 
 static inline void kcsan_init(void)			{ }
+static inline void kcsan_task_init(struct task_struct *task) { }
 
 #endif /* CONFIG_KCSAN */
 
 #endif /* _LINUX_KCSAN_H */
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -93,6 +93,7 @@
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
 #include <linux/kcov.h>
+#include <linux/kcsan.h>
 #include <linux/livepatch.h>
 #include <linux/thread_info.h>
 #include <linux/kstack_erase.h>
@@ -986,7 +986,8 @@
 	tsk->worker_private = NULL;
 
 	kcov_task_init(tsk);
 	kmsan_task_create(tsk);
+	kcsan_task_init(tsk);
 	kmap_local_fork(tsk);
 
 #ifdef CONFIG_FAULT_INJECTION
diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -828,6 +828,25 @@
 	}
 }
 
+void kcsan_task_init(struct task_struct *task)
+{
+	/*
+	 * Drop per-task KCSAN state copied verbatim from the parent by
+	 * arch_dup_task_struct(). A stale reorder_access would otherwise be
+	 * replayed by the child in an unrelated call chain, causing
+	 * false-positive reports and a "Cannot find frame ..." warning in
+	 * replace_stack_entry().
+	 */
+	memset(&task->kcsan_ctx, 0, sizeof(task->kcsan_ctx));
+	task->kcsan_ctx.scoped_accesses = (struct list_head){ LIST_POISON1, NULL };
+#ifdef CONFIG_KCSAN_WEAK_MEMORY
+	task->kcsan_stack_depth = 0;
+#endif
+#ifdef CONFIG_TRACE_IRQFLAGS
+	memset(&task->kcsan_save_irqtrace, 0, sizeof(task->kcsan_save_irqtrace));
+#endif
+}
+
 /* === Exported interface =================================================== */
 
 void kcsan_disable_current(void)

------------------------------------------------------------------------

