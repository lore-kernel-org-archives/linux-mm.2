Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F92CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2844D8E0022; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899A68E001E; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F74D8E0020; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B89B08E0020
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A4DEC0410
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.24.336A9D8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id C005210000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g2lafgha;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=;
	b=fU5IR1NT4sWublP76Wul6xFVZL8WP1rNFtcnf6Qk4YLmYYPnKzs3Izmb5BhG21HyBbt0TU
	dfLT9CgDdOeLcNYFscxFrpmeL58Kup64MmKw3cO0GFNOZNADL8e/Z+mynIpHBAXFwCSoE7
	oGdVItXy+G6l/gk2F9frO3fxEVYPpHo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g2lafgha;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=1bp6U+WuArOw6r16k/zGH9OxaFqTDw/7BoCbjpKMX+G+NCYiB+LmemxkJ059eieX+g0aY+
	e5AQw+xsK1Eg+w6SkyP8W3PjCA2P40vgdXdFVqyi3BATwn4jw9D6j35grLm+VM0C6+oASN
	JS3fwk+uOs12+PLGTpIgo8EiFdekXMo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=; b=g2lafghaCCVmLEsConBp0VSpZg
	mJfJ2S/wp7Nbv4w2buvJBnBgTqCua6X7ylF3CfXi0T4T0daR0idA4DBlDAyLQIAEf7G4fNOYC4wTy
	L10ik7W03b9bGCrYrTDtS1vTkwldFZ7s5j7yxn70ErA3ZcDXl0x6GY7l+oTx2g9QW8kY+R6rTLezh
	ULP9lykfkRGL2NnH7CBoY3E9N+mOt3KMZj+hz01nr3vESNLxMp6JT36Hdd/Eq8jX9Z4/C+zw+4+qe
	1a7erWgM1OxejKpS1Qc4dutWuZ++LIFqyJ+q4w/vI2Bjw/7VXqDs+/jasLm+7QAj+ZCBtX6HCglnL
	c8tIm6Iw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHi-0000000Bwxf-3mGg;
	Tue, 11 Nov 2025 06:55:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 09/50] procfs: make /self and /thread_self dentries persistent
Date: Tue, 11 Nov 2025 06:54:38 +0000
Message-ID: <20251111065520.2847791-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C005210000F
X-Stat-Signature: 5zb7fsfprst1j7use1hxf7mp6s1n3uxr
X-Rspam-User: 
X-HE-Tag: 1762844130-716878
X-HE-Meta: U2FsdGVkX18rUQy0r761tMkpscs76vYhmZY1T4n5Sj6qDlpMbQJdL4shc0vgyvZgFKzBBCd2QDGJQxWZtc0GYTmOhrcfJMyEKU6YWg6uNyotkvJoq+Dw1xLIi3W07M8gvlnU8sfuMbKaWvCqMJS2MlqFBcI1mDbOUaNWoJ7KIajn0wW8CSorHYnv9Pdidy7pSdYgRM61+qIABwCcOJphtAGIEYyZcQgBOK28qo5uF90pf1ZWxlai0h7bhV9vVnpcnkT/nzV+dwO5/SBdFMLMLqE6H0TKhaAnJ1l2/j/+gwWd7m+zU8FK3HY5aLCYMlDS1yR2IeEpSKzkSbR202mj2JYvbe72soCzqz3Ne0Xs/22O6czbcfmMr3rwxMdxwunyWRr/Y6TFUJRZ9vYRr/TPxNI4F/gHyJ57OXw4MTYK2j3/1P8q45YHq3ib7/BBR8JkCaV9K/rUq06B2lcPVRfpHH0PGQrQsMzC4RIsjNYLrVlBlhQvzg2CCuIAPS972bjHGXYPn4rKYlISFaJxu5mpeyP//J6ksG90CykY1N8dq10esMDKBIm30ULnfgkka86nK9GVnxRbu7B4O7lU7WWxH/4Kwg1vWqKsy+HozQY/0CHSdnZ1VL8mBhuiSFgzl0Kqhi2Bza6aA0+O//f8b3iLsucTqiM1JewuoYD4bJkf2E0LAfIV+tWbnECvPVL7N+SQu8rZ9LUIl3MLb0fMuTRrOXh1gLlLpE3XvJeYCb7Kh+++Xj/fNYiOvnYfFf6XNdas5BNoAzMRz1QnD/jjVTum6t2zI9lv8OiEm4kcGa7XcRoj8Rn1MHseFqgD5m3V461q6gg1GdVDemOMhAxmUrdF9jGB04RiW1iCf4hUdz5M95g0YNafkD9nkPVWHWhpYO2d67rQSyZaEmvPKSMwEmYspUGk+ppDR5WGZO/1BQ4l4DKF19uMCxEP1sLcjVmYq9m/s7JOcD0bxkVMncfgXZe
 0BzoD2p6
 o/hrWKmjjoyjTAxAzdSPGJ4waWEGwwHEnQtntC9Knyqg0VKPXW/3hFRE++/x1e6aeguIcLOauE4IUktDHmtIKRacsoJj4CW/1++yQjVpcA22NXr+5BKrBQbJ6BT/BAn5Ex0QwKkJOq3rztNsNb9GoU+vDuBccOzJKX8OKdw9Jl15dxGFfqLGxXA0347Pm7J046QkVW+2j6LX4OGxwgbanVqpkwLuK+sqV23JRf0hLxMnPKubai3lKlIwuyjGrC1NmaIxaA69CBqwRhwPbGOkZQ6DijNQVUIEp3xzF1xMTq9gcTzDAWus3zv8sttOZuFi5qfuc2qo3Iov9W4CN2H1h8DYd89gAa/LzhZdUnYW5qE8AaSsNA9DFNV4SX5a+fW59AVDBnoBygB1sfTJACGuLW6DiiTsGxtUxdEiQ4bNeJ/1Hhd/yvcAECUgv1BFA2Oapj4mApnvuGzKQVkfXozviS1L3tTh0nRS48dUV5EgEVZoBXRNkHxVbG/0BkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... and there's no need to remember those pointers anywhere - ->kill_sb()
