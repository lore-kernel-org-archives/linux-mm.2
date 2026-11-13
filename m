Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A76606A8B9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROqB3IOn
Received: by kanga.kvack.org (Postfix)
	id 647706B06E3; Fri, 13 Nov 2026 07:01:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA0D6B06E5; Fri, 13 Nov 2026 07:01:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F036B06E6; Fri, 13 Nov 2026 07:01:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 260F46B06E3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93ED540223
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:18 +0000 (UTC)
X-FDA: 85429955436.13.A69A29E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2B761C0010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROqB3IOn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571277;
	b=LdH+tx1XV1mDhE1bUk9F3/BKiNncEREXC1MLZQgR2yTJ19nyvBM2m2mvvJza6LGdwro55D
	uD3f1ie5KQIFg1IP7W+SpSlyB268tt7jzC+9sJI/qY1ds6PixWFcd60t732ViPSOvCaf+w
	PR5UcVxwgQHBO1vrYLyY86RSHl6nbFo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YHEqYzi5KXNIwRcZhn83Em4Jwz15A4c49SP6KyvpsM=;
	b=PkseeF1W/Og6JwkKUSOvCMIE1ZnT79F30GLY1liuV1s1THUnWvQDbE0ZN7IvE+78N3kPJ0
	7+AOqzJkf8nM4KwQL/KVXNcBvzo0hJZ/g1YGHn93PgslXr3IT5g2ZWEf4dabdm8CkkRCJ+
	oYWNaL5YX0heo+6SYxPl23Z6DGs7mlM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROqB3IOn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C209408E9;
	Fri, 13 Nov 2026 12:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127921F000C4;
	Fri, 13 Nov 2026 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571276;
	bh=/YHEqYzi5KXNIwRcZhn83Em4Jwz15A4c49SP6KyvpsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ROqB3IOnFwfdV8L8FloWuGRW9fzjTNujIbxsHPGc6ZIYoXTLVhTZjQqpbFYqwssfy
	 wbNG3roSn2UJqG5xX9LzWsBJLHJACFpGxTcgR4Oo/EW56SzA616NfPWYp0sNE6H8qs
	 RooXVYKq2C14UEtszL1v++YKW8z1YHN5QCZlbbX/5Hcsofc/hmAAhRiCAezMKlifUc
	 mOEqeCi9EgNkof/s0h/sg7i5wDBKeHqwFdWGnMQJ6Uz5ZsEAWwNKFwXp8jsGKphQrL
	 SiqQ/CQP2AZgJkAHZRunIRKmH4DOLqojvqPeInDh6/cJH3rNEO1Qm/l5V7N7UGuNIR
	 pkx2wvDSX1/Ww==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:11 +0100
Subject: [PATCH v3 15/33] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-15-0be92bb73709@kernel.org>
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
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4341; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hq2uWZM7C6gmK9X25gRT9szwb+uBN9yc2jOPMElC9g4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+7163lcGr3jlpaG7PNRjpKTusjD2TPE14lpWusM6e
 JWel69BRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERmaDH8s67S7K+Y9S6t7OO2
 rerlTCLH0i5Mm6Fy0OtF6jSWNcuk4xj+GQuwbE8W2r1cRel5RZjorJrMr4tm7HtXoag+Zaan2VZ
 TdgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C2B761C0010
X-Rspamd-Server: rspam12
X-Stat-Signature: um463j1fbsomk3bz1wneqo9bzcxxbq68
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571276-464446
X-HE-Meta: U2FsdGVkX1/xu48RWAkaxBWCcPbvjsNeYwEtMd7sWTTv3PAaWRks2V0IoXfpYsOMZ/3VYatM4Fso2/OpV1S219Ni3Wx+JGvTvcLv4f+qdA2b6RV2xZJs6pSzjQZdky+5gDQJBqncOIWm/3bWlI8Wb1BQAM2BAqzvqnqADnbgX2k4ZXOBN4zj1g2BrBUmLIXX1c8nE2RVOI/LWul7N00BmHUcOlq6X0Vo/WAxe1HKjIorW818Ni/a8YaniQe2f2mRe1a4OBojvDjepz1EQ901gY+QzmuxWMHcRUbr7S1PgirBfPk3ZAkl7D42Qq7feehaxaWoeBuTaM+Z8cdErA1VzWxDcGlsXKkEueklM2la6EgrDxPTgy3GUptBJMuNMRbBE3HkS6MhUOJQczhyomZqEdQmWqNjfZXR/Hdx7XLUN51oyqt0Pg1Ef58TKI2sAURrNqNsb/Dqvw5YgVHg5WQSrrvTubq1Ff9j3KzHvZ1P0bI0q/Rmr74/HM3PxvvM5BVRIn4+/nX+4BWEmMqUYoPxGK48vOVDsQd5YhI201AXmwKH93w575c/+L96oK8yY4PsibBqPKiS9EBFvouzuUo+2xtgz9m0FOw2MnVeAeI6tH4xyR0GLCp6ysVEG0Ejaj3OmZyCk5TCUugFk2CO6KAFCRG1aibk+r6sp6MH+7KPd6nlNq2VoA+Cgbj2vaFSYV2L8B6cL5IxFWnswNQxFpCENep8Hhgq+TzxLo6linfqkkjOjQOAelgMkjfgqpY9n62uphAMTg7pRdzAt7GjcTP3WSdoyDQnv4vMKsvR1Kn+Qwh/M6sx4gy5W0gKSPyNToSH9N6vKr0cLHjpTjhlGeItD/VDJkJNKDFDmoMHMEl+8Hxo14ZR0pTP51/9vx4AwP8KR/b8XaRZLX1jg/9dz1dmRjafKO3WMku8AQDidrIRaGF8skAJ5nk/DNE+TQBZvbGd4mfs0a7miVieTK/F5+r
 UGw+vS1c
 hdC8hnZvRgGnoU68i3DCN4RaEegL1q4elyYCNo+ThmGWI1OocUBZvxLE0PW7LTo7mZJqgzbdCsvAGKrFy3njJJkE1hyp82Rxf56D+HQ3b2nD+sCn3NqfeidE5xooaFTx13a96f8P+CCP4WomPA6M2tKgilnjnWF73wT91LXbl4S/tTLJVDKVrIxqoaNPKDMSOdjeJT73y2hYeVaYGuV3PPQhp/F5k7iPVVNVZarCHia/1XzSKTK0llYyDTnWhiyERQVLD/MMXi8xn7Q3uDXubYHK74hXZkW5zJaMtJh55Pf4q15HmA0XKTxciLVNJAL0clNiY9+LbHtt1smxIcOA3F1j7HXJAYdhk3N+AHK37HENUS2YsJwp4bZV+qOVYv0WOi/MjPuXuLghtx+Owg5korFcOkJGLwcYLVC4S/2N2Jo6Xi6lvfLdWHC5CAOMq1rdX0moCkn+UJPin59dUSmLaEoK+hNNeHQEOBgq7UZmzT/9fa7OtRTc5E6jYPBFBMukHq33zVGBLFM3O6G3QXe0Q9ZvttMN/49wV0rQq
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
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfsplus/btree.c      | 42 ++++++++++++++++++++++++++++--------------
 fs/hfsplus/hfsplus_fs.h |  1 +
 fs/hfsplus/super.c      |  5 +++++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index bd4dbdbc8f98c..4a67569050e36 100644
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
index 6f240f87f8ff1..58c780b09b6f8 100644
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
index ff7d6b3336a66..532f23502df3c 100644
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


