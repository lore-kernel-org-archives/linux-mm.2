Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEF8CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDC48E0008; Fri, 29 Aug 2025 12:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6A48E0001; Fri, 29 Aug 2025 12:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB598E0008; Fri, 29 Aug 2025 12:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFF48E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:47:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DED913A97F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:47:48 +0000 (UTC)
X-FDA: 83830376616.17.442D8B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C400040008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:47:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bkk6YWkn;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756486066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUUmtGKksMfn71dGn5Q05JEgvmfHOm0e+tHo4KDJxXA=;
	b=BW1+6o9fzaS76O8BnRysCcOzXMnxDc+Zaju3zrKe4ARHCGUB0SwDA4VKceofe3bOG0zFDL
	+0EqJ2ccdHEp6GvJCI5AoFXZC9UMmJ2u+sF88iEq7v3/3eXkSidf6MUArWBDEFjO8NiHWf
	UvyMQOaIko0vZ6JRCVoVhu1beBztKQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bkk6YWkn;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756486066; a=rsa-sha256;
	cv=none;
	b=hAerjlXuEjr6RctlVpZMNi4yj6hu14J3f1hSraVt1HVQ7ucOp+y0pK16oZNajAek7MLNVQ
	848kui2y3aibNR+GARJUYSvX8f4WZIGA5RCz0M9CkJzEWKy4czqaaHbNmtA/qPvjP/Ayl1
	zPlBAff5rPEkjuFJEk9l2u0UrzHaZ14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B77601BC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5F9C4CEF0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756486065;
	bh=/ErPdPQMUXalSGRsJ1vF5o9PFjc8+ivNlMW27OZppT8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bkk6YWkn9UXXxa8HtRSbDmkIsNKwiMIAc3Udd/5wPHThVt4ln2rlZUl6YsjvKh7AG
	 tzf8A/ZmhOUk6bzK3uklWuyw+Hy1z6QhGX7JIOZwMygHduHc2L4bH/nYLMblIf7P/d
	 X1xHBSKVUm6VGekabHreN1J+ghmZpONh58QQyAYwHyVRgXqO3IhpoTegvMuhyUOgxX
	 OpD6Vjnq39EMGluH1/RSaErLD2BMjsNh34CcT7PfsMdhCZuGYdYFKdzpYSg7ddEMTc
	 BpE1UrOI4DDeXWywBEWUVqRsqtiux5z+OcMa1ci3lcUPE7WVdB1uT2iW+l83CCmLe5
	 K/CvEJWxoixPg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f646b1db8so1870776e87.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:47:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX8/K6kv2yygnSz+pxuNpr1IxCNiQQpvvn0ScdzNqpLkPcqIFtkfqfi+q78d46BErVTnzwyM1X6Rg==@kvack.org
X-Gm-Message-State: AOJu0YyoQlpzXLZXuLpw758ZTLKf3E6WV4ppGUbX4B5PkGJFs9ThjKP7
	AfBVZ1rNRKB2LuekLpIxrbgT4hOnuCHJbnpCsfPeBvQkMj7ShaK1bPljF3WgJkwpx/nAE2+lrOj
	w5cGslb0C7uW1JQOgz5YtAlldSpk74DM=
X-Google-Smtp-Source: AGHT+IE6Uzzl3OEENhASA0nafKketLOkVpHtLFm6KiMYKZAQYq2n8hu2c3SbfjMq+tSNCTm54kTMyuKLI4TyjxZfl6s=
X-Received: by 2002:a05:6512:1091:b0:55f:6ddb:25 with SMTP id
 2adb3069b0e04-55f6ddb036fmr227107e87.3.1756486064192; Fri, 29 Aug 2025
 09:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <aHjQp9zPVPuPyP3B@kernel.org> <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org> <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org> <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org> <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
 <aJM1RFjpQxQzfASv@kernel.org> <CAMj1kXHg-xB8KxkgL1FYu8PpBVqXUsR7wMxUXwfUXm=BfuUHGg@mail.gmail.com>
 <aJhU_a6NeUKeu4rY@kernel.org>
