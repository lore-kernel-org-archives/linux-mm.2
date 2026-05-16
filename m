Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBD2CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 17:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E2C6B0088; Sat, 16 May 2026 13:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B055D6B008C; Sat, 16 May 2026 13:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4F56B0092; Sat, 16 May 2026 13:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8E56B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:09:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0623C1A03
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:09:40 +0000 (UTC)
X-FDA: 84773919720.15.CC337AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2383B160006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:09:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ag5kydUm;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778951379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cfyFZkaa3FEXkok76MBLSxuVZ3KxjvtB4aKyq78ts6c=;
	b=Ph0bRceVWYRDNXCDMnErKpkstR4FDd20TUX5ZrrMDAzv1tz3Z6XCmzUpJqMItdmoYpiorT
	CL3MLZzcEcKkCNrK6WmvosU25CXmIGIPelv9CxcJzj7EmyNxufbQlcpztMpxRXFOebjeaG
	S21e6cscRjv6Jjo4N8JVPqKzyp+arKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778951379; a=rsa-sha256;
	cv=none;
	b=VI/a22IhnfPjD7CS68MFnOxT+3y9fEv6HSRRrwEOSo275EpLM2WPTehJjzZSjVX4xvoB8x
	HiYhQnNNNrDUec/27+FCUpUKljMqCLlm4sTqYHUAvx1yjtp5jF0O2zhoXIYxYFFP8aZZyM
	HLvqhk33+feHfApUlAfu8b7T3dOGEIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ag5kydUm;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D01260138;
	Sat, 16 May 2026 17:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A291C19425;
	Sat, 16 May 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778951378;
	bh=avja1c3muB5aNK53/UaHaJfeVEZuRT7fYut3+BUNLt8=;
	h=From:Date:Subject:To:Cc:From;
	b=ag5kydUmTpTQAKdVMN7SdKDY8miGTuSmSg0iUg2aUknsWndOET1pt+xdlPKKsdK51
	 qtkxDISjzJdGbVCjLIUEKYu3Hto2roT+diyoidN5F2Ett0ijdtoICAZfK3JEUTjpaS
	 +PORvzyzp8DL6P/+Nv0Gh8Ar/Z70wy+oqvUT7u2gzdI3zzdTqRpr5vaxrGqJF4y1Vc
	 HSMV39zKuZjMjLxFXnjDEv31fCbbYK2QXc5zMP0q2gTdQROxlFnmAmCuGh72qs+gfQ
	 BsuZYKRNOZZg62iFlwfjXWXeZT3KlM+GNjPPFxcdVjessb1/sI4RqnnC/4NJn0e8MG
	 8jFrWpXKpL+9w==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 16 May 2026 19:09:16 +0200
Subject: [PATCH] ptrace: keep task's mm around in separate exit_mm field
 post-exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
X-B4-Tracking: v=1; b=H4sIALukCGoC/yWM4Q6CIBRGX8XxOxoXBKVXaa1d4JLU1AZWbs53T
 +vn+fads7BCOVFhp2phmd6ppHHYAA4V8x0ON+IpbMykkEZoMPwz5genOU3XvucaHerohAkNsE1
 5Zopp/uXOlz+Xl7uTn/bG/nBYiLuMg+/2qccyUT4aCyboRqgQokXVRojGS+8bq1QLKGsiC7U3b
 F2/J0rfXLIAAAA=
X-Change-ID: 20260516-work-exit_mm-5aba5fb06d71
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Oleg Nesterov <oleg@redhat.com>, 
 Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
 linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=9270; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5crXcMUcBASVL5GsYJiuXu/2zYrar/6ATXgspyBQxe0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRxLDmXfvfNurNPitNt3n+1czlh+WbZhsmJyak/FdJmq
 274atTwvqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi4byMDLv/lijZu3VK7nma
 NzWxdILp//SdCc+DT7kdlbZ8kVp36yzDPxsH+1TdF357t01OYZ2dV3P1RTh3GetyKZu9T7LkhPP
 3MwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2383B160006
