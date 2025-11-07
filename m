Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68075CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461A18E0012; Fri,  7 Nov 2025 12:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412308E000E; Fri,  7 Nov 2025 12:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152598E0002; Fri,  7 Nov 2025 12:22:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE55B8E000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:22:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6E681A04BE
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:22:26 +0000 (UTC)
X-FDA: 84084479892.01.A2468D1
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02955180006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:22:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=WqjWZUKg;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762536145; a=rsa-sha256;
	cv=none;
	b=uCKC7gWUT/o3TYX3pR5eaX9a6F44G6xFNmimEzELhSL6GKK9KoezctelZL6ymlp/6T+8sQ
	jQd0g7fHcqezvs36nMluWdgvQtY4AS4FIJfc5bPGdgGJsiWbQUfAEgMuk9I1tG83nNk0Uo
	L3m7wc+RDQ4gV3XLMPPddBVqfJZunT8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=WqjWZUKg;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762536145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EumKOGdR4Bx/Rku+CMtvaij/MaW8ySUAz7yOdzeoAYQ=;
	b=MU2AoAzL3bWIDeExfwU3BPNePn2uM8lmQMHIfMpJ/p7xx80++iD5QvnkRpuXTHGIQYIj9d
	tQJuQWGrwD5R0w+HZoIZ4xIVeI/uTHPTARWqLKwBbD8OwERw+XxKxqpBEoBEDWw6rA1s1V
	du1QPY6/QfClciOq30zT67QmfUHYyGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1762536144;
	bh=EumKOGdR4Bx/Rku+CMtvaij/MaW8ySUAz7yOdzeoAYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqjWZUKgF00socT0LZxjkQsVZpaknQ/ci7TMqTXjdU4fdX+b+eTHj0D/BlcL8M+CC
	 i4oD9go3PjbVIDXCWx0AbYaKwo2rWm4TnEK4eLYMDO/uLqw6t3JYa7t4RrZMXFCZc8
	 WwwqiMsggOuA5kM2fyYVsM7GYTL4H3MDFe0qKHL9aFTZa7AVhsvsRov9wpeBKAM1y1
	 f0Cjgtp8Yws1EGu6mcP+HkzdxMEcLga222W5nRCTn4Fw2lge5iHUdvxmEJjqfTMwqV
	 vIh+W8Ea3rZVOIgZ8rmtO9ia5AVDq2e7paT6B1/gOR1Np601QBJJSQVxyLHTH+z9Ku
	 IDg6FnNhA00pA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4d35Tr0g5xzKtW;
	Fri, 07 Nov 2025 12:22:24 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Sweet Tea Dorminy <sweettea@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH v8 1/2] lib: Introduce hierarchical per-cpu counters
Date: Fri,  7 Nov 2025 12:22:15 -0500
Message-Id: <20251107172216.515754-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251107172216.515754-1-mathieu.desnoyers@efficios.com>
References: <20251107172216.515754-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 02955180006
X-Stat-Signature: e7bf1umxexd3z5udr79hk4ccnt1njo79
X-Rspam-User: 
X-HE-Tag: 1762536144-531929
X-HE-Meta: U2FsdGVkX18TuHIdMxkW+Fro0YX6fqUwN7vzT76LRhrThYIz15m5oK4+ghl0ZMYSr6j8nrDh/QL4DIR5z7PpYtCzD4Le77906vLRn0OQT58zorE2WnkOUHeT4yQWmLpIOBE/uWxVGkaZHOzhfNsrz+Lc/lGaVuMXKTJYwB8nnJbzq30pRpgXgcg2jhUnPtElqQ060NSFNlRVtctKtOY8xyWobgr0c669yQDxoNmaBrkageHj2XREECvAiqFBCq9lhRrwFV+Do9eR7D6L5kGeoz/lHmclmMjzi3XhcB1PiQRW9KguUDOsnUy9F1JZauTujdFYc2xYufrZWwH3ZB/czMM4+CVdmbYfdwLm4rpCt+qXOPek15/LN3r4hvcKOkTYwvwN4/04+AIWN0ulTxukgLu/5gQdNEiRF0DOyPODqfL9Q8DeAnaetbDZ/so1JZLf1PTvk2wzVwA0mVrPTHMuB3Pjzo4UIW7aIlLQYeGlxDWHAEz6fO+W66ae19Q1tW8maD5HiJbDVz7F4ofXyPAeCUJWHfTpEIccOvr2Ejg+6zYvK9+8jH2AUQa6bDBBvfabmE2cU1EC/VPgSrAyQEyHMwDw5TLVD0i3j89w2VNg1UimXKkUNyut8ZAM7PPlLPH/lhppCO6AnKVmHco+I64JepDQ8TZrIw1dkTfnhlhBgciDPy2JgahMD+iga979f7JbV06/iEH4QkFs14VkR701qHv1XiRfd7NYKA1tg+1XmIE40fkXxoCVcgXuP1Yi7yIscQBY7IVmkHhaGX5Q8WE2Z6u4dPyRF2+cU862clpMa/fx3u+sbnEQmBn0BEMWTdreeFGiMCPsJA6iJa0XKAfoiunpRINT3tAoZeL87GYq6ftAwDWxEKA5YMXvPjSnAchYWr/2SSP7n99DEhAKQeK7VqqDYCdGGklhiv+FbRUofX0JsOFBgLVbx2JWESK7W+l9Wz1hiHz9IsC9Yk+mfRs
 pRx2qX0P
 2/2Q85XkoQikSQonw5o/bTZhgkFznbpK8LmZUYuL2xNadNPMSLrSyiO1WG79yz+RG9GCEt+MksXz9wmMaEeuc0FrDERhjjMBcVGMWb463EQfjtElyX1/nUhso17gUqQhAVSgi4gYrrN1tBZiIUO1ZZNUzzfydR0g5C6hqY8+2e3/W0Th+aH3iD7AQcDg6SpNNaXKMpYnAPRYafuQCTyLQjzXOyQ4Ob07rwHGsAkQWvfnoH2hOwgdGGNr+LzLJU18mK2KSY9QAT7VRI3jALqglNX9E3/GXdmzpQ9jBnzeaEEn8Zh42tF6BG+6oi7ZExOej1PiQ3RFRHbsu3SE70TaPP/g0zpdJpQN5fnUxrAg/5Kx1VDi9azR+6E9TketADUAz0bZ+3qyKye7/zTOqS2griQYQBd4io/iKyBOO5cXWak+EwuBgFBSh7hSTFSqvQWJ1BgOCHmbUP6Y1n0q2z+AoXK3D8WFdWtHo9I8SF0+nxW3W7qeql0XWhWwaOpx/4OXuvu7nVGBnF2j7lB2znTppglRbUIc19oqoFOxFniVMY2do0qTXoEWIq+vFPiU/6tUKtNhaSqq7RzNfRvgameLcGuVynhy5tNaF8sg+aZn908YlbAt/fJAomCczf8iN/eMy2qyHMBY+otNle5PPRh3NvGkC1V15QMoH3xrQSX/+GCp4JdCSYiNWGvSWpPoTX9ZPIDQdsDGo5vhqCKZkQ+jUE9+S4morcH64SVrM6pGmR83jUWio6EEsY+2BHQo7XzBS7CS0pEnAEdCn9FORYjndAkiXtDkiALHiFhk1jSjgBoyOx0hZAOIN0tkY0sEdQ8UjiSuADPqNl6FZb9epRT6OmhEL8bI4FdwDhxyMVbV9iqRCt01z5vv8DghYIXteK50S61Sg7ylJDrq7Dru2a4cgakoTS4zZ2terDcOEoa26N+e5s9mSFfBjUoaPa5o79PDnv/qcLRiUjemYknU8yMH0Z8nJNrME
 ZqQinlll
 vuWtV8pW+aU8LrGNmjRuOvNktVcUdSt4QErzdE2X/Nps/sEyDA/cz767ywRLlLcZFlQZOO9mLZ5/P875Rimjgtf2tkK5j9wgUdoCxVEgZTBRi2VA0H/Ksbw0nYOqaMNTifUqUltnkasK/9tpzJSxPQ==
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
Cc: Sweet Tea Dorminy <sweettea@google.com>
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
 include/linux/percpu_counter_tree.h | 217 +++++++++++++++
 init/main.c                         |   2 +
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 392 ++++++++++++++++++++++++++++
 4 files changed, 612 insertions(+)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..c5c71c14040b
