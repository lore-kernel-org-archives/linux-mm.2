Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36D5C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079E66B0088; Tue, 14 Jul 2026 15:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003336B0093; Tue, 14 Jul 2026 15:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0676B0095; Tue, 14 Jul 2026 15:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9019D6B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 089571C0397
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:51 +0000 (UTC)
X-FDA: 84988445262.18.33282C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B46340006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Myjk70+M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059129;
	b=fS4EZvaUWn1jTvdtckMqLDB3K4AueboSotkJQnPn6DO/fwVLgwAPy6q00cBqRe44PkplMx
	9ikr4CxKh/QGG9vhx3iUOSVLmXFEtxfETgWgxst8JlTKZmQ2OL39h+cJ0tA/GJXe4zuHVG
	uKt8HXyA4pZnFZ/hNoDvMTUZwkVCKhs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Myjk70+M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvEvi7jrpq+80AXfohCZG5D53DbAbYRLGGlJ957qs5E=;
	b=rukCJyyUoJA/VHQa7sPDDQZJT+18mTSKzmhqnZ2i2PpRSGyAn5ORdNnwGDph30IrOZu6TF
	dMKIuOplFhnFb4Yr9ghe83L3D8YMi39ThTHOMl0w113wFVZjpcObNmimQIpTZ5UHNfVlT3
	YDMNqI4X5uEJBXFhH+kSp53BKo7icMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E631160254;
	Tue, 14 Jul 2026 19:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4A11F00A3A;
	Tue, 14 Jul 2026 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059128;
	bh=CvEvi7jrpq+80AXfohCZG5D53DbAbYRLGGlJ957qs5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Myjk70+MNSMqK/RDR+4u77+UIoVdnPlKs896NCypXbWxhlzQN3zWBQ2I9ptZpMxOA
	 4DqTHn+B8mCLarFbS2pSIHkt/cgmd9jzlVuvLW9qfL6N5fFWWl+lFc26XU8+N5PLO+
	 4chmWtPNo6o012JQJI8GSNyYHS7MNX6fKIhrkJsHvW3qcgp29SNd1iNLZM5NEeUWfN
	 RYbZRWZ/nUeNe2+aZPOGDJ6Z28pcN8usu9Cbzg4wfEy9nKYywtVaRd9URNo3cR2/kg
	 DuOzkoCE5i9D9ez2uIGhwBJwvflJJSeBML0g5jjCUfUR8cxZ/QvBO79u7EbQWff6dq
	 YYohqwyqlmq/g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:13 +0200
Subject: [PATCH v2 8/9] binfmt_misc: let a bpf handler run the interpreter
 transparently
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-8-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=9938; i=brauner@kernel.org;
 h=from:subject:message-id; bh=w3lOIR1znEh/auAnT1S9gis+Lqn0MI9zD/IGZEwwbV8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbn8PntLxw1zm2jRRUuk5qx3WhC9v1r+ffbmmtm2u
 zZntutO6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIlxuMDA82O85bWX95XuD+
 8DffJIKi5iXcuDPz2ZZa2VvTcrlYDXkY/uk4nF9855TvkeTcmz6/Zecx778VuDj+9oOHvitWL7h
 ocpEVAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 4B46340006
