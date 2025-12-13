Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28370D5B160
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 18:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C616B0008; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB49B6B0006; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D626B000A; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D05B6B0007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCA5B5AC86
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 18:56:17 +0000 (UTC)
X-FDA: 84215353194.18.1490958
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B0E6100006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 18:56:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=gVZSewU1;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765652176; a=rsa-sha256;
	cv=none;
	b=lGK75UpZO1OVSi01HlzWzEdg0xbbZDKlIXYirjijc25Q5qbt1nyeaN20UVcD34UwH3X0Tb
	I8cnhfReYCPvC368r+cUiNcUuCC5SXEdXNV/I+JQM46CEXaeAz0+n0vjhlb5ljPz9kpoMJ
	ZIWiIN2/jmeDNiH4s1ASpDE+606sZIY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=gVZSewU1;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765652176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0v1dFF/8ZWaqYC+CYbnbSe73LklzL2KNepA8cxgVoFY=;
	b=6K8ZgYLBYNHEUbheWULVE2imv2bOrHUTII17Vuugy5utF07A80VYR9qLU6cywVZvFs8s37
	hSaDGZPEXr3PURS7eCr64I6rt/GI6AGcTjqhjqaRCFSLW32xMTR96xTJWoaADK5BFlB4ee
	zIQOzOtLUrKMzyOjc4iPdYvE/chXZ6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1765652175;
	bh=0v1dFF/8ZWaqYC+CYbnbSe73LklzL2KNepA8cxgVoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVZSewU1hdClBTcZwfZpdv9qRwS6B+hFzhMuBnWibjUouPKm3bmpZI1qNY387iY7s
	 D17AkrueDHJxIKbKVW5oTG90AUlqvl7QNaIlF6qBxR9ySAAoFdD2Z2frlNvtIfXae8
	 WrrxrgY6+gj7LB1OFCg1zDvlhmeeo7fx0sJKr4DLV5nqoMadcTabn5K1ENTtTnJfPl
	 DMjJQCO0udaHs7qwlMKYRrLS99BijKIq/eyM2sToo5QQVgQ3x6TILzu7E//dJSgRDn
	 DBu7wBNUDMF84pVB39OWqr61m/fEd4tN7MNyzwjofemQRLTLKgMgdmPg3K7ScF92X1
	 iU+qK9E5t7fZg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dTFsV6BHXzZXd;
	Sat, 13 Dec 2025 13:56:14 -0500 (EST)
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
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v10 1/3] lib: Introduce hierarchical per-cpu counters
Date: Sat, 13 Dec 2025 13:56:06 -0500
Message-Id: <20251213185608.3418096-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
References: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B0E6100006
X-Rspamd-Server: rspam04
X-Stat-Signature: bfxrrwos3ctex1dugzm8x6d9ysx5ei6f
X-HE-Tag: 1765652175-298437
X-HE-Meta: U2FsdGVkX1/da7rB871P4rvoWWXRJHn7ZefK8nMaqCt/M+egvh/i/MJDHo0yn7qqQuqjo4yx1H5qd2dTWebUtYGqRV6fi9N4eIWl2MRbBLt294cUx0dC3ebkwUifjy+9uncNHkdngzzIPrX9Nhh1uarCGDovGPxPC7IpYKUXBXbgdZnR0ExjU7IpM7j8F51gNNfhtBHYMgV3agyR8rDbJ212ehA+Gt80Xm6dGhxJMTM0ZvTmsE00Fp+j1F/9JzKhq0rr2fxhE5St1lkVWYxRENbdcp/+Nc+ToY00hX/WsYbGlvpWQV35ebexMpv5qYLpWc4b+O0ieEv7yPsl22cwa0EiGKObvS7YC+acTDqo5e4+hJ5ubxgFjNUHgXhXmciqGsscvi8QlW8pWL7ZkYBkKxFAiWWIgznXiPQ4sGkdIU/4/ZqD3eypTdGKAZW4jDrc/m46Pbhysr0COwlP1JurPj7uAyvNBnlvWORNxdEW/bURYF6N9wkXrwTGchAnn2MJ+tt/s2bPhIRDkGaXpn095dD8/xp9hLmOwlk691o2j7aaOu+KyhiiKgGYzufWXYDtt9xiFYXEoxiGbyh90L+KR4W56S7+vvQC0q7JOlHkDK/onRZ2jyMBvz48YH53Zb1ZmSh1Z5YGjzQ1zvNnROgWfoDyGMq9WDcZJSDKmKQEH4tl2BTYVzCxyK4ADK7rBRVseuiAwZjDbHCH7w4i1Dv8Ga8UX7726U0YazxMjnrPTFIBrDYlBLV+ENY1sZamOKt7ODp3CnVrZXgRg25OUNXPePtQRLSW0/h6IMm+77MX0dx17VTWhgfVL2rMKo8RapL0XcrCTvcJB2dUi+5lyTp9AcijWkAd4sV87iBz1j9mUz/6NrdvCBwK2PP1nY8Zs29/VUS0ErpismrWrKgnwDgeMspdRi4uDRKXPp+vMpXgq9CAdhQ2ZfSuLl6xYEXYGF/VHsCu5nhss60gZrFg/mN
 +P7yTTXQ
 sFjnU5Xu1fVaWjb4zQuFjoBBLmY2RP2BC2PT4vmnOH/4dSIFF1DoNHpHdx3+vioT3n97PVDqPXnZ1j9b3+TZ7EUrvvBM9OCnMarV4ZHytToDcFYqe4HGnTrMT3vN6Df8wefq6pwrv1poSlM2cg+CezlbOAbMzcLg57P8rTGGhYrFrCXKKtPm/Ej6QVnrv/pHaF3LzcNhQ0z4WeIx92MrLqnOmjGGGWLr9CLo/PcIpG+25Ip4i1/sQyhOXeZ+s5M+5P7yymDvi2a85tPQEY0vQn4ptCuiq28auDRhAlgaGgd5I70QL42b9pZAykJs9rfGfzHmT+Elcq2aBbNPk6WfQa8e7pHdicP7v7GJtxclW7yvktnb1jHNvgM/cM2wnkZ7Ct3D9Nsid16khFp626SflWQT208ZWePizd4XPJtZgXCirr1yURM859kRIHQncgPCOhczKKI5l2p79L1hiJEGxglL/aNj/TboxBCyvh+VZINpEqNwLNxOfMnpSM+U4fUo5AhwM5+lfswx37VORS8oMLI2qhC8cR5tmxyE4TMV8RQvoaUcphdDaqgvFaa9xnG88+/nCOW/x/P0rsRPdU6+FVRcvCurUPu3Wjc7WXEp/RXAVkpIyAmGSRUzqxKOa7ardEJJkHKwY0IP9zLB4BXarlbZSQm+h+adft3iebwnqFshMI9oFuDpymMNCR/cIkO8euIyFxaNnCI1zytTi3YMuWzbn0ZyB1U48xheUP7VofUuyJilKUh5nI9d743mWAu7f2EOoAh1g72Z/2j/XCRuP/cTZhVPnwKu8vYU4fN7uEv5/++Ab1yYTk5gmLHmLql+T+YBGeZl7cbIcUxuvzItrUbbA7EQ4OCAFhrMgGV954MiG+8kqWfJXAfZfqDv7Xu0ut4K8VC9PNKDRhxjit3Rdw47Qz8yhqt1r6b7AuFFweXfQusTeft1lQ8L2dmUyb714NX6lU+W+Hu6/fyQw5DaskVOjjChO
 QCOCXrk9
 uQAFrKKyWXervqorRbwhavRO/ceCc5DKIrfkP6djxfBUWQ/+/iVaxJG8nPXfSFTTwkCab8JuddcT9g7/70R0ytj51uX0IHDydIvpPJJkdEvHPZ+d75QstA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Motivation

