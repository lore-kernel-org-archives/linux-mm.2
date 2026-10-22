Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76DE606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 21:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PBRo7gdT
Received: by kanga.kvack.org (Postfix)
	id B0C246B09D1; Thu, 22 Oct 2026 17:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCCF6B09D2; Thu, 22 Oct 2026 17:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABD36B09D3; Thu, 22 Oct 2026 17:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 614146B09D1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5CDB1601F6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:38:23 +0000 (UTC)
X-FDA: 85351576086.17.2786CF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E5F1100006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:38:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBRo7gdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792705102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50yYjaY+y96cqwOxv67YA9yqjn2siKXdLV0ULyvr6yM=;
	b=TXzEcVLt5EpiiNqQUo4hesSfSs+HOt6xNp72iNvTFmmRXlPO7zG4DQNfCtfO3kOq92wZHm
	BXI21U5mpQGjn4w2rOWY2H3ZWIDexSVZcRTWPupmSOAX0WiGM3zfT294ttJMjjnzNtA50q
	6w3jmboKxeW+IWOlOhRkwFNS0IuKbp4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBRo7gdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792705102;
	b=STPvUT9MLe60Jgts9bOYOkweh5ydSvEdZfJhldXpJ7GQeAZ3EwT4r+0X80Aw6Axu0kjcnk
	U9oL9LEbJ1QieyUFxAMxDrCIIb80Y/uJybSKwXAJsb49GDdddJ+0e6Xzudk9xVJlNmsogL
	fFqsn+qWN1Fo4nr01+7tTzhKeVkvaVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AD8860200;
	Thu, 22 Oct 2026 21:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D6F1F01825;
	Thu, 22 Oct 2026 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792705101;
	bh=50yYjaY+y96cqwOxv67YA9yqjn2siKXdLV0ULyvr6yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PBRo7gdTqnIgoF150jineM85hgi4fjPmYFKIpfo9uOJ3lkItGY2msTBCZ/KMO/gJd
	 540aDBCg2Qy8Imwg5leZFDWqhK/IwgEYZAJ4IlaQ4yAWqyuh3Y8sJ4xWzOMt8yxPx8
	 uKUB1YmDavp37wgBX1ZlFbL3ZqOgVa9tzNb+sjjJ2ynEMuUqGeK3I4H3YHhupVmYbJ
	 tmn8flTmxnbuEALgeCiu4Dt2nhEL7ykZvjSzmIdQThmrnYSpQ6XyW/k2FKMJmAulfD
	 KGX5027pXdOKb7aNtIZ2cfDHqnAmTAcVQJv/hBvVSzAtzSZ0hrCxig+NCXi42nu7F4
	 6u5/9hr6xYOmw==
Date: Thu, 22 Oct 2026 17:38:20 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Mike Snitzer <snitzer@hammerspace.com>, Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 3/5] mm, iomap: keep a partly covered page until an
 uncached write completes it
Message-ID: <atqCTLf42kkGZmSd@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
 <20261020220346.28020-4-snitzer@kernel.org>
 <c3842f844845a0c461ed7a895cff3a6d3d3f74c0.camel@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3842f844845a0c461ed7a895cff3a6d3d3f74c0.camel@kernel.org>
