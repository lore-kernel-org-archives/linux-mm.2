Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DF5CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6366B00A8; Thu, 28 May 2026 05:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDD76B00AA; Thu, 28 May 2026 05:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC836B00AB; Thu, 28 May 2026 05:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3BD76B00A8
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:55:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFDC21C13AF
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:29 +0000 (UTC)
X-FDA: 84816371178.07.507D84A
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 010EE4000E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=gooSu8WX;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP+tXDAHbI+vpJXGx0g74A5vKG5a06odoAVil7kxPRc=;
	b=lKay8NE44nUhiE/NSyzEY17cugAyFBtaVU3YsPfeO5GK9L0QTCZGG6ci5qvRT7fRZ8zbgN
	ZLP9lD4KZphGu5vcTu38SQg4A4I2Q1AusIQhY9PcxnSnS/8WBUg//3VdASV57cSkYdsSn7
	pfm08VlCBf9d2o3S0Do1g8PpIrK9SfY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962128; a=rsa-sha256;
	cv=pass;
	b=7xsfSy4uivZhZtP5WkzYr3P+506Gr/WF+ApNJXLRXKsBP6HkSv5GYicadcuB3zmlovr4/K
	gXMaCDW11pWDcCjolz7usAvGNihjJ9VvcZpb5qV+/QUjsL/+cfjSFxt4GHNV86BE92QCEl
	hvzs7uV9aBM4RExcOIqe24JV51TBjUg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=gooSu8WX;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1779962018; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NiCRIb5eW2EmjWumorNbTFqVTFWRMvbiMFgX0JVJ5UqxeQOoKeglBqPoUS7pU3aoY5wZNnHmTpOZIcK7Ufuccb93ogSCXbqDto2C+AyqCPY1YhZz495SeTWoBlR7iy4hu1RtwLt43urc4771wo8s9KVDA7WpNOozpJ++dl2/bf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962018; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yP+tXDAHbI+vpJXGx0g74A5vKG5a06odoAVil7kxPRc=; 
	b=SaIsF/fNbDe3s/8mTIYMUA+BvDn7XG6Wb3FtDrEQQjybgIPqA2CBpLUcSvS2GZ4QSOJNHjrfsAFsqPZv/E6GiKzg0s0cSz+DNYZ15dpIHV+i5aMCQrDUota3fasPBEEXqBBH323qPN6IHBQCfP2HofnF9WY+7NX0hXOCH719gSM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962018;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yP+tXDAHbI+vpJXGx0g74A5vKG5a06odoAVil7kxPRc=;
	b=gooSu8WXAV0meD4y8CEBu6Z5WLJkTZ/h/TUb/2xCGsyM/FNiDRZUCqvSs5GXNv4I
	RxoWXdxQout4ibJuz3HBRTz1mr/EIcxMS4i9nA8NV9whW9/FnXDMyabvuRQ8nILdG9s
	d+vdx4iRNwGk6Qag8SgUQ+z39unNW37PfT2eN6tc=
