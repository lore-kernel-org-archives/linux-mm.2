Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56220606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAhdl4fq
Received: by kanga.kvack.org (Postfix)
	id 479606B06D2; Fri, 13 Nov 2026 07:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE3C6B06D6; Fri, 13 Nov 2026 07:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CC26B06D8; Fri, 13 Nov 2026 07:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05F786B06D2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2E1F1C33EC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:48 +0000 (UTC)
X-FDA: 85429954176.20.0DB28AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9126914000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAhdl4fq;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83Rx4lxHAigAFvMox5os5PJcxLMzTjusx4xtzuuPVx0=;
	b=xuib82SzzMfWsNZjSV2szHfjt4+7gAM4BENHCwqpGvdf2/AqLhqEVYU0N75pbdlHFHqOja
	eoUUthBLmpmQwBiDnUOJfpAv+eTx3J7JDWBeUaYfIcwavZrw+PHVlrkFErUZL7MHLkOHKi
	NCOdfMYhca82cxIE3pBVpqhUT/r+Gjo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571246;
	b=o5FdaxRHnq6aWN/hOS0mYZDPZB7BVv5Bc3aO160A0Nat3ogGxydB91z/Mw4rV3kvKrhKDN
	/hkcJOf15EpMjDR+LnN9n3dUfXuVgS8AwZ8AXT9//2i3kj3v1dbAUv34SdztTfFbJWFH21
	LHsJ3nDUWJ45MpqwiqTswlDOy1DHzHE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAhdl4fq;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB79645967;
	Fri, 13 Nov 2026 12:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836A31F000C4;
	Fri, 13 Nov 2026 12:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571245;
	bh=83Rx4lxHAigAFvMox5os5PJcxLMzTjusx4xtzuuPVx0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XAhdl4fqWyAtP/y7HKOpuWHylk9tnSpclY3d0xvy7toUj9pWD67SH7X/5Rv7Shh58
	 Yfr0XmjQwfYEFYQOZQWUkxnQvm21ZpuK/uxUBU550jXaxLQTH408xon+YCRYFH8xfM
	 1xPe9fe7YOrhNN6fu2w7GYhEQSRGCU0sC1GXKFj5/8+ZOqHeHpILFbT47f2Sw78aBh
	 jpL5UMIzft3rxj/lmeKIr/r1pkCbb6OSX07Q3Q5Ngqli1cVTl8tigSp97mWs9uoFgX
	 iWrvhfY4VEZqF4mOswWw5tz3N9TZ7rztQfgtR661VTvw7fv5VLssx4qGSCZjYtfwc2
	 rTuo1gmQUdJgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:04 +0100
Subject: [PATCH v3 08/33] nilfs2: don't set SB_RDONLY after filesystem
 errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-8-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8933; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ChCf728zzziUBmxI/JldYwrjB7RGogCjXnmWzqdckL4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73owrGwiugnyd8uKXX8lSgV6ompEfy3jqEiu6ycP
 VdhctuJjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkU2jAyvK5KjLrE3j2jM1xN
 9yjjCdt9u7YfFPM4e6t32zIO4z02FYwMPxU8n4u++2I2T9z/R9IJxcRLOyX6GnT+uUvJLvnzyZW
 dBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: b3qy53nzdyg5fha7nj53fg3bo56yxqob
