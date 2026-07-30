Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A75EC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9046B009D; Thu, 30 Jul 2026 09:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891996B009E; Thu, 30 Jul 2026 09:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758626B009F; Thu, 30 Jul 2026 09:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 541A66B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:35:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E06FC80155
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:05 +0000 (UTC)
X-FDA: 85045538970.22.4511390
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B35C4000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2aC7aaG;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418504;
	b=SmdOj5n20bj0rRTAWbAwmmVbTfUSjJBpDtKCLtHMORjveTvMulI0tlX5xqXEjPQohhY6iV
	gdz1pJLWfv0IoMh0p+ujIbgzsu4O6Yl80nENpu/+mLoRGyi81/zMj9krjRZund/HFn+ITQ
	3Vb0jNIMz0Fto2rZ0d0X9bOvffZObhE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2aC7aaG;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxQz64cpIww2DYEG1hYNJHne2y3Hg0ORAV9bH+ybcgk=;
	b=wfDJxQtEiKu9r6Ih75Y9lpoOUsvTXEb8XCjttp9ePCgSZKl4STUDjR+RfRWVGf7rNHPGTu
	F8aJFoiMUFf0WWJN+d81XLcBO7F9WTBsLE+3iePMaZpQwOkaKuMAJwuKbEuKkR21Z2LeEc
	bTEGkciWgxH5ZUywtB7QW8yOWs6aaCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7030641176;
	Thu, 30 Jul 2026 13:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822E41F000E9;
	Thu, 30 Jul 2026 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418503;
	bh=FxQz64cpIww2DYEG1hYNJHne2y3Hg0ORAV9bH+ybcgk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h2aC7aaGB4KmXjO3Ehs7pGxc774qiO8W8j9N0au32ijP/N5aFEmgTRAAe3oep89+8
	 9m6P6RRJlZCY7xCZj0zcUDQiXKJa9ow+8WkwlxTy++NQ8gtMifrGNQpL2asEx01Lpw
	 g5qQDenogeZtIKaT/bF6YKtUMfP2/zSbGVTHAliagQbkVj7v3Ziwg2flANuBtjKmDX
	 9EErqUv2CfLprrW/z3s7q/j3P7nV9MxFSy61gAnQJN9XhaLXnqKfBCcUg8wVwNHTkV
	 Xp+gm6jDCJGMI+Gi9d4TDbkH2PIjQ2lWR+i22RMxUWQDq8vslsoD13yoN69wNddTL8
	 GHpTJFrJvmNYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:09 +0200
Subject: [PATCH 7/9] binfmt_misc: let a 'B' entry bind its interpreters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-7-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=27951; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WtoAbeAT6vnsiI3QMfLmuhfnCeH/bfTLb+FOFJeTj94=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB73b9Ia17ZTu/nu3/tR0XM09GbVz6zVHn9BrrznDN
 1a94rF80FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR13MZ/pkzO3ar1X3Ld1p/
 0EYsSJv/pPLNf/4fwkx+r88vDdi7toLhr+R5b42cTeslIj9J1fP2Jjy6JGvqUvxkReunJzZFcbv
 WMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B35C4000A
