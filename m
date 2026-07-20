Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA7AC44525
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0966B00CF; Mon, 20 Jul 2026 05:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B476B00D1; Mon, 20 Jul 2026 05:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302006B00D2; Mon, 20 Jul 2026 05:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1A1F6B00CF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D2AB1607DD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:30 +0000 (UTC)
X-FDA: 85008644700.01.14B4016
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C503418000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtcLvcUW;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAKUaYj5DHW9nm1lOWEWXJhJ77C/0u0qe7FA/HC26JE=;
	b=cOyrxrIIW0d9IXfFlNm8NGzJDzuMmU/konJM650lSZLpNwnGZ8+LVifvQqMs+dFA+Jqou2
	+GahbpByA80sJ9Fh2OnivYwAfIlNjSU5mzqdRn/la8BimMuu1d7WMrZXO0heF+KB3fBUyG
	BetUSFSaNbmTHfVJaxBlJbRNi4O2kb8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtcLvcUW;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540068;
	b=hGCPPuobcn0x4/WA/FQoimHw0SllPYjPZVTMFBMuts1Gqp5vxQAtSS3pUyuV+iRHaB8mIv
	XUd6YHgTwsTJ3DZ4Ya8NQXJF+wPnEyscxKPXib3mbxWFI5MA3aHag4j99p0Zojt2lHBOg+
	gA/SB6ssayfsZarPJW90HzzQrDNBe0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 661F060103;
	Mon, 20 Jul 2026 09:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4665D1F00A3A;
	Mon, 20 Jul 2026 09:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540068;
	bh=wAKUaYj5DHW9nm1lOWEWXJhJ77C/0u0qe7FA/HC26JE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PtcLvcUWgji8C06pO0Nbhwhuinq8erGH6bGMb88UpzguOUqi8cwYu177TSeZfq3nK
	 JuOIjRKM++e1kFvETq/72YFxc1wl+YD+c4w2LS+2ftIdOm/K3OaozZBG8PrkqH+lMB
	 Z6X4uxML9bRxF9qiy/G8m4nYTuOUCeWApMNvaLKGConVh4HB0sGHgBV8KVnUBz0WQ/
	 +6bz2t91NfmIm2BVuBg9Mc0bfjCI9CAiTo+Wm7+oxFMQjhnS6RqmWc9ZwwqSgwwkC8
	 alnweCozFNKlHCNztQ029Go+EDXQN9BTkXnG5fCSjgjZmEKckkj0bMgzeOE+ofzutL
	 ib61ufI5orCOg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:32 +0200
Subject: [PATCH 09/21] exec: label mm->exe_file with the binary for a
 transparent dispatch
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-9-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5670; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i7lH8bNEiRx9Hi67BUFlmbcbsKQKKwiaM+41Ap7Y50w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm5yv1tXtSltJovFJx2r1+qzFujUPQ37qJTg8zWDq
 9C7N4Kno5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLPgxj+x6oHSVama7zOueS3
 73DIwaceCj0m7v+/XNXeFBcuci6DgeF/hceE9XcbtliXcfyTFpjLVPx1y/vnx85u+Xb8y4zDBcq
 pTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C503418000E
