Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D638CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBB66B009F; Mon, 18 Aug 2025 08:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CA26B00A0; Mon, 18 Aug 2025 08:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953F48E003F; Mon, 18 Aug 2025 08:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE856B009F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:29:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FC391186B9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:29:06 +0000 (UTC)
X-FDA: 83789807892.18.16604A1
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67F6040010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:29:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEZJQV8d;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWGhIiUrKxsgr5+uGk+m1lOyTRB3MBYIRFP+EnuGnws=;
	b=WjaKR06wFbkO7ZiMsVw4Ar/BvradB59MBfcoUN/TpsAFmZKPQVADAkT0OPFlyTjhlCEqOI
	QqfBalNwh1aAntEACjAr5qebheemRTfU4QcHv5jJIY2KIjUih+uf5S1Z26jKWiaKj63nqx
	5N6N39EcDGeaE6QhfVw6qH2ha9f015w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEZJQV8d;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520143; a=rsa-sha256;
	cv=none;
	b=NY47e4hE6lJlVuI7yN0SWY38BwjLUFaOTvRiM8T4vpvkKOMpDKJHH+CTgmos4EUl2Ssyqg
	qPSDLpZX4p4nh3P302cnTKQ89e3VU7ajgAPHXhgLrYGdEBptN46S/FsKWsKPoZxNn7mgFK
	StzBuJDGlPnY9cgOUYVTmxgwkYyPz2Y=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-244580523a0so34428685ad.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520142; x=1756124942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWGhIiUrKxsgr5+uGk+m1lOyTRB3MBYIRFP+EnuGnws=;
        b=aEZJQV8dSmGbjGSevs2gcpbChCRzXT8AQC3fQMpQVtgYCOciE/Ku1pjDj/cUKwbu0n
         WN75GK51vrpxRcVtBjaets6tBu+KFyOsX6wbOZPkXcDLpGPoqqgJC/XwJuNf7ztnNBTd
         EyARxSZ01JOSohDm9L1s6JZbghrBra2o0a/IEB8vFysdz2p7cLzQkUPiPY3aQRq6ubOG
         b4cDVtVEuFB/asR+HrBSPmIXoowOrqlBX2fPHs88ubF9I4UhQgRTI6j88/9DhPy9g2/l
         /1ZBJryfUHk2gNOAftaZ5/Os60nMNfm8SRcKUTHx8fzR3sC8rDz1NI5CcZ21imYMrcLo
         swvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520142; x=1756124942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWGhIiUrKxsgr5+uGk+m1lOyTRB3MBYIRFP+EnuGnws=;
        b=VkhNFsqktaTOu22Ak1vcyZcGY1UqH/wmIQDg1RBUmu8v+03eWANEhzMQSSaiqUBEoP
         LCbTxwDDUnoVnCfeY4dXt9TXvbREDNlKZWJ7+iKC2JWSfao3t1hQPjQ5nYzGO6AYU+ei
         zYlpmRz4BzmImHBecg5OC1ZLyCRcuijufIC3YXW1u1cbxFPJEnZkojLsQIEvfWZCGvFY
         tX8JC5AWJ8KGNawZBScgLHE3pSbKAXxtLqC4pqudkxvBMDV01tVuanXk2a5kPn14KUCy
         c+wNHmk2SHzhShtDectKlMMxd0RlwbYV+N8ZNFtyFUUwRqpJamyGc1ttM4Vm5g4jDAxF
         4n2g==
X-Forwarded-Encrypted: i=1; AJvYcCVmDgjv8uxwyNt2Oqr28PJK4D/C6Diudrsw66X2QZuMIZeWtZPEnodPqog59SwdHnTlBGq86xEtYQ==@kvack.org
X-Gm-Message-State: AOJu0Yxay40NuwG2fdWjJpaqJQ10ugCrnWqTYjMsuLYzTyCTSdiy/M5K
	jgscM5vxUQG+GWvNQ0vDFz/eP477PhHJFSPW4Tn+k6nv2NFTw3BXh3g1
