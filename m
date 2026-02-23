Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A447EC1136
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8392B6B0089; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812DA6B0092; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6886D6B0095; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4652D6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8773B8024
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:23 +0000 (UTC)
X-FDA: 84476899206.02.DB59B9A
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19197140007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FKGyEXy8;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771879462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw/it6bAj2xPEmK7LaoGCfd2HEFZ8Ovptdjqm5QWOYw=;
	b=SO/Lq/ZBYonmnLFscUZ7tnOMfvi1vWXe4d+trJ2W7JIQjwsubd1A9YvSHRPT2xsH2BbLgX
	+QJklUgPrOt1N2urq17iDXBqDo9N5zBAnFabrKQTYWkL5BJt0Hu1h9xfFI+90CMMxH5qI5
	rwCLiz9ESqzSbsWUJpHQJ/68l4BcBz4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FKGyEXy8;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771879462; a=rsa-sha256;
	cv=none;
	b=CZXz4q9Ub+VmlArrNQtf2IsNpNUkbfbTWyTxLRS3wkkJcfwjQFHAGd+l0hYyh7qugPn+pI
	UjAr/KWIKuUIfd0SmknBO833X246jPSp5gqSu0QIliUxmCCO/ExaT96r8qd12suHNVIMCN
	//TDB0HgcuaAr9hTFCRePsbH5MfVS48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1771879461;
	bh=Lw/it6bAj2xPEmK7LaoGCfd2HEFZ8Ovptdjqm5QWOYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKGyEXy8cbRi4rQnl742qSEHLniHCHzIS3i9hpVLVlJSSj8GbML5iTBoeQqBrQvjh
	 QWPqEtkmbm2UAYWyTk4Cb4JBUEAd3gw2Lz+xamF25/FGINu1zrMOC5wFIYR9+Qcbo3
	 TrFRxXfj9w3CsQ3RZsy80ZpAn2uy2enj7MTeOVz76u4PxnLuumRKS1YxZj2v1aKSJ/
	 dlPwTrWiq40IOnuHvcJLUv9S5/vN+ZjN8Z3yrwZUtlQCK0uftiKwgoC73OKcVX21bC
	 gFSpTaEsNjErL3btCpmbW0AvjiHiMi4GR+R5mVvEfIvIJgJFm2DqrvMVGMnfogFDwW
	 Ckg3qmuj2l18Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fKXs11dcBzHyw;
	Mon, 23 Feb 2026 15:44:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev
Subject: [RFC PATCH v5 1/2] hazptr: Implement Hazard Pointers
Date: Mon, 23 Feb 2026 15:44:17 -0500
Message-Id: <20260223204418.1429025-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260223204418.1429025-1-mathieu.desnoyers@efficios.com>
References: <20260223204418.1429025-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nyjggny5abwi4nd4stijntd5ejmbusb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 19197140007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771879461-360134
X-HE-Meta: U2FsdGVkX19DsUAuoxOm2FvDiZMenXuYQUtBaF+Zq4iu+Lun/Lfv3VFHLh+Ob63a6OZiyrKEi4JhqPXk3njaUy6mKAVG7UtvOJ/H+ctxJRATF0JCsICSNZGcV4OFSMnJL0SM43UQKGCz/yYWvsR5TCxiUT+8xNX0Y+hnopF10hNrLVx+yJi0BEeecfeK/bv7xdSKK0RueIvtd3MCUwrD6IPWwaczXR0rBwHIisqM1PjwrPuHOcteDNM/KxuQzgfmrYlzvwkWNK93hJkaWsYCPRYLv49kImvrnND5BbDrb6SlzB6yCeLt4UVnBK07YltMyY176yOsXOqAX9uLyiRBEky+fbv6A6lpioFkTYae4mR3onYnU0rdKJlkrt1UpT/HBFw1h1LI88uNB9Hn6YxoZkazrGRYLIHeSIEuXPr0xQamVjWdODQ1gzD/6IZkkCvb2Y3rDl9+884n96j8AVoYPISMW+ioCEk0ZvcZvTWNayKTxrZtezBGUFE1JtYKtLK3KM/VtOSyRWuLgVA+N4YPS1SGp75XC+cSVK6z/2pXTEtHWm1bWGcBCZ3rmuf2Zm7uBjK0G8SvJMH6/wIDMWjPtj1oiOwmdGo5myiLeC6PB5RHGF4sN861gMs1Q8euZt9HzjPElzMhibYJNOb2yXAcUejntqDzFzmAjRQM06i0Ky6DpNrJtHUNVQ30RpZeHv8mUA7fuqV5XdEV3h/NlTb37dELoYnnbaWwnWLWKKRVC3/SMQXOvYbWbNUhBO5JfaRUcv49VBl9Kp6dAK6wNx5DATjHM3qbXPS1c+uu5b/Tv6bDNz1xXvVQSPSsbQZQ3pFm+tODKV5cBLqENNEvhGFBc/l7l301BJGMP0OS+RqJ5Ih0lK1HSxFsHQSA0QlD6sRMLEQuFwhScARXrJP6t50t3otsvP0VjHCR2YWavwTHD3LA0QmXyxuMCh/I1D+E162EjP2gemLr62hvVwW6VBK
 PHUfTI8u
 lT2KCexi8QomNmbCvI4VVxZt/aPfNBAt1QZMIxcUGQUsvaHSVvyMBDY3C0xvidtqf+/InC7VWIcMvEpIkCwZPgwD03ap3fzwGd06I3uJodrLos9eRao+aFRztrgtSfSVZVcuWaNESRrdUjcQBm5zxFZhim3/Nz40niVEPsXnR6zeyCGaEz8HyQQ2uv2XY4kjVJmxpPoS3+MYxUW1jRssI59qpgXnEiMrPAVjTwemIi1ChDFx5vm/ANxl6/bkSQLkCpTmIJBRqUmxwMP5GMk2/3GUlnD1/h7A7vstgIM5IcN2UDBmM+GKtH5zmGH6xmVQfiWE1mChjntGUSqUhBuPZFFfgLQP8cCt7fBpccda4EhYzYO6DIc61Lx3rgn8PW6MNs5xfAQKoabsk87y51JGzWVUCTggGKPQPWZCrrSTeRz4/VWVC4nvG0SRyNKjdd35Yuhp5xBN/X/+wz5P3EG1iBQ4bWbznuE5sRuCJFjN9MS/AK2IzlLksJxGAgXymuMivkzVIMqODSovCqWZqVJv/dmes2uawrJ26ovJgmUm9ghivQO+vaRqDlfHxBYlNzr4iSIFLlxXhc4MuM6pSw5ct87G1ia+cts3zK5BFb9nmTddjlnhJF5kIoSPCRY9GtAqrUQifZjHCCkS0LFdHJkne1JIHLzPjlgdVgBicDBtHxm4ATeQUgNjXmLftIDGAHh3FdRBWGukpGznBJCqV7wyvQaKQYOYHsUtmeiO2m4E/i1/2fwr7NntU90bWAT6ue7md8kSr20RiOxYFnqL4hEA/98dgZwKjEmc6J6nM9Ko23vIJyTZ4RsMcSsE633Ja37jA8L1X6MeY/9Fv5LwZWfLeB2TJzz3Td4RxO8o5z0UPU6i3GZx3cegyUrBejYplJLds68dv9tqUyAMw2URlfWtEvJC4samtdVOtXX2ycv4fHUW4o9KSfN3hjeFOFdZGtk0t0VkMlbuotaaCFm5D089MhdAbJQGJ
 5aqTZ/AN
 Qpa3sKmhOPsLC9dnXw/pJh9KkrlTPIk3oK1Fhxk5BWmjr2xJbg4ydieArFV13FJi59ihKzHElcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This API provides existence guarantees of objects through Hazard
Pointers [1] (hazptr).

