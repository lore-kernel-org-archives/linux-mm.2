Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB4ECAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06688E0008; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819768E0018; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB108E000A; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2924B8E000B
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC7A8878EE
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.07.9B360DB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5416340005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jtFtOrXI;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8YKDw/ZJpGmy7UJsDRR+U4SJc3qy9aBRX8nF/jK6hA=;
	b=2upkaBku6rgGSpeUVsPNxWBoKnSNu5fvB1HLEvhw9UALwoGRbgpG4Gyc9yudVwWX7zgDN+
	6CqjixwRgdgbNZrMADLx5s2DmWQfmZ1AvzdLkaMyx1D5/Eaj73739VCNv0ogH8ib6GykLR
	1hqkgCeK2d0MS4cfihRpoYqwCJaKTes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=tdBQkgha+19RLLDZ7QlRnz2juu595g3g4mNqV8c2+pGmd/dXNQbGStptk8za5XBIJDkryt
	SECErJNw4RTdXGtzcHxQOJNwshRWLwH7zPZt3F52qizx9l22He9CSpoacP1nwkGcN43SxZ
	oojmGZV5KmnhqWFOr3+JSqaW3YttDn4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jtFtOrXI;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A8YKDw/ZJpGmy7UJsDRR+U4SJc3qy9aBRX8nF/jK6hA=; b=jtFtOrXI4fTFhphzd0e6wCmi/7
	JjfIpq8JVZN0EjhyoCpioom7D36QQWeM+yiMqXo7UyNAhDGENLZfaj8CgT9raBOYi92eUtrZBfY64
	yZGwFoe3hLGxZEx4WRUtBKsP5JJ+4y6mIjY//tlqgYfDaBin7dr80b8nU7eqvGBcO9GVLeyEWOfPF
	6WhTRHOHnHnr29AlRGpEtJLgKI9r0mB9rJqxXoL8Trk34PZMr51jToLyVUzZzH5/5NvFaCW4gfAO3
	sWbSLJeMzU+YOYGsK/VYRApWAeTTG7X/44xYcs26iWLUm/sobfmkbIRo3Bx1AJdpGHLMEdF1eP0VD
	nUnMHeyw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExC4-3HZU;
	Sat, 20 Sep 2025 07:48:00 +0000
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
Subject: [PATCH 06/39] convert ramfs and tmpfs
Date: Sat, 20 Sep 2025 08:47:25 +0100
Message-ID: <20250920074759.3564072-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5416340005
X-Stat-Signature: 6h7c14yo7tpkdes37kgm5di9iu4ngx7j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758354486-286317
X-HE-Meta: U2FsdGVkX19SbWptq75JFzi/tXmDsiX8nHB7PlCWob361rD2qoPb1llRc3SpAV7VyQQT14RGDH847NI9pREiLoJezjekT89QyGQotmDTEOG/UNs1x9p6Lr4A+fQC8JKJGXdPNcYSSuUeDzVmWVJm8hxzuwgZMIHQa6hgjQfmVZ7RZXpARRni91s2cOLds5QbxbMgmGc4vuWBBuqLKMWksFp/Su2oZ8vJge2/J7s5gaBk+kLwI+m1agIAxoh3YRXF5qI1UY87RvFMS9SR0ISFSxI8BXqTI5IEpUNpF5L8tmiCd1t6C//uAfIqwcCyP0nZ+SsiKCyYGoOsddPHWeaiKa0QC78BrKP+sZteoDJ0xBq4tubghj5l3KVOgk0rJmKcU0rYx6E4zAZbTrugrn4RVAVDriBqCe4WmZw4KsksdjuDEBwxpJ78r2WxiKVPXCE/3lFA19BOvzcaCpCCS7kyuWWIqTWcU42rDFidGk8kICNxOE0z8rmiqUbX7ASJL573zYzsbomkjj4I4Qy91kPJGWILkSPMFTVxsJCxLY0hRBCgE5KzmbvnOAYnIVwHyXEBBX+3nu4bUPgsnPt4nWz97Jpfk8ewy96c9aSHA2M7OJ+jLekOZAlfTcAXgocug0e51RLtfHwIWKRLmWlvtUw7BAsWoxrp6CTSrISLNq3y+kqacWEtxcL4AUb9VSyy5shurTScfi0/eAu/h6S9Rx8V6nLOACPjAKrJ2PShIvf9Nm6xSufR3n+mH+IAY2HJwckksK+iTBjHKiRk/yBeP/34kU2aE2nuFM/rbi33XCm9v969KjsIDJ7Jbz2RP6lpfSeBjJazy6TVhVwv+VXLsrBWE4DQ3/0h6mQcotWyxJiLuKdlKmTtB9bmavaH7wK3VJ6TZCLe2UyPg1vfHyLSWLkkXg+/awX+j3uAu5qFm8SktLocfXf3SS9jkpX3Y8EaRr6jzToKnpvWj5ckuFOux4/
 kTMHr4e1
 PN3sb2IOUlMWllSzfgO1s/2g5MOJaLKPwWc/50uIY0kwEqyJWalFTf6bjYd8ukC62eyRnU7UWsCpvjXx3b3k1fC8XCJp3UkzTjvnp3uNVdd2X5CHgF9/6Gea2TFVjSnEpqDMrxyR+VAEqD3GJtAOQnuNGWkGCNKGu6pTMvEelrMO7U0XLHiNXXjzoSiMj07d5ORJWYGwuLWDYa29j1EZ0BoyBaV/EbIyGI0+Th4G7S9y8pqatj2iu0V900Wgd8Ooq02x8cXT5lDGeljuSdqH6Q6qUBFHV4aPXGPyccdXAD6uBH4wWk6lcJV667CS7UTsjN+aZgghjD4bMMgz41T8n3795dllE7ayVszpW0M+eU87MEgs4pLHFI4kElDCIdw+Q2PaXCNjO5bLIyAXo1fv7+dWLCmzHhAinx+Un
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Quite a bit is already done by infrastructure changes (simple_link(),
simple_unlink()) - all that is left is replacing d_instantiate() +
pinning dget() (in ->symlink() and ->mknod()) with d_make_persistent(),
and, in case of shmem, unpinning dput() in ->unlink() with d_make_discardable().
Since d_make_persistent() accepts (and hashes) unhashed ones,
shmem situation gets simpler - we no longer care whether ->lookup()
has hashed the sucker.

