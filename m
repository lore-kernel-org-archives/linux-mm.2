Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71346C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6999D6B0096; Fri, 31 Jul 2026 00:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B6A6B0098; Fri, 31 Jul 2026 00:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539926B0099; Fri, 31 Jul 2026 00:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2028C6B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:27:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FE9B4033F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:27:09 +0000 (UTC)
X-FDA: 85047786978.14.4BD8970
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id D870B140008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:27:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ff/J4YdC";
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785472027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6jZw2r6wUXuqZBKIGC1dePei5VoJhsmtK5wvBubPfM=;
	b=KwV+OsKP1Z/+EuwhJV6YwE1ttJE9LZTfqwlfQLWgN7Vv1tcIT3l+HNIg0+LyMPyMIvJHpB
	OTbzhepI5pI7SW/ZlvbFT5sRWqPdKBA9x65e276j6aB+GvyzXjgBVGyxU5+KwuL9sg4yXp
	30dPT62uoiHosmNeMYqKvU+jcGlcDhU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ff/J4YdC";
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785472027;
	b=5w/2reE26/4me9qkqCdZtXj5Sz7A+4M3JDxwoSSHyMjrMUHXxH3o+FwGbvf9fjnGPtuQET
	I/JeOjKUDszjctv9a9Vf5n2jReLJzOtgFEqPhnAURiYQNHcip9SmcMvSIkhGw+qFRaCWhK
	6OO4BgSHU5xpcct+9mq6Tz+bARItDVQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab97c86bdso44735ad.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785472027; x=1786076827; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U6jZw2r6wUXuqZBKIGC1dePei5VoJhsmtK5wvBubPfM=;
        b=ff/J4YdCegS3WXs8TgQBvox2czk122PZM6mtKNb/xkRiAUQvPLklDSMVE7XV62mKnx
         9g9f9OMJuuIDJfrBKjTmMDtUTJmWtwNrJNBtOIZkfOtoAoqfRmTsalehk37OpBjBWvyv
         BL42YFlyrtaldIsCTluFtIcb1sRO2SN4aV7G6vpgh+xQk7n9BM4zSpRZAgQnalaMwNVj
         TBItfJxOZcuZVr/c/hQnw79wpKx2I+7nj35P9RhsFpv/Diyqlmjr2vKjkl9K57GbPQ7t
         Lu5OtdzxfTCLO39ZNzpruTlR66ZQ+FpbaBGhJ2XwoFRCYGQBgvJeftYkNs41xGkj3hs3
         5XxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785472027; x=1786076827;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U6jZw2r6wUXuqZBKIGC1dePei5VoJhsmtK5wvBubPfM=;
        b=ckyrxyGOu28KeuGf+MkcQHuQM6Pyy7FS9qmkeqCYnAq8q/AbuEPoPjHnoamVhu5PqQ
         GKhC1gt0nKfsPwgrq4Y5L+9Nw7XtrwlPqRLitoJLCpYVLG6uKNBG+HV0wDpHNgU8bchx
         7LKqhybn7DLVcw25SzyIUcD+liHHkEZddr/rIZplYYZag1BrwvTmD/NIzC48dEi2zGay
         9scBKKhSHExKpwc+ABGQyUNr2L/10hbo3+6sjlRgwgP10rWe4CEljF0TC8EmQdlJMzRf
         4FsAtgUQMxe4jvLqeCQZnm5tDoGSbv9FRmXQSkBLqVm6n1bDJ8dFpcrtmV/F6Inkr9my
         zySA==
X-Forwarded-Encrypted: i=1; AHgh+RqE5MYhZ0x2jY/QLgZn7Kw5SovM61U9AQoJiTrIhECmxEgxGc8Ta0OmZD7BqMrSiKUFLok9IJ+bYg==@kvack.org
X-Gm-Message-State: AOJu0YyWF8P+eumaG/X03bIxC0FM7UmdLVepZ1kD5cb0ffuI8G/fRfAF
	Y9BzxfNDztuv7TFALiiN6dAN1an7AEefbSrSI4Py/nn3myBagWnb8afE8FrMtfQ7EA==
