Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE4FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C68B6B009F; Mon, 20 Jul 2026 08:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776C16B00A0; Mon, 20 Jul 2026 08:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665DD6B00A1; Mon, 20 Jul 2026 08:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 330DF6B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:45:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6F4840174
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:35 +0000 (UTC)
X-FDA: 85009126230.20.33F99A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6161C0013
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6xQMojN;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLn2u9Hh8FCrQb3s4mbnvG4RbIr4QffGlO3KDcKz9h0=;
	b=B4IGW5h5kvF9N0NiOELd0dFfHTRO/E7PdRmiJtTmtTTUGBXOGxB8lttFpbmIx4c/ZQM1eY
	LZEYSw1+EU3MBE1hunnmF282G1EsM5z0/GWOsaPMjDlHvgACKfJdLflEPk+U1zMzAA9UAe
	Hf13iAuO4FTECk1fhfuQTB0C1BmOOZU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6xQMojN;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551534;
	b=Lu5AYmUT6nvlxY5kbe1w7iv/liKTP/hIJci7NgEF74jXkgs0ODR+NOHB04uoSBL7ei7+y9
	ZS1ZTE6Ln0Gm0qDMj9gULdp6YAr2RzeadrvOTUZFk4JiXPR2JU9SbyFp0Bnm6Wtrgi3iYn
	71GYm2JqdPv0nHkOFUVmZAI9ILiW5u0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4469543238;
	Mon, 20 Jul 2026 12:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865B11F00AC4;
	Mon, 20 Jul 2026 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551533;
	bh=nLn2u9Hh8FCrQb3s4mbnvG4RbIr4QffGlO3KDcKz9h0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M6xQMojN18hBukXlBKZ0LNGDGz4ICdaN1aqiI+JJOnzHvU1ThqI+NPQuEsyv3/PQ6
	 him/X3OlnRpbj9wH7jSFcPBm+28ZyRgVlO6o/UqtXKvbbVch+RUAE1Jcbpk6A8NrdK
	 4Y9mFxfHbbvxXliSDI45KOMBxCRdJx7c73+PKupFWHB3U3I5bzTN0NM1MVe510X1Jq
	 pBzkca8wcyJRni72Z9g+AyeIgnDfs3qUiH7CaeeZq0EzipXfgLdSvQHW5p++H3p9XY
	 sMfAZbU5reUrnQBl1LnZGtloY5xFwJ80MVqdeNeTjeJgSuTiYyFgTNRVxwjnIQVjT2
	 UrY0FyzE4k3ng==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:30 +0900