X-Gm-Gg: ASbGncvvSuCIhJQsMZc9KjfzCnME/DhwhbeGlOso4AKk/mYzU6XarzzL0y8B4nOuYS8
	T7eBJTe7DU6tR4oUk8sW5P+aorBKoW12hpxUlXbY3tkiCCrZsIGzQqRYWDL0pR617egurNHlpAf
	Qj0yGpR96IsT8s2pjSKHO9wxUm8QVqNANpObVKk9lSUOv4dxosZBzr3Usbd+IJNvVVFvyRYNQ9W
	9QP50/McTgsHXvMK50ZcYgxNOziesgqa4uYtlMiqPXtIfjkoy0nbzCKSmwFUhFIyTqS2q/oFyqk
	bM/vxfn7fTQHRTK8gkDhsFAwvDKlHa/VNmQrDJGP9r0u7p8T/yLSTSNeLYBggIuJhSMW+RVWFgj
	sCxu6AiYpu9NGkPYZ9DMdE7oEAI22vK0/fQ==
X-Google-Smtp-Source: AGHT+IEtwU3EH40nw5zAQzPHHXzoiBUOdJKizYRpuvX2BrnKPMV4mvfPsFyaNhmOO6WxMZTmIw0cfg==
X-Received: by 2002:a17:903:32c8:b0:240:7fb:cb05 with SMTP id d9443c01a7336-2446d6eeb26mr162548755ad.10.1755520142112;
        Mon, 18 Aug 2025 05:29:02 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:29:01 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 13/13] mm/kstackwatch: Add a test module and script
Date: Mon, 18 Aug 2025 20:26:18 +0800
Message-ID: <20250818122720.434981-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-13-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250818122720.434981-9-wangjinchao600@gmail.com>
 <20250818122720.434981-10-wangjinchao600@gmail.com>
 <20250818122720.434981-11-wangjinchao600@gmail.com>
 <20250818122720.434981-12-wangjinchao600@gmail.com>
 <20250818122720.434981-13-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67F6040010
X-Stat-Signature: h8tqozqa4xww4ysw3q9incz6w9ajdps6
X-Rspam-User: 
X-HE-Tag: 1755520143-498084
X-HE-Meta: U2FsdGVkX1+c0Odw2th4ZaVdR2Dhq7YIpBrtONpVsZ1tftBqRZ437VlcB5fktl5D6Bd3LujtcrcEpmdS5+nq9CCukIE2Dk7Xi0SxH+Z+olVIIVNjxaQdRp0Q+zb60tPxGXuN1A8Q9wKtXXJaLiH5sk41hKfdbAQAmhox37rOwAcE3cdnrZwZFKT2XNhtdGQJUINA1klbHhMOZmpo0UeTcdP8ZhrS/fTGzBzhHqgwCJEhYb9ZV3/o6IdGAYPsHMHmWuKeE8BfxeeX13xEMRJULOPz5Lf0qDKihpH11AQ5jPzvv44c3TRN2z8LAmsDrKOZkpxusyVO1Lc96pI9BSnbOaxXHIVZp74VVXRPUNqYr4mzMPwhoPS10NQnzRxXyXKMXs9EBPERjfHcQVgLl3/hgl3C6cWZubIZoSEMd6taZuZbobNw3YyGHsfghu3/4B4wv4K7iKhxJDCawNVMeujeVOg1RyvOfYw1aAcqheHD6EHkPR50V1Gi9LkXzLo/3UZz8zpkevpq8f8c1qwJA4sFGN3hganVLSt49d/ra8qnS8KP6VNz79DhJuNsmtwBeV+ZbW5OAfJolqGtLIIIbUNJRKtFiwaSQT7x6Kz0x2q8c6RzhAWzJebXj5vgyTm79h1wfFNoGW0cbUjfNxvhVk2HlMLxtEzXaJdUTxv1MXLZWwv9cKhzsLFPjcj9wexBJKjTgmpESQPmE9cNzjMgPDOg2e0NO5xqy4gwkCT2DdJsJH0QXITq7eQPT64xhHg1V+qhlVL4LBs/9FyYNgINYxNFYs+3CGzFhrYS2tuoJ1igyf6fpnhQUzUT0zwhQBe8zprGq2w86NWvFm7zspMvDSgUvyTaYGzgz/EXJQXON7kqzBeFHsF7ICvbUc/eob1jDtQFsdiFfIvRkb4YPt3bgzkJEG36f/QLEvDRTNKOrLAno3v+zqYg3C31lhziiINagkmEjLKNWjiGoRyIldnLvti
 ExAe/8PO
 mIY/SK5brc2Ba6+XfRl6JW2OjpakHGxmfJNCHdVGkdP6rK9pyW1D+xP8ITJeKmuMTIS2RizAvl9Qy7Itpf5m1SDuK2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a test module and a helper script to verify the
functionality of the KStackWatch debugging tool.

