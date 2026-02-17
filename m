Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA856E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 22:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93DB6B0088; Tue, 17 Feb 2026 17:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17356B0089; Tue, 17 Feb 2026 17:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923466B008A; Tue, 17 Feb 2026 17:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 779E36B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:46:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDF4113A974
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:46:03 +0000 (UTC)
X-FDA: 84455433006.05.9EF1630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05D17C000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:46:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hqo8c5H8;
	spf=pass (imf10.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771368362; a=rsa-sha256;
	cv=none;
	b=jCQNVdZoeRHp+izEuMGLPdi7xqSGTXpR4fk3o6K3sgs3YUvmkyaxa1HtVAtw3dDqDzHyTL
	w7GpuIQ5Q3TbGGyC7RbI4gFcqKtRAPZbneeM5ov09L9rtscnjqXcqx7Jp51AUL/vsZY6HP
	F7oVn/Y8d0jM8fYj2iWTqoXRW0aYVlw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hqo8c5H8;
	spf=pass (imf10.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771368362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4vZUG8jjrZ6L1xNI5CEqKtPlNzxZYqa5C4JybuEhUY=;
	b=fnW1eUCGQ38K5II3BXHC1RwVfmypgToFLS0bojKLA0KgVyBKtdw1dQFn70n+WT1ZyPDdMW
	bk7+6Lwio//AY2lpGtBXRx4TPeSjDg1P9kzxKqWy/x6ADBDnUm3/dFn4IypHWL8J8bpJYV
	rtgXQz3R6SxnIi/IvjSERhqjXuPuCuY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00C4E41A17;
	Tue, 17 Feb 2026 22:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DABC4CEF7;
	Tue, 17 Feb 2026 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771368360;
	bh=IA0KJ8qlcIfjt6ChC5mEPNg1N7IRegvYFKFbw03Jb1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hqo8c5H8ggMwsYSveXVxtxUOXCxKypC2JTZQ3yeCid2QUmSkGX7l7m3gEWjxex2R/
	 BYkUqHCm7otpwfwYVtLXEvC9suoYlEtvxPyZbJrx/egY4jo6PKrzgv1/UIwpyM/nm0
	 9j7r7dH0ge3kG1VZQIbAhAecf+ovU7liDXlc4XfZ/EM+pron/dotA89afLXXOaE2pK
	 DRtfXeLMmCUy3VavZuB4VGLNXDjiNNhgQrx96ShaoA/GN9bL35V0vWQHkhssUJSXum
	 FGrn18Rh2xzrkwkRohyP7FKZR42yf9Tdm+CE/AOUNWOz6XpUZ9HWhh6BMcPKEuOnhP
	 n2c5jiREVaxlg==
Date: Wed, 18 Feb 2026 09:45:46 +1100
From: Dave Chinner <dgc@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZTvmpOL7NC4_kDq@dread>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <20260217055103.GA6174@lst.de>
 <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
 <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
X-Rspamd-Queue-Id: 05D17C000D
X-Stat-Signature: gj3ezoqppakrhygu5fji16kukpzec9yz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771368361-884859
X-HE-Meta: U2FsdGVkX1/Dsb+X2ZNS2g7FaSd2dfgwVuOcYFoW41JihO6wASlAZJwIvLy1jFsqm60D1QqMGHDqzC+/T91zMrewEIsQ2NV8WWZLbNQNFN2q4E7ehhOdWf49V0wueevpD7JIEFajY9XsVl/SuBd0qrqwoFAvRpEn/ndmUM7Mc9u1ZhnJXmtg9yaXZ4CWRjz+qK6FlXpYE7vo+uvc30Zz8yXiQOnfrT2r9jMhknPRHdHa0xPJAAeAaJRFQ9ZwguQrweCq1iUNzjPDp0VOuYKBW8RXW2yaC/OYsy0p3MR/1zdcdYjLKhmhlpme+0UFdmGBAVWBR7ljFI8NtrxBfG/I/SoCtYMxvwYzvVXG0FO3Ix9Ot8JRCcg7IwsHMOLe4FsEfjHmMtV6OwhnNGhOBQil3OStt5LS5tSZ9fhSbvr3EEm4+73eUzrlmnPeK4QN6m2DFGSWDHZWnaErA95WS6ShfI2gWiB53KhuzmxYEFlVqUc8ZP/U0kKWIlJ66GcVGikyhr4jWXqjZtxINjDo4MK/1Et9TEN7vkYT+QoSPpeXbHBnwSoibYwJ6or+xTm6M9pvyOJBiivQv3D4dFosPUDqbYGoI0z1Ku5oBiknQM+P7rh22/sCMFDchqlgkD+p5A7CjRCjKrcLRnaj6q3ec4lXP/FETXK5KCapYYI8mAWqKSOn4Kd5ur2Ba+N/V+uJiJizHUf/vMaSRfn8U0ZFn/GGjqsjMA7gdB4I/OdsWyUk85ktLMzf+Z7nCZ7fqpIgQOL5nEFO3rUNo7ZJbVb5ioOz+ilZbtsCsMr8IU8siEGfonl98b+Wwnzd6byAb5ONDnPoMF2uA2tcXrnsHqi2JVtI0zrr76iByo+eEXKJ2M8Lu88d45gu1V6OgH7vYWcL9hRFzYp+XsT7O3j9iI/YtSl3jNQUa/q7fU9+hvZZWcXZciQtwYI9VEaHisf4Vk5VI6k33D4YcUvvHyyp/muoA/o
 mnevyMRj
 B8s1ZVqopjVIiT3oGbYMvnj/3dLnBhGgBZWQP0e9Dq+ClidgpOUYt7TQ8xruaXLZv/YgSG4RfkpFbP/e1cCfjMBibKXOctS6O2iKFaZQPXUuua9o/T40zmQGLFy/fT04wNGmtOG1I9vznVv1XHQPA1oMeb8YDG4PchfnATdeO66Oy5HwvSHji67CkfMxNXKTwzp7u4UBW8w65Ss9tPl/u6o1D2R0I0TFF94B1zGk4WeqLZ+Aqt6kux/QJzxaO0o6CjnMcS4TtzZ/xqqtVEtnPi65Denc0i+Ip9AEujOp+vo+R7mn+tJ06jMNBUvYovLadNAi84dgnO8z3AIACLaix0k535PoOXYk66iHmqOxehOFJEOjOeznXqdR54dt+BFarnM66lenAI9dx30mDDjJEGrRh/j+pdwVL89eUeSyXmtIhYfW+22AwI6JBOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:47:07AM -0500, Andres Freund wrote:
> Hi,
> 
> On 2026-02-17 10:23:36 +0100, Amir Goldstein wrote:
> > On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > I think a better session would be how we can help postgres to move
> > > off buffered I/O instead of adding more special cases for them.
> 
> FWIW, we are adding support for DIO (it's been added, but performance isn't
> competitive for most workloads in the released versions yet, work to address
> those issues is in progress).
> 
> But it's only really be viable for larger setups, not for e.g.:
> - smaller, unattended setups
> - uses of postgres as part of a larger application on one server with hard to
>   predict memory usage of different components
> - intentionally overcommitted shared hosting type scenarios
> 
> Even once a well configured postgres using DIO beats postgres not using DIO,
> I'll bet that well over 50% of users won't be able to use DIO.
> 
> 
> There are some kernel issues that make it harder than necessary to use DIO,
> btw:
> 
> Most prominently: With DIO concurrently extending multiple files leads to
> quite terrible fragmentation, at least with XFS. Forcing us to
> over-aggressively use fallocate(), truncating later if it turns out we need
> less space.

<ahem>

seriously, fallocate() is considered harmful for exactly these sorts
of reasons. XFS has vastly better mechanisms built into it that
mitigate worst case fragmentation without needing to change
applications or increase runtime overhead.

So, lets go way back - 32 years ago to 1994:

commit 32766d4d387bc6779e0c432fb56a0cc4e6b96398
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Thu Mar 3 22:17:15 1994 +0000

    Add fcntl implementation (F_FSGETXATTR, F_FSSETXATTR, and F_DIOINFO).
    Fix xfs_setattr new xfs fields' implementation to split out error checking
    to the front of the routine, like the other attributes.  Don't set new
    fields in xfs_getattr unless one of the fields is requested.

.....

+       case F_FSSETXATTR: {
+               struct fsxattr fa;
+               vattr_t va;
+
+               if (copyin(arg, &fa, sizeof(fa))) {
+                       error = EFAULT;
+                       break;
+               }
+               va.va_xflags = fa.fsx_xflags;
+               va.va_extsize = fa.fsx_extsize;
                                ^^^^^^^^^^^^^^^
+               error = xfs_setattr(vp, &va, AT_XFLAGS|AT_EXTSIZE, credp);
+               break;
+           }


This was the commit that added user controlled extent size hints to
XFS. These already existed in EFS, so applications using this
functionality go back to the even earlier in the 1990s.

So, let's set the extent size hint on a file to 1MB. Now whenever a
data extent allocation on that file is attempted, the extent size
that is allocated will be rounded up to the nearest 1MB.  i.e. XFS
will try to allocate unwritten extents in aligned multiples of the
extent size hint regardless of the actual IO size being performed.

Hence if you are doing concurrent extending 8kB writes, instead of
allocating 8kB at a time, the extent size hint will force a 1MB
unwritten extent to be allocated out beyond EOF. The subsequent
extending 8kB writes to that file now hit that unwritten extent, and
only need to convert it to written. The same will happen for all
other concurrent extending writes - they will allocate in 1MB
chunks, not 8KB.

The result will be that the files will interleave 1MB sized extents
across files instead of 8kB sized extents. i.e. we've just reduced
the worst case fragmentation behaviour by a factor of 128. We've
also reduced allocation overhead by a factor of 128, so the use of
extent size hints results in the filesystem behaving in a far more
efficient way and hence this results in higher performance.

IOWs, the extent size hint effectively sets a minimum extent size
that the filesystem will create for a given file, thereby mitigating
the worst case fragmentation that can occur. However, the use of
fallocate() in the application explicitly prevents the filesystem
from doing this smart, transparent IO path thing to mitigate
fragmentation.

One of the most important properties of extent size hints is that
they can be dynamically tuned *without changing the application.*
The extent size hint is a property of the inode, and it can be set
by the admin through various XFS tools (e.g. mkfs.xfs for a
filesystem wide default, xfs_io to set it on a directory so all new
files/dirs created in that directory inherit the value, set it on
individual files, etc). It can be changed even whilst the file is in
active use by the application.

Hence the extent size hint it can be changed at any time, and you
can apply it immediately to existing installations as an active
mitigation. Doing this won't fix existing fragmentation (that's what
xfs_fsr is for), but it will instantly mitigate/prevent new
fragmentation from occurring. It's much more difficult to do this
with applications that use fallocate()...

Indeed, the case for using fallocate() instead of extent size hints
gets worse the more you look at how extent size hints work.

Extent size hints don't impact IO concurrency at all. Extent size
hints are only applied during extent allocation, so the optimisation
is applied naturally as part of the existing concurrent IO path.
Hence using extent size hints won't block/stall/prevent concurrent
async IO in any way.

fallocate(), OTOH, causes a full IO pipeline stall (blocks submission
of both reads and writes, then waits for all IO in flight to drain)
on that file for the duration of the syscall. You can't do any sort
of IO (async or otherwise) and run fallocate() at the same time, so
fallocate() really sucks from the POV of a high performance IO app.

fallocate() also marks the files as having persistent preallocation,
which means that when you close the file the filesystem does not
remove excessive extents allocated beyond EOF.  Hence the reported
problems with excessive space usage and needing to truncate files
manually (which also cause a complete IO stall on that file) are
brought on specifically because fallocate() is being used by the
application to manage worst case fragmentation.

This problem does not exist with extent size hints - unused blocks
beyond EOF will be trimmed on last close or when the inode is cycled
out of cache, just like we do for excess speculative prealloc beyond
EOF for buffered writes (the buffered IO fragmentation mitigation
mechanism for interleaving concurrent extending writes).

The administrator can easily optimise extent size hints to match the
optimal characteristics of the underlying storage (e.g. set them to
be RAID stripe aligned), etc. Fallocate() requires the application
to provide tunables to modify it's behaviour for optimal storage
layout, and depending on how the application uses fallocate(), this
level of flexibility may not even be possible.

And let's not forget that an fallocate() based mitigation that helps
one filesystem type can actively hurt another type (e.g. ext4) by
introducing an application level extent allocation boundary vector
where there was none before.

Hence, IMO, micromanaging filesystem extent allocation with
fallocate() is -almost always- the wrong thing for applications to
be doing. There is no one "right way" to use fallocate() - what is
optimal for one filesystem will be pessimal for another, and it is
impossible to code optimal behaviour in the application for all
filesystem types the app might run on.

> The fallocate in turn triggers slowness in the write paths, as
> writing to uninitialized extents is a metadata operation.

That is not the problem you think it is. XFS is using unwritten
extents for all buffered IO writes that use delayed allocation, too,
and I don't see you complaining about that....

Yes, the overhead of unwritten extent conversion is more visible
with direct IO, but that's only because DIO has much lower overhead
and much, much higher performance ceiling than buffered IO. That
doesn't mean unwritten extents are a performance limiting factor...

> It'd be great if
> the allocation behaviour with concurrent file extension could be improved and
> if we could have a fallocate mode that forces extents to be initialized.

<sigh>

You mean like FALLOC_FL_WRITE_ZEROES?

That won't fix your fragmentation problem, and it has all the same
pipeline stall problems as allocating unwritten extents in
fallocate().

Only much worse now, because the IO pipeline is stalled for the
entire time it takes to write the zeroes to persistent storage. i.e.
long tail file access latencies will increase massively if you do
this regularly to extend files.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

