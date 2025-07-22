Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8D8C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFEA6B008C; Tue, 22 Jul 2025 04:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B03C6B0092; Tue, 22 Jul 2025 04:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED5E6B0093; Tue, 22 Jul 2025 04:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 759286B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:18:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27BF2C02C9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:18:01 +0000 (UTC)
X-FDA: 83691197562.19.2430B76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 95F3640016
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:17:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i58t+eQw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753172279; a=rsa-sha256;
	cv=none;
	b=bINBH95xnM9WFNRTG3hLoZkCvOv8oQOPQcaI2eHNd6xwkk/2l3ZsYVmDovqglNBrncxo40
	h3CPLTixDeB5DiqPzV7FcIXTT156FKnSzVCrASeLNsDN0nnVL/7vbhYwD1xexjorNFazQ1
	tkkA9lMk9usqJPqVAOun7GlxC87C4wY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i58t+eQw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753172279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuVx/P7sWWKFT3miteJaFYYrWVqAoKtcVxeF88sh9es=;
	b=X11n8Ovxu3S4cCiP7vZ40d6/DbIfo9zI8Giej+IgXrINFVHD997uPQC89bHWLGhcYwLlOr
	9/BXMLDpuXWapCA65LvD/5EfKO22FL2q021zR1tQuUWUqZmBICFjpCW2fonhYLagFAq7ZN
	KohRz/TxqVLUzSw/JTbwIJUDUb5ZeNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB5CB601D6;
	Tue, 22 Jul 2025 08:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C13C4CEF8;
	Tue, 22 Jul 2025 08:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753172278;
	bh=lfgObfb20Wc460ieZjhQIAnsDK6FQlGKlIQgSrIUAtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i58t+eQwe+lMzgAnNqCtjoeHeWNNYK1TDBIZCsfo0Yz/j7CG23IVQcgutqX1Pnupy
	 Wq3egSBJcyRzYw2sRXbGhNwIQedoE+BJoLHKHnGYn+31qRNPCFAm/UJM4vu06425LO
	 XNcar6OSHZwYjxdgxL7j6+FPPdUp5XCKDrs0zg25d0pZI6LUk0ipKyhN/p8X5daGPR
	 INgyKM7V3AwBExeva8MU0cj/vb/kWo770CKmQh8fiUpktfacfJnkwhTJhQ8ZKYyqNg
	 H0bI11lgVOkc0HP/5RF/Auei1FxFfE3ZdY4D4HAQJalxJBwmP0jlV6dHJI16csrGLX
	 SGblJAo7yJECg==
