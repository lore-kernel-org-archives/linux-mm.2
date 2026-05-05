Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9BBFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523376B00A3; Tue,  5 May 2026 04:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9C56B00A4; Tue,  5 May 2026 04:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F866B00A5; Tue,  5 May 2026 04:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9486B00A3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:26:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3B12120479
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:41 +0000 (UTC)
X-FDA: 84732685002.07.8D25BA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4167C0007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dBQTGf7M;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DpCArN7sCuQ6UdeKGF+zw0IlqdsCed390omIrj42NY=;
	b=lK9v4FhldlNCbmvL+r2ml1CEFJJcl+9RRG5hlFbbHrBe85SbQB9ed5OeLGluBnMCO+L23P
	/wRQZFYqeiw5A+//mz1sZjkkJwGuiq25YyHbfHi1gRotDyZuSpHDVBhl0XW29buxwvGL4h
	nSapQMyVQcZaYMlQ+4NphowR2NyDHKI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dBQTGf7M;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969600; a=rsa-sha256;
	cv=none;
	b=pYjQ/7FdEIcHcWUKA3NId0/DvuDGL2R638xwODGw8+yHLkrFly2ppTa3nN11QwVgiPYB7r
	xCqw9MFBa42Au3n3C0nh9cGDSZLnw4UWGZK9gwsKWrKHGr5vxhtlDrZDz+AgTov/iEEjE9
	CjY+/Fo38MEtfdL26AgpGqBgxVSRXPw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8DpCArN7sCuQ6UdeKGF+zw0IlqdsCed390omIrj42NY=;
	b=dBQTGf7MyAUU/lFEYiiNR9FVok8vvIcbjdNkXaMb7VVHCYLOQ1ygOCPgMEJAkxZlrC6u6f
	939uN/wddes8tFyOAOM6qJRbLwMkc2V5AoGwrLeS1mhKlOIXeeEE7vzy67PqtoyiMQvVLv
	igTPc0mcPfa/RYZu99ikvy7rMwE9UnY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-pI57teaCNIK9k6pigSmdoA-1; Tue,
 05 May 2026 04:26:35 -0400
X-MC-Unique: pI57teaCNIK9k6pigSmdoA-1
X-Mimecast-MFC-AGG-ID: pI57teaCNIK9k6pigSmdoA_1777969591
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91FCF195608C;
	Tue,  5 May 2026 08:26:31 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D37A930001A1;
	Tue,  5 May 2026 08:26:19 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v9 08/10] x86/mm/pti: Introduce a kernel/user CR3 software signal
Date: Tue,  5 May 2026 10:23:53 +0200
Message-ID: <20260505082355.1982003-9-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: IiS7i4XJ8KYi2ZvZ-CQG0e1abVIOaIUtkkySpU7urNc_1777969591
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4167C0007
X-Stat-Signature: wa3ymcb3rp1jknywmgq4r5iwojhajpdb
X-HE-Tag: 1777969599-212113
X-HE-Meta: U2FsdGVkX19ZjUS2IzLt1WFCatrX1DRK9BZTT1z84hV/V7+BdLyTiO+nttVFXj3fZ/GpPh27q/G0+A2svLCZxhhhnVJmECDMlwzd2iYaDBSmXMEc+oOIkeRgvOks3uhmSVfaGfeGpL8o++Jh6Y0IGAn/YzgBdghpF7MTv8+2hZy0GEbeIK8c2R01gZhCXQgSrfCYZTRm3N28gOtopUxOF8A85KdlDAvtSQrZoVnqPjT5N04sKWhlF/vDGEZSj9iJYOhxtZuYljBg21OVrUbjh0Ej1X5i25HYpjRZTbcaKiYBPa1Iub4o4RSm7sLBYNWCPkSJS6kt4fKiXeqXUYI+f30wv+ORQaOBR2GtPKc/tVprWN4huM9UA1jwstNqCxYQGAuNXmNf9pxe4Q37biploJY/3GM6Uv8QoZFRR/JF+Q9wKlVqYcuFn9ZQVAUhmivMzeXbRvmP0z6Hx/WLoS5RK8u/t13zu3PW8jna5KjCfGTczw9MKWumm9x+WfpGN5rucL2ghRKNZB1pW0IyWhfswDP6eWBpc6iqz2ON4PiPSMyLEftCM17ZGWwABSyAg6rVlYOK9I7h/5Qkplk2/LYTgbFZmu782EG1INx+BONcsM66If5RTCbVW+uvstAHILnj3vLEd6wE4isgjD11NmP1YTgx2rF7S1jCzDZLxQnkJ9D4WPKC74XCBB16xDXj7jV6DsMc/39EuopD1cEJP1G5wde8utAHgpLNPOWB8dtI9zt6TSytSoJKLFM5McEXXHj4hODtVtCr7ltx8GvwbAr8MY7LR6FQgvrGhSihiCMI+BuxLjU8JareQwliyOd9YOMGUT6x3Suh6/lGlM+tdpSGKVJ0iUVRtFG/jtacPoYRUfPiOKo9qc+DA+d9oGRxO2F08wjvQpR3VNIoFb52Z/Rlm32r4UWSMN2Izha8Lc2lpsK7GkJi/pPyIzwO85QmXWwVhVQ1no3NAcNHEbgPgAj
 lrBHlMMe
 WkOalLhAD+nIfiL6DFLjD7In1F4WR0ZNPVmO/sdGqe63Ys+6eYRoOa7FSk6WZEqtWPdqRLDK4fMw8ejAB9/REU26HIW+5Z85i6uB4j1zARWCsEwa7M6X7b3dhrPmb7P7S7Ur8teSq+cqcamT0reybdVzgoIYRAAnadwy1aAx6bEjZ7L+AQBT4d1kn4S4ch42nNXJcUiYDz+3y4r1I766Qwdu5L8nPd3051Bd9iHjlwFiD1twfggX3L1Ix+cXjO/FIP+pdt89fCp340BHrX5fThzcCXpQWce+sQNOrYTjLIif0mNn61m8iaFDxgX35kDggG7Mm2gNTQRjSDJ7UVJyGmH6XzYP6SN70w6bsxNED/G9/a4ZgytY9I9OhY64Asc+xtB88OmLsgi4NhOZwepiBT+VLIunK5owq/TC9gO6pFhEmYDzztZK4szOIQZKlNigqIC7xP00ZVWbQR8K1MoeuAAhLZm/zXrPr07dO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will rely on being able to check whether a remote CPU is
