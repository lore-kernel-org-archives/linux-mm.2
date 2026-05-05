Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D429FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5528B6B00B3; Tue,  5 May 2026 13:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC4A6B00B7; Tue,  5 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3186B00B8; Tue,  5 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEA96B00B3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C11F31C112D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:57 +0000 (UTC)
X-FDA: 84734003634.07.D2472E6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0024E40007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="zcCtOI/d";
	spf=pass (imf01.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TU6fnwDkVJ/mUD/VZ0OBa0Es886o/JD7esEKomLEV8o=;
	b=0BOJyC0lOEieUyTG7j7FeWZXTgCORA+hzS2jFdPtU8qVyD7ULTI6TyBjedHb5NM6pyv37B
	7gidBYBCgmdila2cxVWRTKtLsdhsyEiXtDw/4xqS24tFg2y/y/slw+Nw/NVtkmzxBRGH2B
	FtwQk+J7hh/xs+Jk0dYyuDRNLW74FgE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="zcCtOI/d";
	spf=pass (imf01.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000996; a=rsa-sha256;
	cv=none;
	b=EKcuZkKn6LJcSwd4NVh3pdmoU2pKhff2zcqzU05a6mCtMAs3YBBP9e8GICgvCRGVNIDltu
	SbaMbIdsgFA1ZApaQAWtQqeoteF9pLZOhYNa99R4lZPnp0zuJ8WiiPdK/uErq+q8BOvjXQ
	6EypIAOe/Ca9ng21IsRO0FMGBZrrF5Q=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id ECED4CFFF7;
	Tue, 05 May 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000994;
	bh=TU6fnwDkVJ/mUD/VZ0OBa0Es886o/JD7esEKomLEV8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcCtOI/d+ZuvnwEzkIXl5D/JI/z6PvCNTaZw9QKwmjnme0R6jWKnWQL1dqEr7LjZ/
	 zS8X0JF9txAqSbwGjuc0jKcz3Xyfm5r1QknHBbg9XC67GAnznYDi/a5WDrY1ZtkK9V
	 0Uh/RsxUM9enkB10s7cXSbaVULny+m8bSeLRl+is=
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
	Dmitry Ilvokhin <d@ilvokhin.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v6 3/7] locking: Add contended_release tracepoint to sleepable locks
Date: Tue,  5 May 2026 17:09:32 +0000
Message-ID: <81cac7754f10897977094baa1b93779c66d894f8.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cb6ekairm7qpmo6drwzkhou88f7uccab
X-Rspamd-Queue-Id: 0024E40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778000995-705128
X-HE-Meta: U2FsdGVkX188gUyTCDCC4gU4v67taxqXoMBaFFXV/roL/GvoaBRb3qi30l9KKytIwJuHlCjLtf8dq3BCIP9Z/1a6KqIypsQdmAOApd4yCjEgIjdSITxVagkSDb3/qZYbGdvySnqTnd1eSM2KBLF6+I30/FrYKh8iF/QPjdgDNOskPv6Tf96UZoFjzZL9IFxZe/KfRCZhoG22Ppiue5BPpu40FNT3fx3QH2c1Em7WUDaiReGwbldAOL3IS+E0mWmKCX/uR7TTOxIlwO25avHThr6ZzomoUkm5WdBPqWWuYtCmqjljT29+4b2yl+Pr8ynq3MnsLK/BlM7g4gL56uNiPszS4B32uWBv6ISDklB/NvvnLPLQJp7qfP2SG830YNrnPQEjZw/x9oEEVIIer1Mq225teFVpMie5tA4eBByFUCCmrIceNuVQh3G3BbpF2QbZv9N+gBkws6UpkZXkxrsnFTwcscoN+9XHBUAe2RI/0NVmZT21S++1MSUZ9L61+MXR0RpjOT+gwi02vn88/2ohhxuXncSGF+/oR4jUPFuoYTO+XsCqmq+cClVTf/KVbjm/5iodCA/pYcIzIKW13xRAVCARt34tSKF14b0FJI1gyiZpO4tAVI0M599HNwCF2jpqaw6hoEYpeIZizxAGmbS6abYBDs739CnJuU4RfVL5F4yOCyA98iHwtbJl0XfrD0rh05GytA+eI4OizMcCTyO2sJT9/yFW8LdwOzUwD41G/5RhAIyf+RiWmDoHfidXU16bZiq+Rudg1xiI4du9mYHR7asNLsyX8yBPzBECc9L3uPSpsaKjbzoP9zKcs3HNLFmrqMj6qQMU5xT5ZbqJwEAXKNRLHX3Wn27hCwWCX/AMwe70S3vmWp3u/ZK4Rdr0tO16RRlWik4QP3k0De5rgqSsoP/MaoS9MvMU0adgkicXLSU+SvgNyoWQSdra2iGSg2qK9BqCpkvPVAXHRIkXt/B
 w5YARbYL
 5HLdW1wM5lDjTEmV4MrERgp3TNFIag01Xx5g8fQr5EGS+7GzuUvcnVpknW1aMlUzIi+4Mvtq7te8i/8sMg2XTnNkFYkxAKuM+0ruLrCvUYs6EqXeL0ZwXXHvgIdNX9oBz9oW3ueHxylgJadAEqgJvmDWgiK5HZ//ur4tmOmPom1I8RS8/HH4ja7PPmT+BnD881IPGf0pln4STtPpFgS4+vGBC9cn8h+/nEtk3qG3ltwZeM/8+VcsXW4HzAWpwSt6BBlljwWsbfrgvu7F8Ckeu6wc4mFkYAEjkIZngPfxJboueBpXhEX8ooCkSl5PprNMB36GV8261CsUcdNYTfX5mJEbxoZH5WRnyRjlr
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

Add trace_contended_release()/trace_call__contended_release() calls to
the slowpath unlock paths of sleepable locks: mutex, rtmutex, semaphore,
rwsem, percpu-rwsem, and RT-specific rwbase locks.

Where possible, trace_contended_release() fires before the lock is
released and before the waiter is woken. For some lock types, the
tracepoint fires after the release but before the wake. Making the
placement consistent across all lock types is not worth the added
complexity.

For reader/writer locks, the tracepoint fires for every reader releasing
while a writer is waiting, not only for the last reader.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/trace/events/lock.h   | 17 +++++++++++++++++
 kernel/locking/mutex.c        |  4 ++++
 kernel/locking/percpu-rwsem.c | 11 +++++++++++
 kernel/locking/rtmutex.c      |  1 +
 kernel/locking/rwbase_rt.c    |  6 ++++++
 kernel/locking/rwsem.c        | 10 ++++++++--
 kernel/locking/semaphore.c    |  4 ++++
 7 files changed, 51 insertions(+), 2 deletions(-)

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
index 09534628dc01..43b7f7e281a0 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1023,6 +1023,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
 		wake_q_add(&wake_q, next);
 	}
 
