Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3ADCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE766B0096; Wed, 20 May 2026 17:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37B56B0098; Wed, 20 May 2026 17:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B276C6B0099; Wed, 20 May 2026 17:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECF76B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:49:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C395160E13
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:22 +0000 (UTC)
X-FDA: 84789139764.06.CF517C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 895FF1A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOGE8ZxQ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQDK7g3H3BcM9ZVo4RUPIYfAvb40npSo2ZMyuMXaIZE=;
	b=z9t8hJErZch5zjSmxqgM/gZ/6BGMFgZyQiYx896uCdPwh/rSrp6ZilNd98ZEInrcPFtunp
	DR/Tr8BPuSzgm38c9mAmR3Vgr3L2kGNNrB4zctHmvkuvuE4yXu4oGByfdF8YqqkH/UrABU
	C6DkvSPKmUjB6/tRbCx12V1C83KyzJU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOGE8ZxQ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779313760; a=rsa-sha256;
	cv=none;
	b=YkdBapWFSXndYVizTFxf9ZBak6cROCBOlih7TpX6MR4z4ODOIVvTUipb7KeUGLdUol+k5X
	KU99VG10ba9UI5z1d1lfiQ9a4TXqO7akFUDinx2r3SpfhQ6fAfQp01LCouV/nLuP/s/uCg
	w+sGt60TF/rD2ynvgEnpz1jT2RE32AI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AB74601E8;
	Wed, 20 May 2026 21:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8D01F000E9;
	Wed, 20 May 2026 21:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779313759;
	bh=NQDK7g3H3BcM9ZVo4RUPIYfAvb40npSo2ZMyuMXaIZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lOGE8ZxQ3NHTktk/bC2+yAfArTkMbuUD9Y1x+fNe/CkJXi/0YRsqQ8qJSsVGDCCrR
	 NCpHai+UIrgQdEBfa/POO+MGjVcQDQpwYcOxOfuwik6mzZfbFhKxKKO8aSLzVXGKKg
	 Dj6xsSsdHKUstyMXKlGGVva8R6g/MSV21dpzDkKx7+sYK40WQdt0Y85Cht46cxupUR
	 NNYZtGNoDAMCM2UMcCyD9hxDHLF4pM7xAs121humHHofxuFuiQ58DrIxqC50Uo4oHE
	 GL8DNinBA7C6NcRl2hPnVOHpa5mrKORSdZWGRh/srIJdCZrRNq3FyR7V0iVPPuH4fv
	 LRnBjCdtsDrDQ==
From: "Christian Brauner (Amutable)" <brauner@kernel.org>
Date: Wed, 20 May 2026 23:48:55 +0200
Subject: [PATCH RFC v3 4/4] exec_state: relocate dumpable information
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=29050; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mTAFm+zhAsXexjpvvHrdSTrgCYzB+/H+2z3m7VfFxsA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx6XinCLnos7c4htl3/NTlF3PWNrWffPfcykW1B+Yn9
 yvG8P3rKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmIhRCsP/UEZLV+Xvm01v/LNU
 2/PMNPpCxLNqhxdql+9dd1yycdX3Eob/Nf2f/0jOPHMz1650/Y0v4WtvPxOd33HHpDp5v8D5VjN
 PXgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: o85p3cyaty14nsytc86t1t1a1nqsjmqg