X-Gm-Gg: AR+sD127/+cuQmm7AGDavCidL20jjIogTOSNZcJ3WwTKqqJ+37WvfRQxaLdMFEkXhV/
	WkznAp0adRonExPvZF6SyXps60dAxpAaGX78i6IWatTI/7yYze6nQqNbGk+rfgG4V3ZA9PTCWwj
	JhQdooyUyUtQZMMEl1xXJIK95Y4b2aZO5Mpr2vFZShKwC/+s7pnz/L4ha4WDdYuHtVxL/oRx5AV
	gcX2CB6NBVw84CC1Oa3KqVHTj4GExpFKr0ZRGLtve0CjJK5osEJ2NLmqfHItpaZcS+djwNe9XNh
	rU5TdE1zoA2gkLkiSLLICYTYYQW6vD9+WezNO4JIgFFCngqLQCkxQn3o+SQeY2MZ1+/De13X+IG
	fXIn6hy52zJl77/T5P1BJxkMzWxQ1glN8BFs/q+is5Fft9ReGORigRL0UXwU9+q51fCwpMQF3TU
	xOalA0dObk75zOm7RmxfAU/x07uIDRcZ96go4Fv6JwOIQE/Ko9aoqgfLDECTl3cmsFPoRHb3UQt
	qu626xpW3u2rBz85mBtR95B+xw7+pWNXEVwyc5QxnFVGtnazM7piL6NHifCU4FNgv4Fu65u6v47
	nn3m6/fhTUqYaf/PROMngINmJQ==
