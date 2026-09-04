Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0782CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23E66B00A2; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBFA6B00A3; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9C76B00A5; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 952FA6B00A3
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F390F40140
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.23.772B4C9
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 530694000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=vgA5TNJu;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538060;
	b=PFSGey77GOzxWI3buqheAVnhlbtprzgyDpMh+aQrEKBT+E5gKcZZ4tvOj1H5KHdKTs4k0+
	ky090gRpUn7PtINbfKfbrq1sahh4J6HNdZFNkcYqNQvocfgEWAaxqf5gh4KZ65dSwibBvJ
	AtYQtqV00YzGCi9Sxz2GTow7xqvjlnk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=vgA5TNJu;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IFEeV8PcQPSD1vEIqV53mGLAZ2GqdJfZuwCTddGWLs=;
	b=h0BazE129nJBJ51kWxhRkXwhQWog8t8Xl/rbUJaBep+HQxzTP7x2rjU0WctdMnYJYVHaHj
	iCgqFkOioZNBrbqT1nSnoqYQphG2+DdDoOW3S+XcFceoGgDwrWJmfrMTtm2Urc8V75cwQ/
	HJ5je8VY6ZvK1U7zss/cGIh51t0G87c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=8IFEeV8PcQPSD1vEIqV53mGLAZ2GqdJfZuwCTddGWLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgA5TNJuOiu4SR7r/Ew5GtX8A1DjTiJ+9CRRFg5I6F7yfgPrKYeVkEt4hd7jQZQ6s
	 /TbTB5jASyMU3xtcMwmTy125/7ZCnzoCAqJcbk0ngMpc5uASkDi6mgR/JB0tABv1wV
	 ecmwMuwBqYlkWjaG5bBGkMp/Jf3Yx8lfShZx0Dt8lTvM0/tiaQHa9gv/5rjz/tcQUu
	 DebWTS6Tm4pASPpsSXo1710s2y6Ux82xQcruJqxPhEJKfglB7Zv1EHpnkuotf16PDD
	 iNj2gFHkczwSA9Zix6OVbQw2mADcJKEHWauaT0hMnzHMtaQ/CKJFVOFsKllY6+4MtL
	 v5Y5cHUegc+iA==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zf64N1zWWZ;
	Fri, 04 Sep 2026 12:07:38 -0400 (EDT)
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
Subject: [PATCH v22 10/10] lib/tests/hpcc: Fix hotplug, module unload, and error handling
Date: Fri,  4 Sep 2026 12:07:22 -0400
Message-ID: <20260904160734.23445-11-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 530694000D
X-Stat-Signature: 3j1ky5aoj7q8i16fn8ohn4ksd8whgaqs
X-Rspam-User: 
X-HE-Tag: 1788538060-592434
X-HE-Meta: U2FsdGVkX19wFDQDD0szufFpdJfsv4RZnDN+2GG2t6x2FPQz2wxMCuW/oTT48MwTlErNzVEvGlzTdh2VQWglSn/AHUbyMAKHclEsy8K0KaB4oU9xOfrX9Kj2MgF5l5n9TRBqCVvSm1VSg3w6g8jpbgTgEgt53DKN1KdOcr25i0cvmeK9Vo2tjjh/hVYmiAhTr5RFwU8P8vIg9amkULB8FP7Fq6Bcsx4GhAp2c0RKKRxQKZbCQdDIVpLPODWtvPPw1Z6d8T3mhDKHh2jydHZGdy+AMLsoXhD4ah9+JTF6RQpv7BqUQVhkeFpoFtmS+y6zbLh0eTECPu9JvZo48A0QnMVKQqwj5/RSrz4S0v8EpnFP9rV2qxq9ANyxxDe//SAcLSEQ3eA67iVBqRlImeUUg5dEvJY7n6raSDIQv9beDoxMxMKWTDJUN8FifauggdJrz2Qbnl037QzQGt4HRcy7DmTCtoISdzBpLiirBwtjl/wvIA2LHE5cy8S7H79RddDDHpfXz/Py8RBlTiTH90vi4DggxoZNDeJtfL87tXsJQhDRJnKmTrYdmcznvEffgLVXxCDTxrtfVLiUmJ88QCNctyiutaSxbHMGThneHusAPdQnjGimFmIqNF0pm9W9Gx3fq5nu5FMzyMWxhU+J5+cIRc4QCnS8DGotFNXM3YJaLD+OhyLG3RhHWH20Ril1Ohsepu7mRBKIQ8kMLYTLPdz661eOqjMg/2mWf63dC9/GLhaCRRK/XaVZB6MCq/HEZDQGVgt6gwvoxii/+HbRLUf6PpS+/4Pk4LISZRbLIO/hNCV+iV3EtAG1dEvyD1ZqTWMUqNn0n3rjomkZ/W7SG+7uWXlVO6cIw89Hdmm+TQVbLsYZt+3IPX5EQVdt47LutSVCI0oZoQqzulyS6SgwLg2QWph+l6nvJ7OPWdRVYrhjHfwrE3PZf1bz9w95RqvhZe4EsoJ6IbKm8tj2kD6fC5d
 hqtIwq/0
 UsOQHPojkvMsNLtlhqHU1yVutIIiBr+Z6jV+shPDxmq/GHkniNPKCdPhNB//th20mLDwH8ELTPZGlqBn1lgTVtVzwI1uPcLq4vZTcCzQsaI9Y+w+2KrPC6MAKTfNdiKKX7iFDwP1b0trWaoVx5qNNDoQVgHIOjY9lIw0o3633sdkTVwdzOM0E/Qn5gi6aI/5Itq6cX18JxdarMm8FWI2CuDwa7i35879j6YxuaVXW35eyiRPiOWzE4e/hxLTNkPWvvkGwZFOYIwNeezGCevup1RTfIKL8jjJLWkTx3zRc/pmL8NiDsAJYX3lL8zj2/8lJLVDQbCY4V5lwvJ+OB0pEnIlAio0cwyOvnmmYJbat52lLkfBf7O8argGb7Dr2KNje+o2fRU4D7FF6w0A+FQBSt/qVIG8laWa2H0PB4peOom40GK8SjtpTYvIG47HTck93hxoEKmiB5G6aPhsGmJhnZgS2i5ZQUj2STRyhGi4BiHNq1/XvWvIOCyZ9TPHv7gBXbeeE9y5GDklWnJg/ehtyEIXF1GK6+A2ZT5/cKOuLf4colxaVdMU4XgyoFNYrmVdEW1lm0B2sHG8ls5e15BVfSd0Fu55bcV1rpT6Yft0yKsj9KS6OgNrLqBZDGC6uFcw3RTNt4GcsKh7cpWoNl7/9zec1/0MKaAra9bhPZmAy/RGlB6tzmwl+DbOTNJB60/4OLFjw03IFE0xmTsyfcDlEE2sIAasQq/RTSif3NkzU6GxEThYtWF9dAcZTTzaPzCs2pg1D1tfuBLQEqlhsEME/J/ciNFajPSnKdZ76CMOezsZ1iTObWf2h6nXGXTRhTsRAjXVFY0cmldHRVdWexlPF58qtHF1yg8eFjNb0CHgikfpuwSALvlfckmOpNiwqapMv9K6gFFnY0elntZZO8oIyEkIXSwSkkWQHfYGEJ1U9jtjnUfoOXCIYRVk1EmeIEphMKhR6C1TBdZWR8pcVCKJpf9WCgrSl
 MFMNW7LQ
 WnhE++gPUnCpeiv7whmyQbLLLRGlBQ2MwihFoNGTNXe6zoAI/KKIT/7YDALYigzWnODChXVtQ8KzNw7SlFRmWydXqsyG6mYJ1wVMIGi9nm/B07vKxFgiuflwzKVGwpJZdJGW59DuaTHmn774WwyNHKimq/kgXLT9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Answer a report from Sashiko at:
