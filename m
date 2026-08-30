Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFF3C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FBB6B0095; Sun, 30 Aug 2026 03:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB066B0096; Sun, 30 Aug 2026 03:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA116B0098; Sun, 30 Aug 2026 03:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B74C26B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:30:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B13F6C023E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:30:10 +0000 (UTC)
X-FDA: 85157112180.27.4369582
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06407140006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:30:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HMON2q++;
	spf=pass (imf09.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788075009;
	b=2Y/mfcuBvkgevxNMgJqgFcjVh29hNWffNbwV0OHNXnlWVRjxCrYEUCGEx7NuTtP3HBEMwj
	H5uKmI42Rzsw1M9ylQuuiNZoWJEJpsE0VJ+NwceZssn78Nq7w/NHEvrKa/H37ZWkxobiZW
	vJPYbTqxxSfo5HrixXIJajf0RJIIk+c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HMON2q++;
	spf=pass (imf09.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788075009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XnUZn6wf9UUIpF2RonxD+yTbLf5BGIQEYs8B6KvVijM=;
	b=5QxYenkPxpWsy2N03uBx7Z0pCEhP+CDTY6eCqiV+uAv+L4ZKvowgGIrsX1HpoRD6XzQ6Kg
	ijVqO9026QSWdjP2tg+Usx0F45fqLZYjF/bN0McjzyZ95QmWmxx+RWGaLITh6N6cF92xpm
	s/PJBJa/Rp4BYdQyhcm1elVJhIMsuvQ=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso2531618a91.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788075008; x=1788679808; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XnUZn6wf9UUIpF2RonxD+yTbLf5BGIQEYs8B6KvVijM=;
        b=HMON2q++eHtwNjAG/xKP4VxWTuXFh3MAaU6UBiU4B6XshLcYG/iAG4WH6APAB0hz8u
         RthTzgawZdCIyDJLSFmuZUZK5gZSIU4UqjgWVhnJuktjDs90MiB1wvyjq1bAVRKG7qdK
         8B7QiNSsFL8sjhN2+Aj8uyKuvKwpSoBYJ8cOqqSXzTEaBAN4wY1tOuotL3027lFGAH+j
         zza8xAh4F7U3VVp3h1HRd46IdLy7lAyvUg2EP5RTDBg57AGuXLsH66f9QYnj6RTGN95f
         zBqQPnaEkE9D581fWv6cElU9eUSOEwk/XcO/rSpDCre3CATRQv1KFqe8dvp0ugOWupNs
         uMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788075008; x=1788679808;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XnUZn6wf9UUIpF2RonxD+yTbLf5BGIQEYs8B6KvVijM=;
        b=MYJB1cjqAmOxruBmqO3bnMN8IsnwTPwQfnOXfhezZKqOQfb1BeLLhpvLOKxR4y3Yua
         FJA0oBvAHQlTpWC57n74WQ9tDnt22Mgs+4OUoSmkgPayifA1mVoWOmsB3THd2PrQycCs
         rypNYuxl5Lcqsmqp02smHj4ocryqiyCdMERslMTn9NXM4G1a4L4eBlGMlJ0tJjzsZpDg
         6roLQf1T8Lgy0Or1s/zmF6ATdsufqCQ4uJQCBnswpeJBNJyjUdx8r/gG+SEkUkzdga25
         Qxh5t2wl7QP/VM8qpEh/Zto1yAmyS2VKaUqM4xgBucK9bOKhYuv0+/ptcq7iA8gkzEAF
         snag==
X-Forwarded-Encrypted: i=1; AKwUvByKcJ6KXrwJyz1KAsUIC9o5dybVj9ju+9+pccauzv6DhLdOMlkwwYXcu7JgKLQZPJ8LObdyptl5Tg==@kvack.org
X-Gm-Message-State: AFuF++nHi5Ytt/laLmKwgd6BYQ2Z1wnHtj1y2Vl9vdkWb1QMFjF16hbv
	yOFtUsQcgVwUimtkWXtnefy72UxsNU8tsGNRO0yiRX4X6zv4+LUqwgMX
X-Gm-Gg: AYBFou3EWtF34N3aqKTL4b5nhPTwZy98uDjcV3XlAsVtcODIb1aZvNiWMpyOoylIcbv
	TM+7M0oWWqve8HofGbD/Y5IxofbXAcVZyPaSGBabEWf8yJ8zaJQIqW9ugXp8ShtFpaw55Uwv7n8
	7BQCpoI0DCV35CP3ir03jJW0lY5QSVyVYg7wTBig9U4g3QG+Kyce8AaipX/DGGEay0G8NVKiQVG
	cWfWsQN55aCT3Ueaz+oEYgJvizeMXLUFN1bxv+VgmfaWrHC2PIraTFvCwE6gDI4jnFG08jJ0ZRC
	PhnUlL2vhJ9VXbfNzzSphXm8sRqfgdezVrjGyo2POjv3aA6ylZXxGvvbVNMQEItZcLHtXwWj3lt
	01Pq29fxFmkYJSPBOzFSizjJQ2q89JdwweE03VbvOlEdBewMxu8/TP5SLoGG29Kqt0sg1TW9vud
	EV6XFqAz9208p/+a7wEpqLwepjaN2Q9Ghy9G/pmH8aiQePNmp3XxaPdCUIM2FkL1hWmaWRmRdy9
	pGDwBvMfdZGRQ/nig==
X-Received: by 2002:a17:90b:3c44:b0:398:dcef:c040 with SMTP id 98e67ed59e1d1-398dcefc24amr634359a91.19.1788075007671;
        Sun, 30 Aug 2026 00:30:07 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992e05sm15110527a91.15.2026.08.30.00.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 00:30:06 -0700 (PDT)
Date: Sun, 30 Aug 2026 16:30:00 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Chen Yu <yu.c.chen@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] sched/cache: Fix use-after-free of the mm replaced by exec
Message-ID: <apPb-Dr4nPYuHQOK@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: 9sq8hrsnpx9ye8pbcehsn8yti4x96w8j
X-Rspamd-Queue-Id: 06407140006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788075008-105538
X-HE-Meta: U2FsdGVkX18NEJPQyrOwRnnW4aoYkbJcFiyQ6FA+XuPgaWat5v+slZWBqr6rhpbDjZ6En06oN3bml5W85eBJWLtScPQQdys8xRdmcg2kaS5uz2/ma0qUt/K62iGqx1k8YzTFe5SgX7ZvSIOnsZTr8B8CjD1zXc12n0/hO/TZa4iEBaPpN6NQ4hc/QKLkW24R2Ol02J1DVcWQZe3tq6s+RkU99BPQGTmziozpR1cOcXbigggX8tBbLbLdSdLa9It299olNv2jAUpcmLXrV78c3S1jby5rswoJnutwGZrnved/IzTu8zeWaHlMN5AWHz9yaUTUJ/PSJgFVZJOC2swdZHmbCyo5UFPzCwiQvzzG7lbwXPtR2pTCvKx3cj8L2oylPa4QL3h91PWu0B872uMA81XuVOdIvT0rZ/gwplfnJY5t0dtc0lMhsCfGy07Wkn4cDeATShZ6IyyLrguNKkR9+x9nnaELoPNTMLDTycWcNwhh9ZPOl41g1CL1Y2CtJHh1w/CUBHl0kFLp8iKwXfqRAF3wpdbqqEuAwjvx/xdBKC3zLwsCdLflXl56KKOjBHsCE4K8fbKbcjGbgUNR89nWueYGMoUSCLHEM9e3P9W6p9HHmyXa4kATHEn2S6SENnoznMXiQcLKneOCI9+DDRGxWvwiA6jHrIN1lAaAH5moCm3hR0TEbt1ybl8INscAP6g2OlCf8Gu8svFv8QnREOg5+8Xpu7ti/3qWB+0myiG/LWnnIyzj8asQQORnZ7FkIvTUqbQ8VvOCkdYbh5mEvAeap/aTILEoc3urDhgWWYCm3MbVrMOQzuqd0EhFHmGBEAzGPwY0o99sVSenIcWTXkARGTOJnYbVmigvVgnpuBwUfubzzf2RU06pMI6N2K1EhEMgoObApVhdwLi9SAvlywVjy9v8q3lIJXd5YjykdTfp+rq7Dx1ahreLOzEK1ODk3vqpTckp/DBSuqWlEWDpDBp
 c17fAzbS
 VNc1ompTkVxxvbHW+trMHlno2LBJ0xNOZCthwYW/HmmaFXxIKO3VN5PGExPloi353Tvy0ez3oYmGwSJb7JFjhtmy2lhcRPnoE2iKLYKO+S2AtyPL+KdhiBsJuJ5n2lBQ9RUa4kypMkoE310mqU+JQ8KmujZowwk6aZeGQtKYKJR418hJxF058Ynip2jg5e/n5eG0IQi6q9+mQhx3W80cF65nzekl7Wuty4eE0lbj/rfjHHhUekZa5tD40EWfhMjLWMKHY2khcC+fuVHhrVAINt3Qvv2+0mliudZjgJ8mBJ9KSFB53icgSMn4aqmcfkMcEUVG4qOyJKQLGwfawtUpTAEqZPrYJA692OBvXsuWxUsSsL2IbIjZhVZ7TNXS4TmSPaon2HWJTtKq7Z4MnlNAeN2ycQ2TL1VL2JSQuWBKwn9+0Fui2ei9zfG2dk2BAOLT+Cp8MimHik+eYOBxiCFi5fN6bZHJFw8jLxJKI+sZPugbs5jieXiMmf8lxxhESCRYb8eHV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the waker cannot use the wakelist, ttwu_queue() takes the target rq
lock and goes down into update_curr(). If the target rq belongs to another
CPU, the task handed to account_mm_sched() is the one running on that CPU,
not the task being woken.

account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps that
mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to do
with the lifetime of the mm.

If that task happens to be in execve(), exec_mmap() points tsk->mm and
tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_exec()
drops the old one. free_bprm() does the same when exec fails. On the way
from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu() on
sc_stat.pcpu_sched and free_mm() returns the mm_struct.

Whoever already read the old pointer keeps using it. It adds to runtime in
the freed per-cpu area and reads sc_stat in the freed mm_struct. Depending
on the condition it also writes sc_stat.cpu. That is a use-after-free.

Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer access")
changed the remaining p->mm dereference to the local variable, and said the
active_mm reference keeps the structure allocated. That holds for the other
paths that detach an mm, since they take an mmgrab_lazy_tlb() reference.
exec reassigns active_mm to the new mm as well, so that reference is gone.
What is left is the mm_users reference in bprm->old_mm, and dropping it is
the free.

             CPU0                                CPU1

                                      write(pipe)
                                      try_to_wake_up()
                                        ttwu_queue()      // takes rq0 lock
                                          enqueue_task_fair()
                                            update_curr()
                                              update_se()
                                                account_mm_sched()
                                                  mm = rq0->curr->mm
                                                        // old mm
  execve()
    exec_mmap()                       // tsk->mm = new mm
    setup_new_exec()
      exec_mm_put_old()
        mmput() -> ... -> __mmdrop()
          mm_destroy_sched()          // free_percpu()
          free_mm()
                                                  read mm->sc_stat.epoch
                                                        // use-after-free

KASAN log:

  BUG: KASAN: slab-use-after-free in update_se+0xe6e/0xf70
  Read of size 8 at addr ffff8880093cad10 by task sc-direct-set/80
  ...
  Call Trace:
   update_se+0xe6e/0xf70
   update_curr.isra.0+0x28/0x380
   enqueue_task_fair+0xb58/0x3560
   enqueue_task+0x70/0x170
   ttwu_do_activate+0xeb/0x590
   try_to_wake_up+0x79b/0x14f0
   autoremove_wake_function+0x16/0x150
   __wake_up_common+0xed/0x160
   __wake_up_sync_key+0x36/0x50
   anon_pipe_write+0xa62/0x1830
   vfs_write+0xa4f/0xcf0
   ksys_write+0x17c/0x1c0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  Freed by task 1:
   kmem_cache_free+0xba/0x3b0
   setup_new_exec+0x2c4/0x3d0
   load_elf_binary+0x435/0x4740
   bprm_execve+0x6d2/0x1290
   do_execveat_common.isra.0+0x3a3/0x580
   __x64_sys_execve+0x8e/0xc0
  ...
  The buggy address belongs to the object at ffff8880093cab80
   which belongs to the cache mm_struct of size 1688
  The buggy address is located 400 bytes inside of
   freed 1688-byte region [ffff8880093cab80, ffff8880093cb218)

Take and release the exec'ing task's own rq lock once before the old mm is
dropped. The task account_mm_sched() looks at is that rq's curr, so it is
the same lock a reader holding the old pointer is on. If the task migrated
to another CPU in between, leaving that rq required the same lock, so a
reader there has already finished.

That reader only uses the mm inside the rq lock and never hands the
pointer out. Getting the lock means it is done, and whoever takes the lock
after that sees the new tsk->mm.

Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 fs/exec.c             |  1 +
 include/linux/sched.h |  4 ++++
 kernel/events/core.c  |  2 ++
 kernel/sched/fair.c   | 16 ++++++++++++++++
 4 files changed, 23 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e6..6194c38807980 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old_mm)
 {
 	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
 	mm_update_next_owner(old_mm);
+	sched_cache_exec_done();
 	mmput(old_mm);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cca..6ae31bffe049e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2415,10 +2415,14 @@ struct sched_cache_stat {
 	int cpu;
 } ____cacheline_aligned_in_smp;
 
+void sched_cache_exec_done(void);
+
 #else
 
 struct sched_cache_stat { };
 
+static inline void sched_cache_exec_done(void) { }
+
 #endif
 
 #ifndef MODULE
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6c8e38a31104..2f29cbccf03f1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
 	if (!cd)
 		return -ENOMEM;
 
+	/* @old, loaded by the try_cmpxchg() below, is only stable under RCU. */
+	guard(rcu)();
 	for (;;) {
 		if (try_cmpxchg(&task->perf_ctx_data, &old, cd)) {
 			if (old)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d881e530f891..fc63bfcbccc5b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1989,6 +1989,22 @@ void init_sched_mm(struct task_struct *p)
 	p->preferred_llc = -1;
 }
 
+/* exec() has switched to the new mm and is about to drop the old one. */
+void sched_cache_exec_done(void)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+
+	/*
+	 * account_mm_sched() dereferences rq->curr->mm under this rq's lock,
+	 * so a remote CPU can still be using the old mm. The lock cycle waits
+	 * for it, and the store to tsk->mm cannot be reordered past the
+	 * release, so later acquirers see the new mm.
+	 */
+	rq = this_rq_lock_irq(&rf);
+	rq_unlock_irq(rq, &rf);
+}
+
 #else /* CONFIG_SCHED_CACHE */
 
 static inline void account_mm_sched(struct rq *rq, struct task_struct *p,
-- 
2.43.0


