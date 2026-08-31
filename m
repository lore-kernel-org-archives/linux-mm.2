Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3534C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 21:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3517F6B008A; Mon, 31 Aug 2026 17:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBCC6B008C; Mon, 31 Aug 2026 17:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A46D6B0092; Mon, 31 Aug 2026 17:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D85936B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:33:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD7EE4027A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:33:12 +0000 (UTC)
X-FDA: 85162865424.16.516E03A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D999180006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:33:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iYNlve+T;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788211991;
	b=Qh0bDuDyFUbWIrC+Zili2BGohdp4umyLempWwZQY9Sbu7BSgzXnksOJJO3tU7OIxJsiqjU
	h4Quz0v1c99XPYgBx8wlgyhWJMYujBSGD0kOMFPllPjhwBOKuLyWv4yMKwxW+/iYQsj0KV
	JoXH5R+0gaA5C5rbLWmWV3UIpbU2czk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788211991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mWPvAnFlFBZe94+YEZeQLMoXJG2Yt4uB4t9syIQupx8=;
	b=240Lo+lrRIWKUnTnPSepAd5SbbobsgVoKajEKd6e97Z2FVXmZs8vrszrYWfl/rvMRbaOaN
	Mo/w8PrhJA8lqj2ABfL46hRhZKeETevXsAy46XmIxioLb8SfmxK3KOohKivwl4XHv9/GnL
	i0Yviw0tub5U6Zi3mqX5JHxpEr/J/6E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iYNlve+T;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84830c774a0so196602b3a.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788211990; x=1788816790; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWPvAnFlFBZe94+YEZeQLMoXJG2Yt4uB4t9syIQupx8=;
        b=iYNlve+T2Vq3CR+vc7VNCozzYqVl4O+ej8oeKqOsteiZLOaSh7XULjqs67Zfla8A5c
         S6fttM2U1cW2yV9AnwGjWcM6o94WfKDH8twj7XzJrdZazUAGyzduA45MexlLNVT+1Qca
         lpDf/WSUeL0Q1Vmu0dniwafuKz2fF+lFZNagdbheUqJdSFFdvP9Osycb5t0BGn5FazXf
         SRIFmxopSkTJqjOoE7lvVa/czU/PBQ15hYPqqYx2C6hMgBuidLfW18BX4S0qE3lyDsBz
         A+D7O3SwlpVBGhnIt8upTO6Ci9A+XQONDlkMxITlB257kM2itH2SpRhldV7trBRArBZh
         bJ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788211990; x=1788816790;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mWPvAnFlFBZe94+YEZeQLMoXJG2Yt4uB4t9syIQupx8=;
        b=nVJ1Cbv3dabNLmKsrvkWTYzI1sA36+cJw84I6TwUH0ZW8Xqk9gNjDcNRZELhg/RkEL
         ELaKYWlfnKajbNR5cScGwAsEEdQtNvkhT8uGAW2xdharKchDfIqXpiPZ3oHfG1koivPi
         FyCHq3jmQFxfRquoG/U7Ssg3HK1PohUXqkAhqy87gvTeUmqzRxoekOgpoX4BKYypy7GI
         vsx3x9QiL0fZBjLZVCkPxV5lPl/6H7WqmpbrY5XDrSUwMwgDHK2iThpCyPWKZ99Rj+0o
         ZRG5xp+l75/E9A/manEk3hKf3x3yuS5E3CuxhEWDq6+yDYGvpM2At9tF0lKJ/93OfoBk
         8HDA==
X-Forwarded-Encrypted: i=1; AHgh+RrAy/JeE6G6oF45X8Y/uunF8cPBLla944lJorqCZOeJWSV7wW3OxN6yV/KdKgOj4+ee1gkHe3aBOA==@kvack.org
X-Gm-Message-State: AFuF++kPyg+tEh2KFOENRyFrV1cm2PKlQN/UviWCSNOU0IcFL4dkAjUC
	BDZaFsdNeqmKb29mfi4W2E40TCeS2bikHXwxyKkYjWvDn+ALhvWLox+T
X-Gm-Gg: AR+sD10AlLuP1XLY7CjkmrZIT1dwHvZko6dMloRt3s9g1n/KKzoEZbxVsx0V6qczW2w
	3OGFZMd1i/AFsPdspiyMJdwG6+FeFFZpRRr4JSfv/pyqtFCiCzfbvQP9b+3Rjb3zd7idTpCy1lm
	Ktcm5m0+ne05hTQwgFK1uD84bEQ7YycS9pQZ6FqD35dyVMy9br992AwWD3o1SDupOMUWGMI9eBU
	+Hr7UEaurzIMN46tHajOC/DdBxGg+aTciUwrXjXc5IEkAGnAjl3juR/jhMyw/bqVBXjo9srbF/R
	qhPrtSjzYBs1ica3JGutC6VEJ499G6Zo0LqeQ65WGuFp0dUt5sAVw77YUb4scZSfswnXuoeFpiB
	32B9FuhyBTcF3q61YHQO3schbul7yghOZD2EYxyYZXkG4bOuBzUk/7GroGqYCKtO7he8ThqXNns
	EdclWU/WG5zyvqIfio+3aAUQebouMKnpb6KUjkj1prTGgZDjF4MQKsno56UFl9g8zHjlfyfoEQX
	P7CI8g=
X-Received: by 2002:a05:6a00:194a:b0:847:9267:2104 with SMTP id d2e1a72fcca58-85629a24448mr43230958b3a.12.1788211989656;
        Mon, 31 Aug 2026 14:33:09 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be5ca747csm77296b3a.5.2026.08.31.14.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 14:33:09 -0700 (PDT)
