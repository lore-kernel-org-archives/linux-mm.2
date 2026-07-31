Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F414C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8916B0095; Fri, 31 Jul 2026 00:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F276B0096; Fri, 31 Jul 2026 00:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4A76B0098; Fri, 31 Jul 2026 00:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCBC96B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:26:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D3A31C09AA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:51 +0000 (UTC)
X-FDA: 85047786222.04.073AD40
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 882C520005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ie9KNtqL;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785472008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtWsT75VcRdayV6UMHe+iQ7OyarIoZiTjxseMwp8AOM=;
	b=cgSm9pA/49JsjPytGsZ4xPZyz2XbM99rs+WhkrjxPJKrZI5nYyeDtnqP8nW9z1GL+cbrGA
	w+nM52KPSstdSX0aFKhEtTh3F9knt2QA0fXwzxBk/nAkoYTtjDSxzniQklWDZ9WXv6N+Tg
	TerfN094ddjmILfXEnuOVDzsxbPedXI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ie9KNtqL;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785472008;
	b=BNOZ76I24uqZka5Tvhejcw2q8947pbmalBimX2rc0bYg89K69GxHvmYMSi5zbeQCtQmflb
	A3vQHHyff8LfqG2pMYzL/GHuW70qXsXkcY/WJBxPnzjBKScEOdybMykU8s80xauyYtr65d
	r2CUi+xX+h0ici3NdLsFEUHbHwjKanc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccdf36f63dso74765ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785472007; x=1786076807; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VtWsT75VcRdayV6UMHe+iQ7OyarIoZiTjxseMwp8AOM=;
        b=ie9KNtqL7rNf5pHlZSGMfHTxVHMBd6zGsIOEnQb9THdNt+o0EOr+HFikChc0lA1JOH
         ByPhx5YJWbbWlNEgb8jL5/1KEwFAxkPdHlHe8U4fRomUYnZSZIxxHLDzUwq6Rcn78X8A
         D+e5gPn/nuoLheS/fa8xUmprJHOJb5cIKGQta50x4I7tKrm1KlZQqn9+8iYKPWcDM6Fg
         RqHywoVJ0jV0ghbmWpxoaeD5Kwb5KIPGfE/efubS8IuycBu4yv7/WJ6+WohxN+Pq6Akh
         mYnWO8FH27uLMkglQ4U9GcK6D1n399We4FROOL3jCwD43Pe3fMMsLcVTKl3CFzYa+xh6
         zsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785472007; x=1786076807;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VtWsT75VcRdayV6UMHe+iQ7OyarIoZiTjxseMwp8AOM=;
        b=aivnHtLK+DE1cGoTrvlkDARLVZzElFDJQx/fhTPAIt5x9WQxFC7I/TAE+j9NUNAJb1
         bVq6H9GER8VmyjhRUDlVwKwVomfgWDiOAbU6Q+4fg3iV6Zq6tAyHQfgVa3iIfo8E2ILN
         AIDmQ2GC3/DNWlAeQiFfu/lweCOKUH+4EgDiAqre9lgpYZoo/XubE3zEjmArQB5J1uBw
         hj7cug0Na+gf5fO4eq9gwMoERhCfTH36/WSUc/uA9fRXIH3kt0vH74djkLfzRE+3iEsC
         4p0xet9ZdRHBa8ZQF3qzvHK7AUq1+6cxZeXJ5e3fRLF8ohfv6a86pja2sh5XTeC9pov/
         qmfA==
X-Forwarded-Encrypted: i=1; AHgh+RqHJCV7/ctH+1VpruEfoW4yKXuOiXbVdsPMI7Fe90Y6wsXYrn4RqATy1XnWS4TnrZySNkn24E8jaQ==@kvack.org
X-Gm-Message-State: AOJu0YzWXoQL3gwwDWWFqjUuAieyoxNHPYfNPmormAaEeNvwiBm942Hf
	szYkWOvWIEM202FpsZDbGcJhe564vonI4nd5sWi9adzq2g75v+QMVH02ZZ5Ww8jyOQ==
