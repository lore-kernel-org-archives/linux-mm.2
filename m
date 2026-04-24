Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58382FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9141C6B00A6; Fri, 24 Apr 2026 15:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2AC6B00A7; Fri, 24 Apr 2026 15:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE4B6B00A8; Fri, 24 Apr 2026 15:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42D6E6B00A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 055741201D6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:15 +0000 (UTC)
X-FDA: 84694407630.10.9176888
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E74718000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YHLzXoTR;
	spf=pass (imf24.hostedemail.com: domain of 3t8HraQgKCEAuvgxgpufiqqing.eqonkpwz-oomxcem.qti@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3t8HraQgKCEAuvgxgpufiqqing.eqonkpwz-oomxcem.qti@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sI3AsQ38T9OUoFK9auQxK91StrB0zHb6WwxxAxz4Ksk=;
	b=bnTUo9KCvHNe8ugHrZcLOAJNPqy0Tx6TKM7UsfHz57D1sm8jVTVCAMtkbZLNJVoUTpzHam
	3b4NuulYH6pWAze7UEOtLkhU6O0zHMC4ySOWLA1s3NCg8ZRUDe9bcIauf7Zqbe9UAkS0A3
	7v+f9cXwIJZBL5r1yiM0q8waZuaNa3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058233; a=rsa-sha256;
	cv=none;
	b=k0iDEreL5i4uvmie7i+E5gWt2KjjAoermekVvRxogmNaw1PDqao5qJdnh5z6zqu2p44NR7
	o9uxxDEg2uaNKUiDAIKdQ31w8rBjsNHV97cYRhxYfdoudvkK7Hcic/E9mDQxQqHksHYYwq
	L0ujKPADD6Hie+yBsZlz7tJ7SxXwWgA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YHLzXoTR;
	spf=pass (imf24.hostedemail.com: domain of 3t8HraQgKCEAuvgxgpufiqqing.eqonkpwz-oomxcem.qti@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3t8HraQgKCEAuvgxgpufiqqing.eqonkpwz-oomxcem.qti@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0ba59a830so12810087eec.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058232; x=1777663032; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sI3AsQ38T9OUoFK9auQxK91StrB0zHb6WwxxAxz4Ksk=;
        b=YHLzXoTRAjxoh0cYwTxtHuBb57gRKXRjp7zFEs1haN0kmeU7g9oAD0Nc9RUehGkdUe
         GMGqfjYsVphLj8MKrbLht0hPpN3fMGItMDqU7m3Z1u+ipWd1NRi+QP31jGoWj9V3ggaX
         UBbbA29J+RYf9nSQB57OSLGua3ZRi7ElQiaVhbKecqqshrJ67vjzCFHL6wyIdPSr51+P
         wclKheXSSsOI5OOia9c99ZbwnIg6VglcqljNOhTMMF+w8VaacXmJvcNBWq1L1amkwkmx
         4+LZWK6ZTAkuhWJ8TTUzrMa4ovr+5oc0J2S/0ubHfcrRdZ4FLeb14ycLcSBhp1FfElD5
         fBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058232; x=1777663032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sI3AsQ38T9OUoFK9auQxK91StrB0zHb6WwxxAxz4Ksk=;
        b=SPUaU0iNfDLUH2SJbSexa6BeB9SVSObbri12SUBt8Qk2Aii3k0B5C6TyCrLZgIcKsk
         OR/qe42Ffg0AzjsFyqHd/AH7xgUUeM8fqnLZ0knOosyBDOti1TkD5FhbFl+QrXa4n1r7
         5q3A+X9ARclvqAy6AH2nx0dilv1hVM20HEbOerPtkCOSUPMeTr1YqANyvIVr77IXvceO
         vjTQDLzgb5VXiPwwkILDoHTBcRnL8jMETLhY9GaVNSL/9MHn696WDp5ui+XDZFMg3JQQ
         E73O89XskjBaaKqpfBN2AcFh0LO3JXyuNGgzEtSriEv8P+iA+Aqaf9ibFcmx2mS+dcKl
         8MZg==
X-Forwarded-Encrypted: i=1; AFNElJ/SLVZ+UzV0OsgNeDgly1q8C176VPC4EhRJGdGD8fvs4dV4Tf44Rfda6aBu0QH101Xt68MuMInThQ==@kvack.org
X-Gm-Message-State: AOJu0YzlYf7e90DrTyYyJ03Fxs1ZoAIlp2DwRshgOXjoMZB4HHVWW3Fp
	K7hCz/y/6pkitW7EvfevG5B1t9RwRc/TVGeUfV51whTDotQpYvi9CBvnmpPHmebl1IxeMzWpAto
	HGWxL4Q2HAhbXUg==
X-Received: from dyhd3.prod.google.com ([2002:a05:7300:8283:b0:2e2:b79e:ed06])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2b04:b0:2de:cc07:e8b with SMTP id 5a478bee46e88-2e466044dddmr18982911eec.1.1777058231713;
 Fri, 24 Apr 2026 12:17:11 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:55 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-13-stevensd@google.com>
Subject: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via FRED
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E74718000C
X-Rspam-User: 
X-Stat-Signature: r1rxdb1kfc756xuia1r3i89wgmuho6rr
X-HE-Tag: 1777058233-497080
X-HE-Meta: U2FsdGVkX18dWz0TSKi6pArKEmVYoFXEFwNFgguJKSmVxfgEg8cWcSGutcAxPWg4MB5qnqGLTH8cLGAclDw/XzCSverFhOXgr2j44bH2Au7KOeXCfFJ4QSpiQw496WwUKvQSqQvC58vTBdXAO+qh5E8W1K0Cml0+rCFtyS+VioUMzywZCpRsQdObmmk8EiZYrkPUPI++lC0Eu1U+cHCAWa7qYw2xr8aeKvX4SFIJaSRy7j5kr9KDMDkuTFzY8GuB8rcuMmSpjDOFhUFLIekNtlpzbjVTl3IBSxF3zTUGeU4TO0gei8/G9gc62VT84CWASv2eefmz+08kNAxLrIbtvxAecqXifh5cMsTQho3t12mO86sm+f9gYptmSa+G/DWCI2cbRNykvKPuVUEbppcCbRjRBDjQjgv7EfUHCqTG6d2AEuxGVrY3OTpCr5TXHIbZp2jkTSXPzuGppRuzPb+EQd85oy7z22HFsXRVrLJ748vJIDf7fPxcFHtTVU5C1/VaxFllYdA56B4zgxUzWh2TiXwzrumYGTJdx7FaZ23vh4HfkhTo3jnbDjw+OdRw3Dq3hcL0aQtMVanonpZcuISi10pZZw2bVY8qPBZ6DpL0QpR0ZNwsjMRNA4yD18kZsl7+UcFS2cOvQbE3cu2iHjkddG5TFqbzXX+KL2eRvjDK9k53OIL+2eqPLLpOvgjltn0p9qh2Is1mkNA2NxmD/ehz1JpWAQhVis+xj49+B5LweDj5TGJWs4ah4iMshPVNenIzv6FNCsaqtd9C484m8sDE06+VMPJLgGCZchypyGwOfF2XYo5xEjlZ7lg6qIyXkXb7wthXjijrenOrPVvDMVdLtI3avS9wvAyS6gvSMk/UsFaSVVyPoj4FKZq+cf1oV38RJpSfUqNXSar2FTLl1WIFumMOIE162YjcUS3egyXmvKNCyGvhV/w766kBsbFWLRF6p6qVd6WoYXsaetFpHPp
 bHpuOkfK
 QS/v1jXIWrTvDrx3puJEPTCfVJTxPImpEZ9awL+oulF4p8wAtatBQ/OCp3uLbQH81VPygZyC8/A0gZMDIa9Biz9qx0ZIOMfPJuDGdnrYDapBBht5BptmFke4UPRwcuGMKRfBFIt5k+TxSjwG3TQ54uEQUq8Vv1vbDD0pUORbl8m/QXALD8rLfeTHtPLexyYA2l5geQgP9heg+9XPTJq3ek3gZexrKD5UIKLB2YaKyerOfOux/rkiq1DObnBqm0uE8f743vwtv6kyAaddMAag8NqudLtqPDZD6n+Ie1MyuGWVlrSE0mRskl8fpZ+0Xf6ycTDTOUBUdcWJSO+oVejXTmz2JpYpcg/Nxe5qfAITYEBg0KX1uXiiMQETJ5YO1bV//a88mRWsq8v45PDVLuqcbQwFnzsrIvox59lQ3rOOvifQ3nVdMdK3fr6r7KDiNxmEpwztqjf27ufq7PM5t0Dqisd7tF/kYCSoTVftufGoko/GHrCqT2Q3uhxwESbAT0VCItxoMMidgPUdTlHJTz+ou95kz2UATxUCEH9cxAAPjYjZBnpCrQYQdfIWJN+U55crelfbv7WziSC0LmwkVqZXrDM4Rw9zzY4y8BAiZiqK1Bml85ZJSBAegC4lhw4jYefuwxZYpEJXS3B8F+rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for dynamic kernel stack faults by handling #PFs from CPL 0
on stack level 1. Since we can't sleep while on a per-CPU stack, any
page faults that didn't originate in an atomic context need to be
bounced back to the originating stack.

With dynamic kernel stacks, the processor pushing data onto the kernel
thread stack can cause a page fault. The SDM says in the #DF section
that the processor should be able to handle these exceptions serially.
However, this does not seem to actually be handled reliably.

With KVM, I've observed timer interrupts dropped. The corresponding bit
in VIRR is cleared and the ISR bit in the APIC is set before the #PF is
delivered, but the interrupt handler is not invoked after the kernel
stack fault is resolved. On bare metal, I've observed frequent hangs due
to threads getting stuck on folio_wait_bit_common. I haven't traced this
to an exact interrupt being lost, but moving interrupts to stack level 1
reduces boot failures from >10% to 0 in 1000s of attempts.

To work around this, external interrupts are also moved to stack level
1, and unconditionally bounced back to the originating stack.

Bouncing page faults and external interrupts through stack level 1 while
in CPL 0 adds a small but non-trivial overhead to those paths. The
shared entry point for events received in CPL 0 also becomes slightly
more expensive, due to the need to detect page faults and external
interrupts.

Since enabling HAVE_ARCH_DYNAMIC_STACK requires unconditional support,
enabling the config is done in the next patch that adds dynamic stack
support for traditional interrupt delivery.

Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/x86/entry/entry_64_fred.S    | 55 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64.h | 36 ++++++++++++++++++++
 arch/x86/include/asm/traps.h      |  5 +++
 arch/x86/kernel/fred.c            | 20 ++++++++---
 arch/x86/mm/dump_pagetables.c     | 14 +++++---
 arch/x86/mm/fault.c               | 53 +++++++++++++++++++++++++++++
 6 files changed, 174 insertions(+), 9 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 119b8214748e..7202655ef662 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -54,7 +54,62 @@ SYM_CODE_END(asm_fred_entrypoint_user)
 	.org asm_fred_entrypoint_user + 256, 0xcc
 SYM_CODE_START_NOALIGN(asm_fred_entrypoint_kernel)
 	FRED_ENTER
+
+#ifdef CONFIG_DYNAMIC_STACK
+	/* Extract event type and vector from augmented SS. */
+	movl	(SS + 4)(%rsp), %esi
+	andl	$0x000f00ff, %esi
+
+	/* Check if event type is hardware exception and vector is #PF. */
+	cmpl	$0x0003000e, %esi
+	jne	.Lcheck_for_extint
+
+	call	handle_dynamic_stack_kernel_faults
+	testq	%rax, %rax
+	jz	.Lentrypoint_done
+	cmpq	%rax, %rsp
+	je	.Lskip_stack_switch
+	jmp	.Ldo_stack_switch
+
+.Lcheck_for_extint:
+	/* Check if event type is external interrupt. */
+	andl	$0xf0000, %esi
+	testl	%esi, %esi
+	jne	.Lcall_primary_entry
+	call	switch_to_kstack
+
+.Ldo_stack_switch:
+#ifdef CONFIG_DEBUG_ENTRY
+	/*
+	 * We should only do a stack switch for an external interrupt or a page
+	 * fault in a non-atomic context. These should only ever happen in user
+	 * space or from a regular kernel stack (i.e. CSL == 0).
+	 */
+	movw	(CS + 2)(%rsp), %si
+	testw	$0x3, %si
+	jz	.Lcsl_ok
+	ud2
+.Lcsl_ok:
+#endif
+	movq	%rax, %rsp
+
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
+	mov	$MSR_IA32_FRED_CONFIG, %ecx
+	rdmsr
+	andl	$~0x3, %eax
+	wrmsr
+
+	movq	%rsp, %rdi
+#endif
+
+.Lskip_stack_switch:
+	movq	%rsp, %rdi
+.Lcall_primary_entry:
 	call	fred_entry_from_kernel
+
+.Lentrypoint_done:
 	FRED_EXIT
 	ERETS
 SYM_CODE_END(asm_fred_entrypoint_kernel)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index ce45882ccd07..fbb042c89d13 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -237,6 +237,42 @@ static inline void native_pgd_clear(pgd_t *pgd)
 #define __swp_entry_to_pte(x)		(__pte((x).val))
 #define __swp_entry_to_pmd(x)		(__pmd((x).val))
 
+#ifdef CONFIG_DYNAMIC_STACK
+
+/*
+ * Skip the present bit. And skip dirty and accessed bits due to
+ * erratum where they can be incorrectly set on non-present ptes.
+ *
+ * Also skip bit 8, which is used for pte_present for PROT_NONE. This
+ * isn't necessary in the strictest sense since PROT_NONE doesn't apply
+ * to kernel PTEs, but it's easier to let pte_present just continue
+ * to work.
+ */
+#define KPTE_AVAILABLE_DATA_BITS 58
+
+static inline pte_t make_data_kpte(unsigned long val)
+{
+	unsigned long low_part, mid_part, high_part;
+
+	low_part = (val & 0xf) << 1;
+	mid_part = (val & 0x10) << 3;
+	high_part = (val & ~0x1f) << 4;
+
+	return __pte(low_part | mid_part | high_part);
+}
+
+static inline unsigned long unpack_data_kpte(pte_t pte)
+{
+	unsigned long val = pte_val(pte), high_part, mid_part, low_part;
+
+	low_part = (val >> 1) & 0xf;
+	mid_part = (val >> 3) & 0x10;
+	high_part = (val >> 4) & ~0x1f;
+
+	return low_part | mid_part | high_part;
+}
+#endif /* CONFIG_DYNAMIC_STACK */
+
 extern void cleanup_highmap(void);
 
 #define HAVE_ARCH_UNMAPPED_AREA
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 3f24cc472ce9..6b55eb91aea6 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -15,6 +15,11 @@ asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs);
 asmlinkage __visible notrace
 struct pt_regs *fixup_bad_iret(struct pt_regs *bad_regs);
 asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *eregs);
