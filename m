Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AEF606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQkzUF9W
Received: by kanga.kvack.org (Postfix)
	id 21A3E6B05A0; Thu, 22 Oct 2026 22:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7556B0AC0; Thu, 22 Oct 2026 22:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4BE6B0AC2; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 945CC6B0556
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFA1C801BE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:58 +0000 (UTC)
X-FDA: 85352351196.05.1424B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 516DD120009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQkzUF9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+LCRyvu/R0wTzZRZEFob59r20QzB8GOilM+8NDrD+M=;
	b=P9Bf1rh4VAFhIQ0RGUQvJn5mddeLj9VwqRvEEEDCIPIM5IRNwK70Ddu1VLvNBoN2bERpuG
	nTlRgZYyeZU+2LUwF+duKeEgjmdnhKlnkpqY8obOIaabL4Yw7Z346VXXk9Ex94B451u6yc
	WV0OKp4Vp3VV9YndaioH+KtHpSp6m2A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQkzUF9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723557;
	b=Eb22g5gWA61Q5JO3zEbvMCVh7Eu1wplqiudlbv3P6TMGF4DSuSnpSP7B212GdRes1hgSYy
	mE3jPBuDqUOUp3fW2YNdaEtFzLtLJEKtsFtrVeqdSYukkPZ8DR73rSt1+Ff1ihjNH6pzAp
	GMZhUNB9uIV8TThwNMWRgw89IEDbfT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A07F344517;
	Fri, 23 Oct 2026 02:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F55B1F01828;
	Fri, 23 Oct 2026 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723556;
	bh=i+LCRyvu/R0wTzZRZEFob59r20QzB8GOilM+8NDrD+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQkzUF9W51kZu+BBHbr5t/7lLpCt9/5kBfLhP3OVbir9qLy/OOeuyxT5ldyEasEJu
	 UPuvjpOyPiqen+AAni99AldYCpPVHZrqJA606lvb4GTztjV5ZIDfE8ur39jB1sD4NK
	 QEJroCzO5tO6/EnVoLn/ffrDJT3n3baqAJTd75UXUSqX2JOsf604ifcnv6T5SxT/Hy
	 oziXVAG4prWsg9XtSrzsTcyDnCZ9yAR1XAvnd9NgvKP/yReQeOGNqmiFjcE56L+wZW
	 huyT3waqnubjRRfFOIVkQHYWs8TQrjaw9/xFcjBytRrmJ2vK2vB5ul70tdNJwjHJcI
	 qaYoAwsR0FHMg==
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
Subject: [PATCH v8 5/7] mm, iomap: keep a partly covered page until an uncached write completes it
Date: Thu, 22 Oct 2026 22:45:46 -0400
Message-ID: <20261023024548.71123-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 516DD120009
X-Stat-Signature: snc1zkog8c9e7ej4798s93g7q9nrj35u
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792723557-706332
X-HE-Meta: U2FsdGVkX19Xgj+0Gm5tIMMfcRM5n5ZWGpfxif5AsDu17i/6qlO6pwSOiUQWp+WbqxFawaC2E7lLQsY2mJJ2Tw77DqvxXqRaOGEjKAB9MUddcv9uXLR2v0EDOLLNHEwv2y+DFjsCe7v6+pkLM/SHaUZQy8eNl9PWgeq5DC7fqpjPOrM3HpZSe4rlIEeq6sjcddvj4h7/qmH9nfQy1W4HI4+oZ2gg0Sz+tRm5wd0e0IzpATbEqgOo+Kg2mXRLPjFBPUDSfO74g+4oxpNsE6lBaGu0CAC9i/czMKWR0OwpnV6/+NvrNiYCwCgGo1d042afnVP6U6EGUTSgdikJ38yjaKpI8ynVS/1q/Ab1nulFxmMtU33x26zmapKGTzdjnd/YhHbuSJZlVb7DKaTRbil6a6cPTZZRHBtVe+dyvW6wmZ/f2R5UKpkV/BeEsZL1aF+Ne3LO2mwI7yxFJEyhLRFh1kkNq4njnvwkbRnKvuB0uzgne1paQcp+PdEQrHXv5agneiaiMU6yQTvXlbuXKei/YNwmzAUifM7fmFyyyKeJYI2FKviWE20FOXl0pC8tmFmLFA/vgUmAsSPoZ99KI7YPKu6qNeHXCDTVS+ZJafv2VBAyzTXq1vmp2Muvo69kflJ3e92h2og6yMrAxA4KFkRBC77IdZI2QW/WFlNsjaXNIr53Vq03TPHDvxtrLlJFNxt9fsSoa/uHmJB0pbxBcd424fSHuaF7eVgnx4TPCPBSGLXdCxxx7VUnHLouawlv16d8dq4EpfdQ4EpUT0dqxsCpygpLD5lnwzwd+wOXpM6aHinLCTYQGwlg9xA0Jlm0UwKf6SK0fLZsYJP77jXEXV4t3uNLBQe984QAVzgVsE2UxY9BE2Udr3BbtvGKaytpd1xHu/z9h4uDU+ounUykLQZeX9lUc3OWCMg6fgTH3UPQtAG02lQaJ+HZv8FvkqjxGyP78XCJF3QrXbla1qBNnVb
 Ts0WVwE2
 Zr+5GKr9f8j9kJYmuP4Jqnu1mc3YE42rZpPHo/Oe0E7KnhKYyWSux+QKJpZtYqGBGLfxiC2EKqd2j0e+GsWZmH+Hk3DCYr/5zTJEwQWZvxQTmdxyF2j6XU3+xPOqCBVWgHQrfH56sieRgiJJWdLZ/CZXlzfIgDLy7KwvhVBNKOWBVODgvX1G8z1680YLf9I+0uD/VXJoEonuVSO6jJe5hQi8x2p6anZT0wke14eYOeS5jGcuj22aiqudwrfKmFdwDk7LBBD65xTliWkBcZihPWfvYnynkhUArytifjZr32q9NGfaZ//j9kOte1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An uncached (RWF_DONTCACHE) buffered write marks drop-behind every folio
