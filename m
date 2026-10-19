Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2A86084840
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WkHIjGMn
Received: by kanga.kvack.org (Postfix)
	id 3CF8C6B029E; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A65A6B02A2; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E296B029E; Mon, 19 Oct 2026 11:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8E7E6B029E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:07:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DDBD1406B4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:31 +0000 (UTC)
X-FDA: 85339704702.21.3F5B99B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7D244C000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkHIjGMn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hOg2i79IwKo0Y5Q+OgE6JXIx9i3XNaUZPWYs4I/bAY=;
	b=bsXjfQwkWV6ovyiOZXmV8E/A744/nZKxJXhpgdl0tIyONxyq06JWNnyWZF6jWUsH/hFea2
	2GGpjksYKJVSpj7XuHMq7mGyklys3DUWdvMCT3J6xUKkwgNCtG0zEmDQR8SuK+uK4b2bg0
	ReKDcq7klY+jpp4pLRSd+VheDqLmOgQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkHIjGMn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422449;
	b=ZLOXbaeZ5TEJ4A6ZYQmW9Krb5T5jlD5QYcVmIJmnPzumVtiVWm2hzIL5HaUb6QhO+tQv7i
	sVDk1F9It3sFgXQfbjBUSN5nDbw8kAMxC26EtqX5uRchH7/l2RtI54AB4Lev4snM7f9/KX
	J0XoVhQThpeFSRRY2V3vlDOa6Uq65II=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F03843C01;
	Mon, 19 Oct 2026 15:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE2E1F000C5;
	Mon, 19 Oct 2026 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422448;
	bh=0hOg2i79IwKo0Y5Q+OgE6JXIx9i3XNaUZPWYs4I/bAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkHIjGMnWtAotlwjZv20dfxOm0u8uniThVMNB9KqQZ9lsnn+DNIZgDtYSgp0B5edA
	 Gn1GHI1p4J93L8uOUxb5aYea7/VttzplGMr3zrXLCp00t+HhTZzU3y3hhe+pVnHJcE
	 kcYrVA0zbl6gcHjgcYQlxhk2NEk2vP/pIhLGCzPA0En1qKvLI6koGbUUX8DM8IWKuP
	 0nzLRsLBDYqxo4A16jUPfWVdQoHK1AMH+xYg77tM5FwdWzL6w8qqAWO3hoC3GIZ4h9
	 J0t0abQoDBgT6zA60ccSCp5+MHZdLqeXcO0p4voKet+1K868iP5sH+dH9fqQW3KmVn
	 sHtGKAa2TBSjQ==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 1/6] NFSD: add tracing for how direct-mode READ and WRITE are serviced
