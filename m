Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67570CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D64D8E0031; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318538E002C; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6A38E0033; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4397B8E0033
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FC1E4D5AD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.25.755D367
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59266180011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RIcNzlCx;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=;
	b=EdMkH9hhHRIYbZyHOTZBD9LwU6LiH6MoKr8fMiChEdBrFwkxZFERPVc4V6HuenZd1kMwO5
	QNf/64corMDdhv/AVD5tJgaQMzJcaIMakNAVtyWUhbU7Mf2IrpjQQuh7WCZZl0uiGOvrbj
	038s40h7mtmDtJpjHUHVx5+gUKFtjXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=wxnLB/4FmhSdddy2QaPd7wegCTKVI0fS2NjIsKPxPc4sfYFy8AAPjod21d3LbCJC7/5SBr
	gt8qbWJy/lT+UDiSKRHkykeL+bpZwjBNrq2lAcDHkhwRgoAmavCTnEyNxHtHZeYc0srJ0W
	m7aewMQa1dSdGV6dK41mnrMH9GSdOcU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RIcNzlCx;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=; b=RIcNzlCxypdVE8ScZwxqGu7uz3
	BZZmn19Sfl1c+AGAni1l/B1tw0I7OiittgQdONblK0uvOG0BOnNz18MAfGCHYVSldRYK9HsKrQS6F
	IE1hZj+Q592h63uzN+w0Zfuipg91jlABb2gf2/EMl7/FnkN31YNe7l4b7Pvl7RbYU0dkWPMh+WK8t
	/chZNjq3N56pMgEKku1kqYeIfn5/qWNIKiJ/TL32e9O5MsM4nXRu+FZ6BgOxPMgG6M7EWMTmICYiL
	vZAxw0cbtuWPbRxU7vceiKcHvvHDfsSzRIHPe47ruBNdzMjN6z4LfnWG0cAuOhRQFgAXr10ly4n6N
	xdIJnDYg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GESj-1Ust;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 31/54] convert autofs
Date: Tue, 18 Nov 2025 05:15:40 +0000
Message-ID: <20251118051604.3868588-32-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jw7tdna35h1p5r8x1cetr1tsu1rq5thk
X-Rspam-User: 
X-Rspamd-Queue-Id: 59266180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763442974-959167
X-HE-Meta: U2FsdGVkX18Iv1ROyxqJDkXmze3c4RecZsRME93fBGWYOw4+4j9YIHlOkU1aVoVDazME3KjTkbqzi1ANC7RMZ8twlNl0UrSQLw05PEVOTgK0RvbDXFfNGvZE3qPy1PGdFOT0b46BnnWUacv0dAEgI+ZQiSDSeW5Htu2FJqzOF6C5wYhT9MYZg/XVX9WNivpiDpx1pNiii8yVyevblZXs1zYwr7Gqz+wbDJ6YrterRC1ovjCYUgQBkJ8nvUSpBy1l5UCon9FKZGIIoVQQUkA9hMcqmjf3dz68tHa6GBks+liUT/v4g+vF9vseuO/X1sEtHZ3bY2apih0iNMNPGIjZRzCS1wN+K0XvNsrDD77/uKOlIOjmvGK2vovSUgIbSysCtW1EEbFFxaYKZe26In/5QZf16T7YdrprcXl7QleI9ux22KHSvPe8mdKs4UWxvOWHrkpYvuXlR++wQygYEq2l2WSK7qgU/VKNLBJmoPUPR0Ooi/b8oN0vE6Xf3OI3Q+6A99hhysxTZ8dmguEPTIdg/Nie2xr+iJHiRz4qFagNWFo8INypABBupzMeMC9//gmLW9ViwCmTI5KwkmDK7rV+EMzodFCHLmlftFmlbqNqcPCzbmk9SuYtWNJ/on8C3IQWoi+FTjWKBefrFmHRGJEY79wJYLT7d94CTU4CaZ62maFGxsOqHEwnU1wWbbs8wwyJLyhtaQReTeuibh8XoqHv7WQYz1dTHXxK7ZcZDdeiHteFFmZkSKSjG8z910C1fYBdYIcQE5mEUAkJGoW1PAwnZtp7dBdP/cJMqwQlYzZJZpYqu09tx6TxXEamLPNI5HbRnN7FgW9HpbUJShOAcH25S6OSxHz3E1WyrvqQG1G2H0HQyKGH4jBBxngRVzNxatBFY0DIU65p+cmRHu9MSdi0fypFoldA6Muj8m1Wy+4J9EezOwjZu5nUWAXi4qKyvT/D+gJ9RioYDKjq1os+JUa
 +9XpCX5k
 wokRPD4dtam6EPc2b0k28p3T83p5H0uYfKUBjtSpE9VCARbT9Z4uwSrTq4CZF7dlvOI5Km1tUmryDgJTKa87tu+hIijrz2ISGu1l/eXMH1/SdJhWNUDGEh+CwrhiToIbYzBv1Cwjv3Zc2Ahf6lIv62t+MGmGZTjvRv4XV7pv5U3lA3+F4aM+lQ76JrUlVWrhFcbndzDNejQBxLCNbwEfiqtq4svjv6ea2ag/XYYvvRrV9eiIUDeTZ/SXBaxzy4952cRldw06f/ZdgQtliAwqHrOkPmKU2Ri60vgEwSrah1fF617MsdKyJLRRxoCk4NDHojVU1QABVMcg6IAtndkTa0SXKi5/VuKI320n6FnQREbo0Njue7dv0F1yce3vw/2rpW9k92FtQzDN7mlKc/dZO1KdqbF9FeFCpVDeaeu1wEOkAA1/PQ28JpGnm4WKYaiZV4PCCa/Ph4W4QhKQ=
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


