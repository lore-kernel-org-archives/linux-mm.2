Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECD8CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 18:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4106C6B0169; Sun, 31 May 2026 14:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2066B016B; Sun, 31 May 2026 14:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7546B016C; Sun, 31 May 2026 14:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7536B0169
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:51:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A43B512037F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:51:19 +0000 (UTC)
X-FDA: 84828607878.15.A0FBC72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1AAA9180002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:51:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+RQr4Xc;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780253478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAxCb8wt4MDofHdr7bDysjYqqW+0dO2zfePgF4EMiLc=;
	b=raGCLq0TJy8475sV9xYhdYtBARACtIvgWz0yN/1ZYx4igzkL8t0TELrTFKahc1i5HzBHFM
	YNlX5dNoJF7Z4kSKuoJZBAp5xh4xZK5LijcF1KNKq39MxYHlg3m8osKB8KJFJv/gyLn9ji
	NSs+gdiDnbHOLVmhzjexbuNG4Y+jiRQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+RQr4Xc;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780253478; a=rsa-sha256;
	cv=none;
	b=Ym+YrN5JRGJf8BM9G4KFKxqwgaB6BLIcY0hE0Oqam9HLkRPLBHxAmgDGY7ichDenX+maPm
	ynp+iPZJoJ1Ns8EUK9NzhqUT2KddI0nrMPpKJ9cOGt4RhWzAwE7u99FeOs3nuDYaHghM46
	fyrPoKcu1gnPVrVmEUuyuNCXaJFPTdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 736826008A;
	Sun, 31 May 2026 18:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E041F00893;
	Sun, 31 May 2026 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780253477;
	bh=FAxCb8wt4MDofHdr7bDysjYqqW+0dO2zfePgF4EMiLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G+RQr4XcxsfKqn/e3SCfS3h9uirQNGVtyU7yFFUFtiaMRwqJpqhfubECNmUCiGK8P
	 YRX5pdjgi775fLQnPYtqhj26Lye5uqnK6D5co+pxhbEIfh1NlRlA1QGfLxlYTVUxKO
	 KhvpfEzmKfkvYVUhJgR21RNGCsHz24aAwBlNjDY6wQ6rBBuNOeDL3Q8dU2e56E8M4q
	 pDJrM3jMgyDlbzB+Q3tELtdfGg7ZrnSoE3Ht4caejeMbAt2e5hbvbpdjt0fnbGKM4w
	 6JYGnMwpbOlQdzWvpfqSL194r6Tq0eE+YauGMYOh5UD9qOapZm6PoN83BK6DXX02kw
	 V5xsWw1ScHvnQ==
Date: Sun, 31 May 2026 21:51:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Message-ID: <ahyDHVSH5eLsnp3C@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-10-pratyush@kernel.org>
 <agHGOxSnP_VraH1M@kernel.org>
 <2vxzecjhc2s8.fsf@kernel.org>
 <ag-a4ru9bMkDMthO@plex>
 <2vxzse7j7ai9.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzse7j7ai9.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AAA9180002
X-Stat-Signature: sr54z4wpbu7x1c5ko38iabmix9cznoob
X-HE-Tag: 1780253477-847399
X-HE-Meta: U2FsdGVkX18cq3rla4gn0+jcAzZB313SIT9ZIFheIeuqNqBzVNpcKoxWO1z5T3DJIwVlehqOtILq8GkYaXSAB+CjCWlVbUlhQBX+DOysDma+UHigNnIooKCrzZCK6VOzWjjPxx5+90RU6joFqGLomOZW7yIxpt2LsdbiaIbi3mRvMPwEkryVhObgc17xf1rK8DldthPqeSkhke8EiZYIhDmHOdIB61g4q+HXm6p2o1vgf/JaXEap5bemTZHbhX0mfeY36v/8W0QdA4vzj+Y+VUfV2L5FjdiMoWLXS+EHfGsOwOKxXuHoK8hkGm3fON9f64UcRr+3NdaXDFIrDr7mPxA2/kaCA/U0h04J9EvGUMVW0c0Ijdf/WrJzdGRiHmbP7Isvx76sqDsLDX0mrXT74KWBBq5pLCXJwhStz39QEZlF2ockeYPuloYC8njkd3JPWoept5O8R3suKOjWMG0QOQxTj8OXm32tCH852606ILUPFWxGtfaJRipA7l1E+d4DAre40DOLGDEJ1PKLTGE4HD4KJUgpagWseU2Lt7KQJHlkMdJ6jmYbcsrEcSQF9hPwb3YR+LdSXYUX7zCwL1lCvHc5e8zXBxu62uixynn3Xcnvt10+2BlePdCkGg/OYSgUdou0xKoZ4wgfriK2BJvLmkGTW0/ONJYUiJHGZghEB1xinmx/hkMLFrx6QRIphQZKLto6Xix+wqfbylJOJ772410aAiNFqON5F/tW8yGikiZH0AHnlwWvVKJg07eYBv0URoKA/0ixcR5dl8ylpkFCAdpmzZ3ZMU/PDn1OKHv48hzgbjoxsWdj82B9pVyH1VdvEGHy8vnQZoxfAD53cGq5zbqjhXAtIMU26sL6FNao81BfyNGYAHAHghYNKTA7PcEq4Sao5ddcEQei02pzloxnXgO6u6e4TygEQBhqS6HXgQmWdZ/rUBP+nirIRIm4QX2iffLkMf2cSd50DOzQSkB
 we6rQIA8
 m1Xwt/i6AI3ZTS7eWRL0lB8l3jspcbZ8xoGgKdxe+7c3T0UxApBiyRczAXwrx0zV3nIfLw6bp5OhB3bDRsekvhoidIgSleEQL4L439yvJDjmOutPaUlNXY4mh1RbH1uCv2Q/6LCxeOhqKo8WzMS63Nwfc6e+vj9MYhkZRioEBiVaqAFyY3k2HMP3wJCpigabejnYdbsBmZo5UcrPk7IiutEfB0JpCPKurhi1iRIsd4mY6C65nncnO3rLbUjicgCBg+VYU05OKi86OODG7e+nOdJFtz+KfhRVmHFpgJFNBeBGNG0YzAwoTCroLY6BdCCt4Gv2Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 05:02:38PM +0200, Pratyush Yadav wrote:
> On Fri, May 22 2026, Pasha Tatashin wrote:
> 
> > On 05-11 18:46, Pratyush Yadav wrote:
> >> On Mon, May 11 2026, Mike Rapoport wrote:
> >> 
> >> > On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
> >> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> >> 
> >> >> In the upcoming commits, the KHO will learn how to discover free blocks
> >> >> of memory by walking the KHO radix tree. It will then mark those regions
> >> >> as scratch to allow memory allocation in case scratch runs low.
> >> >> 
> >> >> To differentiate the extended scratch areas from the main scratch areas,
> >> >> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
> >> >> for allocations during scratch-only. Teach should_skip_region() to check
> >> >> for both flags before deciding if the region should be skipped.
> >> >
> >> > Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
> >> > SCRATCH (I still hate the name) means "memory memblock can safely use for
> >
> >  +1000
> >
> > I also strongly dislike this name and mentioned it in another thread
> > earlier today.
> >
> > If we ever decide to s/scratch/something-else/ globally, that should be a
> > separate cleanup effort. However, since we are introducing a brand new flag
> > here, we can discuss a better name for the _ext portion to avoid overloading
> > the "scratch" concept.
> >
> >> > the allocations". Initially this memory comes from the reservations in the
> >> > first kernel, but if the second kernel can find more memory to extend it,
> >> > why that additional memory should be treated differently? 
> >> 
> >> Two reasons:
> >> 
> >> 1. We mark SCRATCH as MIGRATE_CMA. We don't want to do that for
> >>    SCRATCH_EXT since this memory can be used for non-movable
> >>    allocations.
> >> 
> >> 2. Gigantic (1G) huge pages can not be allocated from scratch. They can
> >>    be preserved memory and thus should not be allocated from SCRATCH.
> >>    See patch 12 that does allocations for gigantic huge pages only from
> >>    SCRATCH_EXT.
> >> 
> >> I will add this in the commit message for the next version.
> >> 
> >> Naming is hard, so if you have any better names I'm all ears :-)
> >
> > IMO, this scratch_ext is not "scratch" in the traditional KHO sense at all.
> > The traditional KHO scratch is what is passed from kernel to kernel and is
> > guaranteed to contain zero preserved memory. This new memory is not passed
> > from kernel to kernel and can contain preserved memory at runtime. It's
> > essentially just memory that we identify as currently unpreserved and release
> > early to the system.
> >
> > If we want to keep the naming aligned with the existing codebase for now:
> > MEMBLOCK_KHO_SCRATCH      -> original scratch
> > MEMBLOCK_KHO_UNPRESERVED  -> for the new memory (instead of SCRATCH_EXT)
> 
> UNPRESERVED sounds good to me. I will use that for the next revision
> unless Mike objects.
 
Can we make it shorter? ;-)

UNPRESERVED makes sense, although I'd love to completely remove KHO_ notion
and make the name reflect how it's used by memblock. I was toying with
PREFERRED instead of SCRATCH, but it didn't feel right enough.
With two of them that surely won't work :)

> > Alternatively, if we do want to tackle the global rename of "scratch" later:
> > MEMBLOCK_KHO_BOOTSTRAP    -> for the original scratch
> > MEMBLOCK_KHO_UNPRESERVED  -> for this new dynamic memory
> 
> Or perhaps BOOTMEM? I suppose either of the two are somewhat better than
> scratch.

Well, if we have BOOTMEM_HVO, we can have BOOTMEM_KHO as well :)

> Anyway, can we please do the SCRATCH rename as a separate series? I

Sure. We can continue bikeshedding in parallel.

> would like this series to not get muddled in the naming discussion. I
> will use UNPRESERVED for the new concept in v2 though.

That might warrant v3 even if everything else is perfect :)
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

