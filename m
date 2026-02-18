Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476E0E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 04:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D316B0088; Tue, 17 Feb 2026 23:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4186B0089; Tue, 17 Feb 2026 23:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EA16B008A; Tue, 17 Feb 2026 23:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20DC86B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:10:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9DFB1A040C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:10:29 +0000 (UTC)
X-FDA: 84456250578.11.0BF9A5C
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf28.hostedemail.com (Postfix) with ESMTP id 944CFC0007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:10:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=NyFKBjU9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=F442jkCw;
	spf=pass (imf28.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.145 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771387827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDesmuvOoqm7KYIcrl+m4jnd+l0mTOjnNT7rySenVmw=;
	b=Z4fMBZytjDxMtnpn0nac3uPXbMCzhALeRy6TQG/V0UA2W+u0AjAn4e/SDLzu642UuFXnw+
	4vtX6cgKxU23LI1+EbCZsSQ1IyXZlkxqIyPX4UcV2V2pxpfBjiLwpXluRRNGD1fSPsk0UG
	fCC+AWRQyQy+GJZVz/BJRZT3hNx2/pA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=NyFKBjU9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=F442jkCw;
	spf=pass (imf28.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.145 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771387827; a=rsa-sha256;
	cv=none;
	b=R7oUFxBgnMswV8CilBiFgEjJB/tVNDUlnoE2auGcf+Sx4U4QSd+2+YABZcb1HQq1Hnf/to
	YeLPGuKV1CQfCndiEuaSSuWZe0BAOXMNV3VJT1ouTjltE4uQLYN+pjmWUqKJ5d5PeQ+bcT
	aVDSEo6opD78pJj15pxXxQtYQl4e4vM=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id D75BC1D00141;
	Tue, 17 Feb 2026 23:10:25 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 17 Feb 2026 23:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771387825; x=1771474225; bh=MDesmuvOoq
	m7KYIcrl+m4jnd+l0mTOjnNT7rySenVmw=; b=NyFKBjU94uhXFhnzD+chKOJfL3
	yU1YSkNcnof42XOEjsSEpCWAZVkUu+HmranGCIoAcsgVDnUtzaRHjfjQ20naydJ5
	vR7edehRvutjHe5B7641tY4oVgmpNOL+02yyVzYgZC4tTNzYWbt048wWlEvhsuoX
	I01uXwJPPZEe2MsXIhDec/gUFbRmS0Toq8p0v6E2PbFBHdPDQ46V75fDhTSREOJj
	ZEf1yuDq2tpncRzE8DDWoXPXvIpCa0uPPSiEROObySFZykMsKd/xY3Gtu4NDWQP8
	rgqFA0fNzlH3BR5eoeNAR8jvcn9TKRGjWyNqLoxWcbGWvK8c+KW1Djpq99Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771387825; x=1771474225; bh=MDesmuvOoqm7KYIcrl+m4jnd+l0mTOjnNT7
	rySenVmw=; b=F442jkCwr4HV0qmZORjuygDkjt04rSy/Efaz7Q8BD1v1NnaVw2L
	7XYqsESZQ54YPbUQuw9OZu4teO/Gnf4MLmUnbJgzEo1C/SRKJc5aEcMbJ+JJpYVY
	GjMpbJquw3OJfFzN6/VILMeBSD6DVJkSSJKbkxu54W7HbkYrQwOYTBgCaGhYC+Zo
	eWXQNqN84Q1oKYRoLE4vXKTNkX9xxdY1vZmOPJ8GmnsZXXiB2KLdXBo3YQUVA6OZ
	W+z0PF4ZY+IdVcZvwkcuF8uLlY8QuUu93CDAbHXKShbGL/DVJdfd7rj6irghdeN7
	ELXlPOquGiniH489rn2yt5RVtOKqGT4rBag==
X-ME-Sender: <xms:sDuVabWuDpIUFyfmsSKYXdkbRMK_Q0wHAHKfW3_-nQPg7TJxoh0XNg>
    <xme:sDuVaT-1ITBl6tXG9k0ueaOFuTkTQoboQ73F-yH40ExN7SHy3GrNik58BWJ3LHUKa
    3iMdIALaFpi_o7l1NVgWn2qOMt2Q4gPYGHgzBmoBrH3jHMpx4_c344>
X-ME-Received: <xmr:sDuVaYjT_v2zR0haW9lDyk8_gtKbwtLQ075sX99mfMx8zCA9Qx02mfK_wtjP_8EAnHFN6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdduieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepfeffgfelvdffgedtveelgfdtgefghfdvkefggeetieevjeekteduleevjefh
    ueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hnughrvghssegrnhgrrhgriigvlhdruggvpdhnsggprhgtphhtthhopedvuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhmpd
    hrtghpthhtoheprhhithgvshhhrdhlihhsthesghhmrghilhdrtghomhdprhgtphhtthho
    peifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepughgtgeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehmtghgrhhofheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepphgrnhhkrghjrdhrrghghhgrvhes
    lhhinhhugidruggvvhdprhgtphhtthhopehojhgrshifihhnsehlihhnuhigrdhisghmrd
    gtohhm
X-ME-Proxy: <xmx:sDuVaSXyvaYr9G4JcHtLiJjGHv7BkLv4m2EGOHI7rzSv2FMRP3QKuw>
    <xmx:sDuVaUtcuJFdwaVpc3lLxwjAe7gl-FjKWnMS_BZNUVMb2ZIaxpwybA>
    <xmx:sDuVab9VSnjlwm6OapAtW3WseZda5kdwfXj4KS58SKNKX1SXeKle4A>
    <xmx:sDuVacu56fRX3vkTE63zvlRcP-Kcb9o6SbXhaumJnNcOZqQqgQDCkQ>
    <xmx:sTuVaYc0aw3wgiVrivwaFwPcMA5_rqDqvtprmBaVh9KjhQZ7Q4xOt3dg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 23:10:24 -0500 (EST)
Date: Tue, 17 Feb 2026 23:10:23 -0500
From: Andres Freund <andres@anarazel.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, 
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, 
	vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <is77m5lxg22z2lfhpj3zh7hse5wmft5i2mae72of7iffmtjktu@euxitej5vwxp>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <20260217055103.GA6174@lst.de>
 <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
 <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
 <aZTvmpOL7NC4_kDq@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZTvmpOL7NC4_kDq@dread>
X-Stat-Signature: 7afi57t54sq9nf1pshg3qpxq1ng49qjq
X-Rspam-User: 
X-Rspamd-Queue-Id: 944CFC0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771387827-837029
X-HE-Meta: U2FsdGVkX1+7kNBUG2v9ozO741yfm/L0CaqAAJURjUHJ7tJxmhJYsrbgLf2RkYVmN1kVHO4HN1LhkiASRMIRGEcfyXRI31h09PtspxVsjclcGUufYbQQf++7fIU/mDE0uvNmFQmjvj9NW9iG0+8ukieILeYyWkfic/JCXoPl1VAq5VfQ64W8ZPUFvCnTS5si+Qgv07uWdsfZl9l/gzPzZ2WPL5mVmV0AR67Qb+Lntq3bA6gwzSLOwlAyX/BNJYQPb/tf5OIoWzK4SBjQ6QDTHhwhExOJyztkFUPtuGUoRXSoTjJZizgOjRsavlogjBhj7GqdyCnjgH4Nvy2QRCQ0Gp5w2MrqM8AeVrjFMXM2uQl1N+VCxi2XqkXsSR54GeG9dALb+fGgshItbG1KRiF8dGhwRU1YTXNBos+Jh5JGF+/CAi7IApA86DJ/9u7ggDQwW028xt+KreXD/YwBqG5sJ7cqsNdNFyE/ArrWPN2KqTGPCmlBpnMGfu9MwFO3U4bpFgA0+yw7u4n52rgcQNBEMZfw7XsoLNFIy1s8DfhzjBPJrTPBfEMoCG51nXoxMctvXa1RMmqUfSUhgXl0L1VZ4BybETe/GQclN5ZCnZ7siflYFTzRKy0VJe4nRRZs0r+HRnm6F/bZZ3Np2eU4ZB1DRhXZcdIv0Luwr3QplIhADrGKNSLlsKDermA0asCamt4TpjokVyf1UFn+IQa9D+HmLdo6l7TwLwtwqvf/w3kKGwBKQLT6lMz+LKa4R1eciQ1LJ/0Q9+mamj2A/vN1YKts0SsD0afOdfM8BlmwcjqkZX43lRU7fd35KDpcPVwjGK2gNQ/ARG7FyfSAK3mVQ3QpIqfXFQkITQD9S+k+yU7mTKy2aPKB9ya3v6vW9IhJO/B0aEZn3EcTF9JTxiJ6wNYCKmQ3/iMoF5ta2Dkz9G1zfkvGER6GT/dRjKtbtSo76TbYdAQeoZ6CgN9iw8cRaub
 amFhdys0
 CdT7HkUCh5iddxfvcRL7gvVdlKJXqD3+hKOlTM1wnFNJiSs18JPayL8jliMN9xws/7KjRMKicnfGF9G2U/pbEL6qqPEARC4IMPLzhCZq1fhrqL47rFPXvcc8bMO1b1hbHW9YeDC4UmBy5MtQUGyAtcHcHNA8YGX2J1Z1EX+s4lNhlhn8OvRIZN0aKEK6eVoaTc9/xCArEQ+04eno+JcTufIIPxdppCaHN60lFe5BI6vHOtSI6xObB1VQClG53jsqDPetfAmt4jkd1OCzqbO31mr4xmMUe3a2DTblpkWVyr9OgshLltH/4Oq+8cdal4SU953BeBkHnRlTIgFIprdytlBZf60G6p5GrgNMP8hBAc7UTTr5oudYFA4rb5o2BnD79D56wZUJEewBsRtgI4Gz+wxLSWiVuFmK8wZIbPp4ADf5p7Rg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-18 09:45:46 +1100, Dave Chinner wrote:
> On Tue, Feb 17, 2026 at 10:47:07AM -0500, Andres Freund wrote:
> > There are some kernel issues that make it harder than necessary to use DIO,
> > btw:
> >
> > Most prominently: With DIO concurrently extending multiple files leads to
> > quite terrible fragmentation, at least with XFS. Forcing us to
> > over-aggressively use fallocate(), truncating later if it turns out we need
> > less space.
>
> <ahem>
>
> seriously, fallocate() is considered harmful for exactly these sorts
> of reasons. XFS has vastly better mechanisms built into it that
> mitigate worst case fragmentation without needing to change
> applications or increase runtime overhead.

There's probably a misunderstanding here: We don't do fallocate to avoid
fragmentation.


We want to guarantee that there's space for data that is in our buffer pool,
as otherwise it's very easy to get into a pickle:

If there is dirty data in the buffer pool that can't be written out due to
ENOSPC, the subsequent checkpoint can't complete. So the system may be stuck
because you're not be able to create more space for WAL / journaling, you
can't free up old WAL due to the checkpoint not being able to complete, and if
you react to that with a crash-recovery cycle you're likely to be unable to
complete crash recovery because you'll just hit ENOSPC again.

And yes, CoW filesystems make that less reliable, it turns out to still save
people often enough that I doubt we can get rid of it.


To ensure there's space for the write out of our buffer pool we have two
choices:

1) write out zeroes
2) use fallocate