using the kernel or the user CR3.

This software signal needs to be updated before the actual CR3 write, IOW
it always immediately precedes it:

  KERNEL_CR3_LOADED := 1
  SWITCH_TO_KERNEL_CR3
  [...]
  KERNEL_CR3_LOADED := 0
  SWITCH_TO_USER_CR3

The variable also gets mapped into the user space visible pages.
I tried really hard not to do that, and at some point had something mostly
working with having an alias to it through the cpu_entry_area accessed like
so before the switch to the kernel CR3:

	subq $10, %rsp
	sgdt (%rsp)
	movq 2(%rsp), \scratch_reg /* GDT address */
	addq $10, %rsp

	movl $1, CPU_ENTRY_AREA_kernel_cr3(\scratch_reg)

however this explodes when running 64-bit user code that invokes SYSCALL,
since the scratch reg is %rsp itself, and I figured this was enough headaches.

This will only be really useful for NOHZ_FULL CPUs, but it should be
cheaper to unconditionally update a never-used per-CPU variable living in
its own cacheline than to check a shared cpumask such as
  housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
at every entry.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/Kconfig                | 14 +++++++++++++
 arch/x86/entry/calling.h        | 18 +++++++++++++++++
 arch/x86/entry/syscall_64.c     |  4 ++++
 arch/x86/include/asm/tlbflush.h |  3 +++
 arch/x86/mm/pti.c               | 36 ++++++++++++++++++++++-----------
 kernel/sched/isolation.c        |  9 ++++++++-
 6 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 99bb5217649a8..36b4527ef69bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2198,6 +2198,20 @@ config ADDRESS_MASKING
 	  The capability can be used for efficient address sanitizers (ASAN)
 	  implementation and for optimizations in JITs.
 
+config TRACK_CR3
+       def_bool n
+       prompt "Track which CR3 is in use"
+       depends on X86_64 && MITIGATION_PAGE_TABLE_ISOLATION && NO_HZ_FULL
+       help
+	 This option adds a software signal that allows checking remotely
+	 whether a CPU is using the user or the kernel page table.
+
+	 This allows further optimizations for NOHZ_FULL CPUs.
+
+	 This obviously makes the user<->kernel transition overhead even worse.
+
+	 If unsure, say N.
+
 config HOTPLUG_CPU
 	def_bool y
 	depends on SMP
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 77e2d920a6407..deb8224b5ee48 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -9,6 +9,7 @@
 #include <asm/ptrace-abi.h>
 #include <asm/msr.h>
 #include <asm/nospec-branch.h>
