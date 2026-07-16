Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDF0C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0136B00DD; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7016B00DF; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCAE6B00E0; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFA86B00DD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC29BA01CD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:43:34 +0000 (UTC)
X-FDA: 84994908348.13.DD85ED9
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 147BD1C000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:43:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="rF//SdgF";
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf18.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGGGL3d8SQPrkB1m/EUNgroSarrv1D2lcVuouiN3SxY=;
	b=tmroVsyzXq3NnSCTasyoDZKo9NggcCqHI2oFhFOtDUvB5PkWC6YFY38g7BNbgSexv6rqYM
	6AzYxsRqfh7CRG2bgMn5Zk7Z14U3xQRnsj2bT+dczoWa+usERSQGYR4ocSy68yMbzb37pz
	NgoBPN9SayDbhqFgLGKWKYsaJ+Z0k98=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="rF//SdgF";
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf18.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784213013;
	b=tLDmXluQT1cUspY3RuGIt1au8rCr6W3PrOCGdJoqbG+Tn1F6OKFe/NPeT3+ODZ0iNRtuox
	vd/ulvzVD9Hzz3PeAhxlyT/G19fbvUSumCZ/09l7yjyZB0Kdt/vdyTQQ1dqV9ZSlPHiUw1
	A0IH7Jq7rForwrem6Q0bTZ6kfwRx7YI=
ARC-Seal: i=1; a=rsa-sha256; t=1784212529; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=APwL2Kory6LxGwxE2Np0jQSgi3eymN5zy/9IRRYXqP6sbLiMmYLJmdcTj42oHQMlryKZNCY9pnHw/2rGZDr+06bNDBUDHK2Ykx/+J4+yXLHA/KZnKu+6pVYla+3EpJBGeIdNtIqSmtz93FiHY+NWgMPObvuTaBTl+16WUhH7BVI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212529; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bGGGL3d8SQPrkB1m/EUNgroSarrv1D2lcVuouiN3SxY=; 
	b=hX/f7XuKg42bXQtPuPQtqwB49lcC7bjGkt7HmNbB887UObR8oTVUG9+l088Dq+e3vzw5LRM/4tCxMqxKgKbOtwxCZRunrJ9n++txhjG5plj8W3bycnq+26jm5G/cOjSPWwz4RqqHw9aY8lCb03q2aUl0UGBRjoEdwuyV5EmJ5hU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212529;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=bGGGL3d8SQPrkB1m/EUNgroSarrv1D2lcVuouiN3SxY=;
	b=rF//SdgFtcD9t/RheCbrjsFCmf/0Fu8DJx5xVxIwgwIrA01PiReAGKNXw+a9cTFf
	DpkWjeenzLpKdxvf3pKG6HqICeiZhvsJ4TFLSBFBMfAKoHLav+MFeL66yo6t00sylSi
	Xegr3Ll7xJDyY7W2lOD5sTeSL426kIL4EWBI9DMM=
