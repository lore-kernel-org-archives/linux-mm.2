Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A57606A334
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f9F397oP
Received: by kanga.kvack.org (Postfix)
	id E16656B05C7; Thu, 12 Nov 2026 14:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEF06B05C9; Thu, 12 Nov 2026 14:09:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD6C6B05CA; Thu, 12 Nov 2026 14:09:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3D26B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B51B840B43
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:24 +0000 (UTC)
X-FDA: 85427405448.30.1440556
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14BDC12000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9F397oP;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+/O66vOIJn5ijFaSp7HX/S1Bk099vXk/XA1u/OHn9Q=;
	b=zreYCYPNi4Mp8/yxEKRt04IPY+sjt8ueImRDb2m47JjNlNTRbfKUKRvvaCpVcL/MFGq9dc
	rfksmCyD9B2DjTW9E8L2di2IbvQHCpSXn6MlaBfkZ5vIMOQj+QKw6S193LDCfvbwNVEF/w
	BkZIRxySrWaIo/PtQn8UwayBWoboyos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510563;
	b=hZsZs/CBMXE+X8AcDpILLjsYrQFuxjA3LZJLNFJPVp794sVfU56hqIy4Ra+mACBGnNAqRZ
	pnEghA1Xq0P+GhWj7Xd6NLUi7fSpqrYm/i9JHhClpaiYaXWk4IX5UpjEu6f7IX0sG2oq5X
	NOVdzRFEAaKstYkNJSMurZN6bpZu4XM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9F397oP;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF33760E04;
	Thu, 12 Nov 2026 19:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3316B1F0092A;
	Thu, 12 Nov 2026 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510562;
	bh=V+/O66vOIJn5ijFaSp7HX/S1Bk099vXk/XA1u/OHn9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9F397oPy6N5bUBCrwUsOiN2tdL5sZXloEHMj76LkPva2qf2Tgx10tX7uTMpuc4jx
	 vnVuRDj3/7Vaa7Q3dcKi+NBZrJgXJrdjXIB3dlweBC7mc8hAbAr38DIGL8xDiJP4CD
	 4BTDlcZgavOBUC3+dtZo69v5rdToy6PP72+B1a3rqltdu6mjAY/jScaVRkoJ5PRmIR
	 /wx5Sc4f3jGLQ/Yv1FboB7KFNNJQD7+UKv6lrAbXK0DmRygggKKakaKO4SQa44w6qV
	 RYyhEQZh5hFawK4Lm6ZkR7qsoqPt9ER2yIQgPUT7WhVF/AsDisF5UauX81WmwDRQqN
	 x9oZBXp4oQRUg==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v12 5/7] mm, iomap: keep a partially covered page until a DONTCACHE write completes it