X-Gm-Gg: AR+sD11JPVLDfAcaVcosvsgwTRs514/qDH4Hurs0CKGcDxfuxgfHM9lz6Ol2iHxfAM6
	bT9DABieiMR/bhoCk0siR8+RHIILqVy5mnbJYEHWHCMl3l2AfizEk1yAqWnOErnp7vRttULl78K
	FNlfW2huejl1aNh+D+W1wg4uOy6ESiIIqZp3duCJeMGAkbUG1eNNMb6o8c4CpeBlokLX1jDWp1E
	Sn95jqGE8abGTpCilwPxF4hqaS3md6Ihn+xOBvcUz4/jxplOy0mZhcbUrVsVuKf0zgEcnTmSdOR
	7ZRbIY6CuAorJ9lnZzV3v7vh66/C7FTA4PRZ56l6z38BNbQzCSrxQELkAkY1zcFsYKfp6h0bUyF
	xn+XsdlaQbkJvVOU76ceCTldzsLfg1vhM22qT6udV96d0e01un+Ztm6dn2konwA8iuHXPHvZ0ll
	VNPMwz4gQzJmkqUU1FU7x/1BMwxqB4cE2sF/HPVR6HCLjc5eNi2W49ieovG5rGxpHMbgSmwxtv0
	DLj2mGXSzy/0FNCe9wAK9BargLaVbunw5wRkHRD9H486yBKGX4R/FePX+HZ29Yjp2elHOZFjsq0
	fBELjxYQi6m2uHa8qpb/ANX8Cw==
