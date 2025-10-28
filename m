Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED366CCF9F0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577A1800D6; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15F6800E1; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2A2800EE; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B20F800DA
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2BEC1A0302
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.13.F0C55CD
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09B602000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C6ElkibK;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=;
	b=NFwr9PgQ8mMT7hYNGFlB0SpTDEOcjsF/Fq2HuUHq5bhIGvGDRba5gvNTruLrKoydRk1qLE
	94bcEsoH+KEwmvDSPvwl5u3Kb3D2PYBiX7zGWWnz5O4upB/9J8fDCXcCoMhs2ux9isKYL6
	IrsQk7qnJwFklNm1QU+BwIfgBIQNloo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C6ElkibK;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=xCt4khQsn1wGgU8xSC6t9Ru+rhmug1xVFzAFBi54hxvgTDN75TnD9onkIT1ujx2LG0uewZ
	kJIHKfgCzBBRfecZxBlWwM0keMh37jVzc7zZ/+mxrMYVfAM6VkGrd/NPmXagLmEpZ+yviF
	QlAsM3Saaz6nEmNJbVnzn+kKeWdODeI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+re8cgG256R+nyhDcVzLSPRAvzZcH6z0w0ygW9fyGms=; b=C6ElkibK0px+2mUJx3est2ATNh
	knmPWICEKuFaRKLX2J8F/OWuvhPQM3kwW2CxlTz4cQ5t1zIYW56OdcKRivRLmBHhtPjhZQq9iiLPb
	2RYVMzXRB0JiCxMRFjhOWbBFAHvo4nCAT7f+7fWR8DegrSnoXDyDdixOrAKVS0zBRzlftAclj91Lq
	B/JfU0nycboNFxv0gK8Oy0vYmatA87jPzEGqPheGMU8jqz0DTO9F1T0kmNSlas37O23j9SoVUy8yy
	1GQ0PKk0c6OLN9FlEsb6fUR81HnVQ23wsJxwB25wJIlMAgXNPM2KB15R5P5XzQ82t5SPaCiSKsRaD
	CtgzjFBg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eYo-1QjE;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 26/50] convert devpts
Date: Tue, 28 Oct 2025 00:45:45 +0000
Message-ID: <20251028004614.393374-27-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 09B602000A
X-Rspamd-Server: rspam03
X-Stat-Signature: p5s3ceem4xs79ih3opfqo4fi6zz81e53
X-HE-Tag: 1761612383-175674
X-HE-Meta: U2FsdGVkX1/uDCIfoGW1W+nKnPoe3s7FNachOUkm5Gja5uurehjiTO/oJw7tr6QXY8+TgfvYbiY5HaTfy8NNYUnTZfatfX9637SO8kZ+4T0yK4lYv4G7mon7oNeNZyaFyBHCrZXdaizkZg7mxmvONk+glId8TZeWlin2RZd3kTKpp+5Im42sdpzpobFfCdDoetxTIflJHWf2fHRKrrrD/M1Enke4sK1hwJvA6yqU3HXyBkH5vpogZ5x3khzr/B5/E5zMy6IVoszRL/SiD7Wu/oosVCfowwJYlGvJmAwzNo49mR94aN+bkSvXNrjOc982DwByOfCZlJ90Vp1BuK2NZadnVigcnrkyU9jFrPBd8mJMGpx6gLxk13k79PPQX1WaJGO2kA63ViSkXeQKnuPAcx5InQXUJAocg9FNt3DSMRcCjIDZQ3krL5pwWJvIwyxq8+qYTXErG9rC/ZYylM+TxBI7Vms+4EzlOluYDC82TMAgPyu5CkG/Cob5nUQjdBWIIisbAcsGgmXEfdhgefCTrW0IckZtEmAVPUoQgz7Hw8Fbbr8rYT+VVoXCVHGWAMjbh6ahYl6IDNzXaJrdRM2MgvWbWdTmYshQsln2dbyYzYdpOV6WJIzjsu6kvnlxjWSLCVFIjkNX6EUavzTUEU25FrvGnMCY2v/XnDRfDugTBOTQIGAw3iVE3IbpRT1dR3iHWZkAinvTs1EZ43ZGv5KcuD3msJBjpypw7CEXlNYzG6vyZnTm2Dv334YR+R//p7oihuSkDBlISOEsq3GTWmRb8cRwNd5WKgH7cnaFrOYa1+fnsowFGCewVADfb3ZMf/wYTMHnSiK2JFdHoWD4gos4+HC5K0DH1RdvQ1H+LKDG4UMrpbU5xkG7aUieP5YTNIDukdtRZCqx81X3yNcUucBk7XS9HMYbca9n6WH8X2VZN2JK6PcHgZ3L//pTe6FB9BMLm2F5dqgEfj+AaFV7Tj+
 rVNLsDw+
 WgANBHBZVFJFs2gxtlRAockfp08JQV7hGrNY89X2HMdAqWwVPCibRY6buZwhtQiAUIY6yonmtBhSsaTun12RCjZuVwlH6XDURNzmL6szs19IN81FMKeV+gXZQ1QLFx4qXydsdezvqDn2WDKLrhfAwbBfbHGkcIPvn2vwtl2jxeF4mWYzHO2rnc0Ylq0cmvfwJg2LVYI/5cwr9DBXXxkRNjPnTz03pKB1Xiuo4cpvUWIU6bl7VtL4I0FdhvGo266xTt4cDxvs6D9IG92XOGfj1wpsY5JyBhIw3Y5/N0aUV7jg8XALALR4Kl9Jpm2HXjxJfIcFpk6kqQC8DjWaXQ2QCAY1yOEhwJUtkou4pzpzmKCUftM2nc43JcQGgzF9ksQ4hColFvZ+hieHXMPLzOVQdi7yYZ/RyfFhFIp1iEbqO2O9pAH2v8orGMQ+CVLGfuIJxF30hq7FVRMHZ8gc=
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


