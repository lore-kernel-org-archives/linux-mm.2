Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376E9CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712C68E0005; Sun, 21 Sep 2025 23:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA588E0001; Sun, 21 Sep 2025 23:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8528E0005; Sun, 21 Sep 2025 23:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF448E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:52:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC38C1604A7
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:52:29 +0000 (UTC)
X-FDA: 83915514018.30.39993C4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id DB39820005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:52:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HRIQZ+mv;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758513148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvOBcE6UQrpI6WGthIQ2mhhrrb+ib1iPppy0esW2pF8=;
	b=EOtKWfKKN4Ct91jELAaStZhHi0saYzvfNJczPiqg8AWacbmMrwDEhjnyjepWfkNMTYoB2s
	mxNtnecnWSnXj3syIKSMA0uRfT3MWztXCeT36Fs5eaTtfAE2SYQ0LmXfDv3SkoVdTYp81A
	K5613YVUASjlE7oloMPJ0OL1scrnDP8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HRIQZ+mv;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758513148; a=rsa-sha256;
	cv=none;
	b=WEzP+U2iyg+1bkuYjE3Jg5Gn8xpIjmhNermc8lSqzqRSa+72Vzyhng6TDQxsBt7hcIw/3u
	VkGOuzuCIkRsCTu8KYAx0rUpelWRyBjTlioZa9muflrVl/w+STt4ESjUT/9comfFgjcE41
	BIUJSRUsxKXPawwWWFfLMEZ4tlv4MpY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uvOBcE6UQrpI6WGthIQ2mhhrrb+ib1iPppy0esW2pF8=; b=HRIQZ+mv3XjEr5HE95zUXo4+a6
	NSRxPd0KrHJeiO55wmL8zxyLexKaYOtukTqYDUk4P7Wms504VRDpnu79qCxm9LPPLIvXhPbJDCS9J
	YRDvUR+wf4nDqbVfzd55z89ZBt+992gTBdYH/kADhegMyk3HdwQFQNcaBQPMTq94apRnfURggWfW/
	JHqnvLMVP0BaRB8Hc5glF+yhqEgLGpQ51cjWLVzIBoXc/Te8IX6AprfxOgc+nyojcMBMgjxAohGXS
	cfa+R9tgKpxmrTagksJYExY1jTrB11KyU7eGcwAdbKgV4ytOY8lJPggIhRGBTZNeJw+hKdXevicaO
	50y2/Udw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0Xb8-00000007I6X-2KnX;
	Mon, 22 Sep 2025 03:52:18 +0000
Date: Mon, 22 Sep 2025 04:52:18 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Subject: Re: [PATCH 31/39] convert selinuxfs
Message-ID: <20250922035218.GP39973@ZenIV>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
 <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
 <20250921222619.GO39973@ZenIV>
 <CAHC9VhTy2j+hkT24hM1J2GH+12wp63DArRo6BGTvTwGX2k4CnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTy2j+hkT24hM1J2GH+12wp63DArRo6BGTvTwGX2k4CnA@mail.gmail.com>
X-Rspamd-Queue-Id: DB39820005
X-Rspamd-Server: rspam05
X-Stat-Signature: dbmwgcp4gf7z9jus4dn1ob6uaftti6sd
X-Rspam-User: 
X-HE-Tag: 1758513147-928916
X-HE-Meta: U2FsdGVkX19EcipbHrxYBU7HAII1kW+hRdyH16NR/wtProPLSKkn+Y/T/NTorR08kBeCQePeRLNFrzsVhmfCcA3mEhcN6gZjqrVH3YEAzHt7NUkmzDsad7D2aVI9Wvy8s7pOkGSpOzpigK+dQ6Y8+/XRFbx4oO7tnptsQxLU+olBzIoBQC89wDYNVZ2JaKcgnP1rgheralqy1af3WOJnZ2WE/zmgvkxU3nMTGQvrDV5KPxxl1rpdzdsNOPdlzN1LlcYtcdJ/uM2RQNSn97XEPaa7u+KHTcsYsh/H+CV/rB1aLUAZyaKkz5sbsqplV1K6XxFkTU/XB1SX3Z4fmVw2gzY7xMXDy5nc6OefA2LSngvxS5doHhGPoI+Xd0rr1TgUu7sUNjdpWiVBPtCbte2Sq75M4QHDxrFx7krs0AaC5GzblCFAaQ9RM6a0ZnyCtdQXQWLUGOwYdVL55Rtlz4w2Bypqoivq2cW2HEeBZuWucftTg7EBQODSLf1KRSqTB736fFl9W9q6ogTgUFLk3HPOEpvPkbfrRiEEGFDts233JmhYlsnp+LUbMfukPzMiIONPLBwy9RR5eKU9T7OYTz8KknMZbWR2gdInRKf/gq0m98rUBNWVRQ+RDuuk8zu7q+VTZOHhzz53bu68hj+beygqWOve8mBPibx1e7CXxhScnZSiCPpdb6wuq9MDa8uWpr3I0rAM1IPqMUzigJyNAdiLPklpWIIIDlQ+vWcQqMYF6yUdVVd3tG91EIMNVAA9tTOIvSY01KcyGWIUFdpoMItofVnp5p5rHct5OzXbzdZy5ASZwCLYOP/hlAkG7nWgbf5fyHPQbzYQPTuIj0HC8/OL/QVi1YNKosoNyXS6QAcY9CzKDrjJGVSO5GFF/nRyw6M1FQPfR9XcYVt2eNrPgGiY2353j5avEACPuJubXMAXkV3hmyzcN6MwEojfmp3I+vAA2B2cGugYPPcL2O36BZy
 /xo5PWHo
 YyHPYP8dvdu7SUjgebH/Pt8VLCl2T6JaojbntCnGsdIuMcHAqGmoItb/J6ll8INjhC/Xdlsj1uTelTxx+wEXPGq046c/NK+evrCAeOYx36NImcwrbrIWYF18+0jb4n1HWjHR6L9cm91FhpSy5jAdw/tE9wxs/Hilwk1lgg55YLZqZxMXMqKyfTiARIr7w8MId0sTFvxeWNFKGZoiZSl/WD8GXSoZBuTTJJA6AOX9uW2HAuwgX/PgeQH/UW78AvycJm7Uog5mlMHjKtswn3oogfrv/U19m1/ohfPN0pGRPP0W9oJ1XEF0iKFDjXRTvrtVRMk/DhT4oOhAa3lNRP9V4hkIzwfDd9btqNCYXW9nOffaIPUrtevHta6abgb33RN5xa7hvIT1NS0fwGKv0vbMG/3tWZDYZHzTaeffU0YVqGghuZ+phpLVORpGj0spbv6a2Hdi1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 10:50:02PM -0400, Paul Moore wrote:

