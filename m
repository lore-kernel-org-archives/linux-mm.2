Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C764CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743A3800DD; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E44800E0; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327BB800EE; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AADE800D9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4161B7E8C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.23.4584CF8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id E465FA000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NNADoC0Q;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=;
	b=yCmh/ZIl1pOUjBkLUHuJf6Vu/SCb1hZZx46Lb3b0LrFLX+Ho/E/WDyZube2LVRZreH38XJ
	6HeiAJ0TIiAhRmg+eUNjmdX3eNgE9WSeWplu6wWJk5WfQ5ZxOpQZRKcQAM1ZNo8NyikJYO
	SCZk9xGT6h63I9K+XX+kQ6oFomBXCuQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NNADoC0Q;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=RFxOu5YPy9MAooEg7bRftXrNqYnhGOc+DIapaENcMi/HNraySu3+34EPpJLlVt55XO5njW
	Lg+VdZYhZKBunDkolYgulqMB3BFd3XZKQc+k+Usqt29PIoaGGMhHT08zsGImQskvqUBW/P
	gDz7m7pk5I9GQ13W62f8/0L+mwsOgBI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ndxAHMuLfdVjp4xlYpconlsf87kf7dRAnlN4D1FUhRg=; b=NNADoC0QPzOHCvpif5Y6e7a21b
	pBUl0PzQ+IbvulPa+5tPA6AYicypuEQu8dMfylLQwaQtkai7ovjgavXoa4QSIk03b9I7tHbu5Ui2G
	bH5HuyZJVGEzFLnAU1CjpdshSGu+5HGErnDr7Xoyjg8OKPvkEJgEdtnovBatL4w5lf2IS1aeo9W2L
	f3CGHfaqs7ieul+HvK3Bx6t7Hwj3JTB8DvOazlJC/2oKsxH7ii56OfH6l4GjJW5d5bidKmJn9cymO
	sUr51YT8JdGsX84IivLBri+O+pSZKpC9yDGcN7MedyXezf6ggKTBqn0qumg/oFCTa8sA0OZBMHp8q
	+JO4W54Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eYx-1tlz;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 27/50] binderfs: use simple_start_creating()
Date: Tue, 28 Oct 2025 00:45:46 +0000
Message-ID: <20251028004614.393374-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E465FA000E
X-Stat-Signature: s1t8axenuge9r43snqcnow5i3wtmc9zi
X-Rspam-User: 
X-HE-Tag: 1761612383-686377
X-HE-Meta: U2FsdGVkX18xcVt5pqQ1H3tT8mVgtxtyR3Rj6vYcc7bUNVCLJe6sh8NxbvrKDUGG1/yf59CHQjskW58pZ0dZTouNh+fYH4dTeCqbg4xpyLKBqXlYl7+guRMWi+OLLLU5QmyyRTbpXvufxQJZf5nNPTYiFJJ8gzW2y7Ap86FcAmEmwbWBQRP9O9aG2kJShIrrJLJc1Wt3zBX6NqcVMCssIeaz61xCAs0mGJFpME8dQ71oMiBtHkGqQ3Dr9EY024fgVszvqBix5htR4pWa1/qNiLU//NyOgQghseckDlsY9Mq/w96TMRpXmxA8ecBFawlT2AUXI+IkMXGpw9VD2PfFKHxKrnV1mbiROiNBcrfqIUAHjogRBZhgOHPdNm4VUMd4uzVSKZzlLOJURz01uznBIIRJyuTxJkPmzHZ0zXucTez1xpCMr9eEmFsYouLpkE+kVZLuikPQLYmDyphi8GSDJgq9DnfXr2VP2jLcQQ29UwnCVOoot71HQIHVZl6vrdSGtAmx7syA+5MSD7FNv5CzoIrGoEjyaEuwjNLNd9IvlVYBiGQMUSJEUlGjGdwlK5Fk+jZ89SDa7djJQNjWNTBBa2Nwe+ocI5g86gHGWGbR5uOk8SEbPQirXCY82RgRCxqY23tU1SuRBIs47mrj8IF5WJmCENfSiRfH8zr79JEOV2LwDLDYEaBwu20CaYW+c08wbPZwlPvH5fzw8ryyZv2J8AQSzIF+Dh5Ylke+jxU8yf5ydBL79r9i8U05J8WqiVknEuV3mn5WJZL9RqV22/yCQCBBWwz8PbAYNYxgdde3vqGE/54GyfWjMt5bwpOJYtbOmXIpUtcwzWiyEalwYhVJINsraZqmClYrFU4gE72b8CuCBixfrAHVvN7D/CRunbileMGfvhvJ0lNRV60x0/y48ZnA9susx0tBbmvzGzV/02AJKq42QW0udTCPLP3p+JUlM/g+9K2e9qyGJ6HIiX3
 DJqDgdlF
 bv/P9UCGIlnQoHlZe4Y3K/8iLoyf2ELvp9iBvgVUrI8rSHt8li3GXPJ6YbUFgNvVmwVXl1RzVQYFCixgj4cpF6gik+kPtlTpJCWFeoZUxE0I634prvvBQI3iSlYeQEV7rkgJwN4h9c8aSeBl3ErFcK0AY/jc1gRIsY1W1fxtjnPrHhW1p5nl+TtDH4+Pg7+9vKw/h33L7kR/uNhpFCPxvpw0NTXjxWCUemsTWuWJDGG8n06nxSwM+ZXzMDJWtO6cLtg8yx4qtJcT52uXGi7NdxDCgCDAemidcHnreMfGhiVlnhMycxktI6AEuSCL2BEcm5FvVCcACw15uVqd7mr//UAZDolfA24s1kkcPVJ5OU2+ROrXuV1sz0YM8af/d2wVbsD7HV/UzSVuiDCqxv+PCrOF93iemw2OIZgbY01s1enpmUe23HXlqa5C+n62m/NoK31cBN360jysY+ZY2bv8dLtRt8Q==
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


