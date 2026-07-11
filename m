Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0FDFC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5AB6B0095; Sat, 11 Jul 2026 00:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A68F6B0096; Sat, 11 Jul 2026 00:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E7B6B0098; Sat, 11 Jul 2026 00:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD696B0095
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45C61C3D73
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:32 +0000 (UTC)
X-FDA: 84975247224.05.EB5BE37
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E52C120002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=VX6klacL;
	spf=pass (imf29.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gu1/GeFwQRCYl7cwa5Py8T4WqePQUyQJElSNNKRQt2U=;
	b=Jd5hxnhwlvXfRGqlGiQ4LMa0eTIDhwpoFfNLUAzEayHm/lOTyol0PF44Bc64OQTS7fyMCt
	ilRhr+Oc/JLjK902zIBqYmn4/06I12sTWakU9UIgPzB4T73gE5ObtoxBeYzIjeULycbtf0
	ci5uBvovWK3Tbv8WWOFy0vntNY9s3PQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744891;
	b=zyKzzg/+rw9LFSFWe9/h8pq3B6uG+tMAUHlfrOasXL7YymVeOSckJwVOnmYPeHyoBlEwhj
	L1W2qDqq2haWg+o46tCD7/tkSupaSRqC9MKpY7mOd6voLTviYGRb2+sijFRQS3vVIWlen8
	o51ak4F3Z1czdsVU8BqXbssx6i3njNY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=VX6klacL;
	spf=pass (imf29.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gxwyJ1tdCzMlFS;
	Sat, 11 Jul 2026 06:41:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gu1/GeFwQRCYl7cwa5Py8T4WqePQUyQJElSNNKRQt2U=;
	b=VX6klacLvGbraNVI0tsWnJLZ4Z7xEg0Tn9pY1gdHncVs4jXsgW9wvOZFd/RZvnSPLF2AIp
	LQ/dLfoa4gyQa/96mQvY+Y+qogB3zBhKlJPOAbwRZrh2mehLMDUFpUimdprjJXK4+m1rWs
	mdhTYOKZQ2QKw45NErA97e2UnWA0DTsK3GbZ96V0hjJ2EU6K+Ww+JAcCejJFhJzYF9+NRb
	G0HtLdTwxmnqSol6GpF+8nImSCDwJhbalio5DZzXsCpgvBUiFRxZqEiDd53cojfm564ybg
	Hjs4jB/v610TbOsLdFpyUwmR/8J55l0eJlfCxH77pQlesIUEvWVEa3bhOI0Y5A==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 11 Jul 2026 12:40:22 +0800
Subject: [PATCH v3 4/5] kunit: add test for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-refcount-final-put-trace-v3-4-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
In-Reply-To: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5255; i=m@mavick.dev;
 h=from:subject:message-id; bh=Ley3/Ev0Q2dr2jIjm9hqbGpVu2QNbexoD9klE+g+ihI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ23LzK0+r1K90OyeKclYb566l3tPX09W++Rwll225
 woFDid1lLIwiHExyIopstRkJbhnrJyVaHx0Ug/MHFYmkCEMXJwCMJGwXEaGDfEX3BawGGj8eBP4
 lMG29MP9ythbz1blvNjKwrKYtcOFkZFh4pInC6ceuWIdc2R5uEex6eXVhw4aPbsleEarw13oj+x
 JZgA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E52C120002
X-Stat-Signature: nf6fgxgezp7isb5czxqdze1abjwupzou
X-HE-Tag: 1783744890-130237
X-HE-Meta: U2FsdGVkX19NzhTqd63dqGN9KvhquArkreTrCK9j5N33rVuceBpSxe/4muQZLf5JD/mMMnMB79U2QJ9PpTigOVJI64g3Jv7OpCH3V4d2m9BUjsc7vM65JMAwAwCcUDLIDK5osaFdvcLvNj+cSfK749bd0I8YNfqDD8sWj40/KnoeKiiptpkxijDuT19atXdorEUnRdtSbHWnPt/t9PKj1EzdJuFzFsKwIXDnqTDSXhd9mAQDKOSqGoXPET5EylsmJpB3XpxMK+lDDGXC30GzQava+JN9KPStWRBrgZelkoXoXa6Fp6dlzn2MXzdYOiWA/5o+s60k3Kcff833TPwYRUfTZrajmj6oz3J5sXo4UKs9CaYvEvAw3b4Nhqo7B3KZOSyyT7b+G2ZozkiMGDxkwE33Uafzo8TWF33q9Al2ljrSXzom5fP7sGJaVdi3jqiMaePvEBPvRBg/wvA1vTnENhb4FcIWHVgkrKlcQdvZh05gCTHnEhQ8NEQNEhe/bJ3bsxoONrw9vyb1wBaPcwztfjRk4nXjjJl8QbEuoLN4qjKXuVTx0b1z07iVnjjo3vCRqjVbKB7y01wcTNOAXWTeZMlAO84FsaUQRUZ3f531oHKvUAdCwfoc24p328VKXqM8krArNooiRbKwC7mWW7Udu+9jZoi9hZ4i7MJu4RdMVAxqrdtVi40JexOC4ZQMBWTG8WC0G/wo621/7Qe0YUgKq/XCMaemHdpbEsEUTEloovbZlJohT3H84BDK8BEDGS0movCWR7M9sbnV8Kl4eEagshED4jmdu04ZgmT462EmMGfNdcIvq4nMFpWEGQ0/gqho5lJ2BSSfXRpGkV4zCx7GUXUA07yNkMLWbgrDZUt4ZTec8XvLNkdZMs2oO4sjvOCSX5KXqE6vYahva06+Iq8f7oEsSvROt9+vx7nm8Aig7qKdKxOfpYO4sUkAWQJztUuGjXiwX3pedtwCB+7tsvQ
 H9T7DGMT
 ZcpA60nmHY4zMRWrHyMTo9JJy/xJ/4u17AqAqhtxxsS5odzsqZF0a30BIKJFOUdS3UqptwfKfF/q1g8FZDvfvoO6XxjtVgunudUWcNqIyxlUXaz0Ri9GSzVqNbcOQkV1BybXm/xPTGXA0iqczDVBoJp/DCezoWMY+kOMNpydABjUhn6IJpj8nXrzJbKBd4gX+61mYCweyPtN+mJsdFTOaygsT5p+HZ0EhgsUqeoDRr/8pBBigao6UsirO41PDFWKh0vI2P3awX2gx2NZjbt0vnE1CPf+kyeBvG1BuCXtsPxGBcuoTwTn2oIt9IyGVroOihqKC0X/GocXyCzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a KUnit test suite for the ref_trace_final_put tracepoint.

The test registers a probe function and triggers both refcount_t and
percpu_ref final put paths, verifying that the tracepoint fires
correctly and that the recorded fields match expected values.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 lib/Kconfig                 |  10 ++++
 lib/tests/Makefile          |   1 +
 lib/tests/ref_trace_kunit.c | 141 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 00a9509636c1..7e2746be6d16 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -52,6 +52,16 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config REF_TRACE_KUNIT_TEST
+	bool "ref_trace kunit test" if !KUNIT_ALL_TESTS
+	depends on KUNIT && TRACEPOINTS
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the ref_trace_final_put
+	  tracepoint.
+
+	  If unsure, say N.
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
index 000000000000..8f896adc96d1
--- /dev/null
+++ b/lib/tests/ref_trace_kunit.c
@@ -0,0 +1,141 @@
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
+		int notimeout = wait_var_event_timeout(				\
+			&capture.count,						\
+			atomic_read_acquire(&capture.count),			\
+			10							\
+		);								\
+										\
+		KUNIT_ASSERT_TRUE(test, notimeout);				\
+										\
+		unregister_trace_ref_trace_final_put(probe, NULL);		\
+		tracepoint_synchronize_unregister();				\
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
+static void test_refcount_sub_and_test(struct kunit *test)
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
+static void test_refcount_dec_if_one(struct kunit *test)
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
+static void test_percpu_ref_put_many(struct kunit *test)
+{
+	struct percpu_ref obj;
+
+	test_init();
+
+	KUNIT_ASSERT_FALSE(test, percpu_ref_init(&obj, dummy_release, 0, GFP_KERNEL));
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


