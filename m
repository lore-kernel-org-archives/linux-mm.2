Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D02BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA6880112; Tue, 28 Oct 2025 00:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AC9800E4; Tue, 28 Oct 2025 00:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A5180112; Tue, 28 Oct 2025 00:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80969800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:51:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D60F58B63
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:33 +0000 (UTC)
X-FDA: 84046299666.11.0B549C2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BD7814000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BIJzKyxX;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761627091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4qEZ4zuN1IQZW5m6n5c8L2VCbvMNXRj9zx1XhqyIgk=;
	b=wp9JZx6VPCLm42XUDo+cSoDaoAgg2C+7rNDoJNo+BvCvvp9cU2JwG/TBODAIFoARBkoOpd
	I7vatZtLOnJIFWI+qG6goZgtCa0ljmElvTualiTHULJ/bE9LhdbrPT4tv3r3XFHD4U8l26
	mOL0XOjQCnb20QIuPchfGlb0GdoN9T0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BIJzKyxX;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761627091; a=rsa-sha256;
	cv=none;
	b=cdzdd7Ia8kFFwSohOjy4Qw/C4dfNxiLiiJeTTM81qfnhWy0vJDo3+S6HcrqIagUxBsPIAt
	lsd46eLbLwDmcxWfc6IQkCtUX90OOCNpNgh5mubtHYJMWW3uTh9zyHJGLLkmBtYWVUX7XR
	kKzxxZ3pf5GWChCKWCdWJFMVCevVZQw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=c4qEZ4zuN1IQZW5m6n5c8L2VCbvMNXRj9zx1XhqyIgk=; b=BIJzKyxX1R7PQwuWCLRCva6WPv
	wK105UO9ofYQayRbgJValoCxp5J/5ejGr0XhW1Cj54ulLIEfPWGbMJI8JcRv1CAtGy7ey8qA/aekX
	9TZAilldnRwv3Pmkmyau4LhdG/6dfJaa8V+hUxa9TABvemX7DxdH3Rk19+Ixu4/ApOT9W34BYJ1tP
	vdVpJ2JVTGiH1TcLRgz1sy276RsVY/SX9E2vp18X7oO5IGUlv17CmW//2ckrnoGgGNN3d/3HujDuO
	B09mMvZ7VpXoFcKIVIA+ZoOccG4KBrrtEws8XaR4PhLZk0/D9DUF8CXukz2Y5Fj3dCUzWplhcW8j4
	lJcrgS/w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eaf-2438;
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
Subject: [PATCH v2 36/50] functionfs: switch to simple_remove_by_name()
Date: Tue, 28 Oct 2025 00:45:55 +0000
Message-ID: <20251028004614.393374-37-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m91mq3beap9utnck854krp8kkucnoy66
X-Rspamd-Queue-Id: 3BD7814000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761627090-544770
X-HE-Meta: U2FsdGVkX192wLL0fsdYVjs1/cD7JcroK9E6GfpKw86vCWgG6OTTCkrGSQQUPhoBoydXq5p/THR4JUlc8iRo5ArUctmxeffyJOhWGd/eG6vR4ePizj7MntWOeHtZF23Bz1iNpRsJBSt0QT9FhEeVUb7NmLUNq7ZNIvlI/DDGfYC04jDhDLEz4STXmhjv9dXcCdhuJSxOuhv3h1FZa0VoR2souWuGVU+q7qrWxWGzwkV+h4PQ/Acns7xSiIGf+/+EL+YxzkeK2lCTqKcJKUDjVnTIY8ohNek3ynDjD+zQHUdXjY6CuJfuUw0yJWob0jgKNMrhoy7+sr0Q+/ZUnojmm+zLCBtqAC4Mw1iGYjxjHpYP3mH6EUiHlMFuaIGJVgialOOzNy5VfTpzFotTOB8JixlDT0s6p5VJYST+Fb63bmpWDaqxQaI8DK9esmrOz1IBNdRW/0PkdbMT7MY4N/cDVcordrZZD7jWfwswUhUZTq3d9Y7H1XQ4/ndjmMbMtz/n/9XriZTYeXPbEVkm7fIhZZ7IGto0mXIHJiWUu876DnvuZq8rpxa//TSSd7b54MHvUEGa1cG7hcfyGktNhRIO8qNaen9+1JI7sEieaFw8IqZvsXHf6p+yiumXkQpb6tk8DaKHj/6WKLSaIg2paxWSILzqkVjECt5/DmgwIjun0jskBOJf0Ri17hr2m/IYYE0/nUIos7DUDoj0zqeYkF9QzO2l3caOnniToPXIDlYV9ERqReMh5XycNt0ztNWdwUlfoSFqidvjFwF+N/f/dJW0aladEyB2+7ysnoQYFRoS7uLEaseOLlZr7uMBenT1u74xmHIx3p7eAKCsLKPm87ZzJs3KFguoXcVVYYRarbuev68lp+5Ls5Bv//ZaGYg4Pio7X412QrmjY3T2q/n4paaYeEbP1MItpIjS+qYhy6uwPLxeg/hk7TkhdhtA7eLxA/uU+X3WRNkJRix2nJd12e6
 /Q/nGElT
 +9WVTclLiTqnDGkkFkScjF110j0N9uE1LiTYkjSL9ngcNrZoluLc9VhJnoaoKTKuy+th4nNn75Xvy+YCSuPH4WqVBI5MFMSQPDbsiMTH9Utx30pNTsFEWG/UUg0+HpffafUw97VeBOW30J+19UDNI2wAu+adbXK8q2knnSEvCbedx/DchitRAIA7R7TbECi5HOWS5gJnDibKdNq5aIJkdUO1hRiATHnp43g0H8aAigoaU9/9tmYPhjaRHhM3Xv+PN7wKz7l/MZQjtuI8EfEk3pz0JsUP1Zak9D1atRTUEd2SsbRGEiWudSJcbWXAMxA7LSUWRMk00XzIZqcuKhrOpwH9izHh0Nj07XLdpqpCz0oP9AWsJGR+can9PxImwrTqHZ5d789AYkbCcNJRP3KSxCpKW4U+Ucu8yKi50l1qxP+o0WEUfuHsGOAgf6Vm43yxM5P7iWFYzu5uREwNEYuD5bCwMFz1vL5Y+JdTViSKJ+M5qTiAB1agusokC7bUID7JcdoH7JYMr/ZLjq3IzmYEUuHZ1M/42wVtVLpMo
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
index 47cfbe41fdff..43dcd39b76c5 100644
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


