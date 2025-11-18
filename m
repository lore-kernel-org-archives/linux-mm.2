Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B890CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B678E0035; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255D38E0031; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ED78E002E; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7428E002F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEF144D5DA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.06.06162A2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00A81A000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=u6pxq8xi;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4mzzCxtvz6lOZcAfbeBdr43fAoSEoEaxjM5CE5ypAE=;
	b=JU5tP5ovUdVDzyBr36WokarHMqDr1mCwlSDS46L+2sOXtA99FG6jGAMDwQEeM1P4+ZA2Hu
	yG2PYZTT6KuTzXWXtg6pVk/ROVlVCscj/baacBrlr8M0oQBHZh0xock/X4j7ak+G3mIjyG
	Tihg7NKxjMag2iMxpoeK5eqruho4vuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=IExbO5vrsyLzSOF3l5/UlgTsSUOVKdge1L3toSHp6+Z4Z4PxkdhvaSbg21vgbVOgq5aeW9
	b0B313Gctvx74Rg9hmgxKHDf7I3i+DMsTi9Q+U3Uyd59hMn1R9LxRvD0ULXoEtb3JUIcOq
	JrDR9lo4UjqOHpiFaSbExP0eMQW0OVg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=u6pxq8xi;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r4mzzCxtvz6lOZcAfbeBdr43fAoSEoEaxjM5CE5ypAE=; b=u6pxq8xiULKAfZWNT1+VCaox5A
	F/P/9pBHh9io8iz5pfLolp+0w10e7lZEMrCWNoB7+gf1mpLxZHNaZcPNvNBob5A4MR1MksfM72TG4
	DSoAfIBkcBd5ue+gAF1tfl2Sg+iijrBFbIuanhlxYitxwb9V2L3Y8Q/uvi1ZtvRUVCIx+6fxT6Uy3
	aOMXQTaEM6NpLuVv6nzbKGoqhYG9MIMSUsmu1MyprXrGtp/Pe2I6IwhplHh0y73uMskQNonKCZmI+
	WaHJCyUZOZkrT1iEOX63Q/Umkzw4crJYpDBU5Wa2diFoeOwt0svaGUzr+rd0K3MyRPVT147oXihOn
	Iq88yr/w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETW-10DT;
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
Subject: [PATCH v4 39/54] functionfs: fix the open/removal races
Date: Tue, 18 Nov 2025 05:15:48 +0000
Message-ID: <20251118051604.3868588-40-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: skk6oq57t57bnc3pa5pd9pp4z8ud5jwn
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A81A000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763442973-497813
X-HE-Meta: U2FsdGVkX18pAuyM+6gaECDit66wiqqUMRBNBhfxKMP9iP3OMBnWOL4hV3xuwVJecSvuYISKxlgtvBD9u5jBcqJLUhVs6egEzhp1YeMZJWrkVOx93o2a1o1rYtWbK2iBci+OjqVNXQ+PIocFcClgIXCgOhinJWTLFUWO8vNTLDDeeGaGV8A+GMS0Rai16RW9hPGh2V+7oUABKW6pf4mnwkE7g6hH8EG2RcWbCNO6NFYzdxVE6bFtPzV/v+y56gbb7X703rJVuuomuFSaclRaobGyuyfCp/HkNrtxB+IZTxo4tDmPXWWMvR2K7sHkMB1Thm7YhqWRYSM8B5wO1E+fmpu6rVfCcsYcDEc3i+uvj5lECU+tH2KmYGr7gAy4Tp6ExCHFhqtRGv8A2LJ0drugOjyn1xKXM5XKz13WXBnR0GiaBCb1VsMwyg7Xa5sqxHVtscFJZNIQjlzjLVChVXUHxaBukx85TmB/j4b+BcZ2g3/I/EP1cHI/8muvi645Xi0skVktZSUnMNJivA2KJ+8BfatNyAhcBBHz0HJC6oTbvhZ8PrdvjB1zsA7FFy5RaQSPUfjEoMaX/niW87g2avY6SWDFoX75fPE6wBL8v6R0u6ZZCFRNOL9w1CDUgBZNaGZaDpZ1FdQi7qe5g7LZn9GOnkUwFM7PgpaCu4lZWoDAfbhQHf5M4rGxDHfRBGBw1IkQ+n2rlWHQAB5+1QSoM9E8/rlF0wa37HN18+FIXNSamI0d2aGjRMvkHhXIcQjBIsk71uwBJsDyQ+XIYXJDas82Y5PYP3tNmtDUN8ZNRQpbWod+i0mkDRueV1L2itSeYZOaJtEVOQIBviKULZTDzGYtoKuvIpwnSj2R6J2YBf4KLC6/pb8lPyfaBJGfZ4XAVYxj7xmp9haTGPsP2IZ3GgKbaN9CBqTy2ZBGaCNeEJNPh7GgR/fiRGhZSBLjpNsb665WaXaxhjkYnOIwF43Z/YU
 B8lVPR8z
 XRRwyBnySY3NtPoqtlA6MmHxcg3AjwIY+Q2KQLPXpn9nlKkvizHLwlPDpATZwYxxWhQm+PJQY8NKo10A22U4386bKL2Es83GIk/yPO/j4GlvUp+PyA/aGOOLE7QedcmZwYdubv1o/eKmucp43WjQGc1wZy7mr7U+kWnaWZDs8ja1NYUExojD4AlB9whZmKV+qidLhowlhVKYI359Y2wfUOgtTIwy2CxwBgT4kTLfyrU4on60S7yTHCdINj6gJ09OhPKE9cXaLFeUdv4hkif8TVlHpx5mMjBSOtbseU80+WpZeWueubGCHd7cEObKXZymbLih7JcI+UXArJyPff0tHDgkd9DSidFFx8daIKDdgZebh+I13lezi64qb66Pf+b31FcJR/sdBHD7GnwmqkYuQ2cVz+BVu/jrqjHKV6NheSfQXQ9W8aHCsODJWYGCI+G3Q9tdvBN+W1fFiD7dAXMYS0DOsjhYUUmz8Pu04
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ffs_epfile_open() can race with removal, ending up with file->private_data
pointing to freed object.

