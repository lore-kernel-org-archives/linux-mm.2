Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06048606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nuVJg5UL
Received: by kanga.kvack.org (Postfix)
	id 762136B05B6; Sat, 24 Oct 2026 18:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739FA6B05B7; Sat, 24 Oct 2026 18:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678CB6B05B8; Sat, 24 Oct 2026 18:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 381886B05B6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:12:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B42671C3C48
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:12:01 +0000 (UTC)
X-FDA: 85358918442.18.4C1DC71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 23C02C0008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuVJg5UL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792879920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzKU6IyObChzl3lwHoNfMnHSLmzyeXJpuhSqPEbdypg=;
	b=EkXSYSEa6lOoBTdeR9mj2BGbnyEl1Hnam2TYD7stnpO7/9+YcPvwIFfwV2hx8h6p6TSIqH
	W1u5aSwZ0yq6d/7VP/j7JW0/1HrcOY3Tf2cNTHo0qBPPcduDBV0+hysiMAld7FukzoS/Ef
	9H8+oQrNG4wH3HZiXd+qxytiq0kQ0z0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuVJg5UL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792879920;
	b=AvGSm8MRigjIpWITzKq9KUXKnXkysqKbPoFVMJ+G+RaO4HQjtiPhmt+wdhZ0eLuJcqz+gd
	y+gTEXG4rxvfzrlJ7LCg5K6NmcrMGR4PdsvA+vqltzHx6zTT0+LFzrplg3QeC6ZhKFXWVh
	Vg2Pse+9uUEfAxfW9dyDIsyoeTPugoU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A72E9601EF;
	Sat, 24 Oct 2026 22:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0501F01825;
	Sat, 24 Oct 2026 22:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792879919;
	bh=ZzKU6IyObChzl3lwHoNfMnHSLmzyeXJpuhSqPEbdypg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuVJg5UL0GJQsA2XXA/fsHKR71oP0tCTYmsPpWoEbRUt6guzY1R6ZuRJoePOYp28v
	 wKwZ5LUmGxR6AFNfbd1sflvccmtcn7Gj4ius8GHY1qTPdq6EW9OsvJwCw9sM5ZCefH
	 DmChg7jcgVWV0nnFGs9fqVe00vya7N6MbrjsYGyaCqR8ZMtUFH7SRr+X8gDNHwfH6J
	 znAcb4d2EocjM9hdbUXRbcY3IQZ1otVZN2RWC1J4w/AW91tECGzV6+YM+ApoVAAreE
	 OCjE4oMe6+uT6qT7JFWSH5QZfR2C5EcX7BlJXIDTu2j7jfCjRikxAsvfzP+9FeFmey
	 V6m6Nvl1yTcfw==
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
Subject: [PATCH v9 5/6] mm, iomap: let an uncached writer complete its shared pages itself
Date: Sat, 24 Oct 2026 18:11:51 -0400
Message-ID: <20261024221152.6965-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261024221152.6965-1-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23C02C0008
X-Stat-Signature: ssywsbypd43jo1tu7bqqp7btzpd6a4j4
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792879919-544960
X-HE-Meta: U2FsdGVkX1/gq3lSJrA4cc1N4Z7/VJuzJmATsHPKSqNZlHrpAaKTdQY0i9mg/Syc2HbDOTmBy7wriY1cPzKni6tL2wcn1EbuOjRf+N3VSlRrSMsfzdl5vocm+f659agxqUv7FUl5y4g2fZdm7bNNgo2msSoWEo4gPTFY7hhgO1XU0XeGIFI57Z6v+IYE9RWwRsQbV3m5ptxzRu32WoExQXVVFDea/H1zYVLjtwyWjKjF8OdAXzZRl9BYvm9QbH+LzGnigrwkX7azrduWRdJcZQvHjTRE23EQlLYDbiMKJ0CSNmdI0PxOI6vil54CHD3E4AXGPDi0HnWkSZyh3yLs75t0v1ShmBywzpCfv7xbbyKMmhbSC60QRNp8XQHD7oZ8LfZdlFyC5HVPay4dsTy2mDbXcNLLY5ebIbOzv6oUweZmhXTy8P/yRaGQZEKNDs3m3ikvTMUBZzosbtssZlJNWU1R4FYY1SGYr8I9swTy71DKmLrdh+d9PTBVZSl5+DeVhfAXEj4vi2OX1o7APUCliCPtfr4y8r4JN2D3wXbbJaHKqmuaXrTRQQ7wpMTeYpPO6/3p7woWuO7EPVbGTnaHpXI06gPI1Pn5XnuZinUHd4z4PJIRbb7zy6Hdxqs8E6WbY7S0JIx3y9LNwCLZ7i9leyD8b+e2P7fO8V0IAvAFkD+fAtglPrOOxamOXtyfublC85srkaie+/xmmSmpa4nunBCqIw3GE+DWNKRsr0GW7pB57+Kbw+RNyYZkUGovBF3sFGxJN5qiro4fxKAgkXib77g1v6SP+kLa659bNPpl6I2Gd99TYdUMo81rmZ2qLH65OoF/DA3WBzADmaHFC4cVtK9FaoCmMurjU4lbsRe9DVNaiHmopUQ/RJr3TCOef4t4Xmh1HLLYxrSWMEJe7m2BjxAwUBhdgemjegmkjeZLFymgumihyYFt2Rii7C3XHCeB1wi+zmkPWlMcw9ia0fA
 UgzOl4Ys
 fSr3Ag0LvkoBjNYXaCTnLH9dTMFtBJfxoM8rHMI95Kn870nO7s02sr59pH9+/WFzWrkyvj+FgqJs4fp8ub4ID1Iw2TviW76Q5W1jQnOkXkdODIlrRD8OHL4T0iY6QqaZaYH85odXbA0aRLhK1aut2pOkikZA/UJx6MA0+jBpz3BUjWuqAklqC4a+JNiKoeTmh1EcFDZKwO1XYOhRWTB2UwkCNZyepmJQ0jL3ToxIqTPE7LQzyIeN3Z1lZtFM8XHSB74OKtM6a3SjEWAEuh2qMPwLlgO+hGoPnALFr+CIyb/aRHtUMD3OOK1wOxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The write that completes a page an uncached write covers only partly