The `kstackwatch_test.c` module provides a set of controlled scenarios for
stack-related issues, including:
- Direct write using ksw_watch_fire().
- Intentional stack overflow.
- Corruption of a local variable from another thread.
- Recursive function calls to test nested stack frames.

The accompanying `kstackwatch_test.sh` script automates the process of
loading the test module, configuring the KStackWatch tool via its debugfs
interface, and triggering each test case. This script also includes
instructions for users to find the necessary offsets for their specific
kernel build.

This dedicated test module and script significantly aid in the development,
validation, and long-term maintenance of the KStackWatch tool.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug                      |  11 ++
 mm/kstackwatch/Makefile               |   8 +
 mm/kstackwatch/kstackwatch_test.c     | 237 ++++++++++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh | 122 +++++++++++++
 4 files changed, 378 insertions(+)
 create mode 100644 mm/kstackwatch/kstackwatch_test.c
 create mode 100644 tools/kstackwatch/kstackwatch_test.sh

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index dd9c1bb7f549..5e9402e39001 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -321,3 +321,14 @@ config KSTACK_WATCH
 	  which is useful for debugging stability issues.
 
 	  If unsure, say N.
+
+
+config KSTACK_WATCH_TEST
+	tristate "KStackWatch Test Module"
+	depends on KSTACK_WATCH
+	help
+	  This module provides controlled stack exhaustion and overflow scenarios
+	  to verify the functionality of KStackWatch. It is particularly useful
+	  for development and validation of the KStachWatch mechanism.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
index 076822eb7661..5e63e8c2e7c0 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,3 +1,11 @@
 obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
 
 kstackwatch-y := kernel.o stack.o watch.o
