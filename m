Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94748CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63CF6B00A8; Fri, 22 May 2026 10:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14936B00A9; Fri, 22 May 2026 10:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03626B00AA; Fri, 22 May 2026 10:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC09F6B00A8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:03:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5200A92B69
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:03:42 +0000 (UTC)
X-FDA: 84795223884.17.7299C1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 696304001D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:03:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMveLUdh;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779458620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zNDp4414zH+HOQSO1FadfrqPKgYl9qxBQdrH1yVTfnk=;
	b=8PQvVJ9UyiWCZync8yB1x7tJP5CnfrSX4OoV529xMCbyGYyYwcYRVgXcMWT2LRlBjQ/0eB
	6kPBmAcp8nIiQqNBPhDPFsk8sqBzmyOLAyy2kQ8G9j8R1SoAM5yow6S5hIBK8uSIyBFVq8
	Mz/NyBbWiyIjFYD52udLyI1BznHUHW8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMveLUdh;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779458620; a=rsa-sha256;
	cv=none;
	b=OfePr/GZnz9mM0EgUGHM1lzhUTdSp0FDKs4JgNMZ37dRz1nHnGogrv6P6WGmJAJZH6JiSw
	lDiJYveI4BU0O7F0pA2M27Ohtska7ncyssDJ02ZpytRT/ihvb7mWWP15m1Wg85tD2sor+E
	i/G8UdAosU6O/BkytxnkDM8HQzu3aNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C49C960138;
	Fri, 22 May 2026 14:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B3A1F000E9;
	Fri, 22 May 2026 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779458619;
	bh=zNDp4414zH+HOQSO1FadfrqPKgYl9qxBQdrH1yVTfnk=;
	h=From:Date:Subject:To:Cc;
	b=oMveLUdhAdgCqlpMBhBfBgA7nb84DnidRAqfv/7iZG4GfQUeNW7tH9C9f4WK9PPSl
	 QtRi5NW04nD6ZZrap6bfcZeeWKlAjji8wlSTuc159idH+vpu0lhoze0YVVE200XaQQ
	 craTX7woimn0Qx4+sNB+Q0+ysrh4n+gNgu22HX8S4/U7K6vuslpChRwCRI83v4M+/6
	 LTD0q7QYlqZown57hMeqlKzB91e91sEzjHMNA19TUhBmb1A67H5FtcZYDkO2SPsaX2
	 HdJauy0TQQOE31KLsV85t2qD4Ev39r8ahR3Yni2JzpLXamDhqznbM3mNWTzynPPu6b
	 Fam5VdSqAGjfQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 22 May 2026 16:03:30 +0200
Subject: [PATCH] exec: free the old mm outside the exec locks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-work-exit_mm-v1-1-bd32d5a560bb@kernel.org>
X-B4-Tracking: v=1; b=H4sIADFiEGoC/yWMUQ7CIBQEr9K8b2mQthq9ijEEcLVYSw0PlaTp3
 aX6OZudmYkRPZiO1UwRb89+CgW2m4pcb8INwl8Kk5JqJzulxGeKg0D2SY+jcM7IrkVzaGxLRXl
 GXH3+5U7nP/PL3uHS2lgf1jCEjSa4fp0GxICH2NeqToYHjQynOZkEWpYvvX/Gvp0AAAA=
X-Change-ID: 20260522-work-exit_mm-cca054e393b4
To: David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=5591; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BH7/MjEx7C8MvssiFkglIW+i0A2JFbcSIhQCVkZzVcA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJJFlIeC2WV9FkXnShvj5Xsu6C9I9GjdLLP2Ke3Hu5r
 IaPWTKxo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLTJBj+R+6NZ1qd9GFZ8lR/
 O+7uqVxPWCXcD/zT3Phq7+JrNq33ZzH8Uz6W/szGZKK+scWB+/mlCZd1tfa+cEg9wDn7CkM6U54
 +EwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: iourknozuhdawwkgmijji3mjqnniqmty
