Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4049CC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552F06B009D; Wed, 19 Aug 2026 03:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529D56B009F; Wed, 19 Aug 2026 03:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440446B00A3; Wed, 19 Aug 2026 03:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2346B009D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:05:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B376AA1CED
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:51 +0000 (UTC)
X-FDA: 85117134102.27.030F531
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0048B80007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKzyhHHr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3zFWFaggKCOcSJbXWVRdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jasonmiu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3zFWFaggKCOcSJbXWVRdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r13rbsEeTBQUt7C0+umCAD05cQ1RPgR2iUrqqxSlQbQ=;
	b=Ld0m3wfgceXc68N2Nqx31CLOsNwdYgix9Mua7SsnMicX6AMAL/CpPyqSZkPhGRdQHsL9N3
	Kc/hxinx6Ur/cNakX0jqdw1jeH1pHnhFWujKHYTbSZH75Zp7Ro3RwxM0IT+sp+9UTwYc3b
	p0pd2UZDshBkgXmZ/CXuTji7/VxYudc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKzyhHHr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3zFWFaggKCOcSJbXWVRdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jasonmiu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3zFWFaggKCOcSJbXWVRdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123150;
	b=Ubz9LFl1TjjgDtVTqnpii5HQQV5OazznA3kpnLbXz38MnTUpdMmi3H11tf8Khp4HtpuwWN
	/kp+dyN0dU9mrFAP/CeBNhrSjIHSTXkmMjmPvlp7+sg02KTtXWq9E5edLJgyrCPB+tpKM6
	bFRgU3jUpSbNYrIVLyKsNOK/eenv9sQ=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso776579a91.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787123149; x=1787727949; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r13rbsEeTBQUt7C0+umCAD05cQ1RPgR2iUrqqxSlQbQ=;
        b=OKzyhHHrRxVRa4GMUrwk+l9cqlBF2eB7DE5vHOs9vX7/UnViTh+8ysuNV5tO7yShom
         fTX6gcTpHDKEX3+hR62TNHPx724ps2FbtJZ5qOmC/m6iZwGYeP3PZZZQKXewG+UYSaNH
         9U7o9OJLARi2i2kld5lQog4LYA5UTzLt0hbnWCoMrBszbDYquTVHPJqIqtvBA5WFp3kV
         N2ZRVpsWL/XD0dNxYPX+I0z8xwYQ9UrJqbDlb8j7ZWSLgst9t0Iduu2dkTPZwjXd8wcz
         VmNIB4eGRcw7S4ak96K21R/iA5STIp4Ulnp2QcbYiIN1hiLBhSr/0wUnRuTdNUq2Dd0v
         OUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123149; x=1787727949;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r13rbsEeTBQUt7C0+umCAD05cQ1RPgR2iUrqqxSlQbQ=;
        b=ARxIKRLVEJFnRpn5ywa0V29vVC+6iHFrCqX2ZDnv3NI6Re6q2rwb1q7O56DXfiEOMA
         OlWlJhISYa2viRRK3ryiTX7re12LRynTRrIf/H09AVVYwMdDMoMzn5zJPkLe3YHOt98k
         agGjEeA2/EeHFAhe+Nq6DsN3vF3D+JmzcFBsUxhYlL+pbxbFAwGPpfENbPJq/KST8tnn
         EP8jhtAhoRhwCiEzz4e4RTCBFQresVnEkiIZfVikw7DQS9ma3DdRTPUDc7vLlVKh1KkR
         Zc8Zd8CZrqoMd1VM5Sexkl045+pTegjNJR8o9AJkZGRU5cuTBxYkMe4g0AicgYSHpzyo
         9f5Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr+veg4if2sq/HS7WnSUH2+Jtcb/Ntv6+BNhPuEkJ3td/OM/bcocsF1HYKtZI3tI+5CFzqBHWW7RQ==@kvack.org
X-Gm-Message-State: AOJu0YzDblex2ycAnCBfJGE9Nux4HjdFixMwZiUdiWBwxptd/9Z/hW65
	VIiZFU57HgbgVktkzNu2KWGYjxObpRl3MbCqNRkT8gdeBj2X/jFxTDGhb1NoB73GUEX3vUc1Sx3
	+tMXvmyHQKq3/7w==
X-Received: from dybhl1.prod.google.com ([2002:a05:7301:2701:b0:327:eee:4918])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a46:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-3958083fc60mr4701528a91.4.1787123148550;
 Wed, 19 Aug 2026 00:05:48 -0700 (PDT)
Date: Wed, 19 Aug 2026 00:05:36 -0700
In-Reply-To: <20260819070538.2404983-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260819070538.2404983-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.55.0.737.g08866a6d13-goog
Message-ID: <20260819070538.2404983-2-jasonmiu@google.com>
Subject: [PATCH 1/3] lib/test_mempress_timer: add module to generate kernel
 allocation pressure
