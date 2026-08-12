Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85D0C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8D26B00D5; Wed, 12 Aug 2026 07:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59576B00D7; Wed, 12 Aug 2026 07:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E5B6B00DB; Wed, 12 Aug 2026 07:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70A366B00D5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:41:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F4801C0D0C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:41:20 +0000 (UTC)
X-FDA: 85092426720.30.5F5FB8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F24220004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:41:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFNsG5v7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3gZ1FMK6CoTy8pVEciCEE7NzrDYyMSkC6mU77m6EGc=;
	b=7tYFbzwZ5HL7b29a1COF5FWNoP/Pf/YV1js6RO8TnjSuYkTMl6VbrWEqEYF7lPCMtwbpTo
	v6WIj3oRMRmCdiyrActE7GO9dR97b9daMgPWqn/9DegTbNtt8fdM6v5jKu4oo9xjf5Dpjo
	y50VJ61FzKhIlc4IidKGa76s1+6eYYU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFNsG5v7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534878;
	b=q4gXgjs0YNNYIAGCt8bnoT4dnEBEr5ZDfxdB3OaKRB8yvHz4n8K5Kuj4YSmHQza0By9fDR
	LrfwzaViRMixk8HIO76bzGaoT6gs+qlzYBge0dw8NMH00nSXohUYrK3mAOSkQMZ/r2c4UX
	Eyn9B94JFRsDa7hHmsDG9WHf1ecJs2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7500B416EE;
	Wed, 12 Aug 2026 11:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615B71F000E9;
	Wed, 12 Aug 2026 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786534877;
	bh=H3gZ1FMK6CoTy8pVEciCEE7NzrDYyMSkC6mU77m6EGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hFNsG5v7l1bYLH8AHxJxTQurUxLaGlnnjZizxaZlF/UEhI5QdtOB5BAiCbSRo/Mfj
	 not+fjdMpz3CVNigeJdaM2uQryJnkDJD8NFLC5ihwXF2pEi5Me6go11Pbv7z/I+wvE
	 1bFE2d6Exx9+k4kqXSGQ7JtpX9M5soPFZb2lmqp9+qiOyzctZynL536Fdv2faUIEiR
	 vBec35/Y2WYYh0VEMnUpdwAWtn+O+Xe7LXH/O34Bb6onANgav5zs/AequvluT/4sCc
	 fGSYgVAqyNPCFgONkao4zDVJlU1s36Wsz6NU9lN6o1cZ84v+38L9Fa4dEcg8MkRalV
	 5hsIWsZ7EmhnQ==
Message-ID: <5d91760e-79e6-4bb7-9c41-52d8ab17ee82@kernel.org>
Date: Wed, 12 Aug 2026 13:41:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gq77565abidfhhhogchr5mhueyz6mrxz
X-Rspamd-Queue-Id: 3F24220004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786534878-146801
X-HE-Meta: U2FsdGVkX1/ZqE5v7ftfH3m+AQHQZg9X+jldQ6Xi6pdSNZFI1k/ZBWm1TdZd15TeJuYZWY/i4KKPMOBx59EQrqssaZH/liUA/lRsTZ30oL3Wn6W/RqfWP3h4q1awBDMYSewJujOLxmsbH7rg0y1dftC0/LDaL2J1gX9ZwSov+Ds0nnHslVYTTK7VIyv0Cnzdndg97XBdZnSObWZey2jxn0AZBA8Gn/qWoCOULx9YYAzpTnww/ZOxzfBqyQSIXKRA1Tqg3YkdS3Eor3DfDN7XpeOiEiZwTh6+ErVfBlKkRF1jH1clpKgzs26+7j4IdJXsBPQm3Ci3lDElrGtDaiIGu9jSCQUr3LYKC41U4lmcTyqVi8SD/AIcYaJkbIJnSsK0CHJRCGI6Ha8WFfbhBSFPNCXTrXBThxHRdBTSKbbjYqYyewEFJkMcVBWh4dEOq7aqQ3/ftbkTyKHOSOEne5DDSGWvR3bR42TJU3MyY2k9iEjnQvDQKVDxOAh0KLtoiYmPL30e6QldQSQi5niJzC6owOyi/dGDP5rBfftHj7EmsW8+q1y60QnBen+wwxuMNuQN4XSIqnr0wOVYsQfsS1Pjj6+wAvYIqIdlJ4mbB+7yiu/TQU7oa6dgzvKqu5/Gh6AfmlJWI1x7xZhYvTS4Lq+HDptpmRTMa3LhSB6giGIzXKby5LpRGhsEmzNJ+WmDaJnalB2IT7LJfCsWDtmlUApCoLtSMSNYpNpD6R448ucHXio860PZKUC5ElEQi0tQBb0V4FRLL7gE0pmhhIz+wHqncobuL8lo9ACryjPWXozRqx/4AW8ikFuMshFm5R8CE7yy/0hhlT/EntBdUKTdpBHhj0XdGipZBYSWLGKQH49R1flHtLi3biaLVoTuM6AxMpc2gH18FqRo6eEmOP2Ew4ZtB6Q1eArzaFEyIMjLC34HLRgH34ArFk1dw/l0yKzpTIAk5GdOexPHZGAB4ReiGkI
 5HnbP26Q
 vzsSyll3zD5QRqhQ9lAMHpy7f6hwkQa6opCBqk4MHQWt6GySkz8IhJQJD5aYnyhUv3POyCyeJcM2mjT+UVHFfXuIrg6uSP4gicdu5zJ32B/8IzV0N6espQjMMVfslF0ZoqSLIQdRDcbzpV5sJWlEBkO/eq9uNfnSJF76KVNW9hZcUw6LSUbfmNxedheQHqTq0+4+0qHSUv1kSU/luJO8eIr/MoEoLXMZ0m+fYpVOYBkFtdGjXME65ZjEuPn1I26se6wbWaQ409SyjGHKddBkGp4zrZhXycPLuuGs2Shs6dFpsWh7AR+ebTMfnFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 04:51, Rik van Riel wrote:
> follow_page_mask() walks the page tables one page at a time, even when the
> caller asked for a whole run of contiguous pages. Every page of a large folio
> re-enters the pmd/pud/pte walk and re-takes the page table lock.
> 
> This series changes follow_page_mask() to return a page count and a fill an
> array of pages, instead of a single struct page, so a walker can hand back
> more than one page per call.
> 
> Patches 1 to 4 are preparation, no functional change:
> 
>   1: move __get_user_pages()'s open-coded pages[] fill and cache flush into a
>      gup_fill_pages() helper, which the rest of the series reuses.
>   2: convert the follow_page_mask()/follow_p4d_mask()/follow_pud_mask()/
>      follow_pmd_mask()/follow_page_pte() call chain to return a long instead of
>      a struct page pointer or ERR_PTR(). Every path still handles one page.
>   3: split the "commit to a resolved page" tail of follow_page_pte() into
>      follow_page_pte_commit().
>   4: split the "work out which page this PTE maps" half of follow_page_pte()
>      into follow_one_pte(), leaving one unlock and one exit.
> 
> Patch 5 has the huge page paths store the page and leave the array fill to
> follow_pud_mask()/follow_pmd_mask() after they unlock, so the cache flushes
> happen outside the pud/pmd critical section.
> 
> Patch 6 has follow_huge_pud()/follow_huge_pmd() report the huge page's real
> subpage count instead of a separate *page_mask output, and retires *page_mask
> and __get_user_pages()'s try_grab_folio() call and subpage loop.
> 
> Patch 7 walks every PTE in a page table in one follow_page_pte() call instead
> of one per page.
> 
> Patch 8 adds follow_pte_batch() so a contiguous same-folio run is committed
> with one refcount grab. This is the only patch whose benefit depends on folio
> size; patch 7 alone covers plain base pages.
> 
> Patches 7 and 8 carry their own benchmark tables, both measured against the
> base of the series, so the split between the two mechanisms is visible: the
> single-call walk is worth 2.3x on base pages and 2.2x on 64 kB mTHP, and
> refcount batching adds a further 5.9x on the mTHP case.
> 
> v3:
>  - split up the series into 8 much smaller patches (David & Lorenzo)
>  - shorten changelogs where they were too long (Lorenzo)
>  - fix FOLL_WRITE folio dirtying by gathering dirty bits from all PTEs

I'll try getting to this soon. As I raised previously, the whole follow_page_*
terminology is just stale, and likely we should just not add new functions that
use this terminology.

I.e., follow_page_pte_commit()

-- 
Cheers,

David

