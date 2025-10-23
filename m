Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648D4CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E648E0006; Thu, 23 Oct 2025 03:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C460F8E0002; Thu, 23 Oct 2025 03:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C2D8E0006; Thu, 23 Oct 2025 03:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A221A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:50:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AC09BCB37
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:50:53 +0000 (UTC)
X-FDA: 84028607586.14.E4D1FB6
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 47751C0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:50:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=O29fK0xQ;
	spf=pass (imf28.hostedemail.com: domain of david@fromorbit.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761205851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwByf+n4jp5MlDetSCexzrKrLtoHg0zmHHS2wZ49+as=;
	b=BcOfRxiITzDtu1yH/WURLRnsb1TfEujHxzwixBBbnF/HMpRAKnT32+BWydJZMKhcbgDlJi
	mU1oEVLBiAlHFl3TyQgoolfyge2ao3S9WLQKWtoJxjI8hvQN8UUM9PGvR4BWEES6nm/phP
	LYi7tbyKWcykgf5abhZl4TykrmhmsK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=O29fK0xQ;
	spf=pass (imf28.hostedemail.com: domain of david@fromorbit.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761205851; a=rsa-sha256;
	cv=none;
	b=8pyGCZCDeUCiey/pc36cyUtzs3O7fE0AXEWN1wqUc7WLlchXc6KuNMVTALe8lIRFlfr/AE
	ftx5sN3SArsMJfhytJHe/giUDl+KnXuBo7YGv3Rpr+w0RG4o8uMtDD1nM+NTyCTO98EBya
	ouxX+m+vB8a5TGIOZZA4UM3AlnKyG5Y=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33226dc4fc9so529450a91.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761205850; x=1761810650; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwByf+n4jp5MlDetSCexzrKrLtoHg0zmHHS2wZ49+as=;
        b=O29fK0xQjNTjCnf7UGAaepx7K4Ji3cFghXW9bURK3rQ2yVaIHPpOTABx4pU1QPMJgZ
         i0BWDDazH82VoXDbkYuBCIqlvHPuYctTIIsh3lFIJf8YrFbyltEFwuaug/D4cMk8JWxy
         vxMlDQX8tR/spFldiFyKOTBzp8rTpIgzzOZdVxINjUt2W07PbH4Ll6nhw5L5HNMlFR3r
         /weu0vJrtmO7gOUCo0iG39P2bLC1mTtOqIAJRioJuTohqH1J0aOxUH0Uxpb7VMByAP2N
         Y3QFHZYdmsghpudxco+8Q+0PGvu8F50QoiDG1JMG81QiWy4tTIwLLhgMr49KbYB0GqNp
         HEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761205850; x=1761810650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwByf+n4jp5MlDetSCexzrKrLtoHg0zmHHS2wZ49+as=;
        b=WHQtQcm4D4EdXNraczPzFG2VMr43+1BT4YGtEJauVc/ez/b3HoTC4rNN0IC7yrZ7K9
         bA3J+5P9u7LPE/Q7ndIkdk8iqRdk+S75ycimszrmJZakKqZiH95psKZ7rbPXxTWxbm3O
         H2crsAEAfj0nAkTJoxrGJnoKwRtyanzGkmSvd4QCvE31V7nwHVGtdX6Cll2nbte6e4dG
         IyBr3dBBk7zdpYuwh54uOwAKKu5uMn7CFExei2uzR+X5FC9cd0XzPfw2cmJOU0DaiFuo
         PRewNlZN6Iz1MwtTxXyCK0tvxeTdzbSo+QnDZSLEjAyA2Su9lL3Yd4R/i8PeH394GGCl
         wMVA==
X-Forwarded-Encrypted: i=1; AJvYcCXm9DlWXEaF73u1c8bXDcCMBm0kN+PnCwKUhJq/sQOnB+/D+IF9NKECTchr02yVjC0ZXu0oFH9S5A==@kvack.org
X-Gm-Message-State: AOJu0Yxr3VaJSce7R+zD4K40cMDqmCOz6fKcN2axi9pKXdf8sq+6AgfK
	peExEg+VX19MjwwCs1WCN52CGjYGbGWNmAsupGR5AE+t+jvBfG281BvqKve9dA3NAEg=
X-Gm-Gg: ASbGncvzEeFKW5i6VGYe7jzaz64vWqrqN5zO5QB9nL6qbdkVbzTPPS2jXXvWyhmoMr9
	4zB9VJH+pVmrkIezxcSmhiQc7Q1v0eld/tvFDcAs4Y53tg6vFxmfp7vM/xh2GOcehK0Lwy5dWZW
	uJZnY1nIRmpb2GvT0UMcJhoGZpltHfz1YrNoqJQbt0NRFnVJ+SX+b7SALla86vOObeuZ2dmSSNn
	yNCfFMzoRxdPlit9juzYzbhDbgbgSRPCmi1SxXmCKGTiVZUl5fUCnD54fktBu9hh4KPIgAuCfkn
	FpQ9qNlQ2CH1E3WTjNRl98peLfS6OkJfRmH6l75Mf2XipGiJvY/CQpb+0fww3i1qPc44SY6vR3H
	D/mjxv1ZejpZnbuEqUvpiyZImgrOLgaMIHOtb/9xTu9pb6hd5zSO52xMrh9pjPXiLPCiLbo8PzM
	dtMrchKs57w4uZ1XZAxADrhSyJ4DwQ5vOKuDr+RXhSjE54SfulGe3VUkv8FZph8w==
X-Google-Smtp-Source: AGHT+IFRfms9e7PzLk9IgH6Ep9yL2WAFmAvRcEuwokRQNbyJf14nzx4x2RDzrKdFQpOW6sShCgNZrQ==
X-Received: by 2002:a17:90b:4b51:b0:32e:7c34:70cf with SMTP id 98e67ed59e1d1-33bcf9237b8mr26054426a91.36.1761205849913;
        Thu, 23 Oct 2025 00:50:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4bb8eacsm1292834a12.3.2025.10.23.00.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 00:50:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vBq5u-00000000xQf-0C9X;
	Thu, 23 Oct 2025 18:50:46 +1100
Date: Thu, 23 Oct 2025 18:50:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <aPneVmBuuTHGQBgl@dread.disaster.area>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
 <aPgZthYaP7Flda0z@dread.disaster.area>
 <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
 <aPiPG1-VDV7ZV2_F@dread.disaster.area>
 <CAHk-=wjVOhYTtT9pjzAqXoXdinrV9+uiYfUyoQ5RFmTEvua-Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjVOhYTtT9pjzAqXoXdinrV9+uiYfUyoQ5RFmTEvua-Jg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47751C0007
X-Stat-Signature: ucp1p8ru7f8faisr1md3563ekkwrfo73
X-Rspam-User: 
X-HE-Tag: 1761205851-653353
X-HE-Meta: U2FsdGVkX1+N1REOhXNoCvDJGvjsc0zpgSkTPp9Wot291S24uyRJxMoBI5DNZoiPA4t+Z5dkCsOJyikPRwV9I8dHyr2NIoXGoZRSxzC8vaE9F5qvlodBz38R3uGBUW2aVRGSpCy/Fl0QTXVqLOxJNEHYEU+9cQSOE01k+q4OjQVDG0CR3NnfkUwba79DWv8Y5+qxyMCilbf7tSFINXfvsOaS2IJkQHkIAgBtWCREb9yVS5f2UGPkipz8QiixtJqY7LIGawXlO22rU3NYgAVQj89pLWpcXZcC3uZz+dW7LxTfveXSSSE9JTrYTC73a5nKZiogm9PxqOjq6NYjJPFtqQ3wFiyhHaHRY+G+E4NNhJ6JGwvbDlexLbDEXuU1B7FUbuUhNvcAWXTkQxp2UjetgG3xUZkNTEUv72rzMwPq8IQ5d7lu2VPRG2jZvm2tiQFsyisYcceDouCyEnBvfHh5d37tkVuh+Yb9Oh/8mGrfN/fYnq4y+gty6UAtT4QzVs6QCApz85kI1YMqNzBZk5eR/AX7GSNf+pArG56Dksf+2CTt8sQ+Q1VgFbalQSnKH94dQh0FKvYNGFmPA7ZLG4s9f2nsYaFZwIOvG9YEEL+ghJfNRfRrHiYp4LNZHHTbHiegyJJ8lmpJH2HolDjKZ7fLtBhzwum/KmmZF+D/mkNzemGOM65M3ZOvloXsKelRcm+tWiTaIUipDwpk4UYZsp8vFH6td/jejDURPt6pUBCfxwOuwgIuOGMNcqMBQhqfcHBTGFHDUtoF3EV3RoOY7p99dX+XNJ+Q3m7KBvgXRKOaDbIbtXLxyOjRn2bDE5ZrEa10XFgF4dtLwvAW6Z41Jzp32do3d9AjBU//hUNgu+TEVxn0e1ekKPYN5zvu4OqA1aM5Culs3cx0S9iJT2l+E1Kta80UgHPxrp3QQS9Tm2RUS34zujE8WV6O6IROnn2JoPZXxuSmPZZs+P/+YHoP8lN
 sr805XPo
 xC1UZIpX+8p6mXoWOGgxnOqQKON5KuBGiaslj8Ml3FWT/QZPhhxGeMoE/1DTBw0cdlSSOt0dcXV6dyUEhtt2RwVmKemte3EvtbCcVofitgZHkAKv9ZHaHCIygBNNX+sKVD2czVbbDryUJ4hFWIrjSo2UPPp7TC3IHwj1SAPjbhSN7PQwEkm8bKELnBhz67G0W/os5CxsNMiyYOQ3uoaCCedn4l4O6/xgrDymSs19m9MGf5zPoyiqCKpOsZh6KUk6IQH+K/nXkDgx/Lv9l7AJi8EtDKa6nZ0o6u5p14HpoyL4OeJs+bqaO/0EqIUrNj+WI7mvekavjuDXwi34U3KwtGvdOZAdIGmVRNtCVk0dbsjerRuDamGOhD19dD8/yQ7s3Yvm5p512T0vYE7BcFbAtLsMl3AmgcGKII527uZziurNA97ndgbaLngNRjj3I/RflcEokjqEtD66X4YwRIvMjh57cj6BD0Mw4EA/10APufqoIkx0U9AjFfGlIW25THABnkD498pU4itSdU14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 05:31:12AM -1000, Linus Torvalds wrote:
> On Tue, 21 Oct 2025 at 22:00, Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Oct 21, 2025 at 06:25:30PM -1000, Linus Torvalds wrote:
> > >
> > > The sequence number check should take care of anything like that. Do
> > > you have any reason to believe it doesn't?
> >
> > Invalidation doing partial folio zeroing isn't covered by the page
> > cache delete sequence number.
> 
> Correct - but neither is it covered by anything else in the *regular* read path.
> 
> So the sequence number protects against the same case that the
> reference count protects against: hole punching removing the whole
> page.
> 
> Partial page hole-punching will fundamentally show half-way things.

Only when you have a busted implementation of the spec.

Think about it: if I said "partial page truncation will
fundamentally show half-way things", you would shout at me that
truncate must -never- expose half-way things to buffered reads.
This is how truncate is specified to behave, and we don't violate
the spec just because it is hard to implement it.

We've broken truncate repeatedly over the past 20+ years in ways
that have exposed stale data to users. This is always considered a
critical bug that needs to be fixed ASAP.

Hole punching is documented to require the same behaviour as
truncate and, like truncate, any breakage of that is a potential
stale kernel or physical data exposure event.

Why will we not tolerate data corruption bugs in truncate due to
page cache races, yet being told that we are supposed to just ignore
those same data corruption races during fallocate operations?

This seems like a double standard to me. 

Also, keep in mind that XFS isn't exposed to these bugs, so I have
no real skin in the game here. People need to be made aware of of a
data integrity issue that are noticed, not have them swept under the
rug with dubious reasoning.

> > > Yes, you can get the "before or after or between" behavior, but you
> > > can get that with perfectly regular reads that take the refcount on
> > > the page.
> >
> > Yes, and it is the "in between" behaviour that is the problem here.
> >
> > Hole punching (and all the other fallocate() operations) are
> > supposed to be atomic w.r.t. user IO. i.e. you should see either the
> > non-punched data or the punched data, never a mix of the two. A mix
> > of the two is a transient data corruption event....
> 
> That "supposed" comes from documentation that has never been true and
> as such is just a bedtime story.

I'll give you the benefit of the doubt here, because you are not
an expert in the field.

That is, I think you are conflating POSIX buffered read/write
syscall atomicity with fallocate() requirements. They are not the
same thing.  The fallocate() atomicity requirements come from the
low level data coherency/integrity requirements of the operations
being performed, not from some POSIX spec.

e.g. FALLOC_FL_ZERO_RANGE turns a range of a file to zeros. The
implementation of this can vary. The filesystem can:
	- write zeros through the page cache. Users have asked us
	  not to do this but return -EOPNOTSUPP so they can choose
	  the fallback mechanism themselves.
	- use block device offloads like WRITE_SAME(0) to have the
	  device physically zero the range.
	- use DISCARD blockdev operations if the device guarantees
	  discarded regiond return zeros.
	- punch out all the extents, leaving a hole.
	- punch out all the extents, then preallocate new unwritten
	  extents thereby defragmenting the range at the same time.
	- preallocate new unwritten extents over holes and convert
	  existing written extents to unwritten.

All of these are valid implementations, and they are all multi-step
operations that could expose partial completion to userspace if
there is no IO serialisation against the ZERO_RANGE operation.

Hence there is really only one behaviour that is required: whilst
the low level operation is taking place, no external IO (read,
write, discard, etc) can be performed over that range of the file
being zeroed because the data andor metadata is not stable until the
whole operation is completed by the filesystem.

Now, this doesn't obviously read on the initial invalidation races
that are the issue being discussed here because zero's written by
invalidation could be considered "valid" for hole punch, zero range,
etc.

However, consider COLLAPSE_RANGE.  Page cache invalidation
writing zeros and reads racing with that is a problem, because
the old data at a given offset is non-zero, whilst the new data at
the same offset is alos non-zero.

Hence if we allow the initial page cache invalidation to race with
buffered reads, there is the possibility of random zeros appearing
in the data being read. Because this is not old or new data, it is
-corrupt- data.

Put simply, these fallocate operations should *never* see partial
invalidation data, and so the "old or new data" rule *must* apply to
the initial page cache invalidation these fallocate() operations do.

Hence various fallocate() operations need to act as a full IO
barrier. Buffered IO, page faults and direct IO all must be blocked
and drained before the invalidation of the range begins, and must
not be allowed to start again until after the whole operation
completes.

IOWs, IO exclusion is a data integrity requirement for fallocate()
operations to prevent users from being exposed to transient data
corruption races whilst the fallocate() operation is being
performed. It has nothing to do with POSIX in any way...

Also, keep in mind that fallocate() is only one vector to this race
condition.  Multiple filesystems have multiple invalidation vectors
to this race condition.  There are similar issues with custom extent
swap ioctls (e.g. for online defragmentation), ensuring
->remap_file_range() and ->copy_file_range() implementations have
exclusive access to the file data and/or metadata they are
manipulating (e.g. offload to hardware copy engines), and so on.

fallocate() is just a convenient example to use because multiple
filesystems implement it, lots of userspace applications use it and
lots of people know about it. It is not niche functionality anymore,
so people should be paying close attention when potential data
corruption vectors are identified in these operations...

> And no, iI'd argue that it's not even documenting desirable behavior,
> because that bedtime story has never been true because it's
> prohibitively expensive.

I disagree, and so do the numbers - IO path exclusion is pretty
cheap for the most part, and not a performance limiting requirement.

e.g. over a range of different benchmarks on 6.15:

https://www.phoronix.com/review/linux-615-filesystems/6

i.e. XFS is 27% faster overall than ext4 and btrfs on a modern NVMe
SSDs.  Numbers don't lie, and these numbers indicate that the IO
path exclusion that XFS implementations for avoiding invalidation
races doesn't have any impact on typical production workloads...

That said, I am most definitely not suggesting that the XFS IO path
exclusion is the solution for the specific buffered read vs cache
invalidation race I pointed out. It's just one example of how it can
be solved with little in the way of runtime overhead.

I suspect the invalidation race could be detected at the page cache
layer with a mark-and-sweep invalidation algorithm using xarray tags
kinda like writeback already does. Those tags could be detected in
the read path at little extra cost (the xarray node is already hot
in cache) which can then punt the folio to a slow path that does the
right thing.  If there's no invalidation tag present, then the fast
path can safely keep doing it's fast path things...

> I think it would be much better to fix the documentation, but that's
> generally out of our hands.

We control the fallocate() specification and documentation
ourselves. But that's not the problem here; the problem is that the
cached data invalidation mechanism used by fallocate operations does
not prevent buffered reads from racing against invalidation and
exposing invalid transient data to users...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

