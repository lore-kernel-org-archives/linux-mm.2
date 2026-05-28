Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A27C8CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBFE6B00AA; Thu, 28 May 2026 05:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D586B00AC; Thu, 28 May 2026 05:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82DB6B00AD; Thu, 28 May 2026 05:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B745E6B00AA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:55:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 870F11C0E00
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:54 +0000 (UTC)
X-FDA: 84816372228.08.CD75F2A
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 91DA7A000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=M7mMVARh;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhfFQvdxoQHQc1XvZzl4k0UIxef+VVV/sdLhZpmWwr0=;
	b=35qniLG2fe0gxBx36h4ikmJpikHM1+jUNL6wtg/IBbO1WJgGwNUhkeb8Gg3FaznLlYW1Xz
	1G20wDjUqgcmbeAJ5HFi3QlJz4hkdMzcHiqKOh3HZckguNMWY34Q9p+98kBgyISOA+MYiI
	J+GmieqmBKUjkugqBN5BJwudchx5T1Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=M7mMVARh;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962152; a=rsa-sha256;
	cv=pass;
	b=UHdg1aPUJ0DT1hy3xzJ9Bo7D+xwPOsYOrzVEjA1yLo0D7DPaTfPO3v0xESJ7sFLU5nFFec
	PMdPXMX6wwDyaR6sVpdareL8vmrxPSDvENaTzANW8LxYmKw1dMrk8MnJn9gQCodtnHSr01
	KFTJ1TXCsmrpeVSfVenUtIC7qBCg2gA=
ARC-Seal: i=1; a=rsa-sha256; t=1779962026; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XQZq3+OEqfGlF9Cs3b3S85VSu6bPQ9oXwSEANCfOq4wMuGKDtilDyajnpC1Z4uLqyzBziU/Ke6iqKGaMa/cFro7xOuhGkoWJlDX1QFtr1Vgwtk6R0ueugPBNiFPayxsBqa1glj0AcPSC4l//Mp01m0JFTBq1To2ppF47zxxbFsE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962026; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LhfFQvdxoQHQc1XvZzl4k0UIxef+VVV/sdLhZpmWwr0=; 
	b=Uc0co1eQ7iD1xTV9AihTzQs/f7HXDjsJ/HnHwefn9A9VOPa3OynYr6QIKQnuRPMONv5JL9iL9JBm5++F0EJu1OnuaC5Z3OA5nh77npZt9Yd5LcvSKN/jjtB9oFiRmiUMmbLYRkkZLCGXbU0x9SEt4KtYJYGPqMqBYu5IVLmsTqo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962026;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=LhfFQvdxoQHQc1XvZzl4k0UIxef+VVV/sdLhZpmWwr0=;
	b=M7mMVARhBBhy6KWTWF+UDlSoGVh6NZ6LFSeX4jEUuEVHOCX6UNmPLDk7Phuww3su
	PGr5l0txatogltgY0VoEDovHmVmNz7k3jw1PA/A0qeXDtTExXKnlgl7/cKnORlUkFst
	LM3BAtkczo/5fEeByO3W/LfsVdnIBr6jvOHdz7U8=
Received: by mx.zohomail.com with SMTPS id 1779962024044536.5261694330434;
	Thu, 28 May 2026 02:53:44 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 06/13] exec: add spawn_template_spawn()
