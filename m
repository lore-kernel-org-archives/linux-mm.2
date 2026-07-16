Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89B3C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6200A6B00AA; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7786B00AB; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF496B00AE; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7496B00AB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2E76A0219
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:42:26 +0000 (UTC)
X-FDA: 84994905492.08.2EB94BD
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id EA87E180002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:42:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Z47C+ajA;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cp63P58EqhNMliQrQZQ8Q/9YAZ3f8xxYXqwfnDAFFKc=;
	b=DOeUTGQPM85Lss8w4dCGMNk7R+jzMB6Zp0fchtgQsdvVCYCzjCEDZv6DvQ7pWC8nLv2lKL
	COm8/FYtvB1t4V28PdCOTA6GCkr2avZMssXWDrkzl9AEkGB+qB5K08nqDjgP72kmWIU1fn
	BOS156qsQ/As8VSgfayVT5zFnkKPskU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Z47C+ajA;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212945;
	b=hsjB09uIfjNQWPKJyfB/2fYNx1OW34Z9zlEh5P32CAFcUPea+Lu7ptzJBDoniweFZ43Ks3
	SZZBrwozwE82It0J1DqLm0k9Y9MaodRsheCLEfB2Dsql/gGGWSQxq2nGdtecF6qO88sPOI
	kUTC8SDJkQf2nZVtXxUrQYNTTKlBt7s=
ARC-Seal: i=1; a=rsa-sha256; t=1784212509; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WnufU84/GEgtpIBGEeik9vP9s0BAzuJ7ev6IvIGA6iA9Zd9YHdMx52tIFRXNerGqAjgTcFwERIZjk/lRB5gTqCbghz/qUGQWmKvhulqJX4QAEVkruttdPAN1wnY8/qrhAygUBwOW1twWZkr7l8TAKrdR9Z4rbgEsCxn0mwEdOcs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212509; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cp63P58EqhNMliQrQZQ8Q/9YAZ3f8xxYXqwfnDAFFKc=; 
	b=btpuqHAYbrWq+/gjrhjNrLaB2NMUJwoWyq7SQW7+A0i9alf/vU2eA3jImbgAVNx2ghJihFIRcst4SdiYrYFdcZrSji/lr3mgAL1/fk6zLcH2Lpx0ZaDL7u7vbF6Y2YHMqe1frlOyWUD9Z1XkrLJ+tUpcjexizw4pmtu2IpXfZeA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212509;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=cp63P58EqhNMliQrQZQ8Q/9YAZ3f8xxYXqwfnDAFFKc=;
	b=Z47C+ajA0NslEJATMGE6sw6Pu/nXEAH4kow1xkWyUD+8Ki/hOqu3EtOJsR//9utK
	qto1QZ/oCo8IP9oSNax70Lf7Cgi5x3L7j5T6tHlPRwXShZROEaiSLgVwuaS9ihzg98X
	pHkZQ3XGF0DSJduNdQ4+jgkkwV7vubKDAIlcifvU=
Received: by mx.zohomail.com with SMTPS id 1784212507685649.0367584656693;
	Thu, 16 Jul 2026 07:35:07 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 18/24] pidfd: make spawn builder execution signal-safe
