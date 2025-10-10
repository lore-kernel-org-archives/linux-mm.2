Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DB6CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84848E003B; Fri, 10 Oct 2025 11:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D349E8E002C; Fri, 10 Oct 2025 11:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD118E003B; Fri, 10 Oct 2025 11:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A74418E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:46:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 702CC119D14
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:46:57 +0000 (UTC)
X-FDA: 83982632874.06.8BAA625
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 479AB140013
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:46:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y6sb//9S";
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bKKG2BLugSLsi1IIecZxqhro79DHlH2Jj6gDNDl6Ik=;
	b=6raNCrKSEYUR4zhq0lpHF6MIn2es7IzA/S+ca+iDox1sXU6q1GtE4drYt8kJWjFSqs7Khw
	04UJlM6QajXh4NDEWg+RLyDY+G0Vgr/Wd1inDVKntt8ZpAZGRthsD/qm/BsxMTS8rIqap4
	vCH7cgTO4c9uM73Qv8ZYN2RSx+1Io20=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Y6sb//9S";
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111215; a=rsa-sha256;
	cv=none;
	b=McqlDuqfbouhp/5yTFszSZZFdAv3nv4h0kfTyKRAwgSJwqTaqvhvSDww9esFz1M9yBHQOC
	RmsaJB7Cgpxhn1p7yDY8pTuKsZNwRwqMR8YQCurCc3adFzJFMiZVUcM1WcGfyXnrppeHQH
	0WYuOv80NteowxqS0EpGrbSB6UD2L4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/bKKG2BLugSLsi1IIecZxqhro79DHlH2Jj6gDNDl6Ik=;
	b=Y6sb//9SvNZU2NPMRGMYw7wXGETuSvrr1FUKe1X0Zkt/YsAIq1eRvv7+0jtj+eFLWGAynW
	MN2R4/euNEwjB+w9ilWQyJVODIwIGpeSwJs5QopruNL6Er6WAFWpB1s8mG1AI+to/w0Pdc
	11Ps5Fgm9eWHXsqRvUtpf8mfYnbTRdU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-gIGuSa3pMa61kkcjeZHMyA-1; Fri,
 10 Oct 2025 11:46:51 -0400
