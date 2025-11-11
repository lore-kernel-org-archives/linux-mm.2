Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1E7CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCD08E0005; Tue, 11 Nov 2025 02:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4418E0002; Tue, 11 Nov 2025 02:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1D58E0005; Tue, 11 Nov 2025 02:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2C48E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:41:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3399D88B74
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:41:32 +0000 (UTC)
X-FDA: 84097531224.21.A8FCDFE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8AE1740007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:41:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XROLldmC;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762846890; a=rsa-sha256;
	cv=none;
	b=OIoXbP501TOIfbSaagDOe6FrQW9+DRTaqhPMsTwirl355ddv7i8c1Rwi5pTScqSE/xOSql
	6YKjBFwkkkbqVKxe2QUaqbmSjQvsz+1BQGnDYo3Z6AMsVWtu12GTCzkrqEkAywFZ5lSk0I
	XG4AFRwti52cc0OF8TUH0ONRgW1cvDg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XROLldmC;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762846890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o92Omq0psZ3ukvz3ytEXVDnarOtbezsCR+bO9JM0kAQ=;
	b=sb60Qyx7SYGaDq4mPaM4TT/AyJb/NceIDamwEr9OQzssStP+fy367n3JVvmFsBs8NMXOwK
	58U0Mect7FVWxMAkf28KZLaieqMTnv85r1TQ1POm67Fup2PdAAnUjLinuNc9SgyaTiVrlr
	JPdDOmrfuqFQAqa0q+Nl8gVHk6oZmNY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o92Omq0psZ3ukvz3ytEXVDnarOtbezsCR+bO9JM0kAQ=; b=XROLldmCt6vbuYYnp0vPCUnJ5r
	4MIOfqGi3QUqBs/hPJsIwMOEeht/upSkaIWOnW2RidmjawMf5e6wCTzF33KPnTafLW1GSw2Si61YT
	heqXkOg8l0moj1QBWrtiM9s79RsazBTl7Awrry1FBsjrAvW/GRHjFGLCNSWHPimn+tVy8fVHPGQnb
	psoxEEp/YzziTl9UE5ntlhzLe7Ehqk4xBfnw9YvLvC+S2Wkt0YpkfZDjXgujxxk0wFO5OG772DyGu
	Y2k7crP+0mFlSAG6DRFWOmavK9Ut4mE2/AvyVdyQICVc3J3mhlf+B3B3qxi5YYSbQHia+dtZiqOul
	VPcxn56A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000BwzL-1HAm;
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
Subject: [PATCH v3 23/50] convert spufs
Date: Tue, 11 Nov 2025 06:54:52 +0000
Message-ID: <20251111065520.2847791-24-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8AE1740007
X-Stat-Signature: 6fiy8az3rx8xfowy6zmhj7dd1g4rih6h
X-HE-Tag: 1762846890-438572
X-HE-Meta: U2FsdGVkX1+zswrRA3YJLe/xpWpBxDkzYWIsHSm3DJ5kOeuCE93jE5auvGQiKuQGjtERa7Xh1HlzK7yBvTTnayhObNWQ6QxR7GqOG6xolVeMAgmRxIolg65vGGLizCa7RdP3asBqMrFqbocjp5TRtuYZFZ05ASFUTFCELN4TG9TVyYbN4wwHKlGHnaUiLpf4onFIu8HXQvkd/1tfjpyeb0d6N92Eut9Wnc7N2/pmJQBOtumjvmpeghVcW1Y8wqNhkkGtDzL2SbVIup/CN0O738U7whzYW/QClDgGgL+MrI/00D0SkGKl2S4YrNHl+OxeBvPPy8u89N847sQjoePvmpiOFu5Q35ENiVCoqG14G1qucSHc1NuClaHAM1D8fInpChU/U9bJ0JWCt24Mmx97aKVsfwMjbAgMVN+32mlOZWvbwrdyDMFVJimS1Rsv3qyhH6RX1h7/rAxDQ4pyg5KE9jMAPdrWE5haY3zFqgCHvNbF+PwR3dTTClssQXougkGftt6KYcnYFLDx4iLKfgtFrVfxLGZpm+Y4KVZYQMkg3L8oXdpye18L6rhZWL61rOAYhxK8hAaQwxC1VOHLZW3J8vw0NiaWo1vpDClrQxjbVS4ZzSE3ulFt2m+jIdipjDf62ZdSYcEm7XI4myvF6wvz/+IMb/SukPqI9e4TggM05Tt55bVe+V+1LpvGi0IaGwiwRht84WFgmQtyu8QNyNwMj5UKqjdxEAmPsm+xp+7zUsyRZSkn/4NCjPrXVPzwSJXkRW4G3gmmX/OKqG9RvO6HsTPCHPilMV056Mw3xkdkiI0RTQDfHootuB7+sbyY4EpHtQU1zwfQbZ6PB824tpOHrih2o6P9AHxIGZBMm5dn+ShubhSGC/T7nKjt3Nej6MCbuAFkXpocnNFSZkmM7FEtz8Nl3o/l0yM4OskRc28WldRdyZv+PQEMkfuHyHleVjheFSxSJmryEyVHhUQcfu+
 alc0RIng
 rt9ycYSnH1WeLm8aY7C6A0vmrcsS0Vb3v8nrCofkVsBH8fQ8GeyW3dBSfhMFQVSfF110xtdBejgE/zv6BlF28rtDK9M30kSWIL74ngyyjZUUZN1OEt1Z6Tc9mB5c07o4ag0YToPqhC+ocM2Te1qbjUjIe3d6KIROJEcbWaRfyKGsBb7x/Ye4/MuuWwsKlb3NJXQ8B7sQNVhP3pwuQMua+fX7BkvB2ODh7dmecQ6a9R8Slx0GVR4+4kC5ffpAWxdpWuf1zsU+6iTU2r3cyFgvHml/jMbGCkIslNwnsYCu7rX+ua86gJus1fVfFKgHKX6dc/s3MWcbSoO7ChMXACCa/VwKAqik0M8OmZduaQXoczJR4OqQkHx0wCYhdau5A+T4CpKWO7E5sN/aGrKQcxBWN2vHRN1xpsDqW6pS7
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


