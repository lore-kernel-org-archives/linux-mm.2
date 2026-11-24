Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7D5606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIkuXiXe
Received: by kanga.kvack.org (Postfix)
	id 78EC56B0899; Tue, 24 Nov 2026 18:00:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718C06B089B; Tue, 24 Nov 2026 18:00:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9836B089C; Tue, 24 Nov 2026 18:00:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D81B6B0899
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9882D40D96
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:36 +0000 (UTC)
X-FDA: 85471533672.14.B2AF5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C1D991A000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIkuXiXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561234;
	b=R4MUM7eqjHXCmY6BEwOyBTPvLUWfUkBpY3LgWrti9xRvXYbRP0CwxiE5Ng3yboQxMskk7N
	mBwT1S3maREftYqPd0VjIvVlEWWUVXDTlvZdTrFYIHwnAlHqaCG9pcUY6Ps2wNeZNfQhpP
	lVD5Wm5r7nlkmWPH48wW/AGohmCxN6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNV8rJH4Kk9+o13rpAbYwrbNyiuK+XJchQZ6VUpEriQ=;
	b=hUh0XuIrIozVTyocOy2WG+YreQa1Y7XaTc/IhYU0mXsg66aAN+XDW4pfi06eE54+7AJfTz
	kLMvqT9lcCvdFHHYMNZxEhh7neBREkEIgwUvPF2Re5Y6BSMbPwUU/5bE6UvVM3d+TK4Gzx
	RL6Qfc5w9t62ybuVRj3t6wc9d65EI18=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIkuXiXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11B5142E1A;
	Tue, 24 Nov 2026 23:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2405E1F0156C;
	Tue, 24 Nov 2026 23:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561233;
	bh=eNV8rJH4Kk9+o13rpAbYwrbNyiuK+XJchQZ6VUpEriQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GIkuXiXeLvYf1n/C5+5N/d5eZjBkiqNux/gyQkp/+9VmYKXhbEjjLjdnxAFAi95mt
	 hNn98Mxho2aVW4wsAkYiZ14NHRv08FXyDzzobCk9qc2EXsfb/h6AQJ8uGTV0ZQ4ghV
	 IKw715rUHNztCMHH6uurR1xfSDlUD6L/nhhl/98PicsPX4oNyfChyzlLmijosxr4oU
	 V6MHG9ejkFn8lg114adbkEN9bbOLz4QwR76VVRfLCzCiHwcn9+v1eXUYfAbCqpBoFF
	 t0QamGt2Sp51vUsfBWuK2ROeTXyuYafbdeW1UHWGzr43WrBMX9tZCuJUYuNKpmpwNr
	 1mM63G/Fr6H6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:40 +0100
Subject: [PATCH RFC 17/19] proc: look up map_files vma without
 exec_update_lock held
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-17-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=4361; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cECZa0eQtjLytpPlR2SBCNYBSmdlP+dulEopZzDPwU8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziZ38aPZaYe2ujs2Lvi0+foDN9Mb8v8p/Rb+kPJhlo
 M70fUnKpI5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJNGkz/I95dT/wwE3Hks9r
 FiyIXfTs1blSaT7OZxcPpZ24mbxqd1ECw/+sO1WZodnqt+P0nshFpbAc92RaceuQgcafZwue3Vn
 IuoADAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C1D991A000F
