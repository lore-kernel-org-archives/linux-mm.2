Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1B5CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E979A8E0002; Sat, 20 Sep 2025 05:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E9B8E0001; Sat, 20 Sep 2025 05:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E0B8E0002; Sat, 20 Sep 2025 05:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDBBE8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:51:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67119C08F5
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:51:40 +0000 (UTC)
X-FDA: 83909161560.22.5F43388
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B796100003
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:51:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HiVW9csO;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758361898;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n+u5mJZbkVOGppwaF2sYBKKadIdALuqoKRX4rc7ffY=;
	b=JrWnxBBd8QsbSw8UxlXuuUmCyQlNTBMt+NWy3HVUML3wo3/MZEWG0rGdKJPNxlEfVVz0iq
	crF+WtqKH6VO0XvHgJIZpde7mkJ2gkvs6Q80noo8CDIYLPfhSelnVBYG6IA7R/4ARmBJyu
	O032iAPfwlGnY506PN4Rxa5hIpkDSuQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HiVW9csO;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758361898; a=rsa-sha256;
	cv=none;
	b=nQth/ayDoPyi5lx7zKN/1ZIMxWgdVZ55tbXIQ56MELQkEZ1N6RgIPXU2dob7NZ0fm3hnB1
	58l3QTwVGN7ZNO0H99ZIixXNfmB3oiLkDhuUKUt3ddVwzsx3k02DCuBL1B98QYTeBXU4Rl
	J4j/kv3KwZZ/N5eRSWhYhlokiIlcsHY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9n+u5mJZbkVOGppwaF2sYBKKadIdALuqoKRX4rc7ffY=; b=HiVW9csO5wBPzyUh4wvbC9GIYx
	YKGxOZnoP/Io27DxYX02JMpe8G4cANuBi3Itop3hCVYnYYAyZfVDGg/w4XSPPYbWB33ufeiJgLjBb
	HwXVmW32L3G0HSw9MordfN1F40Sj/1uLKukoUKkmbjskzbyYATwtnL1flJn2oqPpN1FqXFwY2H2XE
	R1OGCigYvOp7JKEm01oeADrVHA8pywFCJSeGriFVKr19RZxCb9KGZHnddfbIe1ER76Fn51NqNFHJ3
	qP6r1xoo1e7B7+cUg5lnU2Dkg4d6pU/ydQ0ARm3LSeYrti+KOoTXA8P81RPltMNGl8j9qkV6NWEBM
	sDJDZa5w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKC-0000000ExGF-12mR;
	Sat, 20 Sep 2025 07:48:04 +0000
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
Subject: [PATCH 24/39] convert devpts
Date: Sat, 20 Sep 2025 08:47:43 +0100
Message-ID: <20250920074759.3564072-24-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B796100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h3rob9jc8szq7hghbkm9o8yfba1kib9u
X-HE-Tag: 1758361898-907828
X-HE-Meta: U2FsdGVkX1+E7blQO6Cu+hfyiRQZ6ZXeaKl5F8YmmR6oSyFenbHnTjIVRkoyJW/AyrgiNc/oaZAKLj/6iQOKd0yMU7bApn5IkWP9qd44MXI7tZKV5YpTHJL0eQiT3AyyMDYBluooUGO2Mbxl7cOu1dMVO7/+5tHltitmuw2k8AQP5xXXIv7U28MGciV4r7XtSpZbY9C5KhFhiN6EnFgrvBztvFMGY9Kajs389bHYNm2K/nZzkSb8Y0SDCNlNo4bKUg5PPfbHCbXVD5s3lqwgzv159a1h+DqiU14zJpsWn2qbzQXzDvhWqv0P1epqUdAmajsZCh6J78GK9SXhjpcZLPGbA/GmAhU5sX8G+su9IIZDZgcnnJ/fw+PtsMsdUCMCuwvX7r4o+tKVmRGoAvuQbeS1GGF3foDqrRzr+yfAtTjZmTpzs2/nTMAiHyOaSk7L57Av5gjCsdgfcL8SBk8LPZLF0+CK/MFQmC5MW/nw1nb32TOsxGEIwSgbfKqE2BjQUzFU0Skjjqn9XWLL70diJcps+fXpxm+wNVLc+A9M0avxRwJNztv7gwustbzg4Ssg2XrZLL960bYmCnk2aM277ysp6WZctv83ufWM8mkxnWto7bqisVQBs9/mEm3cH3vl8/KIvEiF31vA54/yvXo3GoF9LSd+4x2QDRoopCj6fmo3fMUW8MeiRc8nZUlL+qO5kGZppZFPMZc8jVynVCHVc/81c3GtJOMKDTGvq9kC2mdGa8AEp3I9cxelUu1zi50b54odZPz1DdcPRrmLdSYLhwcMCsKF4S2izIZi3W6/H7n7KJoqGQMIs0ycOo6AsmNVX711jE4z/txpJsjv6++kjyL99sIObSocWfaEe+7eBko65bGJQGI262Q9X80AD2QpugF++oxNEj6IoHtUFG5P4ut4EsjFGn+icyGqKvALCMq1HoGdjHD4dH+1B7mYpRfWytmLn0qqVZgqsEwovnw
 WC3WHtte
 JR2eTXBfldiHZbLbmFbez0dpGXwBhn/5ApLir4kQr4u5ncw6ggqKI4SrqlDUzWIDhp/bVlIuPOsFTmMdjSn6igKEtGzz4rgt0aVxTyPG+ZkE/x4uDD6AcLJ1SVg2r9L7zQ607Rw7g5+RAYHPM1i8Rv4jSfpJl8n7+mSNRjMPloKB1Ne3hFnOm5rmA84PzCK7ij/BzBboiz7e2Z8g4tRZsHMws+5KelQaqVRNwMeGF+KVRuxcITiJuAm/96BQDGathZf4l07KAT4mbk3mVSQmH0zkoWztv3kq+eTFsaMwR2PmXUIxDw/WLfKOibBvW0uhpYrpJ8oQTtHvPtw7NQzjZcIVIAq+s4aM5muCb2yAwea4ZDi37BcP2W+1Ou0qZf9GbLiOL8Gb6o2XqRPWVVtUUo20PSTbhDReUhKDez1i663f198W1xa6cu+IrOjuthtiZoE1cKntLHua2PDo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two kinds of objects there - ptmx and everything else (pty).  The former is
