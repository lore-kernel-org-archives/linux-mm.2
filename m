Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A51860A260B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApHOtygA
Received: by kanga.kvack.org (Postfix)
	id 1696D6B05D1; Thu, 29 Oct 2026 12:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141536B05D2; Thu, 29 Oct 2026 12:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056F56B05D4; Thu, 29 Oct 2026 12:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDAFA6B05D1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 289C21A0496
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:24 +0000 (UTC)
X-FDA: 85376146128.17.60E255C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 561F1C000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApHOtygA;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j99u7pP3jHqCnfV5WtBilQ5GA+9ufePIWzsotxmVBBU=;
	b=jpBcb9jBs9Kl9k9L879TZL0swPYmHnZ1ilOcCQocuIq/lSIt9GRAMjN3vBAn+1AbfwIqfN
	SuP8iVNi/SnzXC7WFBqDCdyT/rAaejykIMq6jApdlEEWGpL8t6JVLJd3zO4PbQKnCKLI/g
	CQ/Xsl5ry/aUnh75L/b3zAFFE7Flwz0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApHOtygA;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290102;
	b=ZURx9pwpqQFdfTm7mn91P2QNvaBvqceQX0Fny439QPRFRth5578ewSQhQPT9xE+W0hmz9J
	8p6VbxduhYv07kn/dMhrASAHv6dernRba08lY/zCUPA+T7W0aVCP3y5n6/xTrtaKyDv/ls
	9VFspHWG60LyDlYPCliWy/5eJq/BNq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B319440600;
	Thu, 29 Oct 2026 16:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003F01F01825;
	Thu, 29 Oct 2026 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290101;
	bh=j99u7pP3jHqCnfV5WtBilQ5GA+9ufePIWzsotxmVBBU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ApHOtygAYie4o6OfC8p8riQyw/hRIKEDv65ljECOi0GbxgJG8hhaZZCSLV1Kaqp/7
	 zEmzGeCD+Mvtk8xp67myAQ9KKZCf2+iEgF4CbfBNy2R/ycA7Ayj9+MHo4CuSKSz61c
	 97AX1RHHqupm/dYhQryHBkxTxqUwAlTMkzWKYY3l5Fy8hBc9SDCG//kmewuIXKdO8Y
	 eNjVoewC3BCUxPV8ygBSL3Q+rzosvTCaK7215ZYw7839CsPKnIY9PEQWrVdUizRJtW
	 0AdJ/13Y/G8NVfaL8At+9hFR7AjOYUc4m9btUTtz5wTd0beeT6PMjKoTfoXo0MFXr6
	 uAmCFZl0/UEiQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:05 +0100
Subject: [PATCH v2 14/34] affs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-14-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3169; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aNVN7e+XHpPHKN9tOY57qjlfaGO8JcRJCASZQZdJlkw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zte/Ebh0pecj7qbpW7nSayITpWwXyx4OFPh5/sHzY
 0LrXyq3dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkETMjw5VvW8XD2QTabio7
 bnE42Suz78+K12eY1aYxP7iW9nt62i5GhqtLpBKr/zsWnqrKZ1e1dVY784VncfucO3Oyrwe/dPn
 4gQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 561F1C000C
X-Stat-Signature: er8ffqi7ik8q3kmico5zduat8d8dguhg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290102-634389
X-HE-Meta: U2FsdGVkX1895lARR98Q4bxAI3FuP5NqPRkfTuRSNBCSLl1UJgUks/sd7XI3UnJbmsVzvALsUcTUwhRSMO2EqKvEl+dFQ92ZpChm83asZ4p/5pLxrM71OELekTkBDZCWGKQexFDQ42gxwZJqlQK8fuP0Ok76hKJqbsNLXrxmhRxyw/bc9KE+UsaJjvaIp/kH5mYT6Rav7ppMtyURiluUIY92sm1vs3zY07ck/llU1uxDtRU48zosSIsCUhNaTe214aGin6icnxQs8GY5YmJRKhZDgDMuR55xUTSYalC5Cd4IZ/OTh3QekYo905fFv+PMyXkuCygHcdjeib+mRpW7GVOU+jhD2nWhoxOU7/HpH5bWaWXILq1DiWgjJ/OChiA4HjmBnFeWsruUmpV6Gr8zqPz/Q4FaQfnaFKiM9BXzqNbIov83fqJgIN59RarJatCHearP8JyMCZREFxNmpMPBTz8TTq0XZA9HFN3OS02reQq0LFo6DpbTS9AlU8kficcbG2C1dzQt9kpfbii3iVKLWRRloS1VLGHqzjGNLRJ/+8xtpfEiS0OCgqigz8L68K7+ZxrHkWpGipqMCZ+mUr8IlKhmXosID/UkHwnvfnRVE70FQenEBHpWZo5lbJJa1MRcAT5Q1uxuS1coi9pf10UlE2T/IzHPAI0FfImPx63EnVHpPoz7P5L+zaOh70fut6OoOhGkermpvoIXZxHDw94u/hWAG6mtWCtRNhjjl0TaHctBQi6yz+QHXu2CETBkHxzGGJiTVDXGLsPHjWYPoP9Ep6ysGjp+lTnbBCHW7vXKJzOoSW3hbDjni4zszukV6COhXkdzf1rifpIcax6lJZQ2D6osaPJXlG4BFnJJcmpcigDcTBEynRfLm3NusJfy4NHlPNIH2VYDQl+fI/F9eTxNS7P+pYUE29lH/xMJLtX1WlVQ1z+XNj61iMp8TfF0kWXXe0da0iOy4ASCYtfRees
 mgJGu9ZC
 DYllolCIsOW9/nuB8roOUlgE1iAMVWgcDiFXtZ15b4r6gcJ4Q6cMl/MFip807CW7kraiWv/YUQ9Rjq+gNHtF2cBjpDEucydza/y/0zNkW9ZrMOVfLFnTblp8kbuK1DJHT+dhSnxVC1jsINI4wjKGyFqWKLvMIUUMofRiyDp7J51rLR9gLZRBXBW9+JaQYiTS+R5Yz+m9sywGJxrwMaqV3dNGVu2quyNTnguxk3mPJjIMsGH+Em0gT9tj1NdR4SsEigI8tmUZ0fN1yTkKBAisvBB7zOWSJpCDVlothFsC2kMFf6eebxuiao7krr5C6kC2sTxZekN5HgAtDwb4=
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
modifications. affs_write_inode() refuses as well and
affs_commit_super() leaves the root block alone in that state.

A remount to read-write fails until umount. A remount to read-only works
and keeps the bitmap around because evict and the last close still free
blocks, affs_kill_sb() frees it. Writes through file descriptors opened
before the error fail with EROFS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/affs/amigaffs.c |  4 ++--
 fs/affs/inode.c    |  2 ++
 fs/affs/super.c    | 14 ++++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index affa20d2b73d..40ee1998ff33 100644
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
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index c7de9c793ab8..009245ad6c99 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -173,6 +173,8 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index ed8225b3c93d..655d7282a8de 100644
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
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
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


