Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367B1606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pJyPe+7E
Received: by kanga.kvack.org (Postfix)
	id 59F276B05B8; Tue, 10 Nov 2026 13:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576BB6B05BE; Tue, 10 Nov 2026 13:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C5E6B05BF; Tue, 10 Nov 2026 13:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF086B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:38:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D12F160A28
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:38:36 +0000 (UTC)
X-FDA: 85420070232.01.917BCF5
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 557F8180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:38:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pJyPe+7E;
	spf=pass (imf06.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z5AvJ6uZvQp8gnIz/IJVqXh+TtL12nMC9fd5jn1sHhE=;
	b=XhRHAiruzeNr9OfPxN5HD8xTmUJmkBEHJeWKg+tydxKpswwRmFz5o+4hDbjVrTYRG8DwAR
	I3HZ60fFiyf+7CQD+zRMIrviR90LvX82P1PZf/+UNhadO683AIejHFDzBY6qY9FY8av9W2
	11JwsvEgf0imly+Enf+KGuQh2ZoFLhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335914;
	b=tWdFQR6QAwfFDAv5oAfNeSh3chVplqfYecRGGc03dN6kVd7XYrYk3ZpiIBRIOzSembmnxo
	lh3RdvDNyGC7lREMqRxykJ3ehmFlXVXRW4bTJFNxTkcIowqr5KZ+DSo6+Ryal6VzSQs7Ua
	E2WTp5aXkhu/yTjVv+y3S/RBZwC0ups=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pJyPe+7E;
	spf=pass (imf06.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so879350b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794335913; x=1794940713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z5AvJ6uZvQp8gnIz/IJVqXh+TtL12nMC9fd5jn1sHhE=;
        b=pJyPe+7EPiChI8YaR/H3lmPPbnlmoq0IdLXpz4W1jCvFVweBU+zxgYdr9+y1AaZnpj
         hhA0VPVwHNEZ1WWKO/lHfvYymvaT2iWZzfbMdi7GHhukSxLZ9ItmYLy2Zu7oH2MajRwM
         qKllUNzaB9lEGOLVfE9/qT4HCi7PsxWi0MKslVwgVFm3QuOLSmYKZFTkyaY5ETCuhCQk
         z7V4glpLrP3JCUgspXLODVE1CNKWzO6LhcN80SHrr9aXjOZcA2OFnJJDDEqirC2tmjiR
         l3m5rJab4Ae341SZCpnKX1KwWRuLWWAvrDz1Js1pUljFEIhimcIa7Xn76Lr5vic+sjhJ
         o5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335913; x=1794940713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z5AvJ6uZvQp8gnIz/IJVqXh+TtL12nMC9fd5jn1sHhE=;
        b=AQfIHoNERe/o02s882GGWI8J4uXDAtNtZ4bcOq8+1p4KALZgzCiiLNv23c2Mg56/hf
         hM+fpkDLh3f7fVRwpJpxQ9Jvd8UT2RYYYbKWaChYjr8kTmk6UzvSSUtOPLklY06cmAmF
         woKKsiYL2SQTIoiGh0UuuqAE48u0uEa0JBZkQp/X4gpFUYXROW/HkXU8sgBEFYinBYqv
         4Pb2DEfFbwlPXCzkLbjSL1ECbLpg9TUIqeAdOsbRjIiQvFa7K7wigEFq6RpszCFuOf/Z
         T7ZXnPsnv3KDmizQ3JtkNuB4p7GzH87qPC19BGm1LLgQ52mBdvmBWx/sAQn0WED3l4bb
         wppA==
X-Forwarded-Encrypted: i=1; AL+hErHFA9vu8km/iW4IyoAYPOyHPjTKS0A8Aq0W6HDkD350ebhLzShgwhDNa7OCpLILtKfJFbZK72AsmQ==@kvack.org
X-Gm-Message-State: APuU4Z/bAg6kk7znD4N8fDcHrheRQC7oKMOoTv8noPz7SbDsZHglowQn
	VX1OQ+UE9NxPG1hbLGMbye1y/T98d/9nC8KgDRKNnLkNhjPGr8UXknL4
X-Gm-Gg: AYBFou0z5nVeLCs6yonZozspG4lg/PBynAB7BT17Qw0gl3wU1e3YGNg0/ezGqweiJDo
	vVtIssWfcYx6yVEvSETTAceS0gEoJZcGCa6yHTxoYqerDQNxDmrA/SD0yPB0y5I+W7yD2txDEXI
	PwiEEu8f4KCVkxHg3kyk1GmvcCjqsBT2FzL4MY90ehNzxllFJmlvwsOM9jnRgQELiJ+0fZdN0pI
	Nep/NKm8BAwtEKGaC9ZMTLMMhtWfOHxMrYUlQtx3exhVGImvAVJ6kBHdRFL3WRJSqSK4NcHvFEW
	XnouTv/lF5xQmfwEj5Bsu9dOgfnLrgY/eZjCnKVKzcQVKxBHXxBSvbKTTyfEz+cgk/NksR7nfxJ
	Ai2p9v9QfwwgNCsh5+CVIb+ZhI9KlnC6zVFX/sDfDwBwzFmtzxpKh+vB7H0SbrXpmbdeeE1b/rX
	muWJr9ZkcDS/yZawhEJ+4E7YzzTisQmC7qe54ft1tXNTk2tGj8Nrc95VM3iKFcpJ2lPUcgJHlI8
	sXQPVr754cInk7bVrdrPIq8vjzvuevAlM8mG5edhp1rpItc9BRijf8s+x6LrG9jPicbqI1WASfI
	HABYuX3dePdBvuXSqGfH0+BwQl+G4FcXt905jfoOPBk44VuUeVpap4UpwN4SVfnXaS4UcVyvHTp
	/ww==
X-Received: by 2002:a05:6a00:4097:b0:8a0:3ed7:939e with SMTP id d2e1a72fcca58-8ba8764538fmr3337017b3a.60.1794335912831;
        Tue, 10 Nov 2026 10:38:32 -0800 (PST)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa963bd1sm1257490b3a.29.2026.11.10.10.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:38:32 -0800 (PST)
From: Weiming Shi <bestswngs@gmail.com>
To: Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org,
	co+cab19e2ebe4d535a@bugs.sh
Subject: [PATCH v3] sched/mmcid: Synchronize MM teardown with affinity updates
Date: Tue, 10 Nov 2026 10:38:08 -0800
Message-ID: <20261110183809.3308868-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pjic7inimjt86pxrih5j8swhupfpwdiu
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 557F8180004
X-Rspam-User: 
X-HE-Tag: 1794335914-569987
X-HE-Meta: U2FsdGVkX1+27viIoYcl+Ua/n9STMIqwW/w1oOR9N91HtcNWUDV6Dj7JNokHS/KDKa5uTt2i4izdwHdZRXpkOurQYQjiMNOYLhqq1qlSuqKckz7v8ntHAlNwb4S/Ircd1+W1KHKWJG5lDY0ufxqPmIIO4Ia8w5lhvGWG5Wt5DL//wIEKEvXLPdyk+f1a6zMFFTedGrm59B5GKF/YWtinxYgBLwk8y4ZIVim7TKCxFYAPrOCHtuuz2KhK8MU84KTU8fTRJ4s/YK/nEyp2ueCfSSOlIQnQQZUhKJ3aKBFlaMOz28bIi4yPFg3g0NG2mhC/s8PTsOFNw/2rzHdZPFSeHgOadMQR/+9OY71KNIvH2Yi3cMoQCrCkxesYKVy2FkMuc6sT2vxU3YG/0HKMF4V0x462h7gUdbiqrseWcehz1LpU5Ll4tD9+SC/bHGbmJia7p3jlYZW2qI2et9nFAbPeYxcVpjdB3eAORWAXN06Xfq5yLm7m0Yjd73HOcvtJjTYbx5xu3TYQ1q47KXk3qr86iGuLowW2l5C6RxvgQKq/FTVsFe7HljAFIx8TTyE+P6mEd/wF543WHqs7IWwQSVu2njl/EbEgBBN3tyi4XipDGCCah5vbmlhOW4+7O2pq/DKAGr1QK0jdixhgCeWdhpHTaEW1ld6GWaScgbUB4SJSEoDMfCxdYntqEM0PCXexLKD1HDq+oWXfLsY1WMFDAj7GA0EMNwcQ+1ejY7UydunTghNdkwAUdZjjc4RV24YNIKy9Emp5dyjbSYA6KXMDnpfPOpOuaGZ8uBgpgulIcR6sMX7a02ZkxNJ7eS4Xd/qP3xemLrkrd3gZ7bRlKrmJ+ltIdTjWCHSvgYPT4uZ4PUYEEc1vfHPQR6LVES8fz7UXX6mPEYZ3xukypGhe8XAv+bGfDakMwM4DigFf5TSBDfEcv6xEy0flJhBe750sUcgijfg/5/RzYqskDZXdccZGSwC
 Q+ijeaI/
 PsXUo/yqi2DO1f6eOLIqKP3WxOFE74WUxuAKsRdHo6EUmL/UGolha8i3ioqa03xQd9G23Ap5eYfrha22H37JXJuGD8ySk3D3oKpvxeY+8ptx+rrPKierclYYcIERKXEaMkMzGnHshGPO1ab3BQVkjiDdISOPu6fjxicv8WdzMxizFoHCI7O+LmOHcqDbzHDlZMTquJIMh4P3wWmRCRiuj6uzjpomtK5Xjz398+SfzIiItM4oLS/kDDJT5wQDCkYGRNOAd4sIgiGXjpHwW/+NjS3jH8nldKrX1djQt6PhgEGIy/j7Y42hwbP5rCjWRLLCdTyhn5b9gAu6FJes2Xa6s4uwWTDt1HPmYgjv2uKBRU/tZH2UCLEZ4I7GSwZikjtv60N+lOlZsMtrG7GqyXwhcZIWfwzbBxYwEkXDgGr8tunxVhDZvXDJGdPy3l5MCMHCwhV2k4Jdqd8A7JBeOeO1HJXDPBtn95eG5SpWOHHmSxZ7ygTCq0+qnLRWjpGqEa4qujx+fFVEAL4jH9YkJSLpjsAN+xvixIHATqnvYaZhTVRK84bVMBYeqB9jqaRo24svM06Y8g/CUnIbc5iMebE+MK3q4VZNGwmDInoOjnHBxhzsSr+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_cpus_allowed_common() passes a remote task's p->mm to
mm_update_cpus_allowed() while holding p->pi_lock, but that lock did not
stabilize the pointer against MM replacement. A same-owner
sched_setaffinity() caller can therefore retain the old pointer while exec
replaces and frees it. On architectures which shoot down rather than
refcount lazy TLB MMs, exit_mm() and kthread_unuse_mm() have the same
lifetime gap.

  BUG: KASAN: slab-use-after-free in set_cpus_allowed_common
  Read of size 4 at addr ffff888123155e4c by task poc/5132
  Call Trace:
   set_cpus_allowed_common (kernel/sched/core.c:10835)
   set_cpus_allowed_fair (kernel/sched/fair.c:10046)
   __set_cpus_allowed_ptr_locked (kernel/sched/core.c:3224)
   __set_cpus_allowed_ptr (kernel/sched/core.c:3258)
   __sched_setaffinity (kernel/sched/syscalls.c:1161)
   sched_setaffinity (kernel/sched/syscalls.c:1239)
   __x64_sys_sched_setaffinity (kernel/sched/syscalls.c:1275)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  Freed by task 5127:
   kmem_cache_free (mm/slub.c:6757)
   __mmput (kernel/fork.c:1204)
   mmput (kernel/fork.c:1215)
   setup_new_exec (fs/exec.c:1395)
   load_elf_binary (fs/binfmt_elf.c:1024)
   bprm_execve (fs/exec.c:1865)
   do_execveat_common.isra.0 (fs/exec.c:1963)
   __x64_sys_execveat (fs/exec.c:2047)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Affinity paths hold p->pi_lock across the p->mm load and its complete use.
After publishing a replacement or NULL p->mm, take and release that same
lock before dropping the old MM reference. For an updater that is already
using the old pointer, the ordering is:

  affinity updater                     MM teardown
  ----------------                     -----------
  raw_spin_lock(&p->pi_lock)
  mm = p->mm            /* old_mm */
                                       p->mm = new_mm or NULL
                                       raw_spin_lock(&p->pi_lock)
                                         /* waits */
  mm_update_cpus_allowed(mm, mask)
  raw_spin_unlock(&p->pi_lock) /* release */
                                         /* acquire succeeds */
                                       raw_spin_unlock(&p->pi_lock)
                                       ...
                                       mmput/mmdrop(old_mm)

The teardown-side acquire cannot complete until an updater ordered before
it has released p->pi_lock, so old_mm remains alive throughout that
updater's access. If teardown is ordered first instead, its unlock is a
release that orders the preceding p->mm store before a later updater's lock
acquire. The later updater therefore observes new_mm or NULL. An updater
that acquired the lock before the store but has not loaded p->mm yet is
still ordered before the teardown-side acquisition; it may observe either
pointer, but teardown waits for its complete use before dropping old_mm.

All runtime callers of set_cpus_allowed_common() hold p->pi_lock across
this access. The runqueue lock is not part of the p->mm lifetime ordering,
so the grace period only needs p->pi_lock. Place it after publication and
before the old reference drop in exec_mmap(), exit_mm(), and
kthread_unuse_mm(). The last two paths matter on architectures which shoot
down rather than refcount lazy TLB MMs.

This change was developed with assistance from an LLM.

Fixes: 7e019dcc470f ("sched: Improve cache locality of RSEQ concurrency IDs for intermittent workloads")
Cc: stable@vger.kernel.org
Reported-by: <co+cab19e2ebe4d535a@bugs.sh>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
Changes in v3:
- Document the p->pi_lock grace period and acquire/release ordering.
- Use p->pi_lock directly and cover exit_mm() and kthread_unuse_mm().
- Refresh the KASAN trace and provide a standalone reproducer in reply.

Changes in v2:
- Replace the schedule-in deferral with an exec-side runqueue-lock barrier.
- Keep affinity expansions synchronous, including expansions narrowed before
  the next schedule-in.
- Avoid changes to the MM-CID fork, exit, and scheduling state machine.

 fs/exec.c             | 1 +
 include/linux/sched.h | 2 ++
 kernel/exit.c         | 1 +
 kernel/kthread.c      | 1 +
 kernel/sched/core.c   | 9 +++++++++
 5 files changed, 14 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 8d2b14e1d455..3196421cb81d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -905,6 +905,7 @@ static int exec_mmap(struct linux_binprm *bprm)
 		BUG_ON(active_mm != old_mm);
 		/* Defer teardown to setup_new_exec(), outside the exec locks. */
 		bprm->old_mm = old_mm;
+		sched_mm_cid_mm_barrier(tsk);
 	} else {
 		mmdrop_lazy_tlb(active_mm);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..f88ab0445be3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2358,6 +2358,7 @@ static __always_inline void alloc_tag_restore(struct alloc_tag *tag, struct allo
 #ifdef CONFIG_SCHED_MM_CID
 void sched_mm_cid_before_execve(struct task_struct *t);
 void sched_mm_cid_after_execve(struct task_struct *t);
+void sched_mm_cid_mm_barrier(struct task_struct *t);
 void sched_mm_cid_exit(struct task_struct *t);
 static __always_inline int task_mm_cid(struct task_struct *t)
 {
@@ -2366,6 +2367,7 @@ static __always_inline int task_mm_cid(struct task_struct *t)
 #else
 static inline void sched_mm_cid_before_execve(struct task_struct *t) { }
 static inline void sched_mm_cid_after_execve(struct task_struct *t) { }
+static inline void sched_mm_cid_mm_barrier(struct task_struct *t) { }
 static inline void sched_mm_cid_exit(struct task_struct *t) { }
 static __always_inline int task_mm_cid(struct task_struct *t)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..5f9979d6216c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -582,6 +582,7 @@ static void exit_mm(void)
 	local_irq_enable();
 	task_unlock(current);
 	mmap_read_unlock(mm);
+	sched_mm_cid_mm_barrier(current);
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
diff --git a/kernel/kthread.c b/kernel/kthread.c
index fdb8fb07f40b..e7b393cfdcee 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1682,6 +1682,7 @@ void kthread_unuse_mm(struct mm_struct *mm)
 	enter_lazy_tlb(mm, tsk);
 	local_irq_enable();
 	task_unlock(tsk);
+	sched_mm_cid_mm_barrier(tsk);
 
 	mmdrop(mm);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 04b62c16fa8c..d78a174b5405 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11128,6 +11128,15 @@ void sched_mm_cid_after_execve(struct task_struct *t)
 		sched_mm_cid_fork(t);
 }
 
+/*
+ * Pair with set_cpus_allowed_common()'s p->pi_lock critical section. Call
+ * after publishing p->mm and before dropping the old MM reference.
+ */
+void sched_mm_cid_mm_barrier(struct task_struct *t)
+{
+	guard(raw_spinlock_irq)(&t->pi_lock);
+}
+
 static void mm_cid_work_fn(struct work_struct *work)
 {
 	struct mm_struct *mm = container_of(work, struct mm_struct, mm_cid.work);
-- 
2.56.0