Date: Mon, 19 Oct 2026 11:07:20 -0400
Message-ID: <20261019150725.1507-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261019150725.1507-1-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D244C000D
X-Stat-Signature: 97a6h48h9ms8uw5jtt3r3na7sx74mpr3
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792422449-929859
X-HE-Meta: U2FsdGVkX18WPD1SOzAQFvfTqYZq1zNkoiOpWvKY1EeXzKafdFZlXhTars1YdF9zz6ZvUlPkvjFEYpXwVhL9D9niYYl1Y6SzNnb7KwkmAcfDBqVEaxapNa5SAI3n8tGIutV+FBKVFjhUrtoaiPz5STPL6xcrU9aiFgN57nEXvFk50UXht8MfQ0OF4T6cUQYYAsBlbGHbR825VT9Ihoxw5FTLZ10P9MtZjTIZ/g2+J0Zj5DlkIuejdOvSYzbrmGhS2oIOtafmdHLx3QyfQ5HPXejrcEf8wOT3aOKQ2b7fmYkIjnFwSwCGXigeRo30Z1T1bSnuDc8vpOiH29pDqTxDDV98KhlVRkgZnHWzgDOcmNbbukNwuABRGj6EDbDTMz0YLrJfwBAYdULtsPWhDLEbpTtit3NurOjHlBWtGEfJObc0kD0WLK1S6N9P9TWqcxujO9v2W0p9a0pjBLdYCvZ9b+itsgE3ri7Ijvx1D8+qdgAthgaIhR8Qxd32IStSSBZ3mAgoNQ7E/LYHJi8voFWk1Sc4Tsguq62Y25HqYksYQ1ZJx3fGqo5TAfuYwZhWWaTuRrSPoi+wTif+IBRP37imw1FwPWXQSY2eseXj7+wM5LN3o5tN1bazQo3iM1exVxgBMtS/glXCOVxp3lnBqjXE3fHrmofddFmSAwSk9b9DLb7BhwG8gwkKi80E1cY3FqL/+z/OU20zARDPMApoS/4Y6GKGAeCRk6+Bogn8nSehB7EBFnbTtiwMQenQ1RyAFgKDVmMc03LzO2dFRjTX0t+YXXXHSRdgeG4zr/xxqAFWFbs/2wd5aiZdfXaSHJcdE1JY+bA2kpRcYBEutnYNVKR8F5U3pHSh9F5n4Zm05piSH893uCUsJLyCw8DNkAzOUOq8YA7r5mvKHiKkfoRM5uJvhqkA1ShwYjSmBmZJRWGK89xZ7gUt+EABcG5EefDs6XQVAQjLQd6PnxtoF9y0CiL
 y4gc3m0r
 CaUbg2GKfDpOdS2kgTA2SEkbCPQUOgmsqEx+q/goh2DpLyCCZFy/QykL4WypszaXI++YAf5BWDVuXZaEiL3f06WDTC9rfwuovmdjG9aFG7BA9VeIMnotYCg5ed2j6eqSqYYocS9HXLLJzcICVEcfAmxMlmnKVTjWh1l2sh04Q12ftt3o7FFidkupFc25/VlvnxKiTSdDq1mGM9uRkge3KGSggDhPbJWoRNaPYb3TNAB8wVZRp2woMPcQfujZg8akBgykFo5thW/GcdbXArjUQd41usDK1YHn8p6mWsN9zdmBcUMUx1F3eisPzmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When io_cache_read or io_cache_write selects a direct I/O mode, a
request may still be serviced with DONTCACHE buffered or normal
buffered I/O, and a WRITE may be split into up to three segments that
each take a different path depending on the request's offset/length
alignment, the payload's memory alignment, the filesystem's
FOP_DONTCACHE support, direct_misaligned_min_bytes and
direct_misaligned_dontcache.  Until now the only visibility was
nfsd_{read,write}_direct for O_DIRECT and nfsd_{read,write}_vector for
everything else, so the DONTCACHE and cached buffered cases were
indistinguishable and the reason a WRITE was not issued as direct I/O
was not recorded at all.

Add:

 - nfsd_write_dio_split, emitted once per direct-mode WRITE before any
   segment is issued.  It records the advertised offset and memory
   alignments, the payload's offset within its first page, the start,
   middle and end segment sizes, a disposition naming the path taken
   (direct, no_alignment, too_small, no_middle, mem_misaligned), and
   whether buffered segments are issued IOCB_DONTCACHE.

 - nfsd_write_dontcache and nfsd_read_dontcache, emitted for WRITE
   segments and READs serviced with IOCB_DONTCACHE.  nfsd_write_vector
   and nfsd_read_vector now fire only for normal buffered I/O.

The disposition enum lives in vfs.h, which trace.h already includes.

Document the new events in nfsd-io-modes.rst, together with iomap's
iomap_dio_invalidate_fail event, which reports an O_DIRECT segment that
the filesystem serviced with buffered I/O instead.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 .../filesystems/nfs/nfsd-io-modes.rst         | 38 ++++++++-
 fs/nfsd/trace.h                               | 77 +++++++++++++++++++
 fs/nfsd/vfs.c                                 | 47 ++++++++---
 fs/nfsd/vfs.h                                 |  9 +++
 4 files changed, 156 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 0a5f4ef14a8a..11da2cee76fc 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -171,21 +171,53 @@ Misaligned WRITE:
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
     misaligned READ to the next DIO-aligned block (on either end of the
-    original READ, as needed).
+    original READ, as needed). A READ that is serviced with buffered IO
+    instead emits nfsd_read_dontcache (DONTCACHE buffered IO) or
+    nfsd_read_vector (normal buffered IO).
 
     This combination of trace events is useful for READs::
 
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_read_vector/enable
+      echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_read_dontcache/enable
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_read_direct/enable
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_read_io_done/enable
       echo 1 > /sys/kernel/tracing/events/xfs/xfs_file_direct_read/enable
 