Received: by mx.zohomail.com with SMTPS id 1779962016151343.1095475450736;
	Thu, 28 May 2026 02:53:36 -0700 (PDT)
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
Subject: [RFC PATCH v1 05/13] exec: add spawn template file descriptors
Date: Thu, 28 May 2026 17:52:26 +0800
Message-ID: <20260528095235.2491226-6-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Stat-Signature: rc48eyabmqrwnt3yxpdd57ix6ehc4bhf
X-Rspamd-Queue-Id: 010EE4000E
X-Rspam-User: 
X-HE-Tag: 1779962127-754050
X-HE-Meta: U2FsdGVkX19jMQ3nnS6F4pf7/5L6QyP7FTT3j+XKR89+0oSVGmFx1QSvhtWPEdyaP1RWG8gvo3cuZC2Uppml4h89hyXgJ8NF8rQNgxuQTnkeU4GfEQt8Pymz5stGIzamR22QAbzkLFAo7i6i8KMDrWAFELXHTScBz0VQDdpYzVOauqrzjS9a2I4jm7QjqfIcmYlby20lxh+Od9DZqL5WFoUAQ8Db9I+Z7JV5wpNXUwTshD6RzVIBxz+zxZQerQyZGsZQ/TBOFpfDQqCqohl4AEhKhATfaaDat3wxT70OUXLUkCpgrQPXY5AI2CiB03oYAte/hp1gMpU2in2Wk/9H+m/C2S0IlODN7Pu+uLrfPf737u19r1ViWM6mxwDO3XTizbdPJx91L4NCfBagPz07Ok5wYbMuIxiKp+ohYpGeIEIyMJkBGiVGuIoKV515ywrxxsx5Tm3eC1LiBJ1V8FV97kXuPTG8VYJgjSpydA3fHXQQt1dSjWf6Jx6brLANU+OPRu91jtYVIDFTTDdbEXCflEpWK6glAqcJAfS4bGUeEG0O3W0fWNt/d7ZSHnCRa5Xkro3tN9Il4v+WJ+trkDiqsHkkXfxko91fVfZ9XHIlzLI9aHVbPBOQXX23fczja5hoNhtX65/NCP3JnxjvgXdPI3EtYsgu86A0cg+mRxS3h56zF0nzep5h2jOWjE7gxndrldLYFkeSchuEOXk90uRp4EH2LMvJki3uUZIGTFgCyicxS3eM+hG1OvpttwH0MHSDFAeNgHz2/yP9+FK36Emplbbtn8lwTGiO89mcalAs2KYlGcAxmVWEqa2h2Ht50qLz4Xnnr9y6rUn55j0mBhtOqzWWZFEO47QRFSFJ4FJEd5S3llGlQ5cqIJnfNMEJrjy11bQcY9LZpDLWwbiYa+++5VrQc6MNMirzWkOlSgLxrIh7glCfzYME/jWn5Qx+VIAO4zK7NNEumndX4Frya/d
 Pjsj1xvT
 7oTWJg/ewIaOU89H7HnHn9B5iO5wTeMrur7JSg2G2Ke0wd4HmcQG/CYBEVHEE8CREi1Wh5tYfwthAxMZZJEBhnWhY3Z6YbjEWWpICup9jwWbExqhjeyQPrk1hsNPDoNYHN1OXQAl/AqmpmuUaETDBu8Q3OxZ4XF9Rd/cx/Btd2w28EqKyOKHT1UGftZxVwOkIaXihEXyvCds3Qy7qCzKUihmspne4jaz4iC/Tv9HbWSlIsdfmAd0Ryx1VLJc/4AmXKiQ3B7hdq97s9tmIVCKrAKTLVBHPaP+L2Ac/CC0Azdub8nG+c1hGS9OBRMByhY+HhvyBry0MIMvL6DFTCaGByfn55GnDaDGKgU+EsXmyHR/TT4r4ECA9YObydt/HciVP8GFOU3ZdlT31V/HCkKg4B3eunC7zvxqAZPPEeVtCdyrpBx1XGDIyHiexeMrlX+LNlaArlJBAz4mpeNBN4fNHw6KLsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add spawn_template_create() and back each template with an anon-inode fd.
Creation records the per-template state that later spawns reuse: the opened
executable file, optional absolute path, creator credential, and deny-write
state. Keep write access denied until the template fd is released so cached
state cannot race with writers.
This patch only creates and releases template fds.
Spawning and ELF metadata caching are added separately.

Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                            |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 -
 fs/Makefile                            |   2 +-
 fs/spawn_template.c                    | 180 +++++++++++++++++++++++++
 include/linux/syscalls.h               |   3 +
 5 files changed, 185 insertions(+), 2 deletions(-)
 create mode 100644 fs/spawn_template.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d7b1191e33ca0..d5441812825c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9732,6 +9732,7 @@ F:	Documentation/userspace-api/ELF.rst
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
+F:	fs/spawn_template.c
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
 F:	include/linux/binfmts.h
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 524155d655da1..d6c1667e8f3b8 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,7 +396,6 @@
 469	common	file_setattr		sys_file_setattr
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
-
 #
 # Due to a historical design error, certain syscalls are numbered differently
 # in x32 as compared to native x86_64.  These syscalls have numbers 512-547.
diff --git a/fs/Makefile b/fs/Makefile
index ae1b07f9c6a0c..796eb4ae143e5 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -8,7 +8,7 @@
 
 
 obj-y :=	open.o read_write.o file_table.o super.o \
