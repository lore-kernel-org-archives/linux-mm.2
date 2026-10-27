Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9FB60A261E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W5ZchX38
Received: by kanga.kvack.org (Postfix)
	id 323446B0630; Tue, 27 Oct 2026 04:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E2D6B0633; Tue, 27 Oct 2026 04:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FEFA6B0634; Tue, 27 Oct 2026 04:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA8246B0630
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:46:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 633E01A090A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:21 +0000 (UTC)
X-FDA: 85367774562.13.1C849C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5CEC9A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W5ZchX38;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090779;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POBWiouFjcVL/0AJQbsFRft/KQzJa80eb9xN5M5sEJ8=;
	b=sJVM6a9fxfrnyRYHxsWOe3bLNIzGXLeE67I56EGq8HXP84ZSyed0yPNtIW3yzMg3NEvkOU
	nxf3JkPhv10x8cV8b8YK3oiVmGVrBXqYsCxaF9F8RR/iylZ0ePL6mNPbMbnv02p/T+E5KL
	k3y/WJrrPNMP/9PH8es0anmFiwS5a/Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W5ZchX38;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793090779;
	b=xPGKDpHbD2vR1YLCi/58gpWpFFxkaMxdTaZOFqK1XyT3Foy5pCUeKZq6e+7VW+iXZ7g/Uq
	MYFQUQmV9Gh+K3TabcAr3pP2Ig3cmfKDYfxrVHsTsoJXkAKNZcucrdDOR4yfq+HNet7eQX
	C//f8UrLk8t8UDjBpjHxuEjb1y+IlFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 114DB6021D;
	Tue, 27 Oct 2026 08:46:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793090777;
	b=oFaJh324rkAcE3eQsql5hBOUJVe51R+8iEGztZjUfwurILLyLRf9DelLj5uMRkkAhrh5
	 JfnOnnPU78dSdV8GYIfM+MlYu9AYFUDONfaRA5UhVoEtdVlMpPwPYxTdypiWh11tQzD8x
	 V+pV+JEP1+OFoWFbbiqPx+T3lArTjgSfjmswOFz1OCy5IE/h7Him+ZOOlOzzkom4ZzhiU
	 hNUBqNlMkEKDLxx1gQMnorHSEE1PbOSV2mCfq91K/nz2PT6BdZQT2NdBW4eB1xxEBHV4l
	 AlDd1QbGFIXu5m7daEubwNB3mMTYI7avEgCDmzSwDdYwhCp4OjV3iJ5fX8nAJxjQmNQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793090777;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=POBWiouFjcVL/0AJQbsFRft/KQzJa80eb9xN5M5sEJ8=;
	b=ktDSftT1n1zchHjZy0IX3hClJ86hy4+hTionTCrQgRW7q9PpOA7Z3B6wcqG4eoKiO/kH
	 ldnK4bjjfXc2lsjhHh3RH5W+WER+3Exczyc08jj6bEjKgPNiM7oagipYilHA/9GLNE5NQ
	 /Gzr67oRZUw2mPUm3qdQdwA4q5+GDq1lGDj1VkwGg2D4rxjJrdMTt4QDxz24Bp5rq3Bu8
	 0ZTJVEHbpNKUc4zXI6n769ESoMkbyQ7RreL3CJbN0Ga+COZMFNqN20XF4b5k3IIUyd6JG
	 QQ+Ba8Y7zKAVNyC2/AOY2sDdAaD2dglXNRMBmeO9Zuqe6lW1a1wa2J/jDoNHkZvDbDw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CE1A41F01829;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090777;
	bh=POBWiouFjcVL/0AJQbsFRft/KQzJa80eb9xN5M5sEJ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=W5ZchX38po3lOGVUegKZZxmylL48xPKsRMfC08ksahq/NWISW9MwBmaixJ7j3TaH+
	 MR6Lv1n1W2X4aKf5OaXa3v7wUWnasZDwFVulLV76921aR+YX8dsCAlJUPwUHb0yeSI
	 orGK7wsFmtxufeSnKI8OiNYOUu3EE5vbMfoo4Xnb+1daEuOPGWG+SD7ELHO/F67Exq
	 ntn5qqKM2BkEuje+cUQRMNP8hiyTe8KKl9sXNvwhHZA8SClk0+AzJOlNu/tRVdS6mz
	 tY3u3oaGzCT4IHdJWPPBR1diftedPqj/N1C4rti1xPx0NrMjN+9+AvWmnoDoENQK6p
	 3bbZ3UB5GTUVA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4F2C945051;
	Tue, 27 Oct 2026 08:46:15 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Tue, 27 Oct 2026 16:46:08 +0800
