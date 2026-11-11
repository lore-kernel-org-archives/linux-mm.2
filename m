Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBC9606A89E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=rPYFW0b2
Received: by kanga.kvack.org (Postfix)
	id 964C96B05B2; Wed, 11 Nov 2026 15:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93CDC6B05B4; Wed, 11 Nov 2026 15:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AF06B05B5; Wed, 11 Nov 2026 15:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 551CA6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE8F6A01DF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:47 +0000 (UTC)
X-FDA: 85423996854.13.8B3EACF
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4830820009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=rPYFW0b2;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi1kqXLWyRnl9Rq7k6QD437Lq+6SSVBzWe+mPT/kZ0Y=;
	b=OntTzQa5BwjQ0XlJFpuSr74t7a4NZllxBNTef5+iWPItxPLiTL3+z34KNZqeIS7+DHUXe4
	U5RSd1YG1r0YpvnkAq0HnFoW0RmYeFT25SqCEIGAxp9GN24u6JmE4yh5cciwNReOcR3U+u
	OQYsHNivPRi0Kp5VEgwyf4SSfWuLvCE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=rPYFW0b2;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429406;
	b=yvqsRdungSyuL04Mxx1mAXKFR6pAPQ3oE+UPw5XaY97F0RwurzTgMkQZTtt9L48uDii08w
	1ciFddrIvp9l/lalj4ivQqf1X3no8vJbxDdrxU6m+8JVymzQpRx+9Iyz3zSUodf+ZWosl3
	PQ+Y8sZJ+DYNpRqKxvsOWgfQU1Xm/A0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429405;
	bh=pi1kqXLWyRnl9Rq7k6QD437Lq+6SSVBzWe+mPT/kZ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPYFW0b2MMFsbT2ef3BPjpWBTBQSPF3AJTinQHyxPMA+nmcxsyT8utW3wNFpoTrMZ
	 5Ti5R/mC2Sug9frpaU5swBbibGmBE3L9TkMxCw19TsFcI40W1Jf3tHtXlwsNi3AjvJ
	 q0WeYYXkKdocMJ/idbGoM/2VSaNE+0i5GGXabBCrON+SvinZp4HsVEUDGgpSUAuXYf
	 9Zd3wiswwmmuv7YPsddo8NHe/5/GrtdNORgnqqnXGYamlv8atS2aZytV9g/ZAUfqPd
	 MBftUkuGl9VV8S3PAMNIsYGFKpvKrLW9RT/DY1FnjMOxLRxX9nh8d4oSrrISGvJoYF
	 PM8W9YuU7+uFw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKn0pkSzNlk;
	Wed, 11 Nov 2026 15:36:45 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH v25 04/14] tools/testing/hpcc: add userspace test of hierarchical per-CPU counters
Date: Wed, 11 Nov 2026 15:36:16 -0500
Message-Id: <20261111203626.95838-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4830820009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bekq1wpntu1dsxk7o5o9y9c9up1wkcjd
X-HE-Tag: 1794429406-566449
X-HE-Meta: U2FsdGVkX18jVXR5BNAvzm7qdHrk6BFz4OBDqfi2IbCCMjqoygV2USxRdpspHricNmwMnTx1R7+H2qdO6CHf8ECRwhgT+3rP2+0m60JfTtj9N6x6FXACEN+NZSRdPr+5RUdi1vQ/kL3edqs4eQ/IInYz0mv6QQ3QB8Z5WWpmYlaOuckm070T35TEyJ/wAcJqli/7eXVBXA9YBQ0fDCI/PbHuI24FKkXahD/+YzhYKgqQ50C1vRO9RYVm9xdDAwzJ5s9spZoWl7qTU1UJ829mAlFCdkWkREntjU4Qof8peaY6vf54C7TgbaODC5PfgQsufNhNnxdkEmnUilY/DC0L6oAka6G3laKPX52hGewSrI8vmk0e6py194gy0Hlk57tw9oZPkgMRNpM50/ZBO3jUw5bd0J3H3RF7ZbDsbf4phMZqGLmzoL4qlea+QRkI863C7d+cEX2SugCXq1wfJTWQtd6ADSaSr1ezrqN11eMIv59NpDgr+MRa99V272/dQy/Q1BckCKqqM4m1EQzTZxSc9D77GviIbZH2jVKvolJIRFv3J1IvmmGoLinbaqBQ1zJNvL/PMXaXTKg+v11iHYwE66AfXrG7lVXaQs+YyVgd8aoGLWVIzXCVfQv60hnxWLwSFVnsEQyOe2pp5DabHnLrEGHA0T5IuL2a6m3iVrk25YlQRWkxD2In2Ras+P6GYVS3guDN5cHC5qLU0EmCV3+Km21+RDWn6/2IO7dS07+6VMG+yHNHHQDXKUffNo+x08ZpwTBEtxhhmN0wB6Ktx8WAXAtpWAhvAfl3EEuJjNCfxp8sT+gyWM+mMzfZ64rHUx8agLO305vAKiwEs8Dn668bfze3CnS4k4EZqqQIaI41DGSExibHT8kqJklRvO8eLq9ly1NqH3z4cDDl1zuulCNrgzAZMlX81Uwb4WeUMKDSEhVqoO2IHH7qKHefuoe+lSk9VGsp7h0EZB+qUp6lFg+
 awWA2/yp
 XM3MWA11Xlpi4jnyekH+8TF2dA/yHBu56oKU1uVSEwcI2u7j1LwG40vTOI4eF8N38/bB64h+597KTQgkgHSF4wXtI3BjqhZ5UkaHt2HRdZj3tAZjSqC4bw50Ej6NBcUmUQiNykFzW6Nypgo+Fq13yW1Us5GRP6TBxIK44u1AtMn/3mIC0vfp0sGZV4bK8ryE+G4uKXbnWNVe2zTxCzwukFChBX9Rgqo91k7BiOf1CQ46o0WnYKM7CuL6QWxyQYVKnXCAQ80/UMb+GZbY+reqnzEgNsMgPqfinTdB4Q8FBAjuaQjpJZH2sdfGEVkbtEmZuh6ULtlNyXw6VUMc6OCgRLdlZWm8z+cEKwiv2V9khCGlBxDiNG5lkAb59r+z02KOll4dD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The KUnit test only covers the topology of the machine it runs on.
