Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CD6D68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE246B0089; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203006B0096; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27266B008C; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8ADC6B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BC0BBD4E4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:38 +0000 (UTC)
X-FDA: 84230899956.22.80703B3
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 171B1180012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kyVLs7X3;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766022337; a=rsa-sha256;
	cv=none;
	b=cUtvT1TP38ZBMY6jeXZfkBMiWQfpof/Qtvc5TA7tCrkqlu2w4m//eP81EGzyGuX4yv4sRa
	4qvHbue3IzIV+3joMmDs4QGWQ32JecK7wnnHtgqZQu4AOuqApbW5IUPbR6Ijkks79wrjlt
	wsbNajyfUwzwq2qpT+qh7faYIrKHS6c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kyVLs7X3;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766022337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn0er9+p6UnCJNLLLNpxdEjMk2XaWZJQ9hmQChlIW7U=;
	b=dty5DvC5u1OKin0BRihHn1JRsVx387HT9AJbfbrhbs8ePrwF9geQ6fDNejyg0+7FTVpGnk
	D/vQnfG26bvrWZ/YoqdbefGClWN9M05aCyV1UbbmAAQxshp5ubbj58IMiVZ5oBuWZkoyT4
	hYI71vVMnvzMM7EBhcs6xGA7UG5jfR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766022336;
	bh=vn0er9+p6UnCJNLLLNpxdEjMk2XaWZJQ9hmQChlIW7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyVLs7X3rMLyjigeHhzCcNXiGVdSv7frHX/fknnCVdTKdR988PUoYGIAVrdg4ErXW
	 EhoEs8IVEsOHBSeId3DLGyKuocWqj9Y0ycUdXNOOHtkt36qU7HSk+lY+C5pL/C//zn
	 ls/5ifuj/zRSlz7F//BaFyO3s+gIWXTQHgfoo3mHfqAiP/Lwmg3XVv8WunsjPOGpg0
	 fOxr7Igt4H1GJIRfrjjYPf71uXhcj/1jU5upuUsWYw1vgn8SIOTPpYnHL0SPALBGJb
	 y0paEgsVc9Rj82Vmd2mSEmRUjCJK6cHi+A6T/H1REjHwWQYcJM/L5bimqTU0RrBk24
	 +yaDtUCrI6/1A==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dWtm01CZ6zcJy;
	Wed, 17 Dec 2025 20:45:36 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Date: Wed, 17 Dec 2025 20:45:30 -0500
Message-Id: <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 171B1180012
X-Stat-Signature: u1b3ue5qes3ryq59nquginkmik5wymhq
X-HE-Tag: 1766022336-560749
X-HE-Meta: U2FsdGVkX19/G/101/x872kvKI9V9YRQJRgI/vvOseEA+jnHDG5EynfmzzqeH2lj8VNIRX/WtQpO5xGZrRY2MFoqO/Cd5TraB2lruBiEFlmfnYTvKr1jFYagloue4WnzI9CRtas6/Bdn+zPQWr4hEQdjFjlG/piW6G9aTTpkeFpRBEdk5F+Bi0WBkV2mW9QY92Ejc37vjqdfcOI8OpICIN53sHjmaKrG1SJjA3NnxN5PTQcYVS7xn3Wic7jW2d5AKstOquCSaMIekC9tTZtBm+lyYKBFXqjRmnhxH3xZtoJ6/pmdfhcnFa6SUJ6CO8pPP8dT//iBCGnlnpANEB41tjoyWA3uJKK1mk98matgnMZtmVIEQeTM+t6RDsSHF7Hf+8JlX81ItW8xVNaLGJJQvxXdfNtpHWLJybWN1xjzTF7RUpiIh96akDFujOfQjIdeBrXu8GSljHmwxgMUszjoAgVmPfgDoIp+3d4OPEn8QMu1W/iq1aCPDHnK2BDz2A31CSaR4F+KIChPfJLzv/KPj8JTNd0KrZYUVhb4OAW95isWm07k3+I/hPAXtnYD5U7EhGSJOvXeI7/ucxlzV6ls8oyZGRQ+4LE6l8IjMDjFTY8w07aAsg+ahzhdbTk/3xdeNB0MIVa4qVJtl9nqC8/d8Oa587vEZPlleJGFPDg8bisSw3Jy451xogg7l3MhaBxa/m3zOSuApnMhRwPcl2WbAf+sKDqBaznY7cp8fNm0pVtc0D2lb1xKr5xrmLfuZP1h+4aTErhMKmJxV/ZvcSildfl3Cj22QNP9P7VewyzySb0KMb7ISNv34Nr+G2NWCOrmil+hrWrKF9dWfr9p9hriTogxgyHl+oSAW4gPJGcM4Id8DfRDNxpD9TGZA/3CixUhxS/40VfE4ESVKefn1+HFzE8dMcKy4B+ptJDkl2rSnA3UpPutkPpybuUvEr5nJ46h7t3UM75NvBMx9T4lZUL
 9ct2aFOH
 EQUAVld5JBZ5vTVkXiPwn0vVR4ebNlLKScpPK/VGMXaosrMphcS/d6A/o5PGZYsDBn5HV
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

