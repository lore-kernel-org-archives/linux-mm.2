Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7136FCCA463
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BDD6B0096; Thu, 15 Oct 2026 19:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01CCE6B0098; Thu, 15 Oct 2026 19:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DC86B0099; Thu, 15 Oct 2026 19:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 969766B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDD3940232
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:14 +0000 (UTC)
X-FDA: 85326463908.05.DA6AAFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17A7380006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=be41zlYX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrooXPF1hhM/MoxFNqM1PlbQKoKP+pEqMYFgXl1fs10=;
	b=gnFble8aHi+aIDpxQ1jstRl6Rc1DdmDLdOSAXO72Rzf12FFmndTq/OpLM0XxpN23+NvX3k
	rvzNyk/Ix2v5yF00RI1qFlsc9dTKQpR8LFvynQirIiF4VputYST30RgA6XdzVqSSUt6a8s
	2iiF1F1w0w8Pbido+zsOeDFUWxrgVyU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=be41zlYX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107193;
	b=NX7dD2R8H3Cr0RIH7qC85gYNRLGjy4p6cp+Ax1qEp9bRJS8Bfl1ly9rtNBzUkHF2YviFn0
	VApikpPGqPE0XUNyqp9dnG5dO/N9u5181VJZY3dJt5mt6RLplumxFZpfWub3SGSzPVZVk+
	aI18rb6zs66MKL25uu3nTcD02wG84KU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45CA342A3A;
	Thu, 15 Oct 2026 23:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8B11F000C5;
	Thu, 15 Oct 2026 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107192;
	bh=yrooXPF1hhM/MoxFNqM1PlbQKoKP+pEqMYFgXl1fs10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=be41zlYXUQwD44Jok0NtpSZ7o7ilsOn6jKjPFtuvyJHNm3+kodNq4v40to+kjFRdj
	 ZARjFHoJQIv2iv98pPQxGx57CCiP5L6T4m5JO3TJJff1ic+46QKwKTTizNXPy5pr9W
	 GJ/VtgUSaQN4LqJPxmsPEoaLpOPjsR2pSDr3t6qkDhG+6it/oST3jJm+tlBxJQb/EX
	 khz2+kHpIpKpudb2QsVoD4d8AjDP0bZRXJ6shDv4HM4WgZ/J/qfyHneU5iUUHGFzme
	 ki/0SoGnV8vR0QbGGqEhw2j1yvbY0t2oE5EFuLsrhVKLy/vNaKMiTXi5CKK7yuKk38
	 Hpbrkzcv7z1aw==
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
Subject: [PATCH v4 01/10] NFSD: cut a misaligned direct-mode WRITE at page boundaries
Date: Thu, 15 Oct 2026 19:33:00 -0400
Message-ID: <20261015233309.42999-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17A7380006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: rqfkywpcuz1qfkx4d9pr8xzygxktfqyc
X-HE-Tag: 1792107192-250996
X-HE-Meta: U2FsdGVkX19l40n5J0nym1EUQXkP+zvprAgPaRHlGQW3b00hGrtzmMkQ9/R143836xuuTW1ok/7vIJE7WB9RWGZVcVaZm8kbCRXycf5nyzzQ1h9qimXNq42HhRDzajqk+w3uLvld/uYrzQHvAMnq+xhh5jKVPmGiEb7uY4V1xmIGDbjGVdAc5Ucs6brCCwF54Cafg0LcDvrbNA+9ln1aCJvC1nTyEdMUftrPyK+ZfsaSz7s6lD7h03G4EW0XttLq+uCI6ky33sxwDTgG9ZJ7c/rWwhaEyOBBeDe/PsXFg5FZ9JzTM9jSb2LNHqykKJ2lD37G2/NtUtX8pVVWFp+TomEIRTH6T+g72CLAEbbsdHeuYXk8xFgzU8uhfsHFkU/L9JRd/ic7PNdYxJVxqM2BQjrIVeC7eQoEovUtwqoRQxwTzb9wE2HCB4XaUvYtx8lFb85nLOtMXjmB8zUe9Y2w8VN4ns3WNuF+mu9XEl+m1MOWfZOVpUDLakROtkfmibIkZvNBd2Z8BEWMIN2hU4cXeJcqoRBOEyZ5Gh3Jp+3+dZiRMLoKGg6/k9ySzq5YrNQrrnkO1/bsCm+sh3VgsywZY1MJLntBLn85DeGBXMcjXRAC9qmhtTbFjnap5OWYR0aIro6T47gDJ1dKG6DGB1uBmC+pNyyVqkK+5pkck5Ld7jwscLjiIVm3YPcD8EYKFjAfYf8VutwJ4idiAI+DT8jfY1zForivYWwCBkb3vfN6Ib3uQC7Xrkeig3E7E9WO2spBXqlXDOmmdNeAGaR2hSqOjJw3kqkbcjd5IO4i3r2f8t94giq8APq4BAlzn7b9ImUgDLDR7owpxuvAdKWcj+k4CMYkQLsevU6GWX648YQ0jiDVr/3aGwm8mY7J/yMO0Og2PVWxlIhreCxOuPLjy+vScmgzaSOp3bltTaEMAMfT+3qqpHlAE2Mpezp9Ol3NLePQIWvDlOrasGTandOKnsb
 buXAhqJp
 Ve0C24DGfWqjHTHesoelk81pRLWBorhTGCaJzhL8luNLv9tfBRRsZtHHg+nqj65cLtud8dEf8mgpnBMonL+CkXH0DtFGBWETXEMH7ZDj8YHHpnGNdL8tkfmEVqmKxLd5FXe2f3YKzUjJ+WXUHZ6cB7eRyPQ2NMAUkp2JEXd/XyNRShwgcwCaUK9E9Z7byzddnn2zg9T1ZixdARuoOT9Zh5Loq6MwoljvsFLq3t8a5E9omkTGwzUtYjGt9E3fb338c8TIakaId9OOhb2VHxLGWY3f/r/cjIQEq+ijTc3tBxM/oYfwiJGpf5MakGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfsd_write_dio_iters_init() splits a misaligned direct-mode WRITE into a
