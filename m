Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D9BC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0C86B0096; Sat,  1 Aug 2026 07:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879616B0098; Sat,  1 Aug 2026 07:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768316B0099; Sat,  1 Aug 2026 07:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0BA6B0096
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:01:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2CD01602BE
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:10 +0000 (UTC)
X-FDA: 85052408700.02.293FC02
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id F2BEA180018
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=xQS5CzkI;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf06.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785582069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTMRjFLThSMMc/w3StUWqu1LpTWLAsUOncWy0PHshAk=;
	b=fdWG0cfoV9Xo0q52vJdRF8bu2ROqAINPyLBAPIJ2hLdcgvSMlMaui1M015PuwrEV+Zv1vs
	+y8z0VgTnGTPyEYBGMXeJ/M1otx4epypyE4ReySJv9Ssudd3Ju+XUzNpJloW4+2rsQMH3H
	VWFcfKYvOp5/QqNaGeDSTo5tiitvbPs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=xQS5CzkI;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf06.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785582069;
	b=I4WyVbEvf8133qt0T/jZ5BQw5Uk+v+aaa7sAdi//VK/pXFP8/nAfxU+cMI4wfzWcG8YCHz
	1T/RR0myoey0qzwXd/f7+CYN27F8eE0k/axPi4WHxXxNd7cHHEuNSCTB3ZSCHuSWDP/jqD
	lSz40VGW/PR57JGMs7CpZkmJy238rsc=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hC0Nf70nBzMlGF;
	Sat, 01 Aug 2026 13:01:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785582067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jTMRjFLThSMMc/w3StUWqu1LpTWLAsUOncWy0PHshAk=;
	b=xQS5CzkIcPO109Cb+436Qqh/cxYj3inN1re6Kjq5Boj4l3I1jsOvvNNKHFxwTEa+mnx5YT
	x8s+MjZu0OWymu98RI9/82lzQcCq+5xcpxjoM2ziXjyF6FhkJm3vslJ/Mr9rBm1jxMMFPU
	HNfDwHkPmKwNzJbuXSzQeUPfgKjbDHpJwAQjzOPGqB125yBnQ8tJzMcSotAA5FcPRnveHW
	OiUDYFDo4YJIFn8+mfHqQu+E79pWcbroR1NktHv5qvX+TePUiUdc+DeZRB4PB+1v0Uycg6
	gp3BlzM4yye6JXSBRrlw7mUXCkB4wqZLmBCPZQBorRKi0smgiPiRAjT310k3xA==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 01 Aug 2026 18:59:44 +0800
Subject: [PATCH v4 4/5] kunit: add test for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260801-refcount-final-put-trace-v4-4-2e58678f0ffd@mavick.dev>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
In-Reply-To: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5222; i=m@mavick.dev;
 h=from:subject:message-id; bh=eH7MOUuGodxq09rRikBFhUdpvaOczF07qkwIpXsPdnM=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm5Fzd2a7LeeL66USZ99ZaZBwMjjzFOvK/B4bGnofX9+
 Wb+hIspHaUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAExk7TSG36yLF5nvyLvHoHNv
 nZQ0wzRDhdyY6Ih0u79mvhcnaO340cvwv1TgpVYAuwuPSIqFlf4WA7GDt81l+iRYLmrNPH3VJPo
 bHwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2BEA180018
