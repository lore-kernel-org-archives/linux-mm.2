Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7AECA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192EA8E0002; Sun, 31 Aug 2025 05:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A4B8E0001; Sun, 31 Aug 2025 05:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7868E0002; Sun, 31 Aug 2025 05:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E25ED8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:16:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 883B01403B9
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:16:13 +0000 (UTC)
X-FDA: 83836496226.16.D953330
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C3E2A40003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:16:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhkISgE1;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxcxPXSaR7GXouO7GiVgvJgyIAW9uNEd7VKT1zcNZkI=;
	b=LP6k8TTYwYlaN8KHB6DkgZyN7upANTceWNxbvC2lJOJKpMPtE0kLCMTjO+ZxBt//r3pMlM
	xh1t0pPMNksUsml3qAH+JHh0kdUWh/dhxOgdmO3pwI2pRLsV31YDn0TbH6Mh7lKTrsY+QB
	fJoPtfGl4mF+eEW3GZCOe0Zx8lSQmOw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhkISgE1;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631772; a=rsa-sha256;
	cv=none;
	b=hf/hdiV/ZZw6L4yyNWGD17nJoqYgftfRSa2i98RSSpIEiy8fxwnQEY+yq4FfBUjbcAWgl8
	x0vDZZ2SO7/HlK5MMWtqqkmXUypMBkjiL1YZSI5Bh8LEfFMN00cdC+Nuoym4slCuP4wi42
	POH5oW97UWdC9VvS2MHhvmdM53RLM+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FFD244244;
	Sun, 31 Aug 2025 09:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD0EC4CEED;
	Sun, 31 Aug 2025 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756631770;
	bh=OH6tNMeQRJO/TBFcwED8ihXqbFs+64VR+2qjljjKpp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhkISgE10TC6vkLlgPmdARGiEGm4DucEnVsn9cwfDa5FZq6FDxyOmHJ1DoY759JN/
	 B95rBjwrcEBelWiruplqCLXAlwUbsKOfgRn+Nyf4GzYnlDazV9ryjvGbCXQrRhDGCy
	 qyel8HNZsy+4GAPAGJwTWUbGCXeG0a3Blp1vhAQEAltyMGwJgmEbllzG4sVtUX8Bzc
	 mS2t6TMsHIhY8oV2wX/4qmKc0P8QsANxP9QehkHQqhMeBxOg8o3LRhzwObJ6GYR7Xo
	 bd7zP14o+gkazOBiUqnNtTv5lN3NPmDGZFLjS4i7TaDA3oDC48BMton0TxjEo3Xh96
	 HtDP/5jeOKaHw==
Date: Sun, 31 Aug 2025 12:16:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: mawupeng <mawupeng1@huawei.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
Message-ID: <aLQS1ABjAaZZwwoW@kernel.org>
References: <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org>
 <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
 <aJM1RFjpQxQzfASv@kernel.org>
 <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
 <aJhU_a6NeUKeu4rY@kernel.org>
 <CAMj1kXGXYTdrJMdUVB1Mc-uF3Vk5r+P-Sq+GGoBA3S5H3NkeUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGXYTdrJMdUVB1Mc-uF3Vk5r+P-Sq+GGoBA3S5H3NkeUQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3E2A40003
X-Stat-Signature: n5azbh8qdk6qpstpmgqzgd1e6cag1hhp
X-Rspam-User: 
X-HE-Tag: 1756631771-520710
X-HE-Meta: U2FsdGVkX19eB+K2M7cC+DGcvCcWBwF7noYEOdLefPz8I/YovvkvtYmV3kKgW1oQEtmaQPmPBn/ucjodCQgMSUXnSJjyF8eywbEB9YR/3OLg6Dm7MZbFHazq7gqlExXC5BRE2cFvIy+Y5j34SSey2uyqTqlrGt7Fp2jpCMI0OnJ/0LWiSiW8wbZHwp/4LfzPF0Smke8NEm712JVn0MLIAHuDryX03RYO7lclEiYzYcmCLpHKvkeSVs6njN+DfPydLKaX84CZNwIaqX7hNGqiOSBFM7BsWJyyYc14k0aUXLVwJ5ZhqUdCKxc329ZJbu/g6S6JLz+PiOMfduy07IW3IS+Q9+tgzENWnnphpjfLXdGoFFpoQvqEAAXNdyw54wDUsHNmH0eQVHxZSya52LKTx93oVFfNGf5ykmD4gPnwo0VIc3DQE5L7osQnE/vpX83hgf0veMikaduL66msn+hWSgQ0nGyA9FmeAYBER0w2YInzCHquluUmmGzrIYPB3DjYVJaPoCRuO8l1tdQbFaCj/sBxJVOuYK968W+s3uoP5DbQnvnRN+OEm2JyY1USaEkHSveZYKAhYgNcJ/Luivfrw4tg7yR/R767VEwZ/Ud5xdFVpEJd9y8xKaFx5P4lL11fn8Mmw1hknGiK0zGXzzAiqPKmQouBqVb2Lkq05/TnjdYTyfwLErxSvZ7665bcYemC2hRco6WZKHrGq8xJpUTFbJbDbuoObxz0FKtXWvNYcU+2GPXRJ4H7C8ozqrfHfarK0aV4ee1WIlVjCIhu5ayZ7g+lrUfeOpgYly6WLQ2iiKhXTV15OKCxLoNr2BpZoiGA4Zhw3PNzDdJMK9yZrV98CnV2rmzEY3Fkh0g3wdfN/bEROP1el5rgo57wvtIbcY+DMBRW3ZIJO7TJzL3WZAZnUjYgGDGonOP75wIYdhXlHCAd4ZxAIVrvEoZCHRa73+p8eNAJqHl/78mLGOUKCnQ
 ubXaSLA5
 CExDiMNUQb0+yr+bn0JtPPsriYVyC7ODW0km3aVV6riTflJGwWCmNLmbspEdHFoNjJzLyKDbd9NYvYrwcu45Xe7ZO0bx09ExBqwEpyWSOybjxy0bYcF0xDR1yMYRTmbIKDeR+478cCiTGtOeiVX+dC7+NTjP2zc7TFpOOPCkGUF1IJWMwUvcBUG8x8U+jhZG+m2hSBILlzakSAHlXx4z8JDR7fgiBWNLaBW0zASR+PbqLwjZfqWQfMj66WaOGAZfexxAffJghNwRAD0YKYb7+uqJJ7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 06:47:32PM +0200, Ard Biesheuvel wrote:
> On Sun, 10 Aug 2025 at 10:15, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sun, Aug 10, 2025 at 03:14:03PM +1000, Ard Biesheuvel wrote:
> > > On Wed, 6 Aug 2025 at 20:58, Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Tue, Aug 05, 2025 at 04:47:31PM +0800, mawupeng wrote:
> > > > >
> > > > > On 2025/7/22 16:17, Mike Rapoport wrote:
> > > > > > Hi Ard,
> > > > > >
> > > > > > On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> > > > > >> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> > > > > >>>
> > > > > >> ...
> > > > > >>>
> > > > > >>>> w/o this patch
> > > > > >>>> [root@localhost ~]# lsmem --output-all
> > > > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> > > > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> > > > > >>>>
> > > > > >>>> w/ this patch
> > > > > >>>> [root@localhost ~]# lsmem --output-all
> > > > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> > > > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> > > > > >>>
> > > > > >>> As I see the problem, you have a problematic firmware that fails to report
> > > > > >>> memory as mirrored because it reserved for firmware own use. This causes
> > > > > >>> for non-mirrored memory to appear before mirrored memory. And this breaks
> > > > > >>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > > > > >>> always has lower addresses than non-mirrored memory and you end up wiht
> > > > > >>> having all the memory in movable zone.
> > > > > >>>
> > > > > >>
> > > > > >> That assumption seems highly problematic to me on non-x86
> > > > > >> architectures: why should mirrored (or 'more reliable' in EFI speak)
> > > > > >> memory always appear before ordinary memory in the physical memory
> > > > > >> map?
> > > > > >
> > > > > > It's not really x86, although historically it probably comes from there.
> > > > > > ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> > > > > > with mirrored (more reliable) memory, the mirrored memory should be before
> > > > > > non-mirrored.
> > > > > >
> > > > > >>> So to workaround this firmware issue you propose a hack that would skip
> > > > > >>> NOMAP regions while calculating zone_movable_pfn because your particular
> > > > > >>> firmware reports the reserved mirrored memory as NOMAP.
> > > > > >>>
> > > > > >>
> > > > > >> NOMAP is a Linux construct - the particular firmware reports a
> > > > > >> 'reserved' memory region, but other more widely used memory types such
> > > > > >> as EfiRuntimeServicesCode or *Data would result in an omitted region
> > > > > >> as well, and can appear anywhere in the physical memory map. There is
> > > > > >> no requirement for the firmware to do anything here wrt the
> > > > > >> MORE_RELIABLE attribute even though such regions may be carved out of
> > > > > >> a block of memory that is reported as such to the OS.
> > > > > >>
> > > > > >> So I agree with Wupeng Ma that there is an issue here: reporting it as
> > > > > >> mirrored even though it is reserved should not be needed to prevent
> > > > > >> the kernel from mishandling it.
> > > > > >
> > > > > > But a check for NOMAP won't actually fix it in the general case, especially
> > > > > > if it can appear anywhere in the physical memory map. E.g. if there's an MR
> > > > > > region followed by two reserved regions and one of these regions is not
> > > > > > NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> > > > > > region.
> > > > >
> > > > > What kind of memory is reserved and is not nomap.
> > > >
> > > > EFI_ACPI_RECLAIM_MEMORY is surely reserved and it won't be nomap if it can
> > > > be mapped WB. I believe other types may be treated the same, I don't
> > > > familiar with efi code enough to tell.
> > > >
> > > > > > We may want to consider scanning the entire memblock.memory to find all
> > > > > > mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> > > > > > based on that.
> > > > >
> > > > > AFICT, mirrored memory should always locate at the top of numa memory
> > > > > region due the linux's zone management. there maybe no good decision
> > > > > based on memblock.memory rather that use the the first non-mirror
> > > > > usable memory pfn to cut.
> > > >
> > > > Thinking out loud, if nomap is not usable to Linux why would efi add it to
> > > > memblock.memory at all?
> > > >
> > >
> > > Because the region has RAM semantics and not MMIO semantics. This is
> > > important on architectures such as arm64, where mapping RAM with
> > > device attributes breaks cache coherency.
> >
> > Right, such regions should not be mapped. But this can be achieved with not
> > memblock_add'ing them at the first place, like e820 does for example.
> 
> How do we distinguish RAM from MMIO in that case, if neither can be
> found in the memblock list?

Maybe we need a list for MMIO regions then?

-- 
Sincerely yours,
Mike.

