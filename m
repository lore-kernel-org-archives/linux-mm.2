Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CF0D172CA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0CD6B0089; Sun,  1 Feb 2026 23:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54686B008C; Sun,  1 Feb 2026 23:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B562A6B0092; Sun,  1 Feb 2026 23:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3C1B6B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:09:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39982D4EA8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:09:52 +0000 (UTC)
X-FDA: 84398188224.24.74BF972
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E5B7180006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:09:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qfNItAW0;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.7 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770005390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLNM8XwLs6ZfkN2Ffdw20cH4cfsACOxpWucxMWKeiyY=;
	b=pVXXx1VcRh2YE38AGqqcT25Bg+hZXfDRjUQAJFp3Z/8LMPCn/NzAUDemFqlZ4HfCvFBhNz
	moB6+LheHghgB4qpnPMnSiu5RxWxIyh3KMu3gv8GElLhOgsa1mL0XFfwt5tTWWEympVLjW
	hF9q61bWHNG3K+pRoeJUzL8v1Xjn9DM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qfNItAW0;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.7 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770005390; a=rsa-sha256;
	cv=none;
	b=I5/89q5CdcTvg+LkMpzBo8syypvjO/Tv5sttvdqBL/BaoOFVobDRa+nQWSJVKeRGe7aPmH
	D5RZnrTgJlJLXlLR1krMI8/neTB8VbaPUiL0rxv9PIIv36md6cWAkFyv8/LGBB58y4nPBH
	70E0d/E6P3DIu3hmV0HNUoxWxXfnPTc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770004782; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YLNM8XwLs6ZfkN2Ffdw20cH4cfsACOxpWucxMWKeiyY=;
	b=qfNItAW07rHVoTvY11QvkHsTdURIsJf+ZPFKD5do8PpZhS5YMUovESvPHglnZTy/w8eqe9VKYtFt2ZmiokjP5YZO45lw3vGlgpmgQpatmEw2JzmO+BXgtnvbdjoNEV1uLEktRLnRAkkpfnoOg+C5najBP0yisS2TCXLKuFLicx8=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyJ0bcv_1770004779 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Feb 2026 11:59:40 +0800
