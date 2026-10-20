Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F722606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=FjgiAk6H
Received: by kanga.kvack.org (Postfix)
	id 99BFF6B0570; Tue, 20 Oct 2026 18:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BE26B0572; Tue, 20 Oct 2026 18:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED6F6B0573; Tue, 20 Oct 2026 18:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C10B6B0570
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 990A216034A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:58 +0000 (UTC)
X-FDA: 85344382956.04.3BE11B9
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF64440002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=FjgiAk6H;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf27.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533836;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksFooBbHDKfmZxe5xUlfiBIprT9yVQQKPdOzVn3Oh+s=;
	b=aNgRvT7fjuB5eFZZYs9kwahwLfgeRv+SIMSmfyLfBIqFla8bIO7o4w0KpeZ7wyvFOu6g3E
	P2tSyZKYLhMfEFPGg/yvpnX+9ruqUtL1XdyBzTSU65fQpkVes5XLL6bs3hq9ez9SZAYtZq
	8pncOmbMUMTevcBwIzq0mOD9oGFegEQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b=FjgiAk6H;
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf27.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533836;
	b=Hv2LrJ029gjRgbx6qpLJ8CLminM9AGsDlMABC/dycgEHhMiYqsF4EdiASVnIIA6yiA9i2Q
	HiZNWkLC4XSfHrZzkJ/XYg3juGLFl7uELHiPM1saf8jSfcvpM/w7cqd0x2CZJEKk3wheq6
	H3XymYGZr/GKgpDIzZ8jk57sY+1xf6E=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f2b8cf037so7490585a.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533836; x=1793138636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ksFooBbHDKfmZxe5xUlfiBIprT9yVQQKPdOzVn3Oh+s=;
        b=FjgiAk6HxSvECsKn8is8NjdqfQUgLGOoSYKIJShr9b65MxiQ56RfotLGR4AOEBfocf
         CPOcvQH10uuSTPBagbjrfSmyBpzo8Oi9DMXlqp2emLNryZVHCiytw4jX/qy8SrNvELxI
         1IOZTFE3Mvizwe8kZBUK41ZxMuUArQgJ1M60WDHlmP2v4ysPmS36TCeMa1o7+vS6UD6x
         5w4Ln9yEWXm6hsmrzTR2v8a8vI7bJQnL/VTzsZQPGUsXBxSIuq2SWDXhgXu2XxIgXjk/
         EPh1GQzubANgSMEMaQZN0IggX5gRo77byBmyWccPsrz4sIe26Fyx8j6+/Cezr98f098h
         vB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533836; x=1793138636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ksFooBbHDKfmZxe5xUlfiBIprT9yVQQKPdOzVn3Oh+s=;
        b=KhW0ukUGFHwQAMMHwtxv9irn+NTtuHO3wP72IZSzZDDnoHIQgIp2BWug6Rz1Azsjfr
         BhbCsCKFhVvPcqZqbCR/9FLcVHzt9C/dfHVAUC8tB7zcVA9LMFMuxnZO4H6riD0xCRRp
         xj6h2B9RS9TC3A+trIT3A9ueX5sEaLTw4/w6CQCB+CT7DBoz+hTX956nvv2S5jSnE7A/
         26DjlCrocTad0OvL29krhtR6X6LoNPRYhbVi1jOcsAKM/im2QtGTK2E3aZ/zZ/R+tuEO
         pmeoyW0fs5/tbsjsK+ZiKPZ4YCheTaLtOi/S5cqKHiq3CbcYX+JJa4e2PCidJOPjcxCQ
         30eA==
X-Forwarded-Encrypted: i=1; AKwUvBwSZ1j0jaEqQJeh5g2Nc6PnQQqKRvbRREyHrSQsHrkQGvaIJmoF79hkc30Pp2A2XAe0j9D2cALBzA==@kvack.org
X-Gm-Message-State: AFq9FYL7vXIbLcYPY7th4t3t/h1tfmovZPqb8Q6sipg5+XyeY3vm+sMM
	tg61degSlni1Yd0HHByd6J4NUv27HdfkbqiOSye6L502Kz77kuMjJH7dINuRsfnwqg0=
X-Gm-Gg: AYBFou3/6R4BDL8zxG/Q8ehuOp0QlYPf1dSSTtlt1xt11Dd+PpQ61bYDO8wq+/61ITE
	1j+lpfdc/+m30Q73cbaq4zL3IuFuslHErX1H6YHKEJcO43ECL9wMt05h6RrSS2yMdCM7bA5ehsN
	8gtM/EEHrS+Zpv3KXJ7TMInfaYxWHkb3pTe9Lx+SKQHr1KeSZ6xAyNMMhRlpc9abdbz5jFY9+5b
	RH7XUMxaHUdndhkacS0SL0fk1H9GDRkDmB+XWsQKFmvxTyfeT9p5UjxTUNzv67J8iIgLkKqif/G
	sagE4YLoRmRcqQWM3SqpK6jz5MlckDoVi/A996Zi7y7A0ohGCJe7tECcxP3cP73gtuos1wCKC0G
	boAwZASSVC0TeChkCgeANMX+741RNAhRJm58s1jWFwlJLq8KxzxHptm/356Ih2DZSu+3t/NrWen
	XZ0R5vhUHi/0nHsOYkzAG7PwOkUTXfD2vhFwParCRiaI3+IM78ppQDt/MF9vrGMXxlQ8MVmTf6t
	P0aNk7EPWenvbUUnMTxRO+SNs+htntmFKJbL2lexrDyzMiqIy5RBY3i0KeXMgWW4O0CK5RWwuUU
	G3HRThx1
