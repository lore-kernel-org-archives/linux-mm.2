Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741C4606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IT2x62J6
Received: by kanga.kvack.org (Postfix)
	id 8E17A6B00EF; Wed,  4 Nov 2026 12:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8A26B05B6; Wed,  4 Nov 2026 12:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CEB76B05B9; Wed,  4 Nov 2026 12:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 540656B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:01:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E54091607E7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:01:50 +0000 (UTC)
X-FDA: 85398053580.28.6095E59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 202F18000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:01:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IT2x62J6;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811709;
	b=ouLOUA50/QlgGeZFYezMFPwt+Mmqv/bk5XWfwpwsoMzh4SVO0HqqqxxQrYjuFH2mqWLhDx
	mV73Zmt7fj/XAiPOIb0oxm/i+452yQvFlv6/YcuotJ5dmRmdFD8ML6d+l9pimrV4Ss5Bdg
	+LWFwNMjzfXWylaNhO+6EwGX9R0Hwxw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IT2x62J6;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkCHVhZioJ1wdZN6npY2hfrvWb9kbC3wPalZmZ3BoVA=;
	b=qcD6LA/QTNvIZYmyGA8o+S8HfLeBDwZrK6WhUfiW0f3UEQDZkZRxOZ9hrS1v5Ajv1LJTbo
	xv2RDgHB6XLyiRvvrjkeUpT5WDdbQ4IRDKTxfgJWZK4uMwFWJcnJlSqO7PDkxxh4iLWrqT
	WLRkTjyoWuy3KB8Js/6q0zHXBNNDUOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4759942A91;
	Wed,  4 Nov 2026 17:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6B91F000C1;
	Wed,  4 Nov 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811708;
	bh=jkCHVhZioJ1wdZN6npY2hfrvWb9kbC3wPalZmZ3BoVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IT2x62J6jn/yfd+OqmhV0T8VN/l364Oj0rtzzElfoSBg5AlI2P5CKcGHPitytOUdB
	 rCMPOzw6jrqFs2RRAsbUrEFz0z7dCmzAo7iAbPX7yMi76pnu0twc0lzcE00PeLaNU1
	 7MeoRZ0ppZpFPXYztbMrcPhjKkDVFz1bx3XsDbcjpguZ59obJbd3Bh5HNxVxh7wXJj
	 ixi0MMwXpoT534c0m/y5CKXBd64MLxm/fo6C8yso6Yih31nWU0nueRk4Gp9PCcknyW
	 IJK4aGSV8dvWYKe0JSt/gc6eY0wF30rE0OZrCl9YV5fP6+DeU7pkN+6UV6uqrUunc9
	 l+HHO6sjCrTxw==
Date: Wed, 4 Nov 2026 12:01:46 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v10 7/7] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Message-ID: <autk-osSQ8l2LKz1@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-8-snitzer@kernel.org>
 <20261104091543.GA31130@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104091543.GA31130@lst.de>
X-Stat-Signature: 9dnh1d38w5pjktkfkygf78qd33bngggz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 202F18000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793811708-993777
X-HE-Meta: U2FsdGVkX1+mqHvp7HOj4LAKTArZa1a4WrBLp0Atxk/7nY0c7nVkSs+AjdhvimUYAaS1WjmSSWNy7cE0r8RSiQnBwlqhZCosRDK86Aof03uzE+t0FgMWJFOC3mJvknrZ/S2e1p+HOjKZ2tTNqLiS4643AwrC0pyu86iaJmhMmjYIa3wnwIym48gyLKsFwISh2fXfPn1+LGoW+KdAYSojRezFYOyg2QK98JfLCrdOL/du41fVMrg+kZZJ1G5UySrwxrC+NYEyzB2L5cCKsnkAyBypwBxieQeOdEFSWXeahUQHASR+g8Z6aiEU+7PcNwOKzDtNSddcAqdBGgXKRZkCcnK63fQ/tQ1YAiP7rA1kF4KHoyFXIh2DdtT7g69xGyMg1uXbznmiG5MjzYzrlxaptWd/EapT/nJSXso17BnkJDyNVWLpHIc2t7C/fOFrShck6MP4g1uSGaVHIZRquiFVURhjJv33BQPA9XFS2wjsKAf/ZQ19/zfRCSZY7g4v8yVK7IUvMpYsBT3rFEqNC2ALDJZKQo1ySjKlgzjCtcZ/4lNVhiE3YAVh373sbpMUVlhICGoOaoDjbYzfhMMihcFDb9z+C0JEYkx6GGe2Xdgq9b6ZgkENCt5fYT1u381YGg4CS4yawVKphzBmbDI8ZEezMBEzvRrFeB+LoWdIr9vtcRQy90nxQ2iIY9ox1RWlTznNYb29wmU2oIbiSUDXkJmmxp34uLjgHltIrexRnMxH7KOA/Vy6XUu68wBtuTdEPOLWIYSKCgOYJwhleXlPIVuNHfp8xKDKOf7GsYNrllFjO0XhqkUMfSzXdHci3SNaDub9JhCQGrRdtG58M8Cnvx9d5ycDgTtqHBdD2pF72Cy3kYM5mt9XOQ2CysZK+ecm0ZDPIGSDlztX7waWZi5IEe4sAuSZ/vH9YRd0WKEEFnz7c7YGnOrtz0HO7g9SJ2cUcLEfENO07bsReE2Kn5Upk8N
 FUFocd77
 3MW+HCHgj4728PulWdIzA4gbDg62XysTpOipy3tCBmZyh8MDvXJt6ImUSEkMT24CiAbihFwBTmOH++R8gHw4yaPTm7EAro+CZbbDZ4JEFpkcGvm0M4/UVlW9KiahnoF4oqpaLNe9JCFcHZFavxSCACgURmNNsICVTgIZK9UMZPDkddckdB6WGvajKGPxHR37Soasy9cJT9YEAU9xbcRgqFUmmXMIlIts/mHZeQ2Ndk9hmgVUplXp1z2ktdUGqbZccOuwyiPaa3hyFloYWCksvodImiqJYln/V4aap7lUdqy7RCOABlTGb31ghu9vy1qBD0Q5OiTHFo3mp8iQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:15:43AM +0100, Christoph Hellwig wrote:
> Why does the write include an fsync?  Are these STABLE writes, and
> if yes, why?

Only when the client asks for it.  A WRITE with stable_how FILE_SYNC or
DATA_SYNC must be on stable storage before NFSD replies.  So NFSD runs
one vfs_fsync_range() over the whole WRITE after all of its segments.
An UNSTABLE WRITE has no fsync.  Its shared units are completed while
still dirty, and the writeback that cleans them drops them, whether the
flusher or the client's COMMIT starts it.

The Linux client sends an O_DIRECT write that fits in one WRITE as
FILE_SYNC (FLUSH_COND_STABLE in nfs_pgio_rpcsetup()).  That is the
common case for the workload below.

> Can you explain where this very odd number comes from.  Is that just a
> worst case?  Or for some reason actually relevant?

It is the transfer size of IO500's ior-hard: every rank writes
47008-byte records, interleaved with the other ranks, into one shared
file, with O_DIRECT.  It is meant as a hard case, and it is the
workload that showed the problem on our servers.  The same happens
with any record size that is not a multiple of the page size.  The
cover letter also has 6000-byte records.

> How does this compare to just not using DONTCACHE at all for unaligned
> tails (and maybe heads, if for some reason they I/O you care about
> reordered writes).

Jon measured that on four pNFS flexfiles data servers with ior-hard
from three clients.  In one run, cached heads and tails removed the
reads, 0.000 per record.  But the page cache on the four servers grew
by 622 GiB during a 318 s write phase.  In a later run of the same
workload with this series, it grew by 2.9 GiB, at 0.003 reads per
record.  Keeping the data out of the server's page cache is the point
of direct mode, so cached ends are not a fix for this case.  Using
buffered heads and tails are available (in cel/nfsd-testing): set the
NFSD debugfs knob /sys/kernel/debug/nfsd/direct_misaligned_dontcache
to N.

> And how does it compare to that plus manual
> sync_file_range calls to micro-manage the I/O?

Wasn't measured because sync_file_range() writes the folio back but
leaves it cached.  To get it out of the cache, NFSD would have to drop
it after writeback.  That is only safe once the neighbouring WRITE has
written its part of the folio.  Otherwise the neighbour reads it back
from disk, which is the problem in the first place. NFSD does not know
when that is without tracking the half-written folios of every file
itself.  An earlier version of NFSD kept one tail folio per open file
for the next sequential WRITE.  With interleaved writers the next
WRITE is rarely the neighbour, and it still read 0.81 blocks per
record.  The folio's uptodate state already records whether the
neighbour has written its part, and 5/7 uses that.

> In general I'm not in favour of so many core hacks for
> very nfsd-specific behavior.

Most of the series is not NFSD-specific.  1/7 to 5/7 fix RWF_DONTCACHE
itself, for any application.  The table in the cover letter is plain
pwritev2() on a local XFS file, with no NFSD.  It reads 0.97 blocks per
write at 831 MiB/s before 5/7, and 0.0005 at 2281 MiB/s after it.  2/7
also fixes a bug in v7.3 on its own.

Only 6/7 is for callers that sync once after writing several segments,
which is what NFSD does for a stable WRITE.  The NFS client's LOCALIO
path does the same.  Without 6/7, each stable WRITE wakes the
DONTCACHE writeback kick once per segment, 23,000 to 65,000 times a
run, for folios that its own fsync is about to write.

Thanks,
Mike

