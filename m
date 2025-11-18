Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F6CCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBA78E0029; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E50C8E0002; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3184C8E0021; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4920A8E0034
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F394313AB76
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.07.0EEB820
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00B9410000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eyBtxzuw;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8Ik4zuriSM27g5TIHw6N+EULicED7c6xnS6UrwX7a8=;
	b=umMN1iiWV6Bm/fW7Zw4POeW06O0jB4lY1eEv9gnCw6zICJ4GwI/n26sHSzL4vLhDLYQ9kp
	/EXApRmnxiE2iGr8r3+4FNDkMcVbcEW1qVrmvrdRog/KaPi+LWrjJLV2kvJa0VedFOXPRS
	0kXMOAagFjJ0nQQreMNr1XwQ0BjipBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=TZSEv3FSgMBzzkO/PXUdczg75NElRQ7QAX/PsyR5hqK0DnnVBGL+H0yL6IFdhuaIYZnC2n
	YLZDdXwb1a8rN4k/tnqZPu+JqGO6viDSxURs4ZJ5dFyc3Zmhkzkh5tFjIzPoqpeR1YApkf
	rTf+Me4VqtDze8Y3nHHQ+q/OlfKIPD0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eyBtxzuw;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=X8Ik4zuriSM27g5TIHw6N+EULicED7c6xnS6UrwX7a8=; b=eyBtxzuw2W0UkWIMfBVDRF5HnN
	c8pkSZ6zguaEQHjWZ/2YQVWhKYltYMabKcqdaSVO4M4nSBHEvb7H6hrRgv3jmvTtamxHVz3gp99D1
	z1QxeZmOHNQ69JiTj+PFPMwzsleOAP2O4YCBcNdYzfNZt/xCwQFsAl/k601PI53kDcXYwe/PyYQ+Q
	fMuF0SZf5Fj5C1eeAww+b1lbhyqIr9kOw39nNvvF1IVvn19yU0aIzYZm6xS2Bwnd6G+iVYXLguIEx
	ZCo8D8StM6Q9hNTpWs6R14iTEwhLT2QwOIIypZLis6Qeg5Em6Pv2BptOzgrwHZ36gOkTjqOy6RCtr
	1d6HSJSQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETc-1Nbr;
	Tue, 18 Nov 2025 05:16:09 +0000
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
Subject: [PATCH v4 40/54] functionfs: switch to simple_remove_by_name()
Date: Tue, 18 Nov 2025 05:15:49 +0000
Message-ID: <20251118051604.3868588-41-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xijomi6tsc6omzosmidto7hyey7p9pgz
X-Rspam-User: 
X-Rspamd-Queue-Id: 00B9410000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763442973-906423
X-HE-Meta: U2FsdGVkX1/+eNYBBhf+Xe4O2X9Hnrvgrj0hd7Ox+FmydHuxPtxj2aJ8RwbTJ/Zgp86vSVjcsD4m23GeHsIrr8eEuFwVZwpa2U1Y9VMKwS9f86dOAVkgIuyuuiMr7KbjJePu+0w8GpT8yss3v+MpWkEEwS3bu7BxpTsgvxQqdSKBbcVM9Ng2ZKhu9YxSJxJKhSt7akdN0zV4DBRi/cahtt0qeGSpSZ62qNUby3N0AspZJ2dADjpZcHi/Y5c5D/7ooM9F2nRANiD5i9txwbsceGatt0W3RZJZt4eZTGI7SNPRVjoLk/hWib6dpJmmUReNCKQvUj5hqlkhtJKOnQR/hYh42Mx/iXihfd4HT2syWZFgB6mAM2HHrtpZIpmkIu8Nw6/L8dssciG4l6LzCiuxq1atFOYhJH2VSVBymEFNhCz3fa3FZxA5XNfB6+vf3MG9YqVD4GxL993STzoM07/t1jvJfmjLKfMwKiDplqKvv2+dgAKdRckN4VcLeE22UZOw1zuoG7VYBCF0e6bJ7YTZrL93VDiRca3II14QoiJQjEtxJAR6LWqFI7R8OblE8S4lzVVev74VvcVyfXlXZbBuYTfg/XOEkHU9HuFCaW8dcDBCRbOTKjNcBNSx4Tzo0OcWR3Zvm2XWKr2Z2HxYNhhKsmGs6Wk3P+u4qcvyViSpmPHYoqKabkCVSJV0iv2tNo2d4N0rRml0jdLXfQTA1FIPBYp2PBS0IqKy0+0nYOdhFGXkeyModGNRz9vNqlaJ9sJgM27R6D/475yoSiAcPin/j04NvpqmnV/mgWNLckXTne1BMTOjmYb2yau37ftifGBVk9UI4KUW4m73pt0X0aLgnypYBbUr4OOx6/Voj60LJvxx/vXOE0KMfCWDD+18+BFKdjEQ3qSmkxTWxnZXO/RFL366QjYpiDFYYJmhDwbTNYTMzM2xl2MpPhis+x8X+iAuWA2pWpOofA85Wa5vcj9
 vVCFLHkj
 Ib0NbGrs71gDRTIZzS4p064ruKfXRqjQwvdzOfCGlod+wUx63cIM2UmkO22CvKVNk/xEwhHseflfQDhBNXgl0oDLCDR61mg7sWn28UO6tpzwm8fD2R1u4gnWEs5Tb4NsviBDHyJEmd/k1jKmjTCx9WPqJ4vmp8r3qe5Zk7zQWXARX53Hi17ZHBjcE/4snHck6kkStbcAOnL4ItBc62E89HgdhvOUPe0Oms1qKq530Gk6qeRlg9Cv1QA30vC4Bwja6Y3BV1LS4ZuKK3Z8skzg6BIoF85WE4G5BhY0V3CZ8miaQq3k7C6se7ggYbYeM7+Watw2UV13onEX8mo1yX39OfX+6NiucId0J79lGbXsB38cHnkjV3NxCITEth1hQ97BUs7q9ibr9Zf/6UwlgbhIMpBd24jEVNtvy5C/5zip09wq1KpkpMHxocESjGVnuI4KJRr3dQB9UzdL2JIHp/DZF37BaEApfomm9ucRHk8v09K2KrghWwTX4fse5pY5kOTFmgx0KA/q5mQ5TSNnZqIgGQpmi45FNK4hzwbqyDpi2Pq9+SpWuVk/IVuvREUhiMAB3cjqlVOYYZ1saM3Y4M52qG9fe0F3QckNJmHxM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to return dentry from ffs_sb_create_file() or keep it around