There is a total count of opened files on functionfs (both ep0 and
dynamic ones) and when it hits zero, dynamic files get removed.
Unfortunately, that removal can happen while another thread is
in ffs_epfile_open(), but has not incremented the count yet.
In that case open will succeed, leaving us with UAF on any subsequent
read() or write().

The root cause is that ffs->opened is misused; atomic_dec_and_test() vs.
atomic_add_return() is not a good idea, when object remains visible all
along.

To untangle that
	* serialize openers on ffs->mutex (both for ep0 and for dynamic files)
	* have dynamic ones use atomic_inc_not_zero() and fail if we had
zero ->opened; in that case the file we are opening is doomed.
	* have the inodes of dynamic files marked on removal (from the
callback of simple_recursive_removal()) - clear ->i_private there.
	* have open of dynamic ones verify they hadn't been already removed,
along with checking that state is FFS_ACTIVE.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 53 ++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 27860fc0fd7d..c7cb23a15fd0 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -640,13 +640,22 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	int ret;
 
-	if (ffs->state == FFS_CLOSING)
-		return -EBUSY;
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
 
-	file->private_data = ffs;
 	ffs_data_opened(ffs);
+	if (ffs->state == FFS_CLOSING) {
+		ffs_data_closed(ffs);
+		mutex_unlock(&ffs->mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&ffs->mutex);
+	file->private_data = ffs;
 
 	return stream_open(inode, file);
 }
@@ -1193,14 +1202,33 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 static int
 ffs_epfile_open(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	struct ffs_epfile *epfile;
+	int ret;
 
-	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
+
+	if (!atomic_inc_not_zero(&ffs->opened)) {
+		mutex_unlock(&ffs->mutex);
+		return -ENODEV;
+	}
+	/*
+	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
+	 * not enough, though - we might have been through FFS_CLOSING
+	 * and back to FFS_ACTIVE, with our file already removed.
+	 */
+	epfile = smp_load_acquire(&inode->i_private);
+	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
+		mutex_unlock(&ffs->mutex);
+		ffs_data_closed(ffs);
 		return -ENODEV;
+	}
+	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
-	ffs_data_opened(epfile->ffs);
-
 	return stream_open(inode, file);
 }
 
@@ -1332,7 +1360,7 @@ static void ffs_dmabuf_put(struct dma_buf_attachment *attach)
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2353,6 +2381,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
+static void clear_one(struct dentry *dentry)
+{
+	smp_store_release(&dentry->d_inode->i_private, NULL);
+}
+
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -2360,7 +2393,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}
-- 
2.47.3


