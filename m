Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C90CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749558E0037; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CCB8E0036; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAE28E0037; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2B18E003B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3684012E896
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.13.D8060BF
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5ECDE180002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=lirMygng;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=7qA3I8Xrs+pe570ZQEsOYRZzNbXWgP2gTEqI6nbGK5lBqNWp50hVh7Qlae7b2iCSvdkMwa
	oqKExvtUp/WyFGaTbuSeUmlNEQ/tWznLor7D3OAehzUli6Oow63EODyxw4Dnc6isc0rrUc
	fD9Ms+2uZzdPO2eZ/Sbj8LgzqBjPQJ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=lirMygng;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq3Y9Ln9oN35uhhFeuHIXT1Lyki6mUmJkqCFVG1Nr1k=;
	b=jdn63tZOgUHG2YY+wpGL3Q8GB1hjNEIoUvJ0JzABjXjeuHJCfEGc+JgrvE3Hxlqlmtwude
	hHeDce+9PxX1LFzHAFEuMWSOR48KEo6UGt7GT7wCXiOGLPJ31i9EWPqrLxDWExvZGMSn0p
	k7BLJ/82dvIH5iNbFyh/+hXtMzPzhS4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cq3Y9Ln9oN35uhhFeuHIXT1Lyki6mUmJkqCFVG1Nr1k=; b=lirMygngoPpV5nhRxhbH4z1mIy
	hlsDjmDWWyE6nUtfUVQPv47nC+/WrEZJr7nDeOysNbnSezFLSrDDz5zP8bgxXHSS5kNCubOa/03mx
	qCP5tuHeyL8zVsljBmH+7tJhHfniiILfb2Q5UvSweK9MHOqiSPNGlncGf4h7f4s+2zlKWvoxZmnsA
	isrL97owOKHiEc3waHW85Hf3xim29p6lbc1QKE1jzZcjx7VW8CjtUOPEBl28F6UTZnks+QcHRgcjb
	Vp4tB4PbayjOYppvwRLnPb96idjTfPVtjWV2z4VsQN+vLGJ3dFR9BViIoT8/dVE6I1CFNQgWaMU4g
	lT2qeQQg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GET4-3GuY;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 34/54] selinuxfs: new helper for attaching files to tree
Date: Tue, 18 Nov 2025 05:15:43 +0000
Message-ID: <20251118051604.3868588-35-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5ECDE180002
X-Stat-Signature: 5wxmaf4b5dmf55tqr6ywqa6de45tohuz
X-Rspam-User: 
X-HE-Tag: 1763442974-296135
X-HE-Meta: U2FsdGVkX19kY/uTuC0bfoxjVjz/+ngDT56J4afKXAgS6tzot3Q8M1+Rngxa2z2VyqqCASqi4R9JbimkWRGE1QblZcBw+C1RGsEZ6N3qbZC9o1NCgKHVJ+5rr5G8gQvrgh77M7f3WQhJQlFXJlxTYzflSV9U98rHznDLy4PX2dy74MBelpSwWW5BHAo8eXNtUOj7+BdWCRHYVbLUi+mnqnfXJ3DOeroRcikbuRA7ElSP62rtJpsFrTEXV5GH4ncsA5ZS7+DgSACLCLiyt80uDYLfwJdnpVFO7xW0Rc75S4nfnL0h3Jm5andymi6ItxQVFh8ZOwMKEkVaCfWUbuwclUtUw5SepLRdjLdsy7maiBiGxdfCTc9TChYJoiFk+3nKcUkLAadF+bvAKusD+6DvaOkSejXkT2MYjLUzLZReqro9n4XtTUu0yNBx6eqOKZevFqv9MhZ4HaDvAa+sYDDeKREfwNZ3PphK3GS5nwCtYxFEqTq/KhueqltvkGYF5hoakHEEpTxVa5ZPe+ij1oP5isEQYRhlHpT4EMqqzK8hvBOMzFTFopJhcV3Gu5UHVwkRhU/YFmldBO9KA/wAh4/6LN7C9hPXU8AV4oxzXssvQy2zw1u2Re323r3/tiLAa5xRdLpl3wSrjqGYdFPA297M4GmbGeWsBnSRtlOxElG70WUsP0pltdgYgG3OicSGfWOPXA87l5Xh/5GFwfaBxiiSzc7kTTYzZZ21E+cO/HoayZFphgl5WZTaXD0DvFsf17ljOkTazJEVSGky+bsWkJS/By3KZyE5SrJqpmEGZ+W0HsA05UjdWO2Q7tsKRMTSQPrdbTjkaBRLOBi2UCXVPay0nY2edMJVa1RH3osO0rmkYeOkUkr14J7AEHGIDwlEwcTkMS4MW8Sq+nHCCDh8giA196yqZdaEbxpOvITw4RN4PCBhg0o79m9MwGtC+u8VcTI/cSxjALycoM3NWhkj1YP
 9JnFlmDj
 eOyoDlVSjI5KWNk56jSbqNKK9VVIfozpcPKPbV6jgpwiiAqKdFIhr9jPYC79YnEymd/M595IUbn5gooYNvd+5zfkOOQNjx0gj6GzXl/7x+4JoU67BYdOfeT04qQV+cfQijy2hjAGT6sanQWsEVNiSyT4TOpbXrlHa8RIb02pJ1LS97iogJIayVqrZNcDktkJ7lssIVODulkTFOF838BCEnPgVyswuOCaDwXPeflScPNZnYfTN1wl4b+ikvvDFmEDO74Dc7nbtbjippq3GyEs6gMFx43w7axJjF32Nd0UDJLMyR5IgVvqKfBHGoay8yotLxjbHuKb1l6to60QWBrK+nBmghO8cLwuqXehueGZkrcONkwCHhMn/RqYLNnLlF5n0RMbrlinWbLbpld0E1SlM6PwYTyFEa+XcKUnPy9GiIQQ0ZNf3tGHH+9bQENIUrurdKQWQP/5X2Nh2ALTJsguAqerUgKe8OJOJIK1WHs6KBwCK+KEl5RKWYMXBFw==
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

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
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


