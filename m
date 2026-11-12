Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3E7606A8AB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JQ+RMj7d
Received: by kanga.kvack.org (Postfix)
	id F28406B05C9; Thu, 12 Nov 2026 14:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00736B05CB; Thu, 12 Nov 2026 14:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFC36B05CC; Thu, 12 Nov 2026 14:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A817E6B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2333AA0C3E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:26 +0000 (UTC)
X-FDA: 85427405532.10.D0B8C09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 77A721C000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQ+RMj7d;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510564;
	b=do63mLmv5dglVlGt8c/B7HtnBHeYmMMbXabbxZ2yQUlGGCyLrbq7L1uSfwXtJFq3YDBjz5
	nTMCRVXOfnwuk/VdNo4EzRM34jtcFAeXw1VFN5DGvRicHT3aPv048Ey1teWmti3nPXnTGl
	XnCiafKIZpUghzQlCTxtGaGz/+XsXlk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQ+RMj7d;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARceR6sl6TvT/XAyg4c0LO7qxkoeYT2JlyXOdZk52rg=;
	b=1MRFeQRbj2NydQy/HOHe1aDKl+tpN8Rj2Xj/kZ0DkLajX/Um3gscqxJNVmXTFXrvbI/M8a
	z6Cp/z3TRQwcTINBD2HxiUWZUb9vatjBSEK4OJsNi9jaDpOrP3dtYUZ6Vju2mXXrGsU3c9
	9qy+Hdy7KgMQpcYxNrFty7DfBMw/8AE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0134638E;
	Thu, 12 Nov 2026 19:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D9F1F00932;
	Thu, 12 Nov 2026 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510563;
	bh=ARceR6sl6TvT/XAyg4c0LO7qxkoeYT2JlyXOdZk52rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQ+RMj7dBNhiAUpKq3rjQI7bybb2GaJoSA2nzb7AukYsIeG+JIDuhm+3Tvtblq0P3
	 YaJ4wPnYU3ip2iqYpgbqu+NxozX+e4XbuhBjd8NB5My1sv8wV5T/G9gV8jZcRDBHhx
	 mXWjyaQ9gDBO+YvcS85ZlOlg9crizEpLWeXan8K+x9JYWoSrjxFpCKlHdkDQYx4JRX
	 ys6HzoPxUdqOYmp2Za2l11sa0l1qJENLJfKe9XZCBjgUqfhsacYu4CX6E9OoDt13Gu
	 xlgEttTOkAh0ZhS3PmGVDKg+xAPrP0QwYPG0g9uJg29/u6mVsaDtDKnLmO/nabP4dQ
	 ezITBAkfhX8uA==
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
Subject: [PATCH v12 6/7] mm, iomap: let a DONTCACHE writer complete its shared pages itself
Date: Thu, 12 Nov 2026 14:09:09 -0500
Message-ID: <20261112190911.84702-7-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s3565zg7fj6k5d96u5c3i475ujmypbd5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77A721C000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794510564-978150
X-HE-Meta: U2FsdGVkX18Fl0hAolRHwNbDyrKf0DjWpIQHOVkTZRG+EtpzFQKrz95AGgirj7Q/jlgrz7ArW3BtsdLL5Shn2WRYJLHn5bQen6aiuzbfhrvWSWF4uQNFItirW3YEx7qrTX/apqnDwk8IK/TQm0K4JFio3AnWPxnCI5DTEKvoNUP83HIgE1ogwdSFzWr6RFEWMNLEXA7WQj0P+2w0LQGikI3HAks4e5ggIMGYMBN+/mMNT+2AHYsAzYtOguxqbnoHrr5HAW5YIiJ+ShgKSIxyk0QViR067oUmzuzwZ14RSIKp/JteN9HCYk+G9l8szIVmY5VBWHYZg57xpVYriZqg7YoHnqlqFzAfIOtbFNTzHe1QuJLOPr9PgF9StJibWnxcEcWlOrKxFfh0U5dk6ve/dpr+1RAvn31zqcsgnPZe9thRuOKhouGCReDZ1jaUsD6tL+uowSwIcCM8tnSjQP9WY4uGY95R5ei03bP5xXnlxt93kQRjjKs//Uwxw2JvGHNge9jx2yqTq8XHSHuHQbV5BBYTWjmnZoGh238kkv7FfXLOz+Emc+B5YuDEJ8lugWlI9IORuXZQ3IqHnFwdRIVI8GQM/jq+cX1WkIIu1XLLedl+nUypIzyNoAWRUr1tkS/UELpz5CwhcBOoWBba7q7YEwFLeRvuBhJmq3CfIFZj+pCIBMASA8Bkb7oyHfaKlYbjk6JyXggzQ4DtRwl6ko1/EQj+hVvOHD+L4siD7pxP8YuyxXuPA4b1uHggsZ4qAfC/Hrv1xQ+mcO8LWMeNDxIDXtBvLLaQwsJCg5LMVSUqFSo67Ho1TuGlajx+9bVaIjeU5D+/8zxp6sALa6I/qfERhR+dYsIZCadxSnxJY+Z6D+ohTIO78/glyzO5fUxOizTbPjNvtCKT54EFjBw1bOshoB9Z659vEEB3FusBz0xz1AUTp13IrbNlYyQQOWwzpYV/ssp/1HDiEkN9A24t65N
 R+qVr2U4
 lWLDOh/kHdiJQtxDcjhR4mp+Efynma1p2k/FJIgBStacFUvVST9l4J6gVeODDi+gDBUlkXLoCf13iiuzyBDxQsVpAlmFbBvtaBbnBUXvJFtIwYP7hXokPYFug9mxFeJW5uHXQRKeoCcv4F3fclVBo1LgmUfhcdAL+68OO6M8mdu876X2afI6/0RxlKfCmxd6R3wrYHgjFdx9L9C3XSgpAP3W0sH/8tfdPhVbvkJGoZZIm8IQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With the previous commit, the write that completes a shared folio marks
