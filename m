Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F1AD68BCA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55ADB6B008C; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C70A6B0093; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F0F6B0095; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF1C6B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D10FE60DCE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:38 +0000 (UTC)
X-FDA: 84230899956.21.CD269AB
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44392180008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=tQgevJyi;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766022337; a=rsa-sha256;
	cv=none;
	b=pY+STbct+PO0YTrVDOAoiIacl2lC9WdR+fssP8EiA1JPKzsK7KtHpzjqKkVIgTCYqSJTG9
	pZpDWtnCt0NfUTZ5K0QxQa/R8ELwA0Je6WlnKx3GIMsKJPAr5qFGWoaYNADyDvdqqlwysx
	22HcqCEVwi9XGDuTK9+/gWB5NaQGZvg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=tQgevJyi;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766022337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mSE4uUm9QS4jRnuJO07Nb3CIxXoe5LmkyYDXf5sG1E=;
	b=5nJH/cX2c7KwJ0ns1qw25wQhr7o6xLdCDkcd41ulVEsc8XJ7W482L1kiYO+p2hIAkcjszw
	fyFLE7+iZ4mQKQsj1TiRGpTdi/ONkLYQzQrUM0iO3nY52wUtHlyKZJkRLjp8gTQzIzTiAj
	VxBEZW+exTixcQvM3df8MS5QgYDYudI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766022336;
	bh=9mSE4uUm9QS4jRnuJO07Nb3CIxXoe5LmkyYDXf5sG1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQgevJyisveTrRgflVsn9F23xBqLaYd8su86QGOgWYc6y/bPRR+jBhxTqD1xk01EZ
	 VDGPvvdDHa1jH6Oq0H+tHvVCeNOShHKxLjIKrs/4IkJfyDqYnhJuw392PD9liZvDXj
	 1l3JcSKa2qwXp4rt8G4UMSD9fiqPjjovHiCB3ZoZBKlGFTAzqOkvw0WkNJIAxUaU9+
	 rTfJ9pwLZ0/DjK9V/7zvdyfdieMFaOZykf8/vfEWMfYmYyodmUhFf0Ac1+N91+KkeS
	 6ZPIAutnM/M7RMO6Sl9HJiKarwuPRUINiT20os+vZaPTjifTJFVozsXoeCVHoLWm8F
	 4Cym1xOrXmnqA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dWtm03TRdzbqP;
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
Subject: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot on context switch
Date: Wed, 17 Dec 2025 20:45:31 -0500
Message-Id: <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44392180008
X-Rspamd-Server: rspam04
X-Stat-Signature: gkmka8sok5bc7id4q6bcjb1hxzk68oja
X-HE-Tag: 1766022337-810076
X-HE-Meta: U2FsdGVkX1983gXGxjrMnwiQagxgLEnxb3PU5VbnZC7CVhXpWJxBOtGdOKWJAcT5hSu17tajt8qMB7RvOpheqk7xTQDq25434rRXXYVcq4ArGgIIyg75BVWcWhNxNMZ0v/8HyZDY5VK0Lu9ONQHug8aiEJhS/fEC5nh77CK0evwhcIJdbxFZQaSVn2+vdltEzQOt5IH7pzHS3Ac5bBwJmJqEos4qGd2ei/nZ8zU+2BDQI+XJbZAXFGTUiypFuuO5DAppxEOY6Em1fRFZPrs4SJNiC53Z0DbDMFam073rE82Qnp2tKyzUkj4ubACPWl9wi7zLmDROjsdEcgWHms4UFwPb84qVYyK7qqJ5yzGVOl2G6X0C+HybiD8JwUrV+t+3yPNK3C0VCstnmdegb9//7f1rT+4gCtRsPa2wJ3QwshNCLPBkfTrjN9j6K4U5TPzA+rCZT/R2rdrIXf81XjSs0ZUtdfEUWpjyMSaCEBKE3DgNMuUlZI5yqtzf/VwgL1iOcNC54hxgGASef/35EcBqk2OWhQeWhhwpjgnXhSMjgyEWfCcH+4b4vDYearwT9ch9LswIscxrrYgvXXSQSmkuMpwbcFO55QxH2I8M5EZ2aitiiEk3fdn79bayYwN39kVv0imQGIfzyoeiqCy8f/ph4P1gXOIu8aAPs6h9hXM8mpyGrhDcJnGBn4YgydXqj/3jjL5rzT7lpMgxl50LFoOhR4b2Y5foOP8IpsJAH+gMpW4VgmCd6uDhn+lXh8yTZSmMXvEXVFrFgBqjNX4uGdHXk8vkAf6mbJYJ/JN/0UND3CBadymtSma7AGVZGZ0zZxYYrccNgy91cU+hax2cdJys60h9SjwCbm8MMCK28hZC3Pv2wVXCtTOznEkbR19eXyrLZsl5UfkqVc2YJVI2+sKKnH21V30z5lrREp26OFt6lbNjtE3OBA05gu0hXvnsXpGQYtOWjoCURfPBX37Gdjq
 0WlnmV6u
 LszUG6Q2ItN1wVi+8A/sqSxWxRjnzDVccCSIidTH8lkcHtALbZNgq3XJDCxXcRCLvbWy3vLR0x4A9ZVPccSw+40+YaYure+xUGJHPRj1uj+d1h0DXXEh2owjtrHX4gMwsD4lJ0u1tP+49Glri4ZrzCZgMs1avtmDidLBnU0ndqUjH4wHMwQtDZulUw+PVd8Oszesfy9dbSQ709KhVxf1exaKRql/jDKEFEMvJ9KBeUZlV+d6gcJ7eLm3rL6hapC/1zGjxU3VKPc//kgiTC/59gmHa3y7UBJF+DLb4tbWyvwagLpCf1sW4i/w6XsLRrF5w3KDda1prfGgWAmFnPv+CpeuucmPujsZbkyfR1MW2TiRN1bZu4h6SWE0JORHSJOBoJF7QtGlVzlqpdoDph5uncNn0GKYE+jr2Un9as5zZrTBzUwnGuhhoDd1wnMbZNS768WKYTLhonGToXr3S8vE64BRsZpxut7p/c6IyT1IkHQE8G8xcyl3cko4b7TK4L/THB3ERhLZxWse3Wf3U/cAObmMJf52W2fEHTxE5y6uoCiKjHs0zGdFstbHD2/rpcM691SfIpcgtHPXZ5GPmgq+R/dSE+8ISQ34hudQ23aoGgwwQTYrVaAWxlcQDbFqL+NVZj32/c9heWrRa+E79TyT2DeKyY9d54GEF/P8zh2MgmWKUDB+qf7H+YRl+YE2jFqh2zKSklqfKyJfFFCR+TXBSHQCDi0Vx6hZj5sbZw3x0GvFppZ0zGJD69VRlzbyfguXvUY64bre85WSHSb4XfnnX0kEeUnykgCZfbta2q6bsZllSZdbH5kUp/gaCrFEIDvt/Ri50A6Pb6Wc4QfaHxqtjD4UqGS5KQA0rAOka+QWiPxPHojxrTXj4ykSmSlLA+ZKPmI2v+CCZcWRITrU6gy4/BpaItGsxDSJjiPmBV9Mc/owRalQm9q/hWbeq+r/gJujgBsXvq4NCX3CrJ2Rsrv0EPf+qvbGJ
 d2g5uRjT
 ORBS3Ijg3alNlCn1D5C2fCSq11b3ZjRnaY8y1CJzByqkQ9BzZre/+yQ01hWMHeGS44DF0aJlBKS1t2b4+WZVu2wtsqu7wQ8W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate with the scheduler to migrate per-CPU slots to the backup slot
