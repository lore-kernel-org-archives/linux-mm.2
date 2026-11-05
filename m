Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F087460A261C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Jbx2Pupq
Received: by kanga.kvack.org (Postfix)
	id BAE2D6B05B5; Thu,  5 Nov 2026 15:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B377C6B05B6; Thu,  5 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ACE6B05B7; Thu,  5 Nov 2026 15:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF646B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:36:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE00AC0C26
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:49 +0000 (UTC)
X-FDA: 85402224138.26.F420449
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2507214000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Jbx2Pupq;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NExlCAuVenVrdev4I8pyDtaJQmhEMVf3AC2GANcPlas=;
	b=HSeTunWbQb1EWMP7YCn5meqWtIjjW/mc7Cfjt2qRS9/HJCssLFUbjI5Ol+DiNbvWMaz/w4
	bGwh6lgmzlOFSeZP3nVyw34O+q2NGiqr1anPL6JzKHlTMT4vb40qA0wdNBKIY1KEIArMgg
	GUhxTtPi6X8gHNkOxU+r2cp+wDKupYg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Jbx2Pupq;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911008;
	b=xLL29FLpTGkB/Bopu9M0oB/G/KvIeirMwwd6Jx/gYgyYisu+PC1hUbElZtXepn2+JZUzVR
	GuVopEFZXQ7McIjbFQrAWbSwpUa4+s1q7NHK3vrBo5J27+pMEK0bDAS9GobCIshs07dPhE
	SEXgnGXnW1AqHL8wi/471Bs83ircxeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793911007;
	bh=NExlCAuVenVrdev4I8pyDtaJQmhEMVf3AC2GANcPlas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jbx2PupqZkvkyk5Zz5/FP0K/wb6d6KGkXzuhJDjErVb5cdGvSiRqrHs6HdUsuuMX0
	 Lpd4eCdF3/Qj3ZW2/Z+NGiKz88bXeOR/9+cYqasOarxCuucrdMF8tGIIy3D1Bi8S9T
	 +OQJEo8sT/orYeHrkfCu/yL9iV3jvsfNcl7yYm7iX8494EYS94jl0gH5JqYgR8r0Jr
	 enHoumai0t/D3aFF9Q7Gl3CnUVusha+siNfzb+NrkpLd7AwaipcRPxHGX7ZU7CvOPN
	 CZ0nBZ65vjwPUgaBrhBqi0YX+fAnsNL+M4Y7dAFG48z23m2JePVfRJGC18/txW9c9w
	 nk0MuPlczV/6Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLDcb3GffzKVS;
	Thu, 05 Nov 2026 15:36:47 -0500 (EST)
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
Subject: [RFC PATCH v24 02/10] lib: test hierarchical per-cpu counters
Date: Thu,  5 Nov 2026 15:36:31 -0500
Message-Id: <20261105203639.1459524-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2507214000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: np3xcqd1rib9ipruawqmho5iysd1to3t
X-HE-Tag: 1793911007-16729
X-HE-Meta: U2FsdGVkX1/mcJDZc9GL86FzYwHmH1PYIKaBSzcuyO/k5AEOYfk4LpAtaoCLFCvos23bHnfofMCJxEQV0JnvIhzhWlBRWvmFz3tFSQimnA0CNad43aPvliLek1dINDcSlrDQNX0hFIokeUFtyP5c8Pv48vNjnG97fbKoQTIjxHvTVz3yRgs5dNBwjm1IqLimNJ2v3d8VV4olwK7YQnRMXzL/a1UmPSZPHMMp+LVKmmBIWryJ8WECmPQqwcf8dl0tCD2MSYPvgg/psjFj0UlW+5SH97hM7yi+SCdC2abSmbuZJ8v5wiJYnYPd6s4vDRD2AN9VY+h+qW+G63YKXftGUeTgKMlDSwxHjkJ5FhTR8cg0fFwWnRKQSJJlYUVVUcHywsbYJHpcsKZ7koC5ZJYgmHs3aBGmSRPqAtiJgBzUyI+FGLty2+vJUOxijBB/w/jrPZ7X/zRozuDsyL7q6X1Pq3tPI6wtt54s47lnaGrlZ0z+a/jj7pzskU0v/Na7nf854lryPh8uiKnpYcp2hvSwD4NaW/m6BXEAjd7PstPHkvXo4o12WHPhMjMEUzSfkGBptRGWPJ01fRcLopFhJVWL0lG7hmpUtT3wVbfyWdBp2zmR1c4em933J4nTpjYRegMLp+rvjTvtAY6OvktvmMpjI8SfznFbuJyf2psi5gih6VSXjHZa65j68HY0gjnOiGs/F6zi2KfOX3Y38LPlPPHuwHc+r+bkaAb4teZ9aZA+7pOT6mtm3mshjaSwsvbaTNzzkz1sg8TwXWhglrHD9jk/w93i8bsi/WW5rgj9gE9EU3tDeCbuNQ3D2v2FGHcSTTa/pFj2gV6BpN/kMUZSgou48IXLrcVbJzAlRuujo0GzNBfG8hwOhBnLry9Z+ng7awwC6gI57B4pP/u5vwEgIA0LbQlvznPj7nghfVxWWriIVjzHqZOIu07xfFz17x6Akvw3Nn1z4TjFjVKic2Ul76f
 8cuauoRh
 B9jQyk7IQaqCF3YUQ5ZT4YCULy1Bn8AgOr789ddXT+BpXrDbIsj8yi+ksnljzSojWI2hvcsPFEppBMNGhf7ttJnBNJ2+sj7Pyq04RdPoptdPmks6/YEQGxFZF5puJIrlz2MYhLOEwflXWefNlGAbc9rEjyhC39Cbtsr3kL9Pl6yqvT0SFemjhBL8veoPDk36RWlNbg/FTmRbGajcIvmxsBwYfujIwU7ixjTGXsz9p4N2FoZ2M2V8u91pPGsnLWXdKUoi8cvL+REp8b50nA91bHjwf7B3Qo2oxg1Tp0Swp7Lhc8fLZI0J3JmNXRs5wUfrUxDLKM6i1NcOh87Rpr8cguwivJ3ErbRToq0DK6MfJdBVrqv3a82JUfmG6ASjHGbL7UmpX3xEjceKL92ZPSpb/0hJfnOGAhn9wOqn73oeDZeu7Q7iYsBuVqtoTGSZuqRFSzRr+kBXl3fRnfwfIe9kEGV2BSJXNchb/UngnfZOhmO63FMURZVXnTA/FIlWPhsywk1Z+2Iz3mbTM6JZHBUkk1M7EFXr1Ea4LD4sKgbaGuNUkBaHZfCoe1OnnWtFUbyttgTr7ld2gYH+kFb8JJVn4rttcNKNl3tYhB8UyHTAFfp87rpRa5LRYRn7EBxBtxeWWgF+CUoEZZ/+6yQTbfKgVad4hs4V02h0cGwNSsBr4JFt+9ZGh77bxXm4m2u6mNYfHMKCgkaovSPfNYfzHJIBEc87mjpvEFp68l5OBPZpI+eN1Hg+DBDO/9b7LieIZMlbdVxKXOYL7vWO0h8GbgPwdjmf+RgyIDGhgp/FsPrvbrgjeRba5Lc3MJqemrFT6UTOkrhoZnvpyNrE9D2UeIx5gJRSF/3j3JteMNDk52ZnbvPVItjg2fF+gmvdLGdq3kjzdy4IBrqXPiWqiOgwrkwofwK2BslQ40/hq4BZfUfPb1OFQztFuvwDddW3h7BWYhIy/jPJAocxmcjoAn0XSVHwdsW19SXNG
 IbjXsv6X
 UDNPBRlVSPGnlTgLBWheEhzzI3SAKPmWD26jGL8jiic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce Kunit tests for hierarchical per-cpu counters.

