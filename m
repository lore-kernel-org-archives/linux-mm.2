Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAD8D78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE56A6B00D7; Fri, 19 Dec 2025 10:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5116B00D9; Fri, 19 Dec 2025 10:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991D66B00DA; Fri, 19 Dec 2025 10:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82F7F6B00D7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C24458616
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:54 +0000 (UTC)
X-FDA: 84236651268.28.945B140
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C5BD1C000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4XEbFmNP;
	spf=pass (imf18.hostedemail.com: domain of 3pnNFaQUKCPMZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pnNFaQUKCPMZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYjsqxfCGUdwb9R0CPMsVyMDBMLSmyZIUW+BdfAkYXg=;
	b=iZaMwgnjbpaLO/xsK79Y8QIQ4BieOsVg6r9v0BS0yR43eKAxNJc3ecTDB5QY7+ItSF/0cp
	4qek23YNtv3/wnr2eS65k28IDYyCtW7bn1d2VGwhK2a5MRJOUJvFhduqtvz6V4QavfyWmX
	GCiDkW0TSKw9Wzyc7M9NjR/iMVbtKbQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4XEbFmNP;
	spf=pass (imf18.hostedemail.com: domain of 3pnNFaQUKCPMZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pnNFaQUKCPMZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159272; a=rsa-sha256;
	cv=none;
	b=S821opiGAlE+Vps0bW568s2WAwqLwOeteOLBBeugIz1XOztuBYu+CfbAeJfZtjwwLtsF9I
	MtsXbQtCSmAz/rYq96I/BUm+Irod4dLXdqmHctQanIMIiRFZ5KQlgFoAMhM92hYIQMNs+J
	N01WcEcZdh2PxMs/Ri8lc+sNkEnEPpQ=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64b735f514dso2250135a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159271; x=1766764071; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pYjsqxfCGUdwb9R0CPMsVyMDBMLSmyZIUW+BdfAkYXg=;
        b=4XEbFmNP5C+CEBbtbgl49ZqwuGmOTCt13Xz6Otfsaw59PdOLY/MpGTJqzsY3ny8VCo
         +lEZl0A5CX06o+Z2AYzUvY5cAlaSvKlskr9SALFM7R6h7sHPWTI++4XbJfQE5Uvgg0xi
         KbveHM4nIGWUcaB0TEJLGp0iDr10ByBn7mxWljy2Jj6AaiOTu3GRBLkQWbdBtCw25K2N
         XUppi1a53hPyUlyeMmCV4b1+iFOiPFYNUOpZ7c1ntjVCLG9jCzWRoGrshlZuIqA2S0s+
         4dHDtTfNXDMhwtGx8FQEdFXSB4pUa21MtBQHvnyJt3do5xaVNA3twNe8E/ezrGMqsr73
         th+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159271; x=1766764071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pYjsqxfCGUdwb9R0CPMsVyMDBMLSmyZIUW+BdfAkYXg=;
        b=jv5r3BMTlConA+WM1cN9upJLVePShkkXs8Tc7oqa0Ov/E7AmypbSJ14G2Pd2XSJ9gn
         U0M6z6ORpCPh34MG8YqInb9bqilKpez/lv4DD1kbFasTL0YCsaPE5q4ULtkVqPOf00rd
         2lG0MjrR2rvJ4iSyGg7+JXETKArMdA78lYE9MHo6h7NANza7WH+0n/RxAlV3tFQwDV60
         HlwZryJm6hCfgzrSFp4T3cRVJajGwzxkOcpr87AmXxsyRBwMaaibkCicZ6CwDOWbbLmh
         ymIjd6xngl9P8qsUuDTou0cPCKiELwMTUr9PYb+orZ8RyI4guHHIE2FvSIjVVVSwgfJ+
         RX9A==
X-Forwarded-Encrypted: i=1; AJvYcCVVp7PX9kFVJNY/jwPSXv6qj+X9YRouXiGWU9abBL/XHNxXdt/s4K7AjqcEc9FuMg9jwLhUG0e4sw==@kvack.org
X-Gm-Message-State: AOJu0YzRtgJtxm4qclgBekCHjtHqo5WCi4lZSDLpQYru6Rk/nHhfJmlA
	J5JLUIDLvlep8KoZ6GniGUyubGSiprcqC2Qe4bkHhaNJx48Mx+yZqqhFJYLjct4guKba9JdT+hk
	3DQ==
X-Google-Smtp-Source: AGHT+IH50SsNKvpYAKux5hehIPpujFsHOPTNm68EIkXovJU4XQLA0skj9Fd0PVWDMx+FLd3BLjEJFVwhBw==
X-Received: from edbbx3.prod.google.com ([2002:a05:6402:b43:b0:64b:82c9:1597])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5108:b0:649:b4d8:7946
 with SMTP id 4fb4d7f45d1cf-64b8edb3335mr2443042a12.23.1766159270510; Fri, 19
 Dec 2025 07:47:50 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:25 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-37-elver@google.com>
Subject: [PATCH v5 36/36] sched: Enable context analysis for core.c and fair.c
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org, 
	Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C5BD1C000B
X-Stat-Signature: xati435kttw51d6fdbnfiq5mgourje1e
X-HE-Tag: 1766159272-50840
X-HE-Meta: U2FsdGVkX19fRx7WRmoQaMNAJS5OrvNkMYT56MY05+R/fwZItihtkaady8iHY+3iVJq+7oyojzUEyYA6SPnyBmxEmsJT7MOKk3r1TE2NvQOc/3aWALECtE0TdIysYTmfaur8bUs0x3/9aTkQdRXVQLmOjygX9vqWExaGH10HTYC1khxb2YtyqpLnUjmbCMbxrI2VN7eawRX+scoa2h3ocP2NS2UuUim+IHLnT1Z33AAynSIAdmp9W0Nk4g5e/GgVuh85QOkQjYNfOQMtKIXlLljj7/j2MB1EDwYExkPuVphIFf+Fmwyf0QznP6VLy7i9VwwUEnUxrx5n9ceheCcdHpCVcSBij2MTsrw6krk0ohtsZCR8hQPdkTkn9emEJmQ2N46GSDR3UjNVg8QZ5ezglqwf0GMu+XNdBjbSpcJqO4FnhQnFolMcsPqVpHw70I0tuWtII2UT0heLFisv+r/x3M6CjzcZpkLFP1J4amHPxJZauwaZ7i2VGp2gDMFZP7sioWvOMroYl9CcXc9Ag0wnT2oHsdLs+Ul5uNqp7FqqwshMJPB9DzopowFzOK+wjYOAg919Xf7MCeEnKbaEKCmk4nnWsYExd4Y4ZFIQj7c6kYyaFe9f6mnBHB15YVdweubHlQ/vpOQ5JkJx55h3+H25PNNl6d118eHfReZvTyt2hA4mvTDWlyUXGvpbfZg/wHDpRrV4+UIqoMEy5bpAokNFI4inxu+/gzF+f3yrEVJlOQJ+aE+SaEPVfhxlC+gVOFtG4dwzG1j/t/utZ8i1jmNjB3h9eq0MLQvJNYb/RFZ2oA531Oe/eRy6Mpo42zu1sfl+e2qfrATG54KwuyjQZFDWTUUMYOhWD89du/5BXskTMlY9PyGddjvvu54Ctppf2BrzmOJk5/ukCm765ecSeWkaVjG8r1zm3dVaNWq0ty5ATeD1cYqTnDer0nqfWHL9JANwGEF8VrK3pl/xFz4YlsK
 C9iyqvwH
 KN4ML9/N47Eyf/2s39UnYrm8anm31HlujTNC6yoAbVA5MoKqvk+KDMMwvqU2oxSzlrrJlh8wSIHCb2PAJBzysXBfKWGG6e6rYr9VoA30hx5NOF/T05zmnIjXth3gA3k0sZjsgVy+PU7WHOeKBRJaT4Xd5f9owS9rmpmo8ZBd47BcBgN5Xleiv/72IJXAzeN9O63uLSaNq67yG5+iXWTHRd1ut424hHbeFSGTGcqkZSqLv9+e0QdR/3Bp+D5NdlAJ+jTEPnbJBRNZbEoB+utZguxzaEBbxUwoj2gP1nAkL18f530ujA9C+wg9tYI2d4EcjNhDpwCDWieMH1fGuDydO4FRVoyAk+ijYcvyrdCu0kQXurIj8AkCqbnqZAM5E3w0ce9QUwJhdi+YAAaXj+MERTDVybtlq4XDx/2b24q2DvmMHzseDAgkn+CZuGCW59jnPiyTzYT8qWF90SQMHfYpn36/BWTZZCkAxoKfIEfCrFJhCp03XyKP9XP7mtsZJhFjykbB9HQNAOfQY46G/kNRyjNtElPvLCfNoSwonpu6LN+DfN/6Jk2VYdu6IzuQNqs4zelHtkVED5NxEnXm/vg6QOeahxaq7kmP6ij/JkYR0PVJvAUAbOvZwS8GMHk4XvcLDcxTe1aEtpzTuJxazoAuxlYYLKpr/TEh2t0rLZRHY8NZ0HjuC439hnsKR4Xgtf53lTuF3VjPnEX1srgslfOn+FpE8S8i1g1LXu0wxttUKOdtb6lTKNYC1jfI0St6p0+fx1MzxjvlhXaPhWeLWWkuBfei1yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This demonstrates a larger conversion to use Clang's context
analysis. The benefit is additional static checking of locking rules,
along with better documentation.

Notably, kernel/sched contains sufficiently complex synchronization
patterns, and application to core.c & fair.c demonstrates that the
latest Clang version has become powerful enough to start applying this
to more complex subsystems (with some modest annotations and changes).

Signed-off-by: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
v5:
* Rename "context guard" -> "context lock".
* Use new cleanup.h helpers to properly support scoped lock guards.

v4:
* Rename capability -> context analysis.

v3:
* New patch.
---
 include/linux/sched.h                    |   6 +-
 include/linux/sched/signal.h             |   4 +-
 include/linux/sched/task.h               |   6 +-
 include/linux/sched/wake_q.h             |   3 +
 kernel/sched/Makefile                    |   3 +
 kernel/sched/core.c                      |  89 +++++++++++-----
 kernel/sched/fair.c                      |   7 +-
 kernel/sched/sched.h                     | 126 ++++++++++++++++-------
 scripts/context-analysis-suppression.txt |   1 +
 9 files changed, 177 insertions(+), 68 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d395f2810fac..c4022647282e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2094,9 +2094,9 @@ static inline int _cond_resched(void)
 	_cond_resched();			\
 })
 
