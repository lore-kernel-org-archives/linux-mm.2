Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD171E9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524EC6B009F; Tue, 24 Mar 2026 05:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBEB6B00A1; Tue, 24 Mar 2026 05:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4121A6B00A2; Tue, 24 Mar 2026 05:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CDD96B009F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:50:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0756DE0D8C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:46 +0000 (UTC)
X-FDA: 84580487292.09.B8FCB5C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2870212000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMgpuJKn;
	spf=temperror (imf29.hostedemail.com: error in processing during lookup of vschneid@redhat.com: DNS error) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345844; a=rsa-sha256;
	cv=none;
	b=TAiYCMa48kBBHoBfGBT50TxOzxqXq4y03De4m5VNGIhy8KfMnPczHLTzjdJwfHhi32wfiL
	kpWSiyZ2iP7JVjCdtUR9pDddR4Kl5bo/r2y1/waD+QEzAoFrdabDSBtEDnIJkeBIVzmKyZ
	KO5LClgXKO4C8IsHIpfi4GotAsiN6mo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tg6n/oqixejy7VhwIIBWEvPzLaP7Ximx0xbVbwmAmuE=;
	b=pf7kAE3pjU4Rx+9Irmxaz345+9puRDekfWg6DeIXmlSf40mjYdZweTYhUgakm6lbgN2Mnm
	TuDJKoZ+YO5BunIAN6SqFHv3LyTLapXNAH1mLyVDTC3G8JTGowA0dH6NURV+KTwJH3yo7T
	vlGAXP5liD0Xra2qd7i6I38SYhXb+jE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CMgpuJKn;
	spf=temperror (imf29.hostedemail.com: error in processing during lookup of vschneid@redhat.com: DNS error) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tg6n/oqixejy7VhwIIBWEvPzLaP7Ximx0xbVbwmAmuE=;
	b=CMgpuJKnBWH154YBc95H8DWiNXqLA6nLtfTh34g4MZOSTO8LaQY4Wy32knIg9bZQ/lgvVI
	CVCrQAMjud6u/tbcdeq4vAdXLjWZdd2g9D05eXF8c9nXFLx9O1X1kn79OHRuEgW7+UKjhX
	O4ojz97uT3j6LQP0BNGiPDlobO9wMPs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-Svp_4I3WOleNg3hwdwqHoA-1; Tue,
 24 Mar 2026 05:50:39 -0400