With that done, we don't need kill_litter_super() for these filesystems
anymore - by the umount time all remaining dentries will be marked
persistent and kill_litter_super() will boil down to call of
kill_anon_super().

The same goes for devtmpfs and rootfs - they are handled by
ramfs or by shmem, depending upon config.

NB: strictly speaking, both devtmpfs and rootfs ought to use
ramfs_kill_sb() if they end up using ramfs; that's a separate
story and the only impact of "just use kill_{litter,anon}_super()"
is that we fail to free their sb->s_fs_info... on reboot.
That's orthogonal to the changes in this series - kill_litter_super()
is identical to kill_anon_super() for those at this point.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/base/devtmpfs.c |  2 +-
 fs/ramfs/inode.c        |  8 +++-----
 init/do_mounts.c        |  2 +-
 mm/shmem.c              | 23 +++++------------------
 4 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 31bfb3194b4c..30b5ae8d79cf 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -70,7 +70,7 @@ static struct file_system_type internal_fs_type = {
 #else
 	.init_fs_context = ramfs_init_fs_context,
 #endif
-	.kill_sb = kill_litter_super,
+	.kill_sb = kill_anon_super,
 };
 
 /* Simply take a ref on the existing mount */
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index f8874c3b8c1e..3cc36b1c60b3 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -110,8 +110,7 @@ ramfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 			goto out;
 		}
 
-		d_instantiate(dentry, inode);
-		dget(dentry);	/* Extra count - pin the dentry in core */
+		d_make_persistent(dentry, inode);
 		error = 0;
 		inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	}
@@ -154,8 +153,7 @@ static int ramfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 
 		error = page_symlink(inode, symname, l);
 		if (!error) {
-			d_instantiate(dentry, inode);
-			dget(dentry);
+			d_make_persistent(dentry, inode);
 			inode_set_mtime_to_ts(dir,
 					      inode_set_ctime_current(dir));
 		} else
@@ -313,7 +311,7 @@ int ramfs_init_fs_context(struct fs_context *fc)
 void ramfs_kill_sb(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type ramfs_fs_type = {
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 6af29da8889e..810878fb55b6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -507,7 +507,7 @@ static int rootfs_init_fs_context(struct fs_context *fc)
 struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
 	.init_fs_context = rootfs_init_fs_context,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 
 void __init init_rootfs(void)
diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b..2d5832a1e67a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3922,12 +3922,7 @@ shmem_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	inode_inc_iversion(dir);
 
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_add(dentry, inode);
-	else
-		d_instantiate(dentry, inode);
-
-	dget(dentry); /* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 	return error;
 
 out_iput:
@@ -4016,11 +4011,7 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir,
 	inode_inc_iversion(dir);
 	inc_nlink(inode);
 	ihold(inode);	/* New dentry reference */
-	dget(dentry);	/* Extra pinning count for the created dentry */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_add(dentry, inode);
-	else
-		d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 out:
 	return ret;
 }
@@ -4039,7 +4030,7 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	inode_inc_iversion(dir);
 	drop_nlink(inode);
-	dput(dentry);	/* Undo the count from "create" - does all the work */
+	d_make_discardable(dentry);
 
 	/*
 	 * For now, VFS can't deal with case-insensitive negative dentries, so
@@ -4194,11 +4185,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	inode_inc_iversion(dir);
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_add(dentry, inode);
-	else
-		d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	return 0;
 
 out_remove_offset:
@@ -5395,7 +5382,7 @@ static struct file_system_type shmem_fs_type = {
 #ifdef CONFIG_TMPFS
 	.parameters	= shmem_fs_parameters,
 #endif
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
 };
 
-- 
2.47.3


