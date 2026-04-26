Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67867FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 14:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C189B6B008A; Sun, 26 Apr 2026 10:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF60B6B008C; Sun, 26 Apr 2026 10:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8936B0092; Sun, 26 Apr 2026 10:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1FA6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:05:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A6DE1A0596
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:05:51 +0000 (UTC)
X-FDA: 84700880502.08.9C227BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A42081C0008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:05:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GuZN3lNZ;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777212349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifUUoE5ADy0pilplShbL3vPBkM3Dr2g15JgBdHmlu10=;
	b=xc43pd7PV6YInrvjsMF5uEFprpB6nrikb/fA5RxCaNbVqz9fDuckxOtZfZdoH9NG50q7Y1
	+Fuk3FFNUlkL7u79DZtSeAkn1GonJnC9d6K2YB1uMa8lzRi3S1WyQhW1OLRB5BuZlS8Xt6
	a7Ey0pWO9ERgXCuQr4+lSX5vsUw/8tc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GuZN3lNZ;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777212349; a=rsa-sha256;
	cv=none;
	b=mPI+VfqRVUv9PrwVVeCKJCVz8gY5X18xZgDPAPKrqw4f+tqNDmiUG0wlvoR2DvykBsLNm4
	z876mEO7JB60mzLCz1CNQ4MplRtolAXzcA8ftNI/glQVj1leINBGGNvIkV9NKZLfJJtXlx
	ReY5nWchybADAK+jtboCwCuQcgrrru8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B276E60121;
	Sun, 26 Apr 2026 14:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FB6C2BCAF;
	Sun, 26 Apr 2026 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777212348;
	bh=T4tAq8f3GyMyfad25bLCniXA7N6Mz1oCdcVsZpFwgJ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=GuZN3lNZME/yjE2qdULa20BWGzJC/R7ThVsMc3/fu4Nra77mXgLO8zF/akws1vuMR
	 5SahTXISJHdXrw34jbyROxbYk2kXjFD0DgG3REtg1X/z9rFdbvC2ZI9LyV3VC8DdTm
	 rZNPiqoj/9gDCnQKCW4ACKQsWaMmF3iW/6COSdXeZclcYHfxE0haX/Y7F8RxjWgXby
	 YHKOBnQGknEAmkSGPRHysFUiOmCEr7sC1C+rOOr7stT0u2bqpa7hbEFwYzfx1vL4p2
	 Wz42SCHeI5jshpWp6VH5zy8UKI2+Kh4XzYwcI5OYZsQJu6YQEOOBAOdvHWnnFFDHKZ
	 iopiD24Wp+XyA==
Message-ID: <2a2d77bb3caf096781b1a4a6000a1c1318d52840.camel@kernel.org>
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
From: Jeff Layton <jlayton@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"	
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Snitzer	 <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ritesh
 Harjani	 <ritesh.list@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 Kairui Song	 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt	 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen	 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu	 <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu	 <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Date: Sun, 26 Apr 2026 10:05:42 -0400
In-Reply-To: <20260426052854.8372fb9d4c616f16a8aa0a0f@linux-foundation.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
		<20260426-dontcache-v3-2-79eb37da9547@kernel.org>
	 <20260426052854.8372fb9d4c616f16a8aa0a0f@linux-foundation.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: krk4hq5pcibzn3t9w41gptkjx1ui1fcj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A42081C0008
