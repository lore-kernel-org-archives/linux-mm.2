Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADC0CE7B1F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F768E002E; Fri, 14 Nov 2025 10:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FD98E0002; Fri, 14 Nov 2025 10:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7958E002E; Fri, 14 Nov 2025 10:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A80A38E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:16:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52CB412DDBE
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:10 +0000 (UTC)
X-FDA: 84109563300.27.06C4C17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3BDE040023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pza14FkG;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZcT1Q7WbmOBLgKadBtI1A3F7m35fxkqgToUirFNbpE=;
	b=qHStYjM9xr94WsKb/lOXMrq7pfwUgAkMldjZfCjGSXOA/xqrMk24XPnqqluxyMHE48tlcl
	zkOZgqYcWWKk9Vkz9K/NOdqVkFQJuOUZlXuhhkzGPkYIHGYTa7WHk11qpJSsYmjFQnm+y8
	Y0AiK0O/sKhFkFzlUDE/unyCN/MM87o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133368; a=rsa-sha256;
	cv=none;
	b=1miPAJLn5OdEr3eUFY7ozi4PS9ufQCNvvlQkq2t2fXvglWhtvKaGspL5OPeWBq+sRJGfiI
	gHsbIdXErhDphoDuD1HH2JlXKxSDFPOW1PEacFhB4T3AgjN0Zq2jqGiNOOlNxaSR5voARN
	tfCogVeb5AmKC9Q0Sofh/zW5/n5fMxI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pza14FkG;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WZcT1Q7WbmOBLgKadBtI1A3F7m35fxkqgToUirFNbpE=;
	b=Pza14FkGuNmgz4tKAB2ZX62wC+Zo7sgdds6W9YMQmlOMokSerhCE7eXLLHvvWEsFzaKyFp
	cO8MkE3td5a5BbPor/FXE991tC+al7gS0on8G2yGL4UterzKosR6oDgUUrgRwOYPKVZIjh
	TeHuGmzSoS3PJ/DWrY7zI5fMz3UWiqg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-0ZR_8xnzNWiuFcmFrrPZ5Q-1; Fri,
 14 Nov 2025 10:16:05 -0500
X-MC-Unique: 0ZR_8xnzNWiuFcmFrrPZ5Q-1
X-Mimecast-MFC-AGG-ID: 0ZR_8xnzNWiuFcmFrrPZ5Q_1763133359
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E23C1805ECE;
	Fri, 14 Nov 2025 15:15:59 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E84BF18004D8;
	Fri, 14 Nov 2025 15:15:41 +0000 (UTC)
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
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: [PATCH v7 25/31] context_tracking,x86: Defer kernel text patching IPIs
Date: Fri, 14 Nov 2025 16:14:22 +0100
Message-ID: <20251114151428.1064524-5-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BDE040023
X-Stat-Signature: 16pd8akqmcnx87oqdwe1sohbou9u9xnp
X-HE-Tag: 1763133368-447056
X-HE-Meta: U2FsdGVkX19h9Vpr/7SLwOMwxGOdr4GWreu/byovx67fPX/A6YlVWw33If5fSWbF0Ack9nU2Xg3RatY0z2nNPbAssSz9Cf1a/b9pTSCVdqxj75Mo7t6fjVcrlBO1r94FXYhog4jp27Jb1F1rS7GFjc/0WDfAYazu7EloUptkjlbec1u4PewzG6HLJbz9VFnwD9QAjL23QxWhhNx1X4mOk68+iYXivFDtrjpIuxmPHUp8MMhYuT8Npal58miI2uw3eQ9ttFpx+FcQoq6TJNAqsrKnjDT2Ld+kuAAKyfm/Q4YEOiOxKJFVtCeCaFpfs2RVozQg3YLeI5XZGklwCabqhuJdT4DuzrdTMRgNgGDlyuKpyGrykd6bX5fdMVRToJwukDmhBZ9dXJQwe6UuYj/ERxtoonThs4c5BL5jGboJLwURNcT0iBLXBbbPgVVKCQ/kmemDDyW9wFWgeJ3Iemv2NA/HcYR4/9Pgk9n0KkMFNoInBCvIgwTfbo+YPP1rW2YS5RxXyfEuSputGeISMH+QYrbyoDLYY6L/vt5Xz14wvUqp9SXJnIn4HmYP9FWnA/toYIe3M2L8PJans7fJEPR62VBSBt0B1pOkMWRtOa2ADKd3WjET+3gcmbhlD+cYgb5I0dkZq9Era7bffpF/3E5lhDViIAYMp4IKrGN8SsuHyERlzaumMv4q8MzIETd1HTT8pTm88+f1WzJySg92x+Ay1qREPyZWM7lVXp3U4/v+yrHXNrBlKe/2dYmvhCGHES4HDmLfSpbw/pNAu0XpAdmLjfKcxmv2yRedOPomrLzE8+DoO3nmIqkC2SCyJPSUvMCfLYOUefdj7uHTG+nzBejwApJsVl9fx7HIbytiL02/4IE7Tb/8JLJnR6YO6LvNSYqqTrI903s+0owAv9wSo205TsqYGT5hd8UELvOdlegzSxNPJcAKsCicdw93u4IGzTLusEzMaGTeLK4+i54702J
 kDez/ahL
 /vxDsAcxfbo7Kzk+3tLoVvWVLjD8V0+fqdeA+aP57woH83USmna8vZVop69Hoo5WfzuknNEvt1JMR7ejHVG39IYVhlFnr8nfHF8wEB3/CyWVXz68+UAq1IzasopdLDS4bYlIcA8WOhu6sroIY/MkMw6Hr2wCWYLvgES/w65pNY5t3/c4po79DZ890JQBU3eg+NjzkBxwLzAAPqnioiVgJN6/QYNY/6IEmhQShfoNdXCxyFPzftJ1eP/oxyz0ZO94YIqFMNLr4+NlMEYuhd6Vs9G3jP0GSRHfnfoglLBtz2AAYzgaiAfHjPw0vMmUm4qtltAq+0QaCgTRKWaeLm+ICizKsBZOyzoDZHCLYR0R4U40AYz6LDZG64uPgrLtLnGYvZHAPuSagxQKAMJpazO1cbYUBgJ+e6EsgGOZG5msxKMbD6Jxoaz1jcuEfk/jBax20X8lWwa2cRu+AyxaJbXx+SkMj5A9dDTbbsusAaZnOQ2iukpJ8Sfcu8V3xZtiOmXx9Wx9W7vV1KDbf2w+0A0Vcio1Cgx7seErGIFO/50/dgOkCbtiNgnbRiyuSng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
