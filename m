Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DB9C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CF56B00EB; Wed, 29 Jul 2026 10:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514456B00ED; Wed, 29 Jul 2026 10:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452EF6B00EE; Wed, 29 Jul 2026 10:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB306B00EB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83554A1A7E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:48 +0000 (UTC)
X-FDA: 85041120696.12.03D0606
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E3CB7100005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XG3Ggfgb;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313306;
	b=VV+L7+GjJ9MxiATuOdcaVXGGiMrbVdUhLFamhHWlv5pwgUQUWPSx2D1WD/j0zd5HYzluWv
	Vn23KqogmGbXx9EUePjRP78/h06kX/4AKEeJFWzYpQ0cRBvg1qxjxj1Si/keX3BQaMMnqh
	FCca2GlsqSa7Cs/1JYzNIekbmUErzok=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XG3Ggfgb;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQgXQ3LLqCfSQ6+KzSoXpszX0uTxmBCepjeRS5yTims=;
	b=0hpwyi6YVKUC2d0jjU/UUbMBUCihVpX+9p8n3lF8HsqgCzyrgN2Mxxp6mg2Zbk/cKDtGh6
	2hltfGBAEskX8NubMmocs5OZj7tYhHzEGlgYdukxm27sx0yIrZXSwYHuh7fSCYzcxlME9s
	QLESneMUVKOATm88m4urz/MwOLwzTUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71D5F60A99;
	Wed, 29 Jul 2026 08:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057B01F00A3D;
	Wed, 29 Jul 2026 08:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313306;
	bh=bQgXQ3LLqCfSQ6+KzSoXpszX0uTxmBCepjeRS5yTims=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XG3GgfgbwN5JSIG+Ed5Pb4FlPiIFQ826L07JPsO6aBK/Sg+x/F3TWY9hbXHJ41/ru
	 Pbk6jkGViyZpKlf7aZ4NQMKjfkK3l3++D2P9BIyUN6xgIFIIigs1iZz76vS5/lHsnt
	 5knwB9IeIWZHAldZlXGazvhy9furSjIxQDxQ+fYw41UtVnnEJBCsEaL1KvLSEi64p6
	 Znj/ZhHdpncq0IViJyq9wv5j9xCk7vJlI32tcu8ofOVsw5ID4ATjidUs09loM9ERLW
	 u00VSO0zQe+1R+qBjYbF0rDQylGtYItM/nNBwYUPcICmSX0/Js0ErTLOTU6L4D39Lh
	 rhpNnEkcmfIXA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:16 +0900
Subject: [PATCH v5 8/8] slub_kunit: extend the test for kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-8-a28cdcda9673@kernel.org>
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
X-Stat-Signature: 4szu1f4o6ytyjc7kx9foiqzznhraht6u
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3CB7100005
X-Rspam-User: 
X-HE-Tag: 1785313306-323975
X-HE-Meta: U2FsdGVkX1/vpBbcscQUJWc7SpUZDwfKzUjU6HMiklL+UvrDuo6StIJ1dUvdHyiSui2TAetX563PUMa1pifLfO6t5PUswNIfyriG/P+ks3MpPIcFjJdzFQ/IJm0m7br56n/lL4rxgWN5wNvCoVfLMrChdbCYuiKnamjUvcGTQCREqUL5kO9IsyzLm3BGPwiqFIUq4t2SB1byu3UBBJoDs9JIv8YmrDcZ63/0xvE6KTqORg9KbEmjt7uObgOEKce0mbi3soECu7CzX6f6DnDy5iS9xqr2hSv8PJ5WQApHh/eovvWM24371G7+X521+cP77PYmnq2p//hahoZ4aobJoolC4gm+t1R5dCaYWiXY+xpwYUDW7p6UChzYxRol9+0ty00GOEKaWz5s1k5IWD0XWdL7WJFFIu/r0LOnPCPEQPmru8yF9YgCDvkho+Vjxi5zrArsidCDWU/VMQP5sGX06kv8Q1yf6t8wtSSHsiknrofo1gWyctwqgE+9kPTyqwbyAQ1WTFvqw+R3p6PVlG5cZGeUPdCiTTtnwiVVg5ky3Noog9epyh15HnyZZgRKz6jdCWq+MnVSOsvRUnDz6giqIK2M4OyzLxqLaNNeyPOYHE6P/rcL0REfdnsFGJQ7Kgbz3CTa0W188ZFBDHyNUvvOqbEZMax7fz3aDK+CqXrhoT8UQ8Blil7nHSpWgZ+Okv7LTE/TpSdO2Usge3YzfvdGQBQX7IL5OK8hDhA05UsRg25ssc+qUPUedTr8mpXNl1kAnGVic6NfsqqK/5nM6c+lpp6d/EM4+6u5YnNfH1vbj60hnSZI9ekZvuUj+GsXwUpNV27q0bMw9NmbBNUfc1El/6MwgEIgEPzdLxBpEbcfBf4cGYFCkZPGPYBlin0STyY4B3anMoGWu4UDeUjT5Y6qvujSNHe55RyDQ5Uw2zJDY8Jb6y/ecG6cFbMc6BsF+OMFjr1iF8OmcCi0ppCoXmI
 rs9bkr9u
 ahiPYVxyvYRCSKKw7l7+CgVur2Yf2r8Z6uVUflV/chZkkwaYuZroZkwTtp/ze6hQRX0oIAqPo/ESERJze3Ttd5+gv92jJNln9lOUwZlmsYgQx5VlXWjMJYjSYlxZp095Bd9QSFABohnZ+4fiH6o8M6XhKMLSHyndDgVkYpCUkATAT1TusADUB155qWw+CW0/t5Rh0JsZuX4eHkUeMD6GsY8uSwDFKcbbpSvzWh7V9Yh6fmw91QHVyZC4+nkgFm/YhfzHs/EMcjGq+SwEoiFNRVZ1DAl2CbEl7gbl3
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
 lib/tests/slub_kunit.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 8c2b9911471e..e3b63f0338d5 100644
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
@@ -311,15 +314,16 @@ struct test_nolock_context {
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
 
-			objects[j] = kmalloc(64, gfp);
+			objects[j] = kmalloc_obj(*objects[j], gfp);
 			if (!objects[j]) {
 				j--;
 				while (j >= 0)
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