+	if (trace_contended_release_enabled() && waiter)
+		trace_call__contended_release(lock);
+
 	if (owner & MUTEX_FLAG_HANDOFF)
 		__mutex_handoff(lock, next);
 
@@ -1220,6 +1223,7 @@ EXPORT_SYMBOL(ww_mutex_lock_interruptible);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(contention_begin);
 EXPORT_TRACEPOINT_SYMBOL_GPL(contention_end);
+EXPORT_TRACEPOINT_SYMBOL_GPL(contended_release);
 
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index f3ee7a0d6047..f7e152c40d6d 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -263,6 +263,9 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
+	if (trace_contended_release_enabled() && wq_has_sleeper(&sem->waiters))
+		trace_call__contended_release(sem);
+
 	/*
 	 * Signal the writer is done, no fast path yet.
 	 *
@@ -292,6 +295,14 @@ EXPORT_SYMBOL_GPL(percpu_up_write);
 void __percpu_up_read(struct percpu_rw_semaphore *sem)
 {
 	lockdep_assert_preemption_disabled();
+	/*
+	 * After percpu_up_write() completes, rcu_sync_is_idle() can still
+	 * return false during the grace period, forcing readers into this
+	 * slowpath. Only trace when a writer is actually waiting for
+	 * readers to drain.
+	 */
+	if (trace_contended_release_enabled() && rcuwait_active(&sem->writer))
+		trace_call__contended_release(sem);
 	/*
 	 * slowpath; reader will only ever wake a single blocked
 	 * writer.
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 69759fde7d10..9a4c3bee50ac 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1470,6 +1470,7 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 		raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	}
 
+	trace_contended_release(lock);
 	/*
 	 * The wakeup next waiter path does not suffer from the above
 	 * race. See the comments there.
diff --git a/kernel/locking/rwbase_rt.c b/kernel/locking/rwbase_rt.c
index 82e078c0665a..2835c9ef9b3f 100644
--- a/kernel/locking/rwbase_rt.c
+++ b/kernel/locking/rwbase_rt.c
@@ -174,6 +174,8 @@ static void __sched __rwbase_read_unlock(struct rwbase_rt *rwb,
 static __always_inline void rwbase_read_unlock(struct rwbase_rt *rwb,
 					       unsigned int state)
 {
+	if (trace_contended_release_enabled() && rt_mutex_owner(&rwb->rtmutex))
+		trace_call__contended_release(rwb);
 	/*
 	 * rwb->readers can only hit 0 when a writer is waiting for the
 	 * active readers to leave the critical section.
@@ -205,6 +207,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
+		trace_call__contended_release(rwb);
 	__rwbase_write_unlock(rwb, WRITER_BIAS, flags);
 }
 
@@ -214,6 +218,8 @@ static inline void rwbase_write_downgrade(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
+		trace_call__contended_release(rwb);
 	/* Release it and account current as reader */
 	__rwbase_write_unlock(rwb, WRITER_BIAS - 1, flags);
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index bf647097369c..b9c180ac1eee 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1387,6 +1387,8 @@ static inline void __up_read(struct rw_semaphore *sem)
 	rwsem_clear_reader_owned(sem);
 	tmp = atomic_long_add_return_release(-RWSEM_READER_BIAS, &sem->count);
 	DEBUG_RWSEMS_WARN_ON(tmp < 0, sem);
+	if (trace_contended_release_enabled() && (tmp & RWSEM_FLAG_WAITERS))
+		trace_call__contended_release(sem);
 	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
 		      RWSEM_FLAG_WAITERS)) {
 		clear_nonspinnable(sem);
@@ -1413,8 +1415,10 @@ static inline void __up_write(struct rw_semaphore *sem)
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
 
@@ -1437,8 +1441,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
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
index 74d41433ba13..233730c25933 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -230,6 +230,10 @@ void __sched up(struct semaphore *sem)
 		sem->count++;
 	else
 		__up(sem, &wake_q);
+
+	if (trace_contended_release_enabled() && !wake_q_empty(&wake_q))
+		trace_call__contended_release(sem);
+
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
 	if (!wake_q_empty(&wake_q))
 		wake_up_q(&wake_q);
-- 
2.52.0


