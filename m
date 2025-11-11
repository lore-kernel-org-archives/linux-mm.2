Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5BACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43D08E0007; Tue, 11 Nov 2025 03:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1ACD8E0002; Tue, 11 Nov 2025 03:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9585F8E0007; Tue, 11 Nov 2025 03:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84A308E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2806C13AFC9
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:32 +0000 (UTC)
X-FDA: 84097682424.11.83168F7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8836BC0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XIQ+y+Vl;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850490; a=rsa-sha256;
	cv=none;
	b=L3pWsq0p7cp0GMdQQ2mKWMwwfrf8KTfwK8j0VOKFMzKCooon6RnQopENxxXVCdoBYDHgnU
	xExJ1uFGx77JuKEFZui6+i1/nlBp2JJHWkepJiAqj6JDFUm9OeEx/LMkmrpjfGoJOzgGjp
	cyUTZQwbpsSJTnhiGU7xN84pCQDvD7Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XIQ+y+Vl;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850490;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+tXunEOs6X459keGHQ5swXgQ1VhlYiy4rVqOJxhLx8=;
	b=O4IcpePb1oQpKRkJP6aoWpajSRu5Dwy1gl89SIba+6rtUitHvK53ONVEJEPF4pZwoYJ31K
	DQrNkqGLb/C/DDefH75wb7Lyh4gsJHv1uGZMLqGMb4eaiwFpGs9t4CWoju/OVi3XRL+gk3
	dNPgtTKeBF0Paa/uBGeCx1VMot11Z3I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=N+tXunEOs6X459keGHQ5swXgQ1VhlYiy4rVqOJxhLx8=; b=XIQ+y+VlFDH+1yuCJgvoROjDye
	zPueB2Z9hy0fbTNFgwsJjwwNUqLSFZXY+uzh/rvreoEu3pkRb38Jj7WMS/xAUSH/r5lBM1Ra/Z9Cj
	H3RzfsUCTskyAGw/Tufvoa/hESm+kdI/n4tbYqd4a+avsp9p3jpsa/4jOB+z91B+sOPf1F6xQx/MY
	eJ8Kp4OjBdKXt8krqSxOZ+Wo0ZokSKMjr7uvMGTYw9awSO0hnlIvfHeOU6AvBEfNeTU+iFcz7czvc
	KdwIP1k/9CIvkLpZhbqncS5dAaBf+h+h5fzsXzPtIDidV/XIh7NDxq5fZ2lS3Cxn+IeObHNr48f/O
	212tHJww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHn-0000000Bx5D-3qL0;
	Tue, 11 Nov 2025 06:55:28 +0000
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
Subject: [PATCH v3 36/50] functionfs: switch to simple_remove_by_name()
Date: Tue, 11 Nov 2025 06:55:05 +0000
Message-ID: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8836BC0009
X-Stat-Signature: titbonxe39ekp3kxuw4oasd3mjzmeies
X-HE-Tag: 1762850490-374272
X-HE-Meta: U2FsdGVkX1/l70Fvtc6zowJbBVVV0aGrprssAbHLpztkmzrZXFBMlnhEJgq7wDftnMpQZJA5njcRjx6jSOoG1CcUlSU/ptn8mdJK2Lxk7Lm5eXVM6PqFbJX1+7R0ZnqA9i7vFZdAKspEhb6swX8BLDyX4ODxrW9vpE8l0+T0IfjZFEUHqfF+5ntlnvmMQwbEICSYl60GyboaIYdQFi6FLgGmsoHfbA/zqRaxwxGXG5rM6eYp/QM5Zh3URjsTlI+0g8XdWxVoP64T5yXoF0OLOrIUAxNLIWuaX1jrHxzV6/OqfMA2sj54qNs1IgLvHaaoypGWIRw7p4EHAPtvCnRBfvxHO6rMrRtFQLedJ/Djq74eW8Fifljp+gnaIB8rwlpYB+3rOgU0S18OWaBW+3hoMC0fNDgVFP5SiecLnZlMwZZ3Riib5hQitpTMbQ+jLpYDHo702GdhbuEGKROgrMJXlhmMoISsEzpLSeCgUCd+BQcOKbfG6g6LwORP/qKlM4rIJnzaY9b9qs8kL7DMSEGMpdWfEt+WBz1t65bVAmvkTuGglWWFH7NFuKlSRA0jICeKvOkO6r4jZk5mLezZW4ZLou+QY1PNuZMF4KYusJC5uVChPtse4/v7eRKFcxhEOz7brk/kCs+HD1yDCnr+IDPbof8tLMsYsOq72nG9hptv3OqhZ7JIy5iwW35znSt5fME/xMkJa8LNdbfzlNh3vWMnQ5yuEaqiKGdpU/zBo4Nnx+7mwwqy8yDe8eCsZVI+Q0alYiI2H9tMmHIhBA60ZIBJ3ANtERaLsRL8NTVkNEEVt3s9GCvjhuTb0ZAHFjZsMJZ8mIKV9T6ZFsvPlkwciF1JkTemW2QRuq3WSrb1dzM5FBALbK2B+fH8d48kETMOV6pw1JeXZz9WgHFi7FHe6pNWMzU0+pbcSBZG7ScEyXucJhmOE4EQnC0yXXwVmbGHUbgthQdUJjLstXrjMGk7fle
 ql5crkgC
 Ca8Ayi0ljceHD4a8u8zz6RROa8QEOUpCpSXxUoSS6eCy19PDOxrOgjnWUrl4b+rnQGcYI4lxTEWLOp4Zd/+SlnpENxfggQA5qTVIoM7639ZBO9wXPSbcaXxkagA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to return dentry from ffs_sb_create_file() or keep it around
afterwards.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


