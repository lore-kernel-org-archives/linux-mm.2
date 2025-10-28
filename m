Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2D2CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCC8800DB; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4D0800E3; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598A2800ED; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF00800E3
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9C2448BD9
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.11.85E3C12
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F689140003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PMdm5O5D;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Swq0voO+aKDUTzOh35qGY7dyE9PZZpqvfSqrFdp+4zM=;
	b=XH9Wt6D48+gW4CwHEjvARElZnc4+8Gcb4Q6NXYim0Bbt0FF1dNLO+soJ84NfBdYkBTROg/
	5V8ckZIwxEF6g+PFSxIoXBNXfP7Jdh9ALXrmPGzHeE6/oGoxd3w0GeOYRcB1L56qznRIQz
	HPwipH1YUSOYtxnI7D2tFqccXpIAhe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=TsJW97nbCksiDJi1p51niok1CXTAK0X/MW+eJznxtgruzzBHG3cVsutrpW2H933cA9LYbe
	E+nYPJJ1t/jEbBRi6R0ZnBXefOoKoTfzmHaUFH8OO7pcK8A/me4ArfH0adNlXB6YA2Ay3S
	8DtLcq2SWdbh240qjk1uzYCnVNEB/Ew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PMdm5O5D;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Swq0voO+aKDUTzOh35qGY7dyE9PZZpqvfSqrFdp+4zM=; b=PMdm5O5DypSxNosRCZjXbf6giR
	S2l8ZgeUeQtWvTBS4262ttA2tRFr/P9cDv0mMkWUuwe6X112adNRzW4r23HUpF/ojuTTWgXjLe+GQ
	MGN+aS+r4bxfpr0KR7QFmy8PEFeN1YlHKPje8zdhE4AcUx5zmlNbcdG+wl62rnJUMyO4EuNgaBSLJ
	oIK0GmpMo6fKsZRSZ076+wfNAUETtrSto0G21f+iRy1y2QzEv/R4O0wcRjPswBHWOm/RLr0f9rlph
	ZhsmjECTxwhWxEmxIN+o/2FR0w6S/tXIoxE+sMzpimtpZHVmHkG81YL7LDa6acIFs6lsUq52pdhlz
	rI//EQfg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWT-2AS4;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 08/50] convert ramfs and tmpfs
