Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE42E606E00C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPzI4b+4
Received: by kanga.kvack.org (Postfix)
	id 0F8FF6B05F7; Thu, 29 Oct 2026 12:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A76E6B05F9; Thu, 29 Oct 2026 12:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB09C6B05FA; Thu, 29 Oct 2026 12:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8FF96B05F7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1862E12044C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:23 +0000 (UTC)
X-FDA: 85376148606.07.BF2F19C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A553140008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPzI4b+4;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQCxXsTbwof9FUg6Ix787w22LF6YubBqqIH8KJ6MCDE=;
	b=vkuu7WD2Mt+0N9Uc4kRHfBfQiqSMwcKao7zpW2jwQiE4W+2JWDyA/JB3OH2FpmiGZk492D
	iKQuPpIbBfKl9d0xsmAy/fpTDk7+i1o+GwIvEfKhWRw2cUwS+hwhJ3cnUvX6FkU5jw5gU/
	5Xvx6Yynv9e8LDPkIHgjMbjMmHV2l9w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPzI4b+4;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290161;
	b=jY8HqTDCM4QB7h+G8BIM9qsmbT7nYp4B3p7uQeT4YIZmgRgTsz6sb1syI6Pab9kymWA8FZ
	UZ5gH2zBYLmT6CyeIFmj9IqXtUmF6VlPv9WIUU6FBJjUxogdLQmG4od/ulYJDC0uC0/xT8
	UzhN2P3sZAw84VnDz1T46/Oin3d9nvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D65216062D;
	Thu, 29 Oct 2026 16:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13B41F01824;
	Thu, 29 Oct 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290160;
	bh=eQCxXsTbwof9FUg6Ix787w22LF6YubBqqIH8KJ6MCDE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JPzI4b+44MGHLq4Jf1Gd4otwA/YDDR9WxZIZKcBtPYvVLxg/NVjj0FSUl04NGD2UF
	 jW+QM9NGcJ8xak2TPxWrHzDPZWsqhQZpmf3e7baLAZcqmOEyqRQFv51S7CZqCBb4ac
	 L6XwWdAsCey9Ual2ko+9VwDzSQk3VqQaRkiLecBFhzzuVikzgtCdezSfjS6hRkvMLH
	 U/N7Ctvgg+K8gvHTFhjxufgGW2WB29OW4MRVU6GRO17sWpTay79NvLRfX8CghFCIEC
	 HxFOPT2Ot/wN3eHNjYIeDLuWrUzgbMFq3kzaw8rT4HrXFXsFEIClPDfvwd6J1cAeEm
	 8E2KYC0d+8GfA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:19 +0100
Subject: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2955; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/l/eYRwD7NiCvHpR0M4Ent49C5EEBbats3rfxEZnvhM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjc437ZtHl/b8osXnrN8PqroI20dtn0u773jdfe+R
 in93ha3vaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiqx8y/I8+fdTck0/0T9Sm
 R2ZFJzZ1leZviTm5Wqdaa8P/dzYRjCYM/9RevWHu7F/ra+K9+1tjgk3Rmwynj2dXLHg2QdjwwLR
 FJUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A553140008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oxapot9nkytydesmxjwcwwyoucqztb9a
