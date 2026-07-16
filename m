Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33900C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB54A6B00B9; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C826B00BA; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE9C6B00BD; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC7A6B00BA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3276E1401E7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:40:53 +0000 (UTC)
X-FDA: 84994901586.27.0AD96DE
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 48BF18000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:40:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=jTTOe8Qb;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMza1E+rhNrE4SicI52nJDf/t3lksusUovzMzX60i1w=;
	b=WGua5jj8mMY71ZG0XcVq4lLThN4TrVnQj4NJnk43hvQKNUqeFDIp9VSMBJbHxrKHPbqUKl
	Wp/gWtbZnX+MEvBSuOrPqBkGqWDsIB3IznuPtMd+KIooiMwwVIjFN7yJbAWbR0ddMnl51c
	rSA0++nao45fWREUUnRMotPnkdHSRwQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=jTTOe8Qb;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212851;
	b=4EBUcbaf2r2/fpXjvD6I9qkOgBhSOfS1VJiPjEcNwIGqs7SNO73fviG/TNMeaO9dTQpZi1
	9OL0LeGObTzBL5vEDNQRXO8nCYpuy1haCgF81ZhFsIHjIXrcd5EXyeHt9mUM8N6GtAgZKk
	21hv3lJScqZ9IpTfrZAeYzlw7mK1Jho=
ARC-Seal: i=1; a=rsa-sha256; t=1784212480; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PIeEPYDFLGgwA2bTk3H8X9leLEPwWCGefeTfHsRrxxCpHQvhSAh6x9xXd5Vku0nOqTkRoGb2dX7qX7DJgpQ1KE3STA8LTmGn4J1HhAOfxHis1BmyrwWGXx4fDh3Gvoq07Wv1PNSIcINVNjaGtR7HE9i7jyc2Jsd7ZPChv9jC4Y4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212480; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IMza1E+rhNrE4SicI52nJDf/t3lksusUovzMzX60i1w=; 
	b=VP0KbG/o8srdoVc5GwysbluUT0DSOlwi+52zXmHWZpzNUra/Q3xsSqB1casGsnG5fhoNOmG7JctCy/YoN+bdTWQsj2RCpyk8yQbBrq8okvFj0WJ9UZQSk6pqquc+0KsJZCxteeCiVXT4GVoF5BfbFpzQvS5GiNEtHz7zYSR7FOg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212480;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=IMza1E+rhNrE4SicI52nJDf/t3lksusUovzMzX60i1w=;
	b=jTTOe8QbcE0FNQMP+8vrP8s5UT4Wi7FibnpPvG8+aNBl6q86aHT3rxLeZEuvRPcV
	e/NdYYLFXmpKPJ01zXstZYw7jydltdcc35Z0uhO80vfy0tbzruWJKHxvk1SvWKz3jyT
	ybmgG+iuzaMJKQB9useiDlzaPeCij/LHJegIPnJw=