Date: Tue, 28 Oct 2025 00:45:27 +0000
Message-ID: <20251028004614.393374-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: crj116nk3at319r3894fimsg3mnyqm85
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F689140003
X-HE-Tag: 1761612383-854630
X-HE-Meta: U2FsdGVkX18aZuhZ80DuADcJ39Lvs5iahFJULesTO/lXw4FOdrTv6rDUS3VAXsDH02S++O+2Ux/KIjv4IbUzOMQ4HZavOcvvKz7DzCL07AeYQXGuUNQ3rmxw0cfFnoFil3ADjiBPmXrNFCbDB5cBoi9k6VBva4hIiQ1FboiXZErvPTMqMrnQRKAmEyQfN3DcWBXthTHmXtNgVPDpW39kVjdVLkQq/DJDqVdCroq9WMee/FWqwXGCx6S0DTUAYNNS6tfXjWMwdR+mWRmpMba8iMh6TKlspNLa+1WC1EXZnjzdxYLJGpQq77h3WTPZuFr7a0iwX55quH511uF6W0XwsPUKhWlTZEZ6N842ElVei3xA+cK4mZD++lxGE9a/k6q2hTHuGCvbtyQbU5dpmAt+EM/QxKXxDANKVnSuoDICt9sV7unHmFrn+sMcMtuV1tmKLzVmC/lYPNthbnz6UzTcsxm2PlBQm2B9IyQ7mbk0RMqHWOGwTCqLSXHsvYcie6ASBOWdRjTOhmtMFzuvvT0Dto3N3T7+A8+P9IBirtYJLGWQ2HCVm7cx4chZUjPjdMNV00BeCLku/Gq+HclTedvipT7Ms6dmIEM1ASRYOms8H9zHix7XOYDHpRxXb+OzqUTpV/rYjsCBV1KhV3g7xPwdXJ+KN0LKv4cnMlTzo2k3pwUja5yL41Na3qjU4ddEP5ySDrUJUaDuBkmKlwZVflZjsr/4zmFdsrst/133hoaMV7MoONL1UIAbTJKb6bMGVUzmCdlEBMsEDEV4isV6Y5MTeMh8BX3slqBVeyeVGVZKDKdqB/bQoAzITm51O1Cnam9/f9UsbzX/XbgNKOoow8CSqKeUJ77AQO3nk6ARm4mSo8tfFmzJIcOBBHZXntJPNe+t0aaVEglEODkEgHLu/ecNAcQ4Any9Ork0JgdnpN6CF929MQeMkALNBoV2FypO/LsznMXYOykPLFY0ynONMSo
 /7pbrhFY
 YiKapaOB3rtwriQoDiRgIwRj4h5vKp1aYOvD5GfgiPPZUWnQoMA7cvKQSqxSVjXRWjTs5qLShYVSoivZTP1Tl8X3RulDbGeBD+KNxmaYOxzb4nPsofFDa93XTtPzwe9BLLU2X2BbJm4uUNDERFBhB3v2iyiWY4k4UFZI4H9h3Rub6JzGhG3fY4YP5QqGF6/0jeXH+3eXOtgHtblZGmjDuzMr7e9jjtIc+15s4oK0YWfqupsIJoYmUv8hcowGVSqemcYAbxgqu3DYO6UJr/R3nRfogGfmgNyvc7NhtuFxXYmaAjEGKQxMKDV9A62r8dG5ZUtsxDUGQuvu6G3tZ96wD8zxaQfjLYDGGzUvfHWAzFFkXaL3TgrLlaVQogKgpdCHPX5TZRFa25eLdzkjRDp7ccEIg5zMpzFtjjIW/
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
and, in case of shmem, using simple_unlink() and simple_link() in
->unlink() and ->link() resp., instead of open-coding those there.
Since d_make_persistent() accepts (and hashes) unhashed ones, shmem
situation gets simpler - we no longer care whether ->lookup() has hashed
the sucker.

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
 mm/shmem.c              | 38 ++++++++------------------------------
 4 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 9d4e46ad8352..a63b0ff0c432 100644
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
index 41f9995da7ca..505d10a0cb36 100644
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
index b9081b817d28..a38f71519813 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3858,12 +3858,7 @@ shmem_mknod(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -3924,7 +3919,7 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir,
 		      struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
-	int ret = 0;
+	int ret;
 
 	/*
 	 * No ordinary (disk based) filesystem counts links as inodes;
@@ -3936,29 +3931,19 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink) {
 		ret = shmem_reserve_inode(inode->i_sb, NULL);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	ret = simple_offset_add(shmem_get_offset_ctx(dir), dentry);
 	if (ret) {
 		if (inode->i_nlink)
 			shmem_free_inode(inode->i_sb, 0);
-		goto out;
+		return ret;
 	}
 
 	dir->i_size += BOGO_DIRENT_SIZE;
-	inode_set_mtime_to_ts(dir,
-			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	inode_inc_iversion(dir);
-	inc_nlink(inode);
-	ihold(inode);	/* New dentry reference */
-	dget(dentry);	/* Extra pinning count for the created dentry */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_add(dentry, inode);
-	else
-		d_instantiate(dentry, inode);
-out:
-	return ret;
+	return simple_link(old_dentry, dir, dentry);
 }
 
 static int shmem_unlink(struct inode *dir, struct dentry *dentry)
@@ -3971,11 +3956,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 	simple_offset_remove(shmem_get_offset_ctx(dir), dentry);
 
 	dir->i_size -= BOGO_DIRENT_SIZE;
-	inode_set_mtime_to_ts(dir,
-			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	inode_inc_iversion(dir);
-	drop_nlink(inode);
-	dput(dentry);	/* Undo the count from "create" - does all the work */
+	simple_unlink(dir, dentry);
 
 	/*
 	 * For now, VFS can't deal with case-insensitive negative dentries, so
@@ -4130,11 +4112,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -5334,7 +5312,7 @@ static struct file_system_type shmem_fs_type = {
 #ifdef CONFIG_TMPFS
 	.parameters	= shmem_fs_parameters,
 #endif
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
 };
 
-- 
2.47.3


