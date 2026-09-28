Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2DDCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6D96B00B4; Mon, 28 Sep 2026 13:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B872E6B00B5; Mon, 28 Sep 2026 13:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50CE6B00B6; Mon, 28 Sep 2026 13:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAA56B00B4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE247C029D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:08 +0000 (UTC)
X-FDA: 85263889536.27.E1781AA
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 30C2B180006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bqZXmGEY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 37aa6aggKCIIysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=37aa6aggKCIIysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nxfrq1oErs1k/vPJqSmHMRIqd6UamZQptG6IeTh3sVg=;
	b=YAbBYFBREJFv1LSF1fvHPNr1s5NnmPfrvwlUmEY+LkLlIbYC70mwQU+Uoa5xkO3OJ6c3zr
	Qqg4U0XeSjLOQbcNwsOPyvSUxcAsrgMTgGomdaUQFNWNcmKcWpccJw2VbzHnc1MuFwFQ7F
	zSaM4oq2AWZi1WZ3am0rpBfHrj/UYZY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bqZXmGEY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 37aa6aggKCIIysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=37aa6aggKCIIysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617327;
	b=1G1jqpoMK2wJnLmSgm47O1gv4nD0p2R12x9SCHijVwCb0DhHOSOKWw7692m9FcV/At9uMZ
	RVGAMx/Q4nKFe51E+SHTCJsl8ntXZ6yDSJ6ACYcb0z5aDkHhGKbBw6ZCqabG5BIW6voz3y
	NFb/dkwpdd8E3tthvdTHdzNv5bF8VPQ=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a0032846d7so13805485e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617326; x=1791222126; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nxfrq1oErs1k/vPJqSmHMRIqd6UamZQptG6IeTh3sVg=;
        b=bqZXmGEYI4lbeq10GBv++VBxELcUmL4UotNEFHIWE4/SzUMOAOlPi5kKwL6rqeLNa1
         hTo14Dp0PzzGa50tfnKu8VkQbR/WzMu6nxrIlhy0FmPrrBZviaLkon03l6whQMpgp3AN
         QqQ/zySh0+3o5wLu0DbR8ZAiRVFs5hAj05tIbtz4zY+NadZ8j8ZITdE7oMl7Par7Re70
         PSb4tUUn5Bq2M5ToSmZISTH3Mtae6EQ1hDiuhZ84qy1B/jSygsar0xRnrA4Hl5QnhDtR
         rDhH8UPfz0KXbzA1N8fhKs16kXj+PiwhT/ynawjSZJvsJJ0+ptjUnAnTq2j1h5Kr2j5R
         1OFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617326; x=1791222126;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nxfrq1oErs1k/vPJqSmHMRIqd6UamZQptG6IeTh3sVg=;
        b=J4BtloIR8rFeM/KX3ye7F2DC8mFjM3EI4cXLC5lJve6ji+RjngVA5L72oOGsAzTnXI
         PAOOILqzz6MTRZPUPTON0Hj1C3WtUQVug4hPSu7RvODbC+tHV+4H8xQC+RlYgi5Hg5ed
         edaHQ6wKiEaMShyTeI8Btjb4oo4FjBbq21WNF00ZAdZmsYGPI1jut3bKD+GQWNB3B8+i
         Zxm9PXO+CnlR0TOe+Qgd1B6lUpZ9oQVvi1FH4PxjdpXBQTzw7kj4EXNQ3CXnffsYfor3
         x9+y3SnDHm5qCseM487LBcls8b05uarwFli5e2KAV2kcFuTIFgUNkovBvMnysOz33DVG
         VwJA==
X-Forwarded-Encrypted: i=1; AKwUvBz1KlzVI8HvbyqtYUEkWFcqZDwSC4qz7mmRSn/buT1QkFuB4xHXbuy1AD/DRxKTLnXghrAJQq61iA==@kvack.org
X-Gm-Message-State: AFuF++n6pGc4XdKS4FLbjyYZcBJJAONi4NZHLVFueiILgw3haR74pNtd
	IIw9YA5aDL3Form5fqyABaYFlLXrI1II0uAy6SM1zSTKI5pj48N4Dzb2l2DvR8VCqzBj6gAXxsA
	WlqLdPadQJMwYMQ==
