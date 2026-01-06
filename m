Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AC4CEFD11
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390906B0093; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36EB66B0095; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2510C6B0096; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 198EB6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D71488D07D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:46 +0000 (UTC)
X-FDA: 84302805972.28.7A90541
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf30.hostedemail.com (Postfix) with ESMTP id 019B480004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=iGxdFPT7;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf30.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734385; a=rsa-sha256;
	cv=none;
	b=I4HFIpQHJZddNy5+Hva1vPklWSr8cw73Zwo5w8P3f1d8b8846NW/6yWhwJwsJ5upoMN7Pb
	ImbJ1ASam9YHUtJCOJdWvjtCCFS1KNRL6FZ+DPR8/vOLMJQCllig1+97GTVU5bsSE+gWvo
	wAsJ4NJ+9/8ZvJpCh/0TuL1sNrEyA/c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=iGxdFPT7;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf30.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fg+x4l4yBVX9RQI2ybe3EpOM6reoeao/7cwqkI1TOyQ=;
	b=G4vCSgNuTudZcXBX5Mq2r3DmWB+WWKCp1s9W2xMFI2fIJn8hZc9fCEiBKaKaUCDjdpzFHl
	i6VxhrkhV9Qs1l6COCG1sUftOcNCdtaBRcF1LD7IM+9tguGKcIriScqgOU6/6lITzCpPvt
	+JB1w4bLTThdPA6h7lmwwNe7jTK51Sk=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrE0029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:12 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrE0029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734353;
	bh=fg+x4l4yBVX9RQI2ybe3EpOM6reoeao/7cwqkI1TOyQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iGxdFPT79I0PpdkAYzQZSVZW0ukEhSHrfJ8YdseZekYdD9otr3Qli9JlqrYKaMy4f
	 401KOwZTDnGXnWvQ2cCrfL5bhhGJDPq7xA+5lh0q7Mck3LpU5SCLsddfUFv3PiKH8p
	 r6Ll/iloRBUgf3PrPaooK0r1TYsKxgLNvdtOW/T8yYmxxvwv7aNSqxUHvjcLzLLgn0
	 UZMJlzEVJemunLL0hjNeU78UNYi/X7VyQ1xyicqmxOliLDIXDjjbTFAYaoSn1k+jC3
	 zjTKcsNYsqp1FHQEcetkq+NKpytHCNmGoIVptocKHY4lF4WDnqfdLELLcHOxRFoPvW
	 SEohb1H8mJfvw==
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
Subject: [PATCH v4.1 10/10] x86/entry/vdso32: when using int $0x80, use it directly
Date: Tue,  6 Jan 2026 13:18:43 -0800
Message-ID: <20260106211856.560186-10-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 019B480004
X-Stat-Signature: xw1aeytsewxxcdqd7d3uffr1t3c8z51t
X-Rspam-User: 
X-HE-Tag: 1767734384-516143
X-HE-Meta: U2FsdGVkX19Cxv8Qd9/bnvoNpmqblblknvgB1QCMYKdiqETucm5QT2RiwlkV8Z/tm1wrHWi0fG76S8FuPoy4jsypiQoUP0tu/5f2JkIIyxEhn55B76DbjFS4faxRwXJ4Ah9FbVNqEtJDKeR8zAPOvHo38ZgrdV+Xvuha2bm588gISX1iCKU4J78AABxtrYv+b1mBivAK0srvBrA6gMoeH3469xrFm6JHLePpsm90OL2IzJ9+lPzejsIoSLawYGAgwAmuRBPrZPjpnBbQNLxhPDMrIc/lqwNauIyidBG6lXZd/yX/qF1NzYn0rgJSFrfiUsMQehLP5m6eRv4whLZ3Q8qtXjtAr/GLIBY9DrXyBmPgWXbxxeuiOytWvb5Hv1N8969X1Zlg6r38NtB5BlP6zVeYvGlkGyne97EAWn5LV8Penv9dvLmAGgsaaxszrFq4DJ+0831H9Tw1kBdVVzZ/FdDL4HZWAS57cBUPdORk+1EvzOiKUJMputmy1jmqHuxYSGSN7Gpw3wgwHP09ZpmGzwgN1nTcYUt2EX8afeh1d/JsvMNRLRdCcOCWWRW6I/rb8RFoc9CeRAvlDh9NTKswI3RtFimH8O84Ah7Vg5wgtVVibLweH/XcKvkwl2hsZr1faR5rH9LnV1q7ZJ5J9CmGdzeOcCclVne5CDOxngZ3xZFoVEVnKUCrrAPT/4WJ2PyOvKSBP0OxckQ2JZ+z1g2UMtgbzmFanigcasEKU/qnetrm5WHImuZwMW68G0/+8Kik8evj5SujWv3kdCOENqCvZZdFe34dhM0SQ7uA8BzIy+W9Tp3hTy3mZno/fStinvVjnKDo4sHdcAc3dkWNJulNGSiYCZ9UPa9+yW4ZLe9lbwzEpR96g218quNu8t5Mqw+XX/gcYuIkvFcs+hAK02XDZrPzrmWMt9sv7VAKVeVy6ryOXcjQhDgMrpa0GAch6qtRUc06GR6wMXsc6xYsw3k
 ULk7tjO9
 xGgYd45iacPkmur4U4+tpcl5MKR5Bs2bA0baR1SnTQoJ9JDs63T8c680juno+vkmUGeuWAaO9iaBZVher/nmDPkYqm1uvBNTKExxY1l1F+nIKRalTr0fF8hee0cLjC8lnuB+gfAZXP6Z7d9Kn4zdVRFBjDROg5jzILbtjy1E+wWwb8tHXERboIxvQAbyQ5kL4tuiGDWAdocWhA9NGBal2EjiCwcU/V3Nmu/MkzNN64kixrkAZCXLTA8I35ra9vc3qG7y7bhv0vEO+3qB1n/CYQOi/TCviGEDzSR/FuOz7ECByW5mCe+8NDP2t/v+LXYMQdeBSXGS/03axcgJHWLMmocQc9jE7NAPR0z2Zl0GLcjzmzds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When neither sysenter32 nor syscall32 is available (on either
FRED-capable 64-bit hardware or old 32-bit hardware), there is no
reason to do a bunch of stack shuffling in __kernel_vsyscall.
Unfortunately, just overwriting the initial "push" instructions will
mess up the CFI annotations, so suffer the 3-byte NOP if not
applicable.