X-Stat-Signature: cqtfp7w1o38c8cxbs8qycauii7bbe19b
X-Rspam-User: 
X-HE-Tag: 1778951378-395867
X-HE-Meta: U2FsdGVkX1+O2zxiKHScTRCKKfiD9CGgyuLWffp6L5G4TeGw8Md2GOJCcmCvNpzH4qHkPjPzfBdXWebcEyxr+c0hmZZpK415pLAFSPxMJs2DkNAyne29zPqQLRwt33EKxhM9YtA0rRzBtlfYwNY7kct6Xu5djh99WgR/ZgDnd1uk5Tcw0pPKLjhEQNYJhfjMglQYe6VtlL85ZNSiFoIkzknGYQaTSY6V13z6A/3f0WRhDdjrtjr9j6eNPJZuahZFDiPxo2iwCDbIPt4Ul5BgiV+dckA8YuIKmcUeY3FcKyleffpNqmQJKX9oT49xW9qVOhcSchMWfcDVN+LTg7xkSgcF29w9IlMX49IR5tV0lQF0kFYxX7nzh6v++syResml/QdT/GQfVg6LPTbcN5stVJCtrJi6XS8SXvocjM5noutgKua3vGXTcQr6rw2jTHhagFLNBOVcwN3octlHSgBf0/NC/kbGeZ8iT8TeqqSCCjrLD8Hufm4zlrSilpOUw89YgLsV596mtwqDTcQ3KwZ51YIR/trg81EmgDrblBWiC8778PVLbMcJByY0qHvg50hyPHShXgN2OoZqLUUHn6MAHQTfvpXqecyJrLo1zxxvnwhchHFnHUWw8CGnZwAwW9AYfyllzMSDpLmWTYpDlAz+A2M8Up/fY2Kt91lBQCx5hIRR23y/OZWe0lzouZWlUhA29Qjp2acqhlHhHps5hR0NUR1Uxaz0Rqh833mU76PaRVWQo4XK3zNGxEz5tqxP4OYBr5xO6u+GPUVv+4Axd0qMtVRdx+PGAk7iCkopvcfT1GALDh7ij2DVaI+hXpSRpsCY6yXuONX1OKnm7Shgvas4I9aHf3Fny7nLjEMfEx9JHQYvtyUN6Gh2Q49n/QXZqi6Py38UrMQjEJsUBBF02a/0MXgI/IEUu/1YS9+5jUdcmTrYlv+w4XL5if3eR9uDxsV+70e1hSWA4z46Hq9v748
 qIrJomzk
 Y0/QNMUjeSgH7X6O5gvIas0ej6P+I94jz2AWaB6lSeSbTLrvChlli91kxEiAOSZoXatZQPyNA4rWMPWP1/kpAzQfUvYflGMFefDIzSsWEx8EeE83sdKxJKcMmRMMKdQQHEXMtbf6rffDmUf1iZd76G5z8GRtfcvlEd7xmTdQTpZBNsbx8rbpWjKXuYq9tdwHeun013rYGsIJ2ZOltkbcSFzi2ZvAHxpf7NvLkMazaEdBpcn968KnFdVNYHaAORJytfwsZQiavuq/iGxwfci1p4P74Dh31fe9MqFiNRwnozuGve/+oI7AjeKnE6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jann Horn <jannh@google.com>

__ptrace_may_access() checks can happen on target tasks that are in the
middle of do_exit(), past exit_mm(). At that point, the ->mm pointer has
been NULLed out, and the mm_struct has been mmput().