created on mount and kept until the fs shutdown; the latter get created
and removed by tty layer (the references are borrowed into tty->driver_data).
The reference to ptmx dentry is also kept, but we only ever use it to
find ptmx inode on remount.

* turn d_add() into d_make_persistent() + dput()  both in mknod_ptmx() and
in devpts_pty_new().

* turn dput() to d_make_discardable() in devpts_pty_kill().

* switch mknod_ptmx() to simple_{start,done}_creating().

* instead of storing a reference to ptmx dentry pts_fs_info, store a reference
to its inode, seeing that this is what we use it for.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/devpts/inode.c | 57 +++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index fdf22264a8e9..9f3de528c358 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -102,7 +102,7 @@ struct pts_fs_info {
 	struct ida allocated_ptys;
 	struct pts_mount_opts mount_opts;
 	struct super_block *sb;
-	struct dentry *ptmx_dentry;
+	struct inode *ptmx_inode; // borrowed
 };
 
 static inline struct pts_fs_info *DEVPTS_SB(struct super_block *sb)
@@ -259,7 +259,6 @@ static int devpts_parse_param(struct fs_context *fc, struct fs_parameter *param)
 static int mknod_ptmx(struct super_block *sb, struct fs_context *fc)
 {
 	int mode;
-	int rc = -ENOMEM;
 	struct dentry *dentry;
 	struct inode *inode;
 	struct dentry *root = sb->s_root;
@@ -268,18 +267,10 @@ static int mknod_ptmx(struct super_block *sb, struct fs_context *fc)
 	kuid_t ptmx_uid = current_fsuid();
 	kgid_t ptmx_gid = current_fsgid();
 
-	inode_lock(d_inode(root));
-
-	/* If we have already created ptmx node, return */
-	if (fsi->ptmx_dentry) {
-		rc = 0;
-		goto out;
-	}
-
-	dentry = d_alloc_name(root, "ptmx");
-	if (!dentry) {
+	dentry = simple_start_creating(root, "ptmx");
+	if (IS_ERR(dentry)) {
 		pr_err("Unable to alloc dentry for ptmx node\n");
-		goto out;
+		return PTR_ERR(dentry);
 	}
 
 	/*
@@ -287,9 +278,9 @@ static int mknod_ptmx(struct super_block *sb, struct fs_context *fc)
 	 */
 	inode = new_inode(sb);
 	if (!inode) {
+		simple_done_creating(dentry);
 		pr_err("Unable to alloc inode for ptmx node\n");
-		dput(dentry);
-		goto out;
+		return -ENOMEM;
 	}
 
 	inode->i_ino = 2;
@@ -299,23 +290,18 @@ static int mknod_ptmx(struct super_block *sb, struct fs_context *fc)
 	init_special_inode(inode, mode, MKDEV(TTYAUX_MAJOR, 2));
 	inode->i_uid = ptmx_uid;
 	inode->i_gid = ptmx_gid;
+	fsi->ptmx_inode = inode;
 
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 
-	fsi->ptmx_dentry = dentry;
-	rc = 0;
-out:
-	inode_unlock(d_inode(root));
-	return rc;
+	simple_done_creating(dentry);
+
+	return 0;
 }
 
 static void update_ptmx_mode(struct pts_fs_info *fsi)
 {
-	struct inode *inode;
-	if (fsi->ptmx_dentry) {
-		inode = d_inode(fsi->ptmx_dentry);
-		inode->i_mode = S_IFCHR|fsi->mount_opts.ptmxmode;
-	}
+	fsi->ptmx_inode->i_mode = S_IFCHR|fsi->mount_opts.ptmxmode;
 }
 
 static int devpts_reconfigure(struct fs_context *fc)
@@ -461,7 +447,7 @@ static void devpts_kill_sb(struct super_block *sb)
 	if (fsi)
 		ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type devpts_fs_type = {
@@ -534,16 +520,15 @@ struct dentry *devpts_pty_new(struct pts_fs_info *fsi, int index, void *priv)
 	sprintf(s, "%d", index);
 
 	dentry = d_alloc_name(root, s);
-	if (dentry) {
-		dentry->d_fsdata = priv;
-		d_add(dentry, inode);
-		fsnotify_create(d_inode(root), dentry);
-	} else {
+	if (!dentry) {
 		iput(inode);
-		dentry = ERR_PTR(-ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	}
-
-	return dentry;
+	dentry->d_fsdata = priv;
+	d_make_persistent(dentry, inode);
+	fsnotify_create(d_inode(root), dentry);
+	dput(dentry);
+	return dentry; // borrowed
 }
 
 /**
@@ -573,7 +558,7 @@ void devpts_pty_kill(struct dentry *dentry)
 	drop_nlink(dentry->d_inode);
 	d_drop(dentry);
 	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
-	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
+	d_make_discardable(dentry);
 }
 
 static int __init init_devpts_fs(void)
-- 
2.47.3


