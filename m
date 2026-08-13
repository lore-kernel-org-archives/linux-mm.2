Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8968BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0CF6B01B3; Wed, 12 Aug 2026 23:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359B56B01F0; Wed, 12 Aug 2026 23:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249A86B01F1; Wed, 12 Aug 2026 23:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB006B01B3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8779740588
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:59 +0000 (UTC)
X-FDA: 85094870238.07.8749FCA
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id D521340005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=TZnbSlZy;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf12.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erDbb09ucbowlxh+KqIe/GemWupH5L/Xw8pXiywX4aU=;
	b=V1L3rXGsb5KN/oTRZ8U9c4/oAG5WDjmQ5RIqSg9clBz0oh9E2r+6hghd1k1ecSYmWSUr33
	/ut7YsLWj9VOShiPxrlnzuCoJbNkmlT0peJUyMzuiKdeFdafCSe35WXBvLBHcwr9P7AKsP
	I9WkJj/ydR6FFFDHbqpQXds8qmHs31Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=TZnbSlZy;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf12.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593058;
	b=NGExlXbA0noBxmbVOLkeiBO/gmb91tLVCUfENnMKwWnik1PaQ7HH8MGeQIe3LwIAPM6ZmB
	2CNcUfx/83C1cftWFULF8Vb+U4Z1ts5LWdih0Hy3dMWPb6TuNH+QppCU6VakfhB9y+fwvJ
	QJVp7E/zjjoJohCUdMqIiwSo1dct3ro=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hLBGl3g1tzMlLg;
	Thu, 13 Aug 2026 05:50:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1786593055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=erDbb09ucbowlxh+KqIe/GemWupH5L/Xw8pXiywX4aU=;
	b=TZnbSlZy7HIOS8R8ZtKog7gJNViTtXeo/MPHBlX60HXcjV7GAOcyfS9aQKirBkB+91lkav
	wdg8opz1yyEhh/JtOpRDQmBbm+NBSWaJuG28GTwUs4XvNRgdhbqIPJloN4C3SlVw+JhNn0
	24/mx0S2n8BC1WP0cdH+gHy1928bZplm2D5JNkbTN9tj+sF+dNBTgUpRuYmSrPbdqsi5Eu
	/U/8fm8gKxM+HBFTrRWJ+VPYbtK5kIuFSW5BK87BsSHFIulOwHrZ6kA6FT80W4zKKjzwMJ
	DIpfWfWW4njO4lEnCKCriDtWE4qN5h5WwV15W5eESREiXbAwdWHY+FekY7Ax/Q==
