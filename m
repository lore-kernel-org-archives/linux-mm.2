Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D50C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BC76B00EA; Thu, 16 Jul 2026 10:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E427A6B00ED; Thu, 16 Jul 2026 10:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9146B00EE; Thu, 16 Jul 2026 10:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 927456B00EA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5E7A1601C9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:37:03 +0000 (UTC)
X-FDA: 84994891926.26.097D683
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19E5720006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:37:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=eJeO+eF4;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf13.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tx3RL7Dpcom2Gtiv6HpK7TldWXCZEPMErda2T+l8Rw=;
	b=bS0zDedB8bi4YsHB3ekIEJhMxt754BPEEq/iKwIEqKCXVC9qWs+a4uzTlStkEujQxahi8v
	Z6djXpwj0H8WGp6gvbcRsCbPOV3AkoZRAPdaN3OVw2IwuaE70xs48GJaqne9/YY0cVAZjZ
	+FijUtQf8KDqLqO/PBkUlCFy+dccov4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=eJeO+eF4;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf13.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212622;
	b=meU5C+5WV61jP06clVoxKbNSpue/3cAz6ZVJZCZ78Qxo2DsucR4OOrhJX7303u6D4TPARz
	iOzvmRZOnlTpuqlPiAghGkTgTpVzunEo2WDwmA9+k/lh4/Msul4NY9YgHz1i14aSipy1uU
	VLWp+4B9YXd42GEwfgO/+PJOPIkaCY8=
ARC-Seal: i=1; a=rsa-sha256; t=1784212413; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j7mSAosRI9wV7TUnNqWq1BzuAf5bXMD6hPBcH2myQKWjCPo30Vc4xJIweaKlhr8i/kRxzr/hkm4I0KRL8zPeSZfTsLk3TRLzehqDyfQtTqPzPs3lXLHaCCbZ6THloKb+Kz8OXRSR4TFar0F+P8iGcdOpdv8ZDfVBlqrx0e8xs2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212413; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6tx3RL7Dpcom2Gtiv6HpK7TldWXCZEPMErda2T+l8Rw=; 
	b=D8RC/Zs/WkdAf3m91cI24PmxOBAKoOEdkM87hMycfQ0ckwq0LLAmp1WKiXniZ9YxBXv8I/1olWoS/FxDTg16OhZExFLGrG28RiDxnqgpoSaTb3jrz7IxtriocYGwhxJ8ZRU/M25BqD7nCWY4xVZtIMtiVbq42SnvAa9uJHEJScM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212413;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6tx3RL7Dpcom2Gtiv6HpK7TldWXCZEPMErda2T+l8Rw=;
	b=eJeO+eF4JoGGJJXCrB9CubM79/Z2MgT9xXlK9WvBTMUbK0M6i0+8FEfFE6jj3hFD
	hUc5sXT1jqrNDmZ0MeYXJw6Ay7rjNNzUThNhUE3Am92zK+dGTVQYSjv3rg2DDIm1o4Q
	6o1y37rGO/MwgKOzwSVjVZioiAqMQt1ZECsUcK2Q=
Received: by mx.zohomail.com with SMTPS id 1784212410836431.9517470736415;
	Thu, 16 Jul 2026 07:33:30 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 08/24] pidfs: attach pids to future pidfd files
