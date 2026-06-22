Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7226BCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47ADB6B0005; Mon, 22 Jun 2026 11:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C196B008A; Mon, 22 Jun 2026 11:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3693A6B008C; Mon, 22 Jun 2026 11:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15EA56B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:44:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CF47889DF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:44:27 +0000 (UTC)
X-FDA: 84907970574.19.B41DEC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00F6E1C0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:44:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPRA+Z0l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782143066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5ESoRNgBLwOTBhJXSow8bOLzdmw6ZzRIPgjJzoRAI8=;
	b=KHK9SiLBR6obyqq1BvDw4ZDsmBy/fvJSc25/3SvLM/UAI5i+QzzskO0NZn94uD7Yd0ZFGU
	6dy2TnNdLu8AaACQSip2guBzdkxdxTh19iH12mFZl51nDG8Scr17UwrUlw1QtQ6hQw1dz6
	xZcktp39IlfdOAWttg75kEJIC5sb8+8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPRA+Z0l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782143066;
	b=P8+lTvp4C1T2a9ImqhRcZFe88wT67jw5x2SO9WgIqvB9tMimowOFk+xlk4Jxia8aJQWzeW
	DrAuYUGKBVVX9kYlik2Jzpg5BjO+VRIA4BH/h5zskdj+BWe4TMDm4Fw4WmMzzZuWCIvceA
	5GNCg++NpctXf6AufenFWkXnzRnrnj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E3D540846;
	Mon, 22 Jun 2026 15:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983001F000E9;
	Mon, 22 Jun 2026 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143065;
	bh=p5ESoRNgBLwOTBhJXSow8bOLzdmw6ZzRIPgjJzoRAI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FPRA+Z0lGhzSBNG7x40scyu5ZxhiL7xH4BQsl4PeAFpfXavbpemnvvzyVySTYGXjd
	 aimj5J9A4vRKhrNN1tUKAmdebuaMPewvpDXCak2imn+JFRSAp6Uu5+zvT4erhJIGOR
	 A3E0e4GhEcPffY12owC2uYJ4dvpIQIlFefRZiq5VsPYPt4KVsLLsV+aXM9t2Kulclh
	 qVVhqd3sRCTyrH5xF6aC+fkF8jioOlPipzE5Jwb0rgSwRIOpGYArz65BSh6K+57isL
	 novbv16+TBssOK0i5hNoCJS8DxVoSjZXS5fQPHLzylVGy4qBNssmzz8A4t6s2Ujn+O
	 nKXW/pV+wOFow==
Date: Mon, 22 Jun 2026 16:44:18 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, Anthony Pighin <anthony.pighin@nokia.com>, 
	linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajlX9BH4E4JncZqs@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <20260618152805.GF231643@ziepe.ca>
 <ajVqRiAMG23QGseC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVqRiAMG23QGseC@casper.infradead.org>
X-Rspamd-Queue-Id: 00F6E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6wscmsare8skpceqfrxjjmq5ik1c18dt
X-HE-Tag: 1782143065-17503
X-HE-Meta: U2FsdGVkX1/AA8XWkLa7MH2EvfqguEPwDHLfMJOeKbyltMzskwnjLQcpnrnRdcKcqCV3TcwzbJZPvjIRBw4seDzZ9ueXmWTnxX28f+RRATaLH/w1Y+xw/qIJQk33oZMTRdgRfG8V181W7ejO5i6HVZqBVqcepc7Kn3Asd30Ow1dGryBacHnzBWWYh2Sq5zkhZnxdpppxc3AfkgUhxIGisFbK3cleDsAeYlV9dDJMLyOYNBw/wzZIo+AN2dXNUFv//GUDocd4RYr+vBZP+IttocpDPZ6fcN3xp+Ijr5ULXWccgpjLEcRkHvURs1XGfgBizKj37YFRDDglpiK8oYtEIzpmcUKreuXRM5xL6+hvIH75sWXVEcr3MOo7+T9sM2r2s4tbq3vt1TE7rjzznGs4U3gkqwLmXiS1keg8Ot8ITMxX9TgF1jFLGT45ggrD/E+LtdTpu2spJT+YGd0K3Xplwb9HgwYXqFPZmKx5SoieLIT+lo3i6IjTlqCcxP7mhOeqjAoM/iddHPDlZZlWhLPSLJ3gxUAJaWNIJ1JoNkuj+9Nt1ty77oeYEqPeOGHD8utCIlHHgcpTQGUNO+AfEDISRj/nppE/z01rchuO4XwQ1bwpz6Mnc8VN9100hoI6awpi0Vw8gp0oeMcYgwKfMkBAS8SM+05LIH0fgVqR0L4H7uC8gQ1h53NYPYrecy7G9PXSLQ1pfYfzpQpjUB/pq/BvkCj0uKhXPB6PD2NDZWYtgHTDjMMbqyEy4kIB7o+sKEnPB6LBidQ0JX+yAhydYO00w7p0+G2wbQWyeoU1uLGNZv1uOhziqJ9Z6Tec+RGND+rcsBRIjWO5UdOQMe7cx69p+Ze0d/dXEAC8jSAiWvrFIUt1EJXjnoEHjYTG9sYeUz0eZDIGwb1eSkWmatJ5tdVnP5/eGkHQIIKp/DuZrGSk+mxbcX/Uw/9IX4SLo5NOCwFdB6sHdYNHy+6298Pg5Ze
 gdr6/z09
 sMpGCbgnhzNNcbBde/O+4I76ZVV5EA5eETMGFeIkem4Iz61vpZ3cSCbp8gKgMc8qYoA3H9QX+1YZ1HSG962MpEM3m8AUwo2b9yylkZYW2X2Z1RBf5I/KLMpp4C8h1e/njtccBrEHtR/Vw5pby0XhS3i8t4Jn/5IIFMltwqk+iaOZezfqItTlj8F2ErvMHmpAFOCg2o5u2jlQFnadX+8FYeZBXPjTTXOmn99v6Fe/o3gv9wAVPnUBFkJk4T/Z6pTQCzaeT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 05:11:50PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 18, 2026 at 12:28:05PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > > Can't we figure this out from what the driver tells us when it invokes an
> > > mmap_prepare action?
> >
> > VFIO installs the pages via fault handler so there is not a naturally
> > existing way to pass in the pfn?
>
> Is there an advantage to doing it this way?  I understand why we (eg)
> demand-page pagecache, that's obvious.  But I've never really understood
> the advantage to taking page faults for PFNMAP areas where we don't
> really do anything, just figure out which PFN needs to be installed.
> It defers page table allocation, I suppose.
>
> > > Not in favour of that, fear it'll be seen as a new go-faster stripe.  Ask
> > > somebody how many free pints they want and they may veer rather towards the
> > > upper bound :)
> >
> > I think you need something, otherwise we will be aligning VMAs that
> > never have anything larger than a 2M THP to 1GB boundaries, doesn't
> > seem good.
>
> If Lorenzo's willing to move the mmap_prepare call earlier, to before we
> allocate the vma then we can do it that way ...

Hmm, I wonder if we could defer the get_unmapped_area stuff until later.

Taking a quick look it's actually not totally insane to do that... Let me fiddle
around with it...

Thanks, Lorenzo

