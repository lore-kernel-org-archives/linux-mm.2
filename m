Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39574C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5686B00E7; Thu, 16 Jul 2026 10:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986E56B00EA; Thu, 16 Jul 2026 10:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8267F6B00EB; Thu, 16 Jul 2026 10:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561686B00E7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17596A01D1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:44:24 +0000 (UTC)
X-FDA: 84994910448.12.04D37E1
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 241A9160006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:44:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=WP2UrJUb;
	spf=pass (imf08.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784213062;
	b=ojoKPum/pNZ+etO7EyZ2d5bboB8LY598D6nhPTFFMiQ2kFK2/MOzk1XKqc1TqBfNgXUWxm
	NBA93ODyYzh7K2jQRCBQ4v2F66wpU91Bg7T+5FFo2+fqNsiQSz4B/SM216j/Y6MxhhT/nH
	WVYgSgZZWrAF9i1jx8pPtruyQS++mZ8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=WP2UrJUb;
	spf=pass (imf08.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=290s3lUtxsTRNn8ivro74GnBQQOXcWg9/LqGiGBD/JE=;
	b=UDYZQWuiuK/K4li74vPwIXvG8wAPXmPtSJxT7l2AyMSSThz639bNS0Y5tv3Z4mfpIO4HLI
	akJDy4tUH9+tJXdSKgsas4Cahcs0aqx6wMDWUv/DHzJWHyvjPA4KPl0lEsvNvBYY8GbNt0
	iwj2tZGoX57WIgqamBt9qzxtDIG5nK8=
ARC-Seal: i=1; a=rsa-sha256; t=1784212539; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Y1A6Pt+xHHCc6RftA1oxacOJWFGI+BHSGYSSzIilKYi44zxyibzMlZx+JFgjaCuIl2X+tsTcOTLhp1njQqNdEHT8eBjIZK/5vpVn3BlfBCJvxx9gns/ezgXVmn9AwLSiXgijV3/rUK/XWdnpYOXaKz/r/OkNMJIB4rMKDbrv9Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212539; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=290s3lUtxsTRNn8ivro74GnBQQOXcWg9/LqGiGBD/JE=; 
	b=fR/XaeXfTU1N2cLozyBjs81xrzUG8XtAbAXU1CLc7XyNeNhn3/NDG8wxlc7uU2sJlcvh3OFbX4UlI7pN3jSg3SHD+OsFxLJNYVKDZ1vp2sk84WCcyLnXeGQJBXgmDgjf+RvXXBm8DRDnL7QoXMEFgJ06+hpNWLKCny4pkjVfqZc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212539;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=290s3lUtxsTRNn8ivro74GnBQQOXcWg9/LqGiGBD/JE=;
	b=WP2UrJUbiLu8S5BIoqWeQ3oKsAnfg+6GHKQe1Uj+MZYX0v39zEVjgf7nqHdgyson
	6Jfto1cKV4coKRtOlwQ19kWrICdvnYj4O/K8/CvgBvKXOGewhe4bjk5Cco/p4rEsyFG
	jMBRYBMg/7dGS0djGkyHDfjrTuj1KI2cpNs9ka6Q=
Received: by mx.zohomail.com with SMTPS id 178421253796522.239109081508104;
	Thu, 16 Jul 2026 07:35:37 -0700 (PDT)
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
Subject: [RFC PATCH 21/24] pidfd: consume spawn builders on the first run attempt
Date: Thu, 16 Jul 2026 22:31:47 +0800
Message-ID: <efb77493eead572a22228a917066917c0a40ba7c.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 241A9160006
X-Stat-Signature: tbrpurzk8mxagysymwjw49t4p41bdtue
X-HE-Tag: 1784213061-654201
X-HE-Meta: U2FsdGVkX19oN7oweN25K74u2ugzqaGkAjbElpi+djAVlVTsOZy0ZmNoxbXjsZchU2LqP8vDsyJNHUUjySdYYEJsryTD8hNAb/2nxJQH9FXq07EH33Xobm0m39FMnwsIyVgAnQw3In1AjII3v577lxBtZbi6/CTtPUsyfaf6d+dfNArtINrcUvkvd/l6m9T91eg0fCAwYXNhKFc9Lu2I01afbgcIf1pTne1cVDnrTJIM2lRxqqLpRs/lDgiF8UCsMvazpXjS6Q4NvpZnNDZDk6Xm8JgZd+g/YWFoX11CK09mMB9dcMCacqw1xiaR4ZrFYBlEbdpE0FuPvzFwnlg2pDdQDXFYfSApIg+wBJReDPoBUmm0blblT7NinkPoIAe6KdkWlMP/F7S3d5l6CLOLyUNrOLu3txIilO/mzEWUXkYjmOXQUtnke1/f1LcmqRbZo3fhyNAAqH+e02P82/vsmnUcqSW3a0bPq7BEYsPyOP7Eu/pZMwr1MR03vUIZTYnmPmw1rTmlbzaOwtGaoPSiCAViFmSSn8Umxyhv43t655y1z/O9kxuwCeX32cQienCXbeGFBvb+FXaUtIU4/5nNn+BYuJMenwxyZYK+dMTdcGnoZVx8pRrckTXqU5lnKBPENIH8ruI8kIoQ208j4/xAaWI7gFpvgUvXJqhneJFzIawSner3E1VdzwimYypnr7YkkrcYZl1dxechoxL8Ig9uBy1NGzPDKC1+lidQwOBCszsqdLjaMIUYbyfgWtkReiQ5bHTdn6rk2MmImC7dF4wPI4ps9Ba7MvjJzoQMhkqa9PaCNqwcsl6gl/z3bEyndK5RRhEXCO01QEFoEVdicX6yhiJkN3hKPCDBz8B4aMtWHecEEQG0lDr73vP/s9CjaxJhVO4VWCDhPAxed6ZiBd2jxrU52odpWmdQ9dCxnLT+TEIp4W1/KKoA6fPsTaVN5jEQufKAzqHCHHuS96Ye3k4
 A67jsZHt
 I9HsT+ayoHpe5smnx3GCncpN4lbt2F6ZKyCWThqdSwRwGjRjeISyet1CP14U+lSdqx5EP3YtBE2aeLDRpwdRpYgW81mlCRq/QDUw/xvYROdS+Vp7gj1FfnzABeOJe7B2u5eySgo6bI8QuVXYJ8A8bRCgyCdQGlV5VJ37RpzK9ZLVv7hbWWq+lEwJAWaPqP9D8EGM6dgSclrCZcSc/KAo68q4TV5FPWYKhcdMNf+6zF3OicyZl7uk7bDOVr5hBn8HdfJEqLyk3PnvmRci5F4c025vipP/CitfLhpA4KHn0MGbK2I0U8V+j+NMyFoKh1P9Gx2jbohtBGCrLXx7h4ovtp4XQRWL97OS4GXTCEDj5cO+RWMTOYBfNPV1ZE8x29Xdo+gdnbEZGkjmdsIljzmvkkgK/CGz43kPPmK/q+BJrsfSIVQOkhxi/1kAkFHVHXSjNc6BB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A pre-task run failure currently returns the builder to CONFIGURING. A
second thread can then publish another invocation before the first
caller probes the pidfd, making the observed process state ambiguous.

Claim the builder after type, authority, and ptrace checks but before
run argument access. Any later validation, uaccess, allocation, or
task-creation failure leaves a terminal taskless builder. Later config
and run operations return EBUSY, while process-dependent pidfd
operations return ESRCH.

Normalize every internal restart error after the claim to EINTR so the
architecture cannot restart a consumed invocation and replace its
result with EBUSY. Preserve normal restart behavior before the claim.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 164 +++++++++++++++++++++++++++++++----------------
 1 file changed, 109 insertions(+), 55 deletions(-)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 3e46a12c0ba07..1309fe99ec091 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -73,6 +73,7 @@ DEFINE_FREE(pidfd_spawn_dismiss_filename, struct delayed_filename,
 enum pidfd_spawn_status {
 	PIDFD_SPAWN_CONFIGURING,
 	PIDFD_SPAWN_STARTING,
+	PIDFD_SPAWN_FAILED_TASKLESS,
 	PIDFD_SPAWN_SETUP_DONE,
 	PIDFD_SPAWN_STARTED,
 	PIDFD_SPAWN_CANCELLED,
@@ -100,6 +101,14 @@ struct pidfd_spawn_state {
 	enum pidfd_spawn_status status;
 };
 
+struct pidfd_spawn_resources {
+	struct pidfd_spawn_action *actions;
+	struct mm_struct *creator_mm;
+	const struct cred *creator_cred;
+	struct pid_namespace *creator_pid_ns;
+	char *staged_path;
+};
+
 static struct pid *
 pidfd_spawn_load_pid(const struct pidfd_spawn_state *state)
 {
@@ -183,8 +192,16 @@ static struct pid *pidfd_spawn_file_pid(void *data)
 	return pid ? pid : ERR_PTR(-ESRCH);
 }
 
+static bool pidfd_spawn_file_terminal(void *data)
+{
+	struct pidfd_spawn_state *state = data;
+
+	return pidfd_spawn_get_status(state) == PIDFD_SPAWN_FAILED_TASKLESS;
+}
+
 static const struct pidfs_future_file_ops pidfd_spawn_future_ops = {
 	.get_pid = pidfd_spawn_file_pid,
+	.is_terminal = pidfd_spawn_file_terminal,
 	.release = pidfd_spawn_state_release,
 };
 
@@ -199,31 +216,47 @@ pidfd_spawn_state_get_file(struct file *file)
 	return state;
 }
 
+static void
+pidfd_spawn_detach_resources(struct pidfd_spawn_state *state,
+			     struct pidfd_spawn_resources *resources)
+{
+	resources->actions = state->actions;
+	resources->creator_mm = state->creator_mm;
+	resources->creator_cred = state->creator_cred;
+	resources->creator_pid_ns = state->creator_pid_ns;
+	resources->staged_path = state->staged_path;
+	state->actions = NULL;
+	state->creator_mm = NULL;
+	state->creator_cred = NULL;
+	state->creator_pid_ns = NULL;
+	state->staged_path = NULL;
+	state->nr_actions = 0;
+}
+
+static void
+pidfd_spawn_put_resources(struct pidfd_spawn_resources *resources)
+{
+	if (resources->creator_mm)
+		mmdrop(resources->creator_mm);
+	if (resources->creator_cred)
+		put_cred(resources->creator_cred);
+	if (resources->creator_pid_ns)
+		put_pid_ns(resources->creator_pid_ns);
+	kfree(resources->staged_path);
+	kvfree(resources->actions);
+}
+
 static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 				      struct filename *filename, int result)
 {
-	const struct cred *creator_cred;
-	struct pidfd_spawn_action *actions;
-	struct mm_struct *creator_mm;
-	struct pid_namespace *creator_pid_ns;
-	char *staged_path;
+	struct pidfd_spawn_resources resources = {};
 
 	/*
 	 * Run data is one-shot. Detach it under the lock, then drop refs
 	 * after the child no longer needs the shared setup payload.
 	 */
 	mutex_lock(&state->lock);
-	actions = state->actions;
-	creator_mm = state->creator_mm;
-	creator_cred = state->creator_cred;
-	creator_pid_ns = state->creator_pid_ns;
-	staged_path = state->staged_path;
-	state->actions = NULL;
-	state->creator_mm = NULL;
-	state->creator_cred = NULL;
-	state->creator_pid_ns = NULL;
-	state->staged_path = NULL;
-	state->nr_actions = 0;
+	pidfd_spawn_detach_resources(state, &resources);
 	state->argv = native_arg(NULL);
 	state->envp = native_arg(NULL);
 	memset(state->audit_args, 0, sizeof(state->audit_args));
@@ -235,14 +268,7 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	mutex_unlock(&state->lock);
 
 	putname(filename);
-	if (creator_mm)
-		mmdrop(creator_mm);
-	if (creator_cred)
-		put_cred(creator_cred);
-	if (creator_pid_ns)
-		put_pid_ns(creator_pid_ns);
-	kfree(staged_path);
-	kvfree(actions);
+	pidfd_spawn_put_resources(&resources);
 }
 
 static bool pidfd_spawn_cancel(struct pidfd_spawn_state *state,
@@ -291,16 +317,44 @@ static bool pidfd_spawn_same_creator(struct pidfd_spawn_state *state)
 	       pidfd_spawn_same_pid_ns(state);
 }
 
-static int pidfd_spawn_check_startable(struct pidfd_spawn_state *state)
+static int pidfd_spawn_claim(struct pidfd_spawn_state *state)
 {
 	int ret;
 
-	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+	scoped_guard(mutex, &state->lock) {
 		ret = pidfd_spawn_configuring_error(state);
-		if (!ret && !pidfd_spawn_same_creator(state))
-			ret = -EPERM;
+		if (ret)
+			return ret;
+		if (!pidfd_spawn_same_creator(state))
+			return -EPERM;
+
+		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
 	}
-	return ret;
+	return 0;
+}
+
+static void pidfd_spawn_fail_taskless(struct file *file,
+				      struct pidfd_spawn_state *state, int result)
+{
+	struct pidfd_spawn_resources resources = {};
+
+	mutex_lock(&state->lock);
+	if (WARN_ON_ONCE(pidfd_spawn_get_status(state) !=
+			 PIDFD_SPAWN_STARTING || pidfd_spawn_load_pid(state))) {
+		mutex_unlock(&state->lock);
+		return;
+	}
+	state->result = result;
+	pidfd_spawn_detach_resources(state, &resources);
+	state->argv = native_arg(NULL);
+	state->envp = native_arg(NULL);
+	memset(state->audit_args, 0, sizeof(state->audit_args));
+	state->audit_syscall = 0;
+	pidfd_spawn_set_status(state, PIDFD_SPAWN_FAILED_TASKLESS);
+	mutex_unlock(&state->lock);
+
+	pidfd_spawn_put_resources(&resources);
+	pidfs_future_file_notify(file);
 }
 
 static struct filename *pidfd_spawn_get_path(const char __user *value)
@@ -718,7 +772,7 @@ static void pidfd_spawn_child(struct callback_head *work)
 }
 
 static int pidfd_spawn_copy_run_args(struct pidfd_spawn_run_args *kargs,
-				     struct pidfd_spawn_run_args __user *uargs,
+				     const struct pidfd_spawn_run_args __user *uargs,
 				     size_t usize)
 {
 	size_t actions_size;
@@ -873,6 +927,13 @@ static int pidfd_spawn_start(struct file *file,
 	struct task_struct *task;
 	int ret;
 
+	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
+		if (pidfd_spawn_get_status(state) != PIDFD_SPAWN_STARTING)
+			return -EBUSY;
+		if (!!state->staged_path == !!kargs->path)
+			return -EINVAL;
+	}
+
 	if (kargs->path) {
 		ret = pidfd_spawn_get_delayed_path(&filename,
 						   pidfd_spawn_user_ptr(kargs->path));
@@ -881,15 +942,8 @@ static int pidfd_spawn_start(struct file *file,
 	}
 
 	scoped_cond_guard(mutex_intr, return -EINTR, &state->lock) {
-		ret = pidfd_spawn_configuring_error(state);
-		if (ret)
-			return ret;
-		if (!pidfd_spawn_same_creator(state))
-			return -EPERM;
-		if (state->staged_path && kargs->path)
-			return -EINVAL;
-		if (!state->staged_path && !kargs->path)
-			return -EINVAL;
+		if (pidfd_spawn_get_status(state) != PIDFD_SPAWN_STARTING)
+			return -EBUSY;
 		if (state->staged_path) {
 			ret = pidfd_spawn_get_delayed_kernel_path(&filename,
 								  state->staged_path);
@@ -903,7 +957,6 @@ static int pidfd_spawn_start(struct file *file,
 		state->envp = pidfd_spawn_user_arg(kargs->envp);
 		state->actions = *actions;
 		state->nr_actions = kargs->nr_actions;
-		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
 		pidfd_spawn_save_audit_context(state);
 		*actions = NULL;
 		reinit_completion(&state->done);
@@ -921,9 +974,6 @@ static int pidfd_spawn_start(struct file *file,
 			memset(state->audit_args, 0,
 			       sizeof(state->audit_args));
 			state->audit_syscall = 0;
-			state->result = 0;
-			pidfd_spawn_set_status(state,
-					       PIDFD_SPAWN_CONFIGURING);
 			return ret;
 		}
 
@@ -1002,17 +1052,13 @@ int pidfd_empty_open(unsigned int flags)
 }
 
 SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
-		struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
+		const struct pidfd_spawn_run_args __user *, uargs, size_t, usize)
 {
 	struct pidfd_spawn_action *actions __free(kvfree) = NULL;
 	struct pidfd_spawn_run_args kargs;
 	struct pidfd_spawn_state *state __free(pidfd_spawn_state) = NULL;
 	int ret;
 
-	ret = pidfd_spawn_copy_run_args(&kargs, uargs, usize);
-	if (ret)
-		return ret;
-
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
@@ -1020,19 +1066,27 @@ SYSCALL_DEFINE3(pidfd_spawn_run, int, fd,
 	state = pidfd_spawn_state_get_file(fd_file(f));
 	if (IS_ERR(state))
 		return PTR_ERR(state);
-	ret = pidfd_spawn_copy_actions(&actions, kargs.actions,
-				       kargs.nr_actions, kargs.action_size);
-	if (ret)
-		return ret;
-
 	scoped_cond_guard(mutex_intr, return -ERESTARTNOINTR,
 			  &current->signal->cred_guard_mutex) {
 		if (READ_ONCE(current->ptrace))
 			return -EPERM;
-		ret = pidfd_spawn_check_startable(state);
+		ret = pidfd_spawn_claim(state);
 		if (ret)
 			return ret;
-		ret = pidfd_spawn_start(fd_file(f), state, &kargs, &actions);
+
+		ret = pidfd_spawn_copy_run_args(&kargs, uargs, usize);
+		if (!ret)
+			ret = pidfd_spawn_copy_actions(&actions, kargs.actions,
+						       kargs.nr_actions,
+						       kargs.action_size);
+		if (!ret)
+			ret = pidfd_spawn_start(fd_file(f), state, &kargs,
+						&actions);
+		if (ret) {
+			ret = pidfd_spawn_normalize_result(ret);
+			if (!pidfd_spawn_load_pid(state))
+				pidfd_spawn_fail_taskless(fd_file(f), state, ret);
+		}
 	}
 	if (!ret)
 		ret = pid_vnr(state->pid);
-- 
2.52.0