X-Received: by 2002:a17:902:d04c:b0:2ca:be81:b469 with SMTP id d9443c01a7336-2d046b045femr923285ad.0.1785472006664;
        Thu, 30 Jul 2026 21:26:46 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:a061:9e19:11a8:45b6] ([2a00:79e0:2eb4:9:a061:9e19:11a8:45b6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2f65459sm97995a91.6.2026.07.30.21.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:26:46 -0700 (PDT)
Date: Thu, 30 Jul 2026 21:26:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 2/3] lib: test_slab: add synthetic benchmark for slab
In-Reply-To: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
Message-ID: <430d42a4-6cbf-405c-8102-5ab5b930f906@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 882C520005
X-Stat-Signature: e4eqqrbswzk68cbxgbbkku8pup8pid38
X-HE-Tag: 1785472008-382727
X-HE-Meta: U2FsdGVkX19E76QTHtsq4QtGVXYq8LGt+IPxBPzntqB1IqA+vrIcGwxsYWpTxHW/RA5XPpS+DS9UGoZnO1RuMhcl/p1WXvAt3IoPalJ1pEBvBJyz4wn3CRIk4vzK10UjxjTzck1Itpua6AbH6IPo9TMbRdxVFNXPcl5b9PV8lcO2pklgMxcc/g448jwzkj7bK1W2YVgGs3HLWlhVYH9WICCTQJFENr4oywuG0dOQsmB6GuTDju1tnDbQ9zRhf8ap+c0GZZ5GRoiqI0GZPxLnJe7ht09ehXKRD6Po+gK4fFIycB7nsIwoRrApznBexQpUlcw0rBhc+4Xj8/6q9Qaw/64YmbCwUKp6mXE28MTA9P8yTlKwkK9IRgniJdW5F62K113pFUdnEqTk+1z1bD1i1n6KRypCD3c7IjwZ0NzeRqt08JWSTtV57atXtXh9nuHhMVKHx/5aConergIrijXO7mZ/oJM0HseLI/afSJVk1ZX+MyLKNlm3ElbFZwk1YVgTHOJF9euftN767cNMIjYSLyxz1HpdisSc34/x0O9wsOb+TNU5+46v/rW2yuAoRCSwROcu60v2i3p+W94U6R9ktcwmAJoxhzolKDWUxXjjCovtverXudC1T4+LxZydKEKYuowody4xq0wNppMWOFMywxlPv4KlqmNVEyBoV9W7OjzoeuPZBqPJ96PH2PLpWqKBKpKO/JLLavCrXhDpHSkNOln+uiGsNxzjXJQma9F5blPNgrEm0+qoPys7D9i1DMwG9IQWDFyU0GP69+GhHaPkR7k9+ne8J6sLg7Zk6SS2rx7IIzmBGtewUjLAWu/MunVqDbDlZtkylnyS9E5b4p0Pki9VIR5yWihMjjpb97SI7uIU9EmVkacmF3+YbyT94iPwCVGfp6Bk05zhld41Qni++7e3VbdsgITMAA8kDlaz58klj24WgAef6aCNJdozRt0oocjNTlkR9Eq5VvyMrCb
 CEGvzSjW
 UY0frTngHOJ7sirURCJ5owTTeZ8D197RqlySBdbjx3g2L2ibP4nqRkOpMruXRQBXHY/nmLQHa8ba24XjwVA7gNxq5i57uBJRNIn9AoVX+6cI3VpcVpDflgf4Q69Y1BBxtiXCc8pXHSwnm6ZIXFwK0b0htjXaolesPTraa1eoT9zyJ69mAuIolkKO/I5pgAsHwl6SmcA5KcYidqhsTJr9xeVrRcLkgAdYJtErSZzhhT0HLD0eDMXUCrBmhRd+QcR4s9akAGjzG9BJkltc5nabrFEUYbpdwFwFaswZLTCdMGqoZTrMutV7VVH5JM3ezv1IU2VQTgI7v+aK8oQk5Om1tGMYAXQbNqeJcHcWpVS0inbamZV/pNjH/kygCBonKZ5zeQX+qgcZpxlgK+OF8PPv++5O5xmgGVQtkDO0hPe7KU1PQU+Lyba5zG9Dm7xSd8wjU5Aaajy9I7udKzV59wCwvsFiKTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of the
slab allocator.  This is used to analyze any improvements or regressions
in slab allocation or freeing functions.

The test is run by inserting the module: modprobe test_slab
The module insertion will always fail so that it is automatically
unloaded; the results are in the kernel log.

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/Kconfig.debug |  10 ++
 lib/Makefile      |   1 +
 lib/test_slab.c   | 375 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 386 insertions(+)
 create mode 100644 lib/test_slab.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6d743c8e27fa..a7e738e6afa8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3437,6 +3437,16 @@ config TEST_VMSTAT
 
 	  If unsure, say N.
 
+config TEST_SLAB
+	tristate "Slab Allocator Benchmark"
+	default n
+	help
+	  A synthetic benchmark that measures slab allocator performance,
+	  specifically focusing on single thread testing by repeatedly
+	  allocating then freeing memory and concurrent or remote allocations.
+
+	  If unsure, say N.
+
 config RATELIMIT_KUNIT_TEST
 	tristate "KUnit Test for correctness and stress of ratelimit" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index 5f3ebabd0224..fe54690d130c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
 obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
 obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
 obj-$(CONFIG_TEST_VMSTAT) += test_vmstat.o
+obj-$(CONFIG_TEST_SLAB) += test_slab.o
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
diff --git a/lib/test_slab.c b/lib/test_slab.c
new file mode 100644
index 000000000000..a43b0d73daab
--- /dev/null
+++ b/lib/test_slab.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test module for synthetic in kernel slab allocator testing.
+ *
+ * The test is triggered by loading the module (which will fail).
+ *
+ * (C) 2009 Linux Foundation <cl@gentwo.org>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/timex.h>
+
+#define TEST_COUNT 10000
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
+	int size;
+	int count;
+	void **v;
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
+		u8 *p;
+
+		if (smp_processor_id()) {
+			p = kmalloc(t->size, GFP_KERNEL);
+			/* Use object */
+			*p = 17;
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
+			u8 *p = test[cpu].v[i];
+
+			if (!p)
+				continue;
+
+			*p = 16;
+			kfree(p);
+		}
+}
+
+/*
+ * Allocate TEST_COUNT objects on cpu 0 and free them immediately on the
+ * other processors.
+ */
+static void alloc_n_free_test_p1(struct test_struct *t)
+{
+	int i;
+	int cpu;
+	char *p;
+
+	if (smp_processor_id()) {
+		/* Consumer */
+		for (i = 0; i < t->count / num_online_cpus(); i++) {
+			do {
+				p = t->v[i];
+				if (!p)
+					cpu_relax();
+				else
+					*p = 17;
+			} while (!p);
+			kfree(p);
+			t->v[i] = NULL;
+		}
+		return;
+	}
+	/* Producer */
+	for (i = 0; i < t->count; i++) {
+		for_each_online_cpu(cpu) {
+			if (cpu) {
+				p = kmalloc(t->size, GFP_KERNEL);
+				/* Use object */
+				*p = 17;
+				test[cpu].v[i] = p;
+			}
+		}
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects and later free them all again
+ */
+static void kmalloc_alloc_then_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		u8 *p = kmalloc(t->size, GFP_KERNEL);
+
+		*p = 14;
+		t->v[i] = p;
+	}
+}
+
+static void kmalloc_alloc_then_free_test_p2(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < t->count; i++) {
+		u8 *p = t->v[i];
+
+		*p = 13;
+		kfree(p);
+	}
+}
+
+/*
+ * Allocate TEST_COUNT objects. Free them immediately.
+ */
+static void kmalloc_alloc_free_test_p1(struct test_struct *t)
+{
+	int i;
+
+	for (i = 0; i < TEST_COUNT; i++) {
+		u8 *p = kmalloc(t->size, GFP_KERNEL);
+
+		*p = 12;
+		kfree(p);
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
+	t->v = kcalloc(t->count, sizeof(void *), GFP_KERNEL);
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
+		int size, const char *name)
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
+		t->size = size;
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
+	pr_alert("%s(%d):", name, size);
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
+static int slab_test_init(void)
+{
+	void **v = kmalloc_array(TEST_COUNT, sizeof(void *), GFP_KERNEL);
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	int size;
+
+	pr_alert("test init\n");
+
+	pr_alert("Single thread testing\n");
+	pr_alert("=====================\n");
+	pr_alert("1. Kmalloc: Repeatedly allocate then free test\n");
+	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = kmalloc(size, GFP_KERNEL);
+
+			*p = 22;
+			v[i] = p;
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_alert("%i times kmalloc(%d) ", i, size);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles ", (unsigned long long) time);
+
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = v[i];
+
+			*p = 23;
+			kfree(p);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_cont("kfree ");
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles\n", (unsigned long long) time);
+	}
+
+	pr_alert("2. Kmalloc: alloc/free test\n");
+	for (size = 8; size <= PAGE_SIZE << 2; size <<= 1) {
+		time1 = get_cycles();
+		for (i = 0; i < TEST_COUNT; i++) {
+			u8 *p = kmalloc(size, GFP_KERNEL);
+
+			kfree(p);
+		}
+		time2 = get_cycles();
+		time = time2 - time1;
+
+		pr_alert("%i times kmalloc(%d)/kfree ", i, size);
+		time = div_u64_rem(time, TEST_COUNT, &rem);
+		pr_cont("-> %llu cycles\n", (unsigned long long) time);
+	}
+	kfree(v);
+#ifdef CONFIG_SMP
+	pr_info("Concurrent allocs\n");
+	pr_info("=================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(kmalloc_alloc_then_free_test_p1,
+			kmalloc_alloc_then_free_test_p2,
+			1 << i, "Kmalloc N*alloc N*free");
+	}
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(kmalloc_alloc_free_test_p1, NULL,
+			1 << i, "Kmalloc N*(alloc free)");
+	}
+
+	pr_info("Remote free test\n");
+	pr_info("================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(remote_free_test_p1,
+				remote_free_test_p2,
+			1 << i, "N*remote free");
+	}
+
+	pr_info("1 alloc N free test\n");
+	pr_info("===================\n");
+	for (i = 3; i <= PAGE_SHIFT; i++) {
+		do_concurrent_test(alloc_n_free_test_p1,
+				NULL,
+			1 << i, "1 alloc N free");
+	}
+
+#endif
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void slab_test_exit(void)
+{
+	pr_alert("test exit\n");
+}
+
+module_init(slab_test_init)
+module_exit(slab_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter and Mathieu Desnoyers");
+MODULE_DESCRIPTION("SLAB test");

