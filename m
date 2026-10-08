Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0511CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D100A6B008C; Thu,  8 Oct 2026 03:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8CB6B009B; Thu,  8 Oct 2026 03:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE326B009D; Thu,  8 Oct 2026 03:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9518A6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:45:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 314DA1A049F
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:45:47 +0000 (UTC)
X-FDA: 85298674734.08.56A6E52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8415D1A0004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:45:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efbSkEJ2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791445545;
	b=E28skGgm/E7dpWvRQNyxCN43nCoEQGsXzsbn5lCudE1XV6kaxsrwRhOFchIG4aZr32lY3h
	Vbr4/JVxwxrViirysFAd6vwArOheGQl2l3vaFUWhAvv3EPoDr/XcTvlJpk1qraWibosJPN
	hbG1AJ0yX+hVkzlY/MA9jBmyZeepe0o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efbSkEJ2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791445545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y82KYwy06rNpAA7M8MsmLg3p1srKgmRdrrUbRlrqajQ=;
	b=593JV5FppiudX1ikTzLRVhKlw/+XC9ZrHCWfgf7bqbFNNbhF6FazFutuGOvvRtye5O/Wdn
	vVFZNWe8HAkBUU/YnkOfQ6H75yK4Bh3Cjshv5VY8zB02lq5e10TjvxnQgDZveUhD7Vq0Kw
	3lGqtxvkdJ2fAdl/vFUS6KEG3SNJmmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD6B960252;
	Thu,  8 Oct 2026 07:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CE81F00893;
	Thu,  8 Oct 2026 07:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791445544;
	bh=Y82KYwy06rNpAA7M8MsmLg3p1srKgmRdrrUbRlrqajQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=efbSkEJ2rpc8pzH1kPR2J923tKrUfBE7MQ7w+c75c9zz7kP1udsRu2q9egp9bcVVb
	 yex1rX8rZYHKwIlwUyH2D2Nfd7iXsk6ngLByQ5EeiA/VKWQkHNdXr8/pXHIKH0dF7e
	 emoGLzk9iEzmtV9p95S1RT0gfKJWTc7J3Dgx36p8pUvMlNWbOldrTtDeHL3Yv4cV6X
	 AAFv3A5HqO2wgDoihb0FNE4EngPcehF9Tar+Xv/l2XFB9bLf8yaK76ERBqLZmgDALH
	 jop9A4VdvQ42FDAVIQQXT2hSlZQaTyJEtnunTHbyiGbEObu/a3PDj2b/kuWjWl/j+Z
	 c1Oo6pn9hqBsw==
Date: Thu, 8 Oct 2026 09:45:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
Message-ID: <asdKHy_xHHa0wJ65@kernel.org>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
 <ar_0GLYM6KsIH6tQ@kernel.org>
 <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
 <asTS6OtxPMVshuIO@kernel.org>
 <CF8ED1DC-9745-42D3-92F0-424A02385EC1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CF8ED1DC-9745-42D3-92F0-424A02385EC1@linux.dev>
X-Stat-Signature: p3jamy5cguqbxnxho9xmrwxq1b646qjf
X-Rspamd-Queue-Id: 8415D1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791445545-723117
X-HE-Meta: U2FsdGVkX18jHzkGqd52/nY5GiPIHOrTzbKxTRr5qd8tBB7LgkZ8ftXdCwm8iKxSBMpCVSyYJBd2jch8okL8bhjIF3normPnIwzv7uD0NF84bxykmP2UywA6fB/8Ppp0r5NBQZV3FUa5B4IJ+rQ8yVAhGhYA1KXhoNBlYvVdvudtIziSImXQcAM/4yo3HvCG3c2swowYMnF18mfV3hQOeaxCJ8xfdWkE584hNVMjVNoD68R4puE9XHLacdH0NLfW8afNbCfBUm9tq0x723RwNdffsT8t52EYBlzHxu8mC3VS4heZM0opTm9ZI18atihCVrw0X1PiaSEOdmYSpG0uI0YkHXSCSoeQHGusF4uKb+0wbynCpaLIXcHI0pHkwLScSZL1w2mfQlQNbJSlsdl6kifnR1fU+1G3ZtfAtZM24mrJOe0nHgQOfPsoUGA6dt+2CwdRh7f3GvzdHIqx4Pa8fvPB0w5dP7xqYVdQfjLVh05D2qF0nJAnqgUcjuOVX8KBAW669KcSYul1lnla6dtB6p56ya0quJ7eK633pMzzaHIl1ehCNu7Adlt5HilEJecCv0+34xbvcYmm1uxkD6gRy2dCEMg1/4AVnsOsdjNHUvc0nXbOAr0A4LeoK/JXhjt5ELKS0/RTrrZfUfLZkxaikP5BweSA/EjMgumomG4XN4Mrto5ghXcaaw8BmaFR3t1sLDTiLka37bnPxkmRpWo6qVFhy2F+NC7L79WlXIq2tk4Rfk276q3YpUOCaiIKLA2qFzwRfPUZD2wlehPWQ8jsN8j+o6094eXgiXQl/nBS1tBiUJzyvVfIiAJHSEQz1ALV5aBoH07hBW0MMmYtV+WcXblGt9LyrsvsAdozRDWhM/cvVtj1TGWlajbZbPYbnRhIzTPoeMYqhO7Y6FY3bYbslSnSyBFsD4smZWAo0+82YeL4+C7LrnUFc/ks2vsa1Ar7dW5sd1ZP97Qx8djm/4r
 xE1EG0ot
 M76aL6F0AIXRWLfYsKfQzaq5inQCunM0w6004wT4kuggIPBfrDgafSHdg8nyBrtXLeH0Q7QNOrchGpPc0iXg0rivzufAFhLbOtQqNiSYjDBguStY7iWOvjQXTB57/Ru4xTHxvV29HGarICYh6v1Y0ffky/tVa2Iu7fC3D3WTc+lO96X0qxJul1ubkoze/5d9x//G+b9/mBuXQfoYtGOx093tsx7hnkHbaAT6HyuMIw/XUor8cpKz0VOYqbKDPLbSMBKt9Ovx1ad9gDQ9XSN6CP8b3wqmq1riYs8UbsGgSUB7gmGz4lONrI9DOR8QVRTCH25r/JbLqR8OUgcEDbdFNp6VbBI3p8wdMgcqXAJBNLkSXoON2eSxMsTJsy47+Vud2HGeewV05w9uUjb4YEsWucoCnmH4vcCif2+lQzgLffC31xes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 03:32:43PM +0200, Muchun Song wrote:
> > On Oct 6, 2026, at 12:52, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Mon, Oct 05, 2026 at 06:27:52PM +0200, Muchun Song wrote:
> >>> On Oct 2, 2026, at 20:12, Mike Rapoport <rppt@kernel.org> wrote:
> >>> 
> >>> On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
> >>>>> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
> >>>> 
> >>>>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >>>>>>>> index 1650d6bc1211..bd02e8d06965 100644
> >>>>>>>> --- a/mm/mm_init.c
> >>>>>>>> +++ b/mm/mm_init.c
> >>>>>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
> >>>>>>>> if (!is_highmem_idx(zone))
> >>>>>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
> >>>>>>>> #endif
> >>>>>>>> + VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> >>>>>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> >>>>>>>> + page_zone_id(page));
> >>>>>>> 
> >>>>>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
> >>>>>>> than page so it'll have stale data in the page->flags, won't it?
> >>>>>> 
> >>>>>> Lance is right. The shared tail struct pages are already initialized by
> >>>>>> vmemmap_shared_tail_page() during vmemmap population, so they're not stale.
> >>>>>> The head 64 struct pages are initialized later — right here, after vmemmap
> >>>>>> population.
> >>>>> 
> >>>>> Still it looks out of place here, can this check be done in sparse-vmemmap
> >>>>> somehow?
> >>>> 
> >>>> The struct page entries of a vmemmap-optimizable compound page
> >>>> are currently initialized in two stages. During vmemmap
> >>>> population, the shared tail entries are initialized first. The
> >>>> retained head area—normally 64—is initialized later through
> >>>> __init_single_page().
> >>>> 
> >>>> This warning connects the two stages: while initializing the
> >>>> retained entries in the second stage, it verifies that their zone
> >>>> information is consistent with the shared entries initialized in
> >>>> the first stage. Therefore, the same check cannot be performed
> >>>> during vmemmap population.
> >>>> 
> >>>> I am planning to first unify the HugeTLB and Device DAX
> >>>> compound-page initialization through a common helper [1]. Once that
> >>>> work is complete, maybe it will be easy to move the initialization
> >>>> of the retained head area into vmemmap population. With both the
> >>>> retained and shared entries initialized in the same stage, there
> >>>> will be no cross-stage inconsistency to check, and this warning
> >>>> can be removed.
> >>>> 
> >>>> Would keeping the check here for now and removing it as part of
> >>>> that follow-up sound reasonable to you?
> >>> 
> >>> While it feels really out of place in __init_single_page(), but having it
> >>> memmap_init_range() close to the if that skips shared tail pages makes
> >>> sense.
> >>> 
> >>> What do you say?
> >> 
> >> Sorry for the late reply because of traveling to LPC.
> >> 
> >> Putting the check in memmap_init_range() would validate the
> >> invariant for the shared-tail range skipped there. It would
> >> not, however, cover all vmemmap-optimized initialization
> >> paths: optimized Device DAX bypasses memmap_init_range()
> >> when there is no altmap, and deferred boot-time HugeTLB
> >> initialization may also initialize retained entries
> >> elsewhere.
> >> 
> >> If the intention is to validate only the skip in
> >> memmap_init_range(), moving it there makes sense. If we want
> >> the warning to cover both HugeTLB and Device DAX generally,
> >> it still needs to remain in __init_single_page() or be
> >> called from the individual initialization paths.
> > 
> > Yeah, putting this into all the callers sucks too :(
> > 
> > With all the callers,__init_single_page() is the right place for this
> > check, but I think we can add a static inline in sparse.h, like e.g.
> > 
> > vmemmap_optimization_verify_zone(page, pfn)
> > 
> > to make it a bit nicer.
> 
> Yeah, factoring this into a helper makes sense.
> 
> Since it currently has only one caller, how about keeping it as a local
> static inline in mm_init.c instead of putting it in sparse.h?

Presuming we don't expect new callers any time soon let's put it just above
__init_single_page().

-- 
Sincerely yours,
Mike.

