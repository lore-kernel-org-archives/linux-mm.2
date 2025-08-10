Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACC9C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 05:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806D96B008A; Sun, 10 Aug 2025 01:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790D06B008C; Sun, 10 Aug 2025 01:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658CE6B0092; Sun, 10 Aug 2025 01:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0DF6B008A
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 01:14:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96DEF823A4
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:14:20 +0000 (UTC)
X-FDA: 83759681880.12.7FC167D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4BB612000A
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:14:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDAgLSST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754802858; a=rsa-sha256;
	cv=none;
	b=tIByvnRz0MLNH3jbtQ0Rb1l0uFOwaG0I80jNC0vdbyFY4hvJVHZNNQalz54h4KJJDpsCqy
	HbTmo9muWqqfnYf0O1OkEoCY0Sxr9epU4A7KQPkTa+yWhLQAgGJbKoUDdjxJ5vBEdWor8g
	tXnrEAs9ybjJlRQz1BQSNdYQ1D0pCLQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDAgLSST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754802858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNn7b32meLG+SQ+LD3+YgK6AHOyjjnsGIzBDLrBqoSY=;
	b=5krSkP2t5eqi31kGEqn0LXeG0AIC6egwgBMTBDj0/wQAcps1exdGzEfC0SzfObM/sFg1gF
	FQhp9/4V++PiDM/iQ3ePzd0xU81XsqmGKeJ9gvE1gB1aM0rgFFGN/NZRpY2BsWTEVF3Bab
	yPxR6TjhyMqymQj2fHlNo2EZnyK9Jz0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id EABA6A54121
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36353C4CEEB
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754802857;
	bh=CsX0+8wPsF+NVaEYBtYgUl5OhjzH9LZHcssQWkW2mKc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VDAgLSST380FoqNiTqfUzCjE+01RJMt/CStnUKgOcI34/24d74D8i6rZL4vyuOkMB
	 9bYVbh1OQ4XENgXaOS7FwxACkgXygu/Ij0eUGT2W/pQpVm5nlZ85us5bLqvvo2kuMx
	 Wx+68IEHmMztUQsf7bS4VHn7zjtL1AdhMzEIt1QN+NlnLlceTRkfFsbfeikVpGjUpo
	 p5F4uMlYeYlalPrOB66R2NSL4XjZVAUKzObIfi+293Uil6GOS3JPZvfpbXopM6+gws
	 fP3E5e9LkymxfJJmGYZziemKjk6HCvuSSWQhD0RKeAN1hzTT0Ni99XO/BZ6+QP5/yi
	 BfKsAq7pZDC8w==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-332612dc0d1so26706991fa.1
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 22:14:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWacCt1W/g73zT30059aXBXGsTIWw+/AqFwsqoSSPCchkdA3wvoC6emjKv6hmOMjvOw515rEIsRcQ==@kvack.org
X-Gm-Message-State: AOJu0YzbQXikjTJaA/kRjWL7UQvBGgWyqxyDEabqdQ6OreNHowoS9jyJ
	8GzuljY19ZSjvYy3Yq3GVlsRT4Whb90bmGO/mfq3UtMTvI/2Q8zgPWOEJQ1vZpqeHyBuNf1kN80
	N0ZEglXOV9teQrG5xM5jHjiYKVqPZn54=
X-Google-Smtp-Source: AGHT+IHL5VOMKYC7wfesoWjZEqnCd5gQuxwltrN3JRoIqGTots354Q4H6YVOxkJlFKo25XIJ0ZLg8dQ2+7XSNVjY0Ts=
X-Received: by 2002:a2e:a987:0:b0:330:8d4c:ae6a with SMTP id
 38308e7fff4ca-333a2145753mr23339921fa.6.1754802855620; Sat, 09 Aug 2025
 22:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org> <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org> <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org> <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org> <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
 <aJM1RFjpQxQzfASv@kernel.org>
In-Reply-To: <aJM1RFjpQxQzfASv@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 10 Aug 2025 15:14:03 +1000
X-Gmail-Original-Message-ID: <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
X-Gm-Features: Ac12FXzf35_uvtEOeRokVqVCBseAN6ZGkichFEJ0PZx8nn7rv48lzsCRiSNtW0w
Message-ID: <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
To: Mike Rapoport <rppt@kernel.org>
Cc: mawupeng <mawupeng1@huawei.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8qt1nb64nsjwyxd31gejz9uaa5pfwuj9
X-Rspam-User: 
X-Rspamd-Queue-Id: B4BB612000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754802858-816315
X-HE-Meta: U2FsdGVkX1+BO8jFbjRT1mz58IW/JIOUF0Wgkc1iMSFSDZ5247bb8eBR1MwHisAnu/LkTpyU9QyedIH8umdvgfFiwQG9srVe3ApKlkCAatTF+PmEznXyby/f0BOqBosg2z93dzh1KoDjAZ2DbwSs6I+f+ojgjTHibVeVS/LmS1i9dEZ/ts+t+i8ctCXd7fAOgT+lAkgwqRgcJqq9o5VwMM56ZrvqOlONL7QLRpYhAFRF6jz8aJxCXS40ZGduzUVjVK8HdVzP/ApORI8evOa1KAAmF1ZRBEJpEDlmCu7pijyXkUZuL9XX80vTc2Y6XhktYrGd1Jcm+E8ccmTm2bU2mqCdL735NotchxCoi7m1sFwLh564USRP1Hw/X5WKhUHl5sl7DCzW+dEauyOFIWYviS/QWguwJl6bT1seeA9ydG/pTR4+At47HLVINFCeZrQtXwfF5OZm30wveLwbLo3Acb4FQ7ZRJ7UtaowBwGBlG2moZwVzx1etuxwQpoRd6UUl14RzjqpBwcNV+zCDDP+MtfOwF9f120OkDac/Rc9dnziYuFTMlEU2tBwwMLIfs7ZbKeM9c9zuiHl+d4ZNQqVB8BRRhY7vGQQFCt22CgjHF/3ckx0kwo78mg2DymwzXTr8KFoAdXrvUSxop1PRJtdWXg4x+sczyXU6KzgoOxe0x6tYxzkTYpgNFCLZioMTNblvOQtY2qXNsyh90MKSMVvhbQfCbQvZRxdOLa4nmDRXKmTNTd48D1FEc0xx5NY3AzY8E/s0SuaaUS8c60H6NkeK3Q5sI804LAy/tOLlywV3gXjFFpLSgERoRKEc4oKO1Q64ZWlUK5NMYstqMk5MehS1/egqJhczIwN5MLygpi2VEIVkb1z15JBtFf0fQ/vKbpD0pfHOa0uSEM+GwOCLm91LNTu3Qs5+IhDc+aHBXqrWJzL10JqbuU34t8a4j4SLJRk3MiRkYVI41GdS90K/EEG
 5EFTMbV9
 n8+tnYKKIDbeHmv3VnY480zVIpG76dx1fibM32XHKSMPU4CDBorj2Yu+e7xzh1EiuRZFhSUwdYoNnLS1mfezyKA6PusdXAKvU7eGmlFowWedFibPoDN5v1Q98XYhBbFSx7WG8chlDfq7GXa+psf7Z2u4Ljr8v17I5LUOi2XzsKZP3uaU4TWr+QU64XrNW6Vlza3ZARR2QmnTJGKmzFunQ2dJAWDwPmnerjg9zW7Y7Umz3S0KDbzo1SRxQ8hY47SMjwnwzh0Z52s5qLcg2s9bF4RT6mne92hdyq7JnVmN6hS5k8uE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 Aug 2025 at 20:58, Mike Rapoport <rppt@kernel.org> wrote:
>
> On Tue, Aug 05, 2025 at 04:47:31PM +0800, mawupeng wrote:
> >
> > On 2025/7/22 16:17, Mike Rapoport wrote:
> > > Hi Ard,
> > >
> > > On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> > >> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> > >>>
> > >> ...
> > >>>
> > >>>> w/o this patch
> > >>>> [root@localhost ~]# lsmem --output-all
> > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> > >>>>
> > >>>> w/ this patch
> > >>>> [root@localhost ~]# lsmem --output-all
> > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> > >>>
> > >>> As I see the problem, you have a problematic firmware that fails to report
> > >>> memory as mirrored because it reserved for firmware own use. This causes
> > >>> for non-mirrored memory to appear before mirrored memory. And this breaks
> > >>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > >>> always has lower addresses than non-mirrored memory and you end up wiht
> > >>> having all the memory in movable zone.
> > >>>
> > >>
> > >> That assumption seems highly problematic to me on non-x86
> > >> architectures: why should mirrored (or 'more reliable' in EFI speak)
> > >> memory always appear before ordinary memory in the physical memory
> > >> map?
> > >
> > > It's not really x86, although historically it probably comes from there.
> > > ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> > > with mirrored (more reliable) memory, the mirrored memory should be before
> > > non-mirrored.
> > >
> > >>> So to workaround this firmware issue you propose a hack that would skip
> > >>> NOMAP regions while calculating zone_movable_pfn because your particular
> > >>> firmware reports the reserved mirrored memory as NOMAP.
> > >>>
> > >>
> > >> NOMAP is a Linux construct - the particular firmware reports a
> > >> 'reserved' memory region, but other more widely used memory types such
> > >> as EfiRuntimeServicesCode or *Data would result in an omitted region
> > >> as well, and can appear anywhere in the physical memory map. There is
> > >> no requirement for the firmware to do anything here wrt the
> > >> MORE_RELIABLE attribute even though such regions may be carved out of
> > >> a block of memory that is reported as such to the OS.
> > >>
> > >> So I agree with Wupeng Ma that there is an issue here: reporting it as
> > >> mirrored even though it is reserved should not be needed to prevent
> > >> the kernel from mishandling it.
> > >
> > > But a check for NOMAP won't actually fix it in the general case, especially
> > > if it can appear anywhere in the physical memory map. E.g. if there's an MR
> > > region followed by two reserved regions and one of these regions is not
> > > NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> > > region.
> >
> > What kind of memory is reserved and is not nomap.
>
> EFI_ACPI_RECLAIM_MEMORY is surely reserved and it won't be nomap if it can
> be mapped WB. I believe other types may be treated the same, I don't
> familiar with efi code enough to tell.
>
> > > We may want to consider scanning the entire memblock.memory to find all
> > > mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> > > based on that.
> >
> > AFICT, mirrored memory should always locate at the top of numa memory
> > region due the linux's zone management. there maybe no good decision
> > based on memblock.memory rather that use the the first non-mirror
> > usable memory pfn to cut.
>
> Thinking out loud, if nomap is not usable to Linux why would efi add it to
> memblock.memory at all?
>

Because the region has RAM semantics and not MMIO semantics. This is
important on architectures such as arm64, where mapping RAM with
device attributes breaks cache coherency.