X-Rspam-User: 
X-Stat-Signature: ncxkf9kyfsrmo3wunx3e439tphgbkojx
X-HE-Tag: 1785582068-275620
X-HE-Meta: U2FsdGVkX1/Y64qOg4KaKkYlrlGLFxbYHYb8+zNfIrzDIsfW3FzXqHwC2wHETfwpAijNe3GMtGUhUYSOXAsNh5EvcnRJby48/ufGIBjxFpV8Omoy9/JD+M5Bm3yUloWMBIY4TRbjuDRLiCHrHcqEc7hrykMeVpNSSzRjZSBhfCrAJjYRqenBX5iNSstKSTd/Cnv+HNUVvFJrTPMejHEC44l1SzH4UPeiRc9ktkZyUQiUC3fUN6iLZgd1BHOBaqsN1mbuyVZYwBr8qGr1Xd47mZiys1wvoI4nRZ3+DGoJ0fzkKBp/hNpgGru+0rW3iVaq2Jv8fQZ/tziGJEySPAnpCzHsvXOUHxHfJAYocCrNODVddCEcwSOE9RboD3QQEQrUjcsYG0Fl7v+LLuDpP9gTZ7b3wZ9axzTwBl1VP34DqICzUk79jt8cK7zRdvqVHt51WsZGJ0dR6dQRnLzcpFeC76WW2hlHE65hAPuy+5x71QaKZX21NoxHT54CzT/Y7c3/v5/kCPNVOJ8jEI3C1vQ4sHML0Hz3XxXNTBFs6fZFSwzmCtosWEXjCtN5sw7QfAuvjJp7UxNbEvCP1CuXu7Nnb4DOcq5UCGaos4+0ugk3Qev4P+s4YGdzqzuVidQWUcp9iOykVKvuKPUCLRmwN95NJfE2pyD30z0lvWD7MyXjhl7pyZ/QwTR9TVlOBJLchtF70BmChRpmeakX6w0g4QThxrdWQS+Ze5aRjTsf6nXs0+lqdm3cTAovc+iowL18BT7zms/x+ZJc1iFky+kJ9bn8iM2ifkBZUBBGJzwAyfmdx4ZjYa6jhS1J8wwxiAK9aRQOCdOq3Hy6fjz0f8jb0lTA1xOopkA9cj58j4bCvfdf6uDTOlnvlAxY0P95r2OpBKuZMAuwIlwkv5e6gVdonQdbLUxl5K/YN87aS/PrQmrETTDqgg0el25l3kQmJKTngxA571BLykvUSqKTK2Ou/DU
 U7EC4W2A
 VVqh4pNeMcX0VAEQuxiQrrEtj0071Pj8oOHf9s0pPBkWVCe4wc0Gcm5PbGA0Y3Azb+wJEimY7TIvARjaheFzdlCfRrlWka4PMqidVkjjB3ODBJcE7z5MCIG/a703c8To+iF2OEmbBgTTkjm09BDw4orjPLd2gmplQeAN8UvFvDJUHtFxwfD6eAUvUJd+UJa3P043WXY+T+xnCodn0OIDKFZ3GH0a+hT0SQ8et9IouQW4+tN0HxGSLBTw5r3Fi4eFCEqpSAcAIpUTDaGgt1K/zZ+sBzKjAa06+ra8EoCvqnYDNw4dCir05M3S32iNj0/niT/xcICFj/yoCcvM=
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
index 000000000000..17f6936ecc1a
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
+#include <linux/jiffies.h>
+#include <linux/percpu-refcount.h>
+#include <linux/refcount.h>
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <trace/events/ref_trace.h>
+
+struct data {
+	unsigned long caller;
+	unsigned long ip;
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
+#define test_exit()								\
+	do {									\
+		/* wait for probe completion */					\
+		int notimeout = wait_var_event_timeout(				\
+			&capture.count,						\
+			atomic_read_acquire(&capture.count),			\
+			msecs_to_jiffies(10000)					\
+		);								\
+										\
+		unregister_trace_ref_trace_final_put(probe, NULL);		\
+		tracepoint_synchronize_unregister();				\
+										\
+		KUNIT_ASSERT_TRUE(test, notimeout);				\
+										\
+		KUNIT_EXPECT_EQ(test, atomic_read_acquire(&capture.count), 1);	\
+										\
+		KUNIT_EXPECT_TRUE(test, __kernel_text_address(capture.caller));	\
+		KUNIT_EXPECT_TRUE(test, __kernel_text_address(capture.ip));	\
+										\
+		KUNIT_EXPECT_PTR_EQ(test, capture.obj, &obj);			\
+	} while (0)
+
+static void probe(
+	  void *ignore,
+	  unsigned long caller,
+	  unsigned long ip,
+	  const void *obj)
+{
+	//prevent non test func final_puts from changing captured values
+	if (chk_obj != obj)
+		return;
+
+	capture.caller = caller;
+	capture.ip = ip;
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
+	test_exit();
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
+	test_exit();
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
+	test_exit();
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


