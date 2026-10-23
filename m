Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19584606A332
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K3Oos1Q4
Received: by kanga.kvack.org (Postfix)
	id 35E4B6B0684; Thu, 22 Oct 2026 22:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFF16B0AC1; Thu, 22 Oct 2026 22:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F086B0AC4; Thu, 22 Oct 2026 22:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5376B05A0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:46:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C587A160179
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:59 +0000 (UTC)
X-FDA: 85352351238.29.D5D7E80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 271221C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3Oos1Q4;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NlcxosGh2gIOhdABr05dDd9bx0s30l3aI//SNro8bs=;
	b=dKxhJKm0qfeKpQ54aBek1qfgNJrt2AobLAVl3I6MEE6WkwlLsQ0pueemOBc1hTr5J/pCnv
	d2uI8+eFsTuftnUbddBrI10u7ZGpFVX7574mXDkogesBzI8bMNuU2XrrgfnOsZxd5IOic8
	mZPy4zWDGCeqpWSA4SoyQ+nYbCwg3J4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723558;
	b=rLZH2nUp3wa3W+d1mwtHME0zW6RmZpYPLRPI9qC7ZmGgFVLa1V3VX5PqgR/TBW7889xwgt
	lRDISxbqLAj7ZF1501wrIPn/TReDMNFilRBDfZjFqmYthWGvpLsGGOESRL7GlNH+d3Ol1d
	VJmUPultB3oWdXUGfmrwjhH2QXe9JjE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3Oos1Q4;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E773243FB4;
	Fri, 23 Oct 2026 02:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1631F031E6;
	Fri, 23 Oct 2026 02:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723557;
	bh=8NlcxosGh2gIOhdABr05dDd9bx0s30l3aI//SNro8bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3Oos1Q4fc+HmrIkBsm3Z6JCyINIrLSRDgmK1YDr/ObmUyCfu7jiKaMIMvT4asOB4
	 CwjTraWQ7ZdLUw/wfiJxz/nngwg90AhEmD0GgxjKN2UQ03K7W86KeTgIX60RmOCIpT
	 ko2YQq/1c5PXUZzbaj5q3huNUNeh8xeHimS5lXHBLH6RdtII9BDN1AeVYCVUjAoaq6
	 WRMxDzjvu5NMW71QVqKLpjIPD3cjM2VCO4QIbxxlIDKrnOy2pPMk6rQEHTqXMOi7Jd
	 aZ7yu7oSUfrkK9fbJ94k77n7/MM0r/7zmlU7ZdqmbzQytUFl31er4q6QFqGr5TvSHS
	 MRaKaZYq9JDdA==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v8 6/7] mm, iomap: let an uncached writer complete its shared pages itself
Date: Thu, 22 Oct 2026 22:45:47 -0400
Message-ID: <20261023024548.71123-7-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 271221C0003
X-Stat-Signature: 89usk46nwt9fy7wbegx3fdbzx4exiw97
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792723558-535514
X-HE-Meta: U2FsdGVkX195/qn/ISaUPWR3CUqrLx2yCx64d/A0i2kDdh0khOxCOWOkA5sqYF8v4nx7+pIdiveIQCf8zXbe8wBg8t3qMv2GH+MszscT6/aEbWA6Pq65gk9/Wcsy9CW515xD9rkVL9YmtHHaHGAiT/JvLw9pKafy4sms3gVEaiCME++GC9ojS09TgSk3Fme/LRqkiKN5cDFDdMEGILtOZXS1iwDYkKcsRBDNsPKYPjI2VcFFzaXiOHvMyKU3kSfH9e7kc05zgY37Nn3TYZIht9KBwqCpsXuYg9hPZpjY7FSCNjlf5zWlGf9IVIZCi60ywahyKje+1DiWbvVArt99KgrjMJCG5HyG1y0DpRJ8bq2nHaVXEnUUjjk3bIKOM2HKvCKLzTvWc2p84PBwEP1JIXIkBpEUDqq/VwonloDMmG4mvCH7GSA2u7eGAqGUw1K83PZzlMrqc6u4kOpTFsAZ4f2AyLkB3wnqYQbFlfJRrjnpfYwkOdILK4BVprk0pU9D6vxTneFa+wMYv0TI1ogctDIp8XN6xp9fbHXzEmEediYPslvWmQnClSkaQN8xMRBrhxx/7Vbcg+tcWdvKsMRMOZQIE+5TEb67GJwCiIOoyteddto8XgR/hpgf1ed+yA8Roj3sSuXO1PB16d9Kw3LdD8S6XzWjJoA/dBfOyVeNETdzFLDHNvIjYrDaLZtx4Ludu3aVW4D7hP9OuB4gSQO1W1ykvaS+XcRq7YHpOeBblw1xALoxZ4zkAGjoaA5+wJsB89qg8KR1oHtdFVF9N/mQd9d4VsPVgJRAHvYtt0/8cEF/uPbhYvaDrxhWmJe9UEBSU6V2KONIkpAqH4aJMbdo7MKmOuPRh7eue0jJN5gKzSpF5BaRtSzAWqJu91WJCSkGGctTV5tKlEfIlpfjUcHtfRZ8lvdrUrYnX1mz+h/rE8vKGmE85iAmzc7jlw6AUXyTPfgybZ1zT9XCXG0sGKg
 Ce0B+u3G
 Aw3j+fKIV/HP8IRX9jMi3IzRQuXGjMFBJPduzrVmYeEhT/v6DrHf53pANM5yS81BBifUPUabwuimAzpU7H0yRwPOSKForrZCzCMQyMW0oq02g3zWg/QzzsTqTpJq2D+vUOkV14YJtLEcPh0CAY/lTupbkhm87MI4hyK50MG774O22y3ImaPAQ1KKPyz3K89mctDjNcWlB0EkO/40yV+6X/j9+nvilSJ5gex4ZM6nsrNnxSZX6Z6EaKY85eVrJlPxmdN+S2jf023VbrnAZhwx+VWxT8PRPRUKikAykhyvXaBIiYclH/TSm3dgqfPumipBgStYE
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
unmarked even when the write finds it uptodate.  Right before writing such
a page the writer asks filemap_dontcache_edge_completes() whether it is
uptodate already, which means the neighbouring write has written its part
and this write completes it; once the write and its sync are done,
filemap_dontcache_edge_complete() marks it and, clean, drops it at once,
before it lets go of the folio lock: dropping it after the unlock, with
folio_end_dropbehind()'s trylock, would leave a page another task locks
in between for reclaim, no writeback being left to drop it.  As in the
default path, both helpers take only a folio the smallest the mapping
allows; a larger one is left cached.

