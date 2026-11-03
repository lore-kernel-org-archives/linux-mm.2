Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677C9606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=axU4iFli
Received: by kanga.kvack.org (Postfix)
	id ADFD56B05C3; Tue,  3 Nov 2026 16:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F726B05C4; Tue,  3 Nov 2026 16:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD4C6B05C5; Tue,  3 Nov 2026 16:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69D7D6B05C3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F5B6140545
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:05 +0000 (UTC)
X-FDA: 85395070530.15.BB61DF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECC911C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axU4iFli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnloUmsZsf6oNfFGEMrCTsKE5Nav6+L5VT61SKrRMnA=;
	b=lcw8U3L8MEVkUf9+u6gzNrMzvk1E+FXLhAb4zY+AufSYXhNsUrANZYpUwgUhGLIolBw8Y7
	l09nel3SWN4HQfh7ve6qAwSVCgIPOinHnhh4m6/SR2nJXcT0McnhXVctAyggyns67/sclR
	J5gFcBJ/+eLw2MJA6/4sDCuLddnvU8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740684;
	b=5Mj1GwMl9lC1nA6xOAOrJnfVroyOMvmjyakeTNZgnxJTq8AAmyghVN45qSSEtZQzlQZklP
	ISRLsmSIOA4hU3dY2nRaN4g5i7aCK9iRQ/fkP1aUhm7/cqBbIIUzqYL+0iZ5EKj7RiYuVM
	2+uAkGZa3m92SlB/NIPAMKqBi6jMUkw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axU4iFli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44B41413D4;
	Tue,  3 Nov 2026 21:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9591F00A1F;
	Tue,  3 Nov 2026 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740683;
	bh=vnloUmsZsf6oNfFGEMrCTsKE5Nav6+L5VT61SKrRMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axU4iFliVMAe/3Md7GyF/qiGEnxxm+dS/eHYLCqgH7+DjBuesHvghs096B3nOru+e
	 bLeaquzxxMyLyt0xqIeBnzl79x+yhGtmKdLRQlKTL7tNkxo4fA/zJxNNhuNo1/qkbV
	 s7fipLDyZMaBy2WiMDTtc1WqM8ZoP4kc2M0oQPj6vnYBiUlOxPG0Bovp7mYsHJzO1X
	 AkD+6nb2gwhHRGlK4LArZ3ZFmoKvy0NyHQfF5hZWjedZF/3c0xSvBdNEf0X4fBvF5+
	 FGDESsPpWiCsIzrYsMTv+zgGC5a/h+U/Hyj6GzQcU4TVvegilWT+2FZXgB8PDyU0n2
	 prKZxz906Qavw==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v10 6/7] mm, iomap: let an uncached writer complete its shared pages itself
Date: Tue,  3 Nov 2026 16:17:53 -0500
Message-ID: <20261103211754.35352-7-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: giogwjxaauwrpys7q4dpr4grhc5jnqrr
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECC911C0005
X-HE-Tag: 1793740683-75531
X-HE-Meta: U2FsdGVkX196WTBVMwr8lA3JnZuH/GrxOohaLVSU+uo+vAJO3nARnfDix3F6sBtG9mSEooTOOU3KJc7+9E/ANj2OsJXVmAR6DCmvFQK86kNyF5tgVUph1Q1MM0CNL5rNdz7/dfWrcCJWZa3w1727M7yaMjhnQtQhYo3+zxo4qvl4CQ2y0UMYXYq3Oai8VoMIG9STe+htjIbEU46tWuD81c4UNTZuJn6fG7894hykV8SpQOb/FA2LfcdbM/SSfQ0Rd7QQt/IF677WbiU+SDGUejpx8kvciMZ9eHl/ra57Wjmh9NBWv3M8QehoTbNIlEbhHLkb3Ulurae/VKg4dCf8WrttpfmrcetuX4U4C6bnU7PMAsyRMqLMjFYsyNflKcfiTfI2aTEqugV43TxnP1pEp18Y5Nw1NbT2jX7lj/LLEAtBL9rPQG8rlmHzMABmix4q0SpuM9KzMJeYNyK38YzZcLYzp3y4OAVYTa6uepGUUdjOAKs6e91O3iSG3g4Fv5HiB0UD7SFUttYn3ncY+Okjfbm5/lOd2odRQz9vPlqU0nZ8Vrqk6UJuTAon6GWgYTkZmwxQGiofNwGKBbN2n9n8RVyIwxBA0P7feEMEWgWE8VIvHmsflWDSNfRlOHiWj45kzfvgKceC9D5ZXTlbiey7edEQc2vdoan9d92q7Ee1WJcKSJza4FEfLZktex8Bih29bybri4TGedDLIkxkr8IeJX+9CLDcfmVM9eaLoNgLyp5c2fHivRcwWZkm2gPolGI/HJksodZbH95dvxgiNmAT5XShO8byoUT9mnZc3lkvbfYLBlZUXdGTOnG61+eR3gRwU0O8/zdU/bFH2HbG852YaXvvcrsxzxeXlu7Mpkd6US6YMkK/EOJB3hqbB9yIulVL6K/zl+5C+G2GeifCQkbjp8Aezc6KRVRpRXWx0KLO7d6Zbmdnu84eOe1QVzfv12OhAoP0ksVEJdFZpHjx3IU
 uUcv/EHd
 8Y0xRQHM5v11DSUkbqPAs+NMGbw9SAKTHVqxMjR6ZWRBkF63wM36VThyZ1WbIjT1kWPRUpVDZ1a/eRvsxkzIq0J3DS1sqNG8N512FKVmTqsBR84zNeKVk7cQWrewIbSz2mhDlTLnt+yqwO+CYyjqTI+QC/YmXWe7HzxaFAMGzBH8llSvq73EIQB1jAIBDFZX9cWY4jFixuqQnD4HebXyVeKr0jP/+Gah7B7MpT6aIEKEGeV7yXE04gbn1S0ApCNKm7TzDB26wsI+UMxQvWOgYMlm+1Ew8MmYIBqZf7pandK/9hNWlvYCs8F0yLQ==
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
writing several segments, as NFSD does for a stable WRITE.  Such a
caller wakes the kick once per segment, for pages that its own sync is
about to write.

