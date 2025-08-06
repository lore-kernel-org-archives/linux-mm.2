Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB37BC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375C38E001A; Wed,  6 Aug 2025 06:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D1A8E0001; Wed,  6 Aug 2025 06:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A728E001A; Wed,  6 Aug 2025 06:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1835F8E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:58:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6C4F1404F8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:58:20 +0000 (UTC)
X-FDA: 83746033560.13.71175AF
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1BD82A0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:58:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fk+8h164;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754477899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjXXUJHaa9Wbn0tVTFb2j8yWelWULSKJVumsbQQDpys=;
	b=N5LzDzBdVs23W9Vp91Cl731DfFUlxMstdt7z6ukVmev8CL/rQc6i0PmKUImqqEYx9nYE2+
	bqDVbMGfkmof919tJ7e9ICW1BjKVVJumkIvGp8vbtFw79dO5XteWRqTWMNTm2PDdLjEt6b
	uKri2o1BlJtHtuw+7istBYv5sIrCMNM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fk+8h164;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754477899; a=rsa-sha256;
	cv=none;
	b=lwWaSYGUPpC5CaczK+xJMf3W6MKmkioFGeCeL45hy6S4EpYH1Er/ASLF36NzoU9L8+nLkh
	Euj0lBiAdAdtrna9N3kC/QGF4T5mrpLqKyiylAihacA5j0aQb00/RZpUIHISQ6EJzG47SV
	iYbt74yfpxIQDbQftzeZPvn5MV9xwsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 5B1E1A569CD;
	Wed,  6 Aug 2025 10:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F20C4CEE7;
	Wed,  6 Aug 2025 10:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754477898;
	bh=9vV6D9rZRafX6ErINmAAiDv16ZiuY96suxd9anC9tBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fk+8h164x2QfKL8pa/aGXhnMZKIXXQ4Lb9ckBtxZNIqewwf9BEdIC4CLImZlBTqWl
	 XuIxFHV4Q6jBI+7MqUL3SmY42VUCcF2b9NxuiOVuygrM/qcVfdVbxv+f9qf3qXASo+
	 kZO7voTduRFa+6rfVotePbUG6lzOS5DFD+gg1M8OCTXdvkU+J23t9sunL0i6mBS+Hj
	 U+L11I0/CMWAdwFN/vLSceqIXuTjt0ZiWL+ptJwuftj0FZs3/fvSLm8UeQA9vdTzaf
	 7v8jldJ4g/5jwrqgzhbowcTn/F5ucIoQZ5u1JxL2c6aLsj7U4P1eDjIzLeWUArCrQM
	 r5OADw0rWBXmg==
Date: Wed, 6 Aug 2025 13:58:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: mawupeng <mawupeng1@huawei.com>
Cc: ardb@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
Message-ID: <aJM1RFjpQxQzfASv@kernel.org>
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org>
 <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
X-Stat-Signature: x8i34rf54ayu1tmynrdzoj7t8bgq4qgw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BD82A0003
X-Rspam-User: 
X-HE-Tag: 1754477898-517287
X-HE-Meta: U2FsdGVkX1+vIlMGIF9rVk28CQ5haHHo0gtIWZXhkoPsERJQ82ypI0QdGqHjqLp0HVi3JkLrtBLetGpzOSo/2oi1ZFTpLXEGy1jk+GMVKXFt6cqObxpwV7/tXSiAaKRxo8a66HbUhEwK4b2GEhXWAjiYVc1/Ch97lc4NyC9PKnbmWKFlXxTYyx7vCVerkKFeWv8f1O11UtKMzlz6tGPs5NzF5/nr80uFlf82nH75NSVKLTTeozBRDBcoAkA01M9aQ1a2UNNyYX6lFhsHNfsZSkfGJu5BaQfPfMXJw37BUeGqV69qZHnQEekG3N6UKszmygxb12xTietg1/73yst2EmHvkujTzuOTprc4zT1FXWCi26UkkXTTpR7pFvQ5Lvh3jEaMPfQmGPIfACKLIoZLCNKi/jW1tdIYhtcLf8rV6nCo4rnKE5wKVedxTpFyvP/Og7NKELSbFxcsJCMi7EVw0mV6txJpKMgBke2hiNPUumd64YzUIWKylRc+cEQcRnPTvZ9jv+3V1vCb1RdI1hJbOePZvyfANfuulbpg+LaLpTJqHZYo2nS9PJtS0GgVrCNB7hijYIFarjJhWXuWaU79eNpxwsEG36U3bFMDQw5C0IIoXLs3b44bxGwbRuzcis5jodlxMxUGsGemM8KhTlRFFTkJ1+rnUn2TsPuTQucq0464DCOANYMCU0/mZJE8tDYcSSG3IVX/1zyhC+5u46/k2nWsgGCHXUn75dPeFqvnF1GMbGC1ZlLrcV8rW5dDFzLoj/GfmU5qt01c/g4Rkbu3fyqPM1MHFnK6bmZkkKAgk2ZPynF7TqDf7flKpa7NokQ3+rWUtgKiqbZsZ+ucJd0adSerGGy+EHBrdBC98uP0dF/6gYhU86RuYhP6G/c0/5Rf1w2QWwpi0rWHikCkgSjOABvp1DLnaFeRU0Q5qmExxhoXVxABPYRwf1ecDH9h+JFuQY0QoF0PRVHKxq8NMaU
 tU7L0wML
 wkgrKfZKnHnjUIpS0AsbaHGRGiojZ69dnVHy++D8X5NXr6wMrWN5rLQe8DhRsL+1UmPK0YxpfoFO0nsJZl57us5An/Ak90iHErUY+2i+SjyUttPJkW4FxPRd9k/Gjdg4/LgueahJ7U4sfXAutv/rG3kbKEZLuqWeLvRN5c7Ei4bxUPl+phWXduQrEmZBqcvT6smtF90dcQHUFqA+vsKM81PqlvWbl3UxM76JmlTt+Xg+u7I8cEIRytru+UNfkC5lONTT5ISzxZ2tiZ8UINXDhddq6fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 04:47:31PM +0800, mawupeng wrote:
> 
> On 2025/7/22 16:17, Mike Rapoport wrote:
> > Hi Ard,
> > 
> > On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> >> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> >>>
> >> ...
> >>>
> >>>> w/o this patch
> >>>> [root@localhost ~]# lsmem --output-all
> >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> >>>>
> >>>> w/ this patch
> >>>> [root@localhost ~]# lsmem --output-all
> >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> >>>
> >>> As I see the problem, you have a problematic firmware that fails to report
> >>> memory as mirrored because it reserved for firmware own use. This causes
> >>> for non-mirrored memory to appear before mirrored memory. And this breaks
> >>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> >>> always has lower addresses than non-mirrored memory and you end up wiht
> >>> having all the memory in movable zone.
> >>>
> >>
> >> That assumption seems highly problematic to me on non-x86
> >> architectures: why should mirrored (or 'more reliable' in EFI speak)
> >> memory always appear before ordinary memory in the physical memory
> >> map?
> > 
> > It's not really x86, although historically it probably comes from there.
> > ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> > with mirrored (more reliable) memory, the mirrored memory should be before
> > non-mirrored.
> >  
> >>> So to workaround this firmware issue you propose a hack that would skip
> >>> NOMAP regions while calculating zone_movable_pfn because your particular
> >>> firmware reports the reserved mirrored memory as NOMAP.
> >>>
> >>
> >> NOMAP is a Linux construct - the particular firmware reports a
> >> 'reserved' memory region, but other more widely used memory types such
> >> as EfiRuntimeServicesCode or *Data would result in an omitted region
> >> as well, and can appear anywhere in the physical memory map. There is
> >> no requirement for the firmware to do anything here wrt the
> >> MORE_RELIABLE attribute even though such regions may be carved out of
> >> a block of memory that is reported as such to the OS.
> >>
> >> So I agree with Wupeng Ma that there is an issue here: reporting it as
> >> mirrored even though it is reserved should not be needed to prevent
> >> the kernel from mishandling it.
> > 
> > But a check for NOMAP won't actually fix it in the general case, especially
> > if it can appear anywhere in the physical memory map. E.g. if there's an MR
> > region followed by two reserved regions and one of these regions is not
> > NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> > region.
> 
> What kind of memory is reserved and is not nomap.

EFI_ACPI_RECLAIM_MEMORY is surely reserved and it won't be nomap if it can
be mapped WB. I believe other types may be treated the same, I don't
familiar with efi code enough to tell.

> > We may want to consider scanning the entire memblock.memory to find all
> > mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> > based on that.
> 
> AFICT, mirrored memory should always locate at the top of numa memory
> region due the linux's zone management. there maybe no good decision
> based on memblock.memory rather that use the the first non-mirror
> usable memory pfn to cut.

Thinking out loud, if nomap is not usable to Linux why would efi add it to
memblock.memory at all? 

-- 
Sincerely yours,
Mike.

