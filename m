Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85829C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 00:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E346B0088; Wed, 15 Jul 2026 20:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DEEA6B0092; Wed, 15 Jul 2026 20:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A72F6B0093; Wed, 15 Jul 2026 20:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D36C76B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:18:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1052212033A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:18:14 +0000 (UTC)
X-FDA: 84992727708.29.D7D80F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69FC0A0005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:18:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edCu6KiN;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=p+7x=FK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=p+7x=FK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784161092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+ZolLsRH55PYQDrNZ8XplwgNVinZ6I37JOCU9BiGYg=;
	b=mAH2vt2lhF5gF5y3vkcms/TKhkUpEIa2X6JzJCkJVx/UDe3NoiibfOe5ww4+ZoSMrTIw9n
	GVP0nSENqILB5UrwQlen2EDH3KEZkIFz3F4MzgUHpuDao6q+EnPfgoGvYjhCRYwbTx56Y+
	qqyRXQBQOeGRbJJai6vjWCIjOAThxOA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edCu6KiN;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=p+7x=FK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=p+7x=FK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784161092;
	b=riH1UrQ2+s5n1SBVHlVW40IAzv5/wdOz5yhngpcF1uswVIw1k4xa/nNlZDrLOrdzEtObVn
	/zqFcWpjK+IYRbeKj1u8tc0Qr02zl3T9PI9hQ0vVc9v52q+qStvMTxK1LTmS0B8swaNf+u
	PPZWzuDVUVPpdL6dy0XZoz+RTpZhm5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83E716001D;
	Thu, 16 Jul 2026 00:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356121F000E9;
	Thu, 16 Jul 2026 00:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784161091;
	bh=n+ZolLsRH55PYQDrNZ8XplwgNVinZ6I37JOCU9BiGYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edCu6KiNENohZoWXHE9KcYahldzB6Sz+Qjoy+Rw/NrGp4PQpk1GwEEydQMznYWoAn
	 nSAc4ws5/gK6MhuqoXgytVry9UYzcDZZ6OjdwreiQnI7l3/yQWJn2QcL2aPARlZWnG
	 vp1QkBOf2HoZ8WrMc05Ka18tH0vzvf5/Vv96WSjsSdXJY/UsYMPwt5FjiJSRVwQalO
	 D1HAj+HAtl3OcMHAKlVYcRiuTlcUNF43dEsd/3yp1hRmiya0U4G3smW+TJRPeUHAG5
	 E/aOjuWixsPIQAVfjQ50oUua2qvW3p+S0nXbzpu/MvJ07Hj4IwphyV+K3iSNtr9YK4
	 YlODpiykbXLpg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 2503ACE0569; Wed, 15 Jul 2026 17:18:11 -0700 (PDT)
From: "Paul E. McKenney" <paulmck@kernel.org>
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	rostedt@goodmis.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
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
	linux-mm@kvack.org,
	lkmm@lists.linux.dev