no longer needs to bother since kill_anon_super() will take care of
them anyway and proc_pid_readdir() only wants the inumbers, which
we had in a couple of static variables all along.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/proc/base.c          |  6 ++----
 fs/proc/internal.h      |  1 +
 fs/proc/root.c          | 14 ++++----------
 fs/proc/self.c          | 10 +++-------
 fs/proc/thread_self.c   | 11 +++--------
 include/linux/proc_fs.h |  2 --
 6 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6299878e3d97..869677a26332 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3585,14 +3585,12 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	if (pos == TGID_OFFSET - 2) {
-		struct inode *inode = d_inode(fs_info->proc_self);
-		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
+		if (!dir_emit(ctx, "self", 4, self_inum, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
 	if (pos == TGID_OFFSET - 1) {
-		struct inode *inode = d_inode(fs_info->proc_thread_self);
-		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
+		if (!dir_emit(ctx, "thread-self", 11, thread_self_inum, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d1598576506c..c1e8eb984da8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -373,6 +373,7 @@ static inline void proc_tty_init(void) {}
 extern struct proc_dir_entry proc_root;
 
 extern void proc_self_init(void);
+extern unsigned self_inum, thread_self_inum;
 
 /*
  * task_[no]mmu.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1e24e085c7d5..d8ca41d823e4 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -347,17 +347,11 @@ static void proc_kill_sb(struct super_block *sb)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(sb);
 
-	if (!fs_info) {
-		kill_anon_super(sb);
-		return;
-	}
-
-	dput(fs_info->proc_self);
-	dput(fs_info->proc_thread_self);
-
 	kill_anon_super(sb);
-	put_pid_ns(fs_info->pid_ns);
-	kfree_rcu(fs_info, rcu);
+	if (fs_info) {
+		put_pid_ns(fs_info->pid_ns);
+		kfree_rcu(fs_info, rcu);
+	}
 }
 
 static struct file_system_type proc_fs_type = {
diff --git a/fs/proc/self.c b/fs/proc/self.c
index b46fbfd22681..62d2c0cfe35c 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -31,12 +31,11 @@ static const struct inode_operations proc_self_inode_operations = {
 	.get_link	= proc_self_get_link,
 };
 
-static unsigned self_inum __ro_after_init;
+unsigned self_inum __ro_after_init;
 
 int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *self;
 	int ret = -ENOMEM;
 
@@ -51,18 +50,15 @@ int proc_setup_self(struct super_block *s)
 			inode->i_uid = GLOBAL_ROOT_UID;
 			inode->i_gid = GLOBAL_ROOT_GID;
 			inode->i_op = &proc_self_inode_operations;
-			d_add(self, inode);
+			d_make_persistent(self, inode);
 			ret = 0;
-		} else {
-			dput(self);
 		}
+		dput(self);
 	}
 	inode_unlock(root_inode);
 
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
-	else
-		fs_info->proc_self = self;
 
 	return ret;
 }
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index 0e5050d6ab64..d6113dbe58e0 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -31,12 +31,11 @@ static const struct inode_operations proc_thread_self_inode_operations = {
 	.get_link	= proc_thread_self_get_link,
 };
 
-static unsigned thread_self_inum __ro_after_init;
+unsigned thread_self_inum __ro_after_init;
 
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *thread_self;
 	int ret = -ENOMEM;
 
@@ -51,19 +50,15 @@ int proc_setup_thread_self(struct super_block *s)
 			inode->i_uid = GLOBAL_ROOT_UID;
 			inode->i_gid = GLOBAL_ROOT_GID;
 			inode->i_op = &proc_thread_self_inode_operations;
-			d_add(thread_self, inode);
+			d_make_persistent(thread_self, inode);
 			ret = 0;
-		} else {
-			dput(thread_self);
 		}
+		dput(thread_self);
 	}
 	inode_unlock(root_inode);
 
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/thread-self\n");
-	else
-		fs_info->proc_thread_self = thread_self;
-
 	return ret;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index f139377f4b31..19d1c5e5f335 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -66,8 +66,6 @@ enum proc_pidonly {
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
-	struct dentry *proc_self;        /* For /proc/self */
-	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
 	enum proc_hidepid hide_pid;
 	enum proc_pidonly pidonly;
-- 
2.47.3


