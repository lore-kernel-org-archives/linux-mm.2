Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C826C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEDE6B0098; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778C66B0088; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641AC6B009D; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 384A76B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA4BB1C2178
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
X-FDA: 85166030544.29.675F5DD
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B850C000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="EF/1MVtg";
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287351;
	b=0EPy3Kx10EOK66P3tKLuGgGKnSB49f4wnUvP3AjBc/RxusCamdVDkkXfoN8e1Ii2yM5jIZ
	nsbh11LNzqup9SKtKnR+dh/87kFyEuzYThRj/vt4rrYuy1z6Svfy0r3A1vO4gngbURcvpV
	ktdG4Eh2sjGtyQg+yuriF9bfpHENzRQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tL1cmKSs0ZNOuF7NNYcj/4wBqlHVdgHSzS/qIxPqsfg=;
	b=vaQB2flcHroYqnSSk+nLjXzjImp67UVUQBNl2xBNbNYL8kpAoT84oH7aAo5UtU6RGPkf0I
	h9dyDppBFo3ULzHDQ4wBTDj9xokIPnXJFxE7gGR9P4I14tizW5JiPBlZGDw+Rj+XKrsh2a
	46Sgj2Nuf6UudQYO9Qnv2JDKmAYBRsY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="EF/1MVtg";
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287350;
	bh=tL1cmKSs0ZNOuF7NNYcj/4wBqlHVdgHSzS/qIxPqsfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EF/1MVtgNb45SIdMte/QMHqupfoCcqLF7n06F2d20MphR4BEWK3YdEglUED64xjo8
	 7wUlfAuuUiqxbLxxqCUdrgHQPCJkV9VGDsp3eabRZZqLY2To/6xb2yLsxxqKsrlQ+H
	 BNByTDfDX0RYSkdVGTx3k1bA3lWlAcyg00usN3iBuOFk/Mz8OLrArUTil0WT5j9tfW
	 ZSIGebSclzrVF2RNTK2X8k4BZb5ZjEY2J4VglWW+XI4ktPbdXNEinhMe8EiEGUcpJe
	 Q1vbXzA2x31MhPnW1WIy5+K3qahZsfl2ldAud4cAiPc73zWk4AHSG4zVgB1xO8g1c+
	 WcXgTGPAPohgw==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsL2f5LzVRK;
	Tue, 01 Sep 2026 14:29:10 -0400 (EDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v21 2/6] lib: test hierarchical per-cpu counters
