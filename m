Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E8EEF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3296B0092; Mon,  6 Apr 2026 05:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55096B0093; Mon,  6 Apr 2026 05:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF76B6B0095; Mon,  6 Apr 2026 05:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE4566B0092
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:09:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9086E16039E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:17 +0000 (UTC)
X-FDA: 84627557154.06.C8EB6BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D1C4410000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UftitZ1R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775466556; a=rsa-sha256;
	cv=none;
	b=Ql47WX0aXdJk+tWiwcVuWaZ3BcbOymW2u90fMUVudAM14AFNhlGf5xNm391HYH4VTBRO1T
	8x8ajqiXUeI1Rty53WU4Lb0WBqXRLzPNPgECgoDQFUkiBIqWm5rKusGxO6yAXM+Z8YJr8E
	W2q4xDQWLwPm+qa5cwN9BsBGWrcbKuA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UftitZ1R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775466556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9ovt/ZDquhAJa2x9016L1imB8FrjN/G6n9PkbMP+2o=;
	b=ZXHIZyEfSfuKxgPkIyF1+sYW/xc/4uiRvq8fzENHliTFS48za1v+aju9A/huS1lRHxLB+B
	ivfC/9KhH+Q6k7FQesnJInJp7LndWtyt37ALqQ5UeOtYe44xKuWn1jtuckHUO1udlQS7Jd
	7KO6m/8MeSv6ttB8jkoGNr6kYTHGmh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 067F144560;
	Mon,  6 Apr 2026 09:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB5BC2BCB0;
	Mon,  6 Apr 2026 09:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775466554;
	bh=+68CRKEHG6u9hyAJFuc4nQLarNYDPrsDi1eLDIKNsuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UftitZ1R+MbUtt7YHFOlyqSgkadiccGJBtvvAWSc+yh9VoDNaWjExtLtlq/8txg13
	 h04D0mP1XHvGngk9G3KfEtVZ+HrXa7eF68hEsazic/bjqGv4Cn0BhHozChIki+huQa
	 tjfhJjrFDDECkJ541aLXY4GnJEdf5WK1kZJSR8oGWwCjvuWfN2+unzeHgIXjVeFf/4
	 gR8xRsQDZLdcW3RwTMiutZ2nNVf30lxuNJGejAKl2698EvTnoA4xYaJYMNJA9T/NCq
	 d+rUaG5sRHuhoWu49JYvOrxwUPoFA8mFuTkbOSQHw7KifR8rjEQBo7uakK0aEaS+Ah
	 lWVSViuop6dHA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 2/2] lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock
Date: Mon,  6 Apr 2026 18:09:07 +0900
Message-ID: <20260406090907.11710-3-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260406090907.11710-1-harry@kernel.org>
References: <20260406090907.11710-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4n3etg9tdn8j4x7q8k5geuhh3gddc1m7
X-Rspamd-Queue-Id: D1C4410000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775466555-334445
X-HE-Meta: U2FsdGVkX19HY+ZrddcExJBUUGY7nNKJTt+73UAeDiHVLBhWNb5NDYW+9B0t31LC9HoIt6pOwa506Dt2qZlBtzhQjGa4hvgiMn9rPWDAE+gCtcRQiIsws/EB7SsCXpQMV58scJ9FKjcCfcwTMrIjbXmBaXFIbqpEvL5Ek7Q7LkCUZLmprymGct4MzXWb85+4CYqKMWHrqim8fk7OYSwDuhdroX0AUI3QFF2VjWMpXnuR5Ti9evTLBTsz+Qgw2v0G5TRGKIRa3bGAAoOzmQRLGdO2zZH7s73ljExzhwrrr8zW3PSDrLKcgKfzqM0cnVu5JaMOSpNmKNTYFd30s0aqG/3gu1PlmNVldPrLxx+DwuT+cklAZg4+fIxsKq/cqxXS3FzH1cl3/Z0NOKtvzN4mE3RtA1KwDnlx9FNzWh1tYknsARTQ6feaplh2g8/KsJpBebctpz6aI7yl0lb0eyy48sihsCJIeyAdUXuUGPkck3dTFmz6GqhPgBV8YfaUzR7vX0amUFF/v7oi89fSU0UxC6whzVFqrctnPJRDydtc/tiz/w7+q4H50gG7So725WuTJW35bXIa2EvrLMcvR8txCedmpPpbTTtjGf28u+d6L3WzKx0q6UFCFe24sfQUO9pPE7KTve363xUsHkiNdEGshge+n1HZ+Rcmyi7bXCgMGTKsSINg3Fy3nwo6b+FlJnF4Ek3mTk2da2nJtV06btu71npZUO6U3/ajCHNHmYw9R/5BJ1iZyS0zROws9nm6DTWfM09ioIakea7XL1CbDshp4dLVf/hjL/oWT3h2dQxlJljsmA5SVZcnW2zdYQ5gIKQ2Ime16VaCRKisJi6XRBc4KpfVx2cEE+nL+s8T2x2x6SLmG82Vb7wPsKRQ5CllFzMUaB8BHlnpIf/feHh1XD8f7y6rPnJd5vyC3bQxoMlINRT+77oo2UvP9XXiqpH6n7wvwMifvjz7L66MWttqWro
 lozG0oHP
 OI/YzUnOt5/oX5J5PTNGcFujbEY6EOFfkk3TZeiM/UtSwQpT3zmsGUFCFa6ZrRGhIiSIUrDFdJvS9ItjUnqnk9aWIpn+DG7y1a917FP1yBq7whLYzpf5zIMdvUNYS/bak1ZBC46h+Qad3W0FXkPbZoukJtdxP/YVuViGLV0izs6+9jqOvRLW0z1WbJTbRBlIjKJWA8MdLBK6gJdbCbHKL+mRWdyZKvW4MUsXBQxPx16W9GQsKKBylIi23VW4gXQMfYjD05peKtXYst49OqGD0UFSj229vpn08L1PSctqB6siKDdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
