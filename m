Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9212606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQHxYfgs
Received: by kanga.kvack.org (Postfix)
	id F20CC6B0329; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2866B0684; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FD46B0AC1; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03BF76B0684
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:46:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 712DD1401DA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:46:01 +0000 (UTC)
X-FDA: 85352351322.14.21ECD28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8330C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQHxYfgs;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723559;
	b=W31vfzYdG/d2UKXcKcQ+T5jIVbj6ejcXvd2Dqyo1A83/HHg7xHUuHcB3YT2s9t7ncHcUqV
	MRMyos43Xp+ZbVb1iLcBnyihIPB2m12fI7ffoFeBciZRKBGp51EkXAMAGoA0ZQOmxB9YRP
	CnuLMTosJgu+ZyfLPrfZQMnenAkbOCk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQHxYfgs;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nzp9VSgPAl9D8NBeOg/qnwmyocNdzgnSUW2JQkZRwcA=;
	b=hK0MgJJiqrgDNcjUbngjYyAM7IM2gGIMzLxQhVocFY5wP+s2c4IGM04iAdx/Lww9XNwEU/
	R57uxutPtaQJe2NUa58oAUD4Y2OiFDaqSALOBAGusoUWsDFIGa0Fp/hdwuv/UGbbgbqAGh
	pNS8PU8XeK0IrQDKMcAZaZ3zQVl9ZZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6251063E78;
	Fri, 23 Oct 2026 02:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7921F031EA;
	Fri, 23 Oct 2026 02:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723559;
	bh=Nzp9VSgPAl9D8NBeOg/qnwmyocNdzgnSUW2JQkZRwcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQHxYfgsUkmD5VUwyTKicGBcpaKhOya9BrdPHTMgbfZRtdHDOSHJ8xk7Hbjr1N3GS
	 YQ0Vw3kDh6BdCHsfHlkE+4S7yY0suliojj0796OyZOefNxciuuSJ/0BlEJvGAD3tQX
	 cWBFuHv/2r/d7k83fyBRKp37m8bS21eSZjeWrQJWXBzMrprnEAq+GVevU61aKb3QYU
	 wdKhLSjcdAljcauzSmRsdXn+XoqNzTkbtLTGbc9OVX97RElFVYOKRGFzl4hGQ9Hdf5
	 OtZxMumAsZx1qAFzLuuHfYkM0+OqY9NAIBxydCBbtMQpmpIlQaWVrGU7LwcMrM4hLm
	 coT2AlaEPCznA==
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
	linux-fsdevel@vger.kernel.org,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: [PATCH v8 7/7] NFSD: drop a shared boundary page only once both WRITEs have written it