Add a userspace test which builds lib/percpu_counter_tree.c with a
simulated topology, which allows testing every supported tree
configuration on a single machine, following the approach of
tools/testing/vma and tools/testing/radix-tree.

A small shim header provides the kernel environment needed by the
library, on top of tools/include: per-CPU data is an array indexed by
the simulated current CPU, and atomic operations are plain operations,
because the test is single-threaded. It therefore only covers settled
counters.

Validate the configuration table, then, for each simulated number of
CPUs (1 to 65536, up to 1048576 with -a) and batch size (2 to 128):

- Saturate the counter upward and downward: leave every tree item with
  its largest positive (or negative) residual which has not been
  propagated yet, check that the distance between the precise and
  approximate sums matches the residual capacity of the tree, computed
  from the configuration table, which is exactly the accuracy range, the
  same in both directions, and check the accuracy range contract and the
  comparison functions in these worst-case states.  A lost carry fails
  the saturation rather than hanging it.

- Random walk: apply random increments from random CPUs to two counters,
  and check the accuracy range contract and the comparison functions
  against shadow sums after each increment.

Along with the accuracy range contract, check the residuals of the tree
items, and that no carry was lost or duplicated.

The comparison checks include the edges of the possible precise range.
The approximate comparison against a value must be definitive exactly
outside of [approx - accuracy, approx + accuracy].

Usage:

  make -C tools/testing/hpcc
  tools/testing/hpcc/hpcc [-a]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
Changes since v23:
- Destroy the counters already initialized when an initialization fails
  in test_saturated() and test_random_walk(). (Reported by Sashiko.)