X-MC-Unique: Svp_4I3WOleNg3hwdwqHoA-1
X-Mimecast-MFC-AGG-ID: Svp_4I3WOleNg3hwdwqHoA_1774345835
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63F90180044D;
	Tue, 24 Mar 2026 09:50:35 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7E0B300019F;
	Tue, 24 Mar 2026 09:50:21 +0000 (UTC)
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
Subject: [RFC PATCH v8 08/10] x86/mm/pti: Introduce a kernel/user CR3 software signal
Date: Tue, 24 Mar 2026 10:47:59 +0100
Message-ID: <20260324094801.3092968-9-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: r01Wq8PpFO3fdvmJkUdWOmpehAYeFyxfi1nnkNNFqi4_1774345835
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2870212000D
X-Stat-Signature: ssx3ptjs5zc6z9gbpr93s3dahnza41bm
X-HE-Tag: 1774345843-78276
X-HE-Meta: U2FsdGVkX19IjIiXL3ZWyYgQsScRV651iroPC3KC7P1F14j9up//MDIGCDPyncwCgpeWEytn2izdzmYyuUBeoOiHvYsxbZG+7MAV52EGEiU/VZVzLfPqagXUyugUDQjHXUYySn29zQOPWuT9YGAaTC+iNkxfa38tGWKvF0142ORiLSaC+konrH/BCPYY+VOUyLUgiUJriKjbOSz9w/4JN09+TmXzuZPJoPKkiIZbFzsYrHD275aD24fdgR4khCdApgOw3SAMe+G2MdIXZzrbnSTarQVACJfXML1nhaRfYSslgp5PYNwf/k1YD2TtvJ1njj2czVsU9witL/iovJkgxz4kXWfcj5nk7G9am6HE9YFKOfWo2j8yKemp2/T6TWRgL/D89RVLV0Ymh/Ei6Sjh+eVT9cn3Zo+6uDKpQnLvZ+I49GnT3HTIXjGtKz05m8EDSOTA/UCf8Ieea4W/sCFJ1vmDAdOicJvYOg3IHkZSIEAq6soyTwC7NHfbf+z5mojWAou03C4cisOugLBneRoOsWCajprN5y51/J6z/UW8QQ1oXE1cqj0sa+JxvqWstv6K9EUO98tjrpMMG88UPKOrGtWFf+okQUvuDrxaxFvhIGwFwEUPxlI3nRuvKFkrTXCIdT96Z0yKmFQ19KUuBFCYNCyfqYROkprzW8FWFE/mVeV7+GDSy6G9vE78Z+1g0lcwWZiIUfdtjA6DBk0KAZDBXnGp47140eCAlz1efqEHwxwWAixRuUoHRDyn58CuJBsmue8JVTc3jzrncVJBhM/8d9cUemrTy5x325g421MaTpZEEfNJcLWyXIQarn3ArHb0YI0xYjEGbm0naHKNpT6gOQawQvpVcP7wfu6HwKPkin9kT28gTJHhKJvrqKFS5CSAo3AaSGLjTPHtMtRogVEFRtDdGm9HyUsrP30bt61LJkXfzGW1APsf7JkWy8+fzsqcPuVxUI+b9GAkSrcbmXJ
 YXhg3bRa
 sUKEJxnQprkkPq8lu2A5i6TKLyE6nFED5sGa12zdGBtlUArEpmXIs5VtKGjB5+F6efNvvVXfbTcbgvfwYl+0l20Obc6lTHHeFEakhRRDodRwzaH1w9sH8qp/BhguaNaEOtJGaZDQ5hYizWIl/2lX2OtGSvbSW99g0MHygm7Qqhm7LCU3MWzvXlIS3BWC2pX0i9r1WMVyOJklvxVm640OmF8ICEspmQ3tBR/Yz50YObcJ7G5lXxGOWkKnk8jI8e410b/33Y5q+DehFYfX0Mh82IiYkjQt59SMzY/jjzXgXDfuabt6oe/Fr8Uc9mgSN1q0Zm27xS9FSS9fo9URCU1E0LsMTLLrdh7yIXnR9iE23x0RuhflWVz9K5qhtxPdlROlk3A+/Vly6J/kIgml6jWrK2DjMhX542gx0zsJQWZalk700TNsrlyYwIZZPc4LO/UCGWQCBlpT5fL/BmbGwbBiMP73KGGZf0j1lz8Xk
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
 arch/x86/entry/calling.h        | 13 ++++++++++++
 arch/x86/entry/syscall_64.c     |  4 ++++
 arch/x86/include/asm/tlbflush.h |  3 +++
 arch/x86/mm/pti.c               | 36 ++++++++++++++++++++++-----------
 5 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859a..f680e83cd5962 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2192,6 +2192,20 @@ config ADDRESS_MASKING
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
index 77e2d920a6407..4099b7d86efd9 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -9,6 +9,7 @@
 #include <asm/ptrace-abi.h>
 #include <asm/msr.h>
 #include <asm/nospec-branch.h>
+#include <asm/jump_label.h>
 
 /*
 
@@ -170,8 +171,17 @@ For 32-bit we have the following conventions - kernel is built with
 	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
 .endm
 
+.macro NOTE_CR3_SWITCH scratch_reg:req in_kernel:req
+#ifdef CONFIG_TRACK_CR3
+	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
+	movl \in_kernel, PER_CPU_VAR(kernel_cr3_loaded)
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
@@ -182,6 +192,7 @@ For 32-bit we have the following conventions - kernel is built with
 	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)
 
 .macro SWITCH_TO_USER_CR3 scratch_reg:req scratch_reg2:req
+	NOTE_CR3_SWITCH \scratch_reg $0
 	mov	%cr3, \scratch_reg
 
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
@@ -229,6 +240,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 .macro SAVE_AND_SWITCH_TO_KERNEL_CR3 scratch_reg:req save_reg:req
 	ALTERNATIVE "jmp .Ldone_\@", "", X86_FEATURE_PTI
+	NOTE_CR3_SWITCH \scratch_reg $1
 	movq	%cr3, \scratch_reg
 	movq	\scratch_reg, \save_reg
 	/*
@@ -257,6 +269,7 @@ For 32-bit we have the following conventions - kernel is built with
 	bt	$PTI_USER_PGTABLE_BIT, \save_reg
 	jnc	.Lend_\@
 
+	NOTE_CR3_SWITCH \scratch_reg $0
 	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID
 
 	/*
diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index b6e68ea98b839..7583f71978856 100644
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
index 00daedfefc1b0..3b3aceee701e6 100644
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
 
-- 
2.52.0