X-Rspamd-Queue-Id: 895FF1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779313760-177203
X-HE-Meta: U2FsdGVkX18nr1cUTFFitWWuIoVX2NvFnPNkZhLKPA2uuDzh5jJndqUnnj5h8vRRaqYjCal1CAZyJZfdBYFHkt2ZFGZ7eagp7LS8fQ1G7hbBjfx5MA0JwSnzLTmrsEtuPl0IaYVPLOjg7pbstVd07kddTD7+5E4TVtU/wvofFAFqThf88LDLa61UvRn8HZMsqxGFWowd2nz8dKxkj4xgycArZ02P3/g9shLteTjopQfJL7BuE+ZE+Tl3vNzFvfVG7EQIe3TpdVlX9oKVCx9WSsd7vgnrIJKrhkS3j/8GjZC+AcjIF+rar+Gyfry0jP8u33h1O9t0rbZXtMFSsMcz4mmDu1zCPX8QOys/nmjP0qCKTlMz26mA7pMyw1aHRwiWk8LxwpO8WTSF+uF96kjVgBb3A5sEdoEGU0mXpgX+oyUE+RRsvZ4j9KKUIB15ySG1vomPbCuIcPJQJ7l9nY59oTj2Q58N8sfVqLpLdEfCG8529auCcbiBcjv8kjJcamfWPXfjC16V0g3Ud46xt/scPf93BB+WAtM996qWBrLkiA5jVm7SKDsI5k5zA5jE+S0gBKPXCV6wF9JdLV4m8oqpNQJxons8EFly9Fo5Zr/RtvjCGtdgDbU/vl/g8/Ks0+g43n+QXereHrVk6YKyXBRZth7srZ4cQcoPhl7mGQ0PiMqi3IN9AwYHZau6O1MpgZeK3ZmX8+xlEy6BlNTC5RGGR+IV6b/tBr+n1ioC5v3wdZC+vNd75cFSuvzsJxBJ28PVeMrHWaeZa3UVwhaYpcA2yC9pwhznJC1efbRWtyVXxt/af06fty5YEQRuaGadaCuoq6s9SK7ksvIikeC0LE5853tXMYwwoKAhT2yS3c0n3CXZdx58PaYHgicwEiRb7+7bgTBQxI6aQyvpFL4AxlYnKcYu0byXm1UwAF4Wwl+oKytup1fPpr3OoSFsjb99wLkVRiuFuddAS85UF5lcev6
 afIaRwvQ
 K7sJiGr/E2r0Cmn8ZxM43IPfr27QelUk+NJnVg+M4pEPEn5sWkQt4LblWzbFwuh+PNsRR2nN3dpSm/bOnrUo5vw6FdPtYkLlXrz9pzAVGwxL7bi3qOC4d3uiYf+YwSFW6UrcqWnqY9xGiwSc6LrBGeuRGKaeGvi50d3RFdS/4E+6Ie2OQdi1AHFXNyo/rIGhSwO1vVuCG8LQY7bs2xZXA9GYVTMH/enKjC+59jAuoaNoOHMzYct0134dKQWlphxjHdZLvi6MNn7P8iXZU3owrvJkRlmr0sdFUYVWVcq6f3xmjlO9phPWFlVLqpJK+1UC5/V4qJHspklQabyv3DXh82IjRoL8QRDTcW+W9AcZmoSoQ/jozo/x0aJZ9tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dumpable flag captured at execve() is consulted by
__ptrace_may_access() and several /proc owner / visibility checks.
It lives on mm_struct today, which exit_mm() clears from the task
long before the task itself is reaped.

exec_state is anchored to the execve() that established the current
privilege domain.  CLONE_VM siblings refcount-share the parent's
exec_state via copy_exec_state(); non-CLONE_VM clones allocate a
fresh exec_state inheriting the parent's dumpable mode and user_ns
reference via task_exec_state_copy().  execve() allocates a fresh
instance (via alloc_task_exec_state() in begin_new_exec()) and
installs it under task_lock + exec_update_lock with
task_exec_state_replace().  init_task uses a static instance.

The dumpable mode now lives on task->exec_state->dumpable.
task->mm->flags no longer carries dumpability; MMF_DUMPABLE_MASK is
removed, but MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* bit
positions remain stable for the /proc/<pid>/coredump_filter ABI. The
task->user_dumpable cache bit and its assignment in exit_mm() are
removed; readers go through get_dumpable(task) directly.

coredump_params gains a snapshot field cprm.dumpable, populated from
get_dumpable(current) at vfs_coredump() entry, replacing the previous
__get_dumpable(cprm->mm_flags) consumers in fs/coredump.c and
fs/pidfs.c.

