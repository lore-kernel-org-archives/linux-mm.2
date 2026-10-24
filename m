Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B712606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4vB6PT7
Received: by kanga.kvack.org (Postfix)
	id E73076B05BF; Sat, 24 Oct 2026 15:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E243E6B05C0; Sat, 24 Oct 2026 15:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12796B05C1; Sat, 24 Oct 2026 15:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4E86B05BF
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:12:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F3191204E8
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:12:26 +0000 (UTC)
X-FDA: 85358465892.05.E058AEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7158F140004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:12:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4vB6PT7;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792869144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tWWiAhD1q3SGqZytIYj8Vfqab8KfOk5ANJFgDlntlxg=;
	b=3IPhxUcnBLhmI1cb/TPXrRRGxiiGLix/C/cIqnUU9LMIApYtxLJmo2rL1i7wmQk3OlXny/
	naxqbx17JuC7TCnzqml8yDfkIHM1/T0AtrCqY/EObKGcbaF01brWl6yE2Gf/vh+YTI+Cq5
	FFFl/FzDA2z+P+3HehmDDMlpYinVEHA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4vB6PT7;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792869144;
	b=kLlr5eNvhM5AVXaDvlPL3xa7arkwCLrz0QWu4nqR9W2iQ0GV+wocYc/++SbkrPEjM5A4hs
	hAMz1czngG5eQkn4FTlKnpgOXHXk97NchcE78907L+JmIhw5Hr45Nx8QF/sfP1fC3gHZxr
	Ikeb+SNyzBfzaZSqeg6zEA8MnXIPkns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D39543937;
	Sat, 24 Oct 2026 19:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5A01F01825;
	Sat, 24 Oct 2026 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792869143;
	bh=tWWiAhD1q3SGqZytIYj8Vfqab8KfOk5ANJFgDlntlxg=;
	h=Date:From:To:Cc:Subject;
	b=k4vB6PT74tlNmxhi9L2GOANsPAVqfX1q2JmIvaC2bdL0QQzOXPu91DEM+YEY8YmL7
	 Ipn+cIXjJJj92UpMbUzvspL0eLaZHA8WyBl9grp+FeepHs0AZnPwVytpeFbtHaP3s7
	 qcE5YOJW23SbpEB3S75h3GCouQSguWnZgE2FuztQv8N77fweEp9pyqXMEu6/68CCPR
	 0zEY8OoEA8qIul/i2czY+AkLUo8+RlW77envDwY21N0biXqvJCAFcQeePCioHJjz/1
	 1Mi4JIs/NL1A7o25TPjX9YiUoWKFry33ar3PRFcxFFXf0UJkCbKBLhBMfxghp/9gl+
	 jF8UX1y1CZ1Hw==
Date: Sat, 24 Oct 2026 15:12:22 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH cel/nfsd-testing replacement] NFSD: cut a misaligned
 direct-mode WRITE at folio boundaries
