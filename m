Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE46CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE6A6B008C; Mon, 22 Jun 2026 11:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F176B0099; Mon, 22 Jun 2026 11:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60346B009D; Mon, 22 Jun 2026 11:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A49406B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:48:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 251781C1174
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:48:28 +0000 (UTC)
X-FDA: 84907980696.07.D307380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8198A4000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:48:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hksrf1sl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782143306;
	b=0FUfrjpP99AIxAMBGjGl2Si03E7XnBvmoo00FiJ7ENtf9ztV8ESQGAhrkBThGotrF9kppL
	/tljF8UTEgIxX7ubUPW/yFJPglmdhMq7iEEMJ9Yays94CjMlh2Z3IWoRPcu42TbupPMYAO
	BrGGPR0uT+H8zvC57rhCuDWGNZ79W2M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hksrf1sl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782143306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ld9ijHTMZKBzCcjtyWIwxgIs4KRDg6NBq43WCQOREXw=;
	b=WuTkRUGCZldtsze3rLaLBQsgTlFaN7qFRQvQWGSkWip/XisD6stvK6EyxqqzgNXVRIg5kG
	bRtqIcFZvC6/IQ7pvg9FcoMinZR8qBHXp0RZG7TK6qu5GzbEi8U7bjNIDZt1BLouqBl+15
	lGI2g/MdIwx66BSt29jgOV2uNx+IC6o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1ED54074B;
	Mon, 22 Jun 2026 15:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D1B1F000E9;
	Mon, 22 Jun 2026 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143305;
	bh=ld9ijHTMZKBzCcjtyWIwxgIs4KRDg6NBq43WCQOREXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hksrf1slb3g0P8qdFp9lx8C3DXXPnzep8daVfJmQpnKp15/sNkWjHOIt3gOb+Xbif
	 iExQ8wnSkci/HJ5WfO7Lj9J/axGDVEz1fUpkJL6E1DmUOaKDtmuM1kxfIz8OTwo2vx
	 JDbKpAXikAa7mIV6Q6CSeXiox+ibTBzeqE5sl6fgHLpMIIn0TKnzgsvWTOhvAuhvKk
	 hrOLM2IF2HcaEsgVjBfVKYJAk8ZUNXsIof50IWoB4UG9K2wNkHhd4Mzas1OYK05nWm
	 44o2YO+Y/sx5J3pLQR5dPFwRaaF6Le/SM2dWyEhLFtM+XGMQGILDjPI6Fi5wANeqWx
	 npGxJ3Q/3rKDA==
