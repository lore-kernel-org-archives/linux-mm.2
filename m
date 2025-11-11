Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0099CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762C38E001C; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBD68E0010; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1158E0010; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA5438E0013
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51FDD13AE11
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.29.28CACE1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB16B40008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fkvVLNgJ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=IfvxBHgOqvYrSiXQUs4vlLRDVLAl5cYIH8WoeRQCAEzEU5kME3HVXgF2c8NJmRiSoWLsiz
	E3IX9IjUdyRyEgJLyYv8V1xnyakEUp9lSWiLbDQ+EsxFQQtOSeY/18V+tRuEnHjguwUD+J
	Xh/IC0PHWUWtwypc1jy0toUetipHCWw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fkvVLNgJ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=;
	b=Cb9uYJ4ymC2k2kjGFuG3l2lOYgZsFF19vlnd/17Fj50DPksVo/EJqTR+bQDwcyBtxeWyvc
	mYbPWX3DY5gZzkv46IC0MKaMi5bOVFFnpe/z4/KunjjoL1n8B4CXMM0ikbFwMvzVTTbezh
	hrX9uPQHVmbW1jWWJOxGjmzEe7mTjUU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=; b=fkvVLNgJdLgRgJSaCKh1AiVNnL
	MmAyZwfdz1QpCDGP0ob6tz9Ftx3Ig6L4tcP2yEVruYokhOSq62BRfx217h6LuUCOLH2dGJo8PXGmF
	GNhjFjK2AcXIlksAi+BvEJGhx4NOMPMlrRRm/g2vKQwa5sdyd52x+6m/Szahmd8IBmt0zgVXhgixA
	pJsl8rkOnTC6GRJkjgcoUIHNOARAx2aRnjXfaO685dYzT/rRcC8JCzhl55qy6oLWXAGll8oHPE72u
	mMFOre4XzqU1Ye1rbixW4MpCaocI494dZ3nJvQ1sLQx/BuhXMqcY2HtgCOFvDIBkjaJTu1Bv++9RG
	ZGrmvqVw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000Bwzk-3Wn6;
	Tue, 11 Nov 2025 06:55:25 +0000
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
Subject: [PATCH v3 27/50] binderfs: use simple_start_creating()
Date: Tue, 11 Nov 2025 06:54:56 +0000
Message-ID: <20251111065520.2847791-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB16B40008
X-Stat-Signature: o9idr3gerj8wfwy5944pczwe4ncfq1hu
X-HE-Tag: 1762844130-863927
X-HE-Meta: U2FsdGVkX19HJg7jNmtzllyLMIIv5fY1RjFkdlwC9URIIdd+7eRW9WbTTR5IW7oDW73v6A+dvonUetHpmSYYuDF4ziuMoCCmIJHVhIMTuu0YSpBZXbzNVeAql+y9efrpPV1n4oggPpC9mnvst3zEhhvqDOgeCEHrDAfXOrDKG6Uq1Lqax3bYWVA3GGdnK68XeNGC3+GdevxhSfpRfwc71C4KB3fqOgy7FAhTelM18jfYYVv36kNupHSalZdx/Xs6pp6xsLuQL67Rc115/P4Jx2KMV13oC82EPQ0YOc2cEC/P7V6TP6x2AkVY912whusVTu55pj34R3tnq837BXddh3VjAZR0Lzu17iVb7KDer2/Ra1g8SochMoPbeRbfL7o2v2puksAPQu8kUak8yML93S4CoMncYVgwuE/fN/XXBClBo5Ughn8Iv7yAXfDSzyLwS3xW+N546JsRALFZPx605dRQExPtBHNvbn3Co0vBJK/doTF1WNvINwCA1bXhFGv0QvfT6T50tWUX3FwugywiAF5AQGlFUMEU5cBmJKvSIW19cbaeQUyAwgm/fZKIqrzYUCBwLEIHb0TuYm2PjLmFhB3udnEG1JnbNItu7PlzMbU5JfteBmofl+0Jcfb+a8TsnOFOYQOmTESDSh3udgAXj4loyOQwURDDv46iLlN2InpBEnE9a4ACHIWfmi51R71nmYMcYllt3HwhscPOYxh/YYeWJB5MLl8pOFjDgOMH6aRXxYo2z3m/8b/dyzdLUGqz5b1C06VWmYIIdvRdlMr+iVnNbvNkzwgcj3iNSOnqltuGN6vm6WoqA/fAh81pkUtPJKQkUFwHXlNbH4b3Dw5+xECxWXUmQyXdTm6kmGqzYMRnkYg0ZYWUh32vmWeQ0jCjaBAksVKidVO+Swnc5bEEI3d2UOCVmZIsjF1GVd+tpZI2pY89SEH+u+KhiJTmD0/+DQtsdXikNX+NM4uE9mO
 4tm3hF/G
 eIC5iPrfv2ip9oFBUvwqVyDy5rmb/YefFy3Z3pVL3WoBwQgAbyZPHdZfzF+47PGRLHnzuXa1LhDPt3C/0n35ZMmL0lz4mliKuqkUgnzugzn3l2xlnttrsEm1vAHyJskzWCVqyo0kdCD2NzgtJw5PtOw6OaCbTQca4X+yS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binderfs_binder_device_create() gets simpler, binderfs_create_dentry() simply
goes away...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 43 +++++---------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index be8e64eb39ec..a7b0a773d47f 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -183,24 +183,11 @@ static int binderfs_binder_device_create(struct inode *ref_inode,
 	}
 
 	root = sb->s_root;
-	inode_lock(d_inode(root));
-
-	/* look it up */
-	dentry = lookup_noperm(&QSTR(name), root);
+	dentry = simple_start_creating(root, name);
 	if (IS_ERR(dentry)) {
-		inode_unlock(d_inode(root));
 		ret = PTR_ERR(dentry);
 		goto err;
 	}
-
-	if (d_really_is_positive(dentry)) {
-		/* already exists */
-		dput(dentry);
-		inode_unlock(d_inode(root));
-		ret = -EEXIST;
-		goto err;
-	}
-
 	inode->i_private = device;
 	d_instantiate(dentry, inode);
 	fsnotify_create(root->d_inode, dentry);
@@ -481,24 +468,6 @@ static struct inode *binderfs_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-static struct dentry *binderfs_create_dentry(struct dentry *parent,
-					     const char *name)
-{
-	struct dentry *dentry;
-
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
-		return dentry;
-
-	/* Return error if the file/dir already exists. */
-	if (d_really_is_positive(dentry)) {
-		dput(dentry);
-		return ERR_PTR(-EEXIST);
-	}
-
-	return dentry;
-}
-
 struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
 				    const struct file_operations *fops,
 				    void *data)
@@ -508,11 +477,10 @@ struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
 	struct super_block *sb;
 
 	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
 
-	dentry = binderfs_create_dentry(parent, name);
+	dentry = simple_start_creating(parent, name);
 	if (IS_ERR(dentry))
-		goto out;
+		return dentry;
 
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFREG | 0444);
@@ -540,11 +508,10 @@ static struct dentry *binderfs_create_dir(struct dentry *parent,
 	struct super_block *sb;
 
 	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
 
-	dentry = binderfs_create_dentry(parent, name);
+	dentry = simple_start_creating(parent, name);
 	if (IS_ERR(dentry))
-		goto out;
+		return dentry;
 
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFDIR | 0755);
-- 
2.47.3