Date: Thu, 22 Oct 2026 22:45:48 -0400
Message-ID: <20261023024548.71123-8-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ssra3bnp49d1cdu5zr3yhgtznu4mi8d5
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8330C0003
X-Rspam-User: 
X-HE-Tag: 1792723559-243688
X-HE-Meta: U2FsdGVkX1/dNIAgysJhsup5w3lpbRoK4lO541vwePLN20jTnN+Ecm+AlNgv7BkbD4HBQiwkMYKsZUkDwHeYiGwcBmBm9qwf6e7QDo31gfHdZNVBShd/OfOwOQ69iLj6r9ThqVUZp0kpc/80JDg5GM2fzxdpNSfeQ+ytuOld2vvgN9W/PQ9w49fLM4Tpi6Xlzc+AIR7o1GEluNXKiQJc7ZPwGFB7UklM3AUmwSNujj70rlVWMma1sQOA6yqmANBSIF5/pz7oID4EYKw16FRyw8IRerl6HoFQevI1PF3Mp3YTsT8EJhxkcRETVZppnbP7ewmFiarWdx5LlnfCkAs1JudQNJt7/pCBWw8xInF3wsxFe1Hi72EU6xPogJao4aAOeKhv81QfbtO/QsQ5cIWllCqWlr2PF4NFW6Qu6oWlPQSVoVYNiYtFkjQ1Qj9yHvCkSqVbGN1I2bUslxeiVvnm2QaOWMQaoGgc8+yQqP5AtwHRxHBCwC9CedTDxPNwKPXDepKsOUf+xYN7eaBdCYQ8N7RdlPvmlMy+uedprsOMdcDxQAY/LBTTiI7wqM8pnfwFlTx1xxp9YATfC5vbeYciiK6gDEgxgnoBZ5t5U94SdIML42XsmUKmlx471QRWs1keW8Da6yXyEQk1hjoAT3V35nXyv/22OaPKe/TYQoF+gDRxW9NkRmUdupGiAzAhKM5hC8Bh2SJToBVsP+UOExBpwJMPgqZsIbW3hjxpIZdKkRFSN4DSjRtosI59mnV9RikktuWepWURZBQ78B1B6FQM+Eyo7GzOE6ckRl098nlEXR8xBNkqpNuFxeA1+GEHuuqFOeUZCOpbzv+U5nsarELpxG7clWHtuc6f9hr/x+YWtGHAwK8qJ694hkSZQ+8o0Ux6mNf/eo1NummIhkdgzdXCi8stjED1SLu0YBhQe3QvByGOMG7ixtG3gJqlHHm76MxRB07www4I4WlhDxB3Exe
 UdeZLaJI
 oCMNzCviKgInqSIPI+yGStwUBxJ+qXCU04hy85IQIe4hFWrAc1zPY1Sz5CLAam61g3th6fy+qA4DYqdP+b8NqkuH8kQXnsfZdQF7JzEQoqeY5kGeQlB/XASCHmEGec6knGQcNmGFyPTwWaoi7RBdM6/Eao63cMDre+DDdlKByRBR2DdZDMuqGKyFr07Rd/yA7KKi0Wd/0gaTF7365pdUNEFbEmGash5hfDzunzztG/DtqK7RygTjXfqCIJXELE0tpFLlTCNonIjZMopDLuvL2aNwAxkOHyUw2bVWQGhCDAjK/Me0bGskaBIEAKPcCWg76ToYXl9Ku+lvXwZU/3ShYrip2OsvK+SbJSXE6x1CCt0qfTIVODmb4J3tMCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A buffered DONTCACHE segment of a direct-mode WRITE -- the misaligned
start or end of a split WRITE, or the whole of one too small to split --
covers its first and last page only partly when it does not start or end
on a page boundary.  Such a page is shared with the neighbouring WRITE,
which may arrive before, after or at the same time, from any client.