Date: Tue, 1 Sep 2026 06:33:02 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH v2] sched/cache: Fix use-after-free of the mm replaced by exec
Message-ID: <apXzDjnvOm9GfTLK@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0D999180006
X-Stat-Signature: us3jnzy8ueksqc1xxndddpintsdwin4d
X-HE-Tag: 1788211990-238461
X-HE-Meta: U2FsdGVkX18V1phBHRWqD0y3hLGg32qBtuCKaxzZqq1S6X47it0j85N2v9YGeBJcUzVtZkn9lJShgRC2o2pWfNOrrMR1ai1Hirz/YbSawF117uegHEI4khKc1UmvgAtdUqiajqNifxnbYWyMokhJhPy6nMkoyMdwe5jR8fLIWOSt9oDCGJ2PVPJvRqasrp/ggcItIm/s8sXtf1HLkwg/xDjxAdvC6RWkOabd23q38OaOChRdXhG3/qNbCX3vsXqsi5UTbkDGMnYdp8aRy7iTQI8l/mCcJ5GEByoCIOGvWjH9+Fu+yyG4Jukh0khi++1n7TvGQfc14DIsoAqsEkad7BjAI1OKRkNygvNlo8a5S0bgAl1KdRY4qvYSVZUZzoZCLbqivYnGqbzNY2Tp6hHo/N3P5UUyO+UGHxxduyTBVR/yHsDHPyUeurpN6BEPe55oyxDVXZknKqqK/pwkTkf8OSTidGxkvG8vQjdFwZgxPstBm9edZ/SqkoAQVaj/odXmsqhBjGierfdMvC7CGStqUS7D/LsnklOiy7ynpzANKyhf9NgsVPXEd8Idkw1N5Dfc4DjFdY2dCXcMbpklzzXPx5kV0vIgO+K5GsSFo2issxAlmnrfFlK1LpeRDmtJ5IYo46GsG31F0otb6K3MbNM1FIV7EIC8NRgboAixNLavPklCoxXH854GxcGogFSD+5ra9WsLwxfmSFNtqi2gU+tuf9wNqNF2wOkGDmegcMeeoF06Hk4tV1LQNMgFibkiSSOb1VmVryw7bZrKf2HKsJBcdVrV6+bHkaJm1fPyzde79+4fjFwyZyoS4kDGvTiXIQYCh8SKEKhMQ6MeBWu7qYH0DNQq6fWy5FaC8C9pIgw9RuyEm8+8nhIlIe8qz7BV/9Ug0EvQm1+ORMV9YiEB5TpFHxcNQ/8ni6HnUKE1CpkcrUNQ0wpQjcRoKLlxW73sd/bXoNQn50khyYq7jtx3hpV
 VHPzsEGP
 BvMF2uiyI0MTWMTREGPMY3uvbIBz19fNLT/yArBM0KJR0BQfA0fa8kZZA+9PepWqPGxD8N5bbcppY76I9+3IL1yGvYQT1bejlQRaZdz8KZQpfcBGeV/AOFJ19AUYrg0eaX0YmNFPB2B+JJSCK5wloZ7q7TQ1avmb2UEMpJeyU/h5yjsK8Y3rx24TiYDCYlWOiM9D/91WCXuS0FUZQcCUpBa1OStiOtK3IjqMuXjvjwTw+0uEC9MQrxp5blVLOHi7ktazv43UphuySEwqZLHNGl4zhe903RtkfiNf2LW1oDDgL1FeUPOJleqCJ+XqTjFGApbOoZD193PK+BOJCgF95HZsJQv47B4m+I5h8LI3zSioNeAKCLddlEg/fAg31ITMLzTiQHmRIbgMKt8W/ISlVLDTOktnw5h9qTCJsxUROb+YWa+/+t/LNGrOFrejJw9FVBtfgRf6LjLVT+m4z756mJPk9DPu1W65urxbDDk+UTDGAvoGjxVIgI05QAgBVHu1tcjeNRy06EhuKHDFs0Gt7EcYNWw==
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

Wait for an RCU grace period before the old mm is dropped.
account_mm_sched() runs with the rq lock held, so preemption is disabled
there and that section is an RCU read-side critical section. A reader that
already holds the old pointer finishes before the grace period ends, and
the store to tsk->mm precedes the wait, so a reader that starts afterwards
observes the new mm.

Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Drop an unrelated hunk that slipped into v1.
- Use synchronize_rcu() instead of cycling the rq lock, which covers
  every reader that runs with preemption disabled.
- v1: https://lore.kernel.org/all/apPb-Dr4nPYuHQOK@v4bel/
---
 fs/exec.c             |  1 +
 include/linux/sched.h |  4 ++++
 kernel/sched/fair.c   | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e65..6194c388079805 100644
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
index 8b3d47a325cca9..6ae31bffe049e3 100644
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf70..a3d0185717f7b1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1989,6 +1989,18 @@ void init_sched_mm(struct task_struct *p)
 	p->preferred_llc = -1;
 }
 
+/* exec() has switched to the new mm and is about to drop the old one. */
+void sched_cache_exec_done(void)
+{
+	/*
+	 * account_mm_sched() dereferences rq->curr->mm with the rq lock held,
+	 * so a remote CPU can still be using the old mm. That section runs with
+	 * preemption disabled and is therefore an RCU read-side critical
+	 * section, so wait for a grace period before the mm goes away.
+	 */
+	synchronize_rcu();
+}
+
 #else /* CONFIG_SCHED_CACHE */
 
 static inline void account_mm_sched(struct rq *rq, struct task_struct *p,
-- 
2.43.0


