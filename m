Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36925C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB806B00F1; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FB46B00F6; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D548C6B00F5; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8F6F6B00F2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4F221A02E7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:29 +0000 (UTC)
X-FDA: 84957420618.21.CE09B9D
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2344DC0004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRtKchl4rToxBOwHE1iEk42Um7GXykTshGoJLgl25Qg=;
	b=d8iVoKyaFuzY/Lydc6L+WzR6jH6X5Ube3rp1ZIFOBk3Jg1Baw5eE+He19sGNwwHcxXvdf4
	AVi9L2FLhuLtSlo8c8tquRRvgDkFNcS6GRpHb0ya7ZxsvFtNR90mo1vaPf6bOKkOvPML3t
	Cgw21bbvOz6fDdTIK7PIcEGrPlUB36g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320448;
	b=y8fJYZm3StqrckfTDWQvJCobYAx/3zM3wlrdtkH9kcGag1U5ujdHWjyxPMGJZERABU2Xd4
	xkEGdAGB2ELLPrLhahKDO9DaDxXEmza8yj7ChmqXyoJWjUnb+xBdKWJULkvzYpgLP/Q4VF
	yqvbPoEWZm/5fMw4MaMDOw7QWYXNCKY=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gt66q2QHkzMlf3;
	Sun, 05 Jul 2026 01:20:35 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 07:19:23 +0800
Subject: [PATCH 4/4] kunit: add test for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-4-cdd0014626a9@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=5737; i=m@mavick.dev;
 h=from:subject:message-id; bh=uO0yuH0cgFlwuh+60ouE/XunglpmQTZB7vngb53hITQ=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeU5kCI4JSjJN+yF3Tt2GQiRXUT953vzjuu9nCtDJOg
 YoZRuYdpSwMYlwMsmKKLDVZCe4ZK2clGh+d1AMzh5UJZAgDF6cATMTmOyPDet/XZc0fq6Y8e7i8
 p1yb76Vkc929VUW20Vf7Jm3YfOMvJyPDhgNNDx+mah2q3f19hrbBxbCJDbnLnCINH2+Udn97Saq
 WAQA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2344DC0004
