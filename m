Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA8ECAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDB78E001B; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86938E001F; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9148E001B; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948058E001E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D238BBF91
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
X-FDA: 83908850466.25.A9A24E4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA4E81C0012
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ES1ypYew;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGdn3pDf8wghTLyVVy97E3Od3T2X2/193b6JKjN8NJc=;
	b=Mj9STI2XwI2joJu7FRdlsBERevF1nXvQZUCSrVl/koEL+TY8VQRbiBCcrQFQD6U8UutRij
	N2b8qaFeggb087eT80xjcupUNAUJswUhh5D1Y4Rts72wAIqXleXkCz/bBhAp2c9wPP9fW6
	xIke3tzKuokh/WJgXqQPqXetNZ6M3fE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354491; a=rsa-sha256;
	cv=none;
	b=O83/Ietnd3gwG+PguudvxiUdItOXbsS2lOJEy2vUspA8DXrp/jM/dGNyK9/ki9Aa2lRxlD
	LRhBN0YdWBIqKTPRw7ceVXb86JwEPRmfgKvIfttcFSPwbGCWB/LmcF1Vg3d6rmFf19zeRR
	0ypbUaddSsIbC0NtjVgkmnaE3SpR4xU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ES1ypYew;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=RGdn3pDf8wghTLyVVy97E3Od3T2X2/193b6JKjN8NJc=; b=ES1ypYewlxE4YxFxiXZsSeuaaO
	QmL30fu3tKL67q+jWRnATpt28gt0tDNlwLkl+UaX4okIB8+IzPJjZJx4aD39bIgOHA6tjvcF6Xn8t
	k120QnYKtxTChAUqnIjDrgaaLtPoymCw7Hk/UjBmXi40nrdHntOkpMbFzUwMgwt7srrzn6Ydw4fGK
	uDz5fJ24pn2lkwybkV4FwBlpyI7Ac/KA9xOxowP8jSgVrFyK0W+dv89U4ChXqTlnGksKO0eyQthUR
	WzpU0Z6leh2CqByrRDmou0KyQdY2e8WqNyMFR2t30SyeagGsXnU1XnTGgvrMc1wclIQUz45XBncCF
	o4CYzpKg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKG-0000000ExLB-1Exi;
	Sat, 20 Sep 2025 07:48:08 +0000
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
Subject: [PATCH 32/39] functionfs: switch to simple_remove_by_name()
Date: Sat, 20 Sep 2025 08:47:51 +0100
Message-ID: <20250920074759.3564072-32-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA4E81C0012
X-Stat-Signature: 1aqri9wgxyxe3816buw84xkbg1grsmf6
X-Rspam-User: 
X-HE-Tag: 1758354491-743365
X-HE-Meta: U2FsdGVkX18UY4l6G20knj1hzl+2Z27KV+mMro7lKrLhpuKAWbVgYvEXN5HMPwqqbByFPZoUz8N1DYFr8SK1XMpX5iKSum1IG/LicxUtVThqz+d2/LXzSPtm59lWNhLbnyp3oys6BEGW7OFh28o9CgI8mWTle/l/Kz0rSbUhSbsTixjnylCr8YRNiIhP7mKM63K65O4G6DHH8CxF2C2pveUs8uG7p+hlj6XGK67e60m/RlnNb+jGLVGTERWeR77b7lMpI5rBT8aS3Ue+H6AVtVafbnxWj5j5HYtL/Dk64XCYCaD/Ze9svOOCuF83KoKoCSNqGRl9+3z8mQ+lzYlGJieuecfNq6Nxzlj6Z3Pql1UOzxbKPCAsFEnAU/0vLgAJgO0PJTXfA26ufVp1ZrxrgSoMzoEZp1IJ4+c4HdrV1cRvn++kLoLJ+88XiQvvqTgEzinrEXbQWUbxz3MXih8iJnEsbBKN/C/aj0aerV1ONrqoF9VjsdRmIqSAWxO45qxzpije62Cpxee42QAv8S59CzAFe6Klwo6Qj98s6w2wd4BHCTK/XfBLiIwgb6mYJcLxot+hkrEezLO0ru674nZHyvAc/ik8BIaKKhSSujAqHqTl3MD4ApV2HeJRMti7xSmTm5FtIQW/JWYLPCux0ljFV1f63ZGeOKKF/kd0qKlvylXKssFM+17eDkc+XS4AS5kA9ALayje6MwnTwj7Elv9DI3NQaYQOppo3orxHwJGSLr8RKInuMYoOtOQ0XPQ+AaWTdrsd0QmcTS7OMNSKTKIUhGAGY3Bu4dIOPwdvGLTR4kpT2XxCc/avezzfC056GPaL2S+LmGHCIIBjr7ySXsvVxsqJ/2RYaBDttvRgadomwMEt/qCHwpctO9iap8fZV9BKJVzSZQdXCUhN22NVW7gy5bGuloGQmaTiH+FBpJ9AI5JfRV3POUv3t/7qM5lbkcJMHFl9SFSR+pj2ul5Y6ku
 Uq7XO9PL
 6brHjqgZv2JBrd/h8kTiSznW0Gmmide91Y8fQIkXPPza/nN6Y9VrpiRmtnlIbav2bMV+1fTCfYsDTanJedb3AXqrP3HJ1BFxm4cvsMqRmOWfd1Bm4ytGdUG8jjzElRLbXpFUlhI361zRZyX9kSrBafMSRb0fCpTPVNbOO22PDxjL09XnIeRaMSJaRpm5TOubclRA5Uo5NcIedg/Lsf8Kg6XTXEKI+ihmDGbGSPLm+C8v+fBaBit2rCuGpO0PfQJs/dNQmqCwvs4fSLO5n8raNOPjP2UxtNfw5lsBvKoJvrE5So/BOz6Kz9lztdJQ2BlNcdrkBTO48jwBffn+b8vjYkZ2Xt2TOIX8LyG7FoPWZES7KtR7V/2hMpMgSDhFveY4WWEdPtsEH3XwX+SeNTPLwtZcuO/MWfbWE2Ucaq+NZWQIIsPvvtUKq41NBMVT7V13xHzSmoEk4ReJ4LkJIPViglA3+ADzIEV7UVIyUImTRwrsw+8W9/tB/QHK0olHhR6MbP5kOMwOauGZeIsGSjyBqatTHjXvaxjPAkTSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to return dentry from ffs_sb_create_file() or keep it around
