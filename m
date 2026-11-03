Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94C3606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q3K/sg4m
Received: by kanga.kvack.org (Postfix)
	id 2A23D6B05C1; Tue,  3 Nov 2026 16:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279206B05C2; Tue,  3 Nov 2026 16:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6C36B05C3; Tue,  3 Nov 2026 16:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59936B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EA6BA809E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:04 +0000 (UTC)
X-FDA: 85395070488.20.AFBA138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD8E1140008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3K/sg4m";
	spf=pass (imf26.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlotGg+tRroSHBXw3jTtsd7gAi/ZgdBA1276pO04Bdg=;
	b=N8q8kPFGphNCrnGBm6bTVFk0CBVlXcZt0Ab28HsCxjKjy3qTDiU7w1JgLfnBeWWcRC5p8w
	i3zU594Ish+o9FFi4SwOtJTVrnqAfib7avA5RKUXX9shfT+3UFG7eohOY6I62e5sZsG7Hz
	EYqVhqy6l0czXgBK9FpHCz6BvXgECt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740682;
	b=OfrBV6nV3W3M4/+16C4vXhlr1q2jxD9sHXCCESeq07yLhjGzSVP2zY43Xi1iFzy2rDimkp
	HHmLkImHzkE4fJ8q0GkgcTTWrGsK2WpeSkhQevYBnPxri38g4sgLV1robTjRStlHF67uW4
	RRpAdUN+rS+VwB2UHAc4l2GZW4IixDU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3K/sg4m";
	spf=pass (imf26.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4390160254;
	Tue,  3 Nov 2026 21:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84151F00A1C;
	Tue,  3 Nov 2026 21:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740682;
	bh=dlotGg+tRroSHBXw3jTtsd7gAi/ZgdBA1276pO04Bdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3K/sg4m9q+h1bF5OatHxnp6XenFw6VgcaW/nuj74DeEVmPso92M/O/42PK0P4K3C
	 3AdClbGvmNx6IekHKGln8CqxOSX2uPtIEH+MZ7FYtkk+QmH6gi0HgXQDrz2yjfaF3t
	 QRfa/RBXs5sJQpJYxaM85Ct3PSNwKwpdCFMRfoWQwoPOS+CqX5cqIojrpwfBBQRPV3
	 YHVio86VBgkEsM5J9AHfYRl19D6BYRvjhUAdLvk23j3wDGURXe/jLSpc+Lc+0TFV8r
	 SjwVQDPczzA/h4sNIrW/Wz3i3YWqSm/RP2RYcf5slMl8lrnwm3M4h9Eoki4j/ENsCl
	 RP6h8z4hF+5AQ==
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
Subject: [PATCH v10 5/7] mm, iomap: keep a partly covered page until an uncached write completes it
Date: Tue,  3 Nov 2026 16:17:52 -0500
Message-ID: <20261103211754.35352-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: xw89y3nqxhj1zrsh6um9ijqjwprqukdo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AD8E1140008
X-Rspam-User: 
X-HE-Tag: 1793740682-849501
X-HE-Meta: U2FsdGVkX192gQ1FeiHtZo1nmBgkCGalQINoh6QM1qHc2vJLrDpfwzUv4+5UoH7R9mgHghBuelRxlJVCX3ME5blVDZ/lUd/cluoLCq3oDm8MjPIqzG3aAUeyfm569nYtwrcnjuFApz21HEfWi63UKT9tMRnSL9FyaKhMtn7fEJGaX80wG65kiPvG28tu0GyojKQK/2+Epjj2bCWJA/PL7WNAiw/fwAmcnuV16MZIt5Iis28sOphfG5lhCYrpf3t9xjiEqA3vXkICGuQFUp+Z6ojHrKKLLA8WvBKL0QebKFD+Zu4bTNstAmFImbWlY86JBzO9/TZxz/82+s39rBNmRws6A03jGkdOi2p8K6hPtmppBRTOSvkEiovZoDtx/8UexDibrQmARtDpl9H0gwE24CR8//vVX8rcxbsJu7p5esKqKi9JFTDjSITtcxbDA26DQ4olqcR+DZBfeRZlFb/BbmOMZBmAGXviNj2WQgcyJov2yMalZ0jZN+veeCS0Nu0sLqomOu9OEQHhoUPIsJfFD1zoi5RqB5u6+8euSpngaf46nMZ9T0FejY87w5pbCPtI9f32NEhoQIX4CWGo2lcdkg7a85WDK05ZvxEUMbrkgW7KxK/mHdnPQUuWVMddvDze0N1Xp/9ncXpCbf8LVHOn2wVjWxOqq+3GbtkQ3ud6J5Wc+401aFqfb6Zzhfv450nvpty+7/ksLFe25/csDQXGK4V29z3dTNVvKdQ+d+Q05fj4X5m5Y75nlKHvNBU44MqOvBhlje9y6yYHzU9fkx2kAYRCz1lFqe8xmqL3gvf39+/MNzPjokBiPFLQJHsFvxImBSTcBhCeYTyAvsi2niIKROe6kZYaln5x8TLvket8Wi0mSl2dQp3rVg7hHSzPeWwpabuVcuj21SuuVS8+5N7Vj+usa/RjnPgW6Xr9T0BG8dz2U2JStwnrXTenoa86Dernee/HNa4OVYPDo5gjjGx
 pxkVXxS+
 o5ycAZMFdWmhIGw2uLNLwwr3OQYQ3IZZ7ejig4IEwgUxhrcY78GibZLzvLW4DvsTJvuq2EtDYOiHyLDQhDcDZoiRecvDXo65GgiiUqnBgLloOrjMipFir/2CSHDn3gdo35rualI7cOKD+PlqJ/hJT1SorjNtMmsjqbq8INbuIP6NwCSVr4Qhyk1XATmpEc6dtP7bneJRTDPl4zaMk9yYeRD73Y0XDHlzlVAlkhq2Z6l7eKH0uI0rIYse0cMD3XqaOVY8WEWGWDVH//F5Uc9jTRMezBtSzpXatYzmVmewLz5faiX3YmBq1M/ePmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An RWF_DONTCACHE buffered write marks every folio it creates dropbehind,
so writeback drops the folio as soon as the write's data is on disk.  A
folio that the write covers only partly is usually shared with the
neighbouring write.  If writeback drops it before the neighbour writes
its part, the neighbour has to read it back from disk first: one read
per misaligned write.

Add FGP_DONTCACHE_EDGE for the lookup of such a folio.  iomap sets it
when a write starts or ends inside the smallest folio the mapping
allows.  A folio created for an edge is not marked dropbehind.  A folio
found uptodate already holds the neighbour's data, so this write
completes it.  Mark it with folio_mark_dropbehind() under the folio
lock, and the writeback that cleans both writes' data drops it.  With
blocks smaller than the folio, the edge is not uptodate yet, so
folio_dontcache_edge_written() also accepts a folio whose blocks outside
this write are uptodate.  A larger folio, such as one from readahead, is
left alone.

An edge whose neighbour never writes, such as the last page of a file,
stays cached until reclaim.

With this commit, using 32 threads writing interleaved 47008-byte
records to one XFS file with RWF_DONTCACHE: Device reads per write fell
from 0.97 to 0.0005, and throughput rose from 831 to 2281 MiB/s.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on questions from earlier reviews, with the code that answers each:
    
    - Blocks smaller than the folio.  folio_dontcache_edge_written()
      calls ->is_partially_uptodate() only for the blocks this write does
      not cover in full.  iomap_get_folio() returns the folio locked
      (FGP_WRITEBEGIN includes FGP_LOCK), so the per-block state is read
      under the folio lock.  iomap_get_folio() tests IS_ERR() before it
      uses the folio.
    - Larger folios.  filemap_dontcache_edge_unit() accepts only a folio
      of mapping_min_folio_nrpages().  iomap_get_folio() limits len to
      the unit, so fgf_set_order() asks for no more than one unit at an
      edge.
    - Lock for the mark.  __filemap_get_folio_mpol() marks an edge only
      with FGP_LOCK set, so folio_mark_dropbehind() always has the folio
      locked.
    - Stale dirty tag.  folio_mark_dropbehind() tests PG_dirty and the
      tag (4/7), so a clean folio with a stale tag is not counted.
    - Mark before iomap validation.  The lookup marks the folio before
      iomap validates the iomap.  If the iomap is stale and a fatal
      signal stops the retry, the folio keeps a mark that this write did
      not earn.  Writeback still cleans the folio before it is dropped,
      so the cost is one read on the application's retry, never data.
      The lookup cannot undo the mark: a folio an earlier write marked
      returns early, so the lookup cannot tell whether it set the mark.
    - A partly covered folio that another task cached and that is
      uptodate is now dropped after this write's writeback.  Before, an
      uncached write never dropped a folio it did not create.
    - Only iomap file systems set FGP_DONTCACHE_EDGE.
      write_begin_get_folio() users, such as ext4 and the NFS client, do
      not change.  With blocks smaller than a page, a write that crosses
      an extent boundary inside a page looks the page up as two partly
      covered halves, so that page stays cached until reclaim.

 fs/iomap/buffered-io.c  | 26 +++++++++++++++---
 include/linux/pagemap.h |  4 +++
 mm/filemap.c            | 59 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6e2f1ded5ca6..919e4d6c3c972 100644
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
+		/* A partly covered unit is shared with the neighbour. */
+		if (off || len < unit) {
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
index 3f5295d6fd73b..7a78f645de9f6 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -698,6 +698,8 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
+ * * %FGP_DONTCACHE_EDGE - With %FGP_DONTCACHE: the write covers the folio
+ *   only partly.  A new folio is not marked dropbehind, one found uptodate is.
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -712,6 +714,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
 #define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_DONTCACHE_EDGE	((__force fgf_t)0x00000200)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
@@ -1307,6 +1310,7 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_mark_dropbehind(struct folio *folio);
+bool folio_dontcache_edge_written(struct folio *folio, loff_t pos, size_t len);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 5134227ba3a23..ec52e4c960849 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1675,6 +1675,52 @@ void folio_mark_dropbehind(struct folio *folio)
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
+ * folio_dontcache_edge_written - has the neighbouring write written its part?
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
@@ -2067,6 +2113,15 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 	if (fgp_flags & FGP_STABLE)
 		folio_wait_stable(folio);
+
+	/*
+	 * An uptodate edge holds the neighbour's part, so this write
+	 * completes it.
+	 */
+	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
+	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio) &&
+	    filemap_dontcache_edge_unit(mapping, folio))
+		folio_mark_dropbehind(folio);
 no_page:
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
@@ -2104,7 +2159,9 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
-			if (fgp_flags & FGP_DONTCACHE)
+			/* A new edge waits for the neighbouring write. */
+			if ((fgp_flags & FGP_DONTCACHE) &&
+			    !(fgp_flags & FGP_DONTCACHE_EDGE))
 				__folio_set_dropbehind(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
-- 
2.52.0