Received: by mx.zohomail.com with SMTPS id 1784212478289926.1473874238077;
	Thu, 16 Jul 2026 07:34:38 -0700 (PDT)
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
Subject: [RFC PATCH 15/24] fork: keep embryonic tasks hidden until exec completes
Date: Thu, 16 Jul 2026 22:31:41 +0800
Message-ID: <92e41fa333983c2f5c10251e64f2214c69aed0e1.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 48BF18000A
X-Stat-Signature: kdpn8853ik1h79nmpaze1gt63pbwyeet
X-Rspam-User: 
X-HE-Tag: 1784212851-799085
X-HE-Meta: U2FsdGVkX1+pi46LWWSdRH0gYnDZcKBJ3RStTKA1uTmAM0G06q5tPOL6WToPRkdX97Q52hyvOWzb4CDTA/uAgGitrkV7J2GOPb08wwD71n+ygxT5gICIjEgWf+/Paij7Hf6Jzoc/P23wLq3YxlGX+JHI6htE6Jyt8DfUh4zSGVJE+txIOcDijhzc7x56ycPlBbeS/AXZ8Ca58I+v6xl3bELAB0g9b2y1fd9Cvj18pF4/kKi3DvDNXCM6A5GJ4Vq+VKfnBxhfKJ21iHt+UK8DDCtIkA55akWzMhqy4N3Obm+ry4WJP+45wTsl7YQqAY8P9nmlFgtMv2UU8eNvtBmWh87tnPUA3+BI8SZzoyq+KJ4KT2SW6phCkdW4kBq76OLM2qQVnw2vnO6ov+U3hErdEfo445mctP8WJBIL2BojOmxUC2OIIGFYAp+7CHlCBHa6RITMBTKXNas3lLLLb1f1XLnwGeNkpabMkhG7O1E0zuVNEXdqJw0NB5sWu8a4FXPAY4wj+BpC3Xak8pm3wUCpuoEo38i4Y4xjWY6sOmRVqIIMjozF+emreNwopk7/6e4W2m/m+D1zOIGBmWooUFhRFsJ/fmpVQqRhwPee/tDiOXr45Y+tXx6EHUSZyKA+989mse/U1NicbG/KIuLl3/5xd8AIxch9UTYvTllfl4PTWNnKfPVwxThdt0ROs0ITFqZqTeyumW9o0mLFhrRHWGZ7v9eFUqZ7d2kTT+CnKWN1Y2VzlYGBWR9syZWFw710gu1i4GbOnRd2MZTQfB8NTI6oOYG/Mg7998sM5yEovA5yeTKgJmPwPCTMjQfJ1lbjAxFG4IG6X/yp0hlWsw+QsfGClGpr52jHA9L3g1DIhcxrEliDKIerXC6I9Qwn6xINTC0lgVNz/InvyslguuuxGlLmVfXFCgcE2ZnpoktFnKRVNlwqeZfdJpqga/UGT84zeSrjL7W+EZHkfrcVd47c2Zz
 RTr/Dzut
 pv6bARSQ+MmWokN4CvUo45Pp71ualkyf2u+5ihlYINnwccq4uoWmPUx56kUgTrCaA7trZYiFEigCN9ypALfCw77/9cjjHXmo/1aFootIgdIMQDTwkrup5c9IFPFROFPqAnQ82zmbilauz4pcwmDU/3lHxi8fa8zL23toakhrHhUz5pLvuGs9KLZNNcNWT+fDgQJDEZNdYeZNvB0SAP47wxNeMdiMwcyy5YHcPj+RRtKk42oPYd6sivvfgnCEWcjfPSOQYaywFVM/aot6/dqJib/UT8os79qD3n9WZwE/oPdn/nP7vyl0Xhe6kEBKyeKX8o5CB3q4HkwPHhBLgY7onSLkGJJVddFjv0X7OCupGCusPE9FzI7G/d11LIJhmnTSF0/819RWp8Z3QDxzZ8ZbiieDUmCe27hwT2PUwMDgcynSaV9xEZyA02ZAVBqdPtumP1JVkON2S0ligve1VE1mfRrJ5LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A spawn task does not gain a valid userspace register frame when
exec_mmap() installs its private mm. A binary loader can still sleep or
fail before START_THREAD(). This can expose setup registers to ptrace or a
late failed-exec core dump. During earlier setup the task also shares the
source mm, which procfs could expose through the child's PID.

Hide procfs PID lookup, iteration, and cached dentry revalidation from
other tasks, deny coredumps, and report coredump skip state through pidfs.
Allow the embryonic task to use its own proc entries because executable and
interpreter lookup can legitimately use /proc/self. This does not expose
source state to another task. Sample the flag before reading published
credentials; acquire ordering covers the state installed by exec.

Release-publish the transition in the exec core after the final binary
handler succeeds and before audit, tracepoint, ptrace, and connector exec
events. Every successful exec observer then sees a normal task, while a
failed exec leaves the task hidden.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/coredump.c      |  4 +++-
 fs/exec.c          |  2 ++
 fs/pidfd_spawn.c   |  2 --
 fs/pidfs.c         |  7 ++++++-
 fs/proc/base.c     | 11 +++++++++--
 fs/proc/internal.h | 18 +++++++++++++++++-
 kernel/ptrace.c    |  2 +-
 7 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index ac3cd74808c64..4b2f0b5c7d606 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1166,7 +1166,9 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 		.limit = rlimit(RLIMIT_CORE),
 		/* Snapshot MMF_DUMP_FILTER_* (unlocked) and dumpable for the dump. */
 		.mm_flags = __mm_flags_get_word(mm),
-		.dumpable = task_exec_state_get_dumpable(current),
+		.dumpable = task_is_embryonic_exec(current) ?
+			TASK_DUMPABLE_OFF :
+			task_exec_state_get_dumpable(current),
 		.vma_meta = NULL,
 		.cpu = raw_smp_processor_id(),
 	};
diff --git a/fs/exec.c b/fs/exec.c
index 1a256ba26425e..292c30e80aecb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1734,6 +1734,8 @@ static int exec_binprm(struct linux_binprm *bprm)
 			fput(exec);
 	}
 