-    The nfsd_write_direct trace event shows how NFSD splits a given
-    misaligned WRITE into a DIO-aligned middle segment.
+    The nfsd_write_dio_split trace event is emitted once per WRITE in a
+    DIRECT IO mode, before any IO is issued. It records the alignments
+    the filesystem advertised, the payload's offset in its first page,
+    the sizes of the start, middle and end segments, and a
+    disposition::
+
+      direct          the aligned middle segment uses O_DIRECT
+      mem_misaligned  payload memory is misaligned; not split
+      no_alignment    the filesystem advertises no DIO alignment; not split
+      too_small       smaller than the larger of the offset and memory
+                      alignments; not split
+      no_middle       no aligned middle, or a misaligned start or end
+                      with a middle smaller than
+                      direct_misaligned_min_bytes bytes; not split
+
+    dontcache=1 means any buffered segment is issued DONTCACHE: the start
+    and end segments of a split WRITE, or the whole of a WRITE that is
+    not split. It is 0 when direct_misaligned_dontcache is N or the
+    filesystem lacks FOP_DONTCACHE, and is reported even for a WRITE
+    that has no buffered segment.
+
+    Each segment then emits nfsd_write_direct (O_DIRECT),
+    nfsd_write_dontcache (DONTCACHE buffered IO) or nfsd_write_vector
+    (normal buffered IO).
 
     This combination of trace events is useful for WRITEs::
 
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_opened/enable
+      echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_dio_split/enable
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_direct/enable
+      echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_dontcache/enable
+      echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_vector/enable
       echo 1 > /sys/kernel/tracing/events/nfsd/nfsd_write_io_done/enable
       echo 1 > /sys/kernel/tracing/events/xfs/xfs_file_direct_write/enable