Subject: [PATCH RFC v2 01/24] hazptr: Implement Hazard Pointers
Date: Wed, 15 Jul 2026 17:17:46 -0700
Message-Id: <20260716001809.11084-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <23e34c2e-67fd-45da-b130-e70a131a59ea@paulmck-laptop>
References: <23e34c2e-67fd-45da-b130-e70a131a59ea@paulmck-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69FC0A0005
X-Stat-Signature: kb11uy4644jq3wqecwn4bisqu3x1ur1x
X-HE-Tag: 1784161092-428368
X-HE-Meta: U2FsdGVkX1+M8V7E8d5LXB5+rt0fluQDURWZ78pJY0a7LXQ0/BldHoxGiXCjVGJECuk3TVf/es2Y+Q57XPOVCsTNlyri1p1yBl4fTGplxmlv0eOhBZlYQX6nj4zWkcL9wAXfVdzVHolLyEpgJlWanutp9c+Og+xQc+XLcVBbClVy3W98lhdQies62M6v961Bk28zmrSSRfHiHGABuD2xRvg8qEBZHj+ktN9H40zdd1oJ53StKE0PiYqipNqNpt84JfcRxlMbgJUxs1OOjFtZZavtTCqzQi1za3OspDUnXS+Au/VfOsnoqCIRea3on0ch4dvfYmhR507EuwB4LZqHSEeOXZUj+Ch/PUTYgrRdo9pvLdFgTVHvbSjG0K5Xuo2UstyeaXjDFXOFhLYyj+Zvo1kIwlqiWzfYkWeWiBFSAY79LjZG8ji9OIyyEXwEEuTCNILN+/XDvY9c7MvZil0CFsX3R5gNradd98FByW8Scv8NVQHDtz3c6HygnhvZQLYHnVg8Dpe7xgIjg5xovDaXQWmfboDOaVk3zNLhUS6x7+TGW/amUcjWOuGiDouq3KzVzTnDIsSHyGPgBGLYyLQaT9J0pRLzlyxYhNVj/telmZfe6cNKw75rebkanUbPOQnBYdefv7nSne4EpZh+GapMW3GV0RlwH4b8me++GKQ2z2btn/jG2Wg/lMJ9C/Q1UQUz7HUPB9U4rCA9FyL9IIvCeESDIzYDmEpXQ533OnVQ3F1k/OksEhh9eCIgqGwvKV3m7nGpPWjHAoUgIS3Pupy0vMVT/wGzflMePY3zgr4mvJQOGjTzEMSehJiY+6CZtwxihEXP7jlQK9+majXEDLULy+iEhtUL3g/HNHY1dy+e4Ujwh+CJL2pID5nyn9UVG/XgrztmAEHU/Cmm5i2/CzJmwTc9yrtVkCbD2KPn9uxJ6yBVq2XnGkCHrn3W9sRK9LtT4Z7BWvwv50mIkzNc8aa
 QFSeKAHV
 Qd9XOt9kxMmUAbVO9HxVdNrl8pnIIW73d8iCN60aJ5MWrIpnCk0xRrc4rixIfRN2zluXqtT7/HJtVl4k19t0IBqTiKKHAgyxPUzldHOoi7nh0VaMP1vG0E3N2gj6HFZDbTmdFK8i+7+e4+InjTGRhXXJP7UK9vs63qky9TLkziyDipQskVtgC+o8M6GDUaG0EG0Ixc6x7YedZ9nnGAhuA7gdx0Qpz8qA9nmcqDcwQqpUMc0V6NsRIighZOmwG9vpfCJA6E3H/Lezy2giVU4Ce9jnVdfajwBow8KilKyhKAtRHY4z8jUsnca3rTANo+wmGKglhBXab47bBi4XJBn7Psca0b3IRyhxSjB6PIqmpbc/tVWw16M18Ve1/kgFd6e8cMetVSijRKjIFcB07WHal1p00VVRVeIqwtEelU7Ki07rARBkwzrGcUH8jEbsYHSZ5trc/tRmCpKDxIdmezp/fsbh+Knh/NAm+ZApcQEy5uiALZ+ubKQ+yY5Sc0oVsY24M1YRVncYxIny2zj8oic6vRyX0G36ai0JiUGSpO23j8RKUDlup+qOFMM07klq0+oIqu/K8KQ3e+jTw924qijXfL1NRE8usUqEsuUSCOzT4zXCsj82ToxjwQyHyqIng8915o0QR4l3xGoMCtMBgulXPrdy4gxcbMiN1RycX28fYu6GD3zA9C8NLGBnPAmFu/PcDMtwvIPgoSYoQfjUXHRTXE5/3dnZCcz6eTdzPy3aAGWN2WUls2/FWx71FLS/Gbzt+4s5AWZ+6XasbO3FOPQx3zuhJzEBfmx2OfnmM7PJpfBrVlkYhpeyV6C2yaGeHzQpUoxFx/NLuaPdVoOCnvoYVMnHB817J/TsBJ2MIxV9fXEEGt0a9rvRUkXHsuoJfaGHeRa555OiF7SO1GzOXSJUxlCpS76KgarlYAxDuk42fBW+WTkv1eLSpN97IRbmAJsyKhkCPujMfehaepfIZtK8XqeGQncHv
 fi6cSEJ8
 E1nl74VQORwzIe7vDfbq1w6nSU8arVpwnGbdLnhZ8GFi/ILDMSvWwJlD1Z7/KR/Uj5v+j77PlolZf2WJgdkW/OwLQCqVNtYoI1/o8vj8F++OHS6NU67lJUHnTMG+buS8bfSNwzocYROHwLCf+bVcvrCdREgwXNYqhGWakvrKtTbgpIVnnyBWwkjVsv/z9ZLWVcaRKf/hE2JPPrsv3WHvioYpTFQvT5ZTuksGN8Hw5nKFIETA9PUYJ5VK/knIS61VSN+uZlnpF00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

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
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
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
index 00000000000000..461f481a480b9c
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
index e363232b428b47..e41f3ae436d496 100644
--- a/init/main.c
+++ b/init/main.c
@@ -107,6 +107,7 @@
 #include <linux/time_namespace.h>
 #include <linux/unaligned.h>
 #include <linux/vdso_datastore.h>
+#include <linux/hazptr.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1065,6 +1066,7 @@ void start_kernel(void)
 	workqueue_init_early();
 
 	rcu_init();
+	hazptr_init();
 	kvfree_rcu_init();
 
 	/* Trace events are available after this */
diff --git a/kernel/Makefile b/kernel/Makefile
index 1e1a31673577d6..8961c8660d0dce 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o exec_state.o panic.o \
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
index 00000000000000..a63ac681cb85df
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
index 96226707c2f613..e3fb70c3843689 100644
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
@@ -7087,6 +7088,7 @@ static void __sched notrace __schedule(int sched_mode)
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
 	migrate_disable_switch(rq, prev);
+	hazptr_note_context_switch();
 
 	/*
 	 * Make sure that signal_pending_state()->signal_pending() below
-- 
2.40.1