sync (ct_work_flush()) must *not* be mutable (patchable) at runtime.

This means we must pay attention to mutable instructions in the early entry
code:
- alternatives
- static keys
- static calls
- all sorts of probes (kprobes/ftrace/bpf/???)

The early entry code leading to ct_work_flush() is noinstr, which gets rid
of the probes.

Alternatives are safe, because it's boot-time patching (before SMP is
even brought up) which is before any IPI deferral can happen.

This leaves us with static keys and static calls.

Any static key used in early entry code should be only forever-enabled at
boot time, IOW __ro_after_init (pretty much like alternatives). Exceptions
are explicitly marked as allowed in .noinstr and will always generate an
IPI when flipped.

The same applies to static calls - they should be only updated at boot
time, or manually marked as an exception.

Objtool is now able to point at static keys/calls that don't respect this,
and all static keys/calls used in early entry code have now been verified
as behaving appropriately.

Leverage the new context_tracking infrastructure to defer sync_core() IPIs
to a target CPU's next kernel entry.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
---
 arch/x86/include/asm/context_tracking_work.h |  6 ++-
 arch/x86/include/asm/text-patching.h         |  1 +
 arch/x86/kernel/alternative.c                | 39 +++++++++++++++++---
 arch/x86/kernel/kprobes/core.c               |  4 +-
 arch/x86/kernel/kprobes/opt.c                |  4 +-
 arch/x86/kernel/module.c                     |  2 +-
 include/asm-generic/sections.h               | 15 ++++++++
 include/linux/context_tracking_work.h        |  4 +-
 8 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/context_tracking_work.h b/arch/x86/include/asm/context_tracking_work.h
index 5f3b2d0977235..485b32881fde5 100644
--- a/arch/x86/include/asm/context_tracking_work.h
+++ b/arch/x86/include/asm/context_tracking_work.h
@@ -2,11 +2,13 @@
 #ifndef _ASM_X86_CONTEXT_TRACKING_WORK_H
 #define _ASM_X86_CONTEXT_TRACKING_WORK_H
 