X-Rspam-User: 
X-Stat-Signature: 7tetfqgpeszi1iygjxqgzhjwkjm3zyuj
X-Rspamd-Server: rspam03
X-HE-Tag: 1784059129-890072
X-HE-Meta: U2FsdGVkX1+aTTDzQtcp7qDXbzcvmkX4NMj6NpqQF/qM5K1+JhH9HUrciNcGk/0aNdWhXs950mOKfnLKbpGpLTRZl8Fg72V81C0fI5u8AKAZZmo56hP8ZZQILN5wYKaEyQJPcwjrDgBXkn7KGZ+6wgbb0Gl72ixNUgIMh3RQ6dK9e7e2E6giDcQxvfbN1HECLcuIajcI45WKBNFwFHSU/7EKZhc0G42K7Ryb+s8HXwOH7Q6lfNGeiG/jLFGn4U4Kt30zK81hmWqDoo5dZ5lyNPiHYukDWmpuRUnj0rfiNf5H5pxLl8TF3E3sinff51x8bPO7wOuToj3xFmUJcW2jd87GIwavF5kRQ48yjM/817+1QGciwt5H7XIV58R8UICGfVAmjwJrh97okCRRpeEvjsyKzv7wLfDCnoX29BAVYxGoMcec9eN96funzInGnezRhEyXuGd+g7Ld2n8iCZhqSZKvWgiQ/b1NOrHvHeFZSnYXn6RkKbdrV8rX1mbhetKbZXc1SVEAXNKKzVtM7CcKWtJYp6+FsP/0wJrN5wVT8B5bnPFU81D8hqlDBYZosDi/u9U1gXq791mqgf3g5SWpti9dhoqxfRaMVaN43PhzKE0lVtE/Ack8cC7VSP7aanGzXgcyPZkkTyCFEsklSQkcx6xwhm1gM+MQ23iZTsDLQb1ocPhPULGdsS8QWx+l9up/3BAVvusG7aEoyxT7YctEJUvjugXI12WDjlAdJobvJC8eL5zKS06/VGhJzHQjQuh/XO0NVwsoo4V/LLiRa9RoKwjHqNME5z6g39P0RBVI69hfi5mnEm3fu319raxHxr1cYuKvP16J3cgkOXp5E/G7SdokpKpj4TYclVNKuWDVRZOLFq/VRBw5LXmSgBYP4mdFfzUXY1XpGGTOiw70QyfOk4M8qN/HnJKdZP32nKcXKnrX0oTnlV+7+xp2hbeFen4IQILIbCTAB9eqzk721Tl
 h+MvwWaD
 xyVxSmOH5vdAhDoQKAPPFYYG919jdn1ngTcjoFGX8e1jjpCKVE6svIqcp5MQ5DuLl3OQOOPDJvXz6+LQknbYPpBbRgklmLvj7uKDSX4+ohES3OH+QGFIGUD731ij10C3Ru0Vio8ovTCr8+h1lqxaMuU0kRCRaX3YbF7nlABlbYq1vmTOyyl8V2xFPbeG3oqKf5FlTybXNvALdgxwrTSEzT/2LqfCk8HX6ZGbJJAWxdj3zLQWJpHPM8frUhWhh+43Ri5iiwXAIVKL7nDrtps3vQYp4u4tdbPBUpC8AnRLc6D6LNAC3MinUB4yqgU18PufqtRNvNXiIoEUDbzQqZcmyYzXwIkoZ71GweY/E3Evrirlp3MNid3LZz4LVRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A binfmt_misc interpreter is visible to the binary it runs: argv[0]
becomes the interpreter path, the binary's path is appended as an
argument and /proc/pid/cmdline shows both. For wine or qemu-user that is
the point, but for a per-binary loader the interpreter is an
implementation detail of running the binary that has no business in the
argument vector. And a binary handed to execveat() as an O_CLOEXEC fd
without a usable path cannot be run through binfmt_misc at all: the
interpreter would have no path to open the binary by, so
load_misc_binary() refuses upfront with -ENOENT.

Add BPF_BINPRM_TRANSPARENT. It goes beyond the static flags: the binary
is handed to the interpreter through AT_EXECFD as with BPF_BINPRM_EXECFD,
but the argument vector and bprm->interp are also left exactly as the
caller set them, so argv[0] and /proc/pid/cmdline look like a direct
execution of the binary. The interpreter has to load the binary from
AT_EXECFD for this; a relocatable loader can, glibc's ld.so does not.

The inaccessible-path bail moves after the load program has run and into
the path-building branch: a transparent interpreter takes the binary from
AT_EXECFD instead of a path, so the restriction no longer applies and the
O_CLOEXEC execveat() case above just works. BPF_BINPRM_PRESERVE_ARGV0 is
subsumed - transparency preserves the whole argument vector, argv[0]
included - and a staged interpreter argument is dropped: no argv slot is
built for it to land in.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  9 +++
 fs/binfmt_misc.c                          | 92 ++++++++++++++++++-------------
 fs/binfmt_misc_bpf.c                      |  6 +-
 include/linux/binfmt_misc.h               |  3 +
 4 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 7f42abf9cfba..b446b3be9628 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -148,6 +148,15 @@ decide them differently for each binary it handles:
 - ``BPF_BINPRM_EXECFD`` opens the binary on the interpreter's behalf and
   passes it through the ``AT_EXECFD`` aux vector entry (the ``O`` flag), so
   the interpreter can run binaries it could not open by path.