From: Jason Miu <jasonmiu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Greg Thelen <gthelen@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: nm5554k4fhxcstgckxzj9jk95bdzpt4i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0048B80007
X-HE-Tag: 1787123149-734589
X-HE-Meta: U2FsdGVkX19HcFaDCYvCCHxt2G9P3mbpvGMXqdDuzSz0WKzMn5hnWWtGG69cxcrtdTzqV+0w4EXPnvjS9oBijp2tvQzdiEWxE7MFArntqreIC9zzHJkqGMXjPp52s7NkHWTpz70DUytJlgfG24sxO9RN8aQJmGUlgMRMx/51BH4xRMZJsMba1WPcUONmQkgEM9qIUhnCJg+owQIeJizD6ifPkgfuEhOuyEcjdL+sPM1yDub0HlShQXBx2c6v10wkVfUVOO6Zx5AyOLC2d8PZp431vrxVHob5q5A4Oj7YlvIVshoNbHL9x/dGo+Yb9ofIRp3LWCgGLq9GsGF9pcBR0k6zTWPU/6sn0qNsWBcRkMXJtNBa01i9rRZH+EprmxRzdcL2ZRwGYbzj0YVkLhFOKHHA0nwf9t5DlubY1XY2+miM9grA458c24JE/ykllMIKCX5/px/yBAUiAknj7rh/CN+A4RZ1W2HRyoBnn2YKPiEz/rKNfrqX+LfFpIymcfo0rYrU6HGe7C81bvFhqiOt+CJruQY5Zj57TIZG9SVvKDmWIyty/w/pG3fZRsBNWwryu21DJ+bYbWaSjKqvcmNcTuZuDzizE+ZXL9FIefB33ZvMKRI25DJJoUez3AUQGKQ8oCnMY/cUI7Xa0QCPEFDue8LPhak1Ntn8j2PjG7An+oPABUTK2o1lOtpjPcWK8tBunFSCR6FrKibNbSEk7QrPH8mmi3flz89z5jx5Is+L6ufAYD4X8afteVHhYkqEJdBTB2Cv6tmLDbFph5wB3Fk7OU/onaEduqhecDLeu4qsmUuLKCrGJLsbfzag+repWvhutwFFzvjK/DR+RfIfPpi2Ocs+PYhwf/xWpUv2ZRGCVnO/e0nPYtLepMLTEpFTn0keEy4EoU/bTfDOY/VKtfKyfw8KT53HWN0I/kKd4JseeITPD8E/balwzbVvnPnvD1tzM+EbZbf2xWgA4xK5qSo
 ZkDZEpiF
 fHQ3l5APBhF7A34VPiwuOfV824mhddBS4S97x1ortaecoHn618uBJLZ/9VZfsc3qjacVr0Zf8kkvSa4aDCo0KIS3wQhSpwjFUSeUMjBRRs/bYu6ujyg1wgaaQy2HqIrglGioh7fbwA79UoyHskwXxREE3yTpAPxn3Hvp0t0KQ3FOl20gL1bts0yMtRCCuUqlanNcMHbWsYJxTqOsmfETXUgllSa3uP594+IInTcaNkzFCmlm+598j8I5FFO8otAZXC9i7pgIf5+oCc6XR+87xNVuPampt34NB7uUkMSAgpKXWhEtY6VwJVFBbVgnRXW3Iv4so671kRk97+vY2NGXy0TK4VN4kGqNIJuEm6bnrBEgmD7Md9/CWPafWIMbA8orPN0vSWDtpAL/p8qbABFwKr4GnvUA7dT1Z31QAZzLLa3Z2wdIpTZ60yo4Xs5dZ8p1lYiGYimEo+cQ6Uw0tJhWP/ycc7/s7s2l2491EpZHbD3TXIhykIbL/npO61FkaAhJPKCT+MIRAQ/Z0SQYb6w/HFt0itrRu4dk90L+FLoxVXB1Amz06o+X0CkOuwKMmyfj2AieY1KPGw4uIDHlZwTNFVoN5gjAp7RqKvx2Qc+fLUBks1Mz6qhcuLoMj5sN1PGE3uKWiPCVfo4mYXic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update lib/Kconfig.debug and lib/Makefile to introduce
test_mempress_timer, a kernel testing module designed to generate
synthetic memory allocation pressure within SoftIRQ contexts.

Bind independent timers to each online CPU to continuously execute
atomic page allocations (GFP_ATOMIC | __GFP_NOWARN). Provide this
workload generator to repeatedly emulate heavy kernel allocation demands.

Add a configurable termination threshold (test_duration_secs) to prevent
permanent test-node lockups, and provide batching control via the
allocs_per_iteration module parameter.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 lib/Kconfig.debug         |  11 +++
 lib/Makefile              |   1 +
 lib/test_mempress_timer.c | 140 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+)
 create mode 100644 lib/test_mempress_timer.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1244dcac2294..00d32012e476 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2635,6 +2635,17 @@ config TEST_BITOPS
 
 	  If unsure, say N.
 