on context switch. This ensures that the per-CPU slots won't be used by
blocked or preempted tasks holding on hazard pointers for a long time.

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
 include/linux/hazptr.h | 63 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/sched.h  |  4 +++
 init/init_task.c       |  3 ++
 kernel/Kconfig.preempt | 10 +++++++
 kernel/fork.c          |  3 ++
 kernel/sched/core.c    |  2 ++
 6 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/hazptr.h b/include/linux/hazptr.h
index 70c066ddb0f5..10ac53a42a7a 100644
--- a/include/linux/hazptr.h
+++ b/include/linux/hazptr.h
@@ -24,6 +24,7 @@
 #include <linux/percpu.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched.h>
 
 /* 8 slots (each sizeof(void *)) fit in a single cache line. */
 #define NR_HAZPTR_PERCPU_SLOTS	8
@@ -46,6 +47,9 @@ struct hazptr_ctx {
 	struct hazptr_slot *slot;
 	/* Backup slot in case all per-CPU slots are used. */
 	struct hazptr_backup_slot backup_slot;
+#ifdef CONFIG_PREEMPT_HAZPTR
+	struct list_head preempt_node;
+#endif
 };
 
 struct hazptr_percpu_slots {
@@ -98,6 +102,50 @@ bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
 	return slot == &ctx->backup_slot.slot;
 }
 
