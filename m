Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C797C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21A26B0005; Sat, 11 Jul 2026 04:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB326B0088; Sat, 11 Jul 2026 04:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973396B008A; Sat, 11 Jul 2026 04:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6F56B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:38:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E05C81C3EF8
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:38:15 +0000 (UTC)
X-FDA: 84975843750.28.E523552
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D42040002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:38:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BY+Mmh8/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783759094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzbbZ75tk0Gn1LrlFpT1UxEwPwXypDF6thZXD0DNZlY=;
	b=0DYzNm91Q898bygwtwKxG+4YFZheFZuVpwpZs6Dh3QLYE8BlM6VFxmrCWQdoF1ol5bVdtV
	FAxJyU0+qT/NeEiViUWz1ntcPRRxMBcnsdnP6ok+LtPD4aoFC3j7eZtlqlNujBvxm3ZoqR
	ShATqFnRnJVjuWYrYSja46MDShOnfGY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BY+Mmh8/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783759094;
	b=MIndo9rywM6ZF73aSRTvAf3Ec8HJ9j04MJwLLJ+yChtQU1Ngwa/UYya/4B1dmIPtGQ+gQ6
	ljKBZ6MdWPJwZL7qk9JrJRWRHMBJ5rEpcnu/22NGg0lkaFoP9GZCf4XJy9rc8vdMbqNEJI
	NJiuPkPus5pygBH52Pyo6+2PmGzA3/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA05960051;
	Sat, 11 Jul 2026 08:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667921F000E9;
	Sat, 11 Jul 2026 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783759093;
	bh=BzbbZ75tk0Gn1LrlFpT1UxEwPwXypDF6thZXD0DNZlY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=BY+Mmh8/jRilUEL9EUyh64uk3XDuqoCgdDxAwxDMiucPAy+8WcCaH9Ro1jHnLGy01
	 gCkb5GbNgGWXVZnZkM5gZlt/9X2jol+Gy40MZGt0bmxkNEDwYrXeUTPJdgVTtO5ZVt
	 WK5gNNgBBUbW4ZOLGJCBWVON0cholPeLMi4pXA11dGIvzsTCH3D7jioxJIhvgVPsKH
	 O/N5qUHiKNciqobi+VvsWkvXEfJXdwf9ExS/NaFZKsc7r/i6rmWFiGumfqyqM7Am4a
	 H6kjsfC8N42inUSM811TIZoIVSSTFL2tj/aeVHSNAw7QeG91L8mozBqJGsWv7twIhc
	 gIu7PK9tQco7A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
 Anthony Pighin <anthony.pighin@nokia.com>, linux-kernel@vger.kernel.org, 
 Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
 linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260630124629.GE7525@ziepe.ca>
References: <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local> <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca> <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org> <20260618153049.GG231643@ziepe.ca>
 <ajQRY7tHShCEz8vg@lucifer> <20260619131658.GA1068655@ziepe.ca>
 <ajlnTdkbmEzy_uhe@lucifer> <20260630124629.GE7525@ziepe.ca>
Date: Sat, 11 Jul 2026 09:37:59 +0100
Message-Id: <178375907930.146648.4528264473005431141.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1766; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CyRaJPcTWVJNhdmwT9EN24t6ISjiq/A84da/xrY/4Vo=;
 b=kA0DAAoWz53NioHifxQByyZiAGpSAOiiJdkLwOBNYMQ01kLLPZdUye72/Ik5n7i90gLpnzNQ5
 Ih1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpSAOgACgkQz53NioHifxTT3gD/Zw3+
 WKEGhLawmfopUhw+JxYey8s/tP1cc7qS8Hwo83YBAM2u9V8WmkkvOpEFTVv/K3q4Vb7NxE+pRuG
 uZp1xjdwG
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D42040002
X-Stat-Signature: bzx5wot9s1xbjk8m3rj69t6kj8yq6md3
X-HE-Tag: 1783759094-353145
X-HE-Meta: U2FsdGVkX19mYtZvt/N3x2kLAiukzBD3oqRt+kAQS8aCpmmEPCoQ9CHiArDmbWcx05Jq6YbSsfJqUUbsPbX198lu+CPU4NUQtU6ZpWGv0v29ISgFRntXYnl0GxI1PV1bGOrpfT9C0KSBtbA7Q4IgFgsZo9K/mX2rIUpoQytakwDhtWHmPhKmVj6F6ddpFEZn2ZbOpMXILr4ryA2Ft4Cggq8RhCcgmqkTPxl8f6PQASprYZbyiYkhsiyH+3KVsJQg7UDbyYcehFkU5Yt+Tz054bFsXLKy4s6a+wOaJw2rfUtTkd2k0r0Zs88RQt5dXu+KZgT3DSAIq77i6hGm7mfRY0YDN40po9Jonk+caYwjaVFH4oTPBHVul9VszaS21M2h3gGBNjM5KFv6Ejq8Msrkqkpq3cp6dYNj3EMiAgLRiJ5Rt6cVF2W3OEgLlBE2e6ApiZQ/IZXs821CX81LaAV/w1ct9dbvtomWlQ4cvwtjTK/jepS1cGdHONCi0UTu6EUe/2utO5kaHQNDe3o/v3b3yJwRYB6iTsnlSV6e7KMQP1i02fI5/XRFz41B4ha/VwCJIvM6tLRt1brh0YwhJpPawCLTyyuxwKLcSN23KP2YWENpfjYrEnfYCAm2FvP11Aoe1yUAmGMM1KI3ereebsxVznwO2oCBPyHP8jrRR1z8oOREfiOLGqr56oMV5HUqF7eE3tLAHYA9TndtzgX1QjHczX7jmJYEYVPOwnbNPwPlj/6OuRlOJz9D6OnkxVfGfQZuLwqzp5/IMl/4v4Te19NsLTVAypxVW4b0pIRPCgeyCJV/X63gjEOOL9RevmLDzACvSQo+FfJj8uyXruYkMsRW49N7N7v4pq2mkTd5+UYy0WBBPHBe1kA3Kgq2Ftl7+4kLFWw8AWqkHnhSwMp8a2Yj5K2GY3OLbOVfiW/Yo638vDGV4XJ04kO6ljgjLj8EmwBYq2hqzDNqhzvIrVcCSN3
 tc2VBD0x
 l8WbSKlmu4HXTrAc7snRc38+zTBAFdqTY+QQtm/x78LqOr7PXPqGv/2FcYatyHEyM7WjuMTAiZniPU/ZVwBktl1B7XDVHNuAat2R7Mt4SJuW9qLNGxTWjIewy+17EcpTLtObDkyvjXOYNgcCEPrTFFOP3Cfnc1d5NV+DTcWyH7DvtG4ouyeLJ+21tf+iROqaLyuo8mfIBO4CX+4vXPFxKIdftOBgPYRNAmLK1p3YuupXLaqYMCaRJynS2mTsAP2dI5v+GhZPo2KIdNRvL82jIiBj8nfZ6Q9aBWuG3KxxjMMD6pKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-30 09:46 -0300, Jason Gunthorpe wrote:
> On Mon, Jun 22, 2026 at 05:54:10PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Jun 19, 2026 at 10:16:58AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jun 18, 2026 at 04:56:06PM +0100, Lorenzo Stoakes wrote:
> > > > > > What you're saying is that offset 0 of the opened file might correspond
> > > > > > to a PFN that is not aligned in any way?  I had assumed that when trying
> > > > > > to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> > > > > > mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> > > > > > case would be 0 and someone needs to know that it corresponds to a PFN
> > > > > > that is misaligned?
> > > > >
> > > > > I do expect that the pgoff space is usually aligned to the pfn space,
> > > > > most drivers do that or could be improved to do that. There will be
> > > > > some off cases, but maybe we don't care, and VFIO should be fine.
> > > >
> > > > Some stuff has weird assumptions about pfn=0 at start of the range (DMA for
> > > > instance).
> > >
> > > Do you have a pointer? I'm drawing a blank what "dma" is?
> >
> > (I am obliged to link https://xkcd.com/138/... :)
> >
> > dmabuf as in [0], where vma->vm_pgoff must be the page offset
> > into the DMA buffer.
> >
> > [0]:https://elixir.bootlin.com/linux/v7.1/source/kernel/dma/direct.c#L550
>
> That's not "dmabuf" that is the DMA API's dma_mmap() interface, very
> different thing. This could probably be reworked if it is some issue..

Yeah right that's what I mean. And I plan to do some rework around that as part
of mmap_prepare() I have some slightly bitrotting patches for this that I'll
shake down at some point...

>
> Jason
>

Cheers, Lorenzo


