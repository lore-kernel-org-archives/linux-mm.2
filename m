Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930E1606D801
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=u8VrgSuh
Received: by kanga.kvack.org (Postfix)
	id F09D06B05BA; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAA66B05BC; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81AA6B05BD; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1F66B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:36:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28A27A0C21
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:53 +0000 (UTC)
X-FDA: 85402224306.18.E635426
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8BDA94000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=u8VrgSuh;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911011;
	b=yV9KnIZStQzO0VEi+d/2RStCP9QkJAhCAuqOST0kLD0f/sMLHqThRYQp4j44fc17v0oBSJ
	gL98q8TK4moJcCSS0Bz+e7z/rkEPQ9NF8B0HAHgGjdiLaKp1Dxqfdr67ISjsQkaDe9b9bF
	VLnn/fP8Ia/Mf4PK6ZgOXsPEnco6OE8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=u8VrgSuh;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z41TFFLAmTTS/5jHmWp+1Ks0Ngs3R36gPuMvGNvv5wY=;
	b=l0XaVP17A+rOb2/1w4IqPR79QXNmLJfK4hNRLwQj/naC5dp5gTNLzckRlCmH8mb6OG5OId
	VNucfAVSmvngn0PMhf7VvV7+hg/9w01jAIk/S/DbV4kOcpK/QOQ6YZ7YmBxXiXE8XaW0MD
	A5ZyDCjsPhteKF8FahWaLij1YzJkNeI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793911009;
	bh=z41TFFLAmTTS/5jHmWp+1Ks0Ngs3R36gPuMvGNvv5wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8VrgSuhHOAiDOBKIUc23yXx3z8v12M53P54J6c0vrDVsVZ8li/jPiS6ok80Hk11k
	 sylYFMWD87BCQ2GdWRwxfsXEN/9bu5UclIBypUmxrLTFJu7dcO4vFoc3Ia43W+8FZv
	 ov/WOoXq+nss5Xqj4Emjpk3LKJFVxkQdBzJo96FVvHtaa2702sIkc7FNVCdxwtZ4ke
	 OuawKH0/b4DzbY8fmodhYB76vX+SbH9e9uAvDXtEK9RR7SAx6zJthiCvbv+rzK9GJe
	 z9Qtm+aw3f2NL2xI17BTkNjnyXsBm/TiNhBi8GlbD8XwE7uKG+jbbgkgO8nUAYBlvX
	 z2f3c77euNMEg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLDcd2w1WzLk9;
	Thu, 05 Nov 2026 15:36:49 -0500 (EST)
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
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v24 10/10] lib: add a benchmark of hierarchical per-cpu counters
Date: Thu,  5 Nov 2026 15:36:39 -0500
Message-Id: <20261105203639.1459524-11-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jekn19jma7dhiwfg79z6sihqbednsymq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BDA94000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793911011-611586
X-HE-Meta: U2FsdGVkX1+NLu3c4dEiLIqD3dXZhdZhreR7NSzXf7VHqEKpLqo2afdBuWVhE8QXHr2tDI5yv6D1qHOH8Z7HTz+hhFJKk3v/k/DxTsPqlVe0U6g3DvG/E4h7eLhpL3JO+uzx4Tk+NTJC/eiYF+dqHJZPfw8r9L748ce6M+4+GjMoPi1yuO597JTltgCTOfpU4WJfxPFPyzui7EZCXcW48RvUuZ4NXwFWjePXTl+LSMS6afBTFbicq+l3TziSbNfg3Jc1DnayFh/3686S2ajr5TQ6R/Hf7pO2wIxTjMwW5H18R5qO1/+cIABKTN0JokZeQiBsLpq0oNHR1Z529dUXDz/RMwuuwC6f6ZhRmT4ne/88jymV7UVn4MW+WtNPhWriNKfevH02reawww3Z2UMcrEcPZOja8Xmjj4PSfTELmuvK/d9V7kUE+knf5/k2/bhveA5Ty+GRQS9GeqLcBv+fLdkVdeMQ0FfWGNVzvx8vxr7bn8RSD0ttxOGkQRDgEASdp/mzZGOu8JUuywtXYNZqbqUU5pAvIo0lkDOPjoqyDnfE7hwctm6HcR3TPPCdgTQ/beDAtz+IPpoW/kRToIq8E1F24iNlozvOWQ2o81YfBxnt3ns4Q6UxyyvvwYRDRuFfkLgGdItCxqxxW2znZMtTiQEmY7tRf5kdv+9N3rr4GZfoaL3TnZ8ZKX8AL43sXL/a8MrcneRjyV1RKmI2M/HMRHDT8JMYANeHwyx5tt6xeK6tuFgocON8ZzCXw5bFol6AHsOQpiM9IZExEpL7P0F8JpCQb8jxxuLEw2uGj8EHYDOUy3Z2+WNRvV5ngQCjqmNHiQ844mRzWOIMZPKbXZTeKq6ubsR3N06wyIXv2Hidf6ntJhpGqZTXZtB9tfeZLNkXU9kMEv4hFq4tDvNtbBvErxf8AGH9xiK2IDhX6LmBAq0ELaa50MGDvkZcJ5ITzD8tyAIGqMd4CuU8tuPdKXl
 F1iCouGu
 w+ebeWlDNu3YpWIeYP9I7M+A2fM4Qae9wA7bW4VuUibn9nJOP17llORYapIXISpp1c3KPv1q2jcQCQTWcsDCiPKWyvLldXpVn/ZFBo/pXs03I4tf4c9oHv8ndX1g+WR0d4iGbFHoK6ahXUt5QoPEP6dLj1N5Zx13vJf57XJY0UPuXI1UBoleeCzPcaS4wHzXSwNmkaKSguUbNoFoU5mrXm70t9ZczWT2HdFZj3JxHZeQH9b1inQpkhvesmu+ivUSgWVtqGJq2oWEZ9UwBuXf3EaOTCXEAHh3VFCGuE+ZSCoHZpwzXTn/JT2bZnnGP2fjaLKIixPQ6rlxf15Xdgx+VDf2VrtV1JG7cNXTKGkVtf9rd4gaNxtIQyWoI/PqNNH7DtUhw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a KUnit benchmark comparing the hierarchical per-cpu counters with
