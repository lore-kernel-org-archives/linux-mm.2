Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52043FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B1E6B00A4; Tue,  5 May 2026 04:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62D86B00A6; Tue,  5 May 2026 04:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78CE6B00A7; Tue,  5 May 2026 04:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97AB76B00A4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:26:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D099160360
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:57 +0000 (UTC)
X-FDA: 84732685674.22.B050F3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3DEEFC0006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Urlpuxq2;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3MM+Rrr4gllCDOAXA/Nf1PZQdNA+vK+kEYbUU2YmTg=;
	b=Or9yZGdRz4aj3t9/RYeR10GvDhjJDw+eBBMGw1jE2i86Oc/l1B8i0lPtncpBi17SJCa5pO
	TrMDsfUbJdUgi7DkPpaedI3dGyBWROndZdF/FEqU87oLDkQ6F+zExCFLZWs1XXIS3fIFIG
	GVPTSB/pIkhKErIddSgvv56oopKAIX8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Urlpuxq2;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969615; a=rsa-sha256;
	cv=none;
	b=V+RdEdhqotNnGOoCwh0PysJj+OC+fsfeAaJqRnGPAu1dPXB8brqCP/CIgNVROfiwT0q4GF
	5xZpbzonFJc11YLxNAGVkytru+NsLOWeZ5W32MfVc/gk/dWv3rex7vx9CdX6aZik5tx5zj
	QBXl/ysjWYPdw7FQB1THQq0xYN5Mc14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c3MM+Rrr4gllCDOAXA/Nf1PZQdNA+vK+kEYbUU2YmTg=;
	b=Urlpuxq2nE9wAnoOcqagFgDzexLbe0jN7oNgAbLkrVYic2JkSTsDnAjfM0L90KDpUv8Uzq
	DtiX45JQ+w1W5iEDI67QEfNLowoYSybS7w6nGoWxCOTugxC+lNB8Vcl6RFp1p0bQzqaiDz
	kE1/vmBZA7xLM0KXm1rxLw2ykhgjs7w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-hB-RglEGNquoXBpJTHj0OA-1; Tue,
 05 May 2026 04:26:49 -0400