Received: by mx.zohomail.com with SMTPS id 178421252661435.43741550150605;
	Thu, 16 Jul 2026 07:35:26 -0700 (PDT)
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
Subject: [RFC PATCH 20/24] pidfd: add initial spawn file actions
Date: Thu, 16 Jul 2026 22:31:46 +0800
Message-ID: <263bb4b019eea28c71fdf66d70bf069fc6ed4d41.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 147BD1C000C
X-Stat-Signature: omcepwux9ph71dxou1qburhi4d55zfpf
X-HE-Tag: 1784213012-940818
X-HE-Meta: U2FsdGVkX1/F7KXGxBS+5sp50tzueMOaRpn37z24FkIOvmtVGYm017yFkyz4tRIiZ+CQP8z2RckZHOXqFRGI8bhbL4a2mhH9d3udJ+NaOzCSi/CeAZlph/P6q29v33QTPr/SQsxI+KVc63ozUq76SB+yeqRpTCyGwUS42r+yMJRUBgDRQt+3Iz5VWHOI+t+VagsjCHlah5HFsZTEhXrS5r3QVNHfYco8SJwVRUc0xPo0YJuXUfx8ri8o+Ff602oC+qj81NCIJCCCnjhGSHnSrHC9aGh8NLkiLCz/K81ayP9Qdv/hEJTHOizZPBUpsuLBPuIZ3KUzHDx+52PWUc/8tssdsPm5diU68R595CoaUD2naF6R9bQvb8ZRChr1Hjx6AYb/1d5/Zcx9hpWZbMXX4PU4NZAXDVALM9WoWuVOaewHVSgl6K48TukTZX+4Zq0vkXH1rKqY68jV97//TMFvg/nDd8iTzZ2tnam2l29eiLEpeVtaz2b5aEuiGUPRdu3EDhxjIlGmkc6zUrhZOxOkqqXYnL6ySAYASZI0KHik7O6X/DZ9Jlh9gZAsHgn7A4dn4kPULTWNhLLqZDzvyYIBViei3cNZjPkXQrEQ61J8hHbqF1lwK5akYNnAotcSX3zS133OR5OaF3GbmyRq9CTuBsP3Qq01iK8OBxPBbBZkx5BT38oi4uQGjI+NZKRyRxnzDJRLOujKZ+wnBKuJX5ivbZSdsReE19oQEOmXMjxRBypd8vUQKWnlYTNB2u+nRh4NEVGJ7xheTN6Oe6KQ79L+XLTIArK8uC8au9csR2Jqx+7DpmoF6E3LLG1KnLm9Ndnv9sSwAfvW7zO9fPwa1tJw+nB7pL5QOx26yY1xD8TC4qXc0Kc9fOnrDFI4FRmLzDwjl9tgVdi+pDyS6mK6jy/DIR2J2zCJXmC7NxNgm7rqZEpo1tA75KksxubQFXHbb4TcsB7P9LceaFhrEdifMeb
 C567khqO
 E9+FoHwq9GNCWrXns7sXJJI9eXXwDnIb5XYoIyfIopzFMZGQ51VBUHLm/MruMfyLjWFSYDk9x1uyESkal8EswWoDNxkz0BiW4plObnalfgm6LwgdQYowCSsL0mag/aEGhZ5uLto7evmlf//lbyWTGeF5AkqBiWMvEVdeytl66bTOngMf4iHsV5W33+O/+shtXLZzT52sqSzx+PgVOsyTJjKXC5MRlM/Zs/PQrhcitp/xYgteW7xKE4LfVn4EQnpP3DNlj/Zbo+uS/bHS1QsExZunRLxqNRPHxeE3XDuuY94bPPc6Bbbd0XSUOnHL/DSs7noPsNUpU/b7U4AHgelxtFKISBQ2mtQvVTl/fozUHrzGr7Qa03UvUn4ArjS36Mp6BKxVlBC1b6DI0amkafVN2nplwe9eUCY6INW5qimKHlwlTFBDE5AoaFdxOmS03Z0FdRf1cYBXD5Arx1bwoXk8qa+ri4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow pidfd_spawn_run() to apply an ordered list of DUP2, FCHDIR, and
CLOSE_RANGE actions before exec. Copy and validate the complete action
list before creating the child so malformed input cannot leave a
partially started process. Use a versioned action stride so userspace can
pass larger future records. Bound the payload by 64 KiB instead of a fixed
action count, keeping allocation bounded without imposing an arbitrary
limit on small records.

Apply actions before completing the delayed executable name. This makes an
FCHDIR action establish the cwd used by both relative executable lookup and
the child transaction's AUDIT_CWD record.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 171 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 163 insertions(+), 8 deletions(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 0e52503976c0c..3e46a12c0ba07 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -5,9 +5,11 @@
 
 #include <asm/syscall.h>
 #include <linux/audit.h>
+#include <linux/close_range.h>
 #include <linux/cgroup.h>
 #include <linux/completion.h>
 #include <linux/cred.h>
+#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -23,15 +25,18 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/security.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/task_work.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 #include <uapi/linux/pidfd.h>
 #include <uapi/linux/wait.h>
 #include <trace/events/sched.h>
 
 #include "exec_internal.h"
