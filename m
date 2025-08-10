Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB29FC87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 08:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669AD6B00A1; Sun, 10 Aug 2025 04:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619E96B00A2; Sun, 10 Aug 2025 04:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52FCA6B00A3; Sun, 10 Aug 2025 04:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3086B00A1
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 04:15:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF01B136CDA
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:15:01 +0000 (UTC)
X-FDA: 83760137202.25.055CFEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3128540004
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:15:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YW+c4kfO;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754813700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGV62aXBxPBt6Z4gl6ZnC+Tm/TTNlh2Vs7XYsyKd+pc=;
	b=aRwe2UQ9/+ae7iyTOKFlWoMozNOff9lr1AsGBKk2spS/zQOoAcBXHWAESQP6G0192TQZ72
	g17TCsvRc5x/yAiB+shrEKhPUl/hlHXO32uYszElGjTmvO08aGaHTHY9o/NBTZEUNajz+9
	RXai1Iii643bMVe1bjgjO6e93CAU8D4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YW+c4kfO;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754813700; a=rsa-sha256;
	cv=none;
	b=DW85r+AIizxHD7p7HIgcS9BTSr2ptXwGBGuq7QkIFgM9RKe+V+Y5lihImJy2J+naSWuzGJ
	IoB1atwI3Ba5X5b+sgP00yrxKAATnqXvdR9LbELQMxLPM5gHzTBDxzl5VPVKbB4tXR5ygy
	hlj7ITyr4dXL9JOtnurVu6naIBm01iQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BE7D613AB;
	Sun, 10 Aug 2025 08:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2309FC4CEEB;
	Sun, 10 Aug 2025 08:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754813699;
	bh=fGW6aFRPqxEB+wkPVbwUTC0fZF4Hi16hQUbYb1/bkBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YW+c4kfO6iVUIhxBhnUx9AMimsxobF81pwBpnyQ0SE5E7ELvWmZdkfeto7vwKO9jq
	 6pfvL+Cjs/zRk8dKyK8FH3SBte060/4efJu+6WPW5gqUVS7doAeda5u4823Pi023DS
	 xSZ4J/a/A52yUL+0jAMbSqNBdb5bPoPsJslMJWDztDUguK7z0qX4D48MemjMXuhf85
	 AABeg3ebvYkxWOGU/om+RSgSI+PV5rsz5/PN3cvtuA/LRwgy8Q3wEZG1Uma+J0C0Hx
	 mwu9p4LHmHq3C+bZ43Yg2AFe8sDP+W4iDit7LlDX3xtJVyjUr+tLkWXA78uG7Q9Isw
	 7bMMhv3lMwXSg==
Date: Sun, 10 Aug 2025 11:14:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: mawupeng <mawupeng1@huawei.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
Message-ID: <aJhU_a6NeUKeu4rY@kernel.org>
References: <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org>
 <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
 <aJM1RFjpQxQzfASv@kernel.org>
 <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
X-Stat-Signature: 6s9fr1ep8tyuas7ua86ceekgzx5i55ff
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3128540004
X-Rspam-User: 
X-HE-Tag: 1754813700-906883
X-HE-Meta: U2FsdGVkX1/mKoStBHahT+y2sB/BLgYl5IpXVyeTMVjEjt8pMAv0QXQ8muktnYgif473tfP4bfBZ69m55Xj5lTEzS9D0sJyEOa84MHEmU2BVB8ocgc+TuS2o9wJTF0j++NbuYh7sxu4CYB+DQWITA4k0IYiXKf/EdQkTMz2N2q3hDRJ1Q//6vR++VVv4AWRVTehIJRcm9l94PH6rsCxXH3BTYQNI8yina4brAbNtUQYu6uW0GGVLXSH/rfdPg36C/akzN2MfPHcGgGyJaYN2K29gQolJWioj0pQyGJ0KWTXZrcBtoQ5Y7x+uWhxZmCWLcYEBih7iZCllNS5wcjlTA8vZrKc4VZYQlehHXcoXngK4LME/srZ+yWTdecH6umLdu5kffxfWIeA+S9L0cjqJ/iRPnoKgpu8Y+PFkOdSEL9LhXQ5QByLcV2nbbAUqw2tOHhGMLDF4o0Lcz9DxBZHN2nxsZps/TA4ref043oUX8goxaTjkq4Kh4336oqVPGB2/+amagA0Na6WG6gxKf8zKJN0/y2i1GKGapETZd2tzPlWkbRylfcAKbmJB1+rfpO9sMd61lrNkOLhupUi6qApbqaQE3kUivPxnln39ObuqSFPVA2qCTbTt6+r6RX6y+0TaYDG7/iweumbckXCOduteSMg/84sqzZR35xk6I8q9pzyfKQGPPiAhaOtrEAJ9C6uSRTN8mHgm1i7dMXl8GVGYUeMszAWxIkbKauNuyvo//4YbNTxiUUhKzsT5MfqXEo1k282EzBANGsUC4nAytAYmzZTf+T6SuxKAuOtfigQNzps1VWVcf1yFOgmuogcf/fKbZJK2QEx/65c/2PBCcZICWJpn1kenGpTTdVkUvYfD3l/gMrjGTfDYzfVUqZVMrP86R76sWD7WonX4w+LBluqRvZckOL13SykpOudjrAPpEVH2o6S/0vzpYGpSjSEO8bC3lgCzGI4iQFTYPo1uQY2
 mLoMY6gi
 vEFxbAh/k3RTf0Lrrf3+iUJFDapIyQkcZfcm5ZwmHrPLVtEwNj1cOGbNn2E4EMZx6vM+JxoJ8jPbwFCMPr/6wayaQ0Ibq7tu2ssd9lzS1fQfglG1BQxCsOY2Sy9EdTYsNSIPBbcfYXwHxsEsRkxedaZ2ewFexz21pArtqCP34X8mNKsYc43wNXMSQlowrTvxfHZtzTsYQLNEkt/PUbZDCIWkdTotobFZxhjXDKtjcOS+7X0G86c79j5M636MnG+N6MKT9ztdjxJIbfddVSBhIvNt10g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 03:14:03PM +1000, Ard Biesheuvel wrote:
> On Wed, 6 Aug 2025 at 20:58, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Aug 05, 2025 at 04:47:31PM +0800, mawupeng wrote:
> > >
> > > On 2025/7/22 16:17, Mike Rapoport wrote:
> > > > Hi Ard,
> > > >
> > > > On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> > > >> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> > > >>>
> > > >> ...
> > > >>>
> > > >>>> w/o this patch
> > > >>>> [root@localhost ~]# lsmem --output-all
> > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> > > >>>>
> > > >>>> w/ this patch
> > > >>>> [root@localhost ~]# lsmem --output-all
> > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> > > >>>
> > > >>> As I see the problem, you have a problematic firmware that fails to report
> > > >>> memory as mirrored because it reserved for firmware own use. This causes
> > > >>> for non-mirrored memory to appear before mirrored memory. And this breaks
> > > >>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > > >>> always has lower addresses than non-mirrored memory and you end up wiht
> > > >>> having all the memory in movable zone.
> > > >>>
> > > >>
> > > >> That assumption seems highly problematic to me on non-x86
> > > >> architectures: why should mirrored (or 'more reliable' in EFI speak)
> > > >> memory always appear before ordinary memory in the physical memory
> > > >> map?
> > > >
> > > > It's not really x86, although historically it probably comes from there.
> > > > ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> > > > with mirrored (more reliable) memory, the mirrored memory should be before
> > > > non-mirrored.
> > > >
> > > >>> So to workaround this firmware issue you propose a hack that would skip
> > > >>> NOMAP regions while calculating zone_movable_pfn because your particular
> > > >>> firmware reports the reserved mirrored memory as NOMAP.
> > > >>>
> > > >>
> > > >> NOMAP is a Linux construct - the particular firmware reports a
> > > >> 'reserved' memory region, but other more widely used memory types such
> > > >> as EfiRuntimeServicesCode or *Data would result in an omitted region
> > > >> as well, and can appear anywhere in the physical memory map. There is
> > > >> no requirement for the firmware to do anything here wrt the
> > > >> MORE_RELIABLE attribute even though such regions may be carved out of
> > > >> a block of memory that is reported as such to the OS.
> > > >>
> > > >> So I agree with Wupeng Ma that there is an issue here: reporting it as
> > > >> mirrored even though it is reserved should not be needed to prevent
> > > >> the kernel from mishandling it.
> > > >
> > > > But a check for NOMAP won't actually fix it in the general case, especially
> > > > if it can appear anywhere in the physical memory map. E.g. if there's an MR
> > > > region followed by two reserved regions and one of these regions is not
> > > > NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> > > > region.
> > >
> > > What kind of memory is reserved and is not nomap.
> >
> > EFI_ACPI_RECLAIM_MEMORY is surely reserved and it won't be nomap if it can
> > be mapped WB. I believe other types may be treated the same, I don't
> > familiar with efi code enough to tell.
> >
> > > > We may want to consider scanning the entire memblock.memory to find all
> > > > mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> > > > based on that.
> > >
> > > AFICT, mirrored memory should always locate at the top of numa memory
> > > region due the linux's zone management. there maybe no good decision
> > > based on memblock.memory rather that use the the first non-mirror
> > > usable memory pfn to cut.
> >
> > Thinking out loud, if nomap is not usable to Linux why would efi add it to
> > memblock.memory at all?
> >
> 
> Because the region has RAM semantics and not MMIO semantics. This is
> important on architectures such as arm64, where mapping RAM with
> device attributes breaks cache coherency.

Right, such regions should not be mapped. But this can be achieved with not
memblock_add'ing them at the first place, like e820 does for example.

-- 
Sincerely yours,
Mike.