X-Stat-Signature: 3s44ahnr8kwdeis3gdpwxspuuside1w4
X-Rspam-User: 
X-HE-Tag: 1785418503-373897
X-HE-Meta: U2FsdGVkX19RScN3IAlzKiFatKzh9uJ4vF4EDXJnbFz9agvsvyXCPlLGM+dr7zRh06/V3sec2Qg15BO62bq9chgRK38Pky0+Hn137Jr/GqN79IimIT7/DYQsLor12EHQ5qZltlcfoQBiYkMhpM8LoJOqaH5GaOBIp0oxFfzct7BCwlcdZ0a1QnBAgw64/SBO7FSKqQmBcuQELeX073HAnMudNTziwUC55xRImUxxSnHXxxfIDXa29CTk1m8rjEASBZIry92/rZpoT098FAZt4zhhqx+lv6BBOB+mrACaDYzptqk1zNXm8xIfj/t0fnkV1hM2eq3lfx+XiEt7T2z85YhrwZQNVKfhPBn+3Yzk4f/0CMbs7FAZnEeVwG6Fi0LKw/PrIzcvXPhEgL6hNFTyhLvolItIAfG2n2H7Jutu7BbE5srxBKKGKwfhUqovKSv9wvhzUeEus+qMbGJOZ0k6ZfMqR/bFbnY3CM02iqmfh5Eep6tO2kPL/mzL0k/11r3I7vzEBXddu2vneyRduHHO0bcpm6qytkifqVDl1ZTuq14XvHRxPB9hMkc+g7rW3GRKcrrNipkVIwBSmbnn0dJv+UkTcXIx7I9+1J/cJeX7+E4DlvDvwRUcUvrLOjhrG3n41mR/zZ7dxozvcd+fOxtgyXrzSUqrq/ihWCiVa+WZmAxT/xXkFHJzjjlGhBcZYlTKzgDmE5tGU+dvWJa/rcuNBfU8yS6JpY0k+1pXKq02IylD63hLjq+u58T0ZMXnsoiO3gXFmpJhLPdO/NI8TjLkAdoUpkinV+siXs0RPiA0lLK8IcV0W87WpSkUAIqHdXZVkrJpTgy4TslcBKIjgKFn7L2GU9kvMk/glsAl7u1S9+kMu5FrcuopoxlzDcBt3KteJbxniMIuzt7dE6WASiXy0/iCCpIeMO3lh4NiMudIa+mN9yElZ8um/+2xDRI39V/0CX5nGtj3+n6UAAZ1VMU
 2LGEx7Bj
 Wp57/gIK2wdik1PyXhW1LAmyqHNIbc4M9HX9GEioj2JGUDKeI4QQB4JGo0Ts7f+QGw1larwRIqFQRDSf0xy5NqEPlWZWHnI5ERqUDZiuUDMPJfs1PmW/Bnmg3baV1hSfburoqqGZ802X8FuqcqFfu/bEHSmPHxur/BoicWMPcrRJZtrf0PxYo0gTYPL03NaqRbKhW97MA83Kx+sUp3PEZoG/tH5QXO8sN0fYNf7fTvgfl+0n8uMV5jIbI3rzhsX01XwFBTNajUGKWtXDY74Qu6hRdzNYPo5WV2Qt4BNbEywZzaQuS+Y9ZnVjXAqVsdp6+lxUUjrmW5QKWpMcac7XP3iNZsf5A6yJZoEPXLCvmYjzfWyJl2FQa0P6xIO+Ud/jHFWmp6wO1gKleKJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A 'B' entry's load program selects its interpreter by absolute path,
which open_exec() resolves at exec time in the mount namespace of whoever
runs the binary. The handler names an interpreter but does not get to say
which file that is. Whoever controls the filesystem view of the exec
decides that instead.

Static entries settled this long ago with 'F'. The interpreter is opened
at registration in the registrant's context and every exec runs a clone
of that file. Give a 'B' entry the same, for as many interpreters as it
needs.

An entry registered with 'D' cannot be matched yet, so it still belongs
to whoever is configuring it and can be given interpreters one write at a
time:

    echo ':qemu:B::::qemu_user:D' > register
    echo '+aarch64 /usr/bin/qemu-aarch64' > qemu
    echo '+arm /usr/bin/qemu-arm' > qemu
    echo 1 > qemu

Each path is opened by its write, with the credentials the entry file
was opened with, by the same helper that opens an 'F' interpreter. The
load program picks one per exec with bpf_binprm_select_interp() and the
entry hands out a clone of it. Nothing is resolved again, in any
namespace. The path is everything past the first space, so no
interpreter has to fit in a register string. An entry binds at most a
hundred interpreters (BINFMT_MISC_INTERP_MAX). Every binding pins a
struct file that no file descriptor accounts for, so RLIMIT_NOFILE does
not apply and some cap is needed. A hundred is plenty and raising it
later is cheap, lowering it is not.

Selection is by name so the register string and the program need not
agree on an order, and so the handler is not tied to where a distribution
puts its interpreters. A name is a single word of printable ASCII so the
entry file can report 'name path' lines. The interpreter runs under the
path it was registered under.

The entry file reads user memory once. bm_entry_write() copies the write
in and dispatches on the first byte, and parse_command() takes the copied
buffer. The status file has no binding to spell, so it keeps its own
small copy in read_command().

