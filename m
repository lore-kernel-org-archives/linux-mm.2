Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A70CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD246B00F3; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA47F6B00F5; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BCB6B00F6; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 755C96B00F3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C8581605DC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:05 +0000 (UTC)
X-FDA: 85041118890.21.319E0BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C82261A0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMnK9Ivp;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFSRdx4VR4AvdkOAoQOMpC+N39DKHBrUpDK98mPZCUM=;
	b=3sTuboE8fWkkYwPpndexBf9rJ9VN3p3FHI9nEkzihyozleXI92II9HCLwP0C2STs4XJzG/
	AiLk4FZlBkvUPq0X+DBxr7UVLO/gilkdEkD3mPnUIZfZn/Rjz43tHvrPy4eCm4pfOTl7+T
	zPPod1wIaL0b93lEgAMUJlffEm215to=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313263;
	b=LLU1Oq5ByJxCuox8gBEgN1rBt71OulhHp0zDXHlga/M+6FoE+H1yAcP5hWrpRIdFyQHmgM
	fv8imTmAk+3EWsofsjUhB5CgowjdUq4dMgsXE2/4FaFq1AcSGlBxHQN9v9r3OXjeyKeVtp
	jYqZksDEQHLWgsSBbYT13qSSqdxt4LY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMnK9Ivp;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C33440BA2;
	Wed, 29 Jul 2026 08:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659DA1F00A3A;
	Wed, 29 Jul 2026 08:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313263;
	bh=VFSRdx4VR4AvdkOAoQOMpC+N39DKHBrUpDK98mPZCUM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kMnK9Ivp6mBrw8pG6TGk8Ypr26SD3KAQistfH6ePze8HfrYfXYetLAqtkh9Fp0ny8
	 fPuU4vZwsxB00ibaFhEaagvZ8GdsCwfxcA40s6XDiq9m7bCwL0VXVawxghLDUqDzKJ
	 ZoP878T1L6qKyu+TW1DJmzLheelntpOeW6TzFxBOe29q55ii9W1uTCWd6PmJakFIe9
	 HBdO6OdFl/V0+V/NeZ42+Aw4ky8+07kuiZr5UKh48pVhOFFQHBrDtk/RRkqG0AOVgT
	 7vqUER7geUK8cGxyfPSV2fHcyx6rcBX6jqsaCWC9vbi1FAOvc627vihJ2Y3b1xXk4t
	 mFciSGtF0FfVg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:09 +0900
