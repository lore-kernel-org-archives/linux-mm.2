Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EED6C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 05:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E386B009D; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1F86B0098; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC366B009B; Thu, 20 Aug 2026 01:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDF226B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74BB51C193F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:51 +0000 (UTC)
X-FDA: 85120561302.27.1BE2918
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 807CC100005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOJTnqsZ;
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787204749;
	b=VmGC6082BR6s6wAJt8xc8LLdb9Zmdpj59tmB8lZcLaNVbMDVQ2etIpze6w8tIH4gYHAwT9
	sLkImb9ZTUiHwuIRqMu1I+GGgBqh4M3KTLle5qM7qYRPAnCm0x59Vz2z6S/AX7w+fsa+82
	DCnuoQWcqLXiw77PO7wL0uDXiqjnuyM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOJTnqsZ;
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787204749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGlNNUxETSeIGaqZ6pH06FvD+3fAwkM5vQ7lcTS/H78=;
	b=yH0+yosGfgCqZAlqQAWIQkMkpdJSEb4I16zjMBhOTUSo5J2HPjFT2lpSHLZguW0W/aKsSL
	HxNZRw2BB37hV4IiWGN2Ijfn3NI6xo0CmgebE/wgaeb8gdCOvBVEuU4aXC4QtHbi0HlB4N
	9YFmlr1Cu/0AZNmbPZf1oyqfFir2rco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4281A44EEB;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03979C2BCFC;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787204748;
	bh=86B0Pk4jVJ6ZQ+Jb+6BAOAHcs2OvwgJHav3rxWmibtI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EOJTnqsZ1kTwBmA6gqd7fuNFjTMRAUr88rZy2dnsYg8Y1VbHCwbm4WqmD2JMgiZYC
	 c6ejc8oatNCihy3kBWSoA5TaDKhFsgv2yTkc0F32AE6hIvqgGzPE030vZU3k3dl4Ix
	 vPMIGcBN4etjKfncuC5IlbIntd86ZLk8E+U5YLd2GGk8O9cNIRlu0PMdWb/ouwO+/l
	 u80UzVUS3SEWVhud64sbtIh/v4jbHKS4AV6CweDohZTQZPkHnjP1mzn4eFqRjWSsn/
	 xhBS7sxKjKPWDEw77dntLh4pOYCrr4Ac2ouP87QD+E3k6tEWe2dj1SKFuhi2N3pJLJ
	 Jl0tq7Je/Dzow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27B4C5DF87;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Thu, 20 Aug 2026 13:45:40 +0800
