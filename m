Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B9360A381D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEALmezT
Received: by kanga.kvack.org (Postfix)
	id 38A926B06E7; Fri, 13 Nov 2026 07:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361226B06E9; Fri, 13 Nov 2026 07:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EB86B06EA; Fri, 13 Nov 2026 07:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05AE56B06E7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D605D1C36A5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:26 +0000 (UTC)
X-FDA: 85429955772.29.C52F677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A116120006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEALmezT;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyHwOd4+jeDfAjPyHgK3+6sDUh4QP1BtL0Q6LcrhmBw=;
	b=cyQb+xIFi4WqKVErTpgAgJZWFxkkSLs9JoPQwJRx3CDacifmrA0F1xtFTnbBado6N8/BXL
	7T4R+iidLF8oVFe8/EQb6shHbM8cRp0cnfy54aG+2HCE1yEAXKRizLVvascdq+QmrJunOL
	1swsRKLG9XNwt9TuxFxCsBJBr1mapCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571285;
	b=q4TlZFHh882ykzGkocjkCn75jhMBTCStJKriRANYu+JHpsrWP27dCGNtFzNaXzD4hjMeMh
	Mq3RPMKMKQsDINzCRW5TCbZXk23FN7ZAx0RLtGbgRaxNx1llvEkyG6kcpwHPLX+2SXHSey
	qLZ/nHmJnWBK3wcPsegKAVIldD4Dimw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEALmezT;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D19B403BF;
	Fri, 13 Nov 2026 12:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0B41F000C4;
	Fri, 13 Nov 2026 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571284;
	bh=pyHwOd4+jeDfAjPyHgK3+6sDUh4QP1BtL0Q6LcrhmBw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FEALmezTxmWxxdb0868r8C6A7XE6j8ReTGac71NMwZYL8q86Ni45LmKl46O3Q6e+j
	 HZ36T/FdnrbBjmZdirVGAg7sPXgUCqERTP62SFYJzWxBWxkCEy1dxjKQGd02O9dTZx
	 XsAJihopJcZ3KmywvHUIosTnUbbopuincxqzBC0juwNvp7jXJ3YtC5r4dvwlB8/Dxe
	 x4FAYUDhnkoeybW6ltAd+u2aFV8UHBLJZDGyqvAMVVXBdI9oAbpdyBCAhw0gpd1VKv
	 osV3bVHfnqkGXuvs0wvyrUeJ7giwL5bKGpc2coVGc+Y8xDFzRN8u7z5HjYrSooU6ff
	 gT+1Ob2sn4foQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:13 +0100
Subject: [PATCH v3 17/33] ufs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-17-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=7255; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9mHOa4m6babHB1kD3/fBV8phtf7EgziKYaBRboKEiCk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+732WH+ijKTmkxSGotyY580iz9Mn3OOLXnZofueiu
 AUa6vycHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5YMbwP8aUaeqOzSbTa9c7
 vC/WvKP2M9rW27bhivnVvSt6UjZdMmBk2LTP8ykvy+7AOUJPb1yala3Ml+W0lGvH5TKWv4ftXP6
 IcwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A116120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 13kbya31ob3jkgmngemhbjhfma4f6ibz
