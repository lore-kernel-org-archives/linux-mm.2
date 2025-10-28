Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD69CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE4380107; Mon, 27 Oct 2025 23:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820C0800E4; Mon, 27 Oct 2025 23:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A6080107; Mon, 27 Oct 2025 23:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54074800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:31:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDE4CC0396
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:37 +0000 (UTC)
X-FDA: 84046098234.16.B5EDCF0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80B801C000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KSdnFP3U;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761622296;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhVZHCo/8A/9+8ahzyAjs/jwjY1fv4im71qjOl+I68U=;
	b=NpbKTR4DGm85sT2l9pQ+W1TBC3m8hig9qaOJU1GYg3UfGLl3Ak51xo56eS95QK1iWqM/yu
	ypwYLOIGu7+9GZHaVQR8KRmlloptN+ahC96WXJMqMHtgLtV/mxRnI1DLfsqng4tyfrwb/1
	Xt4gR57Wle7WAWgPOpRGGxpp3Np+/YA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KSdnFP3U;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761622296; a=rsa-sha256;
	cv=none;
	b=Q3e7aH2TG6SeNjVXm+O1ASgwFob8XTmA396QjOSLhmoy8H8eBO1vT668jvpoDdOpRL63WX
	MbHdYamuWIuO7YFgpAAbgFcwSgOKsbTjqeu4kSQXT2OcZPXzWa9Yn2qW7dJQDzGW+ggP4J
	JZjSeyDBa332ElIP92BaLmcdFQ8Ex+A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nhVZHCo/8A/9+8ahzyAjs/jwjY1fv4im71qjOl+I68U=; b=KSdnFP3Uf3Gc2L4P8+gVMs6NaY
	8h5KjzipOzsvfCYyKmYQWnr1215L9QiltbKbSAfCPYdtlxMvACmdkXsIgY0pjbW9IlTCw7R5euqlf
	g4OjTenHpmrfytwtkD3r6u1UwgCJ5oZSi9cPTgRBCQE1gyYExNmDo7jRg3oVBxODuZVblG2gX8XBd
	ycgKmhaVVXcLZm3EiuzHfXap48uE3rSIXV1wfdda5TIC/DQ33D1NhmBAYzICXl85XUA5Wg4ACHEud
	WW48GlAeR1l8HYwngXSXiHsEkgHl1SZtGhWagy+xkzsAjw6/nrvDLptr4d60gllKfhf1mfy78zba7
	IJmWfHYw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqv-00000001ens-15Pf;
	Tue, 28 Oct 2025 00:46:21 +0000
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
Subject: [PATCH v2 46/50] convert rust_binderfs
Date: Tue, 28 Oct 2025 00:46:05 +0000
Message-ID: <20251028004614.393374-47-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rwywbn37mdyhs5387m5wuxacsb3pj7oy
X-Rspamd-Queue-Id: 80B801C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761622296-423998
X-HE-Meta: U2FsdGVkX18lgvwowzmvkGzWjkH+243nK0qBnQnPCa6Rm5h2mgPco6sUvDS7DkSMn9q5SAEQ70fRfFDLS2Mm//OHQuf4P4omHxw2wdLNXQizCd+tpj8VhOCx96mfgpNBFergoNy0KXoJEQoPg7vYGyBV4e+Clu7J33yv2L40T6vCea61VEmdjulcPfroPUTKFWfblzFaElPjKu0eIzaR4aoyviYoccrSgPbf0G1yHToMY5qu/czL9yO0FY6iEZ2lyFzqwdk3voVnnC3M5v3m5su1QXd+o7wXXqUBFDb9sPdDoO0/lfyt7BvOncXd5fIbaiLlTgzRbkmexRG0BOBRx1wXka8+dR/Pcig3vlAFTs4LT6UXeab7jGPBQyrjHXci+HmGVE6MDlSPxj3ZZDLeAAXH49EBFx3JC1LYWsyQXTmN8CiFBV/kVJF64WnxGmUaH73o5YV6QLtFnfU2xHB/thEqhSevJSWniXdruDQHhxBPnVr0ZytE74vsW9gwN/oiaVHOQtftVSGGgbzA+r5F7+7Ei7mCF1Y6vatx9G2pS5nVEqPrMBtXTkPdn2voakW+7uOE9hY8s63eL67vhafb2mW6OdK2a8I70vU7vgdHyC9Kr5yjcNb5mVRQ7bkAAb0LFc41tiOS53UCU1g/KOd5OLwdazUtQlUrwNygJGASTN1zKZk5a3uo2DFh8iXiVEbL+5CKhMrNpvU9QrQoiruVuLjbbDIhZe1O5EsbkN+nekv02EodhRDqJVHb4+KNJW0C3jkohkY6dLRP8LXVlKZaSvqDONY1pS8BDv9AAEc6EaGeCz51QdT2LloiB+1Y5n+j9OYFYU2rfxj6hC8U3j1xFiucEwPb7x0XBLuKY4jTupek/3UDGKwwPCP8m2bfEolbX0Z3ax296umQPE0TRtKDSqB0hBlGgmEw0Mxyp1c6fP3ByC/dnVkk6EFJu6qPIfmI/qD9qoDLXj+yU72J/1K
 ARPKgVUd
 zlm1iBu8FN6KWwbfwVtcxaXmz8QlQfGmPpAIls3Pswtp5l+lygI2P+1fc5PIyh9fnpC0/oRuuq8rvmqVsq7c2XOvFCL4DFmdeG0oc/qmGangCtjpdhLc5oOdiodFD6MLe0bhLeyCSDBEWFZXwrZjUNjulZVOi6UpJih7D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Parallel to binderfs stuff:
	* use simple_start_creating()/simple_done_creating()/d_make_persistent()
