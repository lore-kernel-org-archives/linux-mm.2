Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA1AFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB406B0088; Sun,  3 May 2026 14:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CA06B008A; Sun,  3 May 2026 14:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723EF6B008C; Sun,  3 May 2026 14:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 602096B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:41:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 082F4160964
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:41:36 +0000 (UTC)
X-FDA: 84726976992.04.48CECE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5555B4000F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:41:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UbFRXW0j;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777833694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veKF5kfrCp7BXvyFOwzCPvxpVY7rrMuV5tADquMab6o=;
	b=zTvDfA5ERRFoIvUfC2jtopmHE8r3o65uGHpCn4sSg6ZZDw7L/G0sYgHJUI8ZgQ65Cja9K6
	pjY9RWEmFbEAPw7sfJL/OvVdOaUv9FBoTQ776CK0SH7AsEZtcpvsvXdFLj0cgJTuYKMokc
	C+6weGQdFbiL5BETy8YYLZEACean/Aw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UbFRXW0j;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777833694; a=rsa-sha256;
	cv=none;
	b=FsyAx8cCazyUfMlM4qOZEobR68cFQR7FtFvrIRI5qfGVMkYp5XY6z50GNIZRReoOFlgIdc
	yrfAj/YVo73bBrt4iR9jQ14sHykSWLk6lUNVu+8zSSDvLl6385+EKbFH/BhQjp/UQuIKQ2
	SSDnglAJV0H5XXkb9k4SVCecK4WTjzs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E52860008;
	Sun,  3 May 2026 18:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CA0C2BCB4;
	Sun,  3 May 2026 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777833693;
	bh=vgELmPGv0ejDx+rBC6rv02xJDSy6NaM+0xejX18ULhQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=UbFRXW0jwghfQEq7bGe33xnAR+3XoLtEJYQE2Dhzgz6JUuo2Ahocggd8xX+yTfigv
	 DyWSXPq/HGQ8QUx3hjAy3YYZFmXjbL/b+XRGRh8/Ni8X7yPmHW7/sxCbdhffTTtEI0
	 NEtelalzlQZ61vvxklNdpnE/iL/4+hxmJ1P/1jWFz7RP1HKAieF5I5VRxhNfEWQnDp
	 uL79Nvghs3eCHVGROr32/OOsv4PXH7fOVPlm4WqzhOpGb/ak7qwnkI3O5iElmrJ1XL
	 marTVaD2y+UeYew1FUDatNo7PpU20MPOgSM29vtwc5WOp0urqpgzRT6K1Zx6vs+3OE
	 /YxEqNbCri5fA==