Keep track of two sets of hierarchical counters, each meant to have the
same precise sum at any time, but distributed differently across the
topology.

Keep track of an atomic counter along with each hierarchical counter, for
sum validation.

Those tests cover:

- Single-threaded (no concurrency) updates.
- Concurrent updates of counters from various CPUs.
- Contended carries: rounds of concurrent carries from many CPUs into
  the tree items they share.

The multi-threaded tests run their workers on at most 64 CPUs, spread
evenly across the online CPUs, so their run time does not grow with the
size of the machine.

The single-threaded and saturation tests run each update on its target
CPU with work_on_cpu(), and the multi-threaded tests queue their updates
on a CPU intensive workqueue, whose workers are reused across rounds
and can preempt each other on a CPU.  The single and multi-threaded
tests stop early after a time bound, so they complete on large virtual
machines where cross-CPU wakeups are slow.

Perform the following validations:

- Compare the precise sum of counters with the sum tracked by
  an atomic counter.
- Compare the precise sum of two sets of hierarchical counters.
- Approximated comparison of hierarchical counter with atomic counter.
- Approximated comparison of two sets of hierarchical counters.
- Validate the bounds of approximation ranges.
- Check the residuals of the tree items, and that no carry was lost or
  duplicated, whenever the counters are settled, including between the
  rounds of contended carries.
- Saturate a counter upward and downward to its worst-case approximation
  errors, check that it reaches the edges of its accuracy range exactly
  when all possible CPUs are online, and validate the comparisons at the
  edges of its precise range.

Run with the following .kunit/.kunitconfig:

CONFIG_KUNIT=y
CONFIG_SMP=y
CONFIG_PREEMPT=y
CONFIG_NR_CPUS=32
CONFIG_HOTPLUG_CPU=y
CONFIG_PERCPU_COUNTER_TREE_KUNIT_TEST=y

With the following execution (to use SMP):

./tools/testing/kunit/kunit.py run --arch=x86_64 --qemu_args="-smp 12"

Link: https://lkml.kernel.org/r/20260227153730.1556542-3-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
Changes since v23:
- Select the first online CPU of the single-threaded tests with the CPU
  hotplug lock held. (Reported by Sashiko.)
- Publish the start flag of the contended carries test with
  smp_store_release(), paired with smp_load_acquire() in the workers.
  (Reported by Sashiko.)
- Check whether every possible CPU is online with the CPU hotplug lock
  held in the saturated counter comparison test. (Reported by Sashiko.)
- Check that a zeroed counter reads as 0.

Changes since v22:
- Fix CPU hotplug locking, module unload, and error handling: ERR_PTR
  handling, a test data leak, allocation sizing, the cpu & ~1 skip, a
  lost worker when kthread_stop() runs before the thread function, and
  a task_struct reaping race. (Reported by Sashiko.)