X-MC-Unique: gIGuSa3pMa61kkcjeZHMyA-1
X-Mimecast-MFC-AGG-ID: gIGuSa3pMa61kkcjeZHMyA_1760111203
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 462FF195608E;
	Fri, 10 Oct 2025 15:46:43 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BE671800576;
	Fri, 10 Oct 2025 15:46:27 +0000 (UTC)
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
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 23/29] context-tracking: Introduce work deferral infrastructure
Date: Fri, 10 Oct 2025 17:38:33 +0200
Message-ID: <20251010153839.151763-24-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: 66ebqztagt9xdr81htm3uc54xkkczfkd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 479AB140013
X-HE-Tag: 1760111215-538909
X-HE-Meta: U2FsdGVkX19Q0SXAmUmj3kM4SllAIOF7JcP8IE/C0sJyvgVAyyR8C2AejDmVWwIeqmxoQnwLba2R+GFOtktPYjjbGos2NEL6bZgLSQqIepa2XbjgxmY8sllnNpJQFtuG0age37h4810DxEA9Bir5TqT1z8Amj/0Inj8xa6/8gNSiB7NiSprRDrpGO+8HjUyJViupdwS8RrlcIhCX2p3+8ifrxHuyFqIiDlZhxI/AwawHoHuebp4axczDzRstWk00rWjjdF5DmG3NT4aqsaXnw1ar6SXvsodr+pfbmslK6K49nS+Sp/36Ptn3v7YQkOF6sWTtbZ0j3DAd8C+RGbJ6ANQ2kNokoEDL23zqxvcc/P+dGKUSuFXAALSvAEkeOi5baK3meuJipKpwl/3p3Sp7A3AToG3GcLpxMp7RVtAJSG0djEUt+t87KynAjouyp11AprAXSzBG3VtMK/FtM2+Ho4mOtT2Aa0gCnOAQ69/eqbrZ3ecTZ4q05Tsta7xpxkD1ZAQagsmF2VUMbMpht6oUkwziwQx369zvBf6MgMR9Uyjmq2MyiXsOVvx51YHiCcgsAPg4BD4A4S8EQ4JISA0zrJiMXG1waUQ6FCz27GKrveu5IhYomih2qoVLP+ewjSoOo/ySPKOq2IIRJo0XV40deLbPVXADoceliP3LHGFgUr461iWDpMikSWjQsXFcGhOpiin6W2jv3Qv27sC9JicYn60IvVr1fFVOPW6ig6DknoRIHLDw651zqWXC6HeMs7kGl4DCoU/ul7lftEQbUpSuKQXdqnZICB9gqGj4P4fzirmbk2daLbiqOk9fLRuBI9sWwnMz7S2dV4i5QZoEyoX7BDJyiwJvmpYiXD1vYdGrP4UNIDTap5Ia4vz54glauHQ6gsYADxUDgXVEOppd7tB98xUxo4+AuNoFAaLdbuV6BZUYMatRm76mVkyf41N1wanpcAeA4IaTd+KzrJSAWJB
 VvFlySUS
 PC/bwOGXwiiIySJwZm5fFykyOPvsZ59PwWpkagud2Po5nC0jXtWQoZm48suzDLUhI5TouPWGenZniD8NOuXHxdI067kAaJnPGOXPXCmREzfJnSI3LLPRtlmT0NiiXyIIoI/9gVDLnbZqPh85Dcze+pdRiawkf3i2HmGSQrwzU/IbMxZqIxK9jAG4MCAusZQjUWputdquhWGYUKZWfpN0tS4fVhb/0mLLRVDk5+EFc97WY+HmQig3ViwHL6c+/NiHipjgqWWlKzN9fsD0/X9Hft4gVBmc2MWKUAigBqYHjqyvFq5w3lCq98WmAW/HnGPHdyfnEtmAmCXVN9l+B/J7AGygskxEosEZB6NNiyO+rpP492RRqoefIKr2wq8Z/bgHKwbI9RgpxMqSzFcQUhJlN4GkmWn8ATK99ol0hLaRWN466xRHVSCDB9U8DDudwSFKPzPAe0qJAa1BlDod4OdX0EkKljzFFQ+TanJpJzXE3UDCnJ0vza3ctYuRNtuyZxebT+GZ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smp_call_function() & friends have the unfortunate habit of sending IPIs to
isolated, NOHZ_FULL, in-userspace CPUs, as they blindly target all online
CPUs.

Some callsites can be bent into doing the right, such as done by commit:

  cc9e303c91f5 ("x86/cpu: Disable frequency requests via aperfmperf IPI for nohz_full CPUs")

Unfortunately, not all SMP callbacks can be omitted in this
fashion. However, some of them only affect execution in kernelspace, which
means they don't have to be executed *immediately* if the target CPU is in
userspace: stashing the callback and executing it upon the next kernel entry
would suffice. x86 kernel instruction patching or kernel TLB invalidation
are prime examples of it.

Reduce the RCU dynticks counter width to free up some bits to be used as a
deferred callback bitmask. Add some build-time checks to validate that
setup.

Presence of CT_RCU_WATCHING in the ct_state prevents queuing deferred work.

Later commits introduce the bit:callback mappings.

Link: https://lore.kernel.org/all/20210929151723.162004989@infradead.org/
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/Kconfig                                 |  9 +++
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/context_tracking_work.h | 16 +++++
 include/linux/context_tracking.h             | 21 ++++++
 include/linux/context_tracking_state.h       | 30 ++++++---
 include/linux/context_tracking_work.h        | 26 ++++++++
 kernel/context_tracking.c                    | 69 +++++++++++++++++++-
 kernel/time/Kconfig                          |  5 ++
 8 files changed, 165 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/include/asm/context_tracking_work.h
 create mode 100644 include/linux/context_tracking_work.h

diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e0856..a33229e017467 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -968,6 +968,15 @@ config HAVE_CONTEXT_TRACKING_USER_OFFSTACK
 	  - No use of instrumentation, unless instrumentation_begin() got
 	    called.
 
+config HAVE_CONTEXT_TRACKING_WORK
+	bool
+	help
+	  Architecture supports deferring work while not in kernel context.
+	  This is especially useful on setups with isolated CPUs that might
+	  want to avoid being interrupted to perform housekeeping tasks (for
+	  ex. TLB invalidation or icache invalidation). The housekeeping
+	  operations are performed upon re-entering the kernel.
+
 config HAVE_TIF_NOHZ
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 05880301212e3..3f1557b7acd8f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -222,6 +222,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING_USER		if X86_64
 	select HAVE_CONTEXT_TRACKING_USER_OFFSTACK	if HAVE_CONTEXT_TRACKING_USER
+	select HAVE_CONTEXT_TRACKING_WORK		if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_OBJTOOL_MCOUNT		if HAVE_OBJTOOL
 	select HAVE_OBJTOOL_NOP_MCOUNT		if HAVE_OBJTOOL_MCOUNT
diff --git a/arch/x86/include/asm/context_tracking_work.h b/arch/x86/include/asm/context_tracking_work.h
new file mode 100644
index 0000000000000..5f3b2d0977235
--- /dev/null
+++ b/arch/x86/include/asm/context_tracking_work.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_CONTEXT_TRACKING_WORK_H
+#define _ASM_X86_CONTEXT_TRACKING_WORK_H
+
+static __always_inline void arch_context_tracking_work(enum ct_work work)
+{
+	switch (work) {
+	case CT_WORK_n:
+		// Do work...
+		break;
+	case CT_WORK_MAX:
+		WARN_ON_ONCE(true);
+	}
+}
+
+#endif
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index af9fe87a09225..0b0faa040e9b5 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/vtime.h>
 #include <linux/context_tracking_state.h>
+#include <linux/context_tracking_work.h>
 #include <linux/instrumentation.h>
 
 #include <asm/ptrace.h>