Date: Thu, 16 Jul 2026 22:31:44 +0800
Message-ID: <9689970b5b584db83756cb38608027876154b92a.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA87E180002
X-Stat-Signature: 9du58xwemuzees89h16ycmub9jiqop6z
X-HE-Tag: 1784212944-107265
X-HE-Meta: U2FsdGVkX198D4gmXsrMHoiZDi6xmq/k7I9nRmiIw8GQ3oW0Oib72VP+8FLbty2sAG7HxBoaO0atseuDHMTeMA9ETjYJlxPzYkVT/1pE60WLh2cq9K5G7Zjq23pqp+16oFcTuCVR62U9DkgeAY+HJ6toadsZrvspp3odwYp2Dp4vSXSdWYmaQu4MvkiwZkd/Ld+6mlIRx2LIqNhwqeONMJQHaoRysCj9m0iXkYw2jD9itDOW2Dq4VSTgpbkN2lNIWWsAOsFr3x98IwDVyuLEcpfHKxN9GiPmaxNHc1p+DdXWMfLWE5UAlAV3WmfqzWD27NaMni2eF2n9YVnrBcA1HvhoObBJpxeSe3yDg98mS0HqLHv2v91GrEFK/SeBhK+Gr23S/vmugfVDLd2PmdFSBhqtaaGgNEUKe/wgF69zehjrfw7vyeh6EY5UJjGORnoMUgYROxGW6XXD/BMZxovqeQi0jp+ZKI545xGktE87sy/b5egGA73WGxz4xkAmZXKa+UqzcM8K/i55D3UErSbd4lmqqDSc0Gr+4aPDBZUiosdzJXcry9qUQO7cPYZJCF/YR/8IyeNS4euFwFPjcYXD31cgvydD5BP6cN5UHC8DcP+hZHWVqaR1jpBn1vQoDnjnevS/PgSDdhRojsBikG6lsaGhsO4MFr4Sp92TMrAxltCrZTZf7m49zNHEtVsDz3KHdmr30zqz02OLpCvvCi86+u81LZ5qF/HceDZm1UPOqlQbw168cNGoegKCaT3WLLNBgCi5YHraJDRw0LvRAK8fa7XvzD2icHDRUkv7lIL8Ck2fMCSezif2rS2t5GCCUtXaJqos4Mh3xdJQ4nawNasmE9fiMSTSXyUm7/2o2794YIpJvoTXdwEbuuxdUeJKxTIYcid6o+JyaKcJ6zeUz+Crr0aMSEJW8z6fBklrHXrR+1RAupu1+Ir+fmX9WaRJecSWlSuC0UdKNSEszGys3aq
 +InwLorj
 F8PxdCzfMi/w6n/7eK4XGNsROOLBM+r7dNImJdW1vMqH+80lEDAStiPbU/wURiMy5rUtVCVF79SxfzrX8u0dhrzvJ5mTxJxl8UjFPtVESOOWaCMcoUqZHh2A3C1KJatv7u62lhrIGv5iFTEZKftvQkJeBb+j6HK4OGxJVakRyDG/2NJblMbg8FcCOYKnI8g1GIuOYhSPU5Uo+P03dl0Z+7irILIh8WG/dQmmqQUceya76yC3nUr4pmCEJXyzBdLzVZ9ZeRx3o0VE5hqIwsTO+VLwos343BVlCy3tvWlhnoD2gbF8zpNggBkZUDOlbziMZF8Qu/+OxsuVfMSrvAvRzE1/L+Jz1zpcnnuIMLUEqy7ldYzT2AAcDyPKsJZpYVLQ+pUDmD454Czo+lIRynCPqOim7Xn2Wv8CK7EXtCWppNtUAEroMbrUAAg8zjMt4rvb3RJva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wait for child setup in a killable and freezable state. If the caller
is interrupted after task creation, cancel a child that is still
setting up and normalize restart errors because the spawn operation is
not idempotent.

Preserve externally delivered fatal signals over setup errors. Complete
the builder and audit transaction before entering the signal core
directly, so the callback never returns through an invalid userspace
frame. The task work can run from an outer get_signal(), so fatal delivery
deliberately nests get_signal(); the inner path exits and never returns to
the outer call. The child remains embryonic and nondumpable until exec
installs a valid frame and mm.

Reject an already traced caller while holding cred_guard_mutex across
the spawn operation. This prevents CLONE_UNTRACED from becoming an
escape from an existing ptrace supervisor.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 189 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 183 insertions(+), 6 deletions(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 5586926988406..0e52503976c0c 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -5,6 +5,7 @@
 
 #include <asm/syscall.h>
 #include <linux/audit.h>
+#include <linux/cgroup.h>
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
@@ -212,8 +213,10 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	state->envp = native_arg(NULL);
 	memset(state->audit_args, 0, sizeof(state->audit_args));
 	state->audit_syscall = 0;
-	state->result = result;
-	pidfd_spawn_set_status(state, PIDFD_SPAWN_SETUP_DONE);
+	if (pidfd_spawn_get_status(state) != PIDFD_SPAWN_CANCELLED) {
+		state->result = result;
+		pidfd_spawn_set_status(state, PIDFD_SPAWN_SETUP_DONE);
+	}
 	mutex_unlock(&state->lock);
 
 	putname(filename);
@@ -226,6 +229,32 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	kfree(staged_path);
 }
 
