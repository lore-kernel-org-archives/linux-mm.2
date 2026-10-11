Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA13CA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 19:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA906B008C; Sun, 11 Oct 2026 15:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291DC6B0095; Sun, 11 Oct 2026 15:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8126B0096; Sun, 11 Oct 2026 15:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBE496B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 15:49:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62F118087E
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:49:09 +0000 (UTC)
X-FDA: 85311384018.24.E8ED4D7
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0FC2140002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:49:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kQvXt3iq;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791748147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//gnix6Q7zPWZqRUnyYFxl36X37p3SjE7FNUFQA1ViE=;
	b=BE4srXWDaI7KEvDzOmDQq6qfob8ptT0YUHgiEj0Vft+vtRDxINtrcvgtO2RSyewaBXgTRN
	Y8+aXpDG0vvGTnfjEhwo/JUm9/+ezLNdCbc3sVi18h3jsQ/YN2xl3qEdK5DU1qF8T8c8S+
	AANGbvS/1pZuHz3OMHLt8nsYmE9hJsQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kQvXt3iq;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791748147;
	b=2PS1fQXhHnMimQxHPzDf/6mChWvOTkxNpJ/gNSynoAsuh3KUOwDnDZJv4az8iN12BZIhMc
	QPM/atEif19I8/o35RPUUsMSg8GLM2z8mjSgjA3TU6IR9ZgG+LZEQbEBMPxW6Il127OcP2
	T8BYXZfJ+0v6axWSJ7zZX/Hnm3/R2sM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1791748146;
	bh=//gnix6Q7zPWZqRUnyYFxl36X37p3SjE7FNUFQA1ViE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQvXt3iqK4O8NKI1hWRm+XbTERguuVGnml0ng/AdDLT/etmcMcXHVngfATD/dLfCX
	 YuTHcrMfJua/DgO9Iyir/h1R4Vp+UVehFtfeN139aT4EmHMtosRkGoLp1A4ks4bkF6
	 ejTW0W9WMGTF7k2ReTKq0Cx90TrU87ZV2tMt9bBlnzfDqGbAa5Rzwx8wCfC8UKZjBV
	 yv8dko47uG/RitxKlYAFkxwsHVboHvtMyc5o/0GEUgYQRjT4K6qAe8ybahjHEyMstq
	 Az08C/nRiw5scwu9dRKbjI9xQHLO0z6Q33454WofdR0AgoIRq2TeDtHjpzklE6UojZ
	 r9EdE2K9Gqe5A==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4j2rl64NX1zmC7;
	Sun, 11 Oct 2026 15:49:06 -0400 (EDT)
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
Subject: [PATCH hazptr v3 2/4] ptr_eq.h: Introduce ptr_eq() to preserve address dependency
Date: Sun, 11 Oct 2026 15:48:48 -0400
Message-ID: <20261011194902.97364-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011194902.97364-1-mathieu.desnoyers@efficios.com>
References: <20261011194902.97364-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: az6dzkkfpruaohsxxomggcugd4sgnsd5
X-Rspam-User: 
X-Rspamd-Queue-Id: A0FC2140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791748147-688990
X-HE-Meta: U2FsdGVkX187C8uu/L5u92oepH+rgkuJmBrQOZLGAdKko2wt9eUNwpMkEMlUMlC+TLpL9SQwM4dWrVaBcb2zQ5o6mG5lGy4eL+mIspK56TImvEOIPJbvvMI3tD1C+wTxu2IslOlFyOnaBi2cSEknoKyMZAuflZEFnCezM3JBj7dfEJ0nByZ/4E0cJNFUU0zSg5ve8yomBxsgnCbTnccJCD344I5KbHTrihjc7n9kf+bp6zdDk03OH2nHufHFpfLL0INHpmibG017Ad3eTnzmQTXNjmVPM5qZQz76xRR8fx53HgW+muOCLBjjOD+tbAQdBGiXZDKV2miJYb8CJN/wVl8dt3LpYb4fMDHiVCaynawL8mcLGebdT1F8Ey9nsgFzXsTUxrSw20HBQoxEC3Bqn4MvgGG+wzS4j/TbZ0TA+JTd6dHtUPSgp+ErxgTpCvdwsXwRfTGjYWO8+ul7AFAMS5Tk1ErQ8+AVkwOwPkZFb233jYzGJEMvwpHw8d/8DWO/f+fPqKPHCgZRt4Na7J6mZs9IBzXJvJTRxNr0oTaTkb6LIcONvCdI3HrHxUge7lLUEwikT23r7hBLjl5WCD3pm0lYUKTdMBW+eQA1OzZ1mPpBvX7WqHhhR7h6H6pqfOX30LVuDSM4o2f4NsS+TGP5Cpq0KG2Um+4pfdfRFAEBgfttDn1Ka0Vpfp7+wNSFswvGhYOwHP8Eb4fN4z3EzDKvyez+7FS7DcavlDCTvg4uH4zJrNhrm4pDb1VBcdnwU17X9ePRpiPQn8QYd8zBISiFu26WG490/pM7p4FPYToGobm9qmk0vXZJlQTxZ+4H3oHpG8LMzGlUCov7X62K2SQlUu01qI158t7//z5e0Nm638XBSPQN02Y81Ilez52l+kDvOFpZgYTw9HsrPsjt3VYdIo41ox9tgI3P//oh0+CrqaT6qu8Qkum7oaE/qmnRLnUoNAXWXPC6FXm5T0tTKrG
 q6XAG18L
 xKVRIrQxHcO3Ez6BABCqqWMYNZ/UcUjt01sWiB25LGSKBCAscUi+fN5ecfboClQ0fxrkxH+Os5/TG27/BpvOM5tNw5Q2h5UVmSReA6jpuxq0StUaEIidd4ifpDLGvqFgGXKWRGbCm2Yuw37FfWPW2k42MSLHgFAWzNSMa+a176L/Gb0FnhJfEtfj+X1dsMe2yAlfWXOjJrfR/XdOudShJ9LKNqzx/cxMXw7JSJS87i6gChmuLcM+34UT2JKlsLAqJJeCCc0wKXmLbKy2gJwteL5vPIXvqEPCHfuQyMESDIUsAXcl66+7VWXzEAcs8LcdyeDKTwrvHjbIvGARz2QwiobT6l608ADvgbLywElSMU5D6cJUpw+UyKSDQmTWASDZuDSgwHehafkLNlbnhIbcDsorGPmdjk0rS+iNFFEDjGKEh0tbp/7zPBx9j4Qk2jlPGeWYBLh1IN+sPPefdlOIhLT9FqNHcfnhbxaM9198dukJk7jiQM8bCSimqRD3tY5/XtLYuDd/oLzk3Awdp3+zfW5F900PW7NA/JgE2GHJZaRIQb5K09z26ICV6OFFi95nfUSEIqxQW02YEKSer+l2NJHOqSu5/+tB4JzPtIShrvYn7W3fnWwC7HMdYHgtaPjbl2ghmCVTViiV2Gfg7OPFtDgxi/CMxJI0gGdCZj8VpMwQniG1lITgRaPIfzkfepH9rrOx88fco/ihXvgB19IPptymAufjOrikTTZS63aG5yrdZRhPGyhW9wQZXSCDXLfiUTuxSQLv+t4zpugAZYJs++pdIu2M9cE52eqwh1GxC7rzVtHg/bW5JHJm0qUXiW3L4O53GM/RkNVaZA7QYuvUqC2OyrFm5xTVEJbqN8npPsK/idpSS4Vq86yFRP8DdhoE31GAUG9VlQ9CnKb6bOVPyJUaIS/FYHmfYXDoONkzwXA77O76808cbKq4NZ+wmT+/cGrpk5OUGm3hib0O8/KL+grP6EypW
 Jh9JwrVP
 yxnUKyD+pRqJukwUuo0YSRZrLfbQ7ECx3IyLtYRjzmH9Hs9TbBXoNInZPS3ZWfeRzs8kQBmGoV6Wy94CtLH627nzpoX+udHnCF3wXShgBRwiiXrGqFIKNnS/StnuITDAdNKChM1jMWw=
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

