Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87991606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F90a1CzM
Received: by kanga.kvack.org (Postfix)
	id B8BA76B05BD; Tue, 10 Nov 2026 20:56:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62D56B05BE; Tue, 10 Nov 2026 20:56:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA01B6B05BF; Tue, 10 Nov 2026 20:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C426B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2AA4A6D78
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:17 +0000 (UTC)
X-FDA: 85421173194.20.9D6E4CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CAA640003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F90a1CzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXUgD80E6LY7kMauMUCaEczYLx2euvAhpzVNS87w6sI=;
	b=dBRRvgiPJ7lpQak4EtyibV1tJOL3a4j9V74jUtpalBm1v3QjhZx2w4ndsq/9iiWwOPGOgN
	kIv0AlzS1sO7if6RHbHYW9D47r0brJDDdENi6zEgjux3qyfVFiptwEk0j3IgTB9dyAkYOv
	ZpTjkQBeO/Rw/8kIbgV/eVn7qwxcvac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362176;
	b=g8yrN02RzvtUGIC8EWg9LAt6DGeLrHQZINozRvC2rbrBCdKLfbJwBhAZbFK4KihK75S61a
	MJDC7+hH/kSPXBy1TnleJMf+1baqbwzwrjk8Jwn7rEuBXFhyVTnAAlRkdyNC4JdPbt1i1S
	V/QmeEJCEVeJN1BzY/ISwtK7ePrCWm0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F90a1CzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E711E613A3;
	Wed, 11 Nov 2026 01:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E1D1F00A07;
	Wed, 11 Nov 2026 01:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362175;
	bh=YXUgD80E6LY7kMauMUCaEczYLx2euvAhpzVNS87w6sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F90a1CzMJBN/ZRXEq4FpiozYUX0jnBIYJLLZ0jYwGXlkEIXWPjX5jADnPV6Jr5z7v
	 M1rkg9CS21HWuVOnrSlr0UnlBQKqA6Q0d6Degb3a6YE2OxZjddgPIf3SmvV/PUk+6B
	 yL6c2ThD8Fn28FG1/fK3Rr2pqRAqGzGNHdYiWlrGsNSf7nS8XcaURFraOQm43pcUHN
	 eHpB93h5zqozpGPSdbptg/QfQHTK/C2L5qRRxua6S0E3t/ZW9lEgU7UyX/ZoHHCTl2
	 EOFNL297DphlCN8iFuKrGNUGu/soD/A5LNcz2Zptxbm1cEs+ZxLVlU9P+4PmIaulqc
	 QDXZ1RZgjmlyA==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v11 5/7] mm, iomap: keep a partially covered page until a DONTCACHE write completes it
Date: Tue, 10 Nov 2026 20:56:05 -0500
Message-ID: <20261111015607.46338-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 333j5itu86g87p7au9qrkx1mjnfqmuhb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CAA640003
X-HE-Tag: 1794362176-144120
X-HE-Meta: U2FsdGVkX18jFWw9i0Z7YmUuzK1KVukukspzeyviQrItTsHjS/dhXw60/hShKRw0a0Vs8gmplADix4Hq4E0f5/HQ2YRPvZZX3547Z7On+O6dlzHN6r9DMjS4MiM+QZJtD/QaxA/7O68P7mj0QhLr9dOQxM/lNPA7OiTSa5anMjxx/jhRF20fsVruOC6R+uIQBDr1Xtf879tzJT92xNkG3Q9IzwDNsn4MmAbcGL6AqLfxL3pmdrBPLhdjZC5h9cQaijj+IJx13r6n57+wPDWvzcnCOwEKIoYyexbkgaXPjA8iysYgZsdM3XbjKxbGv9ocuUavSVUmDJyPNvSkwBl02zPbBLpNSNMhNQwTvh51jtxTImtbH4flqqjthygUkX4si9h5FVj/88wKClpkDdYTTIW0hYv2mn8WI7j0zcDPqe3lACEp0l51rOMT0hOtgR1VfqBG1GHZPIbgo4ysiszINLRq+OqHgrKOHiV0eKQE2RjRzBYTuSDhxT/CEZhGb1WgqHynlbb4wAgAnTC7KEP5JnL9y20hZpIwQe/NzIU9mHaLudkxmAKIO80cGjR2YzD6SRF5TXxXTGqnFcg7Rv81kCDFfislWOVPjlBu3n2XplV5r86tH08cv/hbcUHJKHBsLkVw5FUqRu88MCFL2BSQ7CB7YiRiegmj9DNntgVZuEkvXR1+UibnpU2PfupTHDnM6S3NHq8iwwdAzBuGO7JwYFIpJyDHvHddyMr+8b7E1UuWLnlYeK6ov/jqFI5oSXiXOTNQOUH9kPEhKk1q5ulILfEijpDeQ/lm7ZdFm/lqE+k6A8a/2gIXm+U6q8xKgyhSRaE2fN8q97QXJ1goeG665VMP2YxAK6l4lj2/CV1uKtABFrt9OjNIaYvMG0auFNTcUrj8s6UFnra+IMYnHbL7FxnM8nnAlbpZb7DFpqyM8o82s80fSv1zx3FZtGhKEgtZ6QJYDA/mZBLFFpwkAaA
 NUprZPE5
 npmt88WxkyhN2AN2p4OSWxNi/7Qvm+J/TYlBRly7hGjxZ8G6eDbodYNZ5fXtuitki2bYVUj7DEY+kyWCfyFH7dSnAyrVkYtScs4HnltnLV9NgIZl4QkLrGOf1VParI7oTy/Dd4r98JrFPVshjz31zPDHtP9ImonUcCL5v9v+EpeRFKZVWNV9Ka8Xqvqdgc7ZNlgDVVx5kGxZUQKMK1USiBjfryknmNs65rSdWjdSAyKdM0rM=
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
index a54d0fbd37222..afba94b33dcc6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1686,6 +1686,52 @@ void folio_mark_dropbehind(struct folio *folio)
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
@@ -2078,6 +2124,15 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
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
@@ -2115,7 +2170,9 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


