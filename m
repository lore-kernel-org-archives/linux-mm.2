Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FB5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D496B0095; Fri, 10 Jul 2026 01:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC166B0096; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94576B0098; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90CE76B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A0F5A0358
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:20 +0000 (UTC)
X-FDA: 84971743920.10.6DA5D6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAFEEC0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l65Scuad;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661478;
	b=OOSCPXF51qSa0Mcuuu1uP1IMwHzg5YItLaC0j70gXeou1ZRNyDDGsyc9e0pTd541MvffVb
	Ozk6M2ztXjMgy3STEVn4wB2NR1L6bLVC+mt8ceGrzOXhd0OjS9DK1ttfXtQ7q5pLlTXsRi
	2yj7UGY0uB8S7TjIGwSK5Suay773Q7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l65Scuad;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661478;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1NZ1kFpqgty2czs0pmJvulJgVjk7bOc97fFjwsZ+ew=;
	b=hFe54W4XJj8Bmo9D1chnTaeA3DosisV7T8WtL/42YFCpPggYSDqaB0EtwSTUOus6oIetyo
	NrDIKTQrz5R7yx67DxWAaDhiHuTUkEmsgMXfZ44EUEjNrHtQboeWnHZ/BT8yNW6yRJe9WJ
	ZZmGsYQFqFFQ8nxFcFDFWikKKzKJlGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7216444FE4;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34CBCC2BCFB;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=hYItlIxI3TFxH56tjyUfH5lTleoN/4M0MjnyxZ2eCSw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=l65ScuadIrCDCzyddzFeUgvv1Sxf2QFAxdvh+6epe1m+3ntxxcipFUji0CHV7n13f
	 e2X7H0WyQSX+dI95L/fe1pz7Sk1k7gQfxtETgDN1xMoTyq1DPv6fTVJwWO/E6ZND4G
	 c/Of4WSTzT0ASWATk1kCH+EFISLrG3ZQt7J5XV6ROdSxDTLHSAxldCsLKix70ePI3n
	 qRZgRVflHgR1HpWq5JW6T3HjdcWpTydbZAP/ZDJbFV4/IaRWsAcreUFzhYv51uDSqK
	 2KceLTGKkQU31pb/edjGPJPbkrdL+Rlpo6zbvjZg/pFvRUfOtsJxIwCizfF4V4UcwB
	 s7xMK6KVmo8fA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20261C44509;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Fri, 10 Jul 2026 13:30:42 +0800
Subject: [PATCH v2 4/5] kunit: add test for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-refcount-final-put-trace-v2-4-557cfce860a2@mavick.dev>
References: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
In-Reply-To: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5506; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=/9Dev+Y5OluuMZTbdCo5lc9tYCtS2UAK0B+nMvLxkRA=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT3XlnTrxwqYtC050Bi7wWrFRla/teG+d+LXfH/vu
 Dqtwzezo5SFQYyLQVZMkaUmK8E9Y+WsROOjk3pg5rAygQxh4OIUgInkyzH80137etGuGXom334l
 7cxMMWp0jt3csPWciFXil8ULhTO3iTEyvLTfz7vtbLpA+bapb3MeeP01j1aqVvzZeJ4t8WJ0Ue4
 HfgA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspamd-Queue-Id: EAFEEC0006