+#ifdef CONFIG_PREEMPT_HAZPTR
+static inline
+void hazptr_chain_task_ctx(struct hazptr_ctx *ctx)
+{
+	list_add(&ctx->preempt_node, &current->hazptr_ctx_list);
+}
+
+static inline
+void hazptr_unchain_task_ctx(struct hazptr_ctx *ctx)
+{
+	list_del(&ctx->preempt_node);
+}
+
+static inline
+void hazptr_note_context_switch(void)
+{
+	struct hazptr_ctx *ctx;
+
+	list_for_each_entry(ctx, &current->hazptr_ctx_list, preempt_node) {
+		struct hazptr_slot *slot;
+
+		if (hazptr_slot_is_backup(ctx, ctx->slot))
+			continue;
+		slot = hazptr_chain_backup_slot(ctx);
+		/*
+		 * Move hazard pointer from per-CPU slot to backup slot.
+		 * This requires hazard pointer synchronize to iterate
+		 * on per-CPU slots with load-acquire before iterating
+		 * on the overflow list.
+		 */
+		WRITE_ONCE(slot->addr, ctx->slot->addr);
+		/*
+		 * store-release orders store to backup slot addr before
+		 * store to per-CPU slot addr.
+		 */
+		smp_store_release(&ctx->slot->addr, NULL);
+	}
+}
+#else
+static inline void hazptr_chain_task_ctx(struct hazptr_ctx *ctx) { }
+static inline void hazptr_unchain_task_ctx(struct hazptr_ctx *ctx) { }
+static inline void hazptr_note_context_switch(void) { }
+#endif
+
 /*
  * hazptr_acquire: Load pointer at address and protect with hazard pointer.
  *
@@ -114,6 +162,7 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
 	struct hazptr_slot *slot = NULL;
 	void *addr, *addr2;
 
+	ctx->slot = NULL;
 	/*
 	 * Load @addr_p to know which address should be protected.
 	 */