+- ``BPF_BINPRM_TRANSPARENT`` runs the interpreter transparently. It has no
+  static counterpart: the binary is handed over through ``AT_EXECFD`` as
+  with ``BPF_BINPRM_EXECFD``, but the argument vector is also left as the
+  caller passed it. An interpreter that loads the binary from ``AT_EXECFD``
+  then appears in ``argv[0]`` and ``/proc/pid/cmdline`` as a direct
+  execution of the binary. This is also the only way a binfmt_misc handler
+  can run a binary passed as an inaccessible ``O_CLOEXEC`` file descriptor
+  to ``execveat()``, which otherwise fails because the interpreter has no
+  path by which to open it.
 
 Because these are program choices, a ``B`` entry carries no flags in the
 register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a3175521c8dd..9d7fc598d8c1 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -296,6 +296,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	const char *interpreter;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
+	bool transparent = false;
 	bool preserve_argv0;
 	int retval;
 
@@ -307,10 +308,6 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (!fmt)
 		return -ENOEXEC;
 
-	/* Need to be able to load the file after exec */
-	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
-
 	interpreter = entry_select_interpreter(fmt, bprm);
 	if (IS_ERR(interpreter))
 		return PTR_ERR(interpreter);
@@ -326,10 +323,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		/* Clear so it can't accumulate into a nested interpreter level. */
 		bprm->bpf_flags = 0;
 
-		preserve_argv0 = f & BPF_BINPRM_PRESERVE_ARGV0;
+		transparent = f & BPF_BINPRM_TRANSPARENT;
+		/* In transparent mode argv[0] is already the caller's. */
+		preserve_argv0 = (f & BPF_BINPRM_PRESERVE_ARGV0) && !transparent;
 		if (f & BPF_BINPRM_CREDENTIALS)
 			bprm->execfd_creds = 1;
-		if (f & (BPF_BINPRM_CREDENTIALS | BPF_BINPRM_EXECFD))
+		if (f & (BPF_BINPRM_CREDENTIALS | BPF_BINPRM_EXECFD |
+			 BPF_BINPRM_TRANSPARENT))
 			bprm->have_execfd = 1;
 	} else {
 		preserve_argv0 = fmt->flags & MISC_FMT_PRESERVE_ARGV0;
@@ -339,45 +339,63 @@ static int load_misc_binary(struct linux_binprm *bprm)
 			bprm->have_execfd = 1;
 	}
 
