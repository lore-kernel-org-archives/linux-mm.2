Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EF3606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LM514mES
Received: by kanga.kvack.org (Postfix)
	id 7668F6B0879; Tue, 24 Nov 2026 17:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8C46B087B; Tue, 24 Nov 2026 17:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590BF6B087C; Tue, 24 Nov 2026 17:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B27C6B0879
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 742CCC0D5B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:36 +0000 (UTC)
X-FDA: 85471531152.27.1F95BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A145920003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM514mES;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561174;
	b=JQkuDfv997p0kokj4zUG+CybNmrWAD3+YvUVAOOtcXzfutiJOfc1F+XjEw1vgl4TaXeGi+
	a3PQRbjXsT3T/MBHm8cUT+VonDBzKZts3QCwXuqAqgIoKEVjtlPhC3jnpTq9nnjVPue1Xi
	hudRq2adQtYppxP59BaNM174evAlhNA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ap7gSe/kuNeWblDe+ZfPxsux2kFQeqvhMXOEp+llOPs=;
	b=EYLT+W0poD0wJLY45mkH6Ab8b99i5aFX8QnE892+lFXSrWFfY3nGxF+NCXIRPyfrxVQjw2
	bF/8ZXJQIffPSoejiqHS95f9rBK4Cazzq0FYwVLpIBZS4EHnLVOpHD8U6mAFwxWt6H7fqP
	p3NZXgMP5ORaMt6cGsXMZoRvu+LDb0o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM514mES;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A0FA6126F;
	Tue, 24 Nov 2026 22:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1245F1F000CF;
	Tue, 24 Nov 2026 22:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561174;
	bh=Ap7gSe/kuNeWblDe+ZfPxsux2kFQeqvhMXOEp+llOPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LM514mESwwt6WU10mCghINlN5okJv1Fb2bAXW+OkNtX+LBAJNrQeDTtw4fFARY+eU
	 Vm9Rpqo+5ipsesZC93l8C6m6f8S9wKRHx7FroRQPEdAcaWs1HScN7GTkIXaCWVKwm9
	 tsMjYFHzmig78IX5VyZuxHaCllmSJu3ysTB7kpkyj9GVHCR3HxmtDNS9Jot4UZ2Fi+
	 BgHfdp/CUnXllRhT8F2a9csbix1k2nMEOGDLtA7HJqJlDnOBys87ZBdV+JNrq9d3lT
	 LZb4S7Zlcq9EmjUIlwqGORUysPd84a/mSy3/qzI09h92rl3C9OeE2sspA/7SiJnrpC
	 D5MJY8lnoH68A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:24 +0100
Subject: [PATCH RFC 01/19] proc: copy namespace link after dropping
 exec_update_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-1-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=2802; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lGDUzty6NPq+z3GYcxQr0PrIQZY6uMG00NxetEmFkDY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziW2TOKQonVvLlloyv95ovkQhFzfH5uo67VkRq5PMH
 uecVvbpKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEjzTkaGT/sFNvGf+FNq3Mnc
 xWbE9Fj6S0NauUpDVLRM/e60QJ8aRoZ9Ua/YeALSd97rPe/jKOKwm6nw5hvrGVyMPFnLGjyF85g A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A145920003
