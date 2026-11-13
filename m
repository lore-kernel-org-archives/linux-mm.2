Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F21606A8E4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elY+zSgx
Received: by kanga.kvack.org (Postfix)
	id 203F76B06E9; Fri, 13 Nov 2026 07:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB9C6B06EB; Fri, 13 Nov 2026 07:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3666B06EC; Fri, 13 Nov 2026 07:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4956B06E9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A72C1202B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:32 +0000 (UTC)
X-FDA: 85429956024.23.4DFFA7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34C7B40002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elY+zSgx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571289;
	b=C2kYUJKBg2iny5ooJY8KHn1nO5vGt62PIXlsK35KBlk6gdlsigiJCT2tYjEhx7tj7/xwhG
	3vZp4QiVbfmeRSc59HnkS2mRlVQB4saRGHTcvLMih1rQDPt8dV08CF4HAbB4Q8AnTddR1k
	M1WAdFgZ2SfDrnDXvojnKrwRsx/cS+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4eB5Dae7Sw/Y7CJq0k+uuFPd5FO+2UZBB1BVu7ssxw=;
	b=iVMqGc3Ax55DmXwzz6eHHZwh+ylzVVbiP4osQF9GoyEOBI49/cc1OVxOl3uQAUPRx8DDyb
	1qOOiRi9pjkIkd2SaYwndEQNVG1bWzLF5HVHQuT20Lvx08ehGp4wbmsb0Fh72i8NFrW0r0
	SfxRlAeYCpSBMP4rZ4XBbmE+zkuGPnQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elY+zSgx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 847054037D;
	Fri, 13 Nov 2026 12:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF461F000C5;
	Fri, 13 Nov 2026 12:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571288;
	bh=a4eB5Dae7Sw/Y7CJq0k+uuFPd5FO+2UZBB1BVu7ssxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=elY+zSgx46kAT30TrktLqFL52t/0jLP66/o7rayM9UjLNOvIrptChzKfVlig/t/A8
	 TkOlcTA3QtyTLtgujK0u8UWI6NtCkHEnWYt2Nrl7wtWHp5ky/Rq4nZghfWk5KLFRXC
	 DjLP9XrYXK2nvKDdyCIYIwXN5osA3Rn4RJX1xx1nqMb46qFxuGkZm4vqzkENZvXsj9
	 ANgBqIeNwdB/GnfiLfE0bupPa9Mn7ovVkMOZs8uDD+NaQ34J4TZxiVLeYoEAddQ3Vn
	 oOhD5SAVdmT8PNqtR2Oc9MbCOz0h0eHzeLLzu/qOaoFZF72Se7aquy2VhDjs2Vg1HI
	 9vWV3eDNl2gJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:14 +0100
Subject: [PATCH v3 18/33] hpfs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-18-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4436; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AS7fasJ+R2NTq4wSuHXyshwNLuujPLnebXBr0XQhoiw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73u0CSHSp1ZybYrOvoZPsxjunNmxsrrR6c8X3Dz7
 fuKbNaY7x2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATqbnLyLAtIJZL/TFfgtCC
 FRtEHpTdcHg2wV5ieWBN3K3qCKbrDvIM/2vW7zha831q9ZSHmp9+MtyOvP3Ad5H4w3c2zuIH8mM
 WMLACAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 34C7B40002
X-Rspamd-Server: rspam12
X-Stat-Signature: g5nrksg98yu7d16asu65q735juq6z6mi
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571289-845587
X-HE-Meta: U2FsdGVkX186ZCHjlRJIngaWXby5q2KBSVi3JAkYYEqwH/mV5cBZWZ9iigtkQ0fAsm5AB5eiKaDHWsJMk8V/Z35oJnPopYT9PtcPfYkSOBswbgBtlI2EKVJkYwdKHLGTrbp5InbuUZu8rH1IZzXQgB4WVkjkEAsxEHwAxfnAbPlb6WntsENmPif2hzY/8fC19rh9eJ7YChuWvfM8hlgAZDpkkoonkavIhZipNhpydtUSFqkjsaNmz6PRaCVqz+Mk49gD0w3DGQ2R2PPhX8t40Cv7dTzYw/JmNrWtQCnxmclNJUxR+NCj5S/ldt/jTre2CJddKQCU91flJ4c8OvcSTGd9whxWoxPsF6vJycW8/Ot5yE3Dh/xjghwCYK//fwKUnMbeDEAXX658a5+ZNRUcbMiy9buSNTuna2Dqr4neDEuYWOenlDT8pFLLspSVQKJLPIOfbnMB/QGWOdR9LQAQfA+btcptCbZO1RsJxm4EF7huf2594gNzOTWMwpVhlHRHItNWJXF3JCi8+XK87/K8cDDrv9fSaUj+dthHXuwYXo2M0uaCg6WKYCOGh7J4wXE9LPiY1uQMnkXDIr8EqIKnhWs92wWMa+pvwhYAKgaQwwbMRB8pknxn0Qgll1iFNd/lB3PV/DLV/tDaraj+zLat1N54HZ44E7Eh/ObWI/iYu8rYbQ/3yUM5STZJR7epJmRjOXBwpV6/wy9gaJsDxA6jMmGr0xANxNDfXVFWyNu0tIwUEBo7ciYNubUk3MKN7Tn8FKN/k5NBIDoKZgrVhH0E5PPDzIzZgt63f55zTAAabD0lwAOh9rMCKeYH7jlIrDQTgk/YoqOy9hG7WuTFACH0IBfS7GHjDsp37ySty5VQlmlNR47RnzHU+sFUl0fFT5nQyZ9edhoUxbvcisOFWF1K+oTTLx90AZnkz0PbHp0JsqZnJnqSXAdJx+tfLx7oYJt32AXyA+GIqNIe1dN1Aqs
 qu2geC+n
 1R0CF+55gP1iUKpAgv6dP84VDLu8nPtgoklYZWPsHzYGUHBysva+wycq+FSYInbqfj/EjNd36C8n73lYn593LPm3kV7a3qeOCTHfhGrM1nKPWZtu9H5cqFKYjJcmkjT3057zOomhjPaLSrkLRJL24Rffs8gZPaBffNgYW7ngEFdQU7YBYiVpulA1Q8sqcDQxD8ojr5C/kPHi9UWjMKZBTagDxPR7h4Mt+iKgf59cbo/Yhkm8EDctwDYLv6QRc6j5UW89dcjGScgXA7s7Hidn9HddNoKaJ8pmJamwhToMci5b3N9IrPs6owymmQn1Qq8lJf5E75an8Onkf4hBcmPclcuD0YRFm6NoYhezxonTq+Un10o0azAsDnQeWv1mpWdH5778eVgcFDNIK//G7r6k+Mq+GoklGl2qM58sZI1IKVKNH/zeK86JMMZIgRawOX3GO8EFdif7n/WzBKpr3zRD4mppLJqfCHCSjk3BVpew+m65AQwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro, the hpfs default, hpfs_error() sets SB_RDONLY on