The page cache keeps a page an uncached write covers only partly for the
write that completes it ("mm, iomap: keep a partly covered page until an
uncached write completes it"), so the second WRITE does not have to read
it back from disk.  Left at that, the page cache marks the page drop-
behind while it is still dirty, which counts it as DONTCACHE dirty and
wakes the DONTCACHE writeback kick for every segment of a stable WRITE,
only to write back what NFSD's single fsync is about to write.

Issue the buffered segments IOCB_DONTCACHE_DEFER and mark the pages here
instead ("mm, iomap: let an uncached writer complete its shared pages
itself").  Immediately before writing a segment, NFSD asks
filemap_dontcache_edge_completes() whether each page it covers only
partly has already been written by the neighbouring WRITE; once the
whole WRITE, its fsync included, is complete, it calls
filemap_dontcache_edge_complete() for those pages, which drops a clean
page at once.  An UNSTABLE WRITE marks them dirty, and the writeback
that cleans them, by the flusher or for the client's COMMIT, drops them.

A page whose neighbouring WRITE never arrives, such as the last page of
the file, or arrives at the same time, so that neither finds the other's
part, stays cached until it is reclaimed.  Nothing changes when the
buffered segments are normal buffered I/O (direct_misaligned_dontcache
is N, or the file system lacks FOP_DONTCACHE); the page cache keeps
partly covered pages only for file systems that use iomap for buffered
writes.

Measured with 32 interleaved writers of 47008-byte records over an
emulated 4Kn NVMe with 4 KiB pages, NFSD DIRECT with
direct_misaligned_dontcache=Y, each run from a freshly made file system:
device reads per WRITE are 0.0001-0.0002 whether each record is one
FILE_SYNC WRITE, two sent one after the other, two sent together, or two
sent UNSTABLE, against 45144 reads for 45664 WRITEs with no shared-page
handling, and the DONTCACHE writeback kick does not run at all for the
FILE_SYNC WRITEs.

On a four-server pNFS flexfiles rig (x86_64, 4 KiB logical blocks), three
clients writing 47008-byte records for 240 s against 640 nfsd threads per
server, keeping the shared page took device reads from 0.014-0.015 per
record to 0.003, page-cache growth over the write phase from about
11 GiB to 2.9 GiB, and write throughput up by 2.4% to 4.9%, with read
throughput unchanged.  Keeping every boundary page cached instead, with
direct_misaligned_dontcache=N, grows the page cache by about 630 GiB over
the same runs.

Reported-by: Jonathan Flynn <jonathan.flynn@hammerspace.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         | 17 ++++
 fs/nfsd/vfs.c                                 | 99 ++++++++++++++++---
 2 files changed, 104 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 0e69b5fdd675..9c663ce97c48 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -167,6 +167,23 @@ Misaligned WRITE:
     above. Set it to N for a workload that reads back or rewrites what
     it just wrote.
 
+    The page holding a start or end segment is shared with the
+    neighbouring WRITE, which may arrive before, after or at the same
+    time, from any client. So that the second WRITE to such a page does
+    not have to read it back from disk, the page cache keeps a page an
+    uncached write covers only partly, unmarked, for the write that
+    completes it. NFSD asks, immediately before writing a start or end
+    segment, whether the neighbouring WRITE has already written its
+    part; if it has, NFSD marks the page DONTCACHE once its own WRITE,
+    including its fsync, is complete, and the page is dropped. A page
+    whose neighbouring WRITE never arrives, or arrives at the same time,
+    stays cached until it is reclaimed. The first and last pages of a
+    WRITE that is not split are handled the same way.
+
+    None of this applies when the start and end segments are normal
+    buffered IO, or for a filesystem that does not use iomap for
+    buffered writes.
+
 Tracing:
     The nfsd_read_direct trace event marks a READ that NFSD issues as
     O_DIRECT. It records the offset and length the client requested.
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ade00dabef18..f151289345c9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1387,6 +1387,7 @@ static int wait_for_concurrent_writes(struct file *file)
 struct nfsd_write_dio_seg {
 	struct iov_iter			iter;
 	int				flags;
+	bool				claim;		/* completes shared pages */
 };
 
 static unsigned long
@@ -1406,6 +1407,65 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
 		iov_iter_advance(&segment->iter, start);
 	iov_iter_truncate(&segment->iter, len);
 	segment->flags = iocb->ki_flags;
+	segment->claim = false;
+}
+
+/* The shared pages a segment completes, and how much of it was written. */
+struct nfsd_write_dio_hold {
+	loff_t	first, last;
+	bool	complete_first, complete_last;
+	size_t	written;
+};
+
+/*
+ * A page that a buffered DONTCACHE segment covers only partly is shared with
+ * the neighbouring WRITE.  The page cache keeps it, unmarked, for the write
+ * that completes it; the segment is issued IOCB_DONTCACHE_DEFER so that this
+ * WRITE, not the page cache, marks it, once the whole WRITE, its fsync
+ * included, is complete.  Ask whether the neighbour has already written its
+ * part immediately before writing @seg: asking earlier gives the neighbour
+ * time to write its part and find this WRITE's part missing.
+ */
+static void
+nfsd_write_dio_seg_hold(struct file *file, const struct nfsd_write_dio_seg *seg,
+			loff_t pos, size_t len, struct nfsd_write_dio_hold *hold)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	hold->first = pos;
+	hold->last = pos + len - 1;
+	hold->complete_first = false;
+	hold->complete_last = false;
+	hold->written = 0;
+	if (seg->claim && len) {
+		bool one_page = (hold->first >> PAGE_SHIFT) ==
+				(hold->last >> PAGE_SHIFT);
+		bool head = hold->first & ~PAGE_MASK;
+		bool tail = (hold->last + 1) & ~PAGE_MASK;
+
+		/* Only a page the segment covers partly is shared. */
+		if (head || (one_page && tail))
+			hold->complete_first =
+				filemap_dontcache_edge_completes(mapping, hold->first);
+		if (!one_page && tail)
+			hold->complete_last =
+				filemap_dontcache_edge_completes(mapping, hold->last);
+	}
+}
+
+/* Drop the shared pages this WRITE was the second of two to write. */
+static void
+nfsd_write_dio_seg_release(struct file *file,
+			   const struct nfsd_write_dio_hold *hold)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (hold->complete_first && hold->written)
+		filemap_dontcache_edge_complete(mapping, hold->first);
+	/* A short write did not reach the last page. */
+	if (hold->complete_last &&
+	    hold->written == hold->last - hold->first + 1)
+		filemap_dontcache_edge_complete(mapping, hold->last);
 }
 
 static unsigned int
