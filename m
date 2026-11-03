Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A2E606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MBSkZoy0
Received: by kanga.kvack.org (Postfix)
	id ADEB56B05C4; Tue,  3 Nov 2026 16:18:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F236B05C5; Tue,  3 Nov 2026 16:18:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930A76B05C6; Tue,  3 Nov 2026 16:18:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620686B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1606140545
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:06 +0000 (UTC)
X-FDA: 85395070572.22.29ADFA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3377A100007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBSkZoy0;
	spf=pass (imf05.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740685;
	b=eXe1MVeeZ8aqLtzFmF3sFMSWNf4biZvfQhlt5g0EfbyEzG/nBsND/jd4U68H9J4va4RH24
	bs+Q/OqfClrjLv0bfcTN7Bv/bq1AhUVNNnIHk6ebHnV1UryRezwU/O4cV4qInOlJN0Qnjn
	ONWdoBSoJNFg77fnH0PJzmPa0hnZIWk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBSkZoy0;
	spf=pass (imf05.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otN7QOjeo6dcKarm7LHPsOKbLf9K9HRa9TUg3MA/Yfs=;
	b=VuZDlwcrw6wxOXQ3QI/o44NqVIAEBIpCEn2cDdF8Dp01YF2+K/2dE1IrKiTjHrEKww/SBD
	+0HT07XKO9rhQIaju+8zIHPe40YCsbyDCMyWhs2smOUMuF1qJfB5hA57rX0hGnsAAbwYq6
	y4cqbks3byOfhuJrR8OrP6TenwiGB6w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7842743C2A;
	Tue,  3 Nov 2026 21:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2C01F00A23;
	Tue,  3 Nov 2026 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740684;
	bh=otN7QOjeo6dcKarm7LHPsOKbLf9K9HRa9TUg3MA/Yfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBSkZoy0pO7s2+hbeLhyMD3sMfHFSTTrR/RaK642/GIJRJYggdX4QHiN4Y9p+yg/L
	 C9m07sCRG1mgiLznHxqYibxTuQ/wYIc6aiV6EGjfDCiaAe/JQEiaY8g4a2ZXU2RFvn
	 vqX3HP1vIjqotF64KpWLbm8I4BPLPrk+GckPOG39CAQigeUK68LgmI6herlZxHWnPD
	 kXYoWzphYMozrJTkacMC9SsV9lINDQtnuTUexSAv0fsN5gk0ZpL1wP210a1gsTUB56
	 6tCHXKXMV3bI4Ke9B52+5YD6EBqLwVzHt892L0urWHvHoMF0+x0yIriTUMLNGPsHz5
	 QwMEy6l0vVDaQ==
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
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: [PATCH v10 7/7] NFSD: drop a shared boundary page only once both WRITEs have written it
Date: Tue,  3 Nov 2026 16:17:54 -0500
Message-ID: <20261103211754.35352-8-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3377A100007
X-Stat-Signature: gahgre1r7fnjsgew31kfgs368aej4cow
X-Rspam-User: 
X-HE-Tag: 1793740685-270719
X-HE-Meta: U2FsdGVkX1//gdOdAT+KVE8EF4VYQOpC6LSqBvNpH6c0Abw7QfHBo6g3rjiRrI9kZobDBPRoqRkfHQMwdDrpa1qipo4LpJpwNg6GWJlSTCDx95qKFUk7KBNKuSU6uHtzIz3aZwQWmL5k3iAaQA+lwiT375dkKyG/DRa5tlcuaVSls+kaEk+uznl3AaBM+68EzIA0lf4QbA+53d/nSwtRyBwI96QPwrHqJmHOGeu+Zr5Uklo9C1l2f7gPWg7zxeMc7soGCA99EQMEqbyLZ5g6e7N0PkV0noZos+oIWGcTdkAoc4EK5Xsl7GZrxFFZKL/r1zNl5IrDdY06kxRcu63M1ojatL/4HieJprE0yEqwJ5WT403ZdWjC/C0p+BZP99h+ROx9Kzx/BaUXqVFeU8eF/cWwkngKJ1V4a9QX/ZJc3in1ijZz5ovjmPfE7M9Zx/JOSSY/401fmtTk+dRtEJxcgBakpLTsW4PtVtXsruX5tw+tFZ7JNtYn5JrlTTr1ldVinV5t9X42LE5dk35eLVnGMpwdxzZuqY5/lXBhkLC2Zg7ZcDfjCZFskn5Cl6qFKrNy24wPlmeAZR5CuMijWesYu97r5TZlLO/XjvDD6pZ6vQ5z0wGDA89r4aEYLmj86IRGBo+FR1Ll5tlG9hSbIY8dV+kN7kD5sUWd7j2TVFvFx69gFupKxf5AjKOaDtDJJld83H4oOrhdUfrq35OldnJD6fLFh792X8u9QXKGqkM++VLOy89sFLGxt+aHbMqSHZ7t20Te/xfNewkBwVxm/egpus8bLOsuaKAovor+d8MC9+wXv4SIcIsYauZND4mT/dVQp4xQeNaBv0TCztOv91SdL/t6e7YUMgZdVRgcICGkai+hNRUrot8djnBk8Fh8UWdBOM9N9Xy+RjlTrzHJUJy3LdTnfvamOfaCYhanas3f3KSPJnLCylmy4LwQPQB7p/F9jPB8LDx9KNDqy4GMsoR
 oykxUVuw
 BIjy8JTHKBiYM0kAu6tdh0qhijNpbvO0OXmsMnh9aj8wEB+YftvHS4KBaDRLfuNhQV5wdVbVN8/7U/V9W5RhQt1IWASCw6yM6oc71G1SdxhhN2mU32ORZQeUr3w4/ubQDYXsuCV6qv2FpEojISYeqRK6ve+blj43ep9iK+sMLka6TrXTJGy0yJM4RbofM7gVzdG1FbaRGBdtU579QcKsjJDLXqftL5fc5xRBXh05x/bQJqNgBhl0KpwLDBIKrtAWf/MkMWqtNDoi0mRMXIzemeTcKg+RmWtl1sP59KRaPrOOXSpIAsPl3dsnfO3D+YrU7VykESgaBqBonahn8W1SQh+kmniDy32/NXJvRrcT6qV8/kWhDpANQ0mROtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NFSD splits a misaligned direct-mode WRITE into a direct middle and
buffered DONTCACHE ends.  Each end covers its first or last unit, the
smallest folio the mapping allows, only partly, and shares that unit
with the neighbouring WRITE.

Issue the buffered ends with IOCB_DONTCACHE_DEFER.  Before writing an
end, ask filemap_dontcache_edge_completes() whether the neighbouring
WRITE has written its part of each shared unit.  Once the WRITE, its
fsync included, is done, complete those units with
filemap_dontcache_edge_complete().  A short write completes a unit only
if it wrote its own part of it.

With this commit, 32 interleaved writers of 47008-byte records through
NFSD DIRECT read 0.0001 to 0.0002 blocks per WRITE, instead of reading
0.99 blocks per WRITE.  FILE_SYNC WRITEs no longer wake the DONTCACHE
writeback kick, where they woke it 23,000 to 65,000 times a run without
IOCB_DONTCACHE_DEFER.  On a four-server pNFS flexfiles rig, the page
cache grew by 2.9 GiB during the write phase instead of about 11 GiB.

Reported-by: Jonathan Flynn <jonathan.flynn@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on questions from earlier reviews, with the code that answers each:
    
    - Unit size.  nfsd_write_dio_seg_hold() uses
      mapping_min_folio_nrbytes(), as iomap_get_folio() does (5/7).  The
      cut between the buffered ends and the direct middle is on the same
      boundary since commit b16607436d31 ("NFSD: cut a misaligned
      direct-mode WRITE at folio boundaries") in cel/nfsd-testing.
    - Short write.  NFSD completes the first edge only if written is at
      least first_len, and the last edge only if the write covered the
      whole segment.
    - Release after an error.  This is on purpose.  A segment whose write
      failed is not held: nheld increases only after a write that returns
      >= 0.  A held segment wrote its bytes, so its edges hold the data
      of both WRITEs.  After an fsync error the release still runs: the
      folio is clean when its writeback ends, and the helper drops it as
      DONTCACHE writeback would.  The error stays in the mapping and
      NFSD returns it.  The release changes only what stays cached,
      never data.
    - Unset fields.  For a segment that holds nothing,
      nfsd_write_dio_seg_hold() returns early and does not set
      first_len.  complete_first and complete_last are then false, so
      nfsd_write_dio_seg_release() does not read first_len.
    - Array size.  nsegs is at most 3, so nheld is at most 3 (holds[3]).

 .../filesystems/nfs/nfsd-io-modes.rst         |  17 +++
 fs/nfsd/vfs.c                                 | 106 ++++++++++++++++--
 2 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index e6fd91cac9c77..57acc8f0407ee 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -197,6 +197,23 @@ Misaligned WRITE:
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
index 269dc4968f197..5a2bd2f57620a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1428,6 +1428,7 @@ static int wait_for_concurrent_writes(struct file *file)
 struct nfsd_write_dio_seg {
 	struct iov_iter			iter;
 	int				flags;
+	bool				claim;		/* completes shared pages */
 };
 
 static unsigned long
@@ -1447,6 +1448,78 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
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
@@ -1469,7 +1542,9 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
 		dontcache_flags = IOCB_DONTCACHE;
-	buffered_flags = nfsd_direct_misaligned_dontcache ? dontcache_flags : 0;
+	/* NFSD marks their shared pages itself, see nfsd_write_dio_seg_hold() */
+	buffered_flags = nfsd_direct_misaligned_dontcache && dontcache_flags ?
+			 dontcache_flags | IOCB_DONTCACHE_DEFER : 0;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1523,7 +1598,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1556,7 +1632,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 	return nsegs;
 
@@ -1565,6 +1642,7 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
+	segments[0].claim = !!buffered_flags;
 	return 1;
 }
 
@@ -1573,12 +1651,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -1608,23 +1687,26 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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


