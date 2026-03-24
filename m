Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69411E9A754
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14276B00A1; Tue, 24 Mar 2026 05:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC44B6B00A3; Tue, 24 Mar 2026 05:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB41D6B00A4; Tue, 24 Mar 2026 05:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A539D6B00A1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:51:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75D9C1619BF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:51:02 +0000 (UTC)
X-FDA: 84580487964.11.AF125BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 833D51C0011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=amtmckzY;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gat9n9rqQs56/qB2UIuZaMkqQi+a1E0dBrxpCkg7CqE=;
	b=DIcA5qtmDj0gF7Kk/l5i3Qa/tzbvoijyXJm1DCIhZTiMy2nAYZa0btFaRWEhzjOdriKoI7
	MGyZJpN/kU7gIcvQihKUMYvXLa9j+fqPF+5uV9BZMxtZdP96OzDY2AjV6UqcFtwK1MDyu/
	sL6xNdovw+TGbR7AWNzpvvC2hkUBdFQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=amtmckzY;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345860; a=rsa-sha256;
	cv=none;
	b=SD1yF0rseh0E6ZiePwYkiUDbTOst7b1wxte60v52ms/ttVQCeCv6C00F8emZAICvkqvWOY
	HNkJ+mSIVavpjDeicqXxuinK9XRbzQvZI7P14+EyESiN1T0WAuTNUu1fnE3/zzsFdMUzAY
	2OZiZDY1a0H/WYWbUEjvet5Mh9eTqPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gat9n9rqQs56/qB2UIuZaMkqQi+a1E0dBrxpCkg7CqE=;
	b=amtmckzYZXEHzejzb0uoi137Vv9OhuvMUgaE3upiR1/cq9KpHoN2U1sY87uEguF0MONuR3
	/9FapJnUYoUQHVe5EDFLLClff5JgFaDFk0t8/lmyK5t18THEvCVeIGhKLXgrYwsN93zCG2
	RYFqoctNJLM1jU8c9IoiKr0J6hksu1E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-B5zXNt9rNpyEt3OiBpBtfg-1; Tue,
 24 Mar 2026 05:50:55 -0400
