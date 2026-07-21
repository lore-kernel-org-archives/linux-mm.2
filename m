Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49F8C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694806B00B4; Tue, 21 Jul 2026 10:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644A16B00B6; Tue, 21 Jul 2026 10:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5341E6B00B7; Tue, 21 Jul 2026 10:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09E506B00B4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CA9E1A017A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:16 +0000 (UTC)
X-FDA: 85012981032.29.19E3183
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A6C1520011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLmRJ+ja;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTTXgK6MflQH7VLuF19bKcKZcCVGUHt81E3aPbdRda8=;
	b=b4XGqzZcr4Wfg5+cJcCTOqv3aE4ffxr+8xobNM+sINq1Ii5d0mb+iFzr590k5dLYl3rfS8
	4MTRu+fQf425vGEM1Q6yl462ihrxdd2gMcEjrkoIY8w7VwDFcR/OWDG8PlggSTk2B482RK
	XLQtNEHLn88t/aaeL/Ikfsly1ppMosc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643314;
	b=PNqR/sMGSOAfevNZeNtDIQUl/xoqBwxkZWwdhRpYYBMI9cxEzQdtiIjDaBm6R7zc+iTka+
	oLnrTIKdyvOUQqwk/GSkiDXT+PjGBtVEmDJTpxdyyZTxC8N+A5LOUn/jGucIaLNsCXz8am
	KHITGQ/NvAzGdeiqnCgGWSOZ4e2NmAY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLmRJ+ja;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02B42419EA;
	Tue, 21 Jul 2026 14:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493441F00A3F;
	Tue, 21 Jul 2026 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643313;
	bh=BTTXgK6MflQH7VLuF19bKcKZcCVGUHt81E3aPbdRda8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MLmRJ+jaIAPy/yzwojAurYmnlXHImcyyUKBO7ZqgoaSopjxOf+z4CsVM5iPC0/fCr
	 h0mrmwpuycmLXjg/OTJ80P9M0447OdqtErCDrU6hvZQIooN++eYO0p0PCFFVFneh6T
	 Ien9UtDzki1gd/tyDJZEQWsT0DMW+sdJwVm/obLrnHDstjvsVgzN2HcOzGh+QdgKb1
	 UfzF8FoNt4RMhkTKmDE0n9VhQ5lexqI4ed3ScWlszxzZLoQDjfWnCRBLlkSINo+OPC
	 /VCi8z6x9a6HweIn/XlbCKnnPJKU8GJEr6RApKwgDLotT5R4JcatRznZPiOe8bHsRo
	 4h9XHvp9r7aiA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:57 +0200
Subject: [PATCH v2 15/21] exec: carry a PT_INTERP substitute in struct
 linux_binprm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-15-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5372; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qFJ5ovqMAAT99gsAnowfCX/JHYUOWQhKlZwSrrvkzdo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x3Q8rzc09A3Y3+oWLXcq4+f3m8p+JrlZ3zZp+FAz
 NYz/O8yOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSYMfwh2+nyL6qHfO8PLJ1
 DA4eL3MTyJgTy83utz/TSmnFlxun9BgZ3mSf5lXhtEioZHoYWptjb+ZizB49aYuCUiZDgmXVhSV
 MAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6C1520011