- Merge the four multi-thread increment tests into one function taking
  a CPU selector.
- Add a saturated counter comparison test, upward and downward.
- Add a contended carries test.
- Bound the number of CPUs running workers in the multi-threaded tests.
- Check the residuals and carries of settled counters.
- Add a configuration table validation test.
- Run the updates with work_on_cpu() and a workqueue rather than
  creating a kthread for each update, and bound the run time of the
  single and multi-threaded tests, which timed out with 192 CPUs in a
  virtual machine.
- Fix checkpatch warnings.

Changes since v19:
- Rename config option to PERCPU_COUNTER_TREE_KUNIT_TEST.
---
 MAINTAINERS                           |   1 +
 lib/Kconfig                           |  12 +
 lib/tests/Makefile                    |   2 +
 lib/tests/percpu_counter_tree_kunit.c | 845 ++++++++++++++++++++++++++
 4 files changed, 860 insertions(+)
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 712af0536005..21348605d06e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11955,6 +11955,7 @@ S:	Supported
 F:	Documentation/core-api/percpu-counter-tree.rst
 F:	include/linux/percpu_counter_tree.h
 F:	lib/percpu_counter_tree.c
+F:	lib/tests/percpu_counter_tree_kunit.c
 
 HIGH-RESOLUTION TIMERS, TIMER WHEEL, CLOCKEVENTS
 M:	Anna-Maria Behnsen <anna-maria@linutronix.de>
