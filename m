Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACFECAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8427F8E001D; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF618E001B; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6971A8E001D; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 514A88E001B
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 209225BC87
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
X-FDA: 83908850466.30.66E72E0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8738520008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="CuGI/d4s";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UN/hLnhmlCpkyT8pqk8o93EYJOuBVPC2UlrPzhJvYOk=;
	b=SUfO8BXWVp3kZN1kzhXtu5KJt9pInxvXhMQgs82r3xzqlpaVnceTZqys7JZk+ewlCqzf0N
	8z+VwtnCRYoSvAefJtlnqzmVpF4QZHjm8zPCnvuYG77m3K+9u8WS8zPT7TBhmR9BWg3YlC
	csT5yP2anjEpN0m4m7O6kn61SRkXWzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354491; a=rsa-sha256;
	cv=none;
	b=LN0kUd1Y88c3pWrWObvvEc/7e6ZhJ8+oXCRFbs+7PHtIQYI+9qtRy//E4JNpvsRYdAbnJg
	JzdhuKMAxktKx4PM5yvnud5wx6o82CC6U+reSi9Rk04nNLQmigPqijrKUE53SrqG3XugNg
	YcAUKLfTqqzAnMFhcDRwdEsG93xSSZ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="CuGI/d4s";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UN/hLnhmlCpkyT8pqk8o93EYJOuBVPC2UlrPzhJvYOk=; b=CuGI/d4sHECg4YG3QFRhwKGiio
	LZQLZ1AXIY0v2XvKXbsCbePxX3q82OZKpg6vOx/Hz/VGZIfhjGt/HsTLzoILkroLlOL5AHTH6fNaX
	z5m03HHpSlr3GjXUVAmhMmat4/hLKWnGYxShcLURw57cE2opHIKdkxco/PYvshUkM3dRb0NtexIgU
	WE0qEJMxd6DAWz3vBxhX4RVDd8tJiaklJjVtw+DbAtE11fu3yBwpTFpRuLhn4+WRjEl7uTfa0wv0R
	ygYS/byzth1L95yZPqBMRCbAkXlqLmiRbw5W6hEDt6k7/Hx4FEDT3gtOHe4e2CYi3e5Oim0kM0VGY
	/8l8Zepw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKE-0000000ExJf-3qxA;
	Sat, 20 Sep 2025 07:48:07 +0000
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
Subject: [PATCH 31/39] convert selinuxfs
Date: Sat, 20 Sep 2025 08:47:50 +0100
Message-ID: <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sijkjnyhtkrpxzuxwh4yq8mfuqfyz46j
X-Rspamd-Queue-Id: 8738520008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758354491-942194
X-HE-Meta: U2FsdGVkX18LEehXLXyiB99kmZr275v1Jy6nTnTXwcAoOYU24bFGScDd+SYLtwcvb9YxQiGdSvFwwTxy+MGqt94ide7FCyFyYSo9EZGOwMm0N7rUVhhelpZ5J2W4RDGE/Eb2TiOG/kjdaJyThpDTW8JOhFOstfnNLQtMeBVDPjS+iY0li74CzoaFJ0jFG0ji9DCgCvPeiQVusCZ3XdjMRM4e5TUtYGre48A2j7B3jd46GmQSlr3bJ03DB2iHLVy7ahwnRnV43BCeLwaef7qZ4thfWFBpDF4fgzG2jHP6i8fGXcEA6nHk8MRJvAtf5SkejtfU4qa8810FMBdoTKZ5kuk7bsFlE/K+zP6QEXQvRCavf9iVw2YAnolCc7+mb3X3bz+nyM5DIPAq50wDUMwFD+F0pGTmZPPXOidzW0lY1djXGAmUmPqWBO1/PQmxIjhQzBBTZfHJH15DCIcz1uVfRVl4oh53dGkDGnallwcbsrhFuiCqoZHcCqQJ/uER+s4gcavGxjTUofSFHKZK3xEhpBcCppO0Q2NLynuBawRtVqeMJ2I3dDfnls7oCvK+YUJpaZo+3HfYidG2+4Jpsh4Nl+i46echmxEqnl6k7ieZdDnYfa2djNdrKuJcQ0XEXkdoP5ncjVJyfeJv57YNmrwMXSvcUjUrx/9VVBcAuL0f/sGtOuIWmbOYhDxZgoyr9yIEa1kKFGFZVdTwpqe1uJwl0Rt9AYkwALGIZFDfH4jB61wSeRJrkZT0Ql2q+OfisR2RbLYNyuyvUvULNlIwOamJDd2o+eOB4OOtVuLmcwfW3BgAfgIwQ2xnjITrehf+uDp8sFuejV2gwgWz9zvgtdByymq5g0+e1elKh2Q4/i1uCRYuS0MTOu9D8Fut4gQhnb7v/CgdOaWuZugn0ZT3ZwK8X9TB30hYsKmX8oKdvKfI5vjzNP7vft6VJRQ0NPKj61LudogLhSsy2nysSfFLIvo
 75WP4vCm
 Z9/foO6XtZoeYIrKBUxtTWciaA6QTD6RyMBeoZf7ssVNfhNfrzV4jaLgDIjJW1I0ffONG0mFs9J2+ALhiWSdwiYpbsyUvkufid/QXSUosd+cifSdsufFwqR5ftJgyrgQGQh5+OD07vKi/Heub0/MlNUZLiVSdod3n8OudmnssoQlbpOcy48/qQ46EyCoYOzvfVRn7W2xNK/qCQjqALsIjUVsQ3TCGKQso1/e7tJfYy04uQyVLszNJWhGk1WRCFPmsAr0vsXyLF0EclXFDq+yYOwgOlsznMIfJXMO1ki8diWVLC7EnENggiGviGtKb3TddW6MFFE2odbWmkgC8tqvnqCcnZcFKLKuKvlRnvqhswzwWOQx8hUF57zZ+UfrpoqObOJXA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tree has invariant part + two subtrees that get replaced upon each
