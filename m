Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA12E909D2
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834DE6B0092; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9086B0096; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E1A6B0095; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B6B6B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04349C1489
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:18 +0000 (UTC)
X-FDA: 84454435758.24.A08C104
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D86B1C0011
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=VlcE6tSC;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771344617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCXCKc5bUic49+KM+VRO30RqdAn/ldv24wskZD0uciQ=;
	b=tbzDut3F2OsMDKLcnTciRvokXjc4GUbEFotv0PkTmslPMNW738cPpcl0bqTERpahjMuokQ
	0psGUB0V6/WsnK1S8PpNoU25tGoSgMOcvcw9LKSwl6Gdnquq5AxFu8fad3W3KrvFIFdl0E
	ycRW8RLDDAdPad08ZNFPRB2QhzNc4oE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771344617; a=rsa-sha256;
	cv=none;
	b=qPQZ8y6rVsUZ9pK9f7Cg9SNkNuuQs1QTgCAKlPPdTZu0h7TpTXIaRIpNb/uggCbX2WLo3q
	l3jS865dDDmE9YynmwavQzkiI3NajTiT/lAeUnV7i1S346HkfOg7rhfB56jdn8ZxSZOL0J
	BjtjYFqrhllMAMSMnQ8TL4162hiSbF8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=VlcE6tSC;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1771344616;
	bh=yCXCKc5bUic49+KM+VRO30RqdAn/ldv24wskZD0uciQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlcE6tSC1P58urPP6Nx/eDqQYLYl6F8wruw2EKK5ROBEvORLxORKnK1YU5kDHcjTH
	 krISXDCOUoJhN5MeHwdP+dOXccHCLO1gzwuK3U/8M/bEdHm+JU5uvxH4RUHoFvzX9v
	 C6UcVCFzFHvgTW/crQOmBL8iBzvUYPSyhyru61fJxC+qUvvW1VjvWygjw/PRLlRPe6
	 hz9H3iiES9GQjDQG9BGttdhVI4FT1kuuP1TaDWotWAD6huBPlT6A8JTdIKBH5MaiUF
	 hj2DP5kzKlrRA1iSdhT35fYt6Wp9omvsm4O+9SLdOg8vWqtbzNl+fu5rb483c0qG7c
	 rZCsoV21Y5lUQ==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:1cd8:5cbf:5001:d5b1])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fFl3X4GYHzF7t;
	Tue, 17 Feb 2026 11:10:16 -0500 (EST)
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
Subject: [PATCH v17 2/3] lib: Test hierarchical per-cpu counters
Date: Tue, 17 Feb 2026 11:10:05 -0500
Message-Id: <20260217161006.1105611-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: kf3tinw34jmrxmzxxc5zbs9a5tiobzbe
X-Rspamd-Queue-Id: 6D86B1C0011
X-Rspam-User: 
X-HE-Tag: 1771344617-26580
X-HE-Meta: U2FsdGVkX19HkVcO1C8Jt6QqXFiRh6L34lI8+WbCt0qG62r+9ZiK7/RR9r5bP3ZayuoDsNHi/tPioMVB6Ba1Mf4zvhOhaXvNbLnGAkbI0+W89EIPX6qdXjssr4EnpU6/rnbNskSoZtVbaJflmKW+sn3LDuqJEWfsdjWG9PzzZ2iMeZKsfNInpbdVSbWaQsovAZjImjuAgZtOeEKOhqE1l/pznC1Vy4J2oD2vKLa0VjbbIhJfw2TRouWllFLGDLf1KjuhYC3EMImNdzR+rHeE5fnvUy4g7STmhc8qZJJOeP1eLhzRnkb9/pc9I5u+pQU5Eb7pqBeXes8E1daG0jVd4L2dPnFZGWRtFb1sMq0vtduI2tzEjk4BrTAdLF6Dszbp6YasmqWQRnIkbeTjIm26nwWWaIre+qQ9MktVT5+2uygUuk4+/ZLg+Hlfi/GCyoMxtDmRq00tX5T0t4HbQKJOPFlp5AGrUK2+3SNiwX9RKbaDq/zI/7AxB/lVjODNHA3JQkHeMuOKtnVPErfS9RPisXHxWFsWeydlKgGfjk3zKOG0D6PHY5JmJHEhlytjfN/m+zn/zOgr9AXMxD+KwRiDLv+8dPkh4HsEHytDY7LvJFcKCkmwPW/mXxtgQ1nrF8Awkb6KMzQzvkly2BEB2tRMdF00+/NlQ1QfukQGn6eTxLg2GititgH0b8yU/oyVh5r8Laqgfv0idZaBWK7qjwhVn19wMrg1jUufUrDfFCz9G2K7fXkI1vyoAkwarvZCBVLCGdb5pc6GgF0T94OneqNX/fPgdyv5Ce7sJgQLCt4ku/6DZa3O9YosJ/1mIrOjiPX696Wili50APSB5RapS24MBMi9i1myE6S8i3W4ggB5Okq2HgP7Fb263m5mTfhFSSK36MP4QJiaLBkh162UV+i7p5Y0jnpr1DfuD2FZIUFh3Wr0cbwxDsDWGlNyjqf658+w1pC7+5PGJcaBfUZm3vD
 32Rbz+ad
 AlaXhvFQvlzpsqcAKsbJKRizmPjIeVIZdTfEJBm6orfuLA8p1ynSNknotlCFgK9d2c6USQ6rJh1kktd2l6aGbAmxOCqMO5hxxYgjMAKAINzzywT6A1cA3GUXn1j2fchCBsnjNmnn7CoR8vNB0iFjfS7+tGDMzGc3N1cjMS5dDBMpTcTvexGO0xXJI7u5fbq+1cqlJHVq0Dzzj2qVYyGDMd09XEggjDCQzsmjTKCNjeqfuLFxw8C/RZOVp6gIAF/XMhF5LIP0QJHL51Qa+nlqiqWfxQjeG+AIhSw55/iBECpcNAc7SyEZhLAQ7XWDFp8vNQODetzzDYALHRMEQIQk1RhjLn2trQ7gCT7/1PYd7/RAqv+4SbeOR5mhe+UDnsZZCZCFn6LFYmWdBglXQRLyfbugWdhMhC1Q6vHQnOcesHGrwakzK/RvkBvB5KkZaStZa4cTq3sMvQR/RehffC2pdUoNA7swMA7NsoQ6YJduDMOzV5fOOYmd1Lq3f6vtARwEN2IvoaBdq/yHMAImf2mm7R0MxH5lJvffxmNC+qLMGALXDNa6IIWBeb5Y9fhD8E2E9Q1MP/Sze5i4jaVGbzatzd1znaMpb1zsqxURRO1e/AptQtqW7EIBODWwXti0O6QFgkuVaEE5/EBo1pw8kof2mCFsqUXHzzEqA/nW5F2b6L3csWQKMaAnxAR1Xr+o6WXCO7IVTI8bvQbGxIbvv4eOIB+AWGVvZz5lJwsvYBbiUvUSBYsaHTgm2hp0MMWeaN4WWw5jw3POurx6BzlsisT7oHuHEe9Or5vOB6zK6k6Xp/IoE62yZRHOQ9BQW25SJZVT9xgmPgzh0lrxL2fNVA4f+FcHFujdDnKBjgHpEfJKbHOIkXVnLq4nAhGPZVZRWJO/diPIxMKd/onzJRZOkhU7NeISeJua0cqenXMPUqzLyMFcfFobQTyeNRUzmXBNl5HdMFoUGD/KLZO4VvqId5tXGNBIyuMuP
 5OL0viCF
 BS79jxQfUNY9oAHEVTs438fyGlSD2c9NIAxJUfabPgQOJr1Avxi54IF5lEREoLVNaYrC8QBz2h0s2N6VoO/YdazfCO/6JWLGC0sn56aFEO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce Kunit tests for hierarchical per-cpu counters.