+static bool pidfd_spawn_cancel(struct pidfd_spawn_state *state,
+			       struct task_struct *task)
+{
+	bool cancelled = false;
+
+	mutex_lock(&state->lock);
+	if (pidfd_spawn_get_status(state) == PIDFD_SPAWN_STARTING) {
+		/*
+		 * Establish SIGKILL group-exit state before publishing
+		 * cancellation. The child also takes state->lock before committing
+		 * its setup result, so it cannot return from task work before the
+		 * signal is pending.
+		 */
+		if (WARN_ON_ONCE(do_send_sig_info(SIGKILL, SEND_SIG_PRIV, task,
+						  PIDTYPE_PID)))
+			goto out_unlock;
+		state->result = -ECANCELED;
+		pidfd_spawn_set_status(state, PIDFD_SPAWN_CANCELLED);
+		cancelled = true;
+	}
+out_unlock:
+	mutex_unlock(&state->lock);
+
+	return cancelled;
+}
+
 static bool pidfd_spawn_same_pid_ns(struct pidfd_spawn_state *state)
 {
 	return current->nsproxy->pid_ns_for_children == state->creator_pid_ns;
@@ -383,6 +412,35 @@ SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
 	return ret;
 }
 
+static bool pidfd_spawn_child_cancelled(struct pidfd_spawn_state *state)
+{
+	bool cancelled;
+
+	mutex_lock(&state->lock);
+	cancelled = pidfd_spawn_get_status(state) == PIDFD_SPAWN_CANCELLED;
+	mutex_unlock(&state->lock);
+
+	return cancelled;
+}
+
+static bool pidfd_spawn_setup_done(struct pidfd_spawn_state *state)
+{
+	bool done = false;
+
+	mutex_lock(&state->lock);
+	switch (pidfd_spawn_get_status(state)) {
+	case PIDFD_SPAWN_SETUP_DONE:
+	case PIDFD_SPAWN_STARTED:
+		done = true;
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&state->lock);
+
+	return done;
+}
+
 static void pidfd_spawn_save_audit_context(struct pidfd_spawn_state *state)
 {
 	struct pt_regs *regs = current_pt_regs();
@@ -399,6 +457,52 @@ static void pidfd_spawn_audit_entry(struct pidfd_spawn_state *state)
 				state->audit_args[1], state->audit_args[2],
 				state->audit_args[3]);
 }