it creates, so writeback drops each one as soon as this write's data is
on disk.  A page the write covers only partly is usually shared with the
neighbouring write, the one that ends or starts in it.  Once the first
of the two has been written back, the page is gone, and the second has
to read the block back from disk before it can write its part: one read
per misaligned write.

Measured locally on XFS (emulated 4Kn NVMe, 4 KiB pages), 32 threads
writing interleaved records to one file with pwritev2(), 1 GiB per run,
before and after this patch:

  record  flags                     4 KiB device       MiB/s
  bytes                             reads per write
                                    before   after     before  after
  47008   RWF_DONTCACHE             0.97     0.0005    831     2281
  47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
  6000    RWF_DONTCACHE             0.97     0.0001    121      488
  6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206

Before this patch every write waited for its read, and because XFS holds
its IOLOCK exclusively across a buffered write, the other 31 writers
waited too: both record sizes ran at about 20 thousand writes a second,
one device read per write; after it only metadata is read.  With
RWF_DSYNC each write still waits for its own sync, so the gain is
smaller: the uncached write now runs as fast as the same write without
RWF_DONTCACHE, 1237 and 209 MiB/s against 1227 and 206 in the table.
Records of 49152 bytes, which cover only whole pages, read only that
metadata, 0.0005 per write, before and after.

NFSD DIRECT issues the misaligned ends of a WRITE as buffered uncached
segments and gains the same way.  Without any handling of the shared
page, 32 interleaved writers of 47008-byte records read 45144 blocks
for 45664 WRITEs; with this patch, and no NFSD code for the shared page,
0.0001 to 0.0008 blocks per WRITE whether each record is sent as one
FILE_SYNC WRITE, as two one after the other, as two together, or as two
UNSTABLE.  The page cache then marks the completed page while it is
still dirty, so each segment of a stable WRITE wakes the DONTCACHE
writeback kick (23 to 65 thousand rounds a run); the next two patches
let NFSD mark it after its sync instead.

