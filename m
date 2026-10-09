Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9BECA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C2C6B0088; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163A46B0092; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1056B009F; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D48D56B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:21:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D52E1A02B5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:21:52 +0000 (UTC)
X-FDA: 85303906464.15.1B0F808
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9369940002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:21:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=DBHvMLkv;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791570110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDrZOtFBWf7Dd8+cVztxdzIHxxYfAS3JAMLz+tammXA=;
	b=lUzOeOFIrV+uEjpOw3/KvvpPxA3YEL3Ob571envrF2SOrRRCBGVK5wFGhrY083lUtSdyXV
	XMNFXXy2d/Vnqin8JAeP94uwh0jtYyyEZEfRMd815hn/kHGszyZhFWInty9LtRkpuIW4Wo
	H/b4zTrIXQZUI77Ss2TKqR0PR22KFRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791570110;
	b=tszqBdTO/chnfOjE9nBZ6Pf9WsTs5TvQZnCi4oWgpXLZJsfD4uzIbAaESXR6Pn/P2v8DFO
	Q1BFyTqdORCRkbi8X44uQD7Ju3vU0SjDVFwP4aien5JYQui/CaThvBwrerwre8VMspZEtI
	PlBxrG0RJbo/k4MOwyLpGH0Y5t0DDcM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=DBHvMLkv;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1791570109;
	bh=JDrZOtFBWf7Dd8+cVztxdzIHxxYfAS3JAMLz+tammXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBHvMLkvCbPROIyS66Yd7f3eJnw8hM1cQH3lKNpCpfD+iMsG1VHiX0zPZrzVVC6iP
	 Gmb9EpLj2wahICm7L2FCDVjazdXblPbI/fvCxbd/Bq/T3O7MUqgLX2/9p47vHKpo7L
	 tx7Tnc7nQDRPIsisvMBRM4aSZ57XlU+3zT8XlCPFaOUnUSiy5pQNaUexLIifVPRZAY
	 UEloO6Q1MfBcEuAhsW/KAvCHQs/kTxr/M08Aq7bvLdmRy1zDGx1Ho2fySFAmhfCqbJ
	 KLTnKosmBKM84ZLQg3fayGLG+TJIGI0WFYasrf+hLYKVxNMsIrrLN/Rx+ekSF8BuTI
	 3u0vCI4wJf5KQ==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4j1ZvK4V7KzljQ;
	Fri, 09 Oct 2026 14:21:49 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E . McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH hazptr v2 2/4] ptreq.h: Introduce ptr_eq() to preserve address dependency
