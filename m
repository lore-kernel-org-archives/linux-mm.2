Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C762F60A381A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9XI+ous
Received: by kanga.kvack.org (Postfix)
	id 312AD6B06CC; Fri, 13 Nov 2026 07:00:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAB36B06CE; Fri, 13 Nov 2026 07:00:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2000D6B06CF; Fri, 13 Nov 2026 07:00:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58D56B06CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 669BAA7F74
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:39 +0000 (UTC)
X-FDA: 85429953798.08.336463D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B19480014
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9XI+ous;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8rH1EerGXOcbNF2NyxvkSKNsMomLcR0GIdkZh+GkXs=;
	b=p2Q93K5btRGn4Xmfuj2BxB+d4zlE6YP2EFuhVSU0IpMYCa1PjsvOgFH9VDyM/TJEDjDVUJ
	LBUNwOvENBsWmV0Vdo/SYZcYJBpP60kJxOjRqsKWSjAta6FIoLG4oLes93QxQGzDy0O2SW
	i9FXFHqUlLHYpbhZeKwBf8jBxbAvkak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571237;
	b=qI3jE8sW5IpDIIHsM40f9RXPFOc3uxhHs3aTrg/ZXzwGGzwui0+RrEvJ6hCLMGdolygQ8j
	vLiWspNZB5j8SGozhRBFKt/aIcaOxMfq0/3F9ODNiV1bpaA6sE3KRgYap+mSuF822MWLXD
	tTDT3LhXh33sVLwhlHGvp9jezaR8I7M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9XI+ous;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC71446016;
	Fri, 13 Nov 2026 12:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D818A1F000C5;
	Fri, 13 Nov 2026 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571236;
	bh=q8rH1EerGXOcbNF2NyxvkSKNsMomLcR0GIdkZh+GkXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d9XI+ousp8TuvVII27gWXwVXQ4OUsdvQnGR1cvONAt4a3Mbl8Rqyuv9bwe6VU8fPt
	 StFPFBC0N1LS+k2T0lsaM0QeImbS3tENC6Ov4+pF5cFok8cWk0PDU0xUPjgh45gg1R
	 e9Niaww4fqzK94xUSE4k2M8s4SKRGD/6TvgqbZ3CH+oJszHnQFZxhS2TxfgrNDW12Z
	 G5Dx3AwmCcOdLO05VpzYoSqsYrTYHGO8lqFv61/YT+jFnzpguaVHuD5jJeSJlkyxW7
	 D5Po+RzFi91FSmp2DRn0ReAHiRlM0Y06k7YK+DWeOm45kP07jTX1zuDCJX8ae7RYno
	 JwIqZ0d8XXIXg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:02 +0100
Subject: [PATCH v3 06/33] ext2: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
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
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5325; i=brauner@kernel.org;
 h=from:subject:message-id; bh=epfxXPNa/jx7o9G3z9Hy+9Q1z78RlflSeD6BYjxn3fk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73gVxTjSZ3XdVwrow+UqT7f3t2jNt3t1PLZiVUSL
 3hPxWcWdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEkYGRYcGN/D9mL3kWBbYa
 f5SzubH7xbR9+tePSTzr/5nUH3DmbzrD/+xfn1X+ltUwrVptPOPJwYz1q94tXtI+0ccoatah/q5
 DGewA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: y6jn9ot13m14apiw9edauyhnbxikhqha
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6B19480014
X-Rspam-User: 
X-HE-Tag: 1794571237-525324
X-HE-Meta: U2FsdGVkX18TPjr0wqYAeAALkgvDBCnV6p7TSZKm4IbiJL+UKaIDlf35GRw/yOoUxu70uVSV7j8bOeOOXKTIKuOIvr6c/qpSQzP7p49clewWNRvcHserF/nJUaohleEinJupwvRImbhHCgH6/VYCzaxMn1+85aRJ6qcLM1y2eDxNebsjVVrje9G5qUxUeU4lohp451TNX/kfa3D67BCXTywoHaYPKbrFI6g/v73CWtIWdbJ/hPUXl8wPXFrsKd0Wb7D2TLjN9c5OKqAZHoMAUaEyn1MV8QrbwTaerC1knPNpCpelR9cDF9rOC+11ivQDbGBcMsmltjCed3M7B1AAILrtBCRVj795IAsPXZfusUlFX4lzMAf835DeSNVVRcE13nKDXZvc8GHabP+qt0GyPxmk/rBYBLvnMEm/RLrPSi0EDEjqRvZXOzouqkMEARq7WuzIOn7b3B5mjh/w0/86Q8V/3EARo+E9tVudEomNjmgQ1tpzZkH5sGdXrxU08VtbUdEOY/+5Df930ImupPnB82s3ytJQunmO/3G9SJNpGpjxVZPyWJ+vbKIJM5xGKTRDdCrvxZfdkypEhK76tRHVo23OWwY2RWaeTrBKnKLLWPXBRe7oXLBNeXkl2eJXV9N2wfJjSU/QRQZy1MkAf5sqZgtIXgHx7Rj+/ssYDCNnP8FjfmCWrL0rAx+pzHdLfg7oLvuS1a7ofaWwFen7Oy/05CsWXgaiQ7gHGaYbnaRe9pfWN9Ro4875h135byBYmTq852yALiOFAVtK0v3emKf8uJsONIizcHP6rfOYnv8JGQay06rjC1sesiw6/NI0rBRTpZGdeaKWG/R/5El0r2a74CLjz2nzTpseR93JU7jGEdg9MlK6I+JXK6PpF7CevXm48hCgPL1zFu5jqKovXfQFbifE93L0L8q+hos3MWJQiRHmqViUsZcfvDLka6nmxbfTZE5+PbtODYi3RcmaoAF
 mOPVyMDG
 eVQ2P3KqKkHCOJb/Y1J7pgsbR1tcAdjJF45lHG4mRkyoOQzc9SAnvkPUBXgb3N4OgTnersJHc7ezMEDkRqGqPUpj349j0eZIiLgDd6rrewrTCdH15Wkq+YCoZKTBbNzQOPinJvScRoCKC8jdGIj4413nZtw0R9uGutD+EkCKiJ84L901YDaRElsjPHnokvrJKKsom0oSH1XoAGFNjzhd2/ulWN+bk4ItmBWJkxfcUmDTd7DEwTR7WL9x4NioLD2wtdNtH8O4fi7AUTT0fJWZo+R0oT8WPFpbhW+1sqjQv85vwaggsuJ3YbYsEPqR7eezbepTsqJgJv7iqZjge8+wZ/kJFk37Z/thxgtoj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro ext2_error() sets SB_RDONLY from whatever context