X-Stat-Signature: n676snbmiz7z9h3je9riwwqxgj36kk4f
X-HE-Tag: 1783320447-376002
X-HE-Meta: U2FsdGVkX1+DfjZlunKiEXR2X5stXHVDtKuhDZMP8SWFKupRB+wp1fhRJrdalQdYrx0o/2eXCCjZlFlCF1RHRaEkf2iR6RSHyttgNTrnoNCX9qilOotZ3UygqhOhiqNK4ndEI3igPyumcQVYcs1g49FTbrnPwKnN17yj4lxQ/bKks+UplFXpciYpuxBHYVPy10ueuWIxFbiSaGh50R9F4q2nxMSulX++X4U+W8spLFPSFojQINyhgjWWnsMFPIzahXUOHwk+eQbFLwl0oxO+4VtUR9tRJ1A5or/etFmmowUtOJY8HK0mq3DKZws6DFdIcP80HSVQLCvEGP9zrC2r12gteeP5I4iL429MKZTYxhzTrN3FtEsp/XKOK5igwAZBGp5CYIPr2MkMeAk3fWfPvnZrkPKcy+QJExG2pR72+Qb3AT661to10vCSszBVQYTT8WpR6HG1vxBvQV0U7dbqgfLq8vlCsjAD9z1ttrNNqt1amG0zXBHNWCY8eD5Jnd+iACTGqsA31Jt4euxjS0O+0Cj0DOqMyjGeZOCGylhSWr2N8KRjQBC9bS8Q/iginYLEEcw9rxytatu5aeUHjr9ojt7U25GgOAshwp2YvqwOvlPNWOzWMcqsz2PAc43BcQTEJ7QTdoPixwHXwEnNwX9xryQCTArMAYXjE7RFNuMEYWjkKq/6PUvFu0wXekjw2zGSUsQjaTHGu6O6BG5V5wp/UJMCW0n0p8ocbujc8FChjaxw+68IsbPPKGew5OYidzjIBR3gKLW5iXBqzW8p6pxT+IaTw6SjGthRHcA7hA/ucJ5ZA31Vw0AbPOVlVjv+2FZ4xkBRstMJWAs/A9DwibImDtv2QO3HRYPemaaFEQkXOXO+jwOTp3b4PX9FwFU51ixuVI8eT7KZkSEyeXK9Cb7dD4oJbZnRdmYj6b7orACgQvEcV3ucOQr4qvWvYFPPZySJJ2zSxCHgydyVyxV7yU+
 RU4utQez
 6cd5VK/bZWP20KIvVoLwEo1YSTFe0JlfcJkuZ0nQ0oIDp4Io9qt1l8PdubMe+A9mS6NuOC+mPpEP0W/0fu8riTlP6gBOKItGStaVXfIs3Wshtx2aRr216130g3XJKYFBU8GedLDJ25+kM53SqgKqurCn0OmOhPaUZQM6ExPewRTHhjQP+48wfDW0u/fwxJW6gO/bGGhwq5Atsse/8PT7CVgsQ+IfHqSh/YyV8IR7hYyLb+Qc=
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
 MAINTAINERS                 |   1 +
 lib/Kconfig                 |  10 ++++
 lib/tests/Makefile          |   1 +
 lib/tests/ref_trace_kunit.c | 138 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dab37726b9d..7c387ed746ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4213,6 +4213,7 @@ F:	include/*/atomic*.h
 F:	include/linux/ref_trace.h
 F:	include/linux/refcount.h
 F:	lib/ref_trace.h
+F:	lib/tests/ref_trace_kunit.c
 F:	scripts/atomic/
 F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/
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
index 000000000000..2ece6c840fe0
--- /dev/null
+++ b/lib/tests/ref_trace_kunit.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <kunit/test.h>
+#include <linux/wait_bit.h>
+#include <linux/instruction_pointer.h>
+#include <linux/kallsyms.h>
+#include <linux/percpu-refcount.h>
+#include <linux/refcount.h>
+#include <trace/events/ref_trace.h>
+
+struct data {
+	unsigned long caller;
+	const char *fn;
+	const void *obj;
+	int *flag;
+	struct kunit *test;
+};
+
+struct data refc_chk;
+struct data pcpu_chk;
+
+//called when tracepoint fires
+static void probe(
+	  void *ignore,
+	  unsigned long caller,
+	  const char *fn,
+	  const void *obj)
+{
+	struct data *chk_val;
+
+	char func_name[KSYM_SYMBOL_LEN];
+
+	sprint_symbol_no_offset(func_name, caller);
+
+	if (!strcmp(func_name, "test_refcount")) {
+		chk_val = &refc_chk;
+		KUNIT_EXPECT_FALSE(chk_val->test, memcmp(obj, chk_val->obj, sizeof(refcount_t)));
+	} else if (!strcmp(func_name, "test_percpu")) {
+		chk_val = &pcpu_chk;
+		KUNIT_EXPECT_FALSE(chk_val->test, memcmp(
+			obj, chk_val->obj, sizeof(struct percpu_ref)));
+	} else {
+		//non test function origin trace events
+		return;
+	}
+
+	struct kunit *test = chk_val->test;
+	int *flag = chk_val->flag;
+
+	//ensure past flag writes are done before reading
+	KUNIT_EXPECT_EQ(test, 1, smp_load_acquire(flag));
+	KUNIT_EXPECT_EQ(test, caller, chk_val->caller);
+
+	smp_store_release(flag, 0); //signal probe completion
+}
+
+
+
+static void test_refcount(struct kunit *test)
+{
+	refcount_t refc;
+	int flag_addr = 0;
+
+	refc_chk.caller = (unsigned long)&test_refcount;
+	refc_chk.fn = "__refcount_sub_and_test";
+	refc_chk.obj = &refc;
+	refc_chk.flag = &flag_addr;
+	refc_chk.test = test;
+
+	int *flag = refc_chk.flag;
+
+	KUNIT_EXPECT_FALSE(test, register_trace_ref_trace_final_put(probe, NULL));
+
+	refcount_set(&refc, 2);
+
+	KUNIT_EXPECT_FALSE(test, refcount_dec_and_test(&refc));
+
+	smp_store_release(flag, 1); //signal final put can happen
+
+	KUNIT_EXPECT_TRUE(test, refcount_dec_and_test(&refc));
+
+	wait_var_event(flag, smp_load_acquire(flag)); //wait for probe completion
+	unregister_trace_ref_trace_final_put(probe, NULL);
+}
+
+static void dummy_release(struct percpu_ref *ref) {}
+
+static void test_percpu(struct kunit *test)
+{
+	struct percpu_ref pcpu_ref;
+
+	int flag_addr = 1;
+
+	pcpu_chk.caller = (unsigned long)&test_percpu;
+	pcpu_chk.fn = "percpu_ref_put_many";
+	pcpu_chk.obj = &pcpu_ref;
+	pcpu_chk.flag = &flag_addr;
+	pcpu_chk.test = test;
+
+	int *flag = pcpu_chk.flag;
+
+	KUNIT_EXPECT_FALSE(test, register_trace_ref_trace_final_put(probe, NULL));
+
+	KUNIT_EXPECT_FALSE(test, percpu_ref_init(&pcpu_ref, dummy_release, 0, GFP_KERNEL));
+
+	percpu_ref_get(&pcpu_ref);
+	percpu_ref_get(&pcpu_ref);
+
+	percpu_ref_put(&pcpu_ref);
+	percpu_ref_put(&pcpu_ref);
+
+	percpu_ref_switch_to_atomic_sync(&pcpu_ref);
+
+	smp_store_release(flag, 1); //signal final put can happen
+
+	percpu_ref_put(&pcpu_ref);
+
+	wait_var_event(flag, smp_load_acquire(flag)); //wait for probe completion
+	unregister_trace_ref_trace_final_put(probe, NULL);
+	percpu_ref_exit(&pcpu_ref);
+}
+
+static struct kunit_case __refdata ref_trace_test_cases[] = {
+	KUNIT_CASE(test_refcount),
+	KUNIT_CASE(test_percpu),
+	{}
+};
+
+static struct kunit_suite ref_trace_test_suite = {
+	.name = "ref-trace",
+	.test_cases = ref_trace_test_cases,
+};
+
+kunit_test_suites(&ref_trace_test_suite);
+
+MODULE_AUTHOR("Eugene Mavick <m@mavick.dev>");
+MODULE_DESCRIPTION("KUnit test for ref_trace");
+MODULE_LICENSE("GPL");

-- 
2.51.2


