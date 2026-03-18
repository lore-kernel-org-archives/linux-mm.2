Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F3691077605
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9487B6B02DD; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C926B02E1; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679206B02DF; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4386B02DE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E79EEC02F1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:57 +0000 (UTC)
X-FDA: 84560063154.06.5112619
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DE24140009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gzii1qN3;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoJMtJZBdJt0FTbec+scIJtxKZOmfkRxPSoXFT7NQCU=;
	b=KYG0+ep1llVu9qV0shBPZ0DjayerhI1EqhOX0/PL6tK/JiEQqV3QROmOOkAbdb3Dp4SYrI
	99GXSAeHXjH0K4ZlTzJbsWVirJs3u2i8kRPjbTbnrJqd4uEiYSE+Onf4djl4lfDEnX8ztt
	KqzE2/tyubz3XsQPHEhU3Wq9RIB8Kf0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gzii1qN3;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859556; a=rsa-sha256;
	cv=none;
	b=miPMtZqATp0o0Mf3q2VyXwRIB7IMHKhcwM8joaQnfQV9KxnML86MnLt58ixNBhoxDdmIbp
	VMpwfQopnulRrigMdnQ6DKTVBCFTkFfoxoWM+NewlihkpSxHgGBVuzzsGQbg77bufATNMM
	F24uGo/c4OMhfIVPCLXiHCt3SZDFS64=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B906CB3E49;
	Wed, 18 Mar 2026 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773859554;
	bh=UoJMtJZBdJt0FTbec+scIJtxKZOmfkRxPSoXFT7NQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzii1qN3ZcHKYIqa7QmKZHgZRA1Jqvy2B437x/KXowu8/6H3zG8LQ/rwgSoiffBwj
	 9Mxbl+/LOeX4RmEJE/y5eIdj4he16ieFYSOLvHc+fJQ9yxfojsxUq7XU6qjdPaBu0N
	 uvUjccWiRig8BnciMa5g2jOr1Geng1zDcg8TZzxE=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [RFC PATCH v3 4/4] locking: Add contended_release tracepoint to spinning locks
Date: Wed, 18 Mar 2026 18:45:21 +0000
Message-ID: <51aad0415b78c5a39f2029722118fa01eac77538.1773858853.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773858853.git.d@ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DE24140009
X-Stat-Signature: 7nomb3gnc6aka33n66514p8mszkgh6xs
X-Rspam-User: 
X-HE-Tag: 1773859556-563188
X-HE-Meta: U2FsdGVkX1/BtH3af79ZvoE8ExtL4hQSaZTsf703GEK0IEk5TRuP1phlaLeUM0C0k5peRmyvrgKUF8H0vXYRNLHIS/je36S9b/4AP7SKo7n6Ls1BY3qRxKS/lVkeeErlj/GdJa4HgVNDg84T6OM7bnlz+T3qPYkAX9PbB5pvCgeGhiRx0ZMxZWpkDPX/EcVnC4ubcKQtf0kTdjIRnVnWpD1CWAu43SI+knd87WtHuxAXxVeCSinzVlIWC6CXg0GeSRjeYUTs7aRAjr6tHUQ/ARV9b8qwkf7j7xoSZavzlL0o20POrI5Smp0InyVx3eIc3jpThfxPObuC2e/c21ow/lCqOPh6AfKY7wHL+q8mCsAJTwLwn+x/DGKoJlA8loUGA4VMBirIUmukh/TQN3UpRjbxYs7No0eR+HVMdWdxZb/m2mdYvUO/4LuUrSHRIryIM3gKeTzxVBQhbS9c8tIIhv5d4pMUnbI86YlbAvhMHQmTzDQKevroCOqfHw2tk/JZRU4NGrXstHgHb2d7FKrDQRZ65hgWJTT8eYkDy/dCzKaVIgotMLGcVgxaUpjfZ142S+BlB9LT5rbj43heMNQ4Yu3DyV/G3rAb7c1jzAZLcZSYdl955T/rIch+ZMESxWnJsA6F5Kp9Lve++TR153kX1B1WMaY7bIoyEFzreFauhCcVQwVEZe25G7XBH7Ia5h/GJAw1Oky4NeUBtA0jfgvzfcyu2ObZN3ab7OKJNbi/US9OIy5eWoNtsSQX2XzCMLAzrHmJIqGyXW4grgcNLnyk+36MBHT+78peQNL9nLgzgsB/KaN+s4gqpidgFGVZSI3Wq14rW2pSadFIveF/7ehyMdZtjP2mKIqF0RLHRorw9oTnciMNwc4BuLtcEi0DQc+AK1BfviEydtQXzyIF5BAQj7IO7qF4FU95sRaJaDyLngAxr1+T3vGGMGI+SrIowUS5pE93K1dDSVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the contended_release tracepoint to queued spinlocks and queued
rwlocks.

