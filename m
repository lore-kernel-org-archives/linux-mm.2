Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86027606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9snoCww
Received: by kanga.kvack.org (Postfix)
	id 3E76B6B05B5; Mon, 16 Nov 2026 15:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398D76B05B6; Mon, 16 Nov 2026 15:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE026B05B7; Mon, 16 Nov 2026 15:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035AD6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:47:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AB2CA773D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:47:52 +0000 (UTC)
X-FDA: 85442168784.13.105BC1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0391640002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:47:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9snoCww;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLiavxsDlBfdXBPQBNGT2FAhIOzho6noIQxZvnyUpp0=;
	b=nXKxPeCg+rwG5uH3V/RTXdteMdI484Q98Mxmck6KZ3Jp4sZALtTL1pcRrLOw7bm6w3K6l2
	caSBDT/Ft86jxF3T2KD7c6tiUyzCkjhST7iRyDGZmjEr9C1X4qQkwq2FUfN3TudYYQnKKc
	yZofk6klhbzsERXohjSBSQjF17636zk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9snoCww;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862071;
	b=bIW1CvLBB1O5y7TjDOKe1ic6DMpcGJqLt32O1xIUE1kH5oWX2nAACOgqhAIsaEUxujML/X
	EnDvj/59eSd8iPLo8e88GSrWaBCIQ5fLNUJEHal7hcxPrDwfgpoIYBHjOEGSHZW8J66Age
	rE3UxMgFxQQNt2rlpmr2KTNYqEIte24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8826E630C4;
	Mon, 16 Nov 2026 20:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B241F000C4;
	Mon, 16 Nov 2026 20:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794862070;
	bh=OLiavxsDlBfdXBPQBNGT2FAhIOzho6noIQxZvnyUpp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q9snoCwwFCt1j8KTTj8fxvYElH/dBOlVcv7MgV+Vsx0xrnhaLBNPgFda6Sl8iQiBf
	 O9hNoPUTQMtR6CR7dyuIOc5Jfnhtao/pTx3wZ60Kjf6GM0JBpKzfh6xzmhTU+awkjy
	 N4sDv8gOJ0H59T/m+tZOfiMeRlwzfFcQckc6rBRYDcnycoaMEnAnzhui3UXMqBtUoS
	 9om4jA2rVPNbG7WfTwYdLYjVSoahFM36S1bjAG5zzn4XcrxTPrvAjfZ22wlNdcqFEO
	 yTDsDapCyAEuzkv//R6BGTvos7MaD5HQCkNP3EijpujpGTaEHGJTX3Ys8kN+UurRbW
	 ZjQ66SvnnKpgA==
Date: Mon, 16 Nov 2026 15:47:49 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v12 0/7] mm, iomap, NFSD: stop DONTCACHE writes reading
 back shared pages
Message-ID: <avtr9YaUNyjGHk4h@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
 <iushs6l3mjqkq65srej4gevaf2oeazy5j5miaipy6yxscetzjd@d4ti4qgbhman>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iushs6l3mjqkq65srej4gevaf2oeazy5j5miaipy6yxscetzjd@d4ti4qgbhman>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0391640002
X-Stat-Signature: wgorqxigfuko4ncc5dhbwraszmnjzzd7
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794862070-857998
X-HE-Meta: U2FsdGVkX1+hygXIZ8WkHCZ1yqvWnJWVVCceKrbgDv2i9fuj5ZqRsiAPC1YZ8vaT4ANlipNUMDuVL4LsEoRbFkbU+Vm3gpDsBZsVtw9FgvL4bThFsujx5+phvi50HVarmFIsGVYtFNbRursg5Hx6rdl5RDhmDFjz7mTe7WgBQJwywlwqI3v28XR7twFC6AfS4tf0XquOn3z1M95wdgxFRFCnqVTTCNIMZ7Ln5BZvBcsy3sXGvSnIWIFhNA8fTHYVb3ca6HROLleuOsmTTdqgfGmbGuor4l5h4hEM6ZQ869z0UmvdNn56+8Q1a801mT9/Rui13TQ8Xa8GhFL4GpMCdCG8/qVFoHPhAXSVfC0fxXNM/K/cCWw7x0AUiA2wapvxFWIrnOTvk8GDm059eL3726umRZYBgFznAP4qwyGJA8x8mfYbf5qGds3tFZxTbYV/pqpxrdGhVqgnpeDHsrqYelpqw/J+qAUt60YIJgMdlC6KdiFpUUJNBKFUZ3KHKaW/ejuKhARMCafturj+XRjBPoN3dHJJ9rWU9lCsn7aWvJLpg970A0rVobmICk2CtU1bzj6eqXknF0FXLsa5NsjPLdYGStWtVa0Zwcmyh3q0JVdlLyaK2Hz59itRyDjTweIfE+dUPnEle6HS94PMhCYiLUnpd6aVmymC2omEkkBQXoKSKfVUYrMSe1UqGz02jI22qyIDTjuI2sOqzloIJH9a/RRItux3/HE0eYOlDQ0qM74qnLdl+sosUdfz3eoorBVTghlOomSg3ipumPoEz3GkOhygyZ0xclNVN4qtD5naY0/X+soiAyvPxrAJtmOKia1Lt2yc6O8Xp6wwz7GfdW6y0bIkekAKiI9Smo+LUu8adnB3z1PjGNDQHR/5tJMCu5eEk3LAsUS+lupRnXyfU/cAduf1c1un9gTsTCH6E5UUjXWta0oM1U46euFAENNIlOoFFJ7zkgjmZfN6XGCdMYb
 PdusSM56
 AQ618fnPIfECzXMYeL6flNaWHqqOnXbQg/DiZdLGyMTEtlF4SepqBzEzFEsumKlMTOCKXsR5hVGODrN2RBhCjAzxfjU7v9alyYy+77aKNwGCyLZnKsTV4E8BC5XyKIM59lOlzNkkPw6EcV9VqQjDgczfAXmWAYNokni54rHCtDn96+4rHl2IGSNS9jXtk6Z5P5nBE2CxTTB33GaL036iw30UQLZdQiFBiellYsQstxB/aKsYJHMNfnP88OGTcqrIUUp0/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:02:20PM +0100, Jan Kara wrote:
> Hi!
> 
> On Thu 12-11-26 14:09:03, Mike Snitzer wrote:
> > An RWF_DONTCACHE write is buffered IO: its data goes through the page
> > cache, and writeback drops each folio once the folio is written back.
> > A write that starts or ends inside a folio covers that folio only
> > partially.  Usually another write covers the rest of the folio.  If
> > writeback drops the folio before the other write writes its part, the
> > other write must first read the folio back from disk.  32 threads
> > writing interleaved records to one XFS file, 4 KiB pages, before and
> > after 5/7:
> > 
> >   record  pwritev2() flags          4 KiB device       MiB/s
> >   bytes                             reads per write
> >                                     before   after     before  after
> >   47008   RWF_DONTCACHE             0.97     0.0005    831     2281
> >   47008   RWF_DONTCACHE|RWF_DSYNC   0.99     0.0005    601     1227
> >   6000    RWF_DONTCACHE             0.97     0.0001    121      488
> >   6000    RWF_DONTCACHE|RWF_DSYNC   0.99     0.0002     90      206
> > 
> > 47008 bytes is the transfer size of IO500's ior-hard, in which each
> > rank writes interleaved records to one shared file.  Any record size
> > that is not a multiple of the page size has the same problem.  6000
> > bytes is a second example.
> 
> OK, I understand the problem but frankly I hate the complexity this
> introduces. Patches 1-3 are good improvements, patch 4 is OK but 5 & 6 look
> too complex for too niche usecase to me. I didn't really pay attention to
> previous revisions of this patch set so I'm sorry if this was discussed but
> can't we just make iomap for unaligned RWF_DONTCACHE write ask for
> minimum-sized folios for the partial edges without FGP_DONTCACHE and
> use FGP_DONTCACHE only for folios fully within write? That will also solve
> the problem with the following write having to read again from the disk and
> it will be much simpler. Sure the edge folios will not be dropped after IO
> completion which may have smaller or larger effect (depending on the
> overall write size) but I'd say that's the cost of userspace making life
> hard for the kernel :-p

Thanks for looking, Jan.

On complexity: 5/7 and 6/7 add almost nothing to the fast path.  The
new code runs only at a partial edge.  Aligned IO, and IO that is not
RWF_DONTCACHE, pays for it with a few flag tests:

- IO that is not RWF_DONTCACHE (buffered, direct, reads): every new
  branch is behind IOMAP_DONTCACHE or FGP_DONTCACHE.  The cost is one
  flag test in the found-folio path of __filemap_get_folio(), one when
  a folio is created, and one per write call in
  iomap_file_buffered_write().
- An aligned RWF_DONTCACHE write: iomap_get_folio() tests whether the
  folio is partially covered, which is a mask and two compares per
  folio.  The test is false, so FGP_DONTCACHE_EDGE is not set, and the
  folio is created and marked dropbehind as before.
- No new locks, atomics, allocations, page flags or per-file state.
  The state of an edge is the uptodate state that the folio already
  has.  Writeback and reads do not change.
- folio_dontcache_edge_written() and the two 6/7 helpers run only at a
  partial edge, or for a caller that asks for IOCB_DONTCACHE_DEFER
  (NFSD).

So the complexity is all in the misaligned case, which needs it.  I'd
argue that if the kernel (MM) can handle userspace making life hard it
should, within reason.  I think my patchset nicely isolates the
complexity to userspace that makes life difficult.

The first part of what you describe is what 5/7 already does.  iomap
asks for a minimum-sized folio at each partial edge, and a new edge
folio is not marked dropbehind.  5/7 adds one more step: the write that
completes an edge marks it, so the writeback that cleans it drops it.

Without that step, every edge stays cached until reclaim.  For this
workload, that is a large part of what the writes put in the page
cache:

- With 4 KiB pages, each record leaves about one page cached.  Through
  LOCALIO with cached edges, 8.6% of the data stayed resident with
  47008-byte records, and 66% with 6000-byte records.  When the write
  that completes an edge drops it, 0% stayed resident.
- With 64 KiB pages, a 47008-byte record never covers a whole folio.
  So no folio is ever marked, and RWF_DONTCACHE caches as much as a
  normal buffered write.
- Jon Flynn measured cached edges through NFSD on four pNFS data servers
  with ior-hard.  The page cache grew by 622 GiB in a 318 s write phase.
  With this series it grew by 2.9 GiB.

So for this misaligned workload, cached edges keep from 9% to all of the
written data in the page cache, depending on the record size and the
page size. The reads stop, but the page cache fills until reclaim runs.

6/7 does not change what is cached.  A caller that syncs its own write
(NFSD, for a FILE_SYNC WRITE) uses it to mark the shared folios after
its sync.  Without it, each segment wakes the DONTCACHE writeback kick
for pages that the sync then writes.

Mike

