Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870D310A3D9A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75616B0093; Thu, 26 Mar 2026 11:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C7C6B0095; Thu, 26 Mar 2026 11:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C4C6B0096; Thu, 26 Mar 2026 11:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 810106B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3992F1A0E3D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:26 +0000 (UTC)
X-FDA: 84588550452.07.7BC25B4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43A4180010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dLLqDI1p;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vg6orVDTPecMi8OeXzXS8oUaQlC99nRHDPvEe4x4LeU=;
	b=C8GEV1hD3qAjLN+d+zxlvR8gjtB0vnRrILL1mfHKT+zb86Bx/NlXLt5H76rsLV1f4e9FUK
	fbdsrO+iD0CWHj83z4kbOt7Qj/xV15CpLT/9/hyt3c98DPJHpGZIHGxtqRSQdlCfykhfqN
	Cui6wuZRx5jLYbSjuws6USp4RC31xyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537824; a=rsa-sha256;
	cv=none;
	b=VW/GQsXyhEuQk8MK6xrscOo96CDOBBVc1egiFMhd9zMRY6rhiXpxKCh7CD5JEMPDv/ADBo
	mF1SDLnpHMpcLFvINJDNMzP21Uv5U3UhamaB+mZKvYL/T36CMNgxFsGga70rHew8fAaZ3c
	kckHL7OtMRYt3Ij67T9eCJJiTzclEBc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dLLqDI1p;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9D059BDE1E;
	Thu, 26 Mar 2026 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537822;
	bh=vg6orVDTPecMi8OeXzXS8oUaQlC99nRHDPvEe4x4LeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLLqDI1p21R53wCA8eob+BVI6XwqXJpZuprXjmvBjW/iBsJ7cf+ADApcxOKpwSyya
	 A+lKSNgUYnHa1L7n0SzHyd2w1GjjlxWJLI8NECaewbUXU7VVQTj7a3s0E5eKkMk38Z
	 dNvaBjriNbIT5ix6kJ00hgEddssmRBYJMPY+afno=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 5/5] locking: Add contended_release tracepoint to spinning locks
Date: Thu, 26 Mar 2026 15:10:04 +0000
Message-ID: <81eb8e0cd90b31e761e12721dbacb967281f840f.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43A4180010
X-Stat-Signature: ijdxcbdxxpnhjgrg3trd8xpghxcdcycg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774537824-888395
X-HE-Meta: U2FsdGVkX1+V9NNEWk5ZpYNeoJP6kQQ6bnsW3wMLTnXv2YCMrgbCFl8e6vf7wHDs62IvDJVLLxtYb81/swL9bKzSxEN9jIpU735m0UvThGVVIXlP7TaGU99GiRvCVOPZIMf6cCsCbjA4Hf7sHeFHLmYkZjUts6MBFTaQWuul6OY7MGD0cCG1Vabp7avwbOyyk0OM7zsh0RgDuQfti0QxFf7jk8OI9Eq6DNGh5qxV6fsSy404bHmn1W9VMhM/RPiKICMDC3EKCEASvZFafeA6AN05BmGYw89y33eD6aK3xCNQS1twz/VhW/MgBPTn+zpeXdziY+ZQPpRqg+8KqysekHK5ap2CYja/2ZC+VF/Fz5BXkDYLrFwT50AXnjdpajOzYI1denE3QCE/SdhBosiL5r2DS24fCyCNz5agIb8sMwZnZW42W3qcAuRs2O4a2Lm5LKUeljlMU4IolS4nTZPFOsK+0hJD1PKJT/5SUzFMBuvgW4v28vIReoSGsX+zgGIlYuA2oWICdRHkUgFqLHiBvFWu7HjQgwRhD7qp8uCn5H2t/+b03K5zzxHOmebR9iERIjBEikXWbgbH6Zjv25FQSNqbcxOZktMkSPNnL1G8d9j+pHgoS1QrJWk6iSAvAVtxvBmSZO1YVVJq4G9fkrr/3i9S5b+Gc8W8kJL7Prer8y+vPNwg++fKZOcYs+EJPYO29+OftcvnIOh7b1LkEFPJTy4FoZ2C6rytBmy1WIw1xMNPP/Hno8Yl33z/a1+wlLxsRo1+mVvjD/jzO/uNCPoMkxhY19K1tC7Vyz8IRFkRxs5lq4j/46M1E3FXK6IPCha1yndPTq3dMZ8bGaRv6qabg7KpaJpjom06C3IQeSbhgk70dv2zN33VE/5lykLQmBW7Uc6Zy7xcQlDW/VK1+lh6EeP5fKw0DkVqMKyQvDy7NLkR9mBetl0Bhn26qD6GnUOp7XD41L9GnS21TIk9UJB
 HXvNQGcB
 2uHHDiqqbrtm6W4y6lHXeF/S/m3tjtSOjZb48FmWzyy0Az3c9duHSh7aZXFUy7syIOXLZfOpQ2HH6uNhYbh4LiOVx61hVEyyMMgX6vR6ejJhD6IXr75IxiLXVBwv1c1CY1EHF96WG5+tY++ZAZuXen4SoAy/GAy9AuKNxmwXSNbFRZvt/OPHVg0u8rIS3XwuPpklQGtfmfW/LCpEcLu4K9XtUPbjHIyqXI7whrBg92dB7uRXgqb93OOtyuTGZucavKzuraq+oKU+FJsq+Gbot7QrgcBUzZeklKFXiShkJuvlqe/OxovZtroKE+oxAE5cPx1G+ACf1NJp8aXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the contended_release tracepoint to queued spinlocks and queued