Unfortunately, the mm_struct contains the dumpability and the user_ns in
which the task last went through execve(), and we need those for
__ptrace_may_access(). Currently, that problem is handled by failing open:
If the ->mm is gone, we assume that the task was dumpable. In some edge
cases, this could potentially expose access to things like
/proc/$pid/fd/$fd of originally non-dumpable processes.
(exit_files() comes after exit_mm(), so the file descriptor table is still
there when we've gone through exit_mm().)

I believe that this patch may be the least bad option to fix this - keep
the mm_struct (but not process memory) around with an mmgrab() reference
from exit_mm() until the task goes away completely.

Note that this moves free_task() down in order to make mmdrop_async()
available without a forward declaration.

Christian Brauner (Amutable) <brauner@kernel.org> says:

I massaged the patch a bit and rewrote parts of the commit message.

The cached task->user_dumpable bit introduced by commit 31e62c2ebbfd
("ptrace: slightly saner 'get_dumpable() logic'") is removed here: the
mmgrab'd exit_mm reference supplies the real dumpable flag and the
original user_ns. exit_mm() now publishes ->exit_mm before clearing ->mm
so that task_still_dumpable() readers cannot observe both NULL on a user
task.

Cc: stable@vger.kernel.org
Fixes: bfedb589252c ("mm: Add a user_ns owner to mm_struct and fix ptrace permission checks")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
In 2020 Jann actually pointed to the exact bug class that the recent
ptrace bug used and asked for a architecturally very clean fix to be
merged but it never got anywhere.

In the off-list ptrace discussion I brought up my intention to have this
merged on top. So this rebases Jann's patch [1] which addresses the root
cause directly: stash an mmgrab() reference to the mm_struct in
task->exit_mm during exit_mm(), and release it via mmdrop_async() in
free_task(). The pinned mm_struct keeps the address space metadata
(flags, user_ns) reachable for the full lifetime of the task_struct
without keeping the actual memory mappings alive. ptrace_may_access()
then simply takes the exit_mm into account. The exit_mm field is
separate and none of the other in-kernel callers need to change so
there's no regression risks.

Beyond ptrace, the fact that task->mm isn't accessible post-exit anymore
causes complications for other series. Minchan Kim's recent
PROCESS_MRELEASE_REAP_KILL series [2] describes the same shape from the
OOM-reaper side: process_mrelease() racing against do_exit() ends up with
task->mm and falls over with -ESRCH, deferring reclamation indefinitely
under Android LMKD pressure. That series works around it by moving the
SIGKILL injection into process_mrelease() itself, but the underlying
issue is identical: callers legitimately need to reach the mm of a task
after exit. That whole patch becomes rather simple with this fix.

Note that I had already brought this up with some mm folks that were
involved in the ptrace issue off-list.

Also note that the upstream patch has at least two regressions. Reading
the exit status from /proc/<pid>/stat and opening
/proc/<pid>/ns/{pid,user} of a zombie. The latter I've used multiple
times from inside a container for non-dumpable tasks for nested and
non-nested containers. Afaict, both will now be denied because we resort
to checking in the initial userns for non-dumpable tasks. And tools like
Incus do nested containers so I also suspect that anything that relies
on looking at the userns or pidns of zombies risks spurious failures.

I think we should do the clean thing and let ptrace look at the actual
mm state post exit. Keep it in a separate field and there's no
regression risk for users that expect task->mm itself to be NULL post
exit.

[1] https://lore.kernel.org/r/20201016024019.1882062-2-jannh@google.com
[2] https://lore.kernel.org/r/20260511214226.937793-1-minchan@kernel.org
---
 include/linux/sched.h |  4 +---
 kernel/exit.c         |  3 ++-
 kernel/fork.c         | 64 ++++++++++++++++++++++++++-------------------------
 kernel/ptrace.c       | 20 +++++++++++-----
 4 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee06cba5c6f5..7cefeb6cbba7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -961,6 +961,7 @@ struct task_struct {
 
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
+	struct mm_struct		*exit_mm;
 
 	int				exit_state;
 	int				exit_code;
@@ -1002,9 +1003,6 @@ struct task_struct {
 	unsigned			sched_rt_mutex:1;
 #endif
 
-	/* Save user-dumpable when mm goes away */
-	unsigned			user_dumpable:1;
-
 	/* Bit to tell TOMOYO we're in execve(): */
 	unsigned			in_execve:1;
 	unsigned			in_iowait:1;
diff --git a/kernel/exit.c b/kernel/exit.c
index f50d73c272d6..9af227c23e2b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -571,7 +571,8 @@ static void exit_mm(void)
 	 */
 	smp_mb__after_spinlock();
 	local_irq_disable();
-	current->user_dumpable = (get_dumpable(mm) == SUID_DUMP_USER);
+	mmgrab(mm);
+	current->exit_mm = mm;
 	current->mm = NULL;
 	membarrier_update_current_mm(NULL);
 	enter_lazy_tlb(mm, current);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5f3fdfdb14c7..f43ea7f5888a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -528,37 +528,6 @@ void put_task_stack(struct task_struct *tsk)
 }
 #endif
 
-void free_task(struct task_struct *tsk)
-{
-#ifdef CONFIG_SECCOMP
-	WARN_ON_ONCE(tsk->seccomp.filter);
-#endif
-	release_user_cpus_ptr(tsk);
-	scs_release(tsk);
-
-#ifndef CONFIG_THREAD_INFO_IN_TASK
-	/*
-	 * The task is finally done with both the stack and thread_info,
-	 * so free both.
-	 */
-	release_task_stack(tsk);
-#else
-	/*
-	 * If the task had a separate stack allocation, it should be gone
-	 * by now.
-	 */
-	WARN_ON_ONCE(refcount_read(&tsk->stack_refcount) != 0);
-#endif
-	rt_mutex_debug_task_free(tsk);
-	ftrace_graph_exit_task(tsk);
-	arch_release_task_struct(tsk);
-	if (tsk->flags & PF_KTHREAD)
-		free_kthread_struct(tsk);
-	bpf_task_storage_free(tsk);
-	free_task_struct(tsk);
-}
-EXPORT_SYMBOL(free_task);
-
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	struct file *exe_file;
@@ -775,6 +744,39 @@ static inline void put_signal_struct(struct signal_struct *sig)
 		free_signal_struct(sig);
 }
 
+void free_task(struct task_struct *tsk)
+{
+#ifdef CONFIG_SECCOMP
+	WARN_ON_ONCE(tsk->seccomp.filter);
+#endif
+	release_user_cpus_ptr(tsk);
+	scs_release(tsk);
+
+#ifndef CONFIG_THREAD_INFO_IN_TASK
+	/*
+	 * The task is finally done with both the stack and thread_info,
+	 * so free both.
+	 */
+	release_task_stack(tsk);
+#else
+	/*
+	 * If the task had a separate stack allocation, it should be gone
+	 * by now.
+	 */
+	WARN_ON_ONCE(refcount_read(&tsk->stack_refcount) != 0);
+#endif
+	rt_mutex_debug_task_free(tsk);
+	ftrace_graph_exit_task(tsk);
+	arch_release_task_struct(tsk);
+	if (tsk->flags & PF_KTHREAD)
+		free_kthread_struct(tsk);
+	bpf_task_storage_free(tsk);
+	if (tsk->exit_mm)
+		mmdrop_async(tsk->exit_mm);
+	free_task_struct(tsk);
+}
+EXPORT_SYMBOL(free_task);
+
 void __put_task_struct(struct task_struct *tsk)
 {
 	WARN_ON(!tsk->exit_state);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 130043bfc209..2955a59c18cf 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -272,18 +272,26 @@ static bool ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
 	return ns_capable(ns, CAP_SYS_PTRACE);
 }
 
-static bool task_still_dumpable(struct task_struct *task, unsigned int mode)
+/*
+ * Decide whether ptrace access to @task is allowed based on its mm.
+ * Reads the dumpable flag and user_ns from ->mm, or from ->exit_mm if
+ * the task has gone through exit_mm(). Note that kernel threads may have
+ * neither.
+ */
+static bool may_access_mm(struct task_struct *task, unsigned int mode)
 {
 	struct mm_struct *mm = task->mm;
+	struct user_namespace *mm_userns = &init_user_ns;
+
+	if (!mm)
+		mm = task->exit_mm;
 	if (mm) {
 		if (get_dumpable(mm) == SUID_DUMP_USER)
 			return true;
-		return ptrace_has_cap(mm->user_ns, mode);
+		mm_userns = mm->user_ns;
 	}
 
-	if (task->user_dumpable)
-		return true;
-	return ptrace_has_cap(&init_user_ns, mode);
+	return ptrace_has_cap(mm_userns, mode);
 }
 
 /* Returns 0 on success, -errno on denial. */
@@ -350,7 +358,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * Pairs with a write barrier in commit_creds().
 	 */
 	smp_rmb();
-	if (!task_still_dumpable(task, mode))
+	if (!may_access_mm(task, mode))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);

---
base-commit: 6916d5703ddf9a38f1f6c2cc793381a24ee914c6
change-id: 20260516-work-exit_mm-5aba5fb06d71


