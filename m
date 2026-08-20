Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4C3C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2DC6B008C; Thu, 20 Aug 2026 15:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A276B0092; Thu, 20 Aug 2026 15:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB72E6B0095; Thu, 20 Aug 2026 15:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1D96B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:33:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12022C0295
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:33:56 +0000 (UTC)
X-FDA: 85122648072.21.6884054
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B2B2A0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:33:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ci/czsF4";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs0htD/cjU9OCu4C2Kg80p/TbNt8/mTbG6p2Ku/lBdI=;
	b=ljyrQdb9s5+a2Btp9b4+BjLjX+sjujdg8wUk5bXLYqtFK3Z25caGe/CdqlTWW116H6gd0h
	j6Ws3NTPYKaiJHQmgi0t16NBhjXByswKrGVH5kk9mb+APppbxHICPIiiFX9IIZWtrAy77n
	KBB0oVAukd/YNWbj4NhQl+uedAdyUA4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ci/czsF4";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254433;
	b=asdoKMM4+ufuqdn4Oo4mVy53ojqzvVe4Sn6kZp2gLR8gVBNZlYOZk3iIhTjixWBOKYzoS8
	x2DlRHoDtiM21bFHvP6jaz/cz9CiZ84r5O0vtXXprx6MB9clu+Mdn89wVsP9k9oeIEy8tD
	dqLLsRL+QCnPcA69p3Yu9eLlaN471Qo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=fs0htD/cjU9OCu4C2Kg80p/TbNt8/mTbG6p2Ku/lBdI=; b=ci/czsF4/zM1GNnaf9XI2rrb85
	zzjZAV2v4GTFkP1N4XCj1DpxbCJjSEvQ/M2ZQy1eO1/lU1o+tZngjUMJz0YSlUA2Xou0jPXfa5TLK
	wBex/0pkUn3IFVsl4Vc0aFxnOElaJemGvFvUf56KowyPrEnj9OfROaE150VqiEWoe4KUuu7sZ187D
	Thd8UR61BfasYAqAQ7I26DSCPfQ8fCFTT/ip0VAyM64bNb4jvh0+6BpVJZVa0pryEYMZeHYkycasx
	UcVgoQAjcUDBhn4cIOHxrH/u1M6owTxLlCEoRxQfvRC0vg2wg7qWNfo+sAUsdLyL+2zpjdivzJCWg
	N5YvhS2A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WG-0000000GALd-459O;
	Thu, 20 Aug 2026 19:33:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/7] btrfs: Use filemap_invalidate_pages()
Date: Thu, 20 Aug 2026 20:33:36 +0100
Message-ID: <20260820193343.3852967-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B2B2A0009
X-Stat-Signature: 6staf51w84736zcr5ikiard9bqtriie6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787254433-390573
X-HE-Meta: U2FsdGVkX18IVN0gJ5i5hOF05GlgXlcUUvUfofdYlttaOf2AcBSfw40zr0zo+wB+1EhfvWyXe9+XvW5DW73gWodGWaF4YW1nAuIp1ORX+HWN+V9dlgB3Z8qcthuY9jEfwCprfEk5sXVjQeIGLwvqfNb+ie2Du1QlQQL8uIZJBdHdElvSuxG6CmNrFtn7wE95R93o24N79+WUK3Y+xtBvinhBX1O0H0qpovN6sWF7BeWKhwjTntbDSnFuikduuoq8G7wqHB8O4not4Gjwk97GP3lSnWj0p/HxJUX4K59v9vl7hCKA1tqVfnNZT2YMGsYFCpw7nWoIg6OCZi095bWE67IoT88ETpmavhuZhGWSemFXtH9egDkpEKb7DY5v9CkUaZkDtE8xxqXBRddEn5NTPzb49nqH/63Xp78+hBqneOhBKDtmukLbWp9nRpCgr1zo9T60uONbJn83LIp/xUJUGYVVPpOgTgy0WUPCSJhZOIw4PdaN61ytj1W1CGyaPBHw4eDWbhNSPKOHOCATacTjuSahGfw5lTuZel23L15IOTKIKKqXFKvwLGqC2iFzq7Ahi8YwqZNNtpDBC1AbrckZa8tNk74EqvVbSXTKCNUE1ObiFnnUk0eX7bMBWbnJKc1JUjH59GeAGx4rZ/EpfrnodanihEQO/9kKstbnohwdzbXnQl1YC3C2rJjL/GExOBJcIttbs8f1WhLExUKnVAwq6mBd8KvI0uSeeT+un7qZ3Vbfj7wKEZ8W+tdsxg4xO+rjPz2bS1vdVqc8mcaAOp/u8fciul3U3tAI/LM0+C+8xbKX6LUU63RFhyaAfaMRtGod9nujdZtES9EJkRhrsi5OrAEMhxPDi+FkjOMgGRskTsd+AfuMxCoHBS+CFXDi86myruBUFs+WPBOgst2WEM7VFLqGuGdcUFvf0SkoLh6WlJvcIzZry+/AsZ71xMpZhm1Smh1PC8gfAFKvCJdTAKd
 f/5j6EjS
 MWH9V6d3ZHAtMqAoFWROR6nfB/SFaN5W85ORSCi0zcAMA3XgxtVBX+nI29lNMzshCel+L7TKGLEifR2VUSG/rhOz+7EvsdhKOXaymJkGhuuJVeVOCuvkAjRG0DVw6uCqZ3jHPJ4GwZqONW1lNJcHCxb1lOV1iN53yRtn3S2ok7GPd73l2yuCW0I9WO9kinILrnQ5pZD2HgPCpDNSBloen0s3zDsUKfNTZZBnZSct9YGKK2kC1GhWo0tdlQ4Cop5ezQvgzHU4dGDNeyr2v0BaRaj+X/e7VMwkwerDvaZayON/XDT6ELUB4uMfCDdNGWvmOBAN4ylRVZfRZs0y1K6zVzAmyD7UNPDWmhfjkUztL4nE0TJGcy/+H4s+hvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