Date: Fri,  9 Oct 2026 14:21:33 -0400
Message-ID: <20261009182142.6311-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
References: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9369940002
X-Stat-Signature: 6tfs9zf3z3gkkkkqa8fg7snhojydbijy
X-HE-Tag: 1791570110-471625
X-HE-Meta: U2FsdGVkX1+hnN5aDGBEKRrxZrGjwnMWDn/OR+smmuWLHjULh7YOY0G7mUbfdNHxA6tOzjZiyvpiN9FD0R/P1dQWcGaQcDztP+ZXYKeQrfnpyBM4sGYuqVJ2E6SraLd4Nbx3AaYWFNK0GWC1eHlheaNX4gf18mJUnE3WYcVbE/KHIFhKlAnSWMgS5pNpGYQKsr7NgoxRlUvx/bHKlrrvR2BY4m2wPxIqf+88X8Hr7U5Fsylsi1IwcQdajG2e3bBz5c7eN16PfKY4/md0PAKmqEdOjQuGk2FREePOatFr5BWXUfbmxhdloJozdvmNNYZEs6BS77ycM/ayJfBsCec3e7ft13Suas/cbRhr3QrdiB/fCth9z82uOBQ4MF01YjS9/ASfoQ1riO+02q4IxXbB0h6VlQxExv9ZmMB5pQegD2JFgn0+X1g8gSRu1GOD3g7yUcZuBorgOdBo75J4b525kwtw1j9g/vESHlIqRrIUeJQ03iPaFlnwo/WgxdNbCRy31wwtdaWC0sf+oebs7N/oDRu3zvoYh4js5b7khxyHV8ICATLtD4cFUwggJfB1MxMtYWZER0DAEShY8nz8WazwIvWOVDb/4PcvgV2zzxWGX+1o7ZMilWf0nNRM6j0hYhU/s02TO+DpcYSV28wBEL19UBioovA3PcLbOT1h6QRcw+lPNkSV9viU6zLpDLz0twaXP4GpOM/lWKuTdbzfawkSGCiG4tln4V6dQkd9VgtkFCHlSC0qJLfsNEytluy4b1pKuqKsu4GJKtv4UFBUVaq/Vdq74mKhgo1hMymRIRhhY3t0KXwXiWhI96/74GwQHvnEX/6iD5Wp3TVrkONL4lJOfBg8q5GteHRupKmDe/T7CIQRoSSYeMbmaUh9bxtLrW6YevL0gv9yHpFFt993MbISJmK9yAC8thx0K3xC/8RAdMBb4IXB/8+fYAGmp2fVnR9E/efokdac9KU2mOMasDq
 ++YjHqFr
 NQg6aGyvXLgjWhVrTa/WwUTVTDdPOevKHWkAwuancAaamTMiLwLlmFBx4ojHtWjhWHNOdfNd9nCWrjyjq0tfGJBH2vpOOSqAFa/ohMGcr/5qlsWA1lRz4hnf2+wY6bNe7njWf6yBp82kR7EGZJIJmckLMQwuA5tOj1x+N0kkAuHpyQWI/kbmQadmvyCQJ4HsGpfUgnjN43XjHwhq5vkbl8HL9tHlJW8chxx33upnHGlgNynH6KV26pGLSiDGbJFhtyMZ97f9kiJ4PugFCCOrH4UD19y+NsCcfZ1JgcxyzKlp/gw6TLnhvtXcHi84yaSNpqU5iKk6XNN34rsDG1nv7CwUPF2QUAw/0iN0DdJ/ijxQaBUpxSFkjPStDeztvKtGyc3PHhJzhrLMTa0QkCKsCRe7l4kI1APCU9hfg1x7DV87AtD2xNLa/9vN92kA+jtRv8cb/+BfnGn0y4rcMoAvfreHceVc4BfMoJvc8Uo5/+WozFfJbmEwoUys7l8vF5gWfsITCnGcw9ytOV0Ts9BAOL3THGsOfLG1ExVTVPVwfmZcLEj8pvh/6tCNlbVGMYvtPBvdj2u3pmG0qGr+7H9rXNoqtTCTnNYLUkv9BKIQhRmOCGvArqVPHbHOEq053stcPcLcvmDyPJtyDbiL/MpTu3uMwszSxRkBhE8sOfkm/69pGBt7xzaFz0/cRX4ej+kIypRKo91RBjfIejFFGrKtpKI0ToruvBiaR/e54wfvKmVCYsDWbLjEQjU+JfDc+x7Hn0oNJH9nrxreNALqGIEqKvPhWfzvemmhZbMHj7XxP9kR1MzddhXIa+7VT9Q3NJhpmuz2Lbs6rnQMPLRMJlaD93Sz7AgtbWHrGUqDb73gCRC9Pd97uVSH6sLws0OCbVtl1r1UPLRCrGXwArfy+llJ4G/aPj4t0nfr90CknsTbA6h3rNpbyDaK7VrB8TKxdCwk08F1B38uV4sVakdDKT5WRB5RlJpae
 /MtWSqvM
 KxP0PgO1eqOpDs4+4JJuJQZzF0o6Ko3z3srq9P289GG/8RbYOxGHhOVFkfDRwWGbWqNDwkguwMGDZwAKVQXSOVULzTlUzt7HTpvA27iZsaDGs4UbhDbigBMtxREtrVaecQHriE0u1Pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compiler CSE and SSA GVN optimizations can cause the address dependency
of addresses returned by rcu_dereference to be lost when comparing those
pointers with either constants or previously loaded pointers.

Introduce ptr_eq() to compare two addresses while preserving the address
dependencies for later use of the address. It should be used when
comparing an address returned by rcu_dereference().

This is needed to prevent the compiler CSE and SSA GVN optimizations
from using @a (or @b) in places where the source refers to @b (or @a)
based on the fact that after the comparison, the two are known to be
equal, which does not preserve address dependencies and allows the
following misordering speculations:

- If @b is a constant, the compiler can issue the loads which depend
  on @a before loading @a.
- If @b is a register populated by a prior load, weakly-ordered
  CPUs can speculate loads which depend on @a before loading @a.

The same logic applies with @a and @b swapped.

The header "linux/ptreq.h" is the expected include target. It
contains the documentation of the ptr_eq() API.

An architecture specific implementation of the pointer comparison
can be implemented by each architecture as asm/ptreq.h. The x86
implementation is provided initially. If no implementation header is
present for the architecture, an arch-agnostic fallback based on
OPTIMIZER_HIDE_VAR is included from asm-generic.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: maged.michael@gmail.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
Cc: Nikita Popov <github@npopov.com>
Cc: llvm@lists.linux.dev
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
---
Changes since v1:
- Move to linux/ptreq.h, implement x86-specific comparison
  and asm-generic header (fallback).