Date: Thu, 12 Nov 2026 14:09:08 -0500
Message-ID: <20261112190911.84702-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14BDC12000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9krtfrkuydiry6hrhugmmgwdfwpruetf
X-Rspam-User: 
X-HE-Tag: 1794510562-199246
X-HE-Meta: U2FsdGVkX197nispql03RlU0huWwrp4klJFCB6K+fSMhWryKJKoDmgiTKFEfkmAOjViRkv4cYpyKJGbBhQmC6TYECH/VT1fGdGjFq4O4kJE3YTRlIzQzOIzOuSQtsVdR9ZQ74r8ryvUgwDnnGckorWgOB76iH2lNzyKedeTSIs67aWvWJovhtCRq0/EuKgEVPAjXSGbjdzL5Nos6Tb24XtKfZB3ibXjmDh5s/4qWshG+FqbZVMOWD3b3V4qSQMud6tIvRXugQUGf4hIcZgwpHqZj+D+8mYBZrHdxoLsiKWagCB51n0FnHwYHi2NaIPJWWo1gQyg5eYoG567d8KOGzTORC/XfoEecEcZIhTJyOFSbmXtMVN8FTEIsZ1x8MKVdui00ifXexx7qTQLBlCmnmxToSKgBFkuNG0EhDrkAXGX7YC7Zfr7nnKJAT0NkSol+XHSSaGT4XlW71HpygsguZfsP6BrHPsXjropc1L7vVGfp9ZbC0hb4MhYMtr4wJGvrGRoVX/IO87rOjwoXw/j3DQssnAqxcX7/l3O2hTYvUZz22cvwswL6MHmIyRkccvPa54QdQN/b2CrN1dgY6RPbIAoNwHmHn7By5pEi3YIJFnOyAE9uV1OE4M++LHDBqMjLaw+QwQFb7AWOCtlQXugj5M7GXzHdHOjzt4dvzBmEo4tiB7ETH389R/0XpRJ2EnS2F2jcNkjjp6hTobFsELencaGpk/UCEumpHwHw1Nf/P8kB+X+CPm/8p70Tb5nzvivpYT+9ujE1mQwSd1LIWghouLaN+JsX0lI9aclMNspTRzVs+KIdJQel/2/sjqTbqP6iKL4pImSmIX7KyMzA+iwXzCwSWjrnELUupsWXwSm4Y/4mXvaq5UxObP9vNo3yWRekiVojdQKTB0gs3W/73dVJblbM08UMBjGHBEDYKuyNeWWlGiLSjwc1HdpEsuODvQVoaFBHocnJWanKUad/pvY
 /4d7Tbxj
 1E5HTAJEmdYxG3IEVOn0w0sgGJ0DqXNpkZVqcFXCQsTlArxNC8X00bmF/gMNV15C7eqJRGYERyYoMpF3WNJPz28r5TevfYwLop8HqbrJHxC8OvdmW5SDLvrjSlzb8AbrV4sk0a3sZNDt7ih+JvazSKUHx3NZgsns3zSVQ1FoaxcRJ6QU+4U+kNN3c74MUedVpxqbt7KKCu4CJ8ZF1HVmXiybORtSIzmROjNQfVBJy/J/1CUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An RWF_DONTCACHE buffered write goes through the page cache like any
buffered write.  It marks every folio it creates dropbehind, so
writeback drops the folio as soon as the data of the write is on disk.
A write that starts or ends inside a folio covers that folio only
partially.  Usually another write covers the rest of the folio.  An
example is the next record of a file written in records that are not a
multiple of the page size.  Writeback can drop the folio before the
other write writes its part.  Then the other write must first read the
folio back from disk: one read per misaligned write.

Add FGP_DONTCACHE_EDGE for the lookup of such a folio.  iomap sets it
when a write starts or ends inside the smallest folio the mapping
allows.  A folio created for an edge is not marked dropbehind.  A folio
found uptodate already holds the data of the other write, so this write
completes it.  Mark it with folio_mark_dropbehind() under the folio
lock, and the writeback that cleans the data of both writes drops it.
With blocks smaller than the folio, the edge is not uptodate yet, so
folio_dontcache_edge_written() also accepts a folio whose blocks outside
this write are uptodate.  A larger folio, such as one from readahead, is
left alone.

The kernel cannot know if another write will come, and this commit does
not assume it.  It reads only the uptodate state of the folio.  An edge
that no other write completes, such as the last page of a file, stays
cached until reclaim.  Writeback drops all other folios of the write, as
before.

With this commit, 32 threads write interleaved 47008-byte records to
one XFS file with RWF_DONTCACHE.  Device reads per write fell from 0.97
to 0.0005, and throughput rose from 831 to 2281 MiB/s.  47008 bytes is
the transfer size of IO500's ior-hard, in which each rank writes
interleaved records to one shared file.  Any record size that is not a
multiple of the page size has the same problem.  With 6000-byte records,
device reads per write fell from 0.97 to 0.0001, and throughput rose
from 121 to 488 MiB/s.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  | 26 +++++++++++++++---
 include/linux/pagemap.h |  5 ++++
 mm/filemap.c            | 59 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6e2f1ded5ca6..28431192fb2e3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -798,16 +798,36 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
  */
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
+	struct address_space *mapping = iter->inode->i_mapping;
 	fgf_t fgp = FGP_WRITEBEGIN;