https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers@efficios.com

Those were good catches. Following them up surfaced more than the report
contained: ERR_PTR handling, a td leak, hotplug locking, allocation
sizing, the cpu & ~1 skip, and a lost-worker bug where kthread_stop()
could preempt the threadfn before it ran, plus a task_struct reaping
race that only shows up at 1000 workers.

Plainly following Sashiko's advice to move to kthread_stop() did not
work: the thread running the worker needed a task struct reference, a
completion to ensure the work was actually done, in addition to the
kthread_stop. The kthread_stop only ensure that the thread is really
done before module unload, without guaranteeing that the kthread has
actually done its work.

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
 lib/tests/percpu_counter_tree_kunit.c | 280 +++++++++++++++++++++-----
 1 file changed, 232 insertions(+), 48 deletions(-)

diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
index a79176655c4b..8af8d2659b57 100644
--- a/lib/tests/percpu_counter_tree_kunit.c
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -6,10 +6,13 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/random.h>
+#include <linux/cpuhplock.h>
+#include <linux/slab.h>
+#include <linux/sched/task.h>
 
 struct multi_thread_test_data {
 	long increment;
-	int nr_inc;
+	unsigned int nr_inc;
 	int counter_index;
 };
 
@@ -31,6 +34,9 @@ static void complete_work(void)
 		wake_up(&kernel_threads_wq);
 }
 
