Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36024CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED67A6B0096; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEADD6B0098; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01E96B0099; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E93A6B0096
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C695B40413
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:24 +0000 (UTC)
X-FDA: 85306324488.15.F5F4B85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C10E040005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnbjHFLI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q4CjQ37MPLknHEgUeISaZXCw+fyJpc4AJ33vNr/WYQ=;
	b=pV5O3P+xENCSKk8Bvl4Xl+3nywoJqwQ2lsagfsTzxsWlSkHkmzvMR8z9fI5qS0upDVXnD9
	YMCwO847YF5/AjUMmEJpHvWystoz2ddETQi03PMnmH1dbbQQGLvKt/sHhjpOwwlJQKs6Dq
	mCmOVs5n9WhMhG9DoylHMg+yPlpIBTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnbjHFLI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791627682;
	b=gEB3aNc27+I+Gcerm/0Sg8iLOWkv3niB3/lBJ8tRJ4e9HSjy+FR+i+e2YRF/zs/OTJQvso
	n/jjk2tJlRecDMzjNhLtMrnT13EnTlsmSJNwIrh/HJ/7/lkCzz254G+3nek8IWwXed+7Tg
	EfI2gIveYhE0F1ABL37eAjgcEqB1xWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0994447E2;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E5D2C2BCFA;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791627681;
	bh=+aD0X6sb11+jjyQi1a6joPNVFUBU2mhCSKxc9Gkc3nc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hnbjHFLIZWFngCYiDp+EfjrVJ7WA8pBg9V+ax42ywPTz9IhZktp+rabStfUofY85K
	 18X+EcEjCgUrD+8Gh2V/PUqwbh1p7Zob9OKRUsNzqhCP+svQKs3EG2p7eYdfKRUmkN
	 BXKrU/EZxFlDYHLQ2MjoVwTH2xsFwWQTL0n7KMEjad1sjPs0VYY8ij80CndWPoYvoU
	 5FX/LtCpQtFx5ZNAPE1/ws5eKj0GkRMof311Ga2F63gT7TzHtfD2+TlQcD1BvIJ8e1
	 8NfwW+tGuuL/jQ6sf2LTJwokt5M87BCNYwVVs3HnPuJ3HBdjCL1J+hG8iujHKn6zZ7
	 y/Zy3i670TARA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5597BCA9EC5;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Sat, 10 Oct 2026 18:20:52 +0800
Subject: [PATCH v3 3/4] pidfd: Use scoped cleanup for task access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-pidfd-get-paths-v3-3-f245440b2b30@black-desk.cn>
References: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
In-Reply-To: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5576; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=NPrZdQ1JCSLNhCfcWaYnWbaRI7tW+dlnJo7YNzROnO8=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqyhGdtz+BGZR4qbLH9XDyeyUkCXpONkLNZY2We
 eJq8CZKDvaJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCasoRnQAKCRB2HuYUOZmu
 i1LWD/9SGUhaokHoptBqWEtgjMzuBvw3wDxCPusWYMunfoAcvU8v7bexE4tVDtrK9LkBnWrPn7a
 34AInNfvSHJgIZzxQvgleInp8kv81YUL/3bewRkoKPg+7Nne3h2UDzX+fqj8azu/wFTKt4nMb8r
 xvvE8eXEZV9Ki6Eczvel+LhhatV0tSKa6Iox8OVIJh+JXEmEaFodnPS4qWODHcJ4JlcYWujfKLB
 g6OzhqwGTirqMLuT/QodphIIWY+l9NYvmy5/Jq8xpZCy2m3/Xd5TlXmfbGB9YfNASU1gkHYFl4Y
 uaipPSxELJ6FydEuinCkE0xGrAaN73Zilv0KcN4MPGXyNKDGy3Rnr61TrkkjZ+oxyDIbA1tYVve
 eu0M0fjSY6yAA/CEcyIC9SuK0oy0SxVLaAamcU5l+SEgE7OTVIz0AXyhbXXIy3/tUYAvM/p4vXX
 jArrNnm5SmQEgnDe6JHXPQFga+aLg0DNWTInRVsvolYVwds3eVJUJY2KFrINh+d45PfpHp+mM69
 YF1IhUxMztJApboEf11Y0yzYZcf6XNAVxI7Cvdyd6bkKeyn+Ea65Cq9zs/rydNKAEr0X3nha2uu
 +bj5LrI0SXn2ATN+Qh8nkkR+Aot7u9XOH+amJ05OFPlcp52aWuX0QZanitxw/6cQX2Pnz0nbusB
 xykhYVivPyGQNaA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Stat-Signature: kd7iocb1c7jbb6pwdc1ykmni66gbctjz
