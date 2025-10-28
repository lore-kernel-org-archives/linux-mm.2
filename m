Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11A6CCF9EF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F16800EE; Mon, 27 Oct 2025 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA196800F0; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D31800E4; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32468800D7
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E38BB583AD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.24.0FB6EDF
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 36520C0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hJkvg9Si;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=KCmHEGlDhrU8A5X5MrWXMDpWSknOIbae/2O8ZJiLXZYzGqanVPdXqZ7GqUETFhZQg8QFwE
	xDfgsmFyIUETz1Cqn9Lbu4EGfxpNOXw2eI7eZuM+w+dyw+0HuBFePIxccgc4jizLuMIfhb
	FlPv9wqrEy0rVRmi7B6zcri6vk3X2Jk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hJkvg9Si;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBdNK0gxnR7qfZeEdC/f0rBsP+oFzkGGYr3Jch9A6Js=;
	b=4tbi8+GvFjE8//ySPzq/Q8/zhnW6WNVuqmOGPmTtR6lwwcresql+bGYXalYRmkrAmGXmSZ
	g9FQ8Li4ZeyAFWYfja65+ND3FMl6gRkikzYwCAOZgILqEVmAxeeWRjhxuS+IUkVPL+tPxx
	neUoogltrfwYEAWg0tO1PXkJ1vyTYmM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BBdNK0gxnR7qfZeEdC/f0rBsP+oFzkGGYr3Jch9A6Js=; b=hJkvg9SitMoNdfPHwecrFFEJGO
	woGIgKvY9Ps8P4MffQZjkg2+bGuwKDOXqFqsQvBx+05CGehRJCcwZV+0hcfc11LC7VRQUSe25npna
	WLJsTiIG24TBAx+pWZHlURyousvs8kmfSwd/4atIS6Jb9xxb6LS8ZFJyTSe5nOn7I9Z5FY3HtAjXu
	iEUL2OxtWhPSe9USVVkw9OgUPB3n1J1EB4K21R8NPkVJpx+1hKTCjI+SmfzN3+q8PaL8gGfyzKVz+
	KHeJNuwnG6Evciq+QRMJsEi+0oHrSWPK1vB5xlDqV1jTYtAUslF4G8q9tlgSSVee6WRYJBMnYQpsm
	1IGJpALQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eZz-0kWS;
	Tue, 28 Oct 2025 00:46:18 +0000
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
Subject: [PATCH v2 34/50] selinuxfs: new helper for attaching files to tree
Date: Tue, 28 Oct 2025 00:45:53 +0000
Message-ID: <20251028004614.393374-35-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wjj83rbiab4u75jbejm7pbp568h8epqb
X-Rspamd-Queue-Id: 36520C0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761612383-862534
X-HE-Meta: U2FsdGVkX190+BiEIPcTy9fK0/XEN146Drr7/ReIZ0O4LOG6dOqogs80myqots0H3NCIAM5xnbugKZwf8xWOq9EHfMliGrwVW4H4DzVtARux13hURLZ/yVkuUqjX1eBjpr2sGcfEGw44hDVvnBmvrJZcowRPnBdv3CreCDP2SfZXIpGfUlDXRP/KbGXCmDvpb4Pby68OIkf0gJSd3JFQ2q2Mm+4VbB7DonYslVAv8oQG9DRwwp7gm5sGtq80659ZAGDuBYozD3eTCEM6K3q7Nlkzlv8R5Q90eZG0xsRtTFZ6mHEx53I5M12lEVuMQjDchgcTINMc0ZO8khp+s3r8tg2xWrR65NHwAblcokgF9KjDCJHS9RwE8JvNe4qIDlqLQxX5Y30kaQjSvZL4ru6ujtvdvzZEuuRiXU1LhnoJZIk8w/kANnLeeEWE6vYcW28fukkYVKRfpfcZNWgmmVePwmfbXbBECyCYJQmr4Rs63wv9ndtWViG4RTR+IGjIQpWuJa73Cmrw10WWNiq5dKOAhSAAMbj7Z1u5XvEc9DPddTqYPx9WwerNMyxyWUMsWCq0Ejem94em9NDnFv3FcDVcXXWj5HVVtf13tjKvHL2Q22x256xFZnNeFLBZFeXwUMmePxuuy2gMOWcAWn15GfQJ2TZkomzX7+dkrQr+mZDXEK5vP5L0XVFuRegFHC1rR9ACzhr2qnH6YowSV9iAuRZaO/kzn4S66GFLfN33Ss+AV52nXwPwGEHNaxplPzGyAF2Zrl4ljZ6D9+v1l5XQsuudTOpH6alNLsk9x8u1luN7RcLlsIuaUhl+Irwogq/QC1svpwWvyi4nWNAduC/h/cuJUWndmxXM7NaImd4S7A5gBfyhZ4bsx73v87DXU1gZrCTtXdKdeJoMke3/5dTEsbbDRX0g/ctZ+++dnGvEwIGkEjw/QMpmC2mSVChKnK33YeN1YpA7C4CFQjIIvwLdWF6
 oYJsKs9k
 hbn4milScaU0ZPaKdAIFTlgmFrChTsTH5JuWmXAx+7CggMHOGE8gquxY0T53AV+ivOS8GfR3zQ2YvLJ49RwWyh+3tNthsoNlOKiC9Vk5GGJT17/gOWFBvXiayW12RxHDYIMIMyImppmjE9kgt3Kg2B1E/uzrOzNEHFCYtfYT+rbk2bIVvdsA1ztwy2DMR2kOqkM1XWoFnBjbOnnq3aUxMilXsx1ZK3G9ZKjlgYheCnAG5QYidBHMzJukw+ApJpczOeFxIr535KmA36OjZhOvp9RSFWhgvVRF9LUYOBgtELpZXnkPGQL2RYVrkCrBSAw5WzV5LDfh4P+Y0kodZb+HCGfHxAz3ujPdo9igT8sVceXK1D1p3eUlOHYTnFQUKzOPmeZi5u0S8MxZva+n4Y9Ix7g6vfq/Q4xISq/7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

