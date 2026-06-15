Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A90CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B416B0092; Mon, 15 Jun 2026 07:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CEB6B0093; Mon, 15 Jun 2026 07:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C2A6B0095; Mon, 15 Jun 2026 07:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 520E16B0092
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:06:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E690092F5E
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:37 +0000 (UTC)
X-FDA: 84881868834.22.CD3F27E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24C71140004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTzUu+6l;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcAg6p8uPFXDZsEK18Yc6WgpUSfGRhbKOaoMj5tkMkU=;
	b=m6VQpHWDAXoLE7srwaEmx+Mvl29atljXdcyvL5b4nXD4C8Kex/BimwWec8KM+PqcSJ6GmK
	scvw0VC+ISrniESujJ9+PTmmQDfVUj7xO+97sqyBMQn65KPsg3xBUanMYNhurfmRIj7tcp
	ZnAcOTwlydWDTtJ4z6F589WNFMkjhVU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTzUu+6l;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521596;
	b=elU9bChVTAuNcl6FPlpSDt3NtN9MFSp0QzpC2AguMnuTHiFB7hy+Djr/eeSXg2sx2ECmu2
	uC/FyEibtBcd4GXBdd8uL12es3M16vt5bljzcCxyYlzlWmqJstJVdgEqyXiCcmG+1wFa7F
	Tos63aOrmHEmY+H0WGHPehAUi/7t40s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E83E418E1;
	Mon, 15 Jun 2026 11:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DBC1F000E9;
	Mon, 15 Jun 2026 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521595;
	bh=RcAg6p8uPFXDZsEK18Yc6WgpUSfGRhbKOaoMj5tkMkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eTzUu+6lX/AL6Bep4Xs8pOL7/YPmDO8dFu4iC0orItAJncn+htYYzx+VLgsDiJVmz
	 e68bAsZs/BUNfc/kD0aSFIlTchM2O+FCtfgkl0H77UWDHDzMVDKAEgnuFXBf+71Mqm
	 X5SVx8SYrW4TX0wbgDBe19jseLOJi/w2jS1K6mDVui77I8OTpaNZRtjJQiI5oF9l7p
	 kPVmtkzG2YCUK8dCftoJ2D0pnk1fhlD/XHGpFWqg0MkgsMWqz9bvztU+NxfX+DsHwO
	 DV7z+NosVKk/t03e3VRVLDT1pJ5yDqgQ/3zTsDuA6M0LZLscleJzotgBjScrbs43Jg
	 TVoI2Q9wYQVBQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:05:56 +0900