+      echo 1 > /sys/kernel/tracing/events/iomap/iomap_dio_invalidate_fail/enable
+
+    iomap_dio_invalidate_fail reports an O_DIRECT middle segment that
+    the filesystem serviced with buffered IO instead.
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index e0908cb21c4e..e2615cfdf6b7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -501,6 +501,7 @@ DEFINE_EVENT(nfsd_io_class, nfsd_##name,	\
 DEFINE_NFSD_IO_EVENT(read_start);
 DEFINE_NFSD_IO_EVENT(read_splice);
 DEFINE_NFSD_IO_EVENT(read_vector);
+DEFINE_NFSD_IO_EVENT(read_dontcache);
 DEFINE_NFSD_IO_EVENT(read_direct);
 DEFINE_NFSD_IO_EVENT(read_io_done);
 DEFINE_NFSD_IO_EVENT(read_done);
@@ -508,11 +509,87 @@ DEFINE_NFSD_IO_EVENT(write_start);
 DEFINE_NFSD_IO_EVENT(write_opened);
 DEFINE_NFSD_IO_EVENT(write_direct);
 DEFINE_NFSD_IO_EVENT(write_vector);
+DEFINE_NFSD_IO_EVENT(write_dontcache);
 DEFINE_NFSD_IO_EVENT(write_io_done);
 DEFINE_NFSD_IO_EVENT(write_done);
 DEFINE_NFSD_IO_EVENT(commit_start);
 DEFINE_NFSD_IO_EVENT(commit_done);
 
+TRACE_DEFINE_ENUM(NFSD_WRITE_DIO_DIRECT);
+TRACE_DEFINE_ENUM(NFSD_WRITE_DIO_MEM_MISALIGNED);
+TRACE_DEFINE_ENUM(NFSD_WRITE_DIO_NO_ALIGNMENT);
+TRACE_DEFINE_ENUM(NFSD_WRITE_DIO_TOO_SMALL);
+TRACE_DEFINE_ENUM(NFSD_WRITE_DIO_NO_MIDDLE);
+
+#define show_nfsd_write_dio_disposition(x)				\
+	__print_symbolic(x,						\
+		{ NFSD_WRITE_DIO_DIRECT,	"direct" },		\
+		{ NFSD_WRITE_DIO_MEM_MISALIGNED, "mem_misaligned" },	\
+		{ NFSD_WRITE_DIO_NO_ALIGNMENT,	"no_alignment" },	\
+		{ NFSD_WRITE_DIO_TOO_SMALL,	"too_small" },		\
+		{ NFSD_WRITE_DIO_NO_MIDDLE,	"no_middle" })
+
+/*
+ * Emitted once per direct-mode WRITE, before any segment is issued.
+ * prefix, middle and suffix are zero when not computed.  mem_offset is
+ * the offset of the payload within its first page.
+ */
+TRACE_EVENT(nfsd_write_dio_split,
+	TP_PROTO(struct svc_rqst *rqstp,
+		 struct svc_fh *fhp,
+		 u64 offset,
+		 u32 len,
+		 u32 offset_align,
+		 u32 mem_align,
+		 u32 mem_offset,
+		 u32 prefix,
+		 u32 middle,
+		 u32 suffix,
+		 enum nfsd_write_dio_disposition disposition,
+		 bool dontcache),
+	TP_ARGS(rqstp, fhp, offset, len, offset_align, mem_align, mem_offset,
+		prefix, middle, suffix, disposition, dontcache),
+	TP_STRUCT__entry(
+		__field(u32, xid)
+		__field(u32, fh_hash)
+		__field(u64, offset)
+		__field(u32, len)
+		__field(u32, offset_align)
+		__field(u32, mem_align)
+		__field(u32, mem_offset)
+		__field(u32, prefix)
+		__field(u32, middle)
+		__field(u32, suffix)
+		__field(unsigned int, disposition)
+		__field(bool, dontcache)
+	),
+	TP_fast_assign(
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->fh_hash = knfsd_fh_hash(&fhp->fh_handle);
+		__entry->offset = offset;
+		__entry->len = len;
+		__entry->offset_align = offset_align;
+		__entry->mem_align = mem_align;
+		__entry->mem_offset = mem_offset;
+		__entry->prefix = prefix;
+		__entry->middle = middle;
+		__entry->suffix = suffix;
+		__entry->disposition = disposition;
+		__entry->dontcache = dontcache;
+	),
+	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%llu len=%u "
+		  "offset_align=%u mem_align=%u mem_offset=%u "
+		  "prefix=%u middle=%u suffix=%u disposition=%s "
+		  "dontcache=%u",
+		  __entry->xid, __entry->fh_hash,
+		  __entry->offset, __entry->len,
+		  __entry->offset_align, __entry->mem_align,
+		  __entry->mem_offset,
+		  __entry->prefix, __entry->middle, __entry->suffix,
+		  show_nfsd_write_dio_disposition(__entry->disposition),
+		  __entry->dontcache)
+);
+
 DECLARE_EVENT_CLASS(nfsd_err_class,
 	TP_PROTO(struct svc_rqst *rqstp,
 		 struct svc_fh	*fhp,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 32136cd32af9..0e937d116f39 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1323,7 +1323,10 @@ __be32 nfsd_iter_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 	rqstp->rq_next_page = page;
 
-	trace_nfsd_read_vector(rqstp, fhp, offset, *count - total);
+	if (kiocb.ki_flags & IOCB_DONTCACHE)
+		trace_nfsd_read_dontcache(rqstp, fhp, offset, *count - total);
+	else
+		trace_nfsd_read_vector(rqstp, fhp, offset, *count - total);
 	iov_iter_bvec(&iter, ITER_DEST, rqstp->rq_bvec, v, *count - total);
 	host_err = vfs_iocb_iter_read(file, &kiocb, &iter);
 	return nfsd_finish_read(rqstp, fhp, file, offset, count, eof, host_err);
@@ -1391,7 +1394,8 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
 }
 
 static unsigned int
-nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
+nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
+			  struct nfsd_file *nf, struct bio_vec *bvec,
 			  unsigned int nvecs, struct kiocb *iocb,
 			  unsigned long total,
 			  struct nfsd_write_dio_seg segments[3])
@@ -1399,7 +1403,9 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	u32 offset_align = nf->nf_dio_offset_align;
 	loff_t prefix_end, orig_end, middle_end;
 	u32 mem_align = nf->nf_dio_mem_align;
-	size_t prefix, middle, suffix;
+	size_t prefix = 0, middle = 0, suffix = 0;
+	enum nfsd_write_dio_disposition disposition;
+	u32 mem_offset = nvecs ? bvec->bv_offset : 0;
 	loff_t offset = iocb->ki_pos;
 	unsigned int dontcache_flags = 0;
 	unsigned int buffered_flags;