X-MC-Unique: hB-RglEGNquoXBpJTHj0OA-1
X-Mimecast-MFC-AGG-ID: hB-RglEGNquoXBpJTHj0OA_1777969605
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44EFF19560A6;
	Tue,  5 May 2026 08:26:45 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1519F30001A1;
	Tue,  5 May 2026 08:26:31 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
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
Subject: [PATCH v9 09/10] context_tracking,x86: Defer kernel text patching IPIs when tracking CR3 switches
Date: Tue,  5 May 2026 10:23:54 +0200
Message-ID: <20260505082355.1982003-10-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ic8oYfWsELBuKWgP8vQ0olkbXCYK3LEqIrXlX50n2jQ_1777969605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DEEFC0006
X-Stat-Signature: zrd4mrnc15bd3sxc78pf8ygysajih4u6
X-HE-Tag: 1777969615-860673
X-HE-Meta: U2FsdGVkX1+qYa3uUVKg5ziBfk/i0hRiflQe9+OqtweDZ0Rx6Ik0a2+TDgX8Od9vHs5+85ZtXI7oVDCy1cfAr6RuJDF6bPOd89eEdWqop1i5AhJMLfadk7anAFsWqu9Dyg6CcRgZGVEkd0ZoXPGUQ5IL7U2XxURRJ85ybI/94pR6KnwYNrGc/dt2zYFPIs+R48eWkY4GmDkhexskkr/Gu1PlJo+iAYK2nElZ9N4x42UVNJvKEJrEhTGroB0ZFTVPNL8e0dtYYIzPydsx2EgdN9PI3KIwSICHA6Jq1cwtTzSJKWx9TNeK/2znNlMU3ko5hWktaKnd3Cq3Qyx061Xla3Tl748CiJ1oruleDZw5wD8ZJ+h74FODo7hslN9nylsW9NEr/5HhrfI1sCnQ/ErW5RdUK9ZADnlAlboJywKKmfUQsXnzl3kvn/Qcw48ilw53dWDMs3n/xyfhLq44VNRgWAPPOQ98QiodACfN3VP8gFYog/ji9fm05WfQHSQ0iWwt9aRnpcM7oHbcNXGcH3CkoQVtIIII26Ik9N9hgjZLNt9RU/8Clt4UmJ9KADKXbh1MawpSW1XO1gR9kyAFaG8CwaXTpPJt2vAqbvPslQM/mukJilhH4FWpxgEgIjOCg3/FtKhfL9pX/3QFPueC1G99I2SI2Wy4BKjg6ubT7NX1aQboUXXvd9WYpGPnWdXACj9uDogF6vx2VrcpFeb03Hyat2Hr3QbSUd4Rg3yB1T3m+8jrrLJxg4ZBSOoBF7IoErxwMbg1exVkX43kEmHRx8WaUHde5mvy+vgEYX7GUP+vHdH66jOHnRmOk6JwrxFXyOVneTn9fM20i85Qnvgz19P8bmy3vvB80sx1BK2Wuh4ZjdKfqnPj46EhKboAfhehJ12e2QM//VQ8vwGJp9gHC8U3FO7bCOcCeh3T10AZSaQ9mBHtW1WWSvq28hMPx8nJKrCBEvWvs5A7Dr7n9Kvm5r/
 Qb+Nppyz
 QV/7a7yfyIEzNB+WWYj7BIVFa6efUzTNYQWrktnHu0hNkQm3BkJTrRf28xHffCqaNiGPes7290m6bom/pNDjr9IRpbx1GjTEKl6tXRcX8xipxYR0kzcaCWYW+vAATw2KA7N8MptsVjCh6hP934n6c4yKWLFLJWgQbtbte+fIy2LwvC7PtNEK5WIS7XQBiQ1LR+klAIGWsG0CdaBazM+jAgwa40KllVOBbNVSdiCKDmRsCFMvDmB6YfI228kUlixaWm5Py2K/J8GbOGdpJbwXYGcuWH3oKjJJFUoe25vZZgTCyN+gNo4OfZI69b15jjgEzVP9p1P7Oo9EgrE6yurqUJUUdFkWjAnPZXkoEgD6xtxwIa4EgMep11tK+xpYRlQ+wuubRHYHDWrlJyPHjv1EvWN1oInpvod4zZGO7JuwWkrePo77UKjc9hiFIn7/GZ/WJNZ7ZXKtIhZbomuHI4hDzj8kyQMq1JIzEYfi9GAfBUb/lO51p61MJzuLI0nLspzImcUiEa6JSHawoEqewIdgd9WDyr8PPNSHKEfKo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

text_poke_bp_batch() sends IPIs to all online CPUs to synchronize
them vs the newly patched instruction. CPUs that are executing in userspace
do not need this synchronization to happen immediately, and this is
actually harmful interference for NOHZ_FULL CPUs.

As the synchronization IPIs are sent using a blocking call, returning from
text_poke_bp_batch() implies all CPUs will observe the patched
instruction(s), and this should be preserved even if the IPI is deferred.
In other words, to safely defer this synchronization, any kernel
instruction leading to the execution of the deferred instruction
sync must *not* be mutable (patchable) at runtime.

This means we must pay attention to mutable instructions in the early entry
code:
- alternatives
- static keys
- static calls
- all sorts of probes (kprobes/ftrace/bpf/???)

The early entry code is noinstr, which gets rid of the probes.

Alternatives are safe, because it's boot-time patching (before SMP is
even brought up) which is before any IPI deferral can happen.

This leaves us with static keys and static calls. Any static key used in
early entry code should be only forever-enabled at boot time, IOW
__ro_after_init (pretty much like alternatives). Exceptions to that will
now be caught by objtool.

