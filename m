Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84EDCEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0248E0006; Tue, 18 Nov 2025 01:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1378E0005; Tue, 18 Nov 2025 01:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2568E0006; Tue, 18 Nov 2025 01:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC1888E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:41:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5E6B12E979
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:41:32 +0000 (UTC)
X-FDA: 84122781624.14.5525346
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id EDD4C1C0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:41:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Y5rYDPAz;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763448091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=;
	b=nyzYEMpGm/b4LsUPNDrdZ1PazcfGKFAYTQjL/scXL5j/bhArew0R7dOpE1IrbiJz47F337
	8UAP+f43MkmFcmZmybXbSIbch07842Fn5OoDIr/R4jjy0Yu0OuSTBtTzBcob1YGs9NL4pE
	AHDABhNUvWty/AdiUMTZTmZGQT0UYWo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Y5rYDPAz;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763448091; a=rsa-sha256;
	cv=none;
	b=mjZElfMjWJawnerWNKTb75xsttdKraYxQR5zrmttwZbHHEafuJeIcqbqqmk5ICVD01QZaY
	JMWse3wizDbL0+5rphvidQKh0gD/gi05Ownusp2OUE18tWYdFxIU7It3HsFcDjpJD54vXR
	iYEP9m0mVlPB2k+8I4GuiwQyjJbyOnU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=; b=Y5rYDPAzyYI0YVXbV5vkI7GHZF
	AIbLx3QG1ZLdGqtHieKR5jEtX5ZyQhQXBE58iMFzJ12RsGLj+sWxbtQ4CgNsv+n0HoS3YII2AGZNb
	Gs073ubbEou14VFboUOZBDX4dKUw0RHCay7zKCJ8OzTZ1J1dvraWF9GMqMihTHMQTibJpWz7aYbOJ
	xgOqJaSUP/Me9LrBnjyBU3YdO0jfMPzMbsjg/OJPMQTS1T9TsmXLCqY0Zl8VbMIhPXwhxFQ5GRmVk
	hc9wh8Qo1VieZ9DPLGkilh19f8P5NKoHD1Rha2hWd/umK7mwDdtN/KfqpyydXOxq5eyfa6gH9BM1q
	L165gbIw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GESM-3y6c;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 27/54] binderfs: use simple_start_creating()
Date: Tue, 18 Nov 2025 05:15:36 +0000
Message-ID: <20251118051604.3868588-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDD4C1C0004
X-Stat-Signature: y66xbzudj7rswzx416kfou9pg9yi7eft
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763448090-254821
X-HE-Meta: U2FsdGVkX19JvPm1y/75TgN0uGgAmZHyf1WNGKEu4DqIYsjRBFFFkhVUhWyXx0+frhZ8cz2ZMoOsUh8k7W1LOV2AofYO4R82rlvPwvGFZnaykBJz0L3MK6/jz28puO3iTX0Yj42Xavo0/nDfe6QNNYDJcjbkiNa9al+7ZRyTmFLGDmRkqU+J7hBJoIXu56BhtnYULk2aoXQWxvUYC8V4oyzmi7hT6Up4CoVCv0EqCbx/vZAH3IW8l0J1MxHSgPoUD/ux59sChQyyh3fj1vx2xgttdVoWDezsrnsfT+KtxuUk6Pj6LYgBGLCTdpWM3nJspn/PYrfempSSw7iFtRbQZsiDIaAjUQ9g5kioXQ7/Jges65jG4lG0MjevepeLeiPWO5whZsb4RStZdtA9Ow91pmVhxzfQkwmo+fhk5tJz6BLMcuEXws9uE+goBNf2BlFz4gUeQ/TCYnjBv3RK3xn4yGR+4HS3EzYD68fMOtNSB11FhOcpTRjD2HO1IyDcrmW1OB3I4MV8/pBhAkXq1tKmtQSriv/HqCZmyvIKhcRysIMhcbawE9wvv/ufDTGf55Dgo0MI5zbFSJp3iUqEwtsRBW01VvoMQGfD+cA8ngClHrudWhubiQjmVr/6IfqYKo8W0C5qOd2xKo9jzwTBUrQ0GQTy67zomqdjutCZRiKAxdH/KeueVHSuGZlid9ZuSJAP9yCH1tg7Ey8/S2u+ipxNgUuawm8Yq+dV+iMV1sqnk8VikV8Tel0f9Ar3xhVEnHgsWaJu5uPORGlk1yo1FrJbzWwOyU+Fd/OgR1NU4rT+j+oqblPmL7H6A+NNSioGH3r3O4nUPEZjDdfMPx1sKczMpxURUAzMrrFE2F2C+AbosD/+p/XyEDsUox3qRS4SAs+ZQnv5gzLGKuLlk2ckLxS8mts01rFZB3/6pWspCE7khLCk8hZjE6QxGe/t1gsL3sGP/oQeQFFv42LcKNzfygG
 lmZmlOuC
 oVcz40EBwFXL3/pxzADLH6eXiVp+GWQFdLph8MVdVjJ8IDIhB52xjOmcaYfclerA9juypDizwP4LMprZsiq3v+MJlIvEwhCzHc1WZPCBOWaKnih9mvlFFipNBPNwl6XGADYglb5nYuyVIWlA61mon0TXVhvmHi9Z4yY+8oiRDcCUNoLofxMWPstGWpbia5c6v6ZjpBtohErf5A3xnxVN9LSr7709deqHdJnTAjCZJh1Q2whv+4EC4K4xNT8RnLEYpuaWtE/foitBJ3pIH2KT1wonU/jVamNwPVc6NYduN/YekfSVMgm2NEARpRcvgQA3DAuJ2ylqFaJK/OzkCpLOvBY90mbtitSY60Tr8zjzXEyqgZiunW3P6ClVNGi0fs3VgygWsTLE7NfpJ6OB6u+IRYQFe0Gg02GvsmPj/xG0b/eqSWtV9YFPnZUBWcyW87Ql9mM8AaaE60wJkr8FA/K0Kn9QiVg==
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