marks it drop-behind as it writes, while the page is dirty, so the page
counts as DONTCACHE dirty and the DONTCACHE writeback kick writes it
back.  A writer that syncs its write itself, once, after several
segments -- NFSD answering a stable WRITE, the NFS client's LOCALIO path
-- issues each segment without IOCB_DSYNC, so every segment's kick
writes back pages its own sync is about to write.  Measured with NFSD
DIRECT and 32 writers of 47008-byte records: with the previous patch
alone, 23,000 to 65,000 kick rounds a run, where NFSD marking the pages
itself after its sync had taken 51 to 274; with this patch and NFSD
using it, a FILE_SYNC WRITE wakes the kick not at all.

Let such a writer complete those pages itself.  IOCB_DONTCACHE_DEFER
(IOMAP_DONTCACHE_DEFER, FGP_DONTCACHE_DEFER) leaves a partly covered page
unmarked even when the write finds it uptodate.  Right before the writer
writes such a page, it calls filemap_dontcache_edge_completes() with the
range that this write covers in the page.  The helper locks the folio and
asks folio_dontcache_edge_written() whether the neighbouring write wrote
its part.  If it did, this write completes the page.  When the write and
its sync finish, filemap_dontcache_edge_complete() completes the page
under the folio lock:

- It first waits for writeback that is in flight.  That bio has no mark,
  so its completion would not drop the folio.
- It marks a dirty page, which then counts as DONTCACHE dirty, and wakes
  the DONTCACHE writeback kick.  The kick from generic_write_sync() came
  before the mark.
