Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAF0CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982528E0010; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CB68E0026; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCF68E0012; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3E498E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B74212B35A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.12.AD27719
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9898DC0006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=o6m+fY4R;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=SYlFVMb3gfw1/qQ4RsdeVAFyg6u+c0K/Clc3KL2K9tgtiT3j+rM+qlcfaFSorpjb+B62g6
	0i7dz6CgCatbnelnIvHCaRO5GLM7pNF0XZuSaApPD4GORx67zkwXOc4cEsVa1gZpf18vSX
	55ruZsMC0zcXTPD4GLUxHLQLZAmuhlM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=o6m+fY4R;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=;
	b=k75092xpVMSSQFbKMFQGWImRw837Nb78EU28a1+qXfFv0+/Dh3pnQCxFwYmZ/kI70BMoAx
	ZMC90kuNe74cmKIUpXag8M+ba9I49ucXjfvoPjWQL3ItIk3CiVxCDLuPCevRllXAhiUXG/
	QPAvIAQ9rTM4UPhRmnWdJTKdhQu17WY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=; b=o6m+fY4RoDqM5DvPVGc21EmGSo
	q2cwATyLW4MqdbkO6RZ7ftV0mjw0ZeOBE4FRUA1bI4i3cEn78fZwBAcMA7EuKgujl9pmgN1eaLUYy
	9wCIu9gMJF+JbSy1etZCld8jKsUj0EMcXE7Hapo5yC5NF8hbVoeiYav5RAOL2yqXJp+IOBTpR3MAR
	LYuxVtbgRCW189Evth0KJivbYHwXQucpADFe60jOwcFknmBdMvHuB8kPeN/72pMbv5WT3M7o5XKkC
	yu5lJRSNtz39RqQrPRPRJBGSn3QvxsUD69wRn9x0r6edupfjwU9jaK3UP0Ulg6cqK2Js1cjv0vJf6
	D86Fp2HQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000Bwzf-2uAe;
	Tue, 11 Nov 2025 06:55:25 +0000
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
Subject: [PATCH v3 26/50] convert devpts
Date: Tue, 11 Nov 2025 06:54:55 +0000
Message-ID: <20251111065520.2847791-27-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9898DC0006
X-Stat-Signature: i9wxenkkzenetrzhnt6o9f3n7yga6iub
X-HE-Tag: 1762844130-866909
X-HE-Meta: U2FsdGVkX1895U4Kn7t9CAiX5Y0wsEsrl3ZtpPFwthqiwxucw0QWOzaeu7gJOMWgEtDfhL4zjsrg4gMBm8N8vw3ZfXFyEWWiCpfrCpcTnEYCqrHVnEC0cVyyT4PEpzTdfGyC9TSVtmpy44SEsnsI+4CjVGVpDdi6eBiPgCm9llZGZCDiMGD3I9qHZHjHts+5OCselxlNGjI882EMqtWtcoBsKDSp+5Y4GOaTNHO2lF3xbrG7t/bWHwN4/1W/i78J2UsdDA5OaFqJf4rnoPulj3TUq2Pd4ZomsMndDXwinQKThqn+6AkKIo+13W4DHanPl9A5MR0sYYKCF0r3vbaCZHGkF6GQApLQ9v6Dy/w5lrgyLHoicTPootVtGuP+iOhVPRMImBn0XWd5fr63f6UQmRSdRf6QVpbufPTbOYBScpUT83lMrqarJPefQhF003+Q+TexmcfJ197njkn1vSqnmvN+9QihT/5JJ5xnR8R1Vr1zpNYdN12B04nZ95lC5Wc9nuZYUUbKAgGYu3dNaOfhe88/nLL8NqA6EBnFnJ4A6VVVQ8pFfDQZxBZhda2AqcThTubvtVk4JJcQQb9/TI69IPAUAhrIVsj8gypdWxNaIUktlBFyKDF8WQb0WpQnjLSbjga+4EsmQFeY5FtpwTmgq2lCOdQ7YE39lAaubiuY1Edu8NtZlNS+XQCI890QqKwTsr/ZANmSWX0ncyhHbb+qGSM7NhN49+dR98wwcVoF8/VeY4glnaYQUxmyGyYao/5krWnNx+G+EzSLNP5fBYtxVGZBbE9EPNFafcg9BhkdxG+YKzPyTKcCqqIx4GkEJlh3NOvr/BNW540WEB4HXvRw508izcgFz54DMc4VWUDOrfS31ig6I4p84VwPRNDQTNY8pdWYhssx0UhN2TXsYNzto4rcIFBGw79Ieins0U0Svaov0Wz+EhT2OZjhfjhn10V5Tj0srOLuj94+4/9EP9p
 P2KSN+Bn
 VXGjCi229PTro96Ti5S3WSQYx611knUyhTT3Xn+CEhOn94GrDATW4OPiZsAfN6SvkFyEJoG+/nFtL6hxgQDCrSyXe9CeQLh1HGSP3VT6Tj2fw2uuXDgKqvlZ6eoezRkngKyQBvyAdxecZFvSs0m+Q6EEQgD6hoTjYvd6efNy87+AR2fcP5L4lVECDp3fzpFYqEbJt+YI+KHvCz2nka5c9BNqQCvH16N67nEa8JETrKaxlJYGIa0wGFY6/uDeh/8sdnNUqBA9vDsCJQKeCgx3j1gZSY5ctX/OsYTZ1VYWvYL3qpNXwVYfJyUlREkFWjDTJT9n9eReNAjujLNhAlqC1qLdhXWereruWCjwo3wZM8pgR80ZuXk76e/7UopdhBUVBWpT9
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


