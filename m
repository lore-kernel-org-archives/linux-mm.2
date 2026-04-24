Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87777FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FD16B00A7; Fri, 24 Apr 2026 15:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46916B00A8; Fri, 24 Apr 2026 15:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCA46B00A9; Fri, 24 Apr 2026 15:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8336C6B00A7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 026BCC178C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:16 +0000 (UTC)
X-FDA: 84694407714.10.6F31687
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E62FC000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VzUHdL18;
	spf=pass (imf22.hostedemail.com: domain of 3ucHraQgKCEIwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ucHraQgKCEIwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNroi0x4OeQZPhAnA797U6GF8ZCJTAYEz27NHRzu1+c=;
	b=xD55+ibwnGYsDn1XqvrcKHc7E1Bn+U/0FXI15/UaYnWcYZlxiUo3YN3aV8sEqFf4uYx4VO
	pkKlDt9+KzibAcNb4L22XOeY9VSU1PtaZRu0LvhCvZk5W4/h9K09gVM9KvMYqK/VfEtpp1
	d9kak25LdFUlcxINa5Y5KOuEvTjfk0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058235; a=rsa-sha256;
	cv=none;
	b=juramXDyP2EhrrrAhb3btZgUbmquU2jnlJGi2FnADLVJoOlvoTBzQI3uxbrh7oRJtPNCPL
	XmHJun9zK2y2IdoJlNzV1WjhWce5fLXKc753ypLig7GQOhWZXCkNJHwzNHihx8KJuHY1h5
	PXhwMBQV7JJlA69Odadx5uel/BlE8eo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VzUHdL18;
	spf=pass (imf22.hostedemail.com: domain of 3ucHraQgKCEIwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ucHraQgKCEIwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-126e8ee6227so7942650c88.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058234; x=1777663034; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CNroi0x4OeQZPhAnA797U6GF8ZCJTAYEz27NHRzu1+c=;
        b=VzUHdL18GL21p9yybecFEw9agJhApTnX3c7SU+SLLOspnsl1OM1KnGCJyXmnCt5FrR
         nbfaKff8XiBXYu1yQz0mpUiJ+V9C4uZsblLRJuMAzOma+m7WrBc5f5eMea+bJV4EYrbT
         q1e1TxI5E37lfrxhk3pa7d6dw70ecq5PrgGWjXy/P5WAj1jlLBl6R+mP5kTG2ofVVZMb
         pVjtfaby7FYVqMFmXSOf35CE6mCjZY1Yr/Jo42+TC5+hOOAtVq/gXjB03Wd4FinLIbI4
         wHp7+PIXguuLPyAbwnheUHJjUQpxCbvKpl+w1X2HNCN9Exm3BZJK32nmpWqwdU8uoiPZ
         qDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058234; x=1777663034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNroi0x4OeQZPhAnA797U6GF8ZCJTAYEz27NHRzu1+c=;
        b=FXkEGZSadeoXrTkqPjwxprvAlBPcKPGtZldyLeiz7pxofPhOKTfBCF23e9CwM//KPv
         jnYsY42vhhy8Aenab4YGvSPDdbrn1P3blYzfWn3btD77vhbQPbyYHpDxQR6lp9t/8PTI
         qx7Cdb0Eq5nI0m21rVkbD1dkzdzRzOIJ1XMmPkt700MGQNaqTugWFedev9DEZsT1OmUJ
         zpTrFHT/DQ+mKnv42SZF85Myn+dJa1aioGuxovVGR0u/y71ovaJdYD75WSYBoLmH/MN9
         HT/2vUKAssg6g2bd7JXDzRIpiTXeiTkpvq+rkLyNrJZ5vV6reuC0TRETAIqAKb8UzlkF
         VukA==
X-Forwarded-Encrypted: i=1; AFNElJ9SRXjD5C1KAPcaZ0h6IWJ1XpJdMO8W/WCanhWHcoUw7M/znlj/AnF9RHwhoeo9zxwE6ouh8qLVWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1I7FNiKLbYUYVgO/utUFBUhjAdQxolb1U7xCC26qwk+hM63B4
	mIrB9Pk6lMrAFzUfcjtCHGtXzAiQr8ElqpdxIe6VhQmQKOt9wpA1WfWBz9jFIFamaVGdM/zM5Vu
	5u+FlEReukKpEiQ==
X-Received: from dlak2.prod.google.com ([2002:a05:701b:2902:b0:12d:b319:ccc4])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:6884:b0:128:d23d:81a7 with SMTP id a92af1059eb24-12c73f64315mr17489339c88.6.1777058233635;
 Fri, 24 Apr 2026 12:17:13 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:56 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-14-stevensd@google.com>
Subject: [PATCH v2 13/13] x86: Add support for dynamic kernel stacks via IST
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E62FC000A
X-Stat-Signature: 9safhgchy3xko7a81tom6bbasci8x5ry
X-Rspam-User: 
X-HE-Tag: 1777058235-271996
X-HE-Meta: U2FsdGVkX19lf3ET6tavUT4Fi2zD5HNkfk4dfNuRPbbeD5eSndCuWEZyJJIEQ7deHYVqun+QOf8+XgB4N/YMHpxybWID9M798fa1rOtrszQJ6j4OLPEx62k/+kNkmEAekGR5Redf1vzCx6DshRH6d0KYT8mTeIg76FC4uL1Un2h07apZNy5qQRZnvPngeszXKPKPJx1jpvgQatPP5Z/9r+Doo2/kNpjUASon/oXI25YwIGodWLETXNebcAGG+rm34oUeJnRDfOFWvYsThVte0bTYHZD3dpvZTd3+/iyiY9U3mcJGqrP61co47pTKzU4XQaeZ3N2tF81yycMV2k0fd6WZ/CJu9PEMDWHi/xrYUYD/N3mKYWeXI4CJuRrC3ARrR+3VcEXymQLrjDycPQHaeBVGuZn3qjrbEPZ/fF4WscekpHe4AmJKV4hS5+jV1eTWaYn8350NzrWNQyr7Is/U4mslxjvc+dVYLqCePsFOEvtr/UaR5Gz21hx2zmVKc3FOFfblrAhXEGbEnJR/SIRsWU6OB6mz72qiiAPK9dvKSI/D0FQqWY7fzsccr/ebS3LLUuOMQfrh/lvCG4bNGhU7+F3EW9f12zszBv5nHZeMdr0ksxVVA/dbQJFk6ZErKaG/BW675MV7n9zkUN8fjHFlBF6kDV4FvbA1hL8450uwcX8j7AP3UGFIHYgvN3UZ1zz19Qm6Esj518vKIWRXu+n4w6S02eGZLltkOZ5ag+6U6w9uvsPZXw76CyDokwVJZXCZPWIFXGXjCGzEKxlNS432r3TYh9Sc3ggBQbUiawfOUdgAVj0vVisZXMFAsA7hjgJxC9VEbgzUq8hn6u1EHAIsFEmkfm4of1r4gmnuCYDW58/yUI96pMzsmhU5eBWRC2z2eJuBZyzRuDU616fbm3RunO3WL7ZDmSlWa9YNdTwyvRpC0fwke/yOw+8PVdRIpf7gKl+ml+4sJcFtffZsTz2
 x6S1y5Jb
 j8PSOE76ssUlvw4Y26sitsaXuugsr2IShOgsRvzq9LdZJ7Gu3c5um1ityR2q/ET+KolqAc0jCDwNL5aAJOKkVMFwesrvUV8kz9mMlJmLxegnOE+WsXqjormQ/tF0D2g6gRaXSy2d3wAOh6VNQACnF7HOovCoUq0Y6Kx/hTA3McFlBFddgW9/lQ0v4kTh5LCo/B9ugYH1XXfhbpgFKyy2a6Pj186qkqB8ENRfo98hXDg/RSABvLlX66VF0vjtxU34TQxlCgMYF3R9dU+umB8HVsAgk6X2/sOZqqi3yCiZ6dvCXV0juAMP/yBLEd6+x0R+jmuDQnx6JMzdZ/BtC/BjWffufUzJn+/w5eDJaXiucEqI+1Kfyc1Pq78UhbhTvx2ULwzA+kEkhITAhET0DNuT8mefWaDxSfJ312lrIiC1QTP9NdyqCEVuL8fh38cUcDEBf9EKSpJEDFt8pC/cfr6+kGEqQLTIKPfxINVscnE9jo5qd8RrpGD3duH4/hGM+u6Gl476/f2jbEuIZMoDDrS27ufXG1qTjkPvLgUzFNyVElh1m42jZGIEtY5VuC20+AmoKegiJEypAl8J4BjmqpuF9/4Z0P6pA6jtYKFHw3qq7D930alMAl2y3T440FtPNVZ8nagKe/Tu3cF+Bp0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On hardware that doesn't support FRED, use ISTs to support dynamic
kernel stacks. In the same way as we do when using FRED, any regular #PF
gets manually moved back onto the original stack. Additionally, we take
the similar approach as we do with FRED to avoid issues with interrupt
re-delivery and handle external interrupts on an IST stack.

The fact that IST stacks aren't reentrant means we have to be very
careful to avoid triggering a #PF while the #PF IST is being used. Since
NMIs can trigger #PFs, we have the NMI handler temporarily install a
secondary #PF IST stack if it detects it came from the #PF IST stack, to
avoid clobbering that stack. Note that although iret unmasking of NMIs
can cause us to get a second NMI while an NMI is on the #PF IST stack,
the actual handling of that secondary NMI will be delayed until after
the original NMI (and thus the #PF) is resolved. As such, one extra #PF
IST stack is sufficient to resolve reentrancy issues with respect to
NMIs.

For #DB exceptions, we make sure that all code that executes on the #PF
IST stack is noinstr. Unfortunately this is not 100% bulletproof, since
the handler needs to access data outside of cpu_entry_area (e.g.
current, current's stack, vmap stack page tables), and the user could
have set hardware breakpoints on accesses to those addresses. Rather
than handle this edge case that should only occur during manual
debugging, we just detect reentrancy on the #PF IST and abort.

It is possible for #MCE to occur on the #PF IST stack, but the #MCE
handler shouldn't generate new #PFs. The reentrancy check on the #PF
stack will trigger if any recoverable #MCEs do generate #PFs - if there
are actually reports of it happening, we can address it then.

Bouncing all #PF and external interrupts through IST stacks adds some
overhead. However, such events from userspace already had to bounce
through the CPU entry stack, so introducing ISTs only adds notable
overhead for #PFs and external interrupts that occur while in CPL 0.

Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/x86/Kconfig                      |  1 +
 arch/x86/entry/entry_64.S             | 49 +++++++++++++++++--
 arch/x86/include/asm/cpu_entry_area.h | 18 +++++++
 arch/x86/include/asm/idtentry.h       | 38 ++++++++++++++-
 arch/x86/include/asm/page_64_types.h  | 10 +++-
 arch/x86/include/asm/processor.h      |  6 +++
 arch/x86/kernel/cpu/common.c          | 11 +++++
 arch/x86/kernel/dumpstack_64.c        | 10 +++-
 arch/x86/kernel/idt.c                 | 57 +++++++++++++---------
 arch/x86/kernel/nmi.c                 |  9 ++++
 arch/x86/lib/usercopy.c               |  9 ++++
 arch/x86/mm/cpu_entry_area.c          | 17 +++++++
 arch/x86/mm/fault.c                   | 70 ++++++++++++++++++++++-----
 13 files changed, 262 insertions(+), 43 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..182fda721b0d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -212,6 +212,7 @@ config X86
 	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
 	select HAVE_ARCH_USERFAULTFD_MINOR	if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_DYNAMIC_STACK		if X86_64 && !XEN_PV
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 42447b1e1dff..02dbd00cc4bb 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -286,7 +286,7 @@ SYM_CODE_END(xen_error_entry)
  * @cfunc:		C function to be called
  * @has_error_code:	Hardware pushed error code on stack
  */
-.macro idtentry_body cfunc has_error_code:req
+.macro idtentry_body cfunc has_error_code:req kernel_reentry_fn=
 
 	/*
 	 * Call error_entry() and switch to the task stack if from userspace.
@@ -302,6 +302,38 @@ SYM_CODE_END(xen_error_entry)
 	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
+#ifdef CONFIG_DYNAMIC_STACK
+.ifnb \kernel_reentry_fn
+	/*
+	 * For entry from userspace, we've also already moved off of
+	 * the IST after calling error_entry above.
+	 */
+	testb	$3, CS(%rsp)
+	jnz	.Lregular_fault_\cfunc
+
+	/* Check and set the reentry canary reserved by IST_ENTRY_OFFSET. */
+	cmpq	$0, (SS + 8)(%rsp)
+	jne	.List_reentry_abort_\cfunc
+	movq	$1, (SS + 8)(%rsp)
+
+	movq	%rsp, %rdi
+	call	\kernel_reentry_fn
+
+	movq	$0, (SS + 8)(%rsp)
+
+	testq	%rax, %rax
+	jnz	.Lchange_stack_\cfunc
+	jmp	error_return
+
+.Lchange_stack_\cfunc:
+	movq	%rax, %rsp
+
+	ENCODE_FRAME_POINTER
+	UNWIND_HINT_REGS
+.Lregular_fault_\cfunc:
+.endif
+#endif
+
 	movq	%rsp, %rdi			/* pt_regs pointer into 1st argument*/
 
 	.if \has_error_code == 1
@@ -314,6 +346,13 @@ SYM_CODE_END(xen_error_entry)
 	call	\cfunc
 
 	jmp	error_return
+
+#ifdef CONFIG_DYNAMIC_STACK
+.ifnb \kernel_reentry_fn
+.List_reentry_abort_\cfunc:
+	ud2
+.endif
+#endif
 .endm
 
 /**
@@ -322,11 +361,13 @@ SYM_CODE_END(xen_error_entry)
  * @asmsym:		ASM symbol for the entry point
  * @cfunc:		C function to be called
  * @has_error_code:	Hardware pushed error code on stack
+ * @kernel_reentry_fn:  If set, C function to be called on re-entry from
+ *			kernel space before the main handler is invoked.
  *
  * The macro emits code to set up the kernel context for straight forward
  * and simple IDT entries. No IST stack, no paranoid entry checks.
  */
-.macro idtentry vector asmsym cfunc has_error_code:req
+.macro idtentry vector asmsym cfunc has_error_code:req kernel_reentry_fn=
 SYM_CODE_START(\asmsym)
 
 	.if \vector == X86_TRAP_BP
@@ -358,7 +399,7 @@ SYM_CODE_START(\asmsym)
 .Lfrom_usermode_no_gap_\@:
 	.endif
 
-	idtentry_body \cfunc \has_error_code
+	idtentry_body \cfunc \has_error_code \kernel_reentry_fn
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
@@ -375,7 +416,7 @@ SYM_CODE_END(\asmsym)
  */
 .macro idtentry_irq vector cfunc
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
-	idtentry \vector asm_\cfunc \cfunc has_error_code=1
+	idtentry \vector asm_\cfunc \cfunc has_error_code=1 kernel_reentry_fn=switch_to_kstack
 .endm
 
 /**
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 462fc34f1317..5bce3259edee 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -26,6 +26,12 @@
 	char	DB_stack[EXCEPTION_STKSZ];			\
 	char	MCE_stack_guard[guardsize];			\
 	char	MCE_stack[EXCEPTION_STKSZ];			\
+	char	PF_stack_guard[guardsize];			\
+	char	PF_stack[EXCEPTION_STKSZ];			\
+	char	PF2_stack_guard[guardsize];			\
+	char	PF2_stack[EXCEPTION_STKSZ];			\
+	char	UDI_stack_guard[guardsize];			\
+	char	UDI_stack[EXCEPTION_STKSZ];			\
 	char	VC_stack_guard[guardsize];			\
 	char	VC_stack[optional_stack_size];			\
 	char	VC2_stack_guard[guardsize];			\
@@ -50,6 +56,9 @@ enum exception_stack_ordering {
 	ESTACK_NMI,
 	ESTACK_DB,
 	ESTACK_MCE,
+	ESTACK_PF,
+	ESTACK_PF2,
+	ESTACK_UDI,
 	ESTACK_VC,
 	ESTACK_VC2,
 	N_EXCEPTION_STACKS
@@ -144,6 +153,15 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
 
+#ifdef CONFIG_DYNAMIC_STACK
+bool is_pf_ist_stack(unsigned long addr);
+#else
+static inline bool is_pf_ist_stack(unsigned long addr)
+{
+	return false;
+}
+#endif
+
 #define __this_cpu_ist_top_va(name)					\
 	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
 
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 42bf6a58ec36..d8c846d28a1d 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -163,6 +163,16 @@ noinstr void fred_##func(struct pt_regs *regs)
 #define DECLARE_IDTENTRY_RAW_ERRORCODE(vector, func)			\
 	DECLARE_IDTENTRY_ERRORCODE(vector, func)
 
+/**
+ * DECLARE_IDTENTRY_PF - Declare functions for page fault entry point
+ * @vector:	Vector number (ignored for C)
+ * @func:	Function name of the entry point
+ *
+ * Maps to @DECLARE_IDTENTRY_ERRORCODE().
+ */
+#define DECLARE_IDTENTRY_PF(vector, func)			\
+	DECLARE_IDTENTRY_RAW_ERRORCODE(vector, func)
+
 /**
  * DEFINE_IDTENTRY_RAW_ERRORCODE - Emit code for raw IDT entry points
  * @func:	Function name of the entry point
@@ -391,6 +401,15 @@ static __always_inline void __##func(struct pt_regs *regs)
 #define DEFINE_IDTENTRY_DF(func)					\
 	DEFINE_IDTENTRY_RAW_ERRORCODE(func)
 
+/**
+ * DEFINE_IDTENTRY_PF - Emit code for page fault
+ * @func:	Function name of the entry point
+ *
+ * Maps to DEFINE_IDTENTRY_RAW_ERRORCODE
+ */
+#define DEFINE_IDTENTRY_PF(func)					\
+	DEFINE_IDTENTRY_RAW_ERRORCODE(func)
+
 /**
  * DEFINE_IDTENTRY_VC_KERNEL - Emit code for VMM communication handler
  *			       when raised from kernel mode
@@ -480,6 +499,15 @@ void fred_install_sysvec(unsigned int vector, const idtentry_t function);
 #define DECLARE_IDTENTRY_ERRORCODE(vector, func)			\
 	idtentry vector asm_##func func has_error_code=1
 
+#ifdef CONFIG_DYNAMIC_STACK
+#define DECLARE_IDTENTRY_PF(vector, func)				\
+	idtentry vector asm_##func func has_error_code=1		\
+	kernel_reentry_fn=handle_dynamic_stack_kernel_faults
+#else
+#define DECLARE_IDTENTRY_PF(vector, func)				\
+	DECLARE_IDTENTRY_RAW_ERRORCODE(vector, func)
+#endif
+
 /* Special case for 32bit IRET 'trap'. Do not emit ASM code */
 #define DECLARE_IDTENTRY_SW(vector, func)
 
@@ -494,8 +522,14 @@ void fred_install_sysvec(unsigned int vector, const idtentry_t function);
 	idtentry_irq vector func
 
 /* System vector entries */
+#ifdef CONFIG_DYNAMIC_STACK
+#define DECLARE_IDTENTRY_SYSVEC(vector, func)				\
+	idtentry vector asm_##func func has_error_code=0		\
+	kernel_reentry_fn=switch_to_kstack
+#else
 #define DECLARE_IDTENTRY_SYSVEC(vector, func)				\
 	DECLARE_IDTENTRY(vector, func)
+#endif
 
 #ifdef CONFIG_X86_64
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
@@ -615,7 +649,7 @@ DECLARE_IDTENTRY_ERRORCODE(X86_TRAP_AC,	exc_alignment_check);
 /* Raw exception entries which need extra work */
 DECLARE_IDTENTRY_RAW(X86_TRAP_UD,		exc_invalid_op);
 DECLARE_IDTENTRY_RAW(X86_TRAP_BP,		exc_int3);
-DECLARE_IDTENTRY_RAW_ERRORCODE(X86_TRAP_PF,	exc_page_fault);
+DECLARE_IDTENTRY_PF(X86_TRAP_PF,		exc_page_fault);
 
 #if defined(CONFIG_IA32_EMULATION)
 DECLARE_IDTENTRY_RAW(IA32_SYSCALL_VECTOR,	int80_emulation);
@@ -699,7 +733,7 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI_VECTOR,	sysvec_x86_platform_ipi);
 #endif
 
 #ifdef CONFIG_SMP
-DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
+DECLARE_IDTENTRY_SYSVEC(RESCHEDULE_VECTOR,		sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 7400dab373fe..b0b60f83a531 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -28,7 +28,15 @@
 #define	IST_INDEX_NMI		1
 #define	IST_INDEX_DB		2
 #define	IST_INDEX_MCE		3
-#define	IST_INDEX_VC		4
+#define	IST_INDEX_PF		4
+#define	IST_INDEX_UDI		5
+#define	IST_INDEX_VC		6
+
+/*
+ * Offset used for some IST stacks to reserve a slot for re-entry
+ * canary. At the very top of the stack for cache friendliness.
+ */
+#define IST_ENTRY_OFFSET	8
 
 /*
  * Set __PAGE_OFFSET to the most negative possible address +
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a24c7805acdb..fa790731dea0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -573,6 +573,12 @@ static inline void load_sp0(unsigned long sp0)
 
 #endif /* CONFIG_PARAVIRT_XXL */
 
+#ifdef CONFIG_DYNAMIC_STACK
+void install_nmi_pf_stack(bool use_nmi_pf_stack);
+#else
+static inline void install_nmi_pf_stack(bool use_nmi_pf_stack) {}
+#endif
+
 unsigned long __get_wchan(struct task_struct *p);
 
 extern void select_idle_routine(void);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ec0670114efa..d90a01e2fdd2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2377,6 +2377,8 @@ static inline void tss_setup_ist(struct tss_struct *tss)
 	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
 	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
 	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
+	tss->x86_tss.ist[IST_INDEX_PF] = __this_cpu_ist_top_va(PF) - IST_ENTRY_OFFSET;
+	tss->x86_tss.ist[IST_INDEX_UDI] = __this_cpu_ist_top_va(UDI) - IST_ENTRY_OFFSET;
 	/* Only mapped when SEV-ES is active */
 	tss->x86_tss.ist[IST_INDEX_VC] = __this_cpu_ist_top_va(VC);
 }
@@ -2665,3 +2667,12 @@ void __init arch_cpu_finalize_init(void)
 	 */
 	mem_encrypt_init();
 }
+
+#ifdef CONFIG_DYNAMIC_STACK
+noinstr void install_nmi_pf_stack(bool use_nmi_pf_stack)
+{
+	unsigned long stack = use_nmi_pf_stack ? __this_cpu_ist_top_va(PF2)
+					       : __this_cpu_ist_top_va(PF);
+	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_PF], stack - IST_ENTRY_OFFSET);
+}
+#endif
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6c5defd6569a..6784d31d3eb3 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -24,13 +24,16 @@ static const char * const exception_stack_names[] = {
 		[ ESTACK_NMI	]	= "NMI",
 		[ ESTACK_DB	]	= "#DB",
 		[ ESTACK_MCE	]	= "#MC",
+		[ ESTACK_PF	]	= "#PF",
+		[ ESTACK_PF2	]	= "#PF2",
+		[ ESTACK_UDI	]	= "#UDI",
 		[ ESTACK_VC	]	= "#VC",
 		[ ESTACK_VC2	]	= "#VC2",
 };
 
 const char *stack_type_name(enum stack_type type)
 {
-	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != 9);
 
 	if (type == STACK_TYPE_TASK)
 		return "TASK";
