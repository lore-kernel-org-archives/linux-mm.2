Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47174C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FAD6B00AF; Mon, 20 Jul 2026 08:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8F76B00B1; Mon, 20 Jul 2026 08:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE026B00AF; Mon, 20 Jul 2026 08:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 048046B00AF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:46:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B36680155
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:18 +0000 (UTC)
X-FDA: 85009128036.03.1F00626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D63C6120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HDvhW/pe";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551576;
	b=WdD8Qie5/IdSZ4xwRX/wIajoLj41SBHZUZ8+Ysih+1MujFEUq66r+FOGlDDMN2+9uGEIw1
	ECenHIu6WgpID4XuvzoRTV0kj9R4PJqvy0ix3D7idwC7qPdcE/rIR1tKRoHCn4afBZw2//
	t9H9MMJcRPaLCzqi41uITBSNHsbgrXo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HDvhW/pe";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Mf6ICl8QV0PyvQov1wiSUifOBTOQefLFAPMuDN3x10=;
	b=IREylhwo4KuZP5pWZg436q9Y0aoAKC0l5eoLpG9l1njwAWAUiuE4Bm2kegwNQK6NAr8X3y
	MsyfZqXvy/pasmxfDCJ6k5JQCYy0owLxFskVbrcxmDm8uCv6i7BMlEcVaPaECe9aM7IhAp
	/7epsWlc96M5pk5dsWpxcGsIIL4CcA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B97243F6F;
	Mon, 20 Jul 2026 12:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BE51F00A3D;
	Mon, 20 Jul 2026 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551576;
	bh=8Mf6ICl8QV0PyvQov1wiSUifOBTOQefLFAPMuDN3x10=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HDvhW/peMepVeAoQL2dW+MaaHo1MGlQYb4TFy3R2tW14fKkWa7VZuh/s7cn77dzVq
	 sSUYzoDD0SiPfWqY6iHqc1QPDZJF4mfo7RDsW0xED6Ocm1iSrM006ijnC32MukKMJg
	 +M4A9DHP5vFdtw8YzVwC+FgASQzKKZ/7g8LmG1g7O925c6BlyXO/vrp/UVfT2tnXnB
	 f88Yo0i+2f8bKWy6EHEkO8A/eC2WpRLdVtXDEkY4qe1PwbwR5P2G2Y25t+7v1ZHSRf
	 BgXSa4nahdSdUJJPlQDjNhmC9dsQ5Q1yMC0NEV9C+gyKdIxG/GsiVQFZ1uaKW0ckTc
	 vj+VGSJbrqYpA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:37 +0900
Subject: [PATCH slab/for-next v4 8/8] slub_kunit: extend the test for
 kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-8-964e03c41a4e@kernel.org>
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
X-Stat-Signature: kg7td813ee1fq8ybqwgrewyf94jef7zt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D63C6120002
X-Rspam-User: 
X-HE-Tag: 1784551576-411326
X-HE-Meta: U2FsdGVkX1/XI+k+0A/H5temdTr1FA323c21xi4TqzpYL7t96pNmEUavtkh9m5S+nJ9/bIkCtLj+fVBV5b5r7NU5GPHj8t931xB4x4otjKCp3pNetdyp3MmCauCuZ794fzjeAGSmodtFA9nCSp7twAM1lBMpFyf3/9QFCl/D1J5BVizppMl1RsSFQh49Z5BxdJ5p5UEfYY8ynB5SZfwdtlSN+QIug2mMF2XtEj/mye+9LffU1bPDuO5S/9TCuI8ICxJmiExwq0ZOcpO8JiN3r8sDOLVNpsH96CQeQuIj/p24fHcWPNdOLPhr6vNP9FhTRDxP0AtYG8y8TpjVFZi9GbB4poPPPIay5KP80Koq9I2EkbJImMpp3yxRQfO0x6iQXU8Sk9ou2s0oiZfoyZ/o48adwcyfg562JCpt9aWriY6X46KC86Gc3BsWpOemWeohgVfWTtpHu+6cH8hYylwuj2mrlSWwFckcy0ivQJhXMywXaWpAX3DDVKANbW5R15jtgzkdWH1GpqZiK+tkxIZGZ2F0rOKPJYqQ2HXrZlAsRLWZW9WSB4dMBL435VAJLWaD3GzYqUjRfUII/wwdS73CaW8jrBUoiseVI1IH49i/nQO/wgkgM61KbfCAt3YbFpi0l6vegm1lsEKTlejHAbVHuLIReksePcPDcgSOZzayFROqmkn5Iqio7v3sP8eEttuckhRHPeVO1erCEqIa9pAYPs9wnuj7S/noALjCBfFCKV49TdB4cNjRRudGxK1dVR75BZk8hXZwlUZ1h7IWhWjGwoZTX5UyS+0oIDvLuuFAv8neapty/taz5yKDpC9pL4zVKeyoEqqTA5DwQe3sJum23MyA/dDmB7r2VbipGXooDsX3REJilQG9T3UkhV4mREVxRbTR1gEaGzijCNazx50BrFslFJbESlenro2+/ApoC+DH4N/wYSKz1JthW85BhlZfej5ybH93YLRdTYg0/43
 kBUmicQT
 9/5XTQktZDGH3LBqI18hF04tR5+TUxPC+gD9bS5I6XnW2Z9mHxZHq/dDPB/Z1IW7ihWmmn8NfC7XUCJFdTlPE8zCVuwU8HxgxhKO4czxtUBFL4cH7vHqFua0y10JBjPa9ZcNMqkm6iW5fY4PUcsfyRVEYGIU1cnS6vjoVA+1ZgwoQZkfq+uIuIOLi54D2v9O9DKg8QNEkT48Ha1osKf96zOPOKwecW5cTaZlXnCwVQXu8oes4pSSPLx/5lHqANLYg7m9hGyVDTuFDCaHeD2j83LXsDmW9J6Trm7yp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When slub_kunit is not built-in, call kfree_rcu() and kfree_rcu_nolock()