That moves the length cap ahead of the dispatch. A write to an entry file
longer than a binding can be is now refused with -E2BIG, and one from a
bad address reports -EFAULT, where the command parser used to report
-EINVAL for anything past three bytes.

Configurations of one instance are kept apart by the lock removal
already takes. Reading the set out of the entry file takes no lock.
Bindings are rcu-published and the open entry file pins the entry
together with everything it bound, so a reader either sees a whole node
or misses it. The interpreter is opened before the configuration lock
because resolving the path may walk this very filesystem, and only
after the command has been parsed and the name validated from the
copied buffer, so a write that can never bind opens nothing and the
errno reflects the actual failure.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c            | 266 +++++++++++++++++++++++++++++++++++---------
 fs/binfmt_misc_bpf.c        |  75 ++++++++++++-
 fs/exec.c                   |   2 +
 include/linux/binfmt_misc.h |  39 ++++++-
 include/linux/binfmts.h     |   3 +
 5 files changed, 326 insertions(+), 59 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index afd8a737c95b..ad8c4f64bf10 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -24,6 +24,7 @@
 #include <linux/fs_context.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/magic.h>
 #include <linux/module.h>
@@ -99,24 +100,6 @@ static const struct binfmt_misc_flag *misc_flag_by_char(const char c)
 	return NULL;
 }
 
-/**
- * struct binfmt_misc_interp - an interpreter an entry was registered with
- * @list: link in the entry's list, in registration order
- * @file: the file, opened at registration and never resolved again
- * @path: the path it was registered under, used as the name the interpreter
- *        runs under; stored after @name in the same allocation
- * @name: the name a load program selects it by; empty for the fixed
- *        interpreter of a static 'F' entry
- *
- * Owned by the entry and living exactly as long as it does.
- */
-struct binfmt_misc_interp {
-	struct list_head	list;
-	struct file		*file;
-	const char		*path;
-	char			name[];
-};
-
 struct binfmt_misc_entry {
 	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
@@ -252,6 +235,24 @@ static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
 	return search_binfmt_handler(misc, bprm);
 }
 
+/**
+ * binfmt_misc_find_interp - find a bound interpreter by name
+ * @interps: the interpreters the matched entry was registered with
+ * @name: the name to look for
+ *
+ * Return: the interpreter on success, NULL if @interps has none by that name
+ */
+const struct binfmt_misc_interp *
+binfmt_misc_find_interp(const struct list_head *interps, const char *name)
+{
+	struct binfmt_misc_interp *interp;
+
+	list_for_each_entry(interp, interps, list)
+		if (!strcmp(interp->name, name))
+			return interp;
+	return NULL;
+}
+
 /* Undo the open_exec() a pre-opened interpreter file came from. */
 static void close_interp_file(struct file *f)
 {
@@ -261,6 +262,8 @@ static void close_interp_file(struct file *f)
 	filp_close(f, NULL);
 }
 
+DEFINE_FREE(close_interp_file, struct file *, close_interp_file(_T))
+
 /*
  * Open an interpreter @path for execution: now, in the writer's context,
  * and - since binfmt_misc mounts can be unprivileged - with @cred, the
@@ -293,7 +296,7 @@ static void entry_put_interpreters(struct binfmt_misc_entry *e)
 /**
  * entry_attach_interpreter - bind an opened interpreter to @e
  * @e: entry being configured
- * @name: name a load program can select it by; empty for the fixed
+ * @name: name the load program will select it by; empty for the fixed
  *        interpreter of a static entry
  * @path: the path @f was opened from
  * @f: the interpreter, opened for execution
@@ -301,8 +304,8 @@ static void entry_put_interpreters(struct binfmt_misc_entry *e)
  * Every exec runs a clone of @f, so the path decided which file is bound
  * and nothing else: it is not resolved again, in any namespace.
  *
- * The caller has to have established that @e cannot be matched yet, and
- * owns @f until this succeeds.
+ * The caller has to have validated @name and @path, established that @e
+ * cannot be matched yet, and owns @f until this succeeds.
  *
  * Return: 0 on success, a negative errno on failure
  */