---
 MAINTAINERS                                   |   1 +
 tools/testing/hpcc/.gitignore                 |   2 +
 tools/testing/hpcc/Makefile                   |  18 +
 tools/testing/hpcc/include/hpcc_shim.h        | 177 ++++++++
 tools/testing/hpcc/include/kunit/visibility.h |   2 +
 tools/testing/hpcc/include/linux/args.h       |   4 +
 tools/testing/hpcc/include/linux/atomic.h     |   2 +
 tools/testing/hpcc/include/linux/bug.h        |   2 +
 tools/testing/hpcc/include/linux/cache.h      |   2 +
 tools/testing/hpcc/include/linux/cpumask.h    |   2 +
 tools/testing/hpcc/include/linux/errno.h      |   3 +
 tools/testing/hpcc/include/linux/limits.h     |   2 +
 tools/testing/hpcc/include/linux/math.h       |   2 +
 tools/testing/hpcc/include/linux/percpu.h     |   2 +
 .../hpcc/include/linux/percpu_counter_tree.h  |   2 +
 tools/testing/hpcc/include/linux/preempt.h    |   2 +
 tools/testing/hpcc/include/linux/slab.h       |   2 +
 tools/testing/hpcc/main.c                     | 427 ++++++++++++++++++
 18 files changed, 654 insertions(+)
 create mode 100644 tools/testing/hpcc/.gitignore
 create mode 100644 tools/testing/hpcc/Makefile
 create mode 100644 tools/testing/hpcc/include/hpcc_shim.h
 create mode 100644 tools/testing/hpcc/include/kunit/visibility.h
 create mode 100644 tools/testing/hpcc/include/linux/args.h
 create mode 100644 tools/testing/hpcc/include/linux/atomic.h
 create mode 100644 tools/testing/hpcc/include/linux/bug.h
 create mode 100644 tools/testing/hpcc/include/linux/cache.h
 create mode 100644 tools/testing/hpcc/include/linux/cpumask.h
 create mode 100644 tools/testing/hpcc/include/linux/errno.h
 create mode 100644 tools/testing/hpcc/include/linux/limits.h
 create mode 100644 tools/testing/hpcc/include/linux/math.h
 create mode 100644 tools/testing/hpcc/include/linux/percpu.h
 create mode 100644 tools/testing/hpcc/include/linux/percpu_counter_tree.h
 create mode 100644 tools/testing/hpcc/include/linux/preempt.h
 create mode 100644 tools/testing/hpcc/include/linux/slab.h
 create mode 100644 tools/testing/hpcc/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a4e4badc0648..c9b266a5df54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11959,6 +11959,7 @@ F:	Documentation/core-api/percpu-counter-tree.rst
 F:	include/linux/percpu_counter_tree.h
 F:	lib/percpu_counter_tree.c
 F:	lib/tests/percpu_counter_tree_kunit.c
+F:	tools/testing/hpcc/
 
 HIGH-RESOLUTION TIMERS, TIMER WHEEL, CLOCKEVENTS
 M:	Anna-Maria Behnsen <anna-maria@linutronix.de>