From: Eugene Mavick <m@mavick.dev>
Date: Thu, 13 Aug 2026 11:49:10 +0800
Subject: [PATCH v5 4/5] kunit: add test for refcount_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-refcount-final-put-trace-v5-4-6e8bf8a38b31@mavick.dev>
References: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
In-Reply-To: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kasan-dev@googlegroups.com, 
 Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5310; i=m@mavick.dev;
 h=from:subject:message-id; bh=NWF4Jo4Ftrstc2NjsEJ9G79wJ3MSn8vYx7m8NL0MlZU=;
 b=kA0DAAoWnR/Kftt9NE8ByyZiAGp9PsHI80dHxtCLyQgRi2utuXrj/DrJAEEYHmKk0Ar8vJSYD
 oh1BAAWCgAdFiEEfGpgR2ipmmEzxZKMnR/Kftt9NE8FAmp9PsEACgkQnR/Kftt9NE8TpAD/TJ6T
 /Xft03kCAMYvjSLws92XtG6nUkPg2Ko2+XTnBc4A/ikVItApitgXnzGR+92IsQG0l48gW0o+Jdy
 x9AXn1jMB
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Queue-Id: D521340005
X-Stat-Signature: ihogd8jjocrrf9khp9weh8936wqjb5dp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786593057-532071
X-HE-Meta: U2FsdGVkX1/i4uRf5bczH0+MZkRGRPeonPWhag3KV62GY/qoRcOl47wCOzfS1Jwy7ARA4gH53QGUDKD+91zanorjuXpOoXCoiqYLeILcYjmBDxv9EBbN9GqdYZCAPEoQI0C/hdI76SdYqThEl4bnnhF6a1wKx11JURtMQTAZJDb03WKnikVZK15p0Z8bDzr5kL3bDIZLalmxfHs/L8nUQNidRN0+gzw8IYFgExHNChHj+XTZnxigbYrpet5pOug5n2NODwXvjq4qUdK+R1UkT8szI+Ac5eEz+USNSws9ellEbGtksTy/EIb6kah8b3Ky21epVqSpy1lWKNI7UQMvQ8HS2fK6Db66SJRTxX0kA+LYOugyaYBLeoPSvI8/JtuFDdkmfmOeyzhwwMjTFnOBVc4Lt8QFnyg5p1DAiGVZxd4FTRGi/X/rAoKA6XlPi6/3YmFns1lZnaZF2m1zBL8/X+GrMtCI0IqOfZHgTXJVELB3TUyZhJZ87pvFWfV21kY5DZTQAi3kS9u6Obfl506+gAZGpB70eJl28JflhC+Ze+j5JYrqSKbSSpIWDOPRhta4+a5llKOnO6GHW81v3qngW1EOwrS2yv+Pt3/Eh9Dig8mtjSGYPCCO7sHYXMrxqgnuatZqDXK92PlSnIJE1MFfotqwYKxDUWU5CQ40RshN1LvpeRO+IauAggoT2gQ6YplXZvLDJAdy++jKl85Bu7wUedXSf3cfeed985/ud4EyecxVRJ2fGqjHgeFai+5R7zRawxMOGoX5lYyySL8YXCljLsb41qn8/Vv7m5IGTnPDDvzUv4GWHoFLNFVCV/Kbfbp5Xq0iIjvs4OaxVDGoQMPAd1cb6CiWU1bxJkxmq+r+YjLcxQhFz3C+reBcZUdMWMAHVMnIjIbWiPAAwv5gsXCRPzvzPZ7ftm56nJhJfc406ap0kHSSQ6t9j6lh79Q/uixjnxJIJ7XsCrhaSb/WXkT
 F86MhmWu
 EoJstQPEOQgRd2h4jeRzK1zTBupZ+83ndOeQxqKY10/fSKinXcM/Uk4AE+BB6l55+3aO0w1mQNmqO4E+SH5kBXjPMox81jBAJZFALU5WFZq6gpCDyQfRVSjNCx9R7hAMtl31UJFtH4WijRB+OEU6E1c+1z2oNuiWpdylfahMHCko91MxMk4Upoa4AvMuFroQ7W402GyeqvTiLZ9lltE3Z/RiSVEb/uw3VfecAhCNdcKVk23Ef4E8THKvuWlblnZkDZrj3uO91lSWp/c17vfJjWfdkiiTGqZBodlHrlBpN7OtBkua4bI+KQ1ag0qJfh2PZFTSAP+7JepgZJ7mmIRdgay8Rn4TWUvVdDPKjvNBm41UWiOQJJDHv2XEIkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a KUnit test suite for the refcount_final_put tracepoint.

The test registers a probe function and triggers both refcount_t and
percpu_ref final put paths, verifying that the tracepoint fires
correctly and that the recorded fields match expected values.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 lib/Kconfig                      |  10 +++
 lib/tests/Makefile               |   1 +
 lib/tests/refcount_trace_kunit.c | 141 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 12bc59515a3e..ee12e8f95158 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -60,6 +60,16 @@ config REFCOUNT_TRACE_FINAL_PUT
 
 	  If unsure, say N.
 
+config REFCOUNT_TRACE_KUNIT_TEST
+	tristate "refcount trace kunit test" if !KUNIT_ALL_TESTS
+	depends on REFCOUNT_TRACE_FINAL_PUT && KUNIT && TRACEPOINTS
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the refcount_final_put
+	  tracepoint.
+
+	  If unsure, say N.
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 7e9c2fa52e35..1ef41c0b6a0c 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -57,5 +57,6 @@ obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
+obj-$(CONFIG_REFCOUNT_TRACE_KUNIT_TEST) += refcount_trace_kunit.o
 
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/refcount_trace_kunit.c b/lib/tests/refcount_trace_kunit.c
new file mode 100644
index 000000000000..a57e9e4cfa42
--- /dev/null
+++ b/lib/tests/refcount_trace_kunit.c
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
+#include <trace/events/refcount.h>
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
+			test, register_trace_refcount_final_put(probe, NULL));	\
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
+		unregister_trace_refcount_final_put(probe, NULL);		\
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
+static struct kunit_case refcount_trace_test_cases[] = {
+	KUNIT_CASE(test_refcount_sub_and_test),
+	KUNIT_CASE(test_refcount_dec_if_one),
+	KUNIT_CASE(test_percpu_ref_put_many),
+	{}
+};
+
+static struct kunit_suite refcount_trace_test_suite = {
+	.name = "refcount-trace",
+	.test_cases = refcount_trace_test_cases
+};
+
+kunit_test_suites(&refcount_trace_test_suite);
+
+MODULE_AUTHOR("Eugene Mavick <m@mavick.dev>");
+MODULE_DESCRIPTION("KUnit test for ref_trace");
+MODULE_LICENSE("GPL");

-- 
2.51.2