Date: Thu, 16 Jul 2026 22:31:34 +0800
Message-ID: <0f824d157ae7d9767badfa2294f195fc71329324.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19E5720006
X-Stat-Signature: ksqai7hwe9k6b3x7p9sax6i5piru7gyb
X-Rspam-User: 
X-HE-Tag: 1784212621-469022
X-HE-Meta: U2FsdGVkX18mcGDx1vxC50IniMPDk5oOEDpSN4fbsTt1WFIjIilkSF0YUIBis4EnQDyhnL4zjxA3Tr5FfXtmYJuS6wloxQkAdAo02NrI6X9OY78kgLqY5Zkn3vd0IhqMd1UC8JRAuoaPWZMfj42emTioTKkHDy6jBxRnRQhZDiS9c3wEFkuve7B2VxbJN71bC1ZjVS/IGWvd/Gf9I9MVmT4w3EnaGr+4OLoWlmT01rck9r2nG5SJ6UxcT+uwS18IBvM9HEaa1ucqOUeGmPx36pPIwknFaSl8RmmQZiDllse0+eAgSyjC9Tr7nI8p9jx4N/Ptr/EJkWleleBq6xLILUZUx9wVl/lwhAyuXS2GFmExxCYwJx8AyPtHLS5I/Cot0psnzpSZ8H/vHW/8kOjd5eTKVbCOQXe8VXGDENBYnLLqxhbL4rXG4AKnCv8Ac78CTTwbyoQaknPXUIuNsO81ludAib32Ek2rk8vgOU46nAWr8WM0+TiwQ7mb7+euzhV3jGVEVA+T2IZChXs+KWoKICndCNcQn+6/UaQPyMmFGRmocW3f9IlAtRwWahNeExBqU6SHg8yxZeTY9wZzUALsM3txupXsbpLJH+bo4UXKyMJij/jXlYLqjPNMP5ytEHlIFtxFeoosqqbh0lueyGv+psHOb2v5L+HZJ1azMMt9HxwIlj0fP8cA9jOauoEbPDMcL28so4niBczaJPbmeDmPDGA+ofLTuLy1vBfJMiWv/i3sNiGc6VEXK1naUunr5/qOgIjjdLcgaq0upH1UenpDtcJaFG6WdJOcdOVahbl2xkGHPJShsiOuo4x26r1H1yYBSXwjmJjh1FJ5izyLisQEkV2bdIvaz+F+Oe0otZgwgRi5NYcu1WpjpfkvB6YSvr8ZwLzsEnEnbVHFoA/HEBv8O/C4Ye+jD1O1mG9052AtQ9HTVCbHuyqwxkrE3dmrIWiQNuVcqLLuBbxSQKQgnK1
 OhJ50BYb
 laGYra/Gze1I7TZnn7Rmh6sha6GOznS1JVy5RkmdH/O2sGcc3+poePWbLqj7wISktWySwMnpqZuE1012nmVFL1kRd1v2QZeIasS6CTI3zECX14aGzdt5jQJm3VL95Vwm8EAdfqrq7IaFCfXFlQXpEVHKF1SScFkRKNc6rN8LMp98j6TRCUZI11y2Uk7O8/A2gc4pprWDwAJA3ILeb1ZqmuUWxSNz31lwnLDm7oEVXPsmwWDrM1VsVTe07BF/RkOcQfwSFSb4rfCFOz2wY6nOefG5f/B55I9heTyWtXFwLRdUioK1PfYOlIax8yWIoxcewE2XFWuK2ws1oKKMVGv3N1Dk+ZEH6PwvMy/vv2EKrw3pbqprKJIJpHLHcWnx+j5ky0Eg2dAVV798hD0Ju0Spv5pBzA7ZXJvmNuMYuNWNxyt59xu6fLUB/CNQWXFecWNtcV413
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Associate a future pidfs inode with a preallocated struct pid and reuse
the future dentry as the canonical stashed dentry. Preserve the
reserved inode identity when the pid is registered.

Keep attachment reversible until a task owns the pid so copy_process()
failure can return the future file to its taskless state. File-handle
lookup requires both the stash and an attached task before accepting an
unpublished pid, preventing failed allocations from being reopened
through stale state.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfs.c            | 89 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/pidfs.h |  2 +
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 28464fe274c9e..36ee4f210f73f 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -115,6 +115,7 @@ struct pidfs_future_file {
 	void *data;
 	const struct pidfs_future_file_ops *ops;
 	struct pidfs_attr *attr;
+	struct pid *pid;
 	u64 ino;
 };
 
