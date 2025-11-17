Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93CDBCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 20:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9838E0002; Mon, 17 Nov 2025 15:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582E66B0022; Mon, 17 Nov 2025 15:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423708E0002; Mon, 17 Nov 2025 15:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27B916B0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:51:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9EE913A5C6
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:51:35 +0000 (UTC)
X-FDA: 84121294950.05.0D50B34
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2A2220007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:51:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=yELHYEdv;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf03.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763412693; a=rsa-sha256;
	cv=none;
	b=iLTm5C8xwAeFaOOj1vZsnU4Mpny28cEkU7i5UsJMI8RVQWU0DCSPof0bX6YcBLYKJ0Yg4X
	QSvIaMA7jYZQ3moXWBQ9ExSGmwnuXsdqkwI0pve1kpQY493bupq1GgMWOhp4F/BuZbAnfx
	QFLUtIiye8XKJQo4pMPEcZMHw3fd/Hg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=yELHYEdv;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf03.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763412693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzhSFtd1TJYR/cIblKSU+QrS3cy0V4ly+fmhKB6r+qY=;
	b=JrkHlOmA4ilMt3RJpCraANYryMDGV4Z6EyVqIDpL/uYmwKAlBrgtxjWExe9I2EEnhdNYvi
	m+sqVRgW2bg+jfCGLqRheTtjlYj/a5mOfp7NBHVZdigx/oxbx6qP5jZHqbcflX2vgomfSH
	0Tv4ycfpcQYQrto6KkTnm4AXnljYESU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so3720800b3a.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763412692; x=1764017492; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzhSFtd1TJYR/cIblKSU+QrS3cy0V4ly+fmhKB6r+qY=;
        b=yELHYEdv2PQdbsFIhKTz78xuOfqutOYt6YDAxJ1q6bCCPa1Z7iXiybb8gPNsnxXDIl
         HIo5trudzUcogy4buSO4ufuPFXRB8AUsHRUDxQ8/1NCP4OTe+kCXclv7cPkew1VXP6yx
         jzwXi5RYWWFPQfbhezV6bEG8uowxUNyVvw0YAjX/Kihzkb/uBJ8ivV23nygRovs7Igb2
         WnTGNviVj0ocGxdnjAKJ68/tPGB/ogqBgGd+8Fr/79vipJ8fxWv/35E4WlbKlMALPpkq
         iNTtSDYRCGer9PFib0OZScxMHYOeO5QxH1M0P/psImFd/cKjMW5Um/6ga2UdGvEQT4Ho
         FODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763412692; x=1764017492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VzhSFtd1TJYR/cIblKSU+QrS3cy0V4ly+fmhKB6r+qY=;
        b=DMi1qt2qM5X+a2qRdvfHk9tT1Vr3sZp+2YXIGlGG2DGMkrhR0kwEbwoyAMOg04w+dy
         rndy0Pj0kqRcwBM1fu4goZ22qFvJl4xbgNwqRPmxbd7PILBQNoLjlhcER0s4CqKvsAmO
         V6nn0JDKZN3Ech3t6/FpVvYHsOy9GqUqWUAMEkcLjvR9dZjE7xgkcUjH1c3Q38ErW4oz
         vvfouzbOpiM8PNK3GdseIV/MnYWOh6RoECDhBh4h3YmDyTNoJQ/DK4S6cpVy+c+9R9VP
         D24+lYz4cf2LmtBkxxuqddgltQ7QJOpSylQxm2IWzrR/ngJ23fojRqEz6fRfCAM9zJr/
         f8dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIh0amM+995ffp1JwEgWge91G1Rq2EMjlFF1zjrpJY8pSYXSUaICVBGGSwKfgjm29QYk+tccPWew==@kvack.org
X-Gm-Message-State: AOJu0YxelEB4n6y4M4idaelYkyrPjAt7Dj+hfmM9FQ7a+6UFFgOFlEyC
	qcbZUXwujhkUaoe6tShfjAaFlpxjkWBm7O3I+EvH7xFA3vTO3+PyTPNQA6Le9HQOkME=