hit the error and without holding s_umount. That races with everyone
else changing sb->s_flags and it breaks freezing. If it happens while
the filesystem is frozen thaw_super() sees a read-only superblock and
leaves the s_writers rwsems locked so every writer hangs. A lookup in a
corrupted directory is enough. Karl proposed teaching thaw_super() about
it but Jan preferred fixing the filesystems (cf. [1]) like ext4 and f2fs
already did.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. ext2 still refuses allocations and ext2_xattr_set()
itself, ecryptfs calls the latter without write access on the lower
mount. Unlinked inodes are left to e2fsck. ext2_write_inode() keeps
working because writeback still writes data, bitmaps, indirect and
directory blocks after the error and they'd be lost without the inode.
A thaw after an error while frozen still writes the superblock but
EXT2_ERROR_FS stays set in it.

After a remount to read-only a remount to read-write fails until umount.
A plain remount to read-write right after the error succeeds but the
filesystem stays read-only. Writes through file descriptors opened
before the error fail with EROFS.

[1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/balloc.c |  5 +++++
 fs/ext2/ialloc.c |  2 ++
 fs/ext2/inode.c  |  4 +++-
 fs/ext2/super.c  | 13 ++++++++-----
 fs/ext2/xattr.c  |  2 ++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 80acc1e193871..77f2ed5a76a28 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1236,6 +1236,11 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
 
+	if (sb_emergency_ro(sb)) {
+		*errp = -EROFS;
+		return 0;
+	}
+
 	/*
 	 * Check quota for allocation of this block.
 	 */
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index bf21b57cf98cd..2741ecd2b94fc 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -433,6 +433,8 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 	int err;
 
 	sb = dir->i_sb;
+	if (sb_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe15003..dd28637c60737 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -71,7 +71,9 @@ void ext2_evict_inode(struct inode * inode)
 	struct ext2_block_alloc_info *rsv;
 	int want_delete = 0;
 
-	if (!inode->i_nlink && !is_bad_inode(inode)) {
+	/* After an error made us read-only the inode is left to e2fsck. */
+	if (!inode->i_nlink && !is_bad_inode(inode) &&
+	    !sb_emergency_ro(inode->i_sb)) {
 		want_delete = 1;
 		dquot_initialize(inode);
 	} else {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fb217ef2d69f0..10d5165459749 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -53,7 +53,7 @@ void ext2_error(struct super_block *sb, const char *function,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		spin_lock(&sbi->s_lock);
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
@@ -73,11 +73,11 @@ void ext2_error(struct super_block *sb, const char *function,
 
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT2-fs: panic from previous error\n");
-	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
+	/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO) &&
+	    sb_set_emergency_ro(sb))
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
-		sb->s_flags |= SB_RDONLY;
-	}
 }
 
 static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
@@ -179,7 +179,7 @@ static void ext2_put_super (struct super_block * sb)
 	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
 
-	if (!sb_rdonly(sb)) {
+	if (!sb_rdonly_any(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
 
 		spin_lock(&sbi->s_lock);
@@ -1360,6 +1360,9 @@ static int ext2_reconfigure(struct fs_context *fc)
 	if ((bool)(flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out_set;
 	if (flags & SB_RDONLY) {
+		/* After an error nothing may be written, just go read-only. */
+		if (sb_emergency_ro(sb))
+			goto out_set;
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS))
 			goto out_set;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 8f608930a48c6..12dfffff189cb 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
 		  name_index, name, value, (long)value_len);
 
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	if (value == NULL)
 		value_len = 0;
 	if (name == NULL)

-- 
2.53.0