X-Stat-Signature: iemddt75gu8iz3fs65e8wzktxcfkusea
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795561234-199255
X-HE-Meta: U2FsdGVkX1/uucjkkKFfcpBEztxGCs8KXG5hJ/POTM5kCrs1WtKsbkzWdgKn1jgz4RMM10VGrAzjsaKLy39HHrlvB/MPDIyf1TFvnCay48KQi7ht49/Ptl216Mx4pRw9guz/u8HzJyFlyyWGPNBsiZ8WkEFvxtEVnhy9I12Q7RpjSvWp/XJl7tQt/dDNODdDqp3NyxnS74iOs2Vp4fGOye4TZ544S6mrNRXWaNz/GVSZF5U3qausAKsla2zA7P8J5oC/GYz7kkHO5QdU5fe59VG3CVFqm+2ws9rzb2gz1xvkmGjRG/GVj6i1oUZ/Jnxd23EAudAOiZMcZcppZmraPv4+/u3gOCV6oDgoKyNhvD4BAx7t1X68+30ADgn7Kji7aBlO+Ykn8xgoD6UkRV4kIBSupV2V9IyUkyrkKUN/VU+c4pniXCY5eQcP9AOeD4d54Rk5P7t7XsLggLuxd7/mjkq5iTGH46r806F5J1EnB1vt4UdeSykOBTnjQtuziPCjMYGvWnluIJluxh0/4zO7esjmxORrL4y4l3bzgc2EVbg7G0Gl2ygM68aoYa0MNS4xy3Gq+3Zb3HXNtpKhc/AFJpAcAyocKvjlR+RAd6XBR5RKp0F8PXNqcvnHAuWm/9m3U07iH1CPjPUyFhuP61vHZgI4oiaYV1Mh22RMX8C8V9WbAV6TgyHW+Wxt6SUjyXqcCL8wdWJnIOXNluYi7+HFZcY+ofjIsSOGtOOITQkZ2gGEiYOMiZ0GseDqvk6IhmZ3z42veAboWI3dr9P7huZ4VTvyJbQj51nXlTcLVDDtXtYe323iDMnlxonNIY4x02m/1qINpdU7E6cu2WIljEPw4usmZOKEJOY+MvcZwfA+voRTgW8KVXNvGhIBtY1Nv0n3M+AAI2JmT022Z+fNaMjVI0axZeDr6U0rIyPN6ght1cEECCnnrzLjyx++7D0SLHj98vWJpaoS5RUxDyee5KB
 Muks8tub
 ijPU8Wu8WIv/0uGplG5jAuYtZ58jmYC9NSrKd8EBlyVjAe3ohgtFWcsdD+foXefBJUBK30ctPtT8AjWSkwFKCgHN/2fuvQwov7xchQHZZm82ELMnGtzUihiD1+kM4DHHrj/OcJCXwt+gNEtjkWGpdsj1GzfhD/SQk153DZiSWMcykp14Zniq9bNf8Qc7twwgeMMNnk9MU74NwX8uRdmbq/z6Qy5jFh/eW/w8Wk/IniIaJK8zlqpQmPgbMdl5BjxwJ+nIwzDkiyRdQNT7c94VVwtzkMJskI4/DC5vXwhVRmKrLXb8kElmR//7SS/pHVxsWnOGwFBTeGZ6iqpVwPf8tAe17Is4TD7xLoyKx94+3coJJyxqPIPdB/Ye3udYwMFJhQSEGbtbJ/GKTtGFRBa9h19TVz73qjmaTYNaEGEyxW80auOL1eq+dyJ5LM2H+lFIud3K5+ykkhIdhwd+sX3/a6AUYL/AgELZ+2hORl2dCCfmQmq26qbrg/znqimFhiQyWBP1r5siRgvojS8IYfkPf6uD27cfQD43JhsrKLtlUDv4dVg4aArykjNxKGiQSqOIyISE6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 6255da28d4bb ("proc: protect ptrace_may_access() with
exec_update_lock (FD links)") the links in /proc/<pid>/map_files are
resolved with exec_update_lock of the task held. To find the file
map_files_get_link() looks up the vma and for that it waits for the mmap
lock of the mm.

So whoever reads such a link makes an exec of the task wait for the mmap
lock of its old mm although exec_mmap() doesn't take that lock anymore.
And everyone else who wants to look at the task queues up behind the
exec.

The lock is only needed for the access check and to get at the mm the
check was made for. So only do that with the lock held and look up the
vma afterwards.

