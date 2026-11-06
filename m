Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA4C606D820
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pv71bd6D
Received: by kanga.kvack.org (Postfix)
	id E73836B05B3; Fri,  6 Nov 2026 07:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BE56B05B4; Fri,  6 Nov 2026 07:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61176B05B5; Fri,  6 Nov 2026 07:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF8966B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:09:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47CCD1A0DC3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:09:07 +0000 (UTC)
X-FDA: 85404573534.14.0E8026D
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79033C0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:09:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Pv71bd6D;
	spf=pass (imf10.hostedemail.com: domain of bestswngs@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793966945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m+gQu+r4AwSHyS6gBBODt+jdhh/qECS8DRB45/qqUhU=;
	b=YqggF3UVUP7R/HK2bT0A39IMde6IudAqaZQjMLl+ig32eroq8NzYf8L9E2mC6eAeBKM8a0
	JDmFjbGi/9Bw54ZE87B+uhlMIaScFy2qiehqQC40unW+qj/ujo8OsMgPVqGBVFFeB4pKsh
	0QpGi6mp+l0VZKlp+RgvYjjxeLdsuTs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793966945;
	b=jtVLDHMhxrDGxrOVmnhdV6K1/CuBXwxU5whx8ozJnsPUuADLljBvh2ycfk8I7/huYniQRS
	vIXY0LCT5GU2wesWQDQu+evgbUkVKJ2s+COO9pO2IQGlpAbEzZ0El2mHtyjcIgteTO8em3
	h9U97TvzYkQKgYqaFZSPMeazok9P8Nc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Pv71bd6D;
	spf=pass (imf10.hostedemail.com: domain of bestswngs@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1adbf62dd31so829059c88.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 04:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793966944; x=1794571744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+gQu+r4AwSHyS6gBBODt+jdhh/qECS8DRB45/qqUhU=;
        b=Pv71bd6DBRbkc1ilyXRnSgd22thCkXDgGQV06P5JQlCBfKCTptoiEkvSccULd77TS7
         z15t1HQqpOqVdudqkfR6OWvoJ+nqZu6dO6jI+DtLUjLUIeI8Nhf1wV08Mi6aNPxIQpF1
         7Z8qktIXQWv5IKsri9d2ctRXEHx/UKyEmyWlHj76bAYKcilhuayRZ04jvtb+Y8O0hF2l
         cGY7W9MnnA8uOBnC4WGdcU3tQkrsGFl24V/kEX/KcSXoUzt3AyqArZlXDF8tWnZ2Uaek
         4YZg1RtymT+QdI0MnTq3gvuWqLmYJ7yz7/LhwjWVwsD0hzmfsxuLImyMR/wAzpyejLrh
         pClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793966944; x=1794571744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+gQu+r4AwSHyS6gBBODt+jdhh/qECS8DRB45/qqUhU=;
        b=wScUg0aNAwodBgnoOy7qXna9ks2f4cqHlk/7rNr8bvkr3LNYdh6318lzRXnWrLGm0+
         hws6m9DNhS+LIhbcf9wubD+ap8GwzLS5DGW1jLR3Yg/JRJz3s8eke14hh5wW/pPkEBnM
         92TagVztsv7hUMNbhHVvqnMyCkih7F2c7H0UnG/KxY/PZM8MmqMBm3qfo+tph8Q0U/Ig
         gwJW2TCnwxbqZQixQxalPJz5B2aY1bKsKkOIAeIeDMUCA12IlPBuxo01fdL6nkTXAaSc
         yz2Z/K6uBeugY6PAIyEInL2BXKr117Kt7IcZS6KGiLHAPRaB2AVjEuGUoVhK5UbYu5f0
         gQYg==
X-Forwarded-Encrypted: i=1; AKwUvBxB35+6jfJCY3T7gJzp5QrraIw8/VeUKcyD0kzUJ7A4UZV8d3L62HdbP0HwN69+x8YsNCw17WJxSQ==@kvack.org
X-Gm-Message-State: APuU4Z/o6URLNftVzUBYO4RnMhPIkiM08Ty8np+P3x718t4DerrFdZwc
	XWQppKTGL3zq7G1qemNmTZcupU8fkGeiJA2aFbHupJNrSr9B5SSIHHUT
X-Gm-Gg: AYBFou099pvYjre6ULTa57YJ6Nep6JGt+XjrRW+LT8xNuFmfr8CbGw4+HiGcMwUiETW
	jdxun4m4NJE9K7LG/Ai4reo43RczU5/X9oZRNUtDJk0KfyY1gsbUuFDP7tL79NLYbMnWWZgu4Jd
	BZ3UysIcFORTqCN7R7My2eRU7i9Mgzeuy6wsxI9ePqPhGptWRLbPKUFZExdiVVCKFBKiPEZk7DD
	LlKwve6mG6bhsV2hayjJWEEDA4MnkUxYZC3WUZi2P1b0JhIXNc7S/Pet0ZtO3jCCiI12Oq8Rl1b
	ZpdzrYLf0d0qiLZKuIJBJ7LCR40QG1ffzXmsBDMtAb1mcDQA81cHcpR7qMpJKH/lzXV2EJLCv/t
	ZX9Wo525lRTsv9mH59pPO9e4EVU1Cgqh7rv47gVEQ5FazuEKoOjFigHEBHOGpnTLnGBcvqFrjRk
	5OYDnXD1qVSOFRfMgT1JS68jRku3SuNJ9Cs7s8zh46txi5ib5HDzUVbjfVd3IcG2m6fd273ucmh
	hNlXlUT1EL8+2r0dG6SFlHXz4HLrKNPkuBRmj4m1SfQT27V8zPDmYgHgiB26tBdGh1FG8q3fdld
	i/x283xyXqTWM0895ze8ZDr4wg8rkaqZrg+R+/cYNf2MczwV9jLUSWvhPaPAzVGOl0N5Aq/PHHP
	SKA==
X-Received: by 2002:a05:701b:4251:10b0:1ac:75b9:f82c with SMTP id a92af1059eb24-1b25d387600mr2939021c88.34.1793966943879;
        Fri, 06 Nov 2026 04:09:03 -0800 (PST)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e485ce2sm5289505c88.7.2026.11.06.04.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 04:09:03 -0800 (PST)
From: Weiming Shi <bestswngs@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] sched/mmcid: Defer affinity updates until schedule-in
Date: Fri,  6 Nov 2026 04:08:46 -0800
Message-ID: <20261106120846.2405936-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79033C0004
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ukiei5bd8ufojukccfbmd9dd1z86uzgu
X-Rspam-User: 
X-HE-Tag: 1793966945-267041
X-HE-Meta: U2FsdGVkX1//ycDkjrsVindlVgrpFPqHbPaQ287hpHpsm2jJOJ0RYDbILOmAV42yw7EFRUxHBK+jMRsW4MandoiMjePLlVOZ2SHSJQhx3O+jSKoRqyrqJ8M7g1SA139JwHGSg9f5M+ycwMX4qmuJ6JXuJXv+S5D+WUtLF5Q0sDksqC3T3gz1imux5BlKHw795yBr9hPQPQNjFUfvT3x8xjr7anSlSanI/6c3vgkaStx/of+/t2cMf4QCKKU9F3ogPQOdmTyJ9Un6E8FY1m6oS+IaMfMHXNsROtoPjwLCxFFwkrxqZb4dfwhT/Mu0NrrF2DkNWwVGdNG2VG3nxf8f65OPgs2aXDcD2f6CD3OUchiR1OX3/ZSro9XaaasLRsSDPHtTsiR5QfwBmzgtlohhS4M6/7IT3SvLUnGR9K8TQH1THLWB3jdaQaB0ySBAKHaKhbCtqH54D1xquTPR2OHRm7z43JG6Z/U7AMVozR37kW5GHnO+Z8zGG3qOplctyeds12ISTSlTmxYH8DLghVInIyE3KAu/R8/+YuASZjUqZaueShCCU+2VfPSTbU80rqkPyWiH+XP2EB3ZIOdm7hYhCccGx958vVQPPUx+Rrm+r48xI/CAhWn+mmQNIq8ljq/lcODHvKnAtJzqjHyH1gM7p2Y3OYvB7EWaYTQhiilOK7v6DRMeF7DHWAcd/6U0HCDq4T9itl7rTJi80AKi8wOhJSeRx3w7/zCFuRzsF7S4osly3OXenY3J61w6CH4w1G8ywTTebP9mKsZglsKj/ox+fmG+iEalrLO4Ntnq+9V5eUeKQCAps4dT35YMlF6cMVKLhw92/8vo3+MzNpavcTas8MopVRYkxhrPtJ6IHca1+VgqztenbINdxaWJoQn97zToH8QjPUQ1btKQJt37Nyi5BUCf2dWhHGQZNMPCtJ/2kxf4WosSf0zpYXqVOPurqG54QiJZu0LCVvbl8fmcH57
 9uO9/f1h
 EjCnmbUWE9I+3emJa86eIdzK55Fj2Spe1/U+Qw2/hBUzKhX9hK367bHMW5y9+AsEB2RX+frTBXd/CU0a2X9d+TcMC3Nd229X++TDvaLdPLnlh2hfx5BUrExn9MuaXEQJYPSYBj7uhbF2p9xWhLKmDgZTJUrqwbEzc4wa0UQ81smxYpKnVCTsts3I7buQMnR+4vsRnVpCY/PytipyPat2PhPvGyFev4gwmvOvRMRZegF86GacQg4q7dq0W5HEzCkPmeMoWGU6/rcQRggwP1GWpVoEeOC79JE/6uKrkzmKlWxmM+KzEwvtI9Zh1mKVm1b0Eb37KMq2kfCWppstSC0hPikS3UDLn0zaO6TkFO2lNH8dXaz+W1h+08uORIsuyhM48UKreoWuHdtv89n9qUNANqhgllghTtFHKIGcy7HfI8nQVL6EJ32aiZRQtxuYELw7dPx3C6+x6M+jU+xso0/DLVoHBodMQWZqNoNfjerxqMOQHeCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_cpus_allowed_common() passes a remote task's p->mm to
mm_update_cpus_allowed(), but the scheduler locks do not stabilize that
pointer. A same-owner sched_setaffinity() can race the target replacing and
freeing its old mm during exec. Current kernels are only incidentally
serialized by futex_exec_done() taking p->pi_lock when CONFIG_FUTEX=y;
valid CONFIG_FUTEX=n builds remain vulnerable.

  BUG: KASAN: slab-use-after-free in set_cpus_allowed_common (kernel/sched/core.c:10835 kernel/sched/core.c:2829)
  Read of size 4 at addr ffff88810991b04c by task poc/5127
  Call Trace:
   set_cpus_allowed_common (kernel/sched/core.c:10835 kernel/sched/core.c:2829)
   set_cpus_allowed_fair (kernel/sched/fair.c:10046)
   __set_cpus_allowed_ptr_locked (kernel/sched/core.c:2842 kernel/sched/core.c:3224)
   __set_cpus_allowed_ptr (kernel/sched/core.c:3258)
   __sched_setaffinity (kernel/sched/syscalls.c:1161)
   sched_setaffinity (kernel/sched/syscalls.c:1239)
   __x64_sys_sched_setaffinity (kernel/sched/syscalls.c:1275)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  Freed by task 5128:
   kmem_cache_free (mm/slub.c:6757)
   __mmput (kernel/fork.c:1204)
   mmput (kernel/fork.c:1215)
   setup_new_exec (fs/exec.c:1395)
   load_elf_binary (fs/binfmt_elf.c:1024)
   bprm_execve (fs/exec.c:1865)
   do_execveat_common.isra.0 (fs/exec.c:1963)
   __x64_sys_execve (fs/exec.c:2036)
   do_syscall_64 (arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  The buggy address belongs to the cache mm_struct of size 2776
  The buggy address is located 588 bytes inside of a freed object
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Defer the MM-CID allowed-mask update to the task's next schedule-in, where
its current mm is stable. Synchronize a forked task's shared mm before its
first run so a pending affinity expansion inherited from its parent is not
lost. Protect the fork-time mask snapshot with the task's runqueue lock
because the task is already published before sched_post_fork() runs.

This change was developed with assistance from an LLM.

Fixes: 7e019dcc470f ("sched: Improve cache locality of RSEQ concurrency IDs for intermittent workloads")
Cc: stable@vger.kernel.org
Reported-by: <co+cab19e2ebe4d535a@bugs.sh>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 include/linux/rseq_types.h |  3 +++
 kernel/fork.c              |  1 +
 kernel/sched/core.c        |  9 ++++-----
 kernel/sched/sched.h       | 12 ++++++++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/rseq_types.h b/include/linux/rseq_types.h
index 85739a63e85e..1479ed807add 100644
--- a/include/linux/rseq_types.h
+++ b/include/linux/rseq_types.h
@@ -140,12 +140,15 @@ struct rseq_data { };
 /**
  * struct sched_mm_cid - Storage for per task MM CID data
  * @active:	MM CID is active for the task
+ * @cpus_allowed_changed: Task affinity change needs propagation to the MM;
+ *			 protected by the task's runqueue lock
  * @cid:	The CID associated to the task either permanently or
  *		borrowed from the CPU
  * @node:	Queued in the per MM MMCID list
  */
 struct sched_mm_cid {
 	unsigned int		active;
+	bool			cpus_allowed_changed;
 	unsigned int		cid;
 	struct hlist_node	node;
 };
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b108ed37152..ed5947ae10fd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1013,6 +1013,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #ifdef CONFIG_SCHED_MM_CID
 	tsk->mm_cid.cid = MM_CID_UNSET;
 	tsk->mm_cid.active = 0;
+	tsk->mm_cid.cpus_allowed_changed = false;
 	INIT_HLIST_NODE(&tsk->mm_cid.node);
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 04b62c16fa8c..935c7efd349e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2811,8 +2811,6 @@ int push_cpu_stop(void *arg)
 	return 0;
 }
 
-static inline void mm_update_cpus_allowed(struct mm_struct *mm, const cpumask_t *affmask);
-
 /*
  * sched_class::set_cpus_allowed must do the below, but is not required to
  * actually call this function.
@@ -2826,7 +2824,7 @@ void set_cpus_allowed_common(struct task_struct *p, struct affinity_context *ctx
 
 	cpumask_copy(&p->cpus_mask, ctx->new_mask);
 	p->nr_cpus_allowed = cpumask_weight(ctx->new_mask);
-	mm_update_cpus_allowed(p->mm, ctx->new_mask);
+	mm_cid_notify_affinity_change(p);
 
 	/*
 	 * Swap in a new user_cpus_ptr if SCA_USER flag set
@@ -10826,7 +10824,7 @@ static bool mm_update_max_cids(struct mm_struct *mm)
 	return true;
 }
 
-static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
+void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
 {
 	struct cpumask *mm_allowed;
 	struct mm_mm_cid *mc;
@@ -10986,6 +10984,8 @@ static void sched_mm_cid_fork(struct task_struct *t)
 
 	if (!mm)
 		return;
+	scoped_guard(task_rq_lock, t)
+		mm_update_cpus_allowed(mm, &t->cpus_mask);
 
 	WARN_ON_ONCE(t->mm_cid.cid != MM_CID_UNSET);
 
@@ -11180,7 +11180,6 @@ void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
 	bitmap_zero(mm_cidmask(mm), num_possible_cpus());
 }
 #else /* CONFIG_SCHED_MM_CID */
-static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk) { }
 static inline void sched_mm_cid_fork(struct task_struct *t) { }
 #endif /* !CONFIG_SCHED_MM_CID */
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a..6be52141068b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3964,6 +3964,13 @@ extern const char *preempt_modes[];
 
 #ifdef CONFIG_SCHED_MM_CID
 
+void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk);
+
+static inline void mm_cid_notify_affinity_change(struct task_struct *p)
+{
+	p->mm_cid.cpus_allowed_changed = true;
+}
+
 static __always_inline bool cid_on_cpu(unsigned int cid)
 {
 	return cid & MM_CID_ONCPU;
@@ -4152,6 +4159,10 @@ static __always_inline void mm_cid_schedin(struct task_struct *next)
 
 	if (!next->mm_cid.active)
 		return;
+	if (unlikely(next->mm_cid.cpus_allowed_changed)) {
+		mm_update_cpus_allowed(mm, &next->cpus_mask);
+		next->mm_cid.cpus_allowed_changed = false;
+	}
 
 	cpu_cid = __this_cpu_read(mm->mm_cid.pcpu->cid);
 	mode = READ_ONCE(mm->mm_cid.mode);
@@ -4197,6 +4208,7 @@ static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct
 }
 
 #else /* !CONFIG_SCHED_MM_CID: */
+static inline void mm_cid_notify_affinity_change(struct task_struct *p) { }
 static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct *next) { }
 #endif /* !CONFIG_SCHED_MM_CID */
 
-- 
2.56.0


