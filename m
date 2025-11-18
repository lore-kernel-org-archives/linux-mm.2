Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67FDCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F548E0009; Tue, 18 Nov 2025 03:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0248E0005; Tue, 18 Nov 2025 03:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10D98E0009; Tue, 18 Nov 2025 03:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD8708E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:01:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8325A14042D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:01:32 +0000 (UTC)
X-FDA: 84122983224.21.5AB0CEB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06E4BC0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:01:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t8IhweHC;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763452891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=;
	b=U12l/b6DabbMCZG6DeEwXzRMLimf271ubnmK1ccYxctIHNb+sKyxCihcJg1hihHz0F6BXm
	gpKqq7eQ872bh2qUVOM08GW9ln37L7gUBtwDj1iR2MqoJ/ftddHGaTxU28MI0tJE21qwZG
	xV2j+gjxgVuREj71ApuivECKU2nthHw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t8IhweHC;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763452891; a=rsa-sha256;
	cv=none;
	b=M0eSqCoxu0a/YvuzA+9O9yyYriUksBumu/tUJFaDd8N60z2lXH4aYx0CDcGUtdVZMYyeiT
	vT+AJ0Fjo9o+1RFCQVNBGfk73ixtit8vjtxKrA5gG0JCw7kq6WG+9kmwVWwBk469L5ncT/
	8Pndst31rAQmaJksc4jRjmJsl39d+3Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=; b=t8IhweHCZayCrtoMH6hKG7nYOY
	rHBNKVDd06sHgRmP6BTXPMUFW/MEBSd66hkUDujyKcEmrs8519vyx1SKzFvmLHKUs5n+1yAqvDAZq
	2y/5YCGqWuYeqiXlJEHp46FljywwVPDk4UXo75XopbDhelcuGxf0Hwa1whhfJl16iwcUeR2P80z1F
	DahMfgts2UwV9svUrZxpr0d8LLhA7uVi2bO8u4w0wN7/2/zqqKJhthpKassAGtsHa9fPqSOPQgSMd
	qKyW43Y2ODog4CdXuNVdOrXY4mnSc7dB+q4n5/FdZ7wVgBoU+pw09sUeWo7IEoRtxidG78Bnanep+
	Ke8kz4BQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GEQT-0YNZ;
	Tue, 18 Nov 2025 05:16:06 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 09/54] procfs: make /self and /thread_self dentries persistent
Date: Tue, 18 Nov 2025 05:15:18 +0000
Message-ID: <20251118051604.3868588-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06E4BC0011
X-Stat-Signature: qpni1euwwisxyz4ub5t6jt6gkh7w9ug3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763452890-78203
X-HE-Meta: U2FsdGVkX1/SHYeDmI98Tjj0hIYna+raGLd/GWRBILSvOEQq7l3X3NBUpiri6oqGF3jlcvro4yz5w/7AbnJs1PBf0W8A9FrMZInStjE4nWnxEl9YNQb4eevFy1LeBjrvrXfDbY442syPYKA/0O1gyj97E3d6b3zTPlUy9KL9jkzI9EFTuj3VRXOfPLvXQoleaVJoRbCm4IKY3tMV8aJ2ywM6ZHqjkLGFfZuzgWJeUd95n/BNHICtLcKu24ki4+uMDVb0L5PjymUJvhK8DcNF1Nfx27GPSBEpqmIuFNpvyEonM/hjuFl3uKfKBTdcO6GtlRLu90iMVYZYj6leh+pVicG3ar5Xy03L22we1r9HisR5+HwrAT+gvEqp3rT0ZEqi/nb23ISwFtXcXzr9e17UqFHF2+4DYQEkwAfrCn7MMyt2orgsfymZEnmMCXzBXSNFjMPuYUFXb2xaDdMhQNSPvdpP09zn9n4WWSsDyiZ0dk8jHjDwVJriMxSytgg+TDbhAWDYNpGuvdYPTlOBaOZbHShSQu9My5TCs5S1Tc9s0WgKeCbpzBgEYW10XDRhLHqsTmAl/oCgIB88kWqhev8SVYzymXQ1HN2LUYgDE3rQqrEO2uWfy/Bvw3cdoYpVVNBpWNsJEIZYla+jHh+ti94JXUERd+pVgctFpc5G2iI5QVPtX/EzKzwD70X7Buyye+Pi7ERR0r94sT99Kzg5FRmraWs7infFlZuwoGmTVRRiwSiJV0xYXVJbWjMx5hV4phEzdGfx8D/IRI11pkfiyQ48mjM0/PXUG7OVQHL+KZxkrMVHPO1JdjntF8crTOJwMXmHMe13Fz4IuS2g4/6KjIOWa91hjcWs/2NRVsV9Z6WaE8XA5qzXauQApLO/MtiwiVYs9YG+5GoOWgpUqPVhHjMksASSiXrULLcR2rfrMqybjn22p2Qi72638/OAlyZpPcOP9vxLSS2K3OBcRxBAh0H
 GkKXLLeb
 hb0u22L34cd72Km8mjuybLc2ohMUFqCUZsDwxLYC8mI+bWD2OeWnt6w+K0Gmzeb7WMMyj/QhutyutRfUf0DbQOjA8CLzIXKil76HN1fvclrxgShKBteY0QJIa9karPHuZ4ove4wB/kQogwAIn9ohsWyYG0Vg2cFMN3ySWb3ghLjbRr2F5azJ0v7AWqIH8A64hnbc0
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