The purpose of this hierarchical split-counter scheme is to:

- Minimize contention when incrementing and decrementing counters,
- Provide fast access to a sum approximation,
- Provide a sum approximation with an acceptable accuracy level when
  scaling to many-core systems.
- Provide approximate and precise comparison of two counters, and
  between a counter and a value.

It aims at fixing the per-mm RSS tracking which has become too
inaccurate for OOM killer purposes on large many-core systems [1].

* Design

The hierarchical per-CPU counters propagate a sum approximation through
a N-way tree. When reaching the batch size, the carry is propagated
through a binary tree which consists of logN(nr_cpu_ids) levels. The
batch size for each level is twice the batch size of the prior level.

Example propagation diagram with 8 cpus through a binary tree:

Level 0:  0    1    2    3    4    5    6    7
          |   /     |   /     |   /     |   /
          |  /      |  /      |  /      |  /
          | /       | /       | /       | /
Level 1:  0         1         2         3
          |       /           |       /
          |    /              |    /
          | /                 | /
Level 2:  0                   1
          |               /
          |         /
          |   /
Level 3:  0

For a binary tree, the maximum inaccuracy is bound by:
   batch_size * log2(nr_cpus) * nr_cpus
which evolves with O(n*log(n)) as the number of CPUs increases.

For a N-way tree, the maximum inaccuracy can be pre-calculated
based on the the N-arity of each level and the batch size.

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
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
Changes since v9:
- Introduce kerneldoc documentation.
- Document structure fields.
- Remove inline from percpu_counter_tree_add().
- Reject batch_size==1 which makes no sense.
- Fix copy-paste bug in percpu_counter_tree_precise_compare()
  (wrong inequality comparison).
- Rename "inaccuracy" to "accuracy", which makes it easier to
  document.
- Track accuracy limits more precisely. In two's complement
  signed integers, the range before a n-bit underflow is one
  unit larger than the range before a n-bit overflow. This sums
  for all the counters within the tree. Therefore the "under"
  vs "over" accuracy is not symmetrical.

Changes since v8:
- Remove migrate guard from the fast path. It does not
  matter through which path the carry is propagated up
  the tree.
- Rebase on top of v6.18-rc6.
- Introduce percpu_counter_tree_init_many and
  percpu_counter_tree_destroy_many APIs.
- Move tree items allocation to the caller.
- Introduce percpu_counter_tree_items_size().
- Move percpu_counter_tree_subsystem_init() call before mm_core_init()
  so percpu_counter_tree_items_size() is initialized before it is used.

Changes since v7:
- Explicitly initialize the subsystem from start_kernel() right
  after mm_core_init() so it is up and running before the creation of
  the first mm at boot.
- Remove the module.h include which is not needed with the explicit
  initialization.