X-Stat-Signature: w1me8q6kqws4r8b5zj4a51554swnt4wy
X-Rspam-User: 
X-HE-Tag: 1784643314-687605
X-HE-Meta: U2FsdGVkX196CqDn1xMItHYbyP8JgcH6g9ciRZ6vQ/WqNNxuOoGtCziMk0lNQmPAPQ0XI4UPHNJ1kcNJCJCu/qeaEjdwwkJGm6sdUSoN0W401ZcnuOmKrvbl2hwguipAtqXK9kTgLXudhr8MhSpTW9CbYH6OPszkHCS0UF40NQ0j4SHGOwzd2+fNOw7bo8bR6+SS8hZTCZR4vzF7ZLtfyXqDjM5m78d4tRk1XCyX5qojmJDGZzsZKo+ZUR3aH4Z7a6TxpsCiR7JLjIJOeO/GIwOwGs6pn5hepeW/UC6bM4Cm2xKj1tqA6vV+WpWH3DEGuu2YdO0emADvw5jOrJtufXlt7L1LsQZuvB563Vtv1DkKJY/41UO2i90W3Hy261BdsLvm/PkNvayUJ3emQ+c8fUjvPgGWsyDPxvtkFqZ/QE0/n25WAiba67PJDLplQIx62G1OFu5qdGFVtwklOVtSSLLhMnjAlYWpYLoH1WwCuu1jrxYPNwmvBi3ZPfcVIYo0h9NWOrm7BHVDN61nUbwX+Y2zhuphoqNL7Z9S9ims9Fo9IGzF7P5vT5LAmjkeziPWFjNPJ/iK7kJAgTtHWsia6FsXXUISlwTzrerbxqWuSonPd7J5cpx4pCzFUL2m9cEGkC1wbzvk5/mz3E1q/QmwwHfF/QgaVtyg4fEwTRFHN7ivt0DUwp8gKxx45zqjB4rrbJJY+H0om/cotk24Pjxe4PtiOuxaFjME36XA8sbibqotCafT2puYa8k0VeGzOaY1NV77jgtHfxwGLx1XcHoDKqrDBOrSeSFnT8TUQXwA+u2hYb/QTd2m4wutPH9zKR4SEilM+6Nqp4ryp2htP2VZ10tmchHMQVnDRAfScEY/IOfsyIUPXvLXPhK3RLAPqgFOoQEtsyA4/UMDAWGKEg6+BuYhrAzkx4rBFm0MP78Tza/a8dbxNx4HyGEhEGkzXkiMMasWUKkTrTZJBjZ9/3k
 CGsEs0Qx
 U/Y3/l98vuDDACNK60o0FcgSb8SdGSEUYynXHGzrnEcdW5VFS/jKrn2VvYp+XQC/LSFp9Vml6IZnfGJoNQ5g04TjWLIM2jtic9xnWka4MfUtDJnsfemqMMI2kre+jRa7UZOZn8J6YS9HdCu7jkXg4i6uViuEyRVsZ8fAjMQ/WDVa+5wqi5VYVrhWXDcfgwFcVgLCcmgQIPRFKYsbYnmpuzI+fqVkPEfgJsC3KhLimZhBft0lP9Pdq1kN+YDGWOyG4FqOTMQTURyWj/LklbH9issKe5IKYees6vjaIVsMzTHqsjI4ApMRXsTEZVOzn6ThkBuTdVs6M7t6K7opT/g2z4zTJXVciGGT1NfI9EezebepJVGstfb6XF0WV8om1cjZqeddlUH83xHHGi2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binfmt_misc currently supports an execution model where the registered
interpreter becomes the executed program and the matched binary is
handed to it as payload. The upcoming binfmt_misc loader mode inverts
this. The matched binary remains the executed program and the registered
interpreter is substituted into the role the binary's PT_INTERP would
have played.

Add the channel for that hand-over. bprm->loader carries an
open_exec-style struct file reference from the binfmt_misc match to the
binary format that consumes it. Unlike bprm->interpreter it does not
request a restart of the format search. The stashing handler declines
the exec with -ENOEXEC and the search continues to the real format in
the same round.

Both ELF loaders consume it, so give them the two helpers to do it with
rather than a copy each. bprm_open_interpreter() hands out the substitute
in place of what PT_INTERP names and bprm_drop_loader() releases one that
turned out not to apply.

Establish the complete lifecycle up front so a stashed loader can
neither leak nor be silently ignored.

