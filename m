Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625B4C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37AFC6B00A5; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B496B00A6; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2416E6B00A7; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E31636B00A5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76A95A2C98
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:09 +0000 (UTC)
X-FDA: 85122648618.04.A2D9507
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id B6D2640008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ksuF7ORq;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG85xRuzHVVqZ8P0/h1shN90I4cE/3g+AWY/WvJgU1A=;
	b=C7jV0PR70fUb15sVb3S6TdsIehrMaSjlO8G7XkE9BVm//LKR+kNq3Moq/AldXFPunEacjs
	g0/olt5csFN3Fum3ve4FFg1Emo0x4/zWRLjP4t5CRyMrGdWHCmKgW4lK8ggYEYt6fP+lXB
	0yV9xrCJmxbDwXkCNeCC31Em2WkAe+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254448;
	b=oMqqonDhgMyQPLlyYGWOTouta2+QChh7lBeKne+dBhlxj9wZlRhdt2Z0PQbQOML+zS9uY6
	ordNYcn0UnGpJB+bu6l8C1qjYTgpybxqnm8XQdG93wUGpPXIuiOfuaJBEuWdFgt7/ySaGb
	o8SsB0ToUa7XSEJmR0Z2a7wz/GqFBJA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ksuF7ORq;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=bG85xRuzHVVqZ8P0/h1shN90I4cE/3g+AWY/WvJgU1A=; b=ksuF7ORq0L+VtcJ1VQiotclBx7
	+sYXsMMqsaooFkyGOfi5USXd/tuS+32DcHRgo9+VWhWqeCn4zO/50qMPy0vxjFrHmN7TuGbokMdGN
	sVaVqlM5RyRE/m9fayNF3VnTVVI2q1YNF9ZfgkMDMGlrLVuwjL7614TCd564e34ib86Kgt0GYa0qx
	2j8q3B3n7Ho4HD8+C9KUQaWYaO1BLuTgCg8og5lZUraVVBSQ7LFXFfeEtQmZaOq94xYNsSfs9LxYQ
	Zqm8ADQMOEBodO1e+nns5+X3cDZUr5VZSL5VN+tXM41zX5J+6zWnJcLyDBYqIQjJ7lE+dAwzyFaHV
	54EOK2bQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WG-0000000GALb-3TwJ;
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
Subject: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
Date: Thu, 20 Aug 2026 20:33:35 +0100
Message-ID: <20260820193343.3852967-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uscaoxe8q9jqk4s4s9r8frf8wuyyzab9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6D2640008
X-HE-Tag: 1787254447-57740
X-HE-Meta: U2FsdGVkX1/2+fLEKs7ilvX0e/XpUq+2ctr9w/nIHpz0CAdODryOzNRCKz5dvp330tECVeT3yNIxZhmO3497Pzsu0/duuFPMiZiF6+O5n5USqw9y62d4Tmyn4HEEpB0hB9jgBpsjzSRR+qjiFthgJi0j7sG1SWNQBm7g2ccYk9pwn/13PAj3ItpB3N6Hsa9zk2PO0cFO6nwXJuQ15An/0UtxGfH2h9OLn9oq7BM/GFaydZg2hUil5e64/P9A7UoPHJDz+LcOE03PdhYGrxfsxJfwtMJQcqyrJklfyBdBTrj/VA3qnzDlyn7bj8Bkxb+tXjZnZvUVTPfuzdygWbJiLuGT08rhIDCwC/1puygvQW1OyO3X8dXI0Q9hIHoDclkmrTSFcj3LY/qH7wbgDPctIgcdMljr12IWxqSDUQv2lh1q9EMEhGtDI8GaT+/USIqwUSPPaoT+tFphH72Q6vmsCQEp6kFsTzarprFzpf90n2xuXZcRQrf4WVL9jIo0sH1s5/w97IhfYat+vzjomNIF4ol6+DjymZcX08JXnhj3vqyj1Qts0MefmXh0lXG3Z2dOqf2YqyGMG9V/1R6x6889bz4jXkWglneS4lVJGI/g4MOaN0WaDDW8UAWd436/hupAGClgUR0wzRXrcEcFEqlTgWmQ6H239WGKdDP0du8lHzUnTNRvM1CTCgXC+4yylGwT6zcoIOcdtrtdbSwy8LwUZNzvVUGj8qyYEnjGdnd9Xe76aYSuOWNOIM99syRiDWm/2MfPK8FDxPnr2lq6Zbku31vhf7LqGgZKzB679oFh0gFhyWsDcWYs6+KVk66hZ9sExGSTGzrOleliOxwhhlXyBty5wlxTetLyfmmObsc8FtB0mr73380rwSAQhfK/sEx73VVqGy+UXWCBf8qd3U/4heVo4PA69h062nASws7UVzB4rpZxmgE0k2rww+AbUlMqeFRwgrbnd/8kB0WRxlX
 GFONUtFh
 TxtAexszC5zmKpJ/HZED94+4a+cZMQUEjJhmijUU9TVe7MnPFqM9fuS/Mcr9UiS4J6+m32c3a2nA1ab6cA52JXiBmWVKNr2COTAMaQO3GZgwwsKydAzN8TKyEhdOBPW1Xm2H0qA6DU/xIYa86h+UUJy6LwIfl11cfv5YWtBcz0xQpEnvRJgfY9c2JzvskpyGV1VzdKbaISP8mRjAsavv9CT6CIaPJ8xkLvAawP1s/6I5Aeiej6oubrv3kOjzuQKbPG2NzNHRkx3gL/A9eQS8AeadW+rouU8MwRdfBwDTclbPiAQUH03wOedutQZ98igfX8OrdRHiN2gthWtwsDx3nGe11K4i1kz821IgY7MGHfCcfUCDDfsWR1HkD2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FUSE relies on invalidate_inode_pages2() / invalidate_inode_pages2_range()