X-Rspam-User: 
X-Stat-Signature: tz1tjcb8xoc1cs7o1usd6bxucnxiq8b4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783661477-775585
X-HE-Meta: U2FsdGVkX19R460hyyppR7UUMQUzWmiPiEAAjMZcyxq0BhmOn6qr2N4UM3ZLLXbfBUYGwpfICZ/fB3pLFnATpPjSVefOlBKZ3D/OZA9DylIqD7aPZ+KiVxPfhX1JDrjpvYQADvzIOXN7bEnrComb6vY3lfVSe4OLVKYTPUZyBAV1T0AYb2kwO94WP6pcEYJNl271Msc03uujcj0MdUz14RV4CMUZax4uxhL014lJf/PAuaDw6QkFwk3CBa9wFGU76PM8dyuLniU7Yhj/VAmJtZ6T7uRDwylEufCHfXKoHtii5Z4ILUwuvkcHNSFgrSms6kwIg0P6iivefWAj5fTbwrpHNrLwlSPnDzmSXbJ9fO6U2KdcnOEk7n3S80FuMpk/tuAr7InbEcjvLCBa4ZRQoDxpN3tA8XkYqOCpdELj1mfE7nZmvOni8TF5XLL0ZRisxx8vndePOw2OuBt6oXxAaZ0MFtcjTeaYmQ9SdszgckTv5n+X47OukNOGspj29FtAVA/XjvAyq5GCBVjDSUt3TZz6e0QNVxpMGP6UwE6KEtkCQsg6ipKcdM4oTA8LahUkBqYWwX6qziYLy8CDfkFqcUKA3Dn6PHXXBu9juYmqfJMRdxX1lRO/7vxtWpuVKybEsWEwNt5ArZ5aXUAjQv02wSDfaS+5d5mDV43FZtGc26wSwj4+RKtqtgIBmRaai2qEMaXzX8Ij+88BtVLMzH73t5uOroz56zXyjySejQsIzpSRniXputCXOK6CDxz0m2FSnvjD5uAYuIEGrtxFh4BCIcsF4kEddCvOyTMIqLdTQKrymVfzlcRPwNJGjp22Exwv3JUlrZr2zHq+oTSiqfScYR1u2bwvMqLQniSalOTdliYe0IZixa8LgfHSlQWvwAEFAvK4+cj09ynij5VdiV4DgEBxHcA5Nx3YYf5zMxgxYrb9jeV7kI5plESsJ0MGkgiW0GtsdeSdthWf1VldYz1
 /zG8OBGl
 tZkcI17So/xadKq9b88gxpoj8WiaFWxa0QVVIM6/0hs6dqcRtlCp4BiNI5mwlgO+63p0Wqam7QVJtluodNeyE9ARFLDhI2BLALubzd3OrgNajbJ59I+NY5HSgpPYNVD1Xl3VZjBDszc2WB8pCEejZ5QGyGKpaFD3h35DwDs+OvJIjwF482EMMrogKLyDrHh86KB+MyVYFV/ekjX1Kif3ipGQMDnIKl+CBt1f4q6XA5Ketaf9HszfyR84CQoGCuuhMeJzX0BRFKFrdAwKHFpOVQOvGMT3n00RgnOPU/Nz5lE1QkeLcLlxw5tqxahGZ1YVP12pPHbVcqPGfCCsI0RmlPi0H4rabva6BTGi+J/I6S1mXYd+2HRZdMi9Fcal0B+34BKIow7f+Ri7fOhUoaD96TLqgdBXbvQgJIfUWfZNcn/5yN5cZBKmee2ttZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

Add a KUnit test suite for the ref_trace_final_put tracepoint.

The test registers a probe function and triggers both refcount_t and
percpu_ref final put paths, verifying that the tracepoint fires
correctly and that the recorded fields match expected values.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
v2:
-fix v1 bug where test gave consistent false pass
-make probe minimal, and only check obj and store the values
-add test_init macro to register and reset count
-move value checking to new test_exit macro
-move MAINTAINERS file entries to new MAINTAINERS commit
-v1:https://lore.kernel.org/all/20260705-refcount-final-put-trace-v1-4-cdd0014626a9@mavick.dev/
---
 lib/Kconfig                 |  10 ++++
 lib/tests/Makefile          |   1 +
 lib/tests/ref_trace_kunit.c | 136 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 00a9509636c1..c29b2ccb3c31 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -52,6 +52,16 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config REF_TRACE_KUNIT_TEST