X-Rspam-User: 
X-HE-Tag: 1794571284-619171
X-HE-Meta: U2FsdGVkX197yShf1Cfib4iV9m36W7JT/G+Na9FHjgt2m9hx5LwBJ0KcXhm8k4N9OlHdPV5nnMC1aJkydwSzXeWPC7gloP+S6Wq6m4TO3dd7+N3QaYXA1LafQW0sB+7t+tTtJ5AIrhDzfJ5M7BMncN5C+JSn5nv+Y2RuG6OZk3PPCNt+srHdpAg3l+JlyBwECmsxEVmP68QtJ0vsB3jDErkbKFlaSmy4L8I0RlC64HUpGbxQxadYlmPsO/EDWrMyYxaIFVuxVoEdrwFyulsLggda+ZaxgDOkSjuo7wtDWBPUO3eFT34CGlPbHitgOmZsR4Eh3k/q85Ww+tZnChDISqjYJA1l2isSE60nYTfnzxcbO6wtJuSKmPW7Z/Uz2gYFKkGPdH5IowrPaSwgW94fXrn+hWfLP+2ghqc+ace1Bw0sSRp8Pb5wJp5XtM/aNcbccPF/JiOqR+pTXIr3O0lWynEIt5xDjTvJRirp5YFF03n8pHlipjIPqvDdebGbCnMYstbTh3D720tbExvP89suaT14XxURkH1e+3vXAeo3YKmgCWVNYQmBiTrqjP6vwlc1A/h/UQc4uztKk2wOQe82SKulbVcSXlI/PlEaNnJVCi5XxsqT0QcIUiz8lIJY9dJmqQb9PYOlEcb13HVfDG1qQICSCwCrcasbPF65Fo4eWboZCj3IO0AJb9fl3QNcdYRAo5sHynaWXGiG3cl1br6Bk3Y7f75/HT+PHgfQKcbxp43jKZWRVbjfooqOrIPcCypm4TbUo7nXFBfWSQHwJM8vqMo8sL2EFcHgQp+zwDdWYqNtk5hrY9d5y+H5oZn/AQZP8toIGK1koyN5xuUPbrwmNAaa745cecRW1XH4q42QaMoBZysvr+a1CsPNFWTufsjNlRcG/A6NBott5B/dXyOOLLJ8B3zZ3oUl2XXG4NvYlTEX9Fze44UqqqTCoBUR1vcwMX0ZR7z+x2QeUWCwEix
 LpESI1BC
 ud5Sk3mOunKyDcxpxPgTtToH9AXORwgDCNT8YHh1hQALsG/Zh5VxlhAjEsfehX81ZnIMWTDpeELji48cC0uNJpybT+KNxOALMgn2nvtSSoZykW6iSyXIUQtZPbv3EUaI0xqQSLwOXvSc0DdXBIVm6DDz7uSjBFhMlUEsymTSM9vq/Bkul1VBI2GG0kfk3q191nYpnRlXlKBtK9Z8F+7i6+EIf+y10bJUpZCky8In9Q4RCvdQqO7moonxWjkv7DlrUPMRCcfA/uQXRoqew51uiOSAdpMjdPuQreYnbGBVQ2RVaREO4z2Cquwlpe8ZUKvb669BAu3xgwkC8IuSQTNI8VcQqp9gYsxEP1d+UxHamBeyU/9oO0hZbegI2jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ufs_error() sets SB_RDONLY on every error, whatever onerror= says, and
ufs_panic() does too, both without holding s_umount. If that happens
while the filesystem is frozen through bdev_freeze() thaw_super() sees a
read-only superblock and leaves the s_writers rwsems locked so every
writer hangs. It also leaked the cylinder group info because
ufs_put_super() doesn't free it for a read-only superblock, and a
remount to read-write read it in again over the old copy.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. ufs_error() and ufs_panic() still mark the superblock
UFS_FSBAD but don't queue ufs_sync_fs() anymore which does nothing in
that state. ufs_put_cylinder() doesn't store the allocation rotors.
ufs_write_inode() keeps working because writeback still writes the data
and the blocks the inode points at.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only works and keeps the
cylinder group info because evicting inodes that were unlinked while
open still loads cylinder groups. Writes through file descriptors opened
before the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ufs/cylinder.c | 12 +++++++-----
 fs/ufs/super.c    | 56 ++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/fs/ufs/cylinder.c b/fs/ufs/cylinder.c
index b930ee1cf8530..e0360873a7f8d 100644
--- a/fs/ufs/cylinder.c
+++ b/fs/ufs/cylinder.c
@@ -117,12 +117,14 @@ void ufs_put_cylinder (struct super_block * sb, unsigned bitmap_nr)
 	}
 	/*
 	 * rotor is not so important data, so we put it to disk 
-	 * at the end of working with cylinder
+	 * at the end of working with cylinder, but not after an error
 	 */