Its main benefit over RCU is that it allows fast reclaim of
HP-protected pointers without needing to wait for a grace period.

This implementation has 4 statically allocated hazard pointer slots per
cpu for the fast path, and relies on a on-stack backup slot allocated by
the hazard pointer user as fallback in case no per-cpu slot is
available.

It integrates with the scheduler to migrate per-CPU slots to the backup
slot on context switch. This ensures that the per-CPU slots won't be
used by blocked or preempted tasks holding on hazard pointers for a long
time.

References:

[1]: M. M. Michael, "Hazard pointers: safe memory reclamation for
     lock-free objects," in IEEE Transactions on Parallel and
     Distributed Systems, vol. 15, no. 6, pp. 491-504, June 2004

Link: https://lpc.events/event/19/contributions/2082/
Link: https://lore.kernel.org/lkml/j3scdl5iymjlxavomgc6u5ndg3svhab6ga23dr36o4f5mt333w@7xslvq6b6hmv/
Link: https://lpc.events/event/18/contributions/1731/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: maged.michael@gmail.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
---
Changes since v4:
- Fold scheduler integration.
- Actually set ctx slot to backup slot on context switch.
- Remove CONFIG_PREEMPT_HAZPTR config option.
- Use per-cpu ctx pointers for context switch slot tracking
  rather than per-task lists. This accelerates the hazptr
  acquire/release fast-path.
- Guarantee scan forward progress with two-lists scheme.
- Reimplement the hazptr acquire with a temporary wildcard
  to eliminate a dependency on the addr_p load, likely to
  cause a pipeline stall due to the needed memory barrier.
  This simplifies the algorithm, removes the need for pointer
  re-load + comparison, and is expected to be faster on some
  architectures.
- Reduce number of percpu slots to 4, introduce a hazptr_slot_item
  struct to contain both the slot and ctx pointers. Reducing number
  of slots to 4 makes sure all the slot and ctx pointers fit in a
  single cache line.
- Rebased on v7.0-rc1.

Changes since v3:
- Rename hazptr_retire to hazptr_release.
- Remove domains.
- Introduce "backup_slot" within hazptr context structure (on stack)
  to handle slot overflow.
- Rename hazptr_try_protect to hazptr_acquire.
- Preallocate 8 per-CPU slots, and rely on caller-provided backup
  slots (typically on stack) for out-of-slots situations.

Changes since v2:
- Address Peter Zijlstra's comments.
- Address Paul E. McKenney's comments.

Changes since v0:
- Remove slot variable from hp_dereference_allocate().
---
 include/linux/hazptr.h | 197 +++++++++++++++++++++++++++++++++
 init/main.c            |   2 +
 kernel/Makefile        |   2 +-
 kernel/hazptr.c        | 242 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c    |   2 +
 5 files changed, 444 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/hazptr.h
 create mode 100644 kernel/hazptr.c