+#include <asm/sync_core.h>
+
 static __always_inline void arch_context_tracking_work(enum ct_work work)
 {
 	switch (work) {
-	case CT_WORK_n:
-		// Do work...
+	case CT_WORK_SYNC:
+		sync_core();
 		break;
 	case CT_WORK_MAX:
 		WARN_ON_ONCE(true);
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index f2d142a0a862e..ca989b0b6c0ae 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -33,6 +33,7 @@ extern void text_poke_apply_relocation(u8 *buf, const u8 * const instr, size_t i
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void smp_text_poke_sync_each_cpu(void);
+extern void smp_text_poke_sync_each_cpu_deferrable(void);
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern void *text_poke_copy(void *addr, const void *opcode, size_t len);
 #define text_poke_copy text_poke_copy
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 8ee5ff547357a..ce8989e02ae77 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -6,6 +6,7 @@
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 #include <linux/execmem.h>
+#include <linux/context_tracking.h>
 
 #include <asm/text-patching.h>
 #include <asm/insn.h>
@@ -2708,9 +2709,24 @@ static void do_sync_core(void *info)
 	sync_core();
 }
 
+static bool do_sync_core_defer_cond(int cpu, void *info)
+{
+	return !ct_set_cpu_work(cpu, CT_WORK_SYNC);
+}
+
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
+void smp_text_poke_sync_each_cpu_deferrable(void)
+{
+	__smp_text_poke_sync_each_cpu(do_sync_core_defer_cond);
 }
 
 /*
@@ -2880,6 +2896,7 @@ noinstr int smp_text_poke_int3_handler(struct pt_regs *regs)
  */
 void smp_text_poke_batch_finish(void)
 {
+	smp_cond_func_t cond = do_sync_core_defer_cond;
 	unsigned char int3 = INT3_INSN_OPCODE;
 	unsigned int i;
 	int do_sync;
@@ -2916,11 +2933,21 @@ void smp_text_poke_batch_finish(void)
 	 * First step: add a INT3 trap to the address that will be patched.
 	 */
 	for (i = 0; i < text_poke_array.nr_entries; i++) {
-		text_poke_array.vec[i].old = *(u8 *)text_poke_addr(&text_poke_array.vec[i]);
-		text_poke(text_poke_addr(&text_poke_array.vec[i]), &int3, INT3_INSN_SIZE);
+		void *addr = text_poke_addr(&text_poke_array.vec[i]);
+
+		/*
+		 * There's no safe way to defer IPIs for patching text in
+		 * .noinstr, record whether there is at least one such poke.
+		 */
+		if (is_kernel_noinstr_text((unsigned long)addr) ||
+		    is_module_noinstr_text_address((unsigned long)addr))
+			cond = NULL;
+
+		text_poke_array.vec[i].old = *((u8 *)addr);
+		text_poke(addr, &int3, INT3_INSN_SIZE);
 	}
 
-	smp_text_poke_sync_each_cpu();
+	__smp_text_poke_sync_each_cpu(cond);
 
 	/*
 	 * Second step: update all but the first byte of the patched range.
@@ -2982,7 +3009,7 @@ void smp_text_poke_batch_finish(void)
 		 * not necessary and we'd be safe even without it. But
 		 * better safe than sorry (plus there's not only Intel).
 		 */
-		smp_text_poke_sync_each_cpu();
+		__smp_text_poke_sync_each_cpu(cond);
 	}
 
 	/*
@@ -3003,7 +3030,7 @@ void smp_text_poke_batch_finish(void)
 	}
 
 	if (do_sync)
-		smp_text_poke_sync_each_cpu();
+		__smp_text_poke_sync_each_cpu(cond);
 
 	/*
 	 * Remove and wait for refs to be zero.
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 3863d7709386f..51957cd737f52 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -790,7 +790,7 @@ void arch_arm_kprobe(struct kprobe *p)
 	u8 int3 = INT3_INSN_OPCODE;
 
 	text_poke(p->addr, &int3, 1);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 	perf_event_text_poke(p->addr, &p->opcode, 1, &int3, 1);
 }
 
@@ -800,7 +800,7 @@ void arch_disarm_kprobe(struct kprobe *p)
 
 	perf_event_text_poke(p->addr, &int3, 1, &p->opcode, 1);
 	text_poke(p->addr, &p->opcode, 1);
-	smp_text_poke_sync_each_cpu();
+	smp_text_poke_sync_each_cpu_deferrable();
 }
 
 void arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 0aabd4c4e2c4f..eada8dca1c2e8 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -513,11 +513,11 @@ void arch_unoptimize_kprobe(struct optimized_kprobe *op)
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
index 0ffbae902e2fe..c6c4f391eb465 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -206,7 +206,7 @@ static int write_relocate_add(Elf64_Shdr *sechdrs,
 				   write, apply);
 
 	if (!early) {
-		smp_text_poke_sync_each_cpu();
+		smp_text_poke_sync_each_cpu_deferrable();
 		mutex_unlock(&text_mutex);
 	}
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 0755bc39b0d80..7d2403014010e 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -199,6 +199,21 @@ static inline bool is_kernel_inittext(unsigned long addr)
 	       addr < (unsigned long)_einittext;
 }
 
+
+/**
+ * is_kernel_noinstr_text - checks if the pointer address is located in the
+ *                    .noinstr section
+ *
+ * @addr: address to check
+ *
+ * Returns: true if the address is located in .noinstr, false otherwise.
+ */
+static inline bool is_kernel_noinstr_text(unsigned long addr)
+{
+	return addr >= (unsigned long)__noinstr_text_start &&
+	       addr < (unsigned long)__noinstr_text_end;
+}
+
 /**
  * __is_kernel_text - checks if the pointer address is located in the
  *                    .text section
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
index 3742f461183ac..abd3c196855f4 100644
--- a/include/linux/context_tracking_work.h
+++ b/include/linux/context_tracking_work.h
@@ -5,12 +5,12 @@
 #include <linux/bitops.h>
 
 enum {
-	CT_WORK_n_OFFSET,
+	CT_WORK_SYNC_OFFSET,
 	CT_WORK_MAX_OFFSET
 };
 
 enum ct_work {
-	CT_WORK_n        = BIT(CT_WORK_n_OFFSET),
+	CT_WORK_SYNC     = BIT(CT_WORK_SYNC_OFFSET),
 	CT_WORK_MAX      = BIT(CT_WORK_MAX_OFFSET)
 };
 
-- 
2.51.0