X-Rspam-User: 
X-Rspamd-Queue-Id: C10E040005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791627682-865779
X-HE-Meta: U2FsdGVkX196XN9/6y4uTCMelyvgUpBxd0jNl1LR/dPPzGPSTFI0hCpyMTE4HU4HtwWa21DvC3MFCWljtQOgx3XcDFDySvfyTRLIlzFNCyfXSBFn2Tm7WUPKRHWMDZ8xyUZbmPFlEXQ/0O/PTtYRukmZaqwwDosrFyQO3dF3vS1adw3ia7oK3bobEQDWDmB3KELp5ZWS1gGRSE1spyOpud2/+HCxko0gX7BhdzBPB95Tc0gWdd7bGogXYX0RW6BOeATGt1UVd+vsHYJj1OBUjV1B2taK4yQX9jExpD1jKJkq2mjt/4P73oohCJf60R6MFEJr4U4qvzRl8x9Wa0XjpnyEHudsbBxPEiGeIUQjMyLOhJFBqV7zhqsYZKVCN93fqsjg0XOViTwhE59O89YugCAGxDfQkPbAuz7Wu+E0MLdrHtNgKmYcUb1L16exODuzfaTcuZzk91ld0Loajly0Nc9TCtR/mZIwdhno9Y2KbGqWYBBljYow4At+zmtf0Dwc5++sc6P2GXPApsJ5mf+L4567zbW2HjOVcVsMs4gZc5NZ7iD2dcNfO51dlRNx9QNlTnwbCfBFrcD9U7N6VCQ3Q+xXwQ/BTAwsDKk0gKK38e7SVSsJE2ypoAi7Oxk/LXbKDRo/UXE20iUfmkDi0nQqymaRovVoxTZT9aPqTKxI2sjrdWe7RpPSmqldy9ddt3SiZXZqUloZgxkie0VzXIEvbgX6bT7m4YKts+FEmD+bAxCp6AAZfP/MIwRYszVsK+39Qd+lZQ4uPwyGmuYAJJnAKUO0CWWROCy5tqpQgpWMjY+We3QU+sOjr26qM/kaFw2LpcNDrUAsRFwC298AmzjHseGMI2Ag8kfq0Tctt1tZWvk2/c5eYtNCH/wgFBlH/zrS8ERIJn7UpeF0U8TdFMeIT83HCbhAapj8BlhWHAtDv6eAC4G5J8fyebIkzlDyTniqPvs4fOTB0Ro4hA445n0
 nwgZcXYR
 xMcphrEwsqY9m+1/i73OKohTjBkf6HyH4KTsiR7avUMZKnkRgQNkXZZAU8BmDNIdb1WCVuntT4E8N7XWbEbS3Q4aPixADkkAy7dGe0HJFhFld+q4oO0bBtPrqeSuo8etr6USvgrLWRgOcyk5zdlgIlREPCocfeqOVNPnBYzTaS7Bki7ldZs/eZuXoe2vOdWtke25VfDPw+ApxMN8w46ulT7AQTx2Rl4uezcBnYuylmS4cjszqT0H8N+9Jnc4f64nrUqszeV0wfzO5LBzs9GSHeh37XvOJuuV1UfeOstjF09mjHZ8rrRCm1kvyuPxGMv1JzCVMcyE9wpnIjftnmxLe2LPaZvvUcZVy0WD5MgqBiPM12TFTAdByy7gRl75E2QsXHmoY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Linxuan <me@black-desk.cn>

Split namespace acquisition from namespace fd creation and represent a
privileged target task as a scoped class that owns both the task
reference and exec_update_lock. Use the class for namespace lookups so
ptrace access checks and task state reads remain tied to the same exec
critical section, while open_namespace() stays outside the lock.

Carry the pid namespace visibility check into the helper so that all
users of the class enforce it.

Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c | 120 +++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 46 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 791f7efceabe..82ab4dee55e5 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -527,70 +527,76 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
 	return false;
 }
 
