Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975D5606A332
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WmT6eooy
Received: by kanga.kvack.org (Postfix)
	id 8D9156B05D2; Tue, 27 Oct 2026 01:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A5C6B05D4; Tue, 27 Oct 2026 01:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778316B05D5; Tue, 27 Oct 2026 01:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 475F66B05D2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:48:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE531A0978
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:48:12 +0000 (UTC)
X-FDA: 85367325624.22.3A05AF0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB9F640002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:48:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WmT6eooy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793080090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hu1VVEuy5OK5yu8i0DtNiZ9pBzR9sETJXANmDoyRXnI=;
	b=u6MeeUSUi0yhEuyd3dRfdX5lhbRETFvnBX12hAazcacDCNwOrtnsiqKJV02lBDpsvILREV
	dGh+6FbrEEQ0q6ZxQXCUKAyImP+GKa/XsSx/hTrxriJqsmW4NjFfW5HGVcYn7lC5CbCmVR
	F9H3yd24OOZNiKLKrbGxNhHy9V2E3Xs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WmT6eooy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793080090;
	b=Iz5Z71/hQ1kkz2dogkd8z5LbGEtvg87/iIeEWSxB+VJqOndRfsKb2CrgeZsiK9Wf6naL6N
	RMJCJM9bkOni5yZdtO3AhEFx+ZGcBoD/pg1hE7Tok9u/QDL5lbzDYWCJpKlRPC+EXcfT0s
	fSqQOjEzkWq60blFdhOGa6ii9n/V+wE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8fe8e343fso21943465ad.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793080090; x=1793684890; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hu1VVEuy5OK5yu8i0DtNiZ9pBzR9sETJXANmDoyRXnI=;
        b=WmT6eooytIYz05O+W7tjwLSJoY0sgqlGLWkptHBKScSn1DigzmjSWAIuNGNMmiTG6O
         /jMzwNg7Co1M0KzaVSpFTc90YBMn6xnpttIy8h0g1ZeQxtUD1BHSWc4CDBpN+tCptml3
         Dqab6EZIV0ChYvUMc6RSwvG3ZVBNFgt6Bzzyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793080090; x=1793684890;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hu1VVEuy5OK5yu8i0DtNiZ9pBzR9sETJXANmDoyRXnI=;
        b=iQU0qMf09BjeLgdjbfE3X1BCfRXHFJ50qKjaw/IW9I5taWlS8wkULbU6N0zHY/v/2B
         eupH5Mgoh+1q93NR+t2AaKNHu1Fet2Bo7PGgGAY10t2c6dDwo/x3yRcyZUsB1bBHlEWp
         KVl9CQMmb2n6KT9wESsCb+km3ZBQbgclFgTjhDuMJBw89Hcs4dWQERwVxsov8a9BovPW
         os3QSFqEV8yn5DNm9eqd0xIFrJPDKjQ2qkkCro8iMZRvrvXk9vEJBHoH1t6Wz64KCxqw
         mmI38w9Nux2r2BtcOi2+3uyUFPRlslpxR+7FQcYQzupQj0kT0dAI8BTRcIK5zKui0eaN
         I9ag==
X-Forwarded-Encrypted: i=1; AKwUvBxLLvoNJenw45HMmc97P2tLpLmfh0HqPcedQt0Bndfsg7JRnOaaBm2N/vBD5G5WF6v1QyrEByqZ6Q==@kvack.org
X-Gm-Message-State: AFq9FYJFe3FnSH7RGDtdkZKJCQ8D047rLGQEB1z11VwnLcyvH03QceVb
	1/TkSS+LpT5IvBorfrhr55ZQKhze6IGrKJrfQjiaRhivPghUUX0F5ra5TxPCUkWqz7g=