+#include "internal.h"
 
 static inline void __user *pidfd_spawn_user_ptr(__u64 p)
 {
@@ -59,6 +64,9 @@ static inline struct user_arg_ptr pidfd_spawn_user_arg(__u64 p)
 
 #define PIDFD_SPAWN_EXIT_FAILURE	(127 << 8)
 #define PIDFD_SPAWN_MAX_CONFIG_KEY_SIZE	256
+/* Bound allocation without imposing a fixed number of action records. */
+#define PIDFD_SPAWN_MAX_ACTIONS_SIZE	SZ_64K
+
 DEFINE_FREE(pidfd_spawn_dismiss_filename, struct delayed_filename,
 	    dismiss_delayed_filename(&_T))
 
@@ -82,9 +90,11 @@ struct pidfd_spawn_state {
 	struct pid_namespace *creator_pid_ns;
 	struct delayed_filename filename;
 	char *staged_path;
+	struct pidfd_spawn_action *actions;
 	struct user_arg_ptr argv;
 	struct user_arg_ptr envp;
 	unsigned long audit_args[4];
+	unsigned int nr_actions;
 	int audit_syscall;
 	int result;
 	enum pidfd_spawn_status status;
@@ -139,6 +149,7 @@ static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
 		put_cred(state->creator_cred);
 	if (state->creator_pid_ns)
 		put_pid_ns(state->creator_pid_ns);
+	kvfree(state->actions);
 	put_pid(state->pid);
 	kfree(state);
 }
@@ -192,6 +203,7 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 				      struct filename *filename, int result)
 {
 	const struct cred *creator_cred;
+	struct pidfd_spawn_action *actions;
 	struct mm_struct *creator_mm;
 	struct pid_namespace *creator_pid_ns;
 	char *staged_path;
@@ -201,14 +213,17 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	 * after the child no longer needs the shared setup payload.
 	 */
 	mutex_lock(&state->lock);
+	actions = state->actions;
 	creator_mm = state->creator_mm;
 	creator_cred = state->creator_cred;
 	creator_pid_ns = state->creator_pid_ns;
 	staged_path = state->staged_path;
+	state->actions = NULL;
 	state->creator_mm = NULL;
 	state->creator_cred = NULL;
 	state->creator_pid_ns = NULL;
 	state->staged_path = NULL;
+	state->nr_actions = 0;
 	state->argv = native_arg(NULL);
 	state->envp = native_arg(NULL);
 	memset(state->audit_args, 0, sizeof(state->audit_args));
@@ -227,6 +242,7 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	if (creator_pid_ns)
 		put_pid_ns(creator_pid_ns);
 	kfree(staged_path);
+	kvfree(actions);
 }
 
 static bool pidfd_spawn_cancel(struct pidfd_spawn_state *state,
@@ -441,6 +457,114 @@ static bool pidfd_spawn_setup_done(struct pidfd_spawn_state *state)
 	return done;
 }
 
