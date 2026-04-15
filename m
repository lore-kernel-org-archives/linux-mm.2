Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB86FF43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2768A6B0088; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227956B0089; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF866B008C; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC2166B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B250613B185
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:32 +0000 (UTC)
X-FDA: 84661371144.26.7E0B051
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 76A951C000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf21.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=864GEK4S36PSYlpzhPa2cXHctNNT5vKcK4GtlmwKm8I=;
	b=5Z7Q6wJv7v0cowbb2Yb4IHlCAftfyHODrfdg2qwCwrD6Taidy6HggqVVUg/WMzB0dp+Mx8
	aMfjFnM/saknSacT55ftXUEIi54hITWdeKt+VqTNUBJA2aNqEcMlxQhc6svaBBsVHmAqQU
	oXRkOwDPhPMOtrWnyiUMUIMSy3U55uk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf21.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271651; a=rsa-sha256;
	cv=none;
	b=hmoTvh6kweytGCmFRRke3IdthVNSm4leSoJQQM0lBLY8RHk8/y7+J9olwX9/1Pv3xqnxo0
	Dfccd2xgicoCpk/GUqd1awvyPGG+ny3m6WwI7+5nrxKv8aMj64O42WIGwZOD7po+hHlRC/
	hGdpDQgXQ8ALyK0/k99mmia8URRzOjA=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9r2WvzzHnGjD;
	Thu, 16 Apr 2026 00:47:12 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A8F4840569;
	Thu, 16 Apr 2026 00:47:28 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:28 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 2/7] hq-spinlock: implement inner logic
Date: Thu, 16 Apr 2026 00:44:54 +0800
Message-ID: <20260415164459.2904963-3-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76A951C000F
X-Stat-Signature: 1gygwdfozde6rqhsrmrt87crqkr8za49
X-Rspam-User: 
X-HE-Tag: 1776271650-554337
X-HE-Meta: U2FsdGVkX1+fPkaNosoRPMh/PcswtFnZBFkbLj/AJ6jKfYSjTas1YMdbda+s9xZSUKeltsUeZsya/nO8OBXtCtqfFTOUzt18O/18U6kEzWJ3owUwuQAY7X6oa9HNENXjed8S92MvkV8vaUvWKoiMri9bxNkgYJAWmCWqiEQxc5rzOF76c75g0eNTOI3zWLDVCUFaILmYrZHpJHT6Vu2zSuEYsRSmghjmLiiMp/qOHiUIFpbKkuvE0i71UhpJQ9qeZkLFrrvz3OHmLftWE4P1tEOf3pjq9IgKTwI7UCIppHsmzs8T2ZmTKZzyG5lkRZ046hmMWog6Ptc072s9AxzIduVFQvlS2MkNqHfcOwflTfpMQS5RbbexnS/Iyr17upCRq+Q9qknr4x52974yPbS+LjSe7rsPTkBsVaNgPuNCYNlcioc7vT+c4yeMCU+y60QsOF/bOe2sDnPN9NNe1ac3uSJIBpl/hZVXdcZSYCnAPHEu9oBksDM4Ma0/cZ9FJqhbIg1Uof78AMnqk4Al8Ww8faJTS7Dlex7wX8hJ4lEB+a+a8a9uYrhpw2p/8rucG+gZrB2kwz8xomFKdJEp9+KbSDcaBxFXfcZ7NjHrbdD67RPG4l7QjntCqOuuxT3lJ5O8zlGbex899Vn7amXLEwLy+ORSGQD6C1t9e3aFc7FEhNloVx1/8W2y8OVAYhZGOeRTQQf3eHcmLXV8sPMEjy3GH9/DkoRO8rdWOdxi1loEiFv0aZzOfn8A47PeJpDRTTzGr0cECp1IIBrTYelR8YQxWCNfctFZZufMH1RS3XPzshIxPdf7oAJ5r9HHrBoG9Mky7kIme6XBZ8tfcfnffWDuimIW6QKPBNnlb91XQRu5rveb5hwSo6PbA7w9xtQpLezDVx3q+d0jai72BDPLthpUY1mhdcaF0YS0UDgTH0rDOwtLFAthJZVMpkfW1wZjNL0pTaD78Q+FHbii5l2M4jb
 f0C4X0IG
 tQrD5IgyioEbLJ5NguqmnXdkUfQlx0+kHb+wP+WFPBno7gCVmbt8rg3DXe/YwrxdB1DMHcEnMMtBjVbku80CcJCBDaIAIKNCkzGnoybH7fWtuh4ZeBeQOK6INEhTX8SGTHPX5jqAdH05fE8tMyPqSel0pNuVxJkGJnp/qHoj2v7sVdF8J6ILsNu0WEYOanWy7YhnwfvkSwtp5L55uZejaX9VXljkPbgN0w8aDJHkd2AGy5I/JGKg9Wq8C7jQs+QpVlrxwOQ6xmA/VXh5yJYWJjDPLKLYYn3xvrVNIXaXPuKiTUlt+9gRwQ2bbNOQsxBeHXAs9Qz+nGOTqZO5THMsX9sPu4dIfgZmVNtubP/JFhEg6TRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The design might be considered as a combination of cohort-locking
by Dave Dice and Linux kernel queued spinlock.

The contenders are organized into 2-level scheme where each NUMA-node
has it's own FIFO contender queue.

NUMA-queues are linked into single-linked list alike structure, while
maintaining FIFO order between them.
When there're no contenders left in a NUMA-queue, the queue is removed from
the list.

Contenders try to enqueue to local NUMA-queue first and if there's
no such queue - link it to the list.
As for "qspinlock" only the first contender is spinning globally,
all others - MCS-spinning.

"Handoff" operation becomes two-staged:
- local handoff: between contenders in a single NUMA-queue
- remote handoff: between different NUMA-queues.

If "remote handoff" reaches the end of the NUMA-queue linked list it goes to
the list head.

To avoid potential starvation issues, we use handoff thresholds.

Key challenge here was keeping the same "qspinlock" structure size
and "bind" a given lock to related NUMA-queues.

We came up with dynamic lock metadata concept, where we can
dynamically "bind" a given lock to it's NUMA-related metadata, and
then "unbind" when the lock is released.

This approach allows to avoid metadata reservation for every lock in advance,
thus giving the upperbound of metadata instance number to ~ (NR_CPUS x nr_contexts / 2).
Which corresponds to maximum amount of different locks falling into the slowpath.

HQ-lock supports switching between "default qspinlock" mode to "NUMA-aware lock" mode and backwards.

If for some reason "NUMA-aware" mode cannot be enabled we fallback to default qspinlock mode.