instead of manual inode_lock()/lookup_noperm()/d_instanitate()/inode_unlock().
	* allocate inode first - simpler cleanup that way.
	* use simple_recursive_removal() instead of open-coding it.
	* switch to kill_anon_super()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binder/rust_binderfs.c | 121 +++++++------------------
 1 file changed, 33 insertions(+), 88 deletions(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 6b497146b698..c69026df775c 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -178,28 +178,17 @@ static int binderfs_binder_device_create(struct inode *ref_inode,
 	}
 
 	root = sb->s_root;
-	inode_lock(d_inode(root));
-
-	/* look it up */
-	dentry = lookup_noperm(&QSTR(req->name), root);
+	dentry = simple_start_creating(root, req->name);
 	if (IS_ERR(dentry)) {
-		inode_unlock(d_inode(root));
 		ret = PTR_ERR(dentry);
 		goto err;
 	}
 
-	if (d_really_is_positive(dentry)) {
-		/* already exists */
-		dput(dentry);
-		inode_unlock(d_inode(root));
-		ret = -EEXIST;
-		goto err;
-	}
-
 	inode->i_private = device;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
+
 	fsnotify_create(root->d_inode, dentry);
-	inode_unlock(d_inode(root));
+	simple_done_creating(dentry);
 
 	return 0;
 
@@ -472,37 +461,9 @@ static struct inode *binderfs_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-static struct dentry *binderfs_create_dentry(struct dentry *parent,
-					     const char *name)
-{
-	struct dentry *dentry;
-
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
-		return dentry;
-
-	/* Return error if the file/dir already exists. */
-	if (d_really_is_positive(dentry)) {
-		dput(dentry);
-		return ERR_PTR(-EEXIST);
-	}
-
-	return dentry;
-}
-
 void rust_binderfs_remove_file(struct dentry *dentry)
 {
-	struct inode *parent_inode;
-
-	parent_inode = d_inode(dentry->d_parent);
-	inode_lock(parent_inode);
-	if (simple_positive(dentry)) {
-		dget(dentry);
-		simple_unlink(parent_inode, dentry);
-		d_delete(dentry);
-		dput(dentry);
-	}
-	inode_unlock(parent_inode);
+	simple_recursive_removal(dentry, NULL);
 }
 
 static struct dentry *rust_binderfs_create_file(struct dentry *parent, const char *name,
@@ -510,31 +471,23 @@ static struct dentry *rust_binderfs_create_file(struct dentry *parent, const cha
 						void *data)
 {
 	struct dentry *dentry;
-	struct inode *new_inode, *parent_inode;
-	struct super_block *sb;
-
-	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
-
-	dentry = binderfs_create_dentry(parent, name);
-	if (IS_ERR(dentry))
-		goto out;
-
-	sb = parent_inode->i_sb;
-	new_inode = binderfs_make_inode(sb, S_IFREG | 0444);
-	if (!new_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	struct inode *new_inode;
 
+	new_inode = binderfs_make_inode(parent->d_sb, S_IFREG | 0444);
+	if (!new_inode)
+		return ERR_PTR(-ENOMEM);
 	new_inode->i_fop = fops;
 	new_inode->i_private = data;
-	d_instantiate(dentry, new_inode);
-	fsnotify_create(parent_inode, dentry);
 
-out:
-	inode_unlock(parent_inode);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry)) {
+		iput(new_inode);
+		return dentry;
+	}
+
+	d_make_persistent(dentry, new_inode);
+	fsnotify_create(parent->d_inode, dentry);
+	simple_done_creating(dentry);
 	return dentry;
 }
 
@@ -556,34 +509,26 @@ static struct dentry *binderfs_create_dir(struct dentry *parent,
 					  const char *name)
 {
 	struct dentry *dentry;
-	struct inode *new_inode, *parent_inode;
-	struct super_block *sb;
-
-	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
-
-	dentry = binderfs_create_dentry(parent, name);
-	if (IS_ERR(dentry))
-		goto out;
+	struct inode *new_inode;
 
-	sb = parent_inode->i_sb;
-	new_inode = binderfs_make_inode(sb, S_IFDIR | 0755);
-	if (!new_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	new_inode = binderfs_make_inode(parent->d_sb, S_IFDIR | 0755);
+	if (!new_inode)
+		return ERR_PTR(-ENOMEM);
 
 	new_inode->i_fop = &simple_dir_operations;
 	new_inode->i_op = &simple_dir_inode_operations;
 
-	set_nlink(new_inode, 2);
-	d_instantiate(dentry, new_inode);
-	inc_nlink(parent_inode);
-	fsnotify_mkdir(parent_inode, dentry);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry)) {
+		iput(new_inode);
+		return dentry;
+	}
 
-out:
-	inode_unlock(parent_inode);
+	inc_nlink(parent->d_inode);
+	set_nlink(new_inode, 2);
+	d_make_persistent(dentry, new_inode);
+	fsnotify_mkdir(parent->d_inode, dentry);
+	simple_done_creating(dentry);
 	return dentry;
 }
 
@@ -802,7 +747,7 @@ static void binderfs_kill_super(struct super_block *sb)
 	 * During inode eviction struct binderfs_info is needed.
 	 * So first wipe the super_block then free struct binderfs_info.
 	 */
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	if (info && info->ipc_ns)
 		put_ipc_ns(info->ipc_ns);
-- 
2.47.3


