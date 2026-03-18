Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47E11077603
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA136B02DE; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BC06B02DD; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E37F6B02E0; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2461A6B02DD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3A49540FC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:57 +0000 (UTC)
X-FDA: 84560063154.25.C0BD55F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CD5840006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=heHA5Omz;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dii3j/x0ZzJ6zru2y3vbKrgi3XfTdpsXr7lgtGyp114=;
	b=swKaaXk/o2aA83XeLfRGGH2R/IzJkTY7b1O0+Hjs+eBIt/OHEd4G3p/d5XlYtUS1n7lsZA
	Dagxsz5mPwLwdJHd8p/1BUK4Ik9v+hFjGEeoafeDbTvHwtXh5KSWMuWtzZ5SYQJYSc93pO
	jR7y3lOMXVdraaOKQip1xHMAPbq2Uwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859556; a=rsa-sha256;
	cv=none;
	b=T6FU8fDq6ENqQ4BMmvrW3EvYwcti6HghdyMI3p0doh5zCz94rJCGhRHamWHsZSMpEYPrxh
	5cvqITbW09rpjrUE/zb+K/q0cpR3X4vpoP6MOTDD/iYtJjjD8JIl7Lij196JWJmzIzJBvQ
	3pcQ3TGJ+mqfEtYQE3vcLcF0mNeM5P4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=heHA5Omz;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 716FBB3E46;
	Wed, 18 Mar 2026 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773859554;
	bh=dii3j/x0ZzJ6zru2y3vbKrgi3XfTdpsXr7lgtGyp114=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heHA5OmzNR4pBVCQiXiVwD2U7LO9WNFnY2iIiTS5t3QiuidYpa6PFOuATAY+5ZErf
	 TH/5gr0/YZ3igy2prDaonM5b0M78LMZ9Zk2sQU44n0nmEI5EY3iH5HOgHjxp8CBdSM
	 DHoHpvpOvXw5pSjDAffSKSL9e6bYkv81XX6Oi60s=
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
Subject: [PATCH v3 3/4] locking: Add contended_release tracepoint to sleepable locks
Date: Wed, 18 Mar 2026 18:45:20 +0000
Message-ID: <8579f5a43624ffddfe9a5dcc4b1fa59f016a4c75.1773858853.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773858853.git.d@ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3djhc1nimrqcaeaene35dzw5sba6mhy5
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CD5840006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773859555-456439
X-HE-Meta: U2FsdGVkX18l7PoaghMyrGx8aa1pr7jevPuk9yhNYKOe4xINbG63ZdFk/oY8YcQ1zGZyLbT6BkCU0eh8j25CQ//FSQJqlejS/I8HdE8KBZaXRWENrC3/NKIlhyYyrIuQaRUWtDiw/gvNRnHEastId9Ee7nzxeaJMx77zT83nnu0wiqU+iu26PNC3HsuIyt4+Ikqgtj75NviQKryJtRjTYid6qRChjLWMoBVbXcYiNFS3uDwBuU4xFrA+uMvLc1hBpPqF6HzDAV6xmbhN3yl+c9QGG/jhXmm/hUCgPTceSoR3rrWkFVyhSBDjPtVgMEthtQrwFa80QpbcERcaQvDisLbkc/jah+BPwhM+0mEsNN1QvtlsCIgwPirn+c4P7vHanH8xLRBLUrMkOPFImb9+8sYTbLpWAz8zFmviogjp8rUO9XQOEvdMzA+caNtFHCgEsaM2NVSqfqP6JEhW3t24iIl/4Tfp5KRfAuyD+6H6zUbWN9i0fMMEUkbKPcpXIrb1+5y1RLxjIdqq6PBoAzKxIoHdFHe1MZW272wl2UqAC1DatXsSq1yiKBheecVhNsDZvnNVmYyeTNOY/NLhepDISeZHoWTmvGMn7TOUpmmHWs4C8Cs6ktExXLMDKmipGX7rH3N0C7YJdJwBEw3KSgjq1rCrRJommoFo9vq+7ao4C31Iwd1y/4jXB3BvL3NEixLd+2TUW6syBuxeyhki43oyIpBUt7ilDDrpttVvXvy8hl5iORv9jsXGDWlrUer6CMHH0eU3wHugxajext2yJjRpis33xeOgDAQG7PqANQkviMUGIwjWScNG1Ai+a5XYiyyRmxmEKh5L1N69daXy/MZUV5JG5JCCh5iv6X92Zvz3QODqoUyoimFhSU1HSeqOZk42MZNUE3HqUgg+/miJwAmCRV2S2SbX0+hM3BTid8OMTGa/7ET2h8Uxu1NDrmstrX7SS5OUjydG4kTB/HGKKJo
 wwaCpYWi
 kmxuoT4GlfZYLF4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the contended_release trace event. This tracepoint fires on the
holder side when a contended lock is released, complementing the
existing contention_begin/contention_end tracepoints which fire on the
waiter side.

This enables correlating lock hold time under contention with waiter
events by lock address.

Add trace_contended_release() calls to the slowpath unlock paths of
sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
RT-specific rwbase locks.

