Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA36CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB858E0010; Tue, 11 Nov 2025 03:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64CE8E0002; Tue, 11 Nov 2025 03:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53FB8E0010; Tue, 11 Nov 2025 03:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE1F78E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:21:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60297B6E68
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:21:32 +0000 (UTC)
X-FDA: 84097632024.26.6391D28
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F154120006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:21:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uLAMK0zF;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762849290; a=rsa-sha256;
	cv=none;
	b=v59hE1rbWjJPcJ41/ZnYD79FNl25lhrcbpW8eRnCmoz0PBLA0V/xd0nkk8kk3YFVn2qpy9
	l4EmqLXzGvDLqvkMt7/HLJ6qmTDAbU42rbhT5Df80QTHoZ52obzwHwqR5C/OZD432zTB9h
	tBXZUIbCSZmqaq7N46jTlyDC01l77Os=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uLAMK0zF;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762849290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq3Y9Ln9oN35uhhFeuHIXT1Lyki6mUmJkqCFVG1Nr1k=;
	b=JEkjPrKRcemucKvP/MqqWCetFKKrXEBYLmyMEPMziLTS28/LuP9P+2DuAWcGCu/OInDcoy
	pBuK4IRZxxF5LL+Qt4Ctd4Irj9Kbw2pkzrs3VO7b4z6YG9+ZmAjcz57H8JwqjLRHgEbyBq
	ebZVd3RxvK0VgSZOx3lhlhENu2Nytsc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cq3Y9Ln9oN35uhhFeuHIXT1Lyki6mUmJkqCFVG1Nr1k=; b=uLAMK0zFerBiSsaenZrHEljbe/
	rk8Y8AopEWfD22Dm9hI3hs6eDQ540so0tSl9wAK62G0v5zj/wMzeALoo3rgBPwbzwN+RVjv1FFcLe
	kxWWpxOGGpoiQo/4lh9mcVl+6YpaUm+czp9HdMtNVio8xNOsy5BEQ649BmIIYJqwMDi70lRLWM2/y
	dQDKQ2sP4bTYjFs284TwhC+bYefA3/ZSOPTM2VTpd0ag4mGr/wH0IGNmCzVSjJHQr8Hld1Tqhi6Bm
	y5NYizQdpkJaptKvQiK0hckp83dODr9TTJW9Y8Nsjdefy8sWH29ZHNtxtBGki2L0R5F7hN4E9FCo1
	TCFwQtNA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHn-0000000Bx4H-1b3Q;
	Tue, 11 Nov 2025 06:55:27 +0000
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
Subject: [PATCH v3 34/50] selinuxfs: new helper for attaching files to tree
Date: Tue, 11 Nov 2025 06:55:03 +0000
Message-ID: <20251111065520.2847791-35-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F154120006
X-Stat-Signature: 1edu978ydgq89c476m6nd5jca6e6kpah
X-HE-Tag: 1762849290-676763
X-HE-Meta: U2FsdGVkX18T5LQdIH+UlvpHMe3SZXljbxjM1nqVEMlw6gcwLj7w9Vk2cEnc3/IPwcLPEppB7h+bUgFLRwNXlWxL0lszBc3w5vZYbbQr8gHx41Yxg84OFc8+cqy0hu+rT4J/YIGxswev5FQg4IY86bvWN36XXCLAI+5MSSnY75fceMNPWDf0526dJdbncpColnWE+t2GG0Ae9D99OVombR2WmL72zl0IQ7Z4ZQcuwzwEEuzi2I8TXVY59szGAm2AvOvlK4kQCZOnIJ2KOp0Z1dmGB9IDT5tOyevJuWPFfR29s81VMLK3keXIYcPS+RJ7Ws6JeQ8mLeMFUT1RgxTaG1Hep0H2qU7r2XRaFuyUght3CJzRNVJM6hCd623mYhJxQspc90oS1qKgdiJxtAxLeSEjUpnYyqdjU+osKTrgTMuLld207JkKW/Sj+/3IOdo/AGofkEOx1dk3cXAFn2HuMqfmbRgaiq60aFg7fdMS3qLBRPUUmWBEDsFiEtzwOgYhIc6KJ+XJ9n5Xile65DLCq2Zn6zm+0PPA7yqLm9KOcp5/6G8lsfnioSu1MQ+QsvpBeOVxNuBrrRblRUgkM9jAe9mkWDJG4j+dw0da6Yhk5PCGi8lz7OEYCBpCEq5SwPwOrQ+6S+tMX0LMC0AqAv5CON7zEUJRGP6XEX8MNqhyoBRESik88R06kM2o7AZD6tydPl49ze8ziMNDp3dZ/UwAMqnslKxRqK20COYsvKVAshBL1OlbF+YwC4bkfzaPihdSmH2s7PACUmADOE60b9QBGw09Bl5Wiu9d4FTkzenW8ZMxbhGye4M70+dDSZdMbhPkOQyqRvW1agNfP1fKHlz2zdCZ0kTwRkfPZ7x9XaOCiyyjspuAW0k9P1K2IieOGhOobvvsxDaOW5V/hJU7Zrw/tojurRoO2khO8pvCvPMVEKcKWzNhOcSJ51zu+lA+8ZJ32Av9mOtQh3dMKhsbL7V
 vEITl50h
 VCe7A5RDfTpBowS3xtFvV93gD9fKpbAorIbncQmdNJ7ZYZoHitIKccdLaKxl3Tl4f+x5SrnckGFdOz7Gf6WNodoHTilgVFy+BdoJG/IYtWjwQQguaAtuokFnG3LTJ0wGZq5/Q1pfcWiXmMsM9r59y1+tZO8JPKbWd+NCXy2SxhIcNazaOITlVHaEnNCBinebKjNeGHrGi6MKt6MJae9fWjyT86YAu9CLJkfMNuIef7fzygNaYhWpGkivoTXydJqtasPtpdOa7OQuPdgay0A3bXmF+l8uxi7/Tfq0fkdREHxYHH09BlV8+CeNizCHAHURl5FMhf/f+3K1ouwMXMjOxUm7Ca0Gjn44dV7Y3nrzh5EtXm5XjN3BcP3Dri+XQtoc9hbVhtkzbRLg0lybYaDgYsEv6ENOFWkQjan+JwZAUd5AGy/nE22yZvu065Uy3BJF+McGTYe0NcM8O4RwX6feK1JvHEkfjdxKsLsgokQ1wjdrN7l9X5pwAS3P2Lg==
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