Two writes that arrive together may both find the page absent before
either has written; that page is then left cached until reclaim, which
the folio-lock ordering of the default path avoids.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  |  4 +++
 fs/iomap/trace.h        |  3 +-
 include/linux/fs.h      |  8 ++++-
 include/linux/iomap.h   |  1 +
 include/linux/pagemap.h |  6 ++++
 mm/filemap.c            | 70 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 86f884c9f8f2..78d560a7aeb6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -815,6 +815,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 		 */
 		if (off || len < unit) {
 			fgp |= FGP_DONTCACHE_EDGE;
+			if (iter->flags & IOMAP_DONTCACHE_DEFER)
+				fgp |= FGP_DONTCACHE_DEFER;
 			len = min_t(size_t, len, unit - off);
 		}
 	}
@@ -1322,6 +1324,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 		iter.flags |= IOMAP_NOWAIT;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
 		iter.flags |= IOMAP_DONTCACHE;
+	if (iocb->ki_flags & IOCB_DONTCACHE_DEFER)
+		iter.flags |= IOMAP_DONTCACHE_DEFER;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_write_iter(&iter, i, write_ops);
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47..4f0343eeed1b 100644
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
index f9d1e05e8ae6..ad181b6ce6b4 100644
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
index bc7ae6327dbf..f3509d495a92 100644
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
index 0c1d6bd09aa0..a0a67e4c940b 100644
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
@@ -1316,6 +1320,8 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_mark_dropbehind(struct folio *folio);
+bool filemap_dontcache_edge_completes(struct address_space *mapping, loff_t pos);
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1494e42e609f..890913f38c65 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1695,6 +1695,72 @@ static bool filemap_dontcache_edge_unit(struct address_space *mapping,
 	return folio_nr_pages(folio) == mapping_min_folio_nrpages(mapping);
 }
 
+/**
+ * filemap_dontcache_edge_completes - will this write complete a shared page?
+ * @mapping: the file's mapping
+ * @pos: any byte offset within the page
+ *
+ * For an uncached writer that completes the pages it covers only partly
+ * itself (IOCB_DONTCACHE_DEFER).  Call right before writing such a page: it
+ * is in the page cache and uptodate when the neighbouring write has already
+ * written its part, and this write then completes it.  Two writes that
+ * arrive together may both find it absent; the page is then left cached,
+ * unmarked, until reclaim.
+ *
+ * Return: true if the caller is to call filemap_dontcache_edge_complete()
+ * once its write, including any sync of it, is done.
+ */
+bool filemap_dontcache_edge_completes(struct address_space *mapping, loff_t pos)
+{
+	struct folio *folio;
+	bool ret;
+
+	/* FGP_DONTCACHE: a plain lookup would clear a drop-behind mark. */
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return false;
+	ret = folio_test_uptodate(folio) &&
+	      filemap_dontcache_edge_unit(mapping, folio);
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
+ * Mark the page drop-behind.  If it is already written back, drop it now;
+ * otherwise the writeback that cleans it drops it.  A dirty page marked here
+ * counts as DONTCACHE dirty and wakes the DONTCACHE writeback kick, so a
+ * caller that syncs its write calls this after the sync.  A folio larger
+ * than the smallest the mapping allows is left as it is: it holds more than
+ * the two writes' page, and it cannot be dropped in part.
+ */
+void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos)
+{
+	struct folio *folio;
+
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
+				    FGP_LOCK | FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return;
+	if (filemap_dontcache_edge_unit(mapping, folio)) {
+		folio_mark_dropbehind(folio);
+		/*
+		 * Drop it now if it is already clean, with the lock still
+		 * held: folio_end_dropbehind() would take it again with a
+		 * trylock, and a folio another task locks in between would
+		 * be left for reclaim, no writeback being left to drop it.
+		 */
+		filemap_end_dropbehind(folio);
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_edge_complete);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -2085,8 +2151,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


