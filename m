Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1634C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59466B0095; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23886B009B; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5576B0099; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE446B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9AF01A06E3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:56 +0000 (UTC)
X-FDA: 85190637672.11.5EEFDBB
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02DC018000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BM65C00i;
	spf=pass (imf24.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5+uH0xlKN2hEFrP0JeeUp1z2fKvzaAC1oyZ553cvDk=;
	b=6NK55nG44KLuooVvedMsAU/n8LJ/pQyT/RvvL0hVSUQA0rPyuAiMkmlujnmQvnbRjilUVQ
	NBs1s86FgJQ08emx0SwR4ALg13VENUIUZCJfZ0VtB8ucag4PxpXyjkkSLLw5bIPFTSY+u/
	efogEi7oktTWlKZvo+VFMXvI7fm8U+A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BM65C00i;
	spf=pass (imf24.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873235;
	b=OnW3xLXmY32+46XbLWllS8N0vsS6Wqr47XRqAvKfEQB0+4m1iHc/5l3G6IAvB6Dz9225uw
	jVmH8zpIn1m3x1AIBklM7C7Qg2hD5kvDaNneBT86T+a2rxDkGoiQBK/4RANNEW/enJ12DO
	nv5z53jZMlYPCMB2EXAnHanG/J9YEXs=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a60f0dbeccso6000973a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873233; x=1789478033; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s5+uH0xlKN2hEFrP0JeeUp1z2fKvzaAC1oyZ553cvDk=;
        b=BM65C00iNnI3pwVI8r7Sm1UN7iGKR3vDU09GdFqoZQd1KBTIxIXXBkXlTyG59vYit3
         wXtueS9LPpAfe0n6e+COlmVf+43S1x5OMYPubsmQtiHGtnV7Epql75GYeiUNRUk6qW63
         kZb7+784HR//dbAmgS3Rr1A34mD+cZGXUXCav2ksJ343EkhU5Ga1XkHJXLEWf9+iS+Ic
         DaNP1iV/JuAcW48+OMK+KPS7jmWuGKCXqBzU/l/2Omu+YBaQwHkUSrdcVI1xeUoWz9Qk
         0BTAkvTdIN0un8q1iuEKWQu7DrZik4hE5vJ2TDFifQCcDK7DBm4errpSUXQlMHSy9Shr
         zYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873233; x=1789478033;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5+uH0xlKN2hEFrP0JeeUp1z2fKvzaAC1oyZ553cvDk=;
        b=a7p7KdLKFuhcuSTtV6BNuYx8oUdnRFhDIRPfCHye0ncXP0e90mH077cN1gIY0V21eJ
         ipMoTxgesmrFrOPn/WUIj5G12HBPqCPw8BnTgGF+6L+Sg7Kaq8LvCi8Fht4+v5N1LSvM
         4YqCx3nyQN7LhyEAAfzK88i59Nx6fVRUvHUwI3zdPyYQaJbMOTpoBLAVQ2uXIl68OTlW
         lBQkhdcCdFZuN1ScHkHq3KFXQPU1gfz4bnJXzT0zuOlK9d3gUMY7/6PNAe8lcgsgnc6V
         G0Jk0rbCQ+DIjoHOkUTe3N4jn50Ps9qjYrMEDCOiJdY/gC3aDz6jgxQhjY41XmrasEWf
         8M0g==
X-Gm-Message-State: AFuF++ms550Pw7VbmDQqX0VeAiSnpp36lx9qyHKxAANl6XqQupl3Jn7/
	C6cLjQ5PR6h3xjR0LXvPnZLX1CmlzPQynEcRsn6RoD10yGZI7zFbemME
X-Gm-Gg: AYBFou1kCWYKr54HvyJ0dgC5LGFCi0ruWjwlEXSQH77ulimMpTO57zq4vFrzie8Zy3G
	pGonjyPjOnyqAwc5jsrFaI754eeeT1r5KXF7kkNPEaJeopa7VGNpuOesnopWQxfOBZsyLTsiFDT
	5Nc2HinMp0/1ay0obBI/xpg7B2xk7omKJwGL0VrqvH1BHgXeN1iV1g7T5xolTH4aWzDTJplqfzi
	ZmcDRbZr2lxWhyrnB5BRABvhlvaT+2ueI0aYdON2+CL71S/qdelHIAuwdyGr7jkOrYwY0MxYVaz
	rzgPFTvZ3M1X41NOsRO+jGCNvudlrDqBu/d8a0Xcm0lO3pK8dW6N5z43ymArhsqNrQPKiWShe3B
	a6Ip7ntVg9zrQ4Z7G2FsIEG0wjAV91GrSKxxHg1lvxJDGUTqw84jsBUb3lfwtWJbsexDsU9m0im
	RozMJzcLnjZB+BWVe/liqEZq8hNQlxuatfUGDqJNaZSDXqIkWpQw==
X-Received: by 2002:a17:907:7281:b0:c25:cb7a:12d6 with SMTP id a640c23a62f3a-c260c9972aemr1109763266b.14.1788873233006;
        Tue, 08 Sep 2026 06:13:53 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:52 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:35 +0100
Subject: [PATCH RFC v2 02/11] stackdepot: add caller-owned stack trace
 fetching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-2-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02DC018000F
X-Stat-Signature: 3eci9c5qakuxt7ukcwsxx5hbbdds5z81
X-Rspam-User: 
X-HE-Tag: 1788873234-831848
X-HE-Meta: U2FsdGVkX18j0wGVa42UKwl1efw5rRo8cyY2BpawoM+LipdhNbOk0jiwATxXF9DzfGw97y+6J8oCjAP4L6pkCM5FrBU7hJBzp7orvOV74PdTZ8USdsbKTqjK0Gp0wra9PAn20GgXQrCcjBJTHL7Zy94fvME0sVHpnssJ75FF06KEE6AXOCFW/UlgtKFJyMPmWdoQ57J/Hcv8OA6BqNymgg++0EbKUW3myV8RT5CSEYjPzfZrh/y+Lk43xfJv8IUKeywfZIoM52UXlKQMU0OQwxPImL89xKXoeMUSH8DkZ9nD0Rk0jOCKORlLbWuNflGImujUROmZhikmTi2tsFHIJap+vqlOdb8OHiJY4S4H2CXulyMReXEWxwZNihhBwVo1YTWeuvZOsvz+Tn0OUJCSiB7RGGDMz2nJTHL1lpXec+44b73p+B8wXhQo9p+BPgX7V/5jInwzI9Z8AGD9lc6qhqjYECB0Lkb31NKm+34RUM45Hjjt7C7fF7kXmLKOAsX1ZNjHAOftrQPOCoNimdffCBjmPcyTmTZlqi3LfkJXLzDawSO3jX4AsdxF2ZAzJc74TxRRo3go5PC+A9kDl4+F6q11744c3uOISpPVfka0PoNuK6rAiq84dW4UysGiF4yb0hUNaKwIRbR2yq6oo9YBzpmpvLlGkWpWaAwpr1owryqi/8TK2zous1yahC11CpxjHXuzuP4HNIyP2xV9D0VbdURw6IoqVcGoYspVqi/O07KEwgJk915HrDcKLIq1vmlXfvFTaP17JzFm7yzI5q8pmLdTIzLkz5+0GPHA1k3Ihff0X2QlTrXtxQ2AUVqMn7+Hdklh2IaCpaEmCBwEvEWuew4ke9NbzHiXquI4WHnsHgeqBhfTRStKP69+tt8ZDe4dBHxHUoTVD64kDkRLhKy8f62yIxJTJA2wxic2SON0cgSajhkPYzpzO8MCZAtTYfKZzIISDEsSi/vWVWec6W8
 pISAbM1m
 YeZH885jhXTlaxwciEO/yc/wMkPIpq+IUGqLRLusDjZx+NbltZM6lL+trIByZ+XQGucmOcMweuLUU22P7Ixjy0F18Q28bueLBPL2QDJpTYdVep0I4SUoZn/zm6JfN7xRDLDdeiDeosbfEjnqN9N+MbQoZKzqaGkmg9bziYvDprB35+VXxe/mk7qHwrLOSfngckEl6wqHjm9zbNtHhYPkl2/TpydmXEjIW/mVl7bMOV0zij7re1k3dg6bHocwDQp4ADT9OPjx+Cw9jvNZR3ef91I/1jnfmcITatGVHo0Pp0goTsqFX7U+WcR70ZCENz7H3eeBvBx/NCWde5g00NTUMFs7BdeF59RRZQ9HQ7C5PTmPEOyJV/bSaiSuds+bF4glZZ0OJbepYL21k65cVl26l8GbFZOuKdvBDid6ITVJ72WK27xtWg4pmg7IcKb5C+7OsyAbB8IkrC3vaFhkcE5rfzf6icOHNkJ8xS+e5rxrCzy5wWHLJn+9QyTb/7W3ZzR+lBQPV79VCXkd5g4KIBLskGPsPVVfeyrNrMLKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

stack_depot_fetch() returns a pointer to contiguous storage owned by stack
depot. That cannot work for a backend whose frames are not contiguous, so
callers need an interface that copies the trace before they can support
both backends.

Add stack_depot_fetch_into() to copy a complete trace into caller-owned
storage. Leave the destination unchanged when it is too small, keep a zero
handle as a no-op, and document that callers must keep the handle valid
while copying it. Warn if a caller passes a NULL buffer or zero capacity
for a valid handle instead of treating the stack as missing.

Unpoison the copied entries before returning them because
lib/stackdepot.c is not instrumented by KMSAN. Add built-in KUnit tests for
exact and oversized destinations, zero handles, and undersized buffers.
Later patches add tests for stack depot internals.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 include/linux/stackdepot.h   | 36 ++++++++++++++++++
 lib/Kconfig.debug            | 16 ++++++++
 lib/stackdepot.c             | 28 ++++++++++++++
 lib/tests/Makefile           |  1 +
 lib/tests/stackdepot_kunit.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 170 insertions(+)

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 2cc21ffcdaf9..734529767c8a 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -199,6 +199,42 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+/**
+ * stack_depot_fetch_into - Fetch a stack trace into caller-owned storage
+ *
+ * @handle:	Stack depot handle
+ * @entries:	Caller-owned buffer to copy the stack trace into
+ * @max_entries:	Number of frames that fit in @entries
+ *
+ * Copies the stored frames into caller-owned @entries. If fewer frames are
+ * stored than @max_entries, only the stored frames are written and their count
+ * is returned. If more frames are stored than @max_entries, the copy is skipped
+ * entirely and 0 is returned.
+ *
+ * Passing a NULL @entries buffer or zero @max_entries for a valid @handle is
+ * invalid. Callers must provide storage for @max_entries frames.
+ *
+ * Callers should size @entries to match the save-side stack depth cap (for
+ * example, %CONFIG_STACKDEPOT_MAX_FRAMES or the local stack_trace_save() limit)
+ * when losing diagnostics on an undersized buffer would be surprising.
+ *
+ * A non-zero invalid @handle, including a post-put handle, may WARN. Its return
+ * value and copied contents are undefined because the record may have been
+ * reused for another stack.
+ *
+ * Callers must ensure @handle remains valid for the duration of this call.
+ * Persistent handles saved without %STACK_DEPOT_FLAG_GET require no extra
+ * reference; handles saved with %STACK_DEPOT_FLAG_GET require a held reference.
+ * Callers must not call stack_depot_put() on persistent handles.
+ * Racing this helper with stack_depot_put() on the same handle is invalid.
+ *
+ * Return: Number of frames copied, 0 if @handle is 0, stack depot is disabled,
+ * or @max_entries is less than the number of stored frames.
+ */
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries);
+
 /**
  * stack_depot_print - Print a stack trace from stack depot
  *
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..fcd74edfd93a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2785,6 +2785,22 @@ config RESOURCE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config STACKDEPOT_KUNIT_TEST
+	bool "KUnit test for stack depot" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && STACKDEPOT
+	depends on STACKDEPOT_MAX_FRAMES >= 3
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test stack depot API behavior at boot.
+	  This test is built in, so KUNIT must also be built in.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel
+	  developers running the KUnit test harness, and not intended for
+	  inclusion into a production build.
+
+	  If unsure, say N.
+
 config SYSCTL_KUNIT_TEST
 	tristate "KUnit test for sysctl" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 90c52f2e0d3f..4da7279d9f83 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -785,6 +785,34 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries)
+{
+	struct stack_record *stack;
+	unsigned int nr_entries;
+
+	if (!handle)
+		return 0;
+	if (stack_depot_disabled)
+		return 0;
+	WARN_ON_ONCE(!entries || !max_entries);
+
+	stack = depot_fetch_stack(handle);
+	if (!stack)
+		return 0;
+	nr_entries = stack->size;
+	if (WARN_ON_ONCE(!nr_entries))
+		return 0;
+	if (nr_entries > max_entries)
+		return 0;
+
+	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
+	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
+	return nr_entries;
+}
+EXPORT_SYMBOL_GPL(stack_depot_fetch_into);
+
 void stack_depot_put(depot_stack_handle_t handle)
 {
 	struct stack_record *stack;
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 3cac3b63a752..1f72191f98bb 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
 obj-$(CONFIG_SEQ_BUF_KUNIT_TEST) += seq_buf_kunit.o
 obj-$(CONFIG_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
+obj-$(CONFIG_STACKDEPOT_KUNIT_TEST) += stackdepot_kunit.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
new file mode 100644
index 000000000000..b0c44c096976
--- /dev/null
+++ b/lib/tests/stackdepot_kunit.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/gfp.h>
+#include <linux/stackdepot.h>
+#include <linux/string.h>
+
+static void stackdepot_fetch_into_roundtrip(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x101000UL,
+		0x102000UL,
+		0x103000UL,
+	};
+	unsigned long exact[ARRAY_SIZE(entries)] = {};
+	unsigned long fetched[ARRAY_SIZE(entries) + 1] = {
+		[ARRAY_SIZE(entries)] = 0xa5a5a5a5UL,
+	};
+	unsigned long expected_tail = fetched[ARRAY_SIZE(entries)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+
+	nr_entries = stack_depot_fetch_into(handle, exact, ARRAY_SIZE(exact));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, exact, entries, sizeof(entries));
+
+	nr_entries = stack_depot_fetch_into(handle, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+	KUNIT_EXPECT_EQ(test, fetched[ARRAY_SIZE(entries)], expected_tail);
+}
+
+static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x111000UL,
+		0x112000UL,
+		0x113000UL,
+	};
+	unsigned long fetched[ARRAY_SIZE(entries)] = {
+		0xa1a1a1a1UL,
+		0xb2b2b2b2UL,
+		0xc3c3c3c3UL,
+	};
+	unsigned long expected[ARRAY_SIZE(fetched)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	memcpy(expected, fetched, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, NULL, 0);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+
+	nr_entries = stack_depot_fetch_into(handle, fetched,
+					    ARRAY_SIZE(fetched) - 1);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+}
+
+static struct kunit_case stackdepot_test_cases[] = {
+	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
+	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	{}
+};
+
+static struct kunit_suite stackdepot_test_suite = {
+	.name = "stackdepot",
+	.test_cases = stackdepot_test_cases,
+};
+
+kunit_test_suite(stackdepot_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for stack depot");
+MODULE_AUTHOR("Caleb Kan <ckan@cloudflare.com>");
+MODULE_LICENSE("GPL");

-- 
Git-155)