+	struct folio *folio;
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
-	if (iter->flags & IOMAP_DONTCACHE)
+	if (iter->flags & IOMAP_DONTCACHE) {
+		size_t unit = mapping_min_folio_nrbytes(mapping);
+		size_t off = pos & (unit - 1);
+
 		fgp |= FGP_DONTCACHE;
+		/* Another write may cover the rest of this unit. */
+		if (off || iter->len < unit) {
+			fgp |= FGP_DONTCACHE_EDGE;
+			len = min_t(size_t, len, unit - off);
+		}
+	}
 	fgp |= fgf_set_order(len);
 
-	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
-			fgp, mapping_gfp_mask(iter->inode->i_mapping));
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, fgp,
+				    mapping_gfp_mask(mapping));
+	/*
+	 * With blocks smaller than the folio, an edge is not uptodate
+	 * until this write completes it.
+	 */
+	if ((fgp & FGP_DONTCACHE_EDGE) &&
+	    !IS_ERR(folio) && !folio_test_uptodate(folio) &&
+	    folio_dontcache_edge_written(folio, pos, len))
+		folio_mark_dropbehind(folio);
+	return folio;
 }
 EXPORT_SYMBOL_GPL(iomap_get_folio);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3f5295d6fd73b..07f7f5190c24c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -698,6 +698,9 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
+ * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers the folio
+ *   only partially.  A new folio is not marked dropbehind, one found
+ *   uptodate is.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -712,6 +715,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1307,6 +1311,7 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_mark_dropbehind(struct folio *folio);
+bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 196c385f29801..6740b860939e7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1696,6 +1696,52 @@ void folio_mark_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
 
+/* The unit two writes share is the smallest folio the mapping allows. */
+static bool filemap_dontcache_edge_unit(struct address_space *mapping,
+					struct folio *folio)
+{
+	return folio_nr_pages(folio) == mapping_min_folio_nrpages(mapping);
+}
+
+/**
+ * folio_dontcache_edge_written - has another write written the rest?
+ * @folio: locked edge folio
+ * @pos: file offset of the first byte this write covers in @folio
+ * @len: bytes this write covers in @folio
+ *
+ * Return: true if @folio is an edge unit that is uptodate, or whose blocks
+ * that this write does not cover in full are uptodate.
+ */
+bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len)
+{
+	struct address_space *mapping = folio->mapping;
+	size_t size = folio_size(folio);
+	size_t from, to, bs;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	if (!mapping || !filemap_dontcache_edge_unit(mapping, folio))
+		return false;
+	if (folio_test_uptodate(folio))
+		return true;
+	if (!mapping->a_ops->is_partially_uptodate)
+		return false;
+
+	/* The blocks this write covers in full are [from, to). */
+	bs = i_blocksize(mapping->host);
+	from = offset_in_folio(folio, pos);
+	to = min(from + len, size);
+	from = round_up(from, bs);
+	to = round_down(to, bs);
+	if (from && !mapping->a_ops->is_partially_uptodate(folio, 0, from))
+		return false;
+	if (to < size &&
+	    !mapping->a_ops->is_partially_uptodate(folio, to, size - to))
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(folio_dontcache_edge_written);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -2088,6 +2134,15 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 	if (fgp_flags & FGP_STABLE)
 		folio_wait_stable(folio);
+
+	/*
+	 * An uptodate edge holds the part of the other write, so this write
+	 * completes it.
+	 */
+	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
+	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio) &&
+	    filemap_dontcache_edge_unit(mapping, folio))
+		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
@@ -2125,7 +2180,9 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
-			if (fgp_flags & FGP_DONTCACHE)
+			/* A new edge waits for the write that completes it. */
+			if ((fgp_flags & FGP_DONTCACHE) &&
+			    !(fgp_flags & FGP_DONTCACHE_EDGE))
 				__folio_set_dropbehind(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
-- 
2.52.0