+config TEST_MEMPRESS_TIMER
+	tristate "Test module for memory pressure and allocation stall timing"
+	default n
+	help
+	  This builds the "test_mempress_timer" module that can be used to
+	  provoke and profile page allocation stalls and direct reclaim
+	  slowness. It periodically does a atomic page allocation to generate a
+	  memory pressure.
+
+	  If unsure, say N.
+
 config TEST_VMALLOC
 	tristate "Test module for stress/performance analysis of vmalloc allocator"
 	default n
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94..0f35c2b78970 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -78,6 +78,7 @@ CFLAGS_test_ubsan.o += $(call cc-disable-warning, unused-but-set-variable)
 UBSAN_SANITIZE_test_ubsan.o := y
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
+obj-$(CONFIG_TEST_MEMPRESS_TIMER) += test_mempress_timer.o
 obj-$(CONFIG_TEST_VMALLOC) += test_vmalloc.o
 obj-$(CONFIG_TEST_WORKQUEUE) += test_workqueue.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
diff --git a/lib/test_mempress_timer.c b/lib/test_mempress_timer.c
new file mode 100644
index 000000000000..a102ac4f6725
--- /dev/null
+++ b/lib/test_mempress_timer.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * test_mempress_timer.c
+ *
+ * Simulates kernelspace memory allocation pressure via timers.
+ * This module binds individual timers to each online CPU to independently
+ * allocate and free physical pages concurrently. It serves as a workload
+ * generator to reproduce and measure page allocation stalls under system
+ * memory contention.
+ *
+ * Module Parameters:
+ *  - allocs_per_iteration: Number of atomic page allocations executed
+ *                          during each timer callback.
+ *                          Default: 1000
+ *  - test_duration_secs:   Total duration in seconds to run the pressure test
+ *                          before automatically disengaging.
+ *                          Default: 900 (15 minutes)
+ *
+ * Usage:
+ * insmod test_mempress_timer.ko test_duration_secs=900 allocs_per_iteration=1000
+ */
+
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/proc_fs.h>
+#include <linux/skbuff.h>
+#include <net/tcp.h>
+
+struct mempress_timer {
+	struct timer_list timer;
+	struct list_head list;
+	struct list_head page_list;
+	int cpu;
+};
+
+static LIST_HEAD(timers);
+static bool stop_timers;
+
+static unsigned long interval = 2;
+
+static unsigned long allocs_per_iteration = 1000;
+module_param(allocs_per_iteration, long, 0444);
+
+static unsigned long test_duration_secs = 900; /* 15 mins default */
+module_param(test_duration_secs, ulong, 0444);
+
+static unsigned long end_jiffies;
+
+static void alloc_pages_atomics(struct mempress_timer *test)
+{
+	int i;
+	struct page *page;
+
+	for (i = 0; i < allocs_per_iteration; i++) {
+		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+		if (!page) {
+			pr_warn("page allocation failure from cpu %d at iteration %d\n",
+				test->cpu, i);
+			break;
+		}
+		list_add(&page->lru, &test->page_list);
+	}
+}
+
+static void free_pages_atomics(struct mempress_timer *test)
+{
+	struct list_head *page;
+	struct list_head *iter;
+
+	list_for_each_safe(page, iter, &test->page_list)
+		__free_page(container_of(page, struct page, lru));
+	INIT_LIST_HEAD(&test->page_list);
+}
+
+static void atomic_timer_allocator(struct timer_list *timer)
+{
+	struct mempress_timer *test = timer_container_of(test, timer, timer);
+	bool is_expired = (test_duration_secs > 0 &&
+			   time_after(jiffies, end_jiffies));
+
+	if (list_empty(&test->page_list) && !is_expired)
+		alloc_pages_atomics(test);
+	else
+		free_pages_atomics(test);
+
+	if (!READ_ONCE(stop_timers) && !is_expired) {
+		test->timer.expires = jiffies + interval;
+		add_timer_on(&test->timer, test->cpu);
+	} else if (is_expired) {
+		pr_info_once("Duration (%lu secs) reached, stopping.\n", test_duration_secs);
+	}
+}
+
+static int __init mempress_timers_init(void)
+{
+	int cpu;
+	struct mempress_timer *test;
+
+	if (test_duration_secs > 0)
+		end_jiffies = jiffies + (test_duration_secs * HZ);
+
+	for_each_online_cpu(cpu) {
+		test = kzalloc(sizeof(*test), GFP_KERNEL | __GFP_NOFAIL);
+
+		timer_setup(&test->timer, atomic_timer_allocator, 0);
+		list_add(&test->list, &timers);
+		INIT_LIST_HEAD(&test->page_list);
+		test->cpu = cpu;
+
+		/* For start, use 90 seconds. */
+		test->timer.expires = jiffies + (90 * HZ);
+		add_timer_on(&test->timer, test->cpu);
+	}
+
+	return 0;
+}
+module_init(mempress_timers_init);
+
+static void mempress_timers_exit(void)
+{
+	struct mempress_timer *test, *n;
+
+	pr_crit("exiting\n");
+	stop_timers = true;
+
+	list_for_each_entry_safe(test, n, &timers, list) {
+		timer_delete_sync(&test->timer);
+		list_del(&test->list);
+		cond_resched();
+		free_pages_atomics(test);
+		kfree(test);
+	}
+}
+module_exit(mempress_timers_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Test memory pressure from timers");
-- 
2.55.0.691.gc56d675ccc-goog