Date: Tue, 22 Jul 2025 11:17:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: mawupeng <mawupeng1@huawei.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
Message-ID: <aH9JMT93itrztZ+m@kernel.org>
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95F3640016
X-Stat-Signature: a1eqj6y4x5x1b36nyfczcoxdetr1ouy7
X-Rspam-User: 
X-HE-Tag: 1753172279-371886
X-HE-Meta: U2FsdGVkX1/WmlxeGNGe6qjQAMSwM5VeZ8hxivl1kRmbjSpQ2tlD4pUSiXqO8P7/xeZ3TuzMNNT5UIUU1MWgox+5dR0dDo9s3avSPhtrneLb3uhmRdJuRD+AWdMR8rUAh22F5daiD0AIxZsJD4kgS8Iibclq/Srp9wzKRN6Of7FVIusEstZ3/3/bf1HglWL89y79ZDA4lRj/UWlT/Xt9eForizffiyafiOguNQpmEcP695eyUiQMW7GaX1xOesymi0MMYtetqarw0o4zfX+j7lrSsm1543LrfDBOV6OShPhD9tPvHuet1zqAQAwB8apGfbhNN3PMZ4MV/unsO4sqcxrJwOdRkTttOORq7CzwJwAtkVxT1kEiR5TRyGB2u+zYRNuwATXmv5CAbY37mklJtj9sCGe8NqhbrMnNsyIjDcvDC06kK3369rShgBST0e8Xg/Owht+KtrWqK5vwaf+PUCyTSTw30ZdyxQGfGDK/6KKXMywRdsBkHimYp26GyHe/ysvabC43XOivJ1YrDuhDQ6iUO8VvfiOCscSGJL5UvLLvWe1YLcreXfg0jTKLQCBHDexS8ShdX9AypgXsCWw5akSnIseyFODaOP5B0NqmA7iFBoH+ypHghxRmsAC5xZUii8/iy1dggv5nkKrxJss2CM3ZN/ZLUU/bT/Zrut+WA15hc2FHD4Q3VmF7vAgvsBD6Khnk+aR4h071cG6JXD/9e9O+fWDXdHAreQY8zfeppOcK+H4o4uFOqdjjtfLn6RCPyp9IaZXonuyG2HLJ/wG1MCFMYrtzij6acDCAOGPCCq1oDToTLFI1b5qUJb6TZOgEMpPZvKDwMGp9m7V4Awy8LY95y19ZUJeafOKLJoHRNI5TEQ/j6jIEtMtWfxGvFgAuUMipA9IxkAoyBtPNrYB0fhjpv8RGYDv7I0bS+H/nTmhVDfP3TghFkQq3DN+tjTeYOYPLdUmkqKBfeWnRzdr
 /9EKPWO0
 RaCqBwkqGAyXPVQO/TZmEA1bxN0fPc+SYM1+BXmHhKAdiRbphxeSA7boQM2vS2o2eCQAC4RYGTnR53FQNpj3k0JKA6fwNc/nCBz9CttHkC6K6jNd2GVz3/I2zzRWGsTwAmKs0Kst7ww+7PETzcVUYOtChxdaeRgVtilwunAPjIxGTdZEBJm5QVWKcNExW9LBwVr67cjMOok6gdFnzotuyx/SgLiXJKK+3lfo8ALKIxZ9U/5PNzYf3y3v+rsYATMWx7uA51xxYH3kfxwCFn+4TbDr7xx4yap0BU2+/cJYtD8hwhGJIgFX94GYDbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ard,

On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
> >
> ...
> >
> > > w/o this patch
> > > [root@localhost ~]# lsmem --output-all
> > > RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> > > 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> > >
> > > w/ this patch
> > > [root@localhost ~]# lsmem --output-all
> > > RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> > > 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> > > 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> >
> > As I see the problem, you have a problematic firmware that fails to report
> > memory as mirrored because it reserved for firmware own use. This causes
> > for non-mirrored memory to appear before mirrored memory. And this breaks
> > an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > always has lower addresses than non-mirrored memory and you end up wiht
> > having all the memory in movable zone.
> >
> 
> That assumption seems highly problematic to me on non-x86
> architectures: why should mirrored (or 'more reliable' in EFI speak)
> memory always appear before ordinary memory in the physical memory
> map?

It's not really x86, although historically it probably comes from there.
ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
with mirrored (more reliable) memory, the mirrored memory should be before
non-mirrored.
 
> > So to workaround this firmware issue you propose a hack that would skip
> > NOMAP regions while calculating zone_movable_pfn because your particular
> > firmware reports the reserved mirrored memory as NOMAP.
> >
> 
> NOMAP is a Linux construct - the particular firmware reports a
> 'reserved' memory region, but other more widely used memory types such
> as EfiRuntimeServicesCode or *Data would result in an omitted region
> as well, and can appear anywhere in the physical memory map. There is
> no requirement for the firmware to do anything here wrt the
> MORE_RELIABLE attribute even though such regions may be carved out of
> a block of memory that is reported as such to the OS.
> 
> So I agree with Wupeng Ma that there is an issue here: reporting it as
> mirrored even though it is reserved should not be needed to prevent
> the kernel from mishandling it.

But a check for NOMAP won't actually fix it in the general case, especially
if it can appear anywhere in the physical memory map. E.g. if there's an MR
region followed by two reserved regions and one of these regions is not
NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
region.

We may want to consider scanning the entire memblock.memory to find all
mirrored regions in a and than make a decision where to cut ZONE_NORMAL
based on that.

-- 
Sincerely yours,
Mike.

