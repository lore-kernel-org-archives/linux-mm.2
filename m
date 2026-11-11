Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB9C606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EnQ6Rlsb
Received: by kanga.kvack.org (Postfix)
	id F34646B05BF; Tue, 10 Nov 2026 20:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4B06B05C1; Tue, 10 Nov 2026 20:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C1A6B05BF; Tue, 10 Nov 2026 20:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5B736B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35B65401A3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:19 +0000 (UTC)
X-FDA: 85421173278.06.0D6DC98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92A55140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EnQ6Rlsb;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362177;
	b=hBAlnDppFZdY7g+QRhGdn/H/cdwFCOBwRa6OuY6aVdRfW5SZm/GmoYzq12qu4h+etSjLRu
	EX2fqTFP8HsRjahW9aFtYXkKFCXqOk87p/0JVJhhxVvaBGvoLD31y6wB9iXsCShEpsvu0m
	prolmP5i9N8llFwSqwYn12K8MUjQ/8E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EnQ6Rlsb;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hd4RGh+Kitd+bKI3dRT1HwwrBybf/ObmgK+7t63TdZ8=;
	b=Qs+V5ZUK8tZQlPko0HG/eSO0Uj9v2dm3SI8QbdaDPTVFvHWJsSV+gLYb4orIOQWQwwMhL3
	++C79/sll/I+/MUCHRyP07HURjUDP+iANlsmudThpqTmpL63P6tmQ98lNofI0GgrFPqjif
	KlOFR5OcLOmenNv/dHNbz3fdLDnNO1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E360047318;
	Wed, 11 Nov 2026 01:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9872E1F00A05;
	Wed, 11 Nov 2026 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362176;
	bh=hd4RGh+Kitd+bKI3dRT1HwwrBybf/ObmgK+7t63TdZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnQ6RlsbSRdzDxacWioYu09+SEo5DOgPspa6g+xn0IrH+/5NLcaREuHfT4ip5k2Da
	 TFky5tYZP3XbEhBIiuUWFemU41ld0ANrKKTwgprH5BFAVAuO4ZWyQoAK7FGrAmdV1d
	 MQvTjwd/kpmUC2wpW445KzfUSkWUlaB3hDS4P8dFqHKdm+mA27p0gh6tOypKYYX0WM
	 B3SpZNDcpRI8S/vMgOw83GM+r6eJdubi5vUqvd5tk0Xr5ebggqo8HZ7WnGcF5udrPS
	 qrZZr/OHJOYrU+XCUfEN12rm1is1/yW36pRc+6z9S2uIOb1P2Rh+Nym584B4CEZ5pY
	 UnQpXOiVBYIqg==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v11 6/7] mm, iomap: let a DONTCACHE writer complete its shared pages itself
Date: Tue, 10 Nov 2026 20:56:06 -0500
Message-ID: <20261111015607.46338-7-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3urrxbbm8y7yfibpz43ryi19mni5do74
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92A55140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794362177-134515
X-HE-Meta: U2FsdGVkX19d6HMaHaBs7pVGyHPL0Ipk9ZCJhEMOnT0CniQCURiElZo2HAtM26ROZl68NcY74DeYdrDZtiHMc7m6+Mv/2vsWZTb+jUuf6ydam9Lvy1iVY0klatwehEz0SC/jr2acI4oh0FNEYstUrCvDMuDtblSQR6T7CipG81/ZsiOohHmN9xCAxtKUjZ+AyNrLdiBMY/nU4sE55q3mclGasxjI60sJg3666bLlR4e4a1jz1V8Hd2/RPJwkNGk1oOQSOBzO9bjbdBUTQwvKre9yGpVf3OHx8Tord1q8vDygcbhmUQUfOErGpiMABB+wEJfiwclLknAzzlLJ6vA02+FXZCiwOXuBDZ43Vsnwu091l5Od8FRX5pV1FJYs2LzwbLuh9wRv4y3dEPifbeeSXSZl0IiX3FyBDatiQ0LnvNZAkOkm+1Znjd255j1P+HQFHq5MJ55y9zao8rQ+/MYEg/E0dh6zpZSnJfKXGx7Ak25kciICFLTpMLR0WwXfplevqcuj2CNaDmtuRAgCHfd7bLL/T3gX7MS0YZELtqd/PRDowxMwoLnuFFhthGQnM7X9NeiU+3e9b2XPNHrNfJS54xgSyDKRPi0hQx9EGtyl3GMSkRXK5uYZj9mcGJRqZ2XTQ4lp2xxVZg9kY3+mg/boCbxND7VZWkv50MhBXs1Dk+ndvsDje7ZL7cVUgRrahtR6XxLc+Ux3PExBZDnKT4lIALfTWAHI8NKcMzCj44ughoCCQMTPecoLc8X7mtbPKg/PdSud8SXArGfCzgs+aaf77CcOp035jklU7BrBdjaM+05qf13K9hCDJ6/cEadRgp9yjjlJsSsXTbHAe+hJfQFASXP1N+GeK5FsW7GfMKozHTonLGVrWdY8ZEhWXZ+PQDrZ13liRngDxviISD6oXxJlUu4rX6XpOUnEjd2M3ODCKTe1EmdSS5NhWl2AJ9z/svZn3natHPqFxyradk9JkFj
 cvclxX2d
 68Kw9ysfrSigh6gF3IN+WoOtuSz96T+dr8xs8AH5NMaV3dEhvrgxoRMkCp/mntwbhkXJBx48quw0Xnuw3UD2AVIRjh7NJRBGdkbsZBekkm4CpxEx4tlelJSPjL9m7dOLLUepWPTWqQ6Bs1q/J8tsIBflG7Mx3OY5caMpcKlOPbFP6cOzOBBSXnTBLzpV8kEvHVXD7EOBHXF5VlUCw1oADYYR8naiqX8KfWu3uSm8M7Uex284=
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
it marks a dirty folio and kicks writeback, or drops a clean unmapped
folio at once.  A clean mapped folio stays cached, as
filemap_end_dropbehind() leaves a mapped folio.

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
 mm/filemap.c            | 73 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 89 insertions(+), 5 deletions(-)

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
index afba94b33dcc6..b8d34abe55671 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1732,6 +1732,75 @@ bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len)
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
+ * for the writeback that cleans it, and a clean unmapped folio is dropped now.
+ * A clean mapped folio stays cached, as filemap_end_dropbehind() leaves it.
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
+	if (folio_test_dirty(folio)) {
+		folio_mark_dropbehind(folio);
+		kick = true;
+	} else if (!folio_mapped(folio)) {
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
@@ -2130,8 +2199,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


