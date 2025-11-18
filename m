Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD55CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4B48E003A; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8898E0038; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8388E0009; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07D188E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4E354D5BB
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.08.B483AB2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2E9CC0009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gJiPdzY0;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o92Omq0psZ3ukvz3ytEXVDnarOtbezsCR+bO9JM0kAQ=;
	b=FbrG8JD9qJDLocBI8obO8cHhoCqnWSQ0rb0wV307/OyZU+vUskKZB/GJ03CeCVYaFQ3wFR
	nSWhphXhrbuynZxWbmc4HrDF3NzFmJzlhE6JapAQNNOAI8O8Uap9S7XgGzWg7OGyoV98aW
	WBivFUHatRAzLzk24I6Dyk7F7C/BOvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=TxRIByokYtqYTtIrmNaiwVzDDMRMMtN0NzbopKMeR0w0m6jLXL/ADKyCw9A9+SAerTQd/L
	DoMg/fVCX7zJDE96e95AT96hNIc3tiWvpyAG8MF/VnQGRxvbZ4vHMATAbuCWx4GIeFlhjs
	CNqNgM5ELIcOWxPTzaRTmtMw3DEMbGU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gJiPdzY0;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o92Omq0psZ3ukvz3ytEXVDnarOtbezsCR+bO9JM0kAQ=; b=gJiPdzY0TRltDme/VDbpmSj937
	voGiIUGCZf3gef7x1o6bLNE3mWjRZt2mYVc7BPhPcTWRNNQFndEeftSQ/3vYeJLVJT1roZB2tWHmQ
	URVsY+tmfEYDP9HhZM5fLamP1J8SAp+WeegXyDlN0Z4bVN9uWRFUKgH9GU20hX5GPpD6jfRpmRQC2
	9QQn+Wp/FsAQcqK8JpkX9h+sEJyr9YtkruhstFYaXO7s79ohZh+nRXaFvYWutUTMwwU6ZHwahXc28
	I9t7nAb6ObHn41+9ek5a/PWQ21NefE2VCFPt4dTgxTtjkPZp9cgxIOUGFu5a+s2M0zqiGp41lP0qU
	j3bGGQgQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERs-2LuP;
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
Subject: [PATCH v4 23/54] convert spufs
Date: Tue, 18 Nov 2025 05:15:32 +0000
Message-ID: <20251118051604.3868588-24-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F2E9CC0009
X-Stat-Signature: ic13g988ib5ck7znbu1dnc8jkforrtzw
X-HE-Tag: 1763442973-808237
X-HE-Meta: U2FsdGVkX18yGM2XgCUFuFsYg6Z8mTMzssEZF7jqd2ofyPbuCXYTh14CVWnH5eL6RgJlrRWkoXxWeNzYBHBjcLdgu+OvNagnrfj2bMIwqNE2mEGJ1QistUwY6M51CC6uJFbhm3QHsWYX2DM+l4cqWLnGiHWyiYPjNxdXKtssT8Cda+ZZJkEL/A9L49SpTd2/Li+/JGMUIOBNN7n7CVJsQUkUDIp1ruaD+Q7AWkA2wAZ9urAhxaoAP5i5ChjDW92X4HPCNt4HxkdEfUicQz+PEWbaDiLVRpSsDVD0ypCzwfW3QXW7/ClykOzu7d23V+RzzyGrZAOTjirOaUvSZYmYOIV57Qt54ec/MaP06X2M1koQ47DoZaV/1+WB4X4p13f5YWHmA0zUOn5+WuiE+6C5+/L02hIxVQcVj2t4L0nan0HoC4rk74jYq2jl+OoGkUjroagauDijmS4+soZl6bH+S4lHQTKliZMdS87eSKKurWaCg8XesqFByw9FSUK6yohL2ntMlrzwqr4lXvWAoMCiHz6j2FFJLK5x7hr9ajVH+JgTt5PKyYueYWFFO+XkoFbjqjKfZUS5W69VTixYO7kuGQqPnYrBi04LsLUmgKUQyYuzqdq2vsit3nTRcoa/xoxgFW9M7tRDsvKoznqvtOQiLTx0AYjFHBHl23IlM1BHS8UXeCcno0qyG0RgM+8oe2z41ZJW6MXBZHmIjIDGO7wC1j0Sp3Uzgh5yQj7JvZSkZwGpJj3ZzzdB9mTmlvj6krJ0oBTZJ0T9wF8+KCXEr3sAIAhOIiAMTamL8Z5+PjVC9MuzkZcAJz66cLFEPBwLIEuBaVMLIIUjGmsd87o5zOJQG04FHQM7qL0gasGa7q/Rf8T9WRtdbYyDH98yOer6VBJw9F8nJk2v89qcl1njiVwQl2x2QpWcxfXHU9EoMfAqo0R6+Q+8pj6znfW4dWKB/eC51AlM6TaAn6jcJ+1xLXJ
 e9/1YS5I
 6CWD27uvUF/gtz4yZ6zhMZn/2MizbbVQe3WV7RDpeHk7h+hK67tUFQkisC13xwhsASj7/kEr4eu/yVE8NEZdOyysPy7nB10O/CORUks5Em6mhSoE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

have spufs_new_file() use d_make_persistent() instead of d_add() and
do an uncondition dput() in the caller; the rest is completely
straightforward.

[a braino in spufs_mkgang() fixed]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 7ec60290abe6..fc8ccf4dc159 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -127,7 +127,7 @@ spufs_new_file(struct super_block *sb, struct dentry *dentry,
 	inode->i_fop = fops;
 	inode->i_size = size;
 	inode->i_private = SPUFS_I(inode)->i_ctx = get_spu_context(ctx);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 out:
 	return ret;
 }
@@ -163,10 +163,9 @@ static int spufs_fill_dir(struct dentry *dir,
 			return -ENOMEM;
 		ret = spufs_new_file(dir->d_sb, dentry, files->ops,
 					files->mode & mode, files->size, ctx);
-		if (ret) {
-			dput(dentry);
+		dput(dentry);
+		if (ret)
 			return ret;
-		}
 		files++;
 	}
 	return 0;
@@ -241,11 +240,10 @@ spufs_mkdir(struct inode *dir, struct dentry *dentry, unsigned int flags,
 
 	inode_lock(inode);
 
-	dget(dentry);
 	inc_nlink(dir);
 	inc_nlink(inode);
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 
 	if (flags & SPU_CREATE_NOSCHED)
 		ret = spufs_fill_dir(dentry, spufs_dir_nosched_contents,
@@ -479,10 +477,9 @@ spufs_mkgang(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
 	inc_nlink(dir);
-	inc_nlink(d_inode(dentry));
+	inc_nlink(inode);
+	d_make_persistent(dentry, inode);
 	return ret;
 
 out_iput:
@@ -780,7 +777,7 @@ static struct file_system_type spufs_type = {
 	.name = "spufs",
 	.init_fs_context = spufs_init_fs_context,
 	.parameters	= spufs_fs_parameters,
-	.kill_sb = kill_litter_super,
+	.kill_sb = kill_anon_super,
 };
 MODULE_ALIAS_FS("spufs");
 
-- 
2.47.3