struct percpu_counter, so their performance can be compared on various
machines:

- update: cost of an update with a kthread on each online CPU, on one
  shared counter, on one counter per thread, on groups of 4 counters
  initialized together like the RSS counters of an mm, and on one lazily
  initialized counter per thread updated by its owner, like a
  single-threaded process, with increments of +1, alternating +1/-1, and
  random increments up to 32 and 512.
- lifecycle: cost of initializing and destroying 4 counters together,
  like fork and exit of an mm, eagerly or lazily, from one thread or from
  all online CPUs.
- churn: like lifecycle, with a few updates, keeping some of the
  counters alive until the end, like long-lived processes.

The batch size of the hierarchical counters is selected with the
percpu_counter_tree_bench.batch= parameter (32 by default, like the RSS
counters), and the tree shape with the percpu_counter_tree.arity= boot
parameter.  The struct percpu_counter variants use their default batch
size, like the RSS counters before the hierarchical counters.

The benchmark reports the accuracy of both counter implementations along
with the timings.  It runs for a few minutes on large machines, so it
has its own config option, CONFIG_PERCPU_COUNTER_TREE_BENCH.

For example:

  ./tools/testing/kunit/kunit.py run --arch=x86_64 \
	--kconfig_add CONFIG_PERCPU_COUNTER_TREE_BENCH=y \
	--kconfig_add CONFIG_NR_CPUS=256 --qemu_args="-smp 64 -m 8192" \
	--kernel_args percpu_counter_tree.arity=8,8 \
	--kernel_args percpu_counter_tree_bench.batch=16 \
	--timeout 3000 percpu_counter_tree_bench

or, on a running kernel with CONFIG_PERCPU_COUNTER_TREE_BENCH=m:

  modprobe percpu_counter_tree_bench batch=16

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
Changes since v23:
- Keep the lifecycle and churn sets of counters in struct bench_thread
  rather than on the stack, where debugobjects warns about a struct
  percpu_counter. (Reported by Sashiko.)
---
 MAINTAINERS                           |   1 +
 lib/Kconfig                           |  15 +
 lib/tests/Makefile                    |   1 +
 lib/tests/percpu_counter_tree_bench.c | 610 ++++++++++++++++++++++++++
 4 files changed, 627 insertions(+)
 create mode 100644 lib/tests/percpu_counter_tree_bench.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d421a784e88..3878203de1c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11955,6 +11955,7 @@ S:	Supported
 F:	Documentation/core-api/percpu-counter-tree.rst
 F:	include/linux/percpu_counter_tree.h
 F:	lib/percpu_counter_tree.c
+F:	lib/tests/percpu_counter_tree_bench.c
 F:	lib/tests/percpu_counter_tree_kunit.c
 F:	tools/testing/hpcc/
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 3921177a0d24..6ab9644a4cb8 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -53,6 +53,21 @@ config PERCPU_COUNTER_TREE_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config PERCPU_COUNTER_TREE_BENCH
+	tristate "Benchmark of hierarchical per-cpu counters"
+	depends on KUNIT && SMP
+	help
+	  This builds a KUnit benchmark comparing the hierarchical per-cpu
+	  counters with struct percpu_counter: update cost with all online
+	  CPUs updating shared and private counters, and init/destroy cost.
+	  It runs for a few minutes on large machines.
+
+	  The batch size and the tree shape can be changed with the
+	  percpu_counter_tree_bench.batch= and percpu_counter_tree.arity=
+	  parameters, see lib/tests/percpu_counter_tree_bench.c.
+
+	  When in doubt, say N.
+
 config BITREVERSE
 	tristate
 	select GENERIC_BITREVERSE if !HAVE_ARCH_BITREVERSE
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index e98687da8706..d158a8be8a19 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -60,5 +60,6 @@ obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
 obj-$(CONFIG_PERCPU_COUNTER_TREE_KUNIT_TEST) += percpu_counter_tree_kunit.o