Date: Thu, 28 May 2026 17:52:27 +0800
Message-ID: <20260528095235.2491226-7-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: wh1ezxjyr5g1gjknukcyqux31wazwmrz
X-Rspamd-Queue-Id: 91DA7A000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779962152-614761
X-HE-Meta: U2FsdGVkX18Y/BhSqMt+Cl1hhJBEGxNPCzult00PdfB/+S9ygK6/Wbu3Wp76swLKiwyBWMcLZG6ukY533Ejj9D/jsSJlyi2DWrScpjT6C9G/nazwGjfmW6+B9Gy9zpM7hKdVGxTykEdZ4FNfQh3NjVThQ9Tb9Qx8ff9pkmgeWPTMEhlnb9T6ckxW/QpC/QavrNwcEzF8nZP6ReHZM4QxsYTE9xRw3wLiREQxyCJa42H44rfmUBct7ouEDitNa7SdFGBJ72eV5r4FDHL9cweVj9JFWsxoWXqS8GydZgS1zxpGxmvR1anZUdn/XnRdvrCxnBMhxhAFumvLkD5R1b3dLPog3s2GI4gGYlGymbXj0Fe2F8hRVgmaLUzWAa6pFEEKzgAKamlTA5oK1/x6LQoOi1BSowLsOR7BKQXMNW4r76YkI+wCWLndwOO/QDa8Qr6KEbrDriD2guLxUxhq5uPARFnAMPT/d8YljXlLjt5fzM/fLa46aVkNfRSV1LXxknA1pFWvUwmrYMkAEql3P+X2oN8fzzZ4vLJ3H65V6p9jgA4eZDIMWNq7/kepoOYV4IWj7/YGj12zWdAnIT/zGdcm5cCNL76ICcIpE+7CjqimUQrdKN4qSoXHGkwMpMerOX0xr/2opUz4sRAttHOR4GHm7sEp/VdAm23OhkNaJ0SFFm7fkFsIG5GGpNKzZqc23t/cF/fSKK1Q4sPjwiw11PeD+Z4jw9e0UJqGx/eYNPM7y0jEkHAkZdKSwYjzkDIXPWRGB6WfX6PAZSPQliSjwzUuuZNSGkd1jwsY5S+FD+UBscOI7IyT/h7NzkVhUMIkSv9EPiVQPJcmP16tR9bMYIV4sPOZzqBYFmPsTWhFMB562t7KwNP1R0t44YrxLT8ZmHON77mXN3C04bQvVn6sC43fAQApJwLQUNrdWw3lpbPryEJge8b6ISpdLHRGplOQbjbqNETPG0JFUwU8e3G6+a9
 /G1z9Qsu
 wXDrGSsul2ZMtJsljbpX5N74bz5D0EavcSk08IcDLmyH1BH/74Dw3tAEeHSiWNo6iZcgIEAm+UuOTQYIks0IQ0na0MZUVDyf9lsGBcbfPY2qCVoU3d3lbE4i670FW48Kvln7o7tRmbPG6SM58/3WzBUEfRDeI9Kv2NIT9UC33GZ9AfYBJp9qTKNV7MklsaYWd6GhiTXKZUZ6X++RDwrzOwgagEQyPH8NEwfQxx5EenaOoYPUK6/7RgMXFQe2sdgOieTQrVMFXEP3LkicDGlvdXYas0K/ZKcyzNFW5ssR+Ni28ntyM2jZG6PZ/fyjVwd4pnvXalva7EPkKSBeBdC0mxulvhc8F8rfxx4919X0yYsccHGLjQ4uow4wSdxS+DaVeZ7BM2qSwl8WlIlUSHu5tqbfsxQaV3K287U7GS2Oabgu27R1XfjZURdvlCAe5cpDOsCZR3Nf5XcN47XlmfXPQlODAoMcb8WjhYnNn3Cf3Ta/guQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add spawn_template_spawn() to start a child from a template fd. The child
uses the template's pinned executable file, runs per-spawn fd, cwd, and
signal actions, closes non-stdio fds by default, and then executes through
the normal opened-file exec path.
Return a pidfd for the child so userspace can wait or signal it without
racy pid reuse. Keep fd inheritance opt-in with
SPAWN_TEMPLATE_SPAWN_INHERIT_FDS.
This patch consumes cached template state but does not add ELF metadata
caching; executable identity and ELF metadata caching are added separately.

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/spawn_template.c      | 346 +++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |   4 +
 2 files changed, 350 insertions(+)

diff --git a/fs/spawn_template.c b/fs/spawn_template.c
index 280a1038cc45e..8c3711929cffb 100644
--- a/fs/spawn_template.c
+++ b/fs/spawn_template.c
@@ -1,14 +1,24 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/anon_inodes.h>
+#include <linux/binfmts.h>
+#include <linux/close_range.h>
 #include <linux/cred.h>
 #include <linux/err.h>
 #include <linux/fcntl.h>
+#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/kernel.h>
+#include <linux/namei.h>
+#include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/openat2.h>
 #include <uapi/linux/spawn_template.h>
 
 #include "internal.h"
