Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC94CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6667E6B008C; Tue, 13 Oct 2026 08:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617396B0092; Tue, 13 Oct 2026 08:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5054C6B0095; Tue, 13 Oct 2026 08:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32A246B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:57:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 372EAC0B7D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:57:31 +0000 (UTC)
X-FDA: 85317604302.07.1FB27EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 22D4B2000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:57:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkezcZFO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791896249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9BFwpcjmKrDdzhZwTDHl5KDt9LrzcnjBY0dqWfL9Uo=;
	b=SxTcw29Tn4jZXz18RVk036Y6QA6kkcGbjSaATx9L8ACNostEyN7wVSaP+F8bBuBFzvJuCZ
	j/h8rKzRipVUylneAYzecwu5gPWGn06u6xkvmPNfKoZQeqIbhRILUBtJK+syNuHYgz0hh7
	ybhqABLLbNBEdl3A8J9lIeo9vHFPmSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791896249;
	b=mGkKObIEWLCktvPb8trYLOY1sVaZJA6qjyTwZ6LEoo1F/2HoxPANj4IL03XSZxpV7nyh/M
	OPRaYugWsI49nDPdj+fFa9ijRRcxPHKhfa6yIkVrIsIP5lhvd3VLSJ8BfvrU5/4SUo6LGf
	Dc3qqwrN77tFzyHubEIW6tjCeCJMMuk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XkezcZFO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D4E5440B2;
	Tue, 13 Oct 2026 12:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B431F00893;
	Tue, 13 Oct 2026 12:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791896247;
	bh=X9BFwpcjmKrDdzhZwTDHl5KDt9LrzcnjBY0dqWfL9Uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XkezcZFOnBges/No52JV7lJNChBh2uB/GmGh3tX/uB94BDHnIf+kSMHqz0Vs5wEM2
	 U+eP0xko4YeYYnKDCOCOyXyrxGwNLfEhR3p1Lnkv9eoef7oLmBNoZMZgjvJBKgisqr
	 fX3GPojftjXN8slL6pIFo+UY+/OiqBGSJ4GCYNdCtV9/o9d4041q8eV7EU5s63CCqC
	 tYeDXHaD8ItI5Q172odKRM7uPdhkQLYKqZUOZ776OhtXwJxVuB/cb4b2tZH6NRnuVR
	 rAKBkQh5k60awOuaonXW0fkUiRnZDkBHh2aG/rVUvjZ6M+JFW1mdkG1ryWakILxnV6
	 QTeixMb1Zgpcw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id B609F198003A;
	Tue, 13 Oct 2026 08:57:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 13 Oct 2026 08:57:25 -0400
X-ME-Sender: <xms:sirOaj7t20PPBmC0VgF_kX-BH_szYJkQ1lz5y8Ujzn6YONWN3iITRw>
    <xme:sirOalU4gdiujkt2P6LsVs_jbh5nWBI8zXgOpKSF_RPczri9K0FzdUDoz1dwCjYRJ
    vK6XnP2jojY0Tjhg_kQ3F6X_RGlAEMhwuWmWVpwnICQIvQ0_usyvsWJ>
X-ME-Received: <xmr:sirOahul2_b8Rh5BgbU47dVYAXwNtIUY0HIB8RfgeWHEA0qicCsOa_LHdAY>
X-ME-Proxy-Cause: dmFkZTEetqmizud+clew86He+iiifUKs94ePsfMAGNNPMmxgxaJcQtNwftmQ4FOsIRMZFd
    p1MeZZgEA67dwqEqwnkr9c8OjvKQsDfeAsifflVQReL3Pft+JJQzZK/OJoNXOjH6QFKY1a
    532uP9WhuX8Gl/oakRel8YxZcScQ182XP8mCDVloKrpc1ubB/YrgUwTFFzCtyoDK8vabJ4
    KmBMY3r/03LHp3KTiVQvPSpcMw8RIXIkBRo7d2UWWyg5HdQDMUQ5SJD4LgUB2hnRqejjuE
    E1ZFIiECiniGuVUPUMgC7vY+pflwKfQx2mdVyPbFen760/u7kdhq25cN79pi87MrgbR2HB
    i9QhoZxOz7VJYTBjfS2SH6+BIM6AqXvlQY7HkAxNrn/CUD3hBligPhZqBs1MWtMk1rjQrR
    CdLfeZu3RDnu2z2nrTqzR3NwlFsfj3utQppyMi+BQeDGbR2iO2rxS/p49qPmDzD6HmCLG+
    Dx8/Gem37n8bZyTqaMbP7yuyN4BXCyyTLaJCOhtODibFchmq18+3ExOlh0DHAaJmILTeYz
    NHZyQ9ZtbVyS+Qat+s5v5hPzl/+hCEfxyaOVr70AjmzlWwcuyHHjrvN4xJWidHZfUMsVLj
    qhKdlGgOAZX5kE2Jmf5p+9IAEihQKqaiu7KnsGEes40g2HF423c3tJ48JKyw
X-ME-Proxy: <xmx:sirOaqqqFM4nvubugARgJOFlU8NG2zgnWtQ1wJg84r-NRAMqsopH3g>
    <xmx:sirOanbLvGRBuLjeMPAKNFk2MMGzUwpGA7huIAcIBmf-Xy8vPEnIsQ>
    <xmx:sirOajycdr5YvGZP8lhrx023NDnRgbjQybVtD2iDv9z_H26Fx0wjDg>
    <xmx:sirOal9iEI2KeJoJunp9ApN6o8vMcOa5Okfy0tlrdFxwzWnVS8-HcA>
    <xmx:sirOahW_uXsL7xG2EIb5ixBaQ85q3xBwRNBArPSHh6vnFgNYgSzpac1p>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 08:57:21 -0400 (EDT)