+#include <asm/jump_label.h>
 
 /*
 
@@ -170,8 +171,22 @@ For 32-bit we have the following conventions - kernel is built with
 	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm
 
+.macro NOTE_CR3_SWITCH scratch_reg:req in_kernel:req
+#ifdef CONFIG_TRACK_CR3
+	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
+	LOCK_PREFIX
+.if \in_kernel == 1
+	orq $1, PER_CPU_VAR(kernel_cr3_loaded)
+.else
+	andq $0, PER_CPU_VAR(kernel_cr3_loaded)
+.endif
+.Lend_\@:
+#endif // CONFIG_TRACK_CR3
+.endm
+
 .macro SWITCH_TO_KERNEL_CR3 scratch_reg:req
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
+	NOTE_CR3_SWITCH \scratch_reg $1
 	mov	%cr3, \scratch_reg
 	ADJUST_KERNEL_CR3 \scratch_reg
 	mov	\scratch_reg, %cr3
@@ -182,6 +197,7 @@ For 32-bit we have the following conventions - kernel is built with
 	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)
 
 .macro SWITCH_TO_USER_CR3 scratch_reg:req scratch_reg2:req
+	NOTE_CR3_SWITCH \scratch_reg $0
 	mov	%cr3, \scratch_reg
 
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
@@ -229,6 +245,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 .macro SAVE_AND_SWITCH_TO_KERNEL_CR3 scratch_reg:req save_reg:req
 	ALTERNATIVE "jmp .Ldone_\@", "", X86_FEATURE_PTI
+	NOTE_CR3_SWITCH \scratch_reg $1
 	movq	%cr3, \scratch_reg
 	movq	\scratch_reg, \save_reg
 	/*
@@ -257,6 +274,7 @@ For 32-bit we have the following conventions - kernel is built with
 	bt	$PTI_USER_PGTABLE_BIT, \save_reg
 	jnc	.Lend_\@
 
+	NOTE_CR3_SWITCH \scratch_reg $0
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
 
 	/*
diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index 71f032504e731..5d7596a86f240 100644
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -83,6 +83,10 @@ static __always_inline bool do_syscall_x32(struct pt_regs *regs, int nr)
 	return false;
 }
 
+#ifdef CONFIG_TRACK_CR3
+DEFINE_PER_CPU_PAGE_ALIGNED(bool, kernel_cr3_loaded) = true;
+#endif
+
 /* Returns true to return using SYSRET, or false to use IRET */
 __visible noinstr bool do_syscall_64(struct pt_regs *regs, int nr)
 {
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0545fe75c3fa1..0ec669eb0b4e7 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,6 +17,9 @@
 #include <asm/pgtable.h>
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
+#ifdef CONFIG_TRACK_CR3
+DECLARE_PER_CPU_PAGE_ALIGNED(bool, kernel_cr3_loaded);
+#endif
 
 void __flush_tlb_all(void);
 
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index f7546e9e8e896..e75450cabd3a6 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -440,6 +440,18 @@ static void __init pti_clone_p4d(unsigned long addr)
 	*user_p4d = *kernel_p4d;
 }
 
+static void __init pti_clone_percpu(unsigned long va)
+{
+		phys_addr_t pa = per_cpu_ptr_to_phys((void *)va);
+		pte_t *target_pte;
+
+		target_pte = pti_user_pagetable_walk_pte(va, false);
+		if (WARN_ON(!target_pte))
+			return;
+
+		*target_pte = pfn_pte(pa >> PAGE_SHIFT, PAGE_KERNEL);
+}
+
 /*
  * Clone the CPU_ENTRY_AREA and associated data into the user space visible
  * page table.
@@ -450,25 +462,25 @@ static void __init pti_clone_user_shared(void)
 
 	pti_clone_p4d(CPU_ENTRY_AREA_BASE);
 
+	/*
+	 * This is done for all possible CPUs during boot to ensure that it's
+	 * propagated to all mms.
+	 */
 	for_each_possible_cpu(cpu) {
 		/*
 		 * The SYSCALL64 entry code needs one word of scratch space
 		 * in which to spill a register.  It lives in the sp2 slot
 		 * of the CPU's TSS.
-		 *
-		 * This is done for all possible CPUs during boot to ensure
-		 * that it's propagated to all mms.
 		 */
+		pti_clone_percpu((unsigned long)&per_cpu(cpu_tss_rw, cpu));
 
-		unsigned long va = (unsigned long)&per_cpu(cpu_tss_rw, cpu);
-		phys_addr_t pa = per_cpu_ptr_to_phys((void *)va);
-		pte_t *target_pte;
-
-		target_pte = pti_user_pagetable_walk_pte(va, false);
-		if (WARN_ON(!target_pte))
-			return;
-
-		*target_pte = pfn_pte(pa >> PAGE_SHIFT, PAGE_KERNEL);
+#ifdef CONFIG_TRACK_CR3
+		/*
+		 * The entry code needs access to the @kernel_cr3_loaded percpu
+		 * variable before the kernel CR3 is loaded.
+		 */
+		pti_clone_percpu((unsigned long)&per_cpu(kernel_cr3_loaded, cpu));
+#endif
 	}
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index ef152d401fe20..827e17760f1e2 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -18,7 +18,14 @@ enum hk_flags {
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
 };
 
-DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
+/*
+ * This key is accessed in early entry code to drive the CPU isolation IPI
+ * deferral mechanism. This happens before a serializing instruction has been
+ * executed in the entry path. This is acceptable as a stale value will only be
+ * observed during transient CPU isolation states, and the updated value will be
+ * acted upon at the next kernel exit.
+ */
+DEFINE_STATIC_KEY_FALSE_ENTRY(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
 struct housekeeping {
-- 
2.52.0