Writing out zeroes that we will just overwrite later is obviously not a
particularly good use of IO bandwidth, particularly on metered cloud
"storage". But using fallocate() has fragmentation and unwritten-extent
issues.  Our compromise is that we use fallocate iff we enlarge the relation
by a decent number of pages at once and write zeroes otherwise.


Is that perfect? Hell no.  But it's also not obvious what a better answer is
with today's interfaces.

If there were a "guarantee that N additional blocks are reserved, but not
concretely allocated" interface, we'd gladly use it.



> So, let's set the extent size hint on a file to 1MB. Now whenever a
> data extent allocation on that file is attempted, the extent size
> that is allocated will be rounded up to the nearest 1MB.  i.e. XFS
> will try to allocate unwritten extents in aligned multiples of the
> extent size hint regardless of the actual IO size being performed.
>
> Hence if you are doing concurrent extending 8kB writes, instead of
> allocating 8kB at a time, the extent size hint will force a 1MB
> unwritten extent to be allocated out beyond EOF. The subsequent
> extending 8kB writes to that file now hit that unwritten extent, and
> only need to convert it to written. The same will happen for all
> other concurrent extending writes - they will allocate in 1MB
> chunks, not 8KB.

We could probably benefit from that.


> One of the most important properties of extent size hints is that
> they can be dynamically tuned *without changing the application.*
> The extent size hint is a property of the inode, and it can be set
> by the admin through various XFS tools (e.g. mkfs.xfs for a
> filesystem wide default, xfs_io to set it on a directory so all new
> files/dirs created in that directory inherit the value, set it on
> individual files, etc). It can be changed even whilst the file is in
> active use by the application.