Changes since v0:
- Include feedback from Alan Stern.
---
 arch/x86/include/asm/ptreq.h | 16 +++++++++
 include/asm-generic/Kbuild   |  1 +
 include/asm-generic/ptreq.h  | 16 +++++++++
 include/linux/ptreq.h        | 63 ++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)
 create mode 100644 arch/x86/include/asm/ptreq.h
 create mode 100644 include/asm-generic/ptreq.h
 create mode 100644 include/linux/ptreq.h

diff --git a/arch/x86/include/asm/ptreq.h b/arch/x86/include/asm/ptreq.h
new file mode 100644
index 000000000000..593b45f80451
--- /dev/null
+++ b/arch/x86/include/asm/ptreq.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PTREQ_H
+#define _ASM_X86_PTREQ_H
+
+#include <linux/types.h>
+#include <asm/asm.h>
+
+static __always_inline
+bool ptr_eq(const volatile void *a, const volatile void *b)
+{
+	bool ret;
+	asm(__ASM_SIZE(cmp) " %1,%2" : "=@ccz" (ret) : "r" (a), "r" (b));
+	return ret;
+}
+
+#endif	/* _ASM_X86_PTREQ_H */
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 2bc00c67dc54..e1d95dea09d5 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -47,6 +47,7 @@ mandatory-y += percpu.h
 mandatory-y += percpu_types.h
 mandatory-y += pgalloc.h
 mandatory-y += preempt.h
+mandatory-y += ptreq.h
 mandatory-y += rqspinlock.h
 mandatory-y += runtime-const.h
 mandatory-y += rwonce.h
diff --git a/include/asm-generic/ptreq.h b/include/asm-generic/ptreq.h
new file mode 100644
index 000000000000..db5a88628b1e
--- /dev/null
+++ b/include/asm-generic/ptreq.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_PTREQ_H
+#define __ASM_GENERIC_PTREQ_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+static __always_inline
+bool ptr_eq(const volatile void *a, const volatile void *b)
+{
+	OPTIMIZER_HIDE_VAR(a);
+	OPTIMIZER_HIDE_VAR(b);
+	return a == b;
+}
+
+#endif	/* __ASM_GENERIC_PTREQ_H */
diff --git a/include/linux/ptreq.h b/include/linux/ptreq.h
new file mode 100644
index 000000000000..5499f65da30a
--- /dev/null
+++ b/include/linux/ptreq.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PTREQ_H
+#define _LINUX_PTREQ_H
+
+/*
+ * Compare two addresses while preserving the address dependencies for
+ * later use of the address. It should be used when comparing an address
+ * returned by rcu_dereference().
+ *
+ * This is needed to prevent the compiler CSE and SSA GVN optimizations
+ * from using @a (or @b) in places where the source refers to @b (or @a)
+ * based on the fact that after the comparison, the two are known to be
+ * equal, which does not preserve address dependencies and allows the
+ * following misordering speculations:
+ *
+ * - If @b is a constant, the compiler can issue the loads which depend
+ *   on @a before loading @a.
+ * - If @b is a register populated by a prior load, weakly-ordered
+ *   CPUs can speculate loads which depend on @a before loading @a.
+ *
+ * The same logic applies with @a and @b swapped.
+ *
+ * Return value: true if pointers are equal, false otherwise.
+ *
+ * The compiler barrier() is ineffective at fixing this issue. It does
+ * not prevent the compiler CSE from losing the address dependency:
+ *
+ * int fct_2_volatile_barriers(void)
+ * {
+ *     int *a, *b;
+ *
+ *     do {
+ *         a = READ_ONCE(p);
+ *         asm volatile ("" : : : "memory");
+ *         b = READ_ONCE(p);
+ *     } while (a != b);
+ *     asm volatile ("" : : : "memory");  <-- barrier()
+ *     return *b;
+ * }
+ *
+ * With gcc 14.2 (arm64):
+ *
+ * fct_2_volatile_barriers:
+ *         adrp    x0, .LANCHOR0
+ *         add     x0, x0, :lo12:.LANCHOR0
+ * .L2:
+ *         ldr     x1, [x0]  <-- x1 populated by first load.
+ *         ldr     x2, [x0]
+ *         cmp     x1, x2
+ *         bne     .L2
+ *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
+ *         ret
+ *
+ * On weakly-ordered architectures, this lets CPU speculation use the
+ * result from the first load to speculate "ldr w0, [x1]" before
+ * "ldr x2, [x0]".
+ * Based on the RCU documentation, the control dependency does not
+ * prevent the CPU from speculating loads.
+ */
+
+#include <asm/ptreq.h>
+
+#endif	/* _LINUX_PTREQ_H */
-- 
2.43.0


