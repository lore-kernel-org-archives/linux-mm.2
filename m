Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529E0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Acg7IhlG
Received: by kanga.kvack.org (Postfix)
	id 5E5A06B05C0; Tue, 10 Nov 2026 20:56:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598226B05C1; Tue, 10 Nov 2026 20:56:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45FB36B05C2; Tue, 10 Nov 2026 20:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 103B66B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77346C01D0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:20 +0000 (UTC)
X-FDA: 85421173320.05.71A5539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9B6CC0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:56:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Acg7IhlG;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvsdJA1xQSyMPMbuSIp+CFlJpnM6Fc37qh/WwEbiFd4=;
	b=CeT+Ur1bBZ8hq5ahytbztwiiy0As50QN09+H5ETJHky4bTFc0a9wUM/U9aYZ1Ld8v/Ckfn
	QeUHIbfDfXfMag/P/MXgmQlFpKW4o71m+7Lrb2TgC43H0jn/AFyB+NH90WzIPCdVFMyzhx
	VPMDDhG2iEoDTjxN5zK4bnz9cfyagjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362179;
	b=ldfo7We9bAoIFp//fB7j4kEHMgeknm/CRceHLWUVTcreRKQ8WbD6HC55hhwC74RHI3fP5q
	T4XPDmRLvdqJqoVY/ZdkCrd4nihGNeLvF5s10Vh3VX5I4BouaaemgaHCbU67Ru///unZAT
	zqc8wke1KTY4e9AuQLpfHhPFKO/kwC0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Acg7IhlG;
	spf=pass (imf28.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A7F94735A;
	Wed, 11 Nov 2026 01:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A7A1F00A11;
	Wed, 11 Nov 2026 01:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362178;
	bh=dvsdJA1xQSyMPMbuSIp+CFlJpnM6Fc37qh/WwEbiFd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Acg7IhlGIGwr0r+3nJ6IcWCdWUIkQZLmqg6JA2AN7PQL7lWQ2W9lb2Mdx6WfG0n3Q
	 GQGV9qt9trNQwSS3O/3P+c0Ilr/DFP82vZvQSnnoMnKGJ+kOIT0dtDwq5ahah1bhyi
	 2ljgkFg2xki+m1iWt50SAW2VcV5+Arh6cbhIBONXK7bPM9k74+pmCX0vPjCxRA2tzh
	 PAf+kWo2rLGcs5UR+JYfIJbdwmZdjRyR5W38WmeCgD/i+EdKMddM/AcgQG1NKpX86g
	 cB0CcsS4T0zep5OyMd+zdC0+rj2cT6bOx5Z55DT+CrVVS0TDNlKZ1TiCsV4sJOj8p/
	 OoXhfkfH7hnkw==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: [PATCH v11 7/7] NFSD: drop a shared boundary page only once both WRITEs have written it
Date: Tue, 10 Nov 2026 20:56:07 -0500
Message-ID: <20261111015607.46338-8-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261111015607.46338-1-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C9B6CC0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fw7hs1d3673iape6ey6g6mbk7ycn8szm
X-Rspam-User: 
X-HE-Tag: 1794362178-524932
X-HE-Meta: U2FsdGVkX1/ITaNKXfvmpw9ZqvDAZu4l9N7XLHiqP5ComDCxCt03XdF9GJg0iO9uWZKz4l/RtgI9UYULqGvFJFJUqQRv7hDGRcoGtvUgz18kOkiPymQvgBmfHG3mWKNMNpHzTUoT9zdDgY6EXFVzwXrgQQqq2LGVc3A2dbMV+0HvFMKQZk5M6SnQUYaXjBhSAcva7bvRjGc1W3V07RbIlrurXZfOoEDICdFGtuaSztflkbm32MTWszR5QlchYrhrWDlptLHI5vfA95TvNJ5ny5hx1h+Ir9wnXRagh4tIsnOPRpu45Lt6YjGl2n9aEFa/0o08UXxdYVxWQdpxQFF0LKF2SaOT92V13Fk/I/SLCXncgG8VQUSUN+nSfX9F1FlSK9SECBHzN84cIzG04uvl2HhKOtwDTtlSGeYfqXvusfdZQh4vvAEOrrhT+RZO6nOC/f0muzmtYcIhkNkxiaYsH5boCCIT/9zXYCfLppZPZTRKP4zJvXLIQAfqfLKgfouSgj912H7ei+ne8PVvXwyIOh0ElzfW1/IJLp4nffpT02s8QukpUn3KtJ1IsKtks9+L8FSKLR8o+QpZNXco6G9A+F8Vjzs48WP/FO+Q/R6Cx+p/bl7Z2pDdSXP6nGYB4QcJ/S6NQXVmceKXNTUTKNtJnKsUuE7iDhetXv470+MH4Oj6HnzUzaFuwo/hf2FBt4vxUxG633Wf3rTC4rNSBiJuj7d6TY9RzxvrISGwyUfCQtLr1WfBOD93BooWVQgtCYE7tPFrBckdi9t1rolpNcvj9ViD+WgkQNXSe3FZSfqi0lFvlPYfKEC1mrRbsbQBf/NijNgpzCD7a92wh2pCy5HBOm6M3aOOYQmyxQ4MpEiwLkgVcFOHJuYTtcA+I4K1H64lTEzppT+KdAsihNGTzfen+4g6nj0q4ExWtTsGPiureRhRPHpwkLzQEGh7jjzxc3jDlzQcinRWgXbDGTs6Swz
 tI2+JSVb
 oMgjLkRW6Land4yaxqX9OSD3VpKK8RvLHxhU0/KI0jYO1xTM+nhwwdFxDpkc1KYAqeU5F02OtYPScOJS0l36BY0LrBt0NZzRnR1Yphgyfms4RX9m1Iw3Y7vqkqJndTRxfpl3LkiwCHglJQ6Me7y6GM3Ypt//i4OtQVH+f8nPH8D28lwEsTyFB+3049ug/WVEnV6tifMQSLZgRysiHcZSQeX+Rm2pcYMNwaHuCJ8IR3t4vPvWu1OqWyolCkwB5KvxIhFnIYO8YCyX2claKEU/oGLA1O/UiU2bHf3Zq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NFSD splits a misaligned direct-mode WRITE into a direct middle and
buffered DONTCACHE ends.  Each end covers its first or last unit, the
smallest folio the mapping allows, only partially.  The other WRITE that
covers the rest of that unit shares it.

Issue the buffered ends with IOCB_DONTCACHE_DEFER.  Before writing an
end, ask filemap_dontcache_edge_completes() whether the other WRITE has
written its part of each shared unit.  Once the WRITE is done, complete
those units with filemap_dontcache_edge_complete().  If the client sent
the WRITE as FILE_SYNC or DATA_SYNC, that is after the one
vfs_fsync_range() that NFSD runs over the whole WRITE.  An UNSTABLE
WRITE has no fsync, so its units are completed while still dirty.  A
short write completes a unit only if it wrote its own part of it.

With this commit, 32 interleaved writers of 47008-byte records through
NFSD DIRECT read 0.0001 to 0.0002 blocks per WRITE.  Before, they read
0.99 blocks per WRITE.  FILE_SYNC WRITEs no longer wake the DONTCACHE
writeback kick, where they woke it 23,000 to 65,000 times a run without
IOCB_DONTCACHE_DEFER.  On a four-server pNFS flexfiles rig, the page
cache grew by 2.9 GiB during the write phase instead of about 11 GiB.

47008 bytes is the transfer size of IO500's ior-hard, in which each rank
writes interleaved records to one shared file with O_DIRECT.  The Linux
client sends an O_DIRECT write that fits in one WRITE as FILE_SYNC.

Reported-by: Jonathan Flynn <jonathan.flynn@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         |  18 +++
 fs/nfsd/vfs.c                                 | 107 ++++++++++++++++--
 2 files changed, 113 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index d57b7916f6c2e..6f5941e9ea7b6 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -197,6 +197,24 @@ Misaligned WRITE:
     above. Set it to N for a workload that reads back or rewrites what
     it just wrote.
 
+    The page holding a start or end segment is shared with the other
+    WRITE that covers the rest of the page, which may arrive before,
+    after or at the same time, from any client. So that the second WRITE
+    to such a page does not have to read it back from disk, the page
+    cache keeps a page a DONTCACHE write covers only partially,
+    unmarked, for the write that completes it. NFSD asks, immediately
+    before writing a start or end segment, whether the other WRITE has
+    already written its part; if it has, NFSD marks the page DONTCACHE
+    once its own WRITE, including its fsync, is complete, and the page
+    is dropped. A page that no other WRITE completes, or that the other
+    WRITE writes at the same time, stays cached until it is reclaimed.
+    The first and last pages of a WRITE that is not split are handled
+    the same way.
+
+    None of this applies when the start and end segments are normal
+    buffered IO, or for a filesystem that does not use iomap for
+    buffered writes.
+
 Tracing:
     The nfsd_read_direct trace event marks a READ that NFSD issues as
     O_DIRECT. It records the offset and length the client requested.
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 10ea334cfdab6..5d265b2294b00 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1432,6 +1432,7 @@ static int wait_for_concurrent_writes(struct file *file)
 struct nfsd_write_dio_seg {
 	struct iov_iter			iter;
 	int				flags;
+	bool				claim;		/* completes shared pages */
 };
 
 static unsigned long
@@ -1451,6 +1452,79 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
 		iov_iter_advance(&segment->iter, start);
 	iov_iter_truncate(&segment->iter, len);
 	segment->flags = iocb->ki_flags;
+	segment->claim = false;
+}
+
+/* The shared pages a segment completes, and how much of it was written. */
+struct nfsd_write_dio_hold {
+	loff_t	first, last;
+	size_t	first_len;	/* the segment's bytes in its first unit */
+	bool	complete_first, complete_last;
+	size_t	written;
+};
+
+/*
+ * A page that a buffered DONTCACHE segment covers only partially is shared
+ * with the other WRITE that covers the rest of the page.  The page cache keeps
+ * it, unmarked, for the write that completes it; the segment is issued
+ * IOCB_DONTCACHE_DEFER so that this WRITE, not the page cache, marks it, once
+ * the whole WRITE, its fsync included, is complete.  Ask whether the other
+ * WRITE has already written its part immediately before writing @seg: asking
+ * earlier gives the other WRITE time to write its part and find this WRITE's
+ * part missing.
+ */
+static void
+nfsd_write_dio_seg_hold(struct file *file, const struct nfsd_write_dio_seg *seg,
+			loff_t pos, size_t len, struct nfsd_write_dio_hold *hold)
+{
+	struct address_space *mapping = file->f_mapping;
+	size_t unit, last_len;
+	loff_t mask, last_unit;
+	bool one_unit, head, tail;
+
+	hold->first = pos;
+	hold->last = pos + len - 1;
+	hold->complete_first = false;
+	hold->complete_last = false;
+	hold->written = 0;
+	if (!seg->claim || !len)
+		return;
+
+	/* The shared unit is the smallest folio the mapping allows. */
+	unit = mapping_min_folio_nrbytes(mapping);
+	mask = ~(loff_t)(unit - 1);
+	one_unit = (hold->first & mask) == (hold->last & mask);
+	head = hold->first & (unit - 1);
+	tail = (hold->last + 1) & (unit - 1);
+	last_unit = hold->last & mask;
+	last_len = (hold->last & (unit - 1)) + 1;
+
+	hold->first_len = min_t(size_t, len,
+				unit - (hold->first & (unit - 1)));
+	if (head || (one_unit && tail))
+		hold->complete_first =
+			filemap_dontcache_edge_completes(mapping, hold->first,
+							 hold->first_len);
+	if (!one_unit && tail)
+		hold->complete_last =
+			filemap_dontcache_edge_completes(mapping, last_unit,
+							 last_len);
+}
+
+/* Drop the shared pages this WRITE was the second of two to write. */
+static void
+nfsd_write_dio_seg_release(struct file *file,
+			   const struct nfsd_write_dio_hold *hold)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	/* A short write may have stopped inside the first unit. */
+	if (hold->complete_first && hold->written >= hold->first_len)
+		filemap_dontcache_edge_complete(mapping, hold->first);
+	/* A short write did not reach the last unit. */
+	if (hold->complete_last &&
+	    hold->written == hold->last - hold->first + 1)
+		filemap_dontcache_edge_complete(mapping, hold->last);
 }
 
 static unsigned int
@@ -1473,7 +1547,9 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
 		dontcache_flags = IOCB_DONTCACHE;
-	buffered_flags = nfsd_direct_misaligned_dontcache ? dontcache_flags : 0;
+	/* NFSD marks their shared pages itself, see nfsd_write_dio_seg_hold() */
+	buffered_flags = nfsd_direct_misaligned_dontcache && dontcache_flags ?
+			 dontcache_flags | IOCB_DONTCACHE_DEFER : 0;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1527,7 +1603,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1560,7 +1637,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 	return nsegs;
 
@@ -1569,6 +1647,7 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
+	segments[0].claim = !!buffered_flags;
 	return 1;
 }
 
@@ -1577,12 +1656,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -1612,23 +1692,26 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
+	/* Complete the shared units once the WRITE and its fsync are done. */
+	for (i = 0; i < nheld; i++)
+		nfsd_write_dio_seg_release(file, &holds[i]);
+
+	return host_err < 0 ? host_err : 0;
 }
 
 /**
-- 
2.52.0