@@ -87,6 +90,9 @@ struct estack_pages estack_pages[CEA_ESTACK_PAGES] ____cacheline_aligned = {
 	EPAGERANGE(NMI),
 	EPAGERANGE(DB),
 	EPAGERANGE(MCE),
+	EPAGERANGE(PF),
+	EPAGERANGE(PF2),
+	EPAGERANGE(UDI),
 	EPAGERANGE(VC),
 	EPAGERANGE(VC2),
 };
@@ -98,7 +104,7 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	struct pt_regs *regs;
 	unsigned int k;
 
-	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != 9);
 
 	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
 	/*
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 260456588756..7626fa7adfb3 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -116,6 +116,10 @@ static const __initconst struct idt_data def_idts[] = {
 	ISTG(X86_TRAP_VC,		asm_exc_vmm_communication, IST_INDEX_VC),
 #endif
 
+#ifdef CONFIG_DYNAMIC_STACK
+	ISTG(X86_TRAP_PF,		asm_exc_page_fault, IST_INDEX_PF),
+#endif
+
 	SYSG(X86_TRAP_OF,		asm_exc_overflow),
 };
 
@@ -127,47 +131,55 @@ static const struct idt_data ia32_idt[] __initconst = {
 #endif
 };
 
+#ifdef CONFIG_DYNAMIC_STACK
+#define EXTERNAL_INTR(_vector, _addr)	ISTG(_vector, _addr, IST_INDEX_UDI)
+#define EXTERNAL_INTR_IST_VALUE		(IST_INDEX_UDI + 1)
+#else
+#define EXTERNAL_INTR(_vector, _addr)	INTG(_vector, _addr)
+#define EXTERNAL_INTR_IST_VALUE		0
+#endif
+
 /*
  * The APIC and SMP idt entries
  */
 static const __initconst struct idt_data apic_idts[] = {
 #ifdef CONFIG_SMP
-	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
-	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
-	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
-	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
+	EXTERNAL_INTR(RESCHEDULE_VECTOR,		asm_sysvec_reschedule_ipi),
+	EXTERNAL_INTR(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
+	EXTERNAL_INTR(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
+	EXTERNAL_INTR(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
 
 #ifdef CONFIG_X86_THERMAL_VECTOR
-	INTG(THERMAL_APIC_VECTOR,		asm_sysvec_thermal),
+	EXTERNAL_INTR(THERMAL_APIC_VECTOR,		asm_sysvec_thermal),
 #endif
 
 #ifdef CONFIG_X86_MCE_THRESHOLD
-	INTG(THRESHOLD_APIC_VECTOR,		asm_sysvec_threshold),
+	EXTERNAL_INTR(THRESHOLD_APIC_VECTOR,		asm_sysvec_threshold),
 #endif
 
 #ifdef CONFIG_X86_MCE_AMD
-	INTG(DEFERRED_ERROR_VECTOR,		asm_sysvec_deferred_error),
+	EXTERNAL_INTR(DEFERRED_ERROR_VECTOR,		asm_sysvec_deferred_error),
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	INTG(LOCAL_TIMER_VECTOR,		asm_sysvec_apic_timer_interrupt),
-	INTG(X86_PLATFORM_IPI_VECTOR,		asm_sysvec_x86_platform_ipi),
+	EXTERNAL_INTR(LOCAL_TIMER_VECTOR,		asm_sysvec_apic_timer_interrupt),
+	EXTERNAL_INTR(X86_PLATFORM_IPI_VECTOR,		asm_sysvec_x86_platform_ipi),
 # if IS_ENABLED(CONFIG_KVM)
-	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
-	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
-	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
+	EXTERNAL_INTR(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
+	EXTERNAL_INTR(POSTED_INTR_WAKEUP_VECTOR,	asm_sysvec_kvm_posted_intr_wakeup_ipi),
+	EXTERNAL_INTR(POSTED_INTR_NESTED_VECTOR,	asm_sysvec_kvm_posted_intr_nested_ipi),
 # endif
 #ifdef CONFIG_GUEST_PERF_EVENTS
 	INTG(PERF_GUEST_MEDIATED_PMI_VECTOR,	asm_sysvec_perf_guest_mediated_pmi_handler),
 #endif
 # ifdef CONFIG_IRQ_WORK
-	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
+	EXTERNAL_INTR(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
 # endif
-	INTG(SPURIOUS_APIC_VECTOR,		asm_sysvec_spurious_apic_interrupt),
-	INTG(ERROR_APIC_VECTOR,			asm_sysvec_error_interrupt),
+	EXTERNAL_INTR(SPURIOUS_APIC_VECTOR,		asm_sysvec_spurious_apic_interrupt),
+	EXTERNAL_INTR(ERROR_APIC_VECTOR,		asm_sysvec_error_interrupt),
 # ifdef CONFIG_X86_POSTED_MSI
-	INTG(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
+	EXTERNAL_INTR(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
 # endif
 #endif
 };
@@ -206,11 +218,12 @@ idt_setup_from_table(gate_desc *idt, const struct idt_data *t, int size, bool sy
 	}
 }
 
-static __init void set_intr_gate(unsigned int n, const void *addr)
+static __init void set_intr_gate(unsigned int n, const void *addr, int ist)
 {
 	struct idt_data data;
 
 	init_idt_data(&data, n, addr);
+	data.bits.ist = ist;
 
 	idt_setup_from_table(idt_table, &data, 1, false);
 }
@@ -293,7 +306,7 @@ void __init idt_setup_apic_and_irq_gates(void)
 
 	for_each_clear_bit_from(i, system_vectors, FIRST_SYSTEM_VECTOR) {
 		entry = irq_entries_start + IDT_ALIGN * (i - FIRST_EXTERNAL_VECTOR);
-		set_intr_gate(i, entry);
+		set_intr_gate(i, entry, EXTERNAL_INTR_IST_VALUE);
 	}
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -304,7 +317,7 @@ void __init idt_setup_apic_and_irq_gates(void)
 		 * /proc/interrupts.
 		 */
 		entry = spurious_entries_start + IDT_ALIGN * (i - FIRST_SYSTEM_VECTOR);
-		set_intr_gate(i, entry);
+		set_intr_gate(i, entry, EXTERNAL_INTR_IST_VALUE);
 	}
 #endif
 	/* Map IDT into CPU entry area and reload it. */
@@ -325,10 +338,10 @@ void __init idt_setup_early_handler(void)
 	int i;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++)
-		set_intr_gate(i, early_idt_handler_array[i]);
+		set_intr_gate(i, early_idt_handler_array[i], DEFAULT_STACK);
 #ifdef CONFIG_X86_32
 	for ( ; i < NR_VECTORS; i++)
-		set_intr_gate(i, early_ignore_irq);
+		set_intr_gate(i, early_ignore_irq, DEFAULT_STACK);
 #endif
 	load_idt(&idt_descr);
 }
@@ -352,5 +365,5 @@ void __init idt_install_sysvec(unsigned int n, const void *function)
 		return;
 
 	if (!WARN_ON(test_and_set_bit(n, system_vectors)))
-		set_intr_gate(n, function);
+		set_intr_gate(n, function, EXTERNAL_INTR_IST_VALUE);
 }
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 3d239ed12744..a2444b9d5b71 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -37,6 +37,7 @@
 #include <asm/microcode.h>
 #include <asm/sev.h>
 #include <asm/fred.h>
+#include <asm/cpu_entry_area.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -581,6 +582,11 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	if (IS_ENABLED(CONFIG_NMI_CHECK_CPU) && ignore_nmis) {
 		WRITE_ONCE(nsp->idt_ignored, nsp->idt_ignored + 1);
 	} else if (!ignore_nmis) {
+		bool protect_pf_ist_stack = is_pf_ist_stack(regs->sp);
+
+		if (protect_pf_ist_stack)
+			install_nmi_pf_stack(true);
+
 		if (IS_ENABLED(CONFIG_NMI_CHECK_CPU)) {
 			WRITE_ONCE(nsp->idt_nmi_seq, nsp->idt_nmi_seq + 1);
 			WARN_ON_ONCE(!(nsp->idt_nmi_seq & 0x1));
@@ -590,6 +596,9 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 			WRITE_ONCE(nsp->idt_nmi_seq, nsp->idt_nmi_seq + 1);
 			WARN_ON_ONCE(nsp->idt_nmi_seq & 0x1);
 		}
+
+		if (protect_pf_ist_stack)
+			install_nmi_pf_stack(false);
 	}
 
 	irqentry_nmi_exit(regs, irq_state);
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 24b48af27417..75b9f851f428 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -9,6 +9,7 @@
 #include <linux/instrumented.h>
 
 #include <asm/tlbflush.h>
+#include <asm/cpu_entry_area.h>
 
 /**
  * copy_from_user_nmi - NMI safe copy from user
@@ -39,6 +40,14 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	if (!nmi_uaccess_okay())
 		return n;
 
+	/*
+	 * IST stacks aren't reentrant, so bail before the possibility of
+	 * a #PF. While on the #PF IST stack, we should only need this
+	 * function for stack dumps (WARN/panic/etc).
+	 */
+	if (is_pf_ist_stack(current_stack_pointer))
+		return n;
+
 	/*
 	 * Even though this function is typically called from NMI/IRQ context
 	 * disable pagefaults so that its behaviour is consistent even when
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75..97ac91c109ed 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -156,6 +156,12 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	cea_map_stack(DB);
 	cea_map_stack(MCE);
 
+	if (IS_ENABLED(CONFIG_DYNAMIC_STACK)) {
+		cea_map_stack(PF);
+		cea_map_stack(PF2);
+		cea_map_stack(UDI);
+	}
+
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
 		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
 			cea_map_stack(VC);
@@ -173,6 +179,17 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 }
 #endif
 
+#ifdef CONFIG_DYNAMIC_STACK
+bool noinstr is_pf_ist_stack(unsigned long addr)
+{
+	struct cea_exception_stacks *cs = __this_cpu_read(cea_exception_stacks);
+	unsigned long top = CEA_ESTACK_TOP(cs, PF2);
+	unsigned long bot = CEA_ESTACK_BOT(cs, PF);
+
+	return addr >= bot && addr < top;
+}
+#endif
+
 /* Setup the fixmap mappings only once per-processor */
 static void __init setup_cpu_entry_area(unsigned int cpu)
 {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 40d518d9f562..48ef50982c06 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1482,16 +1482,61 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 
 #ifdef CONFIG_DYNAMIC_STACK
 
-static noinstr unsigned long copy_stack_data(struct pt_regs *regs)
+static noinstr unsigned long copy_stack_data(struct pt_regs *regs, bool is_dynamic_stack_fault)
 {
 	unsigned long new_sp;
 	unsigned long data_len;
+	bool must_avoid_dynamic_stack_fault;
 
-	new_sp = regs->sp - (FRED_CONFIG_REDZONE_AMOUNT << 6);
-	new_sp &= FRED_STACK_FRAME_RSP_MASK;
-	data_len = sizeof(struct fred_frame);
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		new_sp = regs->sp - (FRED_CONFIG_REDZONE_AMOUNT << 6);
+		new_sp &= FRED_STACK_FRAME_RSP_MASK;
+		data_len = sizeof(struct fred_frame);
+		must_avoid_dynamic_stack_fault = false;
+	} else {
+		// Hardware aligns sp to a 16 byte boundary when going through the IDT.
+		new_sp = ALIGN_DOWN(regs->sp, 16);
+		data_len = sizeof(struct pt_regs);
+		must_avoid_dynamic_stack_fault = is_dynamic_stack_fault;
+	}
 	new_sp -= data_len;
 
+	if (must_avoid_dynamic_stack_fault) {
+		bool new_sp_on_stack;
+
+		/*
+		 * We don't have to worry about the window where current_task
+		 * is inconsistent during a context switch because interrupts
+		 * are disabled during that window and the only #PF that can
+		 * happen there is a dynamic stack fault, in which case we
+		 * return directly from handle_dynamic_stack_kernel_faults().
+		 */
+		if (!in_nmi())
+			dynamic_stack_fault(current, new_sp, &new_sp_on_stack);
+		else
+			new_sp_on_stack = false;
+
+		/*
+		 * If new_sp isn't on the current task's stack, verify that it's
+		 * on an exception/irq/entry stack. This is a little expensive,
+		 * but #PFs in those contexts should be rare.
+		 */
+		if (!new_sp_on_stack) {
+			struct stack_info info, info2;
+
+			if (!get_stack_info_noinstr((void *)new_sp, current, &info)) {
+				instrumentation_begin();
+				if (get_stack_info_noinstr((void *)(new_sp - PAGE_SIZE),
+							   current, &info2)) {
+					pr_emerg("Stack overflow during stack switch\n");
+					handle_stack_overflow(regs, new_sp, &info2);
+				} else {
+					die("Stack switch back to unknown stack", regs, 0);
+				}
+			}
+		}
+	}
+
 	memcpy((void *)new_sp, regs, data_len);
 
 	return new_sp;
@@ -1499,7 +1544,7 @@ static noinstr unsigned long copy_stack_data(struct pt_regs *regs)
 
 __visible noinstr unsigned long switch_to_kstack(struct pt_regs *regs)
 {
-	return copy_stack_data(regs);
+	return copy_stack_data(regs, false);
 }
 
 #define ALIGN_TO_STACK(addr) ((addr) & ~(THREAD_ALIGN - 1))
@@ -1510,7 +1555,7 @@ __visible noinstr unsigned long handle_dynamic_stack_kernel_faults(struct pt_reg
 	struct task_struct *tsk;
 	bool on_stack;
 
-	address = fred_event_data(regs);
+	address = cpu_feature_enabled(X86_FEATURE_FRED) ? fred_event_data(regs) : read_cr2();
 	if (fault_in_kernel_space(address) && !in_nmi()) {
 		tsk = task_from_stack_address(address);
 
@@ -1522,18 +1567,19 @@ __visible noinstr unsigned long handle_dynamic_stack_kernel_faults(struct pt_reg
 	}
 
 	/*
-	 * The regular fault handler won't sleep when executing in an
-	 * atomic context, so we can complete the #PF directly on the
-	 * #PF stack.
+	 * The regular fault handler won't sleep when executing in an atomic
+	 * context, so we can complete the #PF directly on the #PF stack.
+	 * However, IST doesn't support nested exceptions, so we need to avoid
+	 * running any non-noinstr code on the IST #PF stack.
 	 */
-	if (in_atomic())
+	if (in_atomic() && cpu_feature_enabled(X86_FEATURE_FRED))
 		return (unsigned long)regs;
 	else
-		return copy_stack_data(regs);
+		return copy_stack_data(regs, true);
 }
 #endif
 
-DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
+DEFINE_IDTENTRY_PF(exc_page_fault)
 {
 	irqentry_state_t state;
 	unsigned long address;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


