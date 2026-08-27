Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA32DC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7785D6B0099; Thu, 27 Aug 2026 19:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728B36B009B; Thu, 27 Aug 2026 19:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8C86B009D; Thu, 27 Aug 2026 19:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324616B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE5F280212
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:31 +0000 (UTC)
X-FDA: 85148648382.06.24093D9
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id E9D311C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NX9mqp6b;
	spf=pass (imf18.hostedemail.com: domain of 30MiQaggKCAEtufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=30MiQaggKCAEtufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873489;
	b=rREgLt1E6L4/CP7TlN0hQjr5Joa7Bf/xYg7C18zvLmL2QPuTQg6NsACKLYeUbaI6pMWtyz
	aXEv1u/UxawQB9ZHzTw+zVGK+fW/0yty9vZZOS8GcftDThV1OrvdOXfTq6WRONdW4S5FiX
	nIVpw2GX7yxrAcfS5Qlf80HSwXskKjQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NX9mqp6b;
	spf=pass (imf18.hostedemail.com: domain of 30MiQaggKCAEtufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=30MiQaggKCAEtufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsQSfVFeubNsDIXPhKgUpT/ImczFchV73yRsCSFESEY=;
	b=IZlxuL0jVHN0l9GDjJHg7sOVFE9V49jyRNe3MmkAaq8LVPrhoH/LiTZtMv5Y3+J4u22E2d
	j7qHH47wbV9ehS/VBOHa5JKB4EdcejQ5uezDUyFxMhRcXepwLiVjv+3mw0zUjG3qMjKHi5
	7dhPiItOQT2czosHcnPAN4fdwrO5J4I=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso620702a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873489; x=1788478289; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qsQSfVFeubNsDIXPhKgUpT/ImczFchV73yRsCSFESEY=;
        b=NX9mqp6bTOCOboOfGL8Le1I4h6YqFZWOzL2AUoNrD1y67h0AyOLOyVSe0rLlsh3C9z
         VVILToRmU33Q4zeVG/PZxccfFbLjs7Twd9Cj7Uxzj26tV/wvdJ4VY4zOLF4ZQSnnNjh8
         85DGvx2XRw9ZqtZcujOdNa/ZtolbpIkSOnPN6RLDcSgqvYtj0Nh70FoNxKd2zaA3B4qf
         WKqjHzstOhU9DUSu3+wpyoN5Ikg9xmZTTEnE+Y/Rjn/JyA4SmEW//GrciYqsgmnKR8tx
         c0gL+vcrO/xesXCSYgvQZ4aN+TkqxEghY0rPXm8Wj6VARz4F/aQK7AOxR5s0QcWcorHx
         0UUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873489; x=1788478289;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qsQSfVFeubNsDIXPhKgUpT/ImczFchV73yRsCSFESEY=;
        b=P0kLQEFhqOLqpipRHAY1I4Q80RlvNirSDsJ/pAbEFn5zUGZNR6XVH8PXsIQ1JWSnSD
         4XkW1N1VCZkVFTE4UrTUoMO0TWshH5ne8zYrseLlo8qDOezZXGOovfO/RAW178ZjrCuZ
         9kR4YXq31l9POgOiiBPYVtpziWQGd202KmlFiuc6AZAIWMQAQjWLBo6YDRG4qF4WS4Gf
         KZ7jTf0Pi277LQlAzTxwYcAadvQ9tkmqIeC5ndQww+5mFxc5K0w/rMhm5jMM2j44wGYI
         Ogv2l8180NhnnU3Uqve1Mtw34w5rVZw/ft+PpPftMc8i7050Kk7QoP6ImZYSxN9tYD+n
         Rnaw==
X-Forwarded-Encrypted: i=1; AHgh+RqPS1cAH+YQAEs8EEMGb0d5XUKRDoVB26JwzpRTo6wAv3sZkE5nxfe53K/A1rRxUUrO2/80jDb2rQ==@kvack.org
X-Gm-Message-State: AFuF++m4Mm2kwA5x6EhTSPW5x71sBUgTGfPOAwoeM39wlIdt6S0C+9CT
	1L4Jspf6MxQG4pyOAcZvlCipyeS6hrRULffkMrr6Cghn5oKHbijjEf8KmzL1iN8nTtteOgvjxXP
	OrmO/HhCnlDR4ig==
X-Received: from dli22-n1.prod.google.com ([2002:a05:7022:296:10b0:141:ac8:b5ae])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:da83:b0:38f:efed:5445 with SMTP id 98e67ed59e1d1-396d0de796fmr5335679a91.4.1787873488329;
 Thu, 27 Aug 2026 16:31:28 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:44 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-7-stevensd@google.com>
Subject: [RFC 06/10] Reclaim memory from blocked kernel stacks
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 4fiupr7g6ahz857ofwzndg6thpk7ygy7
X-Rspamd-Queue-Id: E9D311C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787873489-534101
X-HE-Meta: U2FsdGVkX193gt4AqmJSpJhlCpfriDUh5Y51rHCpA1t/Fhxp3kyUTYMYZ2l0CW6m2zpxnSUMLz1klkKYP+j96dtOvFZCUV+UJfGeYI1s2iVmTCxbt110ql57FWHZIozbZ6YYoZofVRGoMqWTNnYoqPFq3Nld140FfBqksNrq/nRcTZwUxNaQoUy1C91w7mkqNPzOzVf60XKydxd7b1sXNWvPZYO+Gnv7rAXV9xiBJtsyS4HrcsAsq8rme3zGm722p1miBntjV9WwR98bmiHu/HZPmv18pOTSxUSdbfUuOSmwFN4WfPQF/W1UESZw40l1Ez/Q/iJaOiDkDpYwJ5y5/33Nnwd2YndZ9ln+Ti3xeEhIdan/I0rdjYFGIdfDEcpxN38c5+NVBHSfm2Nz5BKPVaB5IVbiSf5vZsPuwQQl8sIUjREHCvWjknIfZeC8flp7qZZZ1O014amDTFTyWl2UGuSzPcgTUw8cHwCIq7OJ+V6vansmKVe9nY/NJJGHf/cLONH+Z8AcSOetc3uotVtlMrewrBux21xOlXqZKesTkSW9ghDFFLQ0IoTTraQLEI2JFrj73C9ZY3JfUe6RTGNTvQ0VNq3UARIQ5sMND/EKwk/brKcZao4UDs9CHcl0EY4MT8WvpxN8eEjgYj2GkQ4QYb7lgKxzWTmdn2zJB/syS7a9bjTNykhigM+Ni5vD3sv2E0MwoQQPvoDyFhVZshRgryDMxk7RNej7ixJrpaieAz5oofpo0DcHXwEGXNjrB801mH9kx2hqxOhpqs6P/CVF+DxHD9ses+OrJmeD3tAdExektlJ4aVxfHjqcEeQNSqg0yuEx0Fj0U37X6qH2yZG7o3hQyrikfS6vCGikFEM3MAT2NoMpHIWMHYfahQ7h2rHTZ9PnSXFxfcx1OwmGYd2SXGtsEE7quLLMBSOgQPMKIQZ3Y5rRagc2AxAN07oNqUpvZyb0BtFeJS5fQyoAp+P
 X31wwjAr
 gKCDc+mBD/vmF2C8Y0FC9e4557Vso770L4Fyg3yUXCzte6fKD32BLignSB3zggjEJJu3UsQAXI2BRk2SphctH9XNm/Z+kqUJh7oJLr6Bsv0OGGsyWWF/fEqQSRUSFme39Ucj47r+VqmtBUI/gxIB3liZjo8n6Nn/FXN7disUrSvcsGIF2ZUbFJwHekH6VabpTHE+nmrWumKj1LF/etnKfMpsZAOgSPPpAEKLunIPPOiExTws3bNeMnVMs4IB0yXPCGyHH0/srxG+cfP/6e+r3Mp/4zvyF1roXRRn8sOsqq3g+4dxqslKcg4Hi8N2/0ZsospB3PWchKIIZPe9tegEPSnaublO3+3bf8XQtun25zejZ9sYYcrP4SpoOwwTKuFyNIzLWOURTeJSPIBknfE75HET341myFxPAD6jzWjiKOSQabeJvamw3LpXp6S7rH30NlAVyCY2hCNHs9f5Dmh7R+alvma8VdsSQ+YOB4rzYLVp7hvbfjW4f5V4GTaEWeE+BBFFxQPRLlqG1PnU7xrouveEum5FVWMLF4ANjwYoGSoj5ZFT33iXxTVKm3q0pkceOjt8DqIWLnKZvIW6XbxRxSbKtE5WIcpur3YC3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although an individual kernel stack is cheap, the cost can add up on
thread heavy systems. On such systems, many threads are often blocked
for extended periods of time, waiting for userspace or external events.
When a task is blocked, its stack is in a stable, well-defined state.
Since we can tell exactly which part of those stacks are unused, we can
free the unused portions and reduce the global memory footprint of
kernel stacks.

That said, not all blocked tasks can safely have their stacks reclaimed.
Since a running task may need all of its stack, a blocked task whose
stack has been partially freed cannot be rescheduled until its stack is
fully repopulated. Since allocating that memory may require direct
reclaim, if a task holding a lock that direct reclaim depends on has its
stack reclaimed, we would run the risk of deadlock.

Knowing when tasks hold locks that direct reclaim may depend on is not
viable in production systems, especially without lockdep. But noting
that most userspace threads will be blocked on events external to
the kernel (e.g. waiting on a futex for a userspace controlled wakeup,
waiting in epoll for a network packet, waiting on a timer for time to
pass, etc), it is possible to enumerate a relatively small number of
call sites where most userspace threads will be blocked while holding
zero kernel locks.

This change adds a new component that reclaims task stacks. A set of
scheduler hooks are used to determine when it is safe to reclaim stacks
and to ensure that a task's stack is fully repopulated before being
rescheduled. A new PF_RECLAIMABLE_STACK task flag is added that will be
used to annotate such safe-to-reclaim call sites. Users of the flag must
ensure the task doesn't block while holding a lock while the flag is
set. A new TASK_STACK_RECLAIM state is introduced for tasks that are
blocked waiting for the stacks to be repopulated.

While reclaimable stacks will not cause direct reclaim to deadlock, it
does introduce a dependency on allocating memory before an OOM victim
can exit, since any reclaimed stacks need to be repopulated before their
threads can run again. This dependency can lead to further OOM kills or
potentially an OOM panic if no additional victims are available.

Reclaimable stacks is built on VMAP_STACK. There is no fundamental
dependency on !STACK_GROWSUP, but since the only STACK_GROWSUP
architecture doesn't support VMAP_STACK, support for STACK_GROWSUP is
not implemented.

This feature does work on PREEMPT_RT, but is likely undesirable due to
the extra uncertainty. The fact that alloc_pages_nolock_noprof() cannot
be called from under the scheduler lock also makes repopulating stacks
more expensive.

Enabling reclaimable stacks is mutually exclusive with enabling
DEBUG_STACK_USAGE. Making stack_not_used() safe (including from NMIs)
may be technically feasible. Even then, the number that it would report
would be subtly different: max since last reclaim vs max ever used. This
difference seems likely to confuse anything consuming the data, so
disabling the feature seems prudent.

Since kernel stacks are not visible in PROC_KCORE when reclaimable
stacks is enabled, it is disabled by default when that config is
enabled. If a user wants to enable the manually enable the feature and
give up visibility, they can make that choice.

In the followup patch, reclaiming task stacks will be done in a
shrinker. However, this patch does the reclaim using per-task work
structs for simplicity.

Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/Kconfig                     |  18 ++
 include/linux/sched.h            |  39 ++-
 include/linux/sched/task_stack.h |  23 ++
 kernel/Makefile                  |   2 +
 kernel/fork.c                    |   7 +
 kernel/sched/core.c              |  18 +-
 kernel/sched/sched.h             |   3 +
 kernel/stack_shrinker.c          | 464 +++++++++++++++++++++++++++++++
 kernel/stack_shrinker.h          |  58 ++++
 9 files changed, 627 insertions(+), 5 deletions(-)
 create mode 100644 kernel/stack_shrinker.c
 create mode 100644 kernel/stack_shrinker.h

diff --git a/arch/Kconfig b/arch/Kconfig
index fa7507ac8e13..adb4a5957996 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1534,6 +1534,24 @@ config VMAP_STACK
 	  backing virtual mappings with real shadow memory, and KASAN_VMALLOC
 	  must be enabled.
 
+config HAVE_ARCH_RECLAIMABLE_STACK
+	def_bool n
+
+config RECLAIMABLE_STACK
+	default !PREEMPT_RT && !PROC_KCORE
+	bool "Allow stacks of some blocked threads to be reclaimed"
+	depends on VMAP_STACK && !STACK_GROWSUP
+	depends on HAVE_ARCH_RECLAIMABLE_STACK
+	depends on !DEBUG_STACK_USAGE
+	depends on !KASAN_VMALLOC # TODO: add support for this
+	depends on !DEBUG_KMEMLEAK # TODO: add support for this
+	help
+	  Enable this to allow the unused portion of kernel stacks of most
+	  blocked tasks to be reclaimed.
+
+	  The wakeup latency of tasks with reclaimed stacks may increase,
+	  especially while the system is under memory pressure.
+
 config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	def_bool n
 	help
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..c93a234fac96 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -83,6 +83,7 @@ struct sched_dl_entity;
 struct seq_file;
 struct sighand_struct;
 struct signal_struct;
+struct stack_reclaim_work;
 struct task_delay_info;
 struct task_exec_state;
 struct task_group;
@@ -124,7 +125,8 @@ struct user_event_mm;
 #define TASK_FREEZABLE			0x00002000
 #define __TASK_FREEZABLE_UNSAFE	       (0x00004000 * IS_ENABLED(CONFIG_LOCKDEP))
 #define TASK_FROZEN			0x00008000
-#define TASK_STATE_MAX			0x00010000
+#define TASK_STACK_RECLAIM		0x00010000
+#define TASK_STATE_MAX			0x00020000
 
 #define TASK_ANY			(TASK_STATE_MAX-1)
 
@@ -823,6 +825,29 @@ struct kmap_ctrl {
 #endif
 };
 
+#ifdef CONFIG_RECLAIMABLE_STACK
+enum stack_reclaim_enum {
+	STACK_IN_USE		= 0,
+	STACK_PREPARE_RECLAIM	= 1,
+	STACK_RECLAIMABLE	= 2,
+	STACK_RECLAIMING	= 3,
+	STACK_RECLAIMING_IN_USE = 4,
+	STACK_RECLAIMED		= 5,
+} __packed;
+
+union stack_reclaim_state {
+	struct {
+		enum stack_reclaim_enum stack_state;
+		u16 node;
+	};
+	u32 val;
+};
+
+union stack_reclaim_list {
+	struct llist_node refill_entry;
+};
+#endif
+
 struct task_struct {
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/*
@@ -1587,6 +1612,16 @@ struct task_struct {
 #endif
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct		*stack_vm_area;
+#ifdef CONFIG_RECLAIMABLE_STACK
+	union stack_reclaim_state	stack_reclaim_state;
+	union stack_reclaim_list	stack_reclaim_list;
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup		*stack_obj_cgroup;
+#endif
+
+	// TODO: Replace these with a shrinker
+	struct stack_reclaim_work	*stack_reclaim_work;
+#endif
 #endif
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/* A live task holds one reference: */
@@ -1796,7 +1831,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_RECLAIMABLE_STACK	0x00800000	/* This task's stack is reclaimable */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 1fab7e9043a3..5d5567899d51 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -6,6 +6,7 @@
  * task->stack (kernel stack) handling interfaces:
  */
 
+#include <linux/cleanup.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/refcount.h>
@@ -83,6 +84,10 @@ static inline void put_task_stack(struct task_struct *tsk) {}
 
 void exit_task_stack_account(struct task_struct *tsk);
 
+/*
+ * Must only be called on current or from inside __schedule() on
+ * prev, to avoid crashing when CONFIG_RECLAIM_STACK is enabled.
+ */
 #define task_stack_end_corrupted(task) \
 		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
@@ -114,4 +119,22 @@ static inline int kstack_end(void *addr)
 	return !(((unsigned long)addr+sizeof(void*)-1) & (THREAD_SIZE-sizeof(void*)));
 }
 
+#ifdef CONFIG_RECLAIMABLE_STACK
+
+DEFINE_CLASS(allow_stack_reclaim, bool,
+	     ({
+		if (!_T)
+			current->flags &= ~PF_RECLAIMABLE_STACK;
+	      }),
+	     ({
+		bool was_set = current->flags & PF_RECLAIMABLE_STACK;
+
+		current->flags |= PF_RECLAIMABLE_STACK;
+		was_set;
+	      }),
+	     void)
+#else /* !CONFIG_RECLAIMABLE_STACK */
+DEFINE_CLASS(allow_stack_reclaim, bool, ({ (void)_T; }), ({ false; }), void)
+#endif /* !CONFIG_VMAP_STACK */
+
 #endif /* _LINUX_SCHED_TASK_STACK_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 1e1a31673577..01547102e13a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -12,6 +12,8 @@ obj-y     = fork.o exec_domain.o exec_state.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o
 
+obj-$(CONFIG_RECLAIMABLE_STACK) += stack_shrinker.o
+
 obj-$(CONFIG_MULTIUSER) += groups.o
 obj-$(CONFIG_VHOST_TASK) += vhost_task.o
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 6acad0038b78..9b2cc3d01dd1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -120,6 +120,8 @@
 /* For dup_mmap(). */
 #include "../mm/internal.h"
 
+#include "stack_shrinker.h"
+
 #include <trace/events/sched.h>
 
 #define CREATE_TRACE_POINTS
@@ -460,6 +462,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
+		add_to_stack_shrinker(tsk, node);
 		return 0;
 	}
 
@@ -472,6 +475,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		free_vmap_stack(vm_area);
 		return -ENOMEM;
 	}