- Only consider levels>0 items for order={0,1} nr_items. No
  functional change except to allocate only the amount of memory
  which is strictly needed.
- Introduce positive precise sum API to handle a scenario where an
  unlucky precise sum iteration would hit negative counter values
  concurrently with counter updates.

Changes since v5:
- Introduce percpu_counter_tree_approximate_sum_positive.
- Introduce !CONFIG_SMP static inlines for UP build.
- Remove percpu_counter_tree_set_bias from the public API and make it
  static.

Changes since v3:
- Add gfp flags to init function.

Changes since v2:
- Introduce N-way tree to reduce tree depth on larger systems.

Changes since v1:
- Remove percpu_counter_tree_precise_sum_unbiased from public header,
  make this function static,
- Introduce precise and approximate comparisons between two counters,
- Reorder the struct percpu_counter_tree fields,
- Introduce approx_sum field, which points to the approximate sum
  for the percpu_counter_tree_approximate_sum() fast path.
---
 include/linux/percpu_counter_tree.h | 242 ++++++++++
 init/main.c                         |   2 +
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 705 ++++++++++++++++++++++++++++
 4 files changed, 950 insertions(+)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..0daf09e08111
--- /dev/null
+++ b/include/linux/percpu_counter_tree.h
@@ -0,0 +1,242 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> */
+
+#ifndef _PERCPU_COUNTER_TREE_H
+#define _PERCPU_COUNTER_TREE_H
+
+#include <linux/preempt.h>
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+#ifdef CONFIG_SMP
+
+struct percpu_counter_tree_level_item {
+	atomic_t count;			/*
+					 * Count the number of carry fort this tree item.
+					 * The carry counter is kept at the order of the
+					 * carry accounted for at this tree level.
+					 */
+} ____cacheline_aligned_in_smp;
+
+struct percpu_counter_tree {
+	/* Fast-path fields. */
+	unsigned int __percpu *level0;	/* Pointer to per-CPU split counters (tree level 0). */
+	unsigned int level0_bit_mask;	/* Bit mask to apply to detect carry propagation from tree level 0. */
+	union {
+		unsigned int *i;	/* Approximate sum for single-CPU topology. */
+		atomic_t *a;		/* Approximate sum for SMP topology.  */
+	} approx_sum;
+	int bias;			/* Bias to apply to counter precise and approximate values. */
+
+	/* Slow-path fields. */
+	struct percpu_counter_tree_level_item *items;	/* Array of tree items for levels 1 to N. */
+	unsigned int batch_size;	/*
+					 * The batch size is the increment step at level 0 which
+					 * triggers a carry propagation. The batch size is required
+					 * to be greater than 1, and a power of 2.
+					 */
+	/*
+	 * The tree approximate sum is guaranteed to be within this accuracy range:
+	 * (precise_sum - approx_accuracy_range.under) <= approx_sum <= (precise_sum + approx_accuracy_range.over).
+	 * This accuracy is derived from the hardware topology and the tree batch_size.
+	 * The "under" accuracy is larger than the "over" accuracy because the negative range of a
+	 * two's complement signed integer is one unit larger than the positive range. This delta
+	 * is summed for each tree item, which leads to a significantly larger "under" accuracy range
+	 * compared to the "over" accuracy range.
+	 */
+	struct {
+		unsigned int under;
+		unsigned int over;
+	} approx_accuracy_range;
+};
+
+size_t percpu_counter_tree_items_size(void);
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags);
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned int batch_size, gfp_t gfp_flags);
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counter, unsigned int nr_counters);
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter);
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, int inc);
+int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter);
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, int v);
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, int v);
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v);
+void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *counter,
+						    unsigned int *under, unsigned int *over);
+int percpu_counter_tree_subsystem_init(void);
+
+/**
+ * percpu_counter_tree_approximate_sum() - Return approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the approximate sum is fast, but it is only accurate within
+ * the bounds delimited by percpu_counter_tree_approximate_accuracy_range().
+ * This is meant to be used when speed is preferred over accuracy.
+ *
+ * Return: The current approximate counter sum.
+ */
+static inline
+int percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	unsigned int v;
+
+	if (!counter->level0_bit_mask)
+		v = READ_ONCE(*counter->approx_sum.i);
+	else
+		v = atomic_read(counter->approx_sum.a);
+	return (int) (v + (unsigned int)READ_ONCE(counter->bias));
+}
+
+#else	/* !CONFIG_SMP */
+
+struct percpu_counter_tree_level_item;
+
+struct percpu_counter_tree {
+	atomic_t count;
+};
+
+static inline
+size_t percpu_counter_tree_items_size(void)
+{
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags)
+{
+	for (unsigned int i = 0; i < nr_counters; i++)
+		atomic_set(&counters[i].count, 0);
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned int batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
+}
+
+static inline
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counter, unsigned int nr_counters)
+{
+}
+
+static inline
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+}
+
+static inline
+int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return atomic_read(&counter->count);
+}
+
+static inline
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	int count_a = percpu_counter_tree_precise_sum(a),
+	    count_b = percpu_counter_tree_precise_sum(b);
+
+	if (count_a == count_b)
+		return 0;
+	if (count_a < count_b)
+		return -1;
+	return 1;
+}
+
+static inline
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	int count = percpu_counter_tree_precise_sum(counter);
+
+	if (count == v)
+		return 0;
+	if (count < v)
+		return -1;
+	return 1;
+}
+
+static inline
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	return percpu_counter_tree_precise_compare(a, b);
+}
+
+static inline
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	return percpu_counter_tree_precise_compare_value(counter, v);
+}
+
+static inline
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v)
+{
+	atomic_set(&counter->count, v);
+}
+
+static inline
+void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *counter,
+						    unsigned int *under, unsigned int *over)
+{
+	*under = 0;
+	*over = 0;
+}
+
+static inline
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, int inc)
+{
+	atomic_add(inc, &counter->count);
+}
+
+static inline
+int percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum(counter);
+}
+
+static inline
+int percpu_counter_tree_subsystem_init(void)
+{
+	return 0;
+}
+
+#endif	/* CONFIG_SMP */
+
+/**
+ * percpu_counter_tree_approximate_sum_positive() - Return a positive approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return an approximate counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive approximate counter sum.
+ */
+static inline
+int percpu_counter_tree_approximate_sum_positive(struct percpu_counter_tree *counter)
+{
+	int v = percpu_counter_tree_approximate_sum(counter);
+	return v > 0 ? v : 0;
+}
+
+/**
+ * percpu_counter_tree_precise_sum_positive() - Return a positive precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return a precise counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive precise counter sum.
+ */
+static inline
+int percpu_counter_tree_precise_sum_positive(struct percpu_counter_tree *counter)
+{
+	int v = percpu_counter_tree_precise_sum(counter);
+	return v > 0 ? v : 0;
+}
+
+#endif  /* _PERCPU_COUNTER_TREE_H */
diff --git a/init/main.c b/init/main.c
index 07a3116811c5..8487489b9d00 100644
--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,7 @@
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
+#include <linux/percpu_counter_tree.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -968,6 +969,7 @@ void start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
+	percpu_counter_tree_subsystem_init();
 	mm_core_init();
 	maple_tree_init();
 	poking_init();