allocating dentry after the inode has been set up reduces the amount
of boilerplate - "attach this inode under that name and this parent
or drop inode in case of failure" simplifies quite a few places.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 160 +++++++++++++++--------------------
 1 file changed, 66 insertions(+), 94 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index b39e919c27b1..f088776dbbd3 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1197,6 +1197,25 @@ static struct inode *sel_make_inode(struct super_block *sb, umode_t mode)
 	return ret;
 }
 
+static struct dentry *sel_attach(struct dentry *parent, const char *name,
+				 struct inode *inode)
+{
+	struct dentry *dentry = d_alloc_name(parent, name);
+	if (unlikely(!dentry)) {
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	d_add(dentry, inode);
+	return dentry;
+}
+
+static int sel_attach_file(struct dentry *parent, const char *name,
+			   struct inode *inode)
+{
+	struct dentry *dentry = sel_attach(parent, name, inode);
+	return PTR_ERR_OR_ZERO(dentry);
+}
+
 static ssize_t sel_read_bool(struct file *filep, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
@@ -1356,8 +1375,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 	*bool_num = num;
 	*bool_pending_names = names;
 
-	for (i = 0; i < num; i++) {
-		struct dentry *dentry;
+	for (i = 0; !ret && i < num; i++) {
 		struct inode *inode;
 		struct inode_security_struct *isec;
 		ssize_t len;
@@ -1368,15 +1386,9 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 			ret = -ENAMETOOLONG;
 			break;
 		}
-		dentry = d_alloc_name(bool_dir, names[i]);
-		if (!dentry) {
-			ret = -ENOMEM;
-			break;
-		}
 
 		inode = sel_make_inode(bool_dir->d_sb, S_IFREG | S_IRUGO | S_IWUSR);
 		if (!inode) {
-			dput(dentry);
 			ret = -ENOMEM;
 			break;
 		}
@@ -1394,7 +1406,8 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 		isec->initialized = LABEL_INITIALIZED;
 		inode->i_fop = &sel_bool_ops;
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
-		d_add(dentry, inode);
+
+		ret = sel_attach_file(bool_dir, names[i], inode);
 	}
 out:
 	free_page((unsigned long)page);
@@ -1579,6 +1592,7 @@ static int sel_make_avc_files(struct dentry *dir)
 	struct super_block *sb = dir->d_sb;
 	struct selinux_fs_info *fsi = sb->s_fs_info;
 	unsigned int i;
+	int err = 0;
 	static const struct tree_descr files[] = {
 		{ "cache_threshold",
 		  &sel_avc_cache_threshold_ops, S_IRUGO|S_IWUSR },
@@ -1588,26 +1602,20 @@ static int sel_make_avc_files(struct dentry *dir)
 #endif
 	};
 
-	for (i = 0; i < ARRAY_SIZE(files); i++) {
+	for (i = 0; !err && i < ARRAY_SIZE(files); i++) {
 		struct inode *inode;
-		struct dentry *dentry;
-
-		dentry = d_alloc_name(dir, files[i].name);
-		if (!dentry)
-			return -ENOMEM;
 
 		inode = sel_make_inode(dir->d_sb, S_IFREG|files[i].mode);
-		if (!inode) {
-			dput(dentry);
+		if (!inode)
 			return -ENOMEM;
-		}
 
 		inode->i_fop = files[i].ops;
 		inode->i_ino = ++fsi->last_ino;
-		d_add(dentry, inode);
+
+		err = sel_attach_file(dir, files[i].name, inode);
 	}
 
-	return 0;
+	return err;
 }
 
 static int sel_make_ss_files(struct dentry *dir)
@@ -1615,30 +1623,25 @@ static int sel_make_ss_files(struct dentry *dir)
 	struct super_block *sb = dir->d_sb;
 	struct selinux_fs_info *fsi = sb->s_fs_info;
 	unsigned int i;
+	int err = 0;
 	static const struct tree_descr files[] = {
 		{ "sidtab_hash_stats", &sel_sidtab_hash_stats_ops, S_IRUGO },
 	};
 
-	for (i = 0; i < ARRAY_SIZE(files); i++) {
+	for (i = 0; !err && i < ARRAY_SIZE(files); i++) {
 		struct inode *inode;
-		struct dentry *dentry;
-
-		dentry = d_alloc_name(dir, files[i].name);
-		if (!dentry)
-			return -ENOMEM;
 
 		inode = sel_make_inode(dir->d_sb, S_IFREG|files[i].mode);
-		if (!inode) {
-			dput(dentry);
+		if (!inode)
 			return -ENOMEM;
-		}
 
 		inode->i_fop = files[i].ops;
 		inode->i_ino = ++fsi->last_ino;
-		d_add(dentry, inode);
+
+		err = sel_attach_file(dir, files[i].name, inode);
 	}
 
-	return 0;
+	return err;
 }
 
 static ssize_t sel_read_initcon(struct file *file, char __user *buf,
@@ -1666,30 +1669,25 @@ static const struct file_operations sel_initcon_ops = {
 static int sel_make_initcon_files(struct dentry *dir)
 {
 	unsigned int i;
+	int err = 0;
 
-	for (i = 1; i <= SECINITSID_NUM; i++) {
-		struct inode *inode;
-		struct dentry *dentry;
+	for (i = 1; !err && i <= SECINITSID_NUM; i++) {
 		const char *s = security_get_initial_sid_context(i);
+		struct inode *inode;
 
 		if (!s)
 			continue;
-		dentry = d_alloc_name(dir, s);
-		if (!dentry)
-			return -ENOMEM;
 
 		inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
-		if (!inode) {
-			dput(dentry);
+		if (!inode)
 			return -ENOMEM;
-		}
 
 		inode->i_fop = &sel_initcon_ops;
 		inode->i_ino = i|SEL_INITCON_INO_OFFSET;
-		d_add(dentry, inode);
+		err = sel_attach_file(dir, s, inode);
 	}
 
-	return 0;
+	return err;
 }
 
 static inline unsigned long sel_class_to_ino(u16 class)
@@ -1771,29 +1769,21 @@ static int sel_make_perm_files(struct selinux_policy *newpolicy,
 	if (rc)
 		return rc;
 
-	for (i = 0; i < nperms; i++) {
+	for (i = 0; !rc && i < nperms; i++) {
 		struct inode *inode;
-		struct dentry *dentry;
 
-		rc = -ENOMEM;
-		dentry = d_alloc_name(dir, perms[i]);
-		if (!dentry)
-			goto out;
-
-		rc = -ENOMEM;
 		inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
 		if (!inode) {
-			dput(dentry);
-			goto out;
+			rc = -ENOMEM;
+			break;
 		}
 
 		inode->i_fop = &sel_perm_ops;
 		/* i+1 since perm values are 1-indexed */
 		inode->i_ino = sel_perm_to_ino(classvalue, i + 1);
-		d_add(dentry, inode);
+
+		rc = sel_attach_file(dir, perms[i], inode);
 	}
-	rc = 0;
-out:
 	for (i = 0; i < nperms; i++)
 		kfree(perms[i]);
 	kfree(perms);
@@ -1808,20 +1798,18 @@ static int sel_make_class_dir_entries(struct selinux_policy *newpolicy,
 	struct selinux_fs_info *fsi = sb->s_fs_info;
 	struct dentry *dentry = NULL;
 	struct inode *inode = NULL;
-
-	dentry = d_alloc_name(dir, "index");
-	if (!dentry)
-		return -ENOMEM;
+	int err;
 
 	inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
-	}
 
 	inode->i_fop = &sel_class_ops;
 	inode->i_ino = sel_class_to_ino(index);
-	d_add(dentry, inode);
+
+	err = sel_attach_file(dir, "index", inode);
+	if (err)
+		return err;
 
 	dentry = sel_make_dir(dir, "perms", &fsi->last_class_ino);
 	if (IS_ERR(dentry))
@@ -1873,58 +1861,47 @@ static int sel_make_policycap(struct dentry *dir)
 {
 	struct super_block *sb = dir->d_sb;
 	unsigned int iter;
-	struct dentry *dentry = NULL;
 	struct inode *inode = NULL;
+	int err = 0;
+
+	for (iter = 0; !err && iter <= POLICYDB_CAP_MAX; iter++) {
+		const char *name;
 
-	for (iter = 0; iter <= POLICYDB_CAP_MAX; iter++) {
 		if (iter < ARRAY_SIZE(selinux_policycap_names))
-			dentry = d_alloc_name(dir,
-					      selinux_policycap_names[iter]);
+			name = selinux_policycap_names[iter];
 		else
-			dentry = d_alloc_name(dir, "unknown");
-
-		if (dentry == NULL)
-			return -ENOMEM;
+			name = "unknown";
 
 		inode = sel_make_inode(sb, S_IFREG | 0444);
-		if (inode == NULL) {
-			dput(dentry);
+		if (!inode)
 			return -ENOMEM;
-		}
 
 		inode->i_fop = &sel_policycap_ops;
 		inode->i_ino = iter | SEL_POLICYCAP_INO_OFFSET;
-		d_add(dentry, inode);
+		err = sel_attach_file(dir, name, inode);
 	}
 
-	return 0;
+	return err;
 }
 
 static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 			unsigned long *ino)
 {
-	struct dentry *dentry = d_alloc_name(dir, name);
 	struct inode *inode;
 
-	if (!dentry)
-		return ERR_PTR(-ENOMEM);
-
 	inode = sel_make_inode(dir->d_sb, S_IFDIR | S_IRUGO | S_IXUGO);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_ino = ++(*ino);
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_add(dentry, inode);
 	/* bump link count on parent directory, too */
 	inc_nlink(d_inode(dir));
 
-	return dentry;
+	return sel_attach(dir, name, inode);
 }
 
 static int reject_all(struct mnt_idmap *idmap, struct inode *inode, int mask)
@@ -2012,17 +1989,10 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto err;
 	}
 
-	ret = -ENOMEM;
-	dentry = d_alloc_name(sb->s_root, NULL_FILE_NAME);
-	if (!dentry)
-		goto err;
-
 	ret = -ENOMEM;
 	inode = sel_make_inode(sb, S_IFCHR | S_IRUGO | S_IWUGO);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		goto err;
-	}
 
 	inode->i_ino = ++fsi->last_ino;
 	isec = selinux_inode(inode);
@@ -2031,7 +2001,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 	isec->initialized = LABEL_INITIALIZED;
 
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_MAJOR, 3));
-	d_add(dentry, inode);
+	ret = sel_attach_file(sb->s_root, NULL_FILE_NAME, inode);
+	if (ret)
+		goto err;
 
 	dentry = sel_make_dir(sb->s_root, "avc", &fsi->last_ino);
 	if (IS_ERR(dentry)) {
-- 
2.47.3


