Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C609CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E9E8E000C; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5DB8E0007; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A9C8E0015; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 059EF8E0006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 999011A0907
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.27.F733474
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 03325C0004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=AQsoIyYj;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAHSdKFZnF4Zow5YQA+xZ1lkb5Ydb+4Xwjcy3wk/6d4=;
	b=Fjm/HQYeeWBT6Z0df8HB2T/wzLi645X4qrbfMXNGgm3IdP2oWua3ZKsjbgyfSUWG5hoYuN
	vIl1hCjgrzFujMIzRMGLhx8cSe+2sjoyqfHYJM1v+dVS2v9f7CR/08DJTcWnNdgKGhBirI
	OZwGC6pm1x16Hxyya6B7rwJukrB5r2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=0PnKBwPOp0AAiCUBHgkbrkBJuwjLHulwuYKthMWxx87CIfhioQJKgS5xPFv2s3gaiQP69d
	DuScEb0E2ijuZH+FTMzQhjkGVfyEpBcWuqTC3tj8/5ifIrLv7ulgGd3kTUtPFkyKOhjnyu
	FlA9j6Zf5+WVdD3xtT6PJ0ssx5vPPeg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=AQsoIyYj;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PAHSdKFZnF4Zow5YQA+xZ1lkb5Ydb+4Xwjcy3wk/6d4=; b=AQsoIyYjFl5JWsVoWRzNaCVStQ
	vfys2KyjQRZsc+oeGdfzgBSJpg3xWyZFHINqZvwJAziA91IMOtKItmxc1KDPkt0i6g5b13GWHHUNa
	PzZSQvGOVcmh4oE0GnFRnGbTL4GLrUs7T9THfqQjcHZpIFMadfIPbv0iuRdZ1Fs8l+vyrryvzxWcC
	SPERbfKp6XLxjdyiPMwaIYZ+9NAglN6uRStI02sMIHWP7wV7hX8fG7bJdjsfFwzHeq9GQzM4bJGc8
	++/1XTR87dLoJozQkKIvWstA1ZlBoZ3R5HKA7oNIhRLMhFnYU9j15bZPzbCbDEW7pap4SPWsVpifV
	rFnv3rvQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExCP-3wgx;
	Sat, 20 Sep 2025 07:48:00 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 07/39] procfs: make /self and /thread_self dentries persistent
Date: Sat, 20 Sep 2025 08:47:26 +0100
Message-ID: <20250920074759.3564072-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03325C0004
X-Stat-Signature: fngqp37g1gzmhbff444be6oq4edpnhtb
X-Rspam-User: 
X-HE-Tag: 1758354485-93880
X-HE-Meta: U2FsdGVkX1+MTpdTPKy8gkvTX0qmolVGvsQVqEndnIfVXJJS0hUZ/TspDB2tDRuKOzkTblXHbodiop+hPatOM1mxCxS6AwjbcfisGugxNZGcTKnslCQXocJ/aT1tC8vh2cUX1IprczS3R5UEzmWiNXnA8lwsnO99ow1/WWnEm+XkjptuG5/HGZuWNJTOaLJCD3U9i74vEDles0dTv8D9jTXH69e7K8WlykzgAK0mypVKlTWJoTmaGRiRHzJ/DFok8OIcFVOA+kfywx+KwRm9pTwh0nD3xQXtfRG2c5RYnxfSPwweea31vdDb2+7kl35TYzxVxSnnreJBWUxCWHWqt6p3IMyPVwtMZgzcDOMAXGQG5vnPSKoPaYxlvD0prNgV22lnUqS0/aq2jP/XxQVKK1kYkgDFW4ekT0qXRrL3+jS2ZXHx7qGRz010iZWJF6iT17dg0i1qNc3CGtM6CxCZUe1NNMiVK80DqaudQrpQRagBjghGZlwbOx3NjzmzlX+IbwJAc2c7c7V1iFrVXU48RDPts8LBHTlR7Th1nEWR8JcgiV99PZIsk8i/w0i5PIEHUvKapfJY5x0uAV3rqOAr0mD3D9PDsAwP8Sv4n5w8ExVNyVwPcPc0xVQPaR8Eq82JhS/qwweGMnaNbg1ISK4Uisg/EXpHOCF1HqG0+PLd/2Vmo3RP/3S1pxkvdGsPJQSsAFoxQiLXHQ+HonGxIpaq18n3tWbYT9Fva26/WauOeB6+KOP7AcmfkCU7o1oj94jn3Ur1J7KJn3lTSx2TADfnQZV4lsfLRPiKg7IhWLyoGgFpJxyOzAjq66kLm6po980NUr6CwZ3CXHT82beF2QCMWL52hJAAOPIE78z21Xbf9iCPEJYFahuBdK6Ir5kr/h+8z658sd8l0oEpZ0b1TPjKQle1orDbnWh1qswx5AKGSzyg8+0ibJS6G/sxfj+76a234tewcIowJo/UCZToUzY
 G1jIV0yY
 2RcYeUDDGA/Mib19VZV93Odrr07grwV/5ftMBzadgUBSmtmoLoMzsOhf4xxq4TsRS9CWRtVRuphzvEoMQIbEzpEJh1C0Eoo3tMiTX2juzHgThSRM8cnlR7CD91GB6IIds6i3wlKE5wVxpi5wUS0MJLioy6YK66HBOwPGgKXhEIqnM//KnRk3BTZxShomkwDheneyRBhheBEYg2fjAueIiuWAUKSG01m0UMH+wjmY5ymazm36SHZBDmaA0qAk24Lta4V4TaoIV+mfawUA6nWkHLC/qgz1Ko8D2JwhPiJS3ilLaf8KEF85dA4/k8jY+wbQLqvR5FLG2MIZISq6nGXrBqNEr2rrkhHhSTDKX4znu50DQnYLRIWAiD1gB1QOvXm/jrX4eEFiK67EaY0sNtm9cXhTiJuHhcYVYQst4f8pqKRY4p83z9kNQSk/aq5LB8AMF3jULLy8OCSEDD839pSenwhi3tjC1Wgn0RkoKiOXjCgTrVF4Icjjw1k94pg==
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
index 62d35631ba8c..f5071b0bdb1b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3583,14 +3583,12 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
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
index e737401d7383..e165e406c14d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -373,6 +373,7 @@ static inline void proc_tty_init(void) {}
 extern struct proc_dir_entry proc_root;
 
 extern void proc_self_init(void);
+extern unsigned self_inum, thread_self_inum;
 
 /*
  * task_[no]mmu.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index ed86ac710384..7cedc08b92d3 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -261,17 +261,11 @@ static void proc_kill_sb(struct super_block *sb)
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