When the tracepoint is disabled, the only addition to the hot path is a
single NOP instruction (the static branch). When enabled, the contention
check, trace call, and unlock are combined in an out-of-line function to
minimize hot path impact, avoiding the compiler needing to preserve the
lock pointer in a callee-saved register across the trace call.

Binary size impact (x86_64, defconfig):
  uninlined unlock (common case): +983 bytes  (+0.00%)
  inlined unlock (worst case):    +71554 bytes (+0.30%)

The inlined unlock case could not be achieved through Kconfig options on
x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
inline the unlock path and estimate the worst case binary size increase.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/asm-generic/qrwlock.h   | 48 +++++++++++++++++++++++++++------
 include/asm-generic/qspinlock.h | 25 +++++++++++++++--
 kernel/locking/qrwlock.c        | 16 +++++++++++
 kernel/locking/qspinlock.c      |  8 ++++++
 4 files changed, 87 insertions(+), 10 deletions(-)

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
index bf47cca2c375..8ba463a3b891 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -41,6 +41,7 @@
 
 #include <asm-generic/qspinlock_types.h>
 #include <linux/atomic.h>
+#include <linux/tracepoint-defs.h>
 
 #ifndef queued_spin_is_locked
 /**
@@ -116,6 +117,19 @@ static __always_inline void queued_spin_lock(struct qspinlock *lock)
 #endif
 
 #ifndef queued_spin_unlock
+
+DECLARE_TRACEPOINT(contended_release);
+
+extern void queued_spin_unlock_traced(struct qspinlock *lock);
+
+static __always_inline void __queued_spin_unlock(struct qspinlock *lock)
+{
+	/*
+	 * unlock() needs release semantics:
+	 */
+	smp_store_release(&lock->locked, 0);
+}
+
 /**
  * queued_spin_unlock - release a queued spinlock
  * @lock : Pointer to queued spinlock structure
@@ -123,9 +137,16 @@ static __always_inline void queued_spin_lock(struct qspinlock *lock)
 static __always_inline void queued_spin_unlock(struct qspinlock *lock)
 {
 	/*
-	 * unlock() needs release semantics:
+	 * Trace and unlock are combined in queued_spin_unlock_traced()
+	 * so the compiler does not need to preserve the lock pointer
+	 * across the function call, avoiding callee-saved register
+	 * save/restore on the hot path.
 	 */
-	smp_store_release(&lock->locked, 0);
+	if (tracepoint_enabled(contended_release)) {
+		queued_spin_unlock_traced(lock);
+		return;
+	}
+	__queued_spin_unlock(lock);
 }
 #endif
 
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
index af8d122bb649..1544dcec65fa 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
 #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
 #endif
 
+void __lockfunc queued_spin_unlock_traced(struct qspinlock *lock)
+{
+	if (queued_spin_is_contended(lock))
+		trace_contended_release(lock);
+	__queued_spin_unlock(lock);
+}
+EXPORT_SYMBOL(queued_spin_unlock_traced);
+
 #endif /* _GEN_PV_LOCK_SLOWPATH */
 
 /**
-- 
2.52.0