X-Rspamd-Queue-Id: 696304001D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779458620-370175
X-HE-Meta: U2FsdGVkX18SnEyAN7eJspgV3TswTHLOxBZczoL0yvvS0puqCLD/yD8dZzSvBjs7uMHc8Y4WknBgU+87wzNsL7q6NVmVV/JFhWBvYOdXVKIQKHBS6YLMc9WdWlig30N4ZHlYPdQ3LxLX3cjzACNUgGgQmfaBdFRc87g5Zg/vyWfWmlar74yAvh4PBjh4qlLpsODzutRU7xjMQNVY3DCSTe/mcA7QwHFKHtJ3xc7GkzfWd+2/JFb1gdNfG3ispl380750eGswrNqPBab4nEmGq9Kmg5RQjW9/7ZgseK/5nDEVHiJRIUtda8HPlOgA1yfVgcmPHY3S5ZpPYHZnVcEs77CKyf1l5Oy/IphrCCFMKZ1cFNtycb6fyy3FSJh2eJOnwrQPkzr6EpbDmBFra8XHxwNeSIPPF6ZJSR7SGFLN5m/zIMTvK1gHDxt0jH7014YsQoz5LBiRlXykeP/jJwtM9nrqOIqne384IzptDQSmdItU0sNjy8RttWQZWEbE2O4ludINGWNMAtTjIFB7FeEzfG0G//iJWhYeRTml0K/os1LVPGWQQB5PeRh20BNiQmQ1f0yi4frhORDv4NWmpVS3Dep6blJaLJOeCpfdsCf/FdU7Hwgc2/3GaxhSQj0s64BL5yquHiVRnbCZVu837sMPc+taPbDsoC3j15IwByjuqVei+kLvoa1LjFRacgzcNH0QjlOP1mr0KY1/BAn2Ea3Ti6mAGKU1NDzEw3HnP6bnbXcAIiGmaU4hOsYUVzrwgCM/+aHkhRTSRQWQHd0sUWx3RKFlmzhqYycfX4rikWg2uYMIfE1nP3/FNEkzhvmstWxxb2U8WurXJTPHBPoPT3Jger6bTMNnIFGjIkRrJzbfKDThTun9OeWYWltb2VNzrCGaNcWyDwGKM//jP1Xxr544IiWTIfRJeXXhIQvTA+AmCWQ+Zq6OtjGa1+UlVJ7X+R+mxb55BbRwiuL4CLtDGy1
 PsXW9QQv
 t1hoJhqugNLzIRnyr2/q6LD4P2kvAS7+iz1NLcH7eX09z0EyD+NxtzMCrl9jfJPbK4nafRCcZ73r4z3cEh1D33Nce4LN7NcHAz6Tq9fC2Dj8MvP2Lixm0oFQfGDoCt9SWLrDoiS1aAqORHTcRHYodKrkuA1+jxd7CKLya0Up3BoyfB2eJ1EQmlHQZ7tDcqtBTJ0vx0FZy7JxnwSghmJnaIeuRWwQUZSRvkII6SIrR2zXs8A/oDNGweMVKJjlneQlFA32Cusp+3Z3zydxbhiFXrT5SHGxGF8YIU9fiTGo5aEYOiew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

exec_mmap() installs the new mm and then tears the old one down while
still holding exec_update_lock for writing -- and with cred_guard_mutex
held all the way to setup_new_exec():

	setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
	mm_update_next_owner(old_mm);
	mmput(old_mm);

Neither lock is needed for this. exec_update_lock only exists to make the
mm swap atomic with the later commit_creds(), so that permission-checking
readers (proc, ptrace, the futex robust list, perf, kcmp, mm_access())
never observe the new mm together with the old credentials. Those readers
all operate on task->mm, i.e. the new mm after the swap; none looks at the
detached old mm, its ->owner or signal->maxrss. cred_guard_mutex guards
credential calculation and is equally irrelevant here.

The cost is real: __mmput() runs exit_mmap() over the entire old address
space and can block in exit_aio() waiting for in-flight AIO, all while
holding exec_update_lock for writing and cred_guard_mutex. For execve() of
a large process this blocks ptrace_attach() and every exec_update_lock
reader for the duration of the teardown.