direct middle and buffered ends so that as little of it as possible goes
through the page cache.  That only works if direct and buffered I/O never
meet inside a page: the direct middle invalidates the page cache over its
range, so a middle that starts or stops inside the page a buffered end
writes has that page dropped, and whichever of the two neighbouring
WRITEs comes second has to read it back from the device.

The middle was cut at the file system's direct I/O offset alignment:

	prefix_end = round_up(offset, offset_align);
	middle_end = round_down(orig_end, offset_align);

On 4 KiB pages over 4096-byte blocks that alignment is the page size,
the cut is a page boundary, and the problem cannot arise.  It is broken
wherever the page is larger than the alignment: 16 and 64 KiB pages over
4096-byte blocks, and 4 KiB pages over 512-byte blocks.  There a
misaligned WRITE costs a read per shared page on top of its three I/Os.

Cut each end of a WRITE on its own:

- an end that is already an offset_align multiple needs no buffered
  segment, and the middle starts or stops there, mid-page or not.  A
  WRITE aligned to the device stays entirely direct at every page size;
- a misaligned end needs a buffered segment whatever is done, and that
  segment now runs to the nearest page boundary inside the WRITE.

That is one rule: a misaligned end is cut at a multiple of the larger of
offset_align and PAGE_SIZE, which are both powers of two.

The segments still tile exactly the bytes of the WRITE: a buffered end
grows inward, at the middle's expense, never outward.  A misaligned WRITE
that holds no whole page has no middle and is issued as one buffered
segment.  Where the offset alignment is a page-size multiple nothing
changes.

nfsd-io-modes.rst said that DONTCACHE is not used for the misaligned
segments, which the write loop already contradicted: every segment
without IOCB_DIRECT gets IOCB_DONTCACHE when the file system supports
it.  Replace that sentence with one that says so, next to one that
describes the new cut.

Fixes: 06c5c97293e3 ("NFSD: Implement NFSD_IO_DIRECT for NFS WRITE")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 Documentation/filesystems/nfs/nfsd-io-modes.rst |  9 ++++++---
 fs/nfsd/vfs.c                                   | 13 +++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 0fd6e82478fe6..1916b2eee58ad 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -126,9 +126,12 @@ Misaligned WRITE:
     middle and end as needed. The large middle segment is DIO-aligned
     and the start and/or end are misaligned. Buffered IO is used for the
     misaligned segments and O_DIRECT is used for the middle DIO-aligned
-    segment. DONTCACHE buffered IO is _not_ used for the misaligned
-    segments because using normal buffered IO offers significant RMW
-    performance benefit when handling streaming misaligned WRITEs.
+    segment. A misaligned start or end segment runs to the nearest page
+    boundary inside the WRITE, not just to the nearest DIO-aligned
+    offset, so the O_DIRECT segment never shares a page with a buffered
+    one; a start or end that is already DIO-aligned gets no buffered
+    segment at all. If the filesystem supports FOP_DONTCACHE, the
+    misaligned segments are marked DONTCACHE.
 
 Tracing:
     The nfsd_read_direct trace event shows how NFSD expands any
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f4069da853725..ed5903c3becac 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1324,6 +1324,7 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	size_t prefix, middle, suffix;
 	loff_t offset = iocb->ki_pos;
 	unsigned int nsegs = 0;
+	u32 cut;
 
 	/*
 	 * Check if direct I/O is feasible for this write request.
@@ -1338,6 +1339,18 @@ nfsd_write_dio_iters_init(struct nfsd_file *nf, struct bio_vec *bvec,
 	orig_end = offset + total;
 	middle_end = round_down(orig_end, offset_align);
 
+	/*
+	 * The direct middle invalidates the page cache over its range, so it
+	 * must not share a page with a buffered end.  An aligned end needs no
+	 * buffered segment; a misaligned one is cut on a page boundary even
+	 * where the offset alignment is finer than a page.
+	 */
+	cut = max_t(u32, offset_align, PAGE_SIZE);
+	if (prefix_end != offset)
+		prefix_end = min(round_up(offset, cut), orig_end);
+	if (middle_end != orig_end)
+		middle_end = max(round_down(orig_end, cut), prefix_end);
+
 	prefix = prefix_end - offset;
 	middle = middle_end - prefix_end;
 	suffix = orig_end - middle_end;
-- 
2.52.0