In-Reply-To: <aJhU_a6NeUKeu4rY@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Aug 2025 18:47:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGXYTdrJMdUVB1Mc-uF3Vk5r+P-Sq+GGoBA3S5H3NkeUQ@mail.gmail.com>
X-Gm-Features: Ac12FXywTQo1B_0JCcEOdtCveAknCs6YbWQKzsYVFfhVgOtOSY0DSPQNBXTA8io
Message-ID: <CAMj1kXGXYTdrJMdUVB1Mc-uF3Vk5r+P-Sq+GGoBA3S5H3NkeUQ@mail.gmail.com>
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
To: Mike Rapoport <rppt@kernel.org>
Cc: mawupeng <mawupeng1@huawei.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C400040008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ojgyb98fto49hhizp661irqs7sjoek7i
X-HE-Tag: 1756486066-557925
X-HE-Meta: U2FsdGVkX1+U6419KLROlfgcUvkTuf0tmysBn1Jc5sksrMyq5DEb2EIyGc25GCpxPLigNIKkWZZhueMIwyBEQh6NAS6ul+Y0gVWWOtU9NySuqnNOoFZlRgaRZvuVgJG+DIxpB8YTSs+maa/M0qhGt7FVu08U9kEmvn9n8xn9deMh+dN5NLu0Fj/12OupwzsnClL9/JGQNkgpuhYtNYZSn0cXWIlw0S0Rz/5on92abNLJRdaMPKes0jb/z4zC3TZWVwKAwPU4E4KXBRGrjK2WS1Ty7qUSF5GQACDzDTrnBiu8q9kc92bESSyUn7hiFw+ByFbTfdTN9hNGA38vIY+ttBXDeLG4VBTTcGoEiashkZy1gaQSX92NYtof368kZSc7wkEz9Na1W1dvFItFrTSGADRpbiH2C+g9EPLrqGfVaTjHrRMSxsUxt1did9tltI1W/DZNzGT8WgZo3o0rWuULqwVbQ4Q4sZ5BrS+RhQo0M/qEC0BEbOQ3K1ON0djgPObHm3yj1SdeR7dolm9BejePMZpXeEqtlIv2qMPxdWpHbdia74P5jhh6s4K3UOgxnH+v+KZfuzJyEuRtwkoHbtR8CfOEsar+FEI3xCqctKOW54Hw6HD/uTQPI72ebLHilrkttsrJWQv0KNrQADjZFEsV0G41Knk/MTEjMBqVpG1o86LsRnFsYi/XETKwm7yAgMVnfB3tBnAEtXXvSgksFevX/MTQniJr/9zvk7xcPiuy/1zvxcX+nNOr/Ui8ab4mKrLOjciV5tMX7aMigfcjnQI5dO1rYCigbdMHNEcuLk0oziczdXcQWDoZfzVbozBZHe7ZfEeMk2nwQWSeRqYSkIrApjFhu5Ue+uWIeUcvUl5MZAa8r+sho1ZhtIMy8Tqg7o4Gm0K8ExRc8j/z41lzSF6r/hIEBwiaN2uoBVNFBHIA3Gqyhsf0O0tofPHOLkXFiD8E7GYFTFmD6QU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 10 Aug 2025 at 10:15, Mike Rapoport <rppt@kernel.org> wrote:
>
> On Sun, Aug 10, 2025 at 03:14:03PM +1000, Ard Biesheuvel wrote:
> > On Wed, 6 Aug 2025 at 20:58, Mike Rapoport <rppt@kernel.org> wrote:
> > >
> > > On Tue, Aug 05, 2025 at 04:47:31PM +0800, mawupeng wrote:
> > > >
> > > > On 2025/7/22 16:17, Mike Rapoport wrote:
> > > > > Hi Ard,
> > > > >
> > > > > On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> > > > >> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> > > > >>>
> > > > >> ...
> > > > >>>
> > > > >>>> w/o this patch
> > > > >>>> [root@localhost ~]# lsmem --output-all
> > > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> > > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> > > > >>>>
> > > > >>>> w/ this patch
> > > > >>>> [root@localhost ~]# lsmem --output-all
> > > > >>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > > >>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> > > > >>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> > > > >>>
> > > > >>> As I see the problem, you have a problematic firmware that fails to report
> > > > >>> memory as mirrored because it reserved for firmware own use. This causes
> > > > >>> for non-mirrored memory to appear before mirrored memory. And this breaks
> > > > >>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > > > >>> always has lower addresses than non-mirrored memory and you end up wiht
> > > > >>> having all the memory in movable zone.
> > > > >>>
> > > > >>
> > > > >> That assumption seems highly problematic to me on non-x86
> > > > >> architectures: why should mirrored (or 'more reliable' in EFI speak)
> > > > >> memory always appear before ordinary memory in the physical memory
> > > > >> map?
> > > > >
> > > > > It's not really x86, although historically it probably comes from there.
> > > > > ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> > > > > with mirrored (more reliable) memory, the mirrored memory should be before
> > > > > non-mirrored.
> > > > >
> > > > >>> So to workaround this firmware issue you propose a hack that would skip
> > > > >>> NOMAP regions while calculating zone_movable_pfn because your particular
> > > > >>> firmware reports the reserved mirrored memory as NOMAP.
> > > > >>>
> > > > >>
> > > > >> NOMAP is a Linux construct - the particular firmware reports a
> > > > >> 'reserved' memory region, but other more widely used memory types such
> > > > >> as EfiRuntimeServicesCode or *Data would result in an omitted region
> > > > >> as well, and can appear anywhere in the physical memory map. There is
> > > > >> no requirement for the firmware to do anything here wrt the
> > > > >> MORE_RELIABLE attribute even though such regions may be carved out of
> > > > >> a block of memory that is reported as such to the OS.
> > > > >>
> > > > >> So I agree with Wupeng Ma that there is an issue here: reporting it as
> > > > >> mirrored even though it is reserved should not be needed to prevent
> > > > >> the kernel from mishandling it.
> > > > >
> > > > > But a check for NOMAP won't actually fix it in the general case, especially
> > > > > if it can appear anywhere in the physical memory map. E.g. if there's an MR
> > > > > region followed by two reserved regions and one of these regions is not
> > > > > NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> > > > > region.
> > > >
> > > > What kind of memory is reserved and is not nomap.
> > >
> > > EFI_ACPI_RECLAIM_MEMORY is surely reserved and it won't be nomap if it can
> > > be mapped WB. I believe other types may be treated the same, I don't
> > > familiar with efi code enough to tell.
> > >
> > > > > We may want to consider scanning the entire memblock.memory to find all
> > > > > mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> > > > > based on that.
> > > >
> > > > AFICT, mirrored memory should always locate at the top of numa memory
> > > > region due the linux's zone management. there maybe no good decision
> > > > based on memblock.memory rather that use the the first non-mirror
> > > > usable memory pfn to cut.
> > >
> > > Thinking out loud, if nomap is not usable to Linux why would efi add it to
> > > memblock.memory at all?
> > >
> >
> > Because the region has RAM semantics and not MMIO semantics. This is
> > important on architectures such as arm64, where mapping RAM with
> > device attributes breaks cache coherency.
>
> Right, such regions should not be mapped. But this can be achieved with not
> memblock_add'ing them at the first place, like e820 does for example.
>

How do we distinguish RAM from MMIO in that case, if neither can be
found in the memblock list?