Subject: [PATCH v5 1/8] mm/slab, slub_kunit: register kprobe to trigger
 _nolock APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-1-a28cdcda9673@kernel.org>
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C82261A0006
X-Stat-Signature: kpw6dqa5ubibncdgqh1rkhryt5s6strt
X-Rspam-User: 
X-HE-Tag: 1785313263-244059
X-HE-Meta: U2FsdGVkX1+kVkV3fo7CkwsMm9AAF6IkcpaPtW+MThBzJlZMpxk2gIJHNH1CQrBH1wNIgbub8xWBVhRjRj3i4SDU9J2C2/zrMLP1FPjOWonG/fyIwvHUE8qSD9reQuFSSQu7fFGOphPtaEmTIydn69xkrfOPzNbMYam7vi966OtqkPqJ4RsJAnY0W5OYoFoiMjhAC3XhuVcKVshVVE3crJ05t1+Knfm3JizewH9yhuHZVneLZkqTwmdq41ShLMrnfzV+pv5mZlJeZi01lYMwkXhqaub+C4QHiI/ACUfw6lxisBuRvScJQ1BIJFtbvrmcNkdGicfPpHteK6xwxnWNiEdhTY7gIYJow5m3O4S2A1fzyiEBnM/Segs1biifTp+rY1Q8geVCoCZsnK4COcIomPh/jd4eLpPRhsdnq4SafuJV/0NoCSGniUzNVk41g/rXnwmmLwYJvYD93AQwulwlfWJSGUiCVkjV5x+9N4UxkfzyFF4cTF0RANk2yslV+4pLQ0jxEqJXYCkPQE+EWfHrUNIrfU1vdZ1g2XUvjuNLWOtKLeARWClVJsGqk24qpf90WfHJkXOIxBx8+Ugq4jkPASpAE0zNGBAfBCbirVunVk2gs6mAi2kWRZHPELTEI7V7ZpF32DwFK7ck/8U1UcI25zWVW/H1n50Iup1CDv3PYtutCzcjnzYhK4Hzn5MGQKDJl6Zg8wjH1kGEYk8xnuUn/uWCPXXse3ThrR3Wa9oLbsSh/sh7WYRo3lrWkJqMPhX48OAfeygQaZEfPcqn5VK1Ki5fbb/X1YIyTd4rwI/RqoX0Kiz6+D7qxfmktZaeQ9S2ZZRiaZ58tahbfG1eQmme5ABwA2fj1lGJlW30CjTqxe0u785ugBhziuCUamGiUORcFuMUr7nH1qv5jIXlhsbhvWG0aOR1An/5UMhkcXRPdymyT/Pm0L9rVFDfWkNGfd7gXozBDO8vSOE+tikg53L
 Y8QBMTLB
 5poh1oO/viosHshnK0aQ9y4WUECwpJTMWheNkXLsd0cnBx+lWfSj5Kez09sbn/ZvBAUnd2CZnBN62+nO9mYHRr1LIz62G51iA9Y/wTiYSQ6Iwn/1XBGOPnsWhLQez/5AhQA3NM3K0e+HS5Ymvq6VaSaXSwZj/3UrfwkEhigEHrhoRSAMj8EahTIxJI+67JyoG+kdblPP2eIfcQRQ8xndr0baN+XQj6IpWvAHaxz0ROOv7DXaaG0JO5a7dgdHYl0Dr4yv88dle0E7dBP0ABxiG1gjxTTDYK2DhLZ/htO1DvIXIHCuxlFMZxtLofgDACJQ1bFrk1ge20ANX1zZAVzQxpWLF0e5+mXVaiUkq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kmalloc_nolock() always fails in NMI and hardirq contexts on
PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.

Register a kprobe pre-handler to invoke kmalloc_nolock() and
kfree_nolock() in the middle of the slab allocator. However, do not
register the handler on UP kernels because that use case is not
well supported [1] in the kernel.

To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
is held, add a wrapper function for lockdep_assert_held() that calls
a no-op function slab_attach_kprobe_locked() on debug builds. The
function is optimized away when neither CONFIG_PROVE_LOCKING nor
CONFIG_DEBUG_VM is selected and register_kprobe() fails.

The function calls barrier() to prevent the compiler from optimizing
away its callsites. Otherwise, the compiler may consider the function
does not have any side effect and remove callsites.

Compared to using plain kprobe, this has two advantages: 1) it avoids
hardcoding function names in the test, and 2) it can trigger those APIs
in the middle of a function, where the lock is expected to be held as
annotated with lockdep.

While it was proposed [2] to use kunit function redirection to test
this, it is currently infeasible as some lock helpers don't have
symbols.

Factor out the nested loop that calls kmalloc and friends to
test_kmalloc_kfree(), and call them in
test_kmalloc_kfree_nolock_{perf,kprobe}(), each being an independent
test case. During the refactoring, drop alloc_fail handling as it
doesn't provide much benefits.

Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 167 +++++++++++++++++++++++++++++++++++--------------
 mm/slub.c              |  36 ++++++++---
 2 files changed, 148 insertions(+), 55 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca16..8c2b9911471e 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -8,6 +8,7 @@
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
 #include <linux/perf_event.h>
+#include <linux/kprobes.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -292,7 +293,7 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
-#ifdef CONFIG_PERF_EVENTS
+#if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
 static void *objects[NR_OBJECTS];