Keep track of two sets of hierarchical counters, each meant to
have the same precise sum at any time, but distributed differently
across the topology.

Keep track of an atomic counter along with each hierarchical
counter, for sum validation.

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
CONFIG_PERCPU_COUNTER_TREE_TEST=y

With the following execution (to use SMP):

./tools/testing/kunit/kunit.py run --arch=x86_64 --qemu_args="-smp 12"

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
 lib/Kconfig                           |  12 +
 lib/tests/Makefile                    |   2 +
 lib/tests/percpu_counter_tree_kunit.c | 351 ++++++++++++++++++++++++++
 3 files changed, 365 insertions(+)
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

diff --git a/lib/Kconfig b/lib/Kconfig
index 0f2fb9610647..0b8241e5b548 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -52,6 +52,18 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config PERCPU_COUNTER_TREE_TEST
+	tristate "Hierarchical Per-CPU counter test" if !KUNIT_ALL_TESTS
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
 
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 05f74edbc62b..d282aa23d273 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -56,4 +56,6 @@ obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
+obj-$(CONFIG_PERCPU_COUNTER_TREE_TEST) += percpu_counter_tree_kunit.o
+
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
new file mode 100644
index 000000000000..6d2cee1c5801
--- /dev/null
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -0,0 +1,351 @@
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
+/* Hierarchical per-CPU counter instances. */
+static struct percpu_counter_tree counter[2];
+static struct percpu_counter_tree_level_item *items[2];
+
+/* Global atomic counters for validation. */
+static atomic_long_t global_counter[2];
+
+static struct wait_queue_head kernel_threads_wq;
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
+	for (counter_index = 0; counter_index < 2; counter_index++) {
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
+	init_waitqueue_head(&kernel_threads_wq);
+}
+
+static void fini_kthreads(void)
+{
+	/* Release our own reference. */
+	complete_work();
+	/* Wait for all others threads to run. */
+	__wait_event(kernel_threads_wq, (atomic_read(&kernel_threads_to_run) == 0));
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
+	for (i = 0; i < 2; i++) {
+		items[i] = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+		KUNIT_EXPECT_PTR_NE(test, items[i], NULL);
+		ret = percpu_counter_tree_init(&counter[i], items[i], batch_size, GFP_KERNEL);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+
+		atomic_long_set(&global_counter[i], 0);
+	}
+}
+
+static void fini_counters(void)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		percpu_counter_tree_destroy(&counter[i]);
+		kfree(items[i]);
+	}
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
+static struct kunit_case hpcc_test_cases[] = {
+	KUNIT_CASE(hpcc_print_info),
+	KUNIT_CASE(hpcc_test_single_thread_first),
+	KUNIT_CASE(hpcc_test_single_thread_first_random),
+	KUNIT_CASE(hpcc_test_single_thread_random),
+	KUNIT_CASE(hpcc_test_multi_thread_batch_increment),
+	KUNIT_CASE(hpcc_test_multi_thread_random_walk),
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
2.39.5