afterwards.

To avoid subtle issues with getting to ffs from epfiles in
ffs_epfiles_destroy(), pass the superblock as explicit argument.
Callers have it anyway.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 51 +++++++++++++-----------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c7cb23a15fd0..40868ceb765c 100644
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
@@ -271,11 +269,11 @@ struct ffs_desc_helper {
 };
 
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count);
 
-static struct dentry *
-ffs_sb_create_file(struct super_block *sb, const char *name, void *data,
-		   const struct file_operations *fops);
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops);
 
 /* Devices management *******************************************************/
 
@@ -1894,9 +1892,8 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
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
@@ -1904,16 +1901,16 @@ static struct dentry *ffs_sb_create_file(struct super_block *sb,
 
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
@@ -1956,10 +1953,7 @@ static int ffs_sb_fill(struct super_block *sb, struct fs_context *fc)
 		return -ENOMEM;
 
 	/* EP0 file */
-	if (!ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations))
-		return -ENOMEM;
-
-	return 0;
+	return ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations);
 }
 
 enum {
@@ -2196,7 +2190,7 @@ static void ffs_data_closed(struct ffs_data *ffs)
 							flags);
 
 			if (epfiles)
-				ffs_epfiles_destroy(epfiles,
+				ffs_epfiles_destroy(ffs->sb, epfiles,
 						 ffs->eps_count);
 
 			if (ffs->setup_state == FFS_SETUP_PENDING)
@@ -2255,7 +2249,7 @@ static void ffs_data_clear(struct ffs_data *ffs)
 	 * copy of epfile will save us from use-after-free.
 	 */
 	if (epfiles) {
-		ffs_epfiles_destroy(epfiles, ffs->eps_count);
+		ffs_epfiles_destroy(ffs->sb, epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -2352,6 +2346,7 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 {
 	struct ffs_epfile *epfile, *epfiles;
 	unsigned i, count;
+	int err;
 
 	count = ffs->eps_count;
 	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
@@ -2368,12 +2363,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
-		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
-						 epfile,
-						 &ffs_epfile_operations);
-		if (!epfile->dentry) {
-			ffs_epfiles_destroy(epfiles, i - 1);
-			return -ENOMEM;
+		err = ffs_sb_create_file(ffs->sb, epfile->name,
+					 epfile, &ffs_epfile_operations);
+		if (err) {
+			ffs_epfiles_destroy(ffs->sb, epfiles, i - 1);
+			return err;
 		}
 	}
 
@@ -2386,16 +2380,15 @@ static void clear_one(struct dentry *dentry)
 	smp_store_release(&dentry->d_inode->i_private, NULL);
 }
 
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
+	struct dentry *root = sb->s_root;
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
-		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, clear_one);
-			epfile->dentry = NULL;
-		}
+		simple_remove_by_name(root, epfile->name, clear_one);
 	}
 
 	kfree(epfiles);
-- 
2.47.3