-extern int __cond_resched_lock(spinlock_t *lock);
-extern int __cond_resched_rwlock_read(rwlock_t *lock);
-extern int __cond_resched_rwlock_write(rwlock_t *lock);
+extern int __cond_resched_lock(spinlock_t *lock) __must_hold(lock);
+extern int __cond_resched_rwlock_read(rwlock_t *lock) __must_hold_shared(lock);
+extern int __cond_resched_rwlock_write(rwlock_t *lock) __must_hold(lock);
 
 #define MIGHT_RESCHED_RCU_SHIFT		8
 #define MIGHT_RESCHED_PREEMPT_MASK	((1U << MIGHT_RESCHED_RCU_SHIFT) - 1)
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index a63f65aa5bdd..a22248aebcf9 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -738,10 +738,12 @@ static inline int thread_group_empty(struct task_struct *p)
 		(thread_group_leader(p) && !thread_group_empty(p))
 
 extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
-						unsigned long *flags);
+						unsigned long *flags)
+	__acquires(&task->sighand->siglock);
 
 static inline void unlock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
+	__releases(&task->sighand->siglock)
 {
 	spin_unlock_irqrestore(&task->sighand->siglock, *flags);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 525aa2a632b2..41ed884cffc9 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -214,15 +214,19 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * write_lock_irq(&tasklist_lock), neither inside nor outside.
  */
 static inline void task_lock(struct task_struct *p)
+	__acquires(&p->alloc_lock)
 {
 	spin_lock(&p->alloc_lock);
 }
 
 static inline void task_unlock(struct task_struct *p)
+	__releases(&p->alloc_lock)
 {
 	spin_unlock(&p->alloc_lock);
 }
 
-DEFINE_GUARD(task_lock, struct task_struct *, task_lock(_T), task_unlock(_T))
+DEFINE_LOCK_GUARD_1(task_lock, struct task_struct, task_lock(_T->lock), task_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(task_lock, __acquires(&_T->alloc_lock), __releases(&(*(struct task_struct **)_T)->alloc_lock))
+#define class_task_lock_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(task_lock, _T)
 
 #endif /* _LINUX_SCHED_TASK_H */
diff --git a/include/linux/sched/wake_q.h b/include/linux/sched/wake_q.h
index 0f28b4623ad4..765bbc3d54be 100644
--- a/include/linux/sched/wake_q.h
+++ b/include/linux/sched/wake_q.h
@@ -66,6 +66,7 @@ extern void wake_up_q(struct wake_q_head *head);
 /* Spin unlock helpers to unlock and call wake_up_q with preempt disabled */
 static inline
 void raw_spin_unlock_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock(lock);
@@ -77,6 +78,7 @@ void raw_spin_unlock_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
 
 static inline
 void raw_spin_unlock_irq_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock_irq(lock);
@@ -89,6 +91,7 @@ void raw_spin_unlock_irq_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
 static inline
 void raw_spin_unlock_irqrestore_wake(raw_spinlock_t *lock, unsigned long flags,
 				     struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock_irqrestore(lock, flags);
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 8ae86371ddcd..b1f1a367034f 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS_core.o := y
+CONTEXT_ANALYSIS_fair.o := y
+
 # The compilers are complaining about unused variables inside an if(0) scope
 # block. This is daft, shut them up.
 ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 41ba0be16911..ae543ee91272 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -396,6 +396,8 @@ static atomic_t sched_core_count;
 static struct cpumask sched_core_mask;
 
 static void sched_core_lock(int cpu, unsigned long *flags)
+	__context_unsafe(/* acquires multiple */)
+	__acquires(&runqueues.__lock) /* overapproximation */
 {
 	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
 	int t, i = 0;
@@ -406,6 +408,8 @@ static void sched_core_lock(int cpu, unsigned long *flags)
 }
 
 static void sched_core_unlock(int cpu, unsigned long *flags)
+	__context_unsafe(/* releases multiple */)
+	__releases(&runqueues.__lock) /* overapproximation */
 {
 	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
 	int t;
@@ -630,6 +634,7 @@ EXPORT_SYMBOL(__trace_set_current_state);
  */
 
 void raw_spin_rq_lock_nested(struct rq *rq, int subclass)
+	__context_unsafe()
 {
 	raw_spinlock_t *lock;
 
@@ -655,6 +660,7 @@ void raw_spin_rq_lock_nested(struct rq *rq, int subclass)
 }
 
 bool raw_spin_rq_trylock(struct rq *rq)
+	__context_unsafe()
 {
 	raw_spinlock_t *lock;
 	bool ret;
@@ -696,15 +702,16 @@ void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	raw_spin_rq_lock(rq1);
 	if (__rq_lockp(rq1) != __rq_lockp(rq2))
 		raw_spin_rq_lock_nested(rq2, SINGLE_DEPTH_NESTING);
+	else
+		__acquire_ctx_lock(__rq_lockp(rq2)); /* fake acquire */
 
 	double_rq_clock_clear_update(rq1, rq2);
 }
 
 /*
- * __task_rq_lock - lock the rq @p resides on.
+ * ___task_rq_lock - lock the rq @p resides on.
  */
-struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock)
+struct rq *___task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 {
 	struct rq *rq;
 
@@ -727,9 +734,7 @@ struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 /*
  * task_rq_lock - lock p->pi_lock and lock the rq @p resides on.
  */
-struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock)
+struct rq *_task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 {
 	struct rq *rq;
 
@@ -2431,6 +2436,7 @@ static inline bool is_cpu_allowed(struct task_struct *p, int cpu)
  */
 static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 				   struct task_struct *p, int new_cpu)
+	__must_hold(__rq_lockp(rq))
 {
 	lockdep_assert_rq_held(rq);
 
@@ -2477,6 +2483,7 @@ struct set_affinity_pending {
  */
 static struct rq *__migrate_task(struct rq *rq, struct rq_flags *rf,
 				 struct task_struct *p, int dest_cpu)
+	__must_hold(__rq_lockp(rq))
 {
 	/* Affinity changed (again). */
 	if (!is_cpu_allowed(p, dest_cpu))
@@ -2513,6 +2520,12 @@ static int migration_cpu_stop(void *data)
 	 */
 	flush_smp_call_function_queue();
 
+	/*
+	 * We may change the underlying rq, but the locks held will
+	 * appropriately be "transferred" when switching.
+	 */
+	context_unsafe_alias(rq);
+
 	raw_spin_lock(&p->pi_lock);
 	rq_lock(rq, &rf);
 
@@ -2624,6 +2637,8 @@ int push_cpu_stop(void *arg)
 	if (!lowest_rq)
 		goto out_unlock;
 
+	lockdep_assert_rq_held(lowest_rq);
+
 	// XXX validate p is still the highest prio task
 	if (task_rq(p) == rq) {
 		move_queued_task_locked(rq, lowest_rq, p);
@@ -2834,8 +2849,7 @@ void release_user_cpus_ptr(struct task_struct *p)
  */
 static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flags *rf,
 			    int dest_cpu, unsigned int flags)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(__rq_lockp(rq), &p->pi_lock)
 {
 	struct set_affinity_pending my_pending = { }, *pending = NULL;
 	bool stop_pending, complete = false;
@@ -2990,8 +3004,7 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 					 struct affinity_context *ctx,
 					 struct rq *rq,
 					 struct rq_flags *rf)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(__rq_lockp(rq), &p->pi_lock)
 {
 	const struct cpumask *cpu_allowed_mask = task_cpu_possible_mask(p);
 	const struct cpumask *cpu_valid_mask = cpu_active_mask;
@@ -4273,29 +4286,30 @@ static bool __task_needs_rq_lock(struct task_struct *p)
  */
 int task_call_func(struct task_struct *p, task_call_f func, void *arg)
 {
-	struct rq *rq = NULL;
 	struct rq_flags rf;
 	int ret;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 
-	if (__task_needs_rq_lock(p))
-		rq = __task_rq_lock(p, &rf);
+	if (__task_needs_rq_lock(p)) {
+		struct rq *rq = __task_rq_lock(p, &rf);
 
-	/*
-	 * At this point the task is pinned; either:
-	 *  - blocked and we're holding off wakeups	 (pi->lock)
-	 *  - woken, and we're holding off enqueue	 (rq->lock)
-	 *  - queued, and we're holding off schedule	 (rq->lock)
-	 *  - running, and we're holding off de-schedule (rq->lock)
-	 *
-	 * The called function (@func) can use: task_curr(), p->on_rq and
-	 * p->__state to differentiate between these states.
-	 */
-	ret = func(p, arg);
+		/*
+		 * At this point the task is pinned; either:
+		 *  - blocked and we're holding off wakeups	 (pi->lock)
+		 *  - woken, and we're holding off enqueue	 (rq->lock)
+		 *  - queued, and we're holding off schedule	 (rq->lock)
+		 *  - running, and we're holding off de-schedule (rq->lock)
+		 *
+		 * The called function (@func) can use: task_curr(), p->on_rq and
+		 * p->__state to differentiate between these states.
+		 */
+		ret = func(p, arg);
 
-	if (rq)
 		__task_rq_unlock(rq, p, &rf);
+	} else {
+		ret = func(p, arg);
+	}
 
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
@@ -4968,6 +4982,8 @@ void balance_callbacks(struct rq *rq, struct balance_callback *head)
 
 static inline void
 prepare_lock_switch(struct rq *rq, struct task_struct *next, struct rq_flags *rf)
+	__releases(__rq_lockp(rq))
+	__acquires(__rq_lockp(this_rq()))
 {
 	/*
 	 * Since the runqueue lock will be released by the next
@@ -4981,9 +4997,15 @@ prepare_lock_switch(struct rq *rq, struct task_struct *next, struct rq_flags *rf
 	/* this is a valid case when another task releases the spinlock */
 	rq_lockp(rq)->owner = next;
 #endif
+	/*
+	 * Model the rq reference switcheroo.
+	 */
+	__release(__rq_lockp(rq));
+	__acquire(__rq_lockp(this_rq()));
 }
 
 static inline void finish_lock_switch(struct rq *rq)
+	__releases(__rq_lockp(rq))
 {
 	/*
 	 * If we are tracking spinlock dependencies then we have to
@@ -5039,6 +5061,7 @@ static inline void kmap_local_sched_in(void)
 static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
+	__must_hold(__rq_lockp(rq))
 {
 	kcov_prepare_switch(prev);
 	sched_info_switch(rq, prev, next);
@@ -5069,7 +5092,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * because prev may have moved to another CPU.
  */
 static struct rq *finish_task_switch(struct task_struct *prev)
-	__releases(rq->lock)
+	__releases(__rq_lockp(this_rq()))
 {
 	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
@@ -5165,7 +5188,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
  * @prev: the thread we just switched away from.
  */
 asmlinkage __visible void schedule_tail(struct task_struct *prev)
-	__releases(rq->lock)
+	__releases(__rq_lockp(this_rq()))
 {
 	/*
 	 * New tasks start with FORK_PREEMPT_COUNT, see there and
@@ -5197,6 +5220,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 static __always_inline struct rq *
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next, struct rq_flags *rf)
+	__releases(__rq_lockp(rq))
 {
 	prepare_task_switch(rq, prev, next);
 
@@ -5865,6 +5889,7 @@ static void prev_balance(struct rq *rq, struct task_struct *prev,
  */
 static inline struct task_struct *
 __pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -5965,6 +5990,7 @@ static void queue_core_balance(struct rq *rq);
 
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	struct task_struct *next, *p, *max;
 	const struct cpumask *smt_mask;
@@ -6273,6 +6299,7 @@ static bool steal_cookie_task(int cpu, struct sched_domain *sd)
 }
 
 static void sched_core_balance(struct rq *rq)
+	__must_hold(__rq_lockp(rq))
 {
 	struct sched_domain *sd;
 	int cpu = cpu_of(rq);
@@ -6418,6 +6445,7 @@ static inline void sched_core_cpu_dying(unsigned int cpu) {}
 
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	return __pick_next_task(rq, prev, rf);
 }
@@ -8043,6 +8071,12 @@ static int __balance_push_cpu_stop(void *arg)
 	int cpu;
 
 	scoped_guard (raw_spinlock_irq, &p->pi_lock) {
+		/*
+		 * We may change the underlying rq, but the locks held will
+		 * appropriately be "transferred" when switching.
+		 */
+		context_unsafe_alias(rq);
+
 		cpu = select_fallback_rq(rq->cpu, p);
 
 		rq_lock(rq, &rf);
@@ -8066,6 +8100,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, push_work);
  * effective when the hotplug motion is down.
  */
 static void balance_push(struct rq *rq)
+	__must_hold(__rq_lockp(rq))
 {
 	struct task_struct *push_task = rq->curr;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da46c3164537..d0c929ecdb6a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2860,6 +2860,7 @@ static int preferred_group_nid(struct task_struct *p, int nid)
 }
 
 static void task_numa_placement(struct task_struct *p)
+	__context_unsafe(/* conditional locking */)
 {
 	int seq, nid, max_nid = NUMA_NO_NODE;
 	unsigned long max_faults = 0;
@@ -4781,7 +4782,8 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
-static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf);
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
+	__must_hold(__rq_lockp(this_rq));
 
 static inline unsigned long task_util(struct task_struct *p)
 {
@@ -6188,6 +6190,7 @@ static bool distribute_cfs_runtime(struct cfs_bandwidth *cfs_b)
  * used to track this state.
  */
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun, unsigned long flags)
+	__must_hold(&cfs_b->lock)
 {
 	int throttled;
 
@@ -8919,6 +8922,7 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
 
 struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	struct sched_entity *se;
 	struct task_struct *p;
@@ -12858,6 +12862,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
  *   > 0 - success, new (fair) tasks present
  */
 static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
+	__must_hold(__rq_lockp(this_rq))
 {
 	unsigned long next_balance = jiffies + HZ;
 	int this_cpu = this_rq->cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d30cca6870f5..25d2ff265227 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1358,8 +1358,13 @@ static inline u32 sched_rng(void)
 	return prandom_u32_state(this_cpu_ptr(&sched_rnd_state));
 }
 
+static __always_inline struct rq *__this_rq(void)
+{
+	return this_cpu_ptr(&runqueues);
+}
+
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		this_cpu_ptr(&runqueues)
+#define this_rq()		__this_rq()
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
@@ -1404,6 +1409,7 @@ static inline raw_spinlock_t *rq_lockp(struct rq *rq)
 }
 
 static inline raw_spinlock_t *__rq_lockp(struct rq *rq)
+	__returns_ctx_lock(rq_lockp(rq)) /* alias them */
 {
 	if (rq->core_enabled)
 		return &rq->core->__lock;
@@ -1503,6 +1509,7 @@ static inline raw_spinlock_t *rq_lockp(struct rq *rq)
 }
 
 static inline raw_spinlock_t *__rq_lockp(struct rq *rq)
+	__returns_ctx_lock(rq_lockp(rq)) /* alias them */
 {
 	return &rq->__lock;
 }
@@ -1545,32 +1552,42 @@ static inline bool rt_group_sched_enabled(void)
 #endif /* !CONFIG_RT_GROUP_SCHED */
 
 static inline void lockdep_assert_rq_held(struct rq *rq)
+	__assumes_ctx_lock(__rq_lockp(rq))
 {
 	lockdep_assert_held(__rq_lockp(rq));
 }
 
-extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass);
-extern bool raw_spin_rq_trylock(struct rq *rq);
-extern void raw_spin_rq_unlock(struct rq *rq);
+extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass)
+	__acquires(__rq_lockp(rq));
+
+extern bool raw_spin_rq_trylock(struct rq *rq)
+	__cond_acquires(true, __rq_lockp(rq));
+
+extern void raw_spin_rq_unlock(struct rq *rq)
+	__releases(__rq_lockp(rq));
 
 static inline void raw_spin_rq_lock(struct rq *rq)
+	__acquires(__rq_lockp(rq))
 {
 	raw_spin_rq_lock_nested(rq, 0);
 }
 
 static inline void raw_spin_rq_lock_irq(struct rq *rq)
+	__acquires(__rq_lockp(rq))
 {
 	local_irq_disable();
 	raw_spin_rq_lock(rq);
 }
 
 static inline void raw_spin_rq_unlock_irq(struct rq *rq)
+	__releases(__rq_lockp(rq))
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_enable();
 }
 
 static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
+	__acquires(__rq_lockp(rq))
 {
 	unsigned long flags;
 
@@ -1581,6 +1598,7 @@ static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
 }
 
 static inline void raw_spin_rq_unlock_irqrestore(struct rq *rq, unsigned long flags)
+	__releases(__rq_lockp(rq))
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_restore(flags);
@@ -1829,18 +1847,16 @@ static inline void rq_repin_lock(struct rq *rq, struct rq_flags *rf)
 	rq->clock_update_flags |= rf->clock_update_flags;
 }
 
-extern
-struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock);
+#define __task_rq_lock(...) __acquire_ret(___task_rq_lock(__VA_ARGS__), __rq_lockp(__ret))
+extern struct rq *___task_rq_lock(struct task_struct *p, struct rq_flags *rf) __acquires_ret;
 
-extern
-struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock);
+#define task_rq_lock(...) __acquire_ret(_task_rq_lock(__VA_ARGS__), __rq_lockp(__ret))
+extern struct rq *_task_rq_lock(struct task_struct *p, struct rq_flags *rf)
+	__acquires(&p->pi_lock) __acquires_ret;
 
 static inline void
 __task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(__rq_lockp(rq))
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1848,8 +1864,7 @@ __task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
 
 static inline void
 task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(__rq_lockp(rq), &p->pi_lock)
 {
 	__task_rq_unlock(rq, p, rf);
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf->flags);
@@ -1859,6 +1874,8 @@ DEFINE_LOCK_GUARD_1(task_rq_lock, struct task_struct,
 		    _T->rq = task_rq_lock(_T->lock, &_T->rf),
 		    task_rq_unlock(_T->rq, _T->lock, &_T->rf),
 		    struct rq *rq; struct rq_flags rf)
+DECLARE_LOCK_GUARD_1_ATTRS(task_rq_lock, __acquires(_T->pi_lock), __releases((*(struct task_struct **)_T)->pi_lock))
+#define class_task_rq_lock_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(task_rq_lock, _T)
 
 DEFINE_LOCK_GUARD_1(__task_rq_lock, struct task_struct,
 		    _T->rq = __task_rq_lock(_T->lock, &_T->rf),
@@ -1866,42 +1883,42 @@ DEFINE_LOCK_GUARD_1(__task_rq_lock, struct task_struct,
 		    struct rq *rq; struct rq_flags rf)
 
 static inline void rq_lock_irqsave(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(__rq_lockp(rq))
 {
 	raw_spin_rq_lock_irqsave(rq, rf->flags);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock_irq(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(__rq_lockp(rq))
 {
 	raw_spin_rq_lock_irq(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(__rq_lockp(rq))
 {
 	raw_spin_rq_lock(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_unlock_irqrestore(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(__rq_lockp(rq))
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irqrestore(rq, rf->flags);
 }
 
 static inline void rq_unlock_irq(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(__rq_lockp(rq))
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irq(rq);
 }
 
 static inline void rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(__rq_lockp(rq))
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1912,18 +1929,27 @@ DEFINE_LOCK_GUARD_1(rq_lock, struct rq,
 		    rq_unlock(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock, __acquires(__rq_lockp(_T)), __releases(__rq_lockp(*(struct rq **)_T)));
+#define class_rq_lock_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rq_lock, _T)
+
 DEFINE_LOCK_GUARD_1(rq_lock_irq, struct rq,
 		    rq_lock_irq(_T->lock, &_T->rf),
 		    rq_unlock_irq(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock_irq, __acquires(__rq_lockp(_T)), __releases(__rq_lockp(*(struct rq **)_T)));
+#define class_rq_lock_irq_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rq_lock_irq, _T)
+
 DEFINE_LOCK_GUARD_1(rq_lock_irqsave, struct rq,
 		    rq_lock_irqsave(_T->lock, &_T->rf),
 		    rq_unlock_irqrestore(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
-static inline struct rq *this_rq_lock_irq(struct rq_flags *rf)
-	__acquires(rq->lock)
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock_irqsave, __acquires(__rq_lockp(_T)), __releases(__rq_lockp(*(struct rq **)_T)));
+#define class_rq_lock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rq_lock_irqsave, _T)
+
+#define this_rq_lock_irq(...) __acquire_ret(_this_rq_lock_irq(__VA_ARGS__), __rq_lockp(__ret))
+static inline struct rq *_this_rq_lock_irq(struct rq_flags *rf) __acquires_ret
 {
 	struct rq *rq;
 
@@ -3050,8 +3076,20 @@ static inline void double_rq_clock_clear_update(struct rq *rq1, struct rq *rq2)
 #define DEFINE_LOCK_GUARD_2(name, type, _lock, _unlock, ...)				\
 __DEFINE_UNLOCK_GUARD(name, type, _unlock, type *lock2; __VA_ARGS__)			\
 static inline class_##name##_t class_##name##_constructor(type *lock, type *lock2)	\
+	__no_context_analysis								\
 { class_##name##_t _t = { .lock = lock, .lock2 = lock2 }, *_T = &_t;			\
   _lock; return _t; }
+#define DECLARE_LOCK_GUARD_2_ATTRS(_name, _lock, _unlock1, _unlock2)			\
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T1,	\
+							    lock_##_name##_t *_T2) _lock; \
+static __always_inline void __class_##_name##_cleanup_ctx1(class_##_name##_t **_T1)	\
+	__no_context_analysis _unlock1 { }						\
+static __always_inline void __class_##_name##_cleanup_ctx2(class_##_name##_t **_T2)	\
+	__no_context_analysis _unlock2 { }
+#define WITH_LOCK_GUARD_2_ATTRS(_name, _T1, _T2)					\
+	class_##_name##_constructor(_T1, _T2),						\
+	*__UNIQUE_ID(unlock1) __cleanup(__class_##_name##_cleanup_ctx1) = (void *)(_T1),\
+	*__UNIQUE_ID(unlock2) __cleanup(__class_##_name##_cleanup_ctx2) = (void *)(_T2)
 
 static inline bool rq_order_less(struct rq *rq1, struct rq *rq2)
 {
@@ -3079,7 +3117,8 @@ static inline bool rq_order_less(struct rq *rq1, struct rq *rq2)
 	return rq1->cpu < rq2->cpu;
 }
 
-extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
+extern void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(__rq_lockp(rq1), __rq_lockp(rq2));
 
 #ifdef CONFIG_PREEMPTION
 
@@ -3092,9 +3131,8 @@ extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
  * also adds more overhead and therefore may reduce throughput.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__must_hold(__rq_lockp(this_rq))
+	__acquires(__rq_lockp(busiest))
 {
 	raw_spin_rq_unlock(this_rq);
 	double_rq_lock(this_rq, busiest);
@@ -3111,12 +3149,16 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * regardless of entry order into the function.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__must_hold(__rq_lockp(this_rq))
+	__acquires(__rq_lockp(busiest))
 {
-	if (__rq_lockp(this_rq) == __rq_lockp(busiest) ||
-	    likely(raw_spin_rq_trylock(busiest))) {
+	if (__rq_lockp(this_rq) == __rq_lockp(busiest)) {
+		__acquire(__rq_lockp(busiest)); /* already held */
+		double_rq_clock_clear_update(this_rq, busiest);
+		return 0;
+	}
+
+	if (likely(raw_spin_rq_trylock(busiest))) {
 		double_rq_clock_clear_update(this_rq, busiest);
 		return 0;
 	}
@@ -3139,6 +3181,8 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
  */
 static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__must_hold(__rq_lockp(this_rq))
+	__acquires(__rq_lockp(busiest))
 {
 	lockdep_assert_irqs_disabled();
 
@@ -3146,14 +3190,17 @@ static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 }
 
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
+	__releases(__rq_lockp(busiest))
 {
 	if (__rq_lockp(this_rq) != __rq_lockp(busiest))
 		raw_spin_rq_unlock(busiest);
+	else
+		__release(__rq_lockp(busiest)); /* fake release */
 	lock_set_subclass(&__rq_lockp(this_rq)->dep_map, 0, _RET_IP_);
 }
 
 static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3163,6 +3210,7 @@ static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3172,6 +3220,7 @@ static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3181,6 +3230,7 @@ static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
 }
 
 static inline void double_raw_unlock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__releases(l1, l2)
 {
 	raw_spin_unlock(l1);
 	raw_spin_unlock(l2);
@@ -3190,6 +3240,13 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
 		    double_raw_lock(_T->lock, _T->lock2),
 		    double_raw_unlock(_T->lock, _T->lock2))
 
+DECLARE_LOCK_GUARD_2_ATTRS(double_raw_spinlock,
+			   __acquires(_T1, _T2),
+			   __releases(*(raw_spinlock_t **)_T1),
+			   __releases(*(raw_spinlock_t **)_T2));
+#define class_double_raw_spinlock_constructor(_T1, _T2) \
+	WITH_LOCK_GUARD_2_ATTRS(double_raw_spinlock, _T1, _T2)
+
 /*
  * double_rq_unlock - safely unlock two runqueues
  *
@@ -3197,13 +3254,12 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
  * you need to do so manually after calling.
  */
 static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
+	__releases(__rq_lockp(rq1), __rq_lockp(rq2))
 {
 	if (__rq_lockp(rq1) != __rq_lockp(rq2))
 		raw_spin_rq_unlock(rq2);
 	else
-		__release(rq2->lock);
+		__release(__rq_lockp(rq2)); /* fake release */
 	raw_spin_rq_unlock(rq1);
 }
 
diff --git a/scripts/context-analysis-suppression.txt b/scripts/context-analysis-suppression.txt
index df25c3d07a5b..fd8951d06706 100644
--- a/scripts/context-analysis-suppression.txt
+++ b/scripts/context-analysis-suppression.txt
@@ -26,6 +26,7 @@ src:*include/linux/refcount.h=emit
 src:*include/linux/rhashtable.h=emit
 src:*include/linux/rwlock*.h=emit
 src:*include/linux/rwsem.h=emit
+src:*include/linux/sched*=emit
 src:*include/linux/seqlock*.h=emit
 src:*include/linux/spinlock*.h=emit
 src:*include/linux/srcu*.h=emit
-- 
2.52.0.322.g1dd061c0dc-goog