X-Received: from wmpg37.prod.google.com ([2002:a05:600c:4ca5:b0:4a0:6b:ade5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f12:b0:49f:ce78:356b with SMTP id 5b1f17b1804b1-49fe6700d0cmr271026815e9.28.1790617325440;
 Mon, 28 Sep 2026 10:42:05 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:21 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-15-smostafa@google.com>
Subject: [RFC PATCH 14/15] arm64: mm: Relax kernel stack alignment
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
X-Rspam-User: 
X-Stat-Signature: r3zddnwuiudejwbp7u4u495occwg3iy7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30C2B180006
X-HE-Tag: 1790617327-322177
X-HE-Meta: U2FsdGVkX1+Msg4nlrISzlXhWBD2lyKQcbdiZrzkrh5kN3oQMN3aPMSrMpu1Y7VhdYUhgaboWNMF2mOyXYdhNjYbs/kHw9wF9oSpS9f7Um674DuXlB6+avnkP/NS9sfznbmlftX+JBU0l/ZCbe+7vyDFNaf62nCQ2XWieqj65Aw/VWC45G6/iNXh5zOGjSNo65eyx0O6FMfpCfItH3Ygk70nmis4ZH67Q39V60KQXlB6+Wc0XUiDfRD9Nd9AUf3XALEEg4JUlFyCbAhbGGjHvFQRdk60BoJj69EHX2fjngypifHTi2IqW3DxnNEucqTAbogyMWREAkdD1B63FRDu5gnGSMbNio2E+g9UNP16KOH1L60OHHx4HyktAlRqiOFoVui8lsnR324UqPL/hbQOZa7bho1b9e2wePM3dGBRcRIS+E2+JVjR/9Z8lvB3cIFmdvo1RtAw1ohiv4lh7NzoT2VMQj5jJSdbOTYE+4yM/ODzZwkSzqBtqJfZrNbDW7lp3MJmXyGkjB30yu5LrkKCQQ7Hf5QKMje0mUB2sDLIVoMcJXmPE9/JeLL3q0xgyFukj7kTA7GKachtjuzRAawKSqQKj/1q+uWP1gSoXfyBq+kLFvM9mI9K/tdofGw8PTEx6QWunkl20nI8Kds6yYixDh/xlw/w4jg3bmrPnFIzz9mzpd2/mM+YIeAdC+PjaaU1n1NDzuURqkEQSbSqohUUlWmAHoGz9gEg0E6uNBCFPhIEzIdrFSd+xAEEaYQ3WtOdKJ7lL67mP9xv2YugRuQHl7EAxKTGpPwUWBNvAJ4OXsYPOI3U4EL6I+dDbEBnAifTFufanRCMa8NrJrodTBPnwSWd+t8m9S7aqDqLTj+uxz6BQGOeSHYYRQly9fyhakNDwwFue3CS5U/1Xs0JlSYxaXlwuzlgPqfnOEz8WQZg9o1fxrRX+zla5sMa6YwHrlfVhwgxhLLtBvOE19myMj1
 ICpHV0pX
 OyBu6fmWiTiZfTRpfukRZwcv6B2Ml5d109wGQHx8wchPqBtMMC7sydgKyqo7ZrU6pB8EMwx4IM1wjMNrJO87cmCzdH124EZrDEWQSrjvQpcMwjsSShpcyyiu21R7Dldf22VZD/qRcRZnE/u+QUDi+4KraMOKSZStU1govUwmwrsoOqEo1pyf0buicTH20h2PWzDHIhe4ZelabAYvriqcHAIyll1Zh33vS6WwcQ4aJQIegUkFuLDex+zd5Rgmkt8VzdlFuWMT7ePjyQL0JD6sh6VUZZJZSHqvP0/g7fa9F9yuGMKYGSyugQEe7+eize2DrikCNoKkCGeDbHWCftPoBEW0Vi/acrvbKV6anDEnV4+plhmMyN51D9LxPzoYa8uxjzOQgLlBFcFDOuY0A5SBSy3kG0UjkD4eaaOBt65bfGgb8UooiXaxJz5MAibIhmt2914/ESTSC0oLiyOKWxC/2WswrbzU/ATm90+6WXf41EioXhpzIiWf4UvDsGw9rBbLesCgd4CiaC3PtSz0wlbecDiEIUNwkfXnMVjrR8GtlB9Fhpvn6qrCbmGXTL7gPF6D3JL7FonM4hC5McCOvFFFTgfnomNpHzFP7nHVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On the kernel entry it was not possible to use the stack until it
was checked for overflow which was done by a clever trick relying
on aligning the kernel stack to double it's size, so if the
bit at THREAD_SHIFT was set it means that the stack pointer has
overflowed.

Now, we can easily switch the sp to sp_el1 which is the overflow
stack, push some registers and execute more complex flow.

Rework the kernel entry code to eliminate the tbnz check and the
alignment requirement.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/memory.h |  7 +--
 arch/arm64/kernel/entry.S       | 87 ++++++++++++++++++++++++++++-----
 2 files changed, 77 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 93ce6ef65573..4545d9b39bd5 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -130,12 +130,7 @@
 
 #define THREAD_SIZE		(UL(1) << THREAD_SHIFT)
 
-/*
- * By aligning VMAP'd stacks to 2 * THREAD_SIZE, we can detect overflow by
- * checking sp & (1 << THREAD_SHIFT), which we can do cheaply in the entry
- * assembly.
- */
-#define THREAD_ALIGN		(2 * THREAD_SIZE)
+#define THREAD_ALIGN		THREAD_SIZE
 
 #define IRQ_STACK_SIZE		THREAD_SIZE
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31ef890a2ee..ea733b673970 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -62,15 +62,33 @@
 	sub	sp, sp, #PT_REGS_SIZE
 
 	/*
-	 * Test whether the SP has overflowed, without corrupting a GPR.
-	 * Task and IRQ stacks are aligned so that SP & (1 << THREAD_SHIFT)
-	 * should always be zero.
+	 * Test whether the SP has overflowed, using the overflow stack.
+	 * As we do not know if the CPU was in process or irq context, first
+	 * check against the task stack if that failed it means it might have
+	 * been an interrupt, so check against an interrupt stack, if both
+	 * failed it means that at least one of the stacks overflowed.
 	 */
-	add	sp, sp, x0			// sp' = sp + x0
-	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
-	tbnz	x0, #THREAD_SHIFT, __bad_stack
-	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
-	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
+	msr	spsel, #1
+	stp	x0, x1, [sp, #-16]!
+
+	mrs	x0, tpidrro_el0
+	ldr	x0, [x0, #TSK_STACK]
+	msr	spsel, #0
+	mov	x1, sp
+	msr	spsel, #1
+	sub	x1, x1, x0
+	cmp	x1, #THREAD_SIZE
+	b.lo	.Lstack_ok\@
+
+	/* Check whether we are on the IRQ, SDEI or EFI stacks. */
+	stp	x2, x30, [sp, #-16]!
+	bl	__check_ext_stacks
+	ldp	x2, x30, [sp], #16
+
+.Lstack_ok\@:
+	ldp	x0, x1, [sp], #16
+	msr	spsel, #0
+
 	b	el1t_\regsize\()_\label
 	.endm
 
@@ -528,13 +546,60 @@ SYM_CODE_START(vectors)
 	kernel_ventry	0, t, 32, error		// Error 32-bit EL0
 SYM_CODE_END(vectors)
 
+
+	.macro check_stack_overflow type, ptr, size
+	.ifc \type, percpu
+	ldr_this_cpu x1, \ptr, x0
+	.else
+	adr_l	x1, \ptr
+	ldr	x1, [x1]
+	.endif
+	cbz	x1, 1f
+	.ifc \type, top
+	sub	x1, x1, #\size
+	.endif
+	msr	spsel, #0
+	mov	x0, sp
+	msr	spsel, #1
+	sub	x0, x0, x1
+	cmp	x0, #\size
+	b.lo	2f
+1:
+	.endm
+
+SYM_CODE_START_LOCAL(__check_ext_stacks)
+	/* IRQ stack check */
+	check_stack_overflow percpu, irq_stack_ptr, IRQ_STACK_SIZE
+#ifdef CONFIG_ARM_SDE_INTERFACE
+	/* SDEI normal stack check */
+	check_stack_overflow percpu, sdei_stack_normal_ptr, IRQ_STACK_SIZE
+	/* SDEI critical stack check */
+	check_stack_overflow percpu, sdei_stack_critical_ptr, IRQ_STACK_SIZE
+#endif
+
+#ifdef CONFIG_EFI
+	/* EFI runtime stack check */
+	check_stack_overflow top, efi_rt_stack_top, THREAD_SIZE
+#endif
+
+	/* All checks failed => it's a real overflow */
+	ldp	x2, x30, [sp], #16
+	b	__bad_stack
+
+2:
+	/* A check succeeded => return to kernel_ventry */
+	ret
+SYM_CODE_END(__check_ext_stacks)
+
 SYM_CODE_START_LOCAL(__bad_stack)
 	/*
 	 * We detected an overflow in kernel_ventry.
-	 * Restore SP and X0.
+	 * Restore X0 and X1, and pop the overflow stack.
 	 */
-	sub	x0, sp, x0
-	sub	sp, sp, x0
+	ldp	x0, x1, [sp], #16
+
+	/* Restore SP_EL0 */
+	msr	spsel, #0
 	add	sp, sp, #PT_REGS_SIZE
 
 	/* Switch to the overflow stack */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