+
 	/*
 	 * We can't call find_vm_area() in interrupt context, and
 	 * free_thread_stack() can be called in interrupt context,
@@ -480,6 +484,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 	tsk->stack_vm_area = vm_area;
 	stack = kasan_reset_tag(stack);
 	tsk->stack = stack;
+	add_to_stack_shrinker(tsk, node);
 	return 0;
 }
 
@@ -898,6 +903,7 @@ void __put_task_struct(struct task_struct *tsk)
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
 	sched_core_free(tsk);
+	remove_from_stack_shrinker(tsk);
 	free_task(tsk);
 }
 EXPORT_SYMBOL_GPL(__put_task_struct);
@@ -1124,6 +1130,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 free_stack:
 	exit_task_stack_account(tsk);
 	free_thread_stack(tsk);
+	remove_from_stack_shrinker(tsk);
 free_tsk:
 	free_task_struct(tsk);
 	return NULL;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..ab7db60d5dc2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4252,6 +4252,7 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
 	guard(preempt)();
 	int cpu, success = 0;
+	bool need_deferred_repopulate, do_deferred_repopulate_wake = false;
 
 	wake_flags |= WF_TTWU;
 
@@ -4295,8 +4296,6 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		if (!ttwu_state_match(p, state, &success))
 			break;
 
-		trace_sched_waking(p);
-
 		/*
 		 * Ensure we load p->on_rq _after_ p->state, otherwise it would
 		 * be possible to, falsely, observe p->on_rq == 0 and get stuck
@@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		 * A similar smp_rmb() lives in __task_needs_rq_lock().
 		 */
 		smp_rmb();