This implementation has 8 statically allocated hazard pointer slots per
cpu for the fast path, and relies on a on-stack backup slot allocated by
the hazard pointer user as fallback in case no per-cpu slot is
available.

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
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
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
 include/linux/hazptr.h | 182 +++++++++++++++++++++++++++++++++++++++++
 init/main.c            |   2 +
 kernel/Makefile        |   2 +-
 kernel/hazptr.c        | 150 +++++++++++++++++++++++++++++++++
 4 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/hazptr.h
 create mode 100644 kernel/hazptr.c

diff --git a/include/linux/hazptr.h b/include/linux/hazptr.h
new file mode 100644
index 000000000000..70c066ddb0f5
--- /dev/null
+++ b/include/linux/hazptr.h
@@ -0,0 +1,182 @@
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
+
+/* 8 slots (each sizeof(void *)) fit in a single cache line. */
+#define NR_HAZPTR_PERCPU_SLOTS	8
+
+/*
+ * Hazard pointer slot.
+ */
+struct hazptr_slot {
+	void *addr;
+};
+
+struct hazptr_backup_slot {
+	struct list_head node;
+	struct hazptr_slot slot;
+	/* CPU requesting the backup slot. */
+	int cpu;
+};
+
+struct hazptr_ctx {
+	struct hazptr_slot *slot;
+	/* Backup slot in case all per-CPU slots are used. */
+	struct hazptr_backup_slot backup_slot;
+};
+
+struct hazptr_percpu_slots {
+	struct hazptr_slot slots[NR_HAZPTR_PERCPU_SLOTS];
+} ____cacheline_aligned;
+
+DECLARE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
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
+struct hazptr_slot *hazptr_get_free_percpu_slot(void)
+{
+	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
+	unsigned int idx;
+
+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
+		struct hazptr_slot *slot = &percpu_slots->slots[idx];
+
+		if (!READ_ONCE(slot->addr))
+			return slot;
+	}
+	/* All slots are in use. */
+	return NULL;
+}
+
+static inline
+bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
+{
+	return slot == &ctx->backup_slot.slot;
+}
+
+/*
+ * hazptr_acquire: Load pointer at address and protect with hazard pointer.
+ *
+ * Load @addr_p, and protect the loaded pointer with hazard pointer.
+ *
+ * Returns a non-NULL protected address if the loaded pointer is non-NULL.
+ * Returns NULL if the loaded pointer is NULL.
+ *
+ * On success the protected hazptr slot is stored in @ctx->slot.
+ */
+static inline
+void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
+{
+	struct hazptr_slot *slot = NULL;
+	void *addr, *addr2;
+
+	/*
+	 * Load @addr_p to know which address should be protected.
+	 */
+	addr = READ_ONCE(*addr_p);
+	for (;;) {
+		if (!addr)
+			return NULL;
+		guard(preempt)();
+		if (likely(!hazptr_slot_is_backup(ctx, slot))) {
+			slot = hazptr_get_free_percpu_slot();
+			/*
+			 * If all the per-CPU slots are already in use, fallback
+			 * to the backup slot.
+			 */
+			if (unlikely(!slot))
+				slot = hazptr_chain_backup_slot(ctx);
+		}
+		WRITE_ONCE(slot->addr, addr);	/* Store B */
+
+		/* Memory ordering: Store B before Load A. */
+		smp_mb();
+
+		/*
+		 * Re-load @addr_p after storing it to the hazard pointer slot.
+		 */
+		addr2 = READ_ONCE(*addr_p);	/* Load A */
+		if (likely(ptr_eq(addr2, addr)))
+			break;
+		/*
+		 * If @addr_p content has changed since the first load,
+		 * release the hazard pointer and try again.
+		 */
+		WRITE_ONCE(slot->addr, NULL);
+		if (!addr2) {
+			if (hazptr_slot_is_backup(ctx, slot))
+				hazptr_unchain_backup_slot(ctx);
+			return NULL;
+		}
+		addr = addr2;
+	}
+	ctx->slot = slot;
+	/*
+	 * Use addr2 loaded from the second READ_ONCE() to preserve
+	 * address dependency ordering.
+	 */
+	return addr2;
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
+	slot = ctx->slot;
+	WARN_ON_ONCE(slot->addr != addr);
+	smp_store_release(&slot->addr, NULL);
+	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
+		hazptr_unchain_backup_slot(ctx);
+}
+
+void hazptr_init(void);
+
+#endif /* _LINUX_HAZPTR_H */
diff --git a/init/main.c b/init/main.c
index 07a3116811c5..858eaa87bde7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,7 @@
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
+#include <linux/hazptr.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1002,6 +1003,7 @@ void start_kernel(void)
 	workqueue_init_early();
 
 	rcu_init();