@@ -313,6 +316,11 @@ static int entry_attach_interpreter(struct binfmt_misc_entry *e,
 	size_t nlen = strlen(name), plen = strlen(path);
 	struct binfmt_misc_interp *interp;
 
+	if (binfmt_misc_find_interp(&e->interps, name))
+		return -EEXIST;
+	if (list_count_nodes(&e->interps) >= BINFMT_MISC_INTERP_MAX)
+		return -ENOSPC;
+
 	/* One allocation, both strings in it, like the entry's own buffer. */
 	interp = kmalloc(struct_size(interp, name, nlen + plen + 2),
 			 GFP_KERNEL_ACCOUNT);
@@ -323,7 +331,8 @@ static int entry_attach_interpreter(struct binfmt_misc_entry *e,
 	strscpy(interp->name, name, nlen + 1);
 	strscpy(interp->name + nlen + 1, path, plen + 1);
 	interp->file = f;
-	list_add_tail(&interp->list, &e->interps);
+	/* Publish the node: a lockless cat may be walking the list. */
+	list_add_tail_rcu(&interp->list, &e->interps);
 	pr_debug("register: interpreter: %s {%s}\n", name, path);
 	return 0;
 }
@@ -361,6 +370,20 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
 
 DEFINE_FREE(put_binfmt_handler, struct binfmt_misc_entry *, put_binfmt_handler(_T))
 
+/* Drop everything a load program staged for this exec. */
+static void drop_staged_selection(struct linux_binprm *bprm)
+{
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = NULL;
+	kfree(bprm->bpf_interp_arg);
+	bprm->bpf_interp_arg = NULL;
+	if (bprm->bpf_interp_file) {
+		fput(bprm->bpf_interp_file);
+		bprm->bpf_interp_file = NULL;
+	}
+	bprm->bpf_flags = 0;
+}
+
 /**
  * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
  *
@@ -394,7 +417,8 @@ static struct binfmt_misc *current_binfmt_misc(void)
  * @bprm: binary that is being executed
  *
  * A static entry carries its interpreter path, for a 'B' entry the
- * handler's load program selects it. The match is committed, so a failing
+ * handler's load program selects it, either by path or by the name of one
+ * of the interpreters the entry bound. The match is committed, so a failing
  * program fails the exec.
  *
  * Return: the interpreter on success, an ERR_PTR on failure
@@ -404,15 +428,20 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
 {
 	int retval;
 
+	/*
+	 * Drop what a previous chain level staged before anything can pick it
+	 * up. A static entry stages nothing but consumes a staged file just
+	 * like a 'B' entry does.
+	 */
+	drop_staged_selection(bprm);
+
 	if (!test_bit(MISC_FMT_BPF_BIT, &e->flags))
 		return e->interpreter;
 
-	/* Drop any interpreter or flags a previous chain level staged. */
-	kfree(bprm->bpf_interp);
-	bprm->bpf_interp = NULL;
-	bprm->bpf_flags = 0;
-
+	/* The interpreters this entry lets the program choose from. */
+	bprm->bpf_interps = &e->interps;
 	retval = e->bpf_ops->load(bprm);
+	bprm->bpf_interps = NULL;
 	if (retval) {
 		/* Keep a program-supplied error within errno range. */
 		if (retval > 0 || retval < -MAX_ERRNO)
@@ -430,9 +459,7 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
 
 drop_staged:
 	/* A failing load leaves nothing behind for later entries. */
-	kfree(bprm->bpf_interp_arg);
-	bprm->bpf_interp_arg = NULL;
-	bprm->bpf_flags = 0;
+	drop_staged_selection(bprm);
 	return ERR_PTR(retval);
 }
 
@@ -477,26 +504,36 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 /**
  * entry_open_interpreter - open the entry's interpreter for execution
  * @e: matched binary type handler
+ * @bprm: binary that is being executed
  * @interpreter: the interpreter selected for this exec
  *
  * An 'F' entry hands out a clone of the file it pre-opened at registration,
- * any other entry opens the selected path.
+ * and so does a 'B' entry whose load program selected one of the
+ * interpreters it bound. Any other entry opens the selected path.
  *
  * Return: the opened interpreter on success, an ERR_PTR on failure
  */
 static struct file *entry_open_interpreter(const struct binfmt_misc_entry *e,
+					   struct linux_binprm *bprm,
 					   const char *interpreter)
 {
 	struct file *interp_file __free(fput) = NULL;
 	struct binfmt_misc_interp *interp;
+	struct file *bound;
 	int retval;
 
-	if (!(e->flags & MISC_FMT_OPEN_FILE))
+	if (bprm->bpf_interp_file) {
+		bound = bprm->bpf_interp_file;
+	} else if (e->flags & MISC_FMT_OPEN_FILE) {
+		/* An 'F' entry pre-opened exactly one interpreter. */
+		interp = list_first_entry(&e->interps,
+					  struct binfmt_misc_interp, list);
+		bound = interp->file;
+	} else {
 		return open_exec(interpreter);
+	}
 
-	/* An 'F' entry pre-opened exactly one interpreter. */
-	interp = list_first_entry(&e->interps, struct binfmt_misc_interp, list);
-	interp_file = file_clone_open(interp->file);
+	interp_file = file_clone_open(bound);
 	if (IS_ERR(interp_file))
 		return interp_file;
 
@@ -606,7 +643,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	 * to the real format in the same round.
 	 */
 	if (flags & MISC_FMT_LOADER) {
-		interp_file = entry_open_interpreter(fmt, interpreter);
+		interp_file = entry_open_interpreter(fmt, bprm, interpreter);
 		if (IS_ERR(interp_file)) {
 			retval = PTR_ERR(interp_file);
 			/* Declining here would run the binary's own PT_INTERP. */
@@ -628,7 +665,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (retval < 0)
 		return retval;
 
-	interp_file = entry_open_interpreter(fmt, interpreter);
+	interp_file = entry_open_interpreter(fmt, bprm, interpreter);
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
 
@@ -902,7 +939,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	/*
 	 * A bpf handler decides the invocation flags per exec with
 	 * bpf_binprm_set_flags() rather than fixing them at registration, and
-	 * 'F' (pre-open a fixed interpreter) is meaningless for it, so a 'B'
+	 * the interpreters it binds pre-open what 'F' would have, so a 'B'
 	 * entry carries no invocation flags.
 	 */
 	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
@@ -913,7 +950,8 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	 * 'D' is a directive for this registration rather than a lasting
 	 * property, so consume it: the entry is created disabled and stays
 	 * out of the search list until '1' is written to its entry file.
-	 * The first enable publishes it, for good.
+	 * Staying out is what leaves it open to being given interpreters;
+	 * the first enable publishes it, for good.
 	 */
 	if (e->flags & MISC_FMT_DISABLED) {
 		e->flags &= ~MISC_FMT_DISABLED;
@@ -955,18 +993,17 @@ enum bm_command {
 	BM_CMD_REMOVE,	/* "-1" */
 };
 
+/* Longest of the commands above, "-1\n". */
+#define MAX_COMMAND_LENGTH 3
+
 /*
  * Parse what userspace wrote to /status or an entry file: '1' enables,
  * '0' disables and '-1' removes the entry or all entries.
  */
-static int parse_command(const char __user *buffer, size_t count)
+static int parse_command(const char *s, size_t count)
 {
-	char s[4];
-
-	if (count > 3)
+	if (count > MAX_COMMAND_LENGTH)
 		return -EINVAL;
-	if (copy_from_user(s, buffer, count))
-		return -EFAULT;
 	if (!count)
 		return BM_CMD_IGNORE;
 	if (s[count - 1] == '\n')
@@ -980,6 +1017,18 @@ static int parse_command(const char __user *buffer, size_t count)
 	return -EINVAL;
 }
 
+/* Copy in a command from a file that takes nothing else, and parse it. */
+static int read_command(const char __user *buffer, size_t count)
+{
+	char s[MAX_COMMAND_LENGTH + 1];
+
+	if (count > sizeof(s) - 1)
+		return -EINVAL;
+	if (copy_from_user(s, buffer, count))
+		return -EFAULT;
+	return parse_command(s, count);
+}
+
 /* generic stuff */
 
 /* The root directory's inode; its lock serializes configuring an instance. */
@@ -1003,10 +1052,23 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 	else
 		seq_puts(m, "disabled\n");
 
-	if (test_bit(MISC_FMT_BPF_BIT, &e->flags))
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		struct binfmt_misc_interp *interp;
+
 		seq_printf(m, "bpf %s\n", e->bpf_ops->name);
-	else
+		/*
+		 * A staged entry's set can still grow, so every binding is
+		 * rcu-published. The open file pins the entry and with it
+		 * every node, so rcu is for the tearing, not the lifetime.
+		 */
+		rcu_read_lock();
+		list_for_each_entry_rcu(interp, &e->interps, list)
+			seq_printf(m, "bpf-interpreter %s %s\n",
+				   interp->name, interp->path);
+		rcu_read_unlock();
+	} else {
 		seq_printf(m, "interpreter %s\n", e->interpreter);
+	}
 
 	/* print the special flags */
 	seq_puts(m, "flags: ");
@@ -1201,12 +1263,111 @@ static int bm_entry_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+/*
+ * Longest '+<name> <path>' a write can spell, and with it the longest
+ * command an entry file takes: the two delimiters and a newline on top of
+ * the two names.
+ */
+#define MAX_BINDING_LENGTH (BINFMT_MISC_INTERP_NAME_MAX + PATH_MAX + 3)
+
+/**
+ * bm_entry_add_interp - bind another interpreter to a staged entry
+ * @e: the entry
+ * @file: the entry file being written to, for its credentials
+ * @buf: the '+<name> <path>' command, parsed in place and owned by the caller
+ * @count: its length
+ *
+ * A 'D' entry is registered outside the search list, which is what leaves
+ * it open to being configured: it cannot be matched, so no exec can be
+ * holding its interpreters and the set can still grow. Its first enable
+ * publishes it and ends that. One interpreter per write, up to
+ * BINFMT_MISC_INTERP_MAX of them, none of which has to fit in a register
+ * string.
+ *
+ * Return: @count on success, a negative errno on failure
+ */
+static ssize_t bm_entry_add_interp(struct binfmt_misc_entry *e,
+				   struct file *file, char *buf, size_t count)
+{
+	struct file *f __free(close_interp_file) = NULL;
+	struct inode *root = bm_root_inode(file_inode(file)->i_sb);
+	size_t nlen, plen;
+	char *name, *path;
+	int retval;
+
+	/* Settled before the open: type is fixed, publication is permanent. */
+	if (!test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		return -EINVAL;
+	if (!hlist_unhashed_lockless(&e->node))
+		return -EBUSY;
+
+	/* '+<name> <path>': the path is everything past the first space. */
+	name = buf + 1;
+	path = strchr(name, ' ');
+	if (!path)
+		return -EINVAL;
+	*path++ = '\0';
+
+	plen = strlen(path);
+	/* The command has to end at the write, like a register string. */
+	if (path + plen != buf + count)
+		return -EINVAL;
+	if (plen && path[plen - 1] == '\n')
+		path[--plen] = '\0';
+	/* Resolved now, so a relative path would name the writer's cwd. */
+	if (path[0] != '/')
+		return -EINVAL;
+
+	nlen = path - name - 1;
+	if (!nlen || nlen > BINFMT_MISC_INTERP_NAME_MAX)
+		return -EINVAL;
+	/* The name prints between delimiters, so keep it a printable word. */
+	for (const char *p = name; *p; p++)
+		if (!isascii(*p) || !isgraph(*p))
+			return -EINVAL;
+
+	/* Opened before the lock: resolving it may walk this very filesystem. */
+	f = open_interp_file(file->f_cred, path);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	inode_lock(root);
+	if (d_unhashed(e->dentry))
+		retval = -ENOENT;	/* removed while we were opening it */
+	else if (!hlist_unhashed(&e->node))
+		retval = -EBUSY;	/* published while we were opening it */
+	else
+		retval = entry_attach_interpreter(e, name, path, f);
+	inode_unlock(root);
+	if (retval)
+		return retval;
+
+	/* The file is owned by the entry now. */
+	retain_and_null_ptr(f);
+	return count;
+}
+
 static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct inode *inode = file_inode(file);
 	struct binfmt_misc_entry *e = inode->i_private;
-	int res = parse_command(buffer, count);
+	char *buf __free(kfree) = NULL;
+	int res;
+
+	/* A binding is the longest command this file takes. */
+	if (count > MAX_BINDING_LENGTH)
+		return -E2BIG;
+
+	buf = memdup_user_nul(buffer, count);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	/* '+<name> <path>' binds an interpreter, everything else toggles. */
+	if (buf[0] == '+')
+		return bm_entry_add_interp(e, file, buf, count);
+
+	res = parse_command(buf, count);
 
 	switch (res) {
 	case BM_CMD_DISABLE:
@@ -1218,8 +1379,9 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		/*
 		 * The first enable publishes a 'D' entry into the search
 		 * list, whole. The lock keeps that ordered against a second
-		 * enable and against removal; a removed entry has nothing
-		 * left to publish.
+		 * enable, against removal - a removed entry has nothing left
+		 * to publish - and against binding: what can be matched can
+		 * no longer be configured.
 		 */
 		inode_lock(root);
 		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
@@ -1348,7 +1510,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	struct binfmt_misc *misc;
-	int res = parse_command(buffer, count);
+	int res = read_command(buffer, count);
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index 92003ea640d3..b246d886437b 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -7,6 +7,15 @@
  * namespace it was registered in. A binfmt_misc 'B' entry activates it:
  *
  *   echo ':entry:B::::<handler-name>:' > <binfmt_misc>/register
+ *
+ * The entry can bind the interpreters the handler may run its binaries
+ * with, each opened by the write that binds it and selected by name per
+ * exec. An entry registered with 'D' is not matchable yet, which is what
+ * leaves it open to being given them:
+ *
+ *   echo ':entry:B::::<handler-name>:D' > <binfmt_misc>/register
+ *   echo '+<name> <path>' > <binfmt_misc>/entry
+ *   echo 1 > <binfmt_misc>/entry
  */
 
 #include <linux/binfmt_misc.h>
@@ -16,6 +25,8 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/cred.h>
+#include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/limits.h>
 #include <linux/slab.h>
@@ -91,6 +102,20 @@ bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog)
 	       prog->aux->st_ops == &bpf_binfmt_misc_ops;
 }
 
+/*
+ * Replace the staged interpreter selection: naming a path drops a bound
+ * file, selecting a bound interpreter carries its file along.
+ */
+static void bm_bpf_stage_selection(struct linux_binprm *bprm, char *path,
+				   struct file *f)
+{
+	if (bprm->bpf_interp_file)
+		fput(bprm->bpf_interp_file);
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = path;
+	bprm->bpf_interp_file = f;
+}
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -103,7 +128,8 @@ __bpf_kfunc_start_defs();
  * before returning zero; the verifier rejects the call from any other
  * program, including the handler's own match program. The path is opened
  * with the credentials of the task doing the exec after the program
- * returns.
+ * returns. Calling it again replaces the selection, as does selecting an
+ * interpreter the entry bound with bpf_binprm_select_interp().
  *
  * Return: 0 on success, a negative errno on failure
  */
@@ -127,8 +153,50 @@ __bpf_kfunc int bpf_binprm_set_interp(struct linux_binprm *bprm,
 	if (!interp)
 		return -ENOMEM;
 
-	kfree(bprm->bpf_interp);
-	bprm->bpf_interp = interp;
+	bm_bpf_stage_selection(bprm, interp, NULL);
+	return 0;
+}
+
+/**
+ * bpf_binprm_select_interp - run this exec under an interpreter the entry bound
+ * @bprm: binary that is being executed
+ * @name: name the interpreter was registered under
+ * @name__sz: size of the @name buffer, including the terminating NUL
+ *
+ * To be called from the load program of a struct binfmt_misc_ops handler
+ * instead of bpf_binprm_set_interp(). It selects one of the interpreters
+ * the matched entry was registered with, each of which was opened once when
+ * the entry was registered. Nothing is resolved at exec time, so no
+ * filesystem view can redirect the interpreter.
+ *
+ * The interpreter runs under the path the entry registered it under.
+ * Calling it again replaces the selection.
+ *
+ * Return: 0 on success, -ENOENT if the matched entry bound no interpreter
+ * of that name, a negative errno on failure
+ */
+__bpf_kfunc int bpf_binprm_select_interp(struct linux_binprm *bprm,
+					 const char *name, size_t name__sz)
+{
+	const struct binfmt_misc_interp *interp;
+	size_t len;
+	char *path;
+
+	if (!name__sz)
+		return -EINVAL;
+	len = strnlen(name, name__sz);
+	if (len == name__sz || !len)
+		return -EINVAL;
+
+	interp = binfmt_misc_find_interp(bprm->bpf_interps, name);
+	if (!interp)
+		return -ENOENT;
+
+	path = kstrdup(interp->path, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	bm_bpf_stage_selection(bprm, path, get_file(interp->file));
 	return 0;
 }
 
@@ -211,6 +279,7 @@ __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bm_bpf_kfunc_ids)
 BTF_ID_FLAGS(func, bpf_binprm_set_interp, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_binprm_select_interp, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_binprm_set_interp_arg, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_binprm_set_flags, KF_SLEEPABLE)
 BTF_KFUNCS_END(bm_bpf_kfunc_ids)
diff --git a/fs/exec.c b/fs/exec.c
index 856731f78d05..a14f28b15607 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1477,6 +1477,8 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
 	kfree(bprm->bpf_interp);
+	if (bprm->bpf_interp_file)
+		fput(bprm->bpf_interp_file);
 	kfree(bprm->bpf_interp_arg);
 	kfree(bprm->fdpath);
 	kfree(bprm);
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index 4abdfd36b3fa..072e4b3dd78d 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -5,11 +5,41 @@
 #include <linux/types.h>
 
 struct bpf_prog;
+struct file;
 struct linux_binprm;
 struct user_namespace;
 
 #define BINFMT_MISC_OPS_NAME_MAX 16
 
+/* Longest name a 'B' entry can bind an interpreter under. */
+#define BINFMT_MISC_INTERP_NAME_MAX 32
+
+/* Most interpreters one entry can bind. */
+#define BINFMT_MISC_INTERP_MAX 100
+
+/**
+ * struct binfmt_misc_interp - an interpreter an entry was registered with
+ * @list: link in the entry's list, in registration order
+ * @file: the file, opened at registration and never resolved again
+ * @path: the path it was registered under, used as the name the interpreter
+ *        runs under; stored after @name in the same allocation
+ * @name: the name the load program selects it by; empty for the fixed
+ *        interpreter of a static 'F' entry
+ *
+ * Owned by the entry and living exactly as long as it does. The list head
+ * is handed to the handler's load program for the duration of one exec,
+ * which picks one with bpf_binprm_select_interp().
+ */
+struct binfmt_misc_interp {
+	struct list_head	list;
+	struct file		*file;
+	const char		*path;
+	char			name[];
+};
+
+const struct binfmt_misc_interp *
+binfmt_misc_find_interp(const struct list_head *interps, const char *name);
+
 /**
  * enum bpf_binprm_flags - per-exec invocation flags a load program can request
  * @BPF_BINPRM_PRESERVE_ARGV0: keep the caller's argv[0] (like the 'P' flag)
@@ -42,10 +72,11 @@ enum bpf_binprm_flags {
  *         so it can read the binary to decide, but the verifier rejects
  *         the interpreter selection kfuncs in it
  * @load:  select an interpreter for the matched @bprm via
- *         bpf_binprm_set_interp() and return zero; a match is committed, so
- *         a failure fails the exec instead of falling through to later
- *         entries; -ENOEXEC does not fail the exec but moves on to the
- *         remaining binary formats
+ *         bpf_binprm_set_interp(), or one the entry bound via
+ *         bpf_binprm_select_interp(), and return zero; a match is
+ *         committed, so a failure fails the exec instead of falling
+ *         through to later entries; -ENOEXEC does not fail the exec but
+ *         moves on to the remaining binary formats
  * @name: name that 'B' entries reference the handler by
  */
 struct binfmt_misc_ops {
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index a2daecbb01d6..f686a37f7a0a 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -14,7 +14,10 @@ struct coredump_params;
 
 /* Interpreter selection staged by a bpf binfmt_misc handler. */
 struct binfmt_misc_bpf {
+	/* interpreters the matched entry bound, selectable by name */
+	const struct list_head *bpf_interps;
 	const char *bpf_interp;		/* interpreter selected by a bpf handler */
+	struct file *bpf_interp_file;	/* the bound interpreter it selected */
 	const char *bpf_interp_arg;	/* interpreter argument from a bpf handler */
 	u64 bpf_flags;			/* enum bpf_binprm_flags from a bpf handler */
 };

-- 
2.53.0