kfree() is tricky, and it is even harder to ensure that slowpaths are
properly tested. Lack of such testing has led to late discovery of
the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
!allow_spin").

Add a slub_kunit test that allocates and frees objects in a tight loop
while a perf event triggers interrupts (NMI or hardirq depending on
the arch) on the same task, invoking {kmalloc,kfree}_nolock() from the
overflow handler.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 92 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 848b682a2d70..fa6d31dbca16 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
+#include <linux/perf_event.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -291,6 +292,94 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+#ifdef CONFIG_PERF_EVENTS
+#define NR_ITERATIONS 1000
+#define NR_OBJECTS 1000
+static void *objects[NR_OBJECTS];
+
+struct test_nolock_context {
+	struct kunit *test;
+	int callback_count;
+	int alloc_ok;
+	int alloc_fail;
+	struct perf_event *event;
+};
+
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
+static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
+						       struct perf_sample_data *data,
+						       struct pt_regs *regs)
+{
+	void *objp;
+	gfp_t gfp;
+	struct test_nolock_context *ctx = event->overflow_handler_context;
+
+	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
+	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
+	objp = kmalloc_nolock(64, gfp, NUMA_NO_NODE);
+
+	if (objp)
+		ctx->alloc_ok++;
+	else
+		ctx->alloc_fail++;
+
+	kfree_nolock(objp);
+	ctx->callback_count++;
+}
+
+static void test_kmalloc_kfree_nolock(struct kunit *test)
+{
+	int i, j;
+	struct test_nolock_context ctx = { .test = test };
+	struct perf_event *event;
+	bool alloc_fail = false;
+
+	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
+						 overflow_handler_test_kmalloc_kfree_nolock,
+						 &ctx);
+	if (IS_ERR(event))
+		kunit_skip(test, "Failed to create perf event");
+	ctx.event = event;
+	perf_event_enable(ctx.event);
+	for (i = 0; i < NR_ITERATIONS; i++) {
+		for (j = 0; j < NR_OBJECTS; j++) {
+			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
+
+			objects[j] = kmalloc(64, gfp);
+			if (!objects[j]) {
+				j--;
+				while (j >= 0)
+					kfree(objects[j--]);
+				alloc_fail = true;
+				goto cleanup;
+			}
+		}
+		for (j = 0; j < NR_OBJECTS; j++)
+			kfree(objects[j]);
+	}
+
+cleanup:
+	perf_event_disable(ctx.event);
+	perf_event_release_kernel(ctx.event);
+
+	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
+		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
+
+	if (alloc_fail)
+		kunit_skip(test, "Allocation failed");
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+}
+#endif
+
 static int test_init(struct kunit *test)
 {
 	slab_errors = 0;
@@ -315,6 +404,9 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+#ifdef CONFIG_PERF_EVENTS
+	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
+#endif
 	{}
 };
 
-- 
2.43.0