-	/* The entry's own choice - not one accumulated from an earlier level. */
-	if (preserve_argv0) {
-		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
+	if (transparent) {
+		/*
+		 * Transparent execution: the interpreter takes the binary from
+		 * AT_EXECFD, so leave the argument vector and bprm->interp as
+		 * the caller set them. argv[0] and /proc/pid/cmdline then look
+		 * like a direct execution of the binary, and a binary passed as
+		 * an inaccessible O_CLOEXEC fd to execveat() can be run at all.
+		 */
+
+		/* No argv is built, so drop any staged interpreter argument. */
+		kfree(bprm->bpf_interp_arg);
+		bprm->bpf_interp_arg = NULL;
 	} else {
-		retval = remove_arg_zero(bprm);
-		if (retval)
-			return retval;
-	}
+		/* The interpreter has to be able to load the binary by path. */
+		if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+			return -ENOENT;
 
-	/* make the binary the last argument to the interpreter */
-	retval = copy_string_kernel(bprm->interp, bprm);
-	if (retval < 0)
-		return retval;
-	bprm->argc++;
+		/* The entry's own choice - not one accumulated from an earlier level. */
+		if (preserve_argv0) {
+			bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
+		} else {
+			retval = remove_arg_zero(bprm);
+			if (retval)
+				return retval;
+		}
 
-	/*
-	 * A single optional argument to the interpreter, inserted between it
-	 * and the binary just like the argument of a #! interpreter line.
-	 */
-	if (bprm->bpf_interp_arg) {
-		retval = copy_string_kernel(bprm->bpf_interp_arg, bprm);
+		/* make the binary the last argument to the interpreter */
+		retval = copy_string_kernel(bprm->interp, bprm);
 		if (retval < 0)
 			return retval;
 		bprm->argc++;
-		/* Consumed - don't let it leak into a nested interpreter's argv. */
-		kfree(bprm->bpf_interp_arg);
-		bprm->bpf_interp_arg = NULL;
-	}
 
-	/* add the interp as argv[0] */
-	retval = copy_string_kernel(interpreter, bprm);
-	if (retval < 0)
-		return retval;
-	bprm->argc++;
+		/*
+		 * A single optional argument to the interpreter, inserted
+		 * between it and the binary like a #! interpreter line's.
+		 */
+		if (bprm->bpf_interp_arg) {
+			retval = copy_string_kernel(bprm->bpf_interp_arg, bprm);
+			if (retval < 0)
+				return retval;
+			bprm->argc++;
+			/* Consumed - don't leak it into a nested interpreter's argv. */
+			kfree(bprm->bpf_interp_arg);
+			bprm->bpf_interp_arg = NULL;
+		}
 
-	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(interpreter, bprm);
-	if (retval < 0)
-		return retval;
+		/* add the interp as argv[0] */
+		retval = copy_string_kernel(interpreter, bprm);
+		if (retval < 0)
+			return retval;
+		bprm->argc++;
+
+		/* Update interp in case binfmt_script needs it. */
+		retval = bprm_change_interp(interpreter, bprm);
+		if (retval < 0)
+			return retval;
+	}
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index 00c787e8bdcc..fb5d0f465ccc 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -178,7 +178,9 @@ __bpf_kfunc int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
  * O flags: BPF_BINPRM_PRESERVE_ARGV0 keeps the caller's argv[0],
  * BPF_BINPRM_CREDENTIALS computes credentials from the binary, and
  * BPF_BINPRM_EXECFD hands the binary to the interpreter through AT_EXECFD.
- * Calling it again replaces the flags, passing zero clears them again.
+ * BPF_BINPRM_TRANSPARENT additionally leaves the argument vector untouched,
+ * making the exec look like a direct execution of the binary. Calling it
+ * again replaces the flags, passing zero clears them again.
  *
  * Return: 0 on success, -EINVAL if @flags contains an unknown bit
  */
@@ -186,7 +188,7 @@ __bpf_kfunc int bpf_binprm_set_flags(struct linux_binprm *bprm,
 				     enum bpf_binprm_flags flags)
 {
 	if (flags & ~(BPF_BINPRM_PRESERVE_ARGV0 | BPF_BINPRM_CREDENTIALS |
-		      BPF_BINPRM_EXECFD))
+		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT))
 		return -EINVAL;
 
 	bprm->bpf_flags = flags;
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index d3112a00cc19..c43df749e021 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -16,6 +16,8 @@ struct user_namespace;
  * @BPF_BINPRM_CREDENTIALS: compute credentials from the binary; implies execfd
  *                          (like the 'C' flag)
  * @BPF_BINPRM_EXECFD: pass the binary via AT_EXECFD (like the 'O' flag)
+ * @BPF_BINPRM_TRANSPARENT: leave argv untouched, the interpreter takes the
+ *                          binary from AT_EXECFD; implies execfd
  *
  * Set from a load program with bpf_binprm_set_flags(). Unlike a static entry,
  * a bpf handler chooses these per exec rather than once at registration.
@@ -24,6 +26,7 @@ enum bpf_binprm_flags {
 	BPF_BINPRM_PRESERVE_ARGV0	= (1ULL << 0),
 	BPF_BINPRM_CREDENTIALS		= (1ULL << 1),
 	BPF_BINPRM_EXECFD		= (1ULL << 2),
+	BPF_BINPRM_TRANSPARENT		= (1ULL << 3),
 };
 
 /**

-- 
2.53.0