btrfs relies on invalidate_inode_pages2() /
invalidate_inode_pages2_range() doing writeback by calling
btrfs_launder_folio().  While this works, it is inefficient as each
folio is written back and waited for individually.  Far better to call
filemap_invalidate_pages() which will do a bulk write first, then remove
the page cache.

With this done, btrfs_launder_folio() no longer needs to exist so
delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/direct-io.c        |  2 +-
 fs/btrfs/disk-io.c          | 11 +++++++----
 fs/btrfs/free-space-cache.c |  4 ++--
 fs/btrfs/inode.c            | 12 ++----------
 fs/btrfs/volumes.c          |  4 ++--
 5 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..4bb5890d0898 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -115,7 +115,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			/*
 			 * We could trigger writeback for this range (and wait
 			 * for it to complete) and then invalidate the pages for
-			 * this range (through invalidate_inode_pages2_range()),
+			 * this range (through filemap_invalidate_pages()),
 			 * but that can lead us to a deadlock with a concurrent
 			 * call to readahead (a buffered read or a defrag call
 			 * triggered a readahead) on a page lock due to an
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f1666d9544e..2cf9189225c9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3304,7 +3304,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 	struct extent_buffer *eb;
 	int ret;
 
-	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	ret = filemap_invalidate_pages(fs_info->btree_inode->i_mapping, 0,
+			OFFSET_MAX);
 	if (likely(ret == 0))
 		return;
 
@@ -3339,7 +3340,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	filemap_invalidate_pages(fs_info->btree_inode->i_mapping, 0,
+			OFFSET_MAX);
 }
 
 static u32 calc_block_max_order(u32 sectorsize_bits)
@@ -4739,7 +4741,8 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 			unsigned int nofs_flag;
 
 			nofs_flag = memalloc_nofs_save();
-			invalidate_inode_pages2(inode->i_mapping);
+			filemap_invalidate_pages(inode->i_mapping, 0,
+					OFFSET_MAX);
 			memalloc_nofs_restore(nofs_flag);
 			iput(inode);
 		}
@@ -4837,7 +4840,7 @@ static void btrfs_cleanup_bg_io(struct btrfs_block_group *cache)
 		unsigned int nofs_flag;
 
 		nofs_flag = memalloc_nofs_save();
-		invalidate_inode_pages2(inode->i_mapping);
+		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
 		memalloc_nofs_restore(nofs_flag);
 
 		BTRFS_I(inode)->generation = 0;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e2af75a205ea..a5d5eba2c85d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1307,7 +1307,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
 				io_ctl->entries, io_ctl->bitmaps);
 out:
 	if (ret) {
-		invalidate_inode_pages2(inode->i_mapping);
+		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
 		BTRFS_I(inode)->generation = 0;
 		if (block_group)
 			btrfs_debug(root->fs_info,
@@ -1500,7 +1500,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	io_ctl->inode = NULL;
 	io_ctl_free(io_ctl);
 	if (ret) {
-		invalidate_inode_pages2(inode->i_mapping);
+		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
 		BTRFS_I(inode)->generation = 0;
 	}
 	btrfs_update_inode(trans, BTRFS_I(inode));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2534cd9284d5..a1bb73f083aa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7616,12 +7616,6 @@ static void wait_subpage_spinlock(struct folio *folio)
 	spin_unlock_irq(&bfs->lock);
 }
 
-static int btrfs_launder_folio(struct folio *folio)
-{
-	return btrfs_qgroup_free_data(folio_to_inode(folio), NULL, folio_pos(folio),
-				      folio_size(folio), NULL);
-}
-
 static bool __btrfs_release_folio(struct folio *folio, gfp_t gfp_flags)
 {
 	if (try_release_extent_mapping(folio, gfp_flags)) {
@@ -10027,9 +10021,8 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = btrfs_wait_ordered_range(inode, start, num_bytes);
 		if (ret)
 			goto out_cb;
-		ret = invalidate_inode_pages2_range(inode->vfs_inode.i_mapping,
-						    start >> PAGE_SHIFT,
-						    end >> PAGE_SHIFT);
+		ret = filemap_invalidate_pages(inode->vfs_inode.i_mapping,
+				start, end);
 		if (ret)
 			goto out_cb;
 		btrfs_lock_extent(io_tree, start, end, &cached_state);
@@ -10782,7 +10775,6 @@ static const struct address_space_operations btrfs_aops = {
 	.writepages	= btrfs_writepages,
 	.readahead	= btrfs_readahead,
 	.invalidate_folio = btrfs_invalidate_folio,
-	.launder_folio	= btrfs_launder_folio,
 	.release_folio	= btrfs_release_folio,
 	.migrate_folio	= btrfs_migrate_folio,
 	.dirty_folio	= btrfs_data_dirty_folio,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..0301465ab87f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1370,8 +1370,8 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 		 * Drop the page of the primary superblock, so later read will
 		 * always read from the device.
 		 */
-		invalidate_inode_pages2_range(mapping, bytenr >> PAGE_SHIFT,
-				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
+		filemap_invalidate_pages(mapping, bytenr,
+				bytenr + BTRFS_SUPER_INFO_SIZE - 1);
 	}
 
 	filemap_invalidate_lock_shared(mapping);
-- 
2.47.3