Date: Tue,  1 Sep 2026 14:28:47 -0400
Message-ID: <20260901182857.26690-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B850C000F
X-Stat-Signature: hczic5qtuhmnu96on67s3jztrc649p8q
X-HE-Tag: 1788287350-256285
X-HE-Meta: U2FsdGVkX1/Dn1Q8FtSh8vqW0zrB2xOotM8ZN9f6nUCAzsq4XIIviBabvRYeCXnUnc19N+pGMmaTBNgA4kAg6CzYAAMSUQKz6YbbMeuFwvLWxfHh5AGexHkefQjRPKmPMaFcIYiyy+LSeMbdF0gH0s3Ul/AUFaKxYGv+bddsJyUwYMNUn5x9jmsuYcY1caJl0yrA53qhBndNWZkx0MelS3fiV7AU+Oz1oOocOapBfVzlq/2PaRDFO1htNs0vovWawUDc648wPxLZG+pQIpWfQyvUWFoGSz6OKvzLRNhsvS3c8HFdVzo7wyn7VBZWWAHfW+zUlRBacDioarJww0sKZ9zbSpAi+V8wRl+YURfHNv1K9ttSMDxFKnrH1NKRPcnfAjmVw89WNiwNSTm20SEOAoEvfKFDvTzdDAoQzMOy6HPbM3GytkynDqOXrfQk2v4Mr63J9wm3iIKjvS/D93RLKEYHhZJwn28MYslQ6WmPCkXdhSAbY5JlpZUdMfbqFcZbDkL10i7fPI8/+2vhwGerZxMHDroby9zbqQy24PhjbHxNttLTy6Ih+2DY9pjTxGQZy3Dk8vHDS0ufDCNg0T6cCmZ04fy5FXl00etwZXx3bfEDx1FHpnVKutlF4f2CoAEsdAPSDDvpo13tA11dmYJG3jqeamtnDdmzq2S3EWhgk0lgBvdzzEiNBk/rU09kbuWky1njlsX9Ivrjes4Ge5S5jWGCQBGUAiWjPpcBpVBx9Lp8AiIRqbCC/SgahzD2iebqFvK2AfHMR+koPWtner948IO+bde9T21ZMbK1LQHq34FPA470IlhEaT1DHRizJptkL64n5dsUjoYqYhrbWdq0VbnhwttxTOSqpU8mOOkLJmJazY3IUgg050g0DF9UF9YaRyZfQ05ORBo8VcM4WjHRqX9d4gyL+kHHlBOhSZvb3KGmd6gUafOYRRtnE5aL4dTsJxEFlph4rZLDkYp1Q4l
 /vsVzp8z
 Sl0UJYdIK1ZeBTU+/EY1EyaJkG5s6y1hwkyQhaqvBYFzxBKos3GqPTq8gIjCH1q13Lw0x3BmRfyU3ZxxXh9QAnq49rPVYSy+MfWa2Jhd2ZPgiwojRFbizStLPvVTnYkDpg93p4LI5fcofYr5uMVSZnK5BC8d0ZtZF7JeGq0uwhT56J8PVyizCGDK7Llt8qllrU0sHQqTw54mNfsnIl8qw5AeLZTKTVplCr71e+ZlVvT7/csz3N+opBhvlJVdslhRNiWx9gS56DogCrM28NhzY5WVYqoM/AfrprjtjNYdtAvRepawi9gB0xpUKGpYmZ5Bh8SmLjWhRqdc9Le6BTYrxREmTTxsAekj5LslvafACIDzpJYKrjyJpz8kSVgc8TTuz3XYB/kr8ULsKkK55Sr3RmS8xDXZIveuaXty5nz1TiSKp1lzS1VLQb0FfVa7BEbHFI+3oyGDkYk8SdsRZcva+OymxM/DN4tgYG4pEqe9BeVQp/VfGKSxGcus21A2besZl1G+Juc4c9deihdwNDVTnhhRTHYX1ZjJDX1XmdF8hEUjVhqdCyq7RUBJSYuXeaEtRdpLV648I//JNtZF4U/RMkw3hiKCD8FvvSuApz/C58v3UzbEsH/OPCExRhPKol9hkGgTrdPLReOa5b7WhcjMhyu376Y+F0iIJa2iLG/fhUPaCfI+qfxt/ejdcsrHUcKQlncSn5+iqBGHw7BiSPqlkQerEMMRpWYIjaoDbo6XHZiJa6uPVWBa6KXX4AzgVUU0nG19eCkeFJpaLpS3r9fa/EQCe97GKPgE19NW/sZ8ZLrOSoavqMCrNohkX5HzA59YE+TwYAuZVTzyZuDnmtBCOJRQp0rMsHfPEQANXBPrx5/1iOJslccG6Zbpx4E0MZaqGr04ybyWp3fj4rg6GTOpvZWSYSkUYX3NZPI+61B1oyN7tBcqfCMlSrdG0XPoRL+qiB8+6Lf62L2Gn/tSyHRoy5M0tsGs0
 msfeS9WN
 FzwStA3+iUiZGd/MxoAeWC1cddX+n7NB3ZktgsKFvp+d8GUOQDN+jONaA/EGfjToOWjffd4z+rIlBaWXu8D7uqJGDxNOy3WN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce Kunit tests for hierarchical per-cpu counters.

Keep track of two sets of hierarchical counters, each meant to have the
same precise sum at any time, but distributed differently across the
topology.

Keep track of an atomic counter along with each hierarchical counter, for
sum validation.

Those tests cover:

- Single-threaded (no concurrency) updates.
- Concurrent updates of counters from various CPUs.

Perform the following validations:

- Compare the precise sum of counters with the sum tracked by
  an atomic counter.
- Compare the precise sum of two sets of hierarchical counters.
- Approximated comparison of hierarchical counter with atomic counter.
- Approximated comparison of two sets of hierarchical counters.
- Validate the bounds of approximation ranges.

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
Cc: Christoph Lameter <cl@linux.com>
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
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
Changes since v19:
- Rename config option to PERCPU_COUNTER_TREE_KUNIT_TEST.
---
 lib/Kconfig                           |  12 +
 lib/tests/Makefile                    |   2 +
 lib/tests/percpu_counter_tree_kunit.c | 399 ++++++++++++++++++++++++++
 3 files changed, 413 insertions(+)
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