+
+obj-$(CONFIG_KSTACK_WATCH_TEST)	+= kstackwatch_test.o
+
+kstackwatch-y := kernel.o stack.o watch.o
+CFLAGS_kstackwatch_test.o := -fno-ipa-sra -fno-inline \
+                             -fno-optimize-sibling-calls \
+                             -fno-section-anchors \
+                             -fno-pic -fno-pie
diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
new file mode 100644
index 000000000000..c21618ca0c8b
--- /dev/null
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
+#include <linux/string.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "kstackwatch.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Simplified KStackWatch Test Module ");
+
+static struct proc_dir_entry *test_proc;
+#define BUFFER_SIZE 4
+#define MAX_DEPTH 4
+
+/* Global variables for multi-thread test synchronization */
+static u64 *g_corrupt_ptr;
+static struct completion g_wait_for_init;
+
+/*
+ * Test Case 0: Write to the canary position directly (Canary Test)
+ * This function uses a u64 buffer
+ * 64-bit write, corrupting the stack canary with a single operation.
+ */
+static void canary_test_write(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KStackWatch Test: Starting %s with u64 write\n", __func__);
+	ksw_watch_show();
+	ksw_watch_fire();
+
+	buffer[0] = 0;
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+	pr_info("KStackWatch Test: Canary write test completed\n");
+}
+
+/*
+ * Test Case 1: Stack Overflow (Canary Test)
+ * This function uses a u64 buffer
+ * 64-bit write, corrupting the stack canary with a single operation.
+ */
+static void canary_test_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KStackWatch Test: Starting %s with u64 write\n", __func__);
+	pr_info("KStackWatch Test: buffer 0x%px\n", buffer);
+
+	/* Intentionally overflow the u64 buffer. */
+	buffer[BUFFER_SIZE] = 0xdeadbeefdeadbeef;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KStackWatch Test: Canary overflow test completed\n");
+}
+
+/*
+ * Corrupts the variable on multi_thread_corruption_test's stack
+ */
+static int multi_thread_corruption_thread2(void *data)
+{
+	pr_info("KStackWatch Test: Starting %s\n", __func__);
+
+	wait_for_completion(&g_wait_for_init);
+
+	pr_info("KStackWatch Test: Thread2  woke up. Corrupting variable at 0x%px\n",
+		g_corrupt_ptr);
+	if (g_corrupt_ptr)
+		*g_corrupt_ptr = 0xdeadbeefdeadbeef;
+
+	pr_info("KStackWatch Test: Thread2 finished corruption\n");
+
+	return 0;
+}
+
+/*
+ * Test Case 2: Multi-threaded Local Variable Corruption
+ * multi_thread_corruption_test initializes a local variable
+ * makes its address globally available,
+ * and then sleeps. Thread B corrupts it.
+ */
+static void multi_thread_corruption_thread1(void)
+{
+	u64 local_var = 0x1234567887654321;
+
+	pr_info("KStackWatch Test: Starting %s\n", __func__);
+
+	pr_info("KStackWatch Test: Thread1 local_var address: 0x%px, value: 0x%llx\n",
+		&local_var, local_var);
+	WRITE_ONCE(g_corrupt_ptr, &local_var);
+
+	/* Signal Thread 2 that the pointer is ready, then sleep */
+	complete(&g_wait_for_init);
+	msleep(1000);
+
+	pr_info("KStackWatch Test: Thread1 woke up. Final local_var value: 0x%llx\n",
+		local_var);
+}
+
+static void multi_thread_corruption_test(void)
+{
+	struct task_struct *corrupt_thread;
+
+	pr_info("KStackWatch Test: Starting %s\n", __func__);
+
+	/* Reset completion */
+	init_completion(&g_wait_for_init);
+
+	corrupt_thread = kthread_run(multi_thread_corruption_thread2, NULL,
+				     "corruption_b");
+	if (IS_ERR(corrupt_thread)) {
+		pr_err("KStackWatch Test: Failed to create corruption thread\n");
+		return;
+	}
+	multi_thread_corruption_thread1();
+}
+
+/*
+ * Test Case 3: Recursive Call Corruption
+ * This function calls itself recursively and corrupts the stack at a specific depth.
+ * This tests whether KStackWatch can handle dynamic stack frames.
+ */
+static void recursive_corruption_test(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KStackWatch Test: Recursive call at depth %d\n", depth);
+	pr_info("KStackWatch Test: buffer 0x%px\n", buffer);
+	if (depth <= MAX_DEPTH)
+		recursive_corruption_test(depth + 1);
+
+	buffer[0] = depth;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KStackWatch Test: Returning from depth %d\n", depth);
+}
+
+static ssize_t test_proc_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *pos)
+{
+	char cmd[256];
+	int test_num;
+
+	if (count >= sizeof(cmd))
+		return -EINVAL;
+
+	if (copy_from_user(cmd, buffer, count))
+		return -EFAULT;
+
+	cmd[count] = '\0';
+	strim(cmd);
+
+	pr_info("KStackWatch Test: Received command: %s\n", cmd);
+
+	if (sscanf(cmd, "test%d", &test_num) == 1) {
+		switch (test_num) {
+		case 0:
+			pr_info("KStackWatch Test: Triggering canary write test\n");
+			canary_test_write();
+			break;
+		case 1:
+			pr_info("KStackWatch Test: Triggering canary overflow test\n");
+			canary_test_overflow();
+			break;
+		case 2:
+			pr_info("KStackWatch Test: Triggering local variable corruption test\n");
+			multi_thread_corruption_test();
+			break;
+		case 3:
+			pr_info("KStackWatch Test: Triggering recursive corruption test\n");
+			/* depth start with 0 */
+			recursive_corruption_test(0);
+			break;
+		default:
+			pr_err("KStackWatch Test: Unknown test number %d\n",
+			       test_num);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("KStackWatch Test: Invalid command format. Use 'test1', 'test2', or 'test3'.\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t test_proc_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *pos)
+{
+	static const char usage[] =
+		"KStackWatch Simplified Test Module\n"
+		"==================================\n"
+		"Usage:\n"
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary test test\n"
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n"
+		"  echo 'test2' > /proc/kstackwatch_test  - Multi-threaded local variable corruption test\n"
+		"  echo 'test3' > /proc/kstackwatch_test  - Recursive corruption test\n";
+
+	return simple_read_from_buffer(buffer, count, pos, usage,
+				       strlen(usage));
+}
+
+static const struct proc_ops test_proc_ops = {
+	.proc_read = test_proc_read,
+	.proc_write = test_proc_write,
+};
+
+static int __init kstackwatch_test_init(void)
+{
+	test_proc = proc_create("kstackwatch_test", 0644, NULL, &test_proc_ops);
+	if (!test_proc) {
+		pr_err("KStackWatch Test: Failed to create proc entry\n");
+		return -ENOMEM;
+	}
+	pr_info("KStackWatch Test: Module loaded, use 'cat /proc/kstackwatch_test' for usage\n");
+	return 0;
+}
+
+static void __exit kstackwatch_test_exit(void)
+{
+	if (test_proc)
+		remove_proc_entry("kstackwatch_test", NULL);
+	pr_info("KStackWatch Test: Module unloaded\n");
+}
+
+module_init(kstackwatch_test_init);
+module_exit(kstackwatch_test_exit);
diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100644
index 000000000000..33ca590b7374
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,122 @@
+#!/bin/bash
+
+# --- Usage function ---
+usage() {
+    echo "======================================"
+    echo "  KStackWatch Test Script Usage"
+    echo "======================================"
+    echo ""
+    echo "IMPORTANT: Before running, make sure you have updated the offset values!"
+    echo ""
+    echo "To find your offsets, use objdump:"
+    echo "  objdump -S --disassemble=canary_test_write vmlinux"
+    echo ""
+    echo "Then search for your function names to find the instruction addresses."
+    echo "- Instruction offset: address relative to function's start"
+    echo "- Stack var offset: distance from stack base (%rbp) to the variable"
+    echo ""
+    echo "Usage: $0 [test_case_number]"
+    echo ""
+    echo "Available test cases:"
+    echo "  0  - Canary Write Test"
+    echo "  1  - Canary Overflow Test"
+    echo "  2  - Multi-threaded Local Variable Corruption Test"
+    echo "  3  - Recursive Corruption Test"
+    echo ""
+    echo "======================================"
+    echo ""
+}
+
+# --- Interactive menu ---
+show_menu() {
+    echo "Select a test case to run:"
+    echo "  0) Canary Write Test"
+    echo "  1) Canary Overflow Test"
+    echo "  2) Multi-threaded Local Variable Corruption Test"
+    echo "  3) Recursive Corruption Test"
+    echo "  q) Quit"
+    echo ""
+    echo "WARNING: Each test may cause system crash/hang!"
+    echo ""
+    read -p "Enter your choice [0-3/q]: " choice
+    echo ""
+
+    case "$choice" in
+        0) test0 ;;
+        1) test1 ;;
+        2) test2 ;;
+        3) test3 ;;
+        q|Q) echo "Exiting..."; exit 0 ;;
+        *) echo "Invalid choice. Please try again."; echo ""; show_menu ;;
+    esac
+}
+
+# --- Test Case 0: Canary Write ---
+test0() {
+    echo "=== Running Test Case 0: Canary Write ==="
+    # function+instruction_off[+depth] [local_var_offset:local_var_len]
+    echo "canary_test_write+0x19" > /proc/kstackwatch
+    echo "test0" > /proc/kstackwatch_test
+    echo ""
+    echo "-------------------------------------"
+    echo ""
+}
+
+# --- Test Case 1: Canary Overflow ---
+test1() {
+    echo "=== Running Test Case 1: Canary Overflow ==="
+    # function+instruction_off[+depth] [local_var_offset:local_var_len]
+    echo "canary_test_overflow+0x19" > /proc/kstackwatch
+    echo "test1" > /proc/kstackwatch_test
+    echo ""
+    echo "-------------------------------------"
+    echo ""
+}
+
+# --- Test Case 2: Multi-threaded Local Variable Corruption ---
+test2() {
+    echo "=== Running Test Case 2: Multi-threaded Corruption ==="
+    # function+instruction_off[+depth] [local_var_offset:local_var_len]
+    echo "multi_thread_corruption_thread1+0x2b 0:8" > /proc/kstackwatch
+    echo "test2" > /proc/kstackwatch_test
+    echo ""
+    echo "-------------------------------------"
+    echo ""
+}
+
+# --- Test Case 3: Recursive Corruption ---
+test3() {
+    echo "=== Running Test Case 3: Recursive Corruption ==="
+    # function+instruction_off[+depth] [local_var_offset:local_var_len]
+    echo "recursive_corruption_test+0x2b+3 0:8"  > /proc/kstackwatch
+    echo "test3" > /proc/kstackwatch_test
+    echo ""
+    echo "-------------------------------------"
+    echo ""
+}
+
+# --- Run all tests ---
+# Removed: These tests cause system crashes and should not be run sequentially
+
+echo 7 > /proc/sys/kernel/printk
+
+# --- Main ---
+if [ -z "$1" ]; then
+    usage
+    echo ""
+    show_menu
+else
+    case "$1" in
+        0) test0 ;;
+        1) test1 ;;
+        2) test2 ;;
+        3) test3 ;;
+        help|--help|-h) usage ;;
+        *)
+            echo "Error: Invalid argument '$1'"
+            echo ""
+            usage
+            exit 1
+            ;;
+    esac
+fi
-- 
2.43.0