Message-ID: <d12b162648d8d2aef521439b672e5624f95c728d.camel@kernel.org>
Subject: Re: [PATCH v4 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
From: Jeff Layton <jlayton@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka	 <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Mike Snitzer	 <snitzer@kernel.org>, Jens Axboe
 <axboe@kernel.dk>, Ritesh Harjani	 <ritesh.list@gmail.com>, Chuck Lever
 <chuck.lever@oracle.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Date: Sun, 03 May 2026 20:41:24 +0200
In-Reply-To: <oykxd436yv47u2yojrwrp3qdtzekq63hanezs6bwlovot6il2a@266nl5oqnnam>
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
	 <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
	 <oykxd436yv47u2yojrwrp3qdtzekq63hanezs6bwlovot6il2a@266nl5oqnnam>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: pp7q8ti9ff5hudauzs9mwezc741otm6o
X-Rspamd-Queue-Id: 5555B4000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777833694-966405
X-HE-Meta: U2FsdGVkX1/smI8J8B1JJsgkQkFBnTaNeHPknEAtk728NBG5xPhrx7QAL24Wo9rGFf+SZdqerMANvzXv7qp/+niDgFG18luMo1tmmsIzyERKtMvJq5HhKKgWgK5vkqPLJrwLDUTdtvz/0qnwTv+m2QTQ6tKfJV+cNygJeFRXScmkd5sRKPCPZyeqj4PzHqpwkPD5JHPsZAJk0HpKBidE20LG9bj9WSNck0K2OHEIvDJbbe4opZpd6H+EsP9rkRdSSEOxCssDvc4tT/tOey7u3yZZYakzdW3k872rWz8U+0s7Y5HWXHokHB7hiFPUSuBQL8e9q4BimOge14SkxMPbNpQUqyoOlgE1wUDkL+PqlkNz0Fu/a2FOovPONtOwS4ZturEcKb4lG/dyWD3Jp1S6lixrbQSb3LvJdllnRRehJiRZM2sEecKgH1IybDZFUEJ9DYVu/ISty7cDS46zJvqNBIrVUsJjuG+Y+Pk0bb0zJm18SSau0dDXR775ZVpwA9R3Thu2KGljClzoBhgdP4ftolEnkT/V3JMia15EMXnD9dQY54wHjsD+n0YQJDYq9rGPVI/bDtbIJb1Aa2ehnMK/KXM5paarMrWyzW34P9Pj670WclMHuRdVF+NjJvngRAZo7OnH12ARfFv9GZkTayou6zrJoT+VmUPXiZGnur11M7fJiW3lAtO7gQ47oRXFw25aMU6SCWhcncXV41RtHoFBQhsrBVhLeI0fuAHXMIQIh07PYr3qbuphEY+x5XIRfUqP2vjUBy1bbLyRqe/9LBFsSoG9GMVeT6oQZT811q0S24lRAM2d9nypG96AXYMl6dYwGQwhbZqxsFqNt6Tah0b2iiE7rPC8Zzpd12f/A9bljRJ9aS3FfqNmis/N3CiC7EKyy2SMGK1eP73AX5dHLOia2WNweD8abLNc1ZZOAUpVt7nTi2fWrzIpJX1XnWV6pdzQ5347Pvoc9FSggpc1Rku
 6RMiKzKz
 Go0K+coYKH4CAR+FL9p3ZZrVNEM/WNxoEG//lZ2LCBHw2Fz97QdpHD63v8/bUnwZn8VYy9wBlIwEzgaWmGL5Vq09ugN8tGzohL8g2us6BwCVF4tzCFYpxmPB4eLcwCe9YkQT/yELTKHDc6oGmV+ReO7T80SlmFzAya2RtAG06KAAUY9rlsgkayLXex5mXYrJ5McJO21kAqHUPpefzfhqnUN4o8meeQYwVMmQvDcQbmPLZd61VeKKKoWZdt2aGWkYbL2Bcz/l7CxS9kKbMMxRaevXdeMmcdWMkqLIlt3JTkIx2dvvxbpeJ6gorOiKvw70eNLfhHuloWu2qN6a+hFpOTxdkSTOMsALFO91i3gHzYedfAII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-05-03 at 16:45 +0200, Jan Kara wrote:
> On Fri 01-05-26 10:49:36, Jeff Layton wrote:
> > The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> > filemap_flush_range() on every write, submitting writeback inline in
> > the writer's context.  Perf lock contention profiling shows the
> > performance problem is not lock contention but the writeback submission
> > work itself =E2=80=94 walking the page tree and submitting I/O blocks t=
he writer
> > for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> > (dontcache).
> >=20
> > Replace the inline filemap_flush_range() call with a flusher kick that
> > drains dirty pages in the background.  This moves writeback submission
> > completely off the writer's hot path.
> >=20
> > To avoid flushing unrelated buffered dirty data, add a dedicated
> > WB_start_dontcache bit and wb_check_start_dontcache() handler that uses
> > the per-wb WB_DONTCACHE_DIRTY counter to determine how many pages to
> > write back.  The flusher writes back that many pages from the oldest di=
rty
> > inodes (not restricted to dontcache-specific inodes). This helps
> > preserve I/O batching while limiting the scope of expedited writeback.
> >=20
> > Like WB_start_all, the WB_start_dontcache bit coalesces multiple
> > DONTCACHE writes into a single flusher wakeup without per-write
> > allocations.
> >=20
> > Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
> > visibility, and target the correct cgroup writeback domain via
> > unlocked_inode_to_wb_begin().
> >=20
> > dontcache-bench results (same host, T6F_SKL_1920GBF, 251 GiB RAM,
> > xfs on NVMe, fio io_uring):
> >=20
> > Buffered and direct I/O paths are unaffected by this patchset. All
> > improvements are confined to the dontcache path:
> >=20
> > Single-stream throughput (MB/s):
> >                         Before    After    Change
> >   seq-write/dontcache      298      897    +201%
> >   rand-write/dontcache     131      236     +80%
> >=20
> > Tail latency improvements (seq-write/dontcache):
> >   p99:    135,266 us  ->  23,986 us   (-82%)
> >   p99.9: 8,925,479 us ->  28,443 us   (-99.7%)
> >=20
> > Multi-writer (4 jobs, sequential write):
> >                                 Before    After    Change
> >   dontcache aggregate (MB/s)     2,529    4,532     +79%
> >   dontcache p99 (us)             8,553    1,002     -88%
> >   dontcache p99.9 (us)         109,314    1,057     -99%
> >=20
> >   Dontcache multi-writer throughput now matches buffered (4,532 vs
> >   4,616 MB/s).
> >=20
> > 32-file write (Axboe test):
> >                                 Before    After    Change
> >   dontcache aggregate (MB/s)     1,548    3,499    +126%
> >   dontcache p99 (us)            10,170      602     -94%
> >   Peak dirty pages (MB)          1,837      213     -88%
> >=20
> >   Dontcache now reaches 81% of buffered throughput (was 35%).
> >=20
> > Competing writers (dontcache vs buffered, separate files):
> >                                 Before    After
> >   buffered writer                  868      433 MB/s
> >   dontcache writer                 415      433 MB/s
> >   Aggregate                      1,284      866 MB/s
> >=20
> >   Previously the buffered writer starved the dontcache writer 2:1.
> >   With per-bdi_writeback tracking, both writers now receive equal
> >   bandwidth. The aggregate matches the buffered-vs-buffered baseline
> >   (863 MB/s), indicating fair sharing regardless of I/O mode.
> >=20
> >   The dontcache writer's p99.9 latency collapsed from 119 ms to
> >   33 ms (-73%), eliminating the severe periodic stalls seen in the
> >   baseline. Both writers now share identical latency profiles,
> >   matching the buffered-vs-buffered pattern.
> >=20
> > The per-bdi_writeback dirty tracking dramatically reduces peak dirty
> > pages in dontcache workloads, with the 32-file test dropping from
> > 1.8 GB to 213 MB. Dontcache sequential write throughput triples and
> > multi-writer throughput reaches parity with buffered I/O, with tail
> > latencies collapsing by 1-2 orders of magnitude.
> >=20
> > Assisted-by: Claude:claude-opus-4-6
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>=20
> Nice and looks good to me now. Feel free to add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
>=20
> One nit below:
>=20
> > +/**
> > + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE =
writes
> > + * @mapping:	address_space that was just written to
> > + *
> > + * Kick the writeback flusher thread to expedite writeback of dontcach=
e
> > + * dirty pages.  Uses a dedicated WB_start_dontcache bit so that only
> > + * pages tracked by WB_DONTCACHE_DIRTY are written back, rather than
> > + * flushing the entire BDI's dirty pages.
>=20
> This comment is a bit confusing as in fact we write arbitrary dirty pages=
.
> It is only the amount of pages that is influenced by WB_DONTCACHE_DIRTY. =
So
> I'd rephrase the last sentence like: We queue writeback for the inode's w=
b
> for as many pages as there are dontcache pages but we don't restrict
> writeback to dontcache pages only. This significantly improves performanc=
e
> over either writing all wb's pages or writing only dontcache pages.
> Although it doesn't guarantee quick writeback and reclaim of dontcache
> pages it keeps the amount of dirty pages in check and over longer term
> dontcache pages get written and reclaimed by background writeback even wi=
th
> this rough heuristic.
>=20
> 								Honza
>=20

I'll add that. Thanks for the suggestion and review!
--=20
Jeff Layton <jlayton@kernel.org>

