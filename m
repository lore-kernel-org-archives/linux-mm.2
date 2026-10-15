Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9CFCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994226B0098; Thu, 15 Oct 2026 19:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96BB66B0099; Thu, 15 Oct 2026 19:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881A26B009B; Thu, 15 Oct 2026 19:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEB06B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2BA5A5C72
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:15 +0000 (UTC)
X-FDA: 85326463950.20.9CFA6D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 357221A0007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Odmx9CmP;
	spf=pass (imf19.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107194;
	b=AU9bcC3G3qlgiCrfz8mT57RSNGB+gXXVxu9wTQUddU2v5+KrGxCle91Mx3cJHEQ0SqlzxC
	6t3h9CH8wZM3JoL03+k2y0zZH+9IS1CtVNYajBS1MyBV+nRm9O7hdvQk5Q5bKPV66dsrGs
	RZ5h8TsTSSeTZ4vLcerYJK0jv1/Wa+A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Odmx9CmP;
	spf=pass (imf19.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QPU6aTL0OhHiRAhc/6gebYSbVWMh+1NkswTXRHKaRE=;
	b=07P1dcrdMWN0aJek5aFDOhp7pSBKQHUcM8zs0MI9DGDeHwgeJ0e6u1kfP6Tby3M4UBzSkS
	OodeBc3st927wXNQC12pw0jD+PSoHgri+xFJp4SDDfMZ0Um2JLKVU3wos5afETjIeZ5sn7
	N6aZpONC+9UgUZI4jrJ0I1/oQNYap5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8546742D8F;
	Thu, 15 Oct 2026 23:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349521F000C4;
	Thu, 15 Oct 2026 23:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107193;
	bh=9QPU6aTL0OhHiRAhc/6gebYSbVWMh+1NkswTXRHKaRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Odmx9CmPFhY9YSSBeZTOnQKy9tG4SZRh28xpZE9lBhig2MHoHxWkS9LicYeGGZKnk
	 AklHAR8gyucQlczqC/PZrQcX03XN/uBnoK4XZa6Yi8EBgS31P5ZWtEEB581HAfAs8W
	 W7e+JXLvBdOXdBnFNAKCpM6HATgDbQ8kRsYv/pRuVyMg62VrICk8wDJcu1YVvk00s6
	 Ra5Oedi0GckHGIl3eBRA/N0YSxT/zV1xOqONo0br6MpZNjGqqAsu9a/G9SrDc67H9g
	 Xs10Q2sL9YgzvzP+A4EFJTkLDAp5OwNDaj1FXywRGk587sd2LaKwWfcLh11eae77PV
	 zMas6m17Mr2Tg==
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
Subject: [PATCH v4 02/10] NFSD: mark the direct middle of a split WRITE IOCB_DONTCACHE as well
Date: Thu, 15 Oct 2026 19:33:01 -0400
Message-ID: <20261015233309.42999-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 357221A0007
X-Stat-Signature: umsb4rtwj6w3fopugznxak5w487pccb1
X-HE-Tag: 1792107194-35805
X-HE-Meta: U2FsdGVkX1/2gD18ttve9cTVjSyWEjCEWqbUjQKJ5wbIdLbFPZVLlKA/pwKochU3eaantnXVu0xAaFIzJdIY63qWRESrnSLR39oKHa5iKWLEgomMJzELvOkNYrYq6BjDIbXcdr1jXa3WPm+rQYZ/M8jzntxaOEEsgOFgrI+KdYR0QcIa6VSmfzQHmVrmWNAenzP0+ztk0XcgMcrbivwd4emabs7ktgZIve6/lEVvHXqhQmaQ7syd0mcPE3/H342vkS/ds4zvLwNnRNhOmk++b2jgmG1uP0MZajWcwWMSWFf7pB8XOSYm/gVfIbtfVwZiDJCSWEBOf36ZgRfXmPXlYqDLIM9eF3GSsfetm6sy7SHzKlI3OkqG0ZFoXqEWcwlC7gEtYhizgx7ubRWRUxi+EMFxZ8pW7jTgTStAojdIF2E/QRiYmvmaM9ROWViGyxFYO+92HXe16v3+n6hZudoodEzZqfFBPPVC2RzjbUFUPc6VkfoctptH4z/8mFbz/G8pNbW3gFtNHnYYvqGNKtStVnRTiiqr2IbqqqZFNYHnmMzCQYgGlgpAWlo0NuB/75lhPKcqd+6hP00GADQAr+uqcfW/xSHSVvGRZG6iHuweQr2Plv8DLHyOPpAhcjTaQX/dxEbHX64PE8AeNUiu9A1IFJCJPrgPmDU8DS+WLmeyT8f2URojstEKfeV9vi04GgfcJY6ITMOvpdn16qV9tYxOgDw0PfjKKWKvLA/Zn4HFcAQrhK2Mqc75/PdZQZJUkBw52E3Xc5CMrYBjMfirW4q+D4QxenML0GUnhFDUY5h89l5DIaLSrpZYDXbp16dO8jx8rOITmhobWGF3nVRIj2W2kgNZANWRWZSB12K475tDsksq2fpKfMqVpxvSZdfvQS9GzWY2Tu6UWVSAk3tadWrq7jfMkPKk6OGWKlAiVKxAO4ruNtk9Sd+qreLScibhS+E5h72wbc6Exoh6I3TxE0T
 gxH/cxdl
 Yt4GlzzTyREioPUju1zRQ6yAZ6XK/OM8wb6SNBnPlW//06PXmC3IiPICxP/wcFmrnt8ut0/sc/aFsyrdgC5rR0oNybZY0rn6cubvq8y80T2J7sLpfuq6gSrHrtj2LpF/JVm2dhb/0DXwATJyIuEbhKRhY2W+R/8+YLUrV5XGKGLlSHBQmdF1l4noT5yCHpJj8EVb+7/URTY6e5wKI6W9qys94bmaop9ACgX4Ux/00/JR/H0+2GjylfUYhbqHHkRIWzeKyYrWG9tF0txxKe7CQpdHBFC9pPFuFr6Mm3ad3Ny0IxQACZKnValzOGwmfApd70BPctsSPLi7m1jX3WNxagmdlwh3DboizqNb6aFSNSurpaUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfsd_write_dio_iters_init() marks the DIO-aligned middle of a misaligned
WRITE IOCB_DIRECT, and nfsd_direct_write() issues it that way.  A file
system may service that request with buffered I/O instead:
xfs_file_write_iter() retries through xfs_file_buffered_write() with the
same kiocb when xfs_file_dio_write() returns -ENOTBLK, which
iomap_dio_rw() does when it cannot invalidate page cache overlapping the
range.

Since the previous commit, the middle of a split WRITE shares no page
with the buffered ends of its neighbours, so a streaming misaligned
WRITE workload no longer causes this by itself.  It still happens
whenever something dirties a page in the middle's range between its
writeback and its invalidation without taking the lock the file system
holds across a direct write: a local process writing the exported file
through mmap, which XFS's IOLOCK does not keep out, or, on a file system
that does not hold such a lock for the length of a direct write, an
overlapping WRITE that is issued buffered as a whole (too small to
split, or its payload misaligned in memory) or a local buffered writer.
All of the middle, nearly the whole WRITE, is then re-issued as a cached
buffered write that nothing ever drops.

Set IOCB_DONTCACHE on the middle segment alongside IOCB_DIRECT when
the file system supports FOP_DONTCACHE.  The direct path ignores the
flag; a buffered fallback now drops its pages once written back.  Say
so in nfsd-io-modes.rst.

Fixes: 06c5c97293e3 ("NFSD: Implement NFSD_IO_DIRECT for NFS WRITE")
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 Documentation/filesystems/nfs/nfsd-io-modes.rst | 4 ++++
 fs/nfsd/vfs.c                                   | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 1916b2eee58ad..f9b63f1a33990 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -132,6 +132,10 @@ Misaligned WRITE:
     one; a start or end that is already DIO-aligned gets no buffered
     segment at all. If the filesystem supports FOP_DONTCACHE, the
     misaligned segments are marked DONTCACHE.
+    So is the O_DIRECT segment, where the flag has no effect unless the
+    filesystem services it with buffered IO instead, as XFS does when it
+    cannot invalidate page cache that overlaps the segment. The
+    iomap_dio_invalidate_fail trace event reports such a fallback.
 
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ed5903c3becac..bd3dab36e2962 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1375,6 +1375,9 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	if (iov_iter_bvec_offset(&segments[nsegs].iter) & (mem_align - 1))
 		goto no_dio;
 	segments[nsegs].flags |= IOCB_DIRECT;
+	/* In case the file system falls back to buffered I/O (-ENOTBLK). */
+	if (nf->nf_file->f_op->fop_flags & FOP_DONTCACHE)
+		segments[nsegs].flags |= IOCB_DONTCACHE;
 	nsegs++;
 
 	if (suffix)
-- 
2.52.0


