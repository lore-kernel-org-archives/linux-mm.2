Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA3BC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 02:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CEE6B008C; Sun, 30 Aug 2026 22:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E46E6B0092; Sun, 30 Aug 2026 22:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D616B0095; Sun, 30 Aug 2026 22:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 157566B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:59:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B8B8403D9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:59:15 +0000 (UTC)
X-FDA: 85160058270.25.AE90E0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 604ABA0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:59:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBavrKJE;
	spf=pass (imf25.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788145153;
	b=yNw1WUOzynDp94VIf4lQFSyY27YbHZ/VuGqssO37SNURn+Yyi65gdJd5qsJHpnWbS+ch+D
	Dd3Fkxv+Lj3u7tvQNBwqLhO+zPco0pQrq8fQcm4pUu4cw0lxHzq3OuII0H1EYZOPMsOmC0
	iq+YekiEFut2+gR1VYRrj4Bl3qKIh7w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBavrKJE;
	spf=pass (imf25.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788145153;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEjcbbJeC5914cjPYDZGp6FvQ77CrDYQBMcoHrUqSjM=;
	b=YJYs7lyqKnJ4mZAfr0nR/GtP5dqdJFuRf9/he/d4cBqB+TcbCF7Ee8vJ6PZuR7CpIH1cZ2
	9mSKlI94tap62T07Q6PoiTvCmYtFLyn7yCli7WSiFMWnL9nfDWuFqXhycLSOpqLI6uLHPM
	cctuVecIVRxTvjZec/u8dXoz63/vB5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 091A343EE8;
	Mon, 31 Aug 2026 02:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA023C2BCFB;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788145151;
	bh=qsO+jEt062xFpgDrZl1uHqGbUzP7YQqOBcQcPn6gP4I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cBavrKJEZ7jFJ8mfLHkDO14p3adji9j2EnNV18XzEhac8oDOLM5kKFReMgjfG1W/v
	 T/EAoV44UaRXUndDbGH3WFXwCqAWrDxaa54Z2iO5SeRAGTg3r7zDExw2taIj02zOY6
	 FZT9Dj6s5HetE+pScGPSuOEnujcXho6JfxslxH3G41lQWd6X+ZOWvT/guT+vPh21ag
	 TrPOZ2DD/HZMj9McsvlCTwqdDFmogjZSwCR68TAjmTOfM+45AEq1u5oSdxVFD7+UPa
	 vAvdrLBgxw0wb9jxfmQspKCSH3MUzsfMhqrlN6QUr5z7ntKyL5DRAcKcoLO/hbgckC
	 lRs4R8qcWlhPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D645C61DE4;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Mon, 31 Aug 2026 10:59:07 +0800
Subject: [PATCH v2 2/3] pidfd: Use scoped cleanup for task access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-pidfd-get-paths-v2-2-c59ea6a21b72@black-desk.cn>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
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
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5079; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=SVmkrkqreGdyu4HBET8Otf2T/l+VOx0ddobGuHRudwA=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqlO38jtoUK7Zb2KaX9LmA95hJa9Ar2TOqQKP0Y
 mknRd85v6uJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCapTt/AAKCRB2HuYUOZmu
 i5X5EACIqaukJokPjfQSlW5sUrgCjOuBxwqea6WJwCreP8MQShFKmwjR4Qmbul9kBNZMsGgkWgD
 pHbwT8els8YMxEYg+Pf1exMDyQJTlhXjpgpIKZKRbDo154/bfblKtzFjAqQVQdWt7JnLv71ric9
 u6squ8kjcsenN0dhwuO8Y00xsDBdD2HJm0mpw+smScEDAbqoZuFrrU7+3nb6EJGVelkXIIWtIjv
 fZrX57jCQCpNBCBlihI1FoX9RW+JEaoII/mVrXK/RfZmgWBBHKt32vCiW0T4TsXbgxsIKKaS7VV
 nRrGBERlyFyufsbAXVuQIcfpvvnt0Rm96XBpfR9OhLptzD1Wi+mI69M+QOXccIs2HGrK2TwtAzI
 LP34Z4zSZAWMbafTwNO6ZBy3zRnEFaKjAaPHAcc1Dl1UWS2SzT38ANIrlI5bpEDxKqlqZFL2JLa
 lKrhCX4nG7CDqSZ6freKOsne110U/HFPFSs7uyU7pUcPLEHlsbXIibjCMTiBEq53yebl+ka2vxA
 oeWS7CnAxRaAh+FitafaT41X3gyg9Bhhjn0C2PCRg1TqnieM3QG1mBkHxh3B/8Xb2cDZ9hfmH9T
 5dhHrLPxUHWf2X1YLnQMwQarcA7H69XPnF8qpf5KLAGo3HE1EFSNKM5WusZhqK394lWi2VIp6Qg
 RjwpZnuocjYlECA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspam-User: 
X-Stat-Signature: wk58w7zuk97y9syjrkx1c6eyxc8uwjnj
X-Rspamd-Queue-Id: 604ABA0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788145153-305467
X-HE-Meta: U2FsdGVkX19l3zEZcMmqmGg+2GPYvuvPbMNBMPnWtiOlIml0fyga+gqN+eEdehg2DykBCKt6xcrxXJEMnANP5kkkIXrM18hJOY2Pq/TYImFp0ee1q0AdBUB2U/Y3QwqNQe8IQVpVFy+tyH9wZ3KKpHVM3zeFFR8sgzOuJNzxstBIFQpyDBKYpa+W7FR0/k145uoH0O9dXhMb7IINFPNyWtO3Y4aHBDA89gJOyNsSG+G2WRlsD9SESvO9pHhMujzyJpHbFJ0zAfYmPNWEoWApvlP02+XjoS981H+Fz7zdsonTZpTZfgQnFaYKKoqIXYe3544/aym4eq/VPcw5/LbfIvLflvGnUqwjwlS27uEgfiv4GvpjLxgJnvMK8E12dzKcnwMpu/gjQnumpodyA23F6RMJyP6WH6VT9UUA3V4i0z2mWKnuNSUi8FEOUK7aJxWwO4qdWYXAX2S9B2tlxnQJSEbxLDRIvTr+1xUaJQdQlVKyRdD2wt9pcPdq50Yzt9mRaFow+mR2JuTKsLrz0Qej/tLJYeU0Kl6PIFVQU/3MXd1LkUj8cTMHDoOVakthjLQ1jElOi5fR1La+FLT7t4+xMFVnniyjH7g1i8+BG0PBr0gJ1OUwFO2d7L3xWo2DZ8zQfVwJA5fYphJPXGBMwaXM6qV+IL0JyKZ04Ec4eJo2NunAACzOWYBuSzrrLHskqjrO/f1bpw3WHblQd07hDR3ZO93oHVKTwoheoZqbRJisc/Nq4eOONWRbIezlsLYJgE0yhc4QxTKsXhfhqZNmCzZgy2JUeHsotwZN19u3ZfTBfzPXegDBK+H3mSjBrBmK2wI6y+Xg1jIneObctctULbQDVMQnHYI20C8yMg3E1MeWtzdEQT9fOBxhwWSmBu+nbUvJo/E96x6zzPFGnJe+zyF6VE76G/OZgN6ozA5m8arH1C1UCRoC0UA2FOOL7NYopbCCsY9jM8N2J0HhInC6675
 ucuofy2M
 QUb7mdCBvA9tcEiVKBQcSi4yXKAZl15VeFl7P41GQWi1tsMZ179Cm8rkXdaBng4BRtqA/bxEL+WioyixEq3lfUGyI9pxmLkXkhYqStPIZxAB7ziFMByQGp1LeqvQhokaWur0A/qtioFvbmHuHWisQvzKKXCII5MdeGIuY7rtgE11UisjMb6dmqsCr0bYADDaq3kVZKTwHIiqOZ7sM/y7DPnr4KbFITTB1PYHcTZrzYqOKm2jZ932xwLO8NZPxR5YXm12KNVlV7eH8pba5HhYpEt7YwE6TpBzJAWXF/myhlX1C4ItYrinkSw7P3oFFrMPmNhB+KNOx4Cxw6txrpubAOk/+IOvHXVyNbQ2I0BpUbleZAVKyphfjDyF+jXDlNimZ5EtZ
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

Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c | 115 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 44 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a6a643f15d08..49a1ab0c42f9 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -527,62 +527,67 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
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
@@ -664,16 +669,38 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
2.53.0