X-Rspamd-Queue-Id: 3E5F1100006
X-Stat-Signature: 41a79181gztsyxxryte8e69c4xngw6nh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792705102-983645
X-HE-Meta: U2FsdGVkX1+U/iJ7DbeTP+gZwdrcU6FBHkAgBeqHdnXI9RlM1nsD4Vu0MqXMVCqK43gkClC6gGq3FKECP4TSj7YxjxiIEvF3nO7LjDj++tA8/uPziOo1VH2x0BHwIjbZrLQI5PsMc57ZnXIDNKjMNjfuua8PJX0LRfK0EMLmWq2wjsgBkQZyNDwYZo7v5eBkU+Zsnp4r8iV+a76WdQg3ghTcTaTc0pzGRQk6LAm7IyKFQeuBBzLj4NQihZ04NoY0mMAgHXJcqJ27/xfwCYsafcpfrJMNXFPg/J0okhAuwhPcHra36Nz0oe/JOTVJexhNunUSqyJEL5Zvr1KNwp2lA4x80nArKMlU7QfH32JcohMRi3Y0L2HBbRZWxeKglHO2PGwdOMg6TDJZNmIy+XBX3VAVmqPOiIMVfzZ4zgqWWibDYa2Ha1cCZmoDejl94274HU6bB45tfPoSDhyMst/4ItDUwMIf/z4Sx1L5gQaaTa752G0FDdfO/LcT5EhQFC4X3DoUM6mOTxhTdmkIQadB6MNPTfF2wSZHWYXohQBJRIas3l0f/Uy3KRSm4mLBzikiQgdKMz+h4/i/iu4SyEf3ttbK9xwfxMUoAgLCDGcaBpZDqF0mF+MpqJo98QHB187o96SE0Lckow/fSIadTLZCrro0sBtfj0SJRow9S5qWdvOD3vqTK6Z3RVD9HZGVmv8vhckx7Qn/Pfh6b0UIcNPmkyYgmjFwoafnu2mtfAugW2v84YjTlOtcdrXmiNkBd0trli84oBhm1kRqaNgFWVc822uCb2fgthB1523H4A00Ztbj0n+8t5jYWFiqm3RWsN0++ULpp+BHR9vuaSAtsHw8mDSyD2p/7SPx8dhZ0HYRRbGmpIrbfXbmdNdaiobcgqtIr1TUGnbMKKr1BVEhqdJHmhQ+mnikNhktWzqBZz48eIf8HhMrdWNKyel+N2l5exjGsucaTRMx7gjHww1j3uu
 xRfTMdLB
 Mv66ec9mLn3gadIZCNsRK64oaS3Nxr/ZJs6WyrWFhFT48uHiphVeuFkkphiIQeuK8ctJdqfoGV7I6Pl0Yrke4f9h92fBAQAVX+Qp11glexzclE05MHOx/jLhLS1LDMhQplvyDF2+aj8TLst7/RwD4wqHG/fgUcTu85aLOv1Yh9V/5eey/eruFMBSgOY4XajMhWVSvYW2cJhVd1X3eSfw95OuHJja8TjtLJfEWV3MPWRbqH0Po/tqJ3upg1F7GUkG6RiQwUBWUINDstN17oX80Xbk0RcuxyPrnT52ROlyjILOqZTF5zamGEl3cR+qlNMDeUFxgZ2kx8Q3gU7j/5xRIzc/IGjuW2rJTYPlF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:07AM -0400, Jeff Layton wrote:
> On Tue, 2026-10-20 at 18:03 -0400, Mike Snitzer wrote:
> > An uncached (RWF_DONTCACHE) buffered write marks drop-behind every folio
> > it creates, so writeback drops each one as soon as this write's data is
> > on disk.  A page the write covers only partly is usually shared with the
> > neighbouring write, the one that ends or starts in it.  Once the first
> > of the two has been written back, the page is gone, and the second has
> > to read the block back from disk before it can write its part: one read
> > per misaligned write.
> > 
> > Measured locally on XFS (emulated 4Kn NVMe, 4 KiB pages), 32 threads
> > writing interleaved records to one file with pwritev2(), 1 GiB per run,
> > before and after this patch:
> > 
> >   record  flags                     4 KiB device       MiB/s
> >   bytes                             reads per write
> >                                     before   after     before  after
> >   47008   RWF_DONTCACHE             0.97     0.000     831     2281
> >   47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.000     601     1227
> >   6000    RWF_DONTCACHE             0.97     0.000     121      488
> >   6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.000      90      206
> > 
> > Before this patch every write waited for its read, and because XFS holds
> > its IOLOCK exclusively across a buffered write, the other 31 writers
> > waited too: both record sizes ran at about 20 thousand writes a second,
> > one device read per write; after it nothing is read back.  With
> > RWF_DSYNC each write still waits for its own sync, so the gain is
> > smaller: the uncached write now runs as fast as the same write without
> > RWF_DONTCACHE, 1237 and 209 MiB/s against 1227 and 206 in the table.
> > Records of 49152 bytes, which cover only whole pages, read nothing
> > before or after.
> > 
> > NFSD DIRECT issues the misaligned ends of a WRITE as buffered uncached
> > segments and gains the same way.  Without any handling of the shared
> > page, 32 interleaved writers of 47008-byte records read 45144 blocks
> > for 45664 WRITEs; with this patch, and no NFSD code for the shared page,
> > 0.0001 to 0.0008 blocks per WRITE whether each record is sent as one
> > FILE_SYNC WRITE, as two one after the other, as two together, or as two
> > UNSTABLE.  The page cache then marks the completed page while it is
> > still dirty, so each segment of a stable WRITE wakes the DONTCACHE
> > writeback kick (23 to 65 thousand rounds a run); the next two patches
> > let NFSD mark it after its sync instead.
> > 
> > Let the write path say which pages a write covers only partly
> > (FGP_DONTCACHE_EDGE, set by iomap when the write starts inside a page or
> > ends before its end) and get such a page as a single page.  A folio
> > created for it is not marked, so writing back this write's part does not
> > drop it.  A folio found uptodate is the neighbour's, already written:
> > this write completes it, so mark it, under the folio lock and before its
> > own data goes in, and the writeback that cleans both writes' data drops
> > it.  The folio lock orders the two writes, so the second always finds
> > the first's data in place.
> > 
> > A page whose neighbour never writes, such as the last page of a file,
> > stays cached until reclaim.  A partly covered page another task had
> > cached and that is uptodate is now dropped after the write's writeback,
> > where before an uncached write never dropped a page it did not create.
> > 
> > Only iomap file systems say which pages a write covers partly so far;
> > write_begin_get_folio() users such as ext4 and the NFS client do not.
> > With blocks smaller than a page, a write that crosses an extent boundary
> > inside a page asks for it as two partly covered halves, so the page,
> > though one write covers it whole, stays cached until reclaim.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > ---
> >  fs/iomap/buffered-io.c  | 12 +++++++++++-
> >  include/linux/pagemap.h |  5 +++++
> >  mm/filemap.c            | 19 ++++++++++++++++++-
> >  3 files changed, 34 insertions(+), 2 deletions(-)
> > 
> 
> The nfsd case typically uses buffered or DONTCACHE for the unaligned
> sub-page-sized "ends" when direct is in force, so mostly these ends get
> submitted as small (< PAGE_SIZE or folio_size()) buffered I/Os.

Yes.
 
> Why do we need this special casing instead of just making those
> unaligned ends use regular buffered I/O? Isn't it basically the same
> thing?

No.

For the first of the two writes that share a page it is the same
thing: 3/5 gets that page as a single page and doesn't mark it
drop-behind, just as a regular buffered write wouldn't.  The
difference is what happens after the second write completes the page.
With regular buffered I/O the page stays cached until reclaim; with
3/5 the second write marks it, and the writeback that cleans both
writes' data drops it.

That difference is the point of NFSD DIRECT: each misaligned WRITE
leaves one shared page behind, so with buffered ends the page cache
grows by about a page per WRITE and nothing ever reads it.  We
measured exactly the alternative you describe, with NFSD's
direct_misaligned_dontcache knob, on IOR-hard (47008-byte O_DIRECT
records, 192 ranks on 3 clients, 4 NFS servers, XFS on NVMe, 240 s):

  ends written as                write MiB/s  device reads  page cache
                                              per record    growth
  regular buffered               35,140       0.000         +653.7 GiB
  DONTCACHE, the shared page     34,463       0.015         +10.7 GiB
  kept until completed

Same rate, and neither reads back, but buffered ends filled ~650 GiB of
page cache in four minutes (about one 4 KiB page per 47008-byte record,
8.7% of everything written), which a longer run turns into reclaim.
The second row is an NFSD-only version of this (the shared page
claimed in nfsd itself); Chuck asked for it to live in mm, which is
patches 3/5 to 5/5 of this series -- which yields even less "device
reads per record" than the 0.015 result above (again, because mm is
the proper place for these changes, less unqualified work by NFSD).

And it isn't only NFSD's: any RWF_DONTCACHE writer whose writes share
pages reads each one back today (0.97 reads per write in the cover
letter's pwritev2() table, 831 -> 2281 MiB/s with 3/5), because
writeback drops the page after the first of the two writes.  Making
those writes use regular buffered I/O isn't an option for an
application that asked for RWF_DONTCACHE.

Thanks,
Mike

