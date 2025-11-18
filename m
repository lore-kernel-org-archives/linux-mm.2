Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD72CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732A38E0010; Tue, 18 Nov 2025 02:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709468E0005; Tue, 18 Nov 2025 02:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6463C8E0010; Tue, 18 Nov 2025 02:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536508E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:21:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F226F1403FD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:21:32 +0000 (UTC)
X-FDA: 84122882424.02.8BA58A9
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39926A0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:21:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="kbhU/xYn";
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763450491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=;
	b=3uouB4fFwRdTq6eRsZfE5BW+WjZultskIXtV78XmGesymj3UjViH1WV/ONP3uYJEhow0RP
	RUkoBcEliOjErZtuWj+I8vYVmMVcqYzQol+siX1h/C6szHU8bh2qCtUoo11S5hNKlMxUHs
	RXJQjb5kCUn8szaUdnIbmTonGhL4naM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="kbhU/xYn";
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763450491; a=rsa-sha256;
	cv=none;
	b=5HQW/CXi4XPSCpv9Fr9jPLQTFBiks6qtG8BIhOWVhF4dVP9pLHrk2CV2t3PILpls4/m+ua
	XEnE1dpjub41K/eBhGqQqcz6L1oZVnzAjtZ/cuzMjaE9qFdMLXDlW68tLBYSOyX6Ea1MUU
	B8fg4oiyhCkxTj2/tft4RCUTX8lPoxo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=; b=kbhU/xYnyhIngKBea3/kKla+DP
	EF4IRivlPSP4d4YskSySn8dMgu8jsC1NotjIvz0miMk1J9eIO1H1jyqqH5P1H+AN2N0P6xZu6GH38
	DC4Bn5lRAWgJa9ic4jFbQTY1brTcqFCu6u3UjXE51nSrOT3w+G53KZkBXNfU9OlnlLloS8lqdUE1M
	wYHp4eAwFAyJXnH/tZdeEk5gDrw/EvOkpqADVq8OtqE6ZiKWT0FAYqFERzRmraQ3XSHtSgygvjXZj
	2iZKvcU01Xve+g8P85heP06Y+NANzkU4tingrfQMGv24fuH/nHyUE8bP9iVlH1guErHdjJ50f9jUO
	t3wA8qAQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GESE-3aMn;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 26/54] convert devpts
Date: Tue, 18 Nov 2025 05:15:35 +0000
Message-ID: <20251118051604.3868588-27-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39926A0004
X-Stat-Signature: dnwq83ccgazegx4out7yucji8kowci7g
X-Rspam-User: 
X-HE-Tag: 1763450491-963283
X-HE-Meta: U2FsdGVkX18q1Hlwz8LW7Qo9XtyUh5TafdBhnCkH7I3XCVxBqTCkl+xpElF8QdrgPXMpaaEEu1sZjHwX2gU5WIu09aZOCY+GMaL+CLOFcfoDGAish63NSOMFAT3ymrFnvdSdF/wxJeN52QdBLV25p8mL6IIVZLbJj6rZXjvLQWyOOkhC3NuMOimb15jDrQz0OVM7bcl6u1kyUebIKGo6EkjCv45fHuphC3BQGX1IVFR3kS9tntx9NHnUfbAXh+nFD3Vu/I+HknDN0soKk9eG7Gz/USx6l3ZZRusNit1ABv99sl7/SmKpwQHnt6miln+Duy2I7dIuDrOBpZtQ3V93rZPCW6p0nuM+dGNVBypJj5RabhQVWG/Oa1G28XPopoV1xT0rxG7xferznMeLOsTORw50SATcCEIQald/zwYTHYMaasyTwsimiRS4nuT1BDLMBOtztcTN4ip5qtk+K3jQv1vq1lfSeDNt2lw7XqP95LjoAO1OY69XJFjPOx9SMb083zHAwCE6MEWlA1eBDsR8CnasJzywvVhllwlJNp277nPgGJgJoaOs2l/6rH2LM9uz961Z4D5I32rwnFsjRU+90F4T+0RWsjJXHRgvkIP+gitWxYh+RxuhLmF+hmRfvwSWAh5+zIkpBnjfWYZkW8mpy04Nf0h/x4G4TLEatpao/kFP5pyUC37cdajGrzRZyaSl9eiPiYDtUTAf+WfMRLlYoUKkRlkAp+mS/BCh8Fmus0mNIaqmVhtpMyWXf1M/WlhO0b+9KV6wfwD2UTXNW/h8WJKUZiuJpF5rY4jNE4jDmJdfaXvN6pPOcgYDTgdqT+rnF/keeWDR7O4N0TSce3SaEBTItyw/LIKePFWu7OA2mxoSSYEUYeSHN8rbFZIXE88NGgjXfO6SkFcRkVEWuqBtlG35wNmCSZyG8BTqSgyi7N7J/2z74BMLvirntEsBrLU/S3jtRHYMIHS9laxIIKV
 +Qo+cVe2
 8Ul5H+oT4cyiL2RpDEENH+9uJb8OPh+itbZfqsoe+Dxfoevy9IyB02Wl5VBIMnMZYfJJdo0Y76xIjVUOKUUMjA3sDUY2tnNYz+27AStzF8tNygm7s2joZoXfnzvUiqVj7JFSnqf/txOfNuBd4bATgBMo0QQmL8H02Buq7js7tyyrfPXfoXUqUuxvA4UoccJiB09kDyYUnO35A/Q3GZGHulltGhs3j1Rx0OHRC8QENNwMvmShr+QlWus1Czw5W/04ydlDLZDjgejGv7HNbkV/oThxllhx3IF3NfBW23S6sRUxXS+hOd3JsgftRX7eXiznLTMhvbs4RWAbsIbKVhjBhCb5sp2plC8UKNjIO7eTs88YAJmAzP1gdfSEhNfKbWfgG2H+A
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

* instead of storing in pts_fs_info a reference to ptmx dentry, store a reference
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