The header "linux/ptr_eq.h" is the expected include target. It
contains the documentation of the ptr_eq() API.

An architecture specific implementation of the pointer comparison
can be implemented by each architecture as asm/ptr_eq.h. The x86
implementation is provided initially. If no implementation header is
present for the architecture, an arch-agnostic fallback based on
OPTIMIZER_HIDE_VAR is included from asm-generic.

The arguments to ptr_eq() are const volatile to take advantage of
implicit conversion that adds cv-qualifiers, which are thus added
implicitly.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
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
Changes since v2:
- Rename ptreq.h to ptr_eq.h (x86, asm-generic and linux headers).
  Adapt the include guards accordingly.

Changes since v1:
- Move to linux/ptreq.h, implement x86-specific comparison
  and asm-generic header (fallback).

Changes since v0:
- Include feedback from Alan Stern.
---
 arch/x86/include/asm/ptr_eq.h | 16 +++++++++
 include/asm-generic/Kbuild    |  1 +
 include/asm-generic/ptr_eq.h  | 16 +++++++++
 include/linux/ptr_eq.h        | 63 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)
 create mode 100644 arch/x86/include/asm/ptr_eq.h
 create mode 100644 include/asm-generic/ptr_eq.h
 create mode 100644 include/linux/ptr_eq.h

diff --git a/arch/x86/include/asm/ptr_eq.h b/arch/x86/include/asm/ptr_eq.h
new file mode 100644
index 000000000000..8e521cabe24b
--- /dev/null
+++ b/arch/x86/include/asm/ptr_eq.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PTR_EQ_H
+#define _ASM_X86_PTR_EQ_H
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
+#endif	/* _ASM_X86_PTR_EQ_H */
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 2bc00c67dc54..86cee0dfd47f 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -47,6 +47,7 @@ mandatory-y += percpu.h
 mandatory-y += percpu_types.h
 mandatory-y += pgalloc.h
 mandatory-y += preempt.h
+mandatory-y += ptr_eq.h
 mandatory-y += rqspinlock.h
 mandatory-y += runtime-const.h
 mandatory-y += rwonce.h
diff --git a/include/asm-generic/ptr_eq.h b/include/asm-generic/ptr_eq.h
new file mode 100644
index 000000000000..2bd1c3b8a56f
--- /dev/null
+++ b/include/asm-generic/ptr_eq.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_PTR_EQ_H
+#define __ASM_GENERIC_PTR_EQ_H
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
+#endif	/* __ASM_GENERIC_PTR_EQ_H */
diff --git a/include/linux/ptr_eq.h b/include/linux/ptr_eq.h
new file mode 100644
index 000000000000..7a2bbf6e64b3
--- /dev/null
+++ b/include/linux/ptr_eq.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PTR_EQ_H
+#define _LINUX_PTR_EQ_H
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
+#include <asm/ptr_eq.h>
+
+#endif	/* _LINUX_PTR_EQ_H */
-- 
2.43.0