it while it is still dirty.  The folio then counts as DONTCACHE dirty
and wakes the DONTCACHE writeback kick.  Some callers sync once, after
writing several segments.  NFSD does this for a WRITE that the client
sends as FILE_SYNC or DATA_SYNC.  Such a caller wakes the kick once per
segment, for pages that its own sync is about to write.

Add IOCB_DONTCACHE_DEFER (with IOMAP_DONTCACHE_DEFER and
FGP_DONTCACHE_DEFER).  The write leaves the folios it covers only
partially unmarked, and the caller completes them itself.  Called right
before the write, filemap_dontcache_edge_completes() tells the caller
whether the other write that shares the folio already wrote its part.
Called once the write and its sync are done,
filemap_dontcache_edge_complete() waits for writeback in flight.  Then
it marks a dirty folio and kicks writeback, or drops a clean folio at
once.  A mapped folio stays cached, as folio_mark_dropbehind() leaves
it.

Two writes that arrive together may both find the folio absent.  The
folio then stays cached until reclaim.

IOCB_DONTCACHE_DEFER enables NFSD, in a later commit, to avoid waking
the DONTCACHE writeback kick.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  |  6 +++-
 fs/iomap/trace.h        |  3 +-
 include/linux/fs.h      |  5 ++-
 include/linux/iomap.h   |  1 +
 include/linux/pagemap.h |  6 ++++
 mm/filemap.c            | 75 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 28431192fb2e3..053fe39dec595 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -812,6 +812,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		/* Another write may cover the rest of this unit. */
 		if (off || iter->len < unit) {
 			fgp |= FGP_DONTCACHE_EDGE;
+			if (iter->flags & IOMAP_DONTCACHE_DEFER)
+				fgp |= FGP_DONTCACHE_DEFER;
 			len = min_t(size_t, len, unit - off);
 		}
 	}
@@ -823,7 +825,7 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 	 * With blocks smaller than the folio, an edge is not uptodate
 	 * until this write completes it.
 	 */
-	if ((fgp & FGP_DONTCACHE_EDGE) &&
+	if ((fgp & FGP_DONTCACHE_EDGE) && !(fgp & FGP_DONTCACHE_DEFER) &&
 	    !IS_ERR(folio) && !folio_test_uptodate(folio) &&
 	    folio_dontcache_edge_written(folio, pos, len))
 		folio_mark_dropbehind(folio);
@@ -1333,6 +1335,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
 		iter.flags |= IOMAP_DONTCACHE;
+	if (iocb->ki_flags & IOCB_DONTCACHE_DEFER)
+		iter.flags |= IOMAP_DONTCACHE_DEFER;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_write_iter(&iter, i, write_ops);
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47d..4f0343eeed1b4 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -104,7 +104,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
 	{ IOMAP_UNSHARE,	"UNSHARE" }, \
 	{ IOMAP_DAX,		"DAX" }, \
 	{ IOMAP_ATOMIC,		"ATOMIC" }, \
-	{ IOMAP_DONTCACHE,	"DONTCACHE" }
+	{ IOMAP_DONTCACHE,	"DONTCACHE" }, \
+	{ IOMAP_DONTCACHE_DEFER, "DONTCACHE_DEFER" }
 
 #define IOMAP_F_FLAGS_STRINGS \
 	{ IOMAP_F_NEW,		"NEW" }, \
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c4..19aaba0bf41f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -357,6 +357,8 @@ struct readahead_control;
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 22)
 #define IOCB_HAS_METADATA	(1 << 23)