The deferred instruction sync is the CR3 RMW done as part of
kPTI when switching to the kernel page table:

  SDM vol2 chapter 4.3 - Move to/from control registers:
  ```
  MOV CR* instructions, except for MOV CR8, are serializing instructions.
  ```

Leverage the new kernel_cr3_loaded signal and the kPTI CR3 RMW to defer
sync_core() IPIs targeting NOHZ_FULL CPUs.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/text-patching.h |  5 +++
 arch/x86/kernel/alternative.c        | 57 +++++++++++++++++++++++++---
 arch/x86/kernel/kprobes/core.c       |  4 +-
 arch/x86/kernel/kprobes/opt.c        |  4 +-
 arch/x86/kernel/module.c             |  2 +-
 include/asm-generic/sections.h       | 14 +++++++
 6 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index f2d142a0a862e..628e80f8318cd 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -33,6 +33,11 @@ extern void text_poke_apply_relocation(u8 *buf, const u8 * const instr, size_t i
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void smp_text_poke_sync_each_cpu(void);
+#ifdef CONFIG_TRACK_CR3
+extern void smp_text_poke_sync_each_cpu_deferrable(void);
+#else
+#define smp_text_poke_sync_each_cpu_deferrable smp_text_poke_sync_each_cpu
+#endif
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern void *text_poke_copy(void *addr, const void *opcode, size_t len);
 #define text_poke_copy text_poke_copy
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 62936a3bde19b..e2d185e6cb7ca 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -6,6 +6,7 @@
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 #include <linux/execmem.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/text-patching.h>
 #include <asm/insn.h>
@@ -13,6 +14,7 @@
 #include <asm/ibt.h>
 #include <asm/set_memory.h>
 #include <asm/nmi.h>
+#include <asm/tlbflush.h>
 
 int __read_mostly alternatives_patched;
 
@@ -2768,10 +2770,43 @@ static void do_sync_core(void *info)
 	sync_core();
 }
 
+static void __smp_text_poke_sync_each_cpu(smp_cond_func_t cond_func)
+{
+	on_each_cpu_cond(cond_func, do_sync_core, NULL, 1);
+}
+
 void smp_text_poke_sync_each_cpu(void)
 {
-	on_each_cpu(do_sync_core, NULL, 1);
+	__smp_text_poke_sync_each_cpu(NULL);
+}
+
+#ifdef CONFIG_TRACK_CR3
+static bool do_sync_core_defer_cond(int cpu, void *info)
+{
+	/*
+	 * Send the IPI if the target CPU is a housekeeping one, or if it is
+	 * already executing in kernelspace.
+	 */
+	bool ret = housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+
+	/*
+	 * Pairs with the LOCK in NOTE_KERNEL_CR3
+	 *
+	 * Ensures any previous operations are visible on a remote CPU
+	 * entering the kernel and setting @kernel_cr3_loaded, if this one
+	 * decides to defer the IPI.
+	 */
+	smp_mb();
+	ret |= per_cpu(kernel_cr3_loaded, cpu);
+
+	return ret;
+}
+
+void smp_text_poke_sync_each_cpu_deferrable(void)
+{
+	__smp_text_poke_sync_each_cpu(do_sync_core_defer_cond);
 }