Functions that will be used in generic qspinlock code are started with "hqlock_"
(`hqlock_xchg_tail`, `hqlock_clear_pending`, `hqlock_clear_pending_set_locked`,
`hqlock_try_clear_tail`, `hqlock_handoff`).

Testing with locktorture module shows that this design reduces overhead
on both x86 and arm64 NUMA systems. On AMD EPYC 9654, throughput gains reach
up to 186% in the evaluated NPS=12 configuration. On Kunpeng 920,
throughput gains range from 93% to 158% across the tested thread
counts. Fairness on AMD EPYC 9654 remained in the 0.51-0.61 range in
the evaluated configurations.

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>

---
The full benchmark tables are included in the cover letter.
---
 kernel/locking/hqlock_core.h | 715 +++++++++++++++++++++++++++++++++++
 kernel/locking/hqlock_meta.h | 467 +++++++++++++++++++++++
 2 files changed, 1182 insertions(+)
 create mode 100644 kernel/locking/hqlock_core.h
 create mode 100644 kernel/locking/hqlock_meta.h

diff --git a/kernel/locking/hqlock_core.h b/kernel/locking/hqlock_core.h
new file mode 100644
index 0000000000..7322199228
--- /dev/null
+++ b/kernel/locking/hqlock_core.h
@@ -0,0 +1,715 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _GEN_HQ_SPINLOCK_SLOWPATH
+#error "Do not include this file!"
+#endif
+
+#include <linux/nodemask.h>
+#include <linux/topology.h>
+#include <linux/sched/clock.h>
+#include <linux/moduleparam.h>
+#include <linux/sched/rt.h>
+#include <linux/random.h>
+#include <linux/mm.h>
+#include <linux/memblock.h>
+#include <linux/sysctl.h>
+#include <linux/types.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/panic.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/sprintf.h>
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
+#include <linux/swab.h>
+#include <linux/hash.h>
+
+/* Contains queues for all possible lock id */
+static struct numa_queue *queue_table[MAX_NUMNODES];
+
+#include "hqlock_types.h"
+#include "hqlock_proc.h"
+
+/* Gets node_id (1..N) */
+static inline struct numa_queue *
+get_queue(u16 lock_id, u16 node_id)
+{
+	return &queue_table[node_id - 1][lock_id];
+}
+
+static inline struct numa_queue *
+get_local_queue(struct numa_qnode *qnode)
+{
+	return get_queue(qnode->lock_id, qnode->numa_node);
+}
+
+static inline void init_queue_link(struct numa_queue *queue)
+{
+	queue->prev_node = 0;
+	queue->next_node = 0;
+}
+
+static inline void init_queue(struct numa_qnode *qnode)
+{
+	struct numa_queue *queue = get_local_queue(qnode);
+
+	queue->head = qnode;
+	queue->handoffs_not_head = 0;
+	init_queue_link(queue);
+}
+
+static void set_next_queue(u16 lock_id, u16 prev_node_id, u16 node_id)
+{
+	struct numa_queue *local_queue = get_queue(lock_id, node_id);
+	struct numa_queue *prev_queue =
+		get_queue(lock_id, prev_node_id);
+
+	WRITE_ONCE(local_queue->prev_node, prev_node_id);
+	/*
+	 * Needs to be guaranteed the following:
+	 * when appending "local_queue", if "prev_queue->next_node" link
+	 * is observed then "local_queue->prev_node" is also observed.
+	 *
+	 * We need this to guarantee correctness of concurrent
+	 * "unlink_node_queue" for the "prev_queue", if "prev_queue" is the first in the list.
+	 * [prev_queue] <-> [local_queue]
+	 *
+	 * In this case "unlink_node_queue" would be setting "local_queue->prev_node = 0", thus
+	 * w/o the smp-barrier, it might race with "set_next_queue", if
+	 * "local_queue->prev_node = prev_node_id" happens afterwards, leading to corrupted list.
+	 */
+	smp_wmb();
+	WRITE_ONCE(prev_queue->next_node, node_id);
+}
+
+static inline struct lock_metadata *get_meta(u16 lock_id);
+
+/**
+ * Put new node's queue into global NUMA-level queue
+ */
+static inline u16 append_node_queue(u16 lock_id, u16 node_id)
+{
+	struct lock_metadata *lock_meta = get_meta(lock_id);
+	u16 prev_node_id = xchg(&lock_meta->tail_node, node_id);
+
+	if (prev_node_id)
+		set_next_queue(lock_id, prev_node_id, node_id);
+	else
+		WRITE_ONCE(lock_meta->head_node, node_id);
+	return prev_node_id;
+}
+
+#include "hqlock_meta.h"
+
+/**
+ * Update tail
+ *
+ * Call proper function depending on lock's mode
+ * until successful queuing
+ */
+static inline u32 hqlock_xchg_tail(struct qspinlock *lock, u32 tail,
+				 struct mcs_spinlock *node, bool *numa_awareness_on)
+{
+	struct numa_qnode *qnode = (struct numa_qnode *)node;
+
+	u16 lock_id;
+	u32 old_tail;
+	u32 next_tail = tail;
+
+	/*
+	 * Key lock's mode switches questions:
+	 * - After init lock is in LOCK_MODE_QSPINLOCK
+	 * - If many contenders have come while lock was in LOCK_MODE_QSPINLOCK,
+	 *   we want this lock to use NUMA awareness next time,
+	 *   so we clean LOCK_MODE_QSPINLOCK, see 'low_contention_try_clear_tail'
+	 * - During next lock's usages we try to go through NUMA-aware path.
+	 *   We can fail here, because we use shared metadata
+	 *   and can have a conflict with another lock, see 'hqlock_meta.h' for details.
+	 *   In this case we fallback to generic qspinlock approach.
+	 *
+	 * In other words, lock can be in 3 mode states:
+	 *
+	 * 1. LOCK_MODE_QSPINLOCK - there was low contention or not at all earlier,
+	 *    or (unlikely) a conflict in metadata
+	 * 2. LOCK_NO_MODE - there was a contention on a lock earlier,
+	 *    now there are no contenders in the queue (we are likely the first)
+	 *    and we need to try using NUMA awareness
+	 * 3. LOCK_MODE_HQLOCK - lock is currently under contention
+	 *    and using NUMA awareness.
+	 */
+
+	/*
+	 * numa_awareness_on == false means we saw LOCK_MODE_QSPINLOCK (1st state)
+	 * before starting slowpath, see 'queued_spin_lock_slowpath'
+	 */
+	if (*numa_awareness_on == false &&
+		try_update_tail_qspinlock_mode(lock, tail, &old_tail, &next_tail))
+		return old_tail;
+
+	/* Calculate the lock_id hash here once */
+	qnode->lock_id = lock_id = hash_ptr(lock, LOCK_ID_BITS);
+
+try_again:
+	/*
+	 * Lock is in state 2 or 3 - go through NUMA-aware path
+	 */
+	if (try_update_tail_hqlock_mode(lock, lock_id, qnode, tail, &next_tail, &old_tail)) {
+		*numa_awareness_on = true;
+		return old_tail;
+	}
+
+	/*
+	 * We have failed (conflict in metadata), now lock is in LOCK_MODE_QSPINLOCK again
+	 */
+	if (try_update_tail_qspinlock_mode(lock, tail, &old_tail, &next_tail)) {
+		*numa_awareness_on = false;
+		return old_tail;
+	}
+
+	/*
+	 * We were slow and clear_tail after high contention has already happened
+	 * (very unlikely situation)
+	 */
+	goto try_again;
+}
+
+static inline void hqlock_clear_pending(struct qspinlock *lock, u32 old_val)
+{
+	WRITE_ONCE(lock->pending, (old_val & _Q_LOCK_TYPE_MODE_MASK) >> _Q_PENDING_OFFSET);
+}
+
+static inline void hqlock_clear_pending_set_locked(struct qspinlock *lock, u32 old_val)
+{
+	WRITE_ONCE(lock->locked_pending,
+			_Q_LOCKED_VAL | (old_val & _Q_LOCK_TYPE_MODE_MASK));
+}
+
+static inline void unlink_node_queue(u16 lock_id,
+					u16 prev_node_id,
+					u16 next_node_id)
+{
+	struct numa_queue *prev_queue =
+		prev_node_id ? get_queue(lock_id, prev_node_id) : NULL;
+	struct numa_queue *next_queue = get_queue(lock_id, next_node_id);
+
+	if (prev_queue)
+		WRITE_ONCE(prev_queue->next_node, next_node_id);
+	/*
+	 * This is guaranteed to be ordered "after" next_node_id observation
+	 * by implicit full-barrier in the caller-code.
+	 */
+	WRITE_ONCE(next_queue->prev_node, prev_node_id);
+}
+
+static inline bool try_clear_queue_tail(struct numa_queue *queue, u32 tail)
+{
+	/*
+	 * We need full ordering here to:
+	 * - ensure all prior operations with global tail and prev_queue
+	 *   are observed before clearing local tail
+	 * - guarantee all subsequent operations
+	 *   with metadata release, unlink etc will be observed after clearing local tail
+	 */
+	return cmpxchg(&queue->tail, tail, 0) == tail;
+}
+
+/*
+ * Determine if we have another local and global contenders.
+ * Try clear local and global tail, understand handoff type we need to perform.
+ * In case we are the last, free lock's metadata
+ */
+static inline bool hqlock_try_clear_tail(struct qspinlock *lock, u32 val,
+				       u32 tail, struct mcs_spinlock *node,
+				       int *p_next_node)
+{
+	bool ret = false;
+	struct numa_qnode *qnode = (void *)node;
+
+	u16 lock_id = qnode->lock_id;
+	u16 local_node = qnode->numa_node;
+	struct numa_queue *queue = get_queue(lock_id, qnode->numa_node);
+
+	struct lock_metadata *lock_meta = get_meta(lock_id);
+
+	u16 prev_node = 0, next_node = 0;
+	u16 node_tail;
+
+	u32 old_val;
+
+	bool lock_tail_updated = false;
+	bool lock_tail_cleared = false;
+
+	/* Do we have *next node* arrived */
+	bool pending_next_node = false;
+
+	tail >>= _Q_TAIL_OFFSET;
+
+	/* Do we have other CPUs in the node queue ? */
+	if (READ_ONCE(queue->tail) != tail) {
+		*p_next_node = HQLOCK_HANDOFF_LOCAL;
+		goto out;
+	}
+
+	/*
+	 * Key observations and actions:
+	 * 1) next queue isn't observed:
+	 *    a) if prev queue is observed, try to unpublish local queue
+	 *    b) if prev queue is not observed, try to clean global tail
+	 *    Anyway, perform these operations before clearing local tail.
+	 *
+	 *    Such trick is essential to safely unlink the local queue,
+	 *    otherwise we could race with upcomming local contenders,
+	 *    which will perform 'append_node_queue' while our unlink is not properly done.
+	 *
+	 * 2) next queue is observed:
+	 *    safely perform 'try_clear_queue_tail' and unlink local node if succeeded.
+	 */
+
+	prev_node = READ_ONCE(queue->prev_node);
+	pending_next_node = READ_ONCE(lock_meta->tail_node) != local_node;
+
+	/*
+	 * Tail case:
+	 * [prev_node] -> [local_node], lock_meta->tail_node == local_node
+	 *
+	 * There're no nodes after us at the moment, try updating the "lock_meta->tail_node"
+	 */
+	if (!pending_next_node && prev_node) {
+		struct numa_queue *prev_queue =
+			get_queue(lock_id, prev_node);
+
+		/* Reset next_node, in case no one will come after */
+		WRITE_ONCE(prev_queue->next_node, 0);
+
+		/*
+		 * release to publish prev_queue->next_node = 0
+		 * and to ensure ordering with 'READ_ONCE(queue->tail) != tail'
+		 */
+		if (cmpxchg_release(&lock_meta->tail_node, local_node, prev_node) == local_node) {
+			lock_tail_updated = true;
+
+			queue->next_node = 0;
+			queue->prev_node = 0;
+			next_node = 0;
+		} else {
+			/* If some node came after the local meanwhile, reset next_node back */
+			WRITE_ONCE(prev_queue->next_node, local_node);
+
+			/* We either observing updated "queue->next" or it equals zero */
+			next_node = READ_ONCE(queue->next_node);
+		}
+	}
+
+	node_tail = READ_ONCE(lock_meta->tail_node);
+
+	/* If nobody else is waiting, try clean global tail */
+	if (node_tail == local_node && !prev_node) {
+		old_val = (((u32)local_node) | (((u32)local_node) << 16));
+		/* release to ensure ordering with 'READ_ONCE(queue->tail) != tail' */
+		lock_tail_cleared = try_cmpxchg_release(&lock_meta->nodes_tail, &old_val, 0);
+	}
+
+	/*
+	 * lock_meta->tail_node was not updated and cleared,
+	 * so we have at least single non-empty node after us
+	 */
+	if (!lock_tail_updated && !lock_tail_cleared) {
+		/*
+		 * If there's a node came before clearing node queue - wait for it to link properly.
+		 * We need this for correct upcoming *unlink*, otherwise the *unlink* might race with parallel set_next_node()
+		 */
+		if (!next_node) {
+			next_node =
+				smp_cond_load_relaxed(&queue->next_node, (VAL));
+		}
+	}
+
+	/* if we're the last one in the queue - clear the queue tail */
+	if (try_clear_queue_tail(queue, tail)) {
+		/*
+		 * "lock_tail_cleared == true"
+		 * It means: we cleared "lock_meta->tail_node" and "lock_meta->head_node".
+		 *
+		 * First new contender will do "global spin" anyway, so no handoff needed
+		 * "ret == true"
+		 */
+		if (lock_tail_cleared) {
+			ret = true;
+
+			/*
+			 * If someone has arrived in the meanwhile,
+			 * don't try to free the metadata.
+			 */
+			old_val = READ_ONCE(lock_meta->nodes_tail);
+			if (!old_val) {
+				/*
+				 * We are probably the last contender,
+				 * so, need to free lock's metadata.
+				 */
+				release_lock_meta(lock, lock_meta, qnode);
+			}
+			goto out;
+		}
+
+		/*
+		 * "lock_tail_updated == true" (implies "lock_tail_cleared == false")
+		 * It means we have at least "prev_node" and unlinked "local node"
+		 *
+		 * As we unlinked "local node", we only need to guarantee correct
+		 * remote handoff, thus we have:
+		 * "ret == false"
+		 * "next_node == HQLOCK_HANDOFF_REMOTE_HEAD"
+		 */
+		if (lock_tail_updated) {
+			*p_next_node = HQLOCK_HANDOFF_REMOTE_HEAD;
+			goto out;
+		}
+
+		/*
+		 * "!lock_tail_cleared && !lock_tail_updated"
+		 * It means we have at least single node after us.
+		 *
+		 * remote handoff and corect "local node" unlink are needed.
+		 *
+		 * "next_node" visibility guarantees that we observe
+		 * correctly additon of "next_node", so the following unlink
+		 * is safe and correct.
+		 *
+		 * "next_node > 0"
+		 * "ret == false"
+		 */
+		unlink_node_queue(lock_id, prev_node, next_node);
+
+		/*
+		 * If at the head - update one.
+		 *
+		 * Another place, where "lock_meta->head_node" is updated is "append_node_queue"
+		 * But we're safe, as that happens only with the first node on empty "node list".
+		 */
+		if (!prev_node)
+			WRITE_ONCE(lock_meta->head_node, next_node);
+
+		*p_next_node = next_node;
+	} else {
+		/*
+		 * local queue has other contenders.
+		 *
+		 * 1) "lock_tail_updated == true":
+		 * It means we have at least "prev_node" and unlinked "local node"
+		 * Also, some new nodes can arrive and link after "prev_node".
+		 * We should just re-add "local node": (prev_node) => ... => (local_node)
+		 * and perform local handoff, as other CPUs from the local node do "mcs spin"
+		 *
+		 * 2) "lock_tail_cleared == true"
+		 * It means we cleared "lock_meta->tail_node" and "lock->head_node".
+		 * We need to re-add "local node" and move "local_queue->head" to the next "mcs-node",
+		 * which is in the progress of linking after the current "mcs-node"
+		 * (that's why we couldn't clear the "local_queue->tail").
+		 *
+		 * Meanwhile other nodes can arrive: (new_node) => (...)
+		 * That "new_node" will spin in "global spin" mode.
+		 * In this case no handoff needed.
+		 *
+		 * 3) "!lock_tail_cleared && !lock_tail_updated"
+		 * It means we had at least one node after us before 'try_clear_queue_tail'
+		 * and only need to perform local handoff
+		 */
+
+		/* Cases 1) and 2) */
+		if (lock_tail_updated || lock_tail_cleared) {
+			u16 prev_node_id;
+
+			init_queue_link(queue);
+			prev_node_id =
+				append_node_queue(lock_id, local_node);
+
+			if (prev_node_id && lock_tail_cleared) {
+				/* Case 2) */
+				ret = true;
+				WRITE_ONCE(queue->head,
+					   (void *) smp_cond_load_relaxed(&node->next, (VAL)));
+				goto out;
+			}
+		}
+
+		/* Cases 1) and 3) */
+		*p_next_node = HQLOCK_HANDOFF_LOCAL;
+		ret = false;
+	}
+out:
+	/*
+	 * Either handoff for current node,
+	 * or remote handoff if the quota is expired
+	 */
+	return ret;
+}
+
+static inline void hqlock_handoff(struct qspinlock *lock,
+					 struct mcs_spinlock *node,
+					 struct mcs_spinlock *next, u32 tail,
+					 int handoff_info);
+
+
+/*
+ * Chech if contention has risen and if we need to set NUMA-aware mode
+ */
+static __always_inline bool determine_contention_qspinlock_mode(struct mcs_spinlock *node)
+{
+	struct numa_qnode *qnode = (void *)node;
+
+	if (qnode->general_handoffs > READ_ONCE(hqlock_general_handoffs_turn_numa))
+		return true;
+	return false;
+}
+
+static __always_inline bool low_contention_try_clear_tail(struct qspinlock *lock,
+					     u32 val,
+					     struct mcs_spinlock *node)
+{
+	u32 update_val = _Q_LOCKED_VAL | _Q_LOCKTYPE_HQ;
+
+	bool high_contention = determine_contention_qspinlock_mode(node);
+
+	/*
+	 * If we have high contention, we set _Q_LOCK_INVALID_TAIL
+	 * to notify upcomming contenders, which have seen QSPINLOCK mode,
+	 * that performing generic 'xchg_tail' is wrong.
+	 *
+	 * We cannot also set HQLOCK mode here,
+	 * because first contender in updated mode
+	 * should check if lock's metadata is free
+	 */
+	if (!high_contention)
+		update_val |= _Q_LOCK_MODE_QSPINLOCK_VAL;
+	else
+		update_val |= _Q_LOCK_INVALID_TAIL;
+
+	return atomic_try_cmpxchg_relaxed(&lock->val, &val, update_val);
+}
+
+static __always_inline void low_contention_mcs_lock_handoff(struct mcs_spinlock *node,
+					       struct mcs_spinlock *next, struct mcs_spinlock *prev)
+{
+	struct numa_qnode *qnode = (void *)node;
+	struct numa_qnode *qnext = (void *)next;
+
+	static u16 max_u16 = (u16)(-1);
+
+	u16 general_handoffs = qnode->general_handoffs;
+
+	if (next != prev && likely(general_handoffs + 1 != max_u16))
+		general_handoffs++;
+
+	qnext->general_handoffs = general_handoffs;
+	arch_mcs_spin_unlock_contended(&next->locked);
+}
+
+static inline void hqlock_clear_tail_handoff(struct qspinlock *lock, u32 val,
+				    u32 tail,
+				    struct mcs_spinlock *node,
+				    struct mcs_spinlock *next,
+					struct mcs_spinlock *prev,
+					bool is_numa_lock)
+{
+	int handoff_info;
+	struct numa_qnode *qnode = (void *)node;
+
+	/*
+	 * qnode->wrong_fallback_tail means we have queued globally
+	 * in 'try_update_tail_qspinlock_mode' after another contender,
+	 * but lock's mode was not QSPINLOCK in that moment.
+	 *
+	 * First confused contender has restored _Q_LOCK_INVALID_TAIL in global tail
+	 * and set us in his local queue.
+	 */
+	if (is_numa_lock || qnode->wrong_fallback_tail) {
+		/*
+		 * Because of splitting generic tail and NUMA tail we must set locked before clearing tail,
+		 * otherwise double lock is possible
+		 */
+		set_locked(lock);
+
+		if (hqlock_try_clear_tail(lock, val, tail, node, &handoff_info))
+			return;
+
+		hqlock_handoff(lock, node, next, tail, handoff_info);
+	} else {
+		if ((val & _Q_TAIL_MASK) == tail) {
+			if (low_contention_try_clear_tail(lock, val, node))
+				return;
+		}
+
+		set_locked(lock);
+
+		if (!next)
+			next = smp_cond_load_relaxed(&node->next, (VAL));
+
+		low_contention_mcs_lock_handoff(node, next, prev);
+	}
+}
+
+static inline void hqlock_init_node(struct mcs_spinlock *node)
+{
+	struct numa_qnode *qnode = (void *)node;
+
+	qnode->general_handoffs = 0;
+	qnode->numa_node = numa_node_id() + 1;
+	qnode->lock_id = 0;
+	qnode->wrong_fallback_tail = 0;
+}
+
+static inline void reset_handoff_counter(struct numa_qnode *qnode)
+{
+	qnode->general_handoffs = 0;
+}
+
+static inline void handoff_local(struct mcs_spinlock *node,
+					       struct mcs_spinlock *next,
+					       u32 tail)
+{
+	static u16 max_u16 = (u16)(-1);
+
+	struct numa_qnode *qnode = (struct numa_qnode *)node;
+	struct numa_qnode *qnext = (struct numa_qnode *)next;
+
+	u16 general_handoffs = qnode->general_handoffs;
+
+	if (likely(general_handoffs + 1 != max_u16))
+		general_handoffs++;
+
+	qnext->general_handoffs = general_handoffs;
+
+	u16 wrong_fallback_tail = qnode->wrong_fallback_tail;
+
+	if (wrong_fallback_tail != 0 && wrong_fallback_tail != (tail >> _Q_TAIL_OFFSET)) {
+		qnext->numa_node = qnode->numa_node;
+		qnext->wrong_fallback_tail = wrong_fallback_tail;
+		qnext->lock_id = qnode->lock_id;
+	}
+
+	arch_mcs_spin_unlock_contended(&next->locked);
+}
+
+static inline void handoff_remote(struct qspinlock *lock,
+						struct numa_qnode *qnode,
+						u32 tail, int handoff_info)
+{
+	struct numa_queue *next_queue = NULL;
+	struct mcs_spinlock *mcs_head = NULL;
+	struct numa_qnode *qhead = NULL;
+	u16 lock_id = qnode->lock_id;
+
+	struct lock_metadata *lock_meta = get_meta(lock_id);
+	struct numa_queue *queue = get_local_queue(qnode);
+
+	u16 next_node_id;
+	u16 node_head, node_tail;
+
+	node_tail = READ_ONCE(lock_meta->tail_node);
+	node_head = READ_ONCE(lock_meta->head_node);
+
+	/*
+	 * 'handoffs_not_head > 0' means at the head of NUMA-level queue we have a node
+	 * which is heavily loaded and has performed a remote handoff upon reaching the threshold.
+	 *
+	 * Perform handoff to the head instead of next node in the NUMA-level queue,
+	 * if handoffs_not_head >= nr_online_nodes
+	 * (It means other contended nodes have been taking the lock at least once after the head one)
+	 */
+	u16 handoffs_not_head = READ_ONCE(queue->handoffs_not_head);
+
+	if (handoff_info > 0 && (handoffs_not_head < nr_online_nodes)) {
+		next_node_id = handoff_info;
+		if (node_head != qnode->numa_node)
+			handoffs_not_head++;
+	} else {
+		if (!node_head) {
+			/* If we're here - we have defintely other node-contenders, let's wait */
+			next_node_id = smp_cond_load_relaxed(&lock_meta->head_node, (VAL));
+		} else {
+			next_node_id = node_head;
+		}
+
+		handoffs_not_head = 0;
+	}
+
+	next_queue = get_queue(lock_id, next_node_id);
+	WRITE_ONCE(next_queue->handoffs_not_head, handoffs_not_head);
+
+	qhead = READ_ONCE(next_queue->head);
+
+	mcs_head = (void *) qhead;
+
+	/* arch_mcs_spin_unlock_contended implies smp-barrier */
+	arch_mcs_spin_unlock_contended(&mcs_head->locked);
+}
+
+static inline bool has_other_nodes(struct qspinlock *lock,
+				   struct numa_qnode *qnode)
+{
+	struct lock_metadata *lock_meta = get_meta(qnode->lock_id);
+
+	return lock_meta->tail_node != qnode->numa_node;
+}
+
+static inline bool is_node_threshold_reached(struct numa_qnode *qnode)
+{
+	return qnode->general_handoffs > hqlock_fairness_threshold;
+}
+
+static inline void hqlock_handoff(struct qspinlock *lock,
+					 struct mcs_spinlock *node,
+					 struct mcs_spinlock *next, u32 tail,
+					 int handoff_info)
+{
+	struct numa_qnode *qnode = (void *)node;
+	u16 lock_id = qnode->lock_id;
+	struct lock_metadata *lock_meta = get_meta(lock_id);
+	struct numa_queue *queue = get_local_queue(qnode);
+
+	if (handoff_info == HQLOCK_HANDOFF_LOCAL) {
+		if (!next)
+			next = smp_cond_load_relaxed(&node->next, (VAL));
+		WRITE_ONCE(queue->head, (void *) next);
+
+		bool threshold_expired = is_node_threshold_reached(qnode);
+
+		if (!threshold_expired || qnode->wrong_fallback_tail) {
+			handoff_local(node, next, tail);
+			return;
+		}
+
+		u16 queue_next = READ_ONCE(queue->next_node);
+		bool has_others = has_other_nodes(lock, qnode);
+
+		/*
+		 * This check is racy, but it's ok,
+		 * because we fallback to local node in the worst case
+		 * and do not call reset_handoff_counter.
+		 * Next local contender will perform remote handoff
+		 * after next queue is properly linked
+		 */
+		if (has_others) {
+			handoff_info =
+				queue_next > 0 ? queue_next : HQLOCK_HANDOFF_LOCAL;
+		} else {
+			handoff_info = HQLOCK_HANDOFF_REMOTE_HEAD;
+		}
+
+		if (handoff_info == HQLOCK_HANDOFF_LOCAL ||
+			(handoff_info == HQLOCK_HANDOFF_REMOTE_HEAD &&
+				READ_ONCE(lock_meta->head_node) == qnode->numa_node)) {
+			/*
+			 * No other nodes have come yet, so we can clean fairness counter
+			 */
+			if (handoff_info == HQLOCK_HANDOFF_REMOTE_HEAD)
+				reset_handoff_counter(qnode);
+			handoff_local(node, next, tail);
+			return;
+		}
+	}
+
+	handoff_remote(lock, qnode, tail, handoff_info);
+	reset_handoff_counter(qnode);
+}
diff --git a/kernel/locking/hqlock_meta.h b/kernel/locking/hqlock_meta.h
new file mode 100644
index 0000000000..5b54801326
--- /dev/null
+++ b/kernel/locking/hqlock_meta.h
@@ -0,0 +1,467 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _GEN_HQ_SPINLOCK_SLOWPATH
+#error "Do not include this file!"
+#endif
+
+/* Lock metadata pool */
+static struct lock_metadata *meta_pool;
+
+static inline struct lock_metadata *get_meta(u16 lock_id)
+{
+	return &meta_pool[lock_id];
+}
+
+static inline hqlock_mode_t set_lock_mode(struct qspinlock *lock, int __val, u16 lock_id)
+{
+	u32 val = (u32)__val;
+	u32 new_val = 0;
+	u32 lock_mode = encode_lock_mode(lock_id);
+
+	while (!(val & _Q_LOCK_MODE_MASK)) {
+		/*
+		 * We need wait until pending is gone.
+		 * Otherwise, clearing pending can erase a NUMA mode we will set here
+		 */
+		if (val & _Q_PENDING_VAL) {
+			val = atomic_cond_read_relaxed(&lock->val, !(VAL & _Q_PENDING_VAL));
+
+			if (val & _Q_LOCK_MODE_MASK)
+				return LOCK_NO_MODE;
+		}
+
+		/*
+		 * If we are enabling NUMA-awareness, we should keep previous value in lock->tail
+		 * in case of having contenders seen LOCK_MODE_QSPINLOCK and set their tails via xchg_tail
+		 * (They will restore it to _Q_LOCK_INVALID_TAIL later).
+		 * If we are setting LOCK_MODE_QSPINLOCK, remove _Q_LOCK_INVALID_TAIL
+		 */
+		if (lock_id != LOCK_ID_NONE)
+			new_val = val | lock_mode;
+		else
+			new_val = (val & ~_Q_LOCK_INVALID_TAIL) | lock_mode;
+
+		/*
+		 * If we're setting LOCK_MODE_HQLOCK, make sure all "seq_counter"
+		 * updates (per-queue, lock_meta) are observed before lock mode update.
+		 * Paired with smp_rmb() in setup_lock_mode().
+		 */
+		if (lock_id != LOCK_ID_NONE)
+			smp_wmb();
+
+		bool updated = atomic_try_cmpxchg_relaxed(&lock->val, &val, new_val);
+
+		if (updated) {
+			return (lock_id == LOCK_ID_NONE) ?
+				LOCK_MODE_QSPINLOCK : LOCK_MODE_HQLOCK;
+		}
+	}
+
+	return LOCK_NO_MODE;
+}
+
+static inline hqlock_mode_t set_mode_hqlock(struct qspinlock *lock, int val, u16 lock_id)
+{
+	return set_lock_mode(lock, val, lock_id);
+}
+
+static inline hqlock_mode_t set_mode_qspinlock(struct qspinlock *lock, int val)
+{
+	return set_lock_mode(lock, val, LOCK_ID_NONE);
+}
+
+/* Dynamic lock-mode conditions */
+static inline bool is_mode_hqlock(int val)
+{
+	return decode_lock_mode(val) == LOCK_MODE_HQLOCK;
+}
+
+static inline bool is_mode_qspinlock(int val)
+{
+	return decode_lock_mode(val) == LOCK_MODE_QSPINLOCK;
+}
+
+enum meta_status {
+	META_CONFLICT = 0,
+	META_GRABBED,
+	META_SHARED,
+};
+
+static inline enum meta_status grab_lock_meta(struct qspinlock *lock, u32 lock_id, u32 *seq)
+{
+	int nid, seq_counter;
+	struct numa_queue *queue;
+	struct qspinlock *old = READ_ONCE(meta_pool[lock_id].lock_ptr);
+
+	if (old && old != lock)
+		return META_CONFLICT;
+
+	if (old && old == lock)
+		return META_SHARED;
+
+	old = cmpxchg_acquire(&meta_pool[lock_id].lock_ptr, NULL, lock);
+	if (!old)
+		goto init_meta;
+
+	/* Hash-conflict */
+	if (old != lock)
+		return META_CONFLICT;
+
+	return META_SHARED;
+init_meta:
+	/*
+	 * Update allocations counter and set it to per-NUMA queues
+	 * to prevent upcomming contenders from parking on deallocated queues
+	 */
+	seq_counter = atomic_inc_return_relaxed(&meta_pool[lock_id].seq_counter);
+
+	/* Very unlikely we can overflow */
+	if (unlikely(seq_counter == 0))
+		seq_counter = atomic_inc_return_relaxed(&meta_pool[lock_id].seq_counter);
+
+	for_each_online_node(nid) {
+		queue = &queue_table[nid][lock_id];
+		WRITE_ONCE(queue->seq_counter, (u32)seq_counter);
+	}
+
+	*seq = seq_counter;
+	return META_GRABBED;
+}
+
+/*
+ * Try to setup current lock mode:
+ *
+ * LOCK_MODE_HQLOCK or fallback to default LOCK_MODE_QSPINLOCK
+ * if there's hash conflict with another lock in the system.
+ *
+ * In general the setup consists of grabbing lock-related metadata and
+ * publishing the mode in the global lock variable.
+ *
+ * For quick meta-lookup the pointer hashing is used.
+ *
+ * To identify "occupied/free" metadata record, we use "meta->lock_ptr"
+ * which is set to corresponding spinlock lock pointer or "NULL".
+ *
+ * The action sequence from initial state is the following:
+ *
+ * "Find lock-meta by hash" => "Occupy lock-meta" => publish "LOCK_MODE_HQLOCK" in
+ * global lock variable.
+ *
+ */
+static inline
+hqlock_mode_t setup_lock_mode(struct qspinlock *lock, u16 lock_id, u32 *meta_seq_counter)
+{
+	hqlock_mode_t mode;
+
+	do {
+		enum meta_status status;
+		int val = atomic_read(&lock->val);
+
+		if (is_mode_hqlock(val)) {
+			struct lock_metadata *lock_meta = get_meta(lock_id);
+			/*
+			 * The lock is currently in LOCK_MODE_HQLOCK, we need to make sure the
+			 * associated metadata isn't used by another lock.
+			 *
+			 * In the meanwhile several situations can occur:
+			 *
+			 * [Case 1] Another lock using the meta (hash-conflict)
+			 *
+			 * If "release + reallocate" of the meta happenned in the meanwhile,
+			 * we're guaranteed to observe lock-mode change in the "lock->val",
+			 * due to the following event ordering:
+			 *
+			 * [release_lock_meta]
+			 *	Clear lock mode in "lock->val", so we wouldn't
+			 *	observe LOCK_MODE_HQLOCK mode.
+			 *	=>
+			 *        [setup_lock_mode]
+			 *	    Update lock->seq_counter
+			 *
+			 * [Case 2] For exact same lock, some contender did "release + reallocate" of the meta
+			 *
+			 * Either We'll get newly set "seq_counter", or in the worst case, we'll get
+			 * outdated "seq_counter" fail in the CAS(queue) in the caller function.
+			 *
+			 * [Case 3] Meta is free, nobody using it
+			 * [Case 4] The lock mode is changed to LOCK_MODE_QSPINLOCK.
+			 */
+			int seq_counter = atomic_read(&lock_meta->seq_counter);
+
+			/*
+			 * "seq_counter" and "lock->val" should be read in program order.
+			 * Otherwise we might observe "seq_counter" updated on-behalf another lock.
+			 * Paired with smp_wmb() in set_lock_mode().
+			 */
+			smp_rmb();
+			val = atomic_read(&lock->val);
+
+			if (is_mode_hqlock(val)) {
+				*meta_seq_counter = (u32)seq_counter;
+				return LOCK_MODE_HQLOCK;
+			}
+			/*
+			 * [else] Here it can be 2 options:
+			 *
+			 * 1. Lock-meta is free, and nobody using it.
+			 *    In this case, we need to try occupying the meta and
+			 *    publish lock-mode LOCK_MODE_HQLOCK again.
+			 *
+			 * 2. Lock mode transitioned to LOCK_MODE_QSPINLOCK mode.
+			 */
+			continue;
+		} else if (is_mode_qspinlock(val)) {
+			return LOCK_MODE_QSPINLOCK;
+		}
+
+		/*
+		 * Trying to get temporary metadata "weak" ownership,
+		 * Three situations might happen:
+		 *
+		 * 1. Metadata isn't used by anyone
+		 *    Just take the ownership.
+		 *
+		 * 2. Metadata is already grabbed by one of the lock contenders.
+		 *
+		 * 3. Hash conflict: metadata is owned by another lock
+		 *    Give up, fallback to LOCK_MODE_QSPINLOCK.
+		 */
+		status = grab_lock_meta(lock, lock_id, meta_seq_counter);
+		if (status == META_SHARED) {
+			/*
+			 * Someone started publishing lock_id for us:
+			 * 1. We can catch the "LOCK_MODE_HQLOCK" mode quickly
+			 * 2. We can loop several times before we'll see "LOCK_MODE_HQLOCK" mode set.
+			 * (lightweight check)
+			 * 3. Another contender might be able to relase lock meta meanwhile.
+			 * Either we catch it in above "seq_counter" check, or we'll grab
+			 * lock meta first and try publishing lock_id.
+			 */
+			continue;
+		}
+
+		/* Setup the lock-mode */
+		if (status == META_GRABBED)
+			mode = set_mode_hqlock(lock, val, lock_id);
+		else if (status == META_CONFLICT)
+			mode = set_mode_qspinlock(lock, val);
+		else
+			BUG_ON(1);
+		/*
+		 * If we grabbed the meta but were unable to publish LOCK_MODE_HQLOCK
+		 * release it, just by resetting the pointer.
+		 */
+		if (status == META_GRABBED && mode != LOCK_MODE_HQLOCK) {
+			smp_store_release(&meta_pool[lock_id].lock_ptr, NULL);
+		}
+	} while (mode == LOCK_NO_MODE);
+
+	return mode;
+}
+
+static inline void release_lock_meta(struct qspinlock *lock,
+					struct lock_metadata *meta,
+				     struct numa_qnode *qnode)
+{
+	int nid;
+	struct numa_queue *queue;
+	bool cleared = false;
+	u32 upd_val = _Q_LOCKTYPE_HQ | _Q_LOCKED_VAL;
+	u16 lock_id = qnode->lock_id;
+	int seq_counter = atomic_read(&meta->seq_counter);
+
+	/*
+	 * Firstly, go across per-NUMA queues and set seq counter to 0,
+	 * it will prevent possible contenders, which haven't even queued locally,
+	 * from using already deoccupied metadata.
+	 *
+	 * We need to perform counter reset with CAS,
+	 * because local contenders (we didn't see them while try_clear_lock_tail and try_clear_queue_tail)
+	 * may have appeared while we were coming that point.
+	 *
+	 * If any CAS is not successful, it means someone has already queued locally,
+	 * in that case we should restore usability of all local queues
+	 * and return seq counter to every per-NUMA queue.
+	 *
+	 * If all CASes are successful, nobody will queue on this metadata's queues,
+	 * and we can free it and allow other locks to use it.
+	 */
+
+	/*
+	 * Before metadata release read every queue tail,
+	 * if we have at least one contender, don't do CASes and leave
+	 * (Reads are much faster and also prefetch local queue's cachelines)
+	 */
+	for_each_online_node(nid) {
+		struct numa_queue *queue = get_queue(lock_id, nid + 1);
+
+		if (READ_ONCE(queue->tail) != 0)
+			return;
+	}
+
+	for_each_online_node(nid) {
+		struct numa_queue *queue = get_queue(lock_id, nid + 1);
+
+		if (cmpxchg_relaxed(&queue->seq_counter_tail, encode_tc(0, seq_counter), 0)
+			!= encode_tc(0, seq_counter))
+			/* Some contender arrived - rollback */
+			goto do_rollback;
+	}
+
+	/*
+	 * We need wait until pending is gone.
+	 * Otherwise, clearing pending can erase a mode we will set here
+	 */
+	while (!cleared) {
+		u32 old_lock_val = atomic_cond_read_relaxed(&lock->val, !(VAL & _Q_PENDING_VAL));
+
+		cleared = atomic_try_cmpxchg_relaxed(&lock->val,
+				&old_lock_val, upd_val | (old_lock_val & _Q_TAIL_MASK));
+	}
+
+	/*
+	 * guarantee current seq counter is erased from every local queue
+	 * and lock mode has been updated before another lock can use metadata
+	 */
+	smp_store_release(&meta_pool[qnode->lock_id].lock_ptr, NULL);
+	return;
+
+do_rollback:
+	for_each_online_node(nid) {
+		queue = get_queue(lock_id, nid + 1);
+		WRITE_ONCE(queue->seq_counter, seq_counter);
+	}
+}
+
+/*
+ * Call it if we observe LOCK_MODE_QSPINLOCK.
+ *
+ * We can do generic xchg_tail in this case,
+ * if lock's mode has already been changed, we will get _Q_LOCK_INVALID_TAIL.
+ *
+ * If we have such a situation, we perform CAS cycle
+ * to restore _Q_LOCK_INVALID_TAIL or wait until lock's mode is LOCK_MODE_QSPINLOCK.
+ *
+ * All upcomming confused contenders will see valid tail.
+ * We will remember the last one before successful CAS and put its tail in local queue.
+ * During handoff we will notify them about mode change via qnext->wrong_fallback_tail
+ */
+static inline bool try_update_tail_qspinlock_mode(struct qspinlock *lock, u32 tail, u32 *old_tail, u32 *next_tail)
+{
+	/*
+	 * next_tail may be tail or last cpu from previous unsuccessful call
+	 * (highly unlikely, but still)
+	 */
+	u32 xchged_tail = xchg_tail(lock, *next_tail);
+
+	if (likely(xchged_tail != _Q_LOCK_INVALID_TAIL)) {
+		*old_tail = xchged_tail;
+		return true;
+	}
+
+	/*
+	 * If we got _Q_LOCK_INVALID_TAIL, it means lock was not in LOCK_MODE_QSPINLOCK.
+	 * In this case we should restore _Q_LOCK_INVALID_TAIL
+	 * and remember next contenders that got confused.
+	 * Later we will update lock's or local queue's tail to the last contender seen here.
+	 */
+	u32 val = atomic_read(&lock->val);
+
+	bool fixed = false;
+
+	while (!fixed) {
+		if (decode_lock_mode(val) == LOCK_MODE_QSPINLOCK) {
+			*old_tail = 0;
+			return true;
+		}
+
+		/*
+		 * CAS is needed here to catch possible lock mode change
+		 * from LOCK_MODE_HQLOCK to LOCK_MODE_QSPINLOCK in the meanwhile.
+		 * Thus preventing from publishing _Q_LOCK_INVALID_TAIL
+		 * when LOCK_MODE_QSPINLOCK is enabled.
+		 */
+		fixed = atomic_try_cmpxchg_relaxed(&lock->val, &val, _Q_LOCK_INVALID_TAIL |
+				(val & (_Q_LOCKED_PENDING_MASK | _Q_LOCK_TYPE_MODE_MASK)));
+	}
+
+	if ((val & _Q_TAIL_MASK) != tail)
+		*next_tail = val & _Q_TAIL_MASK;
+
+	return false;
+}
+
+/*
+ * Call it if we observe LOCK_MODE_HQLOCK or LOCK_NO_MODE in the lock.
+ *
+ * Actions performed:
+ * - Call setup_lock_mode to set or read lock's mode,
+ *   read metadata's sequential counter for valid local queueing
+ * - CAS on union of local tail and meta_seq_counter
+ *   to guarantee metadata usage correctness.
+ *   Repeat from the beginning if fail.
+ * - If we are the first local contender,
+ *   update global tail with our NUMA node
+ */
+static inline bool try_update_tail_hqlock_mode(struct qspinlock *lock, u16 lock_id,
+				struct numa_qnode *qnode, u32 tail, u32 *next_tail, u32 *old_tail)
+{
+	u32 meta_seq_counter;
+	hqlock_mode_t mode;
+
+	struct numa_queue *queue;
+	u64 old_counter_tail;
+	bool updated_queue_tail = false;
+
+re_setup:
+	mode = setup_lock_mode(lock, lock_id, &meta_seq_counter);
+
+	if (mode == LOCK_MODE_QSPINLOCK)
+		return false;
+
+	queue = get_local_queue(qnode);
+
+	/*
+	 * While queueing locally, perform CAS cycle
+	 * on union of tail and meta_seq_counter.
+	 *
+	 * meta_seq_counter is taken from the lock metadata while allocation,
+	 * it's updated every time it's used by a next lock.
+	 * It shows that queue is used correctly
+	 * and metadata hasn't been deoccupied before we queued locally.
+	 */
+	old_counter_tail = READ_ONCE(queue->seq_counter_tail);
+
+	while (!updated_queue_tail &&
+		   decode_tc_counter(old_counter_tail) == meta_seq_counter) {
+		updated_queue_tail =
+			try_cmpxchg_relaxed(&queue->seq_counter_tail, &old_counter_tail,
+				encode_tc((*next_tail) >> _Q_TAIL_OFFSET, meta_seq_counter));
+	}
+
+	/* queue->seq_counter changed */
+	if (!updated_queue_tail)
+		goto re_setup;
+
+	/*
+	 * The condition means we tried to perform generic tail update in try_update_tail_qspinlock_mode,
+	 * but before we did it, lock type was changed.
+	 * Moreover, some contenders have come after us in LOCK_MODE_QSPINLOCK,
+	 * during handoff we must notify them that they are set in LOCK_MODE_HQLOCK in our node's local queue
+	 */
+	if (unlikely(*next_tail != tail))
+		qnode->wrong_fallback_tail = *next_tail >> _Q_TAIL_OFFSET;
+
+	*old_tail = decode_tc_tail(old_counter_tail);
+
+	if (!(*old_tail)) {
+		u16 prev_node_id;
+
+		init_queue(qnode);
+		prev_node_id = append_node_queue(lock_id, qnode->numa_node);
+		*old_tail = prev_node_id ? Q_NEW_NODE_QUEUE : 0;
+	} else {
+		*old_tail <<= _Q_TAIL_OFFSET;
+	}
+
+	return true;
+}
-- 
2.34.1


