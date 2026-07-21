Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE76EC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72C76B008A; Tue, 21 Jul 2026 10:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D492C6B00A3; Tue, 21 Jul 2026 10:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C116D6B00A4; Tue, 21 Jul 2026 10:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91D8B6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C2ADC0153
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:58 +0000 (UTC)
X-FDA: 85012980276.30.EC79312
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3BF8B1A0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D32lg9fl;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaTnVCsoJ0zPmaD338tPdJq70OjLXnWk2vap+l5HqNk=;
	b=gWnEDcVACzY1c/kpwg0GNFmdAs/+iJ8nxlknBP0yBJWX0FixkxXDgk8OQj5nB+iGYQ24/y
	tgFe8jmfARCsrNQy6FCxsNmtSdRO//9sQ42BQXwVFOxD90KMz/G3i35TIuUBpjNi5ufmDh
	d+zv7lifvXl1hoob+NyINAt+3ZGdR+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643296;
	b=adBRKsgZb4THIx8FiqLuhHmDBL64gwvgKzu5erHXxo682nfQOkWWXpF7Ag6qqmDBUAZmDs
	r6bpuaJY27uO8+tdXI6NP1vayu2TNAsd2LQoL8n6gZeNpGkg8pECXfA3DZc3ck15LfwPjh
	kL4V2OhCksgXyW2i6f4ljmCVq72FfYI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D32lg9fl;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B1A443480;
	Tue, 21 Jul 2026 14:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13F11F000E9;
	Tue, 21 Jul 2026 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643295;
	bh=vaTnVCsoJ0zPmaD338tPdJq70OjLXnWk2vap+l5HqNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D32lg9flruBtdAUi53mTuUzpsxElWWYZSJS+/6TJMiYeB03X1v1NOxCby33NVcnBf
	 +Tu2K+lw0/RqOlddnsKiPXCLAGTZ6oFGlaLY1sel4iSdcSus9Yiwi2Gu4j8YrZ9gas
	 UKIotpr+Sz+WRFw1/5cd+1IQke6ThAB8a/8xvpw+MFWYAaU52zIjiYNWJrTDK67+Xd
	 EUHeC6vRw8k9hKIMcHAic22ikSg3h9B1q6/ilvQlpZWjGK1LwsKDiLu7WBsjlzGNa9
	 8RFboFy8+XgAvmKv5o8UFLUJQmw637G7xAcjJHDPs30rVm9PToi+/5pWd2HJb6cCPJ
	 wmod5ZbkBodpw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:51 +0200
Subject: [PATCH v2 09/21] exec: label mm->exe_file with the binary for a
 transparent dispatch
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-9-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5648; i=brauner@kernel.org;
 h=from:subject:message-id; bh=sM2Dc+YPuybL6JF2cqrHbEvEsDEbWyegDPXYB4IgrVQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x3QuFv0enOKZrG811fdK+XR0YsXf3HvYT1zLsCdO
 U022lW+o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIc6YwMB9U1qkwdjs+XXfdg
 C/eaO5F5Exgnv/q6/m37ueRYwfmOlQz/A2s1LC5YpRo9c1L4fksi68m7a6qi7mukV37ewrtCRWk
 VHwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BF8B1A0003
X-Stat-Signature: 7cs5j9gpoxudrye1c9c7eau87jy8fu4b
X-Rspam-User: 
X-HE-Tag: 1784643296-176522
X-HE-Meta: U2FsdGVkX19J0+VGF8tAaKqWnFdqFSSTM5oskQUIwwvRpKQ0d/mxO6RKHiL2iA0KTQsAcYlOy2xNLqfH63A5J+IuDWw3IVJ40dRIJ3je5wm9MN7WihWeOQT3YvgVRP+hY5hcfTVxJYIAap5PvrBjFnq46Z18OaxFP8fhYIDbUHN4p4xCvziJtjy1Li43759WPHNfEIbwjevrDp+CIDhEN1VvHh66LrKpYM+Kwu6lR4g+RWSJyT9UkgM9zn/HZsJBe1d0BNe8JAtK8lafgEOPiBtihylz103A5NYT/sYTJvEGiqs+pfKrqXf6S+bdSf8CYVaq2T1E6CaHyPG4oUORp9xbCDa5FS94ZK1dcD28WZitGDpQ7ODJqpTPE68HPY5L2RDjHc4U5NE0DtuISLCd7XzHtQOGbMLHOr8DjJwGQ+5kFBIeeBzelkj85Ck7tGen0BYCAfbtdlilGfFlBaO5zOoXbTM5ee4RhCSUBjvV7dUwEB9a5InxLJ/hiWpYJRPP0k0+aXNP+kYLHUe17fd0y9GNmft+9kcaL/YNoB3ET80HnrOwgO2bETC/z+b5Y4f7RXv+Rj5hrwHuT9xwV43rNaF7oOl+Zt+6SbK1rJw4V/SpEDTXRhx2YezVZcCN2SNsyxsPP7khKQmXZ4/zZEXQS2w4G13DKz1bInQQ7N9HHnHtFuMGIjUlzRf1Ef6M2Vi7owmZuKhfz66y1vkun+ZCtkSWmFuRjndQXA9a7El/CCgxcoXSiQodgXgElW/dJlKpZn1UE7ccqrr7E/AXE55Kyrjr8lbMtHmD6wTf/2y7T3lq69EBzU9tpLLalcm42nAbOa+wiSrJP/tPuzNauBQjQQBFgb6GWMHmVsXnrF/PSQT7RhppuomF2wIQHQLTO5S7SYen2PhiJ2nNdqIzInySeJc3lsAB0xHq+h9ALLV1TZm8gyC9/Uu1GkUbWjDNUh4V7sgL7/i3LHzHRewIYsY
 XZG0Vjik
 TvJEVn+0tq4xJO/vlpSBTWyIXh//1nElf58cGoa+orllMg7iVXHUqxmPI3NQZljIdZfLd7hEDckd4tp8djnyIZriS3ESceg7fk9AN+KMLrxi5Bmh3415sfAc0QzIThTq6hpu5n1RYiNC8TkSTS+jFi9pR6T0CaQa2CvenIu7Mmp2k7JzdsOvrWM9NhM1vFw2dDBbr2PdxW4qnpG/TIHdTnYvf+bFdeoJHQy2NMbykVwwIsUcjS7JgIXuc+/TNYbfw3Gr/IwIVdtUFj3nKqoCMAjR506HtA/ylywWcxC3OtD1EdnT3E0QTh5/0Ry48yg6BrLT3wQQBM/pNiQyVlw24uRkLcpwGKiPFxuSg7/SnB+7Tk0/92FhDvl29FB5qWM954m79vaq67jiVy0tLWQjASMx+zDCgU+YOHc6zugy2kHbaHzXxcuB9UkOrkD1IOLwcuDD5hWHL1gVwGJ7UQhkWVccxmwUY9HAkPfIj
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