X-Gm-Gg: AYBFou0CMEOQ972F/eZ8trN9ir3fjQZe0aXPaq+IfHfLENX6OTV/ykfxRcibkvQ1TPn
	ncdVDMSDgFDKGVgthXkMZ665dvLLQYsqwxCWfmmaVSAcif97Oy0iVfnoI6yiknlq647JMcFtdK1
	pCbO4zxoQvo4bEcwH/ESvn3I3+K68Cd1RNmYQ5DefJOhJ5PH/kzP6B168RRkrEp9rjGh8Jnn6PU
	jKpjpl3S0I+SKlzKWZj4rRoP0w3jKSa4roKOep3vlC8fg2TM4mw5EQeCK6kNptbzB61JcVIIh4W
	QckzamSUHdovgNGPAzea1WBDue/K6kuc4sMERdruyG1sCy6cFbY+xi2gzpvTAjT1c4kIhXXbLLV
	B69SDd4xCIhAsrTyUGsEIgA5ThLXFBs1mEEg64TTHCPsN68Z2sOMccyNfW52AQPo12GcWkZ3SN4
	Qm0nQXN30Wps+BOQweLOceg+8tq81khosjMoAnDQUPCi7isSAt8V8BQ5OPHU1KHeyJZ8v2Ulx2q
	xwV/y/4INsge0TNXwjmaJ2yW+WbOi+2zJWdLpbz8qvhx8R/nETU71a+WGRLqRzagCkNDc3U16x9
	ZpXMKdEGzpaNKJVBm/UtsFgwBNMMmu+qRnJ9Rf8SKmz6oFhFL6afDskO4KbZuoUYblVyDO3Ek/q
	UYnRSn3e01DjSI8x8JGkB5yQ=
X-Received: by 2002:a17:903:41c7:b0:2e2:cebe:d811 with SMTP id d9443c01a7336-2ea9c8c986bmr72303125ad.46.1793080089604;
        Mon, 26 Oct 2026 22:48:09 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c912f9sm3579065ad.60.2026.10.26.22.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 22:48:08 -0700 (PDT)
Date: Tue, 27 Oct 2026 13:48:05 +0800
From: Chris Down <chris@chrisdown.name>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] kfence: Allow selecting static keys mode at boot
Message-ID: <auA7FdubFEDVPB7v@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB9F640002
X-Stat-Signature: 1isz1w85ny8xsboik6gmx6necfr45aih
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793080090-705643
X-HE-Meta: U2FsdGVkX18qmNxdGHddnVi/By14buCWRBddfzVfm18UbiO3fB7jAICgyGrrxYpzqChoMnCuQ12CIedazeUSUNZ/xtx6qmCI29c6LHwrTXrrPLgcf8guKH/JdUfNEkNvx5DCXO+eQCZrjQfhivYn7tb4TeKZ7w8vEU0+/MwOfABedjcXWz8AE9EYkw2YV925BEMmuNc1ql+qkTotYvbC4PtRzO1ORK/kDTXluXuXjri/SAo6aflY7SHkc7VcxeTTDnCl+j6y3TKOZLR4jRdV3yqfi/xX5dc6lHDAGm2U5NqfbYSi3p7cBJoZa4/Kp3aC+XFlbZ6F0LJMKL4vFfjW4CqvF+9GcUidxArCBLq6qCp8mnUszV44kUKAc1mrzx7P0tPPjZunwuRqlrugxO+HvXj/dTrKZvjpRKiVQYeJ/zvSksq9KyJnj3kmVA8XT2MB72bkBQIYH9Dgl5Dp7kwEcSlmIzSfG65aof4TSrVWhYfp+fs07KFbkqOsFql16k2UbsK6YmMr97qFzZG2jaIUIMnhRcfaCFI7GY023J/nUHdoTqn0tHkz4G69APDMP395JYIwCgOG3LhUlzEFYJXe8Y55l8ugB+JuDN1OIozZ5zrqHAT4cjmlX+aWgatSpYjXa9UgWSKAB/LBhX1zJVq+x0zfY88lef5qEEeNArnyI5qD+pX8RAFMdN8rj2Uhl1r+HalhnP/Su0nmV5aVHob4RCh0PXd0NYw/oH5xSf0xIPg/8CyC2Sc3qgK+LlhchywNp2iv0KEJTR9unB9/2HusEReOAYknzzHyNFn1qqEr88IahbOFczwklFqmgQkLWHFKbzDZ1K7wONjpGnGbG8clmeukuRbznfyWW5H/vTBPMAQLV3imXPv2Vq108ZVnXxSh9nNUmMQ36O4bHnc+2AL2+hAeOp7nOSeQ123C5YOb3AXwILwLa3VLLGHGWmiM4+fpp63PV+OUYhrq1/nVJpZ
 DebqM9Vg
 Hwfbmvk4xp+ZglO4MPPso5wEZ9pzAGhe8IWKJZiLLoKGAIo0yNl/epyA0844Rry8kiuP1EJrIii82gXgIe8dqYWqhcwx1q+Di+yKESFihqVv/gDEgDOzY1L7s5vjZ9Spi36CEgJfA2acuiAF+/8pcUVEjlpOhZTWSO28Eei7BSnW8vTnzIDMuX19V4Wr/00Ajaedez2pXKRb/Xng9QZ1TFhxK1ybAu4tjn1b68IjrR5lZztWZCe3QM5Y6NjBtaMt/oPvk3BoTghtqDGLfnVFFQgzSVELRF+zo0VvtFAVn0gEqmK/WWEs3i0AmB2wzJ8OKYtn9eXig93Yc1P1BU6s3qDUAGJ0rcaBAG9L7AnKKIgBkYkR1MU/m4NnLEisyCKTDlnrKHSwwZ/+r4pCJAez7K0P5jVFLo2ABneY/r46OViJAC3DZ/bJKd5zxnddyOmqzPHR0nGer8M2PJ8eBQltSZp24Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KFENCE can gate allocations by toggling a static key for each sample, or