The user namespace recorded at execve() is consulted by
__ptrace_may_access() and by /proc/PID/* owner derivation. Move the
captured user_ns onto task_exec_state, which stays attached to the task
past exit_mm() and across exit_files().

bprm grows a user_ns field staged in bprm_mm_init() with the caller's
user_ns, narrowed by would_dump() to the closest privileged ancestor,
and consumed by exec_mmap() via alloc_task_exec_state(bprm->user_ns).
free_bprm() releases the staging reference.

mm_struct loses ->user_ns entirely.  Initializers in init-mm, efi_mm,
and the implicit one in mm_init()/dup_mm()/mm_alloc() are removed;
__mmdrop() drops the matching put_user_ns(). The kthread_use_mm()
WARN_ON_ONCE(!mm->user_ns) is no longer meaningful and goes too.

Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arm64/kernel/mte.c          |  6 ++----
 drivers/firmware/efi/efi.c       |  1 -
 fs/coredump.c                    | 20 +++++++-------------
 fs/exec.c                        | 39 ++++++++++++++++++++-------------------
 fs/pidfs.c                       | 17 ++++++-----------
 fs/proc/base.c                   | 39 ++++++++++++++++-----------------------
 include/linux/binfmts.h          |  2 ++
 include/linux/coredump.h         |  4 ++++
 include/linux/mm_types.h         |  9 ++++-----
 include/linux/sched.h            |  4 +---
 include/linux/sched/coredump.h   | 36 ++----------------------------------
 include/linux/sched/exec_state.h |  2 --
 init/init_task.c                 | 10 ++++++++++
 kernel/cred.c                    |  3 +--
 kernel/exit.c                    |  1 -
 kernel/fork.c                    | 32 ++++++++++++++++++++++++++------
 kernel/kthread.c                 |  1 -
 kernel/ptrace.c                  | 26 ++++++++------------------
 kernel/sys.c                     |  4 ++--
 mm/init-mm.c                     |  1 -
 20 files changed, 111 insertions(+), 146 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 904ac41f93bc..1a9aad6ef22a 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/prctl.h>
+#include <linux/ptrace.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/string.h>
@@ -537,16 +538,13 @@ static int access_remote_tags(struct task_struct *tsk, unsigned long addr,
 	if (!mm)
 		return -EPERM;
 
-	if (!tsk->ptrace || (current != tsk->parent) ||
-	    ((get_dumpable(mm) != TASK_DUMPABLE_OWNER) &&
-	     !ptracer_capable(tsk, mm->user_ns))) {
+	if (!ptracer_access_allowed(tsk)) {
 		mmput(mm);
 		return -EPERM;
 	}
 
 	ret = __access_remote_tags(mm, addr, kiov, gup_flags);
 	mmput(mm);
-
 	return ret;
 }
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d04be38f1750..ae78bc021b41 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -73,7 +73,6 @@ struct mm_struct efi_mm = {
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-	.user_ns		= &init_user_ns,
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock		= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.mm_cid.lock),
 #endif
diff --git a/fs/coredump.c b/fs/coredump.c
index f5348d5bc441..e943569e9b6d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -395,8 +395,7 @@ static bool coredump_parse(struct core_name *cn, struct coredump_params *cprm,
 							  cred->gid));
 				break;
 			case 'd':
-				err = cn_printf(cn, "%d",
-					__get_dumpable(cprm->mm_flags));
+				err = cn_printf(cn, "%d", cprm->dumpable);
 				break;
 			/* signal that caused the coredump */
 			case 's':
@@ -869,11 +868,11 @@ static inline void coredump_sock_shutdown(struct file *file) { }
 static inline bool coredump_socket(struct core_name *cn, struct coredump_params *cprm) { return false; }
 #endif
 
-/* cprm->mm_flags contains a stable snapshot of dumpability flags. */
+/* cprm->dumpable is the snapshot of task dumpability at dump start. */
 static inline bool coredump_force_suid_safe(const struct coredump_params *cprm)
 {
 	/* Require nonrelative corefile path and be extra careful. */
-	return __get_dumpable(cprm->mm_flags) == TASK_DUMPABLE_ROOT;
+	return cprm->dumpable == TASK_DUMPABLE_ROOT;
 }
 
 static bool coredump_file(struct core_name *cn, struct coredump_params *cprm,
@@ -1085,7 +1084,7 @@ static inline bool coredump_skip(const struct coredump_params *cprm,
 		return true;
 	if (!binfmt->core_dump)
 		return true;
-	if (!__get_dumpable(cprm->mm_flags))
+	if (cprm->dumpable == TASK_DUMPABLE_OFF)
 		return true;
 	return false;
 }
@@ -1170,14 +1169,9 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
 		.limit = rlimit(RLIMIT_CORE),
-		/*
-		 * We must use the same mm->flags while dumping core to avoid
-		 * inconsistency of bit flags, since this flag is not protected
-		 * by any locks.
-		 *
-		 * Note that we only care about MMF_DUMP* flags.
-		 */
-		.mm_flags = __mm_flags_get_dumpable(mm),
+		/* Snapshot MMF_DUMP_FILTER_* (unlocked) and dumpable for the dump. */
+		.mm_flags = __mm_flags_get_word(mm),
+		.dumpable = task_exec_state_get_dumpable(current),
 		.vma_meta = NULL,
 		.cpu = raw_smp_processor_id(),
 	};
diff --git a/fs/exec.c b/fs/exec.c
index f5663bb607d3..9e7f25e2cd41 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/task.h>
@@ -263,6 +264,9 @@ static int bprm_mm_init(struct linux_binprm *bprm)
 	if (!mm)
 		goto err;
 
