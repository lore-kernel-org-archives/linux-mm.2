Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E09606A8BD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VPtcIKMQ
Received: by kanga.kvack.org (Postfix)
	id 2A5DF6B05CB; Thu, 12 Nov 2026 14:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D386B05CD; Thu, 12 Nov 2026 14:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9A66B05CE; Thu, 12 Nov 2026 14:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D937B6B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 563F180ACB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:27 +0000 (UTC)
X-FDA: 85427405574.07.471534E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 962A314000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPtcIKMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Xh7OUWxH7/Z2MjS4LsAa9wrkIt4sMqjtGquIPmbAwY=;
	b=ibjVmg3mHtzRIY7onEDhhqz0qwvQmkowGrqCJdPestNbk6dyt4pTQkIcbuiYQfF/VfpwYV
	150RJBjgrDCneuMHOIGmHs/p1HHxupH/lEQ+yrnc8d2+s6ox/0f4k93gbmf42paay5C47d
	b/JaZeCYxA2oNo6D7K7+tu8HnyssiDY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510565;
	b=bcrb2wF3Vf5UMi9oH9vPe2Il9R+BVlKXTL0qV/b3PGRCIYUkiYjy525Ax3V7oChkQs8C/1
	HDnbJ4VF0CHTHgPN4HY/WQjDihlxlYugUMTXfDk8n5dY64GRFkIY/P65ibAjmjdN0++t9g
	FYQsYInCMmwVJKiVZbvPEJFsaecdk3w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPtcIKMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F182A46377;
	Thu, 12 Nov 2026 19:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60E51F00934;
	Thu, 12 Nov 2026 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510564;
	bh=5Xh7OUWxH7/Z2MjS4LsAa9wrkIt4sMqjtGquIPmbAwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPtcIKMQJCty8E1gJW+4pBjqbJ4pE+xqWEZYfqs5lEAvsmCRwKcLOzrTIDpBxH8dF
	 Q0I6fYazf6E3ycfjpWX20yR4/W4uFZsnF81MFjmCqh5xP6UtGkCiapGRPnAetR7FcM
	 aViX7wjl5AHFfgoPelLYuMeaGB8UqoaLEiZRspNLjQPLANfw3tCTKQKLIhQjJvwNGh
	 CxcTS1ut0cm9ynKACGiSO10MW1G2Wm8kZQtvbVEK/Er/LSX0D3XuoY5+zYJG0SLxuI
	 gr1hFh4MiwNGDaaVtR/upg1eY7LPkfZ98dROCzOQLHU6W19Ryl/mTb/9pu9O3jCcWg
	 iqSH9uv0FKIwQ==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: [PATCH v12 7/7] NFSD: drop a shared boundary page only once both WRITEs have written it
Date: Thu, 12 Nov 2026 14:09:10 -0500
Message-ID: <20261112190911.84702-8-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: agfw3wtbibq1oar8bfthdqof9qjdy184
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 962A314000F
X-HE-Tag: 1794510565-702433
X-HE-Meta: U2FsdGVkX181cW26ZQMI/d2Vlwg0fNIOKzJaxr6CMZgGVC/1p2zuCOUZZRIZ0ieJmwVb6HwsHhK+KHHPp+IR55A691XAEdjyIzZ8peOGuBvskKeYNNoluenCXbyU6hX1MPnxN2xEkl9qtGaudaNiCJNQUj60NFHTARTfGyu/3f754h0lkUKTWTCXNwihttk7QLe5Nh87isoAiLgfdELm2ALUvD9GfGOyyxXVtln6q0nDFdOO6NeQ7CkM3M8gDwEM46pOOuuT7zB7irG6quvoXSt+8Pqz4oKGm8kq+jANKMeKrPtgCEUpCAxpSCmwRvdJt/bAFPti2Uaj21dCHlfHoTKCGCm+lvMR045CNvHaw+XHXF7X+sNcnHuLpEqgyFYmjRJPHaI+eukVeXBE+A6RN8IlQZkQQGEou7nCaDIbjaeP02nzRsZUZWLcV2fUQ/4S+42QZ92Oq7LBc6SEl913UNhJ5sRg6tewtNgajQ1mXd/lwR3f426feU/FSVtyqYw3UZwoFEHnUs/sp4x6MR1yl2RoOQ1e6uF6HTW8uNVHMXkcSF+jpc37kX9OItrT9QMhN6LqcQTazGNIafArMSim3M8m2uN7fQRhpzFBs0TisspyTxSDa0jPF/BC9vUFN0UH8tduZfoYWiP9jidJhSz3Rm19rLyLbfac9OyzROmPJcixMEEq9AtWj7BlT2hnGYOekCOHefBPmg4P1HFef5r51uXP7Ve3OLo9i3z6SBZdpWfMEBdjcv37YaHZsYlEGNA7gOUm3ceH+o5fnVkR7pfzOeCYElpjKJLjP4FXuQ/WUNJhHsXnNpOUqS1eW6Tfg7VWUWx3biO6bX5qQ5fLRA9mopDI5QHGQlMulHHOhOMajDbUZCN/WApTnL86S04dfRkum3vqKFBahuCrohQcePzVOsjwIlQI10qWMKoEvoWNzpMATT66yNZp2R94/iO9cx7CgrzwCYT3zTQQhAmgPr0
 G0SpvQAH
 l2Ye3GpUtQOaF/3eXZhYdlS6PY+zColojzPfvk/jAU1eQq7u9tMLjKfh/fK/0K+4nBLKFdloIF/zukdJmjbGubBuvccyzbar1Z+Pyk3AET1H4eVqF1uoJGt6A7Pf73igfa8nqWJcN/CvExvxVeAqx/f5bcHy2Jt1OnsH4vyzetr/4PZYbK5ebYKf63fWTAq6LW8yCg9+ISTXBpwu809J95iw0dNHUE794cxTmm+7CZmqd69OPRgeBmfZRKqtY7q4ilX5QPxd/6tmjYym98qlKM5MBxP6alp74USks
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
index 28235eceb0c7d..9fd3b929a240c 100644
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
index b0d754142eab5..2ebee92f28da6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1437,6 +1437,7 @@ static int wait_for_concurrent_writes(struct file *file)
 struct nfsd_write_dio_seg {
 	struct iov_iter			iter;
 	int				flags;
+	bool				claim;		/* completes shared pages */
 };
 
 static unsigned long
@@ -1456,6 +1457,79 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
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
@@ -1478,7 +1552,9 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
 		dontcache_flags = IOCB_DONTCACHE;
-	buffered_flags = nfsd_direct_misaligned_dontcache ? dontcache_flags : 0;
+	/* NFSD marks their shared pages itself, see nfsd_write_dio_seg_hold() */
+	buffered_flags = nfsd_direct_misaligned_dontcache && dontcache_flags ?
+			 dontcache_flags | IOCB_DONTCACHE_DEFER : 0;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1532,7 +1608,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1565,7 +1642,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 	return nsegs;
 
@@ -1574,6 +1652,7 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
+	segments[0].claim = !!buffered_flags;
 	return 1;
 }
 
@@ -1582,12 +1661,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -1617,23 +1697,26 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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