Subject: [PATCH v4 2/3] pidfd: Use scoped cleanup for task access
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-pidfd-get-paths-v4-2-e2a6a47e3c95@black-desk.cn>
References: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
In-Reply-To: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5558; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=gzvhhroq0taD08thWsIYRMrkzi7RjkED7WAzCrTTY6w=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq4GTTq1AmHKjZusegR8P9nHHjSCtmnug2b+9aT
 8eLvb5V5DiJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCauBk0wAKCRB2HuYUOZmu
 iyQDEADYHTpHnbirutXyO9Pkof4XYcj5t298WGhEVy4YGe7vV5nqUzyfb+BecJlkF4qJQ3gJoz5
 WnQmiPN8f3Uum7LESzs46kXOug+XwjrNXO2F4Cagh1bgG0SbPjW8eZLw3f9biM13wIdkoQUvp40
 qzkmBG4Wv9tzr7HSSTM9+TtitKrtudsTWAHsXwGUI5xv9WydDy6yHx8F4G5PEEY5TknFvLRjeGt
 CjJLCRwCIAEtmU82BHf21o0YAcEbbE4KpGxSHsYn9r+HcZhX0wGS3nNxtvAHx9CTi020ouly0Cz
 5sqmkwSFs5Al8RhrCv4Kq85ebXJLReL9NsNmv7q4djiO4dWQgjtVVzGMuEAj+V3Gq4MvTY87tTV
 eHD+ZOpkX667rGpcgz62DTtmwe6liJkzfD/p4bLJ3YGKJncL0ewUJucNywO0HNk0/UQw3EffzOj
 XPhL0c25g4ANeGcsXGYi83e/AOqPUrxoVtbO3btzTHiHF2W/F6VqHgkgw9TUoS9BmgtOWBy3Oi0
 QN75hPbuhgnPiuzQRRSA8genBLRNcBjhQzjsur/4t/DGJ7MQW0yQEB9fWjqS/BlbIlvj6YB1nr+
 3ZY8KL9PdVzdAWtWdbTFlMlyao+AvlSOrcI+FA4T4zk4leohVDGLobJlOSkXkyD5ZWpN8AauioW
 X5oFQRRe8B4OM5Q==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5CEC9A0006
X-Stat-Signature: kgad538tqsj5d3eeoy3uirfqk8p3ajfw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793090779-132470
X-HE-Meta: U2FsdGVkX1/6G9jNt6Y5jYCgtHYKOxPr6hw8JrFM4Mis54PHdEn2/eoj517wfT9LJ+UpsGSrMWdbYJnYiYUhq9NkGhSZ63uYwi0QMP6ef26yZHL/5TIkdlE1xeJpkfrDM5zxcKvdrU7PC/GuHHxle08SuMUU/0MZYAGZXQcDh8wi9HKseTqcP+SaNET166enFevgD8X6H2yki3pV1Hkex2I2gR5UU/iY0or/ldNh2QA50MT7AMDqaIi8lRe68Qq1ZUYYkJrSJpj1kFx8g7PCCNxDfCt5fYumQhZur8wH9EgdmSFVQawdAFODFWr8yn1TVD+84KLC6xXxU+ERXeLUj8CXbqDqeOuVJa3mTotGb9wf5oyeScvPDm7lv8DyqvPsyUPOjfK7bf8coEyinYkr9IPuvAMRa6N5MPdAjQfehcSuiELHRetPObda/k1XqdpBFd3wpnw6k/zShNNx/UO6Lb2ncHZxDWyJYsq94HaRRioeEChTxJmPgA1v9LO13Y+XIiAFOzFxIX+FpUwZ2muSP1yl0W3tr29Q5ae6/5vXRiRnGbwwsAdG3bhaMIEj3rAbv/rn/u/a4LjFwM55R2/ciYdZiSk9ErG8BlYQLIryKpLhoWUT1/IpEWur17EeDiFPU1pE5GSXzuThETNDEBI7+7ojfJY4ycWWZWn8ZiYpe0Q08NJUlm4P0izienailKciULVz+Qb7A5OWvnNG3qXa7wQJX9DL94EnT6vByIbm3Qx+eIVVnL0SYUKMDS2jshht6vpnpjdW6OILsrHY+nUbgblJTLBEWb3U21GDXEbWMd7uN6z/b18VwXreQicO6KDab6H2mmRDNwnRfmCm5IX2s5NSyEbbBAILUD/jDP4yYlz/fOXXvCrUenyvR4xqYXFjCFDLhj+2DW3cJVuiFeNvP2D6WADrcLdsBUKrnan0Qs8S/VcEo5GQ/oPSHIy3oJqB3e49rZYE+6FfSHTpE5g
 jWBPybdH
 xKiRMSRJzcUPDFkeF4EkzxdiPSNqbWGkEHS3JK3Ir7xQKeEsLGWr7/+fVbODkJC6PYHA1tK+0Oqxg/CTUUu38zb5jHPlhoN/zptJ0KWNR2CbTiLHU+peHe7r4a+n0EQyEkJ8M/87eolN0d7pLeTRNdcaw/M40vy1WkraEqZLYaQ2wVUKHHYVcp5D7Hwiky/vqzjTlKliCcZcpYlv9wK5ekm1YSDSaNpC8yqmrQ4uosJMmf6oEsFtok5Zvw69zu4cKdkFp8DlIqBel1VqDdULBd0+kqEnM0CyFuBj2xnT4lzDXUPpPUEHtpLd6mdGVS/9RxSigiCU0nlp5TNu7rPLgTeEbJOMYM4u10+OD4MzEHJmgNZQvbHPZwC0LNeHLaqNvNW8fD0H7PxqtQrf5VlmoFOQT0MOz5JNgmVdoe8ehsmR7Shiam4vtjT1Az2+abayGbTWT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chen Linxuan <me@black-desk.cn>

Split namespace acquisition from namespace fd creation and represent a
privileged target task as a scoped class that owns both the task
reference and exec_update_lock. Use the class for namespace lookups so
ptrace access checks and task state reads remain tied to the same exec
critical section, while open_namespace() stays outside the lock.

Carry the pid namespace visibility check into the helper so that all
users of the class enforce it.

Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c | 120 +++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 46 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index cfb93c4ccf23..b70ec50f64da 100644
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
2.56.0