+/* Random tasks test. */
+#define NR_RAND_TASKS	1000
+
 static void hpcc_print_info(struct kunit *test)
 {
 	kunit_info(test, "Running test with %d CPUs\n", num_online_cpus());
@@ -67,18 +73,19 @@ static void check_counters(struct kunit *test)
 		/* Accuracy limits checks. */
 		percpu_counter_tree_approximate_accuracy_range(&counter[counter_index], &under_accuracy, &over_accuracy);
 
+		/*
+		 * under_accuracy and over_accuracy are unsigned long, so the
+		 * inner expression promotes to unsigned. Compute the difference
+		 * in unsigned and cast to signed for the comparison against 0.
+		 */
 		KUNIT_EXPECT_GE(test, (long)(approx_sum - (v - under_accuracy)), 0);
 		KUNIT_EXPECT_LE(test, (long)(approx_sum - (v + over_accuracy)), 0);
-		KUNIT_EXPECT_GT(test, (long)(approx_sum - (v - under_accuracy - 1)), 0);
-		KUNIT_EXPECT_LT(test, (long)(approx_sum - (v + over_accuracy + 1)), 0);
 
 		/* Precise min/max range check. */
 		percpu_counter_tree_approximate_min_max_range(approx_sum, under_accuracy, over_accuracy, &precise_min, &precise_max);
 
 		KUNIT_EXPECT_GE(test, v - precise_min, 0);
 		KUNIT_EXPECT_LE(test, v - precise_max, 0);
-		KUNIT_EXPECT_GT(test, v - (precise_min - 1), 0);
-		KUNIT_EXPECT_LT(test, v - (precise_max + 1), 0);
 	}
 	/* Compare each counter with the second counter. */
 	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[0]), percpu_counter_tree_precise_sum(&counter[1]));
@@ -96,18 +103,26 @@ static int multi_thread_worker_fn(void *data)
 	return 0;
 }
 
-static void test_run_on_specific_cpu(struct kunit *test, int target_cpu, int counter_index, unsigned int nr_inc, long increment)
+static struct task_struct *test_run_on_specific_cpu(int target_cpu, int counter_index, unsigned int nr_inc, long increment)
 {
-	struct task_struct *task;
 	struct multi_thread_test_data *td = kzalloc(sizeof(struct multi_thread_test_data), GFP_KERNEL);
+	struct task_struct *task;
 
-	KUNIT_EXPECT_PTR_NE(test, td, NULL);
+	if (!td)
+		return NULL;
 	td->increment = increment;
 	td->nr_inc = nr_inc;
 	td->counter_index = counter_index;
 	atomic_inc(&kernel_threads_to_run);
-	task = kthread_run_on_cpu(multi_thread_worker_fn, td, target_cpu, "kunit_multi_thread_worker");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, task);
+	task = kthread_create_on_cpu(multi_thread_worker_fn, td, target_cpu, "kunit_multi_thread_worker");
+	if (IS_ERR_OR_NULL(task)) {
+		complete_work();
+		kfree(td);
+		return task;
+	}
+	get_task_struct(task);
+	wake_up_process(task);
+	return task;
 }
 
 static void init_kthreads(void)