+
+static int pidfd_spawn_normalize_result(int result)
+{
+	if (result == -ERESTARTSYS || result == -ERESTARTNOINTR ||
+	    result == -ERESTARTNOHAND || result == -ERESTART_RESTARTBLOCK)
+		return -EINTR;
+	return result;
+}
+
+static int pidfd_spawn_pending_fatal_signal(void)
+{
+	struct sighand_struct *sighand;
+	sigset_t pending;
+	unsigned long flags;
+	int fatal = 0;
+	int sig;
+
+	/*
+	 * fatal_signal_pending() only recognizes pending SIGKILL. A default-fatal
+	 * coredump signal remains pending as itself, but must still win over a
+	 * setup error. Inspect the same pending sets and default dispositions as
+	 * get_signal() without dequeuing the signal.
+	 */
+	sighand = lock_task_sighand(current, &flags);
+	if (WARN_ON_ONCE(!sighand))
+		return 0;
+
+	sigorsets(&pending, &current->pending.signal,
+		  &current->signal->shared_pending.signal);
+	sigandnsets(&pending, &pending, &current->blocked);
+
+	for (sig = 1; sig < _NSIG; sig++) {
+		if (!sigismember(&pending, sig) || sig_kernel_ignore(sig) ||
+		    sig_kernel_stop(sig) ||
+		    sighand->action[sig - 1].sa.sa_handler != SIG_DFL)
+			continue;
+		if ((current->signal->flags & SIGNAL_UNKILLABLE) &&
+		    !sig_kernel_only(sig))
+			continue;
+		fatal = sig;
+		break;
+	}
+	spin_unlock_irqrestore(&sighand->siglock, flags);
+	return fatal;
+}
+
 static void pidfd_spawn_finish_child(struct pidfd_spawn_state *state,
 				     struct filename *filename, int result)
 {
@@ -406,11 +510,40 @@ static void pidfd_spawn_finish_child(struct pidfd_spawn_state *state,
 	complete_all(&state->done);
 }
 
+static __noreturn void
+pidfd_spawn_deliver_fatal_signal(struct pidfd_spawn_state *state,
+				 struct filename *filename, int sig)
+{
+	struct ksignal ksig;
+	sigset_t blocked;
+
+	/*
+	 * The callback frame is not a valid userspace signal frame on every
+	 * architecture. Complete the spawn transaction, then enter the signal
+	 * core directly instead of returning through the callback trampoline.
+	 *
+	 * The embryonic task state prevents ptrace access and coredumps until exec
+	 * installs a valid userspace frame and private mm. Block other catchable
+	 * signals so the selected default-fatal signal remains terminal. If the
+	 * signal core unexpectedly returns, exit without exposing the frame.
+	 */
+	pidfd_spawn_finish_child(state, filename, 0);
+	audit_pidfd_spawn_exit(0, -EINTR);
+	pidfd_spawn_state_put(state);
+
+	sigfillset(&blocked);
+	sigdelset(&blocked, sig);
+	set_current_blocked(&blocked);
+	get_signal(&ksig);
+	do_group_exit(PIDFD_SPAWN_EXIT_FAILURE);
+}
+
 static void pidfd_spawn_child(struct callback_head *work)
 {
 	struct pidfd_spawn_state *state =
 		container_of(work, struct pidfd_spawn_state, task_work);
 	struct filename *filename;
+	int fatal_sig;
 	int ret;
 
 	pidfd_spawn_audit_entry(state);
@@ -420,9 +553,27 @@ static void pidfd_spawn_child(struct callback_head *work)
 	else
 		ret = 0;
 
+	if (pidfd_spawn_child_cancelled(state)) {
+		ret = -ECANCELED;
+		pidfd_spawn_finish_child(state, filename, ret);
+		audit_pidfd_spawn_exit(0, ret);
+		pidfd_spawn_state_put(state);
+		do_group_exit(SIGKILL);
+	}
+	fatal_sig = pidfd_spawn_pending_fatal_signal();
+	if (fatal_sig)
+		pidfd_spawn_deliver_fatal_signal(state, filename, fatal_sig);
+
 	if (!ret)
 		ret = do_execveat_common(AT_FDCWD, filename,
 					 state->argv, state->envp, 0);
+	ret = pidfd_spawn_normalize_result(ret);
+	if (ret) {
+		fatal_sig = pidfd_spawn_pending_fatal_signal();
+		if (fatal_sig)
+			pidfd_spawn_deliver_fatal_signal(state, filename,
+							 fatal_sig);
+	}
 
 	pidfd_spawn_finish_child(state, filename, ret);
 	if (ret) {
@@ -531,9 +682,16 @@ static void pidfd_spawn_attach_vfork_done(struct task_struct *task,
 	task_unlock(task);
 }
 
-static void pidfd_spawn_wait_for_child(struct pidfd_spawn_state *state)
+static int pidfd_spawn_wait_for_child(struct pidfd_spawn_state *state)
 {
-	wait_for_completion(&state->done);
+	unsigned int wait_state = TASK_KILLABLE | TASK_FREEZABLE;
+	int ret;
+
+	cgroup_enter_frozen();
+	ret = wait_for_completion_state(&state->done, wait_state);
+	cgroup_leave_frozen(false);
+
+	return pidfd_spawn_normalize_result(ret);
 }
 
 static int pidfd_spawn_finish_vfork(struct pidfd_spawn_state *state,
@@ -544,7 +702,7 @@ static int pidfd_spawn_finish_vfork(struct pidfd_spawn_state *state,
 
 	ret = wait_for_vfork_done(task, vfork);
 	if (ret)
-		return ret;
+		return pidfd_spawn_normalize_result(ret);
 
 	mutex_lock(&state->lock);
 	ret = state->result;
@@ -624,7 +782,26 @@ static int pidfd_spawn_start(struct file *file,
 	}
 
 	wake_up_new_task(task);
-	pidfd_spawn_wait_for_child(state);
+	ret = pidfd_spawn_wait_for_child(state);
+	if (ret) {
+		int interrupt = ret;
+
+		if (pidfd_spawn_setup_done(state)) {
+			if (pidfd_spawn_finish_vfork(state, task, &vfork))
+				return interrupt;
+			return 0;
+		}
+		if (!pidfd_spawn_cancel(state, task) &&
+		    pidfd_spawn_setup_done(state)) {
+			if (pidfd_spawn_finish_vfork(state, task, &vfork))
+				return interrupt;
+			return 0;
+		}
+
+		/* Drop the stack-based completion without waiting for child setup. */
+		wait_for_vfork_done(task, &vfork);
+		return interrupt;
+	}
 	return pidfd_spawn_finish_vfork(state, task, &vfork);
 }
 
-- 
2.52.0