The links don't go through call_proc_get_link() anymore so they don't
need ->proc_get_link().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/base.c | 68 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7685660c36241..b28bd6c57e1d8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2228,18 +2228,40 @@ static const struct dentry_operations tid_map_files_dentry_operations = {
 	.d_delete	= pid_delete_dentry,
 };
 
-static int map_files_get_link(struct dentry *dentry, struct path *path,
-			      struct task_struct *task)
+/* Check the access and pin the mm with exec_update_lock held. */
+static struct mm_struct *map_files_mm(struct inode *inode)
+{
+	struct task_struct *task __free(put_task) = NULL;
+	struct mm_struct *mm;
+	int err;
+
+	task = get_proc_task(inode);
+	if (!task)
+		return ERR_PTR(-ENOENT);
+
+	err = down_read_killable(&task->signal->exec_update_lock);
+	if (err)
+		return ERR_PTR(err);
+	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		mm = get_task_mm(task) ?: ERR_PTR(-ENOENT);
+	else
+		mm = ERR_PTR(-EACCES);
+	up_read(&task->signal->exec_update_lock);
+	return mm;
+}
+
+/* The vma lookup waits for the mmap lock so do it without exec_update_lock. */
+static int map_files_get_link(struct dentry *dentry, struct inode *inode,
+			      struct path *path)
 {
 	unsigned long vm_start, vm_end;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	int rc;
 
-	rc = -ENOENT;
-	mm = get_task_mm(task);
-	if (!mm)
-		goto out;
+	mm = map_files_mm(inode);
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
 
 	rc = dname_to_vma_addr(dentry, &vm_start, &vm_end);
 	if (rc)
@@ -2260,7 +2282,6 @@ static int map_files_get_link(struct dentry *dentry, struct path *path,
 
 out_mmput:
 	mmput(mm);
-out:
 	return rc;
 }
 
@@ -2280,17 +2301,36 @@ proc_map_files_get_link(struct dentry *dentry,
 			struct inode *inode,
 		        struct delayed_call *done)
 {
+	struct path path;
+	int error;
+
 	if (!checkpoint_restore_ns_capable(&init_user_ns))
 		return ERR_PTR(-EPERM);
 
-	return proc_pid_get_link(dentry, inode, done);
+	if (!dentry)
+		return ERR_PTR(-ECHILD);
+	error = map_files_get_link(dentry, inode, &path);
+	if (!error)
+		error = nd_jump_link(&path);
+	return ERR_PTR(error);
+}
+
+static int proc_map_files_readlink(struct dentry *dentry, char __user *buffer,
+				   int buflen)
+{
+	struct path path;
+	int error;
+
+	error = map_files_get_link(dentry, d_inode(dentry), &path);
+	if (!error) {
+		error = do_proc_readlink(&path, buffer, buflen);
+		path_put(&path);
+	}
+	return error;
 }
 
-/*
- * Identical to proc_pid_link_inode_operations except for get_link()
- */
 static const struct inode_operations proc_map_files_link_inode_operations = {
-	.readlink	= proc_pid_readlink,
+	.readlink	= proc_map_files_readlink,
 	.get_link	= proc_map_files_get_link,
 	.setattr	= proc_nochmod_setattr,
 };
@@ -2300,7 +2340,6 @@ proc_map_files_instantiate(struct dentry *dentry,
 			   struct task_struct *task, const void *ptr)
 {
 	fmode_t mode = (fmode_t)(unsigned long)ptr;
-	struct proc_inode *ei;
 	struct inode *inode;
 
 	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFLNK |
@@ -2309,9 +2348,6 @@ proc_map_files_instantiate(struct dentry *dentry,
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
-	ei = PROC_I(inode);
-	ei->op.proc_get_link = map_files_get_link;
-
 	inode->i_op = &proc_map_files_link_inode_operations;
 	inode->i_size = 64;
 

-- 
2.53.0