rwlocks.

Use the arch-overridable queued_spin_release(), introduced in the
previous commit, to ensure the tracepoint works correctly across all
architectures, including those with custom unlock implementations (e.g.
x86 paravirt).

When the tracepoint is disabled, the only addition to the hot path is a
single NOP instruction (the static branch). When enabled, the contention
check, trace call, and unlock are combined in an out-of-line function to
minimize hot path impact, avoiding the compiler needing to preserve the
lock pointer in a callee-saved register across the trace call.

Binary size impact (x86_64, defconfig):
  uninlined unlock (common case): +983 bytes  (+0.00%)
  inlined unlock (worst case):    +58165 bytes (+0.24%)

The inlined unlock case could not be achieved through Kconfig options on
x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
inline the unlock path and estimate the worst case binary size increase.

Architectures with fully custom qspinlock implementations (e.g.
PowerPC) are not covered by this change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/asm-generic/qrwlock.h   | 48 +++++++++++++++++++++++++++------
 include/asm-generic/qspinlock.h | 18 +++++++++++++
 kernel/locking/qrwlock.c        | 16 +++++++++++
 kernel/locking/qspinlock.c      |  8 ++++++
 4 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 75b8f4601b28..e24dc537fd66 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -14,6 +14,7 @@
 #define __ASM_GENERIC_QRWLOCK_H
 
 #include <linux/atomic.h>
+#include <linux/tracepoint-defs.h>
 #include <asm/barrier.h>
 #include <asm/processor.h>
 
@@ -35,6 +36,10 @@
  */
 extern void queued_read_lock_slowpath(struct qrwlock *lock);
 extern void queued_write_lock_slowpath(struct qrwlock *lock);
+extern void queued_read_unlock_traced(struct qrwlock *lock);
+extern void queued_write_unlock_traced(struct qrwlock *lock);
+
+DECLARE_TRACEPOINT(contended_release);
 
 /**
  * queued_read_trylock - try to acquire read lock of a queued rwlock
@@ -102,10 +107,16 @@ static inline void queued_write_lock(struct qrwlock *lock)
 }
 
 /**
- * queued_read_unlock - release read lock of a queued rwlock
+ * queued_rwlock_is_contended - check if the lock is contended
  * @lock : Pointer to queued rwlock structure
+ * Return: 1 if lock contended, 0 otherwise
  */
