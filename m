Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB77CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D3A6B009D; Thu, 15 Oct 2026 19:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4145F6B009E; Thu, 15 Oct 2026 19:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303DA6B009F; Thu, 15 Oct 2026 19:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E788C6B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A693A023C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:18 +0000 (UTC)
X-FDA: 85326464076.25.CED57D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5FF68000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVUrcXJr;
	spf=pass (imf30.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107196;
	b=RXZXokpYJnXxICCRmC+QFPgMvxk2Dh5htYtCva58yVHCHropst1ETviCpWkHyd58eHuSEP
	aN6jG63O/AF6xfo0QvzwKPPxxXzIr3cJi85DipiV0LePjlAh6tNlqo37Wq4t1jUj+PGEYz
	D8teQLTXBSZdG2+2XojPJuoMqxyzhNY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVUrcXJr;
	spf=pass (imf30.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIXvUItkvC3iFQGlhX5ecnIhSGL49TpsiZWITMKCrrk=;
	b=CaVahGREQCz92pyclkH/py3H4aia9BLrK0fluYRFIGO682jepqfixEEO1hCb6zvJksdFmR
	a+2sI6gytA7aBmn0I6Q38ZkyEQ1cgaDjydFjk4OiqmQR2Jq8PfVYI+6KqQIiyNzqt+R2pm
	awH45eec3Z4hpGPLWc61BgIW7SU6kX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27B5960A74;
	Thu, 15 Oct 2026 23:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A8D1F000C4;
	Thu, 15 Oct 2026 23:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107195;
	bh=rIXvUItkvC3iFQGlhX5ecnIhSGL49TpsiZWITMKCrrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVUrcXJrD4hV/kTKKy/jyKReYXDl7pCqoRRW4W+yt9Ko3vWe92YgVwtrGoIzMFHxU
	 jLE52P0MlSqeYYFbIpDN71tlRC28KecQFCoA1r4p4C65rJlUKVE6/b9VR/BpRbrreu
	 TZOzQUOpBgKJgQwaoPfEhpLlP29wxwwLpX3xaqQdOFgg4Z+1vVi6MLenwFGCYN3YuW
	 TsrZaQk2J3ZXSi4vGLYCIlT8SkNaa8cji0prMScbFh8+YEHUCw6HzN0TP6B3oWrgrV
	 kD94UilK2EUrO+xvUjcdD85bUGWXqEr3qC4wIgD6vI25PeXWPNPOBTVvD/2fNcGHoB
	 /0iPuHT/qh7sg==
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
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: [PATCH v4 04/10] NFSD: add direct_misaligned_dontcache debugfs knob
Date: Thu, 15 Oct 2026 19:33:03 -0400
Message-ID: <20261015233309.42999-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p589cknc9k7cqi5cy3tkpyy4dy73a4q4
X-Rspamd-Queue-Id: B5FF68000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792107196-217385
X-HE-Meta: U2FsdGVkX1/6zwRzApVAm01txHhTFSfwrZTsu/APcTZoAHPl3eX9SX4BJ7YnXjMUo4AUCFnhkWgFCwpQG0KcGzo+RmsaBmf4PxSD8f66nX1V7i1A0uvitvy2pQK2ik04kaZR6COueFXTroTsgPvBqhE2flcnaeozEXOuzccXnXwhHvndokmG4YHPGV2z5E+StDcnu8v8xm4hi7NEFVAUvM/dpS0tFJInjmOUGtA9ELgzDKwRrbvHCM5sMIyb73kYzgGnF/dIOyVG93t3tN9l5+agbRJDC1v54KQaFhFdae0+GCO7EvnrG6OXd11DCmxLXwYRkLfhes+HyGDQ4R/ydS1NVTj1SPyAVYDk4raMSdztUrgAHCwdXLh8GdKcfh9lQqF15brXyjINCtumRMDCxMFA9Rm9nAMbbNoA4y9A0A7d6owCQ614pnPrfDjO6HXvSh7mdII6f9DM+FquqWobbslpdmj1Xdv9JO43Q5STnxkknbRsUSc79Ok1pZDjNxN86mvxVNTRnzcrx7+4LcFcl2+LvATTruXH01fi05fVCs4vr4TO4GxH0Fh1rYef+qYGl1mN2rTZA/80EyhuHTe12uqPP6mMGI7Dl1+aY00zcIflMQg7JbygIFDff/DIiELB05VevKRGggadDhTFgHPVXwu6BxLbil17KDWY9gIOKcUgWj+vK3+/ySSOM965HpbnHwXVe7/0Pqslt8+t7aGWYTq5etcYs+nSi1AD58P5+JwUwGYd49vjQ+jbgbkDgri2IHn045ZMz67TEIwR7FMHJ66uxXk3jLHGOXCcB6QMrgqJfvCT7eaDDvuKgu8uq4WCFBgGRzfAbf0PvTnpwbgJ2FIjqINv0SQYf6j/8mLQ/mT8Wc97ZIpnGmMXHM9FPZfKAzebUJWcxcjzLfrVFiWvB0VhIjVRQzBwOs3aQu5qN+ehc+jIAGsqxAC2OIRJc2ys3q5tXvXl1W1v6FeC/SU
 iajXXr7K
 CqConaVDXi2MErG8qS9oYhcnhxVwyZiEvd+jt3whiKJTkmiG58Q7Nb9lcstJ8BYrfGYrcDEMBv9edKuquIKlLs3TXbMH+76PVNVOhab1+l+vgTi2nzTGRP2CzFoZNWg2bzvK6HCc3tef/ayrdgKxSR1G5gr1tZFNcE8X9gPe/JiK4FJbci3kvs3hlOIKwXQQd1qgr2YQ0JBaqDPM/NPngKMHdvGLp/Mz/0DnpXkYgSLK3CaLXNaR/sYIbNMlZBIczPai/AcShvwtwf397xvBrHGiYsoXMUzIJixZ8gC1/KYec/hj7FD41ta8o/kUNS6WBGXxPVPC8ZPfjjUMJGSGkJkKRqkQwkv1q2NOkwEr/GVRngCOcdv+i08cCuCrBlNjmdp4xYppPn1LlKFXdOCNjBbMYshk0V7OhkHUL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jonathan Flynn <jonathan.flynn@hammerspace.com>

The parts of a direct-mode WRITE that are not O_DIRECT (the misaligned
start and end of a split WRITE, or the whole of a WRITE that is not
split) are issued IOCB_DONTCACHE when the file system sets
FOP_DONTCACHE.  That suits the workloads a direct mode is chosen for,
but it is a policy, not a requirement: a workload that reads back or
rewrites what it just wrote is better served by those pages staying
cached.

Add /sys/kernel/debug/nfsd/direct_misaligned_dontcache (default Y).  Set
to N, those parts are issued as normal buffered I/O.  The O_DIRECT
middle keeps IOCB_DONTCACHE either way.  With N, a WRITE that is not
split, including one whose payload is misaligned in memory, is cached in
full.  The knob sits beside direct_misaligned_min_bytes, which decides
whether a misaligned WRITE is split at all; this knob decides how the
parts that are not O_DIRECT are cached.

Signed-off-by: Jonathan Flynn <jonathan.flynn@hammerspace.com>
[snitzer: switched from a module parameter to a debugfs knob, moved
next to direct_misaligned_min_bytes, documented in nfsd-io-modes.rst]
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         | 19 +++++++++++++------
 fs/nfsd/debugfs.c                             | 13 +++++++++++++
 fs/nfsd/nfsd.h                                |  1 +
 fs/nfsd/vfs.c                                 | 12 ++++++++----
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index eab35a9bbdb93..2679d85152dfc 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -131,15 +131,17 @@ Misaligned WRITE:
     offset, so the O_DIRECT segment never shares a page with a buffered
     one; a start or end that is already DIO-aligned gets no buffered
     segment at all. If the filesystem supports FOP_DONTCACHE, the
-    misaligned segments are marked DONTCACHE.
-    So is the O_DIRECT segment, where the flag has no effect unless the
-    filesystem services it with buffered IO instead, as XFS does when it
-    cannot invalidate page cache that overlaps the segment. The
-    iomap_dio_invalidate_fail trace event reports such a fallback.
+    O_DIRECT segment is marked DONTCACHE, and so are the misaligned
+    segments unless direct_misaligned_dontcache is N (below). The flag
+    has no effect on the O_DIRECT segment unless the filesystem services
+    it with buffered IO instead, as XFS does when it cannot invalidate
+    page cache that overlaps the segment. The iomap_dio_invalidate_fail
+    trace event reports such a fallback.
 
     If NFSD does not split a misaligned WRITE, it issues the whole WRITE
     as a single DONTCACHE buffered IO (normal buffered IO if the
-    filesystem lacks FOP_DONTCACHE). NFSD does not split a WRITE when:
+    filesystem lacks FOP_DONTCACHE or direct_misaligned_dontcache is N).
+    NFSD does not split a WRITE when:
 
     - the filesystem advertises no DIO alignment;
     - the WRITE is smaller than the larger of the offset and memory
@@ -150,6 +152,11 @@ Misaligned WRITE:
     - the WRITE payload is not aligned in memory to the block device's
       dma_alignment, so the middle cannot be O_DIRECT either.
 
+    Writing N to /sys/kernel/debug/nfsd/direct_misaligned_dontcache
+    (default Y) issues the start and end segments, and a WRITE that is
+    not split, as normal buffered IO instead of DONTCACHE, which suits a
+    workload that reads back or rewrites what it just wrote.
+
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
     misaligned READ to the next DIO-aligned block (on either end of the
diff --git a/fs/nfsd/debugfs.c b/fs/nfsd/debugfs.c
index 02b0369f17648..80f53a4ada7bf 100644
--- a/fs/nfsd/debugfs.c
+++ b/fs/nfsd/debugfs.c
@@ -152,6 +152,19 @@ void nfsd_debugfs_init(void)
 	 */
 	debugfs_create_u32("direct_misaligned_min_bytes", 0644, nfsd_top_dir,
 			   &nfsd_direct_misaligned_min_bytes);
+
+	/*
+	 * /sys/kernel/debug/nfsd/direct_misaligned_dontcache
+	 *
+	 *   Y: the start and end segments of a split direct-mode WRITE, and
+	 *      a WRITE that is not split, use DONTCACHE buffered IO when the
+	 *      file system supports FOP_DONTCACHE
+	 *   N: those segments use normal buffered IO
+	 *
+	 * The default value of this setting is Y.
+	 */
+	debugfs_create_bool("direct_misaligned_dontcache", 0644, nfsd_top_dir,
+			    &nfsd_direct_misaligned_dontcache);
 #ifdef CONFIG_NFSD_V4
 	debugfs_create_bool("delegated_timestamps", 0644, nfsd_top_dir,
 			    &nfsd_delegts_enabled);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index db81620bd5168..b520b51692b09 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -143,6 +143,7 @@ enum {
 extern u64 nfsd_io_cache_read __read_mostly;
 extern u64 nfsd_io_cache_write __read_mostly;
 extern u32 nfsd_direct_misaligned_min_bytes __read_mostly;
+extern bool nfsd_direct_misaligned_dontcache __read_mostly;
 
 bool nfsd_v4client(struct svc_rqst *rqstp);
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a419eee401d9d..b596bd61f8cb7 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -55,6 +55,7 @@ bool nfsd_disable_splice_read __read_mostly;
 u64 nfsd_io_cache_read __read_mostly = NFSD_IO_BUFFERED;
 u64 nfsd_io_cache_write __read_mostly = NFSD_IO_BUFFERED;
 u32 nfsd_direct_misaligned_min_bytes __read_mostly = 8192;
+bool nfsd_direct_misaligned_dontcache __read_mostly = true;
 
 /**
  * nfserrno - Map Linux errnos to NFS errnos
@@ -1325,11 +1326,13 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	size_t prefix, middle, suffix;
 	loff_t offset = iocb->ki_pos;
 	unsigned int dontcache_flags = 0;
+	unsigned int buffered_flags;
 	unsigned int nsegs = 0;
 	u32 cut;
 
 	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
 		dontcache_flags = IOCB_DONTCACHE;
+	buffered_flags = nfsd_direct_misaligned_dontcache ? dontcache_flags : 0;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1368,7 +1371,7 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= dontcache_flags;
+		segments[nsegs++].flags |= buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1392,7 +1395,7 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= dontcache_flags;
+		segments[nsegs++].flags |= buffered_flags;
 	}
 
 	return nsegs;
@@ -1400,11 +1403,12 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 no_dio:
 	/*
 	 * Issue the whole WRITE as a single buffered segment, uncached when
-	 * the file system supports FOP_DONTCACHE.
+	 * the file system supports FOP_DONTCACHE and
+	 * direct_misaligned_dontcache is set.
 	 */
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
-	segments[0].flags |= dontcache_flags;
+	segments[0].flags |= buffered_flags;
 	return 1;
 }
 
-- 
2.52.0