+	bool "ref_trace kunit test" if !KUNIT_ALL_TESTS
+	depends on KUNIT && FTRACE
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the ref_trace_final_put
+	  tracepoint.
+
+	  If unsure, say N
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 7e9c2fa52e35..828a030ad8c7 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -57,5 +57,6 @@ obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
+obj-$(CONFIG_REF_TRACE_KUNIT_TEST) += ref_trace_kunit.o
 
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/ref_trace_kunit.c b/lib/tests/ref_trace_kunit.c
new file mode 100644
index 000000000000..5c7e9d29a030
--- /dev/null
+++ b/lib/tests/ref_trace_kunit.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <kunit/test.h>
+#include <linux/compiler_attributes.h>
+#include <linux/wait_bit.h>
+#include <linux/instruction_pointer.h>
+#include <linux/kallsyms.h>
+#include <linux/percpu-refcount.h>
+#include <linux/refcount.h>
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <trace/events/ref_trace.h>
+
+struct data {
+	unsigned long caller;
+	const char *fn;
+	const void *obj;
+	atomic_t count;
+};
+
+struct data capture;
+
+const void *chk_obj;
+
+#define test_init()								\
+	do {									\
+		KUNIT_EXPECT_FALSE(						\
+			test, register_trace_ref_trace_final_put(probe, NULL));	\
+										\
+		atomic_set_release(&capture.count, 0);				\
+										\
+		chk_obj = &obj;							\
+	} while (0)
+
+
+#define test_exit(func_name)							\
+	do {									\
+		/* wait for probe completion */					\
+		wait_var_event(							\
+			&capture.count,						\
+			atomic_read_acquire(&capture.count) != 0);		\
+										\
+		unregister_trace_ref_trace_final_put(probe, NULL);		\
+										\
+		KUNIT_EXPECT_EQ(test, atomic_read_acquire(&capture.count), 1);	\
+		/*								\
+		 * caller testing may be flaky					\
+		 * due to compile optimisations so omit				\
+		 */								\
+		KUNIT_EXPECT_STREQ(test, capture.fn, #func_name);		\
+		KUNIT_EXPECT_PTR_EQ(test, capture.obj, &obj);			\
+	} while (0)
+
+static void probe(
+	  void *ignore,
+	  unsigned long caller,
+	  const char *fn,
+	  const void *obj)
+{
+	//prevent non test func final_puts from changing captured values
+	if (chk_obj != obj)
+		return;
+
+	capture.caller = caller;	
+	capture.fn = fn;	
+	capture.obj = obj;	
+
+	atomic_inc_return_release(&capture.count); //increase count
+}
+
+static noinline void test_refcount_sub_and_test(struct kunit *test)
+{
+	refcount_t obj;
+
+	test_init();
+	refcount_set(&obj, 2);
+
+	KUNIT_EXPECT_FALSE(test, refcount_dec_and_test(&obj));
+	KUNIT_EXPECT_TRUE(test, refcount_dec_and_test(&obj));
+
+	test_exit(__refcount_sub_and_test);
+}
+
+static __always_inline void test_refcount_dec_if_one(struct kunit *test)
+{
+	refcount_t obj;
+
+	test_init();
+	refcount_set(&obj, 2);
+
+	KUNIT_EXPECT_FALSE(test, refcount_dec_and_test(&obj));
+	KUNIT_EXPECT_TRUE(test, refcount_dec_if_one(&obj));
+
+	test_exit(refcount_dec_if_one);
+}
+static void dummy_release(struct percpu_ref *ref) {}
+
+static noinline void test_percpu_ref_put_many(struct kunit *test)
+{
+	struct percpu_ref obj;
+
+	test_init();
+
+	KUNIT_EXPECT_FALSE(test, percpu_ref_init(&obj, dummy_release, 0, GFP_KERNEL));
+
+	percpu_ref_get(&obj);
+	percpu_ref_get(&obj);
+
+	percpu_ref_put(&obj);
+	percpu_ref_put(&obj);
+
+	percpu_ref_switch_to_atomic_sync(&obj);
+
+	percpu_ref_put(&obj);
+
+	test_exit(percpu_ref_put_many);
+	percpu_ref_exit(&obj);
+}
+
+static struct kunit_case __refdata ref_trace_test_cases[] = {
+	KUNIT_CASE(test_refcount_sub_and_test),
+	KUNIT_CASE(test_refcount_dec_if_one),
+	KUNIT_CASE(test_percpu_ref_put_many),
+	{}
+};
+
+static struct kunit_suite ref_trace_test_suite = {
+	.name = "ref-trace",
+	.test_cases = ref_trace_test_cases
+};
+
+kunit_test_suites(&ref_trace_test_suite);
+
+MODULE_AUTHOR("Eugene Mavick <m@mavick.dev>");
+MODULE_DESCRIPTION("KUnit test for ref_trace");
+MODULE_LICENSE("GPL");

-- 
2.51.2