@@ -302,26 +303,40 @@ struct test_nolock_context {
 	int callback_count;
 	int alloc_ok;
 	int alloc_fail;
+#ifdef CONFIG_PERF_EVENTS
 	struct perf_event *event;
+#endif
+#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
+	struct kprobe kprobe;
+#endif
 };
 
-static struct perf_event_attr hw_attr = {
-	.type = PERF_TYPE_HARDWARE,
-	.config = PERF_COUNT_HW_CPU_CYCLES,
-	.size = sizeof(struct perf_event_attr),
-	.pinned = 1,
-	.disabled = 1,
-	.freq = 1,
-	.sample_freq = 100000,
-};
+static void test_kmalloc_kfree(void)
+{
+	int i, j;
+
+	for (i = 0; i < NR_ITERATIONS; i++) {
+		for (j = 0; j < NR_OBJECTS; j++) {
+			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
+
+			objects[j] = kmalloc(64, gfp);
+			if (!objects[j]) {
+				j--;
+				while (j >= 0)
+					kfree(objects[j--]);
+				return;
+			}
+		}
+
+		for (j = 0; j < NR_OBJECTS; j++)
+			kfree(objects[j]);
+	}
+}
 
-static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
-						       struct perf_sample_data *data,
-						       struct pt_regs *regs)
+static void test_nolock(struct test_nolock_context *ctx)
 {
 	void *objp;
 	gfp_t gfp;
-	struct test_nolock_context *ctx = event->overflow_handler_context;
 
 	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
 	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
@@ -335,47 +350,104 @@ static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
 	kfree_nolock(objp);
 	ctx->callback_count++;
 }
+#endif
+
+#ifdef CONFIG_PERF_EVENTS
+static struct perf_event_attr hw_attr = {
+	.type = PERF_TYPE_HARDWARE,
+	.config = PERF_COUNT_HW_CPU_CYCLES,
+	.size = sizeof(struct perf_event_attr),
+	.pinned = 1,
+	.disabled = 1,
+	.freq = 1,
+	.sample_freq = 100000,
+};
 
-static void test_kmalloc_kfree_nolock(struct kunit *test)
+static void overflow_handler_test_nolock(struct perf_event *event,
+					 struct perf_sample_data *data,
+					 struct pt_regs *regs)
+{
+	struct test_nolock_context *ctx = event->overflow_handler_context;
+
+	test_nolock(ctx);
+}
+
+static bool enable_perf_events(struct test_nolock_context *ctx)
 {
-	int i, j;
-	struct test_nolock_context ctx = { .test = test };
 	struct perf_event *event;
-	bool alloc_fail = false;
 
 	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
-						 overflow_handler_test_kmalloc_kfree_nolock,
-						 &ctx);
+						 overflow_handler_test_nolock,
+						 ctx);
+
 	if (IS_ERR(event))