X-Rspamd-Queue-Id: 9126914000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571246-707244
X-HE-Meta: U2FsdGVkX18V0NoAGnme+k1TXX+RtCV6NMrPyjKG8mKhSNGPeooo1BC2uqoAadpSjgdPceLS8w5F7PxDYU9vRpcpHneJ2A/ille/QoWvUTRgoxgMqJZUSgpAV/pdQfO+UlZe39+c3CeX/OaxuCcD31ZCSxv44xkCXO5CzB8QWZb/zSaJ+RTpZOWmjgtfIEklMleba2YTJ1hIOklHsWRTTYWz7eXe/xnQ1JoGIgOhkKmUvWYjwRJbdcpJH1Du7d97TiUZkRErMTEETMeQGJayeO8rz9liaddT9OIrqmKBiFnv55YxkCfyjiMUjfN1k5woMIPxLD5TnDMBdud6jtqFYTUpbAr2p/9kW5lOudiZtnrdJx0byusWlPHu0m0iYuTuNdVJkYqT/svzovfBxkLN8pvx+rMUiWS6U7sM4WqvJaaYJdYTlp5huJLNrBHgF9AK3Q4db43MAiQB812lp3QYvzUSCiDXFNwVTGxtifAhd8lpeX0jc0hH/KbBC3ktrIevr42QaHsaBPhNdBmp6YqjAay+VPv8meDT4lF4LtG+YHym9eD1FUvDkrnrUOIP4W4eulyfIkR/8kJkeVxFD1YEY8LO5c4edh/PS/YeBLJltokm5T2mmBOhpVtKuvyNx5a75QjVPwCaHkhDcN3LzzK4XexTF2RSTr4Qd4KKKF7v6rW/XZAQm1loqm6oEsiFM0HH1/rFkX96lSdwltN+Y3SGtPtKg16mM4qBCAWTPyNS5Nub03/9BjjVC7gYjiH4bMshZQEFyKE4Di/3sY4FGU5yqwate3Q3VmWthA02T5s7/PWNnhyuaabHUeNArZwj2E/2C6e2GJomZf/4VjAyZh420LGiz+zXIKWn1UYTuOE3Wwp2c411iJeR/DERVejQ9WXbgmNSdOpdm9YQBRyWULmLFQfN39UhdF1i2iSs1azGoT6aA8/uoH3Fw+lujKXZne796hFHWFn8pD8iXooi6Wi
 bE/g21g/
 GXxRuoigFmBfBEKM8NCnKM2lUa9Xi/ZsV3rhImB8kgLAy6QrL7OPq/wUpEDthxbphanWES70jV8iT3jQW3Gr40DE4/yRbDMJ1HK5nlkVtIXDbF5U3ATiyvm3LgnHlbga5l1DgIQFUSeRkZcl+bTy9Vxrs8qcYhayox6JZZwPNiAIsn4b5veW6LPZozVBRwK3ApcAnS0vkOe5KzXxry68BubMFPYJGJw8lrHKzyNo7fPaDxN0X1+5X05LjQcEkVt/p+Y99Wm3ula3kJ3r91cxvpjCv4kNUI3Lge+0ItqMuoVURMWw+r3z84wtri+MvY59vYo0kRi/8xllINQgtCDoGImI1oZTk/waFsVzfFHibjCzIas3Ji/xM+YLIoOXsTh/DwU/bEHSxqncyMhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro, the nilfs2 default, __nilfs_error() sets
SB_RDONLY from whatever context hit the error and without holding
s_umount. If that happens while the filesystem is frozen thaw_super()
sees a read-only superblock and leaves the s_writers rwsems locked so
every writer hangs.

nilfs2 already treats a runtime SB_RDONLY as "degraded because of
corruption" in a lot of places and that can stay. So call
sb_set_emergency_ro() instead and use sb_rdonly_any() for every
sb_rdonly() check that guards a write. FITRIM is refused and a remount
to read-only doesn't write anything anymore. The VFS doesn't call
nilfs_sync_fs() in that state.

nilfs2 explicitly supported "mount -o remount,rw" after an error so far.
Now the state lasts until umount like on ext4. That includes a mount
that reconfigures a superblock only snapshots kept alive.
nilfs_get_tree() does that without reconfigure_super() so
nilfs_reconfigure() refuses going read-write itself. Writes through file
descriptors opened before the error fail with EROFS now instead of being
dropped.

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nilfs2/inode.c   |  4 ++--
 fs/nilfs2/ioctl.c   |  4 ++++
 fs/nilfs2/mdt.c     |  2 +-
 fs/nilfs2/page.c    |  2 +-
 fs/nilfs2/segment.c | 13 ++++++-------
 fs/nilfs2/sufile.h  |  2 +-
 fs/nilfs2/super.c   | 25 ++++++++++++++++++-------
 7 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a99a69e9f91b7..1e336af4a471e 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -162,7 +162,7 @@ static int nilfs_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int err = 0;
 