@@ -1415,9 +1421,14 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	 * If alignments are not available, the write is too small,
 	 * or no alignment can be found, fall back to buffered I/O.
 	 */
-	if (unlikely(!mem_align || !offset_align) ||
-	    unlikely(total < max(offset_align, mem_align)))
+	if (unlikely(!mem_align || !offset_align)) {
+		disposition = NFSD_WRITE_DIO_NO_ALIGNMENT;
 		goto no_dio;
+	}
+	if (unlikely(total < max(offset_align, mem_align))) {
+		disposition = NFSD_WRITE_DIO_TOO_SMALL;
+		goto no_dio;
+	}
 
 	orig_end = offset + total;
 
@@ -1443,8 +1454,10 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 
 	if (!middle ||
 	    ((prefix || suffix) &&
-	     middle < nfsd_direct_misaligned_min_bytes))
+	     middle < nfsd_direct_misaligned_min_bytes)) {
+		disposition = NFSD_WRITE_DIO_NO_MIDDLE;
 		goto no_dio;
+	}
 
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
@@ -1462,28 +1475,35 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	 * the first bvec, all subsequent bvecs start at bv_offset zero
 	 * (page-aligned). Therefore, only the first bvec is checked.
 	 */
-	if (iov_iter_bvec_offset(&segments[nsegs].iter) & (mem_align - 1))
+	if (iov_iter_bvec_offset(&segments[nsegs].iter) & (mem_align - 1)) {
+		disposition = NFSD_WRITE_DIO_MEM_MISALIGNED;
 		goto no_dio;
+	}
 	/*
 	 * IOCB_DONTCACHE matters only if the file system falls back to
 	 * buffered I/O (-ENOTBLK).
 	 */
 	segments[nsegs++].flags |= IOCB_DIRECT | dontcache_flags;
+	disposition = NFSD_WRITE_DIO_DIRECT;
 
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
 		segments[nsegs++].flags |= buffered_flags;
 	}
-
-	return nsegs;
+	goto out;
 
 no_dio:
 	/* Issue the whole WRITE as a single buffered segment. */
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
-	return 1;
+	nsegs = 1;
+out:
+	trace_nfsd_write_dio_split(rqstp, fhp, offset, total, offset_align,
+				   mem_align, mem_offset, prefix, middle,
+				   suffix, disposition, !!buffered_flags);
+	return nsegs;
 }
 
 static noinline_for_stack int
@@ -1499,8 +1519,8 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	ssize_t host_err;
 	size_t expected;
 
-	nsegs = nfsd_write_dio_iters_init(nf, rqstp->rq_bvec, nvecs,
-					  kiocb, *cnt, segments);
+	nsegs = nfsd_write_dio_iters_init(rqstp, fhp, nf, rqstp->rq_bvec,
+					  nvecs, kiocb, *cnt, segments);
 
 	/*
 	 * Persist a split synchronous WRITE once, after all of its
@@ -1517,6 +1537,9 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		if (kiocb->ki_flags & IOCB_DIRECT)
 			trace_nfsd_write_direct(rqstp, fhp, kiocb->ki_pos,
 						segments[i].iter.count);
+		else if (kiocb->ki_flags & IOCB_DONTCACHE)
+			trace_nfsd_write_dontcache(rqstp, fhp, kiocb->ki_pos,
+						   segments[i].iter.count);
 		else
 			trace_nfsd_write_vector(rqstp, fhp, kiocb->ki_pos,
 						segments[i].iter.count);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 1f05c83a3ea6..e2a7c1c44949 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -230,4 +230,13 @@ __be32		nfsd_permission(struct svc_cred *cred, struct svc_export *exp,
 
 void		nfsd_filp_close(struct file *fp);
 
+/* The path nfsd_write_dio_iters_init() took for a direct-mode WRITE. */
+enum nfsd_write_dio_disposition {
+	NFSD_WRITE_DIO_DIRECT,
+	NFSD_WRITE_DIO_MEM_MISALIGNED,
+	NFSD_WRITE_DIO_NO_ALIGNMENT,
+	NFSD_WRITE_DIO_TOO_SMALL,
+	NFSD_WRITE_DIO_NO_MIDDLE,
+};
+
 #endif /* LINUX_NFSD_VFS_H */
-- 
2.52.0


