Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264ADFD4F0F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF66E6B0088; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4CA6B008C; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA9F6B0092; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A82F56B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48AE913A3E4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:02 +0000 (UTC)
X-FDA: 84530891844.05.9064387
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 885D41C000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="GIVr/5DW";
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MN/vj8HfI8aMqCrRTurhnitKN8uIAxpU0TiUVovwqM=;
	b=G1ibRD27Hh4mZARhNw9FIolJ88HWFv1iOyzWPBBP9bva2lQZsvMAsj2xAo2XVe4XGXsqlR
	TbQnMW3ulCYV6VxPkJN7P0M5x08Mggbs5rTFt912C4iIjSQz5H3KW8lb3G4PjIBm6ORhen
	sKMyTLtY9ck2tyjnU8boTzEfjIqUkSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165000; a=rsa-sha256;
	cv=none;
	b=3VW4fj4ggfjqEKYWE1NqrXs9jtUH2nolifozoMOg9bvcT3UTf7Nzyq173HClqpSae0ox9d
	zQ0aINXP06KknTYi9N3jPEBL1RFf5QE26ChwHgVQ8fqjQSqR2j3OPaT3MuZm70wDJe7a0/
	RHj/zA7rxomoDw2617WfMbnx6qr9muI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="GIVr/5DW";
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id EE16EB382C;
	Tue, 10 Mar 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773164999;
	bh=9MN/vj8HfI8aMqCrRTurhnitKN8uIAxpU0TiUVovwqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIVr/5DWzY/aI05+illM0LXMLuWwX9FDyHG64qseRzdJfUMgizJHPNVV0MJ4Sqkxk
	 W4kAaiW+bHnNMROoycbuhLq2ebHtL289aUzHWJJ582bpoSjI2ZxvCPX9dcBuGs0a7I
	 4oJ4HkzcQJXOkQiFKy5/ZbfzED01SksbuWj5nFWc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dennis Zhou <dennis@kernel.org>,
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
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 2/2] locking: Add contended_release tracepoint
Date: Tue, 10 Mar 2026 17:49:39 +0000
Message-ID: <cb89caf58885858433711f0ed6238484f5f1a67f.1773164180.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773164180.git.d@ilvokhin.com>
References: <cover.1773164180.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m1pgf9879rk4nw9wo1is1dw667obmgce
X-Rspamd-Queue-Id: 885D41C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773165000-560196
X-HE-Meta: U2FsdGVkX1/qX+tYKLr+oIE2SBY5PW2UZ4zfwUpm8lOC0dsqkuYIqqUTnecRVLeM0pXb2L+5p4q9FK5fS4PI2YHAsva0QJUD0xp4Wt2O0JMS3FK2ShV/gOEMgOs2FyRCBz25bczSbqptX5mRH7HdAz0LElEeOEL3sf9Mik2FtOChqvZAQ5MnzUrfxb0YtSAhNBr16dDlXW6d3u/lXWtrby8roPHMlxQKa4o2g6mhXmgeE8rIF3jbMNY/QmyYqNpO56Jn/Rsk8xrlIefLDubugtRE8QmrAeaQ4O3FISMNqoD3ZwQLEdAY9BLdtYn2bSSRKTfPd33WUemR8SODT0JZVn+Q0j+BHO2prPPE+/vcHJ+aAzEdT72juUr9CsE9NQEOx+xsKQLHeYXkCSvD7puBI+nd2Jg9bkbaFrOW2pis1xDzltoy2sb+ciX+h/etjAuWLrCWlzCda8EZFTf/BCpm4XuQcly1BxC+3KtxoaDJommica93oCxHvSvoX7ZV733GqrPntO1q/K4s+AQkeURvIdUnMmn9rVY9jTSfmxZnthfaxF4How7EuPk/KWvK1prKpH7xXg5lGkbMDTsUh4z96YepPaD77RfbeydJBBYjr8eG79iViMEitxMRCkG2OP9ZrlqHfiV1ZtVMmoFsMJQ/FF3ToLfTChCqFndcOkHkS69ftPpLENR4Y6ffsHljemcTvpY8J5RKTzXFRruC19vqTw80k1VkFthZGb55VYjDywgjXLfnPTJg00/EVvFixwFbliOYNDiZ1YGFPhMqDSZ5yRd6h/qzCo1yKY8YUJ3jXT74RLIWr3KmYvMpX0aixla1SC6B+2xN85nRIc0QeArYJ58frivwZUlKO0fKXIqM90FkbhKPQ43YwwnGcZ8cZpoP3WFE4ZfCGjeAjfTV5cnri9HmamxyC/O0EMEapXwq5yigFxc7wwVOxk9RXmnkAJxxhBu3QSUYpW4KNThpLBq
 WSQ8YRvR
 C6++YD7xw8BOTUlaK7mGr4sZVRub758/1630az817ng2fJNSLF6LXLbPiaHx6WbNt4rdFFHrFNmnWlv5uJ6Wzhi9cIZ6KXuXLzi1pFeVbEwC8HhppaUL6TN/SOhe/QPyfVa9hWZyq8vDVWWFrnZV9RUxvnNjRPycB5xxeXt6hxkqwwAMTN6IQPVgTMOjgkHVuCHGfkKo9qIOsh8bsFc51Ikzpfq4KsDh6DXqTxUvxT7F9yNpdpwvjLa1YPyHRsU5EyoMFQAnPAs20qyE3Rw3Gejl+/qzwhgGcI1SkSivbuDlHVU3KUJY4KwEsdjRoEyckEmi6ONE6QiUGePw=
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
RT-specific rwbase locks. Each call site fires only when there are
blocked waiters being woken, except percpu_up_write() which always wakes
via __wake_up().

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/trace/events/lock.h   | 17 +++++++++++++++++
 kernel/locking/mutex.c        |  1 +
 kernel/locking/percpu-rwsem.c |  3 +++
 kernel/locking/rtmutex.c      |  1 +
 kernel/locking/rwbase_rt.c    |  8 +++++++-
 kernel/locking/rwsem.c        |  9 +++++++--
 kernel/locking/semaphore.c    |  4 +++-
 7 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 8e89baa3775f..4f28e41977ec 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -138,6 +138,23 @@ TRACE_EVENT(contention_end,
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
index 427187ff02db..ff9d07f3e900 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -992,6 +992,7 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
 	if (waiter) {
 		next = waiter->task;
 
+		trace_contended_release(lock);
 		debug_mutex_wake_waiter(lock, waiter);
 		__clear_task_blocked_on(next, lock);
 		wake_q_add(&wake_q, next);
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index f3ee7a0d6047..1eee51766aaf 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -263,6 +263,8 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
+	trace_contended_release(sem);
+
 	/*
 	 * Signal the writer is done, no fast path yet.
 	 *
@@ -297,6 +299,7 @@ void __percpu_up_read(struct percpu_rw_semaphore *sem)
 	 * writer.
 	 */
 	smp_mb(); /* B matches C */
+	trace_contended_release(sem);
 	/*
 	 * In other words, if they see our decrement (presumably to
 	 * aggregate zero, as that is the only time it matters) they
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
index ba4cb74de064..cf7d8e75ad7b 100644
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


