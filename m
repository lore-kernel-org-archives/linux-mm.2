Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58369CEFD12
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151636B0092; Tue,  6 Jan 2026 16:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9456B009B; Tue,  6 Jan 2026 16:20:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7AD6B0092; Tue,  6 Jan 2026 16:20:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C853E6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8892DBD68C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:01 +0000 (UTC)
X-FDA: 84302806602.29.60E8D47
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2C1740015
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=NDcbLM9l;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734400; a=rsa-sha256;
	cv=none;
	b=c9ej+iU1sLAG4CXrkloCL20X/zKDGQltpa2j6tbTDfT7vOSw3dWqo9epGxo8K6jXvggRRv
	cAJSlg7ky6Kz1PTUicJ9y5dFUJRt34CKCKCZZeAOQcFcBGfu5IDdT+ZHHSPanFajDGgk/L
	j8qFJPrpPp7c0yD9Q4UBkYgiRbby/fU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=NDcbLM9l;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIICqKngmY3M/xEXouuddTda7wdwqxugttI9lzZICi0=;
	b=ltEblCTlmDKpz+/CA5AKTdu/1vD2UJJVuILrqLVTM6GfDdJINFmNDvu23uzjsaGssfK9ZF
	4dcuudLEYgtz5G6XXRHqCB8UiyBeKdUDOY21ASKC3/XL89ySRgc39pF/CPev5jcBeNGxvx
	rP1szdboVXPZERcEQj9qufCB8qaBFzU=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDu029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:05 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDu029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734346;
	bh=wIICqKngmY3M/xEXouuddTda7wdwqxugttI9lzZICi0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NDcbLM9lEE/Hai5uWuqz7pwN0KhUnWUse03si9CuCdtEc9iTlr0x4BEHzW1vvHfvh
	 ALrMA60iMA26sARj6vzO/SiFt5uXB/EQHIsr+7jh0W9lApO5JWIcxKZikqSfXdR0NZ
	 W7Bf0GTdxAXLyyknxI9xF3G92HlqlXHcxU0CjJdTe+JdfTLXa3SRw7ly0IX9phHBuM
	 QO+uRP9tdQGTeMj8XR1vX7fwcgKQWO+ytyFcFLTvJWQmU0GJzZeMEiq0B9lMhFxkce
	 ZR+G7aq/bA1g2V48Xq6BQoDesxE5722HfTM38QsVmDkhdZnt0nUkzTEoiyzGxPfCYH
	 Tt+A/E9bqEfMQ==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in sigreturn.S