+	hazptr_init();
 	kvfree_rcu_init();
 
 	/* Trace events are available after this */
diff --git a/kernel/Makefile b/kernel/Makefile
index 9fe722305c9b..1178907fe0ea 100644
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
index 000000000000..2ec288bc1132
--- /dev/null
+++ b/kernel/hazptr.c
@@ -0,0 +1,150 @@
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
+#include <linux/list.h>
+#include <linux/export.h>
+
+struct overflow_list {
+	raw_spinlock_t lock;		/* Lock protecting overflow list and list generation. */
+	struct list_head head;		/* Overflow list head. */
+	uint64_t gen;			/* Overflow list generation. */
+};
+
+static DEFINE_PER_CPU(struct overflow_list, percpu_overflow_list);
+
+DEFINE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
+EXPORT_PER_CPU_SYMBOL_GPL(hazptr_percpu_slots);
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
+void hazptr_synchronize_overflow_list(struct overflow_list *overflow_list, void *addr)
+{
+	struct hazptr_backup_slot *backup_slot;
+	uint64_t snapshot_gen;
+
+	raw_spin_lock(&overflow_list->lock);
+retry:
+	snapshot_gen = overflow_list->gen;
+	list_for_each_entry(backup_slot, &overflow_list->head, node) {
+		/* Busy-wait if node is found. */
+		while (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
+			raw_spin_unlock(&overflow_list->lock);
+			cpu_relax();
+			raw_spin_lock(&overflow_list->lock);
+			if (overflow_list->gen != snapshot_gen)
+				goto retry;
+		}
+		raw_spin_unlock(&overflow_list->lock);
+		/*
+		 * Release raw spinlock, validate generation after
+		 * re-acquiring the lock.
+		 */
+		raw_spin_lock(&overflow_list->lock);
+		if (overflow_list->gen != snapshot_gen)
+			goto retry;
+	}
+	raw_spin_unlock(&overflow_list->lock);
+}
+
+static
+void hazptr_synchronize_cpu_slots(int cpu, void *addr)
+{
+	struct hazptr_percpu_slots *percpu_slots = per_cpu_ptr(&hazptr_percpu_slots, cpu);
+	unsigned int idx;
+
+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
+		struct hazptr_slot *slot = &percpu_slots->slots[idx];
+
+		/* Busy-wait if node is found. */
+		smp_cond_load_acquire(&slot->addr, VAL != addr); /* Load B */
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
+		/* Scan CPU slots. */
+		hazptr_synchronize_cpu_slots(cpu, addr);
+		/* Scan backup slots in percpu overflow list. */
+		hazptr_synchronize_overflow_list(per_cpu_ptr(&percpu_overflow_list, cpu), addr);
+	}
+}
+EXPORT_SYMBOL_GPL(hazptr_synchronize);
+
+struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx)
+{
+	struct overflow_list *overflow_list = this_cpu_ptr(&percpu_overflow_list);
+	struct hazptr_slot *slot = &ctx->backup_slot.slot;
+
+	slot->addr = NULL;
+
+	raw_spin_lock(&overflow_list->lock);
+	overflow_list->gen++;
+	list_add(&ctx->backup_slot.node, &overflow_list->head);
+	ctx->backup_slot.cpu = smp_processor_id();
+	raw_spin_unlock(&overflow_list->lock);
+	return slot;
+}
+EXPORT_SYMBOL_GPL(hazptr_chain_backup_slot);
+
+void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx)
+{
+	struct overflow_list *overflow_list = per_cpu_ptr(&percpu_overflow_list, ctx->backup_slot.cpu);
+
+	raw_spin_lock(&overflow_list->lock);
+	overflow_list->gen++;
+	list_del(&ctx->backup_slot.node);
+	raw_spin_unlock(&overflow_list->lock);
+}
+EXPORT_SYMBOL_GPL(hazptr_unchain_backup_slot);
+
+void __init hazptr_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct overflow_list *overflow_list = per_cpu_ptr(&percpu_overflow_list, cpu);
+
+		raw_spin_lock_init(&overflow_list->lock);
+		INIT_LIST_HEAD(&overflow_list->head);
+	}
+}
-- 
2.39.5