@@ -238,7 +239,8 @@ int pidfs_add_pid(struct pid *pid)
 {
 	int ret;
 
-	pid->ino = pidfs_alloc_ino();
+	if (!pid->ino)
+		pid->ino = pidfs_alloc_ino();
 	ret = rhashtable_insert_fast(&pidfs_ino_ht, &pid->pidfs_hash,
 				     pidfs_ino_ht_params);
 	if (unlikely(ret))
@@ -987,9 +989,18 @@ static struct pid *pidfs_ino_get_pid(u64 ino)
 	if (!pid)
 		return NULL;
 	attr = READ_ONCE(pid->attr);
-	if (IS_ERR_OR_NULL(attr))
+	if (IS_ERR(attr))
+		return NULL;
+	/*
+	 * A task can become visible before its future pidfd is published. Let
+	 * ->open() wait across that window, but never expose a dentry for a
+	 * caller-supplied pid when copy_process() has failed. That failure path
+	 * clears the stash before freeing the pid allocation.
+	 */
+	if (!attr && (!READ_ONCE(pid->stashed) ||
+		      !pid_has_task(pid, PIDTYPE_PID)))
 		return NULL;
-	if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
+	if (attr && test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
 		return NULL;
 	/* Within our pid namespace hierarchy? */
 	if (pid_vnr(pid) == 0)
@@ -1025,7 +1036,8 @@ static struct dentry *pidfs_fh_to_dentry(struct super_block *sb,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	VFS_WARN_ON_ONCE(!pid->attr);
+	VFS_WARN_ON_ONCE(!pid->attr &&
+			 !pidfs_future_file(d_inode(path.dentry)));
 
 	mntput(path.mnt);
 	return path.dentry;
@@ -1103,6 +1115,10 @@ static int pidfs_init_inode(struct inode *inode, void *data)
 static bool pidfs_inode_data_matches(const struct inode *inode,
 				     const void *data)
 {
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+
+	if (future)
+		return READ_ONCE(future->pid) == data;
 	return pidfs_inode_pid(inode) == data;
 }
 
@@ -1266,6 +1282,10 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
 				PIDFD_AUTOKILL) != 5);
 	BUILD_BUG_ON(PIDFD_EMPTY & VALID_OPEN_FLAGS);
 
+	ret = pidfs_register_pid(pid);
+	if (ret)
+		return ERR_PTR(ret);
+
 	ret = path_from_stashed(&pid->stashed, pidfs_mnt, get_pid(pid), &path);
 	if (ret < 0)
 		return ERR_PTR(ret);
@@ -1369,6 +1389,67 @@ u64 pidfs_future_file_ino(const struct file *file)
 	return future ? future->ino : 0;
 }
 
+/**
+ * pidfs_future_file_set_pid - associate a preallocated pid with a future file
+ * @file: future pidfs file
+ * @pid: preallocated pid whose pidfs inode number matches @file
+ *
+ * This stashes the future dentry in @pid before copy_process() publishes the
+ * task. No pid reference is transferred. On a later creation failure the
+ * producer must call pidfs_future_file_clear_pid() before freeing @pid.
+ *
+ * Return: Zero on success or a negative error code.
+ */
+int pidfs_future_file_set_pid(struct file *file, struct pid *pid)
+{
+	struct inode *inode = file_inode(file);
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *stashed;
+
+	if (!future || !future->ops->get_pid || future->pid ||
+	    pid->ino != future->ino)
+		return -EBADF;
+
+	WRITE_ONCE(future->pid, pid);
+	dentry->d_fsdata = &pid->stashed;
+	stashed = stash_dentry(&pid->stashed, dentry);
+	if (stashed != dentry) {
+		dput(stashed);
+		pidfs_future_file_clear_pid(file, pid);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+/**
+ * pidfs_future_file_clear_pid - undo an unpublished future-pid association
+ * @file: future pidfs file
+ * @pid: pid previously associated with @file
+ *
+ * This may be called only after pidfs_future_file_set_pid() and before
+ * pidfs_future_file_publish_pid(). It removes the stashed dentry so the
+ * producer can free @pid after a task-creation failure.
+ *
+ * The producer must clear the association before attaching @pid to a task.
+ * File-handle lookup treats an attached pid as a publication-in-progress
+ * guarantee, so clearing the association later would violate that contract.
+ */
+void pidfs_future_file_clear_pid(struct file *file, struct pid *pid)
+{
+	struct inode *inode = file_inode(file);
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+	struct dentry *dentry = file->f_path.dentry;
+
+	if (WARN_ON_ONCE(!future || READ_ONCE(future->pid) != pid))
+		return;
+
+	WARN_ON_ONCE(cmpxchg(&pid->stashed, dentry, NULL) != dentry);
+	dentry->d_fsdata = NULL;
+	WARN_ON_ONCE(pid->attr);
+	WRITE_ONCE(future->pid, NULL);
+}
+
 void __init pidfs_init(void)
 {
 	if (rhashtable_init(&pidfs_ino_ht, &pidfs_ino_ht_params))
diff --git a/include/linux/pidfs.h b/include/linux/pidfs.h
index 6b7fbc54ab388..828e96f769ba1 100644
--- a/include/linux/pidfs.h
+++ b/include/linux/pidfs.h
@@ -28,6 +28,8 @@ struct file *pidfs_alloc_future_file(const char *name, void *data,
 void *pidfs_future_file_data(const struct file *file,
 			     const struct pidfs_future_file_ops *ops);
 u64 pidfs_future_file_ino(const struct file *file);
+int pidfs_future_file_set_pid(struct file *file, struct pid *pid);
+void pidfs_future_file_clear_pid(struct file *file, struct pid *pid);
 void __init pidfs_init(void);
 void pidfs_prepare_pid(struct pid *pid);
 int pidfs_add_pid(struct pid *pid);
-- 
2.52.0