X-HE-Tag: 1793290161-915057
X-HE-Meta: U2FsdGVkX1+RXA1D4iAH1qt4mqrv5YtdtKjNSnMv7oxxi5kiN325Z7+1y65EuZldAD1erteWwbN+vudowQrYV0syCUfND5frF8i0ntpGzrNdYSeBuPZAUSfzKxhgFxWRDUf6fYxwgTB94buWS7M6pDvjzkvPyH6V00zu2NTecGHWNcBwUz6TsJmL6tXO27dx7TLiCMadh9L0D5IbrmMPBS5yxMS/Yb3n8nA4esiOUGLrIiuLgmCQCAi2FlDdMVCJWJNKyfIhdxUm8Lx2Pahmg6dAe9PeC5dnEdWNvSmtS145ESOF1XHmFG08ZreO+Jhu4FKLDIHhHkFw1Gc1A0SST/kyF+eoITEKTAe9Gxor96AuVg+9fa7SoXCKBcqQb8OyewNcnwIhzBeESJo7yZ7YWO3EHXOApFxRsLAoyEYzXEpVxiJ96xNfPosah4oSJJIBZT/+lPEHl/oXvVRWZuB5hH+0GL/YCXPpcfIa3OzIYDcC/yd49kxCw79kONv/3frd1iHrBdyEYIf9rPcVrpdI+WNBQq0Z0Gqk/jqSREecaSqItZws3voP23qJoihSk5hxI3leZ9tRo3X3RTOvpg4RKGvmSfTFstCViZc8jebUMMu+YL9DHYLp4PWBf1qn6Dn2RMgMrD9/4sfGqnwdykjd4dZo1hvOXv/YppHiDo/+uZ+oqiM/deGIgmEZm3cp4gmZo3htV0zOfaacT7P1rvsH+Pwl/L98Uv2UPGlqv21Tkpe6lzmWyRnAZZRfXVuSAPX/CXSdva9F5KDjw97LEWUP381xCB5h9CPBJUwT5QhbNHfKiBBp4DSuUGD80tSKa3UoBpD489Q4d8ND4KeMb4wMgZQcahoyTzoAH5xFRNAgA6ZOMAs/PdXGT8W1uLAYsmEZKKsO1JJG541Tifl0GiOjbelQFts81oDUZhY2cKRR3JkN1bl80BWWnbMJXWYEGxwcUZ7tIGRazVlj+LAFw8P
 9fJ3xt7N
 ggyKpgrH+6k3Ka3EuPW/vm36+f+pdsdKCBWoQXO5QM5lQksScWT8UmaNsdGHu6mZGViX8DDS1vmtJhu8ki7rutXsW4nSi8d+8fT0orduXsxy2ExUi5S19gcI6b0/f+HUcwOfuVl+sxBFnL4f0kwJ2t3DBs0+5SxtFpw0EXTJrhp6R4t1yC2Li8SBSeFnySADokCm0IJ64crkYy+ZXxlNq87vpYtAm6pi/582nyATbp/im3Xw2R3wqN2lZuvYDw1K8YIJ6E+36y+kxHapq/X0OSfMXxen5dusEMa2V75LNYD6rASD9K4Xo0+O0GIf2CfpXDmzNAf0WvuQaxGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
the error, e.g. a failing write, and without holding s_umount. UBIFS
can't be frozen but that still races with everyone else changing
sb->s_flags. And c->ro_error alone already makes every write fail with
EROFS.

So only set SB_RDONLY while the filesystem is still being mounted and
call sb_set_emergency_ro() after that. The xattr setters check
c->ro_error as well because ecryptfs calls them without write access on
the lower mount and they change the inode in memory first.

So far a remount to read-only after an error was refused and a remount
to read-write went through and cleared SB_RDONLY again because
c->ro_mount was never set. Now going read-only works and its writes fail
with EROFS before any I/O, and going read-write is refused by the VFS.
fsync() fails with EROFS instead of taking ubifs_fsync()'s read-only
shortcut.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ubifs/io.c    | 9 ++++++++-
 fs/ubifs/super.c | 5 +----
 fs/ubifs/xattr.c | 6 ++++++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 6c6d68242779..7a59aa1ea5ce 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -72,7 +72,14 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
 	if (!c->ro_error) {
 		c->ro_error = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= SB_RDONLY;
+		/*
+		 * Before SB_BORN the mounter holds s_umount, later see
+		 * sb_set_emergency_ro().
+		 */
+		if (!(c->vfs_sb->s_flags & SB_BORN))
+			c->vfs_sb->s_flags |= SB_RDONLY;
+		else
+			sb_set_emergency_ro(c->vfs_sb);
 		ubifs_warn(c, "switched to read-only mode, error %d", err);
 		dump_stack();
 	}
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 38972786817e..ef39da4e780b 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1977,10 +1977,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
 		if (err)
 			return err;
 	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
-		if (c->ro_error) {
-			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
-			return -EROFS;
-		}
+		/* After an error ubifs_remount_ro() can't write but still works. */
 		ubifs_remount_ro(c);
 	}
 
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 3b0e8a270f59..572f6f3e52ad 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
 	if (check_lock)
 		ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (size > UBIFS_MAX_INO_DATA)
 		return -ERANGE;
 
@@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
 
 	ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (fname_len(&nm) > UBIFS_MAX_NLEN)
 		return -ENAMETOOLONG;
 

-- 
2.53.0