X-Stat-Signature: hydstxhno379ohfwn3icwo4oicong5i8
X-HE-Tag: 1784540068-243141
X-HE-Meta: U2FsdGVkX19OzGPEul8mdVZt4iJUtMiDPJXLpz7OXJl3VCYp16k5TLzKTFjAc/WEzJWPfSfKFiNhr47vi6aD7wyWrDA1y3qzQgmRD+DJ78rvZ4lvnYwKd6qj2aFVjpSD6o26ZX9ctPbljQlTfJCA3UpL8nYx9RqG15N9iq3KIlRq7q96JaWx/JiYbY93RpbNWTbQVg2d5pXfHlOPp5tyJItCI2wNsChxULV/kGhFbJV9TTLu+OefDjftGi3kpZAyLwhrLFWmITIH522MaiAp6lwKTBmkKl0tYkRviflk5z/NnA/mURRvcjgtAqHrggUd0EWx9wrlMUUpMxTnkFOWudYDY8KY8i2kyQ0GoH3aDmwznNIOQFoR70FCqExPTIFWNNge9gttYGy7Ukt+MdsuKYp+oODJH/0z2l6hP2qYxAi2A28xKEk5ur0UK7gmTUVV5aypy4Iw0yYI2Hihwim+rq4yXYAkhWbczmb60fkB0Ou4a3TluHZ6T3EAtdercphCv0pVMIdb9t7c+hyDKDSZVHtSxYVirSMC5pyoUVbdD+JPKSWuBemGlko2R8OwezPDbBW0edvHAuH7o044Bsv+3JlyfpJQ6LLHik+0zwxb/sfNJdDufEGcMpE6EjomOF7ch+QVCbpKmny3BhiHYo6W4s70YxliolOqaAaEWBHAoBfZ2oVuaIS+5UWlgCZbVdpeL8/EghU39Z20o+edP9qdci5znTb07yjiaeeAYUX/pspu1GpRZNXU6iz+DFGqTeGI9zg46qlHXIQix67+Iditd0WeDYdXox7EhF2iBI13KCT4nsg6EAzYLfeNaOzjfZfu+Cseilqhans1I+KwnGc+jqDuj/mcoh9Qzf4UuugejiNrRJrYMoEtnh0Tle2bDqGfIAt9eEEyzryX32klayrTV//zHjexkTFHBQQ4O2NmKjKBvFJfUl2tzCpRpoO52+hue54ToiQQtt28O6qeOYP
 JTClWP8G
 5++kar3QWKkGag/lmqcnmK9qJCDbmQP3qaBoY/K7ifES7Geawh2vq5Nmu2VKxTwGe1mwPYVbidX0o+13AczMAG9cQtVmeESCnIn/be6kbDymhNj2pInZmHHr5T+JjNyD+qPbq9fsPLzcV7Z8p9WkFloN4U1jWdtnx0C8dCTFsFobm7z9jJoZf99mQeIq+AstWt++0YbNsxB/fq6NQsfTJ5lcaskSGfsPdCnO8o3UG5Q9Naq455DzdsNBt9yc1IzBqvBOTwEMrQ666HdRYZPYMEKsf/Sny9n81ONIap3uSjX8I5HzFtUNOjZSWsa7wuP1y+E/SomMPl6m/E6ou+qNwSIrm3u3v3codf3Wv2SZxsjuVlSow9yXoILYn6ZC1uAUk9dvmw5ep2oKXyguewlMrDtYwPR579myvGNAysZNcp6e8s0DDE8lOxf3FxNAQwKhaB+5i3aNhI00/DOgXxGsDEuJ7hLvpxggAn3Mm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When binfmt_misc dispatches a binary to an interpreter, the interpreter
becomes bprm->file and begin_new_exec() labels mm->exe_file with it. For
wine or qemu-user that is the point. For the transparent mode it
defeats the point. The interpreter is an implementation detail and the
process's identity is the binary. Relocatable programs that locate
themselves via /proc/self/exe find the dynamic linker instead [1].

Userspace cannot repair this after the fact. The exe link is the one
capability-gated field of PR_SET_MM_MAP, deliberately, because an
uncapped exe swap lets any ptrace-capable process masquerade as an
arbitrary executable.

bprm->executable is the file execve() access-checked and kept open for
AT_EXECFD. It is already the file would_dump() bases the dumpability
decision on and the file bprm->execfd_creds derives credentials from.
Label mm->exe_file with it when the dispatch is transparent and the
identity is correct from the start. The label names precisely the file
the caller passed to execve().

Write-denial moves along with the label. The result is exact parity with
a direct execution. A concurrently written binary fails execve() with
-ETXTBSY at open and a running one cannot be opened for writing. The
interpreter consequently is not exe-pinned and matches the role it has
in a native PT_INTERP exec.

