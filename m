Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5236606A8DE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMQuyq+6
Received: by kanga.kvack.org (Postfix)
	id 7F57F6B06E5; Fri, 13 Nov 2026 07:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6CC6B06E7; Fri, 13 Nov 2026 07:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E30E6B06E8; Fri, 13 Nov 2026 07:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8596B06E5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2FCDA0234
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:22 +0000 (UTC)
X-FDA: 85429955604.20.3F936D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D605F1A000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMQuyq+6;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571281;
	b=oGbojhuvMBbi2rONF2eG0pFLoGDkXD1sf3tR8PYCxXZvjbgRCoQXMklB6t+uOeBZLjT6NJ
	E0G0igJB7c1632Mb1fnfgetO7CX5bfIJ8xDW8AAkl7JHU6id1G8mU3Fw4JpYVPN+FCnx2S
	rmFhYxVJ9xhpLMZ10pgcvbmoAHcce+Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMQuyq+6;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GszE2anAQxCWM5fQiE+znviLqpcjSCVYI4wX3Rv50lw=;
	b=6QzU5cft/2LwKEa7WUyofJ2a7PyzQWrcWw9zlAVmiTFCFyuTmXQDpTp7QgnaYFRmkTMrv+
	2BbhiVY9H7i7KZPUE8OG0GCqeSK5XbR0fGpX4QVw4OXnyPUJyqGTyNhCJ+lVeS8VPTE7fs
	1XAFlrGCLA3bhgbiw5MY7c8ousRaAdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D3B94630A;
	Fri, 13 Nov 2026 12:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7672A1F000C5;
	Fri, 13 Nov 2026 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571280;
	bh=GszE2anAQxCWM5fQiE+znviLqpcjSCVYI4wX3Rv50lw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TMQuyq+6p608xsqKXRQqwgGlwSiM0dRFCXDUPlf6N0gX0MxCWF3e1DGAdkn//5+tV
	 YznW11mwNZ30EOc7xDIGsEhvmn1N2+9yDClEf9GWCFGLUfO7rdTDHPl2aQPYmVvaao
	 7cZSykBwXej9Oi1uLjQYdatvZ5LdlYdCCuZ9Bs4vgavxO5qtL4zICJHtanvG3kZ+BT
	 9JhSKJhCLFj5pd6NCWDkdrAA9cOVsadSEE6XqCDa3Y+TXkywSsCmzKxTyRVw0UqhRy
	 qD+lu2S/s8bi0oYPoSxdA5pAoL15RT2lffhHegCUbGYXGTDp/icKPjuu+641Ly5cU3
	 Mt1Ch42vm5sEg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:12 +0100
Subject: [PATCH v3 16/33] affs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-16-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2952; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nlF3ceMBkFeAzDOwb5efWgYEsyPK+IFw+V5w64DXzAA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71m00LxFRWnTCUtLaYL6N2zbF/MKnflzZQ5Xb5L5
 3k/ObdepKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiS4IZ/tfxTH17ZNFmu+3p
 m3WyZku+DV51TzhCYU9D5u1n6x5fd1vB8Fdq9y35Ywsst0yRestWOvWxToz0LvGtbi8ynL+uPtv
 22ZgVAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: h6ozs7ja5szk18gfidrox9e719e1xzg6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D605F1A000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571280-299523
