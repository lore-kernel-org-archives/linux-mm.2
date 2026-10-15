Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C072CCA463
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06566B009F; Thu, 15 Oct 2026 19:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6946B00A0; Thu, 15 Oct 2026 19:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F6B6B00A1; Thu, 15 Oct 2026 19:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 766326B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCEF1A0234
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:20 +0000 (UTC)
X-FDA: 85326464160.06.16C16DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CC5E40006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfPATXj0;
	spf=pass (imf07.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBemQGCyU69s/WwVOcpeFu3LvfmHsaYEii5qBAWj8sU=;
	b=fhsG1Ouudnz6Nd+BIx2bm79Cim/jZ/szWBNBrwcdXmTkzx3gRIq44/mOVfHMnQPsxq89Y+
	7E/a+8ChfhHDCuHeTNTa1hj9yJil8AtyIlVqAJhR9LiPiMoTuTy6vB+IVvTmSq5q4vOTDK
	Ne00Yi6l2SMVpKUbimzIBPRi9c4rrPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107199;
	b=TrFFtull8exGJfUFanXCkvBMQqTVOCkncMoTnpY+IKhIt3WjLz/hwIYcWG1sxx9QmQn/R4
	2zBXb8ouPYs5JTyOOtmUGKKCfXR/7vmyPzE+yqMS6v1vVs+J6QXXkpCy39o91ky8P53ioo
	bdfZxVR+e1TMWLNznkkEhthyAefYZRw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfPATXj0;
	spf=pass (imf07.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79385447C1;
	Thu, 15 Oct 2026 23:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD9B1F000C4;
	Thu, 15 Oct 2026 23:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107198;
	bh=GBemQGCyU69s/WwVOcpeFu3LvfmHsaYEii5qBAWj8sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfPATXj0eeL7I/tBnomc8jXLBJvcptUsUIIYEFBrrlRLnm4cvc3GaA2dbhlVLw3qL
	 dEijXgXG8BD4+HA8/PAMwN4hhY7gzJQDkiTqay9tCJV6MWYSn4V0f2LdHrZj4CzHZc
	 f3F6cmfNIPgyVlqoMeUk77YI/V+xuyrbdteztkeKJ2pU1cJ0xoXYTRzyx6MCLb/4lS
	 HQ9eiMzmnITZlfJOLi9FrFQRV8mut60fZzLLONV8Gcel2gBPYG7GMiPchDk30Zjw1u
	 OxZBpnYqSmEhuSydt+VBWsTQcVJUCydlaBbeQnnax0DzOsHxjMK+u7IKCOZfHkCtRi
	 CeiNr35uGOLgQ==
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
	linux-mm@kvack.org
Subject: [PATCH v4 06/10] NFSD: persist a synchronous direct-mode WRITE once, after all of its segments
Date: Thu, 15 Oct 2026 19:33:05 -0400
Message-ID: <20261015233309.42999-7-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2CC5E40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3knne3gjopfdu9hxfm8j67jf9117x4bh
X-HE-Tag: 1792107199-168557
X-HE-Meta: U2FsdGVkX1+lvz9dSxCjBpL8F6TPn8SfD0x2jAlkg/mTNIFnkA+a+o6zzQCNLHS1L3Isx1UZ5fW7SKrgG4yEsIzOnH+XMLrIOhr3mmSOJtTVA1ySO8G59D4x3fBfMUyia4anxXCC0iJN1zZRcaIkzcwIF3IlUHikjWsjX3Pl8CzQDUXdn31PWOBhObxW1Tuqp1N1jsNtzt6+S243a3YM5nkwV2PReuXrNL2dq2MR1Cqb7hgeb9ic6RhurEKX3DFF/udHSOnVPCXzv6zC6wAmGGgHjCuUmQd6BsvI+rrcOVnSPwPzQhacTdGVtr+OuV2fcGl/Gf+sUzc4bF4SQReU74uYDuIsQy81h9nqwnZE+ND80ZbewL17WE2dmWS0zKF8Qt486H1WEPUvYNbFZqbw40O8XPGNZ2Ug9L6NtfoKojq0bwNWFNWxfBlCv9gd/HmFlQENSsHFtBNzmgAIderUM5acqEQSkoBiiSE2SRajmNKZGEYAbuho6hHtY0ts4lccLdZ2aoVURc3cslXHvNOFCiGXkn5+lOupk6fpOwEqF6lDEVQXn15IYFjTNKfY69LWmHykgl+J+AtZjhMq+KP2MpGaKgn3gqXDn2kM1/ETfygxv4au7uA4Y62wjE56FCtJZZBDWs8VxZ4IZAOO2eFRxDAluR6JI06nF1QyBR1ixFBoanYqWRUsffCrKrudOg0Umi4UcjffLN0zW7x2Py3FZHSkERPTb/3QT+M5Kemvj5Xq8a3TV2chs7kED3UoBfDbtGaNjUbF3yd+xl8PeHXLokuzgmAYiUW7D8Ibd1VJVmC033U6OFE+yXda0M5eviIszISmbkaL2WZq5p78v3e9/W28s9W+QgBDo9qBmy/8OZclajuw4Rhr+qdgqSKR02t39tq5aVgYyObgAsnxnaaKGxJ5cZppi8IKVaVxUAz8ZOpLhl47bVMEH3u+GSkswCKXG4guQm2AIyI4CBwxDTq
 Zw1scZ82
 26MTIs/ipxDK5VnwVfFmx73ZTHUQysqUEO9dXLsWd4/3uF5vd2sbQladElHdqT0SeitI2hoglPY73Tqo0VrpDln6tTVSvgZLZH0fFLCgal4G5C0asT7kyjQy3eCiNQ+4zkSCmAVtwF9s72yCIBumuLiD0pqekOyt8zi4L7xnZDdvCh6RGD1TpcJ6syRQnyaeDOfNY91saMGxq/oMtnz27fA7JCmoviZcpMlkdu3k17ZGLsJ0+sCIOCvYMgr/4mB+/q7F69M3XBGIKZcjiEbBmjuGsuwkbXlP/kAQDltMFSrlWY3oOAdtpiaexSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfsd_direct_write() may issue a WRITE as up to three segments: a
buffered prefix, a direct middle and a buffered suffix.  For a
FILE_SYNC or DATA_SYNC WRITE the kiocb carries IOCB_DSYNC and every
segment inherits it, so generic_write_sync() runs a range fsync after
each segment: up to three cache flushes and log forces per WRITE.

Strip IOCB_DSYNC and IOCB_SYNC from the per-segment flags of a split
WRITE, and of an unsplit buffered WRITE, and persist the WRITE once with
vfs_fsync_range() over the bytes actually written, after the last
segment.  Durability is unchanged: the reply is not sent until the
fsync completes, and datasync mirrors the previous per-segment choice
(IOCB_SYNC present means metadata too).  An fsync failure is returned
like a write failure.

A WRITE issued whole as direct I/O keeps its flags: iomap already
completes it in one step, and can complete a DATA_SYNC overwrite of
allocated blocks with FUA writes and no cache flush.

Besides the fewer flushes, the sync now runs after the last segment is
written.  A later commit relies on that order: it marks the page shared
with a neighbouring WRITE for dropping only after writing it, and the
WRITE's own fsync is then the writeback that drops the page.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         |  4 +++-
 fs/nfsd/vfs.c                                 | 20 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 90bf1038453cc..c1cc974640cfe 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -141,7 +141,9 @@ Misaligned WRITE:
     has no effect on the O_DIRECT segment unless the filesystem services
     it with buffered IO instead, as XFS does when it cannot invalidate
     page cache that overlaps the segment. The iomap_dio_invalidate_fail
-    trace event reports such a fallback.
+    trace event reports such a fallback. A split FILE_SYNC or DATA_SYNC
+    WRITE is persisted once, after all of its segments are written, not
+    once per segment.
 
     If NFSD does not split a misaligned WRITE, it issues the whole WRITE
     as a single DONTCACHE buffered IO (normal buffered IO if the
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7e65328de7c86..249358256d2f5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1426,16 +1426,27 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 {
 	struct nfsd_write_dio_seg segments[3];
 	struct file *file = nf->nf_file;
+	loff_t start = kiocb->ki_pos;
 	unsigned int nsegs, i;
+	int sync_flags;
 	ssize_t host_err;
 	size_t expected;
 
 	nsegs = nfsd_write_dio_iters_init(nf, rqstp->rq_bvec, nvecs,
 					  kiocb, *cnt, segments);
 
+	/*
+	 * Persist a synchronous WRITE once, after all of its segments.  A
+	 * WRITE issued whole as direct I/O keeps IOCB_DSYNC, so iomap can
+	 * still complete a DATA_SYNC overwrite with FUA writes.
+	 */
+	sync_flags = kiocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC);
+	if (nsegs == 1 && (segments[0].flags & IOCB_DIRECT))
+		sync_flags = 0;
+
 	*cnt = 0;
 	for (i = 0; i < nsegs; i++) {
-		kiocb->ki_flags = segments[i].flags;
+		kiocb->ki_flags = segments[i].flags & ~sync_flags;
 		if (kiocb->ki_flags & IOCB_DIRECT)
 			trace_nfsd_write_direct(rqstp, fhp, kiocb->ki_pos,
 						segments[i].iter.count);
@@ -1453,6 +1464,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			break;	/* partial write */
 	}
 
+	if (sync_flags && *cnt) {
+		host_err = vfs_fsync_range(file, start, start + *cnt - 1,
+					   !(sync_flags & IOCB_SYNC));
+		if (host_err < 0)
+			return host_err;
+	}
+
 	return 0;
 }
 
-- 
2.52.0