@@ -121,7 +170,9 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
 	for (;;) {
 		if (!addr)
 			return NULL;
+
 		guard(preempt)();
+		hazptr_chain_task_ctx(ctx);
 		if (likely(!hazptr_slot_is_backup(ctx, slot))) {
 			slot = hazptr_get_free_percpu_slot();
 			/*
@@ -140,8 +191,11 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
 		 * Re-load @addr_p after storing it to the hazard pointer slot.
 		 */
 		addr2 = READ_ONCE(*addr_p);	/* Load A */
-		if (likely(ptr_eq(addr2, addr)))
+		if (likely(ptr_eq(addr2, addr))) {
+			ctx->slot = slot;
+			/* Success. Break loop, enable preemption and return. */
 			break;
+		}
 		/*
 		 * If @addr_p content has changed since the first load,
 		 * release the hazard pointer and try again.
@@ -150,11 +204,14 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
 		if (!addr2) {
 			if (hazptr_slot_is_backup(ctx, slot))
 				hazptr_unchain_backup_slot(ctx);
+			hazptr_unchain_task_ctx(ctx);
+			/* Loaded NULL. Enable preemption and return NULL. */
 			return NULL;
 		}
 		addr = addr2;
+		hazptr_unchain_task_ctx(ctx);
+		/* Enable preemption and retry. */
 	}
-	ctx->slot = slot;
 	/*
 	 * Use addr2 loaded from the second READ_ONCE() to preserve
 	 * address dependency ordering.
@@ -170,11 +227,13 @@ void hazptr_release(struct hazptr_ctx *ctx, void *addr)
 
 	if (!addr)
 		return;
+	guard(preempt)();
 	slot = ctx->slot;
 	WARN_ON_ONCE(slot->addr != addr);
 	smp_store_release(&slot->addr, NULL);
 	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
 		hazptr_unchain_backup_slot(ctx);
+	hazptr_unchain_task_ctx(ctx);
 }
 
 void hazptr_init(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b469878de25c..bbec9fd6b163 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -933,6 +933,10 @@ struct task_struct {
 	struct rcu_node			*rcu_blocked_node;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 
+#ifdef CONFIG_PREEMPT_HAZPTR
+	struct list_head		hazptr_ctx_list;
+#endif
+
 #ifdef CONFIG_TASKS_RCU
 	unsigned long			rcu_tasks_nvcsw;
 	u8				rcu_tasks_holdout;
diff --git a/init/init_task.c b/init/init_task.c
index a55e2189206f..117aebf5573a 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -160,6 +160,9 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	.rcu_node_entry = LIST_HEAD_INIT(init_task.rcu_node_entry),
 	.rcu_blocked_node = NULL,
 #endif
+#ifdef CONFIG_PREEMPT_HAZPTR
+	.hazptr_ctx_list = LIST_HEAD_INIT(init_task.hazptr_ctx_list),
+#endif
 #ifdef CONFIG_TASKS_RCU
 	.rcu_tasks_holdout = false,
 	.rcu_tasks_holdout_list = LIST_HEAD_INIT(init_task.rcu_tasks_holdout_list),
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index da326800c1c9..beb351b42b7c 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -189,3 +189,13 @@ config SCHED_CLASS_EXT
 	  For more information:
 	    Documentation/scheduler/sched-ext.rst
 	    https://github.com/sched-ext/scx
+
+config PREEMPT_HAZPTR
+	bool "Move Hazard Pointers to Task Slots on Context Switch"
+	help
+	  Integrate hazard pointers with the scheduler so the active
+	  hazard pointers using preallocated per-CPU slots are moved to
+	  their context local slot on context switch. This prevents
+	  blocked or preempted tasks to hold on to per-CPU slots for
+	  a long time, which would cause higher overhead for short
+	  hazard pointer critical sections.
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..35c810fe744e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1780,6 +1780,9 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_blocked_node = NULL;
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_PREEMPT_HAZPTR
+	INIT_LIST_HEAD(&p->hazptr_ctx_list);
+#endif /* #ifdef CONFIG_PREEMPT_HAZPTR */
 #ifdef CONFIG_TASKS_RCU
 	p->rcu_tasks_holdout = false;
 	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f754a60de848..ac8bf2708140 100644
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
@@ -6812,6 +6813,7 @@ static void __sched notrace __schedule(int sched_mode)
 
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
+	hazptr_note_context_switch();
 
 	/*
 	 * Make sure that signal_pending_state()->signal_pending() below
-- 
2.39.5