X-HE-Meta: U2FsdGVkX1/xsjNa3Wsdh1RTG6ij/YG2c8EjJepLHrpolNrjUs1PZbCD6+PW7bwUa2klTwIfv94i8o1jcaKkaEIE3JtYpfTA/DCB+gUn3SZrzoC4pI4e2Y97Kd5ft1ciqP6gR0mwn0EWqahvGJYgpfw0d/SkOZFJLb83MhxVymg2qLH5VU/I5awHqbiTuGY9ty+qEbgI0xG/UCG1a7+joetI/BcOj013g7eELRVM0CMlogI5imuxwsEoHMPZBYfx7KLt1mrmYvZ9NQCmFpSzb6NJOJ4PYHT4TCdLzHGycYWLaaBbXlrir3nOhyaPLoNnPIFtGbPK09o+GexVQGs1tb5QQnD/ZPppRM+GoJm8ohUJ3Im46CfihKjjq6pn281T5OTju1LtGIxE5NyyLJLG9dCoT5hkw0Fv4QZCJxJmQFHDRQhJkwNFUCzxDaZqbfWN4BVM0Np/u7OQuuXNLlSbHNNpooPQX9PHfy4hVzo4Yms4Q+oaiAR2+MXO6zwHlLDQXf1gfb+MEGahcl9PZ1UvFfonBEJ65bptFlNehW1Rp6L9Sstyh1NOqQIiNbGrCo/VbJzNx5Pzix11IeC3bn4TUo0vgl7N2tWwOTVjEYFl9JDTzjINlyE8bI9GLDtEk05KJXmeXAQsGsLZRkwcpks2m7ke4/UVSorDAC932eE2t7rf7bA4FQ1XYbXqz11d8EjNFou7WhmH6kbJld3E43/utGbstsL/QM/7LLJkff3r4FBOrdnqJP7vxnOIPZZWhSD8uZ1IamFKd5wse3VBK/vtUWu+HPQj+hnjrBW9qyeANxx0Swvis8lUUeAZ7OiJHgpEqwnD4F61zml2Ixg6AaInzjlYYTQ4fC9GhoJ/OpHa15s8dv/94oBFi3qd9GAqPcxjpcOnmPJAO7NBnN2bVEF+sMLTmtozz8tilcI3hB6A81A4coIAOupLX6aTpbK20yqP5GRude5/n6kagkRkjHn
 QzQqLijB
 njOQFEovtmnLfsdvc44oaiyMP25RD1euZ14BOK8oVI4uu1eiYbE3rkIbqW5PM0B5VldnVRoEscvlcuMMeqU0O4pB/Wp9uuQipNzMmyitpeIm6ZJ3/QP04d5vSxnjjHaVvAWB4bPJYuMpgDEEZN8jqUMF/43GwIeUVPo3q4yGaeNR9R6PlLDnvZ/1UFc0CSU48Xh9yHXUx4ppbh5C6Q+SjACgkiCHnjFhZwFVIagj/MSaz3SQ6Y/qN94nr/ayM07RXVdSbEns8YjQXRhil/U2qA6rD14HBJ5XCzbzPYGA8n67Q+COMUq7pwsxOsFYZFRgO4Iw48SVHbPmPRFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

affs_error() sets SB_RDONLY from whatever context hit the error and
without holding s_umount. If that happens while the filesystem is frozen
through bdev_freeze(), e.g. by a device mapper suspend, thaw_super()
sees a read-only superblock and leaves the s_writers rwsems locked so
every writer hangs.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. affs_commit_super() leaves the root block alone in that
state. affs_write_inode() keeps working because writeback still writes
the data and the bitmap and extension blocks the inode points at.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. A remount to read-only works and keeps the
bitmap around because evict and the last close still free blocks,
affs_kill_sb() frees it. Writes through file descriptors opened before
the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/affs/amigaffs.c |  4 ++--
 fs/affs/super.c    | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index affa20d2b73d0..40ee1998ff337 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -483,9 +483,9 @@ affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
-	if (!sb_rdonly(sb))
+	/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+	if (!sb_rdonly(sb) && sb_set_emergency_ro(sb))
 		pr_warn("Remounting filesystem read-only\n");
-	sb->s_flags |= SB_RDONLY;
 	va_end(args);
 }
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index ed8225b3c93dd..0957af26652d9 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -36,6 +36,9 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
+	if (sb_emergency_ro(sb))
+		return;
+
 	lock_buffer(bh);
 	affs_secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
@@ -82,7 +85,7 @@ void affs_mark_sb_dirty(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 	       return;
 
 	spin_lock(&sbi->work_lock);
@@ -550,10 +553,13 @@ static int affs_reconfigure(struct fs_context *fc)
 	if ((bool)(fc->sb_flags & SB_RDONLY) == sb_rdonly(sb))
 		return 0;
 
-	if (fc->sb_flags & SB_RDONLY)
-		affs_free_bitmap(sb);
-	else
+	if (fc->sb_flags & SB_RDONLY) {
+		/* After an error evict still frees blocks, keep the bitmap. */
+		if (!sb_emergency_ro(sb))
+			affs_free_bitmap(sb);
+	} else {
 		res = affs_init_bitmap(sb, &fc->sb_flags);
+	}
 
 	return res;
 }

-- 
2.53.0