@@ -137,6 +138,26 @@ static __always_inline unsigned long ct_state_inc(int incby)
 	return raw_atomic_add_return(incby, this_cpu_ptr(&context_tracking.state));
 }
 
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+static __always_inline unsigned long ct_state_inc_clear_work(int incby)
+{
+	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
+	unsigned long new, old, state;
+
+	state = arch_atomic_read(&ct->state);
+	do {
+		old = state;
+		new = old & ~CT_WORK_MASK;
+		new += incby;
+		state = arch_atomic_cmpxchg(&ct->state, old, new);
+	} while (old != state);
+
+	return new;
+}
+#else
+#define ct_state_inc_clear_work(x) ct_state_inc(x)
+#endif
+
 static __always_inline bool warn_rcu_enter(void)
 {
 	bool ret = false;
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 0b81248aa03e2..d2c302133672f 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -5,6 +5,7 @@
 #include <linux/percpu.h>
 #include <linux/static_key.h>
 #include <linux/context_tracking_irq.h>
+#include <linux/context_tracking_work.h>
 
 /* Offset to allow distinguishing irq vs. task-based idle entry/exit. */
 #define CT_NESTING_IRQ_NONIDLE	((LONG_MAX / 2) + 1)
@@ -39,16 +40,19 @@ struct context_tracking {
 };
 
 /*
- * We cram two different things within the same atomic variable:
+ * We cram up to three different things within the same atomic variable:
  *
- *                     CT_RCU_WATCHING_START  CT_STATE_START
- *                                |                |
- *                                v                v
- *     MSB [ RCU watching counter ][ context_state ] LSB
- *         ^                       ^
- *         |                       |
- * CT_RCU_WATCHING_END        CT_STATE_END
+ *                     CT_RCU_WATCHING_START                  CT_STATE_START
+ *                                |         CT_WORK_START          |
+ *                                |               |                |
+ *                                v               v                v
+ *     MSB [ RCU watching counter ][ context work ][ context_state ] LSB
+ *         ^                       ^               ^
+ *         |                       |               |
+ *         |                  CT_WORK_END          |
+ * CT_RCU_WATCHING_END                        CT_STATE_END
  *
+ * The [ context work ] region spans 0 bits if CONFIG_CONTEXT_WORK=n
  * Bits are used from the LSB upwards, so unused bits (if any) will always be in
  * upper bits of the variable.
  */
@@ -59,18 +63,24 @@ struct context_tracking {
 #define CT_STATE_START 0
 #define CT_STATE_END   (CT_STATE_START + CT_STATE_WIDTH - 1)
 
-#define CT_RCU_WATCHING_MAX_WIDTH (CT_SIZE - CT_STATE_WIDTH)
+#define CT_WORK_WIDTH (IS_ENABLED(CONFIG_CONTEXT_TRACKING_WORK) ? CT_WORK_MAX_OFFSET : 0)
+#define	CT_WORK_START (CT_STATE_END + 1)
+#define CT_WORK_END   (CT_WORK_START + CT_WORK_WIDTH - 1)
+
+#define CT_RCU_WATCHING_MAX_WIDTH (CT_SIZE - CT_WORK_WIDTH - CT_STATE_WIDTH)
 #define CT_RCU_WATCHING_WIDTH     (IS_ENABLED(CONFIG_RCU_DYNTICKS_TORTURE) ? 2 : CT_RCU_WATCHING_MAX_WIDTH)
-#define CT_RCU_WATCHING_START     (CT_STATE_END + 1)
+#define CT_RCU_WATCHING_START     (CT_WORK_END + 1)
 #define CT_RCU_WATCHING_END       (CT_RCU_WATCHING_START + CT_RCU_WATCHING_WIDTH - 1)
 #define CT_RCU_WATCHING           BIT(CT_RCU_WATCHING_START)
 
 #define CT_STATE_MASK        GENMASK(CT_STATE_END,        CT_STATE_START)
+#define CT_WORK_MASK         GENMASK(CT_WORK_END,         CT_WORK_START)
 #define CT_RCU_WATCHING_MASK GENMASK(CT_RCU_WATCHING_END, CT_RCU_WATCHING_START)
 
 #define CT_UNUSED_WIDTH (CT_RCU_WATCHING_MAX_WIDTH - CT_RCU_WATCHING_WIDTH)
 
 static_assert(CT_STATE_WIDTH        +
+	      CT_WORK_WIDTH         +
 	      CT_RCU_WATCHING_WIDTH +
 	      CT_UNUSED_WIDTH       ==
 	      CT_SIZE);
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
new file mode 100644
index 0000000000000..c68245f8d77c5
--- /dev/null
+++ b/include/linux/context_tracking_work.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CONTEXT_TRACKING_WORK_H
+#define _LINUX_CONTEXT_TRACKING_WORK_H
+
+#include <linux/bitops.h>
+
+enum {
+	CT_WORK_n_OFFSET,
+	CT_WORK_MAX_OFFSET
+};
+
+enum ct_work {
+	CT_WORK_n        = BIT(CT_WORK_n_OFFSET),
+	CT_WORK_MAX      = BIT(CT_WORK_MAX_OFFSET)
+};
+
+#include <asm/context_tracking_work.h>
+
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+extern bool ct_set_cpu_work(unsigned int cpu, enum ct_work work);
+#else
+static inline bool
+ct_set_cpu_work(unsigned int cpu, unsigned int work) { return false; }
+#endif
+
+#endif
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index fb5be6e9b423f..3238bb1f41ff4 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -72,6 +72,70 @@ static __always_inline void rcu_task_trace_heavyweight_exit(void)
 #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
 
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+static noinstr void ct_work_flush(unsigned long seq)
+{
+	int bit;
+
+	seq = (seq & CT_WORK_MASK) >> CT_WORK_START;
+
+	/*
+	 * arch_context_tracking_work() must be noinstr, non-blocking,
+	 * and NMI safe.
+	 */
+	for_each_set_bit(bit, &seq, CT_WORK_MAX)
+		arch_context_tracking_work(BIT(bit));
+}
+
+/**
+ * ct_set_cpu_work - set work to be run at next kernel context entry
+ *
+ * If @cpu is not currently executing in kernelspace, it will execute the
+ * callback mapped to @work (see arch_context_tracking_work()) at its next
+ * entry into ct_kernel_enter_state().
+ *
+ * If it is already executing in kernelspace, this will be a no-op.
+ */
+bool ct_set_cpu_work(unsigned int cpu, enum ct_work work)
+{
+	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);
+	unsigned int old;
+	bool ret = false;
+
+	if (!ct->active)
+		return false;
+
+	preempt_disable();
+
+	old = atomic_read(&ct->state);
+
+	/*
+	 * The work bit must only be set if the target CPU is not executing
+	 * in kernelspace.
+	 * CT_RCU_WATCHING is used as a proxy for that - if the bit is set, we
+	 * know for sure the CPU is executing in the kernel whether that be in
+	 * NMI, IRQ or process context.
+	 * Set CT_RCU_WATCHING here and let the cmpxchg do the check for us;
+	 * the state could change between the atomic_read() and the cmpxchg().
+	 */
+	old |= CT_RCU_WATCHING;
+	/*
+	 * Try setting the work until either
+	 * - the target CPU has entered kernelspace
+	 * - the work has been set
+	 */
+	do {
+		ret = atomic_try_cmpxchg(&ct->state, &old, old | (work << CT_WORK_START));
+	} while (!ret && !(old & CT_RCU_WATCHING));
+
+	preempt_enable();
+	return ret;
+}
+#else
+static __always_inline void ct_work_flush(unsigned long work) { }
+static __always_inline void ct_work_clear(struct context_tracking *ct) { }
+#endif
+
 /*
  * Record entry into an extended quiescent state.  This is only to be
  * called when not already in an extended quiescent state, that is,
@@ -88,7 +152,7 @@ static noinstr void ct_kernel_exit_state(int offset)
 	rcu_task_trace_heavyweight_enter();  // Before CT state update!
 	// RCU is still watching.  Better not be in extended quiescent state!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !rcu_is_watching_curr_cpu());
-	(void)ct_state_inc(offset);
+	(void)ct_state_inc_clear_work(offset);
 	// RCU is no longer watching.
 }
 
@@ -99,7 +163,7 @@ static noinstr void ct_kernel_exit_state(int offset)
  */
 static noinstr void ct_kernel_enter_state(int offset)
 {
-	int seq;
+	unsigned long seq;
 
 	/*
 	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
@@ -107,6 +171,7 @@ static noinstr void ct_kernel_enter_state(int offset)
 	 * critical section.
 	 */
 	seq = ct_state_inc(offset);
+	ct_work_flush(seq);
 	// RCU is now watching.  Better not be in an extended quiescent state!
 	rcu_task_trace_heavyweight_exit();  // After CT state update!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & CT_RCU_WATCHING));
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 7c6a52f7836ce..1a0c027aad141 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -181,6 +181,11 @@ config CONTEXT_TRACKING_USER_FORCE
 	  Say N otherwise, this option brings an overhead that you
 	  don't want in production.
 
+config CONTEXT_TRACKING_WORK
+	bool
+	depends on HAVE_CONTEXT_TRACKING_WORK && CONTEXT_TRACKING_USER
+	default y
+
 config NO_HZ
 	bool "Old Idle dynticks config"
 	help
-- 
2.51.0