Subject: [PATCH slab/for-next v4 1/8] mm/slab, slub_kunit: register kprobe
 to trigger _nolock APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-1-964e03c41a4e@kernel.org>
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6161C0013
X-Stat-Signature: 4tywodapyu4bi3px5nsn9swcu9nnbiox
X-HE-Tag: 1784551533-223996
X-HE-Meta: U2FsdGVkX1/f1XBTiWDKEOtwn1H4FHaAr/1Se6hXK3voskH2O0oULHDVQB0TiZStE8OP2SyC/gLUKGxI5/eoHPIdgmFbhhIVP//TYp6Xd8n4H3ddWhL7bZ02mtv5rzzFc53CvsE0ZA3iU+VFbVMCo9GRn+iYnlzxf5fYusQdDlIjTSi0pggSYVCnmuYi4S/gEUGhVoeWVPiMoWZHBSSRWHNy6VtWKUX0oLQCEhl2iE11TFWQn7mqG1SeHQjzsCiBKLB9plKywzUF0wFKyfqUo+ltCzxRarKBX7nlJ2fH33DvlGJRImYodrWAO5swi3moLoccjNmHvCUzc/96XxXd7bf017hvt3tY3vWjMc+NsNx5PwNJdvRMmJ+cwl9WEphKbnUY4kcQfEZvD+yirrEkNGM/JvRPocwRvBJGbDadIBm3tfs2FfryC70ByKHfENh9PjqVHsuQvYVPWE70YVV8CsKsnivJvyN1QMAA/Fh4j1/C9lMn443eN7w/8m4YNZq2tgLYQv1vHjtiZzaLqNItonzQO23j0F30jUpwRNwSZ3uLU4yb+F4cJH2xw+rjUH0xKK680e8M6WFnzN/W5iB83Of2OIJsiY+C5+MpSojDV0P2JNVA+lYEBfJwQIZ714j5dRbRa0zmIMDeFQ0ji4mBkqtmUCgECnuBm4wxUuCje25aNztK9sptjCfIpNIoOfqGJo223+PL52hW59eZcBUQK1QORRQgsgt7zvc3/7dBlaAYmcFbt0w0p7mXPF9uQWq+J/W9O2LUvGXI7JYXz6Qpam2o9zIaIMuaH2Z1UQhvyMg4l+FoPkWkql39mW28hfMQJUaaCaY2Bu8H9lMdbn/RWUOjy2Ej+S1TISskQ56peyJ6Yrv0SPMrE76EZ8ymMD8IDTeX0NDpvC8VMMxOzGOrw/BxlO3LwRBqYXC8AG46EVX42eGRUGI70rGdxt0d6YkO6FdLotB9gXsdpIQYez2
 DqsmgZlr
 ha2ppH0JO7vD80MyQPIQ97PSmRPIoGmyQD86PH3hA3BYRchf/vzCVugjZQza1kR62LLPstLWl2tCQvwOnb41qBlwUI5duIS9GHJcFuaoo513bjvN1t9/y8WqmBdW77p2HLs9XLpqUwV/oE5EbHWRyKFcJ7RnNuOmOCsDyeptPINCc+zoj9t7Iswej1yi+x1jAKvLZX28CTtALDXi0BMbH89KLM4X87V3QzBYtpFNFjE9dtwmFWjskLwTbkF58VQl2KOjO7TaM+gLsoVPSq6G4m8Cm4lXdrUUeMl9QxkJ4o1Nm83s=
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
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 167 +++++++++++++++++++++++++++++++++++--------------
 mm/slub.c              |  36 ++++++++---
 2 files changed, 148 insertions(+), 55 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca16..a391467c1aa6 100644
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
 
-static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
-						       struct perf_sample_data *data,
-						       struct pt_regs *regs)
+			objects[j] = kmalloc_obj(*objects[j], gfp);
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
+
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
 
-static void test_kmalloc_kfree_nolock(struct kunit *test)
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
+
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
 
-cleanup:
-	perf_event_disable(ctx.event);
-	perf_event_release_kernel(ctx.event);
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
 
-	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
-		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
+	if (!enable_perf_events(&ctx))
+		kunit_skip(test, "Failed to enable perf event, skipping");
 
-	if (alloc_fail)
-		kunit_skip(test, "Allocation failed");
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
+
+	if (!register_slab_kprobes(&ctx))
+		kunit_skip(test, "Failed to register kprobe, skipping");
+
+	test_kmalloc_kfree();
+
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
index da9efb040040..e32a68677537 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -908,6 +908,24 @@ static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
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
@@ -1665,7 +1683,7 @@ static void add_full(struct kmem_cache *s,
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_add(&slab->slab_list, &n->full);
 }
 
@@ -1674,7 +1692,7 @@ static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
 }
 
@@ -2868,7 +2886,7 @@ static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	sheaf = pcs->main;
@@ -3547,7 +3565,7 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
 static inline void add_partial(struct kmem_cache_node *n,
 				struct slab *slab, enum add_mode mode)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	__add_partial(n, slab, mode);
 }
 
@@ -3561,7 +3579,7 @@ static inline void clear_node_partial_state(struct kmem_cache_node *n,
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct slab *slab)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
 	clear_node_partial_state(n, slab);
 }
@@ -3577,7 +3595,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 {
 	void *object;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 
 #ifdef CONFIG_SLUB_DEBUG
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
@@ -4642,7 +4660,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct node_barn *barn;
 	bool allow_spin;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
@@ -5765,7 +5783,7 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5816,7 +5834,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {

-- 
2.53.0