diff --git a/include/linux/hazptr.h b/include/linux/hazptr.h
new file mode 100644
index 000000000000..461f481a480b
--- /dev/null
+++ b/include/linux/hazptr.h
@@ -0,0 +1,197 @@
+// SPDX-FileCopyrightText: 2024 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+//
+// SPDX-License-Identifier: LGPL-2.1-or-later
+
+#ifndef _LINUX_HAZPTR_H
+#define _LINUX_HAZPTR_H
+
+/*
+ * hazptr: Hazard Pointers
+ *
+ * This API provides existence guarantees of objects through hazard
+ * pointers.
+ *
+ * Its main benefit over RCU is that it allows fast reclaim of
+ * HP-protected pointers without needing to wait for a grace period.
+ *
+ * References:
+ *
+ * [1]: M. M. Michael, "Hazard pointers: safe memory reclamation for
+ *      lock-free objects," in IEEE Transactions on Parallel and
+ *      Distributed Systems, vol. 15, no. 6, pp. 491-504, June 2004
+ */
+
+#include <linux/percpu.h>
+#include <linux/types.h>
+#include <linux/cleanup.h>
+#include <linux/sched.h>
+
+/* 4 slots (each sizeof(hazptr_slot_item)) fit in a single 64-byte cache line. */
+#define NR_HAZPTR_PERCPU_SLOTS	4
+#define HAZPTR_WILDCARD		((void *) 0x1UL)
+
+/*
+ * Hazard pointer slot.
+ */
+struct hazptr_slot {
+	void *addr;
+};
+
+struct hazptr_overflow_list;
+
+struct hazptr_backup_slot {
+	struct hlist_node overflow_node;
+	struct hazptr_slot slot;
+	/* Overflow list where the backup slot is added. */
+	struct hazptr_overflow_list *overflow_list;
+};
+
+struct hazptr_ctx {
+	struct hazptr_slot *slot;
+	/* Backup slot in case all per-CPU slots are used. */
+	struct hazptr_backup_slot backup_slot;
+	struct hlist_node preempt_node;
+};
+
+struct hazptr_slot_ctx {
+	struct hazptr_ctx *ctx;
+};
+
+struct hazptr_slot_item {
+	struct hazptr_slot slot;
+	struct hazptr_slot_ctx ctx;
+};
+
+struct hazptr_percpu_slots {
+	struct hazptr_slot_item items[NR_HAZPTR_PERCPU_SLOTS];
+} ____cacheline_aligned;
+
+DECLARE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
+
+void *__hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p);
+
+/*
+ * hazptr_synchronize: Wait until @addr is released from all slots.
+ *
+ * Wait to observe that each slot contains a value that differs from
+ * @addr before returning.
+ * Should be called from preemptible context.
+ */
+void hazptr_synchronize(void *addr);
+
+/*
+ * hazptr_chain_backup_slot: Chain backup slot into overflow list.
+ *
+ * Set backup slot address to @addr, and chain it into the overflow
+ * list.
+ */
+struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx);
+
+/*
+ * hazptr_unchain_backup_slot: Unchain backup slot from overflow list.
+ */
+void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx);
+
+static inline
+bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
+{
+	return slot == &ctx->backup_slot.slot;
+}
+
+static inline
+void hazptr_note_context_switch(void)
+{
+	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
+	unsigned int idx;
+
+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
+		struct hazptr_slot *slot = &item->slot, *backup_slot;
+		struct hazptr_ctx *ctx;
+
+		if (!slot->addr)
+			continue;
+		ctx = item->ctx.ctx;
+		backup_slot = hazptr_chain_backup_slot(ctx);
+		/*
+		 * Move hazard pointer from the per-CPU slot to the
+		 * backup slot. This requires hazard pointer
+		 * synchronize to iterate on per-CPU slots with
+		 * load-acquire before iterating on the overflow list.
+		 */
+		WRITE_ONCE(backup_slot->addr, slot->addr);
+		/*
+		 * store-release orders store to backup slot addr before
+		 * store to per-CPU slot addr.
+		 */
+		smp_store_release(&slot->addr, NULL);
+		/* Use the backup slot for context. */
+		ctx->slot = backup_slot;
+	}
+}
+
+/*
+ * hazptr_acquire: Load pointer at address and protect with hazard pointer.
+ *
+ * Load @addr_p, and protect the loaded pointer with hazard pointer.
+ * When using hazptr_acquire from interrupt handlers, the acquired slots
+ * need to be released before returning from the interrupt handler.
+ *
+ * Returns a non-NULL protected address if the loaded pointer is non-NULL.
+ * Returns NULL if the loaded pointer is NULL.
+ *
+ * On success the protected hazptr slot is stored in @ctx->slot.
+ */
+static inline
+void *hazptr_acquire(struct hazptr_ctx *ctx, void * const *addr_p)
+{
+	struct hazptr_percpu_slots *percpu_slots;
+	struct hazptr_slot_item *slot_item;
+	struct hazptr_slot *slot;
+	void *addr;
+
+	guard(preempt)();
+	percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
+	slot_item = &percpu_slots->items[0];
+	slot = &slot_item->slot;
+	if (unlikely(slot->addr))
+		return __hazptr_acquire(ctx, addr_p);
+	WRITE_ONCE(slot->addr, HAZPTR_WILDCARD);	/* Store B */
+
+	/* Memory ordering: Store B before Load A. */
+	smp_mb();
+
+	/*
+	 * Load @addr_p after storing wildcard to the hazard pointer slot.
+	 */
+	addr = READ_ONCE(*addr_p);	/* Load A */
+
+	/*
+	 * We don't care about ordering of Store C. It will simply
+	 * replace the wildcard by a more specific address. If addr is
+	 * NULL, we simply store NULL into the slot.
+	 */
+	WRITE_ONCE(slot->addr, addr);	/* Store C */
+	slot_item->ctx.ctx = ctx;
+	ctx->slot = slot;
+	return addr;
+}
+
+/* Release the protected hazard pointer from @slot. */
+static inline
+void hazptr_release(struct hazptr_ctx *ctx, void *addr)
+{
+	struct hazptr_slot *slot;
+
+	if (!addr)
+		return;
+	guard(preempt)();
+	slot = ctx->slot;
+	smp_store_release(&slot->addr, NULL);
+	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
+		hazptr_unchain_backup_slot(ctx);
+}
+
+void hazptr_init(void);
+
+#endif /* _LINUX_HAZPTR_H */
diff --git a/init/main.c b/init/main.c
index 1cb395dd94e4..b66017629935 100644
--- a/init/main.c
+++ b/init/main.c
@@ -105,6 +105,7 @@
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
 #include <linux/unaligned.h>
