Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA3060A2634
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LlQ6HgCA
Received: by kanga.kvack.org (Postfix)
	id 20E626B05B6; Tue, 17 Nov 2026 11:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DCA6B05BB; Tue, 17 Nov 2026 11:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94FB6B05B8; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDD1A6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 486C0404D5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
X-FDA: 85445116008.05.2136C49
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2989140009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=LlQ6HgCA;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbT445wpUVOQuseHxKqXDJcQzACyRBO0wZvsiVSVyj4=;
	b=emankgqDuyHw27kt2HKidVSv/cL1Lzv1FIkHOmyyvaIozx4/lponTVTlQwvCGCEaC4dk0K
	3aPLdTbA8526dQOXw7GlgvJ6kc9Jce+14P0DavgrXZE6WKiQoom50zGAWX0mrth3mFMYIZ
	iuBk6DnJY3A1atwe+eC1y7zA4jQrRyo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=LlQ6HgCA;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932242;
	b=pROj8wf3JgFnoQO6wJ/UBUSUNKImDICokzcOXAkfhSBRNF51eSpIEN1Zo6Hustc3R6OI5V
	Ukq5bdz0FogCrhtIVXVOXZyDpVHFNDLbTX7xJ4fO/wajvRalpj4Wt7+ta48eqrO4csLyvr
	iiAzb41QEyi7XVj01FY2BpaOPPQYJ/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932241;
	bh=CbT445wpUVOQuseHxKqXDJcQzACyRBO0wZvsiVSVyj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlQ6HgCAK6mDmXs48rJgePPsA4NTN42mq46a2a6S9K7N5+GeGljnBH4ekWusIuvFf
	 tElsGuHI7TXi6LQ3A+m3NEFihfKS2HiZuI5PIS+tbP0om86ajW2QSlKWH/rFWaYj1A
	 dvDa0uxxZpraqHiUJKc9GJ4uw999OTBtJo3qcskN6n5PXIRwwMepb2NPHKFiPP9q2G
	 j8N+1xdk9GuAfC4S55xy60GfaTU6FGAYRieMJPN//2a3ryOM3/w/OPE0d3VsT1BRoT
	 XOQAKD9C5tsVgciZ8ejhelPXvTlxu6xfPAEFOwMrsMHFHcDn6rHuTBM/ltCmAQCZbV
	 uRMLYARiPJqtg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHj6MbDzRKX;
	Tue, 17 Nov 2026 11:17:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	paulmck@kernel.org,
	boqun@kernel.org,
	shuah@kernel.org,
	kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	oleg@redhat.com,
	bestswngs@gmail.com,
	xmei5@asu.edu,
	xujiakai24@mails.ucas.ac.cn,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 03/17] sched/mmcid: Reset stale state when the first user joins an mm
Date: Tue, 17 Nov 2026 11:17:03 -0500
Message-Id: <b03714bdaf30f1b552d46caf22f4e1e77ca9e6ff.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2989140009
X-Stat-Signature: ceqja7qwntt3hbhxykmq3mmof55u9x89
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794932242-374324
X-HE-Meta: U2FsdGVkX1/BwRrir6mSCAW9Ph2ELuA1LU9NCYK9bxoOOv2SGlOXi4WFyiZ/WVQLuxiHlkmmo2xVFQhPAIDUGXn9qiA8i32v0p82c72mdz0Y2naoyr8L6wDRmkPwZomyCnotb2iqYs7ISdFp5/X31F6Ap8qsp9RdJwONKH8MmTME8yZrMDjjobOKKxbPxm4HEPHc2Gn7p7fgsBOOdVaG5xrUMyMKtswysQNiu0Ws18opTVpv7wU23LFKTkBr05YoF+QAVzsxBPYyzlQ2UzBotHvo8RIQ7MTgrutXesVRJ3ikMqzossO5RX2BgleovSVhY8Wwj7sOiE/m934mQnh3+980/pdOZfsK+v2H9xEt9K5yVZ+gRSSY56wOepX7zCEMnapEw0WNh/0mPMiHATpWw10ZkCzdcKYUEsLAGz/4wemF5zO9BDNatbJ3oi2n9hzB62rg03TAzZ2DvozmMSJUFu0QMEP+OYnj/+HbMnK4+93Urna1G7ZO6yfS4rJ/4evmHOsyFqT9jZhU1AlpCLJx5fu0FNSIZvK8MCPdlrO269obt0fREEkE2VijamqUxibR5PQDoEimJXnY2QEqhUCZ0o/+HBqztzNCN8WL1ojrE5SXopjkX/WAPCVtkuS4ZniKwHxROA36mUL4aCq4RWbseEqRqgo0dV9bb0E4bnUw3rYWfuXO2zl94yFZJeBcXaDWmoiwCCH4FaSv2DSSlQ6jd3cT+UYQZQuu4ide0pMBC3NXmYczttq/XC22YYsv0HV9l7nM5sSLKNagL02PRkI+kmOOXrDx67HlE90W3bZjF0pwD3zpi5JZKlNBB56UKfd8f1kQY3PCPBe/2Lif9SYQlhDaxAZcQIb8YJpgRZwsvE7IMaE/uMmr1I5f4Ao9aEPA8ka6b3FlNYwBttJuX5MCd2VL5JqWGSm5Ot0kqN3h6+rZioh0if4UBOgXse/oLBxvWTWtLbvgzQzUrEOPv4N
 sN9fS5B3
 nbShaccs5wPOR6Lo+lnZJQQkv3Z+gl3/Fj4+RqMErK72fPTeOFDUDRHZLxNiX48an8Nt3DFFh3MKbHOlYQUeR4Yk7gwaNb33WXqGp5hy38EFtgVfUToHqxJ4x0Azmhapygc7dOI6k4dpx3heQ8GzLUkwpM/5swd1JWM+SGQ6iSvxE31MkfMAFGx9Lni7ydHyLrnlfZOKW5zNHy8n7Ldv7aj7XC+AopcOXnpg7yb2dLlWv6HXefCH6ksZu3H/L2jQMzjw3hNQf2hywrpuozvfsicdgkwLlg33S2QLtEdcDJkffIZWrZE4cgwRRQpZpsZ3Allq1s7u35Vg+swU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sched_mm_cid_exit() ignores the mode change when the last user of an mm