- It drops a clean page that is not mapped at once, without a mark.
  filemap_end_dropbehind() would clear such a mark outside the i_pages
  lock.  A store through a mapping in between could count the folio as
  DONTCACHE dirty, and nothing would uncount it.
- It marks a clean page that is mapped, for the writeback that cleans a
  later store.

The helper drops the page before it releases the folio lock.  A drop
after the unlock, with folio_end_dropbehind()'s trylock, would leave a
page that another task locks in between for reclaim.  As in the default
path, both helpers take only a folio of the smallest size the mapping
allows, and leave a larger one cached.

Two writes that arrive together may both find the page absent before
either has written; that page is then left cached until reclaim, which
the folio-lock ordering of the default path avoids.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on the v8 review questions, with the code that answers each:
    
    - Writeback in flight.  filemap_dontcache_edge_complete() calls
      folio_wait_writeback() under the folio lock before it tests
      PG_dirty.
    - Writeback kick.  The helper calls
      filemap_dontcache_kick_writeback() after it releases the folio
      lock, and only if it marked a dirty folio.
    - WB_DONTCACHE_DIRTY for a clean folio.  A clean folio that is not
      mapped is not marked.  folio_unmap_invalidate() drops it under the
      folio lock.  If a store dirties it first, folio_unmap_invalidate()
      finds PG_dirty under the i_pages lock and keeps the folio.  The
      folio has no mark, so it has no WB_DONTCACHE_DIRTY count to lose.
      The helper marks only a dirty folio, or a mapped clean folio, with
      folio_mark_dropbehind() (3/6).
    - Blocks smaller than the folio.  filemap_dontcache_edge_completes()
      gets the folio with FGP_LOCK and calls
      folio_dontcache_edge_written() (4/6) with the range of this write.
      FGP_DONTCACHE prevents the lookup from clearing a mark.
    - Two writes that arrive together.  The commit message states this
      limit: the page stays cached until reclaim.  Data is not affected.
    - Flag values.  IOCB_DONTCACHE_DEFER (1 << 24) follows
      IOCB_HAS_METADATA (1 << 23).  IOMAP_DONTCACHE_DEFER (1 << 11)
      follows IOMAP_DONTCACHE (1 << 10).  FGP_DONTCACHE_DEFER (0x400) is
      below the order bits (FGF_GET_ORDER() uses bits 26 to 31).

 fs/iomap/buffered-io.c  |  6 ++-
 fs/iomap/trace.h        |  3 +-
 include/linux/fs.h      |  8 +++-
 include/linux/iomap.h   |  1 +
 include/linux/pagemap.h |  7 ++++
 mm/filemap.c            | 92 ++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index eb1f7f019a852..e60a6ec5a1aa3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -817,6 +817,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		 */
 		if (off || len < unit) {
 			fgp |= FGP_DONTCACHE_EDGE;
+			if (iter->flags & IOMAP_DONTCACHE_DEFER)
+				fgp |= FGP_DONTCACHE_DEFER;
 			len = min_t(size_t, len, unit - off);
 		}
 	}
@@ -829,7 +831,7 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 	 * smaller than the folio, the edge this write completes is not
 	 * uptodate yet: mark it if its other blocks are.
 	 */
-	if ((fgp & FGP_DONTCACHE_EDGE) &&
+	if ((fgp & FGP_DONTCACHE_EDGE) && !(fgp & FGP_DONTCACHE_DEFER) &&
 	    !IS_ERR(folio) && !folio_test_uptodate(folio) &&
 	    folio_dontcache_edge_written(folio, pos, len))
 		folio_mark_dropbehind(folio);
@@ -1334,6 +1336,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
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
index f9d1e05e8ae68..ad181b6ce6b4f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -357,6 +357,11 @@ struct readahead_control;
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 22)
 #define IOCB_HAS_METADATA	(1 << 23)