X-Received: by 2002:a17:903:2c0f:b0:2cf:9ec1:ea6e with SMTP id d9443c01a7336-2d046e9a9f7mr1527675ad.8.1785472025985;
        Thu, 30 Jul 2026 21:27:05 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:a061:9e19:11a8:45b6] ([2a00:79e0:2eb4:9:a061:9e19:11a8:45b6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed5e30634sm193651b3a.56.2026.07.30.21.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:27:05 -0700 (PDT)
Date: Thu, 30 Jul 2026 21:27:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 3/3] lib: test_pagealloc: add synthetic benchmark for page
 allocator
In-Reply-To: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
Message-ID: <36750300-0785-6a4d-ec18-b3f549962301@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D870B140008
X-Stat-Signature: yxn59ctwnopniz3f7y8nxes7uupujhhd
X-HE-Tag: 1785472027-261331
X-HE-Meta: U2FsdGVkX1+OZ7CHzZZGY1+ImP9y0puQV92D+xex0IoFgGlg54GFjhEDw+boUrpzO7rLSXn/RjzH83bar6pbpSrVbta9BWuy9nANr2y+2Wpc4Vy/878A3YmaSQH00bl4WAbU1lNkfJbyh/y+rzRdjdymHL0x2F87faVPI6t8D8f0BMg1z5usKJ55QeohJ9/tLiISzLVa0xIvCcIAuId6cDXHZgvW1N3rJVCuv9pTpWsJ5n7k+JVnJliUndgAQUySA9NNqlzIRA0qah9/VShZANlgWc5nxBjNCbXX79AWFh8S/NJk2H1qUaefa6XLE/W9HKsKVaeTtFD8oizyAgq7vCt+oeMr4Pgsxp8m1eW/An+DN0a0FwNB1ZCw4+i7WrJ47M3fdlWm/6fJIyhM/kXJbk7o6Vvevd8RssObooS7ZhhbotXVax72aBqKFKX996LEt2YIMeqQyyUsgM7yF3Cf/LMOR9cca/6DEF08EHC1/3QSVAjXJtJaImiBpCWtnozkPfae2RHZCqaFghyFkOo8FQaU6tmH9Vt0Fu2bV6cErzF1K5FocDtKiO7IIGD65hLY5ZzlTTwjyVsN1EBstdTxJ3HZVboEvalEdNQIPt+hh2p2UYzZwX2xvbuR650uqnnbzgXi0KDcCHWdr5vWgPverC21UK+xzkSrmrnlw8hvlcIUo1HDBalHB7OdH6ju56Mmir2OfjYgUbdyS7s8IpnCCY0Bvm6csk0297f2B42P3k5SzcrJvZot4nYEav/YyM4NglHiGqiAu2QoyFIF6Z9qhmui/KUwXMtYwQ1ZDBI5Yr2pKhYDuQZ9aS+xrQNN54SOm4+R74ST9oObXeGSEgqVwvXLRIsj5pL4I9eYAD6WZ2RchzxX9VEkMlseaH5v91nnkDMjc/sE53yNwlE9ZSoD871akx96BumDsmnKUf80JmtFkUxG+ucpS2OhmKm4Araufd36jA6WQkelSPhaB65
 Vfi5Irm0
 eecf3jUcLrrOtf//7xufP3iEh6QDM0H84YKj47CYRZ38Ey/baXGyk5u0DdgZJCYQ6sZolVS9FTX3u3YfOqXGDKV7qm4MF+hneUnbFQYR5YMP/RfxgOGpkkH5wVHrgeORQ+SDVBofXSw6UlXSLEV2NGNNLSMr+J1rc+U2tXO7vQRnF4klkdhs5b3M6QTSwdbJMeP95IJWGPnC5pYPrwU9kZ31/f2ItLAFFg6TipdnEDsGBZEG2BwUTXJ62eMlQx942p7REhdR5dUg4pgyKlHQx7QhvCO9+6nkB3bcs6uD6DGT4pcfSbIz7g75rXmXgJQHG0Og7Ud1dOLJ+SOxhN2Vg9t0TrQR240JRxCXH51PlT+ozY5SPsCEbdIqLJ5ka01SwNb0dIxSBlEdXVQ4jg4NIaOI3xFknBmt3TOphSKBh5qwwf3BaTp5EOFQTz0TZw67+Yd2HPV1s7DPOaTDRQPNWrjFyzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of the
buddy allocator, including repeatedly allocating and freeing memory as
well as concurrent and remote allocations.

The test is run by inserting the module: modprobe test_pagealloc
The module insertion will always fail so that it is automatically
unloaded; the results are in the kernel log.

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/Kconfig.debug    |  10 ++
 lib/Makefile         |   1 +
 lib/test_pagealloc.c | 337 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 348 insertions(+)
 create mode 100644 lib/test_pagealloc.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a7e738e6afa8..70873aac675f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3447,6 +3447,16 @@ config TEST_SLAB
 
 	  If unsure, say N.
 
+config TEST_PAGEALLOC
+	tristate "Page Allocator Benchmark"
+	default n
+	help
+	  A benchmark measuring the performance of the page allocator, useful
+	  to analyze any improvements or regressions when repeatedly allocating
+	  and freeing memory as well as concurrent and remote allocations.
+
+	  If unsure, say N.
+
 config RATELIMIT_KUNIT_TEST
 	tristate "KUnit Test for correctness and stress of ratelimit" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index fe54690d130c..17c164e145ad 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
 obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
 obj-$(CONFIG_TEST_VMSTAT) += test_vmstat.o
 obj-$(CONFIG_TEST_SLAB) += test_slab.o
+obj-$(CONFIG_TEST_PAGEALLOC) += test_pagealloc.o
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
diff --git a/lib/test_pagealloc.c b/lib/test_pagealloc.c
new file mode 100644
index 000000000000..30514df52c5b
--- /dev/null
+++ b/lib/test_pagealloc.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test module for in kernel synthetic page allocator testing.
+ *
+ * Compiled as a module. The module needs to be loaded to run.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/timex.h>
+
+#define TEST_COUNT 1000
+
+#define CONCURRENT_MAX_ORDER 6
+
+#ifdef CONFIG_SMP
+#include <linux/completion.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+
+static struct test_struct {
+	struct task_struct *task;
+	int cpu;
+	int order;
+	int count;
+	struct page **v;
+	void (*test_p1)(struct test_struct *t);
+	void (*test_p2)(struct test_struct *t);
+	unsigned long start1;
+	unsigned long stop1;
+	unsigned long start2;
+	unsigned long stop2;
+} test[NR_CPUS];
+
+/*
+ * Allocate TEST_COUNT objects on cpus > 0 and then all the
+ * objects later on cpu 0
+ */
+static void remote_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	/* Perform no allocations on cpu 0 */
+	for (i = 0; i < t->count; i++) {
+		struct page *p;
+
+		if (smp_processor_id()) {
+			p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+			/* Use object */
+			memset(page_address(p), 17, 4);
+		} else
+			p = NULL;
+		t->v[i] = p;
+	}
+}
+
+static void remote_free_test_p2(struct test_struct *t)
+{
+	int i;
+	int cpu;
+
+	/* All frees are completed on cpu zero */
+	if (smp_processor_id())
+		return;
+
+	for_each_online_cpu(cpu)
+		for (i = 0; i < t->count; i++) {
+			struct page *p = test[cpu].v[i];
+
+			if (!p)
+				continue;
+
+			__free_pages(p, t->order);
+		}
+}
+
+/*
+ * Allocate TEST_COUNT objects and later free them all again
+ */
+static void alloc_then_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+
+		memset(page_address(p), 14, 4);
+		t->v[i] = p;
+	}
+}
+
+static void alloc_then_free_test_p2(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		struct page *p = t->v[i];
+
+		__free_pages(p, t->order);
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects. Free them immediately.
+ */
+static void alloc_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < TEST_COUNT; i++) {
+		struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP, t->order);
+
+		memset(page_address(p), 12, 4);
+		__free_pages(p, t->order);
+	}
+}
+
+static atomic_t tests_running;
+static atomic_t phase1_complete;
+static DECLARE_COMPLETION(completion1);
+static DECLARE_COMPLETION(completion2);
+static DECLARE_COMPLETION(completion3);
+
+static int test_func(void *private)
+{
+	struct test_struct *t = private;
+	cpumask_t newmask = CPU_MASK_NONE;
+
+	cpumask_set_cpu(t->cpu, &newmask);
+	set_cpus_allowed_ptr(current, &newmask);
+	t->v = kmalloc_array(t->count, sizeof(struct page *), GFP_KERNEL);
+
+	atomic_inc(&tests_running);
+	wait_for_completion(&completion1);
+	t->start1 = get_cycles();
+	t->test_p1(t);
+	t->stop1 = get_cycles();
+	atomic_inc(&phase1_complete);
+	wait_for_completion(&completion2);
+	t->start2 = get_cycles();
+	if (t->test_p2)
+		t->test_p2(t);
+	t->stop2 = get_cycles();
+	atomic_dec(&tests_running);
+	wait_for_completion(&completion3);
+	kfree(t->v);
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	return 0;
+}
+
+static void do_concurrent_test(void (*p1)(struct test_struct *),
+		void (*p2)(struct test_struct *),
+		int order, const char *name)
+{
+	int cpu;
+	unsigned long time1 = 0;
+	unsigned long time2 = 0;
+	unsigned long sum1 = 0;
+	unsigned long sum2 = 0;
+
+	atomic_set(&tests_running, 0);
+	atomic_set(&phase1_complete, 0);
+	init_completion(&completion1);
+	init_completion(&completion2);
+	init_completion(&completion3);
+
+	for_each_online_cpu(cpu) {
+		struct test_struct *t = &test[cpu];
+
+		t->cpu = cpu;
+		t->count = TEST_COUNT;
+		t->test_p1 = p1;
+		t->test_p2 = p2;
+		t->order = order;
+		t->task = kthread_run(test_func, t, "test%d", cpu);
+		if (IS_ERR(t->task)) {
+			pr_err("Failed to start test func\n");
+			return;
+		}
+	}
+
+	/* Wait till all processes are running */
+	while (atomic_read(&tests_running) < num_online_cpus()) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	complete_all(&completion1);
+
+	/* Wait till all processes have completed phase 1 */
+	while (atomic_read(&phase1_complete) < num_online_cpus()) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	complete_all(&completion2);
+
+	/* Wait till all processes have completed phase 2 */
+	while (atomic_read(&tests_running)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(10);
+	}
+	complete_all(&completion3);
+
+	for_each_online_cpu(cpu)
+		kthread_stop(test[cpu].task);
+
+	pr_alert("%s(%d):", name, order);
+	for_each_online_cpu(cpu) {
+		struct test_struct *t = &test[cpu];
+
+		time1 = t->stop1 - t->start1;
+		time2 = t->stop2 - t->start2;
+		sum1 += time1;
+		sum2 += time2;
+		pr_cont(" %d=%lu", cpu, time1 / TEST_COUNT);
+		if (p2)
+			pr_cont("/%lu", time2 / TEST_COUNT);
+	}
+	pr_cont(" Average=%lu", sum1 / num_online_cpus() / TEST_COUNT);
+	if (p2)
+		pr_cont("/%lu", sum2 / num_online_cpus() / TEST_COUNT);
+	pr_cont("\n");
+	schedule_timeout(200);
+}
+#endif
+
+static int pagealloc_test_init(void)
+{
+	void **v = kmalloc_array(TEST_COUNT, sizeof(void *), GFP_KERNEL);
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	int order;
+
+	pr_alert("test init\n");
+
+	pr_alert("Single thread testing\n");
+	pr_alert("=====================\n");
+	pr_alert("1. Repeatedly allocate then free test\n");
+	for (order = 0; order <= MAX_PAGE_ORDER; order++) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP,
+						order);
+
+			if (!p) {
+				pr_err("Cannot allocate order=%d\n", order);
+				break;
+			}
+
+			/* Touch page */
+			memset(page_address(p), 22, 4);
+			v[i] = p;
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_alert("%i times alloc_page(,%d) ", i, order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles ", (unsigned long long) time);
+
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = v[i];
+
+			__free_pages(p, order);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_cont("__free_pages(,%d)", order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles\n", (unsigned long long) time);
+	}
+
+	pr_alert("2. alloc/free test\n");
+	for (order = 0; order <= MAX_PAGE_ORDER; order++) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			struct page *p = alloc_pages(GFP_KERNEL | __GFP_COMP,
+						     order);
+			__free_pages(p, order);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_alert("%i times alloc( ,%d)/free ", i, order);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles\n", (unsigned long long) time);
+	}
+	kfree(v);
+#ifdef CONFIG_SMP
+	pr_info("Concurrent allocs\n");
+	pr_info("=================\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(alloc_then_free_test_p1,
+			alloc_then_free_test_p2,
+			order, "Page alloc N*alloc N*free");
+	}
+	pr_info("----Fastpath---\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(alloc_free_test_p1, NULL,
+			order, "Page N*(alloc free)");
+	}
+
+	pr_info("Remote free test\n");
+	pr_info("================\n");
+	for (order = 0; order < CONCURRENT_MAX_ORDER; order++) {
+		do_concurrent_test(remote_free_test_p1,
+				remote_free_test_p2,
+			order, "N*remote free");
+	}
+
+#endif
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void pagealloc_test_exit(void)
+{
+	pr_alert("test exit\n");
+}
+
+module_init(pagealloc_test_init)
+module_exit(pagealloc_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter");
+MODULE_DESCRIPTION("page allocator performance test");