diff --git a/lib/Kconfig b/lib/Kconfig
index 1e42f5167c68..3921177a0d24 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -41,6 +41,18 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config PERCPU_COUNTER_TREE_KUNIT_TEST
+	tristate "KUnit tests for hierarchical per-cpu counters" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds Kunit tests for the hierarchical per-cpu counters.
+
+	  For more information on KUnit and unit tests in general,
+	  please refer to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  When in doubt, say N.
+
 config BITREVERSE
 	tristate
 	select GENERIC_BITREVERSE if !HAVE_ARCH_BITREVERSE
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index df0537e1b91f..e98687da8706 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -59,4 +59,6 @@ obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
+obj-$(CONFIG_PERCPU_COUNTER_TREE_KUNIT_TEST) += percpu_counter_tree_kunit.o
+
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
new file mode 100644
index 000000000000..5774278ea140
--- /dev/null
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -0,0 +1,845 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+#include <kunit/test.h>
+#include <linux/percpu_counter_tree.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/random.h>
+#include <linux/cpuhplock.h>
+#include <linux/slab.h>
+#include <linux/sched/task.h>
+#include <linux/workqueue.h>
+
+struct multi_thread_test_data {
+	struct work_struct work;
+	long increment;
+	unsigned int nr_inc;
+	int counter_index;
+};
+
+#define NR_COUNTERS	2
+
+/* Hierarchical per-CPU counter instances. */
+static struct percpu_counter_tree counter[NR_COUNTERS];
+
+/* Global atomic counters for validation. */
+static atomic_long_t global_counter[NR_COUNTERS];
+
+static DECLARE_WAIT_QUEUE_HEAD(kernel_threads_wq);
+static atomic_t kernel_threads_to_run;
+
+static void complete_work(void)
+{
+	if (atomic_dec_and_test(&kernel_threads_to_run))
+		wake_up(&kernel_threads_wq);
+}
+
+/* Random tasks test. */
+#define NR_RAND_TASKS	1000
+
+static void hpcc_print_info(struct kunit *test)
+{
+	kunit_info(test, "Running test with %d CPUs\n", num_online_cpus());
+}
+
+static void add_to_counter(int counter_index, unsigned int nr_inc, long increment)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_inc; i++) {
+		percpu_counter_tree_add(&counter[counter_index], increment);
+		atomic_long_add(increment, &global_counter[counter_index]);
+	}
+}
+
+/* Check the residuals and the carries of a settled counter. */
+static void check_residuals(struct kunit *test, struct percpu_counter_tree *c)
+{
+#ifdef CONFIG_SMP
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_check_residuals(c));
+#endif
+}
+
+static void check_counters(struct kunit *test)
+{
+	int counter_index;
+
+	/* Compare each counter with its global counter. */
+	for (counter_index = 0; counter_index < NR_COUNTERS; counter_index++) {
+		struct percpu_counter_tree *c = &counter[counter_index];
+		long v = atomic_long_read(&global_counter[counter_index]);
+		long approx_sum = percpu_counter_tree_approximate_sum(c);
+		unsigned long accuracy;
+		long precise_min, precise_max;
+
+		/* Precise comparison. */
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(c), v);
+		check_residuals(test, c);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare_value(c, v));
+
+		/* Approximate comparison. */
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(c, v));
+
+		/* Accuracy limits checks. */
+		accuracy = percpu_counter_tree_approximate_accuracy(c);
+
+		/*
+		 * The accuracy is an unsigned long, so the inner expression
+		 * promotes to unsigned. Compute the difference in unsigned and
+		 * cast to signed for the comparison against 0.
+		 */
+		KUNIT_EXPECT_GE(test, (long)(approx_sum - (v - accuracy)), 0);
+		KUNIT_EXPECT_LE(test, (long)(approx_sum - (v + accuracy)), 0);
+
+		/* Precise min/max range check. */
+		percpu_counter_tree_approximate_min_max_range(approx_sum, accuracy,
+							      &precise_min, &precise_max);
+
+		KUNIT_EXPECT_GE(test, v - precise_min, 0);
+		KUNIT_EXPECT_LE(test, v - precise_max, 0);
+	}
+	/* Compare each counter with the second counter. */
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[0]),
+			percpu_counter_tree_precise_sum(&counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare(&counter[0], &counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(&counter[0], &counter[1]));
+}
+
+/*
+ * Workqueue running the updates of the multi-threaded tests. Its workers
+ * are reused across rounds, which keeps the tests fast on machines where
+ * creating threads on remote CPUs is slow. Work items are CPU intensive,
+ * so several of them queued on one CPU run concurrently in separate
+ * workers, and can preempt each other in the middle of an update.
+ */
+static struct workqueue_struct *hpcc_test_wq;
+
+static void multi_thread_work_fn(struct work_struct *work)
+{
+	struct multi_thread_test_data *td =
+		container_of(work, struct multi_thread_test_data, work);
+
+	add_to_counter(td->counter_index, td->nr_inc, td->increment);
+	kfree(td);
+	complete_work();
+}
+
+/* Queue an update of a counter on @target_cpu. Call with the CPU hotplug lock held. */
+static int test_queue_on_cpu(int target_cpu, int counter_index, unsigned int nr_inc,
+			     long increment)
+{
+	struct multi_thread_test_data *td = kzalloc(sizeof(*td), GFP_KERNEL);
+
+	if (!td)
+		return -ENOMEM;
+	INIT_WORK(&td->work, multi_thread_work_fn);
+	td->increment = increment;
+	td->nr_inc = nr_inc;
+	td->counter_index = counter_index;
+	atomic_inc(&kernel_threads_to_run);
+	queue_work_on(target_cpu, hpcc_test_wq, &td->work);
+	return 0;
+}
+
+static void init_kthreads(void)
+{
+	atomic_set(&kernel_threads_to_run, 1);
+}
+
+/*
+ * The caller needs to wait for work completion _before_ stopping kthreads.
+ */
+static void fini_kthreads(void)
+{
+	/* Release our own reference. */
+	complete_work();
+	/* Wait for all others threads to run. */
+	wait_event(kernel_threads_wq, (atomic_read(&kernel_threads_to_run) == 0));
+}
+
+static int init_counters(unsigned long batch_size)
+{
+	int i, ret;
+
+	ret = percpu_counter_tree_init_many(counter, NR_COUNTERS, batch_size, GFP_KERNEL);
+	if (ret)
+		return ret;
+	for (i = 0; i < NR_COUNTERS; i++)
+		atomic_long_set(&global_counter[i], 0);
+	return 0;
+}
+
+static void fini_counters(void)
+{
+	percpu_counter_tree_destroy_many(counter, NR_COUNTERS);
+}
+
+enum up_test_inc_type {
+	INC_ONE,
+	INC_MINUS_ONE,
+	INC_RANDOM,
+};
+
+/*
+ * Single-threaded tests. Those run the updates on various CPUs, one at a
+ * time: work_on_cpu() waits for each update to complete before the next,
+ * effectively making sure there are no concurrent updates. Each test
+ * stops early after SINGLE_THREAD_MAX_SECONDS, because cross-CPU wakeups
+ * can be slow on large virtual machines.
+ */
+#define SINGLE_THREAD_MAX_SECONDS	10
+
+struct single_thread_update {
+	long increment;
+	int counter_index;
+};
+
+static long single_thread_update_fn(void *arg)
+{
+	struct single_thread_update *u = arg;
+
+	add_to_counter(u->counter_index, 1, u->increment);
+	return 0;
+}
+
+/* CPU selection for the updates of each counter. */
+enum st_cpu_select {
+	ST_FIRST_CPU,		/* First online CPU. */
+	ST_RANDOM_CPU,		/* Any online CPU, for each update. */
+};
+
+/* Call with the CPU hotplug lock held. */
+static int st_select_cpu(enum st_cpu_select select)
+{
+	if (select == ST_FIRST_CPU)
+		return cpumask_first(cpu_online_mask);
+	return cpumask_any_distribute(cpu_online_mask);
+}
+
+static void do_hpcc_test_single_thread(struct kunit *test, enum st_cpu_select select0,
+				       enum st_cpu_select select1, enum up_test_inc_type type)
+{
+	unsigned long batch_size_order = 5;
+	unsigned long deadline = jiffies + SINGLE_THREAD_MAX_SECONDS * HZ;
+	int ret, i;
+
+	ret = init_counters(1UL << batch_size_order);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
+	cpus_read_lock();
+	for (i = 0; i < 10000 && time_before(jiffies, deadline); i++) {
+		struct single_thread_update u0 = { .counter_index = 0 };
+		struct single_thread_update u1 = { .counter_index = 1 };
+		long increment;
+
+		switch (type) {
+		case INC_ONE:
+			increment = 1;
+			break;
+		case INC_MINUS_ONE:
+			increment = -1;
+			break;
+		case INC_RANDOM:
+			increment = (long)get_random_long() % 50000;
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			increment = 0;
+		}
+		u0.increment = increment;
+		u1.increment = increment;
+		work_on_cpu(st_select_cpu(select0), single_thread_update_fn, &u0);
+		work_on_cpu(st_select_cpu(select1), single_thread_update_fn, &u1);
+		check_counters(test);
+	}
+	cpus_read_unlock();
+	fini_counters();
+}
+
+static void hpcc_test_single_thread_first(struct kunit *test)
+{
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_FIRST_CPU, INC_ONE);
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_FIRST_CPU, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_FIRST_CPU, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_first_random(struct kunit *test)
+{
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_RANDOM_CPU, INC_ONE);
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_RANDOM_CPU, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, ST_FIRST_CPU, ST_RANDOM_CPU, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_random(struct kunit *test)
+{
+	do_hpcc_test_single_thread(test, ST_RANDOM_CPU, ST_RANDOM_CPU, INC_ONE);
+	do_hpcc_test_single_thread(test, ST_RANDOM_CPU, ST_RANDOM_CPU, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, ST_RANDOM_CPU, ST_RANDOM_CPU, INC_RANDOM);
+}
+
+/* Multi-threaded SMP tests. */
+
+/*
+ * Bound the number of CPUs running workers in the multi-threaded tests,
+ * so their run time does not grow with the size of the machine. Beyond
+ * this bound, the workers run on a subset spread evenly across the
+ * online CPUs, so they still reach every branch of the tree.
+ */
+#define MAX_WORKER_CPUS	64
+
+/*
+ * Each multi-threaded test stops early after MULTI_THREAD_MAX_SECONDS,
+ * because cross-CPU wakeups can be slow on large virtual machines.
+ */
+#define MULTI_THREAD_MAX_SECONDS	60
+
+static struct cpumask worker_cpus;
+
+/* Select the CPUs running workers. Call with the CPU hotplug lock held. */
+static const struct cpumask *select_worker_cpus(void)
+{
+	unsigned int nr_online = num_online_cpus(), i = 0;
+	int cpu;
+
+	cpumask_clear(&worker_cpus);
+	for_each_online_cpu(cpu) {
+		/* Pick MAX_WORKER_CPUS of the nr_online CPUs, evenly spaced. */
+		if ((i + 1) * MAX_WORKER_CPUS / nr_online !=
+		    i * MAX_WORKER_CPUS / nr_online)
+			cpumask_set_cpu(cpu, &worker_cpus);
+		i++;
+	}
+	return &worker_cpus;
+}
+
+/*
+ * CPU selection for the second counter's thread, relative to the CPU
+ * running the first counter's thread.
+ */
+enum mt_cpu_select {
+	MT_SAME_CPU,		/* Same CPU as the first counter. */
+	MT_EVEN_CPU,		/* Funnel CPU pairs (0, 1), (2, 3), ... to 0, 2, ... */
+	MT_FIRST_CPU,		/* First online CPU. */
+	MT_RANDOM_CPU,		/* Any online CPU. */
+};
+
+/* Return the CPU for the second counter's thread, or -1 to skip @cpu. */
+static int mt_select_cpu(enum mt_cpu_select select, int cpu)
+{
+	int even_cpu;
+
+	switch (select) {
+	case MT_SAME_CPU:
+		return cpu;
+	case MT_EVEN_CPU:
+		even_cpu = cpu & ~1;
+		return cpumask_test_cpu(even_cpu, cpu_online_mask) ? even_cpu : -1;
+	case MT_FIRST_CPU:
+		return cpumask_first(cpu_online_mask);
+	case MT_RANDOM_CPU:
+		return cpumask_any_distribute(cpu_online_mask);
+	}
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+static void do_hpcc_multi_thread_increment(struct kunit *test, enum mt_cpu_select select,
+					   unsigned long batch_size, unsigned int nr_inc,
+					   long increment)
+{
+	const struct cpumask *cpus;
+	int ret, cpu;
+
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
+	init_kthreads();
+	cpus_read_lock();
+	cpus = select_worker_cpus();
+	for_each_cpu(cpu, cpus) {
+		int cpu1 = mt_select_cpu(select, cpu);
+
+		if (cpu1 < 0)
+			continue;
+		ret = test_queue_on_cpu(cpu, 0, nr_inc, increment);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		if (ret)
+			break;
+		ret = test_queue_on_cpu(cpu1, 1, nr_inc, increment);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		if (ret)
+			break;
+	}
+	fini_kthreads();
+	cpus_read_unlock();
+	check_counters(test);
+	fini_counters();
+}
+
+static void hpcc_test_multi_thread_batch_increment(struct kunit *test)
+{
+	unsigned long deadline = jiffies + MULTI_THREAD_MAX_SECONDS * HZ;
+	unsigned long batch_size_order;
+
+	for (batch_size_order = 2; batch_size_order <= 7; batch_size_order++) {
+		unsigned long batch_size = 1UL << batch_size_order;
+		unsigned int nr_inc;
+
+		for (nr_inc = 1; nr_inc < 1024; nr_inc *= 2) {
+			long increment;
+
+			for (increment = 1; increment < 100000; increment *= 10) {
+				enum mt_cpu_select select;
+
+				if (time_after(jiffies, deadline))
+					return;
+				for (select = MT_SAME_CPU; select <= MT_RANDOM_CPU; select++)
+					do_hpcc_multi_thread_increment(test, select, batch_size,
+								       nr_inc, increment);
+			}
+		}
+	}
+}
+
+static void hpcc_test_multi_thread_random_walk(struct kunit *test)
+{
+	unsigned long deadline = jiffies + MULTI_THREAD_MAX_SECONDS * HZ;
+	unsigned long batch_size_order = 5;
+	int loop;
+
+	for (loop = 0; loop < 100 && time_before(jiffies, deadline); loop++) {
+		int ret, i;
+
+		ret = init_counters(1UL << batch_size_order);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		if (ret)
+			return;
+		init_kthreads();
+		cpus_read_lock();
+		for (i = 0; i < NR_RAND_TASKS; i++) {
+			long increment = (long)get_random_long() % 512;
+			unsigned int nr_inc = ((unsigned long)get_random_long()) % 1024;
+
+			ret = test_queue_on_cpu(cpumask_any_distribute(cpu_online_mask),
+						0, nr_inc, increment);
+			KUNIT_EXPECT_EQ(test, ret, 0);
+			if (ret)
+				break;
+			ret = test_queue_on_cpu(cpumask_any_distribute(cpu_online_mask),
+						1, nr_inc, increment);
+			KUNIT_EXPECT_EQ(test, ret, 0);
+			if (ret)
+				break;
+		}
+		fini_kthreads();
+		cpus_read_unlock();
+		check_counters(test);
+		fini_counters();
+	}
+}
+
+#define CONTENTION_NR_ROUNDS	20000
+#define CONTENTION_NR_INC	8
+
+struct contention_shared {
+	unsigned long batch_size;
+	atomic_t round;			/* Round started by the coordinator. */
+	atomic_t nr_done;		/* Rounds completed by the other workers. */
+	unsigned int nr_workers;
+	unsigned int nr_errors;		/* Rounds ending with invalid residuals. */
+	bool started;
+};
+
+struct contention_data {
+	struct contention_shared *sh;
+	long sum;
+	u32 seed;
+	bool coordinator;
+} ____cacheline_aligned_in_smp;
+
+static DECLARE_WAIT_QUEUE_HEAD(contention_wq);
+
+/*
+ * Add random multiples of the batch size, of either sign, so each
+ * addition carries into the counters above level 0. Increments of
+ * opposite signs and of more than one batch size exercise concurrent
+ * carry extractions retrying after a concurrent update of the residual.
+ */
+static void contention_add(struct contention_data *cd)
+{
+	unsigned int i;
+
+	for (i = 0; i < CONTENTION_NR_INC; i++) {
+		u32 x = cd->seed;
+		long inc;
+
+		/* xorshift32: get_random_u32() would dominate the loop. */
+		x ^= x << 13;
+		x ^= x >> 17;
+		x ^= x << 5;
+		cd->seed = x;
+		inc = (long)((x & 15) + 1) * cd->sh->batch_size;
+		if (x & 16)
+			inc = -inc;
+		percpu_counter_tree_add(&counter[0], inc);
+		cd->sum += inc;
+	}
+}
+
+/*
+ * The workers run rounds of a few additions each, all starting together.
+ * Between rounds, the coordinator checks the residuals of the settled
+ * counter: an invalid residual left by the last updaters of a round would
+ * otherwise be repaired by the next additions.
+ */
+static int contention_worker_fn(void *data)
+{
+	struct contention_data *cd = data;
+	struct contention_shared *sh = cd->sh;
+	int round;
+
+	/* Pairs with the release of started: nr_workers is final. */
+	wait_event(contention_wq, smp_load_acquire(&sh->started));
+	for (round = 1; round <= CONTENTION_NR_ROUNDS; round++) {
+		if (cd->coordinator) {
+			atomic_set_release(&sh->round, round);
+			contention_add(cd);
+			while (atomic_read_acquire(&sh->nr_done) < round * (sh->nr_workers - 1))
+				cond_resched();
+#ifdef CONFIG_SMP
+			if (percpu_counter_tree_check_residuals(&counter[0]))
+				sh->nr_errors++;
+#endif
+		} else {
+			while (atomic_read_acquire(&sh->round) < round)
+				cond_resched();
+			contention_add(cd);
+			/* Order the additions before the coordinator check. */
+			atomic_inc_return_release(&sh->nr_done);
+		}
+	}
+	complete_work();
+	return 0;
+}
+
+static void do_hpcc_test_contended_carries(struct kunit *test, unsigned long batch_size)
+{
+	struct percpu_counter_tree *c = &counter[0];
+	struct contention_shared sh = { .batch_size = batch_size };
+	struct contention_data *cd;
+	struct task_struct **task;
+	const struct cpumask *cpus;
+	unsigned long accuracy;
+	long expected = 0, approx;
+	bool first = true;
+	int ret, cpu;
+
+	cd = kvcalloc(nr_cpu_ids, sizeof(*cd), GFP_KERNEL);
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, cd);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!cd || !task)
+		goto free;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto free;
+	init_kthreads();
+	cpus_read_lock();
+	cpus = select_worker_cpus();
+	for_each_cpu(cpu, cpus) {
+		cd[cpu].sh = &sh;
+		cd[cpu].coordinator = first;
+		cd[cpu].seed = get_random_u32() | 1;
+		task[cpu] = kthread_create_on_cpu(contention_worker_fn, &cd[cpu], cpu,
+						  "kunit_hpcc_contention/%u");
+		KUNIT_EXPECT_FALSE(test, IS_ERR(task[cpu]));
+		if (IS_ERR(task[cpu]))
+			break;
+		atomic_inc(&kernel_threads_to_run);
+		get_task_struct(task[cpu]);
+		wake_up_process(task[cpu]);
+		sh.nr_workers++;
+		first = false;
+	}
+	/*
+	 * Start the workers once their number is known. The coordinator may
+	 * already be running and see started without the wait queue lock.
+	 */
+	smp_store_release(&sh.started, true);
+	wake_up_all(&contention_wq);
+	fini_kthreads();
+	for_each_cpu(cpu, cpus) {
+		if (IS_ERR_OR_NULL(task[cpu]))
+			continue;
+		kthread_stop_put(task[cpu]);
+		expected += cd[cpu].sum;
+	}
+	cpus_read_unlock();
+
+	kunit_info(test, "batch_size=%lu workers=%u rounds with invalid residuals=%u\n",
+		   batch_size, sh.nr_workers, sh.nr_errors);
+	KUNIT_EXPECT_EQ(test, sh.nr_errors, 0);
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(c), expected);
+	check_residuals(test, c);
+	approx = percpu_counter_tree_approximate_sum(c);
+	accuracy = percpu_counter_tree_approximate_accuracy(c);
+	KUNIT_EXPECT_GE(test, approx, expected - (long)accuracy);
+	KUNIT_EXPECT_LE(test, approx, expected + (long)accuracy);
+	fini_counters();
+free:
+	kvfree(task);
+	kvfree(cd);
+}
+
+/*
+ * Concurrent carries from the worker CPUs into the counters above level 0
+ * which they share, with a check that the residuals are back within range
+ * and that no carry was lost or duplicated after each round.
+ */
+static void hpcc_test_contended_carries(struct kunit *test)
+{
+	unsigned long batch_size_order;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "needs at least 2 online CPUs");
+	for (batch_size_order = 1; batch_size_order <= 5; batch_size_order += 2)
+		do_hpcc_test_contended_carries(test, 1UL << batch_size_order);
+}
+
+static void hpcc_test_init_one(struct kunit *test)
+{
+	struct percpu_counter_tree pct, zeroed = {};
+	int ret;
+
+	/* A zeroed counter reads as 0 before its initialization. */
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_approximate_sum(&zeroed), 0);
+	ret = percpu_counter_tree_init(&pct, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
+
+	percpu_counter_tree_destroy(&pct);
+}
+
+static void hpcc_test_set(struct kunit *test)
+{
+	static long values[] = {
+		5, 100, 127, 128, 255, 256, 4095, 4096, 500000, 0,
+		-5, -100, -127, -128, -255, -256, -4095, -4096, -500000,
+	};
+	struct percpu_counter_tree pct;
+	int i, ret;
+
+	ret = percpu_counter_tree_init(&pct, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(values); i++) {
+		long v = values[i];
+
+		percpu_counter_tree_set(&pct, v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), v);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, v));
+
+		percpu_counter_tree_add(&pct, v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), 2 * v);
+		KUNIT_EXPECT_EQ(test, 0,
+				percpu_counter_tree_approximate_compare_value(&pct, 2 * v));
+
+		percpu_counter_tree_add(&pct, -2 * v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), 0);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, 0));
+	}
+
+	percpu_counter_tree_destroy(&pct);
+}
+
+struct saturate_data {
+	struct percpu_counter_tree *c, *probe;
+	long inc;
+	unsigned long max_steps;
+	bool overrun;
+};
+
+/* Copy the state of counter @src into counter @dst, of the same topology. */
+static void copy_counter_state(struct percpu_counter_tree *dst,
+			       struct percpu_counter_tree *src)
+{
+#ifdef CONFIG_SMP
+	percpu_counter_tree_copy_state(dst, src);
+#else
+	atomic_long_set(&dst->count, atomic_long_read(&src->count));
+#endif
+}
+
+/*
+ * Add inc (1 or -1) until the next addition would propagate a carry to the
+ * approximate sum. This leaves every tree item on the path from this CPU to
+ * the root holding its largest residual in the direction of inc which has
+ * not been propagated yet, without knowledge of the tree topology. Each
+ * addition is first tried on the probe counter, which holds the same state:
+ * reverting an addition which reached the approximate sum would not restore
+ * the residuals subtracted on the way. The path from a CPU to the root
+ * holds less than the accuracy bound: more additions mean that a carry was
+ * lost.
+ */
+static long saturate_worker_fn(void *data)
+{
+	struct saturate_data *sd = data;
+	unsigned long steps;
+
+	for (steps = 0; steps < sd->max_steps; steps++) {
+		long approx = percpu_counter_tree_approximate_sum(sd->probe);
+
+		percpu_counter_tree_add(sd->probe, sd->inc);
+		if (percpu_counter_tree_approximate_sum(sd->probe) != approx) {
+			copy_counter_state(sd->probe, sd->c);
+			break;
+		}
+		percpu_counter_tree_add(sd->c, sd->inc);
+	}
+	if (steps == sd->max_steps)
+		sd->overrun = true;
+	return 0;
+}
+
+static void do_hpcc_test_saturated_compare(struct kunit *test, unsigned long batch_size,
+					   long inc)
+{
+	struct percpu_counter_tree *c = &counter[0], *exact = &counter[1], probe;
+	struct saturate_data sd = { .c = c, .probe = &probe, .inc = inc };
+	unsigned long accuracy;
+	long approx, precise, precise_min, precise_max;
+	bool all_saturated;
+	int ret, cpu;
+
+	ret = percpu_counter_tree_init(&probe, batch_size, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto destroy_probe;
+	accuracy = percpu_counter_tree_approximate_accuracy(c);
+	sd.max_steps = batch_size + accuracy;
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		work_on_cpu(cpu, saturate_worker_fn, &sd);
+		KUNIT_EXPECT_FALSE(test, sd.overrun);
+		if (sd.overrun)
+			break;
+	}
+	/* Whether every possible CPU was online, thus saturated. */
+	all_saturated = num_online_cpus() == nr_cpu_ids;
+	cpus_read_unlock();
+
+	precise = percpu_counter_tree_precise_sum(c);
+	approx = percpu_counter_tree_approximate_sum(c);
+	kunit_info(test, "batch_size=%lu inc=%ld precise=%ld approx=%ld accuracy=%lu\n",
+		   batch_size, inc, precise, approx, accuracy);
+
+	check_residuals(test, c);
+	check_residuals(test, &probe);
+
+	/* Accuracy contract. */
+	KUNIT_EXPECT_GE(test, approx, precise - (long)accuracy);
+	KUNIT_EXPECT_LE(test, approx, precise + (long)accuracy);
+	/* Saturating every possible CPU reaches the accuracy exactly. */
+	if (all_saturated)
+		KUNIT_EXPECT_EQ(test, (precise - approx) * inc, (long)accuracy);
+	percpu_counter_tree_approximate_min_max_range(approx, accuracy,
+						      &precise_min, &precise_max);
+	KUNIT_EXPECT_GE(test, precise, precise_min);
+	KUNIT_EXPECT_LE(test, precise, precise_max);
+
+	/* Comparisons against a value. */
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(c, precise));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare_value(c, precise));
+	KUNIT_EXPECT_EQ(test, -1, percpu_counter_tree_precise_compare_value(c, precise - 1));
+	KUNIT_EXPECT_EQ(test, 1, percpu_counter_tree_precise_compare_value(c, precise + 1));
+
+	/* Comparisons against a counter with the same precise sum, exactly approximated. */
+	percpu_counter_tree_set(exact, precise);
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_approximate_sum(exact), precise);
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(c, exact));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(exact, c));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare(c, exact));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare(exact, c));
+
+	fini_counters();
+destroy_probe:
+	percpu_counter_tree_destroy(&probe);
+}
+
+/*
+ * Saturate the unpropagated residuals of every tree item reachable from
+ * online CPUs, upward and downward, which yields the largest distance
+ * between the precise and approximate sums of a settled counter in each
+ * direction, and check that the comparison
+ * functions do not return a wrong definitive answer. Small batch sizes
+ * are the most likely to expose margin errors, because the fan-out of
+ * the tree levels can be larger than the batch size.
+ */
+static void hpcc_test_saturated_compare(struct kunit *test)
+{
+	unsigned long batch_size_order;
+
+	for (batch_size_order = 1; batch_size_order <= 5; batch_size_order++) {
+		do_hpcc_test_saturated_compare(test, 1UL << batch_size_order, 1);
+		do_hpcc_test_saturated_compare(test, 1UL << batch_size_order, -1);
+	}
+}
+
+static void hpcc_test_check_config(struct kunit *test)
+{
+#ifdef CONFIG_SMP
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_check_config());
+#else
+	kunit_skip(test, "The configuration table requires CONFIG_SMP");
+#endif
+}
+
+static struct kunit_case hpcc_test_cases[] = {
+	KUNIT_CASE(hpcc_test_check_config),
+	KUNIT_CASE(hpcc_print_info),
+	KUNIT_CASE(hpcc_test_single_thread_first),
+	KUNIT_CASE(hpcc_test_single_thread_first_random),
+	KUNIT_CASE_SLOW(hpcc_test_single_thread_random),
+	KUNIT_CASE(hpcc_test_multi_thread_batch_increment),
+	KUNIT_CASE_SLOW(hpcc_test_multi_thread_random_walk),
+	KUNIT_CASE(hpcc_test_init_one),
+	KUNIT_CASE(hpcc_test_set),
+	KUNIT_CASE(hpcc_test_saturated_compare),
+	KUNIT_CASE(hpcc_test_contended_carries),
+	{}
+};
+
+static int hpcc_test_suite_init(struct kunit_suite *suite)
+{
+	hpcc_test_wq = alloc_workqueue("hpcc_test", WQ_PERCPU | WQ_CPU_INTENSIVE, 0);
+	return hpcc_test_wq ? 0 : -ENOMEM;
+}
+
+static void hpcc_test_suite_exit(struct kunit_suite *suite)
+{
+	destroy_workqueue(hpcc_test_wq);
+}
+
+static struct kunit_suite hpcc_test_suite = {
+	.name = "percpu_counter_tree",
+	.suite_init = hpcc_test_suite_init,
+	.suite_exit = hpcc_test_suite_exit,
+	.test_cases = hpcc_test_cases,
+};
+
+kunit_test_suite(hpcc_test_suite);
+
+MODULE_DESCRIPTION("Test cases for hierarchical per-CPU counters");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.47.3


