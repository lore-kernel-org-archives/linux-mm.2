Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB6F606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaNj3haK
Received: by kanga.kvack.org (Postfix)
	id 07F0B6B05CD; Thu, 29 Oct 2026 12:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056F46B05CE; Thu, 29 Oct 2026 12:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87DA6B05D0; Thu, 29 Oct 2026 12:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0CE6B05CD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 210E916048C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:20 +0000 (UTC)
X-FDA: 85376145960.23.2D9B8E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C1D716000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SaNj3haK;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVtfPcXJU1Dl8ABOoiDUG8I8knzlj5kyhgqCw7tVF5M=;
	b=lNMUX7wSXoKYNhGdZaLSs3qaUmpLPAWr/vkZtBjO7tSSRge8S21di0weeZAj4dsQ0/yoxX
	bY4+Ld0pRaPFcvyrNjufYQzFTDxUcKDM0dmEA93O81z7noJGBXANd8z62Y3YSCeF6XYSQU
	euMAJunuQYRbHSP2kVtEyZduCvBdnVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290098;
	b=ApxFOeqTI4wjEeg+racHeoDjUpcnU5+tb8ODPSxY5UfHh0R2oc6TuK1dLIEcjIWh2QlE8m
	etD8f+Yoc3pwaEC144Gq9///c3lkWHoEiUmNjBxzrbXkA2/ZC997LoBQ6+oHDbo+N2GNrg
	Z4FW2W5NvzbxQSozdRvdZNiXDbLtyO0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SaNj3haK;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99645406F0;
	Thu, 29 Oct 2026 16:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20F91F01816;
	Thu, 29 Oct 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290097;
	bh=iVtfPcXJU1Dl8ABOoiDUG8I8knzlj5kyhgqCw7tVF5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SaNj3haKjPhS0EV5du9JfwoaG8Rin7tmXFLxPOygnrJjfpOEMsH1kKI3PDQ5XrA31
	 elsbGH2JC31Wkk9r2juQXQaMil6mGer0JYCXeGnlS7/hHIbTjXtNGAiTEsULpLJxMu
	 x7YJWpentI1ho5FrGAqj77ZuQkE0HOtBSPBH+2h5Sw/HmrQ7Qr5Z3mw2MkbbdT1YeW
	 C4YSP8lYmdEQ5tm4M6lVTrBxeZPwia5DPaoZf9AuXRGXTJe+LAly8bh0nCkCaJXpRy
	 gtiqGKF122MQYR1+vHibsjYN3LXS6PReB5hM7+APMQef/PKfJbmCFxtyQT0H0voNLH
	 HSOMgvztVLvIA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:04 +0100
Subject: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4282; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ceXsregJOQeiQPf6PAYWpIExvMexFMwQYxKrBcvN4/M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztf/G9F4fqpwKhPTyquti1c/aoie/mDt5qzJk/o3n
 OiRrDI53VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRNWcY/ofueNnGaSAsE9ow
 Q/pZjtOVzvKr4cfmvV425Zn10Rk6T2sYGR4lKM17/HbTJjHHb7e8RaenbuR6nMZutGfxEYddod2
 vjJkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C1D716000C
X-Stat-Signature: fcy63w8bhbsqh6sxtfde6zzegy3adoic
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290098-352991
X-HE-Meta: U2FsdGVkX1/1Ujifq1r1wWDo6tMvicximdW2oUvi9HlMKLfmfo+XjS3nFcFv/FSt4/q81bRLRsRwN81PY2xs98ree4cq12iHzVahs0SiKMRlSGhujJDhBeBJVWmzUHmTCZxaB76/zoWCoQHvaR3DD6mKB64eG9VhmUQAlTisbecz/OsQgy0xgpDDkUC+tWCww6DV49kWuevpmajQgj80PxZMQI+LPFpSJincrxbyeLk+DX99JdbavZNvU6NsWwOXSC7FKiYEwoN/gQBEPVo2oJ0dINAsTh2SSK0XaRL0YgMRrwC2+tZC6HiM1va+Kx/5MulK897hcoe/lWnO6c4QlfNw3tQ1sh89vztV4v0a3f+nDt+Ckwe/8uUy/6yqR3NylgTb4CNCPvT0oqkC9KgW0xXTIjjEmDuIk3n1oLsg//orOpm2iqRQAPWHBZV3YbxqhSQrgJkX+Gr9+J6zz7ArcMiRJgAi1mCsTiurTjoyWmKIxYcw9j/wxUxMWY9ciGpot9rOP5cj3L813g5TYTnHhQ1ouFiZdTOOps38HGdtlkjd1DHcJImZF6SeDyn7whkJXRm8EBjsFKRUneiiwnf0/Lc84KdQckf8mr+mvRNQADJ87Xy4KqmxsrWgqkuMKz7wGsqG0KtXv5grPbdF8pf3zB4ma/nJREtmlr2o5xMWeMrDN9zYVVtWxWfJCbr9dq5+/ZUPA16u0FRPjEkEPmY7SzGLE7lTXtM4fheEVddaexkTvz1hQbCGUyi0tef84JcK29epGflbdQ125STNqQNJbOFOBIJAi9vrLKye0Il9m1hUUbzCfJDAWjEpPA9JFkQt/Ud3we4Km+R4ajhF42FnjCHIHp6cPe5PAJfmSaKHLxpLYHCc23+MHdm+JABPYPJn5P/rZjmqtMnTXPb3pRSso4PMkegj5bdU4Lz54WSjItTzXdtR3JBKUHgIu1b7IXXum4lDERRjYJ4Zaive0Le
 2GrV/6sl
 pRtdBWwT0270qZpUR5wijRst/E4cq8CzLTQjQub0PDXYg8X2fPMFjZ7whJsTVE2S6NWyUCl3VWOnwlUDngLrqgiSoXbc8UNb+UZvps3DKzx3IOcDmT9uv8ATS0ewYpDm6K67SImgI9dJMP5S9Bjl2lKXtM98FyUxpmx54tVIP8Z6N1GqtMR3iC16rNlTwL8Jg08VSaXdN+J1ty/eafnUqwk1VQM33g3ZYAJ4FLFfmoZZrhMWit8aKpSGtiCW8BaSSjSvDsD3E6o0Vbjz0Ij1XY2tRhjtcdvz6BQgwsRwtAQfVHGUp1FYx5+4oVCkKNXTiK1pNvb+c0G2NTS5Af55ysLyG/AhzMgschjaqZvaQ+ceFOfCQvI8O+cJi6PhRYMY9CBXQNHDJZF/UKTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hfs_btree_open() sets SB_RDONLY when the map record of a b-tree doesn't
