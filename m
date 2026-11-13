Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0C160A6F4B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4PJhCa9
Received: by kanga.kvack.org (Postfix)
	id ED2E56B06D6; Fri, 13 Nov 2026 07:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA2B6B06D9; Fri, 13 Nov 2026 07:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7EA6B06DA; Fri, 13 Nov 2026 07:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFF146B06D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46AF11602F4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:52 +0000 (UTC)
X-FDA: 85429954344.26.D57F92D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83ADC100016
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4PJhCa9;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fO/77PxjazTXozaWYmXfnUNBIcfWAA9M213KUMdEO2E=;
	b=LVyb7CgwoSZj8fTaMsySr/+zSYtrH62/+pYnFtePb5glSKChahto2f5YI0T9NZqoqZG/il
	/O7GerFRD+byU5/bmRAl8y/8Y9uJ5C+vCHIXDZ6iPxSwm9QOrCUxo6p1NVPQPakd/ugQRb
	Ha5DjE16uKGjeqJU09FRqDggPIfKYe8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571250;
	b=Qv84OCrO1MPYXFizdfV6SG506xyEP1e47goWS09Jre2Z4yDtgwELxJJVoeBxfKUMD8BTrP
	p4j/i78qrPNl+137zfgreLCYcgDOn33eDpGX20T1JQzfIniZUQKiaOyAGiojMi/9z+ysYL
	89oOZ9Ue/BcT2MY/yUEX//uc17JBvaM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4PJhCa9;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27AD6612D0;
	Fri, 13 Nov 2026 12:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4455C1F000D0;
	Fri, 13 Nov 2026 12:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571249;
	bh=fO/77PxjazTXozaWYmXfnUNBIcfWAA9M213KUMdEO2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O4PJhCa9GmprnCSodb1Tvbb5kApzBmc9OY3BjB+klV4lzQqGkYLRy4J9XCwPWpgSe
	 xbwQUYHBIhjx2aSoPuJ+YCZ0M9uzKPLEU0OXxmpUcPq28r/yrwofrICt9RE2KfGMXT
	 0P9zk91R8g/+C8WyS8lIR7JipZtseBKB75Vi3tDqIhrAXzoU2OeaLi8XuvQiCB+ydM
	 mHYj9piJvtVu4YrS77Kz4D0t0eLFN08qSngK45yf60mjQ0rcyERqc2U9vHRbawZQPm
	 kewOhL5htAQCPY93n9kLf/hq1uqgXcQIM0wC6m59Nfoyxu2ghl71D/f9J8gPuPh0Yt
	 gB3NCmsUUkouw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:05 +0100
Subject: [PATCH v3 09/33] fat: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6918; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hJjqcETpnF8Bw85Y5EMVd99FPp/4PHlnKsk14i9xJCk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73k3peNa5ziZH+ZT1ELYw4+uesn+5H7Rk2sP/jlF
 yvX+fnodJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkTx/Db9Yqy4MBDS6hZlsO
 Lplv8Oe/8oaXf4q65T7I7D50+OGTnXwM/wNW7r0ZHML9PKJIeIqbSv6pmtDjirnnKx9OyT79Pvy
 hFgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ukhrfeghcszucyof3o315wftoqcryket
