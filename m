Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DEDCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A6B6B0099; Thu, 15 Oct 2026 19:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FAFF6B009B; Thu, 15 Oct 2026 19:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6116A6B009D; Thu, 15 Oct 2026 19:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8296B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E904C0239
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:17 +0000 (UTC)
X-FDA: 85326464034.25.4FEF815
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9514E40007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B//psEQW";
	spf=pass (imf17.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107195;
	b=V8NlVKFRXigZc04XAyrC9RLx8rLGGVprSK1xub+yorqDkutT+zn/5AAGKDA8Nk0q0lxz38
	OMx+Di4++rozjJPznfU5vTI9pS7jIn6htnEVA9sfsdnR6h65Lfoe7zJ8xNptnzAQQKuDt+
	RM4v53EwPdM2qH99/JC6BdgeqEDTkWw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B//psEQW";
	spf=pass (imf17.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFOCc0VSdNc0cHBxC5EnZMiNIFzOFbGe0LmlYJb7AAE=;
	b=necuT2Uc0YDvaTqojGmgSKl9uVInwY07AbrPHyirlw2iyHwxyguK9dYSbkNCH/CJF5KSJt
	CzDTMuPLLhxKqCBbAzc61xVsbew3d0hgM/nAdB49NcwWLHiDqHVTd7KHTFa/ZdaLIxiE+f
	Zdak5+2ybfkC5Ct93USR8vIo6ONxZj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFCA2447BF;
	Thu, 15 Oct 2026 23:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D47A1F000C5;
	Thu, 15 Oct 2026 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107194;
	bh=XFOCc0VSdNc0cHBxC5EnZMiNIFzOFbGe0LmlYJb7AAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B//psEQWAtsi4Sd9kWhFsqexJxobRTD4hC1mcMpLs2UEKlb2QdFEkTuyw6OXeWfLh
	 oo6Y14CL0QEL/90mWt+EakF+geRpj3Bo/9nJVU/Okuh2hq9PKyGnh7lfldYL1YeW1l
	 cUfW07cPrJ4S+eeLC81tkienpPVUY/4QRWE2levRtNOnYZCxSAtXDykvankGou4bqA
	 KUUCv5ZXgR9dVbTS+MTzjgd2QmmoRIqY9R2QnE+xm7Ej2EE51v1iuNlm6W40UHB7b4
	 OjLIS1L0vXBXC9aRx7UOO/xhcBQR7NedS2Rbmu/hIbQpRCpB4twmDx5tXmH1jAs+Rk
	 M2mT3BLKLP8Ew==
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
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 03/10] NFSD: only split a direct-mode WRITE for a worthwhile direct middle
Date: Thu, 15 Oct 2026 19:33:02 -0400
Message-ID: <20261015233309.42999-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9514E40007
X-Stat-Signature: wfy3h6cfow9xmcxmoohoecuj8t3s38pt
X-HE-Tag: 1792107195-94138
X-HE-Meta: U2FsdGVkX1+ze70SeyHqrRWcoflhn5XTSFL2jTCywi2q8rJtV/W/Jl7D7Uyg8n03Imzldx6dP6FVKk6lzE8sfFa6o5Kgjo8MNDQvjHUfO51j5RahyO7CftmAsA976FfAxwSw4awhRRJ83R8M6jS9W9OdYEUW6rwTxt29qGFK7mYNvZ3Ywa4l1HkJ37RPPYZq3EieVu7bjiT3L08XTrpm577XpFIXjejNtSs+/GSX7nbgmOZr5jfclq58G+AsNGNZfwDIwZdmYdBLcpf084hiiCKObqrCXjfTCSVmO8Sc6A7F828jdfolKiR9tt+mU3ynIPrZ4xnzZZ3QxorotJdGiSBbBvCCPeUHVNy1dI+PWLd9bpPsqOTFWjswu24VUFnG0S9HQx27OWLQwwkegh3qaMqIwTPn4tzkxUcJ295pxyguoyDdKFwHgrm90ToeztijKUKysILCptLshgPH+ntY8HK6T2gC4bIvI9IXkj3zGslKWgY3U0Qctt32xh/yhSBCcIcWISKCo0xzBPkFUr5tCSrjeLPsyJ6C/FMe/XUY+2OMz5RM4SOo4U+pZR8Lm5F/H4HaMsVcYTqh0HO0qiH4TW+BXU+4e2ftt/EV+nobnbLXTMSd9LuPaKuXjQG4oRsisV665GuJpSAEFCguAFg3LeKG4HxJU3NSh2SkZvvtyzaQp9+OZam3Y6JKvTiwaX5OdjL6VjjmGBfM8cDvstUUOnPTXODl9N4DBdirZNMf3IXjNJtLHz0qGnWWhHsbS6oPZrW/tskJDE6AM+s7DlJ4uur34hSOR1oyuaAbymjnyIU0SV9fWF4a2dQ100TDlH/cbqmSJ8zlif8K4EGR0UjX72HXh6wfaJADm+t1WCQ+agh5ISzaB7BSnCJhUABeotILMJFxgX1LRYGh/KOjWIlJdlibZpModVnfUIWxVGL2gcQp0BDvU/Tq7woLq0Vx8rokJV8YBPrPCps1BdAXk7q
 Nx2ddPat
 K8crPJpiAKXmjty5xIDX13ia+VtGgLDwh6R7BuyE6cvca2uHFocf8pZWXYJlgUpZBSzobvuJiyJMmMI/XcqYkQxu9K4p2po59dHgZ/Cy877Vo1BUZhrpjr+FNi6NxJkYHdLgQZUpMrE3pSuPdFqAnYDeOrexGM3KhiwvrXmhQboUkB2FT5S2pNjyo5Q29EVGDxZvfmcjC3ewzTR7HjUUku/ryaaH601fjC8N1njLjN89Q2c2LM+OjD6OtyWzK2l5eejC9MUPPpmIJaxY/Iqb7ccHbzNNlvoaXmxubyYdeNCynk8NsgJIz0/flzH5+x8SqVtSVj9/mNs7m/9uANAU3ZPeUOFfPrVlUiiM8TKsCxhad9c88C7oPDvDD4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Splitting a misaligned direct-mode WRITE issues it as two or three
writes instead of one, and the direct write first writes back and
invalidates the page cache over its range.  When the DIO-aligned middle
is small, the WRITE is mostly its buffered prefix and suffix anyway, and
the direct middle only adds that overhead.

Add direct_misaligned_min_bytes (debugfs, default 8192) and do not split
a WRITE that has a misaligned start or end and a middle smaller than that
many bytes.  Such a WRITE is issued as a single buffered segment, like
the other WRITEs NFSD does not split.

The gate counts bytes, not pages.  What it weighs, the cost of three I/Os
against one, does not change with the page size, and since a misaligned
WRITE's middle is cut at page boundaries, the middle of such a WRITE is
whole pages: a gate of two pages would demand a 32 KiB middle on 16 KiB
pages and 128 KiB on 64 KiB pages before splitting at all.  On 4 KiB
pages the default is two pages.

Also decide each segment's IOCB_* flags in nfsd_write_dio_iters_init()
instead of in the write loop of nfsd_direct_write().  The flags do not
change: the loop already set IOCB_DONTCACHE on every segment without
IOCB_DIRECT when the file system supports FOP_DONTCACHE.

The threshold, counted there in pages, and the move of the flag
decisions come from Christoph's suggested diff [1].  Two of its choices
are not taken.  It issued the prefix, the suffix and any WRITE it did
not split, whether smaller than its alignment or with a middle below the
threshold, as cached buffered I/O, to leave partial pages in place for
read-modify-write; this patch keeps the DONTCACHE policy already in the
tree, and a later commit makes that policy selectable.  It also split a
WRITE whose payload is misaligned in memory and issued the middle as
DONTCACHE buffered I/O, so that a large middle stayed out of the page
cache while the cached ends stayed in it.  Here the prefix and suffix
are DONTCACHE as well, so that split would issue the same uncached
buffered I/O as two or three writes instead of one; such a WRITE is
issued whole, like every other WRITE NFSD does not split.

Document in nfsd-io-modes.rst when NFSD does not split a WRITE.

Link: https://lore.kernel.org/linux-nfs/aRShjU_Ti7f2Ci7I@infradead.org/ [1]
Suggested-by: Christoph Hellwig <hch@infradead.org>
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         | 13 ++++++
 fs/nfsd/debugfs.c                             | 12 +++++
 fs/nfsd/nfsd.h                                |  1 +
 fs/nfsd/vfs.c                                 | 46 +++++++++++--------
 4 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index f9b63f1a33990..eab35a9bbdb93 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -137,6 +137,19 @@ Misaligned WRITE:
     cannot invalidate page cache that overlaps the segment. The
     iomap_dio_invalidate_fail trace event reports such a fallback.
 
+    If NFSD does not split a misaligned WRITE, it issues the whole WRITE
+    as a single DONTCACHE buffered IO (normal buffered IO if the
+    filesystem lacks FOP_DONTCACHE). NFSD does not split a WRITE when:
+
+    - the filesystem advertises no DIO alignment;
+    - the WRITE is smaller than the larger of the offset and memory
+      alignments;
+    - the WRITE has a misaligned start or end and its DIO-aligned middle
+      is smaller than /sys/kernel/debug/nfsd/direct_misaligned_min_bytes
+      bytes (default 8192);
+    - the WRITE payload is not aligned in memory to the block device's
+      dma_alignment, so the middle cannot be O_DIRECT either.
+
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
     misaligned READ to the next DIO-aligned block (on either end of the
diff --git a/fs/nfsd/debugfs.c b/fs/nfsd/debugfs.c
index 386fd1c54f527..02b0369f17648 100644
--- a/fs/nfsd/debugfs.c
+++ b/fs/nfsd/debugfs.c
@@ -140,6 +140,18 @@ void nfsd_debugfs_init(void)
 
 	debugfs_create_file("io_cache_write", 0644, nfsd_top_dir, NULL,
 			    &nfsd_io_cache_write_fops);
+
+	/*
+	 * /sys/kernel/debug/nfsd/direct_misaligned_min_bytes
+	 *
+	 * Minimum size, in bytes, of the DIO-aligned middle segment for NFSD
+	 * to split a misaligned direct-mode WRITE.  A WRITE with a misaligned
+	 * start or end and a smaller middle is issued as a single buffered
+	 * segment.  It is in bytes so that it means the same on every page
+	 * size.  The default value of this setting is 8192.
+	 */
+	debugfs_create_u32("direct_misaligned_min_bytes", 0644, nfsd_top_dir,
+			   &nfsd_direct_misaligned_min_bytes);
 #ifdef CONFIG_NFSD_V4
 	debugfs_create_bool("delegated_timestamps", 0644, nfsd_top_dir,
 			    &nfsd_delegts_enabled);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index d824d2c390294..db81620bd5168 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -142,6 +142,7 @@ enum {
 
 extern u64 nfsd_io_cache_read __read_mostly;
 extern u64 nfsd_io_cache_write __read_mostly;
+extern u32 nfsd_direct_misaligned_min_bytes __read_mostly;
 
 bool nfsd_v4client(struct svc_rqst *rqstp);
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index bd3dab36e2962..a419eee401d9d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -54,6 +54,7 @@
 bool nfsd_disable_splice_read __read_mostly;
 u64 nfsd_io_cache_read __read_mostly = NFSD_IO_BUFFERED;
 u64 nfsd_io_cache_write __read_mostly = NFSD_IO_BUFFERED;
+u32 nfsd_direct_misaligned_min_bytes __read_mostly = 8192;
 
 /**
  * nfserrno - Map Linux errnos to NFS errnos
@@ -1323,9 +1324,13 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	u32 mem_align = nf->nf_dio_mem_align;
 	size_t prefix, middle, suffix;
 	loff_t offset = iocb->ki_pos;
+	unsigned int dontcache_flags = 0;
 	unsigned int nsegs = 0;
 	u32 cut;
 
+	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
+		dontcache_flags = IOCB_DONTCACHE;
+
 	/*
 	 * Check if direct I/O is feasible for this write request.
 	 * If alignments are not available, the write is too small,
@@ -1355,12 +1360,16 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	middle = middle_end - prefix_end;
 	suffix = orig_end - middle_end;
 
-	if (!middle)
+	if (!middle ||
+	    ((prefix || suffix) &&
+	     middle < nfsd_direct_misaligned_min_bytes))
 		goto no_dio;
 
-	if (prefix)
-		nfsd_write_dio_seg_init(&segments[nsegs++], bvec,
+	if (prefix) {
+		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
+		segments[nsegs++].flags |= dontcache_flags;
+	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
 				total, prefix, middle, iocb);
@@ -1374,22 +1383,28 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	 */
 	if (iov_iter_bvec_offset(&segments[nsegs].iter) & (mem_align - 1))
 		goto no_dio;
-	segments[nsegs].flags |= IOCB_DIRECT;
-	/* In case the file system falls back to buffered I/O (-ENOTBLK). */
-	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
-		segments[nsegs].flags |= IOCB_DONTCACHE;
-	nsegs++;
+	/*
+	 * IOCB_DONTCACHE matters only if the file system falls back to
+	 * buffered I/O (-ENOTBLK).
+	 */
+	segments[nsegs++].flags |= IOCB_DIRECT | dontcache_flags;
 
-	if (suffix)
-		nfsd_write_dio_seg_init(&segments[nsegs++], bvec, nvecs, total,
+	if (suffix) {
+		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
+		segments[nsegs++].flags |= dontcache_flags;
+	}
 
 	return nsegs;
 
 no_dio:
-	/* No DIO alignment possible - pack into single non-DIO segment. */
+	/*
+	 * Issue the whole WRITE as a single buffered segment, uncached when
+	 * the file system supports FOP_DONTCACHE.
+	 */
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
+	segments[0].flags |= dontcache_flags;
 	return 1;
 }
 
@@ -1413,16 +1428,9 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		if (kiocb->ki_flags & IOCB_DIRECT)
 			trace_nfsd_write_direct(rqstp, fhp, kiocb->ki_pos,
 						segments[i].iter.count);
-		else {
+		else
 			trace_nfsd_write_vector(rqstp, fhp, kiocb->ki_pos,
 						segments[i].iter.count);
-			/*
-			 * Mark the I/O buffer as evict-able to reduce
-			 * memory contention.
-			 */
-			if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
-				kiocb->ki_flags |= IOCB_DONTCACHE;
-		}
 
 		expected = iov_iter_count(&segments[i].iter);
 
-- 
2.52.0