- Chain restart: if another format wins the round by staging
  bprm->interpreter (binfmt_script) the stashed loader belonged to
  the file being replaced. Drop it at the top of the swap block in
  exec_binprm().

- Unclaimed or error: free_bprm() releases a still-stashed loader
  next to the other bprm file references.

- Silent non-substitution: a final format that reaches
  begin_new_exec() with a pending loader would run the binary while
  ignoring the override. Refuse with -ENOEXEC before the point of no
  return. Formats that do not know about the override (binfmt_flat,
  out-of-tree) need no changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h |  3 +++
 2 files changed, 45 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 128964d1e9d6..856731f78d05 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1123,6 +1123,10 @@ int begin_new_exec(struct linux_binprm * bprm)
 	struct task_struct *me = current;
 	int retval;
 
+	/* A pending PT_INTERP substitution this format cannot consume. */
+	if (bprm->loader)
+		return -ENOEXEC;
+
 	/* Once we are committed compute the creds */
 	retval = bprm_creds_from_file(bprm);
 	if (retval)
@@ -1414,6 +1418,39 @@ static void do_close_execat(struct file *file)
 	fput(file);
 }
 
+/**
+ * bprm_open_interpreter - open the interpreter the binary asks for
+ * @bprm: binary that is being executed
+ * @path: the interpreter path named in the binary's PT_INTERP
+ *
+ * A binfmt_misc loader entry substitutes for the interpreter the binary
+ * names. Hand out the stashed substitute if there is one and open @path
+ * if there is not. The caller owns the reference either way and releases
+ * it like any other open_exec() one.
+ *
+ * Return: the interpreter on success, an ERR_PTR on failure
+ */
+struct file *bprm_open_interpreter(struct linux_binprm *bprm, const char *path)
+{
+	if (bprm->loader)
+		return no_free_ptr(bprm->loader);
+	return open_exec(path);
+}
+
+/**
+ * bprm_drop_loader - discard a PT_INTERP substitute that does not apply
+ * @bprm: binary that is being executed
+ *
+ * A binary without PT_INTERP has nothing to substitute for, so drop the
+ * override and let the binary load natively rather than have
+ * begin_new_exec() refuse it. A no-op once bprm_open_interpreter() took
+ * the substitute.
+ */
+void bprm_drop_loader(struct linux_binprm *bprm)
+{
+	do_close_execat(no_free_ptr(bprm->loader));
+}
+
 static void free_bprm(struct linux_binprm *bprm)
 {
 	if (bprm->mm) {
@@ -1433,6 +1470,8 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->old_mm)
 		exec_mm_put_old(bprm->old_mm);
 	do_close_execat(bprm->file);
+	/* An unconsumed PT_INTERP substitute from a binfmt_misc loader entry. */
+	bprm_drop_loader(bprm);
 	do_close_execat(bprm->executable);
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
@@ -1750,6 +1789,9 @@ static int exec_binprm(struct linux_binprm *bprm)
 		if (!bprm->interpreter)
 			break;
 
+		/* A stashed PT_INTERP substitute belonged to the replaced file. */
+		bprm_drop_loader(bprm);
+
 		exec = bprm->file;
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 62465574e2a0..a2daecbb01d6 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -62,6 +62,7 @@ struct linux_binprm {
 		is_check:1;
 	struct file *executable; /* Executable to pass to the interpreter */
 	struct file *interpreter;
+	struct file *loader;
 	struct file *file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
@@ -159,6 +160,8 @@ extern int begin_new_exec(struct linux_binprm * bprm);
 extern void setup_new_exec(struct linux_binprm * bprm);
 extern void finalize_exec(struct linux_binprm *bprm);
 extern void would_dump(struct linux_binprm *, struct file *);
+struct file *bprm_open_interpreter(struct linux_binprm *bprm, const char *path);
+void bprm_drop_loader(struct linux_binprm *bprm);
 
 extern int suid_dumpable;
 

-- 
2.53.0