mark the header node as used. That's fine while mounting. But
hfsplus_create_attributes_file() calls it too when the first extended
attribute is set on a filesystem that has no attributes file yet. That
runs on the live filesystem without s_umount and a filesystem must not
change SB_RDONLY behind the VFS' back.

hfsplus_create_attributes_file() opens a tree it has just created itself
with the header node marked as used, so there's nothing to check there.
Move the check into hfsplus_fill_super() and do it for every tree it
opens. No functional changes.

Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfsplus/btree.c      | 42 ++++++++++++++++++++++++++++--------------
 fs/hfsplus/hfsplus_fs.h |  1 +
 fs/hfsplus/super.c      |  5 +++++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index bd4dbdbc8f98..4a67569050e3 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -270,7 +270,6 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	struct hfs_btree *tree;
 	struct hfs_btree_header_rec *head;
 	struct address_space *mapping;
-	struct hfs_bnode *node;
 	struct inode *inode;
 	struct page *page;
 	unsigned int size;
@@ -381,19 +380,6 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	kunmap_local(head);
 	put_page(page);
 
-	node = hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
-	if (IS_ERR(node))
-		goto free_inode;
-
-	if (!hfs_bmap_test_bit(node, 0)) {
-		pr_warn("(%s): %s (cnid 0x%x) map record invalid or bitmap corruption detected, forcing read-only.\n",
-				sb->s_id, hfs_btree_name(id), id);
-		pr_warn("Run fsck.hfsplus to repair.\n");
-		sb->s_flags |= SB_RDONLY;
-	}
-
-	hfs_bnode_put(node);
-
 	return tree;
 
  fail_page:
@@ -407,6 +393,34 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	return NULL;
 }
 
+/*
+ * Check the map record of a b-tree at mount. hfs_btree_open() can't do it
+ * because hfsplus_create_attributes_file() calls it on the live filesystem
+ * where SB_RDONLY must not be set.
+ */
+int hfsplus_btree_check_map(struct hfs_btree *tree)
+{
+	struct super_block *sb = tree->sb;
+	struct hfs_bnode *node;
+
+	node = hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
+	if (IS_ERR(node)) {
+		pr_err("failed to load %s header node\n",
+		       hfs_btree_name(tree->cnid));
+		return PTR_ERR(node);
+	}
+
+	if (!hfs_bmap_test_bit(node, 0)) {
+		pr_warn("(%s): %s (cnid 0x%x) map record invalid or bitmap corruption detected, forcing read-only.\n",
+				sb->s_id, hfs_btree_name(tree->cnid), tree->cnid);
+		pr_warn("Run fsck.hfsplus to repair.\n");
+		sb->s_flags |= SB_RDONLY;
+	}
+
+	hfs_bnode_put(node);
+	return 0;
+}
+
 /* Release resources used by a btree */
 void hfs_btree_close(struct hfs_btree *tree)
 {
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 6f240f87f8ff..58c780b09b6f 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -362,6 +362,7 @@ int hfsplus_block_free(struct super_block *sb, u32 offset, u32 count);
 u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u64 sectors,
 				  int file_id);
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
+int hfsplus_btree_check_map(struct hfs_btree *tree);
 void hfs_btree_close(struct hfs_btree *tree);
 int hfs_btree_write(struct hfs_btree *tree);
 int hfs_bmap_reserve(struct hfs_btree *tree, u32 rsvd_nodes);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ff7d6b3336a6..532f23502df3 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -564,6 +564,11 @@ static int hfsplus_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	sb->s_xattr = hfsplus_xattr_handlers;
 
+	if (hfsplus_btree_check_map(sbi->ext_tree) ||
+	    hfsplus_btree_check_map(sbi->cat_tree) ||
+	    (sbi->attr_tree && hfsplus_btree_check_map(sbi->attr_tree)))
+		goto out_close_attr_tree;
+
 	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
 	if (IS_ERR(inode)) {
 		pr_err("failed to load allocation file\n");

-- 
2.53.0