Nothing sets BINPRM_FLAGS_TRANSPARENT_INTERP yet; the transparent
dispatch machinery in binfmt_misc follows and raises it from birth, so
the label and the aux vector bit that announces it appear together.

Link: https://inbox.sourceware.org/libc-alpha/87ik6fymha.fsf@oldenburg.str.redhat.com [1]
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 33 ++++++++++++++++++++++++++++-----
 include/linux/binfmts.h |  4 +++-
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6e540f4b43d8..45d416994682 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1101,6 +1101,17 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 	perf_event_comm(tsk, exec);
 }
 
+/*
+ * The file the process presents as: its exe link and comm. A transparent
+ * dispatch presents as the binary, which is bprm->executable.
+ */
+static struct file *bprm_identity_file(const struct linux_binprm *bprm)
+{
+	if (bprm->interp_flags & BINPRM_FLAGS_TRANSPARENT_INTERP)
+		return bprm->executable;
+	return bprm->file;
+}
+
 /*
  * Calling this is the point of no return. None of the failures will be
  * seen by userspace since either the process is already taking a fatal
@@ -1157,7 +1168,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * not visible until then. Doing it here also ensures
 	 * we don't race against replace_mm_exe_file().
 	 */
-	retval = set_mm_exe_file(bprm->mm, bprm->file);
+	retval = set_mm_exe_file(bprm->mm, bprm_identity_file(bprm));
 	if (retval)
 		goto out;
 
@@ -1247,6 +1258,8 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * Let's fix it up to be something reasonable.
 	 */
 	if (bprm->comm_from_dentry) {
+		struct file *comm_file = bprm_identity_file(bprm);
+
 		/*
 		 * Hold RCU lock to keep the name from being freed behind our back.
 		 * Use acquire semantics to make sure the terminating NUL from
@@ -1256,7 +1269,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 		 * detecting a concurrent rename and just want a terminated name.
 		 */
 		rcu_read_lock();
-		__set_task_comm(me, smp_load_acquire(&bprm->file->f_path.dentry->d_name.name),
+		__set_task_comm(me, smp_load_acquire(&comm_file->f_path.dentry->d_name.name),
 				true);
 		rcu_read_unlock();
 	} else {
@@ -1300,6 +1313,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 		retval = FD_ADD(0, bprm->executable);
 		if (retval < 0)
 			goto out_unlock;
+		/* mm->exe_file carries its own write denial now. */
+		if (bprm->executable_denied)
+			exe_file_allow_write_access(bprm->executable);
 		bprm->executable = NULL;
 		bprm->execfd = retval;
 	}
@@ -1419,8 +1435,12 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->old_mm)
 		exec_mm_put_old(bprm->old_mm);
 	do_close_execat(bprm->file);
-	if (bprm->executable)
+	if (bprm->executable) {
+		/* A transparent dispatch still holds the write denial. */
+		if (bprm->executable_denied)
+			exe_file_allow_write_access(bprm->executable);
 		fput(bprm->executable);
+	}
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
@@ -1746,8 +1766,11 @@ static int exec_binprm(struct linux_binprm *bprm)
 				do_close_execat(exec);
 				return -ENOEXEC;
 			}
-			/* Only the reference is kept, for AT_EXECFD. */
-			exe_file_allow_write_access(exec);
+			/* A transparent dispatch keeps the denial for mm->exe_file. */
+			if (bprm->interp_flags & BINPRM_FLAGS_TRANSPARENT_INTERP)
+				bprm->executable_denied = 1;
+			else
+				exe_file_allow_write_access(exec);
 			bprm->executable = exec;
 		} else {
 			do_close_execat(exec);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index d4f64d143d1a..ba5037b69866 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -59,7 +59,9 @@ struct linux_binprm {
 		 * Set by user space to check executability according to the
 		 * caller's environment.
 		 */
-		is_check:1;
+		is_check:1,
+		/* bprm->executable holds a write denial still to be released. */
+		executable_denied:1;
 	struct file *executable; /* Executable to pass to the interpreter */
 	struct file *interpreter;
 	struct file *file;

-- 
2.53.0