Date: Tue,  6 Jan 2026 13:18:39 -0800
Message-ID: <20260106211856.560186-6-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2C1740015
X-Rspamd-Server: rspam03
X-Stat-Signature: u344n164gkpadnuxi4ffwp1o78jdqfbd
X-Rspam-User: 
X-HE-Tag: 1767734399-381628
X-HE-Meta: U2FsdGVkX1/WGQAoePe7ZjWEp1oXqFOEj64vlZxqTOQPOaZElJz61VwtU3NMMcus4CoktSoLbQ3kqyTXIXDELDdwLlhjvv5IXQnlXlfOvwf/oAnIR22vDr2WzzflQ61ufYOgLlccAtBkbFB0TuN4xu4GusfZ5s7JRG1g/vS1HLEqOybEnbCEENMg0ZtJ2kpyo01n0uUSN0LMIAznIG9Dkptc3lhgvMPAr9BvL+CIaTKCoRfTsg6iDer8RZARbRy6ypebPh3qeH6x0lFvCjjGfoB9BcVBr1wid5Bo2QpHHhYidAh+Ye1tkXbhcHNxextALR55F7HOG1y0eaTwj02YCp3AVmHP2+a5RyX5TJIh5FayXSMv/Ay+L5s3/zRv8a6io8xh/9ZWWZygqxNnfb73ackyLiq9dpDNLedpwikCV1APSsH/lej8wyHl4h4V9hzneBC2j66UKg0iy+yZV59FJ9Kt9RA4Qi3zlJWKEiJe11J/GiaLjnOLHaqHICoWZpoCkPEZ2L66/C8T4CRJRSTMkjNn0NGL5+BlIwvOHij387YfPjYJ25eKalob+q8mel/mYxwqoeL24zRR6gN1ODZktj7MdblVnt2ZXHB3wrJBSjfkBZ0adglT0389qOAw+PjXe9L5m/Uzs5Bnny8niph501fc8G+EIcPVLGKU7nVryGuWp6iLd8AkMO5xfh2TzeNSUKb8gU9Zha1uyQBwk/GTcUWa4sep+w+m75ArWTc0MapsUOgTd1GpZ8GJwboxXO4A+eJusgJm9xvWNZgnZIPcXJORL7FmKl1L6HS+wFoMuJPBCmZco2JfEVwXohqliNvlqqr+tmHABXVMii1iuypz/PNXO0hIZYCnPxOnaIs54cEh5OJPvWS7km5OPZmK82NUIxe187kWHpAVUn6PvgRcCFZ+q5p1b7sZDUNhfSSoVM7Wxo1Zx8GAeeFRew3TXMhEGi5kDWbYW8qd9cXQgys
 KNkwM94H
 DriyNWXX16w1SLeqCn4wl9LYTSbQTROdbuS/dxsBw4kcvXrYdmpCOU+GqphBa00zciE53ldbFQAxA3oJwtPOmPY8NchOEMpDjPSSS6vUXiL9/ZMde2asv+RgFz4YoXJ4Agn9ld3HJWNxq8Rbes/YU+TOfAlIaFqi5reMg2zcaneiQCP8fLahlZShj5k0Q6rV8CHZvymOq/CbaVP1vCYh4xtG6fqP628Rt5T8z/QsUdJ7ryRDJYdBbS5og64wAm571SrxXbkMf6vMgD0TLeycZXaClv28qjf+Ga43Ln1gPTIKGAuKo+j3DlRzTDsrvBZ8oU1q7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vdso32 sigreturn.S contains open-coded DWARF bytecode, which
includes a hack for gdb to not try to step back to a previous call
instruction when backtracing from a signal handler.

Neither of those are necessary anymore: the backtracing issue is
handled by ".cfi_entry simple" and ".cfi_signal_frame", both of which
have been supported for a very long time now, which allows the
remaining frame to be built using regular .cfi annotations.

Add a few more register offsets to the signal frame just for good
measure.

Replace the nop on fallthrough of the system call (which should never,
ever happen) with a ud2a trap.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/sigreturn.S | 146 ++++++-------------------
 arch/x86/include/asm/dwarf2.h          |   1 +
 arch/x86/kernel/asm-offsets.c          |   6 +
 3 files changed, 39 insertions(+), 114 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S
index 965900c6763b..25b0ac4b4bfe 100644
--- a/arch/x86/entry/vdso/vdso32/sigreturn.S
+++ b/arch/x86/entry/vdso/vdso32/sigreturn.S
@@ -1,136 +1,54 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
 #include <asm/unistd_32.h>
+#include <asm/dwarf2.h>
 #include <asm/asm-offsets.h>
 
+.macro STARTPROC_SIGNAL_FRAME sc
+	CFI_STARTPROC	simple
+	CFI_SIGNAL_FRAME
+	/* -4 as pretcode has already been popped */
+	CFI_DEF_CFA	esp,	\sc - 4
+	CFI_OFFSET	eip,    IA32_SIGCONTEXT_ip
+	CFI_OFFSET	eax,    IA32_SIGCONTEXT_ax
+	CFI_OFFSET	ebx,    IA32_SIGCONTEXT_bx
+	CFI_OFFSET	ecx,    IA32_SIGCONTEXT_cx
+	CFI_OFFSET	edx,    IA32_SIGCONTEXT_dx
+	CFI_OFFSET	esp,    IA32_SIGCONTEXT_sp
+	CFI_OFFSET	ebp,    IA32_SIGCONTEXT_bp
+	CFI_OFFSET	esi,    IA32_SIGCONTEXT_si
+	CFI_OFFSET	edi,    IA32_SIGCONTEXT_di
+	CFI_OFFSET	es,     IA32_SIGCONTEXT_es
+	CFI_OFFSET	cs,     IA32_SIGCONTEXT_cs
+	CFI_OFFSET	ss,     IA32_SIGCONTEXT_ss
+	CFI_OFFSET	ds,     IA32_SIGCONTEXT_ds
+	CFI_OFFSET	eflags, IA32_SIGCONTEXT_flags
+.endm
+
 	.text
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
-	nop /* this guy is needed for .LSTARTFDEDLSI1 below (watch for HACK) */
 	ALIGN
 __kernel_sigreturn:
-.LSTART_sigreturn:
-	popl %eax		/* XXX does this mean it needs unwind info? */
+	STARTPROC_SIGNAL_FRAME IA32_SIGFRAME_sigcontext
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
 	movl $__NR_sigreturn, %eax
 	int $0x80
-.LEND_sigreturn:
 SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
-	nop
-	.size __kernel_sigreturn,.-.LSTART_sigreturn
+	ud2a
+	CFI_ENDPROC
+	.size __kernel_sigreturn,.-__kernel_sigreturn
 
 	.globl __kernel_rt_sigreturn
 	.type __kernel_rt_sigreturn,@function
 	ALIGN
 __kernel_rt_sigreturn:
-.LSTART_rt_sigreturn:
+	STARTPROC_SIGNAL_FRAME IA32_RT_SIGFRAME_sigcontext
 	movl $__NR_rt_sigreturn, %eax
 	int $0x80
-.LEND_rt_sigreturn:
 SYM_INNER_LABEL(vdso32_rt_sigreturn_landing_pad, SYM_L_GLOBAL)
-	nop
-	.size __kernel_rt_sigreturn,.-.LSTART_rt_sigreturn
-	.previous
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAMEDLSI1:
-	.long .LENDCIEDLSI1-.LSTARTCIEDLSI1
-.LSTARTCIEDLSI1:
-	.long 0			/* CIE ID */
-	.byte 1			/* Version number */
-	.string "zRS"		/* NUL-terminated augmentation string */
-	.uleb128 1		/* Code alignment factor */
-	.sleb128 -4		/* Data alignment factor */
-	.byte 8			/* Return address register column */
-	.uleb128 1		/* Augmentation value length */
-	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
-	.byte 0			/* DW_CFA_nop */
-	.align 4
-.LENDCIEDLSI1:
-	.long .LENDFDEDLSI1-.LSTARTFDEDLSI1 /* Length FDE */
-.LSTARTFDEDLSI1:
-	.long .LSTARTFDEDLSI1-.LSTARTFRAMEDLSI1 /* CIE pointer */
-	/* HACK: The dwarf2 unwind routines will subtract 1 from the
-	   return address to get an address in the middle of the
-	   presumed call instruction.  Since we didn't get here via
-	   a call, we need to include the nop before the real start
-	   to make up for it.  */
-	.long .LSTART_sigreturn-1-.	/* PC-relative start address */
-	.long .LEND_sigreturn-.LSTART_sigreturn+1
-	.uleb128 0			/* Augmentation */
-	/* What follows are the instructions for the table generation.
-	   We record the locations of each register saved.  This is
-	   complicated by the fact that the "CFA" is always assumed to
-	   be the value of the stack pointer in the caller.  This means
-	   that we must define the CFA of this body of code to be the
-	   saved value of the stack pointer in the sigcontext.  Which
-	   also means that there is no fixed relation to the other
-	   saved registers, which means that we must use DW_CFA_expression
-	   to compute their addresses.  It also means that when we
-	   adjust the stack with the popl, we have to do it all over again.  */
-
-#define do_cfa_expr(offset)						\
-	.byte 0x0f;			/* DW_CFA_def_cfa_expression */	\
-	.uleb128 1f-0f;			/*   length */			\
-0:	.byte 0x74;			/*     DW_OP_breg4 */		\
-	.sleb128 offset;		/*      offset */		\
-	.byte 0x06;			/*     DW_OP_deref */		\
-1:
-
-#define do_expr(regno, offset)						\
-	.byte 0x10;			/* DW_CFA_expression */		\
-	.uleb128 regno;			/*   regno */			\
-	.uleb128 1f-0f;			/*   length */			\
-0:	.byte 0x74;			/*     DW_OP_breg4 */		\
-	.sleb128 offset;		/*       offset */		\
-1:
-
-	do_cfa_expr(IA32_SIGCONTEXT_sp+4)
-	do_expr(0, IA32_SIGCONTEXT_ax+4)
-	do_expr(1, IA32_SIGCONTEXT_cx+4)
-	do_expr(2, IA32_SIGCONTEXT_dx+4)
-	do_expr(3, IA32_SIGCONTEXT_bx+4)
-	do_expr(5, IA32_SIGCONTEXT_bp+4)
-	do_expr(6, IA32_SIGCONTEXT_si+4)
-	do_expr(7, IA32_SIGCONTEXT_di+4)
-	do_expr(8, IA32_SIGCONTEXT_ip+4)
-
-	.byte 0x42	/* DW_CFA_advance_loc 2 -- nop; popl eax. */
-
-	do_cfa_expr(IA32_SIGCONTEXT_sp)
-	do_expr(0, IA32_SIGCONTEXT_ax)
-	do_expr(1, IA32_SIGCONTEXT_cx)
-	do_expr(2, IA32_SIGCONTEXT_dx)
-	do_expr(3, IA32_SIGCONTEXT_bx)
-	do_expr(5, IA32_SIGCONTEXT_bp)
-	do_expr(6, IA32_SIGCONTEXT_si)
-	do_expr(7, IA32_SIGCONTEXT_di)
-	do_expr(8, IA32_SIGCONTEXT_ip)
-
-	.align 4
-.LENDFDEDLSI1:
-
-	.long .LENDFDEDLSI2-.LSTARTFDEDLSI2 /* Length FDE */
-.LSTARTFDEDLSI2:
-	.long .LSTARTFDEDLSI2-.LSTARTFRAMEDLSI1 /* CIE pointer */
-	/* HACK: See above wrt unwind library assumptions.  */
-	.long .LSTART_rt_sigreturn-1-.	/* PC-relative start address */
-	.long .LEND_rt_sigreturn-.LSTART_rt_sigreturn+1
-	.uleb128 0			/* Augmentation */
-	/* What follows are the instructions for the table generation.
-	   We record the locations of each register saved.  This is
-	   slightly less complicated than the above, since we don't
-	   modify the stack pointer in the process.  */
-
-	do_cfa_expr(IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_sp)
-	do_expr(0, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ax)
-	do_expr(1, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_cx)
-	do_expr(2, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_dx)
-	do_expr(3, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_bx)
-	do_expr(5, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_bp)
-	do_expr(6, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_si)
-	do_expr(7, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_di)
-	do_expr(8, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ip)
-
-	.align 4
-.LENDFDEDLSI2:
+	ud2a
+	CFI_ENDPROC
+	.size __kernel_rt_sigreturn,.-__kernel_rt_sigreturn
 	.previous
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 302e11b15da8..09c9684d3ad6 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -20,6 +20,7 @@
 #define CFI_RESTORE_STATE	.cfi_restore_state
 #define CFI_UNDEFINED		.cfi_undefined
 #define CFI_ESCAPE		.cfi_escape
+#define CFI_SIGNAL_FRAME	.cfi_signal_frame
 
 #ifndef BUILD_VDSO
 	/*
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 25fcde525c68..081816888f7a 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -63,8 +63,14 @@ static void __used common(void)
 	OFFSET(IA32_SIGCONTEXT_bp, sigcontext_32, bp);
 	OFFSET(IA32_SIGCONTEXT_sp, sigcontext_32, sp);
 	OFFSET(IA32_SIGCONTEXT_ip, sigcontext_32, ip);
+	OFFSET(IA32_SIGCONTEXT_es, sigcontext_32, es);
+	OFFSET(IA32_SIGCONTEXT_cs, sigcontext_32, cs);
+	OFFSET(IA32_SIGCONTEXT_ss, sigcontext_32, ss);
+	OFFSET(IA32_SIGCONTEXT_ds, sigcontext_32, ds);
+	OFFSET(IA32_SIGCONTEXT_flags, sigcontext_32, flags);
 
 	BLANK();
+	OFFSET(IA32_SIGFRAME_sigcontext,    sigframe_ia32,    sc);
 	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe_ia32, uc.uc_mcontext);
 #endif
 
-- 
2.52.0