Where possible, trace_contended_release() fires before the lock is
released and before the waiter is woken. For rwsem, semaphore, and
rwbase_rt read unlock, the tracepoint fires after the release but before
the wake, as contention is determined by the return value of the atomic
release operation.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/trace/events/lock.h   | 17 +++++++++++++++++
 kernel/locking/mutex.c        |  3 +++
 kernel/locking/percpu-rwsem.c |  4 ++++
 kernel/locking/rtmutex.c      |  1 +
 kernel/locking/rwbase_rt.c    |  8 +++++++-
 kernel/locking/rwsem.c        |  9 +++++++--
 kernel/locking/semaphore.c    |  4 +++-
 7 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index da978f2afb45..1ded869cd619 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -137,6 +137,23 @@ TRACE_EVENT(contention_end,
 	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
 );
 
+TRACE_EVENT(contended_release,
+
+	TP_PROTO(void *lock),
+
+	TP_ARGS(lock),
+
+	TP_STRUCT__entry(
+		__field(void *, lock_addr)
+	),
+
+	TP_fast_assign(
+		__entry->lock_addr = lock;
+	),
+
+	TP_printk("%p", __entry->lock_addr)
+);
+
 #endif /* _TRACE_LOCK_H */
 
 /* This part must be outside protection */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 427187ff02db..bb25741c2768 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -997,6 +997,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
 		wake_q_add(&wake_q, next);
 	}
 
+	if (trace_contended_release_enabled() && waiter)
+		trace_contended_release(lock);
+
 	if (owner & MUTEX_FLAG_HANDOFF)
 		__mutex_handoff(lock, next);
 
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index f3ee7a0d6047..6bf2ccddd42d 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -263,6 +263,9 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
+	if (trace_contended_release_enabled() && wq_has_sleeper(&sem->waiters))
+		trace_contended_release(sem);
+
 	/*
 	 * Signal the writer is done, no fast path yet.
 	 *
@@ -292,6 +295,7 @@ EXPORT_SYMBOL_GPL(percpu_up_write);
 void __percpu_up_read(struct percpu_rw_semaphore *sem)
 {
 	lockdep_assert_preemption_disabled();
+	trace_contended_release(sem);
 	/*
 	 * slowpath; reader will only ever wake a single blocked
 	 * writer.
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index ccaba6148b61..3db8a840b4e8 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1466,6 +1466,7 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 		raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	}
 
+	trace_contended_release(lock);
 	/*
 	 * The wakeup next waiter path does not suffer from the above
 	 * race. See the comments there.
diff --git a/kernel/locking/rwbase_rt.c b/kernel/locking/rwbase_rt.c
index 82e078c0665a..081778934b13 100644
--- a/kernel/locking/rwbase_rt.c
+++ b/kernel/locking/rwbase_rt.c
@@ -162,8 +162,10 @@ static void __sched __rwbase_read_unlock(struct rwbase_rt *rwb,
 	 * worst case which can happen is a spurious wakeup.
 	 */
 	owner = rt_mutex_owner(rtm);
-	if (owner)
+	if (owner) {
+		trace_contended_release(rwb);
 		rt_mutex_wake_q_add_task(&wqh, owner, state);
+	}
 
 	/* Pairs with the preempt_enable in rt_mutex_wake_up_q() */
 	preempt_disable();
@@ -205,6 +207,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
+		trace_contended_release(rwb);
 	__rwbase_write_unlock(rwb, WRITER_BIAS, flags);
 }
 
@@ -214,6 +218,8 @@ static inline void rwbase_write_downgrade(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
+		trace_contended_release(rwb);
 	/* Release it and account current as reader */
 	__rwbase_write_unlock(rwb, WRITER_BIAS - 1, flags);
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index bf647097369c..767a1a2b7d8c 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1390,6 +1390,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
 		      RWSEM_FLAG_WAITERS)) {
 		clear_nonspinnable(sem);
+		trace_contended_release(sem);
 		rwsem_wake(sem);
 	}
 	preempt_enable();
@@ -1413,8 +1414,10 @@ static inline void __up_write(struct rw_semaphore *sem)
 	preempt_disable();
 	rwsem_clear_owner(sem);
 	tmp = atomic_long_fetch_add_release(-RWSEM_WRITER_LOCKED, &sem->count);
-	if (unlikely(tmp & RWSEM_FLAG_WAITERS))
+	if (unlikely(tmp & RWSEM_FLAG_WAITERS)) {
+		trace_contended_release(sem);
 		rwsem_wake(sem);
+	}
 	preempt_enable();
 }
 
@@ -1437,8 +1440,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 	tmp = atomic_long_fetch_add_release(
 		-RWSEM_WRITER_LOCKED+RWSEM_READER_BIAS, &sem->count);
 	rwsem_set_reader_owned(sem);
-	if (tmp & RWSEM_FLAG_WAITERS)
+	if (tmp & RWSEM_FLAG_WAITERS) {
+		trace_contended_release(sem);
 		rwsem_downgrade_wake(sem);
+	}
 	preempt_enable();
 }
 
diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index 74d41433ba13..d46415095dd6 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -231,8 +231,10 @@ void __sched up(struct semaphore *sem)
 	else
 		__up(sem, &wake_q);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
-	if (!wake_q_empty(&wake_q))
+	if (!wake_q_empty(&wake_q)) {
+		trace_contended_release(sem);
 		wake_up_q(&wake_q);
+	}
 }
 EXPORT_SYMBOL(up);
 
-- 
2.52.0