to test kfree_rcu_nolock() in slub_kunit.

Rename the test case as the test covers more _nolock() APIs.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index a391467c1aa6..e3b63f0338d5 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -162,7 +162,10 @@ static void test_kmalloc_redzone_access(struct kunit *test)
 }
 
 struct test_kfree_rcu_struct {
-	struct rcu_head rcu;
+	union {
+		struct rcu_head rcu;
+		struct kvfree_rcu_head kvrcu;
+	};
 };
 
 static void test_kfree_rcu(struct kunit *test)
@@ -296,7 +299,7 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
-static void *objects[NR_OBJECTS];
+static struct test_kfree_rcu_struct *objects[NR_OBJECTS];
 
 struct test_nolock_context {
 	struct kunit *test;
@@ -311,13 +314,14 @@ struct test_nolock_context {
 #endif
 };
 
-static void test_kmalloc_kfree(void)
+static void test_kmalloc_and_friends(void)
 {
 	int i, j;
+	bool can_use_kfree_rcu = !IS_BUILTIN(CONFIG_SLUB_KUNIT_TEST);
 
 	for (i = 0; i < NR_ITERATIONS; i++) {
 		for (j = 0; j < NR_OBJECTS; j++) {
-			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
+			gfp_t gfp = (i & 1) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
 
 			objects[j] = kmalloc_obj(*objects[j], gfp);
 			if (!objects[j]) {
@@ -328,26 +332,35 @@ static void test_kmalloc_kfree(void)
 			}
 		}
 
-		for (j = 0; j < NR_OBJECTS; j++)
-			kfree(objects[j]);
+		for (j = 0; j < NR_OBJECTS; j++) {
+			if (can_use_kfree_rcu && (i & 2))
+				kfree_rcu(objects[j], rcu);
+			else
+				kfree(objects[j]);
+		}
 	}
 }
 
 static void test_nolock(struct test_nolock_context *ctx)
 {
-	void *objp;
+	struct test_kfree_rcu_struct *objp;
 	gfp_t gfp;
+	bool can_use_kfree_rcu = !IS_BUILTIN(CONFIG_SLUB_KUNIT_TEST);
 
 	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
-	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
-	objp = kmalloc_nolock(64, gfp, NUMA_NO_NODE);
+	gfp = (ctx->callback_count & 1) ? 0 : __GFP_ACCOUNT;
+	objp = kmalloc_nolock(sizeof(*objp), gfp, NUMA_NO_NODE);
 
 	if (objp)
 		ctx->alloc_ok++;
 	else
 		ctx->alloc_fail++;
 
-	kfree_nolock(objp);
+	if (can_use_kfree_rcu && (ctx->callback_count & 2))
+		kfree_rcu_nolock(objp, kvrcu);
+	else
+		kfree_nolock(objp);
+
 	ctx->callback_count++;
 }
 #endif
@@ -397,14 +410,14 @@ static void disable_perf_events(struct test_nolock_context *ctx)
 	perf_event_release_kernel(ctx->event);
 }
 
-static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
+static void test_kmalloc_nolock_and_friends_perf(struct kunit *test)
 {
 	struct test_nolock_context ctx = { .test = test };
 
 	if (!enable_perf_events(&ctx))
 		kunit_skip(test, "Failed to enable perf event, skipping");
 
-	test_kmalloc_kfree();
+	test_kmalloc_and_friends();
 
 	disable_perf_events(&ctx);
 	KUNIT_EXPECT_EQ(test, 0, slab_errors);
@@ -438,14 +451,14 @@ static void unregister_slab_kprobes(struct test_nolock_context *ctx)
 	unregister_kprobe(&ctx->kprobe);
 }
 
-static void test_kmalloc_kfree_nolock_kprobe(struct kunit *test)
+static void test_kmalloc_nolock_and_friends_kprobe(struct kunit *test)
 {
 	struct test_nolock_context ctx = { .test = test };
 
 	if (!register_slab_kprobes(&ctx))
 		kunit_skip(test, "Failed to register kprobe, skipping");
 
-	test_kmalloc_kfree();
+	test_kmalloc_and_friends();
 
 	unregister_slab_kprobes(&ctx);
 	KUNIT_EXPECT_EQ(test, 0, slab_errors);
@@ -477,10 +490,10 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
 #ifdef CONFIG_PERF_EVENTS
-	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_perf),
+	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
 #if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
-	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock_kprobe),
+	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_kprobe),
 #endif
 	{}
 };

-- 
2.53.0