@@ -22,8 +32,262 @@ struct spawn_template {
 	bool deny_write;
 };
 
+struct spawn_template_spawn_context {
+	struct spawn_template *tmpl;
+	struct spawn_template_spawn_args args;
+	struct spawn_template_action *actions;
+};
+
 static const struct file_operations spawn_template_fops;
 
+static int spawn_template_exit_status(int err)
+{
+	switch (err) {
+	case -ENOENT:
+		return 127;
+	case -EACCES:
+	case -ENOEXEC:
+		return 126;
+	default:
+		return 1;
+	}
+}
+
+static bool spawn_template_cred_matches(struct spawn_template *tmpl)
+{
+	return current_cred() == tmpl->creator_cred;
+}
+
+static int spawn_template_copy_signal_set(const struct spawn_template_action *action,
+					  sigset_t *mask)
+{
+	struct spawn_template_sigset sigset;
+
+	if (!action->arg)
+		return -EINVAL;
+	if (copy_from_user(&sigset, u64_to_user_ptr(action->arg),
+			   sizeof(sigset)))
+		return -EFAULT;
+	if (sigset.sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+	if (copy_from_user(mask, u64_to_user_ptr(sigset.sigset), sizeof(*mask)))
+		return -EFAULT;
+	sigdelsetmask(mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+
+	return 0;
+}
+
+static int spawn_template_apply_open(const struct spawn_template_action *action)
+{
+	struct spawn_template_open open;
+	struct file *file __free(fput) = NULL;
+	struct file *tmp;
+	struct open_flags op;
+	int ret;
+
+	if (action->fd < AT_FDCWD || action->newfd < 0 || action->flags ||
+	    !action->arg)
+		return -EINVAL;
+
+	if (copy_from_user(&open, u64_to_user_ptr(action->arg), sizeof(open)))
+		return -EFAULT;
+
+	ret = build_open_flags(&open.how, &op);
+	if (ret)
+		return ret;
+
+	CLASS(filename_flags, name)(u64_to_user_ptr(open.path), op.lookup_flags);
+	tmp = do_file_open(action->fd, name, &op);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+	file = tmp;
+
+	return replace_fd(action->newfd, file, open.how.flags & O_CLOEXEC);
+}
+
+static int spawn_template_apply_sigmask(const struct spawn_template_action *action)
+{
+	sigset_t mask;
+	int ret;
+
+	if (action->fd || action->newfd || action->flags)
+		return -EINVAL;
+
+	ret = spawn_template_copy_signal_set(action, &mask);
+	if (ret)
+		return ret;
+
+	set_current_blocked(&mask);
+	return 0;
+}
+
+static int spawn_template_apply_sigdefault(const struct spawn_template_action *action)
+{
+	sigset_t mask;
+	struct k_sigaction sa = {};
+	int ret;
+	int sig;
+
+	if (action->fd || action->newfd || action->flags)
+		return -EINVAL;
+
+	ret = spawn_template_copy_signal_set(action, &mask);
+	if (ret)
+		return ret;
+
+	sa.sa.sa_handler = SIG_DFL;
+	sigemptyset(&sa.sa.sa_mask);
+
+	for (sig = 1; sig < _NSIG; sig++) {
+		if (!sigismember(&mask, sig))
+			continue;
+		ret = do_sigaction(sig, &sa, NULL);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int spawn_template_apply_action(const struct spawn_template_action *action)
+{
+	switch (action->type) {
+	case SPAWN_TEMPLATE_ACTION_CLOSE:
+		return close_fd(action->fd);
+	case SPAWN_TEMPLATE_ACTION_DUP2:
+		if (action->fd == action->newfd) {
+			if (action->flags)
+				return -EINVAL;
+			CLASS(fd, f)(action->fd);
+
+			if (fd_empty(f))
+				return -EBADF;
+			return 0;
+		}
+		return ksys_dup3(action->fd, action->newfd, action->flags);
+	case SPAWN_TEMPLATE_ACTION_FCHDIR: {
+		CLASS(fd, f)(action->fd);
+		int ret;
+
+		if (fd_empty(f))
+			return -EBADF;
+		if (!d_can_lookup(fd_file(f)->f_path.dentry))
+			return -ENOTDIR;
+
+		ret = file_permission(fd_file(f), MAY_EXEC | MAY_CHDIR);
+		if (!ret)
+			set_fs_pwd(current->fs, &fd_file(f)->f_path);
+		return ret;
+	}
+	case SPAWN_TEMPLATE_ACTION_OPEN:
+		return spawn_template_apply_open(action);
+	case SPAWN_TEMPLATE_ACTION_CLOSE_RANGE:
+		return do_close_range(action->fd, action->newfd, action->flags);
+	case SPAWN_TEMPLATE_ACTION_SIGMASK:
+		return spawn_template_apply_sigmask(action);
+	case SPAWN_TEMPLATE_ACTION_SIGDEFAULT:
+		return spawn_template_apply_sigdefault(action);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int spawn_template_copy_actions(struct spawn_template_action **out_actions,
+				       u64 count, u64 uaddr)
+{
+	struct spawn_template_action __user *uactions;
+	struct spawn_template_action *actions __free(kfree) = NULL;
+	struct spawn_template_action *tmp;
+	u64 i;
+
+	*out_actions = NULL;
+	if (!count)
+		return 0;
+	if (count > SPAWN_TEMPLATE_MAX_ACTIONS)
+		return -E2BIG;
+	if (!uaddr)
+		return -EINVAL;
+
+	uactions = u64_to_user_ptr(uaddr);
+	tmp = memdup_array_user(uactions, count, sizeof(*actions));
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+	actions = tmp;
+
+	for (i = 0; i < count; i++) {
+		switch (actions[i].type) {
+		case SPAWN_TEMPLATE_ACTION_CLOSE:
+			if (actions[i].fd < 0 || actions[i].flags ||
+			    actions[i].newfd || actions[i].arg)
+				return -EINVAL;
+			break;
+		case SPAWN_TEMPLATE_ACTION_DUP2:
+			if (actions[i].fd < 0 || actions[i].newfd < 0 ||
+			    (actions[i].flags & ~O_CLOEXEC) || actions[i].arg)
+				return -EINVAL;
+			break;
+		case SPAWN_TEMPLATE_ACTION_FCHDIR:
+			if (actions[i].fd < 0 || actions[i].flags ||
+			    actions[i].newfd || actions[i].arg)
+				return -EINVAL;
+			break;
+		case SPAWN_TEMPLATE_ACTION_OPEN:
+			if (actions[i].fd < AT_FDCWD || actions[i].newfd < 0 ||
+			    actions[i].flags || !actions[i].arg)
+				return -EINVAL;
+			break;
+		case SPAWN_TEMPLATE_ACTION_CLOSE_RANGE:
+			if (actions[i].fd < 0 || actions[i].newfd < 0 ||
+			    actions[i].fd > actions[i].newfd ||
+			    (actions[i].flags &
+			     ~(CLOSE_RANGE_UNSHARE | CLOSE_RANGE_CLOEXEC)) ||
+			    actions[i].arg)
+				return -EINVAL;
+			break;
+		case SPAWN_TEMPLATE_ACTION_SIGMASK:
+		case SPAWN_TEMPLATE_ACTION_SIGDEFAULT:
+			if (actions[i].fd || actions[i].newfd ||
+			    actions[i].flags || !actions[i].arg)
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	*out_actions = no_free_ptr(actions);
+	return 0;
+}
+
+static int spawn_template_child(void *data)
+{
+	struct spawn_template_spawn_context *ctx = data;
+	struct spawn_template *tmpl = ctx->tmpl;
+	int ret;
+	u64 i;
+
+	for (i = 0; i < ctx->args.actions_len; i++) {
+		ret = spawn_template_apply_action(&ctx->actions[i]);
+		if (ret < 0)
+			goto out_exec_error;
+	}
+
+	if (!(ctx->args.flags & SPAWN_TEMPLATE_SPAWN_INHERIT_FDS)) {
+		ret = do_close_range(3, ~0U, 0);
+		if (ret < 0)
+			goto out_exec_error;
+	}
+
+	ret = kernel_execveat_file(tmpl->exec_file, "",
+				   u64_to_user_ptr(ctx->args.argv),
+				   u64_to_user_ptr(ctx->args.envp),
+				   AT_EMPTY_PATH);
+out_exec_error:
+	if (ret < 0)
+		do_exit(spawn_template_exit_status(ret));
+	return 0;
+}
+
 static bool spawn_template_file_exec_allowed(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))
@@ -53,6 +317,18 @@ static const struct file_operations spawn_template_fops = {
 	.llseek		= noop_llseek,
 };
 
+static struct file *spawn_template_file_from_fd(int fd)
+{
+	CLASS(fd, f)(fd);
+
+	if (fd_empty(f))
+		return ERR_PTR(-EBADF);
+	if (fd_file(f)->f_op != &spawn_template_fops)
+		return ERR_PTR(-EINVAL);
+
+	return get_file(fd_file(f));
+}
+
 static int spawn_template_open_execfd(int execfd, struct file **file,
 				      bool *deny_write)
 {
@@ -178,3 +454,73 @@ SYSCALL_DEFINE2(spawn_template_create,
 	kfree(tmpl);
 	return ret;
 }
+
+SYSCALL_DEFINE3(spawn_template_spawn, int, template_fd,
+		struct spawn_template_spawn_args __user *, uargs,
+		size_t, usize)
+{
+	struct spawn_template_spawn_context *ctx;
+	struct kernel_clone_args kargs;
+	struct file *template_file;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct spawn_template_spawn_args) !=
+		     SPAWN_TEMPLATE_SPAWN_ARGS_SIZE_VER0);
+
+	if (usize < SPAWN_TEMPLATE_SPAWN_ARGS_SIZE_VER0)
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+
+	template_file = spawn_template_file_from_fd(template_fd);
+	if (IS_ERR(template_file))
+		return PTR_ERR(template_file);
+
+	if (!spawn_template_cred_matches(template_file->private_data)) {
+		ret = -EACCES;
+		goto out_put_template;
+	}
+
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out_put_template;
+	}
+
+	ctx->tmpl = template_file->private_data;
+
+	ret = copy_struct_from_user(&ctx->args, sizeof(ctx->args), uargs,
+				    usize);
+	if (ret)
+		goto out_free_ctx;
+
+	if ((ctx->args.flags & ~SPAWN_TEMPLATE_SPAWN_INHERIT_FDS) ||
+	    !ctx->args.pidfd || ctx->args.reserved[0] ||
+	    ctx->args.reserved[1] || ctx->args.reserved[2] ||
+	    ctx->args.reserved[3]) {
+		ret = -EINVAL;
+		goto out_free_ctx;
+	}
+
+	ret = spawn_template_copy_actions(&ctx->actions, ctx->args.actions_len,
+					  ctx->args.actions);
+	if (ret)
+		goto out_free_ctx;
+
+	kargs = (struct kernel_clone_args) {
+		.flags		= CLONE_VM | CLONE_VFORK | CLONE_PIDFD,
+		.pidfd		= u64_to_user_ptr(ctx->args.pidfd),
+		.exit_signal	= SIGCHLD,
+		.fn		= spawn_template_child,
+		.fn_arg		= ctx,
+	};
+
+	ret = kernel_clone(&kargs);
+
+	kfree(ctx->actions);
+out_free_ctx:
+	kfree(ctx);
+out_put_template:
+	fput(template_file);
+	return ret;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4b41950488bd6..df7368edf6778 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -68,6 +68,7 @@ union bpf_attr;
 struct io_uring_params;
 struct clone_args;
 struct spawn_template_create_args;
+struct spawn_template_spawn_args;
 struct open_how;
 struct mount_attr;
 struct landlock_ruleset_attr;
@@ -824,6 +825,9 @@ asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
 asmlinkage long sys_clone3(struct clone_args __user *uargs, size_t size);
 asmlinkage long sys_spawn_template_create(struct spawn_template_create_args __user *uargs,
 					  size_t size);
+asmlinkage long sys_spawn_template_spawn(int template_fd,
+					 struct spawn_template_spawn_args __user *uargs,
+					 size_t size);
 
 asmlinkage long sys_execve(const char __user *filename,
 		const char __user *const __user *argv,
-- 
2.52.0