doing writeback by calling fuse_launder_folio().  While this works, it
is inefficient as each page is written back and waited for individually.
Far better to call filemap_invalidate_pages() which will do a bulk write
first, then remove the page cache.

With this done, fuse_launder_folio() no longer needs to exist so
delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/fuse/dax.c   | 15 +++------------
 fs/fuse/dir.c   | 12 +++++++-----
 fs/fuse/file.c  | 46 ++++++----------------------------------------
 fs/fuse/inode.c | 17 +++++------------
 4 files changed, 21 insertions(+), 69 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 8b53625ac7ab..45843975e28b 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -835,19 +835,10 @@ static int dmap_writeback_invalidate(struct inode *inode,
 	loff_t start_pos = dmap->itn.start << FUSE_DAX_SHIFT;
 	loff_t end_pos = (start_pos + FUSE_DAX_SZ - 1);
 
-	ret = filemap_fdatawrite_range(inode->i_mapping, start_pos, end_pos);
-	if (ret) {
-		pr_debug("fuse: filemap_fdatawrite_range() failed. err=%d start_pos=0x%llx, end_pos=0x%llx\n",
-			 ret, start_pos, end_pos);
-		return ret;
-	}
-
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    start_pos >> PAGE_SHIFT,
-					    end_pos >> PAGE_SHIFT);
+	ret = filemap_invalidate_pages(inode->i_mapping, start_pos, end_pos);
 	if (ret)
-		pr_debug("fuse: invalidate_inode_pages2_range() failed err=%d\n",
-			 ret);
+		pr_debug("fuse: filemap_invalidate_pages() failed. err=%d start_pos=0x%llx, end_pos=0x%llx\n",
+			 ret, start_pos, end_pos);
 
 	return ret;
 }
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0e2a1039fa43..c6c72c0ee669 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -913,7 +913,8 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 		if (fm->fc->atomic_o_trunc && trunc)
 			truncate_pagecache(inode, 0);
 		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-			invalidate_inode_pages2(inode->i_mapping);
+			filemap_invalidate_pages(inode->i_mapping, 0,
+					OFFSET_MAX);
 	}
 	return err;
 
@@ -1904,7 +1905,8 @@ static int fuse_dir_open(struct inode *inode, struct file *file)
 		if (ff->open_flags & (FOPEN_STREAM | FOPEN_NONSEEKABLE))
 			nonseekable_open(inode, file);
 		if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-			invalidate_inode_pages2(inode->i_mapping);
+			filemap_invalidate_pages(inode->i_mapping, 0,
+					OFFSET_MAX);
 	}
 
 	return err;
@@ -2277,13 +2279,13 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	spin_unlock(&fi->lock);
 
 	/*
-	 * Only call invalidate_inode_pages2() after removing
-	 * FUSE_NOWRITE, otherwise fuse_launder_folio() would deadlock.
+	 * Only call filemap_invalidate_pages() after removing
+	 * FUSE_NOWRITE, otherwise it would deadlock.
 	 */
 	if ((is_truncate || !is_wb) &&
 	    S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
 		truncate_pagecache(inode, outarg.attr.size);
-		invalidate_inode_pages2(mapping);
+		filemap_invalidate_pages(mapping, 0, OFFSET_MAX);
 	}
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ceada75310b8..2496161f9298 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -294,7 +294,8 @@ static int fuse_open(struct inode *inode, struct file *file)
 		if (is_truncate)
 			truncate_pagecache(inode, 0);
 		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-			invalidate_inode_pages2(inode->i_mapping);
+			filemap_invalidate_pages(inode->i_mapping, 0,
+					OFFSET_MAX);
 	}
 	if (dax_truncate)
 		filemap_invalidate_unlock(inode->i_mapping);
@@ -644,10 +645,8 @@ static void fuse_aio_invalidate_worker(struct work_struct *work)
 	struct fuse_io_priv *io = container_of(work, struct fuse_io_priv, work);
 	struct address_space *mapping = io->iocb->ki_filp->f_mapping;
 	ssize_t res = fuse_get_res_by_io(io);
-	pgoff_t start = io->offset >> PAGE_SHIFT;
-	pgoff_t end = (io->offset + res - 1) >> PAGE_SHIFT;
 
-	invalidate_inode_pages2_range(mapping, start, end);
+	filemap_invalidate_pages(mapping, io->offset, io->offset + res - 1);
 	io->iocb->ki_complete(io->iocb, res);
 	kref_put(&io->refcnt, fuse_io_release);
 }