+/*
+ * With IOCB_DONTCACHE: the caller completes the pages the write covers only
+ * partly itself, see filemap_dontcache_edge_complete().
+ */
+#define IOCB_DONTCACHE_DEFER	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
@@ -374,7 +379,8 @@ struct readahead_control;
 	{ IOCB_NOIO,		"NOIO" }, \
 	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
-	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
+	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }, \
+	{ IOCB_DONTCACHE_DEFER,	"DONTCACHE_DEFER" }
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf8..f3509d495a92a 100644
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
index 0b151c1201082..73c906e782b7e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -705,6 +705,9 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  *   only partly, and a neighbouring write may complete it.  A folio created
  *   for it is not marked drop-behind; a folio found uptodate is, as the
  *   write that completes it.
+ * * %FGP_DONTCACHE_DEFER - With %FGP_DONTCACHE_EDGE: the caller completes the
+ *   page itself (filemap_dontcache_edge_complete()), so a folio found uptodate
+ *   is not marked either.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -720,6 +723,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
 #define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
+#define FGP_DONTCACHE_DEFER	((__force fgf_t)0x00000400)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1317,6 +1321,9 @@ void folio_end_writeback_no_dropbehind(struct folio *folio);
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
index d7bbea442a019..be9997aa5ac48 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1742,6 +1742,94 @@ bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len)
 }
 EXPORT_SYMBOL_GPL(folio_dontcache_edge_written);
 
+/**
+ * filemap_dontcache_edge_completes - will this write complete a shared page?
+ * @mapping: the file's mapping
+ * @pos: file offset of the first byte the write covers in the page
+ * @len: bytes the write covers in the page
+ *
+ * For an uncached writer that completes the pages it covers only partly
+ * itself (IOCB_DONTCACHE_DEFER).  Call right before writing such a page: it
+ * is in the page cache, with the neighbouring write's part written, when
+ * that write came first, and this write then completes it (see
+ * folio_dontcache_edge_written()).  Two writes that arrive together may both
+ * find it absent.  The page is then left cached, unmarked, until reclaim.
+ *
+ * Return: true if the caller is to call filemap_dontcache_edge_complete()
+ * once its write, including any sync of it, is done.
+ */
+bool filemap_dontcache_edge_completes(struct address_space *mapping,
+				      loff_t pos, size_t len)
+{
+	struct folio *folio;
+	bool ret;
+
+	/*
+	 * FGP_DONTCACHE: a plain lookup would clear a drop-behind mark.
+	 * FGP_LOCK: the per-block state of the folio is read under its lock.
+	 */
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
+ * filemap_dontcache_edge_complete - drop a shared page both writes have written
+ * @mapping: the file's mapping
+ * @pos: any byte offset within the page
+ *
+ * A page already written back is dropped now.  A dirty page is marked
+ * drop-behind, counts as DONTCACHE dirty, and the DONTCACHE writeback kick
+ * is woken, so the writeback that cleans it drops it.  A caller that syncs
+ * its write calls this after the sync.  A page that is clean but mapped is
+ * marked for the writeback that cleans a later store through the mapping.
+ * A folio larger than the smallest the mapping allows is left as it is: it
+ * holds more than the two writes' page, and it cannot be dropped in part.
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
+	/*
+	 * A writeback already in flight was submitted without the mark, and
+	 * its completion would not drop the folio.  Wait for it.
+	 */
+	folio_wait_writeback(folio);
+	if (folio_test_dirty(folio)) {
+		folio_mark_dropbehind(folio);
+		kick = true;
+	} else if (folio_mapped(folio)) {
+		folio_mark_dropbehind(folio);
+	} else {
+		/*
+		 * Drop it now, with the lock still held, and without a mark.
+		 * A mark set here and cleared again outside the i_pages lock
+		 * could miss a store through a mapping that counts the folio
+		 * as DONTCACHE dirty in between.
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
@@ -2135,8 +2223,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	 * more than they wrote and cannot be dropped in part.
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