X-Received: by 2002:a05:620a:4592:b0:93f:2a95:a503 with SMTP id af79cd13be357-93f57f6c6acmr119603485a.67.1792533835652;
        Tue, 20 Oct 2026 15:03:55 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d98978sm89964885a.10.2026.10.20.15.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:55 -0700 (PDT)
From: Mike Snitzer <snitzer@hammerspace.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
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
Subject: [PATCH v7 5/5] NFSD: drop a shared boundary page only once both WRITEs have written it
Date: Tue, 20 Oct 2026 18:03:46 -0400
Message-ID: <20261020220346.28020-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261020220346.28020-1-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF64440002
X-Rspam-User: 
X-Stat-Signature: rdz6atrisa3nicb5r6gfwirtgz4qitfm
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792533836-915149
X-HE-Meta: U2FsdGVkX1+j2ETiESr1wHANq/ihI+NUndRK+g6OxxhvScbKZH23gXVJjJpzdLOGRjiGP9iuQ6rK2/zZZD8n4/rn9cDJikcX45F6Ow7mxZsyk+vqh04vHImUlpa9eT71+NokGFdYmT0yn26VIudXJdWJLpwNLx6YxFl6vpE9Y9lsiIztlDJMK0esyqcFygi5vZGLh7YkXGqFhL6UoJVDG6A0VwEesL60poP3YD3ZfsL1NZ6bEIl254019S665xk274dulgkrR0cXmgSN5E9XRoPwXSVE+Cecg61Z9cVPq8XK8B9Y9xYy9m+IcbxbU7GxLFglsxIWonyZ+uVkWbU5IC7Ey6TjL/eFZMBAoee68rXmHh+ZimZ9H4+akKsAN/bo/QMnO2AlDgM6Yv7Dn9YOw08YtnC7eY6ZOrVzJdL9WtmgNkDmfiNHgoRZRWwzICTiH5wYXT1ScGj9tkibuHo/PFQK2slaqElPd+Xbjx3exu+FqAq/EiIrdc/xnOHrEQEdMjzABnK+FO5GwJAtyAMd73cZOMqUg5HQGvRh27T3HXT/N7rg48k3f+WoNoSYdgYtsPAQYjRU/1mMzl6ByRLxGhwndsHwlOF0HvqDHSPrv1pyOWqtAUza/r0aYby111yX3W+kW7F0tO/dz2MWi3J17OoCLfEQejKaOCX5rTKXqjOdiZHQsL//pgXIFQUK96HiBL+21rafCpROdjM0ZNkX0XLj2x5PPjeTXOlW0q7Zuc5dYsRh7QLAH/8/QY/+kXQQ/D8VRpYzbFqXRKz1lUUZHQePC/faK+EIIemiuWBxOQ6gRpOVCocCs3X5oQbgX0qCkuM+7D73zmSpVNcfllhY95UlQjOKh+KkVmHe3yKb8pztxRRXW2sugC9Bz2IfhK9dmZfbisjJC9qtEP1J3g6yiwJX0AaZQ/5GzU7CKG2AwGcTDh9e72CkwcVtPENJk77dVzrVmxW6R3BaiqNtqef
 9NqRRQGE
 k9DtczEN41DGgX0MzH0jVcqEmRCWmHiSrSOIz+ScIHC78fI5eMzwgNwd22GyF5JNGWykFY3B8CA5qJSom5gWXmwWjLCnqaYzvpCAb4nyHueTRhfE6OWZoV2nocnSQr/rQxfh5lZx9ysiVe8SItNiW97f8woauimh0khGw0aA8zDRuAyGAgWQh/n6LEzICURkH0upwTOLYapwPQeS3f3uknHdbZYLoZyag7fMg6IW+O5hUPEPJf8watLiDcqreWTwe6o6JDKVKkf7s4jGmkMb1RuZWrB8ugGQ4zmPep+nzICzEfnT1I0KndPzkxGSyGxq8PHEXUt0DXNndyKfewtUGOUHgek8mbtLE+vKN4vbSX3mYGEhSYDGk/EmttaJKmzmhN1U5UVZgB+s2vrafITmZAzsGSpemToGXiesDgIUx7Y7a2PbPRUuipHDW2AJbjoIQrBeiKlCTAyyeCzEe5+8EdKdxZI323Mq791V/NrN6IOpy18NIZMdfCdKAfPR47n7RfBEdgNl6wDt2V7Ks5W2ssiuD2w7FGfo3DsD65umYUWMr8/8JNEdL59UQdESbYQogAN/apJQdUcERGtKA9GBRp4h78fg9FSPwizjaJXHADeZ44dv2h+8JP9PqX3oZaLCKWedvCdUaah/EB27uMKo9TJDtxS0cwkerkMqh
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
Assisted-by: LLM
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
index 9219f8eb386d..3605ddf1ad1e 100644
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
@@ -1483,7 +1545,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (prefix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec,
 					nvecs, total, 0, prefix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 
 	nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs,
@@ -1516,7 +1579,8 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (suffix) {
 		nfsd_write_dio_seg_init(&segments[nsegs], bvec, nvecs, total,
 					prefix + middle, suffix, iocb);
-		segments[nsegs++].flags |= buffered_flags;
+		segments[nsegs].flags |= buffered_flags;
+		segments[nsegs++].claim = !!buffered_flags;
 	}
 	return nsegs;
 
@@ -1525,6 +1589,7 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_write_dio_seg_init(&segments[0], bvec, nvecs, total, 0,
 				total, iocb);
 	segments[0].flags |= buffered_flags;
+	segments[0].claim = !!buffered_flags;
 	return 1;
 }
 
@@ -1533,12 +1598,13 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -1567,23 +1633,32 @@ nfsd_direct_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
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