X-Rspam-User: 
X-HE-Tag: 1777212349-910513
X-HE-Meta: U2FsdGVkX189WHTWSRJQrdIiCWIdebRnCenht876q+qN4jVtBvGQHule6WFXNkI18m9gW1WfSbwXOeNIUr4UY2nPGUev+PUJj6Azv8XDV1RxmU4zAMPV4bGlFC1GK/wx918ykthcKoAGGUaUusGC6QZJiJ9dStbXcmHzuYLlXK4nv08x5203NMWrXV5xAng8WFjKg6c2mi/JFPsVuqy/B3vwYbDqadlga8BYHmhXnXdxt0f0Vl/18tbp7+IWt39giVo53VG8AvZAmO9Fzx5qOU0zRV8zXdykT3nE1BYMkRioMlYu8Sq0mNvoy5UFgPPNm5WBhmpOFO9IaHoI9sHCidWQl1CTIkZvuSy9A27rxFzKXf0a44MHYL1wxTf3ivXhyVhPgU2jDUxADxf/HBSz5fX9nDsf44gz0k7aLg6b8RKoJNLZjiflLFTkrl8tD94XJcRMW9/rG7IY8m65FPtK7hAk/h+T1ZbcM84fX6FfoEEkayc7C2u+Dclni67oTZnzkcQ78hvDXAe7PftWrul+SGArXFnfXsa/Ax2I7srJKrTfebjtypFFLzkfSxJGgznYbwg+RpWEWFN3i+B52bfnuGtSfvq5+NiF6xCB0qqBhyIOjxjAP3s/g5bYw4dbBdQ00oyGzPDI3wT9WC6yUQJcwfj9pbAA1i1dcBWs66c2Vw1yV8HjVWOnc9CZbkoV637Hm5645L/knbVMw31iIclZXc6ZWUZkV3ThDw14qiO9zQaAIxLi28Q0Nc+F1EAK+sf4T0XVw/GVz3eJu+LnhjjF5stTlTpXM06iWhj4IFkn362758PMwIVBA5gkUXE6qxC2IcGoN4js7AwuBWsAoPodawdlLSAD81W8rt2LwMXf7nzx6Q13sC06Z64YSKwjwZvjHBnQX+WwBs6HJnuqp6iLtS3rWqOk0qqJxbxm1MGWJGYF1ziqULuXL/1ydFfbmNglJehvAb62wJ+j/HrJlQQ
 I4IkP3/9
 Nb6OMJxkjGxCaNAR9UkKG5YN4IXgPS56JzM8WNxdAPRaW4w3090eDnQGuiJS2hxxXwej2aGvtPAeDpCx5YDFhkUrjfh6rjvxSXvpVfahaioCeFMkngJgjr+Wu4MJ7XytOe325x1CdUo7nrEg+8QrSbGVwqqBZmm1yt2+NEp0+3eEiv302G75AiIbwz5zQEPPP/kCJea+fgEbCSGrOHvidkokLMPvBY+MnenhINsKrw0v3I7s8rww1Lyg7tPL0+l3bqJV5U/hL02yAf22tF0gQ6sEYcZuCLH+nx9bgPVWD2m5DvPxyqZreReIfqSYCMoiiaEqh70s28tiNgmWPazIYrr5c7Bytw4Ig97+gW4xl94wgWbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-04-26 at 05:28 -0700, Andrew Morton wrote:
> Naive questions...
>=20
> On Sun, 26 Apr 2026 07:56:08 -0400 Jeff Layton <jlayton@kernel.org> wrote=
:
>=20
> > The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> > filemap_flush_range() on every write, submitting writeback inline in
> > the writer's context.  Perf lock contention profiling shows the
> > performance problem is not lock contention but the writeback submission
> > work itself =E2=80=94 walking the page tree and submitting I/O blocks t=
he writer
> > for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> > (dontcache).
>=20
> So in the current case, when generic_write_sync() returns, all that
> memory is written back and clean&reclaimable (or freed?), yes?
>=20

No. Before returning, it submits the I/Os for the portion that it wrote
rather than leaving it to the flusher to take care of things, but it
doesn't wait for the I/Os to complete.

> > Replace the inline filemap_flush_range() call with a flusher kick that
> > drains dirty pages in the background.  This moves writeback submission
> > completely off the writer's hot path.
>=20
> Whereas after this change, that pagecache is probably still dirty,
> unreclaimable, waiting for the flusher to do its thing?
>=20

Correct, but that's sort of the case today too since DONTCACHE I/Os
don't wait for the completion. With this change we're just deferring
the I/O submission to the flusher thread (which should hopefully soon
wake and take care of business). If the flusher thread can't keep up,
then eventually balance_dirty_pages() will kick in and start slowing
things down.

> So is there potential that the system will get all gummed up with
> dirty, to-be-written-soon pagecache?  Is there something which limits
> this buildup?
>=20