--- /dev/null
+++ b/include/linux/percpu_counter_tree.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> */
+
+#ifndef _PERCPU_COUNTER_TREE_H
+#define _PERCPU_COUNTER_TREE_H
+
+#include <linux/cleanup.h>
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
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, unsigned int batch_size, gfp_t gfp_flags);
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
+	if (!inc)
+		return;
+	/* Make sure the fast and slow paths use the same cpu number. */
+	guard(migrate)();
+	res = this_cpu_add_return(*counter->level0, inc);
+	orig = res - inc;
+	inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
+	if (!inc)
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
+struct percpu_counter_tree {
+	atomic_t count;
+};
+
+static inline
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, unsigned int batch_size, gfp_t gfp_flags)
+{
+	atomic_set(&counter->count, 0);
+	return 0;
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
index 07a3116811c5..204d9f913130 100644
--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,7 @@
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
+#include <linux/percpu_counter_tree.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -969,6 +970,7 @@ void start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
+	percpu_counter_tree_subsystem_init();
 	maple_tree_init();
 	poking_init();
 	ftrace_init();
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
index 000000000000..dbb7ac737842
--- /dev/null
+++ b/lib/percpu_counter_tree.c
@@ -0,0 +1,392 @@
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
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, unsigned int batch_size, gfp_t gfp_flags)
+{
+	/* Batch size must be power of 2 */
+	if (!batch_size || (batch_size & (batch_size - 1)))
+		return -EINVAL;
+	counter->batch_size = batch_size;
+	counter->bias = 0;
+	counter->level0 = alloc_percpu_gfp(unsigned int, gfp_flags);
+	if (!counter->level0)
+		return -ENOMEM;
+	if (!nr_cpus_order) {
+		counter->items = NULL;
+		counter->approx_sum.i = per_cpu_ptr(counter->level0, 0);
+		counter->level0_bit_mask = 0;
+	} else {
+		counter->items = kzalloc(counter_config->nr_items *
+					 sizeof(struct percpu_counter_tree_level_item),
+					 gfp_flags);
+		if (!counter->items) {
+			free_percpu(counter->level0);
+			return -ENOMEM;
+		}
+		counter->approx_sum.a = &counter->items[counter_config->nr_items - 1].count;
+		counter->level0_bit_mask = 1UL << get_count_order(batch_size);
+	}
+	counter->inaccuracy = batch_size * inaccuracy_multiplier;
+	return 0;
+}
+
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+	free_percpu(counter->level0);
+	kfree(counter->items);
+}
+
+/* Called with migration disabled. */
+void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, int inc)
+{
+	unsigned int level_items, nr_levels = counter_config->nr_levels,
+		     level, n_arity_order, bit_mask;
+	struct percpu_counter_tree_level_item *item = counter->items;
+	unsigned int cpu = smp_processor_id();
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
+		if (!inc)
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


