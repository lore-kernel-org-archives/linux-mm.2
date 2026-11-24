Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE3D606A338
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSVRCz46
Received: by kanga.kvack.org (Postfix)
	id E93D36B088D; Tue, 24 Nov 2026 18:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7566B088F; Tue, 24 Nov 2026 18:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C709F6B0890; Tue, 24 Nov 2026 18:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3C46B088D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 246C41A0CCD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:15 +0000 (UTC)
X-FDA: 85471532790.17.15DE538
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5271AC000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSVRCz46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561213;
	b=qbf8qXoCd4KufGmWFkXRtG0QXbURW6QJwCj5+/wdHMe5kWUELbN372dmBfWGJuOaGCA8L3
	v7U+YYd9AzA7GBGMgfNGDV4OwW1xIVcMEvY7r++/IDXVMQtYzTZnjGQtnh/V1+q+3GX2s9
	6zjkCX4neBiQSDcm/ReQxAgVes9cwcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kG9Qh13joT/rVCnoPcocJxtcYRE0b9tjEwh3hGBMBRQ=;
	b=DoaNOmYRMvi2sJJXiOO6u1FcB6/voPo8vBDL4IpkCOZxsjXa1vHaiuZeVMHsu28xqYZKNa
	LeMCLMlKLiVXvXH3rLAqflDqDgEJ6RktmiS+Zxxk+k6QPqY6CWrNIFWbZi8DVDl5OxKyoq
	S+oh1I9rSkXcNQ9ToDbyYUF0iOzdgYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSVRCz46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E131F625AD;
	Tue, 24 Nov 2026 23:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149CA1F00AE3;
	Tue, 24 Nov 2026 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561211;
	bh=kG9Qh13joT/rVCnoPcocJxtcYRE0b9tjEwh3hGBMBRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SSVRCz46ehCh55Kj4DqnxRYUuOiDxe0mjpCZdwE6ZHxs3DLXenc1NI7Cq8lulVJDO
	 i6XAwipYoR4lcEd+4h2gBJ5KS/J8yNW2M/yo4zqHTspksPgKgXy9k3E07WIyG5S59L
	 FWIn8gyYfZKMc8y0pBBaZeeEd6FtVUYEjGp5I2W4LbZYpz7K5RODom8YqpfiyuXwik
	 0ojvkZNBtOUaFSk5wm4RBKo/2gk2QYDvoq41zL4b+eOe5WodKuEUp/B2mf3otFzaNg
	 g/NpyMEP1o6dhODIfOaxkHZqVCSL5X/iwo6yQRUh6wddQsuBJpFvdDikPa5vIere4B
	 rx6X7SrEIjLQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:34 +0100
Subject: [PATCH RFC 11/19] selinux: revalidate inherited files before
 taking exec_update_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-11-e489035395b8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4552; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qkAv1M929y64I19wC8Cu8ZECHEnR673EN13elCJRS20=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziR0q+nvvr9oF1h5306fr+5I0luzUbvljePvsvK9Tp
 JJ/eord6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIGQ9Ght/sOT0ftvlf9Q4Q
 VNBxjA66dco+PV7jNFfCvL0nfRb/y2D4K9Tz5uv292sPGScXfpxa3leaeDlEZsXBpzfclq7KXzG
 rjAUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 11at36app8c4u3o8bm6n9hh93xi84rym
X-Rspamd-Queue-Id: 5271AC000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795561213-121154
X-HE-Meta: U2FsdGVkX1+yIA1x4oWqPD0a17hfG9G5yvNT+paMGuAbwBhIe6A7+iXrog8Mm004pBzha9sFasXWYPEyOJCIxul9Jg3wKJCfhTUvkguZzMbioUx1aZBPQyj6nxbAvWW73ANx5f7GsXSbRXD65bJxb3a+IVjPYAkiBZ04sVZPP04F+hghM/w+Z8wzkr+UfL4uGu2gX3u43gsUOtOsVKrYhRVuk6eSRKJLf2OMCPnBmqA5ehAQQRlepWvKqigVEj8hZwMv0bRc2qBKcmG4ygpEpUwI/fL2skrjoVO9tX0oPo3H9DskcS/szb6AH0Q6IH+sYIUjelcRN9fmyVBRJM/KxvKa8iT9XgCICorQQ9qv266HJxvmWB4VHYw6KGwPrCeBuhP5qpOnsZXPxPbzW5nOnMD5vVHRhYZWdiK5fvvCiZxW8AHgobU5eCoPmR2rwcqTLdZ8BsMYhBTFNEynZlEgFtlSjScULpjuibXF0FTr/HXqMmySGe7mGary5GYY/ggrZQqVM+AAMN8Sw2NYFaeJSFQzErnuw06lxkbIMrdWhvuju7eO0b5mna2F7r/uRF0Qm5TRXGKCIBSGWi6T5UoMHja9yIwQ6O+9ldPuRwcJPi7yISVjXgsz56aWcAChk8y5cc+ifQueUc/IaNq07FXfLccwMzmMjnZitFVu7vzekCHtcUdsmWTCBk3spfXr2QnmRNZXghLt8bJ3prXgX/eWilyd672nerspTKXw7SICgkKP/2VTX5SROqpjtD9klLhWV61NYtUX/KEd1oqZ83//WuVb8M8aHeDRmvU4OpyZwtjcaP7ui6ara01kZkX6zpIIA1gON4QEcMjbHizACGRn6EpxpSTLvIpbmfaYRRBqpfu/QQl8zI+ES2HEJi+vqJbSMGB1LKm9HRI+fg1IrLtD3h3r7M1e5A+5ocoMatfAMZKCX+LgvMv9lWnO/bKCbdTgeeBW5ChAqbHwdrFPv0L
 InV8sgz/
 kw1tP58f2xOI4kD5bpAojMaCTCRG1cfXBlHOCMuuYHuNqk2MPfsF2Xw0SZIcZgPUITTJ5mppDRUuqyHlgMZLpGwx2GqBMlSZHOs0+Yat2JIGufIerf2UNSbDsZ77UqGdRJWzDGTDg07v/jqfzXY5y9bFtsWAQccZMLmFPfPEegnal58E18v0knO7u/BxxS29VWf11lIrJL73WfRh9F8Gxkzk6vNzwe7bvOE2/zbnbRYxdRHyZWCjQH7LU4HMMQamy6aOE9pknWDccU7ukdmCEaoqYGbN8hWXpHXoaMP5ZDMcWzS+RQ9Widc0VJIHZST2Q5srIxocddxDm9tKKAGSLFINNd+AFOSM/E5oHrRR0trJ+7x06Up7JbiVItlS4QKuDphg317L/3j/bcG4QGZThTNC7MiE7HbGBnsBE54+5JKUGnSN7AtQGtIQJpGLi4v5yAcjQEqP1H7i9ro6ieMgDJBQ/4kj6Ba9uYuNfZQq/9ayC+dQcM/9lE3YwmFKbr73InZSyzlW79oD323o5j/9036IC65rj/NEiwzGj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an exec transitions to a new SID flush_unauthorized_files()