+#endif
 
 /*
  * NOTE: crazy scheme to allow patching Jcc.d32 but not increase the size of
@@ -2940,6 +2975,7 @@ noinstr int smp_text_poke_int3_handler(struct pt_regs *regs)
  */
 void smp_text_poke_batch_finish(void)
 {
+	void (*sync_fn)(void) = smp_text_poke_sync_each_cpu_deferrable;
 	unsigned char int3 = INT3_INSN_OPCODE;
 	unsigned int i;
 	int do_sync;
@@ -2976,11 +3012,20 @@ void smp_text_poke_batch_finish(void)
 	 * First step: add a INT3 trap to the address that will be patched.
 	 */
 	for (i = 0; i < text_poke_array.nr_entries; i++) {
-		text_poke_array.vec[i].old = *(u8 *)text_poke_addr(&text_poke_array.vec[i]);
-		text_poke(text_poke_addr(&text_poke_array.vec[i]), &int3, INT3_INSN_SIZE);
+		void *addr = text_poke_addr(&text_poke_array.vec[i]);
+
+		/*
+		 * There's no safe way to defer IPIs for patching text in
+		 * entry, record whether there is at least one such poke.
+		 */
+		if (is_kernel_entrytext((unsigned long)addr))
+			sync_fn = smp_text_poke_sync_each_cpu;
+
+		text_poke_array.vec[i].old = *((u8 *)addr);
+		text_poke(addr, &int3, INT3_INSN_SIZE);
 	}
 
-	smp_text_poke_sync_each_cpu();
+	sync_fn();
 
 	/*
 	 * Second step: update all but the first byte of the patched range.
@@ -3042,7 +3087,7 @@ void smp_text_poke_batch_finish(void)
 		 * not necessary and we'd be safe even without it. But
 		 * better safe than sorry (plus there's not only Intel).
 		 */
-		smp_text_poke_sync_each_cpu();
+		sync_fn();
 	}
 
 	/*
@@ -3063,7 +3108,7 @@ void smp_text_poke_batch_finish(void)
 	}
 
 	if (do_sync)
-		smp_text_poke_sync_each_cpu();
+		sync_fn();
 
 	/*
 	 * Remove and wait for refs to be zero.
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index c1fac3a9fecc2..61a93ba30f255 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -789,7 +789,7 @@ void arch_arm_kprobe(struct kprobe *p)
 	u8 int3 = INT3_INSN_OPCODE;
 
 	text_poke(p->addr, &int3, 1);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 	perf_event_text_poke(p->addr, &p->opcode, 1, &int3, 1);
 }
 
@@ -799,7 +799,7 @@ void arch_disarm_kprobe(struct kprobe *p)
 
 	perf_event_text_poke(p->addr, &int3, 1, &p->opcode, 1);
 	text_poke(p->addr, &p->opcode, 1);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 }
 
 void arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 6f826a00eca29..3b3be66da320c 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -509,11 +509,11 @@ void arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	       JMP32_INSN_SIZE - INT3_INSN_SIZE);
 
 	text_poke(addr, new, INT3_INSN_SIZE);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 	text_poke(addr + INT3_INSN_SIZE,
 		  new + INT3_INSN_SIZE,
 		  JMP32_INSN_SIZE - INT3_INSN_SIZE);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 
 	perf_event_text_poke(op->kp.addr, old, JMP32_INSN_SIZE, new, JMP32_INSN_SIZE);
 }
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 11c45ce42694c..0894b1f38de77 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -209,7 +209,7 @@ static int write_relocate_add(Elf64_Shdr *sechdrs,
 				   write, apply);
 
 	if (!early) {
-		smp_text_poke_sync_each_cpu();
+		smp_text_poke_sync_each_cpu_deferrable();
 		mutex_unlock(&text_mutex);
 	}
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 0755bc39b0d80..7496d26a85a4c 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -199,6 +199,20 @@ static inline bool is_kernel_inittext(unsigned long addr)
 	       addr < (unsigned long)_einittext;
 }
 
+/**
+ * is_kernel_entrytext - checks if the pointer address is located in the
+ *                      .entry.text section
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in .entry.text, false otherwise.
+ */
+static inline bool is_kernel_entrytext(unsigned long addr)
+{
+	return addr >= (unsigned long)__entry_text_start &&
+	       addr < (unsigned long)__entry_text_end;
+}
+
 /**
  * __is_kernel_text - checks if the pointer address is located in the
  *                    .text section
-- 
2.52.0