X-Rspamd-Queue-Id: 83ADC100016
X-Rspam-User: 
X-HE-Tag: 1794571250-290823
X-HE-Meta: U2FsdGVkX1/Bnay4Wl4bTQofwpEZnpB1aaDeOBtOX4R3AW6wX4FKNMra0YyCGr/g7653mw11X477Z1YUvuKrn+bOnEPxJTwIFOjWxABAL7bXjWy/5EqTjvPVlUdmyRHYUKHYd3WMysZIUBSYfcFivKusiBnzggIkrErlXhKJafgpbLM5Qrlrs4uZw0QDXdwlNpBONZKpNw9wbTTkn3gd/h9r7bCUG8R4Acvs4DZYEgMfoLYTSOluEzfDVpFwkIaWRyw7JrKUwztV03+r90PwwXkhgR7FzQ2XoovKiQCGBtxb8nZKnQI8uf2S7tcjNOxv7+foG60DZRBPWGw6yWf6rf3y7FuMVfXKyNi2eWlP3d32xGKKG4N3x3+XKxn152cJmEGElnnx6YbKGEKW+Tm/VTFitoxe3l08zZGmVn5Dm8WaGm4b4EzxV7ZPCezM7N7ZEO/pNV0akcNrXlMtMfCBsBePR8jt8G7ZaSu5zM2OaJadIqDz46RNimX5HNBF23fLcy3WoC0X3LDe244TtSBrhqwS8jTb2U3LYeFcOS7R+NvJqpSBtq/CfHob9DZH3V5JLU2E64IwsGeYeMhzxnnJTXsClwXrJrpeqTmVt5zOHOmPZmcsR8UPkapvPgLt/xHpeJF2PYb6T1HQ5QOq4fSVShU5WJGdLahooUvPhvv7BlzZRvTVkdD3PF0lM4QiV7VyVbruEZyDhavM7KSx9uRKtaET5Hx1b7J4pXjeQigEIJc3aXx5/aCHTqonPOKfVzyK4pIjQ7+mxmpdD/arMGaaoi+mXy92BbGB56AMmJQW6jI57NPAJXXUutbczHza96BwSxbxPSbwR4y+n+R1xBRfKtDIKUMytpB0/nDXemTEyuEVWsdOhLC3MuxqK4DmfG5Fl7dR/WlNWdb3FFueBZRuc/rAMGhTYqsf35MlkJeyHFlWlt/Ofe4ah6z+ZMfyEfDVruAzyZgY3LRcqiHQsxH
 8GtLFHw8
 3STQRuLJorOPZsldyoAlG6TX0FIDlQt3uHiWhL05jyXWNOWcb+mMvkuRKNLevwKq91BNOgTjWQslnwIvdAzfntiGHbm4QlWL++xAdOYhrAHCc68mtEYhgUgy4GbtHGoKr2D8yD4PPJzS5jKoIUsTmyQa+pfrURVHClyMcydFHqOUAe5dJhUd009iGmmrvcrf2l33A87az03ZpVkG7H3uUnhxs2ZxJMvMxDGDmZA6ywzjBWNDs/aNbSMrXEEG22YpurV9mW2j6Uw+b9CpGRO97MoW3SREkUJC91u30VW19H58IqUD/sP15pKURPX76OlQbawUPAQYTZRYhU2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro, the default, __fat_fs_error() sets SB_RDONLY
from whatever context hit the error and without holding s_umount. If
that happens while the filesystem is frozen through bdev_freeze(), e.g.
by a device mapper suspend, thaw_super() sees a read-only superblock and
leaves the s_writers rwsems locked so every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. fat still refuses FAT writes, cluster allocation,
write_begin, O_DIRECT writes and FITRIM itself, leaves the volume marked
dirty and doesn't free fallocated clusters on evict. fat_write_inode()
keeps working. Writeback still writes the FAT and the directory blocks
and rename and create leave the new entry with cluster 0 and size 0
until fat_write_inode() fills them in. Errors while mounting still set
SB_RDONLY, nothing can freeze the superblock before SB_BORN.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only doesn't mark the
volume clean. Writes through file descriptors opened before the error
fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/dir.c    |  3 +++
 fs/fat/fatent.c | 11 ++++++++++-
 fs/fat/file.c   |  4 ++++
 fs/fat/inode.c  | 13 +++++++++++--
 fs/fat/misc.c   | 19 +++++++++++++------
 5 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb62944a2e..553034bcbed40 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1329,6 +1329,9 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 	loff_t pos;
 	bool saw_eod;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	sinfo->nr_slots = nr_slots;
 
 	/* First stage: search free directory entries */
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 2d10a815a5797..9e4bb0140320f 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -314,7 +314,7 @@ static void mark_fsinfo_dirty(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb_rdonly(sb) || !is_fat32(sbi))
+	if (sb_rdonly_any(sb) || !is_fat32(sbi))
 		return;
 
 	__mark_inode_dirty(sbi->fsinfo_inode, I_DIRTY_SYNC);
