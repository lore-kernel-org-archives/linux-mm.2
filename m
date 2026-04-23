Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0D2F99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32126B0005; Thu, 23 Apr 2026 06:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08A26B0092; Thu, 23 Apr 2026 06:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F476B0093; Thu, 23 Apr 2026 06:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD3F6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:40:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D56A1B81BC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:40:36 +0000 (UTC)
X-FDA: 84689476872.18.9B67963
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C17A40008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:40:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SyDXjw67;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Y8S77J+oll0C3v8c6IwEV3VuOTGfRCVAy7vQUUTqXQ=;
	b=bbXqNYKddQx8FWte/L7+cBGLxYZZTugw8qW65pIhpNrTPjtclHRYEI/fgF4TmR1x/TxduA
	fBwDt558Tv0j7+RPI5n+OnGvNyoAWLhNr+oAveIThUQp/1vLZ3b+gAmdfv/eRqvZG4zanw
	0zTMP/T7ED79cuWf1+s94ZpF1hoTu1I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SyDXjw67;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940834; a=rsa-sha256;
	cv=none;
	b=EdYUGfOKYXQ5LKwGxzcGBNMiKZq0pZRRepIdXs2re6gsEYhAHakxLRTv/4M3qJIzSiNDtg
	Fx6l3+3evrsPi/ualSzyHn9k52Q2hbXEh6AYYkAoLJ5GIwDyEv0stKLIuOu2tFBx/oaY8a
	jYlA51SxJw3Z0xRw2u4c3oKa55D5zUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64764409DC;
	Thu, 23 Apr 2026 10:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367B3C2BCAF;
	Thu, 23 Apr 2026 10:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776940833;
	bh=ldBC+Ysj0hCLJEg88xc/mTOy0nXdrmU3TEgqL4XJ3Lw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SyDXjw67eKz4ElrNUAP3vrz40SZ2nZyRbGXglliuF6pdnreTSXlzdzAOThBUatOPb
	 pT2wKGzPScqcH4H2w4YyFCSnwUgJ/OR/4Wu4n7J3pbp1AsUj+vm5iHr9QHeHqsvqwR
	 233gi2TE6bMnZ14GO9a14IrHPga1EVJ7K/2z5mlc6w0/QbLp6YnJzyE9c6sUCzjQau
	 PjL6mihpztsJFUeDKJLw3clRAq2Sm2Sqkx5z4NtVFEzNbXsj3jQemSJne51QZKPkrR
	 EAdxX/bqB839XJZyJ3IkLG5UllO7X1eQlFOUAlPypulDb26ovc0kAkC7Hjz7+k1LqP
	 koClPQSbDNUkA==
Message-ID: <1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
Date: Thu, 23 Apr 2026 12:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423071911.1962859-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s7wj8tzijsirdgozh1orgyutu1kaeg3o
X-Rspamd-Queue-Id: 7C17A40008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776940834-130872
X-HE-Meta: U2FsdGVkX1+FRsqm+LIdNiF46XpqAHivRYxb+UDq5DMx7BgO59szVYbrRpIom1pB8vX5RYUWWXRgJHndT/FGxlwI6M6eXGhyWMq8qd9Nk8MdMZUzB9dHd88KQwGH0+3qXQg1zc+DxvWUVJbL4wB1DFn7Y5Y5o9nvNErvXtmNQqRyFaMHSOoW5byatiRqOCV7oLKsTqYq81Q4lYGOelF7BubShAlJ6ukrEZ1aFS1C2yqTc5BU0uDzqRb73ZQfkcB8wu9UTkwPq8Q+/kkizMIOlLOD0RAwWq8FL7GK05vwem+evvTrBc6WtlhcdN1yYf/OaJbG772aQVNAnnQ9VKEpyrLWDWKRIy+23MczG4h6XXFglUVXoO5nWVnHJI9OiiGAntbQZEEh2IpgtgtzN8iwT5C15h/lU3LqdzTgFa9mVzq4tkzXf5dkhB/zVfQ4xv5BzqPm5lZfv1SlK6O6cGlhYRRRle0GSp2TgsHctNC8/j0wCB1iEQ4i1Jew/zS9s9oCNwUw20t/4IP5R9BOdM9K8fFAdP4C3wqdDlxy0ZaQadK52m+NT88AyvyyiAKQjvq5B5IcUk3fbaNOH8Gqs8pe8UF2hQutKrDCJc+2wQEB1f+8sQp/l8hKGDFfcQApw8EQatp5yFce/08poeJ+r1pT0imdygoR9gQ5Lgss7tQjqGDAbSAPbfDw2i7RHVXW/CFcdrt05ITbbTmf6nSnznj1pBHDN84YFrJYVXyGrbxwFNQB6X+xsMIjJCMHmQuz8YUfnm4XQNLPcyOpOluD71GW3VVuZEsp9734UWUxqtNjbrh/RCq+SsYfIxugfcLpUNhSPJ2886Ad2qtGa2JTq3y2HRlmfxZq7DAw6tP0UMceWNPnjzNmYspdeNebHRSvYWiTGyzZ6b9mSSX/TTNByx3zAtNrA6luhYjvjF8pjLl2936QkLUHVGWzQWQm5ApCYFC2D+8e+XDTnHO4+OjIUiU
 yc6jxZDn
 KkyQvos3TuJU2v6tH1BVgTVsGjDzqMHEduAJHrAL5ha/zLhEPDYZ5iS1hfWWRjSa58bHH2r2WUSNuCq6PA7Di++FBg0SVr1eXJLNfXBUaZ4qDtlncJt6+CpTzCOzJSGRH8K7PT9s+ccaT3d4JQgiAHLvUhiMGiMg0Sgs3qm/igifC6g9OFDNbPeOSblj7KTsrFBxf+LLk07gZB01Mii4fZZcUvo458qG7xf6PHni9ocPZOvz2/W2VPi2HqAaE4QGjwraL5YVKySplYHSB/AtwzSD34hWCYhaD8AldHPNVvhwEWlUg/i5JEekSKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 09:19, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 3340f6d30b01..979d71158c9b 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	const unsigned long pages_per_compound = 1UL << order;
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));

Thinking about the PAGES_PER_SECTION, can't we get called for sub-sections?

-- 
Cheers,

David