policy load.  Invariant parts stay for the lifetime of filesystem,
these two subdirs - from policy load to policy load (serialized
on lock_rename(root, ...)).

All object creations are via d_alloc_name()+d_add() inside selinuxfs,
all removals are via simple_recursive_removal().

Turn those d_add() into d_make_persistent()+dput() and that's mostly it.
Don't bother to store the dentry of /policy_capabilities - it belongs
to invariant part of tree and we only use it to populate that directory,
so there's no reason to keep it around afterwards.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 52 +++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 9aa1d03ab612..dc1bb49664f2 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -75,7 +75,6 @@ struct selinux_fs_info {
 	struct dentry *class_dir;
 	unsigned long last_class_ino;
 	bool policy_opened;
-	struct dentry *policycap_dir;
 	unsigned long last_ino;
 	struct super_block *sb;
 };
@@ -1404,7 +1403,8 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 		isec->initialized = LABEL_INITIALIZED;
 		inode->i_fop = &sel_bool_ops;
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 out:
 	free_page((unsigned long)page);
@@ -1614,7 +1614,8 @@ static int sel_make_avc_files(struct dentry *dir)
 
 		inode->i_fop = files[i].ops;
 		inode->i_ino = ++fsi->last_ino;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 
 	return 0;
@@ -1645,7 +1646,8 @@ static int sel_make_ss_files(struct dentry *dir)
 
 		inode->i_fop = files[i].ops;
 		inode->i_ino = ++fsi->last_ino;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 
 	return 0;
@@ -1696,7 +1698,8 @@ static int sel_make_initcon_files(struct dentry *dir)
 
 		inode->i_fop = &sel_initcon_ops;
 		inode->i_ino = i|SEL_INITCON_INO_OFFSET;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 
 	return 0;