diff --git a/lib/Kconfig b/lib/Kconfig
index 4e6b34c3346d..c0524258b205 100644
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
index 3cac3b63a752..051e73705977 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -58,4 +58,6 @@ obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
+obj-$(CONFIG_PERCPU_COUNTER_TREE_KUNIT_TEST) += percpu_counter_tree_kunit.o
+
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
new file mode 100644
index 000000000000..a79176655c4b
--- /dev/null
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+#include <kunit/test.h>
+#include <linux/percpu_counter_tree.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/random.h>
+
+struct multi_thread_test_data {
+	long increment;
+	int nr_inc;
+	int counter_index;
+};
+
+#define NR_COUNTERS	2
+
+/* Hierarchical per-CPU counter instances. */
+static struct percpu_counter_tree counter[NR_COUNTERS];
+static struct percpu_counter_tree_level_item *items;
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
+static void check_counters(struct kunit *test)
+{
+	int counter_index;
+
+	/* Compare each counter with its global counter. */
+	for (counter_index = 0; counter_index < NR_COUNTERS; counter_index++) {
+		long v = atomic_long_read(&global_counter[counter_index]);
+		long approx_sum = percpu_counter_tree_approximate_sum(&counter[counter_index]);
+		unsigned long under_accuracy = 0, over_accuracy = 0;
+		long precise_min, precise_max;
+
+		/* Precise comparison. */
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[counter_index]), v);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare_value(&counter[counter_index], v));
+
+		/* Approximate comparison. */
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&counter[counter_index], v));
+
+		/* Accuracy limits checks. */
+		percpu_counter_tree_approximate_accuracy_range(&counter[counter_index], &under_accuracy, &over_accuracy);
+
+		KUNIT_EXPECT_GE(test, (long)(approx_sum - (v - under_accuracy)), 0);
+		KUNIT_EXPECT_LE(test, (long)(approx_sum - (v + over_accuracy)), 0);
+		KUNIT_EXPECT_GT(test, (long)(approx_sum - (v - under_accuracy - 1)), 0);
+		KUNIT_EXPECT_LT(test, (long)(approx_sum - (v + over_accuracy + 1)), 0);
+
+		/* Precise min/max range check. */
+		percpu_counter_tree_approximate_min_max_range(approx_sum, under_accuracy, over_accuracy, &precise_min, &precise_max);
+
+		KUNIT_EXPECT_GE(test, v - precise_min, 0);
+		KUNIT_EXPECT_LE(test, v - precise_max, 0);
+		KUNIT_EXPECT_GT(test, v - (precise_min - 1), 0);
+		KUNIT_EXPECT_LT(test, v - (precise_max + 1), 0);
+	}
+	/* Compare each counter with the second counter. */
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[0]), percpu_counter_tree_precise_sum(&counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare(&counter[0], &counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(&counter[0], &counter[1]));
+}
+
+static int multi_thread_worker_fn(void *data)
+{
+	struct multi_thread_test_data *td = data;
+
+	add_to_counter(td->counter_index, td->nr_inc, td->increment);
+	complete_work();
+	kfree(td);
+	return 0;
+}
+
+static void test_run_on_specific_cpu(struct kunit *test, int target_cpu, int counter_index, unsigned int nr_inc, long increment)
+{
+	struct task_struct *task;
+	struct multi_thread_test_data *td = kzalloc(sizeof(struct multi_thread_test_data), GFP_KERNEL);
+
+	KUNIT_EXPECT_PTR_NE(test, td, NULL);
+	td->increment = increment;
+	td->nr_inc = nr_inc;
+	td->counter_index = counter_index;
+	atomic_inc(&kernel_threads_to_run);
+	task = kthread_run_on_cpu(multi_thread_worker_fn, td, target_cpu, "kunit_multi_thread_worker");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, task);
+}
+
+static void init_kthreads(void)
+{
+	atomic_set(&kernel_threads_to_run, 1);
+}
+
+static void fini_kthreads(void)
+{
+	/* Release our own reference. */
+	complete_work();
+	/* Wait for all others threads to run. */
+	wait_event(kernel_threads_wq, (atomic_read(&kernel_threads_to_run) == 0));
+}
+
+static void test_sync_kthreads(void)
+{
+	fini_kthreads();
+	init_kthreads();
+}
+
+static void init_counters(struct kunit *test, unsigned long batch_size)
+{
+	int i, ret;
+
+	items = kzalloc(percpu_counter_tree_items_size() * NR_COUNTERS, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, items, NULL);
+	ret = percpu_counter_tree_init_many(counter, items, NR_COUNTERS, batch_size, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	for (i = 0; i < NR_COUNTERS; i++)
+		atomic_long_set(&global_counter[i], 0);
+}
+
+static void fini_counters(void)
+{
+	percpu_counter_tree_destroy_many(counter, NR_COUNTERS);
+	kfree(items);
+}
+
+enum up_test_inc_type {
+	INC_ONE,
+	INC_MINUS_ONE,
+	INC_RANDOM,
+};
+
+/*
+ * Single-threaded tests. Those use many threads to run on various CPUs,
+ * but synchronize for completion of each thread before running the
+ * next, effectively making sure there are no concurrent updates.
+ */
+static void do_hpcc_test_single_thread(struct kunit *test, int _cpu0, int _cpu1, enum up_test_inc_type type)
+{
+	unsigned long batch_size_order = 5;
+	int cpu0 = _cpu0;
+	int cpu1 = _cpu1;
+	int i;
+
+	init_counters(test, 1UL << batch_size_order);
+	init_kthreads();
+	for (i = 0; i < 10000; i++) {
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
+			increment = (long) get_random_long() % 50000;
+			break;
+		}
+		if (_cpu0 < 0)
+			cpu0 = cpumask_any_distribute(cpu_online_mask);
+		if (_cpu1 < 0)
+			cpu1 = cpumask_any_distribute(cpu_online_mask);
+		test_run_on_specific_cpu(test, cpu0, 0, 1, increment);
+		test_sync_kthreads();
+		test_run_on_specific_cpu(test, cpu1, 1, 1, increment);
+		test_sync_kthreads();
+		check_counters(test);
+	}
+	fini_kthreads();
+	fini_counters();
+}
+
+static void hpcc_test_single_thread_first(struct kunit *test)
+{
+	int cpu = cpumask_first(cpu_online_mask);
+
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_ONE);
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_first_random(struct kunit *test)
+{
+	int cpu = cpumask_first(cpu_online_mask);
+
+	do_hpcc_test_single_thread(test, cpu, -1, INC_ONE);
+	do_hpcc_test_single_thread(test, cpu, -1, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, cpu, -1, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_random(struct kunit *test)
+{
+	do_hpcc_test_single_thread(test, -1, -1, INC_ONE);
+	do_hpcc_test_single_thread(test, -1, -1, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, -1, -1, INC_RANDOM);
+}
+
+/* Multi-threaded SMP tests. */
+
+static void do_hpcc_multi_thread_increment_each_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpu, 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_even_cpus(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpu & ~1, 1, nr_inc, increment); /* even cpus. */
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_single_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpumask_first(cpu_online_mask), 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_random_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void hpcc_test_multi_thread_batch_increment(struct kunit *test)
+{
+	unsigned long batch_size_order;
+
+	for (batch_size_order = 2; batch_size_order < 10; batch_size_order++) {
+		unsigned int nr_inc;
+
+		for (nr_inc = 1; nr_inc < 1024; nr_inc *= 2) {
+			long increment;
+
+			for (increment = 1; increment < 100000; increment *= 10) {
+				do_hpcc_multi_thread_increment_each_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_even_cpus(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_single_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_random_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+			}
+		}
+	}
+}
+
+static void hpcc_test_multi_thread_random_walk(struct kunit *test)
+{
+	unsigned long batch_size_order = 5;
+	int loop;
+
+	for (loop = 0; loop < 100; loop++) {
+		int i;
+
+		init_counters(test, 1UL << batch_size_order);
+		init_kthreads();
+		for (i = 0; i < 1000; i++) {
+			long increment = (long) get_random_long() % 512;
+			unsigned int nr_inc = ((unsigned long) get_random_long()) % 1024;
+
+			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 0, nr_inc, increment);
+			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+		}
+		fini_kthreads();
+		check_counters(test);
+		fini_counters();
+	}
+}
+
+static void hpcc_test_init_one(struct kunit *test)
+{
+	struct percpu_counter_tree pct;
+	struct percpu_counter_tree_level_item *counter_items;
+	int ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	percpu_counter_tree_destroy(&pct);
+	kfree(counter_items);
+}
+
+static void hpcc_test_set(struct kunit *test)
+{
+	static long values[] = {
+		5, 100, 127, 128, 255, 256, 4095, 4096, 500000, 0,
+		-5, -100, -127, -128, -255, -256, -4095, -4096, -500000,
+	};
+	struct percpu_counter_tree pct;
+	struct percpu_counter_tree_level_item *counter_items;
+	int i, ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
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
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, 2 * v));
+
+		percpu_counter_tree_add(&pct, -2 * v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), 0);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, 0));
+	}
+
+	percpu_counter_tree_destroy(&pct);
+	kfree(counter_items);
+}
+
+static struct kunit_case hpcc_test_cases[] = {
+	KUNIT_CASE(hpcc_print_info),
+	KUNIT_CASE(hpcc_test_single_thread_first),
+	KUNIT_CASE(hpcc_test_single_thread_first_random),
+	KUNIT_CASE(hpcc_test_single_thread_random),
+	KUNIT_CASE(hpcc_test_multi_thread_batch_increment),
+	KUNIT_CASE(hpcc_test_multi_thread_random_walk),
+	KUNIT_CASE(hpcc_test_init_one),
+	KUNIT_CASE(hpcc_test_set),
+	{}
+};
+
+static struct kunit_suite hpcc_test_suite = {
+	.name = "percpu_counter_tree",
+	.test_cases = hpcc_test_cases,
+};
+
+kunit_test_suite(hpcc_test_suite);
+
+MODULE_DESCRIPTION("Test cases for hierarchical per-CPU counters");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.43.0