+
+#ifdef CONFIG_DYNAMIC_STACK
+asmlinkage __visible noinstr unsigned long switch_to_kstack(struct pt_regs *regs);
+asmlinkage __visible noinstr unsigned long handle_dynamic_stack_kernel_faults(struct pt_regs *regs);
+#endif
 #endif
 
 extern int ibt_selftest(void);
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index e736b19e18de..01d727420d1f 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -9,6 +9,8 @@
 
 /* #DB in the kernel would imply the use of a kernel debugger. */
 #define FRED_DB_STACK_LEVEL		1UL
+#define FRED_PF_STACK_LEVEL		1UL
+#define FRED_INT_STACK_LEVEL		1UL
 #define FRED_NMI_STACK_LEVEL		2UL
 #define FRED_MC_STACK_LEVEL		2UL
 /*
@@ -25,6 +27,11 @@
 DEFINE_PER_CPU(unsigned long, fred_rsp0);
 EXPORT_PER_CPU_SYMBOL(fred_rsp0);
 
+#define FRED_CONFIG_VAL(int_stklvl) \
+	(FRED_CONFIG_REDZONE /* Reserve for CALL emulation */ | \
+	 FRED_CONFIG_INT_STKLVL(int_stklvl) | \
+	 FRED_CONFIG_ENTRYPOINT(asm_fred_entrypoint_user))
+
 void cpu_init_fred_exceptions(void)
 {
 	/* When FRED is enabled by default, remove this log message */
@@ -44,11 +51,7 @@ void cpu_init_fred_exceptions(void)
 	 */
 	loadsegment(ss, __KERNEL_DS);
 
-	wrmsrq(MSR_IA32_FRED_CONFIG,
-	       /* Reserve for CALL emulation */
-	       FRED_CONFIG_REDZONE |
-	       FRED_CONFIG_INT_STKLVL(0) |
-	       FRED_CONFIG_ENTRYPOINT(asm_fred_entrypoint_user));
+	wrmsrq(MSR_IA32_FRED_CONFIG, FRED_CONFIG_VAL(0));
 
 	wrmsrq(MSR_IA32_FRED_STKLVLS, 0);
 
@@ -84,8 +87,15 @@ void cpu_init_fred_rsps(void)
 	       FRED_STKLVL(X86_TRAP_DB,  FRED_DB_STACK_LEVEL) |
 	       FRED_STKLVL(X86_TRAP_NMI, FRED_NMI_STACK_LEVEL) |
 	       FRED_STKLVL(X86_TRAP_MC,  FRED_MC_STACK_LEVEL) |
+#ifdef CONFIG_DYNAMIC_STACK
+	       FRED_STKLVL(X86_TRAP_PF,  FRED_PF_STACK_LEVEL) |
+#endif
 	       FRED_STKLVL(X86_TRAP_DF,  FRED_DF_STACK_LEVEL));
 