-		kunit_skip(test, "Failed to create perf event");
-	ctx.event = event;
-	perf_event_enable(ctx.event);
-	for (i = 0; i < NR_ITERATIONS; i++) {
-		for (j = 0; j < NR_OBJECTS; j++) {
-			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
+		return false;
 
-			objects[j] = kmalloc(64, gfp);
-			if (!objects[j]) {
-				j--;
-				while (j >= 0)
-					kfree(objects[j--]);
-				alloc_fail = true;
-				goto cleanup;
-			}
-		}
-		for (j = 0; j < NR_OBJECTS; j++)
-			kfree(objects[j]);
-	}
+	ctx->event = event;
+	perf_event_enable(ctx->event);
+	return true;
+}
+
+static void disable_perf_events(struct test_nolock_context *ctx)
+{
+	kunit_info(ctx->test, "HW perf events: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
+		   ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
+
+	perf_event_disable(ctx->event);
+	perf_event_release_kernel(ctx->event);
+}
+
+static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
+{
+	struct test_nolock_context ctx = { .test = test };
+
+	if (!enable_perf_events(&ctx))
+		kunit_skip(test, "Failed to enable perf event, skipping");
+
+	test_kmalloc_kfree();
+
+	disable_perf_events(&ctx);
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+}
+#endif
+
+#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
+static int slab_kprobe_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct test_nolock_context *ctx;
+
+	ctx = container_of(p, struct test_nolock_context, kprobe);
+	test_nolock(ctx);
+	return 0;
+}
+
+static bool register_slab_kprobes(struct test_nolock_context *ctx)
+{
+	ctx->kprobe.symbol_name = "slab_attach_kprobe_locked";
+	ctx->kprobe.pre_handler = slab_kprobe_pre_handler;
+
+	if (register_kprobe(&ctx->kprobe))
+		return false;
+	return true;
+}
+
+static void unregister_slab_kprobes(struct test_nolock_context *ctx)
+{
+	kunit_info(ctx->test, "kprobes: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
+		   ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
+	unregister_kprobe(&ctx->kprobe);
+}
+
+static void test_kmalloc_kfree_nolock_kprobe(struct kunit *test)
+{
+	struct test_nolock_context ctx = { .test = test };
 
-cleanup:
-	perf_event_disable(ctx.event);
-	perf_event_release_kernel(ctx.event);
+	if (!register_slab_kprobes(&ctx))
+		kunit_skip(test, "Failed to register kprobe, skipping");
 
-	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
-		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
+	test_kmalloc_kfree();
 
-	if (alloc_fail)
-		kunit_skip(test, "Allocation failed");
+	unregister_slab_kprobes(&ctx);
 	KUNIT_EXPECT_EQ(test, 0, slab_errors);
 }
 #endif
@@ -405,7 +477,10 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
 #ifdef CONFIG_PERF_EVENTS
-	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
+	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_perf),
+#endif
+#if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
+	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_kprobe),
 #endif
 	{}
 };
diff --git a/mm/slub.c b/mm/slub.c
index 691977e8c09d..d14226ad0982 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -905,6 +905,24 @@ static inline void slab_set_obj_exts_in_object(struct slab *slab)
 }
 #endif
 
+/*
+ * A no-op function used to attach kprobe handlers in slub_kunit tests.
+ * The barrier is needed to prevent the compiler from optimizing out callsites.
+ */
+#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PROVE_LOCKING)
+static noinline void slab_attach_kprobe_locked(void)
+{
+	barrier();
+}
+#else
+static inline void slab_attach_kprobe_locked(void) { }
+#endif
+
+#define slab_lockdep_assert_held(lock) do {	\
+	lockdep_assert_held(lock);		\
+	slab_attach_kprobe_locked();	\
+} while (0)
+
 #ifdef CONFIG_SLUB_DEBUG
 
 /*
@@ -1662,7 +1680,7 @@ static void add_full(struct kmem_cache *s,
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_add(&slab->slab_list, &n->full);
 }
 
@@ -1671,7 +1689,7 @@ static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
 }
 
@@ -2884,7 +2902,7 @@ static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	sheaf = pcs->main;
@@ -3568,7 +3586,7 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
 static inline void add_partial(struct kmem_cache_node *n,
 				struct slab *slab, enum add_mode mode)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	__add_partial(n, slab, mode);
 }
 
@@ -3582,7 +3600,7 @@ static inline void clear_node_partial_state(struct kmem_cache_node *n,
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct slab *slab)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
 	clear_node_partial_state(n, slab);
 }
@@ -3598,7 +3616,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 {
 	void *object;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 
 #ifdef CONFIG_SLUB_DEBUG
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
@@ -4663,7 +4681,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct node_barn *barn;
 	bool allow_spin;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
@@ -5788,7 +5806,7 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5839,7 +5857,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {

-- 
2.53.0