IME our users run enough postgres instances, across a lot of differing
workloads, that manual tuning like that will rarely if ever happen :(. I miss
well educated DBAs :(.  A large portion of users doesn't even have direct
access to the server, only via the postgres protocol...

If we were to use these hints, it'd have to happen automatically from within
postgres.  But that does seem viable, but certainly is also not exactly
filesystem independent...



> > The fallocate in turn triggers slowness in the write paths, as
> > writing to uninitialized extents is a metadata operation.
>
> That is not the problem you think it is. XFS is using unwritten
> extents for all buffered IO writes that use delayed allocation, too,
> and I don't see you complaining about that....

It's a problem for buffered IO as well, just a bit harder to hit on many
drives, because buffered O_DSYNC writes don't use FUA.

If you need any durable writes into a file with unwritten extents, things get
painful very fast.

See a few paragraphs below for the most crucial case where we need to make
sure writes are durable.


testdir=/srv/fio && for buffered in 0 1; do for overwrite in 0 1; do echo buffered: $buffered overwrite: $overwrite; rm -f $testdir/pg-extend* && fio --directory=$testdir --ioengine=psync --buffered=$buffered --bs=4kB --fallocate=none --overwrite=0 --rw=write --size=64MB --sync=dsync --name pg-extend --overwrite=$overwrite |grep IOPS;done;done

buffered: 0 overwrite: 0
  write: IOPS=1427, BW=5709KiB/s (5846kB/s)(64.0MiB/11479msec); 0 zone resets
buffered: 0 overwrite: 1
  write: IOPS=4025, BW=15.7MiB/s (16.5MB/s)(64.0MiB/4070msec); 0 zone resets
buffered: 1 overwrite: 0
  write: IOPS=1638, BW=6554KiB/s (6712kB/s)(64.0MiB/9999msec); 0 zone resets
buffered: 1 overwrite: 1
  write: IOPS=3663, BW=14.3MiB/s (15.0MB/s)(64.0MiB/4472msec); 0 zone resets


That's a > 2x throughput difference. And the results would be similar with
--fdatasync=1.


If you add AIO to the mix, the difference gets way bigger, particularly on
drives with FUA support and DIO:


testdir=/srv/fio && for buffered in 0 1; do for overwrite in 0 1; do echo buffered: $buffered overwrite: $overwrite; rm -f $testdir/pg-extend* && fio --directory=$testdir --ioengine=io_uring --buffered=$buffered --bs=4kB --fallocate=none --overwrite=0 --rw=write --size=64MB --sync=dsync --name pg-extend --overwrite=$overwrite --iodepth 32 |grep IOPS;done;done

buffered: 0 overwrite: 0
  write: IOPS=6143, BW=24.0MiB/s (25.2MB/s)(64.0MiB/2667msec); 0 zone resets
buffered: 0 overwrite: 1
  write: IOPS=76.6k, BW=299MiB/s (314MB/s)(64.0MiB/214msec); 0 zone resets
buffered: 1 overwrite: 0
  write: IOPS=1835, BW=7341KiB/s (7517kB/s)(64.0MiB/8928msec); 0 zone resets
buffered: 1 overwrite: 1
  write: IOPS=4096, BW=16.0MiB/s (16.8MB/s)(64.0MiB/4000msec); 0 zone resets


It's less bad, but still quite a noticeable difference, on drives without
volatile caches.  And it's often worse on networked storage, whether it has a
volatile cache or not.




> > It'd be great if
> > the allocation behaviour with concurrent file extension could be improved and
> > if we could have a fallocate mode that forces extents to be initialized.
>
> <sigh>
>
> You mean like FALLOC_FL_WRITE_ZEROES?

I hadn't seen that it was merged, that's great!  It doesn't yet seem to be
documented in the fallocate(2) man page, which I had checked...

Hm, also doesn't seem to work on xfs yet :(, EOPNOTSUPP.


> That won't fix your fragmentation problem, and it has all the same pipeline
> stall problems as allocating unwritten extents in fallocate().

The primary case where FALLOC_FL_WRITE_ZEROES would be useful is for WAL file
creation, which are always of the same fixed size (therefore no fragmentation
risk).

To avoid having metadata operation during our commit path, we today default to
forcing them to be allocated by overwriting them with zeros and fsyncing
them. To avoid having to do that all the time, we reuse them once they're not
needed anymore.

Not ensuring that the extents are already written, would have a very large
perf penalty (as in ~2-3x for OLTP workloads, on XFS). That's true for both
when using DIO and when not.

To avoid having to do that over and over, we recycle WAL files.

Unfortunately this means that when all those WAL files are not yet
preallocated (or when we release them during low activity), the performance is
rather noticeably worsened by the additional IO for pre-zeroing the WAL files.

In theory FALLOC_FL_WRITE_ZEROES should be faster than issuing writes for the
whole range.


> Only much worse now, because the IO pipeline is stalled for the
> entire time it takes to write the zeroes to persistent storage. i.e.
> long tail file access latencies will increase massively if you do
> this regularly to extend files.

In the WAL path we fsync at the point we could use FALLOC_FL_WRITE_ZEROES, as
otherwise the WAL segment might not exist after a crash, which would be
... bad.

Greetings,

Andres Freund

