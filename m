Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183B8CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 22:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743208E0006; Sun, 21 Sep 2025 18:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CBBB8E0001; Sun, 21 Sep 2025 18:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BABA8E0006; Sun, 21 Sep 2025 18:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 483468E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:26:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DC3986D74
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:26:29 +0000 (UTC)
X-FDA: 83914692498.12.8C3EA0F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A0B1100005
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:26:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=usSSiHDQ;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758493587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlILJqwe+hl8iDH5chyH6rCDu8EauUbPjDhI89Nes6o=;
	b=cwZKg23tIK4Y7RDWjxcRmv57oSz5cdH4IFxIL7iqd4qG0QjdaOETRLPb3E3sWJNojjjLyF
	swr+czPLPaEx0SGX+vTD5xY59cSEUQZithV51IcnM447t/MYHVbJcwV10YFPumtC0EUcI+
	hISSVO/+d/Fd/6cs/Jk8QOKqPnWN7lE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758493587; a=rsa-sha256;
	cv=none;
	b=uIB40irSo2VIo1TIfhhArnhAf1pkl1AYmLQ6jeU1EYD8ncJSKrRSU/WIE7Asmhtb5gma8+
	DvdHW1FgnkuFCS17l7TE6catfPAMCxqIr/wkMVhldqNPoCICKXjQdDN080BFfF3ME5cRS1
	n+sizwcBnJxIYLy8nZub/IV/b4qUS48=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=usSSiHDQ;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=vlILJqwe+hl8iDH5chyH6rCDu8EauUbPjDhI89Nes6o=; b=usSSiHDQ2Qbq/moPc13PFOUsWD
	OZvJvj3RMtsst8Itt4LV6ByI/pzdDEGYN59hMSjI9D0WKjMpT8umQJlX0udr+u4Z6EjToaCR2MjnL
	JebpsLsLxysXhYvgIRefuiFMxaAfazcku591eCGxw6/Bs7jzvr5ECie8rG4QZaTP+dCdYplQgGebB
	YeDuAM/mp6sz+txh4iD92ykjvSJ0E6qNuH5HhVaoO7funuh+WDy1Dw1yHMep3uwkJGBdVEjnzoTwA
	wjFjO1cvVgjL6w9gvL00vzdQ4iPjYVLDWXrxzvViNv4wuO++/Zm/0MKeyjfWXJDfNuQ+w27Vk9XKP
	fM2DzG5w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0SVf-00000003poQ-2RiS;
	Sun, 21 Sep 2025 22:26:19 +0000
Date: Sun, 21 Sep 2025 23:26:19 +0100
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
Message-ID: <20250921222619.GO39973@ZenIV>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
 <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
X-Rspamd-Queue-Id: 1A0B1100005
X-Stat-Signature: 8cmisfrcnxtyt9g1y4undpjymbymkwi5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758493586-540591
X-HE-Meta: U2FsdGVkX18HnC2Oa9yUF3Zq0TepE/LbsISHWbwGTFHTFC5p4mksKuXcTpYYEZBYNuS8HKcYl3x7rCfYHCLc5qxFTT6UXAjDyJrySS3TNGk6Gch7cNRRxRFgHCtjZZnF8pxNH4nqXWfMpLGiJsYHHmyRjI0RxBveGr9m4zcXV2crv/AMKJDAgMSmfA9rJK33AE9c7ctBlv4QnMoJBdQmvwJAyxuA/nH6PKGsG6ekKtH82IO9DF2kXAr3PI0Z+G/9U6/OlJ822kNaCW1Mr42Hfc2rlJaHUjz6e3+KkQmcwUDIXhG3Tk6qlbZ9kxoT1lY63Rww61qvne3aQGKV5giR19+JXXfp0KuXPz5tTPkaTNvJrcqXYF/kkwmcr5wVvrvfjtHlUgtnAXKbboQiWrdxrU7u7Y7a9FndU83m7lsq2i8iaQg4i/kiLodRU/FPXTWCZrVDratiJhGy1FZeC0AomDk/orK79k8kbjTb73DUIJQpwoGcxu7IaxvbHdfeWepQCtDyR//BD+8zFsN6NCA3X7zDXmbm1uyZF3Clhvehtud5FW6FL0sn4a4pLyLynadMK5kUSt55WU3fjDqjBlrV7eVP9nKKImR9xx8t4koYq6YIg6t3/KqrksGBRW/LBMD3xvt8nHYVLIRKmnt4OsxXARRLS7Bs5Nzt4lv8rgfQ0INx3JJw/V7KlZrzSBZ4tVZCOpH5pb1sS1ZWQtUCNQPrKixIdFCklW8aXdnGhFHgywQQPKoGfo+PlJfb4j9ZmT+QvwZ8OSqFnenIps3NKaBqjkJ2xE3q2MRbiJEL7ZVryZ4EvqfSGrwZfGvmUeZUV00UqZ1g7MCH8SZbzXSxqsb0C6xq2Q+IzyMBKIT9HamXe6v9aEGDlM0HrnBgFs4XKLPejjVvznRsIXpgPefi7LWEEe+PXKOOEskEUt/L/kwqPM7lsUxgHDTtV5aaffaVQKo/thUaqfWiHX/RCjlvAB1
 ht1m1e26
 ACKsJYOGa48Xb0DbnHiNcEaCjUWUTYffY6WqTptIvxCelvDam1HzFz7hsvAE7YXwzEhhcN+6lPRkNsQEc6oZd5lRKaTjBo78Ilo1OPa4/4UbgVL8c6CY4SbJ6DxiTdbLmRVW4qD4kCwrDt+ChbvEW4UbL2hKzXOncbbRwTdXeHWnsvRrXQGnkEHkE93pY2OczbovSFy8aV/+NYVWVQI+FsAoM7OfRXC8mWOpFjaKx7EEwYyN20fHOjteBEnDhgpknYugI5Plbm9iGVhAtaQ+38AeAsypBiCVJR1BFC5YCw3t18kwvgGrfsMPqLmN4uZmuyPjX11qCtP4MlDmVuMmryy62W+/DPI0ST0D2XBmgfSzGX5cK7q6JJ3MTk/thqIci4uMc6yOpvONd3NAaPQ5Cl4TeDucZhFLDui8rO9TMapfr4Rxpxhb0aDnFoLH/bho1SVqChhj8HMjZSERxZPCPZII5/WpOLULr+6cosVVu27vP8134Ipjoi5fb+sJ+EK+T2Rs9kSxzB8lSeoo4WtF/+Z9+pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 04:44:28PM -0400, Paul Moore wrote:
> On Sat, Sep 20, 2025 at 3:48 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Tree has invariant part + two subtrees that get replaced upon each
> > policy load.  Invariant parts stay for the lifetime of filesystem,
> > these two subdirs - from policy load to policy load (serialized
> > on lock_rename(root, ...)).
> >
> > All object creations are via d_alloc_name()+d_add() inside selinuxfs,
> > all removals are via simple_recursive_removal().
> >
> > Turn those d_add() into d_make_persistent()+dput() and that's mostly it.
> > Don't bother to store the dentry of /policy_capabilities - it belongs
> > to invariant part of tree and we only use it to populate that directory,
> > so there's no reason to keep it around afterwards.
> 
> Minor comment on that below, as well as a comment style nitpick, but
> overall no major concerns from me.

FWIW, how's this for the preparatory part?

commit 17f3b70a28233078dd3dae3cf773b68fcd899950
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Sep 21 18:09:48 2025 -0400

    selinuxfs: don't stash the dentry of /policy_capabilities
    
    Don't bother to store the dentry of /policy_capabilities - it belongs
    to invariant part of tree and we only use it to populate that directory,
    so there's no reason to keep it around afterwards.
    
    Same situation as with /avc, /ss, etc.  There are two directories that
    get replaced on policy load - /class and /booleans.  These we need to
    stash (and update the pointers on policy reload); /policy_capabilities
    is not in the same boat.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 9aa1d03ab612..482a2cac9640 100644
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
@@ -117,7 +116,6 @@ static void selinux_fs_info_free(struct super_block *sb)
 
 #define BOOL_DIR_NAME "booleans"
 #define CLASS_DIR_NAME "class"
-#define POLICYCAP_DIR_NAME "policy_capabilities"
 
 #define TMPBUFLEN	12
 static ssize_t sel_read_enforce(struct file *filp, char __user *buf,
@@ -1879,23 +1877,24 @@ static int sel_make_classes(struct selinux_policy *newpolicy,
 	return rc;
 }
 
-static int sel_make_policycap(struct selinux_fs_info *fsi)
+static int sel_make_policycap(struct dentry *dir)
 {
+	struct super_block *sb = dir->d_sb;
 	unsigned int iter;
 	struct dentry *dentry = NULL;
 	struct inode *inode = NULL;
 
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
 
-		inode = sel_make_inode(fsi->sb, S_IFREG | 0444);
+		inode = sel_make_inode(sb, S_IFREG | 0444);
 		if (inode == NULL) {
 			dput(dentry);
 			return -ENOMEM;
@@ -2079,15 +2078,13 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto err;
 	}
 
-	fsi->policycap_dir = sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
-					  &fsi->last_ino);
-	if (IS_ERR(fsi->policycap_dir)) {
-		ret = PTR_ERR(fsi->policycap_dir);
-		fsi->policycap_dir = NULL;
+	dentry = sel_make_dir(sb->s_root, "policy_capabilities", &fsi->last_ino);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto err;
 	}
 
-	ret = sel_make_policycap(fsi);
+	ret = sel_make_policycap(dentry);
 	if (ret) {
 		pr_err("SELinux: failed to load policy capabilities\n");
 		goto err;