by leaving the key enabled and checking an allocation gate. Static keys
mode saves a load and compare per allocation, but sends IPIs to all CPUs
twice per sample interval.

Which tradeoff makes sense depends on the host. For example, on machines
with many CPUs or latency-sensitive workloads, the IPI cost can outweigh
the saving in the allocation path.

For this reason on some machines we prefer to have static keys, and some
we don't. However, today this is configurable only by
CONFIG_KFENCE_STATIC_KEYS, so this means building and shipping separate
kernels. It also for that reason makes comparing the modes on a
particular workload more cumbersome.

Let's add kfence.static_keys= as a boot parameter so that the mode can
be selected per host. The default still comes from
CONFIG_KFENCE_STATIC_KEYS.

Testing with the unoptimised branch layout showed no obvious changes in
performance across allocation sizes.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++
 Documentation/dev-tools/kfence.rst            |  9 ++--
 lib/Kconfig.kfence                            |  4 ++
 mm/kfence/core.c                              | 47 +++++++++++--------
 4 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e75344f4e0cd..cda98e1b0b68 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2989,6 +2989,12 @@ Kernel parameters
 			Format: <unsigned integer>
 			Default: 75
 
+	kfence.static_keys=
+			[MM,KFENCE] Whether to use static keys to set up
+			KFENCE allocations. Ignored without CONFIG_JUMP_LABEL.
+			Format: <bool>
+			Default: CONFIG_KFENCE_STATIC_KEYS
+
 	kgdbdbgp=	[KGDB,HW,EARLY] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
diff --git a/Documentation/dev-tools/kfence.rst b/Documentation/dev-tools/kfence.rst
index b03d1201ddae..15212ea1047d 100644
--- a/Documentation/dev-tools/kfence.rst
+++ b/Documentation/dev-tools/kfence.rst
@@ -259,10 +259,11 @@ SLUB) returns a guarded allocation from the KFENCE object pool (allocation
 sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
 the next allocation is set up after the expiration of the interval.
 
-When using ``CONFIG_KFENCE_STATIC_KEYS=y``, KFENCE allocations are "gated"
-through the main allocator's fast-path by relying on static branches via the
-static keys infrastructure. The static branch is toggled to redirect the
-allocation to KFENCE. Depending on sample interval, target workloads, and
+When using static keys mode (boot parameter ``kfence.static_keys=1``, which is
+the default with ``CONFIG_KFENCE_STATIC_KEYS=y``), KFENCE allocations are
+"gated" through the main allocator's fast-path by relying on static branches
+via the static keys infrastructure. The static branch is toggled to redirect
+the allocation to KFENCE. Depending on sample interval, target workloads, and
 system architecture, this may perform better than the simple dynamic branch.
 Careful benchmarking is recommended.
 
diff --git a/lib/Kconfig.kfence b/lib/Kconfig.kfence
index 6fbbebec683a..2b2ad21aa36c 100644
--- a/lib/Kconfig.kfence
+++ b/lib/Kconfig.kfence
@@ -70,6 +70,10 @@ config KFENCE_STATIC_KEYS
 	  enabling and disabling static keys invoke IPI broadcasts, the latency
 	  and impact of which is much harder to predict than a dynamic branch.
 
+	  Sets the default for the "kfence.static_keys" boot parameter.
+	  Selecting the other mode at boot adds one extra jump to each
+	  slab allocation's KFENCE check.
+
 	  Say N if you are unsure.
 
 config KFENCE_STRESS_TEST_FAULTS
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 55d5c114eadf..cfbefca5b78b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -119,6 +119,9 @@ module_param_named(deferrable, kfence_deferrable, bool, 0444);
 static bool kfence_check_on_panic __read_mostly;
 module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
 
+static bool kfence_static_keys __ro_after_init = IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS);
+module_param_named(static_keys, kfence_static_keys, bool, 0444);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -845,7 +848,6 @@ static struct notifier_block kfence_check_canary_notifier = {
 
 static struct delayed_work kfence_timer;
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
 
@@ -878,7 +880,6 @@ static void wake_up_kfence_timer(struct irq_work *work)
 	wake_up(&allocation_wait);
 }
 static DEFINE_IRQ_WORK(wake_up_kfence_timer_work, wake_up_kfence_timer);
