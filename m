Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F68A109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55076B0520; Thu, 19 Mar 2026 11:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B586B0522; Thu, 19 Mar 2026 11:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C413A6B0523; Thu, 19 Mar 2026 11:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09296B0520
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:59:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EF0113B2F2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:59:09 +0000 (UTC)
X-FDA: 84563271618.27.8A21F83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB0E7C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:59:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U/qOknp+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzcOkDPq6Ist1fLDHgrMP5cByNJDD5WnbJutZsJi9mg=;
	b=1gU0Gg6Kvl/rc0q7IBb6B9OwvaMKvYvmUDu2LrBfD2qZvzS3ltXWPlF490r1OfL3i35IuJ
	37PWGFPFrD46WicKyGY9IChiKqzjLCJOKWLOsDaOf/w2H5WWaV9PnAwNwVkKPkcVZ2dN72
	s/hYaC1iwh4SdjejnxN7xWahunI2cug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773935947; a=rsa-sha256;
	cv=none;
	b=3PLtsUOL+JwEuD7qDLYQwz1wmBkVqNhnv1qgDzd2E/BEos9nukrSjzgyMs7bkg/H5uA/Tj
	ZjMSYaVpWbIf5WDA9BLfQ9qF7JVFT6U5oaEEfXy42YfzOac/LQXIPKcAL3IA19BqSuDn1d
	/wgDzu7WbGWKwRaIU4B+4wsiv7leeds=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U/qOknp+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 317976013A;
	Thu, 19 Mar 2026 15:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D16AC2BCAF;
	Thu, 19 Mar 2026 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773935946;
	bh=Lb4oqU4iPyvZ1i8PhgXMxctkWzAoFzaDDuT6Xm9wAYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/qOknp+NF8zfgg9EcPZ92SUhgK1wewr6thkOtev0OirSgVgo8CxM22mhI9t4olCZ
	 F9QKHOptUpnMSX4t//ajKhF5QZVTFfWiTzSdh88rgLDPci0Uy/5jKPaSIt/ZY+woCQ
	 1n1O3LjlaVjdze6GVVaNtuWOMomclWrAxCMWuiCtU/Xj6RODTMoR64DPCJ2wrJe3Lu
	 5XBLLtaNWFj+NSJ+SaQsQ1OkK6AmSV+CFKKwHIvC0xSPoR0rlXgaNxqOHEkmHJfDSu
	 m0EFEZECCKyxoGkvSvJVq8deNghNUoIIkQ3zHPRhsF2x61w5GnxOB6q4xDOrVKDUW3
	 CYFk6ohEaWLnw==
Date: Thu, 19 Mar 2026 15:59:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, 
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
Message-ID: <b4731810-2ee0-4e89-a193-9cc4ba015e3e@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032631.234234-1-npache@redhat.com>
 <d8028d32-4791-4993-aae3-66506bf6d1bd@lucifer.local>
 <a9ddfa7b-5ee4-4c68-bac0-8a0c6c355bf7@redhat.com>
 <4774da78-8349-4eda-a09b-7248e82cb26b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4774da78-8349-4eda-a09b-7248e82cb26b@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB0E7C0005
X-Stat-Signature: m6b449b6you3kcunnb5qokcbz3tjpymh
X-Rspam-User: 
X-HE-Tag: 1773935947-835532
X-HE-Meta: U2FsdGVkX1/KUuvrDCGA5cz3qoc0WpQ/wFrhxQNNp2JuZ3uQjZ0RdPRoufx3YP9cHiSeXB/YsNqqtwt1BqLxYWTDZ5xzvcTdYV9p3nhV0iKxz6LLwiV5WaNl9n3Y6J9HC0LW+t2SlWEznAoFkuYNCHXfCiDR+TG6+0Y33ay5Ro0lYh1O7aG9mRAAzA7k7pXE5k5Yq34MkpkP8KeZhExbMgDaj02gyp6y8/xYEo/8V/81F2gDB8WYpzuxUcmenBoFAbujVS8uhMRF3JL8TLQ5jsw5A7L2A9RLy2F6HPOJmb34/8p4N7yH+zkbHFQx/eWBCA14KR5Qy1a0YON8Hty59/wT6aVQoHexLk2lIJKkO4kHSzac5R8ejpTylWYDQy3bT1nv6KqvN2JLODb9fzh4i3FYltmDxouQavlTYRgWDfGMdTdn04pzQQtxAoJnykGYL6GYlmdCAdfet46FGwxptDmZTxhrwo5dRrBfaCRZBemWUM7sNYctqgbijcNcuzTpHV6hR+7/iFHrODCDJ2Kaxz/SLJLYR1pkSvVIEGrFVBi7rsiRax7mGYaDm9D38y413HpbkOVcmIFMpNJT0nsuDXmXB02jvJS97XXasZqaxsUX1R2uP9sCTuIriuKX8zoTCoaJTn9gApyGvjXzP2snFArqHzCHTnjAYG1x2KkgFYbZseLRLn4353tfVHCa6tcwxXdYPd+a1FbN5gm7E/vxbAV2GqIH+0xYECGfAdQOc4X8XuYeZqOZ/5fJHuC6D2cQxN6WCrNpClUWvn4DJza9MoFKX2oy+XZB94aGJqlDQWTBY847bNX42SE2AZIoHGP09IJjAQzD5j+xzJ9tXNtrBaAxNEjWHdDnEdjcQantaI+gNhxEKA7kyLuVk9rVvUKO2MPRnpjd5IDCZIO+brh0jSDrOflCK6N7d4hS9i+QsuJhZ5jJqHNUb/fI/rk1c6mVgihz2IqD0jv7a+9QqDo
 moUpdT8s
 opqHfw1Wk19wldm3xBYK+tVQf4ZPYTZr08xqMOt2DAf5osRZK1mUQIDnHi2bzUSzx/gUZX5YLvxT+wPsCvvhFINHnZExgzseAsIRQcvB60x1koas4GBAWlp5tZovkEZWl0nRI79djanM64g4ofnihaJBUK+9UJQC4NeAyXhckc3R7eJ/zAiF8oS0QlkLBz7/zOB9sMgwYHW/dxb+R1rJENqCEy1SiiigN5d0EpGE7HCFRrOX5MSuJCVEGNdMX+TwxWAUN8Jm+yOFBX7usk1uWl7g2tFn53ob1YIEUSDiKeZO8MfYCgvGrfffv7G1wEK1ZM+puXWHJ4o9IlZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 08:48:30PM +0100, David Hildenbrand (Arm) wrote:
> On 3/18/26 19:59, Nico Pache wrote:
> >
> >
> > On 3/17/26 4:35 AM, Lorenzo Stoakes (Oracle) wrote:
> >> On Wed, Feb 25, 2026 at 08:26:31PM -0700, Nico Pache wrote:
> >>> There are cases where, if an attempted collapse fails, all subsequent
> >>> orders are guaranteed to also fail. Avoid these collapse attempts by
> >>> bailing out early.
> >>>
> >>> Signed-off-by: Nico Pache <npache@redhat.com>
> >>
> >> With David's concern addressed:
> >>
> >> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >>
> >>> ---
> >>>  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> >>>  1 file changed, 34 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 1c3711ed4513..388d3f2537e2 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> >>>  			ret = collapse_huge_page(mm, collapse_address, referenced,
> >>>  						 unmapped, cc, mmap_locked,
> >>>  						 order);
> >>> -			if (ret == SCAN_SUCCEED) {
> >>> +
> >>> +			switch (ret) {
> >>> +			/* Cases were we continue to next collapse candidate */
> >>> +			case SCAN_SUCCEED:
> >>>  				collapsed += nr_pte_entries;
> >>> +				fallthrough;
> >>> +			case SCAN_PTE_MAPPED_HUGEPAGE:
> >>>  				continue;
> >>> +			/* Cases were lower orders might still succeed */
> >>> +			case SCAN_LACK_REFERENCED_PAGE:
> >>> +			case SCAN_EXCEED_NONE_PTE:
> >>> +			case SCAN_EXCEED_SWAP_PTE:
> >>> +			case SCAN_EXCEED_SHARED_PTE:
> >>> +			case SCAN_PAGE_LOCK:
> >>> +			case SCAN_PAGE_COUNT:
> >>> +			case SCAN_PAGE_LRU:
> >>> +			case SCAN_PAGE_NULL:
> >>> +			case SCAN_DEL_PAGE_LRU:
> >>> +			case SCAN_PTE_NON_PRESENT:
> >>> +			case SCAN_PTE_UFFD_WP:
> >>> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> >>> +				goto next_order;
> >>> +			/* Cases were no further collapse is possible */
> >>> +			case SCAN_CGROUP_CHARGE_FAIL:
> >>> +			case SCAN_COPY_MC:
> >>> +			case SCAN_ADDRESS_RANGE:
> >>> +			case SCAN_NO_PTE_TABLE:
> >>> +			case SCAN_ANY_PROCESS:
> >>> +			case SCAN_VMA_NULL:
> >>> +			case SCAN_VMA_CHECK:
> >>> +			case SCAN_SCAN_ABORT:
> >>> +			case SCAN_PAGE_ANON:
> >>> +			case SCAN_PMD_MAPPED:
> >>> +			case SCAN_FAIL:
> >>> +			default:
> >>
> >> Agree with david, let's spell them out please :)
> >
> > I believe David is arguing for the opposite. To drop all these spelt out cases
> > and just leave the default case.
> >
> > @david is that correct or did I misunderstand that.
>
> Either spell all out (no default) OR add a default.
>
> I prefer to just ... use the default :)

I mean yup that's fine too I guess, all or nothing, something in between is
weird!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