-		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
+		char_dev.o stat.o exec.o spawn_template.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
diff --git a/fs/spawn_template.c b/fs/spawn_template.c
new file mode 100644
index 0000000000000..280a1038cc45e
--- /dev/null
+++ b/fs/spawn_template.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/anon_inodes.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/spawn_template.h>
+
+#include "internal.h"
+
+#define SPAWN_TEMPLATE_MAX_ACTIONS	256
+
+struct spawn_template {
+	struct file *exec_file;
+	const struct cred *creator_cred;
+	char *filename;
+	bool deny_write;
+};
+
+static const struct file_operations spawn_template_fops;
+
+static bool spawn_template_file_exec_allowed(struct file *file)
+{
+	if (!S_ISREG(file_inode(file)->i_mode))
+		return false;
+	if (path_noexec(&file->f_path))
+		return false;
+	if (file_permission(file, MAY_EXEC))
+		return false;
+	return can_mmap_file(file);
+}
+
+static int spawn_template_release(struct inode *inode, struct file *file)
+{
+	struct spawn_template *tmpl = file->private_data;
+
+	if (tmpl->deny_write)
+		exe_file_allow_write_access(tmpl->exec_file);
+	fput(tmpl->exec_file);
+	put_cred(tmpl->creator_cred);
+	kfree(tmpl->filename);
+	kfree(tmpl);
+	return 0;
+}
+
+static const struct file_operations spawn_template_fops = {
+	.release	= spawn_template_release,
+	.llseek		= noop_llseek,
+};
+
+static int spawn_template_open_execfd(int execfd, struct file **file,
+				      bool *deny_write)
+{
+	int ret;
+
+	if (execfd < 0)
+		return -EINVAL;
+
+	CLASS(fd, f)(execfd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	if (!spawn_template_file_exec_allowed(fd_file(f)))
+		return -EACCES;
+
+	ret = exe_file_deny_write_access(fd_file(f));
+	if (ret)
+		return ret;
+
+	*file = get_file(fd_file(f));
+	*deny_write = true;
+	return 0;
+}
+
+static int spawn_template_open_filename(u64 filename, struct file **file,
+					char **path,
+					bool *deny_write)
+{
+	char *kfilename __free(kfree) = NULL;
+	struct file *exec __free(fput) = NULL;
+	struct file *tmp_file;
+	char *tmp;
+
+	if (!filename)
+		return -EINVAL;
+
+	tmp = strndup_user(u64_to_user_ptr(filename), PATH_MAX);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+	kfilename = tmp;
+
+	tmp_file = open_exec(kfilename);
+	if (IS_ERR(tmp_file))
+		return PTR_ERR(tmp_file);
+	exec = tmp_file;
+	if (!spawn_template_file_exec_allowed(exec)) {
+		exe_file_allow_write_access(exec);
+		return -EACCES;
+	}
+
+	*file = no_free_ptr(exec);
+	*path = no_free_ptr(kfilename);
+	*deny_write = true;
+	return 0;
+}
+
+SYSCALL_DEFINE2(spawn_template_create,
+		struct spawn_template_create_args __user *, uargs,
+		size_t, usize)
+{
+	struct spawn_template_create_args args;
+	struct spawn_template *tmpl;
+	int fd_flags = 0;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct spawn_template_create_args) !=
+		     SPAWN_TEMPLATE_CREATE_ARGS_SIZE_VER0);
+
+	if (usize < SPAWN_TEMPLATE_CREATE_ARGS_SIZE_VER0)
+		return -EINVAL;
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+
+	ret = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (ret)
+		return ret;
+
+	if (args.flags & ~SPAWN_TEMPLATE_CREATE_CLOEXEC)
+		return -EINVAL;
+	if (args.exec_flags || args.reserved[0] || args.reserved[1] ||
+	    args.reserved[2] || args.reserved[3])
+		return -EINVAL;
+	if (args.actions || args.actions_len)
+		return -EINVAL;
+	if ((args.execfd < 0 && !args.filename) ||
+	    (args.execfd >= 0 && args.filename))
+		return -EINVAL;
+
+	tmpl = kzalloc_obj(*tmpl, GFP_KERNEL);
+	if (!tmpl)
+		return -ENOMEM;
+	tmpl->creator_cred = get_current_cred();
+
+	if (args.filename)
+		ret = spawn_template_open_filename(args.filename,
+						   &tmpl->exec_file,
+						   &tmpl->filename,
+						   &tmpl->deny_write);
+	else
+		ret = spawn_template_open_execfd(args.execfd,
+						 &tmpl->exec_file,
+						 &tmpl->deny_write);
+	if (ret)
+		goto out_free_tmpl;
+
+	if (args.flags & SPAWN_TEMPLATE_CREATE_CLOEXEC)
+		fd_flags |= O_CLOEXEC;
+
+	ret = anon_inode_getfd("spawn_template", &spawn_template_fops, tmpl,
+			       fd_flags);
+	if (ret < 0)
+		goto out_put_exec;
+
+	return ret;
+
+out_put_exec:
+	if (tmpl->deny_write)
+		exe_file_allow_write_access(tmpl->exec_file);
+	fput(tmpl->exec_file);
+out_free_tmpl:
+	put_cred(tmpl->creator_cred);
+	kfree(tmpl->filename);
+	kfree(tmpl);
+	return ret;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f3dfc3269188a..4b41950488bd6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -67,6 +67,7 @@ struct rseq;
 union bpf_attr;
 struct io_uring_params;
 struct clone_args;
+struct spawn_template_create_args;
 struct open_how;
 struct mount_attr;
 struct landlock_ruleset_attr;
@@ -821,6 +822,8 @@ asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
 #endif
 
 asmlinkage long sys_clone3(struct clone_args __user *uargs, size_t size);
+asmlinkage long sys_spawn_template_create(struct spawn_template_create_args __user *uargs,
+					  size_t size);
 
 asmlinkage long sys_execve(const char __user *filename,
 		const char __user *const __user *argv,
-- 
2.52.0