> Looks good to me, ACK below.  For me personally, it's a bit late to
> take non-bugfix stuff for the upcoming merge window so I would defer
> this for a few weeks, but if you want to take it now that's your call.
> Also your call if you would prefer this to go in with the rest of the
> patchset you've working on, or if you want me to take it via the
> SELinux tree.  Let me know.

Seeing that it's already a 41-commit patchset (rpc_pipe conversion pulled
in, now +1 from this split) with several more in the pipeline (securityfs
conversion, for starters) and it's -rc7...

I think I'll post v2 in the middle of the week, but aim for the next
cycle.  Rebase to -rc1 as soon as it comes, post v3 for review and testing,
then shove it into -next.

Especially since #work.nfsctl is in -next, so hopefully by -rc1 there won't
be any need to put merges in the middle of the series, with conversion of
nfsctl included into the series, bringing with it removal of kill_litter_super()
and (hopefully) "give configfs and apparmorfs private copies of simple_unlink()
and simple_rmdir() doing dput() instead of d_make_discardable(), then make
d_make_discardable() complain about being called on non-persistent dentries".

Speaking of additional patches into that series: AFAICS there's no reason
for selinuxfs to allocate dentry before the inode.  Doing it the other way
round simplifies the things quite a bit, IMO.  Something like this (as followup
to the previous patch):

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 482a2cac9640..7bee2d8bdec5 100644
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
@@ -1364,8 +1383,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 	*bool_num = num;
 	*bool_pending_names = names;
 
-	for (i = 0; i < num; i++) {
-		struct dentry *dentry;
+	for (i = 0; !ret && i < num; i++) {
 		struct inode *inode;
 		struct inode_security_struct *isec;
 		ssize_t len;
@@ -1376,15 +1394,9 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
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
@@ -1402,7 +1414,8 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 		isec->initialized = LABEL_INITIALIZED;
 		inode->i_fop = &sel_bool_ops;
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
-		d_add(dentry, inode);
+
+		ret = sel_attach_file(bool_dir, names[i], inode);
 	}
 out:
 	free_page((unsigned long)page);
@@ -1587,6 +1600,7 @@ static int sel_make_avc_files(struct dentry *dir)
 	struct super_block *sb = dir->d_sb;
 	struct selinux_fs_info *fsi = sb->s_fs_info;
 	unsigned int i;
+	int err = 0;
 	static const struct tree_descr files[] = {
 		{ "cache_threshold",
 		  &sel_avc_cache_threshold_ops, S_IRUGO|S_IWUSR },
@@ -1596,26 +1610,20 @@ static int sel_make_avc_files(struct dentry *dir)
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
@@ -1623,30 +1631,25 @@ static int sel_make_ss_files(struct dentry *dir)
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
@@ -1674,30 +1677,25 @@ static const struct file_operations sel_initcon_ops = {
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
@@ -1779,29 +1777,21 @@ static int sel_make_perm_files(struct selinux_policy *newpolicy,
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
@@ -1816,20 +1806,18 @@ static int sel_make_class_dir_entries(struct selinux_policy *newpolicy,
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
@@ -1881,58 +1869,47 @@ static int sel_make_policycap(struct dentry *dir)
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
@@ -2020,17 +1997,10 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
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
@@ -2039,7 +2009,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 	isec->initialized = LABEL_INITIALIZED;
 
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_MAJOR, 3));
-	d_add(dentry, inode);
+	ret = sel_attach_file(sb->s_root, NULL_FILE_NAME, inode);
+	if (ret)
+		goto err;
 
 	dentry = sel_make_dir(sb->s_root, "avc", &fsi->last_ino);
 	if (IS_ERR(dentry)) {