-	if (sb_rdonly(inode->i_sb)) {
+	if (sb_rdonly_any(inode->i_sb)) {
 		nilfs_clear_dirty_pages(mapping, false);
 		return -EROFS;
 	}
@@ -848,7 +848,7 @@ void nilfs_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 
 	nilfs = sb->s_fs_info;
-	if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
+	if (unlikely(sb_rdonly_any(sb) || !nilfs->ns_writer)) {
 		/*
 		 * If this inode is about to be disposed after the file system
 		 * has been degraded to read-only due to file system corruption
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 686ac53498bcf..42848601b394c 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1050,6 +1050,10 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the segment usage after an error. */
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(nilfs->ns_bdev))
 		return -EOPNOTSUPP;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 77dc2be2ce652..876a32eedbb17 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -400,7 +400,7 @@ static int nilfs_mdt_writeback(struct address_space *mapping,
 	if (!inode)
 		return 0;
 
-	if (sb_rdonly(inode->i_sb)) {
+	if (sb_rdonly_any(inode->i_sb)) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 857926da9f21d..9d787c6dc6190 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -259,7 +259,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_lock(folio);
 		if (unlikely(!folio_test_dirty(folio))) {
-			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+			if (WARN_ONCE(!sb_rdonly_any(smap_inode->i_sb),
 					"inconsistent dirty state\n"))
 				goto unlock_folio;
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index af0c3560444f5..05c33c978b82b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
+	if (sb_rdonly_any(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2099,7 +2099,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sci->sc_super))
+	if (sb_rdonly_any(sci->sc_super))
 		return -EROFS;
 
 	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
@@ -2323,7 +2323,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (sb_rdonly_any(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2356,7 +2356,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (sb_rdonly(sb) || unlikely(!sci))
+	if (sb_rdonly_any(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2870,9 +2870,8 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem is made read-only by
-		 * __nilfs_error or nilfs_remount and then remounted
-		 * read/write.  In these cases, reuse the existing
+		 * This happens if the filesystem is remounted read-only and
+		 * then read/write again.  In this case, reuse the existing
 		 * writer.
 		 */
 		return 0;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 5888ed479c8bd..4711d75e92357 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -76,7 +76,7 @@ int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 		int _err = (err);					\
 									\
 		if (unlikely(_err))					\
-			_err = WARN_ONCE(!sb_rdonly((sufile)->i_sb),	\
+			_err = WARN_ONCE(!sb_rdonly_any((sufile)->i_sb), \
 				"unexpected sufile error %d\n", _err) ? \
 				-EIO : -EROFS;				\
 		_err;							\
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2e3b591c117c9..add1bb8a16646 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const char *function,
 
 	va_end(args);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		nilfs_set_error(sb);
 
 		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-			sb->s_flags |= SB_RDONLY;
+			/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+			sb_set_emergency_ro(sb);
 		}
 	}
 
@@ -508,7 +509,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	nilfs_detach_log_writer(sb);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_cleanup_super(sb);
 		up_write(&nilfs->ns_sem);
@@ -588,7 +589,7 @@ static int nilfs_freeze(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	/* Mark super block clean */
@@ -602,7 +603,7 @@ static int nilfs_unfreeze(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	down_write(&nilfs->ns_sem);
@@ -1083,7 +1084,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_unload;
 	}
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		err = nilfs_attach_log_writer(sb, fsroot);
 		if (err)
 			goto failed_checkpoint;
@@ -1095,7 +1096,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	nilfs_put_root(fsroot);
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sb, true);
 		up_write(&nilfs->ns_sem);
@@ -1141,6 +1142,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
 	if (fc->sb_flags & SB_RDONLY) {
 		sb->s_flags |= SB_RDONLY;
 
+		/* After an error nothing may be written, just go read-only. */
+		if (sb_emergency_ro(sb))
+			goto out;
+
 		/*
 		 * Remounting a valid RW partition RDONLY, so set
 		 * the RDONLY flag and then mark the partition as valid again.
@@ -1152,6 +1157,12 @@ static int nilfs_reconfigure(struct fs_context *fc)
 		__u64 features;
 		struct nilfs_root *root;
 
+		/* The VFS doesn't refuse this when nilfs_get_tree() calls us. */
+		if (sb_emergency_ro(sb)) {
+			err = -EROFS;
+			goto ignore_opts;
+		}
+
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
 		 * store the current valid flag.  (It may have been changed

-- 
2.53.0