diff --git a/lib/Makefile b/lib/Makefile
index 1ab2c4be3b66..767dc178a55c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -179,6 +179,7 @@ obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
 obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
 obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
+obj-$(CONFIG_SMP) += percpu_counter_tree.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += compat_audit.o
 
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
new file mode 100644
index 000000000000..9b7ae7df5530
--- /dev/null
+++ b/lib/percpu_counter_tree.c
@@ -0,0 +1,705 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+/*
+ * Split Counters With Tree Approximation Propagation
+ *
+ * * Propagation diagram when reaching batch size thresholds (± batch size):
+ *
+ * Example diagram for 8 CPUs:
+ *
+ * log2(8) = 3 levels
+ *
+ * At each level, each pair propagates its values to the next level when
+ * reaching the batch size thresholds.
+ *
+ * Counters at levels 0, 1, 2 can be kept on a single byte ([-128 .. +127] range),
+ * although it may be relevant to keep them on 32-bit counters for
+ * simplicity. (complexity vs memory footprint tradeoff)
+ *
+ * Counter at level 3 can be kept on a 32-bit counter.
+ *
+ * Level 0:  0    1    2    3    4    5    6    7
+ *           |   /     |   /     |   /     |   /
+ *           |  /      |  /      |  /      |  /
+ *           | /       | /       | /       | /
+ * Level 1:  0         1         2         3
+ *           |       /           |       /
+ *           |    /              |    /
+ *           | /                 | /
+ * Level 2:  0                   1
+ *           |               /
+ *           |         /
+ *           |   /
+ * Level 3:  0
+ *
+ * * Approximation accuracy:
+ *
+ * BATCH(level N): Level N batch size.
+ *
+ * Example for BATCH(level 0) = 32.
+ *
+ * BATCH(level 0) =  32
+ * BATCH(level 1) =  64
+ * BATCH(level 2) = 128
+ * BATCH(level N) = BATCH(level 0) * 2^N
+ *
+ *            per-counter     global
+ *            accuracy        accuracy
+ * Level 0:   [ -32 ..  +31]  ±256  (8 * 32)
+ * Level 1:   [ -64 ..  +63]  ±256  (4 * 64)
+ * Level 2:   [-128 .. +127]  ±256  (2 * 128)
+ * Total:      ------         ±768  (log2(nr_cpu_ids) * BATCH(level 0) * nr_cpu_ids)
+ *
+ * Note that the global accuracy can be calculated more precisely
+ * by taking into account that the positive accuracy range is
+ * 31 rather than 32.
+ *
+ * -----
+ *
+ * Approximate Sum Carry Propagation
+ *
+ * Let's define a number of counter bits for each level, e.g.:
+ *
+ * log2(BATCH(level 0)) = log2(32) = 5
+ *
+ *               nr_bit        value_mask                      range
+ * Level 0:      5 bits        v                             0 ..  +31
+ * Level 1:      1 bit        (v & ~((1UL << 5) - 1))        0 ..  +63
+ * Level 2:      1 bit        (v & ~((1UL << 6) - 1))        0 .. +127
+ * Level 3:     25 bits       (v & ~((1UL << 7) - 1))        0 .. 2^32-1
+ *
+ * Note: Use a full 32-bit per-cpu counter at level 0 to allow precise sum.
+ *
+ * Note: Use cacheline aligned counters at levels above 0 to prevent false sharing.
+ *       If memory footprint is an issue, a specialized allocator could be used
+ *       to eliminate padding.
+ *
+ * Example with expanded values:
+ *
+ * counter_add(counter, inc):
+ *
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = percpu_add_return(counter @ Level 0, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b00011111);  // Clear used bits
+ *                 // xor bit 5: underflow
+ *                 if ((inc ^ orig ^ res) & 0b00100000)
+ *                         inc -= 0b00100000;
+ *         } else {
+ *                 inc &= ~0b00011111;           // Clear used bits
+ *                 // xor bit 5: overflow
+ *                 if ((inc ^ orig ^ res) & 0b00100000)
+ *                         inc += 0b00100000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = atomic_add_return(counter @ Level 1, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b00111111);  // Clear used bits
+ *                 // xor bit 6: underflow
+ *                 if ((inc ^ orig ^ res) & 0b01000000)
+ *                         inc -= 0b01000000;
+ *         } else {
+ *                 inc &= ~0b00111111;           // Clear used bits
+ *                 // xor bit 6: overflow
+ *                 if ((inc ^ orig ^ res) & 0b01000000)
+ *                         inc += 0b01000000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = atomic_add_return(counter @ Level 2, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b01111111);  // Clear used bits
+ *                 // xor bit 7: underflow
+ *                 if ((inc ^ orig ^ res) & 0b10000000)
+ *                         inc -= 0b10000000;
+ *         } else {
+ *                 inc &= ~0b01111111;           // Clear used bits
+ *                 // xor bit 7: overflow
+ *                 if ((inc ^ orig ^ res) & 0b10000000)
+ *                         inc += 0b10000000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         atomic_add(counter @ Level 3, inc);
+ */
+
+#include <linux/percpu_counter_tree.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/math.h>
+
+#define MAX_NR_LEVELS 5
+
+/*
+ * The counter configuration is selected at boot time based on the
+ * hardware topology.
+ */
+struct counter_config {
+	unsigned int nr_items;				/*
+							 * nr_items is the number of items in the tree for levels 1
+							 * up to and including the final level (approximate sum).
+							 * It excludes the level 0 per-CPU counters.
+							 */
+	unsigned char nr_levels;			/*
+							 * nr_levels is the number of hierarchical counter tree levels.
+							 * It excludes the final level (approximate sum).
+							 */
+	unsigned char n_arity_order[MAX_NR_LEVELS];	/*
+							 * n-arity of tree nodes for each level from
+							 * 0 to (nr_levels - 1).
+							 */
+};
+
+static const struct counter_config per_nr_cpu_order_config[] = {
+	[0] =	{ .nr_items = 0,	.nr_levels = 0,		.n_arity_order = { 0 } },
+	[1] =	{ .nr_items = 1,	.nr_levels = 1,		.n_arity_order = { 1 } },
+	[2] =	{ .nr_items = 3,	.nr_levels = 2,		.n_arity_order = { 1, 1 } },
+	[3] =	{ .nr_items = 7,	.nr_levels = 3,		.n_arity_order = { 1, 1, 1 } },
+	[4] =	{ .nr_items = 7,	.nr_levels = 3,		.n_arity_order = { 2, 1, 1 } },
+	[5] =	{ .nr_items = 11,	.nr_levels = 3,		.n_arity_order = { 2, 2, 1 } },
+	[6] =	{ .nr_items = 21,	.nr_levels = 3,		.n_arity_order = { 2, 2, 2 } },
+	[7] =	{ .nr_items = 21,	.nr_levels = 3,		.n_arity_order = { 3, 2, 2 } },
+	[8] =	{ .nr_items = 37,	.nr_levels = 3,		.n_arity_order = { 3, 3, 2 } },
+	[9] =	{ .nr_items = 73,	.nr_levels = 3,		.n_arity_order = { 3, 3, 3 } },
+	[10] =	{ .nr_items = 149,	.nr_levels = 4,		.n_arity_order = { 3, 3, 2, 2 } },
+	[11] =	{ .nr_items = 293,	.nr_levels = 4,		.n_arity_order = { 3, 3, 3, 2 } },
+	[12] =	{ .nr_items = 585,	.nr_levels = 4,		.n_arity_order = { 3, 3, 3, 3 } },
+	[13] =	{ .nr_items = 1173,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 2, 2 } },
+	[14] =	{ .nr_items = 2341,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 3, 2 } },
+	[15] =	{ .nr_items = 4681,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 3, 3 } },
+	[16] =	{ .nr_items = 4681,	.nr_levels = 5,		.n_arity_order = { 4, 3, 3, 3, 3 } },
+	[17] =	{ .nr_items = 8777,	.nr_levels = 5,		.n_arity_order = { 4, 4, 3, 3, 3 } },
+	[18] =	{ .nr_items = 17481,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 3, 3 } },
+	[19] =	{ .nr_items = 34953,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 4, 3 } },
+	[20] =	{ .nr_items = 69905,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 4, 4 } },
+};
+
+static const struct counter_config *counter_config;	/* Hierarchical counter configuration for the hardware topology. */
+static unsigned int nr_cpus_order,			/* Order of nr_cpu_ids. */
+		    accuracy_multiplier;		/* Calculate accuracy for a given batch size (multiplication factor). */
+
+static
+int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			       unsigned int batch_size, gfp_t gfp_flags,
+			       unsigned int __percpu *level0,
+			       struct percpu_counter_tree_level_item *items)
+{
+	/* Batch size must be greater than 1, and a power of 2. */
+	if (WARN_ON(batch_size <= 1 || (batch_size & (batch_size - 1))))
+		return -EINVAL;
+	counter->batch_size = batch_size;
+	counter->bias = 0;
+	counter->level0 = level0;
+	counter->items = items;
+	if (!nr_cpus_order) {
+		counter->approx_sum.i = per_cpu_ptr(counter->level0, 0);
+		counter->level0_bit_mask = 0;
+	} else {
+		counter->approx_sum.a = &counter->items[counter_config->nr_items - 1].count;
+		counter->level0_bit_mask = 1UL << get_count_order(batch_size);
+	}
+	/*
+	 * Each tree item signed integer has a negative range which is
+	 * one unit greater than the positive range.
+	 */
+	counter->approx_accuracy_range.under = batch_size * accuracy_multiplier;
+	counter->approx_accuracy_range.over = (batch_size - 1) * accuracy_multiplier;
+	return 0;
+}
+
+/**
+ * percpu_counter_tree_init_many() - Initialize many per-CPU counter trees.
+ * @counters: An array of @nr_counters counters to initialize.
+ *	      Their memory is provided by the caller.
+ * @items: Pointer to memory area where to store tree items.
+ *	   This memory is provided by the caller.
+ *	   Its size needs to be at least @nr_counters * percpu_counter_tree_items_size().
+ * @nr_counters: The number of counter trees to initialize
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ * 		carry propagation.
+ *		The batch size is required to be greater than 1, and a power of 2.
+ * @gfp_flags: gfp flags to pass to the per-CPU allocator.
+ *
+ * Initialize many per-CPU counter trees using a single per-CPU
+ * allocator invocation for @nr_counters counters.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags)
+{
+	void __percpu *level0, *level0_iter;
+	size_t counter_size, items_size = 0;
+	void *items_iter;
+	unsigned int i;
+	int ret;
+
+	counter_size = ALIGN(sizeof(*counters), __alignof__(*counters));
+	level0 = __alloc_percpu_gfp(nr_counters * counter_size,
+				    __alignof__(*counters), gfp_flags);
+	if (!level0)
+		return -ENOMEM;
+	if (nr_cpus_order) {
+		items_size = percpu_counter_tree_items_size();
+		memset(items, 0, items_size * nr_counters);
+	}
+	level0_iter = level0;
+	items_iter = items;
+	for (i = 0; i < nr_counters; i++) {
+		ret = __percpu_counter_tree_init(&counters[i], batch_size, gfp_flags, level0_iter, items_iter);
+		if (ret)
+			goto free_level0;
+		level0_iter += counter_size;
+		if (nr_cpus_order)
+			items_iter += items_size;
+	}
+	return 0;
+
+free_level0:
+	free_percpu(level0);
+	return ret;
+}
+
+/**
+ * percpu_counter_tree_init() - Initialize one per-CPU counter tree.
+ * @counter: Counter to initialize.
+ *	     Its memory is provided by the caller.
+ * @items: Pointer to memory area where to store tree items.
+ *	   This memory is provided by the caller.
+ *	   Its size needs to be at least percpu_counter_tree_items_size().
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ * 		carry propagation.
+ *		The batch size is required to be greater than 1, and a power of 2.
+ * @gfp_flags: gfp flags to pass to the per-CPU allocator.
+ *
+ * Initialize one per-CPU counter tree.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned int batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
+}
+
+/**
+ * percpu_counter_tree_destroy_many() - Destroy many per-CPU counter trees.
+ * @counters: Array of counters trees to destroy.
+ * @nr_counters: The number of counter trees to destroy.
+ *
+ * Release internal resources allocated for @nr_counters per-CPU counter trees.
+ */
+
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters, unsigned int nr_counters)
+{
+	free_percpu(counters->level0);
+}
+
+/**
+ * percpu_counter_tree_destroy() - Destroy one per-CPU counter tree.
+ * @counter: Counter to destroy.
+ *
+ * Release internal resources allocated for one per-CPU counter tree.
+ */
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_destroy_many(counter, 1);
+}
+
+static
+int percpu_counter_tree_carry(int orig, int res, int inc, unsigned int bit_mask)
+{
+	if (inc < 0) {
+		inc = -(-inc & ~(bit_mask - 1));
+		/*
+		 * xor bit_mask: underflow.
+		 *
+		 * If inc has bit set, decrement an additional bit if
+		 * there is _no_ bit transition between orig and res.
+		 * Else, inc has bit cleared, decrement an additional
+		 * bit if there is a bit transition between orig and
+		 * res.
+		 */
+		if ((inc ^ orig ^ res) & bit_mask)
+			inc -= bit_mask;
+	} else {
+		inc &= ~(bit_mask - 1);
+		/*
+		 * xor bit_mask: overflow.
+		 *
+		 * If inc has bit set, increment an additional bit if
+		 * there is _no_ bit transition between orig and res.
+		 * Else, inc has bit cleared, increment an additional
+		 * bit if there is a bit transition between orig and
+		 * res.
+		 */
+		if ((inc ^ orig ^ res) & bit_mask)
+			inc += bit_mask;
+	}
+	return inc;
+}
+
+/*
+ * It does not matter through which path the carry propagates up the
+ * tree, therefore there is no need to disable preemption because the
+ * cpu number is only used to favor cache locality.
+ */
+static
+void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, int inc)
+{
+	unsigned int level_items, nr_levels = counter_config->nr_levels,
+		     level, n_arity_order, bit_mask;
+	struct percpu_counter_tree_level_item *item = counter->items;
+	unsigned int cpu = raw_smp_processor_id();
+
+	WARN_ON_ONCE(!nr_cpus_order);	/* Should never be called for 1 cpu. */
+
+	n_arity_order = counter_config->n_arity_order[0];
+	bit_mask = counter->level0_bit_mask << n_arity_order;
+	level_items = 1U << (nr_cpus_order - n_arity_order);
+
+	for (level = 1; level < nr_levels; level++) {
+		atomic_t *count = &item[cpu & (level_items - 1)].count;
+		unsigned int orig, res;
+
+		res = atomic_add_return_relaxed(inc, count);
+		orig = res - inc;
+		inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
+		if (likely(!inc))
+			return;
+		item += level_items;
+		n_arity_order = counter_config->n_arity_order[level];
+		level_items >>= n_arity_order;
+		bit_mask <<= n_arity_order;
+	}
+	atomic_add(inc, counter->approx_sum.a);
+}
+
+/**
+ * percpu_counter_tree_add() - Add to a per-CPU counter tree.
+ * @counter: Counter added to.
+ * @inc: Increment value (either positive or negative).
+ *
+ * Add @inc to a per-CPU counter tree. This is a fast-path which will
+ * typically increment per-CPU counters as long as there is no carry
+ * greater or equal to the counter tree batch size.
+ */
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, int inc)
+{
+	unsigned int bit_mask = counter->level0_bit_mask, orig, res;
+
+	res = this_cpu_add_return(*counter->level0, inc);
+	orig = res - inc;
+	inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
+	if (likely(!inc))
+		return;
+	percpu_counter_tree_add_slowpath(counter, inc);
+}
+
+
+static
+int percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counter)
+{
+	unsigned int sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += *per_cpu_ptr(counter->level0, cpu);
+	return (int) sum;
+}
+
+/**
+ * percpu_counter_tree_precise_sum() - Return precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the precise sum is relatively expensive because it needs to
+ * iterate over all CPUs.
+ * This is meant to be used when accuracy is preferred over speed.
+ *
+ * Return: The current precise counter sum.
+ */
+int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(counter->bias);
+}
+
+static
+int compare_delta(int delta, unsigned int accuracy_neg, unsigned int accuracy_pos)
+{
+	if (delta >= 0) {
+		if (delta <= accuracy_pos)
+			return 0;
+		else
+			return 1;
+	} else {
+		if (-delta <= accuracy_neg)
+			return 0;
+		else
+			return -1;
+	}
+}
+
+/**
+ * percpu_counter_tree_approximate_compare - Approximated comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate an approximate comparison of two counter trees.
+ * This approximation comparison is fast, and provides an accurate
+ * answer if the counters are found to be either less than or greater
+ * than the other. However, if the approximated comparison returns
+ * 0, the counters respective sums are found to be within the two
+ * counters accuracy range.
+ *
+ * Return:
+ * * %0		- Counters @a and @b do not differ by more than the sum of their respective
+ *                accuracy ranges.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	return compare_delta(percpu_counter_tree_approximate_sum(a) - percpu_counter_tree_approximate_sum(b),
+			     a->approx_accuracy_range.over + b->approx_accuracy_range.under,
+			     a->approx_accuracy_range.under + b->approx_accuracy_range.over);
+}
+
+/**
+ * percpu_counter_tree_approximate_compare_value - Approximated comparison of a counter tree against a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate an approximate comparison of a counter tree against a given value.
+ * This approximation comparison is fast, and provides an accurate
+ * answer if the counter is found to be either less than or greater
+ * than the value. However, if the approximated comparison returns
+ * 0, the value is within the counter accuracy range.
+ *
+ * Return:
+ * * %0		- The value @v is within the accuracy range of the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	return compare_delta(v - percpu_counter_tree_approximate_sum(counter),
+			     counter->approx_accuracy_range.under,
+			     counter->approx_accuracy_range.over);
+}
+
+/**
+ * percpu_counter_tree_precise_compare - Precise comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate a precise comparison of two counter trees.
+ * As an optimization, it uses the approximate counter comparison
+ * to quickly compare counters which are far apart. Only cases where
+ * counter sums are within the accuracy range require precise counter
+ * sums.
+ *
+ * Return:
+ * * %0		- Counters are equal.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	int count_a = percpu_counter_tree_approximate_sum(a),
+	    count_b = percpu_counter_tree_approximate_sum(b);
+	unsigned int accuracy_a, accuracy_b;
+	int delta = count_a - count_b;
+	int res;
+
+	res = compare_delta(delta,
+			    a->approx_accuracy_range.over + b->approx_accuracy_range.under,
+			    a->approx_accuracy_range.under + b->approx_accuracy_range.over);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/*
+	 * The approximated comparison is within the accuracy range, therefore at least one
+	 * precise sum is needed. Sum the counter which has the largest accuracy first.
+	 */
+	if (delta >= 0) {
+		accuracy_a = a->approx_accuracy_range.under;
+		accuracy_b = b->approx_accuracy_range.over;
+	} else {
+		accuracy_a = a->approx_accuracy_range.over;
+		accuracy_b = b->approx_accuracy_range.under;
+	}
+	if (accuracy_b < accuracy_a) {
+		count_a = percpu_counter_tree_precise_sum(a);
+		res = compare_delta(count_a - count_b,
+				    b->approx_accuracy_range.under,
+				    b->approx_accuracy_range.over);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_b = percpu_counter_tree_precise_sum(b);
+	} else {
+		count_b = percpu_counter_tree_precise_sum(b);
+		res = compare_delta(count_a - count_b,
+				    a->approx_accuracy_range.over,
+				    a->approx_accuracy_range.under);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_a = percpu_counter_tree_precise_sum(a);
+	}
+	if (count_a - count_b < 0)
+		return -1;
+	if (count_a - count_b > 0)
+		return 1;
+	return 0;
+}
+
+/**
+ * percpu_counter_tree_precise_compare_value - Precise comparison of a counter tree against a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate a precise comparison of a counter tree against a given value.
+ * As an optimization, it uses the approximate counter comparison
+ * to quickly identify whether the counter and value are far apart.
+ * Only cases where the value is within the counter accuracy range
+ * require a precise counter sum.
+ *
+ * Return:
+ * * %0		- The value @v is equal to the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	int count = percpu_counter_tree_approximate_sum(counter);
+	int res;
+
+	res = compare_delta(v - count,
+			    counter->approx_accuracy_range.under,
+			    counter->approx_accuracy_range.over);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/* Precise sum is required. */
+	count = percpu_counter_tree_precise_sum(counter);
+	if (v - count < 0)
+		return -1;
+	if (v - count > 0)
+		return 1;
+	return 0;
+}
+
+static
+void percpu_counter_tree_set_bias(struct percpu_counter_tree *counter, int bias)
+{
+	WRITE_ONCE(counter->bias, bias);
+}
+
+/**
+ * percpu_counter_tree_set - Set the counter tree sum to a given value.
+ * @counter: Counter to set.
+ * @v: Value to set.
+ *
+ * Set the counter sum to a given value. It can be useful for instance
+ * to reset the counter sum to 0. Note that even after setting the
+ * counter sum to a given value, the counter sum approximation can
+ * return any value within the accuracy range around that value.
+ */
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v)
+{
+	percpu_counter_tree_set_bias(counter,
+				     v - percpu_counter_tree_precise_sum_unbiased(counter));
+}
+
+/**
+ * percpu_counter_tree_approximate_accuracy_range - Query the accuracy range for a counter tree.
+ * @counter: Counter to query.
+ * @under: Pointer where to store the to the accuracy range below the approximation.
+ * @over: Pointer where to store the to the accuracy range above the approximation.
+ *
+ * Query the accuracy range limits for the counter.
+ * Because of two's complement binary representation, the "under" range is typically
+ * slightly larger than the "over" range.
+ * Those values are derived from the hardware topology and the counter tree batch size.
+ * They are invariant for a given counter tree.
+ * Using this function should not be typically required, see the following functions instead:
+ * * percpu_counter_tree_approximate_compare(),
+ * * percpu_counter_tree_approximate_compare_value(),
+ * * percpu_counter_tree_precise_compare(),
+ * * percpu_counter_tree_precise_compare_value().
+ */
+void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *counter,
+						    unsigned int *under, unsigned int *over)
+{
+	*under = counter->approx_accuracy_range.under;
+	*over = counter->approx_accuracy_range.over;
+}
+
+/*
+ * percpu_counter_tree_items_size - Query the size required for counter tree items.
+ *
+ * Query the size of the memory area required to hold the counter tree
+ * items. This depends on the hardware topology and is invariant after
+ * boot.
+ *
+ * Return: Size required to hold tree items.
+ */
+size_t percpu_counter_tree_items_size(void)
+{
+	if (!nr_cpus_order)
+		return 0;
+	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
+}
+
+static void __init calculate_accuracy_topology(void)
+{
+	unsigned int nr_levels = counter_config->nr_levels, level;
+	unsigned int level_items = 1U << nr_cpus_order;
+	unsigned int batch_size = 1;
+
+	for (level = 0; level < nr_levels; level++) {
+		unsigned int n_arity_order = counter_config->n_arity_order[level];
+
+		/*
+		 * The accuracy multiplier is derived from a batch size of 1
+		 * to speed up calculating the accuracy at tree initialization.
+		 */
+		accuracy_multiplier += batch_size * level_items;
+		batch_size <<= n_arity_order;
+		level_items >>= n_arity_order;
+	}
+}
+
+int __init percpu_counter_tree_subsystem_init(void)
+{
+	nr_cpus_order = get_count_order(nr_cpu_ids);
+	if (WARN_ON_ONCE(nr_cpus_order >= ARRAY_SIZE(per_nr_cpu_order_config))) {
+		printk(KERN_ERR "Unsupported number of CPUs (%u)\n", nr_cpu_ids);
+		return -1;
+	}
+	counter_config = &per_nr_cpu_order_config[nr_cpus_order];
+	calculate_accuracy_topology();
+	return 0;
+}
-- 
2.39.5