the first error without holding s_umount. If that happens while the
filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
superblock and leaves the s_writers rwsems locked so every writer hangs.

hpfs_error() is also called from hpfs_fill_super() where nothing can
freeze the superblock yet, so keep setting SB_RDONLY there. After that
call sb_set_emergency_ro() instead and let the VFS refuse modifications.
FITRIM is refused and unmark_dirty() does nothing in that state so the
next mount reports the volume as improperly stopped. hpfs_map_dnode()
and hpfs_lookup() treat the state like read-only so lookups behave as
before.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only doesn't write the
spare block. Writes through file descriptors opened before the error
fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hpfs/alloc.c |  4 ++--
 fs/hpfs/dir.c   |  2 +-
 fs/hpfs/map.c   |  3 ++-
 fs/hpfs/super.c | 11 +++++++++--
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/alloc.c b/fs/hpfs/alloc.c
index f5150372618ed..15b12afa856a4 100644
--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -539,7 +539,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 		return 0;
 	if (start < sbi->sb_dirband_start + sbi->sb_dirband_size && end > sbi->sb_dirband_start) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly_any(s)) {
 			err = -EROFS;
 			goto unlock_1;
 		}
@@ -560,7 +560,7 @@ int hpfs_trim_fs(struct super_block *s, u64 start, u64 end, u64 minlen, unsigned
 	end_bmp = (end + 0x3fff) >> 14;
 	while (start_bmp < end_bmp && !err) {
 		hpfs_lock(s);
-		if (sb_rdonly(s)) {
+		if (sb_rdonly_any(s)) {
 			err = -EROFS;
 			goto unlock_2;
 		}
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 3bf11202e2d3c..a82c06635b891 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -265,7 +265,7 @@ struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, unsigned in
 	hpfs_result = hpfs_i(result);
 	if (!de->directory) hpfs_result->i_parent_dir = dir->i_ino;
 
-	if (de->has_acl || de->has_xtd_perm) if (!sb_rdonly(dir->i_sb)) {
+	if ((de->has_acl || de->has_xtd_perm) && !sb_rdonly_any(dir->i_sb)) {
 		hpfs_error(result->i_sb, "ACLs or XPERM found. This is probably HPFS386. This driver doesn't support it now. Send me some info on these structures");
 		iput(result);
 		result = ERR_PTR(-EINVAL);
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index be73233502f81..9cfda43215cc9 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -288,7 +288,8 @@ struct dnode *hpfs_map_dnode(struct super_block *s, unsigned secno,
 					goto bail;
 				}
 				if (((31 + de->namelen + de->down*4 + 3) & ~3) != le16_to_cpu(de->length)) {
-					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) && s->s_flags & SB_RDONLY) goto ok;
+					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) &&
+					    sb_rdonly_any(s)) goto ok;
 					hpfs_error(s, "namelen does not match dirent size in dnode %08x, dirent %03x, last %03x", secno, p, pp);
 					goto bail;
 				}
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 8fbdbf0806276..a9e26ae2e3752 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -44,7 +44,7 @@ static void unmark_dirty(struct super_block *s)
 {
 	struct buffer_head *bh;
 	struct hpfs_spare_block *sb;
-	if (sb_rdonly(s)) return;
+	if (sb_rdonly_any(s)) return;
 	sync_blockdev(s->s_bdev);
 	if ((sb = hpfs_map_sector(s, 17, &bh, 0))) {
 		sb->dirty = hpfs_sb(s)->sb_chkdsk > 1 - hpfs_sb(s)->sb_was_error;
@@ -81,7 +81,14 @@ void hpfs_error(struct super_block *s, const char *fmt, ...)
 			else {
 				pr_cont("; remounting read-only\n");
 				mark_dirty(s, 0);
-				s->s_flags |= SB_RDONLY;
+				/*
+				 * Before SB_BORN the mounter holds s_umount,
+				 * later see sb_set_emergency_ro().
+				 */
+				if (s->s_flags & SB_BORN)
+					sb_set_emergency_ro(s);
+				else
+					s->s_flags |= SB_RDONLY;
 			}
 		} else if (sb_rdonly(s))
 				pr_cont("; going on - but anything won't be destroyed because it's read-only\n");

-- 
2.53.0


