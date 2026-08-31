Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 265ABC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2997B6B008A; Mon, 31 Aug 2026 12:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FEB6B008C; Mon, 31 Aug 2026 12:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE416B0092; Mon, 31 Aug 2026 12:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED1E66B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:00:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73088A01D4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:00:25 +0000 (UTC)
X-FDA: 85162026810.14.BAA45B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C48BEA0014
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:00:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMmNyu28;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788192023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih88Ia/0BJN7Fm8iuou5qyhg3UJj/ugsQclFFOXLskw=;
	b=RcnFCTM546xj10xSVErBQjeyEQSXOEd8jjcuBT9I20QtpF2WkGW7SJOg1em80wCIPPzEy9
	sviFPt/zqi4XKC5+dZZzFx39+BpVZI1FLh89GaaXps+X8tAL41BvCEACNWnwaJsGKC6Swd
	mrDCl8SygrlNRk/jsIW5a4Y8kHzFHKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788192023;
	b=J8vSBD68EBMX9D+iIpKDoF+XgJXgkbRQTIJQU8K2PqPwqwFrQg8epyIKjgkiq8uFqPA4GA
	5LIarDgr6qLtB6psop7zT1BUDPeCiZF52eZpDkMOYsP9gLCjQbNcd61XtM0ZbRJuoDelHI
	0YhDB2FgN18nXIcjojGW2+TCoGyrhME=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMmNyu28;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 278126022C;
	Mon, 31 Aug 2026 16:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E921F000E9;
	Mon, 31 Aug 2026 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192022;
	bh=Ih88Ia/0BJN7Fm8iuou5qyhg3UJj/ugsQclFFOXLskw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iMmNyu284Cp1Ib61oBSDyZMXrSkHCwtuFZ2rKSHGECKvjm9amQ3YOVBb9ZHt5hUYm
	 p1F+g83rzca5F0Z5226WuIm0RrG9DufzQi//ktx3NzDT/hTE/TXknTqvTkXPSl2oh6
	 cKJHkB2IfckZQuiVHIViVlNtQ69HfbfUDPJYwVPbP/VfV5at2BIHWiI9OqAlA0n/NU
	 CoD40eMyda2Fsb7zZW5+LD/SS7GjXAEum6q6ZNnbelP8A01Kc6M3K6PHaCWnuNSIIw
	 Uv8I6Uf89hpv6uAVlYy9a+NIaw4U1xbrScrb498A9DJifghBlXryoxX/VDjmrwxHeF
	 gj1GROWBmNRBw==
Date: Mon, 31 Aug 2026 16:59:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>, Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apWk0GYdNuPcE6zw@lucifer>
References: <20260831075635.2244437-1-noren@nvidia.com>
 <apVHXmSljK8HrIuA@tiehlicka>
 <apVKf8FgTG-l2EU_@gremlin>
 <784BE9B6-F891-4DFE-A4C5-D1986CE0F242@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784BE9B6-F891-4DFE-A4C5-D1986CE0F242@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C48BEA0014