Date: Mon, 22 Jun 2026 16:48:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	Anthony Pighin <anthony.pighin@nokia.com>, linux-kernel@vger.kernel.org, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajlYwMYswMO1LUXk@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <160f8cdf-0d26-43f3-b487-4181e6374782@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160f8cdf-0d26-43f3-b487-4181e6374782@arm.com>
X-Stat-Signature: ntpwdqxkk33k88rwgzrr34g69jejxhp1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8198A4000D
X-HE-Tag: 1782143306-261814
X-HE-Meta: U2FsdGVkX19Nk48yDkRv1fnvqv/VFxc6U/vpRcm/tWqfmXCwYa2S88p/jIvbDHqTU1esJbMFTkIRFtVyE8CAyqjP60iUj5un0QddgVxDM6q7/id7ZIlpSWHy7QclSqGpo1xtsdSl4l8KBxxn/13o5cQvE260ft0fT0RjCjoQp592eoAhrZwnM2LR43M6RHl3H/puy5/3CCQQ8a4HqrqHfUFfy+IUi6c/DdMnqel1mr94DXeqNoVm2oH4F6kSDHamvyemolAMMWNGOuYBNn1U0WSqST4AnVSEdDd0zQONRPS+yumcfif8F8mEpa6c5DtRqj5LAtqAVpZssBeEBKLxlrxN1eaZu8ANaMdjPcMQe9kG/I/4PdaxBYPeLEywPjW+tdqZk8A3DxEYhHTo05q7ns1/IxwhRdZJ9B6O5nDTI6va8kCq0y7wwhg4i7nox/qpg6cB2+BYndYLvvrLiOZOUrRp7HvrCsNVmUwkW44qLaXMqdQVfD5PyrtJdf/oZC5S4PVTbQJJwpTCtl9Qgsv7hSaUHjgEm3zS+tuY7D9pdf4B0hA8eeyFKehHKn4XCW8tUVlGy9ZqphkNnKGtyNUB7PRXGTxXIXtm6GCDFJIPoPr3/LO0zZCdXDTsA2crbRZJg9fU15c0TLr5dFyQse8fpJshhdRnWMUElswdDJTwwRZ7gUbV0SWo3JIdRxkstHRCMWNLZhOo9T/nRfvxx9xP4XeX9ySUS8JrurVXMDizTBv4jCuKK+b+90gNkP7NUNtFX27WHI/ngrCrQNnxRsSsZMYT168ga63MG3Tk6VkzKx5/ctMJw2/W+R1Scq/n5ZgupME6YFywMlw/T/2WdgX3Q36K4DjTPZE8KKndnsgkSNrfR+BlbTYbxAL5k+vnnsjrejgCV7noIoc285J7LRASSVgCRJS367EL+dCPZW57W2l1yafhIuV2H71JPVtNVofQLVr7YSCrNIOx5l1pBFB
 ybu0qGRx
 lXknCbAxvzlNUf/glJnK12NG4CfjakuHj9fJY8MzrSp4PRnjgSzDefoO+Jr0wEEVrQX0LkhnHfAVnvm2iX+MmxBbkapV11byLcP/KPN77nGpvP8WoUI9cgBiXdwey1faFuWZd27iMG9xmOVqxP5k8LEi7BmXuiLg6tcRmrOiuy9Ll3+MT0aGaog+4ku9NlHg5HwAXeCqu6y3KrxOVRQt89/ybeK6cGVYPo1NHFpoXFgEUX/V1A66S3/HbrLUxX5CbMj3t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 04:04:18PM +0100, Ryan Roberts wrote:
> On 18/06/2026 15:55, Lorenzo Stoakes wrote:
> > +cc Ryan for contPMD
> >
> >>
> >>> And maybe there's a CONTPMD architecture we should also consider?
> >>
> >> ARM HW supports "CONTPMD" but I suppose it is not implemented..
> >
> > Maybe Ryan has thoughts?
>
> Sorry not quite sure what you're asking so will give a generic answer:
>
> Arm arch does indeed support CONTPMD at level 2 in the same way that it supports
> CONTPTE at level 3, as follows:
>
> +-----------+-----------+-----------+-----------+-----------+
> | Page Size |  CONTPTE  |    PMD    |  CONTPMD  |    PUD    |
> +-----------+-----------+-----------+-----------+-----------+
> |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
> |   16KB    |    2MB    |   32MB    |     1GB   |           |
> |   64KB    |    2MB    |  512MB    |    16GB   |           |
> +-----------+-----------+-----------+-----------+-----------+
>
> For HugeTLB, Linux/arm64 support all of the listed sizes today. For !HugeTLB
> (i.e. THP, large file filos) Linux/arm64 supports CONTPTE and PMD only. We could
> (and probably would) extend to support CONTPMD once THP PUDs are supported.
>
> Not sure if that answers the question?

Thanks, that's really useful!

I think Jason's concern was that we'd have to account for contpmd here, but
that'd only be w.r.t. THP rather than hugetlb, so we're safe for now I think!

I guess this would be a new >PMD sized mTHP size which... I really hope we have
the THP code in better shape once we come to that :)

>
> Thanks,
> Ryan
>
> >
> >>
> >> Jason
> >
> > Thanks, Lorenzo
>

Cheers, Lorenzo