X-Gm-Gg: ASbGncu4U7vN9xILtpaDYrJZaW6w0yxDW9hrlDwfKSOFFeZrqQsPkxIK3atBdFDo9Zl
	ShVPJui3/LhcT2HicnBu6JV0MAcNL8P/8Kjvk6KE9UjmKKc9EVhz69d+6XeF9PBjNxSt9Ce1MCC
	hPR8fYFCMAH4Gi8RmMDE14iXL/9K/18M+oA3oGoq1C1Pn3DUtFP/qQU6zx8A/UtNoWT7D8tHcd9
	/gTTB4ZcI37OJ29THnmR+JZpOV4saAUPTVis1cfrZO8ufS7NBBhQjdw2G8t3lz5XT7aFXJC5FZa
	etwLWdXVENYfM8jJP3nL3EBDgykr7pb83rXEYd+awXQ/P8EQWrMnVUaV/YJuuizCuVbVxeFx0lK
	1R66SO5ttfyRS8X0H0JMHRU3c+yrw+IyKymF341Ff3ffR8HuvXY5AxV65y1b+3dSkzm6I64W5vw
	ZKOiw18mDjeHvbD4ODQyLwtVmqsRbvOZ/aayrbM06r+aNPw/hm/6+cp0iRTguTPw==
X-Google-Smtp-Source: AGHT+IFmWemPBugDags9Dp2aFdnpOuTH5HosoXLiUasMcQMlSkctA94mD5u3ieiUdMxFP9/1+M2F7w==
X-Received: by 2002:a05:6a00:982:b0:7b2:2d85:ae59 with SMTP id d2e1a72fcca58-7ba39ecfa9dmr13503855b3a.11.1763412692398;
        Mon, 17 Nov 2025 12:51:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92714df0esm14242994b3a.37.2025.11.17.12.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 12:51:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vL6C7-0000000CADH-2ixk;
	Tue, 18 Nov 2025 07:51:27 +1100
Date: Tue, 18 Nov 2025 07:51:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	tytso@mit.edu, willy@infradead.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRuKz4F3xATf8IUp@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <aRUCqA_UpRftbgce@dread.disaster.area>
 <20251113052337.GA28533@lst.de>
 <87frai8p46.ritesh.list@gmail.com>
 <aRWzq_LpoJHwfYli@dread.disaster.area>
 <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <aRmHRk7FGD4nCT0s@dread.disaster.area>
 <8d645cb5-7589-4544-a547-19729610d44d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d645cb5-7589-4544-a547-19729610d44d@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2A2220007
X-Stat-Signature: qcwme5bsrg38sm6xwzi36zutfrhnj1ab
X-HE-Tag: 1763412693-16675
X-HE-Meta: U2FsdGVkX1/EZb4FP2iiDmi1WAIiPFxiOo9lkqgJexypRopr15zkufn+EIFofUFiZ7c0bQOFUs+rmFXAS5qQ6kFmTK00SWAfLdihZHvl7R68w1w0wks5Tq9Z3FLM+BFcb7G71c2q7pqG6pfEoLNe4idxRCxCcU/ScKKT4aipEUO1UE+HmJJczXEksuksDRbiEIDtmdjjO+RUZxU0j85LXLGf77nYF4EHRszU4g983N/ZIjHeESFPBafHZbLXFfxlIXZMXIg8xMyj1SfYL0i5umNnwyN1o8RTGpeXALD/YpOzuGk2rD+u2cOvY58R96iqjSjxu5ak75ugrO/gg49Z5aNp2l7hzMnpR+Rsvpfrmmp9bX0hj62CPnWlp/rEVJ5mYs/e38nxiqc7EsR881/suka4fBzNZWh9A+BspQHpqhAUfpqxIh+NUpAnAnhbFy5xyDqFpsz3ClCpCJ1U4PmL1ZnGMwLQf4TujVPge+I8xye77058+RZx1Hlg/buMda16A5lfkX7H0L46SiTwr0vuJQrUEIGt4GaneSdDQL9kMd0CDPadTCDtnlGWr/fHX6StphMFqU/iQ9ZRtS00A8KVmNVXDLNsOJJ0GLXaR1s0dP2xlvdWSmC+FYRB0mi6gHsdoggr0vIpl7fVQmAH3hR+xcSjzGf5ppKYMQsp8foGcPlVKXsf9tUtB77pUImE5s8Tk2Qjz4wIex8E1nfydk0Lq4FRUHs7RuuouCU932EDdgEbQsROzQLXHFVS04qjsMWLR0+9pODxTCMbCtdDEcSdJXXApuM82gZJF1XuDJu3xBqc9sEkbXqKRiiINJUYjtZMsmQeyJdyZPZAJAkUAaEZkqphv6orwvbajmGzN/EzLsR2Q/YVsQzeIFoLl3NKQgFjXzL+6iJwNj6f5JcCqA1/nZhLkY73O3yLYzqjCrergxBh5ptmvjV19hYbvN765Fs0frd3RxhS5EKnBmcMnwD
 QyMLhK68
 LoX9EmDWM9tuz6NjHkJuN187iby8xoZAp/bx4WgOppOnvxCe+K8Cq7CF4EecNt95vm61mYjwdVN+xfxXASIHY+bKRou9rgSrsMPs9kPyggNfKrr3mHLod/gIZpCOZb6D0rV1A9zI0SSq3t/myfBugKlZEfnAaq3q+8jHig8o0FdIBa3U0+Ybc/n0VOqdltTzjbB2XFepU5RxQixMp99R3FQJ/riTxifbD31yoHKtocw0lPxJjyQ9R0A3v1uJrN07YQOx1j5BO8eeKRH1bDKsQc7ZLXwvd1TllBFuXfM4uyBtBjw+qy/oKiBmXZjmGUsCeK/Qse26i3NZ45LY325lWDoadxqs9EbUK+MSjS3LCOoNFQJdMXkeaWq2NEeic0yS6ujVGo30w+W3gqm1wEW+O5xFOfxccQ88SE0dBYKPKZdNnX3uEyubupEXePgOooPiiW5bsAfXV2zZCs+EYLzJs2fp+4jzXfTtdowo7EeMiqW69pLtmZ+MbXuPKfq3nvLeV8hIuTrpB3ZVUI58=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:59:55AM +0000, John Garry wrote:
> On 16/11/2025 08:11, Dave Chinner wrote:
> > > This patch set focuses on HW accelerated single block atomic writes with
> > > buffered IO, to get some early reviews on the core design.
> > What hardware acceleration? Hardware atomic writes are do not make
> > IO faster; they only change IO failure semantics in certain corner
> > cases.
> 
> I think that he references using REQ_ATOMIC-based bio vs xfs software-based
> atomic writes (which reuse the CoW infrastructure). And the former is
> considerably faster from my testing (for DIO, obvs). But the latter has not
> been optimized.

For DIO, REQ_ATOMIC IO will generally be faster than the software
fallback because no page cache interactions or data copy is required
by the DIO REQ_ATOMIC fast path.

But we are considering buffered writes, which *must* do a data copy,
and so the behaviour and performance differential of doing a COW vs
trying to force writeback to do REQ_ATOMIC IO is going to be much
different.

Consider that the way atomic buffered writes have been implemented
in writeback - turning off all folio and IO merging.  This means
writeback efficiency of atomic writes is going to be horrendous
compared to COW writes that don't use REQ_ATOMIC.

Further, REQ_ATOMIC buffered writes need to turn off delayed
allocation because if you can't allocate aligned extents then the
atomic write can *never* be performed. Hence we have to allocate up
front where we can return errors to userspace immediately, rather
than just reserve space and punt allocation to writeback. i.e. we
have to avoid the situation where we have dirty "atomic" data in the
page cache that cannot be written because physical allocation fails.

The likely outcome of turning off delalloc is that it further
degrades buffered atomic write writeback efficiency because it
removes the ability for the filesystem to optimise physical locality
of writeback IO. e.g. adjacent allocation across multiple small
files or packing of random writes in a single file to allow them to
merge at the block layer into one big IO...

REQ_ATOMIC is a natural fit for DIO because DIO is largely a "one
write syscall, one physical IO" style interface. Buffered writes,
OTOH, completely decouples application IO from physical IO, and so
there is no real "atomic" connection between the data being written
into the page caceh and the physical IO that is performed at some
time later.

This decoupling of physical IO is what brings all the problems and
inefficiencies. The filesystem being able to mark the RWF_ATOMIC
write range as a COW range at submission time creates a natural
"atomic IO" behaviour without requiring the page cache or writeback
to even care that the data needs to be written atomically.

From there, we optimise the COW IO path to record that
the new COW extent was created for the purpose of an atomic write.
Then when we go to write back data over that extent, the filesystem
can chose to do a REQ_ATOMIC write to do an atomic overwrite instead
of allocating a new extent and swapping the BMBT extent pointers at
IO completion time.

We really don't care if 4x16kB adjacent RWF_ATOMIC writes are
submitted as 1x64kB REQ_ATOMIC IO or 4 individual 16kB REQ_ATOMIC
IOs. The former is much more efficient from an IO perspective, and
the COW path can actually optimise for this because it can track the
atomic write ranges in cache exactly. If the range is larger (or
unaligned) than what REQ_ATOMIC can handle, we use COW writeback to
optimise for maximum writeback bandwidth, otherwise we use
REQ_ATOMIC to optimise for minimum writeback submission and
completion overhead...

IOWs, I think that for XFS (and other COW-capable filesystems) we
should be looking at optimising the COW IO path to use REQ_ATOMIC
where appropriate to create a direct overwrite fast path for
RWF_ATOMIC buffered writes. This seems a more natural and a lot less
intrusive than trying to blast through the page caceh abstractions
to directly couple userspace IO boundaries to physical writeback IO
boundaries...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