revalidates the controlling terminal and the inherited files against the
new SID. Files the new SID isn't allowed to use are replaced with the
null device. This is done from selinux_bprm_committing_creds() which
runs with exec_update_lock held for writing.

Replacing a file closes the old one and so calls its ->flush() method
which can block waiting on the filesystem. So a hung filesystem blocks
everyone who needs the exec_update_lock of that task. And a FUSE server
that looks at the task it serves the flush request for deadlocks:

  exec                                 FUSE server
  begin_new_exec()
    exec_mmap()
      down_write(exec_update_lock)
    security_bprm_committing_creds()
      flush_unauthorized_files()
        replace_fd()
          filp_close()
            fuse_flush()
                                       do_task_stat()
                                         down_read(exec_update_lock)

With a FUSE server that reads /proc/<pid>/stat of the task that sent the
flush request the exec hangs until the server is killed:

  task:se-target       state:S pid:143
  Call Trace:
   __schedule+0x53e/0x13f0
   schedule+0x36/0x100
   request_wait_answer+0x1a9/0x320
   fuse_chan_send+0x110/0x250
   fuse_flush+0x1af/0x1f0
   filp_flush+0x33/0x90
   filp_close+0x12/0x30
   do_dup2+0xbf/0x1b0
   replace_fd+0x7e/0xd0
   selinux_bprm_committing_creds+0x1a7/0x2d0
   security_bprm_committing_creds+0x1e/0x30
   begin_new_exec+0x6dc/0xf90
   load_elf_binary+0x12a/0x1990
   bprm_execve+0x39d/0x870
   do_execveat_common.isra.0+0x165/0x180
   __x64_sys_execve+0x38/0x50
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  task:se-fuse         state:D pid:142
  Call Trace:
   __schedule+0x53e/0x13f0
   schedule+0x36/0x100
   schedule_preempt_disabled+0x11/0x20
   rwsem_down_read_slowpath+0x186/0x5f0
   down_read_killable+0x78/0x1b0
   do_task_stat+0x87/0x10c0
   proc_single_show+0x67/0xe0
   seq_read_iter+0x11c/0x480
   seq_read+0x127/0x1c0
   vfs_read+0xd8/0x4a0
   ksys_read+0x7c/0x110
   do_syscall_64+0x110/0x600
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The flush is a forced request so the exec can't even be killed while it
waits for the reply.

This is the same problem that commit e780259b54e6 ("exec:
do_close_on_exec() before taking exec_update_lock") fixed for
close-on-exec files.

Fix this by moving the revalidation into the new bprm_revalidate_files
hook which is called before exec_update_lock is taken.

Fixes: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/hooks.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4ec9ec723cacc..71ea94f663772 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2529,6 +2529,20 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 		fput(devnull);
 }
 
+/*
+ * Close files for which the new task SID is not authorized. Called before
+ * exec_update_lock is taken as closing files may block in the filesystem.
+ */
+static void selinux_bprm_revalidate_files(const struct linux_binprm *bprm)
+{
+	const struct cred_security_struct *new_crsec = selinux_cred(bprm->cred);
+
+	if (new_crsec->sid == new_crsec->osid)
+		return;
+
+	flush_unauthorized_files(bprm->cred, current->files);
+}
+
 /*
  * Prepare a process for imminent new credential changes due to exec
  */
@@ -2542,9 +2556,6 @@ static void selinux_bprm_committing_creds(const struct linux_binprm *bprm)
 	if (new_crsec->sid == new_crsec->osid)
 		return;
 
-	/* Close files for which the new task SID is not authorized. */
-	flush_unauthorized_files(bprm->cred, current->files);
-
 	/* Always clear parent death signal on SID transitions. */
 	current->pdeath_signal = 0;
 
@@ -7690,6 +7701,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(netlink_send, selinux_netlink_send),
 
 	LSM_HOOK_INIT(bprm_creds_for_exec, selinux_bprm_creds_for_exec),
+	LSM_HOOK_INIT(bprm_revalidate_files, selinux_bprm_revalidate_files),
 	LSM_HOOK_INIT(bprm_committing_creds, selinux_bprm_committing_creds),
 	LSM_HOOK_INIT(bprm_committed_creds, selinux_bprm_committed_creds),
 

-- 
2.53.0