+#ifdef CONFIG_DYNAMIC_STACK
+	wrmsrq(MSR_IA32_FRED_CONFIG, FRED_CONFIG_VAL(FRED_INT_STACK_LEVEL));
+#endif
+
 	/* The FRED equivalents to IST stacks... */
 	wrmsrq(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
 	wrmsrq(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e..5c33c33e93fe 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -306,11 +306,17 @@ static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	static const char units[] = "BKMGTPE";
 	struct seq_file *m = st->seq;
 
-	new_prot = val & PTE_FLAGS_MASK;
-	if (!val)
+	/* Ignore prot/eff from data kptes. */
+	if (val & _PAGE_PRESENT || addr < address_markers[KERNEL_SPACE_NR].start_address) {
+		new_prot = val & PTE_FLAGS_MASK;
+		if (!val)
+			new_eff = 0;
+		else
+			new_eff = st->prot_levels[level];
+	} else {
+		new_prot = 0;
 		new_eff = 0;
-	else
-		new_eff = st->prot_levels[level];
+	}
 
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b83a06739b51..40d518d9f562 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1480,6 +1480,59 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 	local_irq_disable();
 }
 
+#ifdef CONFIG_DYNAMIC_STACK
+
+static noinstr unsigned long copy_stack_data(struct pt_regs *regs)
+{
+	unsigned long new_sp;
+	unsigned long data_len;
+
+	new_sp = regs->sp - (FRED_CONFIG_REDZONE_AMOUNT << 6);
+	new_sp &= FRED_STACK_FRAME_RSP_MASK;
+	data_len = sizeof(struct fred_frame);
+	new_sp -= data_len;
+
+	memcpy((void *)new_sp, regs, data_len);
+
+	return new_sp;
+}
+
+__visible noinstr unsigned long switch_to_kstack(struct pt_regs *regs)
+{
+	return copy_stack_data(regs);
+}
+
+#define ALIGN_TO_STACK(addr) ((addr) & ~(THREAD_ALIGN - 1))
+
+__visible noinstr unsigned long handle_dynamic_stack_kernel_faults(struct pt_regs *regs)
+{
+	unsigned long address;
+	struct task_struct *tsk;
+	bool on_stack;
+
+	address = fred_event_data(regs);
+	if (fault_in_kernel_space(address) && !in_nmi()) {
+		tsk = task_from_stack_address(address);
+
+		if (tsk && dynamic_stack_fault(tsk, address, &on_stack)) {
+			WARN_ON_ONCE(tsk != current &&
+				     ALIGN_TO_STACK(regs->sp) != ALIGN_TO_STACK(address));
+			return 0;
+		}
+	}
+
+	/*
+	 * The regular fault handler won't sleep when executing in an
+	 * atomic context, so we can complete the #PF directly on the
+	 * #PF stack.
+	 */
+	if (in_atomic())
+		return (unsigned long)regs;
+	else
+		return copy_stack_data(regs);
+}
+#endif
+
 DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 {
 	irqentry_state_t state;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