leaves. Its comment says there is nothing to do. That holds for an exit:
the mm goes away. It holds for a successful execve() too, which joins a
new mm.

A failed execve() is missed. It leaves the mm in
sched_mm_cid_before_execve() and rejoins the same mm in
sched_mm_cid_after_execve(). If the last user left in per CPU mode,
MM_CID_TRANSIT stays set and the other CPUs still own their CIDs.

In the diagram below, the machine has two CPUs. T is the main thread
of a process. The four threads it creates only wait. H is another
process. It stays on CPU 1.

  CPU 0                                     CPU 1

  T: creates four threads
     the mm switches to per CPU mode
                                            T: runs on CPU 1
                                               CPU 1 owns a CID
  T: runs on CPU 0 again
     CPU 0 owns a CID
  T: joins the four threads
     T is the only user left
  T: execve()
     sched_mm_cid_before_execve()
       T leaves as the last user
       drops the CID of CPU 0
       MM_CID_TRANSIT is set
       CPU 1 still owns its CID
                                            H: sched_setaffinity(T, CPU 1)
                                            T: migrates to CPU 1
                                               execve() fails
                                               sched_mm_cid_after_execve()
                                                 sched_mm_cid_fork(T)
                                                   T is the first user
                                                   mm_get_cid() succeeds
                                                   writes that CID to the
                                                   storage of CPU 1
                                                   the CID CPU 1 owned keeps
                                                   its bit, with no owner

The mm has one CID fewer from then on. Once every remaining CID is
taken, mm_get_cid() loops forever with interrupts disabled. On a guest
with two CPUs, the next pthread_create() of T does not return:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  RIP: 0010:sched_mm_cid_fork+0x1dd/0x660
   copy_process+0x2339/0x2ca0
   kernel_clone+0xc3/0x3c0
   __do_sys_clone3+0xe2/0x130

Per CPU mode lasts down to one user when mm_cid_calc_pcpu_thrs() returns
1. It does with two or three possible CPUs. It also does on any machine
when the mm is allowed a single CPU. The lockup was reproduced in the
first case only.

Fix this in sched_mm_cid_fork(), when the first user joins an mm whose
mode is not 0. Clear the mode, the CID of every CPU and the CID bitmap,
and take the allowed CPUs of the task. A new mm has mode 0, so this
does nothing for it.

sched_mm_cid_exit() stays as it is. The last user of an mm that goes
away runs no fixup.

Also check the user count again under the lock in
mm_update_cpus_allowed(). An affinity change can race with the last
user leaving. It would change the allowed CPUs of an mm with no user.

With this patch, in the same test, T keeps CID 0 after the failed
execve() and its next pthread_create() returns.

[ mathieu: wrote the changelog from the thread; the code is Thomas's
  draft, placed on the current sched_mm_cid_fork() ]

Fixes: 653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")
Originally-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/87mrs8bhp4.ffs@fw13/
---
 kernel/sched/core.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7e213e88ac28..ab68e8605eed 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10847,6 +10847,10 @@ static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpu
 	 */
 	mc = &mm->mm_cid;
 	guard(raw_spinlock)(&mc->lock);
+	/* Might have raced with exit() */
+	if (!mm->mm_cid.users)
+		return;
+
 	mm_allowed = mm_cpus_allowed(mm);
 	weight = cpumask_weighted_or(mm_allowed, mm_allowed, affmsk);
 	if (weight == mc->nr_cpus_allowed)
@@ -10986,6 +10990,33 @@ static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
 	return mm_update_max_cids(mm);
 }
 
+/*
+ * sched_mm_cid_exit() does not handle the mode switch for the last user
+ * because for normal exit() that's a pointless exercise. But if the
+ * process which issued execve() was multithreaded and the last exiting
+ * thread switched back from per CPU mode then this leaves stale state
+ * around. The indicator for that is mm_cid::mode having MM_CID_TRANSIT
+ * set.
+ */
+static void sched_mm_cid_cleanup_execve(struct task_struct *t, struct mm_struct *mm)
+{
+	if (likely(!mm->mm_cid.mode))
+		return;
+
+	WARN_ON_ONCE(mm->mm_cid.mode & MM_CID_ONCPU);
+	mm->mm_cid.mode = 0;
+
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(mm->mm_cid.pcpu->cid, cpu) = 0;
+
+	bitmap_zero(mm_cidmask(mm), num_possible_cpus());
+
+	mm->mm_cid.nr_cpus_allowed = t->nr_cpus_allowed;
+	cpumask_copy(mm_cpus_allowed(mm), &t->cpus_mask);
+}
+
 /*
  * Make @t a user of the CIDs of its mm. Called on fork(2) and on
  * execve(2). A failed execve(2) rejoins the mm it left.
@@ -11015,6 +11046,7 @@ static void sched_mm_cid_fork(struct task_struct *t)
 
 		/* First user ? */
 		if (!mm->mm_cid.users) {
+			sched_mm_cid_cleanup_execve(t, mm);
 			sched_mm_cid_add_user(t, mm);
 			t->mm_cid.cid = mm_get_cid(mm);
 			/* Required for execve() */
-- 
2.47.3