@@ -419,6 +419,9 @@ int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	int err;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
@@ -513,6 +516,9 @@ static int __fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluste
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, count, err, nr_bhs, idx_clus;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
 	    sbi->free_clusters < nr_cluster) {
@@ -620,6 +626,9 @@ int fat_free_clusters(struct inode *inode, int cluster)
 	int i, err, nr_bhs;
 	int first_cl = cluster, dirty_fsinfo = 0;
 
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	nr_bhs = 0;
 	fatent_init(&fatent);
 	lock_fat(sbi);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index d4f1b360b9743..3d0a81994fb70 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -135,6 +135,10 @@ static int fat_ioctl_fitrim(struct inode *inode, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust the FAT after an error. */
+	if (unlikely(sb_emergency_ro(sb)))
+		return -EROFS;
+
 	if (!bdev_max_discard_sectors(sb->s_bdev))
 		return -EOPNOTSUPP;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d85c8fbdcca46..2779583c64423 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -228,6 +228,9 @@ static int fat_write_begin(const struct kiocb *iocb,
 {
 	int err;
 
+	if (unlikely(sb_emergency_ro(mapping->host->i_sb)))
+		return -EROFS;
+
 	err = cont_write_begin(iocb, mapping, pos, len,
 				foliop, fsdata, fat_get_block,
 				&MSDOS_I(mapping->host)->mmu_private);
@@ -264,6 +267,8 @@ static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
+		if (unlikely(sb_emergency_ro(inode->i_sb)))
+			return -EROFS;
 		/*
 		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
@@ -662,6 +667,10 @@ static int fat_sync_inode_metadata(struct inode *inode,
 
 static void fat_free_eofblocks(struct inode *inode)
 {
+	/* Nothing can be freed after an error. */
+	if (sb_emergency_ro(inode->i_sb))
+		return;
+
 	/* Release unwritten fallocated blocks on inode eviction. */
 	if ((inode->i_blocks << 9) >
 			round_up(MSDOS_I(inode)->mmu_private,
@@ -710,8 +719,8 @@ static void fat_set_state(struct super_block *sb,
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	/* do not change any thing if mounted read only */
-	if (sb_rdonly(sb) && !force)
+	/* do not change any thing if mounted read only or after an error */
+	if ((sb_rdonly(sb) && !force) || sb_emergency_ro(sb))
 		return;
 
 	/* do not change state if fs was dirty */
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 65d02f2edec38..05d061b594a67 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -14,9 +14,9 @@
  * fat_fs_error reports a file system problem that might indicate fa data
  * corruption/inconsistency. Depending on 'errors' mount option the
  * panic() is called, or error message is printed FAT and nothing is done,
- * or filesystem is remounted read-only (default behavior).
- * In case the file system is remounted read-only, it can be made writable
- * again by remounting it.
+ * or the filesystem is made read-only (default behavior): a mount in
+ * progress comes up read-only, a mounted filesystem refuses all further
+ * modifications until it is unmounted.
  */
 void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 {
@@ -32,10 +32,17 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		va_end(args);
 	}
 
-	if (opts->errors == FAT_ERRORS_PANIC)
+	if (opts->errors == FAT_ERRORS_PANIC) {
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
-	else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
-		sb->s_flags |= SB_RDONLY;
+	} else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
+		/*
+		 * Before SB_BORN the mounter holds s_umount so SB_RDONLY is
+		 * fine. Later it needs a remount, see sb_set_emergency_ro().
+		 */
+		if (!(sb->s_flags & SB_BORN))
+			sb->s_flags |= SB_RDONLY;
+		else if (!sb_set_emergency_ro(sb))
+			return;
 		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }

-- 
2.53.0


