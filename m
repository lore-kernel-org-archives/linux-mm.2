Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C499CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2884F6B00B5; Mon, 28 Sep 2026 13:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238B36B00B6; Mon, 28 Sep 2026 13:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100D26B00B7; Mon, 28 Sep 2026 13:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFBC86B00B5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C00D140292
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:10 +0000 (UTC)
X-FDA: 85263889620.22.95696E1
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCF1CC000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKq2akpQ;
	spf=pass (imf28.hostedemail.com: domain of 376a6aggKCIQ0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=376a6aggKCIQ0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvWsjS4kJdvoXcVGD6geTFWpf+d6azd0mBr60JzC1QM=;
	b=riRANflZxxXdQcCIYtkRfw7e2dyzniCkWDS4fbdT9RoVtIBiWVqNrd/9QVysICNad4ICCy
	jGzNfbc+aYU/Q9+O6YF90HWgT48IOILxCyTyvl/c3iDpZnjyfGaqDZ5ILTIg+mJhqLPyd2
	jt5+pZamTHTXs4yOVNdlN0fcxJBhWlY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKq2akpQ;
	spf=pass (imf28.hostedemail.com: domain of 376a6aggKCIQ0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=376a6aggKCIQ0uw01iniowwotm.kwutqv25-uus3iks.wzo@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617328;
	b=D1ahamHqBrgsZIoLGA5D2xWAhNRDJmVOfW9Lx9d3/5lnmNz4ioRm8TPvV+Ddy4hYr6kJiV
	36vZW7oACf8SFVzBsXM9AAI7JJEcglVGkHTHie0aew3MfF/P7NGvABUzXI10Da3wzRBpA3
	SB2XY4GyuFjMdJZBtv6FZHAiWf26H7o=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49fff093efcso25655925e9.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617327; x=1791222127; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GvWsjS4kJdvoXcVGD6geTFWpf+d6azd0mBr60JzC1QM=;
        b=TKq2akpQN4bl7wi3njWjpwthuQ/0ZImSTChzVKbxwIwSWmdlqjlgb4By56h1SCGttd
         FzwtjiP4hE0utxXa819iEi6uGAJmQ5uSIyIaleQul8IHPzL0KtAwBIdQMkRH2GSJtNdJ
         k6LuAxD/BJC8tMsFR5Xp3iCkiFbKioTtqQtnIPy3W6CVf48eDl1w91DqpzCQU8cQ9fw/
         dKm4fTP3Sm/5GERDQaCj43WHLRmEFoQFFIJ+5EFOa+GzoyUORYV/jgALTXrnxqe+YzdK
         upH7Df2VO/v2UFuCep2PNTpPZrJ2avFH7v3G75YFHEruqG1e9slBTn9befrPYv3W8+y7
         Oosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617327; x=1791222127;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GvWsjS4kJdvoXcVGD6geTFWpf+d6azd0mBr60JzC1QM=;
        b=RCbwxEBiwPj2HK6Jbgin3F3Xh33Hvant+am5S9Whfl9mOT4coCat7ZyLNF0NMDRYwa
         xSDB4gjSZEciEX5AUk3jKKEjGA1AqHTp4dHJHy+U66L4C5IjU5exmBgiUyZyYOElE78r
         3ILlLIHXQQEF2AtVlAZEISvUh7mWYiyPLBTuoHwS3vxO15i5/hIn93zuVsGI1KvoPL9+
         B658HDq43TYOY9HNc+bzNNpqKDp/ouBbSADHnwo0o8rC3rTv3pJ77lY2Ekge5Su0ifYW
         pjk/XT5+m6kLd/syv14bPiXcgcE/lukby7wmZTxrVExKOf2M9O/Ih3r64cRtIXSowvj2
         2IdA==
X-Forwarded-Encrypted: i=1; AKwUvBwODVpC7ZM6P+ULsRLBg6SnRzrNqzv4+9g9cyof2se88Rycna7FNGzsumFaNAwWgIGt0wQKOfBKOg==@kvack.org
X-Gm-Message-State: AFuF++mE/Gpx5isAbAxSY4QO1ZS1t56pN1f/JB8Hj0AlwRGF2ztNn/aE
	YmwSihB3v97Ov7IMFzLmJJNittGALnPg2DkLU8rJiA/qHUKLlrP9s75TVI0KSjkawtE8LpSfDQv
	n5HXxnNqE8nTIDA==
X-Received: from wmpr40.prod.google.com ([2002:a05:600c:3228:b0:49f:fde6:649f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6287:b0:49d:827:e5b6 with SMTP id 5b1f17b1804b1-49fe7babaadmr223084505e9.20.1790617327143;
 Mon, 28 Sep 2026 10:42:07 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:22 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-16-smostafa@google.com>
Subject: [RFC PATCH 15/15] arm64: mm: Set stack size from the kernel command line
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5ephx5ob3y1qc4mctc4fokxytdiockk7
X-Rspamd-Queue-Id: BCF1CC000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790617328-9112
X-HE-Meta: U2FsdGVkX180p+kqOB1rycwUL+IHZAk8HwP+19w2WGU3oB1gUTT09WYgARfu+DW2vXl8CCyB9MJjj/CG3qjwlUZ3bcRerhFqIzXUg8r5r57kLIiv3C7vUdtcYjJwiIild2MShYH5GPFVslhMuCwI85ISmk10mvon5B3ZOqirR8tuiAyqKt8YR5ntv3Ip8aQxMKmxD2wPwhSGX7BCJYstgLtUww1b6rS9FC2IGRiRPLBrV06/pXIBCl0JJYcHXWHcz+beijGQm+IBB7jiDKxpUxrVDbo4MNS7jydaLF+nP7HFJsmXf/wHubjJ0lC3CMxGlULdS4t2qDKaK873MKitYN32GqRbgk5eOF0Sc5HbsiSkNKNOvlSKpCmheiGyIP0wTSoQGAwKwZhth2ebOrAS1ys/VWHICkfFEmRvgY5p4aHaj/PqMZ7IM5MQLNu3keMuvcCcVAYFc9prv19ZSg/d5z1yCo7kMR973F6TwO6EAfk7QjJyp41VyvFieT4AuPsWULm7eUEiqQ3t4a+LKgLdh1Z8dJFgeznYPcjm6uLhh/3umoo6tBwAXKgUk7Z7iX2Fp1fx3bQDpmG2TGAIamAnUR3F6bV9sxhkRD24CjWDDvhPpN9wWqJT10GX3BW1WNmUEgU83KxkddCGk6+jst3CBTK4QAsnQ0lv1xtMWjsaLTnCF827yWRaiDtQ+6imj3NONmdCBUsY9Wl9qmuH1AP/obaEPD4X8vRTLe3+T+phX/JC0t+T4MiFUnYR5eQ++KjjQhkHKA7Yck7KJbOz6KZY3zyu9/wT2Y/9AaIPuVcrFUOcYi5a2XjJPNKg7+Qgt6mbDNiedGmcgAlZlRx03L1+Raq6qlIL9F7JLxZge1wVNdXO47+LQHegMyBSPAL7VTfjHLbl4IjySNQMod2kJyx9LeIHh7px1RWYpSFZJxf5IoI0j3NooV9/DSc27V4w2ETXyP6mUIJ9jpdhoewhJM3
 P4MgC5nu
 jU6uH+VL/B9+yN7XQgH3X9WNN4znaE2q+fmeCNAn+LYYWVUuYdkRNrJ+K+HJD1LRg61LyZieDhJjJzU4wEOzJ0fVtPHWIIYIX/I/q438l5xKH1HH5euasUsWNqQxaz/PO6c45rGaew+X6fNRjvDdN0gjmaryGGcSs5TKF0ttOPfofCJRt2rYL2J2dY1KjVYqvFPZT6pdRhRURucfJSsTcZJ8coXr5NwOzTJu6AZeRBxb1yeUPUn3RZ0JOm4LhdbJgH9f6hawcM8ngaVScZ5bcdfNpdEQwvcWzyy3Op7X0H6fhAixqcclJsYLvV6M2YGbgyTLM3vgL1iRFHCp7NBOgEc9mt1gGiOY5MzbcHoFBrAog0RQ7+24LFw4DGa6tjlATIxotz430HhD/PlDm0maa11AV0xuybokB+919L/hE0j/FtV5h7Cr5vlooR3apBrjqV0CuUZEraUnfq9hsCqa7s7VgW8iMP392OBkniT+XBTSGOPoZYcggnGiPXY4h07Jl0rJPHaWyZmflWvuISSS/IbgP6yYa2q3zZoGYkbVouvFnyPfDu+HTTxNnETDJ5OYflZ2mE5MsvA+3qVPgPW/Xq8s8KDodRpexln7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Select CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE for arm64 and override
arch_vm_stack_pages() to a value set from the command line, this
value have the following properties:
- Aligned to page size (doesn't need to be a power of 2), so it can
  be 12kB for example
- Min value is chosen to be 8kB
- Max value will be the default stack size on arm64 which is used to
  allocate the VA range for the kernel stack.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++++++
 arch/arm64/Kconfig                            |  1 +
 arch/arm64/include/asm/memory.h               | 12 ++++++++++
 arch/arm64/kernel/entry.S                     | 10 +++++---
 arch/arm64/kernel/setup.c                     | 24 +++++++++++++++++++
 5 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33cd30996e47..e6ef22f01e01 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2920,6 +2920,13 @@ Kernel parameters
 
 	keepinitrd	[HW,ARM] See retain_initrd.
 
+	kernel_stack_pages=
+			[ARM64,EARLY]
+			Format: <integer>
+			Number of pages mapped for each task kernel stack.
+			The virtual area stays THREAD_SIZE and only its top
+			pages are mapped.
+
 	kernelcore=	[KNL,X86,PPC,EARLY]
 			Format: nn[KMGTPE] | nn% | "mirror"
 			This parameter specifies the amount of memory usable by
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 020fcaf36b1b..5e09ae904e34 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -58,6 +58,7 @@ config ARM64
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
+	select ARCH_HAS_VARIABLE_STACK_SIZE
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_TRACE_MMIO_ACCESS
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 4545d9b39bd5..1d300b16032d 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -113,6 +113,13 @@
 #define DIRECT_MAP_PHYSMEM_END	__pa(PAGE_END - 1)
 
 #define MIN_THREAD_SHIFT	(14 + KASAN_THREAD_SHIFT)
+#define MIN_KERNEL_STACK_SHIFT	(13 + KASAN_THREAD_SHIFT)
+
+#if (MIN_KERNEL_STACK_SHIFT < PAGE_SHIFT)
+#define MIN_KERNEL_STACK_SIZE	PAGE_SIZE
+#else
+#define MIN_KERNEL_STACK_SIZE	(UL(1) << MIN_KERNEL_STACK_SHIFT)
+#endif
 
 /*
  * VMAP'd stacks are allocated at page granularity, so we must ensure that such
@@ -130,6 +137,11 @@
 
 #define THREAD_SIZE		(UL(1) << THREAD_SHIFT)
 
+#ifndef __ASSEMBLY__
+extern unsigned long kernel_stack_pages;
+#define arch_vm_stack_pages()	(kernel_stack_pages)
+#endif
+
 #define THREAD_ALIGN		THREAD_SIZE
 
 #define IRQ_STACK_SIZE		THREAD_SIZE
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ea733b673970..39e68aace0a6 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -76,9 +76,13 @@
 	msr	spsel, #0
 	mov	x1, sp
 	msr	spsel, #1
-	sub	x1, x1, x0
-	cmp	x1, #THREAD_SIZE
-	b.lo	.Lstack_ok\@
+
+	add	x0, x0, #THREAD_SIZE
+	sub	x1, x0, x1
+	adr_l	x0, kernel_stack_pages
+	ldr	x0, [x0]
+	cmp	x1, x0, lsl #PAGE_SHIFT
+	b.ls	.Lstack_ok\@
 
 	/* Check whether we are on the IRQ, SDEI or EFI stacks. */
 	stp	x2, x30, [sp, #-16]!
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 29c6100f0c50..34559048dcca 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -278,6 +278,30 @@ u64 cpu_logical_map(unsigned int cpu)
 	return __cpu_logical_map[cpu];
 }
 
+unsigned long kernel_stack_pages __ro_after_init = THREAD_SIZE / PAGE_SIZE;
+
+static int __init setup_kernel_stack_pages(char *str)
+{
+	unsigned long min = MIN_KERNEL_STACK_SIZE / PAGE_SIZE;
+	unsigned long max = THREAD_SIZE / PAGE_SIZE;
+	unsigned long val;
+
+	if (!str)
+		return -EINVAL;
+
+	if (kstrtoul(str, 10, &val) || val < min || val > max) {
+		pr_err("Invalid kernel_stack_pages=%s, should be between %lu and %lu\n",
+		       str, min, max);
+		return 0;
+	}
+
+	kernel_stack_pages = val;
+	pr_info("Kernel stack size set to %lu KiB\n", (val * PAGE_SIZE) / SZ_1K);
+
+	return 0;
+}
+early_param("kernel_stack_pages", setup_kernel_stack_pages);
+
 void __init __no_sanitize_address setup_arch(char **cmdline_p)
 {
 	setup_initial_init_mm(_text, _etext, _edata, _end);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