+	/* Staged for would_dump() narrowing; consumed by begin_new_exec(). */
+	bprm->user_ns = get_user_ns(current_user_ns());
+
 	/* Save current stack limit for all calculations made during exec. */
 	task_lock(current->group_leader);
 	bprm->rlim_stack = current->signal->rlim[RLIMIT_STACK];
@@ -834,12 +838,17 @@ EXPORT_SYMBOL(read_code);
  * On success, this function returns with exec_update_lock
  * held for writing.
  */
-static int exec_mmap(struct mm_struct *mm)
+static int exec_mmap(struct mm_struct *mm, struct user_namespace *user_ns)
 {
+	struct task_exec_state *exec_state __free(put_task_exec_state) = NULL;
 	struct task_struct *tsk;
 	struct mm_struct *old_mm, *active_mm;
 	int ret;
 
+	exec_state = alloc_task_exec_state(user_ns);
+	if (!exec_state)
+		return -ENOMEM;
+
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
@@ -870,6 +879,7 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->active_mm = mm;
 	tsk->mm = mm;
 	mm_init_cid(mm, tsk);
+	exec_state = task_exec_state_replace(tsk, exec_state);
 	/*
 	 * This prevents preemption while active_mm is being loaded and
 	 * it and mm are being updated, which could cause problems for
@@ -1145,7 +1155,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * Release all of the old mmap stuff
 	 */
 	acct_arg_size(bprm, 0);
-	retval = exec_mmap(bprm->mm);
+	retval = exec_mmap(bprm->mm, bprm->user_ns);
 	if (retval)
 		goto out;
 
@@ -1210,9 +1220,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 	if (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP ||
 	    !(uid_eq(current_euid(), current_uid()) &&
 	      gid_eq(current_egid(), current_gid())))
-		set_dumpable(current->mm, suid_dumpable);
+		task_exec_state_set_dumpable(suid_dumpable);
 	else
-		set_dumpable(current->mm, TASK_DUMPABLE_OWNER);
+		task_exec_state_set_dumpable(TASK_DUMPABLE_OWNER);
 
 	perf_event_exec();
 
@@ -1261,7 +1271,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * wait until new credentials are committed
 	 * by commit_creds() above
 	 */
-	if (get_dumpable(me->mm) != TASK_DUMPABLE_OWNER)
+	if (task_exec_state_get_dumpable(me) != TASK_DUMPABLE_OWNER)
 		perf_event_exit_task(me);
 	/*
 	 * cred_guard_mutex must be held at least to this point to prevent
@@ -1298,14 +1308,14 @@ void would_dump(struct linux_binprm *bprm, struct file *file)
 		struct user_namespace *old, *user_ns;
 		bprm->interp_flags |= BINPRM_FLAGS_ENFORCE_NONDUMP;
 
-		/* Ensure mm->user_ns contains the executable */
-		user_ns = old = bprm->mm->user_ns;
+		/* Ensure bprm->user_ns contains the executable. */
+		user_ns = old = bprm->user_ns;
 		while ((user_ns != &init_user_ns) &&
 		       !privileged_wrt_inode_uidgid(user_ns, idmap, inode))
 			user_ns = user_ns->parent;
 
 		if (old != user_ns) {
-			bprm->mm->user_ns = get_user_ns(user_ns);
+			bprm->user_ns = get_user_ns(user_ns);
 			put_user_ns(old);
 		}
 	}
@@ -1375,6 +1385,8 @@ static void free_bprm(struct linux_binprm *bprm)
 		acct_arg_size(bprm, 0);
 		mmput(bprm->mm);
 	}
+	if (bprm->user_ns)
+		put_user_ns(bprm->user_ns);
 	free_arg_pages(bprm);
 	if (bprm->cred) {
 		/* in case exec fails before de_thread() succeeds */
@@ -1905,17 +1917,6 @@ void set_binfmt(struct linux_binfmt *new)
 }
 EXPORT_SYMBOL(set_binfmt);
 
-/*
- * set_dumpable stores three-value TASK_DUMPABLE_* into mm->flags.
- */
-void set_dumpable(struct mm_struct *mm, int value)
-{
-	if (WARN_ON((unsigned)value > TASK_DUMPABLE_ROOT))
-		return;
-
-	__mm_flags_set_mask_dumpable(mm, value);
-}
-
 static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
 {
 	return (struct user_arg_ptr){.ptr.native = p};
diff --git a/fs/pidfs.c b/fs/pidfs.c
index 9cd12f2f004c..b2ff950a096e 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -338,9 +338,9 @@ static inline bool pid_in_current_pidns(const struct pid *pid)
 	return false;
 }
 
