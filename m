Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD5010A3D96
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174736B008C; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1256E6B0093; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F6E6B008C; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15C86B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B10E61B94FF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:24 +0000 (UTC)
X-FDA: 84588550368.06.C455D9C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id E44F61C0016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=CVHp7urw;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/M9PsdD1hvodrj8kym7pAUYAKq2QJMoXOtrpOgGSSk=;
	b=UX0MTB2o8BoS25V94nCK1NDAffqgJ2oOfEw1kyWbDEBY3Wk2wpjACK0RGj7I/QGhFXVWc+
	3FTByP21lyOk7CU9emW+hbkHK+m/o2fNu3UGUQusr+LEQD1+ALbjWehYHUM+cNmZxlNf5A
	e/bb8TvLhTJpMPHJKRnnxPI23qKwkyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537823; a=rsa-sha256;
	cv=none;
	b=Q1NPzqzp0RPo7lGddo/VR2rtFxlH7pfvy9az22bxAkNP7/QnaIgEgmA9IPD8FJAGnY3Bsw
	b+BifWMBZnuf6fUEBrsriHiQ+kogZND8Eyv4SLSaI72Y7lLNvHoRJiUM+xcuFxFK+2eczX
	DUUJvEn3GU1bNM/wZnLOpczTsYyjIZY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=CVHp7urw;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A15A2BDE15;
	Thu, 26 Mar 2026 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537821;
	bh=i/M9PsdD1hvodrj8kym7pAUYAKq2QJMoXOtrpOgGSSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVHp7urwzbN5ASyotqDRqqGd+HBvSD1RzM6rD7/UT4LcaHVhcSPSvqdam9KollFRC
	 bPnWAZOq+H9bCYGM7CSQ1TsjvY8A0RzEooO/Ydq1T5xkNsQk6+u3rSCseIlPRRYBHW
	 +QjOaMxZL31tg/TU0+IvGKyZkz0PskRVs7I9EKoM=
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
Subject: [PATCH v4 3/5] locking: Add contended_release tracepoint to sleepable locks
Date: Thu, 26 Mar 2026 15:10:02 +0000
Message-ID: <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E44F61C0016
X-Stat-Signature: jguysd4wyn41rxeq49iwpjxw55zuiwq3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774537822-12466
X-HE-Meta: U2FsdGVkX18emJu+OH9cWOJgi4IuR2z6hQxIGvzHNi+Sy0aYMBbNJyfhSWZDa7eSqUMPW4cupOwJGE0TtjcirxemsMdvqw0/aM3VUK6KxCphWz0acvcIACMNbICYCrF6x6Ga55koBhVmtq0mf8d5NSEfI3HnXsVoOcEWU6BUFiRVh5iEr/vBaZR59g3n0o0h6cidIEvf3EsKL4MjeoO8udb0cjEZWRGiUMOAMMvrRM3SaOkIwP240YLkG9YjcB99YPg981NaiT8Gz7XQmfIjSI4Sy/mYgIj1hdBKki0C1hyT4M8BD8Aqc/xUD0h/Ci+hbY9cZ1X725PAEY7l7+BVi/Gp7Hzcejh+apkRIw0sCXC31IVseyCXDBDybHtmQMFi9uXj4dz+cTll0uCkPIYo//JxO83+s2TVjSiCwkGw+CcsWPx7ODHGutQXqO+mWc1D0OvpHnU1BforZ8SaMX7Q9GzEbtTYn1QZSsgK7pj00VR87F29t+vM9nq4Ganucmn6CXG6scRKtYAMZcVhNAfVEOglKSbuHxgVte6fDdEz5pRgq9HWpPfZ47MM6UNbnOTK4KcMcM7myqidSp8Z6yiyOvA4RLyUB/r+u+Fbg//dYGEzluZfi+TeacqLRgzkDLP2QKeeG7ae3HoqzjUYwNMJ6nKWa2aIF7bG5d+el0ybQEyEea6MFHnEkXgb1Kq75GG78l42XielRYlbOTdXfoBSp3rZeRVH71B+h5WX0Op8Cganw3Ds7XcIUUF1xqTJS25V+plsplvSIRWiY2buqI/0pwG7OqVLme37Ij3Lh4bo5Z31cP4QrAJoxeAj+DH6TVNpejvUtJk2yNeau45wyE3VckwIspn0GANbpRKx3URWgyYnWmKZyso+HuxHRgf0GWNkV7YzHIEnvVig1Vjo6Pb37GP4Uniw5k15rH3k5BD62Z5Lx5HsdIgOMkHQG1iCiC3BcwjdZ2C+3f09iz8l4pM
 /nN12wSl
 qr6n95mA+Oeddbhw=
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
released and before the waiter is woken. For some lock types, the
tracepoint fires after the release but before the wake. Making the
placement consistent across all lock types is not worth the added
complexity.

For reader/writer locks, the tracepoint fires for every reader releasing
while a writer is waiting, not only for the last reader.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
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
index 427187ff02db..6c2c9312eb8f 100644
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
 
@@ -1194,6 +1197,7 @@ EXPORT_SYMBOL(ww_mutex_lock_interruptible);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(contention_begin);
 EXPORT_TRACEPOINT_SYMBOL_GPL(contention_end);
+EXPORT_TRACEPOINT_SYMBOL_GPL(contended_release);
 
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index f3ee7a0d6047..46b5903989b8 100644
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
+		trace_contended_release(sem);
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
index 82e078c0665a..74da5601018f 100644
--- a/kernel/locking/rwbase_rt.c
+++ b/kernel/locking/rwbase_rt.c
@@ -174,6 +174,8 @@ static void __sched __rwbase_read_unlock(struct rwbase_rt *rwb,
 static __always_inline void rwbase_read_unlock(struct rwbase_rt *rwb,
 					       unsigned int state)
 {
+	if (trace_contended_release_enabled() && rt_mutex_owner(&rwb->rtmutex))
+		trace_contended_release(rwb);
 	/*
 	 * rwb->readers can only hit 0 when a writer is waiting for the
 	 * active readers to leave the critical section.
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
index bf647097369c..602d5fd3c91a 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1387,6 +1387,8 @@ static inline void __up_read(struct rw_semaphore *sem)
 	rwsem_clear_reader_owned(sem);
 	tmp = atomic_long_add_return_release(-RWSEM_READER_BIAS, &sem->count);
 	DEBUG_RWSEMS_WARN_ON(tmp < 0, sem);
+	if (trace_contended_release_enabled() && (tmp & RWSEM_FLAG_WAITERS))
+		trace_contended_release(sem);
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
index 74d41433ba13..35ac3498dca5 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -230,6 +230,10 @@ void __sched up(struct semaphore *sem)
 		sem->count++;
 	else
 		__up(sem, &wake_q);
+
+	if (trace_contended_release_enabled() && !wake_q_empty(&wake_q))
+		trace_contended_release(sem);
+
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
 	if (!wake_q_empty(&wake_q))
 		wake_up_q(&wake_q);
-- 
2.52.0