Add IOCB_DONTCACHE_DEFER (with IOMAP_DONTCACHE_DEFER and
FGP_DONTCACHE_DEFER).  The write leaves the folios it covers only partly
unmarked, and the caller completes them itself.  Called right before the
write, filemap_dontcache_edge_completes() tells the caller whether the
neighbouring write already wrote its part.  Called once the write and
its sync are done, filemap_dontcache_edge_complete() waits for writeback
in flight.  Then it marks a dirty folio and kicks writeback, drops a
clean unmapped folio at once, or marks a clean mapped one.

Two writes that arrive together may both find the folio absent.  The
folio then stays cached until reclaim.

IOCB_DONTCACHE_DEFER enables NFSD, in a later commit, to avoid waking
the DONTCACHE writeback kick.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on questions from earlier reviews, with the code that answers each:
    
    - Writeback in flight.  filemap_dontcache_edge_complete() calls
      folio_wait_writeback() under the folio lock before it tests
      PG_dirty.
    - Writeback kick.  The helper calls filemap_dontcache_kick_writeback()
      after it releases the folio lock, and only if it marked a dirty
      folio.
    - WB_DONTCACHE_DIRTY for a clean folio.  A clean folio that is not
      mapped is not marked: folio_unmap_invalidate() drops it under the
      folio lock.  If a store dirties it first, folio_unmap_invalidate()
      finds PG_dirty under the i_pages lock and keeps the folio, which
      has no mark and so no count to lose.  Only a dirty folio, or a
      mapped clean one, is marked, with folio_mark_dropbehind() (4/7).
    - Blocks smaller than the folio.  filemap_dontcache_edge_completes()
      gets the folio with FGP_LOCK and calls
      folio_dontcache_edge_written() (5/7) with the range of this write.
      FGP_DONTCACHE keeps the lookup from clearing a mark.
    - Flag values.  IOCB_DONTCACHE_DEFER (1 << 24) follows
      IOCB_HAS_METADATA (1 << 23).  IOMAP_DONTCACHE_DEFER (1 << 11)
      follows IOMAP_DONTCACHE (1 << 10).  FGP_DONTCACHE_DEFER (0x400) is
      below the order bits (FGF_GET_ORDER() uses bits 26 to 31).

 fs/iomap/buffered-io.c  |  6 +++-
 fs/iomap/trace.h        |  3 +-
 include/linux/fs.h      |  5 ++-
 include/linux/iomap.h   |  1 +
 include/linux/pagemap.h |  6 ++++
 mm/filemap.c            | 74 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 919e4d6c3c972..c47fa683aaa8a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -812,6 +812,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		/* A partly covered unit is shared with the neighbour. */
 		if (off || len < unit) {
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
index 7a78f645de9f6..a276d6e7279a3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -700,6 +700,8 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_DONTCACHE - Uncached buffered IO
  * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers the folio
  *   only partly.  A new folio is not marked dropbehind, one found uptodate is.
+ * * %FGP_DONTCACHE_DEFER - With %FGP_DONTCACHE_EDGE: a folio found uptodate is
+ *   not marked either, the caller completes it.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -715,6 +717,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
 #define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
+#define FGP_DONTCACHE_DEFER	((__force fgf_t)0x00000400)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1311,6 +1314,9 @@ void folio_end_writeback_no_dropbehind(struct folio *folio);
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
index ec52e4c960849..d540df29870a9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1721,6 +1721,76 @@ bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len)
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
+ * Call once the write, and any sync of it, is done.  A clean folio is
+ * dropped now, a dirty or mapped one by the writeback that cleans it.
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
+	} else if (folio_mapped(folio)) {
+		folio_mark_dropbehind(folio);
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
@@ -2119,8 +2189,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