-static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static inline void pidfd_put_task_locked(struct task_struct *task)
 {
-	struct task_struct *task __free(put_task) = NULL;
-	struct nsproxy *nsp __free(put_nsproxy) = NULL;
-	struct ns_common *ns_common = NULL;
-	int error;
-
-	if (!pidfs_ioctl_valid(cmd))
-		return -ENOIOCTLCMD;
-
-	if (cmd == FS_IOC_GETVERSION) {
-		if (!arg)
-			return -EINVAL;
-
-		__u32 __user *argp = (__u32 __user *)arg;
-		return put_user(file_inode(file)->i_generation, argp);
+	if (!IS_ERR_OR_NULL(task)) {
+		up_read(&task->signal->exec_update_lock);
+		put_task_struct(task);
 	}
+}
 
-	/* Extensible IOCTL that does not open namespace FDs, take a shortcut */
-	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
-		return pidfd_info(file, cmd, arg);
+/*
+ * Return @pid's task with @task's exec_update_lock held, or -EREMOTE if the
+ * task is not visible in the caller's pid namespace. The ptrace check and
+ * the callers' task state lookup must be performed while the lock is held
+ * so that they cannot race with a concurrent execve().
+ */
+static struct task_struct *pidfd_get_task_locked(struct pid *pid,
+						 unsigned long arg)
+{
+	struct task_struct *task __free(put_task) =
+		get_pid_task(pid, PIDTYPE_PID);
+	int error;
 
-	task = get_pid_task(pidfd_pid(file), PIDTYPE_PID);
 	if (!task)
-		return -ESRCH;
+		return ERR_PTR(-ESRCH);
 
 	if (arg)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Require the target to be visible in the caller's pid namespace
 	 * for operations that grant access to its resources, mirroring
 	 * procfs and PIDFD_GET_INFO.
 	 */
-	if (!pid_in_current_pidns(pidfd_pid(file)))
-		return -EREMOTE;
+	if (!pid_in_current_pidns(pid))
+		return ERR_PTR(-EREMOTE);
 
-	/*
-	 * We're trying to open a file descriptor to the namespace so perform a
-	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the
-	 * duration of the ptrace check and the namespace lookup so that the
-	 * credentials used for the access decision match those of @task at the
-	 * time its namespace is read, preventing a concurrent execve() from
-	 * swapping the task's credentials in between the check and the use. We
-	 * mirror nsfs behavior.
-	 */
 	error = down_read_killable(&task->signal->exec_update_lock);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
-		error = -EACCES;
-		goto out_unlock;
+		up_read(&task->signal->exec_update_lock);
+		return ERR_PTR(-EACCES);
 	}
 
+	return_ptr(task);
+}
+
+DEFINE_CLASS(pidfd_task_locked, struct task_struct *,
+	     pidfd_put_task_locked(_T),
+	     pidfd_get_task_locked(pid, arg),
+	     struct pid *pid, unsigned long arg)
+
+static struct ns_common *pidfd_get_namespace(struct pid *pid,
+					     unsigned int cmd,
+					     unsigned long arg)
+{
+	struct nsproxy *nsp __free(put_nsproxy) = NULL;
+	struct ns_common *ns_common = NULL;
+
+	CLASS(pidfd_task_locked, task)(pid, arg);
+	if (IS_ERR(task))
+		return ERR_CAST(task);
+
 	scoped_guard(task_lock, task) {
 		nsp = task->nsproxy;
 		if (nsp)
 			get_nsproxy(nsp);
 	}
-	if (!nsp) {
-		error = -ESRCH; /* just pretend it didn't exist */
-		goto out_unlock;
-	}
+	if (!nsp)
+		return ERR_PTR(-ESRCH); /* just pretend it didn't exist */
 
 	switch (cmd) {
 	/* Namespaces that hang of nsproxy. */
@@ -672,16 +678,38 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #endif
 		break;
 	default:
-		error = -ENOIOCTLCMD;
+		return ERR_PTR(-ENOIOCTLCMD);
 	}
 
-	if (!error && !ns_common)
-		error = -EOPNOTSUPP;
+	if (!ns_common)
+		return ERR_PTR(-EOPNOTSUPP);
 
-out_unlock:
-	up_read(&task->signal->exec_update_lock);
-	if (error)
-		return error;
+	return ns_common;
+}
+
+static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ns_common *ns_common = NULL;
+
+	if (!pidfs_ioctl_valid(cmd))
+		return -ENOIOCTLCMD;
+
+	if (cmd == FS_IOC_GETVERSION) {
+		if (!arg)
+			return -EINVAL;
+
+		__u32 __user *argp = (__u32 __user *)arg;
+
+		return put_user(file_inode(file)->i_generation, argp);
+	}
+
+	/* Extensible IOCTL that does not open namespace FDs, take a shortcut */
+	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
+		return pidfd_info(file, cmd, arg);
+
+	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
+	if (IS_ERR(ns_common))
+		return PTR_ERR(ns_common);
 
 	/* open_namespace() unconditionally consumes the reference */
 	return open_namespace(ns_common);

-- 
2.55.0