@@ -115,6 +130,9 @@ static void init_kthreads(void)
 	atomic_set(&kernel_threads_to_run, 1);
 }
 
+/*
+ * The caller needs to wait for work completion _before_ stopping kthreads.
+ */
 static void fini_kthreads(void)
 {
 	/* Release our own reference. */
@@ -129,23 +147,27 @@ static void test_sync_kthreads(void)
 	init_kthreads();
 }
 
-static void init_counters(struct kunit *test, unsigned long batch_size)
+static int init_counters(unsigned long batch_size)
 {
 	int i, ret;
 
-	items = kzalloc(percpu_counter_tree_items_size() * NR_COUNTERS, GFP_KERNEL);
-	KUNIT_EXPECT_PTR_NE(test, items, NULL);
+	items = kvcalloc(NR_COUNTERS, percpu_counter_tree_items_size(), GFP_KERNEL);
+	if (!items)
+		return -ENOMEM;
 	ret = percpu_counter_tree_init_many(counter, items, NR_COUNTERS, batch_size, GFP_KERNEL);
-	KUNIT_EXPECT_EQ(test, ret, 0);
-
+	if (ret) {
+		kvfree(items);
+		return ret;
+	}
 	for (i = 0; i < NR_COUNTERS; i++)
 		atomic_long_set(&global_counter[i], 0);
+	return 0;
 }
 
 static void fini_counters(void)
 {
 	percpu_counter_tree_destroy_many(counter, NR_COUNTERS);
-	kfree(items);
+	kvfree(items);
 }
 
 enum up_test_inc_type {
@@ -164,11 +186,16 @@ static void do_hpcc_test_single_thread(struct kunit *test, int _cpu0, int _cpu1,
 	unsigned long batch_size_order = 5;
 	int cpu0 = _cpu0;
 	int cpu1 = _cpu1;
-	int i;
+	int ret, i;
 
-	init_counters(test, 1UL << batch_size_order);
+	ret = init_counters(1UL << batch_size_order);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return;
 	init_kthreads();
+	cpus_read_lock();
 	for (i = 0; i < 10000; i++) {
+		struct task_struct *task;
 		long increment;
 
 		switch (type) {
@@ -181,18 +208,34 @@ static void do_hpcc_test_single_thread(struct kunit *test, int _cpu0, int _cpu1,
 		case INC_RANDOM:
 			increment = (long) get_random_long() % 50000;
 			break;
+		default:
+			WARN_ON_ONCE(1);
+			increment = 0;
 		}
 		if (_cpu0 < 0)
 			cpu0 = cpumask_any_distribute(cpu_online_mask);
 		if (_cpu1 < 0)
 			cpu1 = cpumask_any_distribute(cpu_online_mask);
-		test_run_on_specific_cpu(test, cpu0, 0, 1, increment);
+		task = test_run_on_specific_cpu(cpu0, 0, 1, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task);
+		if (IS_ERR_OR_NULL(task)) {
+			fini_kthreads();
+			goto end;
+		}
 		test_sync_kthreads();
-		test_run_on_specific_cpu(test, cpu1, 1, 1, increment);
+		kthread_stop_put(task);
+		task = test_run_on_specific_cpu(cpu1, 1, 1, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task);
+		if (IS_ERR_OR_NULL(task)) {
+			fini_kthreads();
+			goto end;
+		}
 		test_sync_kthreads();
+		kthread_stop_put(task);
 		check_counters(test);
 	}
-	fini_kthreads();
+end:
+	cpus_read_unlock();
 	fini_counters();
 }
 
@@ -225,62 +268,168 @@ static void hpcc_test_single_thread_random(struct kunit *test)
 
 static void do_hpcc_multi_thread_increment_each_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
 {
-	int cpu;
-
-	init_counters(test, batch_size);
+	struct task_struct *(*task)[NR_COUNTERS];
+	int ret, cpu;
+
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!task)
+		return;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 	init_kthreads();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
-		test_run_on_specific_cpu(test, cpu, 1, nr_inc, increment);
+		task[cpu][0] = test_run_on_specific_cpu(cpu, 0, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][0]);
+		if (IS_ERR_OR_NULL(task[cpu][0]))
+			break;
+		task[cpu][1] = test_run_on_specific_cpu(cpu, 1, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][1]);
+		if (IS_ERR_OR_NULL(task[cpu][1]))
+			break;
 	}
 	fini_kthreads();
