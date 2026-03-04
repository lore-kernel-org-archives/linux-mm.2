Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B70AEF9011
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216F86B0096; Wed,  4 Mar 2026 11:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB296B0099; Wed,  4 Mar 2026 11:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2BC6B0098; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5C766B0096
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A369140320
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:47 +0000 (UTC)
X-FDA: 84508984854.01.113CA86
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id DC8F0160007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=X3TlCjHO;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3yRfNXX1+f1+LW15V0yGBwftW08pQA9GRuFVJ3tzvg=;
	b=1kp+ydLEowoRVkBHvd/bhLd9bWWq59OfnFj0e2pqpEQnUxXyK3oOu3ivg5NlSZQQf4hgjE
	iBznZ990RTX/cmIIVav14saZtqJqNsqgVdK++KZWEzcPKvywHV4Xt79lXOQVrb5EK/oCEF
	da+z7xxKJNPTWpAcAe4cjhHunO3V328=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=X3TlCjHO;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643406; a=rsa-sha256;
	cv=none;
	b=BN8pEXz86tFyisn5HncHnCVfFOsHrjKdIwZAS002jLKlaSmpYn0I/hGdfCtjrMiS4WX5BZ
	lNFsKiGZ4qY6u60akz7HtLs7qx1yD2JD/rT7JvTxtCoHTuP5RL4ymbFyPxcUGLallAi6LX
	diaMLG51RT5GoGVoLXUo3sEKSLDr4vE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 45993B31BE;
	Wed, 04 Mar 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772643404;
	bh=O3yRfNXX1+f1+LW15V0yGBwftW08pQA9GRuFVJ3tzvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3TlCjHOsSseO+2N7d1/0TOOCk2wyunsg9PR1h+de8WTIZv1RH7Mkc1VJx5uZDoFS
	 d4oQJ0cSWvIlmN53vvg4LkZCrvbRvupa6DyK7X/cd3VKR3xSrMQQfVmw4eC6Z33CBg
	 dx4CGpln3mqj8r/39TWNRRcRvU0sGT49U+bQHCL8=
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
Subject: [PATCH RFC 3/3] locking: Wire up contended_release tracepoint
Date: Wed,  4 Mar 2026 16:56:17 +0000
Message-ID: <8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772642407.git.d@ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC8F0160007
X-Rspamd-Server: rspam07
X-Stat-Signature: 7g16ptzn3794h458i6t5f18y19i4j8c7
X-Rspam-User: 
X-HE-Tag: 1772643405-424799
X-HE-Meta: U2FsdGVkX1/lIG0cuq+j4TsAPfCvXTZWrb5qpjJ/IZFoJssRMiZI9S92fX5UrNIUNVakiyc81Pm1/7V9GHc4gwPX4P4TTnAFpLVMDhbYzIM5z2vXR9dnojxGbUWqt8c8ITlQOYwX7o9bXpb7at96pGgITrlNmY4EGnK3ObzOXbJXS2RpWI1nEY85tRdCG+5AGLYK5SQzPuE3ctRQOmE5ZSRkBdfKovDQxpnlb3aWcohBOL2WOqickjz90ffDMXxVTOPRPtrYKMG2zD1hYU/mibaOkuKjEzjdI1lOcKrNIw8gagTSGW5ln7+Mv9Ad3cQlH1yKqSU0c7HtkwctQBV2u/fnNj2z7huU90+xm+TUtNR57g9knVMQ50b2PQ6QXHmKv518HTfO/pa6BRla6GknaF64NNgNniUpAms8amhkDJYpGub8CS+kn46ftRz3gr5tPoagO7pIE/I76iMySYUp10+Mx4LrbP8HMvS2GB7zcIOKAl6kPPjiB+xGThvWriEs7OsTT1ihyLqfzxjNM06SQAZe/KpHypIO6Ss/YY0zrneGcVnzgCFZtYkZLQRlw0MOccWOoKbxycdxHJmj39PLbIo/+nDMCq3OJRorgldajkX46NXWNqlEtwaMUA1G1OaeEtdlup4Jm9YR25pCWyyOiznuHk0Za6k3nga7F5UGzZxJrr/UKtsp3bEZwbOhLYBRgE8Q24Gng/GknMy3+S7rSDXhDgXYkwDhhIgaBfm+OL7qWiCW9QNDLcA7FT7/jnoKcmVBp8CMSBwyBA1QZgeXcvUcCft/NBqojvHhVADXn5VdYulQb9fc+/M+m5tzL+55WmfW+7sz3FZb6KGP1fdcr5gIZMTDLUn8DHcFCmXNx5QEYmVQZMl4y/gCW1XeLbJLzCJaLTyiP3rNMrCZih6+v55vehW2FUYgnlgUaxQ8JStSVEqgRSi00ntm6ZPBwFZ7OqXBxxBED5bTkIHIp9c
 pCSlZN8p
 malP//sfQpG2wdG1D7VgZSGJBNC98fBCKqq9rdWFh1jn5is9CCIzecK8Rp63xmDm66rQGTy9acNEaT+eYbNXqhZBETyMjcY8c1s5p7KtNBKXl4WC6Ph1zQreb0BfHZXs0VuRUsPgCXz7tVuBBn/OiSnA5xH5cF85ofpnSm3JLEo56U+aSnSTuRs8xE1sSQJ5fm7gamsiO3sYIqvEzyp4VF/fC4C2gnq7YdJdNb/sq1rLMyrbVZcaryFwQ7LSWYTzlevc2xzcMgjQrOJYmRiJs0XUx3wRpCJkOF4yK/M7iaDbAvHjUx4xMHTeHOuaWokVKlJtyAM0nkk4modo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add trace_contended_release() calls to the slowpath unlock paths of
sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
RT-specific rwbase locks. Each call site fires only when there are
blocked waiters being woken, except percpu_up_write() which always wakes
via __wake_up().

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 kernel/locking/mutex.c        | 1 +
 kernel/locking/percpu-rwsem.c | 3 +++
 kernel/locking/rtmutex.c      | 1 +
 kernel/locking/rwbase_rt.c    | 8 +++++++-
 kernel/locking/rwsem.c        | 9 +++++++--
 kernel/locking/semaphore.c    | 4 +++-
 6 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index c867f6c15530..54ca045987a2 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -970,6 +970,7 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
 
 		next = waiter->task;
 
+		trace_contended_release(lock);
 		debug_mutex_wake_waiter(lock, waiter);
 		__clear_task_blocked_on(next, lock);
 		wake_q_add(&wake_q, next);
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index 4190635458da..0f2e8e63d252 100644
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
@@ -297,6 +299,7 @@ void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem)
 	 * writer.
 	 */
 	smp_mb(); /* B matches C */
+	trace_contended_release(sem);
 	/*
 	 * In other words, if they see our decrement (presumably to
 	 * aggregate zero, as that is the only time it matters) they
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index c80902eacd79..e0873f0ed982 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1457,6 +1457,7 @@ static void __sched rt_mutex_slowunlock(struct rt_mutex_base *lock)
 		raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	}
 
+	trace_contended_release(lock);
 	/*
 	 * The wakeup next waiter path does not suffer from the above
 	 * race. See the comments there.
diff --git a/kernel/locking/rwbase_rt.c b/kernel/locking/rwbase_rt.c
index 9f4322c07486..42f3658c0059 100644
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
@@ -204,6 +206,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (rt_mutex_has_waiters(rtm))
+		trace_contended_release(rwb);
 	__rwbase_write_unlock(rwb, WRITER_BIAS, flags);
 }
 
@@ -213,6 +217,8 @@ static inline void rwbase_write_downgrade(struct rwbase_rt *rwb)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
+	if (rt_mutex_has_waiters(rtm))
+		trace_contended_release(rwb);
 	/* Release it and account current as reader */
 	__rwbase_write_unlock(rwb, WRITER_BIAS - 1, flags);
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 24df4d98f7d2..4e61dc0bb045 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1360,6 +1360,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 	if (unlikely((tmp & (RWSEM_LOCK_MASK|RWSEM_FLAG_WAITERS)) ==
 		      RWSEM_FLAG_WAITERS)) {
 		clear_nonspinnable(sem);
+		trace_contended_release(sem);
 		rwsem_wake(sem);
 	}
 	preempt_enable();
@@ -1383,8 +1384,10 @@ static inline void __up_write(struct rw_semaphore *sem)
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
 
@@ -1407,8 +1410,10 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
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
index 3ef032e22f7e..3cef5ba88f7e 100644
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
2.47.3