Message-ID: <at0DFod8CcUfus2S@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7158F140004
X-Stat-Signature: w4yotdcxz1fggwm8nzgta8bbs4cwz3cq
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792869144-850258
X-HE-Meta: U2FsdGVkX1/Gk9CBXfSWDM1XFmajgfOGGHpSP7EOLSkAbLX3up8MzYuETUEYJo0p+5MNid/5fkKvqlXqcJqb2iE1b6TDqjjwqaOMP3cApCJ5zV6jvDeDxZCADqWAzgLIjWME8gOUTTK3aR91A/n9c6QWRB9FSNdCwmNKmxfYTz55tTz/kDrupdtARUg4I5XWhww9s68yataSNPGqkdeqvb6OnP2323H/dRcE+YS5IWWD30XEB/TJDt+5lB1mZUjP98/zpwQgN0XpiXOUHMkgO+uxOpjndZU+o4V/46xeblIWZIhRu1QQQmxH7Idk5lthFws6dp63YdD6jYCw22QiM2OL4+TKPfR5uTx/8ou7DcvNfUuoc9KCMnC2++dpjWH7t2lm2R5tUN1gatIEwwNQHeHl3t+TbBpxeoGkuQv/n+scFjExUm/9utJE+P3B1Wk7sG1F1izFT5qJ823p77/lo50vEwVWujDANrXSo3528EHH8tziQpl25xxAFbKP7swIo9XfFTEyK14Bohri+SnBtzDEPcGvDNZ++pxW5fetuzHXcLJptzV1SZ6gy53RGxb2CvaJAqDrKxHl93NCRNATE3xYSnOiTDHOWqyURANtgyxRSmu+988Z8W8VUt+oKUQLOfZ63hFC5AFyLL4KRGAgKnO0pxhlKhklKc90tS330RKh674FQ5YzVYH/fxE3lMWKxh+q/0e0G6+SZV/vUdsLY/dtMykiyxCeSCVKzDwHLQMDS8CfNTIh9oA8UvYS42YXlRoQKrW+/A28CFUPkb/A31iT5ukPcSKvJ4uXECAJh+8TIlCq6AmSyRnb6j448zy9VLKMU/YCrXpWpu7y3fG+XUwxhttSRzUq4FmJFbfAEkby6KFRnANob6J1eUHpUON2RV1QmiQzkQtMZqhDIkfzhCHXUqSnj7v1FnKo81AIn/ubbmJD0Exc70/oJ/HW+tk1pCE6slfxdclKVw6q1W4
 gm8pILmM
 UAuwtO6kx015oNsgu9fduLLn3SC6i8AwNkZhIuugzHVa9rxvjaD76H/wyJ1DAe/TOVI7ArqyxBEUBaR089Fq/4Uc2D19fcmiyDbuf+scgOHm4FsBqrBIxHiUdNbgTVAT0At9LL8W/ASBlkwy47jxpXETSvx/vDkncaqZYgfolTSuoxX8cXufSa6E7Uo2Zg95FrgrMc8Ex+bh2QTlNqQxURUH2DHiYxmIsX+AoU1HDniYjfNRbtjKePSt6mDme4abBP6NYQXFzIYyQKI0xU2SLB32BAizV2ECJ3eDGfkslU/GlVYhDEUjbSoOceiWuvWn8GHwwObtIG9JSc/QzmHenn1PSYZhWL230sDw8fDMPTb/igOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

nfsd_write_dio_iters_init() splits a misaligned direct-mode WRITE into a
direct middle and buffered ends.  Then as little of the WRITE as
possible goes through the page cache.  That works only if direct and
buffered I/O never meet inside a folio.  The direct middle invalidates
the page cache over its range.  So a middle that starts or stops inside
the folio of a buffered end drops that folio.  Then the second of the
two neighbouring WRITEs reads it back from the device.

The middle was cut at the file system's direct I/O offset alignment:

        prefix_end = round_up(offset, offset_align);
        middle_end = round_down(orig_end, offset_align);

Where that alignment is a multiple of the smallest folio the mapping
allows, the cut is a folio boundary, and the problem cannot occur.  This
is the case for 4 KiB pages over 4096-byte blocks.  It is broken where
the smallest folio is larger than the alignment.  Examples are 16 and
64 KiB pages over 4096-byte blocks, and 4 KiB pages over 512-byte
blocks.

Another is a block larger than the page, which the page cache holds as
one folio.  There a misaligned WRITE costs a read per shared folio on
top of its three I/Os.

Cut each end of a WRITE on its own:

- an end that is already an offset_align multiple needs no buffered
  segment, and the middle starts or stops there, inside a folio or not.
  A WRITE aligned to the device stays fully direct at every page size.
- a misaligned end needs a buffered segment in any case.  That segment
  now runs to the nearest boundary of the smallest folio inside the
  WRITE.

That is one rule: a misaligned end is cut at a multiple of the larger of
offset_align and mapping_min_folio_nrbytes().  Both are powers of two.

The segments still tile exactly the bytes of the WRITE: a buffered end
grows inward, at the middle's expense, never outward.  A misaligned
WRITE that holds no whole folio of the smallest size has no middle, and
is issued as one buffered segment.  Where offset_align is a multiple of
the smallest folio, nothing changes.

A folio larger than the smallest that the mapping allows can still span
the cut.  Readahead or an earlier buffered write can leave one, and only
the lookup that finds it learns its size.  The direct middle then
invalidates it as a whole, and the neighbouring WRITE reads its part
back once.  Direct I/O always has that read-back for a cached folio, and
the cut cannot prevent it.