+#include <linux/hazptr.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1101,6 +1102,7 @@ void start_kernel(void)
 	workqueue_init_early();
 
 	rcu_init();
+	hazptr_init();
 	kvfree_rcu_init();
 
 	/* Trace events are available after this */
diff --git a/kernel/Makefile b/kernel/Makefile
index 6785982013dc..b7cef6e23038 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    cpu.o exit.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o user.o \
 	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
-	    extable.o params.o \
+	    extable.o params.o hazptr.o \
 	    kthread.o sys_ni.o nsproxy.o nstree.o nscommon.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o
diff --git a/kernel/hazptr.c b/kernel/hazptr.c
new file mode 100644
index 000000000000..a63ac681cb85
--- /dev/null
+++ b/kernel/hazptr.c
@@ -0,0 +1,242 @@
+// SPDX-FileCopyrightText: 2024 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+//
+// SPDX-License-Identifier: LGPL-2.1-or-later
+
+/*
+ * hazptr: Hazard Pointers
+ */
+
+#include <linux/hazptr.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/export.h>
+
+struct hazptr_overflow_list {
+	raw_spinlock_t lock;		/* Lock protecting overflow list and list generation. */
+	struct hlist_head head;		/* Overflow list head. */
+	uint64_t gen;			/* Overflow list generation. */
+};
+
+/*
+ * Flip between two lists to guarantee list scan forward progress even
+ * with frequent generation counter increments. The list additions are
+ * always done on a different list than the one used for scan. The scan
+ * successively iterates on both lists. Therefore, only list removals
+ * can cause the iteration to retry, and the number of removals is
+ * limited to the number of list elements.
+ */
+struct hazptr_overflow_list_flip {
+	struct mutex lock;		/* Mutex protecting add_idx from concurrent updates. */
+	unsigned int add_idx;		/* Index of current flip-list to add to. */
+	struct hazptr_overflow_list array[2];
+};
+
+static DEFINE_PER_CPU(struct hazptr_overflow_list_flip, percpu_overflow_list_flip);
+
+DEFINE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
+EXPORT_PER_CPU_SYMBOL_GPL(hazptr_percpu_slots);
+
+static
+struct hazptr_slot *hazptr_get_free_percpu_slot(struct hazptr_ctx *ctx)
+{
+	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
+	unsigned int idx;
+
+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
+		struct hazptr_slot *slot = &item->slot;
+
+		if (!slot->addr) {
+			item->ctx.ctx = ctx;
+			return slot;
+		}
+	}
+	/* All slots are in use. */
+	return NULL;
+}
+
+/*
+ * Hazard pointer acquire slow path.
+ * Called with preemption disabled.
+ */
+void *__hazptr_acquire(struct hazptr_ctx *ctx, void * const *addr_p)
+{
+	struct hazptr_slot *slot = hazptr_get_free_percpu_slot(ctx);
+	void *addr;
+
+	/*
+	 * If all the per-CPU slots are already in use, fallback
+	 * to the backup slot.
+	 */
+	if (unlikely(!slot))
+		slot = hazptr_chain_backup_slot(ctx);
+	WRITE_ONCE(slot->addr, HAZPTR_WILDCARD);	/* Store B */
+
+	/* Memory ordering: Store B before Load A. */
+	smp_mb();
+
+	/*
+	 * Load @addr_p after storing wildcard to the hazard pointer slot.
+	 */
+	addr = READ_ONCE(*addr_p);	/* Load A */
+
+	/*
+	 * We don't care about ordering of Store C. It will simply
+	 * replace the wildcard by a more specific address. If addr is
+	 * NULL, we simply store NULL into the slot.
+	 */
+	WRITE_ONCE(slot->addr, addr);	/* Store C */
+	ctx->slot = slot;
+	if (!addr && hazptr_slot_is_backup(ctx, slot))
+		hazptr_unchain_backup_slot(ctx);
+	return addr;
+}
+EXPORT_SYMBOL_GPL(__hazptr_acquire);
+
+/*
+ * Perform piecewise iteration on overflow list waiting until "addr" is
+ * not present. Raw spinlock is released and taken between each list
+ * item and busy loop iteration. The overflow list generation is checked
+ * each time the lock is taken to validate that the list has not changed
+ * before resuming iteration or busy wait. If the generation has
+ * changed, retry the entire list traversal.
+ */
+static
+void hazptr_synchronize_overflow_list(struct hazptr_overflow_list *overflow_list, void *addr)
+{
+	struct hazptr_backup_slot *backup_slot;
+	uint64_t snapshot_gen;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&overflow_list->lock, flags);
+retry:
+	snapshot_gen = overflow_list->gen;
+	hlist_for_each_entry(backup_slot, &overflow_list->head, overflow_node) {
+		/* Busy-wait if node is found. */
+		for (;;) {
+			void *load_addr = smp_load_acquire(&backup_slot->slot.addr);	/* Load B */
+
+			if (load_addr != addr && load_addr != HAZPTR_WILDCARD)
+				break;
+			raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
+			cpu_relax();
+			raw_spin_lock_irqsave(&overflow_list->lock, flags);
+			if (overflow_list->gen != snapshot_gen)
+				goto retry;
+		}
+		raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
+		/*
+		 * Release raw spinlock, validate generation after
+		 * re-acquiring the lock.
+		 */
+		raw_spin_lock_irqsave(&overflow_list->lock, flags);
+		if (overflow_list->gen != snapshot_gen)
+			goto retry;
+	}
+	raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
+}
+
+static
+void hazptr_synchronize_cpu_slots(int cpu, void *addr)
+{
+	struct hazptr_percpu_slots *percpu_slots = per_cpu_ptr(&hazptr_percpu_slots, cpu);
+	unsigned int idx;
+
+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
+
+		/* Busy-wait if node is found. */
+		smp_cond_load_acquire(&item->slot.addr, VAL != addr && VAL != HAZPTR_WILDCARD); /* Load B */
+	}
+}
+
+/*
+ * hazptr_synchronize: Wait until @addr is released from all slots.
+ *
+ * Wait to observe that each slot contains a value that differs from
+ * @addr before returning.
+ * Should be called from preemptible context.
+ */
+void hazptr_synchronize(void *addr)
+{
+	int cpu;
+
+	/*
+	 * Busy-wait should only be done from preemptible context.
+	 */
+	lockdep_assert_preemption_enabled();
+
+	/*
+	 * Store A precedes hazptr_scan(): it unpublishes addr (sets it to
+	 * NULL or to a different value), and thus hides it from hazard
+	 * pointer readers.
+	 */
+	if (!addr)
+		return;
+	/* Memory ordering: Store A before Load B. */
+	smp_mb();
+	/* Scan all CPUs slots. */
+	for_each_possible_cpu(cpu) {
+		struct hazptr_overflow_list_flip *overflow_list_flip = per_cpu_ptr(&percpu_overflow_list_flip, cpu);
+		unsigned int scan_idx;
+
+		/* Scan CPU slots. */
+		hazptr_synchronize_cpu_slots(cpu, addr);
+
+		/*
+		 * Scan backup slots in percpu overflow lists.
+		 * Forward progress is guaranteed by scanning one list
+		 * while new elements are added into the other list.
+		 */
+		guard(mutex)(&overflow_list_flip->lock);
+		scan_idx = overflow_list_flip->add_idx ^ 1;
+		hazptr_synchronize_overflow_list(&overflow_list_flip->array[scan_idx], addr);
+		/* Flip current list. */
+		WRITE_ONCE(overflow_list_flip->add_idx, scan_idx);
+		hazptr_synchronize_overflow_list(&overflow_list_flip->array[scan_idx ^ 1], addr);
+	}
+}
+EXPORT_SYMBOL_GPL(hazptr_synchronize);
+
+struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx)
+{
+	struct hazptr_overflow_list_flip *overflow_list_flip = this_cpu_ptr(&percpu_overflow_list_flip);
+	unsigned int list_idx = READ_ONCE(overflow_list_flip->add_idx);
+	struct hazptr_overflow_list *overflow_list = &overflow_list_flip->array[list_idx];
+	struct hazptr_slot *slot = &ctx->backup_slot.slot;
+
+	slot->addr = NULL;
+	guard(raw_spinlock_irqsave)(&overflow_list->lock);
+	overflow_list->gen++;
+	hlist_add_head(&ctx->backup_slot.overflow_node, &overflow_list->head);
+	ctx->backup_slot.overflow_list = overflow_list;
+	return slot;
+}
+EXPORT_SYMBOL_GPL(hazptr_chain_backup_slot);
+
+void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx)
+{
+	struct hazptr_overflow_list *overflow_list = ctx->backup_slot.overflow_list;
+
+	guard(raw_spinlock_irqsave)(&overflow_list->lock);
+	overflow_list->gen++;
+	hlist_del(&ctx->backup_slot.overflow_node);
+}
+EXPORT_SYMBOL_GPL(hazptr_unchain_backup_slot);
+
+void __init hazptr_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct hazptr_overflow_list_flip *overflow_list_flip = per_cpu_ptr(&percpu_overflow_list_flip, cpu);
+
+		mutex_init(&overflow_list_flip->lock);
+		for (int i = 0; i < 2; i++) {
+			raw_spin_lock_init(&overflow_list_flip->array[i].lock);
+			INIT_HLIST_HEAD(&overflow_list_flip->array[i].head);
+		}
+	}
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 759777694c78..b3e10be20329 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -60,6 +60,7 @@
 #include <linux/profile.h>
 #include <linux/psi.h>
 #include <linux/rcuwait_api.h>
+#include <linux/hazptr.h>
 #include <linux/rseq.h>
 #include <linux/sched/wake_q.h>
 #include <linux/scs.h>
@@ -6790,6 +6791,7 @@ static void __sched notrace __schedule(int sched_mode)
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
 	migrate_disable_switch(rq, prev);
+	hazptr_note_context_switch();
 
 	/*
 	 * Make sure that signal_pending_state()->signal_pending() below
-- 
2.39.5