-static inline void queued_read_unlock(struct qrwlock *lock)
+static inline int queued_rwlock_is_contended(struct qrwlock *lock)
+{
+	return arch_spin_is_locked(&lock->wait_lock);
+}
+
+static __always_inline void __queued_read_unlock(struct qrwlock *lock)
 {
 	/*
 	 * Atomically decrement the reader count
@@ -114,22 +125,43 @@ static inline void queued_read_unlock(struct qrwlock *lock)
 }
 
 /**
- * queued_write_unlock - release write lock of a queued rwlock
+ * queued_read_unlock - release read lock of a queued rwlock
  * @lock : Pointer to queued rwlock structure
  */
-static inline void queued_write_unlock(struct qrwlock *lock)
+static inline void queued_read_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Trace and unlock are combined in the traced unlock variant so
+	 * the compiler does not need to preserve the lock pointer across
+	 * the function call, avoiding callee-saved register save/restore
+	 * on the hot path.
+	 */
+	if (tracepoint_enabled(contended_release)) {
+		queued_read_unlock_traced(lock);
+		return;
+	}
+
+	__queued_read_unlock(lock);
+}
+
+static __always_inline void __queued_write_unlock(struct qrwlock *lock)
 {
 	smp_store_release(&lock->wlocked, 0);
 }
 
 /**
- * queued_rwlock_is_contended - check if the lock is contended
+ * queued_write_unlock - release write lock of a queued rwlock
  * @lock : Pointer to queued rwlock structure
- * Return: 1 if lock contended, 0 otherwise
  */
-static inline int queued_rwlock_is_contended(struct qrwlock *lock)
+static inline void queued_write_unlock(struct qrwlock *lock)
 {
-	return arch_spin_is_locked(&lock->wait_lock);
+	/* See comment in queued_read_unlock(). */
+	if (tracepoint_enabled(contended_release)) {
+		queued_write_unlock_traced(lock);
+		return;
+	}
+
+	__queued_write_unlock(lock);
 }
 
 /*
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index df76f34645a0..915a4c2777f6 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -41,6 +41,7 @@
 
 #include <asm-generic/qspinlock_types.h>
 #include <linux/atomic.h>
+#include <linux/tracepoint-defs.h>
 
 #ifndef queued_spin_is_locked
 /**
@@ -129,12 +130,29 @@ static __always_inline void queued_spin_release(struct qspinlock *lock)
 }
 #endif
 
+DECLARE_TRACEPOINT(contended_release);
+
+extern void queued_spin_release_traced(struct qspinlock *lock);
+
 /**
  * queued_spin_unlock - unlock a queued spinlock
  * @lock : Pointer to queued spinlock structure
+ *
+ * Generic tracing wrapper around the arch-overridable
+ * queued_spin_release().
  */
 static __always_inline void queued_spin_unlock(struct qspinlock *lock)
 {
+	/*
+	 * Trace and release are combined in queued_spin_release_traced() so
+	 * the compiler does not need to preserve the lock pointer across the
+	 * function call, avoiding callee-saved register save/restore on the
+	 * hot path.
+	 */
+	if (tracepoint_enabled(contended_release)) {
+		queued_spin_release_traced(lock);
+		return;
+	}
 	queued_spin_release(lock);
 }
 
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index d2ef312a8611..5f7a0fc2b27a 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -90,3 +90,19 @@ void __lockfunc queued_write_lock_slowpath(struct qrwlock *lock)
 	trace_contention_end(lock, 0);
 }
 EXPORT_SYMBOL(queued_write_lock_slowpath);
+
+void __lockfunc queued_read_unlock_traced(struct qrwlock *lock)
+{
+	if (queued_rwlock_is_contended(lock))
+		trace_contended_release(lock);
+	__queued_read_unlock(lock);
+}
+EXPORT_SYMBOL(queued_read_unlock_traced);
+
+void __lockfunc queued_write_unlock_traced(struct qrwlock *lock)
+{
+	if (queued_rwlock_is_contended(lock))
+		trace_contended_release(lock);
+	__queued_write_unlock(lock);
+}
+EXPORT_SYMBOL(queued_write_unlock_traced);
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index af8d122bb649..c72610980ec7 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
 #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
 #endif
 
+void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
+{
+	if (queued_spin_is_contended(lock))
+		trace_contended_release(lock);
+	queued_spin_release(lock);
+}
+EXPORT_SYMBOL(queued_spin_release_traced);
+
 #endif /* _GEN_PV_LOCK_SLOWPATH */
 
 /**
-- 
2.52.0