-#endif
 
 /*
  * Set up delayed work, which will enable and disable the static key. We need to
@@ -897,17 +898,17 @@ static void toggle_allocation_gate(struct work_struct *work)
 		return;
 
 	atomic_set(&kfence_allocation_gate, -kfence_burst);
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-	/* Enable static key, and await allocation to happen. */
-	static_branch_enable(&kfence_allocation_key);
+	if (kfence_static_keys) {
+		/* Enable static key, and await allocation to happen. */
+		static_branch_enable(&kfence_allocation_key);
 
-	wait_event_idle(allocation_wait,
-			atomic_read(&kfence_allocation_gate) > 0 ||
-			!READ_ONCE(kfence_enabled));
+		wait_event_idle(allocation_wait,
+				atomic_read(&kfence_allocation_gate) > 0 ||
+				!READ_ONCE(kfence_enabled));
 
-	/* Disable static key and reset timer. */
-	static_branch_disable(&kfence_allocation_key);
-#endif
+		/* Disable static key and reset timer. */
+		static_branch_disable(&kfence_allocation_key);
+	}
 	queue_delayed_work(system_dfl_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
@@ -956,7 +957,7 @@ void __init kfence_alloc_pool_and_metadata(void)
 
 static void kfence_init_enable(void)
 {
-	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
+	if (!kfence_static_keys)
 		static_branch_enable(&kfence_allocation_key);
 
 	if (kfence_deferrable)
@@ -967,22 +968,29 @@ static void kfence_init_enable(void)
 	if (kfence_check_on_panic)
 		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-	register_reboot_notifier(&kfence_reboot_notifier);
-#endif
+	if (kfence_static_keys)
+		register_reboot_notifier(&kfence_reboot_notifier);
 
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
 
-	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
+	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p%s\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
-		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
+		(void *)(__kfence_pool + KFENCE_POOL_SIZE),
+		kfence_static_keys ? ", static keys mode" : "");
 }
 
 void __init kfence_init(void)
 {
 	stack_hash_seed = get_random_u32();
 
+	/*
+	 * Without jump labels a static key is just another dynamic branch, so
+	 * static keys mode would only add the cost of toggling it.
+	 */
+	if (!IS_ENABLED(CONFIG_JUMP_LABEL))
+		kfence_static_keys = false;
+
 	/* Setting kfence_sample_interval to 0 on boot disables KFENCE. */
 	if (!kfence_sample_interval)
 		return;
@@ -1175,10 +1183,10 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	allocation_gate = atomic_inc_return(&kfence_allocation_gate);
 	if (allocation_gate > 1)
 		return NULL;
-#ifdef CONFIG_KFENCE_STATIC_KEYS
 	/*
 	 * waitqueue_active() is fully ordered after the update of
-	 * kfence_allocation_gate per atomic_inc_return().
+	 * kfence_allocation_gate per atomic_inc_return(). There are only ever
+	 * waiters in static keys mode.
 	 */
 	if (allocation_gate == 1 && waitqueue_active(&allocation_wait)) {
 		/*
@@ -1187,7 +1195,6 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 		 */
 		irq_work_queue(&wake_up_kfence_timer_work);
 	}
-#endif
 
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;

base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
-- 
2.54.0