Message-ID: <5aefd2ea-8eba-49ed-bc21-f84dbab8cf3b@linux.alibaba.com>
Date: Mon, 2 Feb 2026 11:59:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and
 avoid deferred_list handling
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260130034818.472804-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E5B7180006
X-Stat-Signature: ye9msgjtcgq76ooe4iwwe5io5iad8usp
X-Rspam-User: 
X-HE-Tag: 1770005389-187712
X-HE-Meta: U2FsdGVkX191S93ofdUMWxEMGyh7TuLdOKnZnQg8KAItBaGWCpIUgN4ieB29W5/7YT0XmIRzmt39kXYScXohzMFT3f1egGfUvTt8WwQKz6UiCTQDDS+x6fuGux2o3zpWKZ/8eMnQlDuQSgivntV/fBYSpBQp75nibAsOfIVX8AFqTs5X0KC1HxebNnaGOyEoDl2zKCr13iC9VUkBptJIs04DF/eQ7viL1PalPANNJvVs8Y3Cgs24jM9W1TtpzWhhDsmPinvK80ZHo1K+4KJIKq7qGKtrTvgS9AV2pPGlEtNL8kUDf9WymG4Xigga2N/yeBWiPSMdbduxN7Ps9XpQIMrocwzjc06j+4P5OGNt816e+mZjl825bm3BmxEV6i1wo5UPniJmvHNUzncUDHgP1Ds+M5T3wcIob81sOgEH4eDNKo1zy6uA8ubYW+lZGXUuutSL8NZbtAg48Z0uTtoLMp05IhFmyAEX4epNIE4TlInkY3h2vdCmqQXR0v8j66GVesXo2wHwysyuzbZNB/Ey15KRLfK4ofw3m0dohTloxn2bRyUv+rTyx4no8k/N7MLxoas85d+XXefNOr8b3f3V2BSIXL0pWgeA4Xlv7zaGAugnLjGmMu5r4XBM9VoLzxRKzJnORmP8XMKXo3uh5IY2mkizJH9X9e2pOdujhW8H5KmusuiV0PEZbskykdWv/CXrbde0CMvXCkV6iG+4D0Ju3HiATA12+r+NxWBM8OluFkY/FKl3DfPtvNLQqhTMS0TzX9vsX2MuC39cttEikQ1+fC35oyLiLvERGCAaFiHiNQTR2OMbx5tpj6lQX9Z1rx5NgbZRFXpYyIjNYZ1TzJLydPXVkRFWVjQ0K6a+Qg/qcHjg6h5yOdHR+npvAgSlZ9ghZAQDw5cWKCaFKe4zGngVLOrL9CWvTCU8hn/WyQ9PpKXd20NqvEMBHX6xM2zp9jD+Tiog5zCXOXcoSyA+KXC
 HwWXdSZ8
 kL+yaaZ90qZvj0OT9B7tuAJ5wVj8INlA8XYBiYVk+pCWDNirrd8V7bBQeGh/2Jp2au2o+oKyJoxd7ABQKY8VVp7SqPZ4ksozegjWXayaiK0H0AF3s0IL9Mm8hec+iGtGWQiCq5f1BQpsiA4sPheo6fJp3dIrmVinbUuZWZKWhfMB0sFIly5k0oULPAZurYtaf/YYlIGnxQ+Sb9eyALOv4v4MOXpBvHFFGuKXYSulSsOOSf2/09B426GbKHh+2FpKmqu4yXUPG7VGe+bivgV0NNQ/Pv+eudz07rCelVrFmdFCQHPlwHn65iQ8YMynyDjlt0fvH0PBlTuA8BhafsxmoCqE6RZ4Fx6Smn6eKK4LO9b1xv9eKd7JITnyv2ferPvQZgfI8gJLSI18fiUFoK3T0Zvt2qlsVZBuls7cC+F/6fSE6G8vPvteYhx6pFxiXmgL9+RQV2qNt4qyJDtoCrX6DKU0Cwn8ciOFd8CqwD1cV1kwOivR5fyrqCbcJuolaTHfdM2jEmu8XDuEUWD0E1rQ5hVPH+odX08kEbXntVyzYMlVcVCXIinen6DGPuNY7gpsVBnPrefsvDHMvHsA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/30/26 11:48 AM, Zi Yan wrote:
> Commit f708f6970cc9 ("mm/hugetlb: fix kernel NULL pointer dereference when
> migrating hugetlb folio") fixed a NULL pointer dereference when
> folio_undo_large_rmappable(), now folio_unqueue_deferred_list(), is used on
> hugetlb to clear deferred_list. It cleared large_rmappable flag on hugetlb.
> hugetlb is rmappable, thus clearing large_rmappable flag looks misleading.
> Instead, reject hugetlb in folio_unqueue_deferred_list() to avoid the
> issue.
> 
> This prepares for code separation of compound page and folio in a follow-up
> commit.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/hugetlb.c     | 6 +++---
>   mm/hugetlb_cma.c | 2 +-
>   mm/internal.h    | 3 ++-
>   3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6e855a32de3d..7466c7bf41a1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1422,8 +1422,8 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>   	if (hugetlb_cma_exclusive_alloc())
>   		return NULL;
>   
> -	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
> -							  nid, nodemask);
> +	folio = page_rmappable_folio(alloc_contig_frozen_pages(1 << order, gfp_mask,
> +							  nid, nodemask));
>   	return folio;
>   }
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
> @@ -1859,7 +1859,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>   	if (alloc_try_hard)
>   		gfp_mask |= __GFP_RETRY_MAYFAIL;
>   
> -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> +	folio = page_rmappable_folio(__alloc_frozen_pages(gfp_mask, order, nid, nmask));
>   
>   	/*
>   	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f83ae4998990..4245b5dda4dc 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -51,7 +51,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>   	if (!page)
>   		return NULL;
>   
> -	folio = page_folio(page);
> +	folio = page_rmappable_folio(page);
>   	folio_set_hugetlb_cma(folio);
>   	return folio;
>   }

IIUC, this will break the semantics of the is_transparent_hugepage() and 
might trigger a split of a hugetlb folio, right?

static inline bool is_transparent_hugepage(const struct folio *folio)
{
	if (!folio_test_large(folio))
		return false;

	return is_huge_zero_folio(folio) ||
		folio_test_large_rmappable(folio);
}