Write-denial moves along with the label. Rather than tracking per mode
who still owes a release, the denial do_open_execat() took stays on
bprm->executable until the file is handed over. begin_new_exec() drops
it right before installing the descriptor - set_mm_exe_file() has taken
its own denial on the identity file by then - and free_bprm() releases
an unconsumed executable with do_close_execat() like the other exec
files. For a transparent dispatch the result is exact parity with a
direct execution: a concurrently written binary fails execve() with
-ETXTBSY at open and a running one cannot be opened for writing. The
interpreter consequently is not exe-pinned and matches the role it has
in a native PT_INTERP exec. A classic execfd dispatch now keeps the
binary write-denied until the exec completes rather than only until the
interpreter swap; the difference is confined to the exec itself.

Nothing sets BINPRM_FLAGS_TRANSPARENT_INTERP yet; the transparent
dispatch machinery in binfmt_misc follows and raises it from birth, so
the label and the aux vector bit that announces it appear together.

Link: https://inbox.sourceware.org/libc-alpha/87ik6fymha.fsf@oldenburg.str.redhat.com [1]
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 061e0f9fb4ef..128964d1e9d6 100644
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
@@ -1151,7 +1162,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * not visible until then. Doing it here also ensures
 	 * we don't race against replace_mm_exe_file().
 	 */
-	retval = set_mm_exe_file(bprm->mm, bprm->file);
+	retval = set_mm_exe_file(bprm->mm, bprm_identity_file(bprm));
 	if (retval)
 		goto out;
 
@@ -1241,6 +1252,8 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * Let's fix it up to be something reasonable.
 	 */
 	if (bprm->comm_from_dentry) {
+		struct file *comm_file = bprm_identity_file(bprm);
+
 		/*
 		 * Hold RCU lock to keep the name from being freed behind our back.
 		 * Use acquire semantics to make sure the terminating NUL from
@@ -1250,7 +1263,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 		 * detecting a concurrent rename and just want a terminated name.
 		 */
 		rcu_read_lock();
-		__set_task_comm(me, smp_load_acquire(&bprm->file->f_path.dentry->d_name.name),
+		__set_task_comm(me, smp_load_acquire(&comm_file->f_path.dentry->d_name.name),
 				true);
 		rcu_read_unlock();
 	} else {
@@ -1291,10 +1304,17 @@ int begin_new_exec(struct linux_binprm * bprm)
 
 	/* Pass the opened binary to the interpreter. */
 	if (bprm->have_execfd) {
-		retval = FD_ADD(0, bprm->executable);
-		if (retval < 0)
-			goto out_unlock;
+		struct file *executable = bprm->executable;
+
+		/* mm->exe_file carries its own write denial now so drop it. */
+		exe_file_allow_write_access(executable);
 		bprm->executable = NULL;
+		retval = FD_ADD(0, executable);
+		if (retval < 0) {
+			/* The reference was not consumed. */
+			fput(executable);
+			goto out_unlock;
+		}
 		bprm->execfd = retval;
 	}
 	return 0;
@@ -1413,8 +1433,7 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->old_mm)
 		exec_mm_put_old(bprm->old_mm);
 	do_close_execat(bprm->file);
-	if (bprm->executable)
-		fput(bprm->executable);
+	do_close_execat(bprm->executable);
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
@@ -1740,8 +1759,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 				do_close_execat(exec);
 				return -ENOEXEC;
 			}
-			/* Only the reference is kept, for AT_EXECFD. */
-			exe_file_allow_write_access(exec);
+			/* Kept for AT_EXECFD; the write denial rides along until hand-over. */
 			bprm->executable = exec;
 		} else {
 			do_close_execat(exec);

-- 
2.53.0