Stash the old mm in bprm->old_mm and release it from setup_new_exec()
after both locks are dropped. setup_new_exec() still runs before
setup_arg_pages() and the segment mappings, so the old address space is
freed before the new one is populated and peak memory is unchanged. The
ordering constraints are kept: old_mm's mmap_lock is still dropped in
exec_mmap() before mm_update_next_owner() (required since commit
31a78f23bac0 ("mm owner: fix race between swapoff and exit")), and
mm_update_next_owner() still precedes mmput(); both run in the execing
task's context, as mm_update_next_owner() requires.

If exec swaps the mm but fails before setup_new_exec() runs the old mm
would leak, so add a backstop in free_bprm(). The lazy-tlb case
(old_mm == NULL, e.g. kernel_execve()) has no address space to
free and is left in exec_mmap().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 32 +++++++++++++++++++++++++-------
 include/linux/binfmts.h |  1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9e7f25e2cd41..824b46c069ae 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -836,16 +836,18 @@ EXPORT_SYMBOL(read_code);
 /*
  * Maps the mm_struct mm into the current task struct.
  * On success, this function returns with exec_update_lock
- * held for writing.
+ * held for writing. The replaced address space is stashed in
+ * bprm->old_mm for setup_new_exec() to release outside the lock.
  */
-static int exec_mmap(struct mm_struct *mm, struct user_namespace *user_ns)
+static int exec_mmap(struct linux_binprm *bprm)
 {
 	struct task_exec_state *exec_state __free(put_task_exec_state) = NULL;
+	struct mm_struct *mm = bprm->mm;
 	struct task_struct *tsk;
 	struct mm_struct *old_mm, *active_mm;
 	int ret;
 
-	exec_state = alloc_task_exec_state(user_ns);
+	exec_state = alloc_task_exec_state(bprm->user_ns);
 	if (!exec_state)
 		return -ENOMEM;
 
@@ -898,15 +900,22 @@ static int exec_mmap(struct mm_struct *mm, struct user_namespace *user_ns)
 	if (old_mm) {
 		mmap_read_unlock(old_mm);
 		BUG_ON(active_mm != old_mm);
-		setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
-		mm_update_next_owner(old_mm);
-		mmput(old_mm);
+		/* Defer teardown to setup_new_exec(), outside the exec locks. */
+		bprm->old_mm = old_mm;
 		return 0;
 	}
 	mmdrop_lazy_tlb(active_mm);
 	return 0;
 }
 
+/* Release the address space replaced by exec, outside the exec locks. */
+static void exec_mm_put_old(struct mm_struct *old_mm)
+{
+	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
+	mm_update_next_owner(old_mm);
+	mmput(old_mm);
+}
+
 static int de_thread(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
@@ -1155,7 +1164,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * Release all of the old mmap stuff
 	 */
 	acct_arg_size(bprm, 0);
-	retval = exec_mmap(bprm->mm, bprm->user_ns);
+	retval = exec_mmap(bprm);
 	if (retval)
 		goto out;
 
@@ -1338,6 +1347,12 @@ void setup_new_exec(struct linux_binprm * bprm)
 	me->mm->task_size = TASK_SIZE;
 	up_write(&me->signal->exec_update_lock);
 	mutex_unlock(&me->signal->cred_guard_mutex);
+
+	/* The exec locks are dropped: release the old address space now. */
+	if (bprm->old_mm) {
+		exec_mm_put_old(bprm->old_mm);
+		bprm->old_mm = NULL;
+	}
 }
 EXPORT_SYMBOL(setup_new_exec);
 
@@ -1394,6 +1409,9 @@ static void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	/* exec swapped the mm but failed before setup_new_exec() freed it */
+	if (bprm->old_mm)
+		exec_mm_put_old(bprm->old_mm);
 	do_close_execat(bprm->file);
 	if (bprm->executable)
 		fput(bprm->executable);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index a8379f4eee61..2c77e383e737 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -25,6 +25,7 @@ struct linux_binprm {
 	struct page *page[MAX_ARG_PAGES];
 #endif
 	struct mm_struct *mm;
+	struct mm_struct *old_mm;	/* replaced address space, freed by setup_new_exec() */
 	/* user_ns published to task->exec_state at execve, narrowed by would_dump(). */
 	struct user_namespace *user_ns;
 	unsigned long p; /* current top of mem */

---
base-commit: 2a30fad67ac4748784f417aee3d003c24bbf3293
change-id: 20260522-work-exit_mm-cca054e393b4