+static int pidfd_spawn_validate_action(const struct pidfd_spawn_action *action)
+{
+	if (action->reserved[0] || action->reserved[1])
+		return -EINVAL;
+
+	switch (action->type) {
+	case PIDFD_SPAWN_ACTION_DUP2:
+		if (action->flags)
+			return -EINVAL;
+		return 0;
+	case PIDFD_SPAWN_ACTION_FCHDIR:
+		if (action->flags || action->newfd)
+			return -EINVAL;
+		return 0;
+	case PIDFD_SPAWN_ACTION_CLOSE_RANGE:
+		if (action->newfd < action->fd)
+			return -EINVAL;
+		if (action->flags & ~(CLOSE_RANGE_UNSHARE |
+				      CLOSE_RANGE_CLOEXEC))
+			return -EINVAL;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int pidfd_spawn_copy_actions(struct pidfd_spawn_action **actions,
+				    __u64 uactions, unsigned int nr_actions,
+				    unsigned int action_size)
+{
+	const char __user *uptr;
+	struct pidfd_spawn_action *kactions __free(kvfree) = NULL;
+	unsigned int i;
+	int ret;
+
+	if (!nr_actions)
+		return 0;
+
+	BUILD_BUG_ON(sizeof(struct pidfd_spawn_action) !=
+		     PIDFD_SPAWN_ACTION_SIZE_VER0);
+
+	uptr = pidfd_spawn_user_ptr(uactions);
+	kactions = kvmalloc_array(nr_actions, sizeof(*kactions),
+				  GFP_KERNEL_ACCOUNT);
+	if (!kactions)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_actions; i++) {
+		ret = copy_struct_from_user(&kactions[i], sizeof(kactions[i]),
+					    uptr + (size_t)i * action_size,
+					    action_size);
+		if (ret)
+			return ret;
+
+		ret = pidfd_spawn_validate_action(&kactions[i]);
+		if (ret)
+			return ret;
+	}
+
+	*actions = no_free_ptr(kactions);
+	return 0;
+}
+
+static int pidfd_spawn_do_dup2(unsigned int oldfd, unsigned int newfd)
+{
+	struct file *file __free(fput) = NULL;
+
+	file = fget_raw(oldfd);
+	if (!file)
+		return -EBADF;
+	if (oldfd == newfd) {
+		set_close_on_exec(newfd, 0);
+		return 0;
+	}
+
+	return replace_fd(newfd, file, 0);
+}
+
+static int pidfd_spawn_apply_actions(struct pidfd_spawn_state *state)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < state->nr_actions; i++) {
+		const struct pidfd_spawn_action *action = &state->actions[i];
+
+		switch (action->type) {
+		case PIDFD_SPAWN_ACTION_DUP2:
+			ret = pidfd_spawn_do_dup2(action->fd, action->newfd);
+			break;
+		case PIDFD_SPAWN_ACTION_FCHDIR:
+			ret = do_fchdir(action->fd);
+			break;
+		case PIDFD_SPAWN_ACTION_CLOSE_RANGE:
+			ret = do_close_range(action->fd, action->newfd,
+					     action->flags);
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			break;
+		}
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static void pidfd_spawn_save_audit_context(struct pidfd_spawn_state *state)
 {
 	struct pt_regs *regs = current_pt_regs();
@@ -543,24 +667,32 @@ static void pidfd_spawn_child(struct callback_head *work)
 	struct pidfd_spawn_state *state =
 		container_of(work, struct pidfd_spawn_state, task_work);
 	struct filename *filename;
+	bool cancelled;
 	int fatal_sig;
 	int ret;
 
 	pidfd_spawn_audit_entry(state);
+	cancelled = pidfd_spawn_child_cancelled(state);
+	fatal_sig = 0;
+	ret = 0;
+	if (!cancelled) {
+		fatal_sig = pidfd_spawn_pending_fatal_signal();
+		if (!fatal_sig)
+			ret = pidfd_spawn_apply_actions(state);
+	}
+
+	/* FCHDIR must establish the cwd captured by audit_getname(). */
 	filename = complete_getname(&state->filename);
-	if (IS_ERR(filename))
+	if (!ret && !cancelled && !fatal_sig && IS_ERR(filename))
 		ret = PTR_ERR(filename);
-	else
-		ret = 0;
 
-	if (pidfd_spawn_child_cancelled(state)) {
+	if (cancelled) {
 		ret = -ECANCELED;
 		pidfd_spawn_finish_child(state, filename, ret);
 		audit_pidfd_spawn_exit(0, ret);
 		pidfd_spawn_state_put(state);
 		do_group_exit(SIGKILL);
 	}
-	fatal_sig = pidfd_spawn_pending_fatal_signal();
 	if (fatal_sig)
 		pidfd_spawn_deliver_fatal_signal(state, filename, fatal_sig);
 
@@ -589,6 +721,7 @@ static int pidfd_spawn_copy_run_args(struct pidfd_spawn_run_args *kargs,
 				     struct pidfd_spawn_run_args __user *uargs,
 				     size_t usize)
 {
+	size_t actions_size;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct pidfd_spawn_run_args) !=
@@ -606,8 +739,17 @@ static int pidfd_spawn_copy_run_args(struct pidfd_spawn_run_args *kargs,
 		return -EINVAL;
 	if (!kargs->argv)
 		return -EINVAL;
-	if (kargs->nr_actions || kargs->actions || kargs->action_size)
+	if (kargs->nr_actions) {
+		if (!kargs->actions ||
+		    kargs->action_size < PIDFD_SPAWN_ACTION_SIZE_VER0 ||
+		    !IS_ALIGNED(kargs->action_size, sizeof(__u64)))
+			return -EINVAL;
+	} else if (kargs->actions || kargs->action_size) {
 		return -EINVAL;
+	}
+	actions_size = array_size(kargs->nr_actions, kargs->action_size);
+	if (actions_size > PIDFD_SPAWN_MAX_ACTIONS_SIZE)
+		return -E2BIG;
 	if (!pidfd_spawn_user_ptr_fits(kargs->path) ||
 	    !pidfd_spawn_user_ptr_fits(kargs->argv) ||
 	    !pidfd_spawn_user_ptr_fits(kargs->envp) ||
@@ -713,10 +855,12 @@ static int pidfd_spawn_finish_vfork(struct pidfd_spawn_state *state,
 
 static int pidfd_spawn_start(struct file *file,
 			     struct pidfd_spawn_state *state,
-			     const struct pidfd_spawn_run_args *kargs)
+			     const struct pidfd_spawn_run_args *kargs,
+			     struct pidfd_spawn_action **actions)
 {
 	struct delayed_filename filename
 		__free(pidfd_spawn_dismiss_filename) = {};
+	struct pidfd_spawn_action *drop_actions __free(kvfree) = NULL;
 	struct delayed_filename drop_filename
 		__free(pidfd_spawn_dismiss_filename) = {};
 	struct kernel_clone_args clone_args = {
@@ -757,8 +901,11 @@ static int pidfd_spawn_start(struct file *file,
 
 		state->argv = pidfd_spawn_user_arg(kargs->argv);
 		state->envp = pidfd_spawn_user_arg(kargs->envp);
+		state->actions = *actions;
+		state->nr_actions = kargs->nr_actions;
 		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
 		pidfd_spawn_save_audit_context(state);
+		*actions = NULL;
 		reinit_completion(&state->done);
 
 		task = pidfd_spawn_create_task(file, state, &clone_args);
@@ -766,6 +913,9 @@ static int pidfd_spawn_start(struct file *file,
 			ret = PTR_ERR(task);
 			drop_filename = state->filename;
 			INIT_DELAYED_FILENAME(&state->filename);
+			drop_actions = state->actions;
+			state->actions = NULL;
+			state->nr_actions = 0;
 			state->argv = native_arg(NULL);
 			state->envp = native_arg(NULL);
 			memset(state->audit_args, 0,
@@ -854,6 +1004,7 @@ int pidfd_empty_open(unsigned int flags)
 SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
 		struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
 {
+	struct pidfd_spawn_action *actions __free(kvfree) = NULL;
 	struct pidfd_spawn_run_args kargs;
 	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
 	int ret;
@@ -869,6 +1020,10 @@ SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
 	state = pidfd_spawn_state_get_file(fd_file(f));
 	if (IS_ERR(state))
 		return PTR_ERR(state);
+	ret = pidfd_spawn_copy_actions(&actions, kargs.actions,
+				       kargs.nr_actions, kargs.action_size);
+	if (ret)
+		return ret;
 
 	scoped_cond_guard(mutex_intr, return -ERESTARTNOINTR,
 			  &current->signal->cred_guard_mutex) {
@@ -877,7 +1032,7 @@ SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
 		ret = pidfd_spawn_check_startable(state);
 		if (ret)
 			return ret;
-		ret = pidfd_spawn_start(fd_file(f), state, &kargs);
+		ret = pidfd_spawn_start(fd_file(f), state, &kargs, &actions);
 	}
 	if (!ret)
 		ret = pid_vnr(state->pid);
-- 
2.52.0