+	for_each_online_cpu(cpu) {
+		if (!IS_ERR_OR_NULL(task[cpu][0]))
+			kthread_stop_put(task[cpu][0]);
+		if (!IS_ERR_OR_NULL(task[cpu][1]))
+			kthread_stop_put(task[cpu][1]);
+	}
+	cpus_read_unlock();
 	check_counters(test);
 	fini_counters();
+end:
+	kvfree(task);
 }
 
 static void do_hpcc_multi_thread_increment_even_cpus(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
 {
-	int cpu;
-
-	init_counters(test, batch_size);
+	struct task_struct *(*task)[NR_COUNTERS];
+	int ret, cpu;
+
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!task)
+		return;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 	init_kthreads();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
-		test_run_on_specific_cpu(test, cpu & ~1, 1, nr_inc, increment); /* even cpus. */
+		/*
+		 * Funnel pairs of CPU indexes to their associated even index.
+		 *
+		 *   Map 0 and 1 -> index 0
+		 *   Map 2 and 3 -> index 2 and so on.
+		 */
+		int even_cpu = cpu & ~1;
+
+		if (!cpumask_test_cpu(even_cpu, cpu_online_mask))
+			continue;
+		task[cpu][0] = test_run_on_specific_cpu(cpu, 0, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][0]);
+		if (IS_ERR_OR_NULL(task[cpu][0]))
+			break;
+		task[cpu][1] = test_run_on_specific_cpu(even_cpu, 1, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][1]);
+		if (IS_ERR_OR_NULL(task[cpu][1]))
+			break;
 	}
 	fini_kthreads();
+	for_each_online_cpu(cpu) {
+		if (!IS_ERR_OR_NULL(task[cpu][0]))
+			kthread_stop_put(task[cpu][0]);
+		if (!IS_ERR_OR_NULL(task[cpu][1]))
+			kthread_stop_put(task[cpu][1]);
+	}
+	cpus_read_unlock();
 	check_counters(test);
 	fini_counters();
+end:
+	kvfree(task);
 }
 
 static void do_hpcc_multi_thread_increment_single_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
 {
-	int cpu;
-
-	init_counters(test, batch_size);
+	struct task_struct *(*task)[NR_COUNTERS];
+	int ret, cpu;
+
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!task)
+		return;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 	init_kthreads();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
-		test_run_on_specific_cpu(test, cpumask_first(cpu_online_mask), 1, nr_inc, increment);
+		task[cpu][0] = test_run_on_specific_cpu(cpu, 0, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][0]);
+		if (IS_ERR_OR_NULL(task[cpu][0]))
+			break;
+		task[cpu][1] = test_run_on_specific_cpu(cpumask_first(cpu_online_mask), 1, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][1]);
+		if (IS_ERR_OR_NULL(task[cpu][1]))
+			break;
 	}
 	fini_kthreads();
+	for_each_online_cpu(cpu) {
+		if (!IS_ERR_OR_NULL(task[cpu][0]))
+			kthread_stop_put(task[cpu][0]);
+		if (!IS_ERR_OR_NULL(task[cpu][1]))
+			kthread_stop_put(task[cpu][1]);
+	}
+	cpus_read_unlock();
 	check_counters(test);
 	fini_counters();