-	ucg->cg_rotor = cpu_to_fs32(sb, ucpi->c_rotor);
-	ucg->cg_frotor = cpu_to_fs32(sb, ucpi->c_frotor);
-	ucg->cg_irotor = cpu_to_fs32(sb, ucpi->c_irotor);
-	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
+	if (!sb_emergency_ro(sb)) {
+		ucg->cg_rotor = cpu_to_fs32(sb, ucpi->c_rotor);
+		ucg->cg_frotor = cpu_to_fs32(sb, ucpi->c_frotor);
+		ucg->cg_irotor = cpu_to_fs32(sb, ucpi->c_irotor);
+		ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
+	}
 	for (i = 1; i < UCPI_UBH(ucpi)->count; i++) {
 		brelse (UCPI_UBH(ucpi)->bh[i]);
 	}
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3569ac92b065b..d82cf73360a79 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -280,11 +280,13 @@ void ufs_error (struct super_block * sb, const char * function,
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
-	if (!sb_rdonly(sb)) {
+	/*
+	 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The superblock
+	 * marked bad goes out with the block device.
+	 */
+	if (!sb_rdonly(sb) && sb_set_emergency_ro(sb)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		ufs_mark_sb_dirty(sb);
-		sb->s_flags |= SB_RDONLY;
 	}
 	va_start(args, fmt);
 	vaf.fmt = fmt;
@@ -314,15 +316,14 @@ void ufs_panic (struct super_block * sb, const char * function,
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
-	if (!sb_rdonly(sb)) {
+	/* See ufs_error(). */
+	if (!sb_rdonly(sb) && sb_set_emergency_ro(sb)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		ufs_mark_sb_dirty(sb);
 	}
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	sb->s_flags |= SB_RDONLY;
 	pr_crit("panic (device %s): %s: %pV\n",
 		sb->s_id, function, &vaf);
 	va_end(args);
@@ -512,11 +513,13 @@ static int ufs_read_cylinder_structures(struct super_block *sb)
 
 failed:
 	kfree (base);
+	sbi->s_csp = NULL;
 	if (sbi->s_ucg) {
 		for (i = 0; i < uspi->s_ncg; i++)
 			if (sbi->s_ucg[i])
 				brelse (sbi->s_ucg[i]);
 		kfree (sbi->s_ucg);
+		sbi->s_ucg = NULL;
 		for (i = 0; i < UFS_MAX_GROUP_LOADED; i++)
 			kfree (sbi->s_ucpi[i]);
 	}
@@ -579,7 +582,8 @@ static void ufs_put_cstotal(struct super_block *sb)
  * ufs_put_super_internal() - put on-disk intrenal structures
  * @sb: pointer to super_block structure
  * Put on-disk structures associated with cylinder groups
- * and write them back to disk, also update cs_total on disk
+ * and write them back to disk, also update cs_total on disk.
+ * Nothing is written back after an error.
  */
 static void ufs_put_super_internal(struct super_block *sb)
 {
@@ -591,10 +595,14 @@ static void ufs_put_super_internal(struct super_block *sb)
 	
 	UFSD("ENTER\n");
 
+	base = space = (char*) sbi->s_csp;
+	/* Don't write anything back after an error, see ufs_error(). */
+	if (sb_emergency_ro(sb))
+		goto release;
+
 	ufs_put_cstotal(sb);
 	size = uspi->s_cssize;
 	blks = (size + uspi->s_fsize - 1) >> uspi->s_fshift;
-	base = space = (char*) sbi->s_csp;
 	for (i = 0; i < blks; i++, space += uspi->s_fsize) {
 		struct buffer_head *bh = sb_bread(sb, uspi->s_csaddr + i);
 
@@ -607,6 +615,7 @@ static void ufs_put_super_internal(struct super_block *sb)
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
+release:
 	for (i = 0; i < sbi->s_cg_loaded; i++) {
 		ufs_put_cylinder (sb, i);
 		kfree (sbi->s_ucpi[i]);
@@ -616,7 +625,9 @@ static void ufs_put_super_internal(struct super_block *sb)
 	for (i = 0; i < uspi->s_ncg; i++) 
 		brelse (sbi->s_ucg[i]);
 	kfree (sbi->s_ucg);
+	sbi->s_ucg = NULL;
 	kfree (base);
+	sbi->s_csp = NULL;
 
 	UFSD("EXIT\n");
 }
@@ -628,6 +639,10 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	struct ufs_super_block_third * usb3;
 	unsigned flags;
 
+	/* Leave the superblock alone after an error, see ufs_error(). */
+	if (sb_emergency_ro(sb))
+		return 0;
+
 	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
@@ -684,7 +699,8 @@ static void ufs_put_super(struct super_block *sb)
 
 	UFSD("ENTER\n");
 
-	if (!sb_rdonly(sb))
+	/* NULL if a remount to read-only freed the cylinder groups */
+	if (sbi->s_ucg)
 		ufs_put_super_internal(sb);
 	cancel_delayed_work_sync(&sbi->sync_work);
 
@@ -1265,14 +1281,20 @@ static int ufs_reconfigure(struct fs_context *fc)
 	 * fs was mouted as rw, remounting ro
 	 */
 	if (fc->sb_flags & SB_RDONLY) {
-		ufs_put_super_internal(sb);
-		usb1->fs_time = ufs_get_seconds(sb);
-		if ((flags & UFS_ST_MASK) == UFS_ST_SUN
-		  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
-		  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86) 
-			ufs_set_fs_state(sb, usb1, usb3,
-				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
-		ubh_mark_buffer_dirty (USPI_UBH(uspi));
+		/*
+		 * After an error leave the superblock alone and keep the
+		 * cylinder groups, evict still needs them.
+		 */
+		if (!sb_emergency_ro(sb)) {
+			ufs_put_super_internal(sb);
+			usb1->fs_time = ufs_get_seconds(sb);
+			if ((flags & UFS_ST_MASK) == UFS_ST_SUN
+			  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
+			  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
+				ufs_set_fs_state(sb, usb1, usb3,
+					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
+			ubh_mark_buffer_dirty (USPI_UBH(uspi));
+		}
 		sb->s_flags |= SB_RDONLY;
 	} else {
 	/*

-- 
2.53.0