+	if (task_is_embryonic_exec(current))
+		task_clear_embryonic_exec(current);
 	audit_bprm(bprm);
 	trace_sched_process_exec(current, old_pid, bprm);
 	ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index c0e95c2ddbe6e..41d5cbb49a0f7 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -400,8 +400,6 @@ static void pidfd_spawn_child(struct callback_head *work)
 	if (!ret)
 		ret = do_execveat_common(AT_FDCWD, filename,
 					 state->argv, state->envp, 0);
-	if (!ret)
-		task_clear_embryonic_exec(current);
 
 	pidfd_spawn_finish_child(state, filename, ret);
 	if (ret) {
diff --git a/fs/pidfs.c b/fs/pidfs.c
index d62235e01b351..7a473c049dcd4 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -477,6 +477,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	struct user_namespace *user_ns;
 	struct pidfs_attr *attr;
 	const struct cred *c;
+	bool embryonic;
 	__u64 mask;
 
 	BUILD_BUG_ON(sizeof(struct pidfd_info) != PIDFD_INFO_SIZE_VER3);
@@ -533,12 +534,16 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		goto copy_out;
 	}
 
+	embryonic = task_is_embryonic_exec(task);
 	c = get_task_cred(task);
 	if (!c)
 		return -ESRCH;
 
 	if ((mask & PIDFD_INFO_COREDUMP) && !kinfo.coredump_mask) {
-		kinfo.coredump_mask = pidfs_coredump_mask(task_exec_state_get_dumpable(task));
+		enum task_dumpable dumpable = embryonic ?
+			TASK_DUMPABLE_OFF : task_exec_state_get_dumpable(task);
+
+		kinfo.coredump_mask = pidfs_coredump_mask(dumpable);
 		kinfo.mask |= PIDFD_INFO_COREDUMP;
 		/* No coredump actually took place, so no coredump signal. */
 	}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62a..bd059ddcce863 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2053,7 +2053,7 @@ static int pid_revalidate(struct inode *dir, const struct qstr *name,
 		goto out;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 
-	if (task) {
+	if (task && proc_task_visible(task)) {
 		pid_update_inode(task, inode);
 		ret = 1;
 	}
@@ -3492,6 +3492,8 @@ struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
 	rcu_read_unlock();
 	if (!task)
 		goto out;
+	if (!proc_task_visible(task))
+		goto out_put_task;
 
 	/* Limit procfs to only ptraceable tasks */
 	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE) {
@@ -3539,11 +3541,12 @@ static bool next_tgid(struct tgid_iter *it)
 		if (pid) {
 			it->tgid = pid_nr_ns(pid, it->pid_ns);
 			it->task = pid_task(pid, PIDTYPE_TGID);
-			if (it->task) {
+			if (it->task && proc_task_visible(it->task)) {
 				get_task_struct(it->task);
 				rcu_read_unlock();
 				return true;
 			}
+			it->task = NULL;
 		} else {
 			rcu_read_unlock();
 			return false;
@@ -3807,6 +3810,8 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	rcu_read_unlock();
 	if (!task)
 		goto out;
+	if (!proc_task_visible(task))
+		goto out_drop_task;
 	if (!same_thread_group(leader, task))
 		goto out_drop_task;
 
@@ -3844,6 +3849,8 @@ static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
 	task = pid_task(pid, PIDTYPE_PID);
 	if (!task)
 		goto fail;
+	if (!proc_task_visible(task))
+		goto fail;
 
 	/* Attempt to start with the tid of a thread */
 	if (tid && nr) {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b232e1098117b..81ad44502272e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -147,9 +147,25 @@ static inline struct pid *proc_pid(const struct inode *inode)
 	return PROC_I(inode)->pid;
 }
 
+static inline bool proc_task_visible(struct task_struct *task)
+{
+	/*
+	 * An embryonic task may need its own proc entries during exec setup,
+	 * but it is not a valid userspace process image for other tasks yet.
+	 */
+	return task == current || !task_is_embryonic_exec(task);
+}
+
 static inline struct task_struct *get_proc_task(const struct inode *inode)
 {
-	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
+	struct task_struct *task;
+
+	task = get_pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task && !proc_task_visible(task)) {
+		put_task_struct(task);
+		return NULL;
+	}
+	return task;
 }
 
 void task_dump_owner(struct task_struct *task, umode_t mode,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 36eb9b154a397..59e11dae803c8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -314,7 +314,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		WARN(1, "denying ptrace access check without PTRACE_MODE_*CREDS\n");
 		return -EPERM;
 	}
-	if (task_is_embryonic_exec(task))
+	if (task_is_embryonic_exec(task) && task != current)
 		return -EPERM;
 
 	/* May we inspect the given task?
-- 
2.52.0


