Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4645DFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B95E6B009F; Fri, 24 Apr 2026 15:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0856B00A0; Fri, 24 Apr 2026 15:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5423F6B00A1; Fri, 24 Apr 2026 15:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 363386B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3AA31C0125
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:04 +0000 (UTC)
X-FDA: 84694407168.18.780724F
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21A05160003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GCiB9VFM;
	spf=pass (imf08.hostedemail.com: domain of 3rcHraQgKCDYklWnWfkVYggYdW.Ugedafmp-eecnSUc.gjY@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3rcHraQgKCDYklWnWfkVYggYdW.Ugedafmp-eecnSUc.gjY@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtvA7IpLXk0S/YWb/vbFA+ZmsgjoMJHMRLoR+QNRjhA=;
	b=q+sfYCMJ99iKJenLfyAp+5kkKfbF3jpeOCzIgpyJwyxhzf+DYL43vXSruLJZOrXfmxnh0V
	wQW6zbcpNyCp6NWGPCBJ861sZgJ4LvrFmQfcLiafR5UOHgNQToG97Xgi8dRx9j884iAiKT
	rUQOGe0ZOq73lGxtgsdJGm5xMBjBTS0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GCiB9VFM;
	spf=pass (imf08.hostedemail.com: domain of 3rcHraQgKCDYklWnWfkVYggYdW.Ugedafmp-eecnSUc.gjY@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3rcHraQgKCDYklWnWfkVYggYdW.Ugedafmp-eecnSUc.gjY@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058223; a=rsa-sha256;
	cv=none;
	b=DGv0ZVT6HTqorQ+sLzWfSU/m71lJupAI5SxHBkpG2doVvHK+g6u3+fVmfgZjYtATbCU08v
	vY7RJcDdyeQetYrHpN7DsaGQAkpEwzP304EXR7idPRu4Fde2FAWZDmw9QNiT4knzTw6V2U
	+r162jaWNEg36VG6PyY6t0HT96Lk3eY=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2dd6fb4c867so12584187eec.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058222; x=1777663022; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtvA7IpLXk0S/YWb/vbFA+ZmsgjoMJHMRLoR+QNRjhA=;
        b=GCiB9VFMHsfmQa7NT4ANrO5/AFwNs5mRmAbz4xHm/64QyCW9sa6haQm+QXKtkfMXTY
         APIo6kisrfcWw9mzzPbDjJ+LXVMHmNDqhEzuwlDJJUPd/re9jlsMDAkoU5AKZMmXNSi4
         j+8couEvCdj+JneQYNKyZLyHYQRu+KT+RYdH3bZmlUeTQM6+SsmxqfMQ8NtJWOuc+wFd
         1wthglHSkjA+PoqB/PxlhzUewKuMQaZNu+nTZY2BJ1TTXAnmjSZ8jaWJImegpNnHaJgv
         E2At05P2e2KjS/LEonyZ2P8Fc7bM1ZPMxsCQkgqM5xhPf01tkPRSJAXfiskCZ6b6AISJ
         4dCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058222; x=1777663022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtvA7IpLXk0S/YWb/vbFA+ZmsgjoMJHMRLoR+QNRjhA=;
        b=onEMcJxtXOukVlxasgaaeJKcRTRRgd5E4xIJrnhZxfUPAFwXlc4Q+PBEFkTcI48VRv
         N8FMTA0sl3pBZ7WQOD0bmTRpOr5olKRObIgT95Xox3U1NtntgYJDN+g62kZh5sDXonca
         hD5LgILFgjF0Kyu8Yi+WnKZ4eDlAzFygQvmrSMMdLjrzntLqb/4rddi9BezXOg6XstUw
         PLOGDhz0kS2dMNhAcpD/hmzjWxhDj1So0BMqZ0xXA9Jd/gYTZZsp5XC3Fh/qYU+wJAek
         sGqW6E2qEgI6M1fgk4/Mu/ogLvCxTZy3yp4gfub7pjVuJqcuXmXveikhby8enWym8roO
         qlCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4c7+WyaDnmejdvyoJTWUvKwL1Fc3RfBYpGNuTrUtv/IjrKLm9QjN7891AWBj9OhIst6bmoexV8Q==@kvack.org
X-Gm-Message-State: AOJu0YzASqRXt4qHMUPBNulAPPGuq4WoKnYmPDdomV7cVGG/CPx1Ynfm
	7kWJN4lOYby/sD4ssjzJdcG0Qi6v08hklFzBcKT8+BLc4WnKDLv/6JViuKjVGTei6z2n+nCKxha
	5LfoJMPc+v2ZFaA==
X-Received: from dlbut4.prod.google.com ([2002:a05:7022:7e04:b0:12b:e83a:8d31])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:69a:b0:11b:7970:ea3f with SMTP id a92af1059eb24-12c73f9f519mr16491319c88.25.1777058221615;
 Fri, 24 Apr 2026 12:17:01 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:50 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-8-stevensd@google.com>
Subject: [PATCH v2 07/13] fork: Dynamic Kernel Stacks
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21A05160003
X-Rspam-User: 
X-Stat-Signature: 97n6734jtm4goq4hbdoeenb3xoyx68mg
X-HE-Tag: 1777058222-969169
X-HE-Meta: U2FsdGVkX193IuU8yXKin8DOLXev+A4usjaxGy1Ou8lLsFlEAduYxk9RNJ6712pKRtY9D97VaUP1Oi2FDjDtublzTeMUg4fwryji2p+Kbo14SePxj2nzOGkGKnK7KTT7DaSoN0jfD6eJd49Ta5oOs7olRVL1alz8YiCIP1VV4naMnh7f/fkm8ZCLBd3gZE2L1rxoSrvPo6KOk+Z4MbGr/jo5NaaFWUf/4r4JKCdfF3zoZqRoy2g0XSzd65Qtl/OiK3KdjVNIx+1kRllS7XEIVUQy2+VN1BokqF99GEXcpph/2rmX7qML+bJPnM0qDqdy7j4kk8aU2gvp5VFM2pRv+6wxhzMEh8TiXIl6dkVM9zPAnbJ0iYJQHpEriF2YQUPLc6zRtRBxO4UbTbK8Zw4yNGY/qJKqh9KiPrW7LM/Z3B8pWAQuOj/EE47w5wsgu2H5TkA2rPjrn8yeqr0T4jJOz63u41zXcye0S8uNGZBDOP36UTfLyvTw29ZJFkWbhMrcbxK94n0CztGMbzeC5nLH+SPEWiGdt98TQK7M8Y2EBzNeIDxFUQNzZIZPNyjBMx8rEdtCPYunpoDS1mSm6+GfCUoMSJVSEs1TGMQFMu3/0IoC1xpeHTfQk/zJnPRAr3jdZNNwwDOLykrT4YJnov7m1J9Wm3EK/l2XphXRtfnXwFIwz9Qy2jxtRLJ6tuaJcWhP4OgJ0aYfmvyVCwuBzwDXhNmOHOQyl+9GwDba3b6eKa9MbIVz1lrHK305O1k0IysOyKIi3zuPRlR/AXwGhGPi1R371hGX0laYZTN5jaIJr6El1q/vsQKgEtZyLkKoJDjORO/aex+bPUgfInPsVbBIVZXJs8I26BqNFPuTFz9lsmEgWB4zyi051k0G7RwoFpr3COQwf4Vb/OarUecoaJhTOzGPiv2/sHfDgb+qAb4cvRTWisJIhH/NUDT6Sw2gPr40tC7bVd2XQ9AjozQfC8/
 2T+Tk4BE
 c3XHe6ne7YtRU5mkp1n2GT6fi4fCYOIdZ7jHG2x1nSot2uMY3EtYNOBlD7/1ZqlAgvHqD/BOA9FAO3uRwgdD7BhAQplP8ZfLizpOq+o91q2gnb0T5WnM85mWuANyrXWZdrB91StMjENL6jhXRcZSsua/PGCPw38tGqdwRa1GCuXRZjMoeQ5z/7gR64XNmfjZut17xUj3JkQtCIasD60iwC6cJqO5pZPfZSoJLtJMdKpl//M1kn077Ap0cOwJEonj1xFerNw69+SOK7Z/zFhDtHP4/c+JCBSWm9y/Xle57XDNvdZ/3cZ8RYo01ZOEn2ignwd2Y0J5frnfOpUPM0bRt2MoGosLNmj/UdZAp4wtbhTUND26LCS0FNPgZ4B4vb3dwQpJwZ22G2rvenKDOs7DLsBmbona69mYqm+RuY8q5lqkLlSqV8BOFO6psQxrLx7hbkxx+AJCWpGqwm/h+pAiSZ3E/v4OO0IXMIB2rylC0PJ3LSwDFdZNkWADceJF8AQBfu2/Y+0cmfWcCoJrU93hI1UwEXoiWdD/yR+MeaNjo5U4zkxIzP5cV8FU6NrLSboQCYYX8US2TGXu+dO3ugJ5r0zdajUUDhfNEN/qRcMnCur7PHFvDuellh1/c7d3/z+hOefSqyAB2G926K1ph8Kx5t2fLYGxWXviruothLz8C8X2qGsmgeVkx3MsiGsuQ1/ex9OUJYZDKoB8wX5emEeEmLz5GQ4XW60IlJ9zJSVWlk80TD43vfgv5S0YX+Kq6oEk9T/+4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

The core implementation of dynamic kernel stacks.

Unlike traditional kernel stacks, these stacks auto-grow as they are
used. This allows to save a significant amount of memory in the fleet
environments. Also, potentially the default size of kernel thread can be
increased in order to prevent stack overflows without compromising on
the overall memory overhead.

The dynamic kernel stacks interface provides two global functions:

1. dynamic_stack_fault().
Architectures that support dynamic kernel stacks, must call this function
in order to handle the fault in the stack.

It allocates and maps new pages into the stack. The pages are
maintained in a per-cpu data structure.

2. dynamic_stack()
Must be called as a thread leaving CPU to check if the thread has
allocated dynamic stack pages (tsk->flags & PF_DYNAMIC_STACK) is set.
If this is the case, there are two things need to be performed:
  a. Charge the thread for the allocated stack pages.
  b. refill the per-cpu array so the next thread can also fault.

Dynamic kernel threads do not support "STACK_END_MAGIC", as the last
page does not have to be faulted in. However, since they are based off
vmap stacks, the guard pages always protect the dynamic kernel stacks
from overflow.

The average depth of a kernel thread depends on the workload, profiling,
virtualization, compiler optimizations, and driver implementations.

Therefore, the numbers should be tested for a specific workload. From
my tests I found the following values on a freshly booted idling
machines:

CPU           #Cores #Stacks  Regular(kb) Dynamic(kb)
AMD Genoa        384    5786    92576       23388
Intel Skylake    112    3182    50912       12860
AMD Rome         128    3401    54416       14784
AMD Rome         256    4908    78528       20876
Intel Haswell     72    2644    42304       10624

On all machines dynamic kernel stacks take about 25% of the original
stack memory. Only 5% of active tasks performed a stack page fault in
their life cycles.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased, used vm_area->nr_pages directly in one instance]
[Depends on !PREEMPT_RT]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Fix races around accounting]
[Use GFP_ATOMIC when executing in the scheduler]
[Depend on INIT_STACK_ALL_* config]
[Fix bugs in some error paths and edge cases]
[Don't cache partially faulted stacks]
[Added out-var to tell if address is on target stack]
Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/Kconfig                     |  39 ++++
 include/linux/sched.h            |  11 +-
 include/linux/sched/task_stack.h |  47 +++-
 init/init_task.c                 |   4 +
 kernel/fork.c                    | 357 +++++++++++++++++++++++++++++--
 kernel/sched/core.c              |   1 +
 6 files changed, 439 insertions(+), 20 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 102ddbd4298e..95ded79f0825 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1515,6 +1515,45 @@ config VMAP_STACK
 	  backing virtual mappings with real shadow memory, and KASAN_VMALLOC
 	  must be enabled.
 
+config HAVE_ARCH_DYNAMIC_STACK
+	def_bool n
+	help
+	  An arch should select this symbol if it can support kernel stacks
+	  that grow dynamically.
+
+	  - Arch must have support for HAVE_ARCH_VMAP_STACK, in order to handle
+	    stack related page faults.
+
+	  - Arch must be able to fault from interrupt context.
+
+	  - Arch must allow the kernel to handle stack faults gracefully, even
+	    during interrupt handling.
+
+	  - Exceptions such as no pages available should be handled the same
+	    in the consistent and predictable way. I.e. the exception should be
+	    handled the same as when stack overflow occurs when guard pages are
+	    touched with extra information about the allocation error.
+
+config DYNAMIC_STACK
+	default y
+	bool "Dynamically grow kernel stacks"
+	depends on THREAD_INFO_IN_TASK
+	depends on HAVE_ARCH_DYNAMIC_STACK
+	depends on VMAP_STACK
+	depends on INIT_STACK_ALL_ZERO || INIT_STACK_ALL_PATTERN
+	depends on !KASAN
+	depends on !DEBUG_STACK_USAGE
+	depends on !STACK_GROWSUP
+	depends on !PREEMPT_RT
+	help
+	  Dynamic kernel stacks allow to save memory on machines with a lot of
+	  threads by starting with small stacks, and grow them only when needed.
+	  On workloads where most of the stack depth do not reach over one page
+	  the memory saving can be substantial. The feature requires virtually
+	  mapped kernel stacks in order to handle page faults. It requires stack
+	  initialization to preclude one thread from faulting on another thread's
+	  stack.
+
 config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	def_bool n
 	help
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a5d3dbc9cdf..7aa06233afd5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -836,7 +836,11 @@ struct task_struct {
 	 */
 	randomized_struct_fields_start
 
+#ifdef CONFIG_DYNAMIC_STACK
+	unsigned long			packed_stack;
+#else
 	void				*stack;
+#endif
 	refcount_t			usage;
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
@@ -1563,6 +1567,11 @@ struct task_struct {
 	struct timer_list		oom_reaper_timer;
 #endif
 #ifdef CONFIG_VMAP_STACK
+	/*
+	 * We can't call find_vm_area() in interrupt context, and
+	 * free_thread_stack() can be called in interrupt context,
+	 * so cache the vm_struct.
+	 */
 	struct vm_struct		*stack_vm_area;
 #endif
 #ifdef CONFIG_THREAD_INFO_IN_TASK
@@ -1773,7 +1782,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_DYNAMIC_STACK	0x00800000	/* This thread allocated dynamic stack pages */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 1fab7e9043a3..7dcff2836d7e 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -13,6 +13,10 @@
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
+#ifdef CONFIG_DYNAMIC_STACK
+#define DYNAMIC_STACK_MAX_ACCOUNT_MASK  ((1 << (THREAD_SIZE_ORDER + 1)) - 1)
+#endif
+
 /*
  * When accessing the stack of a non-current task that might exit, use
  * try_get_task_stack() instead.  task_stack_page will return a pointer
@@ -20,7 +24,11 @@
  */
 static __always_inline void *task_stack_page(const struct task_struct *task)
 {
+#ifdef CONFIG_DYNAMIC_STACK
+	return (void *)(task->packed_stack & ~DYNAMIC_STACK_MAX_ACCOUNT_MASK);
+#else
 	return task->stack;
+#endif
 }
 
 #define setup_thread_stack(new,old)	do { } while(0)
@@ -30,7 +38,7 @@ static __always_inline unsigned long *end_of_stack(const struct task_struct *tas
 #ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long *)((unsigned long)task->stack + THREAD_SIZE) - 1;
 #else
-	return task->stack;
+	return task_stack_page(task);
 #endif
 }
 
@@ -83,9 +91,45 @@ static inline void put_task_stack(struct task_struct *tsk) {}
 
 void exit_task_stack_account(struct task_struct *tsk);
 
+#ifdef CONFIG_DYNAMIC_STACK
+
+#define task_stack_end_corrupted(task)	0
+
+#ifndef THREAD_PREALLOC_PAGES
+#define THREAD_PREALLOC_PAGES		1
+#endif
+
+#define THREAD_DYNAMIC_PAGES						\
+	((THREAD_SIZE >> PAGE_SHIFT) - THREAD_PREALLOC_PAGES)
+
+void dynamic_stack_refill_pages(void);
+unsigned long dynamic_stack_accounting(struct task_struct *tsk, bool finalize);
+bool dynamic_stack_fault(struct task_struct *tsk, unsigned long address, bool *on_stack);
+
+/*
+ * Refill and charge for the used pages.
+ */
+static inline void dynamic_stack(struct task_struct *tsk)
+{
+	if (unlikely(tsk->flags & PF_DYNAMIC_STACK)) {
+		dynamic_stack_refill_pages();
+		dynamic_stack_accounting(tsk, false);
+		tsk->flags &= ~PF_DYNAMIC_STACK;
+	}
+}
+
+static inline void set_task_stack_end_magic(struct task_struct *tsk) {}
+
+#else /* !CONFIG_DYNAMIC_STACK */
+
 #define task_stack_end_corrupted(task) \
 		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
+void set_task_stack_end_magic(struct task_struct *tsk);
+static inline void dynamic_stack(struct task_struct *tsk) {}
+
+#endif /* CONFIG_DYNAMIC_STACK */
+
 static inline int object_is_on_stack(const void *obj)
 {
 	void *stack = task_stack_page(current);
@@ -104,7 +148,6 @@ static inline unsigned long stack_not_used(struct task_struct *p)
 	return 0;
 }
 #endif
-extern void set_task_stack_end_magic(struct task_struct *tsk);
 
 static inline int kstack_end(void *addr)
 {
diff --git a/init/init_task.c b/init/init_task.c
index 5c838757fc10..e3645ec4ab02 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -99,7 +99,11 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	.stack_refcount	= REFCOUNT_INIT(1),
 #endif
 	.__state	= 0,
+#ifdef CONFIG_DYNAMIC_STACK
+	.packed_stack	= (unsigned long)init_stack,
+#else
 	.stack		= init_stack,
+#endif
 	.usage		= REFCOUNT_INIT(2),
 	.flags		= PF_KTHREAD,
 	.prio		= MAX_PRIO - 20,
diff --git a/kernel/fork.c b/kernel/fork.c
index 01e0bf4f4b02..e615ef736dc0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -202,7 +202,10 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
  * accounting is performed by the code assigning/releasing stacks to tasks.
  * We need a zeroed memory without __GFP_ACCOUNT.
  */
-#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
+static gfp_t vmap_stack_gfp(bool is_atomic)
+{
+	return (is_atomic ? GFP_ATOMIC : GFP_KERNEL) | __GFP_ZERO;
+}
 
 struct vm_stack {
 	struct rcu_work work;
@@ -241,6 +244,18 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	unsigned int i;
 	int nid;
 
+#ifdef CONFIG_DYNAMIC_STACK
+	/*
+	 * Skip the cache for populated dynamic stacks to avoid punishing a
+	 * memcg with a larger charge just because it happened to pick up a
+	 * dynamic stack that's been partially faulted in. We may get a lower
+	 * number of cache hits, but stacks with dynamically faulted pages
+	 * should be fairly uncommon.
+	 */
+	if (vm_area->nr_pages != THREAD_PREALLOC_PAGES)
+		return false;
+#endif /* CONFIG_DYNAMIC_STACK */
+
 	/*
 	 * Don't cache stacks if any of the pages don't match the local domain, unless
 	 * there is no local memory to begin with.
@@ -269,11 +284,285 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+#ifdef CONFIG_DYNAMIC_STACK
+
+/*
+ * There is a window between when a thread refills the page pool and when it
+ * actually gets scheduled out where it can still consume pages from the pool.
+ * To guarantee the next thread has enough pages to fully populate its stack,
+ * double the size of the page pool.
+ */
+#define DYNSTK_PAGE_POOL_NR (THREAD_DYNAMIC_PAGES * 2)
+
+static DEFINE_PER_CPU(struct page *, dynamic_stack_pages[DYNSTK_PAGE_POOL_NR]);
+
+static void link_vmap_stack_to_task(struct task_struct *tsk, struct vm_struct *vm_area)
+{
+	tsk->stack_vm_area = vm_area;
+	tsk->packed_stack = (unsigned long)kasan_reset_tag(vm_area->addr);
+}
+
+static void free_vmap_stack(struct vm_struct *vm_area)
+{
+	int i;
+
+	remove_vm_area(vm_area->addr);
+
+	for (i = 0; i < vm_area->nr_pages; i++)
+		__free_page(vm_area->pages[i]);
+
+	kfree(vm_area->pages);
+	kfree(vm_area);
+}
+
+static struct vm_struct *alloc_vmap_stack(int node)
+{
+	gfp_t gfp = vmap_stack_gfp(false);
+	unsigned long addr, end;
+	struct vm_struct *vm_area;
+	int err, i;
+
+	/*
+	 * Paranoid check to guarantee we never straddle a page table, so
+	 * that virt_to_kpte() is always valid in dynamic_stack_fault().
+	 */
+	BUILD_BUG_ON((PMD_SIZE % THREAD_SIZE) || (THREAD_ALIGN % THREAD_SIZE));
+
+	vm_area = get_vm_area_node(THREAD_SIZE, THREAD_ALIGN, VM_MAP, node,
+				   gfp, __builtin_return_address(0));
+	if (!vm_area)
+		return NULL;
+
+	vm_area->pages = kmalloc_node(sizeof(void *) *
+				      (THREAD_SIZE >> PAGE_SHIFT), gfp, node);
+	if (!vm_area->pages)
+		goto cleanup_err;
+
+	for (i = 0; i < THREAD_PREALLOC_PAGES; i++) {
+		vm_area->pages[i] = alloc_pages(gfp, 0);
+		if (!vm_area->pages[i])
+			goto cleanup_err;
+		vm_area->nr_pages++;
+	}
+
+	addr = (unsigned long)vm_area->addr +
+					(THREAD_DYNAMIC_PAGES << PAGE_SHIFT);
+	end = (unsigned long)vm_area->addr + THREAD_SIZE;
+	err = vmap_pages_range(addr, end, PAGE_KERNEL, vm_area->pages, PAGE_SHIFT);
+	if (err)
+		goto cleanup_err;
+
+	return vm_area;
+cleanup_err:
+	free_vmap_stack(vm_area);
+	return NULL;
+}
+
+static struct page *noinstr dynamic_stack_get_page(void)
+{
+	struct page **pages = this_cpu_ptr(dynamic_stack_pages);
+	int i;
+
+	for (i = 0; i < DYNSTK_PAGE_POOL_NR; i++) {
+		struct page *page = pages[i];
+
+		if (!page)
+			continue;
+		pages[i] = NULL;
+		return page;
+	}
+
+	return NULL;
+}
+
+static int dynamic_stack_refill_pages_cpu(unsigned int cpu)
+{
+	struct page **pages = per_cpu_ptr(dynamic_stack_pages, cpu);
+	int i;
+
+	for (i = 0; i < DYNSTK_PAGE_POOL_NR; i++) {
+		if (pages[i])
+			continue;
+		pages[i] = alloc_pages(vmap_stack_gfp(false), 0);
+		if (unlikely(!pages[i])) {
+			pr_err("failed to allocate dynamic stack page for cpu[%d]\n",
+			       cpu);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int dynamic_stack_free_pages_cpu(unsigned int cpu)
+{
+	struct page **pages = per_cpu_ptr(dynamic_stack_pages, cpu);
+	int i;
+
+	for (i = 0; i < DYNSTK_PAGE_POOL_NR; i++) {
+		if (!pages[i])
+			continue;
+		__free_page(pages[i]);
+		pages[i] = NULL;
+	}
+
+	return 0;
+}
+
+void dynamic_stack_refill_pages(void)
+{
+	struct page **pages = this_cpu_ptr(dynamic_stack_pages);
+	int i;
+
+	for (i = 0; i < DYNSTK_PAGE_POOL_NR; i++) {
+		struct page *page = pages[i];
+
+		if (page)
+			continue;
+
+		/*
+		 * This is called during context switch, so we can't take any
+		 * sleeping locks. As such, we need to use GFP_ATOMIC.
+		 */
+		page = alloc_pages(vmap_stack_gfp(true), 0);
+		if (unlikely(!page))
+			pr_err_ratelimited("failed to refill per-cpu dynamic stack\n");
+		pages[i] = page;
+	}
+}
+
+unsigned long dynamic_stack_accounting(struct task_struct *tsk, bool finalize)
+{
+	struct vm_struct *vm_area = tsk->stack_vm_area;
+	unsigned long nr_accounted, i;
+
+	cant_sleep();
+
+	/* Verify enough low order bits in the page-aligned stack pointer. */
+	BUILD_BUG_ON(THREAD_PREALLOC_PAGES == 0 ||
+		     PAGE_SIZE - 1 <= DYNAMIC_STACK_MAX_ACCOUNT_MASK);
+
+	nr_accounted = tsk->packed_stack & DYNAMIC_STACK_MAX_ACCOUNT_MASK;
+
+	if (nr_accounted == DYNAMIC_STACK_MAX_ACCOUNT_MASK) {
+		WARN_ON_ONCE(finalize);
+		return 0;
+	}
+
+	for (i = THREAD_PREALLOC_PAGES + nr_accounted; i < vm_area->nr_pages; i++) {
+		struct page *page = vm_area->pages[i];
+
+		int ret = memcg_kmem_charge_page(page, GFP_ATOMIC, 0);
+		/*
+		 * XXX Since stack pages were already allocated, we should never
+		 * fail charging. Therefore, we should probably induce force
+		 * charge and oom killing if charge fails.
+		 */
+		if (unlikely(ret))
+			pr_warn_ratelimited("dynamic stack: charge for allocated page failed\n");
+
+		mod_lruvec_page_state(page, NR_KERNEL_STACK_KB,
+				      PAGE_SIZE / 1024);
+	}
+
+	if (finalize) {
+		tsk->packed_stack |= DYNAMIC_STACK_MAX_ACCOUNT_MASK;
+	} else {
+		tsk->packed_stack &= ~DYNAMIC_STACK_MAX_ACCOUNT_MASK;
+		tsk->packed_stack |= (i - THREAD_PREALLOC_PAGES);
+	}
+
+	return i;
+}
+
+bool noinstr dynamic_stack_fault(struct task_struct *tsk, unsigned long address, bool *on_stack)
+{
+	unsigned long stack, hole_end, addr;
+	struct vm_struct *vm_area;
+	struct page *page;
+	int nr_pages;
+	pte_t *pte;
+
+	cant_sleep();
+
+	if (WARN_ON(in_nmi())) {
+		*on_stack = false;
+		return false;
+	}
+
+	/* check if address is inside the kernel stack area */
+	stack = (unsigned long)task_stack_page(tsk);
+	if (address < stack || address >= stack + THREAD_SIZE) {
+		*on_stack = false;
+		return false;
+	}
+	*on_stack = true;
+
+	vm_area = tsk->stack_vm_area;
+	if (WARN_ON_ONCE(!vm_area))
+		return false;
+
+	nr_pages = vm_area->nr_pages;
+
+	/* Check if fault address is within the stack hole */
+	hole_end = stack + THREAD_SIZE - (nr_pages << PAGE_SHIFT);
+	if (address >= hole_end)
+		return false;
+
+	/*
+	 * Most likely we faulted in the page right next to the last mapped
+	 * page in the stack, however, it is possible (but very unlikely) that
+	 * the faulted page is actually skips some pages in the stack. Make sure
+	 * we do not create  more than one holes in the stack, and map every
+	 * page between the current fault  address and the last page that is
+	 * mapped in the stack.
+	 */
+	address = PAGE_ALIGN_DOWN(address);
+	for (addr = hole_end - PAGE_SIZE; addr >= address; addr -= PAGE_SIZE) {
+		/* Take the next page from the per-cpu list */
+		page = dynamic_stack_get_page();
+		if (!page) {
+			instrumentation_begin();
+			pr_emerg("Failed to allocate a page during kernel_stack_fault\n");
+			instrumentation_end();
+			return false;
+		}
+
+		/* Add the new page entry to the page table */
+		pte = virt_to_kpte(addr);
+		if (!pte) {
+			instrumentation_begin();
+			pr_emerg("The PTE page table for a kernel stack is not found\n");
+			instrumentation_end();
+			return false;
+		}
+
+		/* Make sure there are no existing mappings at this address */
+		if (pte_present(*pte)) {
+			instrumentation_begin();
+			pr_emerg("The PTE contains a mapping\n");
+			instrumentation_end();
+			return false;
+		}
+		set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+
+		/* Store the new page in the stack's vm_area */
+		vm_area->pages[nr_pages] = page;
+		vm_area->nr_pages = ++nr_pages;
+	}
+
+	/* Refill the pcp stack pages during context switch */
+	tsk->flags |= PF_DYNAMIC_STACK;
+
+	return true;
+}
+
+#else /* !CONFIG_DYNAMIC_STACK */
 static inline struct vm_struct *alloc_vmap_stack(int node)
 {
 	void *stack;
 
-	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, GFP_VMAP_STACK,
+	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, vmap_stack_gfp(false),
 			       node, __builtin_return_address(0));
 
 	return stack ? find_vm_area(stack) : NULL;
@@ -284,6 +573,13 @@ static inline void free_vmap_stack(struct vm_struct *vm_area)
 	vfree(vm_area->addr);
 }
 
+static void link_vmap_stack_to_task(struct task_struct *tsk, struct vm_struct *vm_area)
+{
+	tsk->stack_vm_area = vm_area;
+	tsk->stack = kasan_reset_tag(vm_area->addr);
+}
+#endif /* CONFIG_DYNAMIC_STACK */
+
 static void thread_stack_free_work(struct work_struct *work)
 {
 	struct vm_stack *vm_stack = container_of(to_rcu_work(work), struct vm_stack, work);
@@ -300,9 +596,9 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
 	struct vm_stack *vm_stack;
 
 	if (IS_ENABLED(CONFIG_STACK_GROWSUP))
-		vm_stack = tsk->stack;
+		vm_stack = task_stack_page(tsk);
 	else
-		vm_stack = tsk->stack + THREAD_SIZE - sizeof(*vm_stack);
+		vm_stack = task_stack_page(tsk) + THREAD_SIZE - sizeof(*vm_stack);
 
 	vm_stack->stack_vm_area = tsk->stack_vm_area;
 	INIT_RCU_WORK(&vm_stack->work, thread_stack_free_work);
@@ -361,14 +657,13 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
-		tsk->stack = kasan_reset_tag(vm_area->addr);
+		link_vmap_stack_to_task(tsk, vm_area);
 
 		/* Clear stale pointers from reused stack. */
 		if (!IS_ENABLED(CONFIG_STACK_GROWSUP))
 			memset_offset = THREAD_SIZE - vm_area->nr_pages * PAGE_SIZE;
-		memset(tsk->stack + memset_offset, 0, vm_area->nr_pages * PAGE_SIZE);
+		memset(task_stack_page(tsk) + memset_offset, 0, vm_area->nr_pages * PAGE_SIZE);
 
-		tsk->stack_vm_area = vm_area;
 		return 0;
 	}
 
@@ -380,22 +675,20 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		free_vmap_stack(vm_area);
 		return -ENOMEM;
 	}
-	/*
-	 * We can't call find_vm_area() in interrupt context, and
-	 * free_thread_stack() can be called in interrupt context,
-	 * so cache the vm_struct.
-	 */
-	tsk->stack_vm_area = vm_area;
-	tsk->stack = kasan_reset_tag(vm_area->addr);
+	link_vmap_stack_to_task(tsk, vm_area);
 	return 0;
 }
 
 static void free_thread_stack(struct task_struct *tsk)
 {
-	if (!try_release_thread_stack_to_cache(tsk->stack_vm_area))
+	if (!try_release_thread_stack_to_cache(task_stack_vm_area(tsk)))
 		thread_stack_delayed_free(tsk);
 
+#ifdef CONFIG_DYNAMIC_STACK
+	tsk->packed_stack = 0;
+#else
 	tsk->stack = NULL;
+#endif
 	tsk->stack_vm_area = NULL;
 }
 
@@ -498,9 +791,27 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 {
 	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
 		struct vm_struct *vm_area = task_stack_vm_area(tsk);
-		int i;
+		int i, nr_accounted;
 
-		for (i = 0; i < vm_area->nr_pages; i++)
+#ifdef CONFIG_DYNAMIC_STACK
+		/*
+		 * For the exit path, resolve any pending accounting to avoid
+		 * underflow. Finalize to skip accounting for any faults that
+		 * happen between here and this thread's final __schedule()
+		 * call in do_task_dead().
+		 */
+		if (account < 0) {
+			preempt_disable();
+			nr_accounted = dynamic_stack_accounting(tsk, true);
+			preempt_enable();
+		} else {
+			nr_accounted = THREAD_PREALLOC_PAGES;
+		}
+#else
+		nr_accounted = vm_area->nr_pages;
+#endif
+
+		for (i = 0; i < nr_accounted; i++)
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
 	} else {
@@ -901,6 +1212,16 @@ void __init fork_init(void)
 			  NULL, free_vm_stack_cache);
 #endif
 
+#ifdef CONFIG_DYNAMIC_STACK
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:dynamic_stack",
+			  dynamic_stack_refill_pages_cpu,
+			  dynamic_stack_free_pages_cpu);
+	/*
+	 * Fill the dynamic stack pages for the boot CPU, others will be filled
+	 * as CPUs are onlined.
+	 */
+	dynamic_stack_refill_pages_cpu(smp_processor_id());
+#endif
 	scs_init();
 
 	lockdep_init_task(&init_task);
@@ -914,6 +1235,7 @@ int __weak arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+#ifndef CONFIG_DYNAMIC_STACK
 void set_task_stack_end_magic(struct task_struct *tsk)
 {
 	unsigned long *stackend;
@@ -921,6 +1243,7 @@ void set_task_stack_end_magic(struct task_struct *tsk)
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 }
+#endif
 
 static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 496dff740dca..417269a86973 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6783,6 +6783,7 @@ static void __sched notrace __schedule(int sched_mode)
 	rq = cpu_rq(cpu);
 	prev = rq->curr;
 
+	dynamic_stack(prev);
 	schedule_debug(prev, preempt);
 
 	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