+obj-$(CONFIG_PERCPU_COUNTER_TREE_BENCH) += percpu_counter_tree_bench.o
 
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/percpu_counter_tree_bench.c b/lib/tests/percpu_counter_tree_bench.c
new file mode 100644
index 000000000000..e041ba8ba8c7
--- /dev/null
+++ b/lib/tests/percpu_counter_tree_bench.c
@@ -0,0 +1,610 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+/*
+ * Benchmark of hierarchical per-CPU counters against struct percpu_counter.
+ *
+ * update: ns per percpu_counter_tree_add() per thread, one kthread pinned
+ *         on each online CPU, on one shared counter, on one counter per
+ *         thread, or on the counters of a few mm-like groups of 4 counters
+ *         initialized together. The "single" variant gives each thread a
+ *         lazily initialized counter updated with
+ *         percpu_counter_tree_add_owner(), like a single-threaded process.
+ *         The "percpu_counter" variants use percpu_counter_add() with the
+ *         default batch, like the RSS counters before hierarchical counters.
+ * lifecycle: ns per init_many(4) + destroy_many(4), like fork + exit of an
+ *         mm, from one thread or from all online CPUs at once; "lazy" uses
+ *         init_many_lazy(4), like a single-threaded process.
+ * churn: like lifecycle with a few updates, keeping one in @pin_period sets
+ *         of counters alive until the end, like long-lived processes.
+ *
+ * Each result ends with the implementation measured: "tree" for the
+ * hierarchical counters, "percpu_counter" for struct percpu_counter.
+ *
+ * The knobs to try on a given machine are:
+ * - the batch size: percpu_counter_tree_bench.batch=<2..128> (power of 2),
+ *   or "modprobe percpu_counter_tree_bench batch=<n>",
+ * - the tree shape: percpu_counter_tree.arity=<fan-out>,... on the kernel
+ *   command line, from level 0 to the root. The product of the fan-outs
+ *   is nr_cpu_ids rounded up to a power of 2, e.g. "16" (flat) or "4,4"
+ *   when nr_cpu_ids is 16. The shape in use is shown in
+ *   /sys/module/percpu_counter_tree/parameters/arity.
+ *
+ * For example, in a VM:
+ *   ./tools/testing/kunit/kunit.py run --arch=x86_64 \
+ *	--kconfig_add CONFIG_PERCPU_COUNTER_TREE_BENCH=y \
+ *	--kconfig_add CONFIG_NR_CPUS=256 --qemu_args="-smp 64 -m 8192" \
+ *	--kernel_args percpu_counter_tree.arity=8,8 \
+ *	--kernel_args percpu_counter_tree_bench.batch=16 \
+ *	--timeout 3000 percpu_counter_tree_bench
+ */
+#include <kunit/test.h>
+#include <linux/percpu_counter_tree.h>
+#include <linux/percpu_counter.h>
+#include <linux/kthread.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/ktime.h>
+#include <linux/math64.h>
+#include <linux/sched/task.h>
+#include <linux/cpuhplock.h>
+#include <linux/moduleparam.h>
+
+/* Like the RSS counters by default. */
+static unsigned int batch = 32;
+module_param(batch, uint, 0444);
+MODULE_PARM_DESC(batch, "Batch size of the hierarchical counters (power of 2, 2 to 128)");
+
+#define BENCH_MS	300
+#define LIFECYCLE_NR	4	/* Counters per mm. */
+#define LIFECYCLE_ITER	2000
+#define CHURN_ITER	4096
+
+enum { W_MONO, W_BOUNCE, W_RAND32, W_RAND512, NR_W };
+static const char * const wname[] = { "monotonic +1", "bounce +-1", "random +-32", "random +-512" };
+
+enum bench_impl { IMPL_TREE, IMPL_PERCPU_COUNTER };
+static const char * const impl_name[] = { "tree", "percpu_counter" };
+
+struct bench_shared {
+	atomic_t ready;
+	int wl;
+	unsigned int pin_period;	/* churn: keep one in pin_period sets, 0: none. */
+	enum bench_impl impl;
+	bool go, stop;
+	bool owner;		/* update: percpu_counter_tree_add_owner(). */
+	bool lifecycle;
+	bool lazy;		/* lifecycle: percpu_counter_tree_init_many_lazy(). */
+};
+
+struct bench_thread {
+	u64 ns;
+	unsigned long ops;
+	struct bench_shared *sh;
+	struct percpu_counter_tree *c;
+	struct percpu_counter *pc;	/* update: IMPL_PERCPU_COUNTER. */
+	struct percpu_counter_tree *pinned;	/* churn: IMPL_TREE sets kept alive. */
+	struct percpu_counter *pinned_pc;	/* churn: IMPL_PERCPU_COUNTER sets kept alive. */
+	struct task_struct *task;
+	unsigned int nr_pinned;
+	u32 seed;
+	/*
+	 * lifecycle and churn: sets not kept alive. They are not on the
+	 * stack, where debugobjects warns about a struct percpu_counter.
+	 */
+	struct percpu_counter_tree tmp[LIFECYCLE_NR];
+	struct percpu_counter tmp_pc[LIFECYCLE_NR];
+} ____cacheline_aligned_in_smp;
+
+/*
+ * Buffers are allocated through KUnit, which frees them if an assertion
+ * aborts the test, and are freed explicitly otherwise, since the benchmark
+ * runs many steps within one test.
+ */
+KUNIT_DEFINE_ACTION_WRAPPER(bench_kvfree, kvfree, const void *);
+
+static void *bench_kvzalloc(struct kunit *test, size_t size)
+{
+	void *p = kvzalloc(size, GFP_KERNEL);
+
+	if (p && kunit_add_action_or_reset(test, bench_kvfree, p))
+		return NULL;
+	return p;
+}
+
+static void bench_kvfree_now(struct kunit *test, void *p)
+{
+	kunit_release_action(test, bench_kvfree, p);
+}
+
+/* Wait for the start signal; return true if the benchmark is cancelled. */
+static bool bench_wait_go(struct bench_shared *sh)
+{
+	atomic_inc(&sh->ready);
+	/* Pairs with bench_start(): a cancellation sets stop before go. */
+	while (!smp_load_acquire(&sh->go))
+		cond_resched();
+	return READ_ONCE(sh->stop);
+}
+
+static int bench_update_fn(void *data)
+{
+	struct bench_thread *t = data;
+	struct bench_shared *sh = t->sh;
+	unsigned long ops = 0;
+	long sign = -1;
+	u32 x = t->seed;
+	int i;
+
+	if (bench_wait_go(sh))
+		return 0;
+	while (!READ_ONCE(sh->stop)) {
+		for (i = 0; i < 1024; i++) {
+			long inc;
+
+			switch (sh->wl) {
+			case W_MONO:
+				inc = 1;
+				break;
+			case W_BOUNCE:
+				inc = sign;
+				sign = -sign;
+				break;
+			default:
+				x ^= x << 13;
+				x ^= x >> 17;
+				x ^= x << 5;
+				inc = sh->wl == W_RAND32 ? 32 : 512;
+				if (x & 1)
+					inc = -inc;
+				break;
+			}
+			if (sh->impl == IMPL_PERCPU_COUNTER)
+				percpu_counter_add(t->pc, inc);
+			else if (sh->owner)
+				percpu_counter_tree_add_owner(t->c, inc);
+			else
+				percpu_counter_tree_add(t->c, inc);
+		}
+		ops += 1024;
+		cond_resched();
+	}
+	t->ops = ops;
+	return 0;
+}
+
+static int bench_lifecycle_fn(void *data)
+{
+	struct bench_thread *t = data;
+	struct percpu_counter_tree *c = t->tmp;
+	struct percpu_counter *pc = t->tmp_pc;
+	u64 t0;
+	int i;
+
+	if (bench_wait_go(t->sh))
+		return 0;
+	t0 = ktime_get_ns();
+	for (i = 0; t->sh->impl == IMPL_PERCPU_COUNTER && i < LIFECYCLE_ITER; i++) {
+		if (percpu_counter_init_many(pc, 0, GFP_KERNEL, LIFECYCLE_NR))
+			break;
+		percpu_counter_add(&pc[0], 1);
+		percpu_counter_add(&pc[0], -1);
+		percpu_counter_destroy_many(pc, LIFECYCLE_NR);
+		cond_resched();
+	}
+	for (; t->sh->impl == IMPL_TREE && t->sh->lazy && i < LIFECYCLE_ITER; i++) {
+		if (percpu_counter_tree_init_many_lazy(c, LIFECYCLE_NR, batch))
+			break;
+		percpu_counter_tree_add_owner(&c[0], 1);
+		percpu_counter_tree_add_owner(&c[0], -1);
+		percpu_counter_tree_destroy_many(c, LIFECYCLE_NR);
+		cond_resched();
+	}
+	for (; t->sh->impl == IMPL_TREE && !t->sh->lazy && i < LIFECYCLE_ITER; i++) {
+		if (percpu_counter_tree_init_many(c, LIFECYCLE_NR, batch, GFP_KERNEL))
+			break;
+		percpu_counter_tree_add(&c[0], 1);
+		percpu_counter_tree_add(&c[0], -1);
+		percpu_counter_tree_destroy_many(c, LIFECYCLE_NR);
+		cond_resched();
+	}
+	t->ns = ktime_get_ns() - t0;
+	t->ops = i;
+	return 0;
+}
+
+static int bench_churn_fn(void *data)
+{
+	struct bench_thread *t = data;
+	unsigned int pin_period = t->sh->pin_period;
+	struct percpu_counter_tree *c;
+	struct percpu_counter *pc;
+	u64 t0;
+	int i;
+
+	if (bench_wait_go(t->sh))
+		return 0;
+	t0 = ktime_get_ns();
+	for (i = 0; t->sh->impl == IMPL_PERCPU_COUNTER && i < CHURN_ITER; i++) {
+		bool pin = pin_period && !(i % pin_period);
+
+		pc = pin ? &t->pinned_pc[t->nr_pinned * LIFECYCLE_NR] : t->tmp_pc;
+		if (percpu_counter_init_many(pc, 0, GFP_KERNEL, LIFECYCLE_NR))
+			break;
+		percpu_counter_add(&pc[0], 100);
+		percpu_counter_add(&pc[1], -77);
+		percpu_counter_add(&pc[2], 1);
+		if (pin)
+			t->nr_pinned++;
+		else
+			percpu_counter_destroy_many(pc, LIFECYCLE_NR);
+		cond_resched();
+	}
+	for (; t->sh->impl == IMPL_TREE && i < CHURN_ITER; i++) {
+		bool pin = pin_period && !(i % pin_period);
+
+		c = pin ? &t->pinned[t->nr_pinned * LIFECYCLE_NR] : t->tmp;
+		if (percpu_counter_tree_init_many(c, LIFECYCLE_NR, batch, GFP_KERNEL))
+			break;
+		percpu_counter_tree_add(&c[0], 100);
+		percpu_counter_tree_add(&c[1], -77);
+		percpu_counter_tree_add(&c[2], 1);
+		if (pin)
+			t->nr_pinned++;
+		else
+			percpu_counter_tree_destroy_many(c, LIFECYCLE_NR);
+		cond_resched();
+	}
+	t->ns = ktime_get_ns() - t0;
+	t->ops = i;
+	return 0;
+}
+
+/* List at most @max online CPUs in @cpus, and return their number. */
+static unsigned int bench_cpus(int *cpus, unsigned int max)
+{
+	unsigned int n = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (n == max)
+			break;
+		cpus[n++] = cpu;
+	}
+	return n;
+}
+
+static void bench_stop(struct bench_thread *t, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		kthread_stop_put(t[i].task);
+}
+
+/*
+ * Start a thread on each of the @n CPUs of @cpus, waiting for the start
+ * signal. On failure, cancel and join the threads already started.
+ */
+static int bench_start(struct bench_shared *sh, struct bench_thread *t, const int *cpus,
+		       unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		t[i].sh = sh;
+		t[i].task = kthread_create_on_cpu(sh->pin_period != UINT_MAX ? bench_churn_fn :
+						  sh->lifecycle ? bench_lifecycle_fn :
+						  bench_update_fn, &t[i], cpus[i], "hpcc_bench/%u");
+		if (IS_ERR(t[i].task)) {
+			int ret = PTR_ERR(t[i].task);
+
+			WRITE_ONCE(sh->stop, true);
+			/* Pairs with bench_wait_go(): the threads see stop with go. */
+			smp_store_release(&sh->go, true);
+			bench_stop(t, i);
+			return ret;
+		}
+		get_task_struct(t[i].task);
+		wake_up_process(t[i].task);
+	}
+	while (atomic_read(&sh->ready) < n)
+		usleep_range(1000, 2000);
+	return 0;
+}
+
+enum bench_mode { BENCH_SHARED, BENCH_PRIVATE, BENCH_MM, BENCH_SINGLE };
+static const char * const mode_name[] = { "shared", "private", "mm", "single" };
+
+/*
+ * BENCH_SHARED: all threads update one counter.
+ * BENCH_PRIVATE: each thread updates its own counter (a separate mm).
+ * BENCH_MM: blocks of n / LIFECYCLE_NR threads each update one counter of
+ * one mm. Its counters share the cache lines of their tree items, and
+ * CPUs sharing an item are strided, so each line is updated for every
+ * counter.
+ * BENCH_SINGLE: each thread owns a lazily initialized counter, like a
+ * single-threaded process, never activated. Its IMPL_PERCPU_COUNTER
+ * comparison is BENCH_PRIVATE.
+ */
+/* Counters @i of bench_update(), @c_stride and @pc_stride bytes apart. */
+#define BENCH_C(i)	((struct percpu_counter_tree *)((char *)c + (i) * c_stride))
+#define BENCH_PC(i)	((struct percpu_counter *)((char *)pc + (i) * pc_stride))
+
+static void bench_update(struct kunit *test, enum bench_mode mode, int wl,
+			 enum bench_impl impl)
+{
+	bool shared = mode == BENCH_SHARED || mode == BENCH_MM;
+	unsigned int n, i, nr_counters, nr_init = 0;
+	struct bench_shared sh = { .wl = wl, .pin_period = UINT_MAX, .impl = impl,
+				   .owner = mode == BENCH_SINGLE };
+	struct percpu_counter_tree *c;
+	struct percpu_counter *pc;
+	struct bench_thread *t;
+	unsigned long ops = 0;
+	unsigned int *perm;
+	size_t c_stride, pc_stride;
+	void *c_mem, *pc_mem;
+	u64 t0, t1;
+	int *cpus;
+	int ret;
+
+	cpus = kunit_kcalloc(test, nr_cpu_ids, sizeof(*cpus), GFP_KERNEL);
+	t = bench_kvzalloc(test, array_size(nr_cpu_ids, sizeof(*t)));
+	perm = kunit_kcalloc(test, nr_cpu_ids, sizeof(*perm), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, cpus);
+	KUNIT_ASSERT_NOT_NULL(test, t);
+	KUNIT_ASSERT_NOT_NULL(test, perm);
+	/*
+	 * Set up the counters for the CPUs online now, before taking
+	 * cpus_read_lock(), which a failed assertion would leave held. The
+	 * threads then run on the CPUs online under the lock, at most as many.
+	 */
+	n = num_online_cpus();
+	nr_counters = mode == BENCH_SHARED ? 1 : mode == BENCH_MM ? LIFECYCLE_NR : n;
+	/*
+	 * Each private counter is written by its own thread: give each its
+	 * own cache line, as the RSS counters of separate mms, to avoid false
+	 * sharing. The counters of one mm stay packed, as in mm_struct.
+	 */
+	c_stride = shared ? sizeof(*c) : ALIGN(sizeof(*c), SMP_CACHE_BYTES);
+	pc_stride = shared ? sizeof(*pc) : ALIGN(sizeof(*pc), SMP_CACHE_BYTES);
+	c_mem = kunit_kzalloc(test, nr_counters * c_stride + SMP_CACHE_BYTES, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, c_mem);
+	c = PTR_ALIGN(c_mem, SMP_CACHE_BYTES);
+	pc_mem = kunit_kzalloc(test, nr_counters * pc_stride + SMP_CACHE_BYTES, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, pc_mem);
+	pc = PTR_ALIGN(pc_mem, SMP_CACHE_BYTES);
+	/*
+	 * Each private counter stands for a separate mm: initialize them
+	 * separately so they do not share the cache lines of their tree items.
+	 */
+	if (impl == IMPL_PERCPU_COUNTER && mode == BENCH_MM) {
+		if (!percpu_counter_init_many(pc, 0, GFP_KERNEL, nr_counters))
+			nr_init = nr_counters;
+	} else if (impl == IMPL_PERCPU_COUNTER) {
+		for (; nr_init < nr_counters; nr_init++)
+			if (percpu_counter_init(BENCH_PC(nr_init), 0, GFP_KERNEL))
+				break;
+	} else if (mode == BENCH_MM) {
+		if (!percpu_counter_tree_init_many(c, nr_counters, batch, GFP_KERNEL))
+			nr_init = nr_counters;
+	} else {
+		for (; nr_init < nr_counters; nr_init++) {
+			if (mode == BENCH_SINGLE ?
+			    percpu_counter_tree_init_many_lazy(BENCH_C(nr_init), 1, batch) :
+			    percpu_counter_tree_init(BENCH_C(nr_init), batch, GFP_KERNEL))
+				break;
+		}
+	}
+	if (nr_init < nr_counters) {
+		KUNIT_FAIL(test, "cannot initialize %u counters", nr_counters);
+		goto destroy;
+	}
+	cpus_read_lock();
+	n = bench_cpus(cpus, n);
+	/* Random placement of the private counters. */
+	for (i = 0; i < n; i++)
+		perm[i] = mode == BENCH_SHARED ? 0 : mode == BENCH_MM ? i * LIFECYCLE_NR / n : i;
+	for (i = n - 1; !shared && i > 0; i--)
+		swap(perm[i], perm[get_random_u32_below(i + 1)]);
+	for (i = 0; i < n; i++) {
+		t[i].c = BENCH_C(perm[i]);
+		t[i].pc = BENCH_PC(perm[i]);
+		t[i].seed = get_random_u32() | 1;
+	}
+	ret = bench_start(&sh, t, cpus, n);
+	if (ret) {
+		cpus_read_unlock();
+		KUNIT_FAIL(test, "cannot start the benchmark threads: %d", ret);
+		goto destroy;
+	}
+	t0 = ktime_get_ns();
+	WRITE_ONCE(sh.go, true);
+	msleep(BENCH_MS);
+	WRITE_ONCE(sh.stop, true);
+	t1 = ktime_get_ns();
+	bench_stop(t, n);
+	cpus_read_unlock();
+	for (i = 0; i < n; i++)
+		ops += t[i].ops;
+	for (i = 0; impl == IMPL_TREE && i < nr_counters; i++)
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_check_residuals(BENCH_C(i)));
+	kunit_info(test, "update %-8s %-14s %3u thr %10llu ns/op/thr %s\n",
+		   mode_name[mode], wname[wl], n,
+		   ops ? div64_ul((t1 - t0) * n, ops) : 0, impl_name[impl]);
+destroy:
+	if (impl == IMPL_PERCPU_COUNTER && mode == BENCH_MM) {
+		if (nr_init)
+			percpu_counter_destroy_many(pc, nr_counters);
+	} else if (impl == IMPL_PERCPU_COUNTER) {
+		for (i = 0; i < nr_init; i++)
+			percpu_counter_destroy(BENCH_PC(i));
+	} else if (mode == BENCH_MM) {
+		if (nr_init)
+			percpu_counter_tree_destroy_many(c, nr_counters);
+	} else {
+		for (i = 0; i < nr_init; i++)
+			percpu_counter_tree_destroy(BENCH_C(i));
+	}
+	kunit_kfree(test, pc_mem);
+	kunit_kfree(test, c_mem);
+	kunit_kfree(test, perm);
+	bench_kvfree_now(test, t);
+	kunit_kfree(test, cpus);
+}
+
+static void bench_lifecycle(struct kunit *test, bool all, enum bench_impl impl, bool lazy)
+{
+	struct bench_shared sh = { .lifecycle = true, .pin_period = UINT_MAX,
+				   .impl = impl, .lazy = lazy };
+	unsigned int n, i;
+	struct bench_thread *t;
+	unsigned long ops = 0;
+	u64 ns = 0;
+	int *cpus;
+	int ret;
+
+	cpus = kunit_kcalloc(test, nr_cpu_ids, sizeof(*cpus), GFP_KERNEL);
+	t = bench_kvzalloc(test, array_size(nr_cpu_ids, sizeof(*t)));
+	KUNIT_ASSERT_NOT_NULL(test, cpus);
+	KUNIT_ASSERT_NOT_NULL(test, t);
+	cpus_read_lock();
+	n = bench_cpus(cpus, all ? num_online_cpus() : 1);
+	ret = bench_start(&sh, t, cpus, n);
+	if (ret) {
+		cpus_read_unlock();
+		KUNIT_FAIL(test, "cannot start the benchmark threads: %d", ret);
+		goto free;
+	}
+	WRITE_ONCE(sh.go, true);
+	bench_stop(t, n);
+	cpus_read_unlock();
+	for (i = 0; i < n; i++) {
+		ops += t[i].ops;
+		ns += t[i].ns;
+	}
+	KUNIT_EXPECT_EQ(test, ops, (unsigned long)n * LIFECYCLE_ITER);
+	kunit_info(test, "lifecycle init_many%s(%d)+destroy_many %3u thr %10llu ns/op %s\n",
+		   lazy ? "_lazy" : "", LIFECYCLE_NR, n, ops ? div64_ul(ns, ops) : 0,
+		   impl_name[impl]);
+free:
+	bench_kvfree_now(test, t);
+	kunit_kfree(test, cpus);
+}
+
+static void bench_churn(struct kunit *test, bool all, unsigned int pin_period,
+			enum bench_impl impl)
+{
+	struct bench_shared sh = { .pin_period = pin_period, .impl = impl };
+	unsigned int n, i, j, max_pinned = pin_period ? DIV_ROUND_UP(CHURN_ITER, pin_period) : 0;
+	unsigned long ops = 0, live = 0;
+	unsigned int nr_alloc;
+	struct bench_thread *t;
+	u64 ns = 0;
+	int *cpus;
+	int ret;
+
+	cpus = kunit_kcalloc(test, nr_cpu_ids, sizeof(*cpus), GFP_KERNEL);
+	t = bench_kvzalloc(test, array_size(nr_cpu_ids, sizeof(*t)));
+	KUNIT_ASSERT_NOT_NULL(test, cpus);
+	KUNIT_ASSERT_NOT_NULL(test, t);
+	/* Allocate before taking cpus_read_lock(), as in bench_update(). */
+	nr_alloc = all ? num_online_cpus() : 1;
+	for (i = 0; i < nr_alloc; i++) {
+		t[i].pinned = bench_kvzalloc(test, array_size(max_pinned * LIFECYCLE_NR + 1,
+							      sizeof(*t[i].pinned)));
+		t[i].pinned_pc = bench_kvzalloc(test, array_size(max_pinned * LIFECYCLE_NR + 1,
+								 sizeof(*t[i].pinned_pc)));
+		KUNIT_ASSERT_NOT_NULL(test, t[i].pinned_pc);
+		KUNIT_ASSERT_NOT_NULL(test, t[i].pinned);
+	}
+	cpus_read_lock();
+	n = bench_cpus(cpus, nr_alloc);
+	ret = bench_start(&sh, t, cpus, n);
+	if (ret) {
+		cpus_read_unlock();
+		KUNIT_FAIL(test, "cannot start the benchmark threads: %d", ret);
+		goto destroy;
+	}
+	WRITE_ONCE(sh.go, true);
+	bench_stop(t, n);
+	cpus_read_unlock();
+	for (i = 0; i < n; i++) {
+		ops += t[i].ops;
+		ns += t[i].ns;
+		live += t[i].nr_pinned * LIFECYCLE_NR;
+	}
+	KUNIT_EXPECT_EQ(test, ops, (unsigned long)n * CHURN_ITER);
+	kunit_info(test, "churn pin 1/%-4u %3u thr %8llu ns/op live %6lu %s\n",
+		   pin_period, n, ops ? div64_ul(ns, ops) : 0, live, impl_name[impl]);
+destroy:
+	for (i = 0; i < nr_alloc; i++) {
+		for (j = 0; j < t[i].nr_pinned; j++) {
+			if (impl == IMPL_PERCPU_COUNTER)
+				percpu_counter_destroy_many(&t[i].pinned_pc[j * LIFECYCLE_NR],
+							    LIFECYCLE_NR);
+			else
+				percpu_counter_tree_destroy_many(&t[i].pinned[j * LIFECYCLE_NR],
+								 LIFECYCLE_NR);
+		}
+		bench_kvfree_now(test, t[i].pinned_pc);
+		bench_kvfree_now(test, t[i].pinned);
+	}
+	bench_kvfree_now(test, t);
+	kunit_kfree(test, cpus);
+}
+
+static void hpcc_bench(struct kunit *test)
+{
+	static const unsigned int pin_periods[] = { 0, 256, 64, 16, 4 };
+	struct percpu_counter_tree probe;
+	unsigned int p;
+	int wl;
+
+	if (batch < 2 || !is_power_of_2(batch) || batch > PERCPU_COUNTER_TREE_MAX_BATCH)
+		kunit_skip(test, "invalid batch size %u", batch);
+	KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_init(&probe, batch, GFP_KERNEL));
+	kunit_info(test, "%u CPUs online, nr_cpu_ids %u\n", num_online_cpus(), nr_cpu_ids);
+	kunit_info(test, "%s batch %u, accuracy +-%lu\n", impl_name[IMPL_TREE], batch,
+		   percpu_counter_tree_approximate_accuracy(&probe));
+	kunit_info(test, "%s batch %d, accuracy +-%lu\n", impl_name[IMPL_PERCPU_COUNTER],
+		   percpu_counter_batch, (unsigned long)nr_cpu_ids * (percpu_counter_batch - 1));
+	percpu_counter_tree_destroy(&probe);
+	bench_lifecycle(test, false, IMPL_TREE, false);
+	bench_lifecycle(test, false, IMPL_TREE, true);
+	bench_lifecycle(test, false, IMPL_PERCPU_COUNTER, false);
+	bench_lifecycle(test, true, IMPL_TREE, false);
+	bench_lifecycle(test, true, IMPL_TREE, true);
+	bench_lifecycle(test, true, IMPL_PERCPU_COUNTER, false);
+	for (p = 0; p < ARRAY_SIZE(pin_periods); p++) {
+		bench_churn(test, false, pin_periods[p], IMPL_TREE);
+		bench_churn(test, false, pin_periods[p], IMPL_PERCPU_COUNTER);
+		bench_churn(test, true, pin_periods[p], IMPL_TREE);
+		bench_churn(test, true, pin_periods[p], IMPL_PERCPU_COUNTER);
+	}
+	for (wl = 0; wl < NR_W; wl++) {
+		bench_update(test, BENCH_SHARED, wl, IMPL_TREE);
+		bench_update(test, BENCH_SHARED, wl, IMPL_PERCPU_COUNTER);
+		bench_update(test, BENCH_PRIVATE, wl, IMPL_TREE);
+		bench_update(test, BENCH_PRIVATE, wl, IMPL_PERCPU_COUNTER);
+		bench_update(test, BENCH_MM, wl, IMPL_TREE);
+		bench_update(test, BENCH_MM, wl, IMPL_PERCPU_COUNTER);
+		bench_update(test, BENCH_SINGLE, wl, IMPL_TREE);
+	}
+}
+
+static struct kunit_case hpcc_bench_cases[] = {
+	KUNIT_CASE_SLOW(hpcc_bench),
+	{}
+};
+
+static struct kunit_suite hpcc_bench_suite = {
+	.name = "percpu_counter_tree_bench",
+	.test_cases = hpcc_bench_cases,
+};
+
+kunit_test_suite(hpcc_bench_suite);
+
+MODULE_DESCRIPTION("Benchmark for hierarchical per-CPU counters");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.47.3