X-MC-Unique: B5zXNt9rNpyEt3OiBpBtfg-1
X-Mimecast-MFC-AGG-ID: B5zXNt9rNpyEt3OiBpBtfg_1774345850
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6F7F1800281;
	Tue, 24 Mar 2026 09:50:50 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D57C830001BB;
	Tue, 24 Mar 2026 09:50:35 +0000 (UTC)
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
Subject: [RFC PATCH v8 09/10] context_tracking,x86: Defer kernel text patching IPIs when tracking CR3 switches
Date: Tue, 24 Mar 2026 10:48:00 +0100
Message-ID: <20260324094801.3092968-10-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: rau2glKmVIrghuAd_rXrhrKeW5jMAxu3BGY4QgMWlac_1774345850
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 833D51C0011
X-Stat-Signature: i4hcho8pnnz5fdk6crmzudm7kqc3gkms
X-Rspam-User: 
X-HE-Tag: 1774345860-961006
X-HE-Meta: U2FsdGVkX194nEqafck8RzdCWozJorJhOe8KLWR/Ev4wP5qON2TLp/ltleCB4lpjBvdgYdqWPdeAMdjozfF5lEjfRBJu80fcotRo7uWQ+6Co5NUVEeXVs6Z7nan0qJYz2Bikgr+gZ4jVxooGcFGOMbPXW0vHsX0eD4THgvXATZJyquM7rUTtLIUb+XcGDZTaK0hLEbX1qoCfsOqgrcP9NvLuOT3Qd2xjjWRCLdItN2/BsXa6tCR9l2l9J8j6cLLQucMbqVvYu3P66SY9RXWC1QLM+7ypJ1USvR4UbXtuzN3hPat9qhKoLyxdMbZoXF3BKenr0H39Ve3zKztDkIB2MVls2kga+5JIqQxvOpdjxSMrLKf7RRlorrE5BdN9usKqu8ws1Zb+ioKewyZoh0gkCcOKY5LpKPpP84iYETJ+4uSQn5yqqBEDIQWjzECYGkEsRSW957n3m2xUcsx/t+C1OexCjdz9zp1mSzDBTaE/RR9RQOISA+u66GrEA/cSxmzuTL5Gh+sVeXOCJOReul3yCtegYEVONRiTlIk0fMMEpjI0MmQsKwgYTs26ELCeDrFfODtAINCzchxRDbuBUwvChs4d3fVD2RMRw2LGwcK6doGyp+T7mbpPL2JDjwGH42CqZCHz1EOP3wcmNghpdzkxKQc1NnGLTRiu7k84ZOSA1kQ80pIodOyTtfMIrkEnA5ndl4pp+XkJrl5c1hnX10AFGqnlhWiPZTtxdaRg3gYoXyUsqgvIo+bPcuafurgPpqX6WwdHsCHpncSukAxMf0L1Dl3wKTSx1RchxPQ6T2w6PcrqsqdIYotUK/i0ajqbPblIA0f0oRkgQ7cnf0BIufazD2GMZpbMOhrIvGLPMmLRBtregMXPJljwu0Axypt0SNU2fs0CLDZ5zR8WTzG/ngnLnV9aI3QemSa8meoj/CLCP2wiLB+pFRMpRf2vEn41guiSRFsIq/J/VO3zDYuhy2o
 sm/G43cl
 NO8fg/0beY73ijlgah7mr5G3XyZLbBd4oWAae0mzZ8pg0WK1ijowI0j79H+O0UvoxfOv2QYRW0tgwZqhiNCUVukblHxqYobyxge5mpfGAbtDsDMNTnt1MgZ2EtpMRoQnDHdOa1OkqaZxp28YFMnQ6XnLPiGbTGLn3t9HYT7cdaYBVanZqDDqTAGcES0K7HnMdHMQlw3B3ALFxlsVPaxX9tL0lVEPuoKOtJpKhqLZhLBktNvf2gBYLppZ/Pt3j6rNMLUE4rsY8/qf8xo1WrlF1qwTuf3VJCjEkMJDpVyFUpGw5R0UE2u1ctQmBbJ2TTkIU4DUGqpK5aUNgH69czKCykOAo6NO7o6dYCn/Y6fBrwlgcAckwja2mXsMuKp7EpMMMUgVBHAGJF/0X+HtK5/sn9unokp2A47HgLMIZ2WzAs6gi3cSszTrIMeZ5ZwpQy2lQgIT1q5jSavInW+gB8A4eQleZeYKiDAIAkV7i/4fw8oPSJU7PA1vbRtrjy2/wJLFvyvTkgxzqjkssVjvWHoiS7eVTR9IGt2Ut4q4a
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
 arch/x86/include/asm/text-patching.h |  5 ++++
 arch/x86/kernel/alternative.c        | 34 +++++++++++++++++++++++-----
 arch/x86/kernel/kprobes/core.c       |  4 ++--
 arch/x86/kernel/kprobes/opt.c        |  4 ++--
 arch/x86/kernel/module.c             |  2 +-
 5 files changed, 38 insertions(+), 11 deletions(-)

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
index 28518371d8bf3..f3af77d7c533c 100644
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
 
@@ -2706,11 +2708,29 @@ static void do_sync_core(void *info)
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
+	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
+	       per_cpu(kernel_cr3_loaded, cpu);
 }
 
+void smp_text_poke_sync_each_cpu_deferrable(void)
+{
+	__smp_text_poke_sync_each_cpu(do_sync_core_defer_cond);
+}
+#endif
+
 /*
  * NOTE: crazy scheme to allow patching Jcc.d32 but not increase the size of
  * this thing. When len == 6 everything is prefixed with 0x0f and we map
@@ -2914,11 +2934,13 @@ void smp_text_poke_batch_finish(void)
 	 * First step: add a INT3 trap to the address that will be patched.
 	 */
 	for (i = 0; i < text_poke_array.nr_entries; i++) {
-		text_poke_array.vec[i].old = *(u8 *)text_poke_addr(&text_poke_array.vec[i]);
-		text_poke(text_poke_addr(&text_poke_array.vec[i]), &int3, INT3_INSN_SIZE);
+		void *addr = text_poke_addr(&text_poke_array.vec[i]);
+
+		text_poke_array.vec[i].old = *((u8 *)addr);
+		text_poke(addr, &int3, INT3_INSN_SIZE);
 	}
 
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 
 	/*
 	 * Second step: update all but the first byte of the patched range.
@@ -2980,7 +3002,7 @@ void smp_text_poke_batch_finish(void)
 		 * not necessary and we'd be safe even without it. But
 		 * better safe than sorry (plus there's not only Intel).
 		 */
-		smp_text_poke_sync_each_cpu();
+		smp_text_poke_sync_each_cpu_deferrable();
 	}
 
 	/*
@@ -3001,7 +3023,7 @@ void smp_text_poke_batch_finish(void)
 	}
 
 	if (do_sync)
-		smp_text_poke_sync_each_cpu();
+		smp_text_poke_sync_each_cpu_deferrable();
 
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
 
-- 
2.52.0