Similarly, inline the int $0x80 when doing inline system calls in the
vdso instead of calling __kernel_vsyscall.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 18 ++++++++++++++----
 arch/x86/include/asm/vdso/sys_call.h     |  4 +++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 7b1c0f16e511..9157cf9c5749 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -14,6 +14,18 @@
 	ALIGN
 __kernel_vsyscall:
 	CFI_STARTPROC
+
+	/*
+	 * If using int $0x80, there is no reason to muck about with the
+	 * stack here. Unfortunately just overwriting the push instructions
+	 * would mess up the CFI annotations, but it is only a 3-byte
+	 * NOP in that case. This could be avoided by patching the
+	 * vdso symbol table (not the code) and entry point, but that
+	 * would a fair bit of tooling work or by simply compiling
+	 * two different vDSO images, but that doesn't seem worth it.
+	 */
+	ALTERNATIVE "int $0x80; ret", "", X86_FEATURE_SYSFAST32
+
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
@@ -52,11 +64,9 @@ __kernel_vsyscall:
 	#define SYSENTER_SEQUENCE	"movl %esp, %ebp; sysenter"
 	#define SYSCALL_SEQUENCE	"movl %ecx, %ebp; syscall"
 
-	/* If SYSENTER (Intel) or SYSCALL32 (AMD) is available, use it. */
-	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSFAST32, \
-			  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
+	ALTERNATIVE SYSENTER_SEQUENCE, SYSCALL_SEQUENCE, X86_FEATURE_SYSCALL32
 
-	/* Enter using int $0x80 */
+	/* Re-enter using int $0x80 */
 	int	$0x80
 SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 
diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/vdso/sys_call.h
index dcfd17c6dd57..5806b1cd6aef 100644
--- a/arch/x86/include/asm/vdso/sys_call.h
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -20,7 +20,9 @@
 # define __sys_reg4	"r10"
 # define __sys_reg5	"r8"
 #else
-# define __sys_instr	"call __kernel_vsyscall"
+# define __sys_instr	ALTERNATIVE("ds;ds;ds;int $0x80",		\
+				    "call __kernel_vsyscall",		\
+				    X86_FEATURE_SYSFAST32)
 # define __sys_clobber	"memory"
 # define __sys_nr(x,y)	__NR_ ## x ## y
 # define __sys_reg1	"ebx"
-- 
2.52.0