@@ -1800,7 +1803,8 @@ static int sel_make_perm_files(struct selinux_policy *newpolicy,
 		inode->i_fop = &sel_perm_ops;
 		/* i+1 since perm values are 1-indexed */
 		inode->i_ino = sel_perm_to_ino(classvalue, i + 1);
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 	rc = 0;
 out:
@@ -1831,7 +1835,8 @@ static int sel_make_class_dir_entries(struct selinux_policy *newpolicy,
 
 	inode->i_fop = &sel_class_ops;
 	inode->i_ino = sel_class_to_ino(index);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	dentry = sel_make_dir(dir, "perms", &fsi->last_class_ino);
 	if (IS_ERR(dentry))
@@ -1879,7 +1884,7 @@ static int sel_make_classes(struct selinux_policy *newpolicy,
 	return rc;
 }
 
-static int sel_make_policycap(struct selinux_fs_info *fsi)
+static int sel_make_policycap(struct selinux_fs_info *fsi, struct dentry *dir)
 {
 	unsigned int iter;
 	struct dentry *dentry = NULL;
@@ -1887,10 +1892,10 @@ static int sel_make_policycap(struct selinux_fs_info *fsi)
 
 	for (iter = 0; iter <= POLICYDB_CAP_MAX; iter++) {
 		if (iter < ARRAY_SIZE(selinux_policycap_names))
-			dentry = d_alloc_name(fsi->policycap_dir,
+			dentry = d_alloc_name(dir,
 					      selinux_policycap_names[iter]);
 		else
-			dentry = d_alloc_name(fsi->policycap_dir, "unknown");
+			dentry = d_alloc_name(dir, "unknown");
 
 		if (dentry == NULL)
 			return -ENOMEM;
@@ -1903,7 +1908,8 @@ static int sel_make_policycap(struct selinux_fs_info *fsi)
 
 		inode->i_fop = &sel_policycap_ops;
 		inode->i_ino = iter | SEL_POLICYCAP_INO_OFFSET;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 
 	return 0;
@@ -1929,11 +1935,12 @@ static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 	inode->i_ino = ++(*ino);
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 	/* bump link count on parent directory, too */
 	inc_nlink(d_inode(dir));
 
-	return dentry;
+	dput(dentry);
+	return dentry; // borrowed
 }
 
 static int reject_all(struct mnt_idmap *idmap, struct inode *inode, int mask)
@@ -1966,10 +1973,11 @@ static struct dentry *sel_make_swapover_dir(struct super_block *sb,
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	inode_lock(sb->s_root->d_inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(sb->s_root->d_inode);
 	inode_unlock(sb->s_root->d_inode);
-	return dentry;
+	dput(dentry);
+	return dentry;	// borrowed
 }
 
 #define NULL_FILE_NAME "null"
@@ -2040,7 +2048,8 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 	isec->initialized = LABEL_INITIALIZED;
 
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_MAJOR, 3));
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	dentry = sel_make_dir(sb->s_root, "avc", &fsi->last_ino);
 	if (IS_ERR(dentry)) {
@@ -2079,15 +2088,14 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto err;
 	}
 
-	fsi->policycap_dir = sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
+	dentry = sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
 					  &fsi->last_ino);
-	if (IS_ERR(fsi->policycap_dir)) {
-		ret = PTR_ERR(fsi->policycap_dir);
-		fsi->policycap_dir = NULL;
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto err;
 	}
 
-	ret = sel_make_policycap(fsi);
+	ret = sel_make_policycap(fsi, dentry);
 	if (ret) {
 		pr_err("SELinux: failed to load policy capabilities\n");
 		goto err;
@@ -2119,7 +2127,7 @@ static int sel_init_fs_context(struct fs_context *fc)
 static void sel_kill_sb(struct super_block *sb)
 {
 	selinux_fs_info_free(sb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type sel_fs_type = {
-- 
2.47.3


