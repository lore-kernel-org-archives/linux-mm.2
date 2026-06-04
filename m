Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8CACD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3296B0095; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCEA6B0099; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182AF6B0095; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 049BD6B0095
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7DB0A062E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:33 +0000 (UTC)
X-FDA: 84841369746.16.1C5B4E4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 121D61C000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0LupkOPV;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLXxTrSmFHZlKaFxxrI36D4pPO0XMiNqu/N8Xnsp7Ew=;
	b=6NZvjAneC7k+hDFw/BqlR2/HXTBlkxAab4vwxMM5HSd0cgXnA/CzCB51KpnBH3abnd0OJe
	03NeBkAMejdqshMWETwyD8lGxVusMac0kh8sPgrsivKx1SUuGjFfAeQ6QYSK1uOpkw8wOd
	oI+18xyKPe21jpCs9RYNVoymCxs4C4M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0LupkOPV;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557332;
	b=iLJZsNCVU7oFt4452jtjAzTh/N8MWfBaLhdviQU/WI+4Qg7VidAQn6OFWhVJ2vaLEYQHEi
	z6XNP7o/aY9LEQuZvnjeIwmhW1RntOEr2tgCKGYqJeu4SHVmYVzEyRHBPqCcp7GqI/9dOx
	hzBljfnkYyJMbuP83IKVdmE7vVoIsZE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6647DD115E;
	Thu, 04 Jun 2026 07:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780557330;
	bh=nLXxTrSmFHZlKaFxxrI36D4pPO0XMiNqu/N8Xnsp7Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LupkOPVf3tCpIHMJgDydCAfvmN7wz6XEcgmGwHjRfJ6qW9D2RZtPF0rbr1OBzcwE
	 y6o3/hjwIBwGgrqwEZvER8bj72zW5Q2VZfi/HdInxcwNim66vPqyj9DRBAg+N8a8iW
	 kSu+X1bBLNAydLirVXs8DaDPV5AVO/PymAFDvoSw=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v7 3/3] locking: Add contended_release tracepoint to sleepable locks
Date: Thu,  4 Jun 2026 07:15:07 +0000
Message-ID: <02f4f6c5ce6761e7f6587cf0ff2289d962ecddd4.1780506267.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780506267.git.d@ilvokhin.com>
References: <cover.1780506267.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 121D61C000D
X-Stat-Signature: 3e3xjorxr3zo4u5w6rr8b8n4wpyu1qem
X-HE-Tag: 1780557331-472385
X-HE-Meta: U2FsdGVkX18EIi+hzxO1UPjXuDmUlAtitEy5Kz/gkRhBAZSAwbsk4vIYdOfP5cDmYdyTPR6J7xs+jiY1Rjw5Y7/dK799qAjlPUQ3Do1mwXWQHaxrxkElc067Zux6rgSngKvtCC3m/zBoHJW7xPiXqpGhlvsE65+lRFU9ZemNAYv3MdrlL5sCUFOYv2oGGn3xb6X/DdNrEcM5VRqI70Sgw/8coUDietjWoYmd0gHxlpNTF+ttFZTD3LOj47vgnwmBRL31zT4q9z9tZLCmEFhypIeQ+zGg1TV78IaAgeUdOdq3Kwsg3OKRxH00I/EXVwfTb3BI43SSRkrS2pDhDgWDlt5wbZVVtcMRh7HhxOIGvdqM0NeaA6xdBQ4Be+v5zYD3TzJWScMRoBa0GseTjeJZ1emruXeikBlvuDcX8DS41Tmf6gu5bpfyQFVEZIMqO9NvFi40Xb9xkb+k67wzIov2qMbDwePnM+inV8T3CO1mWl1XVh9Y3ZIBUPXQxwbWMzNTXSE6XmmSmZwuVJvJwOSj/hOq53HV/MmGCiJYvTjBHU/PlYq/h3hZMqFeUfpPW571l012tAGStlk795ZFuxh4g/fUwkR1gLF2dqPRFe7LcqfyTaiPzlz98U9jXW3XE8VSGApBfRvO2wQtHDL/iyB7qv2jDo2ZWfStS1P0Lcw3xDhl/k3btMKQ9s0D6LPh3bXOvp+P3MGKDx1nugcZSd57bezVjKuKW5gPzpMaXnDPO8KI5wVFKFE/xm1bknKrCNY0sB3UietaZRM2oJlhaoDZVWV3WDuTPBtqgoaQk4bu95jNhFe7y+iEKlbprYJTxwZSthJ9lNVk1gtAfQUKcU+710/P62QofWzNUlYvh7PuK8ShXEIXdFqB9tb3hINItXhk+743IxbNQHYeqiGqCvKtunCPoaGBaXNPyvdeg689aXIbaLProEmBS8nx8DKUuXj/oXbAbbu9u28lzes06vM
 y2lfVaI4
 pSX/ehO8Y8wb3R4k+aqpvRwUu33lRKC04jk1hRy6LQ+S4CwcziN9b5oHh3cjpF/VoS+oxJCR7isbBFOZie35Rfdz85wSGOu6GqYWH+J61K51Az6rbKMu2v5G5pUEEPMnRVcBMFBiSUfrvqnivVmn8Xd7J7DPcUYm7LAjSaFjhdkTx7RWnRTBPKSZFfHPq3uv4k4hViii7xq502xyRuROdThUo1U+bSXF7yUY+4tdmP/qVb+W8Qv5oDDTqlbAvAIDDVetgExuLMJaphV+5qJN4ixvb9UdwtM8NHL9zGZ4JfmkUlGhlMq4IZC6ta6HyJCI8kEMPoGw8a8U763OsChJhobMIKnhq48maTfyZ
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
index 9147d6a31b78..28beae7d21fe 100644
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
2.53.0-Meta