Date: Tue, 13 Oct 2026 13:57:20 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ying Huang <huang.ying.caritas@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Chuanhua Han <hanchuanhua@oppo.com>, Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
Message-ID: <as4qKLx_XwQ6qY3p@thinkstation>
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
X-Rspamd-Queue-Id: 22D4B2000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6cf44gn4xqp4555ifw4jjeqyehh8a3qt
X-HE-Tag: 1791896248-605731
X-HE-Meta: U2FsdGVkX1/Auut/5nw4M28fm9q+YWhHODCdYkn++xFG0eGRjVzq866x0THCMcfNx3Iz+5YnJj4eqDsodfmAWocSQ5LnrivLjtG9+aH/lQn4+FNkzga14UA7fYTvwIzx+yM0hKOICrQPAabLKFj6nXjVe/3DBVkAwgJZDuYgr19l4IH7P5QBR2DtRA3HbE88vAioe/egP3hDs8MUd/+N1A1ExF4iABA5VAX0Qyzx2BeAVsSa5Ww7GjrUi9NV7Yu+kbQAgle9Er/8A+YNpjJDu4D9H12xBdUB7LPpgLFdqUrwc3N+CZ4fnwoEyp9sn7eonMsmsu/mq2/BIDaAtjqrepBcrbdRnxRK1uz/2wzkZGZgkdY8nq5rJgrfj2Mzoo/E6xR72qQA+4zyKgXp11kUBHX6vFb1V4hGhddll2Yfd+Mqx+ejaKcugZijjsZVCOZBsOXUHqM0I1bSNfJbmwmDc8WUl8wAWY9usJFTz4RJkEd+SYo+QcVrMmfZHyd+gdPXryWJ0ZIVohkTUDntpHguGuw2qdmD3X9DgjqNhEWrUpcT6MmPOJemIdQDZBtog/d3/J+d9vUN1u2P0J/jbw+Qrl1MKwFtYeZrTynD6QtAoDOOas30I7wecYWRz3IddCQz1dU2v0zuv/5OixeFeFWNJRRv61f7KRMRSFawzO+yePljSgl0GjHhdv8nAg7hb/BQvBrXru2LA3gGGc8E+Hgs34v8hHO2fsqRFYYK/Fx5jDLnrt/j2XM6mhJ7V5nVp3UzBdHL17FBAMvsI/i0SScMllbqwmLPSGAh6P1DOWvuKElZ3s7bwFMRTW9GqVOl15WcnyRIiUquWEcbOWd2i2sxh8tTjym4BhzltB61hvu0EXrh7VCGjBQE06tk9dYkheF8HpmPSSzF4ppR/YIUXYONDcMTKxJoPoKfJRriJRGuipiOrKwo6YWBH2MeAU/KiPzTy3yrlwrOgtUMos26pk0
 9GNfdmnc
 bx5wCVR2dNTx4vM6W+uNYX2odbwjTeoZEylJcazyeKTOgjfhqVMdFgvPzVWVfBxETzgnBjyMHXUuicSqY10IJmYdaFu1RoxnKWjzTypnUQMSeGDtFSculDoho8Q4bJ1CUy18u3jbY0L6IEFxAF/qbISyfS4B0/koChSzkq1rzu6FitsT03n+BIyZy/m1UJHRg5HUmUapNVSZ1+kbYu4TnkBZh+BtC2kZ26pNUK19wE5V0iEg32YrC66hTC9JIy2mWxJSPTGmX4LL8RYB41+TjZgw8y03pWyCAnW7HFHRbW76tAadSZ5uz3lNFhA8tZbDcRFfR16zwWQ7Neij92kJuWle/OLpLzSX4C6KqLBePIl0WS0oZQsaOlU1fqqOFprnMPDzSBEWMPUH/XQIqCQc0eRUVfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 02:30:37PM +0200, David Hildenbrand (Arm) wrote:
> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
> generating an address wraparound, crashing the kernel. All that's required
> is to map a tail page of a large folio close enough to the start/end of
> the address space to e.g., make
> 
> 	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
> 
> to wrap around.
> 
> Let's fix it by providing a better helper, folio_pte_scan_range(), that
> takes care of staying within VMA and page table boundaries while
> handling possible wraparounds.
> 
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 1f5d5f7d39cd2..a3823010aa981 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>  	} while (--nr_pages);
>  }
>  
> +/*
> + * Get the address range in which a folio might be mapped, assuming its pages
> + * are mapped consecutively and the folio page at the given idx is mapped at
> + * the given address.
> + */
> +static void folio_pte_scan_range(const struct folio *folio,
> +		const struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long idx, unsigned long *start, unsigned long *end)
> +{
> +	/* Stay within the page table and VMA boundaries. */
> +	const unsigned long pmd_start = addr & PMD_MASK;
> +	const unsigned long pmd_end = pmd_start + PMD_SIZE;
> +	const unsigned long lower = max(pmd_start, vma->vm_start);
> +	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;

These -1/+1 gave me a pause. I guess it is for pmd_end wrapping to 0 in
the top PMD? A comment would be nice.

Otherwise:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