afterwards.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 39 ++++++++++++------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 08a251df20c4..5c9a7bd4e41e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -160,8 +160,6 @@ struct ffs_epfile {
 	struct ffs_data			*ffs;
 	struct ffs_ep			*ep;	/* P: ffs->eps_lock */
 
-	struct dentry			*dentry;
-
 	/*
 	 * Buffer for holding data from partial reads which may happen since
 	 * we’re rounding user read requests to a multiple of a max packet size.
@@ -273,9 +271,8 @@ struct ffs_desc_helper {
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
 
-static struct dentry *
-ffs_sb_create_file(struct super_block *sb, const char *name, void *data,
-		   const struct file_operations *fops);
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops);
 
 /* Devices management *******************************************************/
 
@@ -1866,9 +1863,8 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 }
 
 /* Create "regular" file */
-static struct dentry *ffs_sb_create_file(struct super_block *sb,
-					const char *name, void *data,
-					const struct file_operations *fops)
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops)
 {
 	struct ffs_data	*ffs = sb->s_fs_info;
 	struct dentry	*dentry;
@@ -1876,16 +1872,16 @@ static struct dentry *ffs_sb_create_file(struct super_block *sb,
 
 	dentry = d_alloc_name(sb->s_root, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	d_add(dentry, inode);
-	return dentry;
+	return 0;
 }
 
 /* Super block */
@@ -1928,10 +1924,7 @@ static int ffs_sb_fill(struct super_block *sb, struct fs_context *fc)
 		return -ENOMEM;
 
 	/* EP0 file */
-	if (!ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations))
-		return -ENOMEM;
-
-	return 0;
+	return ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations);
 }
 
 enum {
@@ -2323,6 +2316,7 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 {
 	struct ffs_epfile *epfile, *epfiles;
 	unsigned i, count;
+	int err;
 
 	count = ffs->eps_count;
 	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
@@ -2339,12 +2333,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
-		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
-						 epfile,
-						 &ffs_epfile_operations);
-		if (!epfile->dentry) {
+		err = ffs_sb_create_file(ffs->sb, epfile->name,
+					 epfile, &ffs_epfile_operations);
+		if (err) {
 			ffs_epfiles_destroy(epfiles, i - 1);
-			return -ENOMEM;
+			return err;
 		}
 	}
 
@@ -2355,13 +2348,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
+	struct dentry *root = epfile->ffs->sb->s_root;
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
-		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
-			epfile->dentry = NULL;
-		}
+		simple_remove_by_name(root, epfile->name, NULL);
 	}
 
 	kfree(epfiles);
-- 
2.47.3