@@ -1428,7 +1488,9 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
 		dontcache_flags = IOCB_DONTCACHE;
-	buffered_flags = nfsd_direct_misaligned_dontcache ? dontcache_flags : 0;
+	/* NFSD marks their shared pages itself, see nfsd_write_dio_seg_hold() */
+	buffered_flags = nfsd_direct_misaligned_dontcache && dontcache_flags ?
+			 dontcache_flags | IOCB_DONTCACHE_DEFER : 0;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1485,7 +1547,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1518,7 +1581,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 	return nsegs;
 
@@ -1527,6 +1591,7 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
+	segments[0].claim = !!buffered_flags;
 	return 1;
 }
 
@@ -1535,12 +1600,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  struct nfsd_file *nf, unsigned int nvecs,
 		  unsigned long *cnt, struct kiocb *kiocb)
 {
+	struct nfsd_write_dio_hold holds[3];
 	struct nfsd_write_dio_seg segments[3];
 	struct file *file = nf->nf_file;
 	loff_t start = kiocb->ki_pos;
-	unsigned int nsegs, i;
+	unsigned int nsegs, nheld = 0, i;
+	ssize_t host_err = 0;
 	int sync_flags;
-	ssize_t host_err;
 	size_t expected;
 
 	nsegs = nfsd_write_dio_iters_init(rqstp, fhp, nf, rqstp->rq_bvec,
@@ -1569,23 +1635,32 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 					kiocb->ki_flags);
 
 		expected = iov_iter_count(&segments[i].iter);
-
+		nfsd_write_dio_seg_hold(file, &segments[i], kiocb->ki_pos,
+					expected, &holds[nheld]);
 		host_err = vfs_iocb_iter_write(file, kiocb, &segments[i].iter);
 		if (host_err < 0)
-			return host_err;
+			break;
+		holds[nheld++].written = host_err;
 		*cnt += host_err;
 		if (host_err < (ssize_t)expected)
 			break;	/* partial write */
 	}
 
-	if (sync_flags && *cnt) {
+	if (host_err >= 0 && sync_flags && *cnt)
 		host_err = vfs_fsync_range(file, start, start + *cnt - 1,
 					   !(sync_flags & IOCB_SYNC));
-		if (host_err < 0)
-			return host_err;
-	}
 
-	return 0;
+	/*
+	 * Mark the pages this WRITE shares with its neighbours for dropping
+	 * only once the WRITE is complete, including its fsync if it has one.
+	 * A page marked while still dirty is counted as DONTCACHE dirty and
+	 * wakes the DONTCACHE writeback kick; a page marked once clean is
+	 * simply dropped.
+	 */
+	for (i = 0; i < nheld; i++)
+		nfsd_write_dio_seg_release(file, &holds[i]);
+
+	return host_err < 0 ? host_err : 0;
 }
 
 /**
-- 
2.52.0