nfsd-io-modes.rst said that DONTCACHE is not used for the misaligned
segments.  The write loop already contradicted that: every segment
without IOCB_DIRECT gets IOCB_DONTCACHE when the file system supports
it.  Replace that sentence with one that says so, next to one that
describes the new cut.

Fixes: 06c5c97293e3 ("NFSD: Implement NFSD_IO_DIRECT for NFS WRITE")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
This replaces 80728157d1bd ("NFSD: cut a misaligned direct-mode WRITE at
page boundaries") in cel/nfsd-testing.  Changes from that commit:

- the cut is max_t(unsigned long, offset_align,
  mapping_min_folio_nrbytes(nf->nf_file->f_mapping)).  PAGE_SIZE is
  gone, and cut keeps the helper's unsigned long type.
- the subject, the commit message, the comment and nfsd-io-modes.rst
  name two bounds: the DIO offset alignment and the mapping's smallest
  folio.

It also takes the place of v8 1/7, which will not be in v9.

Heads-up for applying the commits after 80728157d1bd: of the 27 in
cel/nfsd-testing (6d13b7f74eec), only fcd8823db80e ("NFSD: only split a
direct-mode WRITE for a worthwhile direct middle") conflicts, in
nfsd-io-modes.rst.  Take its paragraph with "page" changed to "folio" in
"nearest page boundary" and "never shares a page".  Nothing conflicts in
code.  The other 26 apply cleanly, and the result differs from
cel/nfsd-testing only in this change.

 .../filesystems/nfs/nfsd-io-modes.rst         |  9 ++++++---
 fs/nfsd/vfs.c                                 | 20 +++++++++++++++++--
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 0fd6e82478fe6..8f5e6872f1004 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -126,9 +126,12 @@ Misaligned WRITE:
     middle and end as needed. The large middle segment is DIO-aligned
     and the start and/or end are misaligned. Buffered IO is used for the
     misaligned segments and O_DIRECT is used for the middle DIO-aligned
-    segment. DONTCACHE buffered IO is _not_ used for the misaligned
-    segments because using normal buffered IO offers significant RMW
-    performance benefit when handling streaming misaligned WRITEs.
+    segment. A misaligned start or end segment runs to the nearest folio
+    boundary inside the WRITE, not just to the nearest DIO-aligned
+    offset, so the O_DIRECT segment never shares a folio with a buffered
+    one; a start or end that is already DIO-aligned gets no buffered
+    segment at all. If the filesystem supports FOP_DONTCACHE, the
+    misaligned segments are marked DONTCACHE.
 
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c4b32e41b4c5e..f18309d4609b7 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1396,6 +1396,7 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	size_t prefix, middle, suffix;
 	loff_t offset = iocb->ki_pos;
 	unsigned int nsegs = 0;
+	unsigned long cut;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1406,9 +1407,24 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	    unlikely(total < max(offset_align, mem_align)))
 		goto no_dio;
 
-	prefix_end = round_up(offset, offset_align);
 	orig_end = offset + total;
-	middle_end = round_down(orig_end, offset_align);
+
+	/*
+	 * The direct middle invalidates the page cache over its range, so it
+	 * must not share a folio with a buffered end.  An aligned end needs no
+	 * buffered segment.  A misaligned one is cut on a boundary of the
+	 * smallest folio the mapping allows, even where the offset alignment
+	 * is finer.  A WRITE may end at OFFSET_MAX, so the prefix is sized as
+	 * a distance rather than by rounding @offset up, which could wrap.
+	 */
+	cut = max_t(unsigned long, offset_align,
+		    mapping_min_folio_nrbytes(nf->nf_file->f_mapping));
+	prefix_end = offset;
+	if (!IS_ALIGNED(offset, offset_align))
+		prefix_end += min_t(loff_t, cut - (offset & (cut - 1)), total);
+	middle_end = orig_end;
+	if (!IS_ALIGNED(orig_end, offset_align))
+		middle_end = max(round_down(orig_end, cut), prefix_end);
 
 	prefix = prefix_end - offset;
 	middle = middle_end - prefix_end;

base-commit: 4e84914d70a0194e18bba6d814cfe71b340aadc8
-- 
2.52.0