Let the write path say which pages a write covers only partly
(FGP_DONTCACHE_EDGE) and get such a page as the smallest folio the
mapping allows: a single page, or a single block where the mapping's
minimum folio order makes the block larger than a page, which is then
the unit two writes share.  iomap sets it when the write starts inside
that unit or ends before its end, testing against
mapping_min_folio_nrbytes().  A folio created for it is not marked, so
writing back this write's part does not drop it.  A folio found
uptodate is the neighbour's, already written: this write completes it,
so mark it, under the folio lock and before its own data goes in, and
the writeback that cleans both writes' data drops it.  The folio lock
orders the two writes, so the second always finds the first's data in
place.  A folio found there that is larger than that unit, left by
readahead or another buffered write, holds more than the two writes
share and cannot be dropped in part: it is not marked, and stays cached
as it would without this change.

A page whose neighbour never writes, such as the last page of a file,
stays cached until reclaim.  A partly covered page another task had
cached and that is uptodate is now dropped after the write's writeback,
where before an uncached write never dropped a page it did not create.

Only iomap file systems say which pages a write covers partly so far;
write_begin_get_folio() users such as ext4 and the NFS client do not.
With blocks smaller than a page, a write that crosses an extent boundary
inside a page asks for it as two partly covered halves, so the page,
though one write covers it whole, stays cached until reclaim.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/iomap/buffered-io.c  | 16 +++++++++++++++-
 include/linux/pagemap.h |  5 +++++
 mm/filemap.c            | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..86f884c9f8f2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -802,8 +802,22 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
-	if (iter->flags & IOMAP_DONTCACHE)
+	if (iter->flags & IOMAP_DONTCACHE) {
+		size_t unit = mapping_min_folio_nrbytes(iter->inode->i_mapping);
+		size_t off = pos & (unit - 1);
+
 		fgp |= FGP_DONTCACHE;
+		/*
+		 * The smallest folio the mapping allows, a page or a block
+		 * where the block is larger, that this write covers only
+		 * partly is shared with a neighbouring write: get it as just
+		 * that, which is kept until the write that completes it.
+		 */
+		if (off || len < unit) {
+			fgp |= FGP_DONTCACHE_EDGE;
+			len = min_t(size_t, len, unit - off);
+		}
+	}
 	fgp |= fgf_set_order(len);
 
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3012bd95812a..0c1d6bd09aa0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -701,6 +701,10 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
+ * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers this page
+ *   only partly, and a neighbouring write may complete it.  A folio created
+ *   for it is not marked drop-behind; a folio found uptodate is, as the
+ *   write that completes it.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -715,6 +719,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 0c76ee5750b3..1494e42e609f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1683,6 +1683,18 @@ void folio_mark_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
 
+/*
+ * Is @folio the unit two writes share at an edge: the smallest folio the
+ * mapping allows, a single page or, where the block is larger, a single
+ * block?  A larger folio, left by readahead or another buffered write, holds
+ * more than that unit and is not marked for an edge.
+ */
+static bool filemap_dontcache_edge_unit(struct address_space *mapping,
+					struct folio *folio)
+{
+	return folio_nr_pages(folio) == mapping_min_folio_nrpages(mapping);
+}
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -2063,6 +2075,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 	if (fgp_flags & FGP_STABLE)
 		folio_wait_stable(folio);
+
+	/*
+	 * An uncached write that covers this folio only partly, finding it
+	 * uptodate, is the write that completes it: the neighbouring write
+	 * that left it here has written its part.  Mark it now, under the
+	 * folio lock, so the writeback that cleans both writes' data drops it.
+	 * Not a folio larger than the edge the two writes share, which holds
+	 * more than they wrote and cannot be dropped in part.
+	 */
+	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
+	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio) &&
+	    filemap_dontcache_edge_unit(mapping, folio))
+		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
@@ -2100,7 +2125,14 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
-			if (fgp_flags & FGP_DONTCACHE)
+			/*
+			 * A folio the write covers only partly is left
+			 * unmarked, so that writing back this write's part
+			 * does not drop it before a neighbouring write has
+			 * written the rest.
+			 */
+			if ((fgp_flags & FGP_DONTCACHE) &&
+			    !(fgp_flags & FGP_DONTCACHE_EDGE))
 				__folio_set_dropbehind(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
-- 
2.52.0