Today in this situation, the writers are limited by the backing device
throughput. Once the I/O submission queues are full, then the DONTCACHE
writers end up stacking up on those. With this change, the writers will
be more limited by traditional VM limits in this situation.=20

In the test runs I did, the peak pagecache with DONTCACHE writes was
higher than with the unpatched version but still considerably less than
with normal buffered I/O. That's the cost of deferring the I/O
submission to the flusher.

One thing we could consider is going back to submitting the writes
inline when the number of dirty pages is high. But, that could have a
detrimental effect on performance too.

> > ...
> >=20
> > dontcache-bench results on dual-socket Xeon Gold 6138 (80 CPUs, 256 GB
> > RAM, Samsung MZ1LB1T9HALS 1.7 TB NVMe, local XFS, io_uring, file size
> > ~503 GB, compared to a v6.19-ish baseline):
> >=20
> >   Single-client sequential write (MB/s):
> >                        baseline    patched     change
> >   buffered              1449.8     1440.1      -0.7%
> >   dontcache             1347.9     1461.5      +8.4%
> >   direct                1450.0     1440.1      -0.7%
> >=20
> >   Single-client sequential write latency (us):
> >                        baseline    patched     change
> >   dontcache p50         3031.0    10551.3    +248.1%
> >   dontcache p99        74973.2    21626.9     -71.2%
> >   dontcache p99.9      85459.0    23199.7     -72.9%
> >=20
> >   Single-client random write (MB/s):
> >                        baseline    patched     change
> >   dontcache              284.2      295.4      +3.9%
> >=20
> >   Single-client random write p99.9 latency (us):
> >                        baseline    patched     change
> >   dontcache             2277.4      872.4     -61.7%
> >=20
> >   Multi-writer aggregate throughput (MB/s):
> >                        baseline    patched     change
> >   buffered              1619.5     1611.2      -0.5%
> >   dontcache             1281.1     1629.4     +27.2%
> >   direct                1545.4     1609.4      +4.1%
> >=20
> >   Mixed-mode noisy neighbor (dontcache writer + buffered readers):
> >                        baseline    patched     change
> >   writer (MB/s)         1297.6     1471.1     +13.4%
> >   readers avg (MB/s)     855.0      462.4     -45.9%
>=20
> These results look ambiguous.  Sometimes better, sometimes worse?
>=20
> > nfsd-io-bench results on same hardware (XFS on NVMe, NFSv3 via fio
> > NFS engine with libnfs, 1024 NFSD threads, pool_mode=3Dpernode,
> > file size ~502 GB, compared to v6.19-ish baseline):
> >=20
> >   Single-client sequential write (MB/s):
> >                        baseline    patched     change
> >   buffered              4844.2     4653.4      -3.9%
> >   dontcache             3028.3     3723.1     +22.9%
> >   direct                 957.6      987.8      +3.2%
> >=20
> >   Single-client sequential write p99.9 latency (us):
> >                        baseline    patched     change
> >   dontcache            759169.0   175112.2     -76.9%
> >=20
> >   Single-client random write (MB/s):
> >                        baseline    patched     change
> >   dontcache              590.0     1561.0    +164.6%
> >=20
> >   Multi-writer aggregate throughput (MB/s):
> >                        baseline    patched     change
> >   buffered              9636.3     9422.9      -2.2%
> >   dontcache             1894.9     9442.6    +398.3%
> >   direct                 809.6      975.1     +20.4%
> >=20
> >   Noisy neighbor (dontcache writer + random readers):
> >                        baseline    patched     change
> >   writer (MB/s)         1854.5     4063.6    +119.1%
> >   readers avg (MB/s)     131.2      101.6     -22.5%
>=20
> Ditto but less so.
>=20
> > The NFS results show even larger improvements than the local benchmarks=
.
> > Multi-writer dontcache throughput improves nearly 5x, matching buffered
> > I/O. Dirty page footprint drops 85-95% in sequential workloads vs.
> > buffered.
>=20
> It sounds that you like the results, so OK ;)

--=20
Jeff Layton <jlayton@kernel.org>