X-Stat-Signature: a1eygaj9xrgh149y49iwkfepmu7uxfdo
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795561174-501020
X-HE-Meta: U2FsdGVkX1+rMExHmYBVSflL67VvSUMtaHPIOOHo8Ly0GWB49wd8QU+/QtEMuLzn5yrTVUxZU+klJpZj01OautX7ZNFixLlTvQh1vNTSOM7puTenDn8+a18zKcCMYpZxR5vpuvYEV81Y/oW4g7kZsMEZCEopM5wwCpnBM0bVtonZGgJiGNBbIwV1HkXnpX36HyRUEuP3JE+ghyoyMjJthlegxGZxuAossqorVeZ2vAcHaeZ0eBfGyf7mWmZXvqfzXh8IHwmUrU3BBmwNndR7n+omsXhy9Md0Bqp/ZTs5RdRisOSHjV+w1p2VHYPDKzXZDS+hjL8oYnfTTxTqoU14gb7tZU8NZcF+yKpB4hE2lQeeTEP34rZHp1ZhmT/TzoykhLXcgZFEY/EHsQYrgiOc4MBf9ZkgLtWd1lY/SVebRjiVBqNLdmcmAHFIJuhz6vDC8ApGcfMfPeyVl52nmWOxSsm7Y39ppskxkKnkk6AgzpIqAYdhVIwJrVnrQArKiz1TF+8nmJMO1U85zNopfPNd3g+YKfeAHjWqJnNEaPrxa2NMzc33YI1ERwW2MX8lccUgWq5+TkTvBBxK2VXJtBTidc7gI/o1z0oV/hc079mFvg+2jEL8mDK6BBAeSv1vSSxK2Kib1Fb7pUweHtRhtObzXZp0tLQpCR2WmxIdj/qEOl1JLlxomCCJrT9qE7Zg3aRvFp3HfeFpc94V8PeH5oDxJYD+5v87kZ467uSrI6CfxU4s0GPOKfRVisZN5XxnLtXhvTbJotIZbx4in6Anud8f5Uz9fIVVaX3xg2LiSHgOe1wyFZK9NLuVtrf84sedENMbSUUGs5+9jsOReMefAZ+d+o17v3RrghFFCTJiDd/ZZT4d2fw6F7qcd7qyNbjV4Q/JNOolp7TQAv0Ad5+ecnK23rZ8ujNqwWYjTfv4sC9qlYw4GG0wgLk8Gbu0DH65U11997Om1mvkrWxxE5bCYbm
 FdXYWeCL
 2dPSM0BYdMx6GXrLdQzwJkMuFn6F26SUGPs7oAzFBhZuw7x0Ary8l5RLHQSd4BiM/rAEO7IAoOVNe+YQN/G0mqGGqNLX5KjkGvTniWHeRyob171EAmf2kUGS/pGR0QLgFaqEd9lwAyAOo/FRD7Myi+cVsbMtJ6KzfAVbGe+ZUnskVaZF5RvC8lPYfvpqjQp4ePGagVkxd9MAz/eMsf4o/LADKb3ewBW7QENATko48xJvLAKBuY0InBZNc1ptP8ge0vWTHzA3l+8M92NEIH04WTTmxhTk92u3mRMOxupKnkccJUPtDfcHWAan8SiBTRgE14CKLEBywsu/BUZjSbfj3fIBO02R0LtalYvIb84PQtfMfH1IEq2BKdGLvxZBmEowPm3vaWdXgpDnDbJfFwNmVgA300Qrbgb+5pVTfhhwYtFrsfK/mWkFsnH2cirtjtn6EFrQ2V9UltZvFK10ebMd4OedCOdGCCXkGHkbdS5bzK8KSVwDWlW4vus9Ry6/CimocQrMdHOkwNXxcRUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_ns_readlink() copies the name of the namespace to userspace under
exec_update_lock. If that faults the lock is held for as long as the
fault takes. With a buffer in a mapping of a file on a FUSE filesystem
or in a range registered with userfaultfd it's the caller who decides
how long that is:

  locks held by ns-reader/230:
   #0: (&sig->exec_update_lock){++++}-{4:4}, at: proc_ns_readlink+0x180/0x340

In the meantime an exec of the task waits for exec_update_lock past the
point of no return. And everyone else who needs the exec_update_lock of
the task queues up behind the exec. So a read of /proc/<pid>/stat hangs
as well:

  task:exec-task       state:D pid:229
  Call Trace:
   __schedule+0x1691/0x4b00
   schedule+0xe0/0x2e0
   schedule_preempt_disabled+0x11/0x20
   rwsem_down_write_slowpath+0x472/0x1820
   down_write_killable+0x1ba/0x240
   begin_new_exec+0xa4b/0x2df0
   load_elf_binary+0x340/0x4af0
   bprm_execve+0x772/0x1400
   do_execveat_common.isra.0+0x3d9/0x540
   __x64_sys_execve+0x8c/0xc0
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  task:stat-reader     state:D pid:231
  Call Trace:
   __schedule+0x1691/0x4b00
   schedule+0xe0/0x2e0
   schedule_preempt_disabled+0x11/0x20
   rwsem_down_read_slowpath+0x5cc/0x10c0
   down_read_killable+0xf1/0x5f0
   do_task_stat+0x13b/0x2870
   proc_single_show+0x110/0x1d0
   seq_read_iter+0x2e4/0x1280
   seq_read+0x29b/0x550
   vfs_read+0x171/0xb20
   ksys_read+0x111/0x250
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

All it takes is being allowed to read the namespace links of the task.

The name is formatted into a buffer on the stack anyway. So drop the
lock before it's copied out.

Fixes: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/namespaces.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index ea6ec61a0430b..4c91ccbed21ef 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -92,12 +92,11 @@ static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int bufl
 		goto out_put_task;
 
 	res = -EACCES;
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
+	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
 		res = ns_get_name(name, sizeof(name), task, ns_ops);
-		if (res >= 0)
-			res = readlink_copy(buffer, buflen, name, strlen(name));
-	}
 	up_read(&task->signal->exec_update_lock);
+	if (res >= 0)
+		res = readlink_copy(buffer, buflen, name, strlen(name));
 out_put_task:
 	put_task_struct(task);
 	return res;

-- 
2.53.0