diff --git a/tools/testing/hpcc/.gitignore b/tools/testing/hpcc/.gitignore
new file mode 100644
index 000000000000..f362a8a46868
--- /dev/null
+++ b/tools/testing/hpcc/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+hpcc
diff --git a/tools/testing/hpcc/Makefile b/tools/testing/hpcc/Makefile
new file mode 100644
index 000000000000..e4758643a3f0
--- /dev/null
+++ b/tools/testing/hpcc/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+
+.PHONY: default clean
+
+default: hpcc
+
+CFLAGS += -O2 -g -Wall -I./include -I../../include -fno-strict-overflow -fno-strict-aliasing
+CFLAGS += -DCONFIG_SMP -DCONFIG_KUNIT=1 -D'NR_CPUS=(1U << 20)'
+
+DEPS = ../../../lib/percpu_counter_tree.c \
+	../../../include/linux/percpu_counter_tree.h \
+	include/hpcc_shim.h
+
+hpcc: main.c $(DEPS)
+	$(CC) $(CFLAGS) -o $@ main.c $(LDLIBS)
+
+clean:
+	$(RM) hpcc
diff --git a/tools/testing/hpcc/include/hpcc_shim.h b/tools/testing/hpcc/include/hpcc_shim.h
new file mode 100644
index 000000000000..7e268de984c6
--- /dev/null
+++ b/tools/testing/hpcc/include/hpcc_shim.h
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/*
+ * Minimal userspace environment to build lib/percpu_counter_tree.c.
+ *
+ * The test is single-threaded: per-CPU data is an array indexed by the
+ * simulated current CPU, and atomic operations are plain operations.
+ */
+#ifndef _HPCC_SHIM_H
+#define _HPCC_SHIM_H
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+/* From tools/include. */
+#include <linux/compiler.h>
+#include <linux/gfp_types.h>
+#include <linux/init.h>
+#include <linux/kconfig.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#define __ro_after_init
+#define __percpu
+#define SMP_CACHE_BYTES			64
+#define ____cacheline_aligned_in_smp	__aligned(SMP_CACHE_BYTES)
+#define S8_MAX				INT8_MAX
+
+#undef abs
+#define abs(x) ({ typeof(x) __x = (x); __x < 0 ? -__x : __x; })
+
+#define pr_err(...)		fprintf(stderr, __VA_ARGS__)
+#define pr_info(...)		do { if (0) printf(__VA_ARGS__); } while (0)
+
+extern unsigned long hpcc_nr_warnings;
+
+#define WARN(cond, ...) ({						\
+	int __ret_warn = !!(cond);					\
+	if (__ret_warn) {						\
+		hpcc_nr_warnings++;					\
+		fprintf(stderr, "WARNING at %s:%d: ", __FILE__, __LINE__); \
+		fprintf(stderr, __VA_ARGS__);				\
+	}								\
+	__ret_warn;							\
+})
+#define WARN_ON(cond)		WARN(cond, "%s\n", #cond)
+#define WARN_ON_ONCE(cond)	WARN_ON(cond)
+
+static inline int get_count_order(unsigned int count)
+{
+	int order;
+
+	if (!count)
+		return -1;
+	order = 31 - __builtin_clz(count);
+	if (count & (count - 1))
+		order++;
+	return order;
+}
+
+#define atomic_long_read(v)			READ_ONCE((v)->counter)
+#define atomic_long_set(v, i)			WRITE_ONCE((v)->counter, (i))
+#define atomic_long_add(i, v)			((void)((v)->counter += (i)))
+#define atomic_long_add_return_relaxed(i, v)	((v)->counter += (i))
+#define atomic_long_add_return_release(i, v)	((v)->counter += (i))
+#define smp_rmb()				barrier()
+
+static inline bool atomic_long_try_cmpxchg_relaxed(atomic_long_t *v, long *old, long new)
+{
+	if (v->counter == *old) {
+		v->counter = new;
+		return true;
+	}
+	*old = v->counter;
+	return false;
+}
+
+/* Simulated topology, and CPU on which the current code runs. */
+extern unsigned int nr_cpu_ids;
+extern unsigned int hpcc_current_cpu;
+
+#define raw_smp_processor_id()		hpcc_current_cpu
+#define for_each_possible_cpu(cpu)	for ((cpu) = 0; (cpu) < (int)nr_cpu_ids; (cpu)++)
+
+/*
+ * Each per-CPU allocation reserves HPCC_PCPU_UNIT bytes per CPU, so
+ * per_cpu_ptr() can be applied to a pointer within an allocation.
+ */
+#define HPCC_PCPU_UNIT	64
+
+static inline void *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp)
+{
+	if (size > HPCC_PCPU_UNIT || align > HPCC_PCPU_UNIT)
+		return NULL;
+	return calloc(nr_cpu_ids, HPCC_PCPU_UNIT);
+}
+
+static inline void free_percpu(void *ptr)
+{
+	free(ptr);
+}
+
+#define SLAB_PANIC	0
+
+struct kmem_cache {
+	size_t size;
+	size_t align;
+};
+
+static inline struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
+						   unsigned int align, unsigned int flags,
+						   void (*ctor)(void *))
+{
+	struct kmem_cache *s = malloc(sizeof(*s));
+
+	if (!s)
+		abort();
+	s->size = size;
+	s->align = align;
+	return s;
+}
+
+static inline void kmem_cache_destroy(struct kmem_cache *s)
+{
+	free(s);
+}
+
+static inline void *kmem_cache_zalloc(struct kmem_cache *s, gfp_t gfp)
+{
+	/* The allocation size needs to be a multiple of the alignment. */
+	void *p = aligned_alloc(s->align, (s->size + s->align - 1) / s->align * s->align);
+
+	if (p)
+		memset(p, 0, s->size);
+	return p;
+}
+
+static inline void kmem_cache_free(struct kmem_cache *s, void *p)
+{
+	free(p);
+}
+
+static inline void *kzalloc(size_t size, gfp_t gfp)
+{
+	return calloc(1, size);
+}
+
+static inline void kfree(void *p)
+{
+	free(p);
+}
+
+#define per_cpu_ptr(ptr, cpu)	\
+	((typeof(ptr))((char *)(ptr) + (size_t)(cpu) * HPCC_PCPU_UNIT))
+
+/* Level 0 counters are the only per-CPU data: s8. */
+static inline bool __hpcc_this_cpu_try_cmpxchg(s8 *pcp, s8 *old, s8 new)
+{
+	s8 *p = per_cpu_ptr(pcp, hpcc_current_cpu);
+
+	if (*p != *old) {
+		*old = *p;
+		return false;
+	}
+	*p = new;
+	return true;
+}
+
+#define this_cpu_read(pcp)	(*per_cpu_ptr(&(pcp), hpcc_current_cpu))
+#define this_cpu_try_cmpxchg(pcp, ovalp, nval)	\
+	__hpcc_this_cpu_try_cmpxchg(&(pcp), (ovalp), (nval))
+
+#endif /* _HPCC_SHIM_H */
diff --git a/tools/testing/hpcc/include/kunit/visibility.h b/tools/testing/hpcc/include/kunit/visibility.h
new file mode 100644
index 000000000000..dfcbfd01a415
--- /dev/null
+++ b/tools/testing/hpcc/include/kunit/visibility.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#define EXPORT_SYMBOL_IF_KUNIT(symbol)
diff --git a/tools/testing/hpcc/include/linux/args.h b/tools/testing/hpcc/include/linux/args.h
new file mode 100644
index 000000000000..0c00a85fdd21
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/args.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* Also defined by the C library <sys/cdefs.h>. */
+#undef __CONCAT
+#include "../../../../../include/linux/args.h"
diff --git a/tools/testing/hpcc/include/linux/atomic.h b/tools/testing/hpcc/include/linux/atomic.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/atomic.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/bug.h b/tools/testing/hpcc/include/linux/bug.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/bug.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/cache.h b/tools/testing/hpcc/include/linux/cache.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/cache.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/cpumask.h b/tools/testing/hpcc/include/linux/cpumask.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/cpumask.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/errno.h b/tools/testing/hpcc/include/linux/errno.h
new file mode 100644
index 000000000000..45fdd60261e7
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/errno.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* Also included by the C library <errno.h>: only provide the error numbers. */
+#include <asm/errno.h>
diff --git a/tools/testing/hpcc/include/linux/limits.h b/tools/testing/hpcc/include/linux/limits.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/limits.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/math.h b/tools/testing/hpcc/include/linux/math.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/math.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/percpu.h b/tools/testing/hpcc/include/linux/percpu.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/percpu.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/percpu_counter_tree.h b/tools/testing/hpcc/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..065a2aca4d5b
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/percpu_counter_tree.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../../../../../include/linux/percpu_counter_tree.h"
diff --git a/tools/testing/hpcc/include/linux/preempt.h b/tools/testing/hpcc/include/linux/preempt.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/preempt.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/include/linux/slab.h b/tools/testing/hpcc/include/linux/slab.h
new file mode 100644
index 000000000000..b2aa26415cca
--- /dev/null
+++ b/tools/testing/hpcc/include/linux/slab.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#include "../hpcc_shim.h"
diff --git a/tools/testing/hpcc/main.c b/tools/testing/hpcc/main.c
new file mode 100644
index 000000000000..28fb3af2ea1d
--- /dev/null
+++ b/tools/testing/hpcc/main.c
@@ -0,0 +1,427 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+/*
+ * Userspace test of the hierarchical per-CPU counters (lib/percpu_counter_tree.c).
+ *
+ * The library is built with a simulated topology, which allows testing
+ * every supported tree configuration on a single machine, whereas the
+ * KUnit test only covers the topology of the machine it runs on.
+ *
+ * For each simulated number of CPUs and batch size:
+ *
+ * - Saturate the counter upward and downward: leave every tree item with
+ *   its largest positive (or negative) residual which has not been
+ *   propagated yet, check that the distance between the precise and
+ *   approximate sums matches the residual capacity of the tree in that
+ *   direction, and check the accuracy range contract and the comparison
+ *   functions in these worst-case states.
+ *
+ * - Random walk: apply random increments from random CPUs to two counters,
+ *   and check the accuracy range contract and the comparison functions
+ *   against shadow sums after each increment.
+ *
+ * The test is single-threaded, so it only covers settled counters.
+ */
+
+#include <stdarg.h>
+#include "hpcc_shim.h"
+
+unsigned int nr_cpu_ids;
+unsigned int hpcc_current_cpu;
+unsigned long hpcc_nr_warnings;
+
+#include "../../../lib/percpu_counter_tree.c"
+
+#define MAX_REPORTED_FAILURES	10
+
+static unsigned long nr_case_failures;
+
+#define CHECK(cond) do {							\
+	if (!(cond)) {								\
+		if (nr_case_failures++ < MAX_REPORTED_FAILURES)			\
+			printf("#   %s:%d: check failed: %s\n",			\
+			       __FILE__, __LINE__, #cond);			\
+	}									\
+} while (0)
+
+static uint64_t rng_state = 88172645463325252ULL;
+
+static uint64_t rnd(void)
+{
+	rng_state ^= rng_state << 13;
+	rng_state ^= rng_state >> 7;
+	rng_state ^= rng_state << 17;
+	return rng_state;
+}
+
+static int sign(long v)
+{
+	return (v > 0) - (v < 0);
+}
+
+struct test_counter {
+	struct percpu_counter_tree tree;
+	long shadow;	/* Expected precise sum. */
+};
+
+int scnprintf(char *buf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	if (!size)
+		return 0;
+	va_start(args, fmt);
+	len = vsnprintf(buf, size, fmt, args);
+	va_end(args);
+	return len < (int)size ? len : (int)size - 1;
+}
+
+static void hpcc_init_topology(unsigned int nr_cpus)
+{
+	nr_cpu_ids = nr_cpus;
+	/* Reset the state accumulated by a prior subsystem initialization. */
+	kmem_cache_destroy(tree_topology.items_cachep);
+	memset(&tree_topology, 0, sizeof(tree_topology));
+	tree_topology.nr_items = UINT_MAX;
+	CHECK(!percpu_counter_tree_subsystem_init());
+}
+
+static int test_counter_init(struct test_counter *c, unsigned long batch_size)
+{
+	c->shadow = 0;
+	return percpu_counter_tree_init(&c->tree, batch_size, GFP_KERNEL);
+}
+
+static void test_counter_destroy(struct test_counter *c)
+{
+	percpu_counter_tree_destroy(&c->tree);
+}
+
+static void test_counter_add(struct test_counter *c, unsigned int cpu, long inc)
+{
+	hpcc_current_cpu = cpu;
+	percpu_counter_tree_add(&c->tree, inc);
+	c->shadow += inc;
+}
+
+static void test_counter_set(struct test_counter *c, long v)
+{
+	percpu_counter_tree_set(&c->tree, v);
+	c->shadow = v;
+}
+
+/*
+ * Residual capacity of the tree items above level 0, in either direction:
+ * sum of the largest residual which each item can hold without propagating
+ * a carry. A level L item only receives multiples of the level L - 1 carry,
+ * and propagates once its residual reaches the level L carry, so it holds
+ * at most bit(L) - bit(L - 1) in either direction.
+ */
+static unsigned long tree_item_capacity(unsigned long batch_size)
+{
+	unsigned long capacity = 0, lo = batch_size, hi;
+	unsigned int level, level_items;
+
+	level_items = 1U << tree_topology.nr_cpus_order;
+	for (level = 1; level < tree_topology.config->nr_levels; level++) {
+		unsigned int n_arity_order = tree_topology.config->n_arity_order[level - 1];
+
+		level_items >>= n_arity_order;
+		hi = lo << n_arity_order;
+		capacity += level_items * (hi - lo);
+		lo = hi;
+	}
+	return capacity;
+}
+
+/*
+ * Residual capacity of the tree, in either direction: a level 0 counter
+ * holds at most batch_size - 1 on top of the item capacity.
+ */
+static unsigned long tree_residual_capacity(unsigned long batch_size)
+{
+	return nr_cpu_ids * (batch_size - 1) + tree_item_capacity(batch_size);
+}
+
+/* Copy the state of counter @src into counter @dst, of the same topology. */
+static void test_counter_copy(struct test_counter *dst, struct test_counter *src)
+{
+	percpu_counter_tree_copy_state(&dst->tree, &src->tree);
+	dst->shadow = src->shadow;
+}
+
+/*
+ * Check the accuracy range contract, and the comparison of the counter
+ * against values around its precise sum and its possible precise range.
+ */
+static void check_counter(struct test_counter *c)
+{
+	struct percpu_counter_tree *t = &c->tree;
+	long approx = percpu_counter_tree_approximate_sum(t);
+	long precise = c->shadow, precise_min, precise_max;
+	unsigned long accuracy;
+	long values[7];
+	unsigned int i;
+
+	CHECK(percpu_counter_tree_precise_sum(t) == precise);
+	CHECK(!percpu_counter_tree_check_residuals(t));
+
+	/* precise - accuracy <= approx <= precise + accuracy */
+	accuracy = percpu_counter_tree_approximate_accuracy(t);
+	CHECK(approx >= precise - (long)accuracy);
+	CHECK(approx <= precise + (long)accuracy);
+
+	percpu_counter_tree_approximate_min_max_range(approx, accuracy,
+						      &precise_min, &precise_max);
+	CHECK(precise >= precise_min);
+	CHECK(precise <= precise_max);
+
+	/* Approximate comparison is definitive exactly outside of the precise range. */
+	CHECK(percpu_counter_tree_approximate_compare_value(t, precise_min - 1) == -1);
+	CHECK(percpu_counter_tree_approximate_compare_value(t, precise_min) == 0);
+	CHECK(percpu_counter_tree_approximate_compare_value(t, precise_max) == 0);
+	CHECK(percpu_counter_tree_approximate_compare_value(t, precise_max + 1) == 1);
+
+	values[0] = precise - 1;
+	values[1] = precise;
+	values[2] = precise + 1;
+	values[3] = precise_min - 1;
+	values[4] = precise_min;
+	values[5] = precise_max;
+	values[6] = precise_max + 1;
+	for (i = 0; i < ARRAY_SIZE(values); i++) {
+		long v = values[i];
+		int expect = sign(v - precise);
+		int res = percpu_counter_tree_approximate_compare_value(t, v);
+
+		CHECK(res == 0 || res == expect);
+		CHECK(percpu_counter_tree_precise_compare_value(t, v) == expect);
+	}
+}
+
+/* Check the comparison of two counters against their shadow sums. */
+static void check_counter_pair(struct test_counter *a, struct test_counter *b)
+{
+	int expect = sign(a->shadow - b->shadow);
+	int res = percpu_counter_tree_approximate_compare(&a->tree, &b->tree);
+
+	CHECK(res == 0 || res == expect);
+	CHECK(percpu_counter_tree_precise_compare(&a->tree, &b->tree) == expect);
+	res = percpu_counter_tree_approximate_compare(&b->tree, &a->tree);
+	CHECK(res == 0 || res == -expect);
+	CHECK(percpu_counter_tree_precise_compare(&b->tree, &a->tree) == -expect);
+}
+
+/*
+ * On each CPU, add @inc (1 or -1) until the next addition would propagate a
+ * carry to the approximate sum. This leaves every tree item on the path from
+ * this CPU to the root holding its largest residual in the direction of @inc.
+ * Each addition is first tried on @probe, which holds the same state as @c:
+ * reverting an addition which reached the approximate sum would not restore
+ * the residuals subtracted on the way. The path from a CPU to the root
+ * holds less than the accuracy bound: more additions mean that a carry was
+ * lost.
+ */
+static void saturate(struct test_counter *c, struct test_counter *probe, long inc)
+{
+	unsigned long max_steps;
+	unsigned int cpu;
+
+	max_steps = percpu_counter_tree_approximate_accuracy(&c->tree) +
+		    (1UL << c->tree.batch_order);
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		unsigned long steps;
+
+		for (steps = 0; steps < max_steps; steps++) {
+			long approx = percpu_counter_tree_approximate_sum(&probe->tree);
+
+			test_counter_add(probe, cpu, inc);
+			if (percpu_counter_tree_approximate_sum(&probe->tree) != approx) {
+				test_counter_copy(probe, c);
+				break;
+			}
+			test_counter_add(c, cpu, inc);
+		}
+		if (steps == max_steps) {
+			CHECK(0);
+			return;
+		}
+	}
+}
+
+static void test_saturated(unsigned long batch_size, long inc)
+{
+	struct test_counter c, probe, exact;
+	unsigned long accuracy;
+	long approx, delta;
+
+	if (test_counter_init(&c, batch_size)) {
+		CHECK(0);
+		return;
+	}
+	if (test_counter_init(&probe, batch_size)) {
+		CHECK(0);
+		goto destroy_c;
+	}
+	if (test_counter_init(&exact, batch_size)) {
+		CHECK(0);
+		goto destroy_probe;
+	}
+	saturate(&c, &probe, inc);
+	approx = percpu_counter_tree_approximate_sum(&c.tree);
+	accuracy = percpu_counter_tree_approximate_accuracy(&c.tree);
+	/* Symmetric residuals: the accuracy is reached in both directions. */
+	CHECK((c.shadow - approx) * inc == (long)tree_residual_capacity(batch_size));
+	CHECK((c.shadow - approx) * inc == (long)accuracy);
+	check_counter(&c);
+
+	/* Compare with exactly approximated counters around the saturated precise sum. */
+	for (delta = -1; delta <= 1; delta++) {
+		test_counter_set(&exact, c.shadow + delta);
+		CHECK(percpu_counter_tree_approximate_sum(&exact.tree) == exact.shadow);
+		check_counter_pair(&c, &exact);
+	}
+	test_counter_destroy(&exact);
+destroy_probe:
+	test_counter_destroy(&probe);
+destroy_c:
+	test_counter_destroy(&c);
+}
+
+static long random_increment(unsigned long batch_size)
+{
+	long v;
+
+	switch (rnd() % 4) {
+	case 0:
+		v = rnd() % 4;
+		break;
+	case 1:
+		v = rnd() % (4 * batch_size);
+		break;
+	case 2:
+		v = rnd() % (64 * batch_size);
+		break;
+	default:
+		v = rnd() % 1000000;
+		break;
+	}
+	return rnd() & 1 ? v : -v;
+}
+
+static void test_random_walk(unsigned long batch_size, unsigned long nr_steps)
+{
+	struct test_counter c[2];
+	unsigned long step;
+
+	if (test_counter_init(&c[0], batch_size)) {
+		CHECK(0);
+		return;
+	}
+	if (test_counter_init(&c[1], batch_size)) {
+		CHECK(0);
+		test_counter_destroy(&c[0]);
+		return;
+	}
+	for (step = 0; step < nr_steps; step++) {
+		struct test_counter *t = &c[rnd() & 1];
+
+		test_counter_add(t, rnd() % nr_cpu_ids, random_increment(batch_size));
+		/* Bring the counters close to each other to exercise the precise comparison. */
+		if (!(rnd() % 8)) {
+			long delta = c[0].shadow - c[1].shadow;
+			unsigned long accuracy;
+
+			accuracy = percpu_counter_tree_approximate_accuracy(&c[0].tree);
+			delta += (long)(rnd() % (2 * accuracy + 1)) - (long)accuracy;
+			test_counter_add(&c[1], rnd() % nr_cpu_ids, delta);
+		}
+		check_counter(t);
+		check_counter_pair(&c[0], &c[1]);
+	}
+	test_counter_destroy(&c[0]);
+	test_counter_destroy(&c[1]);
+}
+
+static const unsigned int test_nr_cpus[] = {
+	1, 2, 3, 4, 5, 8, 9, 16, 17, 32, 33, 64, 65, 100, 128, 256, 512,
+	1000, 1024, 2048, 4096, 8192, 16384, 32768, 65536,
+};
+
+/* Exhaustive mode: also cover the largest supported configurations. */
+static const unsigned int test_nr_cpus_large[] = {
+	1U << 17, 1U << 18, 1U << 19, 1U << 20,
+};
+
+static const unsigned long test_batch_sizes[] = { 2, 4, 8, 16, 32, 64, 128 };
+
+static int test_num;
+
+static int run_case(unsigned int nr_cpus, unsigned long batch_size)
+{
+	/* Each check iterates over all CPUs: bound the random walk cost. */
+	unsigned long nr_steps = 10000000 / nr_cpus;
+
+	if (nr_steps < 100)
+		nr_steps = 100;
+	if (nr_steps > 50000)
+		nr_steps = 50000;
+
+	nr_case_failures = 0;
+	hpcc_nr_warnings = 0;
+	hpcc_init_topology(nr_cpus);
+	test_saturated(batch_size, 1);
+	test_saturated(batch_size, -1);
+	test_random_walk(batch_size, nr_steps);
+	CHECK(!hpcc_nr_warnings);
+	printf("%sok %d - nr_cpus=%u batch_size=%lu\n", nr_case_failures ? "not " : "",
+	       ++test_num, nr_cpus, batch_size);
+	if (nr_case_failures > MAX_REPORTED_FAILURES)
+		printf("#   ... %lu failed checks in total\n", nr_case_failures);
+	return nr_case_failures ? 1 : 0;
+}
+
+static int run_check_config(void)
+{
+	unsigned int nr_errors = percpu_counter_tree_check_config();
+
+	printf("%sok %d - configuration table\n", nr_errors ? "not " : "", ++test_num);
+	return nr_errors ? 1 : 0;
+}
+
+static void usage(const char *name)
+{
+	fprintf(stderr, "Usage: %s [-a]\n", name);
+	fprintf(stderr, "  -a  Also test the largest supported numbers of CPUs (slow).\n");
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int i, j, nr_tests;
+	bool large = false;
+	int failed = 0;
+
+	if (argc > 2 || (argc == 2 && strcmp(argv[1], "-a"))) {
+		usage(argv[0]);
+		return 2;
+	}
+	if (argc == 2)
+		large = true;
+
+	nr_tests = 1 + ARRAY_SIZE(test_nr_cpus) * ARRAY_SIZE(test_batch_sizes);
+	if (large)
+		nr_tests += ARRAY_SIZE(test_nr_cpus_large) * ARRAY_SIZE(test_batch_sizes);
+	printf("1..%u\n", nr_tests);
+
+	failed += run_check_config();
+	for (i = 0; i < ARRAY_SIZE(test_nr_cpus); i++)
+		for (j = 0; j < ARRAY_SIZE(test_batch_sizes); j++)
+			failed += run_case(test_nr_cpus[i], test_batch_sizes[j]);
+	if (large) {
+		for (i = 0; i < ARRAY_SIZE(test_nr_cpus_large); i++)
+			for (j = 0; j < ARRAY_SIZE(test_batch_sizes); j++)
+				failed += run_case(test_nr_cpus_large[i], test_batch_sizes[j]);
+	}
+	printf("# %d/%u test cases failed\n", failed, nr_tests);
+	return failed ? 1 : 0;
+}
-- 
2.47.3