Subject: [PATCH RFC 2/3] pidfd: Use scoped cleanup for task access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-pidfd-get-paths-v1-2-ac3eee4003d5@black-desk.cn>
References: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
In-Reply-To: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
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
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5184; i=me@black-desk.cn;
 h=from:subject:message-id;
 bh=KBo9FLg9vQy1MB4oOYDcDc0kQebzYNbPiSNI8fLNAR0=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqhpSIhKwGZauH3fC6nxip9ANmNISsp+MKbUnCe
 /TrubcJkUmJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaoaUiAAKCRB2HuYUOZmu
 ixmID/41QbF14zMynFNvfg9xr0TvYsQnr5aSI0j2biffLrXEfTAP6BRpHjSCrg/K/mp9z703xWm
 EdtYRqlXwDUSPzZ8NSsaryeHXNlsADwpA2/9lzhbUfHlunyJ1OiboJCDp6AMophJj2WjqYKxwSl
 7WSKaF1HJS0fttFvQK9Bn6tVW80AvAHRbwOQZyLXGpW1dO59yI1Zcsuo9gXYqZlMI/6JGaV/b1b
 1hIm9lRiuEBgbJKLZf04LdGEzbS343+JOOqyfTK5BPxqDxNzTUhVPbT+hz2jOcG4KkHFAC9ij0G
 WBJC5NVICg5EAvvuO60Tl0V7AHNoopxdlgO5z/7IK6eHG1e152EmwKHVsouyJWSOepeD0A7Uz2o
 q48TzL3h3HmOJ9GBTignvke9t6TBPDriI6GxUlctkca3hh1hRPQglvXItNlt+DZRlffizuumBlr
 5vkMGB+9ZCnPh/9LTa4l3jrXlLHw5+ZGLQzsUJ8tRb8THJx3Fnvha4+Eq3GkvuA/w4eGQqRJw+c
 AFG0KKBtIZvGZCkokmw8vnMxiPah60Qg7VKrwqQ1kNiDsgrFr3YLZZFKxc/bgqkj3Kw9LirC7Si
 mYvrooo55v/G9MB5TyyLeW3g9JaO6LBMR4pzS5PMLnhe8LyEEkx9cIlMX9HEojUK3DInni74x8k
 Ze3Wt7ddjFy833A==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/default with
 auth_id=573
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 807CC100005
X-Stat-Signature: sr1wc3kfquqdxc4upcgbz9soasddnh49
X-HE-Tag: 1787204749-464889
X-HE-Meta: U2FsdGVkX184viPFRMjsmLIqTEbtbuuIEjYLxcKuQZsjsT2WKR4kfA8AHFhx6XhNpxRksTXoHDFqdSj96XZrWV/npKtODYjG6S34y0v8II9+D3yFP6Mo+dmqXMJI4XRKjkdcDqskcUci3lUax5UlqJ+nMMXf09gy8Cr92/9xT4Vcwqaw7YfgWGw2XZ5k+qhYR3d/zftV3TDeL0z/fOdH50dOhoHpm/OAhGi4EN7FCoNFB9f4z1esBLdDLZu2/Dtec6QVTdhdZjI92Q4dRb90fPuuEd/NNMtSRjYow0GV0wj8g6KamA/bfsG3UcGgY6NmbFym0PWkEmWnw4gFwkpqXRzaPyrdEzXJ31ytNKXkyABuLVFcWKc6W1z+QUUB+rlufbJE1FcsQX4XthSGs7OQ3k2b1iwgZCTAmZ0drRCcVzItX0QJJgUJTBZHSvONiyFRv7lNMXw/D5HCW1QfAvhKAP45m8OZwHO2qL0IP/bSNufq+Z31WTiDwmCdiSZMl6m+nKNmS1+N+Om5LOEXRu/OUQnys5jKEmhv3ktNuU67mnk2kulSGkMm4XMZFtYudWsR6my17hi9hvZJzVfVJUeb/flsxrguF4gfA/isZ0/hYunWrT3lhPzSq8qUfLaDLscVpbayFbwepBiVjAdeP+yhNT0lVdBmIEiTU8d3ebKD+4JdDxYLjnfKzvqTMW2tShsQ6Rz9FAZT5yKriIhC9LvzQRbosXG6r2PTzVIW9/mzd+GNKi2XG+bSbZ+Ob8fIr4ENx5NLqV8E1nqU/gHLJ4OH+Tzxrqv9j3FCGFFYRgZ2besaInsK838j4AK5wS5VAKLWoR4Yuu7e4Gl2pPYpDC98FBU0oZQU0HKLEIueBqM817NWQuYPWKjG1/+ZmSUO8/gXXIlxDHbKjCBUJdsMpZY4YVKM6266Bfx7jU9/nodzSkVOH2k26qjxTcOy+d4u4HbLwd+bGsvgvMUdIoqsc1Z
 aDZre4hn
 dvyLjZxJB5+UNSjB3JYMTcrqRZ5y/wkAwyHkaoYSYlhKCzDe6amJoOZBlWbwroZSq35dPIWkccgOIaMu/MwR/y1rHrJhrknX2VBa1RJASfuB07gUwRrJbuHQBMnlpa050Q/UtMAAhtPaIc1Y6Z/LupWCWCoRrl1gk0Cyl7SUy3RXw9nRoelxdFfJb61zhFppZRoEzcvRJrwinI/iKyeNK1AJUIJV1s3IP8SpTJ3XLs0CvxnAMryRvFkT1Y8Dc1ZVhmrCXxADyVTBlh+gEc60ZYm/6BDEIqOKGXQKjkTW3KkyvK0ldtMv6p/iIB5UG2B+2m4Vg6xDMHKoMQsPIa4AP/a7v7Go6Q+XW0XG4mZWN2SAo0sCwDuKZH8g89gEtvwbCQYon
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

Assisted-by: codex:glm-5.3
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c | 123 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 77 insertions(+), 46 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a6a643f15d08..39e1e7ad9b2b 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -527,62 +527,71 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
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
+ * Return @pid's task with @task's exec_update_lock held. The ptrace check
+ * and the callers' task state lookup must be performed while the lock is held
+ * so that they cannot race with a concurrent execve().
+ */
+static struct task_struct *pidfd_get_task_locked(struct pid *pid,
+						 unsigned long arg)
+{
+	struct task_struct *task = get_pid_task(pid, PIDTYPE_PID);
+	int error;
 
-	task = get_pid_task(pidfd_pid(file), PIDTYPE_PID);
 	if (!task)
-		return -ESRCH;
+		return ERR_PTR(-ESRCH);
 
-	if (arg)
-		return -EINVAL;
+	if (arg) {
+		put_task_struct(task);
+		return ERR_PTR(-EINVAL);
+	}
 
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
-	if (error)
-		return error;
+	if (error) {
+		put_task_struct(task);
+		return ERR_PTR(error);
+	}
 
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
-		error = -EACCES;
-		goto out_unlock;
+		up_read(&task->signal->exec_update_lock);
+		put_task_struct(task);
+		return ERR_PTR(-EACCES);
 	}
 
+	return task;
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
@@ -664,16 +673,38 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #endif
 		break;
 	default:
-		error = -ENOIOCTLCMD;
+		return ERR_PTR(-ENOIOCTLCMD);
+	}
+
+	if (!ns_common)
+		return ERR_PTR(-EOPNOTSUPP);
+
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
 	}
 
-	if (!error && !ns_common)
-		error = -EOPNOTSUPP;
+	/* Extensible IOCTL that does not open namespace FDs, take a shortcut */
+	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
+		return pidfd_info(file, cmd, arg);
 
-out_unlock:
-	up_read(&task->signal->exec_update_lock);
-	if (error)
-		return error;
+	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
+	if (IS_ERR(ns_common))
+		return PTR_ERR(ns_common);
 
 	/* open_namespace() unconditionally consumes the reference */
 	return open_namespace(ns_common);

-- 
2.53.0