+end:
+	kvfree(task);
 }
 
 static void do_hpcc_multi_thread_increment_random_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
 {
-	int cpu;
-
-	init_counters(test, batch_size);
+	struct task_struct *(*task)[NR_COUNTERS];
+	int ret, cpu;
+
+	task = kvcalloc(nr_cpu_ids, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!task)
+		return;
+	ret = init_counters(batch_size);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 	init_kthreads();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
-		test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+		task[cpu][0] = test_run_on_specific_cpu(cpu, 0, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][0]);
+		if (IS_ERR_OR_NULL(task[cpu][0]))
+			break;
+		task[cpu][1] = test_run_on_specific_cpu(cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[cpu][1]);
+		if (IS_ERR_OR_NULL(task[cpu][1]))
+			break;
 	}
 	fini_kthreads();
+	for_each_online_cpu(cpu) {
+		if (!IS_ERR_OR_NULL(task[cpu][0]))
+			kthread_stop_put(task[cpu][0]);
+		if (!IS_ERR_OR_NULL(task[cpu][1]))
+			kthread_stop_put(task[cpu][1]);
+	}
+	cpus_read_unlock();
 	check_counters(test);
 	fini_counters();
+end:
+	kvfree(task);
 }
 
 static void hpcc_test_multi_thread_batch_increment(struct kunit *test)
@@ -305,25 +454,50 @@ static void hpcc_test_multi_thread_batch_increment(struct kunit *test)
 
 static void hpcc_test_multi_thread_random_walk(struct kunit *test)
 {
+	struct task_struct *(*task)[NR_COUNTERS];
 	unsigned long batch_size_order = 5;
 	int loop;
 
+	task = kvcalloc(NR_RAND_TASKS, sizeof(*task), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, task);
+	if (!task)
+		return;
 	for (loop = 0; loop < 100; loop++) {
-		int i;
+		int ret, i;
 
-		init_counters(test, 1UL << batch_size_order);
+		memset(task, 0, NR_RAND_TASKS * sizeof(*task));
+		ret = init_counters(1UL << batch_size_order);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		if (ret)
+			goto end;
 		init_kthreads();
-		for (i = 0; i < 1000; i++) {
+		cpus_read_lock();
+		for (i = 0; i < NR_RAND_TASKS; i++) {
 			long increment = (long) get_random_long() % 512;
 			unsigned int nr_inc = ((unsigned long) get_random_long()) % 1024;
 
-			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 0, nr_inc, increment);
-			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+			task[i][0] = test_run_on_specific_cpu(cpumask_any_distribute(cpu_online_mask), 0, nr_inc, increment);
+			KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[i][0]);
+			if (IS_ERR_OR_NULL(task[i][0]))
+				break;
+			task[i][1] = test_run_on_specific_cpu(cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+			KUNIT_EXPECT_NOT_ERR_OR_NULL(test, task[i][1]);
+			if (IS_ERR_OR_NULL(task[i][1]))
+				break;
 		}
 		fini_kthreads();
+		for (i = 0; i < NR_RAND_TASKS; i++) {
+			if (!IS_ERR_OR_NULL(task[i][0]))
+				kthread_stop_put(task[i][0]);
+			if (!IS_ERR_OR_NULL(task[i][1]))
+				kthread_stop_put(task[i][1]);
+		}
+		cpus_read_unlock();
 		check_counters(test);
 		fini_counters();
 	}
+end:
+	kvfree(task);
 }
 
 static void hpcc_test_init_one(struct kunit *test)
@@ -333,11 +507,16 @@ static void hpcc_test_init_one(struct kunit *test)
 	int ret;
 
 	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
-	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	KUNIT_EXPECT_NOT_NULL(test, counter_items);
+	if (!counter_items)
+		return;
 	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 
 	percpu_counter_tree_destroy(&pct);
+end:
 	kfree(counter_items);
 }
 
@@ -352,9 +531,13 @@ static void hpcc_test_set(struct kunit *test)
 	int i, ret;
 
 	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
-	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	KUNIT_EXPECT_NOT_NULL(test, counter_items);
+	if (!counter_items)
+		return;
 	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		goto end;
 
 	for (i = 0; i < ARRAY_SIZE(values); i++) {
 		long v = values[i];
@@ -373,6 +556,7 @@ static void hpcc_test_set(struct kunit *test)
 	}
 
 	percpu_counter_tree_destroy(&pct);
+end:
 	kfree(counter_items);
 }
 
-- 
2.43.0


