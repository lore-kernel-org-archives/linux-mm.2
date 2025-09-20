Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20869CAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8C98E001C; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A9C8E001B; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4232B8E001C; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6D68E0018
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E86BA42DCA
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
X-FDA: 83908850382.02.FF38BE2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 462D914000D
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=T5ZCUcZd;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354490;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=;
	b=jrzLIEidPTndmelAblXM2ERn3TqPhDQBBfaPmKupZrxPfg0LGVrl+o28xoQoLu7Wj/ndxi
	hRiXvgJEB7UOIPB/Kolkxr0naD8I0bUuqm8YKFapZK8vasXS5T4MMD1Qptt0G1UD/nFYl1
	kdT5msLiVKjWvuL9hWw0jVUoQOeQkCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354490; a=rsa-sha256;
	cv=none;
	b=l963MIyjJAoggd663XkH/G/OKG6LMj8XHmMefEqsuXQBgklV61ZfQoEbI/DBBWWNyPJvZ2
	xwKB7clQFgCH7iZ4op75fOOgtRd3AhIPQhVgc5IZPvaAuByvnyPQIzcdP+qxQsEamRmxoa
	kxdhBhr07PE6X2AvL+/3eF2+O7xeBOI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=T5ZCUcZd;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=; b=T5ZCUcZdL4OqnW+yseb2hTTdp3
	AMHz1GaHLVAewFm2t9EcGNA3s0uh2/tA95nBbs8ImDaiGtKljTZ6bAJ05xg00Ogl6b8F2IxUuTNHA
	DodSCrWkUkYUvGm/aF+NRiIv+bNlrJponEr2oOoYw6AOE3GnTumvWq7XvMXB/d2xreYw/Mt+ipPaq
	ZSE3CGKqvCtOJ/5FWvwy5stqw8dRb4pvRv09eKvwGrhWmQoYnui5jxqpy/0dq2W3Ffw90klBjBgeu
	xyOSXQwlPK+MqAt6BveuOh1Klt4KneVw23G17eC7cCWC2x6ZcxqFpmTdIldm0qGF2ttCGqztpe1MZ
	9bUEDj/g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKD-0000000ExIT-4B8X;
	Sat, 20 Sep 2025 07:48:06 +0000
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
Subject: [PATCH 29/39] convert autofs
Date: Sat, 20 Sep 2025 08:47:48 +0100
Message-ID: <20250920074759.3564072-29-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 462D914000D
X-Stat-Signature: d55yftppy1bdh3wyomxbwd9n8ksn9qqc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758354490-330632
X-HE-Meta: U2FsdGVkX19jUZcpBjPhfOSZJ9O39br9LIYK+EAvsuEZ7bG5fKwOqOEObBoqz/0gaWbeDY+cuqBJ9crPrNlktYul8pFLyCAVK7sEWXKQTF96DViBt61xctmEisOFttWLMobk7mAdztD/iONVCPcFEeu7GG3kxAnYQOzaW1KK/++xcW7q/Lw44zyGfxVpNVsuw92nJUuO18c6N3T0H4K1q+44Lf527rFVJRZWaYq3/EdAJb9vHqCqpyeAq9xi4qB/zZQU/Tl1DE8QUcK1xDcgwYaaoLVlPJAFcD7sbvW6wCfRzeNBmsdj7eSetqwSPmxXdndFpVNDQo5SW0GEwhIa1uyO2Wve8P/r4dDKB8+TPBIMdKyF7sXCuci40MyYyhcyHG2PqidbRF6S5cVCCvscwVZHLPkpGotLm7Msa9/db3+82KkVlAJeAY7ADrU9dN+OQylrp/TF2rhfgON7psvvFjA0oG8X+XXKS6Yg8b5hv+vWgu9cLYoy+SEUImWZUxWOUeZFyZIKgTvj9L6NsoVTKCkuaBKoCi8i6vp9WHAqraUTyb+XpqYGb6TdCpYyBheDP3THutA9H3qiAmR1JKgIwAdR8wk/CaMjQ2U5e97tYCZfb4XXXIlvLSytsdLyAO+2Cm7m7hvX1IQcO/Ycth56atAb9ODPYGRuEc2c74x9PAjMXaAq6FIMfg6xEVdKw8qQGnET7wGGdsA2UMaDAED8AomijUFsiufcPTyh6mhpy3XSdxPsWnKQaoboumhnGc0xIty1l82OkJMF/Pwi+anPs3w9MogBUCrA+MIDiLXMz7b2YAx/IGpB303MSaT9MiFPn5tGIIC3lTF2uKSZhee7JZfWPX9nJRDB/2zTr1qyFbuf6MC87QStMSPBC+dJgRUMb1/PAGu5RodQ6RLLE51HnzSVqt7h3+yfryuMg7SMMTn/8D9HRIrvSYQJf6WN0rDMGct9WBqYOPCMfB9ByI+
 Gz7WK5eG
 rR2/SVMOE4iCd09tTkwp0Vw+SFXPHUmRQzmRGhH0ytT7Xh58CY24DvX0FHgb6VHpw+ZMm1X3sLygn2ob4wDUnfqx8zcq1vQB4Co/46LesyLnQsmFeAQ/21uJaL3i5iaPt3htrPUdGQ9ntNm3CyBCHIYXTBCKS6UtuvUywPjT0QUQum8Sn4byosnjCcTOyi/IjzVe0ypCfKnW3oEzb2mMWAXrzNv/WZcV0RmQeC9+8a82jMGz/foy8yPeocAgKc33ZLq6B2Byb8+vpoucrpc7cocOz1XqaxJNTmUpsVMXuW3iWNbySezjqDWi6K5Ta4eQ7cLFcE0IlekkDHARlW5mJymMevPA4cLHtpkooOoZM8sVNSVKvIOAgGPDKtp3GI/yr9XsUoeH/bDJ+3Kw4OJF/Z3gOFShW7FiRlOclBMhann5OA3c6X4SHpGY/1BH0PHngEV3fi+vqvPzNGigqytFLeS8D4VGxOYoeqCzpgavvacDJkHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

creation/removal is via normal VFS paths; make ->mkdir() and ->symlink()
use d_make_persistent(); ->rmdir() and ->unlink() - d_make_discardable()
instead of dput() and that's it.

d_make_persistent() works for unhashed just fine...

Note that only persistent dentries are ever hashed there; unusual absense
of ->d_delete() in dentry_operations is due to that - anything that has
refcount reach 0 will be unhashed there, so it won't get to checking
->d_delete anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/inode.c |  2 +-
 fs/autofs/root.c  | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index f5c16ffba013..eb86f893efbb 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -55,7 +55,7 @@ void autofs_kill_sb(struct super_block *sb)
 	}
 
 	pr_debug("shutting down\n");
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sbi)
 		kfree_rcu(sbi, rcu);
 }
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 39794633d484..fb6c8215456c 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -594,9 +594,8 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 	}
 	inode->i_private = cp;
 	inode->i_size = size;
-	d_add(dentry, inode);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 
@@ -627,7 +626,7 @@ static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -709,7 +708,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
@@ -739,12 +738,11 @@ static struct dentry *autofs_dir_mkdir(struct mnt_idmap *idmap,
 	inode = autofs_get_inode(dir->i_sb, S_IFDIR | mode);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	d_add(dentry, inode);
 
 	if (sbi->version < 5)
 		autofs_set_leaf_automount_flags(dentry);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 	inc_nlink(dir);
-- 
2.47.3