-		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
+		if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags)) {
+			trace_sched_waking(p);
+			break;
+		}
+
+		if (!ensure_stack_is_present(p, &need_deferred_repopulate)) {
+			WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
+			do_deferred_repopulate_wake = need_deferred_repopulate;
 			break;
+		}
+
+		trace_sched_waking(p);
 
 		/*
 		 * Ensure we load p->on_cpu _after_ p->on_rq, otherwise it would be
@@ -4418,6 +4427,8 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	if (success)
 		ttwu_stat(p, task_cpu(p), wake_flags);
 
+	if (unlikely(do_deferred_repopulate_wake))
+		wake_stack_repopulate();
 	return success;
 }
 
@@ -5354,6 +5365,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	prev_state = READ_ONCE(prev->__state);
 	vtime_task_switch(prev);
 	perf_event_task_sched_in(prev, current);
+	allow_stack_reclaim(prev);
 	finish_task(prev);
 	tick_nohz_task_switch();
 	finish_lock_switch(rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502ba26..8a81fb83fe8f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -79,6 +79,7 @@
 #include <trace/events/sched.h>
 
 #include "../workqueue_internal.h"
+#include "../stack_shrinker.h"
 
 struct rq;
 struct cfs_rq;
@@ -3039,6 +3040,8 @@ static inline void __block_task(struct rq *rq, struct task_struct *p)
 		delayacct_blkio_start();
 	}
 
+	prepare_stack_for_reclaim(p);
+
 	ASSERT_EXCLUSIVE_WRITER(p->on_rq);
 
 	/*
diff --git a/kernel/stack_shrinker.c b/kernel/stack_shrinker.c
new file mode 100644
index 000000000000..d7b1a7dfa716
--- /dev/null
+++ b/kernel/stack_shrinker.c
@@ -0,0 +1,464 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/cpuhotplug.h>
+#include <linux/highmem.h>
+#include <linux/irq_work.h>
+#include <linux/list.h>
+#include <linux/list_lru.h>
+#include <linux/llist.h>
+#include <linux/memcontrol.h>
+#include <linux/oom.h>
+#include <linux/percpu_counter.h>
+#include <linux/pgtable.h>
+#include <linux/sched/task.h>
+#include <linux/spinlock.h>
+#include <linux/swait.h>
+#include <linux/vmalloc.h>
+
+#include "stack_shrinker.h"
+
+#include "../mm/internal.h"
+
+struct repopulate_work {
+	struct work_struct work;
+	struct llist_head stacks;
+};
+
+static DEFINE_PER_CPU(struct repopulate_work, repopulate_work);
+
+// TODO: replace with shrinker
+struct stack_reclaim_work {
+	struct task_struct *tsk;
+	struct irq_work irq_work;
+	struct work_struct work;
+};
+
+static void schedule_stack_reclaim_work(struct irq_work *w)
+{
+	struct stack_reclaim_work *work = container_of(w, typeof(*work), irq_work);
+
+	if (!queue_work(system_wq, &work->work))
+		put_task_struct(work->tsk);
+}
+
+static void do_reclaim_stack(struct task_struct *tsk);
+
+static void do_stack_reclaim_work(struct work_struct *w)
+{
+	struct task_struct *tsk = container_of(w, struct stack_reclaim_work, work)->tsk;
+
+	do_reclaim_stack(tsk);
+}
+
+#ifdef CONFIG_MEMCG
+static void set_stack_obj_cgroup(struct task_struct *tsk)
+{
+	tsk->stack_obj_cgroup = get_obj_cgroup_from_current();
+}
+
+static void put_stack_obj_cgroup(struct task_struct *tsk)
+{
+	if (tsk->stack_obj_cgroup)
+		obj_cgroup_put(tsk->stack_obj_cgroup);
+}
+
+static inline struct mem_cgroup *get_stack_memcg(struct task_struct *tsk)
+{
+	return tsk->stack_obj_cgroup ? get_mem_cgroup_from_objcg(tsk->stack_obj_cgroup)
+				     : root_mem_cgroup;
+}
+#else /* !CONFIG_MEMCG */
+static void set_stack_obj_cgroup(struct task_struct *tsk) { }
+
+static void put_stack_obj_cgroup(struct task_struct *tsk) { }
+
+static inline struct mem_cgroup *get_stack_memcg(struct task_struct *tsk)
+{
+	return NULL;
+}
+#endif /* CONFIG_MEMCG */
+
+void add_to_stack_shrinker(struct task_struct *tsk, int node)
+{
+	BUILD_BUG_ON(sizeof(tsk->stack_reclaim_state) != sizeof(tsk->stack_reclaim_state.val));
+	BUILD_BUG_ON(NODES_SHIFT > 15);
+
+	tsk->stack_reclaim_state.val = 0;
+	tsk->stack_reclaim_state.stack_state = STACK_IN_USE;
+	tsk->stack_reclaim_state.node = node;
+	set_stack_obj_cgroup(tsk);
+	init_llist_node(&tsk->stack_reclaim_list.refill_entry);
+
+	// TODO: replace with shrinker
+	tsk->stack_reclaim_work = kmalloc_obj(*tsk->stack_reclaim_work, GFP_KERNEL);
+	BUG_ON(!tsk->stack_reclaim_work);
+
+	tsk->stack_reclaim_work->tsk = tsk;
+	init_irq_work(&tsk->stack_reclaim_work->irq_work, schedule_stack_reclaim_work);
+	INIT_WORK(&tsk->stack_reclaim_work->work, do_stack_reclaim_work);
+}
+
+static inline int calculate_num_unused_pages(struct task_struct *tsk)
+{
+	unsigned long top_of_stack = (unsigned long)end_of_stack(tsk);
+	/*
+	 * Since tsk is !on_rq and !on_cpu, top_of_blocked_task_stack() safely
+	 * tells us the end of the stack frame of the inner most context switch
+	 * function. Any parts of the stack above that are stale stack frames
+	 * or never used, and thus can be unmapped and discarded.
+	 */
+	return (top_of_blocked_task_stack(&tsk->thread) - top_of_stack) >> PAGE_SHIFT;
+}
+
+static bool repopulate_stack(struct task_struct *tsk, bool is_deferred,
+			     struct llist_head *fail_list)
+{
+	int num_missing_pages = 0, nr_allocated = 0, ret;
+	struct page *pages[THREAD_SIZE >> PAGE_SHIFT] = {};
+	struct vm_struct *vm_area = tsk->stack_vm_area;
+	unsigned long addr = (unsigned long)vm_area->addr;
+	struct mem_cgroup *tsk_memcg, *old_active_memcg;
+	int node = tsk->stack_reclaim_state.node == U16_MAX ? NUMA_NO_NODE
+							    : tsk->stack_reclaim_state.node;
+
+	num_missing_pages = (THREAD_SIZE >> PAGE_SHIFT) - vm_area->nr_pages;
+	if (num_missing_pages == 0)
+		return true;
+
+	tsk_memcg = get_stack_memcg(tsk);
+	old_active_memcg = set_active_memcg(tsk_memcg);
+
+	if (is_deferred) {
+		gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
+		/*
+		 * If the oom killer wants to free memory from this process,
+		 * allow access to reserves so the task can hopefully run
+		 * sooner to die and thus make progress towards freeing the
+		 * process's non-mm memory.
+		 */
+		if (tsk_is_oom_victim(tsk))
+			gfp |= __GFP_MEMALLOC;
+
+		for (; nr_allocated < num_missing_pages; nr_allocated++) {
+			pages[nr_allocated] = alloc_pages_node_noprof(node, gfp, 0);
+			if (!pages[nr_allocated])
+				goto repopulate_fail;
+		}
+	} else {
+		/*
+		 * PREEMPT_RT turns spin_trylock() from an atomic cmpxchg into
+		 * an operation that takes a rt_mutex's internal raw spin lock.
+		 * Doing that from inside the scheduler would result in a
+		 * circular locking dependency.
+		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_RT))
+			goto repopulate_fail;
+
+		for (; nr_allocated < num_missing_pages; nr_allocated++) {
+			pages[nr_allocated] = alloc_pages_nolock_noprof(__GFP_ACCOUNT,
+									node, 0);
+			if (!pages[nr_allocated])
+				goto repopulate_fail;
+		}
+	}
+
+	set_active_memcg(old_active_memcg);
+	mem_cgroup_put(tsk_memcg);
+
+	for (int i = 0; i < num_missing_pages; i++) {
+		vm_area->pages[i] = pages[i];
+		mod_lruvec_page_state(pages[i], NR_KERNEL_STACK_KB, PAGE_SIZE / 1024);
+		mod_node_page_state(page_pgdat(pages[i]), NR_VMALLOC, 1);
+	}
+	vm_area->nr_pages = THREAD_SIZE >> PAGE_SHIFT;
+
+	/*
+	 * The page tables for the stack were allocated when the stack was
+	 * originally created, so we're guaranteed not to need to allocate new
+	 * ones. As such, vmap_pages_range() won't acquire any locks and can be
+	 * called under the scheduler's raw spinlocks.
+	 *
+	 * The only way it can fail is if we're trying to colbber an existing
+	 * mapping or if the page allocator gave us an invalid page. Neither
+	 * case is recoverable.
+	 */
+	ret = vmap_pages_range(addr, addr + num_missing_pages * PAGE_SIZE,
+			       PAGE_KERNEL, vm_area->pages, PAGE_SHIFT);
+	BUG_ON(ret != 0);
+
+	// TODO: Clearing pages under the scheduler lock is probably too much
+	// work under a raw spinlock. We could try maintaining our own small
+	// pool of pre-zero'ed pages instead of using alloc_pages_nolock.
+	if (!is_deferred)
+		clear_pages((void *)addr, num_missing_pages);
+
+	set_task_stack_end_magic(tsk);
+	return true;
+
+repopulate_fail:
+	set_active_memcg(old_active_memcg);
+	mem_cgroup_put(tsk_memcg);
+
+	while (nr_allocated--)
+		free_pages_nolock(pages[nr_allocated], 0);
+
+	if (!fail_list) {
+		/*
+		 * Preemption is left disabled until wake_stack_repopulate(), to
+		 * guarantee that we queue the correct work.
+		 */
+		preempt_disable();
+		fail_list = &this_cpu_ptr(&repopulate_work)->stacks;
+	}
+	llist_add(&tsk->stack_reclaim_list.refill_entry, fail_list);
+	return false;
+}
+
+static void release_stack(struct task_struct *tsk)
+{
+	struct vm_struct *vm_area = tsk->stack_vm_area;
+	unsigned long addr = (unsigned long)vm_area->addr;
+	int nr_to_free;
+
+	nr_to_free = calculate_num_unused_pages(tsk);
+
+	if (unlikely(nr_to_free == 0))
+		return;
+
+	vm_area_unmap_pages(vm_area, addr, addr + nr_to_free * PAGE_SIZE);
+	for (int i = 0; i < nr_to_free; i++) {
+		mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
+				      -(int)(PAGE_SIZE / 1024));
+		mod_node_page_state(page_pgdat(vm_area->pages[i]), NR_VMALLOC, -1);
+		__free_pages(vm_area->pages[i], 0);
+	}
+	vm_area->nr_pages -= nr_to_free;
+}
+
+static void do_reclaim_stack(struct task_struct *tsk)
+{
+	union stack_reclaim_state prev_state, target_state;
+
+	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
+	do {
+		target_state.val = prev_state.val;
+		if (prev_state.stack_state == STACK_RECLAIMABLE)
+			target_state.stack_state = STACK_RECLAIMING;
+	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
+
+	/*
+	 * If target_state.stack_state == STACK_RECLAIMING, we know tsk is still
+	 * alive and can't run until we're done, so putting the ref here is safe.
+	 */
+	put_task_struct(tsk);
+	if (target_state.stack_state != STACK_RECLAIMING)
+		return;
+
+	release_stack(tsk);
+
+	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
+	do {
+		target_state.val = prev_state.val;
+		target_state.stack_state = STACK_RECLAIMED;
+	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
+
+	if (prev_state.stack_state == STACK_RECLAIMING_IN_USE) {
+		struct repopulate_work *work = get_cpu_ptr(&repopulate_work);
+
+		llist_add(&tsk->stack_reclaim_list.refill_entry, &work->stacks);
+		queue_work(system_highpri_wq, &work->work);
+		put_cpu_ptr(work);
+	}
+}
+
+static void do_repopulate_stacks(struct work_struct *w)
+{
+	struct repopulate_work *work = container_of(w, struct repopulate_work, work);
+	struct llist_node *head;
+
+	while ((head = llist_del_all(&work->stacks))) {
+		struct task_struct *tsk, *tmp;
+
+		llist_for_each_entry_safe(tsk, tmp, head, stack_reclaim_list.refill_entry) {
+			init_llist_node(&tsk->stack_reclaim_list.refill_entry);
+			if (repopulate_stack(tsk, true, &work->stacks)) {
+				wake_up_state(tsk, TASK_STACK_RECLAIM);
+			} else {
+				/*
+				 * Repopulate only failes due to low memory. If
+				 * that happens, give the rest of the system a
+				 * chance to free some memory.
+				 */
+				cond_resched();
+			}
+		}
+	}
+}
+
+bool __ensure_stack_is_present(struct task_struct *tsk, bool *need_deferred_repopulate)
+{
+	union stack_reclaim_state prev_state, target_state;
+
+	*need_deferred_repopulate = false;
+	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
+	do {
+		target_state.val = prev_state.val;
+
+		switch (prev_state.stack_state) {
+		case STACK_IN_USE:
+			return true;
+		case STACK_PREPARE_RECLAIM:
+		case STACK_RECLAIMABLE:
+		case STACK_RECLAIMED:
+			/*
+			 * Transitioning STACK_RECLAIM -> STACK_IN_USE won't
+			 * combine with the prior STACK_IN_USE case to lead to
+			 * tasks with unpopulated stacks running. If immediate
+			 * repopulation fails, then ttwu() puts the task in the
+			 * TASK_STACK_RECLAIM state, so the only ttwu() that can
+			 * wake up the task is after we repopulate the stack.
+			 */
+			target_state.stack_state = STACK_IN_USE;
+			break;
+		case STACK_RECLAIMING:
+			target_state.stack_state = STACK_RECLAIMING_IN_USE;
+			break;
+		case STACK_RECLAIMING_IN_USE:
+			/*
+			 * Tasks with stacks in state STACK_RECLAIMING_IN_USE
+			 * should have __state == TASK_STACK_RECLAIM state, so
+			 * ttwu_state_match() should reject any wakeups other
+			 * than the one after the stack gets repopulated.
+			 */
+			WARN(1, "TASK_STACK_RECLAIM violation");
+			return false;
+		}
+	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
+
+	switch (prev_state.stack_state) {
+	case STACK_RECLAIMABLE:
+	case STACK_PREPARE_RECLAIM:
+		return true;
+	case STACK_RECLAIMING:
+		return false;
+	case STACK_RECLAIMED:
+		if (repopulate_stack(tsk, false, NULL))
+			return true;
+		*need_deferred_repopulate = true;
+		return false;
+	default:
+		// Unreachable due to return statements in cmpxchg loop
+		unreachable();
+	}
+}
+
+void __prepare_stack_for_reclaim(struct task_struct *tsk)
+{
+	union stack_reclaim_state prev_state, target_state;
+
+	// TODO: Skip rt threads
+
+	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
+	do {
+		target_state.val = prev_state.val;
+
+		if (prev_state.stack_state == STACK_IN_USE) {
+			target_state.stack_state = STACK_PREPARE_RECLAIM;
+		} else {
+			WARN(1, "Runnable thread with reclaimable stack state=%x",
+			     prev_state.stack_state);
+			return;
+		}
+	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
+
+	/*
+	 * With delayed dequeue, __allow_stack_reclaim() can be called by
+	 * finish_task() before __block_task() calls this function. When
+	 * that happens, __allow_stack_reclaim() sees STACK_IN_USE and is
+	 * thus a no-op. We need a call here to progress the state machine.
+	 *
+	 * Note that __block_task() is called under the rq lock, so we don't
+	 * need to worry about concurrent calls.
+	 */
+	if (!tsk->on_cpu)
+		__allow_stack_reclaim(tsk);
+}
+
+void __allow_stack_reclaim(struct task_struct *tsk)
+{
+	union stack_reclaim_state prev_state, target_state;
+
+	if (WARN_ON_ONCE(tsk->__state == TASK_DEAD))
+		return;
+
+	prev_state.val = READ_ONCE(tsk->stack_reclaim_state.val);
+	do {
+		target_state.val = prev_state.val;
+
+		if (prev_state.stack_state != STACK_PREPARE_RECLAIM) {
+			WARN(prev_state.stack_state != STACK_IN_USE,
+			     "Reclaimable state %x for previously running task", prev_state.val);
+			return;
+		}
+		target_state.stack_state = STACK_RECLAIMABLE;
+	} while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.val, target_state.val));
+
+	if (irq_work_queue(&tsk->stack_reclaim_work->irq_work)) {
+		/*
+		 * Take a ref that gets released by do_reclaim_stack() so we don't
+		 * have to worry about races with remove_from_stack_shrinker().
+		 */
+		get_task_struct(tsk);
+	}
+}
+
+/*
+ * This function is called when the task is deleted, which can happen well
+ * after the task releases its stack. However, a dead task will never have
+ * TASK_STACK_RECLAIM set, so its last context switch will leave the stack
+ * state as STACK_IN_USE. As such, if the shrinker processes a task after its
+ * death, it will remove the task from the lru without accessing the stack.
+ */
+void remove_from_stack_shrinker(struct task_struct *tsk)
+{
+	put_stack_obj_cgroup(tsk);
+	kfree(tsk->stack_reclaim_work);
+}
+
+void wake_stack_repopulate(void)
+{
+	queue_work(system_highpri_wq, &this_cpu_ptr(&repopulate_work)->work);
+	preempt_enable();
+}
+
+static int stack_shrinker_cpuhp_setup(unsigned int cpu)
+{
+	struct repopulate_work *work = per_cpu_ptr(&repopulate_work, cpu);
+
+	init_llist_head(&work->stacks);
+	INIT_WORK(&work->work, do_repopulate_stacks);
+	return 0;
+}
+
+static int stack_shrinker_cpuhp_teardown(unsigned int cpu)
+{
+	flush_work(&per_cpu_ptr(&repopulate_work, cpu)->work);
+	return 0;
+}
+
+static int __init fork_late_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "stack_shrinker",
+				stack_shrinker_cpuhp_setup,
+				stack_shrinker_cpuhp_teardown);
+	if (ret < 0) {
+		WARN(1, "Failed to initialize stack_shrinker cpuhp %d\n", ret);
+		return 0;
+	}
+
+	return 0;
+}
+
+module_init(fork_late_init);
diff --git a/kernel/stack_shrinker.h b/kernel/stack_shrinker.h
new file mode 100644
index 000000000000..242a35bddf3e
--- /dev/null
+++ b/kernel/stack_shrinker.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_STACK_SHRINKER_H
+#define _LINUX_STACK_SHRINKER_H
+
+#include <linux/cleanup.h>
+#include <linux/list.h>
+#include <linux/llist.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+
+#ifdef CONFIG_RECLAIMABLE_STACK
+
+void add_to_stack_shrinker(struct task_struct *tsk, int node);
+void remove_from_stack_shrinker(struct task_struct *tsk);
+
+bool __ensure_stack_is_present(struct task_struct *tsk, bool *need_deferred_repopulate);
+void __prepare_stack_for_reclaim(struct task_struct *tsk);
+void __allow_stack_reclaim(struct task_struct *tsk);
+void wake_stack_repopulate(void);
+
+static inline bool ensure_stack_is_present(struct task_struct *tsk, bool *need_deferred_repopulate)
+{
+	if (unlikely(tsk->flags & PF_RECLAIMABLE_STACK))
+		return __ensure_stack_is_present(tsk, need_deferred_repopulate);
+	return true;
+}
+
+static inline void prepare_stack_for_reclaim(struct task_struct *tsk)
+{
+	if (unlikely(tsk->flags & PF_RECLAIMABLE_STACK))
+		__prepare_stack_for_reclaim(tsk);
+}
+
+static inline void allow_stack_reclaim(struct task_struct *tsk)
+{
+	if (unlikely(tsk->flags & PF_RECLAIMABLE_STACK))
+		__allow_stack_reclaim(tsk);
+}
+
+#else /* !CONFIG_RECLAIMABLE_STACK */
+
+static inline void add_to_stack_shrinker(struct task_struct *tsk, int node) {}
+static inline void remove_from_stack_shrinker(struct task_struct *tsk) {}
+
+static inline bool ensure_stack_is_present(struct task_struct *tsk, bool *need_deferred_repopulate)
+{
+	return true;
+}
+
+static inline void prepare_stack_for_reclaim(struct task_struct *tsk) {}
+
+static inline void allow_stack_reclaim(struct task_struct *tsk) {}
+
+static inline void wake_stack_repopulate(void) {}
+
+#endif /* CONFIG_RECLAIMABLE_STACK */
+
+#endif /* _LINUX_STACK_SHRINKER_H */
-- 
2.55.0.897.gb25b4bd76c-goog