@@ -1675,8 +1674,6 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	size_t nmax = write ? fc->max_write : fc->max_read;
 	loff_t pos = *ppos;
 	size_t count = iov_iter_count(iter);
-	pgoff_t idx_from = pos >> PAGE_SHIFT;
-	pgoff_t idx_to = (pos + count - 1) >> PAGE_SHIFT;
 	ssize_t res = 0;
 	int err = 0;
 	struct fuse_io_args *ia;
@@ -1689,7 +1686,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 		return -ENOMEM;
 
 	if (fopen_direct_io) {
-		res = filemap_write_and_wait_range(mapping, pos, pos + count - 1);
+		res = filemap_invalidate_pages(mapping, pos, pos + count - 1);
 		if (res) {
 			fuse_io_free(ia);
 			return res;
@@ -1703,14 +1700,6 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 			inode_unlock(inode);
 	}
 
-	if (fopen_direct_io && write) {
-		res = invalidate_inode_pages2_range(mapping, idx_from, idx_to);
-		if (res) {
-			fuse_io_free(ia);
-			return res;
-		}
-	}
-
 	io->should_dirty = !write && user_backed_iter(iter);
 	while (count) {
 		ssize_t nres;
@@ -1824,9 +1813,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			 * write, to invalidate read-ahead cache that may have
 			 * with the write.
 			 */
-			invalidate_inode_pages2_range(mapping,
-				pos >> PAGE_SHIFT,
-				(pos + res - 1) >> PAGE_SHIFT);
+			filemap_invalidate_pages(mapping, pos, pos + res - 1);
 		}
 	}
 	fuse_dio_unlock(iocb, exclusive);
@@ -2324,26 +2311,6 @@ static int fuse_writepages(struct address_space *mapping,
 	return iomap_writepages(&wpc);
 }
 
-static int fuse_launder_folio(struct folio *folio)
-{
-	int err = 0;
-	struct fuse_fill_wb_data data = {};
-	struct iomap_writepage_ctx wpc = {
-		.inode = folio->mapping->host,
-		.iomap.type = IOMAP_MAPPED,
-		.ops = &fuse_writeback_ops,
-		.wb_ctx	= &data,
-	};
-
-	if (folio_clear_dirty_for_io(folio)) {
-		err = iomap_writeback_folio(&wpc, folio);
-		err = fuse_iomap_writeback_submit(&wpc, err);
-		if (!err)
-			folio_wait_writeback(folio);
-	}
-	return err;
-}
-
 /*
  * Write back dirty data/metadata now (there may not be any suitable
  * open files later for data)
@@ -2427,7 +2394,7 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 		if ((vma->vm_flags & VM_MAYSHARE) && !fc->direct_io_allow_mmap)
 			return -ENODEV;
 
-		invalidate_inode_pages2(file->f_mapping);
+		filemap_invalidate_pages(file->f_mapping, 0, OFFSET_MAX);
 
 		if (!(vma->vm_flags & VM_MAYSHARE)) {
 			/* MAP_PRIVATE */
@@ -3102,7 +3069,6 @@ static const struct address_space_operations fuse_file_aops  = {
 	.read_folio	= fuse_read_folio,
 	.readahead	= fuse_readahead,
 	.writepages	= fuse_writepages,
-	.launder_folio	= fuse_launder_folio,
 	.dirty_folio	= iomap_dirty_folio,
 	.release_folio	= iomap_release_folio,
 	.invalidate_folio = iomap_invalidate_folio,
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d975073c6029..2c9a93a2173a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -382,7 +382,8 @@ static void fuse_change_attributes_i(struct inode *inode, struct fuse_attr *attr
 		}
 
 		if (inval)
-			invalidate_inode_pages2(inode->i_mapping);
+			filemap_invalidate_pages(inode->i_mapping, 0,
+					OFFSET_MAX);
 	}
 
 	if (IS_ENABLED(CONFIG_FUSE_DAX))
@@ -547,8 +548,6 @@ int fuse_reverse_inval_inode(struct fuse_conn *fc, u64 nodeid,
 {
 	struct fuse_inode *fi;
 	struct inode *inode;
-	pgoff_t pg_start;
-	pgoff_t pg_end;
 
 	inode = fuse_ilookup(fc, nodeid, NULL);
 	if (!inode)
@@ -561,15 +560,9 @@ int fuse_reverse_inval_inode(struct fuse_conn *fc, u64 nodeid,
 
 	fuse_invalidate_attr(inode);
 	forget_all_cached_acls(inode);
-	if (offset >= 0) {
-		pg_start = offset >> PAGE_SHIFT;
-		if (len <= 0)
-			pg_end = -1;
-		else
-			pg_end = (offset + len - 1) >> PAGE_SHIFT;
-		invalidate_inode_pages2_range(inode->i_mapping,
-					      pg_start, pg_end);
-	}
+	if (offset >= 0)
+		filemap_invalidate_pages(inode->i_mapping, offset,
+				offset + len - 1);
 	iput(inode);
 	return 0;
 }
-- 
2.47.3


