Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AD1CE7B1F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34F18E0031; Fri, 14 Nov 2025 10:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE48D8E0002; Fri, 14 Nov 2025 10:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADEC8E0031; Fri, 14 Nov 2025 10:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6BBA8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:17:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71FD313AD4F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:17:01 +0000 (UTC)
X-FDA: 84109565442.25.048A4BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A2E8D4000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QzeOcwr9;
	spf=pass (imf07.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrHUzPGBZEMSREH/RvanIYE5RDDkqwnke9Df1bzomfM=;
	b=V6aEZm+NklE/hFS/hN6JYHMJ1xocCHWU7ssZ8QxCwkeu8LeI7WgbHmeo6YlcuOjfrtfRLU
	qLYL5MZKN4tSBRihuI9ezMV+1puDzEYV4DW6hwKwCekK9AGMafbfEFfIGCv6jPZGg6gd/E
	+44RlzfDnL60gQKQmvkv8bdZwvbf/eY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QzeOcwr9;
	spf=pass (imf07.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133419; a=rsa-sha256;
	cv=none;
	b=ZTR3vqUUxWny8ulXUHxRURBfoaPsGQn2O9+Q4F+FB1Ah+LeRGihNa1cElMosPWAJwnK9RJ
	1aS5QZVb9g3JVrKJMR7dU+00oOIH2wpXHuvCQ9xSghrQT1vHWYe8Xa1TUKfmo4p/YpWHhE
	+Z7Y6DRcief74G6ZNIKV84aoWFa5Sww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrHUzPGBZEMSREH/RvanIYE5RDDkqwnke9Df1bzomfM=;
	b=QzeOcwr9zi8tb3gRRQm+n7RtBgKF0SwwvG0HySMCXlfAy+jMq+z75FPk25AB1GmTK2/El1
	MdrpLqA33Z+QiHtz56JcGZSmjcVfeUNtbkf/EVX1MD7cmlDPpxE+yukEwY+zh6gmzvCKaU
	WkUTPH4pGTJzVi02fmLFdR+AnhfRrE0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-nkLlETgCP3ukpkMvj_2ARA-1; Fri,
 14 Nov 2025 10:16:52 -0500
X-MC-Unique: nkLlETgCP3ukpkMvj_2ARA-1
X-Mimecast-MFC-AGG-ID: nkLlETgCP3ukpkMvj_2ARA_1763133407
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66EDF18D95D1;
	Fri, 14 Nov 2025 15:16:47 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF03E180049F;
	Fri, 14 Nov 2025 15:16:32 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v7 28/31] x86/mm/pti: Introduce a kernel/user CR3 software signal
Date: Fri, 14 Nov 2025 16:14:25 +0100
Message-ID: <20251114151428.1064524-8-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2E8D4000D
X-Stat-Signature: yk33mejfzw3nscym37se8fpgpp9on7mu
X-Rspam-User: 
X-HE-Tag: 1763133419-85301
X-HE-Meta: U2FsdGVkX1/VvH2xwuOIQJ9IbXnUk7J42JL26ZxebtNja+Z0yrTZ337j52QfYlu3DMbA42bHgvBNgaQxOocPGXo/GAQbb+AmuyT8GgWqvTlo8EKTppZshlyZwV1x4ZL3+SC3t+vKXP/D9JEU1yTZ+0XrFzxTkfC4NeY0D6osUUsu3JkkNj9OrmZNUQRN3/VysY7AMvlF1CElGxx2A3u6qErWe2VlQtbQ6x3zkmWVT+C17RgaH65JuTCWuultoF2uXLcNJ3jICFOUS09fVhftaunIHH6/cXeQP3W0NPlnR/YW3GnnuZ+/JyuzsWZai/z8zJQM9fFt1s8m5iQNNP+rGbCapDEKSYkO5JETu1NwGfOCrmnu66yIjvLvy+P9WQHNsvpgzXhZgDJ9ViZxgrGiZVo5gx0pybL8NmiAb0pwxVrEw05ynA111AnewhZZ+rkGgRfxWYzPF/XJg5q0DELeo50jIEMI1dJ07u86GMnjMkbFxQxM5ldyhxKpd0nNNzVHPTSIE9Vl9bWn5LMpVXVHivV38zkqNc+tOKdDu2JYa6y2FBP3R+tc/X+4jPv4Yi+35RdTuj+QrBnRzeJ/oTh7eRJuajL0l6Dh8PCt1E4djwcfPu6W8SYBDB1miO+LhoDYSLrTTtb6KhUhDPhsmvSqHqW+IjzAs1g8FWrkSekKay+a3H638Ii7jW+MAGw9bY/D5u0BBIxsAgcdgju2pbM1mYDKjcEqy42+4S4rteq90VpW4p3X3i5JwlJ7uuA5WpmnvTWwQYB2FhQ/AcMF0bkoZm/UeGSPCCZC568aXF9u7U4XCEaahm2/M9lMqG0UJtB/87XUsXQN5P7WV3YKEE5Ivb/w2Kbxd3Lrqg2beVUhxTIUr+6nEE2yMP6gra0shDnKWOAWuuirNHG3r6+KzBXJvE/mxxyFO9LdQ8twhvpYc9LXHCuD///cfE126Qq5G9DolTpCzvSDRD7FgNDctf9
 CCTcBuDJ
 knGQIrn4sx/70X1H1Rntv3XkYBUbU82wq2sdjdmACBxRaVBHMoupZI6FiUpVWgkYnFmYVcoX0ai9iDzvUWK70zlfGmyBU2EqMoOshKlbHo76exPQNIrLB0uAEvOsynoL6Ro2yI6PR2lIdUExNF6/V2f+HVnWPVi80XzvsqqOYELcABwI8Jv0AHC64zbG3Fz6p+tYeypRD9a/9u3GTBpbkqk7M0PK8+olOtPB3tQF7s5Lh/kq+PPT8JJ9EMBAb8gk9aQU7MHLALZUs5CAHza6g4PGK4EzYYVblxB/MiBn9k29uvTHoGaXXrcacb14REkaDcC/u95B5Cyi4QgrGNMW4C9cdYY5uSsTidShk9Dvkph3NJGDOyJHgRq/1jSESlngYApKIXMIN/a6vrmWQlAe3Jpj/ynEYbK1qPoEU+4pd6UhZXkhQDjHQ7CvSQoeNP7tndQIUUKAIQba9Uj/MyVEyTEUhBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will rely on this information to defer kernel TLB flush
IPIs. Update it when switching to and from the kernel CR3.

This will only be really useful for NOHZ_FULL CPUs, but it should be
cheaper to unconditionally update a never-used per-CPU variable living in
its own cacheline than to check a shared cpumask such as
  housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
at every entry.

Note that the COALESCE_TLBI config option is introduced in a later commit,
when the whole feature is implemented.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
Per the cover letter, I really hate this, but couldn't come up with
anything better.
---
 arch/x86/entry/calling.h        | 21 +++++++++++++++++++++
 arch/x86/entry/syscall_64.c     |  4 ++++
 arch/x86/include/asm/tlbflush.h |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 77e2d920a6407..0187c0ea2fddb 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -9,6 +9,7 @@
 #include <asm/ptrace-abi.h>
 #include <asm/msr.h>
 #include <asm/nospec-branch.h>
+#include <asm/jump_label.h>

 /*

@@ -170,11 +171,28 @@ For 32-bit we have the following conventions - kernel is built with
	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm

+.macro COALESCE_TLBI
+#ifdef CONFIG_COALESCE_TLBI
+	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
+	movl     $1, PER_CPU_VAR(kernel_cr3_loaded)
+.Lend_\@:
+#endif // CONFIG_COALESCE_TLBI
+.endm
+
+.macro NOTE_SWITCH_TO_USER_CR3
+#ifdef CONFIG_COALESCE_TLBI
+	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
+	movl     $0, PER_CPU_VAR(kernel_cr3_loaded)
+.Lend_\@:
+#endif // CONFIG_COALESCE_TLBI
+.endm
+
 .macro SWITCH_TO_KERNEL_CR3 scratch_reg:req
	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
	mov	%cr3, \scratch_reg
	ADJUST_KERNEL_CR3 \scratch_reg
	mov	\scratch_reg, %cr3
+	COALESCE_TLBI
 .Lend_\@:
 .endm

@@ -182,6 +200,7 @@ For 32-bit we have the following conventions - kernel is built with
	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)

 .macro SWITCH_TO_USER_CR3 scratch_reg:req scratch_reg2:req
+	NOTE_SWITCH_TO_USER_CR3
	mov	%cr3, \scratch_reg

	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
@@ -241,6 +260,7 @@ For 32-bit we have the following conventions - kernel is built with

	ADJUST_KERNEL_CR3 \scratch_reg
	movq	\scratch_reg, %cr3
+	COALESCE_TLBI

 .Ldone_\@:
 .endm
@@ -257,6 +277,7 @@ For 32-bit we have the following conventions - kernel is built with
	bt	$PTI_USER_PGTABLE_BIT, \save_reg
	jnc	.Lend_\@

+	NOTE_SWITCH_TO_USER_CR3
	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID

	/*
diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index b6e68ea98b839..2589d232e0ba1 100644
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -83,6 +83,10 @@ static __always_inline bool do_syscall_x32(struct pt_regs *regs, int nr)
	return false;
 }

+#ifdef CONFIG_COALESCE_TLBI
+DEFINE_PER_CPU(bool, kernel_cr3_loaded) = true;
+#endif
+
 /* Returns true to return using SYSRET, or false to use IRET */
 __visible noinstr bool do_syscall_64(struct pt_regs *regs, int nr)
 {
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 00daedfefc1b0..e39ae95b85072 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,6 +17,9 @@
 #include <asm/pgtable.h>

 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
+#ifdef CONFIG_COALESCE_TLBI
+DECLARE_PER_CPU(bool, kernel_cr3_loaded);
+#endif

 void __flush_tlb_all(void);

--
2.51.0