Subject: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24C71140004
X-Stat-Signature: ymxg6f79jkhwcgz195wkfxjpxj7xobnc
X-Rspam-User: 
X-HE-Tag: 1781521595-579851
X-HE-Meta: U2FsdGVkX1+RsMR5Urc5TJJR1gI5OS2T9iIvqxgc4kYrVR+mrzPM8DlM+J0E6CRXU8mKLU/kvseS5PCX3Gj+FXsI+9pmkQSyLiOSlhJ85+3S3RLOADMrf5plEOuJQyVczmMwEe8MrysCeO5Mw23pZxv3a870MSu/w+NdCXSF5PpWnPPwHvrAerPB/ZN2n02YhGwTwcmNjazDtVCGVy8uii/OG+R1udurnS4/en5TLF79uC7Y271W/8swIpDHw+/47Y+Rm/wDRp565P5wu+hstaaCo/t485VUpTWCukC7EaOkNWU4HvFP0HFR5e5psnzjDva2DvF38Od2QNZqwR3+igWLjvoXzKMRIB5UnAIICnBWzmDcMNWNiWgIV+r3tBCAcokw7MjVK/mPImQkRm4OQ7jUEE0pXBc8eQD3ZTYGFqZe32QNG3r6diNYBLAUEMU4MHyJq70Gyf2zLvO57EL+exfFysCfIySemTL3wOUhuhw75GhHiM5+XaTLAy6L/rKWRzTIU3UeSRjnV48BfVcL0tQY+duBNXeQlUK/g0QeWP30sB2cCkOjppp7ijRbvnc4P23M0q+RtlElwGIb7bRW6Klwwz7Kz2mamj6CIgn9vM75llZbf5m/MbJnyoK2J73j0+cw/jUumjTVKoYgANlYZ/IAivuJe7thN3d4TEOpUsmTKMGPjr7iBcHRoi7b62pyPgQsnSNsW4GQZ9V5021dCjaBZhCr0h5ryKPgDtHhRPT9nKMtdJ4FAZpK7LQ5WZFzUCNLdw7HgqycKTqpAyChK5qgE4+1kNqNzI2sVzRXQDe0a6b/z92e7WFAJVxIuRdUD+AJ57tzm9/2Kv3B7decTmRuXQeYLLFnf4uZqt64dyfBTKxu1qHayMnkk2aeYB8FdeiuDXy2Tz5idfksa5+IRvckgRI6qVtgyB/YPx9rDF8uDO5m9J/nqzW+tXjDzCSPRhbL7DXZ0XnxEZIu1Vn
 Z+PDwBMB
 U+jMze/sDx3ZWgQMmEtsj3lzrXjqdNUpGkyibk36y14rXMB1UJdaa1KeuA8Y/JoHvYo6tjUHhDZabNGwMMzYYTp61qPuimEYvsMKJW1En4ihXBAZ/pZQEgzQ170qMlbJaxLih5aErTvowBWh+v0gasK3PZqikmLKcO9mW6fkNZCxdSqiyZU4kITfAXI+rQvEuQK+OmZerbXlAWCZnQQbcjEIjpyYMYbnSEvQuo9MdsAPWbhQOvqgKSgOLwDMCUNeD6IiPAkBmDWxsJkD5S9MJWUrxZNgzfn1hOIm0
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
register the handler on UP kernels [1].

To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
is held, add a wrapper function for lockdep_assert_held() that calls
a no-op function slab_attach_kprobe_locked() on debug builds. The
function is optimized away when neither CONFIG_PROVE_LOCKING nor
CONFIG_DEBUG_VM is selected and register_kprobe() fails.

The function calls barrier() to prevent the compiler from optimizing
away its callsites. Otherwise, the compiler may consider the function
does not have any side effect and remove callsites.

Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 82 +++++++++++++++++++++++++++++++++++++++++++-------
 mm/slub.c              | 36 ++++++++++++++++------
 2 files changed, 98 insertions(+), 20 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 11255fc8eb78..01d808cb77fa 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -8,6 +8,7 @@
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
 #include <linux/perf_event.h>
+#include <linux/kprobes.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -292,7 +293,8 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
-#ifdef CONFIG_PERF_EVENTS
+#if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
+#define SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
 static void *objects[NR_OBJECTS];
@@ -302,10 +304,16 @@ struct test_nolock_context {
 	int callback_count;
 	int alloc_ok;
 	int alloc_fail;
+#ifdef CONFIG_PERF_EVENTS
 	struct perf_event *event;
 	bool is_perf_type_hw;
+#endif
+#ifdef CONFIG_KPROBES
+	struct kprobe kprobe;
+#endif
 };
 