+/* With IOCB_DONTCACHE: see filemap_dontcache_edge_complete() */
+#define IOCB_DONTCACHE_DEFER	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -374,7 +376,8 @@ struct readahead_control;
 	{ IOCB_NOIO,		"NOIO" }, \
 	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
-	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
+	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }, \
+	{ IOCB_DONTCACHE_DEFER,	"DONTCACHE_DEFER" }
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5254430844b2c..fcef97e64a0bd 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,6 +212,7 @@ struct iomap_write_ops {
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
+#define IOMAP_DONTCACHE_DEFER	(1 << 11) /* see IOCB_DONTCACHE_DEFER */
 
 /*
  * Return the existing mapping at pos, or reserve space starting at pos for up
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 07f7f5190c24c..74ae4914b5820 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -701,6 +701,8 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers the folio
  *   only partially.  A new folio is not marked dropbehind, one found
  *   uptodate is.
+ * * %FGP_DONTCACHE_DEFER - With %FGP_DONTCACHE_EDGE: a folio found uptodate is
+ *   not marked either, the caller completes it.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -716,6 +718,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
 #define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
+#define FGP_DONTCACHE_DEFER	((__force fgf_t)0x00000400)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1312,6 +1315,9 @@ void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_mark_dropbehind(struct folio *folio);
 bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len);
+bool filemap_dontcache_edge_completes(struct address_space *mapping,
+				      loff_t pos, size_t len);
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 6740b860939e7..e9d87488421fc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1742,6 +1742,77 @@ bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len)
 }
 EXPORT_SYMBOL_GPL(folio_dontcache_edge_written);
 
+/**
+ * filemap_dontcache_edge_completes - will this write complete a shared folio?
+ * @mapping: the file's mapping
+ * @pos: file offset of the first byte the write covers in the folio
+ * @len: bytes the write covers in the folio
+ *
+ * For an IOCB_DONTCACHE_DEFER write: call right before the write.
+ *
+ * Return: true if the caller must call filemap_dontcache_edge_complete() once
+ * the write, and any sync of it, is done.
+ */
+bool filemap_dontcache_edge_completes(struct address_space *mapping,
+				      loff_t pos, size_t len)
+{
+	struct folio *folio;
+	bool ret;
+
+	/* FGP_DONTCACHE keeps a mark, FGP_LOCK guards the block state. */
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
+				    FGP_LOCK | FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return false;
+	ret = folio_dontcache_edge_written(folio, pos, len);
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_edge_completes);
+
+/**
+ * filemap_dontcache_edge_complete - drop a folio both writes have written
+ * @mapping: the file's mapping
+ * @pos: any byte offset within the folio
+ *
+ * Call once the write, and any sync of it, is done.  A dirty folio is marked
+ * for the writeback that cleans it, and a clean folio is dropped now.  A
+ * mapped folio stays cached, as folio_mark_dropbehind() leaves it.
+ */
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos)
+{
+	struct folio *folio;
+	bool kick = false;
+
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
+				    FGP_LOCK | FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return;
+	if (!filemap_dontcache_edge_unit(mapping, folio))
+		goto out;
+	/* Writeback in flight was submitted unmarked and would not drop it. */
+	folio_wait_writeback(folio);
+	if (folio_mapped(folio))
+		goto out;
+	if (folio_test_dirty(folio)) {
+		folio_mark_dropbehind(folio);
+		kick = true;
+	} else {
+		/*
+		 * Drop it now, unmarked: a mark cleared outside the i_pages
+		 * lock could miss a store that counts the folio.
+		 */
+		folio_unmap_invalidate(mapping, folio, 0);
+	}
+out:
+	folio_unlock(folio);
+	folio_put(folio);
+	if (kick)
+		filemap_dontcache_kick_writeback(mapping);
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_edge_complete);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -2140,8 +2211,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	 * completes it.
 	 */
 	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
-	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio) &&
-	    filemap_dontcache_edge_unit(mapping, folio))
+	    !(fgp_flags & FGP_DONTCACHE_DEFER) && (fgp_flags & FGP_LOCK) &&
+	    folio_test_uptodate(folio) && filemap_dontcache_edge_unit(mapping, folio))
 		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
-- 
2.52.0