X-Stat-Signature: tfow83gaz31xsrszbbxw3ugr9ygw1uij
X-Rspam-User: 
X-HE-Tag: 1788192023-600746
X-HE-Meta: U2FsdGVkX1/Yrd/fEDy3NdLk0IKoFdWEMzQKAUz5PSy0Vw7l0Fh/MtqL4PrE98xK4GqjT7RyyzLHfNWzdadfwZEwALhKuV9HD6v8xYavZj9XF91Y7zzEzy3ZD7k2P7hsetlIdowgF2oYzph5SYYbVS9u8aRSqbLdfldynwsYLSm+Jp1z0oijEKp11Q5HSAWdTG+nBe9E0qRHaeB4SpJeelQaXKQu0wVmIoXD1irJRpTSIg2DuZecKnbltYifzTvNtfT9/bboqHIkSJMbZEJVDCQeBckPWLEfsGhGWTL1VLHHHUEqEQMklfB4PvLp+tb+dbHeabz11L183GuzAxUOiiCAayPLl0p6geLKwShaWVHrDxqTqNo888QK/CsuNHSlfi0OhHQU5jkOA5rDDUmBKrYWFzviROeA306t15qx/gRgYfqhiiFZODeCCFrPkdyioIs1GV4eF4pS8P2iJmhBXbSUCZF/yxfzOD7Xg8k1NyDhVud0CFHTfnqXwo2INKdhHvaco8AqW3OrnMCJVX/cQ/b6HGZOdiPF/8VgYuXby/yPXr7Fzd4mbck2BWWibYObt0pPjgGBSDHBCZymt5z8vegZ8/MVb6Jl2Wsx/p9QeoDdYlylgIw88memL4qdjlQsHbLSpmCyc32nr38alcJpzzu2SknUkfyTCze+Ou3AQ8wRw/WINXPiDu6khhf7BIu9nhBjrPuz9dN4pWOtEdQgEIzpqoeGAs5uW6rGzymDjmhmWs2Yk6KXOdIpC5SHf1vOX68Pp6oRBogOjFRpNIcxAAtX1i5rz2Dcn1Eob7HSxyfsO3F1NhvFlUVrJJcrYLHs47LkBrMHAoO7XY6OpvXaU5aAWMdEmFPRVxVjsEQwq4TCT9Afbnf3/ddljKrAZdO+btqJQ8rlkq5Q+NEa2hSM9dUtlXm903ljsy6gmugqNRsqDM1UlF19Pu/gOltsq+3YsVQ0vRn63KxRiV8qkPl
 iy6onfLw
 fH6Uir3yD2DPI8QdnGXT2L4ZCJGCr1gDMmGZQBIs1RbC3bGe7gvVbf5F5k0MJ/ZZ14b3zqTB3+T7wvfYkE3dKK++4TJvblA5BnbdGOxCfV0TlVqtYY9zlZN2ifvPsnNerVoy7vh4Z2/EYSNzlQgmkaJkjfgBQ7twj9KfLeYBIuzrKf42pI1msu0M664mEbMj2lHc5w5TJ1x6ykE//cVL+9cjEChT0/ik/T+Zzfy9hexCfKlEH4UptMMJO5s26DGZRVrUnCt3HSJcQFo40Kpj0a6FIJksymrsIE05AMM+4Ln8LgSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:00:13AM -0400, Zi Yan wrote:
> On 31 Aug 2026, at 5:34, Lorenzo Stoakes (ARM) wrote:
>
> > On Mon, Aug 31, 2026 at 11:20:30AM +0200, Michal Hocko wrote:
> >> On Mon 31-08-26 10:56:35, Nimrod Oren wrote:
> >>> When THP is enabled, set_recommended_min_free_kbytes() may raise
> >>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> >>> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> >>> pageblocks for every eligible populated zone before capping the result
> >>> at 5% of low memory.
> >>>
> >>> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> >>> configurations, but scales poorly with larger base page sizes. With
> >>> the default arm64 pageblock sizes, the contribution per eligible zone
> >>> before the 5% cap is:
> >>>
> >>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> >>>
> >>> Consequently, min_free_kbytes can reach excessive and unwanted levels.
> >>>
> >>> Add an absolute 1 GiB cap to the recommendation, in addition to the
> >>> existing percentage cap. This bounds the automatic recommendation to a
> >>> sane value on systems with large pageblocks while preserving existing
> >>> behavior for typical systems with 2 MiB pageblocks.
> >>
> >> I would argue that the whole model of increasing min_free_kbytes for THP
> >> is wrong. This will trigger memory reclaim sooner and make the THP
> >> availability more likely but this was at times where we didn't have
> >> pro-active compaction and many changes in the compaction. So is this
> >> actually needed in general resp. only large pageblocks systems?
> >
> > Ohh even better :)
> >
> > I did find it strange that we increased accordingly.
> >
> > I'm more than happy to see this just die altogether if people agree that's
> > a sensible way forward...
>
> It sounds reasonable to me.
>
> My first reaction was that THP generation might be hurt due to fewer
> free pages. But probably the extra min_free_kbytes just moves reclaim earlier,
> like Michal said.
>
> After removing this automatic min_free_kbytes bump, user can retain the old
> behavior by setting a higher min_free_kbytes at boot time.

Nimrod - care to send a patch to just yank this min_free_kbytes change for
thp out? :)

This solves your problem another way and is neater overall.

>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo

