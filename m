Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2579CFA448
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5F76B0028; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1986E6B002A; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011936B0029; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E28DD6B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:04:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D3F38803B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:02 +0000 (UTC)
X-FDA: 84132212724.19.DA84A61
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3A7040014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="U/fkJ5fm";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763672640; a=rsa-sha256;
	cv=none;
	b=Dm77hxMB/jIqy2sXks7FumMKMYfR+PZRNtPm2Kl8FlgVKpxHlpn+QT/ACzlmXgDgnTWVBG
	Awawxbp8cX5R9ErpLOdnLLQht0lA/Zqd+1JbKZxjrkM/oEdIJdDWDCdtD453tqU/o8kOhv
	zFcstPOaHwpUqVvwz1btFOSV5/+mi2U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="U/fkJ5fm";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763672640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDEGT5UlvOJw8u5evplTELA1yB8Y9ZZnqn3PTVPb22A=;
	b=1jiyW/xltTcsmZjSVJBSAD6xhfGI9yC73GzGYZdAef2ti8UuWNnKOmtaGz4P7yIQYNs9Yc
	3QlldiO5nOKTP0/ORgtZ/zBl+NAv+E1r86hXQyIrn/OM4LaWqfdEFFAOJRsszKo1PmbuGa
	mqWYz6ektmqVX62hvGoAFVnIh9bPXyU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1763672640;
	bh=zDEGT5UlvOJw8u5evplTELA1yB8Y9ZZnqn3PTVPb22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/fkJ5fmb2bBgWeYVC8qPS/ujfG+HGICIbbXDrEFsD+eQtXrR5xx0WHh1U07KVirr
	 4CVsUVUXsKA7kpUJnN/0e/JuUbaIGlZnCWCgwLNkb1mQYql9Q0CbS3Zb6hKkJYZZnA
	 DWXFAbY0mc5js/gvkdmgJ46efEzUt8AGhxSRjHaAW38XhPZqFrVmwWtjDd1oKAnF6j
	 b2Q2K0TMBw9Dvphnp4IR6rZ7HRXmOYBnAKlAcQ3GZss7pG0DG7Y+xyFRFHnp/mSR8o
	 8x37OwvFv5VTfH8Avvxa9de+bOjj9YGAvb9IQKF6RJKrdBcY57fxap7BnX1Iyr851a
	 vy6E5PQge3hmA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dC9nX00NhzNVQ;
	Thu, 20 Nov 2025 16:03:59 -0500 (EST)
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
Subject: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
Date: Thu, 20 Nov 2025 16:03:53 -0500
Message-Id: <20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3A7040014
X-Stat-Signature: 9zdot8pm16m6qmnkzaxwshnfxuor8ojh
X-HE-Tag: 1763672640-144840
X-HE-Meta: U2FsdGVkX1/YQMELBxYnBvgkhgXKAAxgyEpFVyTn0flMba1nIycmPlw7f8BjfexcAUmRW9ny6QE0ASQno/jH4k5Q/Mi25E5O39jJcpoLGhctKY1PbDAQRJOiANrg8fCVNoUSglQIMuJMuVlEV8O5iFBRaPiqRl4qXLSMsOAG44uV7r3R4KlXTyrZYYs+k7t+QSvAh/Pnlc8+8XpX8Vu4ikCQIPws9CSRqgbuSZgeG5cl9fDiRvVau4Okd+gHavxn2jHpSJ6ZCJYppIlW4tNHIZLV6VH2lonhBq8ByPR1V+aZ2Y/sXD1JGhoJZrpM191/Dvyg28T4TnRYvawSqbstDQqoHADZIVYd5O59sbo0jXE3lMIKMRsPbXKeAMlwOmnDi0w56h1ZizWGbuebHIclwSQYA7mc7y7cg8eAcS1j0/w1RcqiJXKv9BbGgQ4k1k0W/uvf1YodeRfY79veWyorpRJvDCnM686qgyy36HzpT165Ko57qtbtL8EhRc0WfAbqt/mU7W5mzCkb+6E0FodogwWGxC28fvVNoXLhO9/rCepsl6Jyp/5yNsGhIc9p6+SHxXfe8Bl3n/Tdbt0OnxJZy+D3l/OFuBx8ncKQEdS/MWsHbm74Iq0XKN/q0sEP6Ta8cGM4JguhrtlcLVs8GVGx35nMU2dsi1Ejdtzhe3SNsV3MbXHfpLV7jsaGhVD07j28NFPGc7GhifcRzgtS0LmuBSSsLAvKIGvbKxakznVfOLf9pmThLtZrBmcYWtaBzFiPP06/Vykup/Nd/BBO1Nl1HDnxWiRUVrHKfR2ZpDUijQgEq+mj5BiihhNjBPDKfEsknXTqZ9tqTWZ8uhDYChz3giQoLzjW0Zc3HOM6/EvUBwfzzWLkUHCqu3kEQk8tcZ8JRFJgem9hPpDgGyTrXeXZ+Umaml/zuxRKvzo8yWZHODzrSc/vVrukvKKBqjxYa/oVs753mAgjx2tUPMXGA2M
 jaFhG51E
 nmIjlwzyD559rTC/mmb4DfjWt0LDuJK3qB1E0lYexHfOYi/Dc1Tn6ndQ8pc2dpPSzB3WWe7NHH0rwX2M+76p3p+YtJ/qAw+CCOmKwdM8kAIleFA9w96t5ZG2X76sYOOC2GagZvuD6w5J12TR/1eu7i5pT5RFT0XjLdmTNtWWgSlKz9pIinEuZXbqWJd9ebm+FLWQlO65Z6LLF7ZFKcy6FaZSrkkNOElmDL+qtVnV8oJoTjITXcZ0GYMTvgGHTvqmoHbav4mCClfrjEOob5I20nIhgDQlkMyio3UxcGZBjIo9aVYcvzOSHO9PQ25VjDy/Mtizrogt4EAejwSIdCNhaKmg3aSBkdn1pziVnA8M2OlMDy/1YmOIOLIUD1ANpML+IB58SYHPCdiRwa3HWVdTwUU4DabEl0DIgkiv15WKfH8PoGqxIVUL63fJJ74V+R14lAmmEXepo1F9Z04bgXXSrIx8+Fom0vZ9mbZjPR+oRo3vGMtIxU7kNoiPvTJyGaOeUvtWFadbu15n5YYRJpuc442wfV1mUFcv/vsBzzF6A8xEem+iGWmjR0Z2EUmN4iRLbIEewAfW3Wc+8/Kt9g/BprCvyuxOBH8uiMstObNnLKpW7qlV/5myun7LKMQ3TPjUn2fK1rAOpqZudAmuUR8JabEFrFcm5EAX1LbiQfnbL8xYvIlsRKiQ+2v5n8vGuXVVgDFdEfKeR85Xx0vi0og32C5nEpxgHujVPQahErOOFpTQlQa6wut5xxX7Cma97Mbrk1kziL/3OHwFM2t190V5XhNFAiXa49LIgTpdOT5qlBX7BMcg8DpDB9+gdIx93vJUFGgIiQX7gQGul6AmUO0ZTn8WX3oQ6cJ8g+TtgGAmHrDBXZp2vNPHtfqVkqS59J+pVikEl/h+Q3RhSEU3TuTpv0VvHh9hw8R71HVJQMcvhKQiChO5+y6D+SSOGrI74Jf06ZbrODA+Kuav+udL/K20KccR3eGfZ
 0xeiluN7
 /LWvtTJ7ouzP7W7PiADhIEloVkVxNb6VumHY8TPT4intQNg2HUgoOvIJNRJsWI/JnfoafrKmUPDDYJJepd/310sJ4qDyrAWKSUHOOhUhmFyITNxqg8DkoQ==
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
 include/linux/percpu_counter_tree.h | 239 +++++++++++++++
 init/main.c                         |   2 +
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 443 ++++++++++++++++++++++++++++
 4 files changed, 685 insertions(+)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..1f4938b67730