+#ifdef CONFIG_PERF_EVENTS
 static struct perf_event_attr hw_attr = {
 	.type = PERF_TYPE_HARDWARE,
 	.config = PERF_COUNT_HW_CPU_CYCLES,
@@ -326,13 +334,10 @@ static struct perf_event_attr sw_attr = {
 	.sample_freq = 100000,
 };
 
-static void overflow_handler_test_nolock(struct perf_event *event,
-					 struct perf_sample_data *data,
-					 struct pt_regs *regs)
+static void test_nolock(struct test_nolock_context *ctx)
 {
 	void *objp;
 	gfp_t gfp;
-	struct test_nolock_context *ctx = event->overflow_handler_context;
 
 	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
 	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
@@ -347,6 +352,15 @@ static void overflow_handler_test_nolock(struct perf_event *event,
 	ctx->callback_count++;
 }
 
+static void overflow_handler_test_nolock(struct perf_event *event,
+					 struct perf_sample_data *data,
+					 struct pt_regs *regs)
+{
+	struct test_nolock_context *ctx = event->overflow_handler_context;
+
+	test_nolock(ctx);
+}
+
 static bool enable_perf_events(struct test_nolock_context *ctx)
 {
 	struct perf_event *event;
@@ -382,17 +396,60 @@ static void disable_perf_events(struct test_nolock_context *ctx)
 	perf_event_disable(ctx->event);
 	perf_event_release_kernel(ctx->event);
 }
+#else
+static bool enable_perf_events(struct test_nolock_context *ctx) { return false; }
+static void disable_perf_events(struct test_nolock_context *ctx) { }
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
+#else
+static bool register_slab_kprobes(struct test_nolock_context *ctx) { return false; }
+static void unregister_slab_kprobes(struct test_nolock_context *ctx) { }
+#endif
 
 static void test_kmalloc_kfree_nolock(struct kunit *test)
 {
 	int i, j;
-	struct test_nolock_context ctx = { .test = test };
+	struct test_nolock_context perf_ctx = { .test = test };
+	struct test_nolock_context kprobe_ctx = { .test = test };
 	bool alloc_fail = false;
 	bool perf_events_enabled;
+	bool slab_kprobes_enabled;
 
-	perf_events_enabled = enable_perf_events(&ctx);
-	if (!perf_events_enabled)
-		kunit_skip(test, "Failed to create perf event");
+	perf_events_enabled = enable_perf_events(&perf_ctx);
+	slab_kprobes_enabled = register_slab_kprobes(&kprobe_ctx);
+
+	if (!perf_events_enabled && !slab_kprobes_enabled)
+		kunit_skip(test, "Failed to enable perf event and kprobe, skipping");
+	else if (!perf_events_enabled)
+		kunit_info(test, "Failed to create perf event");
+	if (!slab_kprobes_enabled)
+		kunit_info(test, "Failed to register kprobe pre-handler");
 
 	for (i = 0; i < NR_ITERATIONS; i++) {
 		for (j = 0; j < NR_OBJECTS; j++) {
@@ -412,7 +469,10 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 	}
 
 cleanup:
-	disable_perf_events(&ctx);
+	if (perf_events_enabled)
+		disable_perf_events(&perf_ctx);
+	if (slab_kprobes_enabled)
+		unregister_slab_kprobes(&kprobe_ctx);
 
 	if (alloc_fail)
 		kunit_skip(test, "Allocation failed");
@@ -444,7 +504,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
-#ifdef CONFIG_PERF_EVENTS
+#ifdef SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
 	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
 #endif
 	{}
diff --git a/mm/slub.c b/mm/slub.c
index 813fb863254d..87ca154ccd80 100644
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
 
@@ -2866,7 +2884,7 @@ static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	sheaf = pcs->main;
@@ -3545,7 +3563,7 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
 static inline void add_partial(struct kmem_cache_node *n,
 				struct slab *slab, enum add_mode mode)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	__add_partial(n, slab, mode);
 }
 
@@ -3559,7 +3577,7 @@ static inline void clear_node_partial_state(struct kmem_cache_node *n,
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct slab *slab)
 {
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
 	clear_node_partial_state(n, slab);
 }
@@ -3575,7 +3593,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 {
 	void *object;
 
-	lockdep_assert_held(&n->list_lock);
+	slab_lockdep_assert_held(&n->list_lock);
 
 #ifdef CONFIG_SLUB_DEBUG
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
@@ -4646,7 +4664,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct node_barn *barn;
 	bool allow_spin;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
@@ -5786,7 +5804,7 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5837,7 +5855,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	slab_lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {

-- 
2.53.0