-static __u32 pidfs_coredump_mask(unsigned long mm_flags)
+static __u32 pidfs_coredump_mask(enum task_dumpable dumpable)
 {
-	switch (__get_dumpable(mm_flags)) {
+	switch (dumpable) {
 	case TASK_DUMPABLE_OWNER:
 		return PIDFD_COREDUMP_USER;
 	case TASK_DUMPABLE_ROOT:
@@ -433,14 +433,9 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		return -ESRCH;
 
 	if ((mask & PIDFD_INFO_COREDUMP) && !kinfo.coredump_mask) {
-		guard(task_lock)(task);
-		if (task->mm) {
-			unsigned long flags = __mm_flags_get_dumpable(task->mm);
-
-			kinfo.coredump_mask = pidfs_coredump_mask(flags);
-			kinfo.mask |= PIDFD_INFO_COREDUMP;
-			/* No coredump actually took place, so no coredump signal. */
-		}
+		kinfo.coredump_mask = pidfs_coredump_mask(task_exec_state_get_dumpable(task));
+		kinfo.mask |= PIDFD_INFO_COREDUMP;
+		/* No coredump actually took place, so no coredump signal. */
 	}
 
 	/* Unconditionally return identifiers and credentials, the rest only on request */
@@ -779,7 +774,7 @@ void pidfs_coredump(const struct coredump_params *cprm)
 	VFS_WARN_ON_ONCE(attr == PIDFS_PID_DEAD);
 
 	/* Note how we were coredumped and that we coredumped. */
-	attr->coredump_mask = pidfs_coredump_mask(cprm->mm_flags) |
+	attr->coredump_mask = pidfs_coredump_mask(cprm->dumpable) |
 			      PIDFD_COREDUMPED;
 	/* If coredumping is set to skip we should never end up here. */
 	VFS_WARN_ON_ONCE(attr->coredump_mask & PIDFD_COREDUMP_SKIP);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index da0b316befb8..65f56136ec3f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -91,6 +91,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/exec_state.h>
 #include <linux/sched/stat.h>
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
@@ -1893,7 +1894,6 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
 	cred = __task_cred(task);
 	uid = cred->euid;
 	gid = cred->egid;
-	rcu_read_unlock();
 
 	/*
 	 * Before the /proc/pid/status file was created the only way to read
@@ -1903,29 +1903,22 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
 	 * made this apply to all per process world readable and executable
 	 * directories.
 	 */
-	if (mode != (S_IFDIR|S_IRUGO|S_IXUGO)) {
-		struct mm_struct *mm;
-		task_lock(task);
-		mm = task->mm;
-		/* Make non-dumpable tasks owned by some root */
-		if (mm) {
-			if (get_dumpable(mm) != TASK_DUMPABLE_OWNER) {
-				struct user_namespace *user_ns = mm->user_ns;
-
-				uid = make_kuid(user_ns, 0);
-				if (!uid_valid(uid))
-					uid = GLOBAL_ROOT_UID;
-
-				gid = make_kgid(user_ns, 0);
-				if (!gid_valid(gid))
-					gid = GLOBAL_ROOT_GID;
-			}
-		} else {
-			uid = GLOBAL_ROOT_UID;
-			gid = GLOBAL_ROOT_GID;
+	if (mode != (S_IFDIR | S_IRUGO | S_IXUGO)) {
+		struct task_exec_state *exec_state;
+
+		exec_state = task_exec_state_rcu(task);
+		if (READ_ONCE(exec_state->dumpable) != TASK_DUMPABLE_OWNER) {
+			uid = make_kuid(exec_state->user_ns, 0);
+			if (!uid_valid(uid))
+				uid = GLOBAL_ROOT_UID;
+
+			gid = make_kgid(exec_state->user_ns, 0);
+			if (!gid_valid(gid))
+				gid = GLOBAL_ROOT_GID;
 		}
-		task_unlock(task);
 	}
+	rcu_read_unlock();
+
 	*ruid = uid;
 	*rgid = gid;
 }
@@ -2965,7 +2958,7 @@ static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
 	ret = 0;
 	mm = get_task_mm(task);
 	if (mm) {
-		unsigned long flags = __mm_flags_get_dumpable(mm);
+		unsigned long flags = __mm_flags_get_word(mm);
 
 		len = snprintf(buffer, sizeof(buffer), "%08lx\n",
 			       ((flags & MMF_DUMP_FILTER_MASK) >>
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 65abd5ab8836..a8379f4eee61 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -25,6 +25,8 @@ struct linux_binprm {
 	struct page *page[MAX_ARG_PAGES];
 #endif
 	struct mm_struct *mm;
+	/* user_ns published to task->exec_state at execve, narrowed by would_dump(). */
+	struct user_namespace *user_ns;
 	unsigned long p; /* current top of mem */
 	unsigned int
 		/* Should an execfd be passed to userspace? */
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 68861da4cf7c..7b38ee2e7913 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/sched/coredump.h>
 #include <asm/siginfo.h>
 
 #ifdef CONFIG_COREDUMP
@@ -20,7 +21,10 @@ struct coredump_params {
 	const kernel_siginfo_t *siginfo;
 	struct file *file;
 	unsigned long limit;
+	/* MMF_DUMP_FILTER_* bits, snapshot of mm->flags at dump start. */
 	unsigned long mm_flags;
+	/* Snapshot of dumpable at dump start. */
+	enum task_dumpable dumpable;
 	int cpu;
 	loff_t written;
 	loff_t pos;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 51ea37b2a0aa..9588ce3b16df 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1342,7 +1342,6 @@ struct mm_struct {
 		 */
 		struct task_struct __rcu *owner;
 #endif
-		struct user_namespace *user_ns;
 
 		/* store ref to file /proc/<pid>/exe symlink points to */
 		struct file __rcu *exe_file;
@@ -1907,11 +1906,11 @@ enum {
 /* mm flags */
 
 /*
- * The first two bits represent core dump modes for set-user-ID,
- * the modes are TASK_DUMPABLE_* defined in linux/sched/coredump.h
+ * Bits 0 and 1 were dumpability; that moved to task->exec_state.  Reserve
+ * the bits so MMF_DUMP_FILTER_* positions stay stable for the
+ * /proc/<pid>/coredump_filter ABI.
  */
 #define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK (BIT(MMF_DUMPABLE_BITS) - 1)
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
 #define MMF_DUMP_ANON_SHARED	3
@@ -1972,7 +1971,7 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
-#define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
+#define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6674dbf960b5..258cb075478d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -85,6 +85,7 @@ struct seq_file;
 struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
+struct task_exec_state;
 struct task_group;
 struct task_struct;
 struct timespec64;
@@ -1004,9 +1005,6 @@ struct task_struct {
 	unsigned			sched_rt_mutex:1;
 #endif
 
-	/* Save user-dumpable when mm goes away */
-	unsigned			user_dumpable:1;
-
 	/* Bit to tell TOMOYO we're in execve(): */
 	unsigned			in_execve:1;
 	unsigned			in_iowait:1;
diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
index ed6547692b61..20957ccde3b5 100644
--- a/include/linux/sched/coredump.h
+++ b/include/linux/sched/coredump.h
@@ -2,8 +2,6 @@
 #ifndef _LINUX_SCHED_COREDUMP_H
 #define _LINUX_SCHED_COREDUMP_H
 
-#include <linux/mm_types.h>
-
 /*
  * Task dumpability mode.  Gates core dump production and ptrace_attach()
  * authorization.  The numeric values are stable ABI (suid_dumpable
@@ -15,37 +13,7 @@ enum task_dumpable {
 	TASK_DUMPABLE_ROOT	= 2,	/* dump as root; ptrace needs CAP_SYS_PTRACE */
 };
 
-static inline unsigned long __mm_flags_get_dumpable(const struct mm_struct *mm)
-{
-	/*
-	 * By convention, dumpable bits are contained in first 32 bits of the
-	 * bitmap, so we can simply access this first unsigned long directly.
-	 */
-	return __mm_flags_get_word(mm);
-}
-
-static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
-{
-	__mm_flags_set_mask_bits_word(mm, MMF_DUMPABLE_MASK, value);
-}
-
-extern void set_dumpable(struct mm_struct *mm, int value);
-/*
- * This returns the actual value of the suid_dumpable flag. For things
- * that are using this for checking for privilege transitions, it must
- * test against TASK_DUMPABLE_OWNER rather than treating it as a boolean
- * value.
- */
-static inline int __get_dumpable(unsigned long mm_flags)
-{
-	return mm_flags & MMF_DUMPABLE_MASK;
-}
-
-static inline int get_dumpable(struct mm_struct *mm)
-{
-	unsigned long flags = __mm_flags_get_dumpable(mm);
-
-	return __get_dumpable(flags);
-}
+void task_exec_state_set_dumpable(enum task_dumpable value);
+enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task);
 
 #endif /* _LINUX_SCHED_COREDUMP_H */
diff --git a/include/linux/sched/exec_state.h b/include/linux/sched/exec_state.h
index dc5a795cbfe2..23fe4b55e010 100644
--- a/include/linux/sched/exec_state.h
+++ b/include/linux/sched/exec_state.h
@@ -21,8 +21,6 @@ void put_task_exec_state(struct task_exec_state *exec_state);
 struct task_exec_state *task_exec_state_rcu(const struct task_struct *tsk);
 struct task_exec_state *task_exec_state_replace(struct task_struct *tsk,
 						struct task_exec_state *exec_state);
-void task_exec_state_set_dumpable(enum task_dumpable value);
-enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task);
 int task_exec_state_copy(struct task_struct *tsk);
 void __init exec_state_init(void);
 
diff --git a/init/init_task.c b/init/init_task.c
index b5f48ebdc2b6..47a651b05058 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -7,6 +7,8 @@
 #include <linux/sched/rt.h>
 #include <linux/sched/task.h>
 #include <linux/sched/ext.h>
+#include <linux/sched/exec_state.h>
+#include <linux/user_namespace.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -56,6 +58,13 @@ static struct sighand_struct init_sighand = {
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(init_sighand.signalfd_wqh),
 };
 
+/* init to 2 - one for init_task, one to ensure it is never freed */
+static struct task_exec_state init_task_exec_state = {
+	.count		= REFCOUNT_INIT(2),
+	.dumpable	= TASK_DUMPABLE_OWNER,
+	.user_ns	= &init_user_ns,
+};
+
 #ifdef CONFIG_SHADOW_CALL_STACK
 unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)] = {
 	[(SCS_SIZE / sizeof(long)) - 1] = SCS_END_MAGIC
@@ -113,6 +122,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	.nr_cpus_allowed= NR_CPUS,
 	.mm		= NULL,
 	.active_mm	= &init_mm,
+	.exec_state	= &init_task_exec_state,
 	.restart_block	= {
 		.fn = do_no_restart_syscall,
 	},
diff --git a/kernel/cred.c b/kernel/cred.c
index 12a7b1ce5131..dceb9fa4a4b4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -384,8 +384,7 @@ int commit_creds(struct cred *new)
 	    !uid_eq(old->fsuid, new->fsuid) ||
 	    !gid_eq(old->fsgid, new->fsgid) ||
 	    !cred_cap_issubset(old, new)) {
-		if (task->mm)
-			set_dumpable(task->mm, suid_dumpable);
+		task_exec_state_set_dumpable(suid_dumpable);
 		task->pdeath_signal = 0;
 		/*
 		 * If a task drops privileges and becomes nondumpable,
diff --git a/kernel/exit.c b/kernel/exit.c
index 507eda655e8d..9a909993ab1d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -571,7 +571,6 @@ static void exit_mm(void)
 	 */
 	smp_mb__after_spinlock();
 	local_irq_disable();
-	current->user_dumpable = (get_dumpable(mm) == TASK_DUMPABLE_OWNER);
 	current->mm = NULL;
 	membarrier_update_current_mm(NULL);
 	enter_lazy_tlb(mm, current);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5f3fdfdb14c7..b8b651abce8b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -23,6 +23,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
 #include <linux/sched/ext.h>
+#include <linux/sched/exec_state.h>
 #include <linux/seq_file.h>
 #include <linux/rtmutex.h>
 #include <linux/init.h>
@@ -555,6 +556,7 @@ void free_task(struct task_struct *tsk)
 	if (tsk->flags & PF_KTHREAD)
 		free_kthread_struct(tsk);
 	bpf_task_storage_free(tsk);
+	put_task_exec_state(tsk->exec_state);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -731,7 +733,6 @@ void __mmdrop(struct mm_struct *mm)
 	destroy_context(mm);
 	mmu_notifier_subscriptions_destroy(mm);
 	check_mm(mm);
-	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
@@ -1072,8 +1073,7 @@ static void mmap_init_lock(struct mm_struct *mm)
 #endif
 }
 
-static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
-	struct user_namespace *user_ns)
+static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	mt_init_flags(&mm->mm_mt, MM_MT_FLAGS);
 	mt_set_external_lock(&mm->mm_mt, &mm->mmap_lock);
@@ -1132,7 +1132,6 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 				     NR_MM_COUNTERS))
 		goto fail_pcpu;
 
-	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
 	return mm;
 
@@ -1163,7 +1162,7 @@ struct mm_struct *mm_alloc(void)
 		return NULL;
 
 	memset(mm, 0, sizeof(*mm));
-	return mm_init(mm, current, current_user_ns());
+	return mm_init(mm, current);
 }
 EXPORT_SYMBOL_IF_KUNIT(mm_alloc);
 
@@ -1527,7 +1526,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 
 	memcpy(mm, oldmm, sizeof(*mm));
 
-	if (!mm_init(mm, tsk, mm->user_ns))
+	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
 	uprobe_start_dup_mmap();
@@ -1593,6 +1592,23 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
+static int copy_exec_state(u64 clone_flags, struct task_struct *tsk)
+{
+	int ret;
+	struct task_exec_state *exec_state;
+
+	exec_state = rcu_access_pointer(tsk->exec_state);
+	if (clone_flags & CLONE_VM) {
+		refcount_inc(&exec_state->count);
+		return 0;
+	}
+
+	ret = task_exec_state_copy(tsk);
+	if (ret)
+		RCU_INIT_POINTER(tsk->exec_state, NULL);
+	return ret;
+}
+
 static int copy_fs(u64 clone_flags, struct task_struct *tsk)
 {
 	struct fs_struct *fs = current->fs;
@@ -2090,6 +2106,9 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	retval = copy_exec_state(clone_flags, p);
+	if (retval)
+		goto bad_fork_free;
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
@@ -3098,6 +3117,7 @@ void __init proc_caches_init(void)
 			sizeof(struct signal_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
+	exec_state_init();
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 791210daf8b4..63beb59b7a3d 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1619,7 +1619,6 @@ void kthread_use_mm(struct mm_struct *mm)
 
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
-	WARN_ON_ONCE(!mm->user_ns);
 
 	/*
 	 * It is possible for mm to be the same as tsk->active_mm, but
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0e1f80f73a7f..ea8a682e837d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -72,21 +72,14 @@ int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 		     void *buf, int len, unsigned int gup_flags)
 {
 	struct mm_struct *mm;
-	int ret;
+	int ret = 0;
 
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
 
-	if (!tsk->ptrace ||
-	    (current != tsk->parent) ||
-	    ((get_dumpable(mm) != TASK_DUMPABLE_OWNER) &&
-	     !ptracer_capable(tsk, mm->user_ns))) {
-		mmput(mm);
-		return 0;
-	}
-
-	ret = access_remote_vm(mm, addr, buf, len, gup_flags);
+	if (ptracer_access_allowed(tsk))
+		ret = access_remote_vm(mm, addr, buf, len, gup_flags);
 	mmput(mm);
 
 	return ret;
@@ -301,16 +294,13 @@ static bool ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
 
 static bool task_still_dumpable(struct task_struct *task, unsigned int mode)
 {
-	struct mm_struct *mm = task->mm;
-	if (mm) {
-		if (get_dumpable(mm) == TASK_DUMPABLE_OWNER)
-			return true;
-		return ptrace_has_cap(mm->user_ns, mode);
-	}
+	const struct task_exec_state *exec_state;
 
-	if (task->user_dumpable)
+	guard(rcu)();
+	exec_state = task_exec_state_rcu(task);
+	if (READ_ONCE(exec_state->dumpable) == TASK_DUMPABLE_OWNER)
 		return true;
-	return ptrace_has_cap(&init_user_ns, mode);
+	return ptrace_has_cap(exec_state->user_ns, mode);
 }
 
 /* Returns 0 on success, -errno on denial. */
diff --git a/kernel/sys.c b/kernel/sys.c
index f1189f719db5..df69bd71de03 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2565,14 +2565,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		error = put_user(me->pdeath_signal, (int __user *)arg2);
 		break;
 	case PR_GET_DUMPABLE:
-		error = get_dumpable(me->mm);
+		error = task_exec_state_get_dumpable(me);
 		break;
 	case PR_SET_DUMPABLE:
 		if (arg2 != TASK_DUMPABLE_OFF && arg2 != TASK_DUMPABLE_OWNER) {
 			error = -EINVAL;
 			break;
 		}
-		set_dumpable(me->mm, arg2);
+		task_exec_state_set_dumpable(arg2);
 		break;
 
 	case PR_SET_UNALIGN:
diff --git a/mm/init-mm.c b/mm/init-mm.c
index c5556bb9d5f0..3e792aad7626 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -43,7 +43,6 @@ struct mm_struct init_mm = {
 	.vma_writer_wait = __RCUWAIT_INITIALIZER(init_mm.vma_writer_wait),
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
-	.user_ns	= &init_user_ns,
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
 #endif

-- 
2.47.3