--- /dev/null
+++ b/include/linux/percpu_counter_tree.h
@@ -0,0 +1,239 @@
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
+	atomic_t count;
+} ____cacheline_aligned_in_smp;
+
+struct percpu_counter_tree {
+	/* Fast-path fields. */
+	unsigned int __percpu *level0;
+	unsigned int level0_bit_mask;
+	union {
+		unsigned int *i;
+		atomic_t *a;
+	} approx_sum;
+	int bias;			/* bias for counter_set */
+
+	/* Slow-path fields. */
+	struct percpu_counter_tree_level_item *items;
+	unsigned int batch_size;
+	unsigned int inaccuracy;	/* approximation imprecise within ± inaccuracy */
+};
+
+size_t percpu_counter_tree_items_size(void);
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned int batch_size, gfp_t gfp_flags);
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned int batch_size, gfp_t gfp_flags);
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counter, unsigned int nr_counters);
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter);
+void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, int inc);
+int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter);
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, int v);
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, int v);
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v);
+unsigned int percpu_counter_tree_inaccuracy(struct percpu_counter_tree *counter);
+int percpu_counter_tree_subsystem_init(void);
+
+/* Fast paths */
+
+static inline
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
+static inline
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
+unsigned int percpu_counter_tree_inaccuracy(struct percpu_counter_tree *counter)
+{
+	return 0;
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
+static inline
+int percpu_counter_tree_approximate_sum_positive(struct percpu_counter_tree *counter)
+{
+	int v = percpu_counter_tree_approximate_sum(counter);
+	return v > 0 ? v : 0;
+}
+
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
index 000000000000..5056d470bdc2
--- /dev/null
+++ b/lib/percpu_counter_tree.c
@@ -0,0 +1,443 @@
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
+ * Counters at levels 0, 1, 2 can be kept on a single byte (±128 range),
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
+ * * Approximation inaccuracy:
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
+ *            inaccuracy      inaccuracy
+ * Level 0:   [ -32 ..  +31]  ±256  (8 * 32)
+ * Level 1:   [ -64 ..  +63]  ±256  (4 * 64)
+ * Level 2:   [-128 .. +127]  ±256  (2 * 128)
+ * Total:      ------         ±768  (log2(nr_cpu_ids) * BATCH(level 0) * nr_cpu_ids)
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
+struct counter_config {
+	unsigned int nr_items;
+	unsigned char nr_levels;
+	unsigned char n_arity_order[MAX_NR_LEVELS];
+};
+
+/*
+ * nr_items is the number of items in the tree for levels 1 to and
+ * including the final level (approximate sum). It excludes the level 0
+ * per-cpu counters.
+ */
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
+static const struct counter_config *counter_config;
+static unsigned int nr_cpus_order, inaccuracy_multiplier;
+
+static
+int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			       unsigned int batch_size, gfp_t gfp_flags,
+			       unsigned int __percpu *level0,
+			       struct percpu_counter_tree_level_item *items)
+{
+	/* Batch size must be power of 2 */
+	if (!batch_size || (batch_size & (batch_size - 1)))
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
+	counter->inaccuracy = batch_size * inaccuracy_multiplier;
+	return 0;
+}
+
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
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned int batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
+}
+
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters, unsigned int nr_counters)
+{
+	free_percpu(counters->level0);
+}
+
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_destroy_many(counter, 1);
+}
+
+/*
+ * It does not matter through which path the carry propagates up the
+ * tree, therefore there is no need to disable preemption because the
+ * cpu number is only used to favor cache locality.
+ */
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
+/*
+ * Precise sum. Perform the sum of all per-cpu counters.
+ */
+static int percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counter)
+{
+	unsigned int sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += *per_cpu_ptr(counter->level0, cpu);
+	return (int) sum;
+}
+
+int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(counter->bias);
+}
+
+/*
+ * Do an approximate comparison of two counters.
+ * Return 0 if counters do not differ by more than the sum of their
+ * respective inaccuracy ranges,
+ * Return -1 if counter @a less than counter @b,
+ * Return 1 if counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	int count_a = percpu_counter_tree_approximate_sum(a),
+	    count_b = percpu_counter_tree_approximate_sum(b);
+
+	if (abs(count_a - count_b) <= (a->inaccuracy + b->inaccuracy))
+		return 0;
+	if (count_a < count_b)
+		return -1;
+	return 1;
+}
+
+/*
+ * Do an approximate comparison of a counter against a given value.
+ * Return 0 if the value is within the inaccuracy range of the counter,
+ * Return -1 if the value less than counter,
+ * Return 1 if the value is greater than counter.
+ */
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	int count = percpu_counter_tree_approximate_sum(counter);
+
+	if (abs(v - count) <= counter->inaccuracy)
+		return 0;
+	if (count < v)
+		return -1;
+	return 1;
+}
+
+/*
+ * Do a precise comparison of two counters.
+ * Return 0 if the counters are equal,
+ * Return -1 if counter @a less than counter @b,
+ * Return 1 if counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	int count_a = percpu_counter_tree_approximate_sum(a),
+	    count_b = percpu_counter_tree_approximate_sum(b);
+
+	if (abs(count_a - count_b) <= (a->inaccuracy + b->inaccuracy)) {
+		if (b->inaccuracy < a->inaccuracy) {
+			count_a = percpu_counter_tree_precise_sum(a);
+			if (abs(count_a - count_b) <= b->inaccuracy)
+				count_b = percpu_counter_tree_precise_sum(b);
+		} else {
+			count_b = percpu_counter_tree_precise_sum(b);
+			if (abs(count_a - count_b) <= a->inaccuracy)
+				count_a = percpu_counter_tree_precise_sum(a);
+		}
+	}
+	if (count_a > count_b)
+		return -1;
+	if (count_a > count_b)
+		return 1;
+	return 0;
+}
+
+/*
+ * Do a precise comparision of a counter against a given value.
+ * Return 0 if the value is equal to the counter,
+ * Return -1 if the value less than counter,
+ * Return 1 if the value is greater than counter.
+ */
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, int v)
+{
+	int count = percpu_counter_tree_approximate_sum(counter);
+
+	if (abs(v - count) <= counter->inaccuracy)
+		count = percpu_counter_tree_precise_sum(counter);
+	if (count < v)
+		return -1;
+	if (count > v)
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
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v)
+{
+	percpu_counter_tree_set_bias(counter,
+				     v - percpu_counter_tree_precise_sum_unbiased(counter));
+}
+
+unsigned int percpu_counter_tree_inaccuracy(struct percpu_counter_tree *counter)
+{
+	return counter->inaccuracy;
+}
+
+size_t percpu_counter_tree_items_size(void)
+{
+	if (!nr_cpus_order)
+		return 0;
+	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
+}
+
+static unsigned int __init calculate_inaccuracy_multiplier(void)
+{
+	unsigned int nr_levels = counter_config->nr_levels, level;
+	unsigned int level_items = 1U << nr_cpus_order;
+	unsigned int inaccuracy = 0, batch_size = 1;
+
+	for (level = 0; level < nr_levels; level++) {
+		unsigned int n_arity_order = counter_config->n_arity_order[level];
+
+		inaccuracy += batch_size * level_items;
+		batch_size <<= n_arity_order;
+		level_items >>= n_arity_order;
+	}
+	return inaccuracy;
+}
+
+int __init percpu_counter_tree_subsystem_init(void)
+{
+
+	nr_cpus_order = get_count_order(nr_cpu_ids);
+	if (WARN_ON_ONCE(nr_cpus_order >= ARRAY_SIZE(per_nr_cpu_order_config))) {
+		printk(KERN_ERR "Unsupported number of CPUs (%u)\n", nr_cpu_ids);
+		return -1;
+	}
+	counter_config = &per_nr_cpu_order_config[nr_cpus_order];
+	inaccuracy_multiplier = calculate_inaccuracy_multiplier();
+	return 0;
+}
-- 
2.39.5


